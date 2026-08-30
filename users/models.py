from django.db import models
from django.contrib.auth.models import User


class CustomerProfile(models.Model):
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="customer_profile"
    )
    phone_number = models.CharField(
        max_length=15,
        unique=True
    )
    is_verified = models.BooleanField(default=False)
    profile_picture = models.ImageField(
        upload_to="profiles/customers/",
        blank=True,
        null=True
    )

    def __str__(self):
        return self.user.get_full_name() or self.user.username