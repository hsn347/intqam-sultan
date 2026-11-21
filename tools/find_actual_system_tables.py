import os
import re

GAME_DIR = r"e:\intqam-sultan\game_file"

def inspect_ctrl_file(rel_path):
    full = os.path.join(GAME_DIR, rel_path.replace("/", os.sep))
    if not os.path.exists(full):
        print(f"File not found: {rel_path}")
        return
    with open(full, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()
    
    print(f"\n{'='*60}\nFILE: {rel_path}\n{'='*60}")
    # find require_data, require_once, include, config_server
    requires = re.findall(r'(require_data|require_once|include|config_server|config_client|config_read)\s*\([\'"]([^\'"]+)[\'"]\)', text)
    print("Requires/Includes:")
    for r, mod in set(requires):
        print(f"  {r}: {mod}")
        
    # check for buff or effect mentions
    buff_mentions = re.findall(r'.{0,50}(?:getBuff|BuffEffect|buffType|effectType).{0,50}', text)
    print(f"Buff mentions ({len(buff_mentions)}):")
    for bm in buff_mentions[:10]:
        print(f"  {bm.strip()}")

if __name__ == "__main__":
    inspect_ctrl_file("src/app/module/pet/petCtrl.lua")
    inspect_ctrl_file("src/app/localtb/config_read/petltCtrl.lua")
    inspect_ctrl_file("src/app/module/warGem/warGemCtrl.lua")
    inspect_ctrl_file("src/app/module/nebulaWar/nebulaActivityCtrl.lua")
    inspect_ctrl_file("src/app/module/kingdomLevel/kingdomLevelDataModuleAPI.lua")
    inspect_ctrl_file("src/app/module/intetior/intetiorCtrl.lua")
    inspect_ctrl_file("src/app/module/hero/heroCenotaphCtrl.lua")
    inspect_ctrl_file("src/app/module/exoticPavilion/exoticPavilionCtrl.lua")
    inspect_ctrl_file("src/app/module/equipment/miraculousWeaponCtrl.lua")
    inspect_ctrl_file("src/app/module/legendLordWarCtrl/legendMCtrl.lua")
