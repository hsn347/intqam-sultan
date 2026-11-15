import os
import shutil
from PIL import Image

artifact_dir = r"C:\Users\Computer Home\.gemini\antigravity\brain\e5847600-b50d-43e2-9461-8bca7dfd2dc3"

# Load background and icon
bg = Image.open('scratch/frame_common_round.png').convert('RGBA')
icon = Image.open('scratch/icon_alliance_mineral_check.png').convert('RGBA')

print("BG size:", bg.size)
print("Icon size:", icon.size)

# Composite together (button with icon in center)
composite = bg.copy()
# Center the icon slightly adjusted
offset_x = (bg.width - icon.width) // 2
offset_y = (bg.height - icon.height) // 2
composite.paste(icon, (offset_x, offset_y), icon)
composite.save('scratch/quest_button_full.png')

# Also standalone 80x80 balanced icon
canvas_80 = Image.new('RGBA', (80, 80), (0, 0, 0, 0))
canvas_80.paste(icon, ((80 - icon.width) // 2, (80 - icon.height) // 2), icon)
canvas_80.save('scratch/quest_icon_clean.png')

# Copy to artifact folder
shutil.copy('scratch/quest_button_full.png', os.path.join(artifact_dir, 'quest_button_full.png'))
shutil.copy('scratch/quest_icon_clean.png', os.path.join(artifact_dir, 'quest_icon_clean.png'))
shutil.copy('scratch/icon_alliance_mineral_check.png', os.path.join(artifact_dir, 'icon_quest_scroll.png'))
shutil.copy('scratch/frame_common_round.png', os.path.join(artifact_dir, 'frame_common_round.png'))

print("Composite and clean icons created successfully.")
