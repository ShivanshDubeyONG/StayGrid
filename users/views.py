from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.shortcuts import redirect, render

from .models import CustomerProfile


def register(request):

    if request.user.is_authenticated:
        return redirect("home")

    if request.method == "POST":

        username = request.POST.get(
            "username",
            ""
        ).strip()

        email = request.POST.get(
            "email",
            ""
        ).strip()

        first_name = request.POST.get(
            "first_name",
            ""
        ).strip()

        last_name = request.POST.get(
            "last_name",
            ""
        ).strip()

        phone = request.POST.get(
            "phone_number",
            ""
        ).strip()

        password = request.POST.get(
            "password",
            ""
        )

        confirm = request.POST.get(
            "confirm_password",
            ""
        )

        if not username:
            messages.error(
                request,
                "Username is required."
            )
            return redirect("register")

        if not password:
            messages.error(
                request,
                "Password is required."
            )
            return redirect("register")

        if password != confirm:
            messages.error(
                request,
                "Passwords do not match."
            )
            return redirect("register")

        if User.objects.filter(
            username=username
        ).exists():

            messages.error(
                request,
                "Username already exists."
            )
            return redirect("register")

        if email and User.objects.filter(
            email=email
        ).exists():

            messages.error(
                request,
                "Email already exists."
            )
            return redirect("register")

        if phone and CustomerProfile.objects.filter(
            phone_number=phone
        ).exists():

            messages.error(
                request,
                "Phone number already exists."
            )
            return redirect("register")

        user = User.objects.create_user(
            username=username,
            email=email,
            first_name=first_name,
            last_name=last_name,
            password=password,
        )

        if phone:
            CustomerProfile.objects.create(
                user=user,
                phone_number=phone,
            )

        messages.success(
            request,
            "Account created successfully."
        )

        return redirect("login")

    return render(
        request,
        "users/register.html"
    )


def login_view(request):

    if request.user.is_authenticated:
        return redirect("home")

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
                "Invalid username or password."
            )

            return redirect("login")

        login(
            request,
            user
        )

        return redirect("home")

    return render(
        request,
        "users/login.html"
    )


@login_required
def logout_view(request):

    logout(request)

    return redirect("home")


@login_required
def profile(request):

    profile, created = (
        CustomerProfile.objects.get_or_create(
            user=request.user,
            defaults={
                "phone_number": (
                    f"auto-{request.user.id}"
                )
            },
        )
    )

    if request.method == "POST":

        first_name = request.POST.get(
            "first_name",
            ""
        ).strip()

        last_name = request.POST.get(
            "last_name",
            ""
        ).strip()

        email = request.POST.get(
            "email",
            ""
        ).strip()

        phone = request.POST.get(
            "phone_number",
            ""
        ).strip()

        if first_name:
            request.user.first_name = first_name

        else:
            request.user.first_name = ""

        request.user.last_name = last_name

        request.user.email = email

        request.user.save(
            update_fields=[
                "first_name",
                "last_name",
                "email",
            ]
        )

        if phone and phone != profile.phone_number:

            if CustomerProfile.objects.filter(
                phone_number=phone
            ).exclude(
                user=request.user
            ).exists():

                messages.error(
                    request,
                    "That phone number is already in use."
                )

                return redirect("profile")

            profile.phone_number = phone
            profile.save(
                update_fields=["phone_number"]
            )

        messages.success(
            request,
            "Profile updated successfully."
        )

        return redirect("profile")

    return render(
        request,
        "users/profile.html",
        {
            "profile": profile,
        },
    )