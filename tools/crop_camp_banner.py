from PIL import Image
import numpy as np
import os

img_path = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\.user_uploaded\media_1794779238820_f55d8d9c.jpg'
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

img = Image.open(img_path).convert('RGB')
arr = np.array(img)

# Filter red circle in center region
sub = arr[250:650, 200:450]
red_mask = (sub[:, :, 0] > 180) & (sub[:, :, 1] < 50) & (sub[:, :, 2] < 50)
ys, xs = np.where(red_mask)
if len(xs) > 0:
    min_x, max_x = xs.min() + 200, xs.max() + 200
    min_y, max_y = ys.min() + 250, ys.max() + 250
    print(f"Red circle bbox: x=[{min_x}, {max_x}], y=[{min_y}, {max_y}]")
    pad = 5
    crop_box = (max(0, min_x - pad), max(0, min_y - pad), min(img.width, max_x + pad), min(img.height, max_y + pad))
    cropped = img.crop(crop_box)
    cropped.save(os.path.join(art_dir, 'user_crop_camp_banner.png'))
    
    # Also crop specifically the top round icon on the pole
    # top round icon is in upper part of this crop
    icon_box = (min_x, min_y, max_x, min_y + int((max_y - min_y) * 0.35))
    top_icon = img.crop(icon_box)
    top_icon.save(os.path.join(art_dir, 'user_crop_camp_top_icon.png'))
    print("Saved crops successfully!")
else:
    print("No red pixels found in specified range!")
