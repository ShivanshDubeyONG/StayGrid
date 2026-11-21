"""
Business logic and domain services for the hotels application.

Encapsulates stay score calculation, booking concurrency management,
pricing computations, and vendor analytics.
"""

from datetime import date
from decimal import Decimal
from typing import Any, Dict, Optional, Tuple

from django.db import IntegrityError, transaction
from django.db.models import Avg, Count, Max, Min, Q, QuerySet, Sum

from .models import Booking, Hotel, Room


def calculate_stay_score(
    hotel: Hotel,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
) -> float:
    """
    Calculates StayGrid score out of 100 based on weighted metrics:
    - Hotel star rating: 40% (max 40 pts)
    - Guest reviews average: 35% (max 35 pts)
    - Number of reviews: 10% (max 10 pts, capped at 10 reviews)
    - Relative price value: 15% (max 15 pts)
    """
    # --------------------------------------------------
    # STAR RATING — 40 POINTS
    # --------------------------------------------------
    star_rating = float(hotel.star_rating or 0)
    star_score = (star_rating / 5.0) * 40.0

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
        average_rating = float(review_data["average"] or 0.0)
        review_count = int(review_data["count"] or 0)

    review_score = (average_rating / 5.0) * 35.0

    # --------------------------------------------------
    # REVIEW COUNT — 10 POINTS
    # --------------------------------------------------
    review_count_score = min(float(review_count), 10.0)

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
        min_price = float(price_stats["min_p"] or 0.0)
        max_price = float(price_stats["max_p"] or 0.0)

    price_score = 0.0
    if hotel.offer_price and max_price > 0:
        hotel_price = float(hotel.offer_price)
        if max_price > min_price:
            price_score = (
                (max_price - hotel_price) / (max_price - min_price)
            ) * 15.0
        else:
            price_score = 15.0

    total_score = star_score + review_score + review_count_score + price_score
    return round(min(max(total_score, 0.0), 100.0), 1)


# Backwards compatibility alias
stay_score = calculate_stay_score


def check_booking_conflict(
    room: Room,
    check_in: date,
    check_out: date,
    exclude_booking_id: Optional[int] = None,
) -> bool:
    """
    Checks if a room already has an active overlapping booking
    for the specified date range.
    """
    query = Booking.objects.filter(
        room=room,
        status__in=["PENDING", "CONFIRMED"],
        check_in__lt=check_out,
        check_out__gt=check_in,
    )
    if exclude_booking_id:
        query = query.exclude(id=exclude_booking_id)
    return query.exists()


def calculate_booking_cost(
    price_per_night: Decimal,
    check_in: date,
    check_out: date,
) -> Tuple[int, Decimal]:
    """
    Computes number of nights and total price.
    Raises ValueError if check_out is not strictly after check_in.
    """
    nights = (check_out - check_in).days
    if nights <= 0:
        raise ValueError("Check-out date must be strictly after check-in date.")
    total_price = price_per_night * Decimal(nights)
    return nights, total_price


def create_room_booking(
    *,
    user: Any,
    room_id: int,
    check_in: date,
    check_out: date,
    guests: int = 1,
) -> Booking:
    """
    Atomically books a room with row-level locking to prevent race conditions
    and double-bookings.
    """
    nights, total_price = calculate_booking_cost(
        Room.objects.get(id=room_id).price_per_night,
        check_in,
        check_out,
    )

    with transaction.atomic():
        locked_room = (
            Room.objects.select_for_update()
            .select_related("hotel")
            .get(id=room_id, is_active=True, hotel__is_active=True)
        )

        if check_booking_conflict(locked_room, check_in, check_out):
            raise ValueError("This room is unavailable for the selected dates.")

        # Recalculate with locked room price in case it changed
        total_price = locked_room.price_per_night * Decimal(nights)

        booking = Booking.objects.create(
            user=user,
            room=locked_room,
            check_in=check_in,
            check_out=check_out,
            guests=guests,
            total_price=total_price,
            status="CONFIRMED",
        )
        return booking


def get_vendor_analytics(vendor: Any) -> Dict[str, Any]:
    """
    Computes vendor dashboard metrics:
    - revenue from confirmed/completed stays
    - total booking count
    - total active rooms
    - occupancy percentage
    - top performing hotel by booking count
    """
    hotels = vendor.hotels.all()

    bookings = Booking.objects.filter(
        room__hotel__owner=vendor,
        status__in=["CONFIRMED", "COMPLETED"],
    )

    revenue_aggregate = bookings.aggregate(total=Sum("total_price"))
    total_revenue = revenue_aggregate["total"] or Decimal("0")
    total_bookings = bookings.count()

    total_rooms = Room.objects.filter(
        hotel__owner=vendor,
        is_active=True,
    ).count()

    occupied_rooms = bookings.values("room").distinct().count()
    occupancy = (
        (occupied_rooms / total_rooms) * 100.0 if total_rooms > 0 else 0.0
    )

    top_hotel = (
        hotels.annotate(
            booking_count=Count(
                "rooms__bookings",
                filter=Q(
                    rooms__bookings__status__in=["CONFIRMED", "COMPLETED"]
                ),
            )
        )
        .order_by("-booking_count")
        .first()
    )

    return {
        "hotels": hotels,
        "total_revenue": total_revenue,
        "total_bookings": total_bookings,
        "total_rooms": total_rooms,
        "occupancy": round(occupancy, 1),
        "top_hotel": top_hotel,
    }
