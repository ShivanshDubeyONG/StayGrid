from django.db import models
from django.contrib.auth.models import User


class VendorProfile(models.Model):
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="vendor_profile"
    )
    business_name = models.CharField(max_length=150)
    phone_number = models.CharField(max_length=15)
    is_verified = models.BooleanField(default=False)
    profile_picture = models.ImageField(
        upload_to="profiles/vendors/",
        blank=True,
        null=True
    )

    def __str__(self):
        return self.business_name