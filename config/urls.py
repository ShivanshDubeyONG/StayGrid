from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import render

from hotels.models import Hotel


def home(request):
    try:
        featured_hotels = list(
            Hotel.objects
            .filter(is_active=True)
            .prefetch_related("images")
            .order_by("-created_at")[:6]
        )
        hotel_count = Hotel.objects.filter(is_active=True).count()
    except Exception:
        featured_hotels = []
        hotel_count = 0

    return render(
        request,
        "home/home.html",
        {
            "featured_hotels": featured_hotels,
            "hotel_count": hotel_count,
        },
    )


urlpatterns = [

    path(
        "admin/",
        admin.site.urls
    ),

    path(
        "",
        home,
        name="home"
    ),

    path(
        "users/",
        include("users.urls")
    ),

    path(
        "hotels/",
        include("hotels.urls")
    ),

    path(
        "vendors/",
        include("vendors.urls")
    ),
]

urlpatterns += static(
    settings.MEDIA_URL,
    document_root=settings.MEDIA_ROOT,
)