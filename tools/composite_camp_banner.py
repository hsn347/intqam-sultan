import os
from PIL import Image

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

# Load eft_jiaochang_byzantine texture
tex = Image.open('tools/eft_jiaochang_byzantine.png').convert('RGBA')

# Bounds from atlas:
# qi: bounds: 2, 2, 98, 178, rotate: 90
# In atlas, qi is rotated 90
# qigan: bounds: 2, 102, 313, 341
# Let's crop qigan
qigan = tex.crop((2, 102, 2 + 313, 102 + 341))
qigan.save(f'{art_dir}/camp_flagpole.png')

# Save to public images
os.makedirs('dashboard/public/images/soldiers', exist_ok=True)
qigan.save('dashboard/public/images/soldiers/camp_flagpole.png')

print(f"Saved camp_flagpole.png ({qigan.size})")
