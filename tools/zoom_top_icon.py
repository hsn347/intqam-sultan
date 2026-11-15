from PIL import Image

art_dir = r'C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3'
src = Image.open(f'{art_dir}/user_crop_camp_top_icon.png')
# Zoom in 4x nearest neighbor
w, h = src.size
zoomed = src.resize((w * 4, h * 4), Image.Resampling.NEAREST)
zoomed.save(f'{art_dir}/user_crop_top_icon_zoomed.png')
print("Zoomed saved!")
