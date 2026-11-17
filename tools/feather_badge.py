import os
from PIL import Image, ImageDraw

orig = Image.open('tools/orig_dayaniklilik_1.png').convert('RGBA')
w, h = orig.size

# Let's inspect the golden inner border:
# The inner border has pixel colors where (r+g+b) > 100 or r > 60 and g > 50 and b < 50
# If we create a binary mask where True = "Not border and inside", we can flood fill!

# Even better: The diamond inside the gold border has smooth edges.
# Let's find the inner contour of the gold border:
# Let's test a simple flood fill on an image where border is preserved:

test_img = orig.copy()
# Let's fill the entire interior with the smooth background color:
# Center is (208, 210)
# Let's draw an ellipse of radius 110 with feathered edge!
mask = Image.new('L', (w, h), 0)
d = ImageDraw.Draw(mask)
d.ellipse([208-115, 210-115, 208+115, 210+115], fill=255)

from PIL import ImageFilter
mask = mask.filter(ImageFilter.GaussianBlur(8))

# Background plate
bg = Image.new('RGBA', (w, h), (24, 26, 29, 255))
test_img.paste(bg, (0, 0), mask)

# Now check the cone tip at (290, 115) and plus at (265, 250)
mask_extra = Image.new('L', (w, h), 0)
d_extra = ImageDraw.Draw(mask_extra)
# Cone tip
d_extra.ellipse([270, 95, 310, 135], fill=255)
# Base
d_extra.ellipse([140, 270, 185, 315], fill=255)
# Plus
d_extra.ellipse([225, 215, 295, 285], fill=255)
mask_extra = mask_extra.filter(ImageFilter.GaussianBlur(5))

test_img.paste(bg, (0, 0), mask_extra)

# Now paste the new stamina potion
potion = Image.open('tools/stamina_potion_clean.png').convert('RGBA')
potion_scaled = potion.resize((210, 210), Image.Resampling.LANCZOS)
px = 208 - 210 // 2
py = 210 - 210 // 2
test_img.paste(potion_scaled, (px, py), potion_scaled)

test_img.save('tools/test_feathered_badge.png')
test_img.save('dashboard/public/images/daily/dayaniklilik_1.png')
test_img.save('dashboard/dist/images/daily/dayaniklilik_1.png')
test_img.save(r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\dayaniklilik_1.png')
print("Saved feathered badge!")
