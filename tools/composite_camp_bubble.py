import os
from PIL import Image

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'

frame = Image.open(f'{art_dir}/frame_main_receive.png').convert('RGBA')
icon = Image.open(f'{art_dir}/icon_bzjs.png').convert('RGBA')

# In game: icon is placed at center of circular area
# Frame is (74, 81). The circular area is roughly (0, 0) to (74, 74), with pointer at bottom (y ~ 70 to 81)
fw, fh = frame.size
comp = frame.copy()

# Resize icon slightly to fit comfortably inside inner circle
# Inner circle diameter is around 60 px
iw, ih = int(fw * 0.76), int(fw * 0.76)
icon_resized = icon.resize((iw, ih), Image.Resampling.LANCZOS)

# Center in the upper circle (circle center is at x = fw // 2, y ~ 35)
pos_x = (fw - iw) // 2
pos_y = int(fh * 0.44) - (ih // 2)

comp.paste(icon_resized, (pos_x, pos_y), icon_resized)

# Save composite
comp.save(f'{art_dir}/troop_promote_bubble.png')
comp.save(f'{art_dir}/camp_banner_icon_btn.png')

# Also deploy to dashboard/public/images/soldiers/
os.makedirs('dashboard/public/images/soldiers', exist_ok=True)
icon.save('dashboard/public/images/soldiers/icon_bzjs.png')
icon.save('dashboard/public/images/soldiers/troop_promote.png')
comp.save('dashboard/public/images/soldiers/troop_promote_bubble.png')
comp.save('dashboard/public/images/soldiers/camp_banner_bubble.png')

print(f"Bubble composite generated: {comp.size}")
