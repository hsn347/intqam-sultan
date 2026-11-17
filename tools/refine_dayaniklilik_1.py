import os
from PIL import Image, ImageDraw, ImageFilter

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

# 1. Load the original dayaniklilik_1.png backup or clean frame
# Let's inspect the frame: It has ornate golden border and dark interior.
# We can cleanly paint the inner polygon of the diamond with the exact smooth dark radial gradient!

medallion = Image.open('dashboard/public/images/daily/dayaniklilik_1.png').convert('RGBA')
w, h = medallion.size

# The center of the medallion is around (w/2, h/2) = (209, 214)
# Let's create a clean dark diamond patch to cover any infill artifacts cleanly
# Inside the gold border, the diamond shape vertices:
# Top: (209, 70), Right: (355, 214), Bottom: (209, 360), Left: (65, 214)

inner_mask = Image.new('L', (w, h), 0)
draw_mask = ImageDraw.Draw(inner_mask)

# Define the inner polygon just inside the golden border
poly = [
    (209, 65),
    (230, 95), (280, 140), (320, 180), (355, 214),
    (320, 250), (280, 290), (230, 335), (209, 365),
    (188, 335), (138, 290), (98, 250), (63, 214),
    (98, 180), (138, 140), (188, 95)
]
draw_mask.polygon(poly, fill=255)
# Erode slightly so we don't touch the gold inner bevel
inner_mask = inner_mask.filter(ImageFilter.GaussianBlur(1.5))

# Create smooth gradient dark background plate matching the exact dark slate texture
plate = Image.new('RGBA', (w, h), (0, 0, 0, 0))
plate_draw = ImageDraw.Draw(plate)

# The plate color is a very rich dark radial charcoal (#1b1e22 center, #111316 edges)
for r in range(160, 0, -1):
    val = int(22 + (160 - r) * 0.08)
    color = (val, val + 2, val + 4, 255)
    plate_draw.ellipse([209 - r, 214 - r, 209 + r, 214 + r], fill=color)

# Composite clean plate inside the inner area only
clean_medallion = medallion.copy()
clean_medallion.paste(plate, (0, 0), inner_mask)

# Now load the raw clean potion (3004.png)
raw_potion = Image.open(os.path.join(art_dir, 'stamina_potion_3004_raw.png')).convert('RGBA')

# Target size inside the medallion: scale to fit comfortably and beautifully
potion_target_w = 210
potion_target_h = int(raw_potion.size[1] * (potion_target_w / raw_potion.size[0]))
potion_scaled = raw_potion.resize((potion_target_w, potion_target_h), Image.Resampling.LANCZOS)

# Position centered in medallion:
px = (w - potion_target_w) // 2
py = (h - potion_target_h) // 2 - 2  # slightly optical center

# Paste new potion onto the clean medallion
clean_medallion.paste(potion_scaled, (px, py), potion_scaled)

# Save to all target paths
targets = [
    'dashboard/public/images/daily/dayaniklilik_1.png',
    'dashboard/dist/images/daily/dayaniklilik_1.png',
    os.path.join(art_dir, 'dayaniklilik_1.png')
]

for t in targets:
    os.makedirs(os.path.dirname(t), exist_ok=True)
    clean_medallion.save(t)
    print(f"Saved refined: {t}")
