import os
import shutil
from PIL import Image

artifact_dir = r"C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3"
dest_dir = "dashboard/public/images/daily"

raw = Image.open('scratch/icon_build_pet_raw.png')
print("Raw pet icon size:", raw.size)

# Create 110x110 canvas (original TexturePacker size)
canvas_110 = Image.new('RGBA', (110, 110), (0, 0, 0, 0))
offset_x = (110 - raw.width) // 2
offset_y = (110 - raw.height) // 2
canvas_110.paste(raw, (offset_x, offset_y), raw)
canvas_110.save('scratch/icon_build_pet_110.png')

# Create 128x128 canvas as well
canvas_128 = Image.new('RGBA', (128, 128), (0, 0, 0, 0))
canvas_128.paste(raw, ((128 - raw.width) // 2, (128 - raw.height) // 2), raw)
canvas_128.save('scratch/icon_build_pet_128.png')

# Copy to artifact dir
shutil.copy('scratch/icon_build_pet_raw.png', os.path.join(artifact_dir, 'icon_build_pet_raw.png'))
shutil.copy('scratch/icon_build_pet_110.png', os.path.join(artifact_dir, 'icon_build_pet_110.png'))
shutil.copy('scratch/icon_build_pet_128.png', os.path.join(artifact_dir, 'icon_build_pet_128.png'))

# Deploy to dashboard
shutil.copy('scratch/icon_build_pet_110.png', os.path.join(dest_dir, 'pet.png'))
shutil.copy('scratch/icon_build_pet_110.png', os.path.join(dest_dir, 'icon_build_pet.png'))
shutil.copy('scratch/icon_build_pet_raw.png', os.path.join(dest_dir, 'icon_build_pet_raw.png'))

print("Deployed pet icons successfully.")
