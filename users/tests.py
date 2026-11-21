from django.contrib.auth.models import User
from django.test import TestCase, Client
from django.urls import reverse

from users.models import CustomerProfile
from users.utils import (
    normalize_phone_number,
    validate_phone_number,
    get_user_display_name,
    is_profile_complete,
)


class UserAuthAndProfileTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_user_registration(self):
        response = self.client.post(reverse("register"), {
            "username": "newguest",
            "email": "newguest@example.com",
            "first_name": "New",
            "last_name": "Guest",
            "phone_number": "9123456780",
            "password": "Password123!",
            "confirm_password": "Password123!",
        })
        self.assertEqual(response.status_code, 302)
        self.assertTrue(User.objects.filter(username="newguest").exists())
        self.assertTrue(CustomerProfile.objects.filter(phone_number="9123456780").exists())

    def test_login_with_next_redirect(self):
        User.objects.create_user(
            username="existingguest",
            email="existing@example.com",
            password="SecurePass123",
        )

        response = self.client.post(
            reverse("login") + "?next=/hotels/my-bookings/",
            {
                "username": "existingguest",
                "password": "SecurePass123",
            },
        )
        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, "/hotels/my-bookings/")

    def test_profile_update_and_unique_email(self):
        user = User.objects.create_user(
            username="alice",
            email="alice@example.com",
            password="AlicePassword123",
        )
        User.objects.create_user(
            username="bob",
            email="bob@example.com",
            password="BobPassword123",
        )

        self.client.login(username="alice", password="AlicePassword123")

        # Try to change email to Bob's email
        response = self.client.post(reverse("profile"), {
            "first_name": "Alice",
            "last_name": "Wonder",
            "email": "bob@example.com",
            "phone_number": "9988776655",
        })
        self.assertEqual(response.status_code, 302)
        user.refresh_from_db()
        self.assertEqual(user.email, "alice@example.com")  # Email must not change to bob's


class UserUtilsTest(TestCase):
    def test_normalize_phone_number(self):
        self.assertEqual(normalize_phone_number("(987) 654-3210"), "9876543210")
        self.assertEqual(normalize_phone_number("+91 98765 43210"), "+919876543210")
        self.assertEqual(normalize_phone_number("  9876543210  "), "9876543210")
        self.assertEqual(normalize_phone_number(None), "")
        self.assertEqual(normalize_phone_number(""), "")

    def test_validate_phone_number(self):
        self.assertTrue(validate_phone_number("9876543210"))
        self.assertTrue(validate_phone_number("+919876543210"))
        self.assertFalse(validate_phone_number("123"))
        self.assertFalse(validate_phone_number("abc-def-ghij"))
        self.assertFalse(validate_phone_number(None))

    def test_get_user_display_name(self):
        user_with_name = User.objects.create_user(
            username="jdoe",
            first_name="John",
            last_name="Doe",
        )
        self.assertEqual(get_user_display_name(user_with_name), "John Doe")

        user_without_name = User.objects.create_user(
            username="solouser",
        )
        self.assertEqual(get_user_display_name(user_without_name), "solouser")
        self.assertEqual(get_user_display_name(None), "")

    def test_is_profile_complete(self):
        user = User.objects.create_user(
            username="incomplete",
        )
        self.assertFalse(is_profile_complete(user))

        user.first_name = "Priya"
        user.email = "priya@example.com"
        user.save()
        self.assertFalse(is_profile_complete(user))

        CustomerProfile.objects.create(
            user=user,
            phone_number="auto-999",
        )
        self.assertFalse(is_profile_complete(user))

        user.customer_profile.phone_number = "9876543210"
        user.customer_profile.save()
        self.assertTrue(is_profile_complete(user))

