import re

def check_klv_47_plus():
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\kingdom_lv_config.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    lines = text.splitlines()
    for idx, line in enumerate(lines):
        if "kingdomLv = 47" in line or "kingdomLv = 48" in line or "kingdomLv = 100" in line:
            print(f"Line {idx+1}:")
            for j in range(max(0, idx-2), min(len(lines), idx+30)):
                print(f"  {lines[j].strip()}")
            print("="*40)

if __name__ == "__main__":
    check_klv_47_plus()
