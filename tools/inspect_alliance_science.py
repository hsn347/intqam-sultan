import re
import os
import json

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def inspect_alliance_science():
    as_file = os.path.join(CONFIG_DIR, "alliance_science.lua")
    as_lv_file = os.path.join(CONFIG_DIR, "alliance_science_lv_star.lua")
    
    print("Checking alliance_science files...")
    
    # Read alliance_science.lua to see science definitions
    if os.path.exists(as_file):
        with open(as_file, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            # print matching lines for 31001-31005 and 32001-32011
            for sid in range(31001, 31006):
                m = re.search(rf'\["{sid}"\]\s*=\s*\{{([^}}]+)\}}', content)
                if m:
                    print(f"Science {sid}: {m.group(1)}")
            for sid in range(32001, 32012):
                m = re.search(rf'\["{sid}"\]\s*=\s*\{{([^}}]+)\}}', content)
                if m:
                    print(f"Science {sid}: {m.group(1)}")

    # Read alliance_science_lv_star.lua
    if os.path.exists(as_lv_file):
        with open(as_lv_file, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            # Search for buffType 96, attr 5, or march capacity keywords
            # Let's see what properties exist in alliance_science_lv_star
            lines = content.splitlines()
            print(f"alliance_science_lv_star lines: {len(lines)}")
            matches = [line for line in lines if any(k in line for k in ['"96"', '"5"', 'expArmy', 'armyCount', 'army_count', 'troop'])]
            print(f"Matching lines in alliance_science_lv_star: {len(matches)}")
            for l in matches[:20]:
                print(l)

if __name__ == "__main__":
    inspect_alliance_science()
