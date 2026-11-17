import os
from PIL import Image
import numpy as np

src_path = 'scratch/zhucheng.png'
im = Image.open(src_path)

# Let's inspect alpha threshold bbox
alpha = np.array(im.split()[-1])
mask = alpha > 10
rows = np.any(mask, axis=1)
cols = np.any(mask, axis=0)
rmin, rmax = np.where(rows)[0][[0, -1]]
cmin, cmax = np.where(cols)[0][[0, -1]]

print(f"Tight bbox: left={cmin}, top={rmin}, right={cmax+1}, bottom={rmax+1}")
print(f"Tight dimensions: {cmax - cmin + 1} x {rmax - rmin + 1}")

tight_im = im.crop((cmin, rmin, cmax + 1, rmax + 1))

# Destination dirs
dashboard_castles_dir = 'dashboard/public/images/castles'
artifact_castles_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\castles'
os.makedirs(dashboard_castles_dir, exist_ok=True)
os.makedirs(artifact_castles_dir, exist_ok=True)

# Save tight version
tight_path_dash = os.path.join(dashboard_castles_dir, 'main_castle.png')
tight_path_art = os.path.join(artifact_castles_dir, 'main_castle.png')
tight_im.save(tight_path_dash, optimize=True)
tight_im.save(tight_path_art, optimize=True)
print(f"Saved {tight_path_dash} ({tight_im.size})")

# Also create a square icon with subtle margin for clean badge presentation
max_dim = max(tight_im.size)
square_im = Image.new('RGBA', (max_dim, max_dim), (0, 0, 0, 0))
offset_x = (max_dim - tight_im.width) // 2
offset_y = (max_dim - tight_im.height) // 2
square_im.paste(tight_im, (offset_x, offset_y), tight_im)

square_path_dash = os.path.join(dashboard_castles_dir, 'main_castle_square.png')
square_path_art = os.path.join(artifact_castles_dir, 'main_castle_square.png')
square_im.save(square_path_dash, optimize=True)
square_im.save(square_path_art, optimize=True)
print(f"Saved {square_path_dash} ({square_im.size})")
