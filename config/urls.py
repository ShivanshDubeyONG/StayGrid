from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import render

from hotels.models import Hotel


def home(request):

    hotels = (
        Hotel.objects
        .filter(is_active=True)
        .prefetch_related("images", "rooms")
        .order_by("-created_at")
    )

    featured_hotels = hotels[:6]

    return render(
        request,
        "home/home.html",
        {
            "hotels": hotels,
            "featured_hotels": featured_hotels,
            "hotel_count": hotels.count(),
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