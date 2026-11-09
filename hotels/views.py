from datetime import datetime
from decimal import Decimal
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError, transaction
from django.db.models import Avg, Count, Max, Min, Q, Sum
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
    location = request.GET.get("location", "").strip()
    check_in = request.GET.get("check_in", "").strip()
    check_out = request.GET.get("check_out", "").strip()
    guests = request.GET.get("guests", "").strip()

    if not location or not check_in or not check_out or not guests:
        messages.error(
            request,
            "Please select a destination, dates, and number of guests."
        )
        return redirect("home")

    try:
        check_in_date = datetime.strptime(
            check_in, "%Y-%m-%d"
        ).date()

        check_out_date = datetime.strptime(
            check_out, "%Y-%m-%d"
        ).date()

    except ValueError:
        messages.error(request, "Please select valid dates.")
        return redirect("home")

    if check_out_date <= check_in_date:
        messages.error(request, "Check-out must be after check-in.")
        return redirect("home")

    try:
        guest_count = int(guests)

        if guest_count < 1 or guest_count > 20:
            raise ValueError

    except ValueError:
        messages.error(request, "Please select a valid number of guests.")
        return redirect("home")

    hotels = Hotel.objects.filter(
        is_active=True
    ).prefetch_related("images")

    if location:
        hotels = hotels.filter(location__icontains=location)

    min_price = request.GET.get("min_price")
    max_price = request.GET.get("max_price")
    rating = request.GET.get("rating")

    if min_price:
        hotels = hotels.filter(offer_price__gte=min_price)

    if max_price:
        hotels = hotels.filter(offer_price__lte=max_price)

    if rating:
        hotels = hotels.filter(star_rating__gte=rating)

    hotels = hotels.annotate(
        review_average=Avg("reviews__rating"),
        review_count=Count("reviews"),
    )

    price_bounds = Hotel.objects.filter(
        is_active=True,
        offer_price__gt=0,
    ).aggregate(
        min_p=Min("offer_price"),
        max_p=Max("offer_price"),
    )
    global_min = float(price_bounds["min_p"] or 0)
    global_max = float(price_bounds["max_p"] or 0)

    hotels = list(hotels)

    for hotel in hotels:
        hotel.stay_score = stay_score(
            hotel,
            min_price=global_min,
            max_price=global_max,
        )

    hotels.sort(
        key=lambda hotel: hotel.stay_score,
        reverse=True,
    )

    return render(
        request,
        "hotels/hotel_list.html",
        {
            "hotels": hotels,
            "check_in": check_in,
            "check_out": check_out,
            "guests": guests,
        },
    )


def stay_score(hotel, min_price=None, max_price=None):
    """
    StayGrid score out of 100.

    Factors:
    - Hotel star rating: 40%
    - Guest reviews: 35%
    - Number of reviews: 10%
    - Price value: 15%
    """

    # --------------------------------------------------
    # STAR RATING — 40 POINTS
    # --------------------------------------------------

    star_rating = float(hotel.star_rating or 0)
    star_score = (star_rating / 5) * 40

    # --------------------------------------------------
    # GUEST REVIEWS — 35 POINTS
    # --------------------------------------------------

    if hasattr(hotel, "review_average") and hotel.review_average is not None:
        average_rating = float(hotel.review_average)
        review_count = int(getattr(hotel, "review_count", 0) or 0)
    elif hasattr(hotel, "review_count") and hotel.review_count == 0:
        average_rating = 0.0
        review_count = 0
    else:
        review_data = hotel.reviews.aggregate(
            average=Avg("rating"),
            count=Count("id"),
        )
        average_rating = float(review_data["average"] or 0)
        review_count = int(review_data["count"] or 0)

    review_score = (average_rating / 5) * 35

    # --------------------------------------------------
    # REVIEW COUNT — 10 POINTS
    # --------------------------------------------------

    review_count_score = min(review_count, 10)

    # --------------------------------------------------
    # PRICE VALUE — 15 POINTS
    # --------------------------------------------------

    if min_price is None or max_price is None:
        price_stats = Hotel.objects.filter(
            is_active=True,
            offer_price__gt=0,
        ).aggregate(
            min_p=Min("offer_price"),
            max_p=Max("offer_price"),
        )
        min_price = float(price_stats["min_p"] or 0)
        max_price = float(price_stats["max_p"] or 0)

    price_score = 0

    if hotel.offer_price and max_price > 0:
        hotel_price = float(hotel.offer_price)

        if max_price > min_price:
            price_score = (
                (max_price - hotel_price)
                / (max_price - min_price)
            ) * 15
        else:
            price_score = 15

    # --------------------------------------------------
    # FINAL SCORE
    # --------------------------------------------------

    score = (
        star_score
        + review_score
        + review_count_score
        + price_score
    )

    return round(
        min(score, 100),
        1,
    )


@login_required
def hotel_detail(request, hotel_id):
    hotel = get_object_or_404(
        Hotel.objects.prefetch_related("images"),
        pk=hotel_id,
        is_active=True,
    )

    rooms = (
        hotel.rooms
        .filter(is_active=True)
        .order_by("room_type", "price_per_night")
    )

    reviews = (
        hotel.reviews
        .select_related("user")
        .order_by("-created_at")
    )

    review_stats = reviews.aggregate(
        avg=Avg("rating"),
        count=Count("id"),
    )
    average_rating = review_stats["avg"] or 0
    hotel.review_average = average_rating
    hotel.review_count = review_stats["count"] or 0

    return render(
        request,
        "hotels/hotel_detail.html",
        {
            "hotel": hotel,
            "rooms": rooms,
            "reviews": reviews,
            "average_rating": average_rating,
            "stay_score": stay_score(hotel),
        },
    )

@login_required
def book_room(request, room_id):

    from datetime import date

    room = get_object_or_404(
        Room.objects.select_related("hotel"),
        id=room_id,
        is_active=True,
        hotel__is_active=True,
    )


    # ==================================================
    # DATES + GUESTS FROM SEARCH
    # ==================================================

    check_in_param = request.GET.get(
        "check_in",
        ""
    )

    check_out_param = request.GET.get(
        "check_out",
        ""
    )

    guests_param = request.GET.get(
        "guests",
        "1"
    )


    try:
        guests = max(
            1,
            int(guests_param)
        )
    except (ValueError, TypeError):
        guests = 1


    check_in = None
    check_out = None
    nights = None
    total_price = None


    if check_in_param and check_out_param:

        try:

            check_in = date.fromisoformat(
                check_in_param
            )

            check_out = date.fromisoformat(
                check_out_param
            )

            nights = (
                check_out - check_in
            ).days

            if nights > 0:

                total_price = (
                    room.price_per_night
                    * Decimal(nights)
                )

        except ValueError:

            check_in = None
            check_out = None


    # ==================================================
    # GET
    # ==================================================

    if request.method == "GET":

        form = BookingForm(
            initial={
                "check_in": check_in,
                "check_out": check_out,
            }
        )

        return render(
            request,
            "hotels/book_room.html",
            {
                "room": room,
                "hotel": room.hotel,
                "form": form,

                "check_in": check_in,
                "check_out": check_out,

                "guests": guests,

                "nights": nights,
                "total_price": total_price,
            },
        )


    # ==================================================
    # POST
    # ==================================================

    form = BookingForm(
        request.POST
    )


    if form.is_valid():

        check_in = form.cleaned_data[
            "check_in"
        ]

        check_out = form.cleaned_data[
            "check_out"
        ]

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


            # ------------------------------------------
            # DOUBLE BOOKING CHECK
            # ------------------------------------------

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


            # ------------------------------------------
            # TOTAL
            # ------------------------------------------

            total = (
                locked_room.price_per_night
                * Decimal(nights)
            )


            # ------------------------------------------
            # CREATE BOOKING
            # ------------------------------------------

            try:

                booking = Booking.objects.create(

                    user=request.user,

                    room=locked_room,

                    check_in=check_in,

                    check_out=check_out,

                    guests=guests,

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


    # ==================================================
    # INVALID FORM
    # ==================================================

    return render(
        request,
        "hotels/book_room.html",
        {
            "room": room,
            "hotel": room.hotel,
            "form": form,
            "check_in": check_in or request.POST.get("check_in"),
            "check_out": check_out or request.POST.get("check_out"),
            "guests": guests,
            "nights": None,
            "total_price": None,
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
    bookings = Booking.objects.filter(
        user=request.user
    ).select_related(
        "room",
        "room__hotel",
    ).order_by("-created_at")

    active_bookings_count = bookings.exclude(
        status="CANCELLED"
    ).count()

    return render(
        request,
        "hotels/my_bookings.html",
        {
            "bookings": bookings,
            "active_bookings_count": active_bookings_count,
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