import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def search_capacity_values():
    print("Searching config_server for march capacity buffs...")
    
    # We want to check all files in config_server where buffType 96 or attr 5 or capacity is referenced
    for f in sorted(os.listdir(CONFIG_DIR)):
        if not f.endswith(".lua"):
            continue
        p = os.path.join(CONFIG_DIR, f)
        try:
            with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
            
            # Check for numbers 21500, 20000, 1500
            for val in [21500, 20000, 1500]:
                if str(val) in content:
                    # check if it's near buff, attr, capacity, or army
                    lines = content.splitlines()
                    for idx, line in enumerate(lines):
                        if str(val) in line and any(k in line for k in ["buff", "attr", "capacity", "army", "powerNum", "effect"]):
                            print(f"[{f}:{idx+1}] {line.strip()}")
        except:
            pass

if __name__ == "__main__":
    search_capacity_values()
