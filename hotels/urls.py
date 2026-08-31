from django.urls import path

from . import views


urlpatterns = [

    path(
        "",
        views.hotel_list,
        name="hotel_list",
    ),

    path(
        "<int:hotel_id>/",
        views.hotel_detail,
        name="hotel_detail",
    ),

    # Booking
    path(
        "rooms/<int:room_id>/book/",
        views.book_room,
        name="book_room",
    ),

    path(
        "bookings/",
        views.my_bookings,
        name="my_bookings",
    ),

    path(
        "bookings/<int:booking_id>/success/",
        views.booking_success,
        name="booking_success",
    ),

    path(
        "bookings/<int:booking_id>/cancel/",
        views.cancel_booking,
        name="cancel_booking",
    ),

    # Reviews
    path(
        "<int:hotel_id>/review/",
        views.create_review,
        name="create_review",
    ),

    # Vendor
    path(
        "create/",
        views.create_hotel,
        name="create_hotel",
    ),

    path(
        "<int:hotel_id>/edit/",
        views.edit_hotel,
        name="edit_hotel",
    ),

    path(
        "<int:hotel_id>/manage/",
        views.manage_hotel,
        name="manage_hotel",
    ),

    path(
        "<int:hotel_id>/rooms/create/",
        views.create_room,
        name="create_room",
    ),

    path(
        "rooms/<int:room_id>/edit/",
        views.edit_room,
        name="edit_room",
    ),

    path(
        "rooms/<int:room_id>/delete/",
        views.delete_room,
        name="delete_room",
    ),
]