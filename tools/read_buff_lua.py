import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def search_buff_lua():
    p = os.path.join(CONFIG_DIR, "buff.lua")
    with open(p, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
    for idx, line in enumerate(lines):
        if re.search(r'effectType\s*=\s*96\b', line):
            print(f"Line {idx+1}: {line.strip()}")
            for j in range(max(0, idx-10), min(len(lines), idx+15)):
                print(f"  {lines[j].strip()}")
            print("="*40)

if __name__ == "__main__":
    search_buff_lua()
