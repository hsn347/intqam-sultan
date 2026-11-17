import os
from PIL import Image, ImageDraw, ImageOps

orig = Image.open('tools/orig_dayaniklilik_1.png').convert('RGBA')
w, h = orig.size
cx, cy = 208, 210

# In orig_dayaniklilik_1:
# The border is 100% clean along:
# - Top-left quadrant
# - Bottom-left border (only '+' overlaps near bottom-right!)
# Let's inspect the border pixels!
# Let's create a clean frame by mirroring the clean top-left half:
# Top-left is [0:cx, 0:cy]

# Let's make a copy of top-left quadrant
tl = orig.crop((0, 0, cx, cy))

# Mirror horizontally to make top-right
tr = ImageOps.mirror(tl)

# Mirror vertically to make bottom-left
bl = ImageOps.flip(tl)

# Mirror both to make bottom-right
br = ImageOps.flip(tr)

# Assemble perfectly symmetrical 4-fold ornate frame
clean_frame = Image.new('RGBA', (w, h), (0, 0, 0, 0))
clean_frame.paste(tl, (0, 0))
clean_frame.paste(tr, (cx, 0))
clean_frame.paste(bl, (0, cy))
clean_frame.paste(br, (cx, cy))

# Now, in this clean frame, the inner diamond background:
# Since top-left had NO bottle near the border, the border is 100% PRISTINE!
# What about inside the diamond? In top-left, the bottle was near center (130-208, 130-210).
# Let's flood-fill or mask the inner diamond cleanly with the original dark slate color (#181a1d)!

# Let's create an inner diamond mask
inner_mask = Image.new('L', (w, h), 0)
draw_mask = ImageDraw.Draw(inner_mask)

# Diamond points inside gold border:
top_pt = (208, 72)
right_pt = (346, 210)
bottom_pt = (208, 348)
left_pt = (70, 210)

poly = [top_pt, (250, 114), right_pt, (250, 306), bottom_pt, (166, 306), left_pt, (166, 114)]
draw_mask.polygon(poly, fill=255)

# Fill inner diamond with clean rich dark texture
slate = Image.new('RGBA', (w, h), (24, 26, 29, 255))
clean_frame.paste(slate, (0, 0), inner_mask)

# Add subtle inner shadow / radial gradient
for r in range(140, 0, -2):
    alpha = int((140 - r) * 0.4)
    # subtle radial highlight in center
    col = (28 + int(alpha*0.15), 30 + int(alpha*0.15), 33 + int(alpha*0.15), 255)
    draw_slate = ImageDraw.Draw(clean_frame)
    # only inside diamond
    # draw circle
    # we can do radial gradient using an image
    pass

radial = Image.new('RGBA', (w, h), (0, 0, 0, 0))
r_draw = ImageDraw.Draw(radial)
for r in range(130, 0, -1):
    val = int(22 + (130 - r) * 0.1)
    r_draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(val, val + 2, val + 4, 255))

clean_frame.paste(radial, (0, 0), inner_mask)

# Now paste the new stamina potion (3004.png)
potion_raw = Image.open('tools/stamina_potion_clean.png').convert('RGBA')

# Scale to fit nicely
target_size = 200
potion_scaled = potion_raw.resize((target_size, target_size), Image.Resampling.LANCZOS)

# Center it in the medallion
px = cx - target_size // 2
py = cy - target_size // 2

clean_frame.paste(potion_scaled, (px, py), potion_scaled)

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

clean_frame.save('tools/test_perfect_dayaniklilik_1.png')
clean_frame.save(os.path.join(art_dir, 'dayaniklilik_1.png'))
clean_frame.save('dashboard/public/images/daily/dayaniklilik_1.png')
clean_frame.save('dashboard/dist/images/daily/dayaniklilik_1.png')

print("Successfully generated perfect dayaniklilik_1.png!")
