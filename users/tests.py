from django.contrib.auth.models import User
from django.test import TestCase, Client
from django.urls import reverse

from users.models import CustomerProfile


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
