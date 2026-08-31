from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.shortcuts import redirect, render

from .models import VendorProfile


def vendor_register(request):
    if request.user.is_authenticated:
        return redirect("vendor_dashboard")

    if request.method == "POST":
        first_name = request.POST.get("first_name", "").strip()
        last_name = request.POST.get("last_name", "").strip()
        username = request.POST.get("username", "").strip()
        email = request.POST.get("email", "").strip()
        phone_number = request.POST.get("phone_number", "").strip()
        business_name = request.POST.get("business_name", "").strip()
        password = request.POST.get("password", "")
        confirm_password = request.POST.get("confirm_password", "")

        if not all([
            first_name,
            last_name,
            username,
            email,
            phone_number,
            business_name,
            password,
            confirm_password,
        ]):
            messages.error(request, "Please fill in all fields.")
            return redirect("vendor_register")

        if password != confirm_password:
            messages.error(request, "Passwords do not match.")
            return redirect("vendor_register")

        if User.objects.filter(username=username).exists():
            messages.error(request, "Username already exists.")
            return redirect("vendor_register")

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already exists.")
            return redirect("vendor_register")

        if VendorProfile.objects.filter(
            phone_number=phone_number
        ).exists():
            messages.error(request, "Phone number already exists.")
            return redirect("vendor_register")

        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
        )

        VendorProfile.objects.create(
            user=user,
            business_name=business_name,
            phone_number=phone_number,
        )

        messages.success(
            request,
            "Vendor account created successfully."
        )

        return redirect("vendor_login")

    return render(request, "vendors/register.html")


def vendor_login(request):
    if request.user.is_authenticated:
        return redirect("vendor_dashboard")

    if request.method == "POST":
        username = request.POST.get("username", "").strip()
        password = request.POST.get("password", "")

        user = authenticate(
            request,
            username=username,
            password=password,
        )

        if user is None:
            messages.error(
                request,
                "Invalid username or password."
            )
            return redirect("vendor_login")

        try:
            user.vendor_profile
        except VendorProfile.DoesNotExist:
            messages.error(
                request,
                "This account is not registered as a vendor."
            )
            return redirect("vendor_login")

        login(request, user)

        messages.success(
            request,
            f"Welcome, {user.vendor_profile.business_name}!"
        )

        return redirect("vendor_dashboard")

    return render(request, "vendors/login.html")


@login_required
def vendor_logout(request):
    logout(request)
    return redirect("home")


@login_required
def vendor_dashboard(request):
    vendor = request.user.vendor_profile

    hotels = vendor.hotels.all()

    return render(
        request,
        "vendors/dashboard.html",
        {
            "vendor": vendor,
            "hotels": hotels,
        },
    )