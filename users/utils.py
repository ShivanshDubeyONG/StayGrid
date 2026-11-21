"""
Utility functions for the users app.

Provides phone number normalization, validation, display helpers,
and user profile verification utilities.
"""

import re
from typing import Any, Optional


PHONE_REGEX = re.compile(r"^\+?[0-9]{10,15}$")


def normalize_phone_number(phone: Optional[str]) -> str:
    """
    Strips whitespace, parentheses, and dashes from a phone string.
    Preserves leading '+' if present.
    """
    if not phone:
        return ""
    cleaned = re.sub(r"[\s\-\(\)\.]", "", str(phone).strip())
    return cleaned


def validate_phone_number(phone: Optional[str]) -> bool:
    """
    Validates that a phone number contains 10 to 15 digits,
    optionally preceded by a '+' sign.
    """
    if not phone:
        return False
    normalized = normalize_phone_number(phone)
    return bool(PHONE_REGEX.match(normalized))


def get_user_display_name(user: Any) -> str:
    """
    Returns the user's full name if available, otherwise falls back to username.
    """
    if not user:
        return ""
    if hasattr(user, "get_full_name"):
        full_name = user.get_full_name().strip()
        if full_name:
            return full_name
    return getattr(user, "username", "")


def is_profile_complete(user: Any) -> bool:
    """
    Returns True if user has email, first name, and a verified or valid customer phone.
    """
    if not user or not getattr(user, "is_authenticated", False):
        return False
    if not getattr(user, "email", "") or not getattr(user, "first_name", ""):
        return False
    profile = getattr(user, "customer_profile", None)
    if not profile or not profile.phone_number:
        return False
    # Avoid auto-generated placeholder phone numbers
    if str(profile.phone_number).startswith("auto-"):
        return False
    return True
