import os
import shutil

dest_dir = "dashboard/public/images/daily"

shutil.copy('scratch/quest_button_full.png', os.path.join(dest_dir, 'quest_button.png'))
shutil.copy('scratch/quest_button_full.png', os.path.join(dest_dir, 'daily_quest_btn.png'))
shutil.copy('scratch/quest_icon_clean.png', os.path.join(dest_dir, 'quest_scroll.png'))
shutil.copy('scratch/icon_alliance_mineral_check.png', os.path.join(dest_dir, 'icon_alliance_mineral_check.png'))

print("Deployed quest tab icons successfully.")
