from PIL import Image
import numpy as np
import os

images = [
    ('media_1794777746014_6b1a995f.jpg', 'farm_boost'),
    ('media_1794777746026_5d2c1ff4.jpg', 'wood_boost'),
    ('media_1794777746030_216a8114.jpg', 'iron_boost'),
    ('media_1794777746032_ad6dbe9f.jpg', 'silver_boost'),
]

base_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

for filename, tag in images:
    path = os.path.join(base_dir, '.user_uploaded', filename)
    img = Image.open(path).convert('RGB')
    arr = np.array(img)
    # Filter red pixels strictly in the center region (x: 200 to 500, y: 400 to 800)
    sub = arr[400:850, 200:500]
    red_mask = (sub[:, :, 0] > 200) & (sub[:, :, 1] < 40) & (sub[:, :, 2] < 40)
    ys, xs = np.where(red_mask)
    if len(xs) > 0:
        min_x, max_x = xs.min() + 200, xs.max() + 200
        min_y, max_y = ys.min() + 400, ys.max() + 400
        print(f"{tag}: Red circle bbox: x=[{min_x}, {max_x}], y=[{min_y}, {max_y}]")
        pad = 5
        crop_box = (max(0, min_x - pad), max(0, min_y - pad), min(img.width, max_x + pad), min(img.height, max_y + pad))
        cropped = img.crop(crop_box)
        cropped.save(os.path.join(base_dir, f'user_crop_{tag}.png'))
    else:
        print(f"{tag}: No center red pixels found!")
