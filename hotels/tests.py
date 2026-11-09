from datetime import date, timedelta
from decimal import Decimal
from django.contrib.auth.models import User
from django.test import TestCase, Client
from django.urls import reverse

from vendors.models import VendorProfile
from hotels.models import Hotel, Room, Booking, Review
from hotels.views import stay_score


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
