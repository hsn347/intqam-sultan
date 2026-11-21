import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def find_non_hero_buff96():
    for f in sorted(os.listdir(CONFIG_DIR)):
        if not f.endswith(".lua") or "hero" in f:
            continue
        path = os.path.join(CONFIG_DIR, f)
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
            if "buffType" in content and ("= 96" in content or "96" in content):
                # check if 96 is assigned as buffType
                matches = re.findall(r'(\w+)\s*=\s*96\b', content)
                if matches:
                    print(f"File: {f} matched {set(matches)}")
            if "attrID" in content or "attrType" in content:
                matches = re.findall(r'(attrID|attrType)\s*=\s*5\b', content)
                if matches:
                    print(f"File: {f} matched attr 5: {set(matches)}")
        except Exception as e:
            pass

if __name__ == "__main__":
    find_non_hero_buff96()
