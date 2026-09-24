"""Regenerates every Eduvora app icon (web PWA, favicon, Android, iOS, Play Store)
from the approved book mark, crisp at every size.

Why this exists: the approved mark PNG is only 249x272 px. The old icons were that
tiny bitmap stretched up to 512 px, so edges were blurry, and the mark ran edge to
edge, so phone launchers (which crop icons to a circle/squircle) showed mostly a blue
blob. This script:
  1. smoothly enlarges the mark's alpha mask 8x (Lanczos + threshold) so its edges
     stay sharp at any size,
  2. draws a white mark on the brand blue with the correct safe-zone padding for each
     kind of icon, supersampled 4x for clean anti-aliasing.

Run from the repo root:  py tools/gen_icons.py
"""
import glob
import json
import os

from PIL import Image, ImageDraw

BLUE = (37, 99, 235, 255)  # AppColours.primary #2563EB
WHITE = (255, 255, 255, 255)
SS = 4  # supersampling factor

SRC = 'assets/branding/eduvora_mark_white.png'

# ---------------------------------------------------------------- mark mask
_src_alpha = Image.open(SRC).convert('RGBA').split()[3]
_big = _src_alpha.resize((_src_alpha.width * 8, _src_alpha.height * 8), Image.LANCZOS)
MASK = _big.point(lambda v: 255 if v >= 128 else 0).convert('L')  # crisp edges
ASPECT = MASK.width / MASK.height  # ~0.915 (width / height)


def mark_layer(canvas, height_frac, color=WHITE):
    """A transparent canvas x canvas layer with the mark centred at height_frac."""
    h = round(canvas * height_frac)
    w = round(h * ASPECT)
    m = MASK.resize((w, h), Image.LANCZOS)
    layer = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    solid = Image.new('RGBA', (w, h), color)
    layer.paste(solid, ((canvas - w) // 2, (canvas - h) // 2), m)
    return layer


def icon(size, height_frac, radius_frac=0.0, background=BLUE, transparent_bg=False):
    """Blue tile (optionally rounded) with the white mark. Returns an RGBA image."""
    s = size * SS
    tile = Image.new('RGBA', (s, s), (0, 0, 0, 0) if transparent_bg else background)
    if not transparent_bg and radius_frac > 0:
        mask = Image.new('L', (s, s), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            (0, 0, s - 1, s - 1), radius=round(s * radius_frac), fill=255)
        rounded = Image.new('RGBA', (s, s), (0, 0, 0, 0))
        rounded.paste(background, (0, 0), mask)
        tile = rounded
    tile.alpha_composite(mark_layer(s, height_frac))
    return tile.resize((size, size), Image.LANCZOS)


def foreground(size, height_frac):
    """Transparent layer with just the white mark (Android adaptive foreground)."""
    s = size * SS
    return mark_layer(s, height_frac).resize((size, size), Image.LANCZOS)


def save(img, path, opaque=False):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if opaque:
        flat = Image.new('RGB', img.size, BLUE[:3])
        flat.paste(img, mask=img.split()[3])
        img = flat
    img.save(path, optimize=True)
    print('wrote', path, img.size)


# ---------------------------------------------------------------- web / PWA
ANY_H, ANY_R = 0.60, 0.225      # rounded tile, transparent corners
MASKABLE_H = 0.46               # inside the 80% circular safe zone, full bleed
FLAT_H = 0.56                   # opaque squares (iOS / Play Store) - OS rounds them

for size in (192, 512):
    save(icon(size, ANY_H, ANY_R), f'web/icons/Icon-{size}.png')
    save(icon(size, MASKABLE_H), f'web/icons/Icon-maskable-{size}.png', opaque=True)
save(icon(180, FLAT_H), 'web/icons/apple-touch-icon.png', opaque=True)
save(icon(64, 0.66, ANY_R), 'web/favicon.png')

# ---------------------------------------------------------------- Android
LEGACY = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}
for dpi, px in LEGACY.items():
    save(icon(px, ANY_H, 0.18), f'android/app/src/main/res/mipmap-{dpi}/ic_launcher.png')
ADAPTIVE = {'mdpi': 108, 'hdpi': 162, 'xhdpi': 216, 'xxhdpi': 324, 'xxxhdpi': 432}
for dpi, px in ADAPTIVE.items():
    save(foreground(px, 0.44),
         f'android/app/src/main/res/drawable-{dpi}/ic_launcher_foreground.png')

with open('android/app/src/main/res/values/colors.xml', 'w', encoding='utf-8') as f:
    f.write('<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
            '    <color name="ic_launcher_background">#2563EB</color>\n</resources>\n')
with open('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml', 'w', encoding='utf-8') as f:
    f.write('<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '  <background android:drawable="@color/ic_launcher_background"/>\n'
            '  <foreground android:drawable="@drawable/ic_launcher_foreground"/>\n'
            '  <monochrome android:drawable="@drawable/ic_launcher_foreground"/>\n'
            '</adaptive-icon>\n')

# ---------------------------------------------------------------- iOS
ios_dir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
if os.path.isdir(ios_dir):
    contents = json.load(open(os.path.join(ios_dir, 'Contents.json'), encoding='utf-8'))
    for entry in contents['images']:
        name = entry.get('filename')
        if not name:
            continue
        pts = float(entry['size'].split('x')[0])
        scale = int(entry['scale'].replace('x', ''))
        save(icon(round(pts * scale), FLAT_H), os.path.join(ios_dir, name), opaque=True)

# ---------------------------------------------------------------- masters / store
save(icon(1024, FLAT_H), 'assets/branding/eduvora_icon_master_1024.png', opaque=True)
save(foreground(1024, 0.44), 'assets/branding/eduvora_icon_foreground_1024.png')
save(icon(512, FLAT_H), 'assets/branding/play_store_icon_512.png', opaque=True)
print('done')
