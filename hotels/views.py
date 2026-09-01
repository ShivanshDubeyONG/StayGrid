from decimal import Decimal

from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError, transaction
from django.db.models import Avg, Count, Sum, Q
from django.shortcuts import (
    get_object_or_404,
    redirect,
    render,
)

from .forms import (
    BookingForm,
    HotelForm,
    ReviewForm,
    RoomForm,
)

from .models import (
    Booking,
    Hotel,
    HotelImage,
    Review,
    Room,
)


def get_vendor(user):

    try:
        return user.vendor_profile
    except Exception:
        return None


# ==========================================================
# HOTEL DISCOVERY
# ==========================================================

def hotel_list(request):

    hotels = (
        Hotel.objects
        .filter(is_active=True)
        .prefetch_related(
            "images",
            "rooms",
        )
    )

    q = request.GET.get("q", "").strip()
    location = request.GET.get("location", "").strip()
    min_price = request.GET.get("min_price", "").strip()
    max_price = request.GET.get("max_price", "").strip()
    rating = request.GET.get("rating", "").strip()

    # --------------------------------------------------
    # SEARCH
    # --------------------------------------------------

    if q:
        hotels = hotels.filter(
            Q(name__icontains=q)
            | Q(location__icontains=q)
            | Q(description__icontains=q)
        )

    # Destination search
    if location:
        hotels = hotels.filter(
            location__icontains=location
        )

    # --------------------------------------------------
    # PRICE
    # --------------------------------------------------

    if min_price:
        hotels = hotels.filter(
            offer_price__gte=min_price
        )

    if max_price:
        hotels = hotels.filter(
            offer_price__lte=max_price
        )

    # --------------------------------------------------
    # RATING
    # --------------------------------------------------

    if rating:
        hotels = hotels.filter(
            star_rating__gte=rating
        )

    # --------------------------------------------------
    # STAY SCORE
    # --------------------------------------------------

    hotels = hotels.annotate(
        review_average=Avg("reviews__rating"),
        review_count=Count("reviews"),
    )

    hotels = list(hotels)

    for hotel in hotels:
        hotel.stay_score = stay_score(hotel)

    hotels.sort(
        key=lambda hotel: hotel.stay_score,
        reverse=True,
    )

    return render(
        request,
        "hotels/hotel_list.html",
        {
            "hotels": hotels,

            # Search values
            "query": q,
            "location": location,

            # Filters
            "min_price": min_price,
            "max_price": max_price,
            "rating": rating,

            # Useful for the results page
            "result_count": len(hotels),
        },
    )


def stay_score(hotel):

    rating = float(
        hotel.review_average or hotel.star_rating
    )

    rating_score = (rating / 5) * 40

    price = float(hotel.offer_price or 0)

    if price <= 1500:
        price_score = 30
    elif price <= 2500:
        price_score = 25
    elif price <= 4000:
        price_score = 18
    else:
        price_score = 10

    review_score = min(
        (hotel.review_count or 0) * 1,
        10
    )

    availability_score = (
        5 if hotel.rooms.filter(
            is_active=True
        ).exists()
        else 0
    )

    return round(
        rating_score
        + price_score
        + review_score
        + availability_score,
        1,
    )


def hotel_detail(request, hotel_id):

    hotel = get_object_or_404(
        Hotel.objects
        .prefetch_related(
            "images",
            "rooms",
            "reviews__user",
        )
        .annotate(
            review_average=Avg("reviews__rating"),
            review_count=Count("reviews"),
        ),
        id=hotel_id,
        is_active=True,
    )

    reviews = hotel.reviews.all().order_by(
        "-created_at"
    )

    average_rating = reviews.aggregate(
        average=Avg("rating")
    )["average"]

    return render(
        request,
        "hotels/hotel_detail.html",
        {
            "hotel": hotel,
            "reviews": reviews,
            "average_rating": average_rating,
            "stay_score": stay_score(hotel),
        },
    )


# ==========================================================
# BOOKING ENGINE
# ==========================================================

@login_required
def book_room(request, room_id):

    room = get_object_or_404(
        Room.objects.select_related("hotel"),
        id=room_id,
        is_active=True,
        hotel__is_active=True,
    )

    if request.method == "POST":

        form = BookingForm(request.POST)

        if form.is_valid():

            check_in = form.cleaned_data["check_in"]
            check_out = form.cleaned_data["check_out"]

            nights = (
                check_out - check_in
            ).days

            with transaction.atomic():

                locked_room = (
                    Room.objects
                    .select_for_update()
                    .select_related("hotel")
                    .get(id=room.id)
                )

                conflict = (
                    Booking.objects
                    .filter(
                        room=locked_room,
                        status__in=[
                            "PENDING",
                            "CONFIRMED",
                        ],
                        check_in__lt=check_out,
                        check_out__gt=check_in,
                    )
                    .exists()
                )

                if conflict:

                    messages.error(
                        request,
                        "This room is unavailable "
                        "for those dates."
                    )

                    return redirect(
                        "book_room",
                        room_id=room.id,
                    )

                total = (
                    locked_room.price_per_night
                    * Decimal(nights)
                )

                try:

                    booking = Booking.objects.create(
                        user=request.user,
                        room=locked_room,
                        check_in=check_in,
                        check_out=check_out,
                        total_price=total,
                        status="CONFIRMED",
                    )

                except IntegrityError:

                    messages.error(
                        request,
                        "Booking failed. Please try again."
                    )

                    return redirect(
                        "book_room",
                        room_id=room.id,
                    )

            return redirect(
                "booking_success",
                booking_id=booking.id,
            )

    else:
        form = BookingForm()

    return render(
        request,
        "hotels/book_room.html",
        {
            "room": room,
            "hotel": room.hotel,
            "form": form,
        },
    )


@login_required
def booking_success(request, booking_id):

    booking = get_object_or_404(
        Booking.objects.select_related(
            "room",
            "room__hotel",
        ),
        id=booking_id,
        user=request.user,
    )

    return render(
        request,
        "hotels/booking_success.html",
        {
            "booking": booking,
        },
    )


@login_required
def my_bookings(request):

    bookings = (
        Booking.objects
        .filter(user=request.user)
        .select_related(
            "room",
            "room__hotel",
        )
        .order_by("-created_at")
    )

    return render(
        request,
        "hotels/my_bookings.html",
        {
            "bookings": bookings,
        },
    )


@login_required
def cancel_booking(request, booking_id):

    booking = get_object_or_404(
        Booking,
        id=booking_id,
        user=request.user,
    )

    if request.method == "POST":

        if booking.status in [
            "PENDING",
            "CONFIRMED",
        ]:

            booking.status = "CANCELLED"
            booking.save(
                update_fields=["status"]
            )

            messages.success(
                request,
                "Booking cancelled successfully."
            )

        else:

            messages.error(
                request,
                "This booking cannot be cancelled."
            )

    return redirect("my_bookings")


# ==========================================================
# REVIEWS
# ==========================================================

@login_required
def create_review(request, hotel_id):

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        is_active=True,
    )

    has_completed_stay = Booking.objects.filter(
        user=request.user,
        room__hotel=hotel,
        status="COMPLETED",
    ).exists()

    if not has_completed_stay:

        messages.error(
            request,
            "You can review a hotel only after "
            "completing a stay there."
        )

        return redirect(
            "hotel_detail",
            hotel_id=hotel.id,
        )

    if Review.objects.filter(
        user=request.user,
        hotel=hotel,
    ).exists():

        messages.error(
            request,
            "You have already reviewed this hotel."
        )

        return redirect(
            "hotel_detail",
            hotel_id=hotel.id,
        )

    if request.method == "POST":

        form = ReviewForm(request.POST)

        if form.is_valid():

            review = form.save(
                commit=False
            )

            review.user = request.user
            review.hotel = hotel

            review.save()

            messages.success(
                request,
                "Review submitted!"
            )

            return redirect(
                "hotel_detail",
                hotel_id=hotel.id,
            )

    else:
        form = ReviewForm()

    return render(
        request,
        "hotels/create_review.html",
        {
            "form": form,
            "hotel": hotel,
        },
    )


# ==========================================================
# VENDOR HOTEL MANAGEMENT
# ==========================================================

@login_required
def create_hotel(request):

    vendor = get_vendor(request.user)

    if vendor is None:
        return redirect("home")

    if request.method == "POST":

        form = HotelForm(request.POST)

        if form.is_valid():

            hotel = form.save(
                commit=False
            )

            hotel.owner = vendor
            hotel.save()

            form.save_m2m()

            messages.success(
                request,
                "Hotel created successfully."
            )

            return redirect(
                "vendor_dashboard"
            )

    else:
        form = HotelForm()

    return render(
        request,
        "hotels/create_hotel.html",
        {
            "form": form,
        },
    )


@login_required
def edit_hotel(request, hotel_id):

    vendor = get_vendor(request.user)

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
                "Hotel updated successfully."
            )

            return redirect(
                "vendor_dashboard"
            )

    else:
        form = HotelForm(
            instance=hotel
        )

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

    vendor = get_vendor(request.user)

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        owner=vendor,
    )

    if request.method == "POST":

        form = RoomForm(request.POST)

        if form.is_valid():

            room = form.save(
                commit=False
            )

            room.hotel = hotel

            try:
                room.save()

            except IntegrityError:

                form.add_error(
                    "room_number",
                    "Room number already exists."
                )

            else:

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

    vendor = get_vendor(request.user)

    hotel = get_object_or_404(
        Hotel,
        id=hotel_id,
        owner=vendor,
    )

    rooms = hotel.rooms.all()

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

    vendor = get_vendor(request.user)

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

            form.save()

            return redirect(
                "manage_hotel",
                hotel_id=room.hotel.id,
            )

    else:
        form = RoomForm(
            instance=room
        )

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

    vendor = get_vendor(request.user)

    room = get_object_or_404(
        Room,
        id=room_id,
        hotel__owner=vendor,
    )

    hotel_id = room.hotel.id

    if request.method == "POST":
        room.delete()

    return redirect(
        "manage_hotel",
        hotel_id=hotel_id,
    )


# ==========================================================
# VENDOR ANALYTICS
# ==========================================================

@login_required
def vendor_analytics(request):

    vendor = get_vendor(request.user)

    if vendor is None:
        return redirect("home")

    hotels = vendor.hotels.all()

    bookings = Booking.objects.filter(
        room__hotel__owner=vendor,
        status__in=[
            "CONFIRMED",
            "COMPLETED",
        ],
    )

    total_revenue = bookings.aggregate(
        total=Sum("total_price")
    )["total"] or Decimal("0")

    total_bookings = bookings.count()

    total_rooms = Room.objects.filter(
        hotel__owner=vendor,
        is_active=True,
    ).count()

    occupied_rooms = bookings.values(
        "room"
    ).distinct().count()

    occupancy = (
        (occupied_rooms / total_rooms) * 100
        if total_rooms
        else 0
    )

    top_hotel = (
        hotels
        .annotate(
            booking_count=Count(
                "rooms__bookings",
                filter=Q(
                    rooms__bookings__status__in=[
                        "CONFIRMED",
                        "COMPLETED",
                    ]
                ),
            )
        )
        .order_by("-booking_count")
        .first()
    )

    return render(
        request,
        "vendors/analytics.html",
        {
            "hotels": hotels,
            "total_revenue": total_revenue,
            "total_bookings": total_bookings,
            "total_rooms": total_rooms,
            "occupancy": round(occupancy, 1),
            "top_hotel": top_hotel,
        },
    )