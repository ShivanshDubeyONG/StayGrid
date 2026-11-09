from decimal import Decimal
from django.contrib.auth.models import User
from django.test import TestCase, Client
from django.urls import reverse

from vendors.models import VendorProfile
from hotels.models import Hotel, Room


class VendorPortalTest(TestCase):
    def setUp(self):
        self.client = Client()

        self.vendor_user = User.objects.create_user(
            username="grandvendor",
            email="grand@staygrid.test",
            password="VendorPassword123",
        )
        self.vendor = VendorProfile.objects.create(
            user=self.vendor_user,
            business_name="Grand Hospitality",
            phone_number="9900112233",
            is_verified=True,
        )

        self.regular_user = User.objects.create_user(
            username="regularcustomer",
            email="regular@staygrid.test",
            password="CustomerPass123",
        )

    def test_vendor_dashboard_requires_vendor_profile(self):
        # Non-vendor user accessing dashboard should not 500
        self.client.login(username="regularcustomer", password="CustomerPass123")
        response = self.client.get(reverse("vendor_dashboard"))
        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, reverse("vendor_register"))

    def test_vendor_dashboard_loads_for_vendor(self):
        self.client.login(username="grandvendor", password="VendorPassword123")
        response = self.client.get(reverse("vendor_dashboard"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Grand Hospitality")

    def test_vendor_can_create_hotel_and_rooms(self):
        self.client.login(username="grandvendor", password="VendorPassword123")

        hotel_resp = self.client.post(reverse("create_hotel"), {
            "name": "Emerald Bay Resort",
            "location": "Kochi, Kerala",
            "description": "Backwater retreat with Ayurvedic spa.",
            "original_price": "7500.00",
            "offer_price": "6000.00",
            "star_rating": "5",
            "is_active": True,
        })
        self.assertEqual(hotel_resp.status_code, 302)
        hotel = Hotel.objects.filter(name="Emerald Bay Resort").first()
        self.assertIsNotNone(hotel)
        self.assertEqual(hotel.owner, self.vendor)

        # Create Room
        room_resp = self.client.post(reverse("create_room", args=[hotel.id]), {
            "room_number": "Suite-01",
            "room_type": "SUITE",
            "capacity": 3,
            "price_per_night": "9000.00",
            "is_active": True,
        })
        self.assertEqual(room_resp.status_code, 302)
        self.assertTrue(Room.objects.filter(hotel=hotel, room_number="Suite-01").exists())

    def test_vendor_analytics(self):
        self.client.login(username="grandvendor", password="VendorPassword123")
        response = self.client.get(reverse("vendor_analytics"))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Partner Analytics")
