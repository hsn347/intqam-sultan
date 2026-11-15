from PIL import Image
import numpy as np
import os

img_path = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3\.user_uploaded\media_1794780699122_4bd59b12.jpg'
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

img = Image.open(img_path).convert('RGB')
arr = np.array(img)

# Filter red circle in center region (x: 200 to 400, y: 400 to 650)
sub = arr[400:650, 200:400]
red_mask = (sub[:, :, 0] > 180) & (sub[:, :, 1] < 50) & (sub[:, :, 2] < 50)
ys, xs = np.where(red_mask)
if len(xs) > 0:
    min_x, max_x = xs.min() + 200, xs.max() + 200
    min_y, max_y = ys.min() + 400, ys.max() + 400
    print(f"Red circle bbox: x=[{min_x}, {max_x}], y=[{min_y}, {max_y}]")
    pad = 5
    crop_box = (max(0, min_x - pad), max(0, min_y - pad), min(img.width, max_x + pad), min(img.height, max_y + pad))
    cropped = img.crop(crop_box)
    cropped.save(os.path.join(art_dir, 'user_crop_train_finish.png'))
    
    # 4x zoom for ultra detail
    w, h = cropped.size
    zoomed = cropped.resize((w * 4, h * 4), Image.Resampling.NEAREST)
    zoomed.save(os.path.join(art_dir, 'user_crop_train_finish_zoomed.png'))
    print("Saved crop and zoom successfully!")
else:
    print("No red pixels found in specified range!")
