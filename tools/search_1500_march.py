import os
import re

APP_DIR = r"E:\intqam-sultan\game_file\src\app"

def search_1500_march():
    print("Searching for 1500 march/dispatch...")
    for root, dirs, files in os.walk(APP_DIR):
        for f in files:
            if f.endswith(".lua"):
                p = os.path.join(root, f)
                try:
                    with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                        content = fp.read()
                    if "1500" in content:
                        # check if line or nearby lines have 96 or 5 or capacity or march or dispatch
                        lines = content.splitlines()
                        for idx, line in enumerate(lines):
                            if "1500" in line:
                                context = " ".join([lines[j] for j in range(max(0, idx-3), min(len(lines), idx+4))])
                                if any(k in context for k in ["96", "attrType", "attrID", "DISPATCH", "MARCH", "capacity", "expArmy"]):
                                    print(f"[{f}:{idx+1}] {line.strip()}")
                                    for j in range(max(0, idx-2), min(len(lines), idx+3)):
                                        print(f"    {lines[j].strip()}")
                                    print("-" * 40)
                except:
                    pass

if __name__ == "__main__":
    search_1500_march()
