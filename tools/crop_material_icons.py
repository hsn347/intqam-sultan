from PIL import Image
import os

img_path = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\.user_uploaded\media_1794847231484_01d4c27e.jpg'
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

img = Image.open(img_path).convert('RGB')
w, h = img.size
print(f"User image size: {w}x{h}")

# The arc spans y ~ 270 to 580, x ~ 20 to 560
# Let's crop individual rough boxes around each circle:
# 1. Horn (top left): x: 25 to 145, y: 280 to 420
# 2. Hide (mid-left): x: 110 to 220, y: 390 to 520
# 3. Red gem (center-left): x: 280 to 390, y: 460 to 580
# 4. Ore (center-right): x: 380 to 490, y: 460 to 580
# 5. Purple herb (mid-right): x: 500 to 620, y: 400 to 520
# 6. Green sprout (top right): x: 560 to 680, y: 290 to 420
# Wait, let's normalize by w, h:

crops = {
    'crop_horn': (0.04, 0.28, 0.25, 0.42),
    'crop_hide': (0.12, 0.39, 0.32, 0.53),
    'crop_red_gem': (0.28, 0.46, 0.48, 0.60),
    'crop_ore': (0.49, 0.46, 0.70, 0.60),
    'crop_purple_wood': (0.68, 0.39, 0.88, 0.53),
    'crop_sprout': (0.75, 0.28, 0.95, 0.42),
}

for name, (rx1, ry1, rx2, ry2) in crops.items():
    box = (int(w * rx1), int(h * ry1), int(w * rx2), int(h * ry2))
    c = img.crop(box)
    c.save(os.path.join(art_dir, f'user_{name}.png'))
    print(f"Saved {name}: {c.size}")

# Also crop the whole arc
arc_box = (int(w * 0.03), int(h * 0.27), int(w * 0.97), int(h * 0.61))
img.crop(arc_box).save(os.path.join(art_dir, 'user_materials_arc.png'))
print("Saved user_materials_arc.png")
