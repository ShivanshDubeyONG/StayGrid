from django import forms

from .models import Hotel, Room


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
            "amenities",
            "is_active",
        ]

        widgets = {
            "description": forms.Textarea(
                attrs={
                    "rows": 5,
                    "placeholder": "Describe the hotel..."
                }
            ),
            "amenities": forms.CheckboxSelectMultiple(),
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

        widgets = {
            "room_number": forms.TextInput(
                attrs={
                    "placeholder": "e.g. 101"
                }
            ),
            "capacity": forms.NumberInput(
                attrs={
                    "min": 1
                }
            ),
            "price_per_night": forms.NumberInput(
                attrs={
                    "min": 0,
                    "step": "0.01"
                }
            ),
        }