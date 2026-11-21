import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def inspect_attr_config():
    p = os.path.join(CONFIG_DIR, "attribute_config.lua")
    with open(p, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()
    
    print("=== attribute_config.lua entries for attrID = 5 or attrType = 5 ===")
    lines = text.splitlines()
    for idx, line in enumerate(lines):
        if re.search(r'\b(attrID|attrType)\s*=\s*5\b', line):
            print(f"Line {idx+1}:")
            for j in range(max(0, idx-5), min(len(lines), idx+15)):
                print(f"  {lines[j].strip()}")
            print("-" * 40)

if __name__ == "__main__":
    inspect_attr_config()
