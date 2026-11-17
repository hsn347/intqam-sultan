import os
from PIL import Image

orig = Image.open('tools/orig_dayaniklilik_1.png').convert('RGBA')
w, h = orig.size
pix = orig.load()

# Let's inspect each pixel. If it's inside the inner diamond area and belongs to the old bottle,
# replace it with the dark charcoal color (25, 26, 28, 255).
# The inner diamond area is bounded roughly by x in [100, 320], y in [85, 340].
# Within this box, the gold border is clearly distinguished by its coordinates and colors.

# Let's clean the bottle pixels across all regions of the old bottle:
for y in range(80, 345):
    for x in range(100, 325):
        r, g, b, a = pix[x, y]
        if a < 50:
            continue
        
        # Check if pixel is part of the old bottle:
        is_green = (g > 45 and g > r * 0.95 and g > b)
        is_gold = (r > 70 and g > 50 and b < r * 0.75)
        is_yellow = (r > 150 and g > 130 and b < 80)
        is_purple_glow = (r > 80 and b > 80 and g < r * 0.7)
        is_glass_white = (r > 70 and g > 70 and b > 70 and abs(r-g) < 20 and abs(r-b) < 20)
        is_brown_cork = (r > 50 and g > 35 and b < 40 and r > b * 1.4)
        
        # Distance from center
        dist_from_center = ((x - 208)**2 + (y - 210)**2)**0.5
        
        # In the specific bottle regions:
        in_cone_tip = (260 <= x <= 315 and 90 <= y <= 135)
        in_base = (130 <= x <= 195 and 265 <= y <= 325)
        in_plus = (220 <= x <= 300 and 210 <= y <= 290)
        
        if dist_from_center < 135 or in_cone_tip or in_base or in_plus:
            # Don't touch the golden outer border
            # The inner diamond boundary:
            # At y=100, inner diamond starts around x=135, ends around x=280. But cone tip is at (295, 115)
            # Let's check if pixel is part of the bottle:
            if is_green or is_gold or is_yellow or is_purple_glow or is_glass_white or is_brown_cork or (r+g+b > 90):
                # Only if not the ornate border (border has r~150, g~140, b~115)
                # But inside the diamond, any bright color is bottle!
                # The gold border at (300, 115) is at distance > 135 from center
                if dist_from_center < 145:
                    # Let's ensure we don't erase the frame border:
                    # Frame border has alpha gradient and specific coordinates
                    pix[x, y] = (25, 26, 28, 255)

# Save the cleaned blank medallion
orig.save('tools/blank_medallion.png')

# Now paste the new 3004.png stamina potion cleanly centered
potion = Image.open('tools/stamina_potion_clean.png').convert('RGBA')

# Target size inside medallion: 215x215
target_size = 215
potion_scaled = potion.resize((target_size, target_size), Image.Resampling.LANCZOS)

# Position centered in medallion
px = 208 - target_size // 2
py = 210 - target_size // 2

clean_badge = orig.copy()
clean_badge.paste(potion_scaled, (px, py), potion_scaled)

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

clean_badge.save('tools/test_clean_badge.png')
clean_badge.save(os.path.join(art_dir, 'dayaniklilik_1.png'))
clean_badge.save('dashboard/public/images/daily/dayaniklilik_1.png')
clean_badge.save('dashboard/dist/images/daily/dayaniklilik_1.png')

print("Clean medallion created and saved!")
