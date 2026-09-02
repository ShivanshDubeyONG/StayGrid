from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db.models import Q

from vendors.models import VendorProfile


class Amenity(models.Model):
    name = models.CharField(
        max_length=100,
        unique=True
    )

    def __str__(self):
        return self.name


class Hotel(models.Model):
    owner = models.ForeignKey(
        VendorProfile,
        on_delete=models.CASCADE,
        related_name="hotels"
    )

    name = models.CharField(max_length=200)
    description = models.TextField()

    location = models.CharField(max_length=200)

    original_price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)]
    )

    offer_price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)]
    )

    star_rating = models.PositiveIntegerField(
        default=3,
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ]
    )

    is_active = models.BooleanField(default=True)

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    def __str__(self):
        return self.name


class HotelImage(models.Model):
    hotel = models.ForeignKey(
        Hotel,
        on_delete=models.CASCADE,
        related_name="images"
    )

    image = models.ImageField(
        upload_to="hotels/"
    )

    def __str__(self):
        return f"{self.hotel.name} image"


class Room(models.Model):
    ROOM_TYPES = [
        ("STANDARD", "Standard"),
        ("DELUXE", "Deluxe"),
        ("SUITE", "Suite"),
    ]

    hotel = models.ForeignKey(
        Hotel,
        on_delete=models.CASCADE,
        related_name="rooms"
    )

    room_number = models.CharField(
        max_length=20
    )

    room_type = models.CharField(
        max_length=20,
        choices=ROOM_TYPES
    )

    capacity = models.PositiveIntegerField(
        default=2
    )

    price_per_night = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)]
    )

    is_active = models.BooleanField(
        default=True
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["hotel", "room_number"],
                name="unique_room_number_per_hotel"
            ),
            models.CheckConstraint(
                condition=Q(capacity__gt=0),
                name="room_capacity_must_be_positive"
            ),
        ]

    def __str__(self):
        return f"{self.hotel.name} - Room {self.room_number}"


class Booking(models.Model):
    STATUS_CHOICES = [
        ("PENDING", "Pending"),
        ("CONFIRMED", "Confirmed"),
        ("CANCELLED", "Cancelled"),
        ("COMPLETED", "Completed"),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="bookings"
    )

    room = models.ForeignKey(
        Room,
        on_delete=models.CASCADE,
        related_name="bookings"
    )

    check_in = models.DateField()

    check_out = models.DateField()

    guests = models.PositiveIntegerField(
        default=1
    )

    total_price = models.DecimalField(
            max_digits=10,
            decimal_places=2,
            validators=[MinValueValidator(0)]
        )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="PENDING"
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=Q(check_out__gt=models.F("check_in")),
                name="checkout_after_checkin"
            )
        ]

    def __str__(self):
        return (
            f"{self.user.username} - "
            f"{self.room} - "
            f"{self.check_in} to {self.check_out}"
        )


class Review(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="reviews"
    )

    hotel = models.ForeignKey(
        Hotel,
        on_delete=models.CASCADE,
        related_name="reviews"
    )

    rating = models.PositiveIntegerField(
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ]
    )

    comment = models.TextField()

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["user", "hotel"],
                name="one_review_per_user_per_hotel"
            )
        ]

    def __str__(self):
        return f"{self.hotel.name} - {self.rating}/5"