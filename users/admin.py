from django.contrib import admin

from .models import CustomerProfile


@admin.register(CustomerProfile)
class CustomerProfileAdmin(admin.ModelAdmin):
    list_display = (
        "user",
        "phone_number",
        "is_verified",
    )
    list_filter = (
        "is_verified",
    )
    search_fields = (
        "user__username",
        "user__email",
        "phone_number",
    )