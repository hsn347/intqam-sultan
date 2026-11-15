import os
import shutil
from PIL import Image

src = 'tools/merchant_cw.png'

# Ensure directories exist
os.makedirs('dashboard/public/images/transport', exist_ok=True)
os.makedirs('dashboard/public/images/daily', exist_ok=True)

# Deploy to dashboard
img = Image.open(src)
img.save('dashboard/public/images/transport/transport.png')
img.save('dashboard/public/images/transport/icon_alliance_merchant.png')
img.save('dashboard/public/images/daily/transport.png')
img.save('dashboard/public/images/daily/icon_alliance_merchant.png')

# Also copy to artifacts directory
art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'
img.save(f'{art_dir}/transport_extracted.png')
img.save(f'{art_dir}/icon_alliance_merchant.png')

print("Deployed merchant icon to frontend and artifacts!")
