import shutil
import os
from PIL import Image

src_full = 'scratch/flower_full_132.png'
src_raw = 'scratch/flower_crop_raw.png'

dest_dir = 'dashboard/public/images/daily'

# Copy full 132x132 square as flower.png and btn_flower_enter.png
shutil.copy(src_full, os.path.join(dest_dir, 'flower.png'))
shutil.copy(src_raw, os.path.join(dest_dir, 'flower_raw.png'))
shutil.copy(src_full, os.path.join(dest_dir, 'btn_flower_enter.png'))

print("Deployed flower icons to dashboard/public/images/daily/")
