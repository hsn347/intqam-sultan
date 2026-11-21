import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def search_attrid_3():
    for f in sorted(os.listdir(CONFIG_DIR)):
        if not f.endswith(".lua"):
            continue
        p = os.path.join(CONFIG_DIR, f)
        try:
            with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
            if "attrID" in content and ("= 3" in content or "attrID = 3" in content or "attrID.*3" in content):
                matches = re.findall(r'attrID\s*=\s*3\b', content)
                if matches:
                    print(f"File {f} has attrID = 3 ({len(matches)} matches)")
        except:
            pass

if __name__ == "__main__":
    search_attrid_3()
