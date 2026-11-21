from datetime import date, timedelta
from decimal import Decimal
from io import StringIO
from django.contrib.auth.models import User
from django.core.management import call_command
from django.test import TestCase, Client
from django.urls import reverse

from vendors.models import VendorProfile
from hotels.models import Hotel, Room, Booking, Review
from hotels.services import (
    calculate_stay_score,
    stay_score,
    check_booking_conflict,
    calculate_booking_cost,
    create_room_booking,
    get_vendor_analytics,
)


class HotelViewsAndFlowTest(TestCase):
    def setUp(self):
        self.client = Client()

        self.vendor_user = User.objects.create_user(
            username="testvendor",
            email="vendor@staygrid.test",
            password="vendorpass123",
        )
        self.vendor = VendorProfile.objects.create(
            user=self.vendor_user,
            business_name="Grand Stays Ltd",
            phone_number="9876543210",
            is_verified=True,
        )

        self.hotel = Hotel.objects.create(
            owner=self.vendor,
            name="Grand Azure Stay",
            description="Luxury seaside stay with serene views.",
            location="Goa",
            original_price=Decimal("8000.00"),
            offer_price=Decimal("6500.00"),
            star_rating=4,
            is_active=True,
        )

        self.room = Room.objects.create(
            hotel=self.hotel,
            room_number="101",
            room_type="DELUXE",
            capacity=2,
            price_per_night=Decimal("6500.00"),
            is_active=True,
        )

        self.customer = User.objects.create_user(
            username="traveler",
            email="traveler@staygrid.test",
            password="travelpass123",
        )

    def test_home_page_loads_and_counts(self):
        response = self.client.get(reverse("home"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Grand Azure Stay")
        self.assertEqual(response.context["hotel_count"], 1)

    def test_hotel_search_mandatory_params(self):
        # Missing dates should redirect home with message
        response = self.client.get(reverse("hotel_list"))
        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, reverse("home"))

    def test_hotel_search_valid(self):
        today = date.today() + timedelta(days=1)
        next_day = today + timedelta(days=2)
        response = self.client.get(reverse("hotel_list"), {
            "location": "Goa",
            "check_in": today.isoformat(),
            "check_out": next_day.isoformat(),
            "guests": "2",
        })
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Grand Azure Stay")

    def test_stay_score_calculation(self):
        score = stay_score(self.hotel, min_price=5000.0, max_price=10000.0)
        self.assertGreater(score, 0)
        self.assertLessEqual(score, 100)

    def test_book_room_success_and_conflict(self):
        self.client.login(username="traveler", password="travelpass123")

        today = date.today() + timedelta(days=10)
        checkout = today + timedelta(days=3)

        response = self.client.post(
            reverse("book_room", args=[self.room.id]),
            {
                "check_in": today.isoformat(),
                "check_out": checkout.isoformat(),
            },
        )
        self.assertEqual(response.status_code, 302)
        booking = Booking.objects.filter(user=self.customer, room=self.room).first()
        self.assertIsNotNone(booking)
        self.assertEqual(booking.status, "CONFIRMED")
        self.assertEqual(booking.total_price, Decimal("6500.00") * 3)

        # Attempt conflicting overlapping booking on same room
        overlap_response = self.client.post(
            reverse("book_room", args=[self.room.id]),
            {
                "check_in": (today + timedelta(days=1)).isoformat(),
                "check_out": (checkout + timedelta(days=2)).isoformat(),
            },
        )
        self.assertEqual(overlap_response.status_code, 302)
        # Should remain only 1 booking because of double-booking prevention
        self.assertEqual(Booking.objects.filter(room=self.room).count(), 1)

    def test_my_bookings_requires_login(self):
        response = self.client.get(reverse("my_bookings"))
        self.assertEqual(response.status_code, 302)
        self.assertIn("/users/login/", response.url)

    def test_review_requires_completed_stay(self):
        self.client.login(username="traveler", password="travelpass123")

        # Without completed booking, should be rejected
        response = self.client.get(reverse("create_review", args=[self.hotel.id]))
        self.assertEqual(response.status_code, 302)
        self.assertEqual(Review.objects.count(), 0)

        # Create completed booking
        Booking.objects.create(
            user=self.customer,
            room=self.room,
            check_in=date.today() - timedelta(days=5),
            check_out=date.today() - timedelta(days=2),
            total_price=Decimal("13000.00"),
            status="COMPLETED",
        )

        review_resp = self.client.post(
            reverse("create_review", args=[self.hotel.id]),
            {
                "rating": 5,
                "comment": "Exceptional hospitality and clean suites!",
            },
        )
        self.assertEqual(review_resp.status_code, 302)
        self.assertEqual(Review.objects.filter(hotel=self.hotel, user=self.customer).count(), 1)


class ServicesAndCommandsTest(TestCase):
    def setUp(self):
        self.vendor_user = User.objects.create_user(
            username="servicevendor",
            email="servicevendor@staygrid.test",
            password="VendorPass123!",
        )
        self.vendor = VendorProfile.objects.create(
            user=self.vendor_user,
            business_name="Coastal Retreats Group",
            phone_number="9876501234",
            is_verified=True,
        )
        self.hotel = Hotel.objects.create(
            owner=self.vendor,
            name="Serene Bay Resort",
            location="Goa",
            description="Luxury resort by the sea.",
            original_price=Decimal("10000.00"),
            offer_price=Decimal("8000.00"),
            star_rating=5,
            is_active=True,
        )
        self.room = Room.objects.create(
            hotel=self.hotel,
            room_number="201",
            room_type="SUITE",
            capacity=3,
            price_per_night=Decimal("8000.00"),
            is_active=True,
        )
        self.customer = User.objects.create_user(
            username="servicetraveler",
            email="servicetraveler@staygrid.test",
            password="TravelerPass123!",
        )

    def test_calculate_booking_cost(self):
        check_in = date.today() + timedelta(days=5)
        check_out = check_in + timedelta(days=4)
        nights, total = calculate_booking_cost(Decimal("8000.00"), check_in, check_out)
        self.assertEqual(nights, 4)
        self.assertEqual(total, Decimal("32000.00"))

        with self.assertRaises(ValueError):
            calculate_booking_cost(Decimal("8000.00"), check_out, check_in)

    def test_booking_conflict_service(self):
        d1 = date.today() + timedelta(days=20)
        d2 = d1 + timedelta(days=3)

        self.assertFalse(check_booking_conflict(self.room, d1, d2))

        booking = create_room_booking(
            user=self.customer,
            room_id=self.room.id,
            check_in=d1,
            check_out=d2,
            guests=2,
        )
        self.assertEqual(booking.status, "CONFIRMED")
        self.assertTrue(check_booking_conflict(self.room, d1, d2))

        # Check with exclude_booking_id
        self.assertFalse(check_booking_conflict(self.room, d1, d2, exclude_booking_id=booking.id))

        # Double booking with service should raise ValueError
        with self.assertRaises(ValueError):
            create_room_booking(
                user=self.customer,
                room_id=self.room.id,
                check_in=d1 + timedelta(days=1),
                check_out=d2 + timedelta(days=2),
            )

    def test_vendor_analytics_service(self):
        d1 = date.today() + timedelta(days=30)
        d2 = d1 + timedelta(days=2)
        create_room_booking(
            user=self.customer,
            room_id=self.room.id,
            check_in=d1,
            check_out=d2,
            guests=2,
        )

        analytics = get_vendor_analytics(self.vendor)
        self.assertEqual(analytics["total_bookings"], 1)
        self.assertEqual(analytics["total_revenue"], Decimal("16000.00"))
        self.assertEqual(analytics["total_rooms"], 1)
        self.assertEqual(analytics["occupancy"], 100.0)
        self.assertEqual(analytics["top_hotel"], self.hotel)

    def test_management_health_check_command(self):
        out = StringIO()
        call_command("health_check", stdout=out)
        output = out.getvalue()
        self.assertIn("StayGrid System Health Check", output)
        self.assertIn("All critical system checks passed successfully", output)

    def test_management_optimize_images_command(self):
        out = StringIO()
        call_command("optimize_images", dry_run=True, stdout=out)
        output = out.getvalue()
        self.assertTrue(len(output) > 0)

    def test_management_seed_data_command(self):
        out = StringIO()
        call_command("seed_data", stdout=out)
        output = out.getvalue()
        self.assertIn("Successfully seeded database", output)
        self.assertTrue(Hotel.objects.filter(location="Jaipur").exists())

