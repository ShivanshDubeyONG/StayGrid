from django.contrib import admin

from .models import VendorProfile


@admin.register(VendorProfile)
class VendorProfileAdmin(admin.ModelAdmin):
    list_display = (
        "business_name",
        "user",
        "phone_number",
        "is_verified",
    )
    list_filter = (
        "is_verified",
    )
    search_fields = (
        "business_name",
        "user__username",
        "user__email",
        "phone_number",
    )