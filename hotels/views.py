from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError
from django.shortcuts import get_object_or_404, redirect, render

from .forms import HotelForm, RoomForm
from .models import Hotel, Room


def get_vendor_for_user(user):
    try:
        return user.vendor_profile
    except user.vendor_profile.RelatedObjectDoesNotExist:
        return None


@login_required
def create_hotel(request):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "You must be registered as a vendor."
        )
        return redirect("home")

    if request.method == "POST":
        form = HotelForm(request.POST)

        if form.is_valid():
            hotel = form.save(commit=False)

            # Never trust the browser to tell us who owns the hotel.
            hotel.owner = vendor
            hotel.save()

            # Save ManyToMany amenities.
            form.save_m2m()

            messages.success(
                request,
                f"{hotel.name} was created successfully."
            )

            return redirect("vendor_dashboard")

    else:
        form = HotelForm()

    return render(
        request,
        "hotels/create_hotel.html",
        {"form": form},
    )


@login_required
def edit_hotel(request, hotel_id):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "Vendor access required."
        )
        return redirect("home")

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        owner=vendor,
    )

    if request.method == "POST":
        form = HotelForm(
            request.POST,
            instance=hotel,
        )

        if form.is_valid():
            form.save()

            messages.success(
                request,
                f"{hotel.name} was updated successfully."
            )

            return redirect("vendor_dashboard")

    else:
        form = HotelForm(instance=hotel)

    return render(
        request,
        "hotels/edit_hotel.html",
        {
            "form": form,
            "hotel": hotel,
        },
    )


@login_required
def create_room(request, hotel_id):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "Vendor access required."
        )
        return redirect("home")

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        owner=vendor,
    )

    if request.method == "POST":
        form = RoomForm(request.POST)

        if form.is_valid():
            room = form.save(commit=False)
            room.hotel = hotel

            try:
                room.save()

            except IntegrityError:
                form.add_error(
                    "room_number",
                    "This room number already exists in this hotel."
                )

            else:
                messages.success(
                    request,
                    f"Room {room.room_number} was added."
                )

                return redirect(
                    "manage_hotel",
                    hotel_id=hotel.id,
                )

    else:
        form = RoomForm()

    return render(
        request,
        "hotels/create_room.html",
        {
            "form": form,
            "hotel": hotel,
        },
    )


@login_required
def manage_hotel(request, hotel_id):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "Vendor access required."
        )
        return redirect("home")

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        owner=vendor,
    )

    rooms = hotel.rooms.all().order_by(
        "room_type",
        "room_number",
    )

    return render(
        request,
        "hotels/manage_hotel.html",
        {
            "hotel": hotel,
            "rooms": rooms,
        },
    )


@login_required
def edit_room(request, room_id):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "Vendor access required."
        )
        return redirect("home")

    room = get_object_or_404(
        Room,
        id=room_id,
        hotel__owner=vendor,
    )

    if request.method == "POST":
        form = RoomForm(
            request.POST,
            instance=room,
        )

        if form.is_valid():
            try:
                form.save()

            except IntegrityError:
                form.add_error(
                    "room_number",
                    "This room number already exists in this hotel."
                )

            else:
                messages.success(
                    request,
                    f"Room {room.room_number} was updated."
                )

                return redirect(
                    "manage_hotel",
                    hotel_id=room.hotel.id,
                )

    else:
        form = RoomForm(instance=room)

    return render(
        request,
        "hotels/edit_room.html",
        {
            "form": form,
            "room": room,
        },
    )


@login_required
def delete_room(request, room_id):
    vendor = get_vendor_for_user(request.user)

    if vendor is None:
        messages.error(
            request,
            "Vendor access required."
        )
        return redirect("home")

    room = get_object_or_404(
        Room,
        id=room_id,
        hotel__owner=vendor,
    )

    hotel_id = room.hotel.id

    if request.method == "POST":
        room.delete()

        messages.success(
            request,
            "Room deleted successfully."
        )

    return redirect(
        "manage_hotel",
        hotel_id=hotel_id,
    )