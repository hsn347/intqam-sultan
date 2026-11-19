import os
from PIL import Image, ImageEnhance

# 1. Prepare icon_building_levelup.png
levelup_src = 'scratch/dev_icons/icon_building_levelup.png'
im_lu = Image.open(levelup_src)
bbox_lu = im_lu.getbbox()
cropped_lu = im_lu.crop(bbox_lu)

# Centered on a clean square canvas
w, h = cropped_lu.size
max_dim = max(w, h)
sq_lu = Image.new('RGBA', (max_dim, max_dim), (0, 0, 0, 0))
offset = ((max_dim - w) // 2, (max_dim - h) // 2)
sq_lu.paste(cropped_lu, offset, cropped_lu)

# Also slightly enhance contrast and color vibrance for miniature tab rendering
enhancer = ImageEnhance.Color(sq_lu)
sq_lu_enhanced = enhancer.enhance(1.15)
enhancer_con = ImageEnhance.Contrast(sq_lu_enhanced)
sq_lu_final = enhancer_con.enhance(1.1)

# Destination paths
dash_public = 'dashboard/public/images/development'
dash_dist = 'dashboard/dist/images/development'
artifact_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\dev_icons'

for d in [dash_public, dash_dist, artifact_dir]:
    os.makedirs(d, exist_ok=True)

sq_lu_final.save(os.path.join(dash_public, 'icon_building_levelup.png'), optimize=True)
sq_lu_final.save(os.path.join(dash_dist, 'icon_building_levelup.png'), optimize=True)
sq_lu_final.save(os.path.join(artifact_dir, 'icon_building_levelup.png'), optimize=True)
print("Saved icon_building_levelup.png")

# 2. Also prepare pandect hammer as an alternative
hammer_src = 'scratch/dev_icons/btn_main_pandect_01.png'
im_h = Image.open(hammer_src)
bbox_h = im_h.getbbox()
cropped_h = im_h.crop(bbox_h)
w_h, h_h = cropped_h.size
max_dim_h = max(w_h, h_h)
sq_h = Image.new('RGBA', (max_dim_h, max_dim_h), (0, 0, 0, 0))
offset_h = ((max_dim_h - w_h) // 2, (max_dim_h - h_h) // 2)
sq_h.paste(cropped_h, offset_h, cropped_h)

sq_h.save(os.path.join(dash_public, 'icon_construction_hammer.png'), optimize=True)
sq_h.save(os.path.join(dash_dist, 'icon_construction_hammer.png'), optimize=True)
sq_h.save(os.path.join(artifact_dir, 'icon_construction_hammer.png'), optimize=True)
print("Saved icon_construction_hammer.png")
