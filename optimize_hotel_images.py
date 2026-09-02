from pathlib import Path
from PIL import Image, ImageOps

SOURCE = Path("media/hotels")
OUTPUT = Path("media/hotels/optimized")

OUTPUT.mkdir(parents=True, exist_ok=True)

allowed = {".jpg", ".jpeg", ".png", ".webp"}

for image_path in sorted(SOURCE.iterdir()):
    if image_path.suffix.lower() not in allowed:
        continue

    try:
        with Image.open(image_path) as image:
            image = ImageOps.fit(
                image.convert("RGB"),
                (1200, 800),
                method=Image.Resampling.LANCZOS
            )

            output_path = OUTPUT / f"{image_path.stem}.webp"

            image.save(
                output_path,
                "WEBP",
                quality=78,
                method=6
            )

            size_kb = output_path.stat().st_size / 1024

            print(f"✓ {image_path.name} → {output_path.name} ({size_kb:.0f} KB)")

    except Exception as e:
        print(f"✗ {image_path.name}: {e}")

print("\nDone.")