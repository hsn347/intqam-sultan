import os
import glob
import re

print("Searching for building 121 or troop capacity formulas in game_file/src...")

# 1. Search for building 121 in localtb or src/app/localtb
tables_dir = r"E:\intqam-sultan\game_file\src\app\localtb"
if not os.path.exists(tables_dir):
    tables_dir = r"E:\intqam-sultan\game_file\localtb"

def search_text_in_files(folder, patterns, ext=(".lua", ".json", ".cs")):
    results = []
    for root, dirs, files in os.walk(folder):
        for f in files:
            if f.endswith(ext):
                path = os.path.join(root, f)
                try:
                    with open(path, "r", encoding="utf-8", errors="ignore") as fl:
                        content = fl.read()
                        for p in patterns:
                            if re.search(p, content, re.IGNORECASE):
                                results.append((path, p))
                                break
                except Exception as e:
                    pass
    return results

# Let's search in src/app/module/army
print("--- Checking src/app/module/army ---")
army_dir = r"E:\intqam-sultan\game_file\src\app\module\army"
if os.path.exists(army_dir):
    for f in os.listdir(army_dir):
        print("  army file:", f)

# Also let's check dump.cs for building 121 or March / Troop Capacity
print("--- Checking building tables in delta_patch_tables or localtb ---")
for root, dirs, files in os.walk(r"E:\intqam-sultan\game_file"):
    for f in files:
        if "building" in f.lower() or "build" in f.lower():
            print("  found building file:", os.path.join(root, f))
