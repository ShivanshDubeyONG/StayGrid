"""
Management command to populate StayGrid with realistic initial/demo data.
Usage:
    python manage.py seed_data [--clear]
"""

from decimal import Decimal
from django.contrib.auth.models import User
from django.core.management.base import BaseCommand
from django.db import transaction

from hotels.models import Hotel, Room, Review
from users.models import CustomerProfile
from vendors.models import VendorProfile


SAMPLE_HOTELS = [
    {
        "name": "The Grand Azure Resort & Spa",
        "location": "Goa",
        "description": "Beachfront luxury resort overlooking Calangute Beach with world-class infinity pool, private cabanas, and authentic Goan dining.",
        "original_price": Decimal("8500.00"),
        "offer_price": Decimal("6999.00"),
        "star_rating": 5,
        "rooms": [
            ("101", "DELUXE", 2, Decimal("6999.00")),
            ("102", "DELUXE", 2, Decimal("6999.00")),
            ("201", "SUITE", 4, Decimal("11499.00")),
            ("301", "STANDARD", 2, Decimal("4999.00")),
        ],
    },
    {
        "name": "Royal Rajputana Palace",
        "location": "Jaipur",
        "description": "Heritage palace hotel featuring traditional Rajasthani architecture, tranquil courtyard gardens, rooftop dining, and royal suites.",
        "original_price": Decimal("9200.00"),
        "offer_price": Decimal("7500.00"),
        "star_rating": 5,
        "rooms": [
            ("101", "STANDARD", 2, Decimal("5500.00")),
            ("102", "DELUXE", 2, Decimal("7500.00")),
            ("201", "SUITE", 3, Decimal("12000.00")),
        ],
    },
    {
        "name": "Himalayan Pine Retreat",
        "location": "Manali",
        "description": "Cozy mountain hideaway surrounded by cedar forests and snow-capped peaks, offering warm cedarwood suites, fireplaces, and guided treks.",
        "original_price": Decimal("5500.00"),
        "offer_price": Decimal("4200.00"),
        "star_rating": 4,
        "rooms": [
            ("101", "STANDARD", 2, Decimal("3200.00")),
            ("102", "DELUXE", 2, Decimal("4200.00")),
            ("201", "SUITE", 4, Decimal("6800.00")),
        ],
    },
    {
        "name": "Emerald Backwater Palms",
        "location": "Kochi",
        "description": "Serene backwater resort in Kerala with Ayurvedic wellness center, infinity water views, private boat cruises, and organic cuisine.",
        "original_price": Decimal("7000.00"),
        "offer_price": Decimal("5800.00"),
        "star_rating": 4,
        "rooms": [
            ("101", "STANDARD", 2, Decimal("4200.00")),
            ("102", "DELUXE", 2, Decimal("5800.00")),
            ("201", "SUITE", 4, Decimal("9500.00")),
        ],
    },
    {
        "name": "Urban Skyline Luxury Hotel",
        "location": "Mumbai",
        "description": "Sophisticated contemporary hotel situated in Bandra Kurla Complex with panoramic city views, fine dining, and executive suites.",
        "original_price": Decimal("11000.00"),
        "offer_price": Decimal("8999.00"),
        "star_rating": 5,
        "rooms": [
            ("101", "STANDARD", 2, Decimal("6500.00")),
            ("102", "DELUXE", 2, Decimal("8999.00")),
            ("201", "SUITE", 3, Decimal("15500.00")),
        ],
    },
]


class Command(BaseCommand):
    help = "Seeds the database with initial vendor profiles, realistic hotels, rooms, and reviews."

    def add_arguments(self, parser):
        parser.add_argument(
            "--clear",
            action="store_true",
            help="Clear previously seeded sample hotels and rooms before inserting fresh data.",
        )

    def handle(self, *args, **options):
        clear_first = options.get("clear", False)

        with transaction.atomic():
            if clear_first:
                self.stdout.write("Clearing existing sample hotels and rooms...")
                Hotel.objects.filter(owner__business_name="StayGrid Premier Hospitality").delete()

            # 1. Create or get primary demo vendor
            vendor_user, _ = User.objects.get_or_create(
                username="demovendor",
                defaults={
                    "email": "vendor@staygrid.demo",
                    "first_name": "Rajesh",
                    "last_name": "Sharma",
                },
            )
            if not vendor_user.has_usable_password():
                vendor_user.set_password("VendorPass123!")
                vendor_user.save()

            vendor_profile, _ = VendorProfile.objects.get_or_create(
                user=vendor_user,
                defaults={
                    "business_name": "StayGrid Premier Hospitality",
                    "phone_number": "9876543210",
                    "is_verified": True,
                },
            )

            # 2. Create demo customer
            customer_user, _ = User.objects.get_or_create(
                username="demotraveler",
                defaults={
                    "email": "traveler@staygrid.demo",
                    "first_name": "Priya",
                    "last_name": "Verma",
                },
            )
            if not customer_user.has_usable_password():
                customer_user.set_password("TravelerPass123!")
                customer_user.save()

            CustomerProfile.objects.get_or_create(
                user=customer_user,
                defaults={
                    "phone_number": "9123456789",
                    "is_verified": True,
                },
            )

            # 3. Create hotels and rooms
            created_hotels_count = 0
            created_rooms_count = 0

            for hotel_info in SAMPLE_HOTELS:
                hotel, created = Hotel.objects.get_or_create(
                    owner=vendor_profile,
                    name=hotel_info["name"],
                    defaults={
                        "location": hotel_info["location"],
                        "description": hotel_info["description"],
                        "original_price": hotel_info["original_price"],
                        "offer_price": hotel_info["offer_price"],
                        "star_rating": hotel_info["star_rating"],
                        "is_active": True,
                    },
                )
                if created:
                    created_hotels_count += 1

                for room_num, room_type, capacity, price in hotel_info["rooms"]:
                    _, room_created = Room.objects.get_or_create(
                        hotel=hotel,
                        room_number=room_num,
                        defaults={
                            "room_type": room_type,
                            "capacity": capacity,
                            "price_per_night": price,
                            "is_active": True,
                        },
                    )
                    if room_created:
                        created_rooms_count += 1

                # Add sample review
                Review.objects.get_or_create(
                    user=customer_user,
                    hotel=hotel,
                    defaults={
                        "rating": hotel_info["star_rating"],
                        "comment": f"Wonderful stay at {hotel.name}! Impeccable cleanliness and courteous staff.",
                    },
                )

        self.stdout.write(
            self.style.SUCCESS(
                f"Successfully seeded database! ({created_hotels_count} hotels created, {created_rooms_count} rooms created)"
            )
        )
