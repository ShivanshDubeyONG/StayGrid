from django.urls import path

from . import views


urlpatterns = [
    path("register/", views.vendor_register, name="vendor_register"),
    path("login/", views.vendor_login, name="vendor_login"),
    path("logout/", views.vendor_logout, name="vendor_logout"),
    path("dashboard/", views.vendor_dashboard, name="vendor_dashboard"),
]