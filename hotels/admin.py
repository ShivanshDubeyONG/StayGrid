from django.contrib import admin

from .models import (
    Amenity,
    Hotel,
    HotelImage,
    Room,
    Booking,
    Review,
)


@admin.register(Amenity)
class AmenityAdmin(admin.ModelAdmin):
    list_display = (
        "name",
    )
    search_fields = (
        "name",
    )


class HotelImageInline(admin.TabularInline):
    model = HotelImage
    extra = 1


@admin.register(Hotel)
class HotelAdmin(admin.ModelAdmin):
    list_display = (
        "name",
        "owner",
        "location",
        "offer_price",
        "star_rating",
        "is_active",
        "created_at",
    )

    list_filter = (
        "is_active",
        "star_rating",
        "location",
    )

    search_fields = (
        "name",
        "location",
        "description",
        "owner__business_name",
    )

    filter_horizontal = (
        "amenities",
    )

    inlines = [
        HotelImageInline,
    ]


@admin.register(Room)
class RoomAdmin(admin.ModelAdmin):
    list_display = (
        "room_number",
        "hotel",
        "room_type",
        "capacity",
        "price_per_night",
        "is_active",
    )

    list_filter = (
        "room_type",
        "is_active",
    )

    search_fields = (
        "room_number",
        "hotel__name",
    )


@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = (
        "user",
        "room",
        "check_in",
        "check_out",
        "total_price",
        "status",
        "created_at",
    )

    list_filter = (
        "status",
        "check_in",
        "check_out",
    )

    search_fields = (
        "user__username",
        "user__email",
        "room__room_number",
        "room__hotel__name",
    )


@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = (
        "hotel",
        "user",
        "rating",
        "created_at",
    )

    list_filter = (
        "rating",
    )

    search_fields = (
        "hotel__name",
        "user__username",
        "comment",
    )