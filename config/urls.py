from django.contrib import admin
from django.urls import include, path
from django.conf import settings
from django.conf.urls.static import static

from django.shortcuts import render


def home(request):
    return render(request, "base.html")


urlpatterns = [
    path("admin/", admin.site.urls),

    path("", home, name="home"),

    path("users/", include("users.urls")),
    path("hotels/", include("hotels.urls")),
    path("vendors/", include("vendors.urls")),
]

if settings.DEBUG:
    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT,
    )