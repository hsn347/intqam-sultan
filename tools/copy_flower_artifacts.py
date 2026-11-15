import shutil
import os
from PIL import Image

artifact_dir = r"C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3"

crop = Image.open('scratch/flower_crop_raw.png')
print("Raw crop size:", crop.size)

# Create 132x132 canvas (the original frame size in TexturePacker)
canvas = Image.new('RGBA', (132, 132), (0, 0, 0, 0))
offset_x = (132 - crop.width) // 2
offset_y = (132 - crop.height) // 2
canvas.paste(crop, (offset_x, offset_y), crop)
canvas.save('scratch/flower_full_132.png')

# Also standard dashboard icon size (e.g. 128x128 or preserving aspect ratio)
# Let's save a clean centered version
shutil.copy('scratch/flower_crop_raw.png', os.path.join(artifact_dir, 'flower_crop_raw.png'))
shutil.copy('scratch/flower_rot_0.png', os.path.join(artifact_dir, 'flower_rot_0.png'))
shutil.copy('scratch/flower_rot_90_cw.png', os.path.join(artifact_dir, 'flower_rot_90_cw.png'))
shutil.copy('scratch/flower_rot_90_ccw.png', os.path.join(artifact_dir, 'flower_rot_90_ccw.png'))
shutil.copy('scratch/flower_rot_180.png', os.path.join(artifact_dir, 'flower_rot_180.png'))
shutil.copy('scratch/flower_full_132.png', os.path.join(artifact_dir, 'flower_full_132.png'))

print("Copied all images to artifact dir:", artifact_dir)
