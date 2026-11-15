import os
import shutil
from PIL import Image

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'
frame_path = os.path.join(art_dir, 'frame_common_round.png')
if not os.path.exists(frame_path):
    frame_path = 'tools/frame_common_round.png'

frame_img = Image.open(frame_path).convert('RGBA')
print(f"Frame round size: {frame_img.size}")

icons = [
    ('icon_building_up_food.png', 'boost_food'),
    ('icon_building_up_wood.png', 'boost_wood'),
    ('icon_building_up_iron_cw.png', 'boost_iron'),
    ('icon_building_up_silver.png', 'boost_silver'),
    ('icon_building_up_crystal_cw.png', 'boost_crystal'),
]

os.makedirs('dashboard/public/images/boosts', exist_ok=True)
os.makedirs('dashboard/public/images/development', exist_ok=True)

for src_name, alias in icons:
    src_file = os.path.join(art_dir, src_name)
    icon_img = Image.open(src_file).convert('RGBA')
    
    # 1. Clean transparent icon
    # Normalize size or save original
    icon_img.save(f"dashboard/public/images/boosts/{alias}.png")
    icon_img.save(f"dashboard/public/images/boosts/{src_name.replace('_cw', '')}")
    icon_img.save(f"{art_dir}/{alias}_clean.png")
    
    # 2. Composite with frame_common_round
    # Frame is e.g. 100x100 or 108x108.
    comp = frame_img.copy()
    fw, fh = comp.size
    
    # Scale icon to fit nicely centered in frame (~70% of frame)
    target_w = int(fw * 0.72)
    aspect = icon_img.height / icon_img.width
    target_h = int(target_w * aspect)
    icon_resized = icon_img.resize((target_w, target_h), Image.Resampling.LANCZOS)
    
    # Center
    pos_x = (fw - target_w) // 2
    pos_y = (fh - target_h) // 2 - 2 # slight optical upward shift
    comp.paste(icon_resized, (pos_x, pos_y), icon_resized)
    
    comp.save(f"dashboard/public/images/boosts/{alias}_btn.png")
    comp.save(f"{art_dir}/{alias}_btn.png")
    print(f"Saved {alias} clean & btn composites")

print("All boost icon variants generated successfully!")
