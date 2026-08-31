from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.shortcuts import redirect, render

from .models import VendorProfile
from hotels.models import Booking


def vendor_register(request):

    if request.user.is_authenticated:
        return redirect("vendor_dashboard")

    if request.method == "POST":

        username = request.POST.get("username", "").strip()
        email = request.POST.get("email", "").strip()
        first_name = request.POST.get("first_name", "").strip()
        last_name = request.POST.get("last_name", "").strip()
        phone = request.POST.get("phone_number", "").strip()
        business = request.POST.get("business_name", "").strip()

        password = request.POST.get("password", "")
        confirm = request.POST.get("confirm_password", "")

        if not username:
            messages.error(request, "Username is required.")
            return redirect("vendor_register")

        if password != confirm:
            messages.error(
                request,
                "Passwords do not match."
            )
            return redirect("vendor_register")

        if User.objects.filter(
            username=username
        ).exists():

            messages.error(
                request,
                "Username already exists."
            )
            return redirect("vendor_register")

        if email and User.objects.filter(
            email=email
        ).exists():

            messages.error(
                request,
                "Email already exists."
            )
            return redirect("vendor_register")

        user = User.objects.create_user(
            username=username,
            email=email,
            first_name=first_name,
            last_name=last_name,
            password=password,
        )

        VendorProfile.objects.create(
            user=user,
            business_name=business,
            phone_number=phone,
        )

        messages.success(
            request,
            "Vendor account created."
        )

        return redirect("vendor_login")

    return render(
        request,
        "vendors/register.html"
    )


def vendor_login(request):

    if request.method == "POST":

        username = request.POST.get(
            "username",
            ""
        ).strip()

        password = request.POST.get(
            "password",
            ""
        )

        user = authenticate(
            request,
            username=username,
            password=password,
        )

        if user is None:

            messages.error(
                request,
                "Invalid credentials."
            )

            return redirect("vendor_login")

        try:
            user.vendor_profile
        except VendorProfile.DoesNotExist:

            messages.error(
                request,
                "This is not a vendor account."
            )

            return redirect("vendor_login")

        login(request, user)

        return redirect("vendor_dashboard")

    return render(
        request,
        "vendors/login.html"
    )


@login_required
def vendor_logout(request):

    logout(request)

    return redirect("home")


@login_required
def vendor_dashboard(request):

    vendor = request.user.vendor_profile

    hotels = vendor.hotels.all()

    bookings = Booking.objects.filter(
        room__hotel__owner=vendor
    )

    return render(
        request,
        "vendors/dashboard.html",
        {
            "vendor": vendor,
            "hotels": hotels,
            "bookings": bookings,
        },
    )


@login_required
def vendor_bookings(request):

    vendor = request.user.vendor_profile

    bookings = (
        Booking.objects
        .filter(
            room__hotel__owner=vendor
        )
        .select_related(
            "user",
            "room",
            "room__hotel",
        )
        .order_by("-created_at")
    )

    return render(
        request,
        "vendors/bookings.html",
        {
            "bookings": bookings,
        },
    )