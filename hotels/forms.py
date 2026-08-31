from django import forms
from django.core.exceptions import ValidationError
from django.utils import timezone

from .models import Hotel, Room, Review


class HotelForm(forms.ModelForm):

    class Meta:
        model = Hotel

        fields = [
            "name",
            "description",
            "location",
            "original_price",
            "offer_price",
            "star_rating",
            "is_active",
        ]

        widgets = {
            "description": forms.Textarea(
                attrs={"rows": 5}
            ),
        }


class RoomForm(forms.ModelForm):

    class Meta:
        model = Room

        fields = [
            "room_number",
            "room_type",
            "capacity",
            "price_per_night",
            "is_active",
        ]


class BookingForm(forms.Form):

    check_in = forms.DateField(
        widget=forms.DateInput(
            attrs={"type": "date"}
        )
    )

    check_out = forms.DateField(
        widget=forms.DateInput(
            attrs={"type": "date"}
        )
    )

    def clean(self):

        data = super().clean()

        check_in = data.get("check_in")
        check_out = data.get("check_out")

        if check_in and check_in < timezone.localdate():
            raise ValidationError(
                "Check-in cannot be in the past."
            )

        if check_in and check_out:

            if check_out <= check_in:
                raise ValidationError(
                    "Check-out must be after check-in."
                )

        return data


class ReviewForm(forms.ModelForm):

    class Meta:
        model = Review

        fields = [
            "rating",
            "comment",
        ]

        widgets = {
            "rating": forms.NumberInput(
                attrs={
                    "min": 1,
                    "max": 5
                }
            ),
            "comment": forms.Textarea(
                attrs={
                    "rows": 4,
                    "placeholder": "Tell us about your stay..."
                }
            ),
        }