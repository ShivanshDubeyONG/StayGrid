"""
Django management command to compress and convert hotel media images to WebP format.

Usage:
    python manage.py optimize_images [--quality 78] [--width 1200] [--height 800] [--dry-run]
"""

from pathlib import Path
from django.conf import settings
from django.core.management.base import BaseCommand

try:
    from PIL import Image, ImageOps
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False


class Command(BaseCommand):
    help = "Optimizes hotel media images by resizing and converting to modern WebP format."

    def add_arguments(self, parser):
        parser.add_argument(
            "--quality",
            type=int,
            default=78,
            help="WebP compression quality (1-100, default: 78).",
        )
        parser.add_argument(
            "--width",
            type=int,
            default=1200,
            help="Target image width in pixels (default: 1200).",
        )
        parser.add_argument(
            "--height",
            type=int,
            default=800,
            help="Target image height in pixels (default: 800).",
        )
        parser.add_argument(
            "--dry-run",
            action="store_true",
            help="Simulate optimization without writing changes to disk.",
        )

    def handle(self, *args, **options):
        if not PIL_AVAILABLE:
            self.stderr.write(
                self.style.ERROR("Pillow library is not installed. Run 'pip install Pillow' to use this command.")
            )
            return

        quality = options.get("quality", 78)
        max_width = options.get("width", 1200)
        max_height = options.get("height", 800)
        dry_run = options.get("dry_run", False)

        media_root = Path(settings.MEDIA_ROOT)
        source_dir = media_root / "hotels"
        output_dir = source_dir / "optimized"

        if not source_dir.exists():
            self.stdout.write(
                self.style.WARNING(f"Media directory '{source_dir}' does not exist yet. No images to optimize.")
            )
            return

        if not dry_run:
            output_dir.mkdir(parents=True, exist_ok=True)

        allowed_extensions = {".jpg", ".jpeg", ".png", ".webp"}
        files_to_process = [
            f for f in sorted(source_dir.iterdir())
            if f.is_file() and f.suffix.lower() in allowed_extensions
        ]

        if not files_to_process:
            self.stdout.write(self.style.NOTICE("No candidate images found in media/hotels/."))
            return

        self.stdout.write(f"Found {len(files_to_process)} image(s) to optimize (quality={quality}, target={max_width}x{max_height})...")

        optimized_count = 0
        saved_bytes = 0

        for image_path in files_to_process:
            try:
                original_size = image_path.stat().st_size
                output_path = output_dir / f"{image_path.stem}.webp"

                if dry_run:
                    self.stdout.write(f"[Dry Run] Would optimize: {image_path.name} -> {output_path.name}")
                    optimized_count += 1
                    continue

                with Image.open(image_path) as img:
                    fitted = ImageOps.fit(
                        img.convert("RGB"),
                        (max_width, max_height),
                        method=Image.Resampling.LANCZOS,
                    )
                    fitted.save(
                        output_path,
                        "WEBP",
                        quality=quality,
                        method=6,
                    )

                new_size = output_path.stat().st_size
                diff_kb = (original_size - new_size) / 1024
                if original_size > new_size:
                    saved_bytes += (original_size - new_size)

                self.stdout.write(
                    self.style.SUCCESS(
                        f"✓ {image_path.name} ({original_size/1024:.0f} KB) -> {output_path.name} ({new_size/1024:.0f} KB, saved {diff_kb:.0f} KB)"
                    )
                )
                optimized_count += 1

            except Exception as e:
                self.stderr.write(self.style.ERROR(f"✗ Failed to process {image_path.name}: {e}"))

        self.stdout.write(
            self.style.SUCCESS(
                f"Optimization complete! {optimized_count} images processed. Total space saved: {saved_bytes / 1024:.1f} KB."
            )
        )
