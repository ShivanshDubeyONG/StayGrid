from django.urls import path

from . import views


urlpatterns = [
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