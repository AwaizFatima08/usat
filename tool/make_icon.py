#!/usr/bin/env python3
"""Draws the launcher icon in code (flat shapes, no AI): deep navy square with a row of three
answer-sheet bubbles (the middle one filled amber) above three essay lines: USAT's Part I and Part II. Writes Android mipmaps, the Play icon and site images.

  python3 tool/make_icon.py
"""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
NAVY = (31, 58, 107)
AMBER = (227, 154, 28)
WHITE = (255, 255, 255)


def draw(size, rounded):
    s = 4 * size  # supersample for smooth edges
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if rounded:
        d.rounded_rectangle([0, 0, s - 1, s - 1], radius=int(s * 0.22), fill=NAVY)
    else:
        d.rectangle([0, 0, s, s], fill=NAVY)
    r, stroke = s * 0.095, int(s * 0.03)
    for i, cx in enumerate([0.27, 0.50, 0.73]):
        box = [s * cx - r, s * 0.33 - r, s * cx + r, s * 0.33 + r]
        filled = i == 1
        d.ellipse(box, fill=AMBER if filled else None, outline=AMBER if filled else WHITE, width=stroke)
    for y, end in [(0.58, 0.80), (0.68, 0.80), (0.78, 0.62)]:
        d.rounded_rectangle([s * 0.20, s * y - s * 0.028, s * end, s * y + s * 0.028], radius=int(s * 0.028), fill=WHITE)
    return img.resize((size, size), Image.LANCZOS)


def main():
    res = ROOT / "android/app/src/main/res"
    for folder, px in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        draw(px, rounded=True).save(res / f"mipmap-{folder}" / "ic_launcher.png")
    draw(512, rounded=False).convert("RGB").save(ROOT / "store-assets/icon-512.png")
    img = ROOT / "website/img"
    img.mkdir(exist_ok=True)
    draw(192, rounded=True).save(img / "icon.png")
    draw(48, rounded=True).save(img / "favicon.png")
    # Feature graphic: icon plus title.
    from PIL import ImageFont
    fg = Image.new("RGB", (1024, 500), NAVY)
    icon = draw(240, rounded=True)
    fg.paste(icon, (70, 130), icon)
    d = ImageDraw.Draw(fg)
    bold = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 54)
    small = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 30)
    d.text((350, 160), "Prep Simulator", font=bold, fill=WHITE)
    d.text((350, 224), "for USAT", font=bold, fill=WHITE)
    d.text((350, 305), "HEC USAT mocks · essays · notes", font=small, fill=(240, 220, 170))
    fg.save(ROOT / "store-assets/feature-graphic.png")
    print("icons written")


main()
