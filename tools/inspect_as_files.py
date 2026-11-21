import re
import os

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def inspect_as():
    # 1. alliance_science_info
    as_info = os.path.join(CONFIG_DIR, "alliance_science_info.lua")
    with open(as_info, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
        print("alliance_science_info sample:")
        print(content[:1000])

    # 2. alliance_science_lv
    as_lv = os.path.join(CONFIG_DIR, "alliance_science_lv.lua")
    with open(as_lv, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
        print("\nalliance_science_lv sample:")
        print(content[:1000])

if __name__ == "__main__":
    inspect_as()
