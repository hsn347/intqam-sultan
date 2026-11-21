import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def scan_as_star():
    as_star = os.path.join(CONFIG_DIR, "alliance_science_lv_star.lua")
    with open(as_star, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    entries = re.findall(r';\(nil\)\.id\s*=\s*(\d+).*?;\(nil\)\.technologyPower\s*=\s*"([^"]+)"', content, re.DOTALL)
    print(f"Total entries parsed in star: {len(entries)}")
    for sid, pwr in entries:
        prop_type = pwr[:2]
        if prop_type in ['43', '96', '05', '5']:
            print(f"Star Science {sid}: {pwr}")

if __name__ == "__main__":
    scan_as_star()
