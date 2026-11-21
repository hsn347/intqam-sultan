import os
import re

def find_exact_matches():
    config_dir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
    
    print("Searching for exact buffType == 96 ...")
    for f in os.listdir(config_dir):
        if not f.endswith(".lua"):
            continue
        path = os.path.join(config_dir, f)
        with open(path, "r", encoding="utf-8", errors="ignore") as fp:
            lines = fp.readlines()
        for i, line in enumerate(lines):
            if re.search(r"buffType\s*=\s*96\b", line) or re.search(r"buffType.*?\[.*?\]\s*=\s*.*?96", line):
                print(f"[{f}:{i+1}] {line.strip()}")
                # print surrounding
                for j in range(max(0, i-4), min(len(lines), i+8)):
                    print(f"    {lines[j].strip()}")
                print("="*50)

    print("\nSearching for exact attrID / attrType == 5 ...")
    for f in os.listdir(config_dir):
        if not f.endswith(".lua"):
            continue
        path = os.path.join(config_dir, f)
        with open(path, "r", encoding="utf-8", errors="ignore") as fp:
            lines = fp.readlines()
        for i, line in enumerate(lines):
            if re.search(r"\b(attrID|attrType)\s*=\s*5\b", line):
                print(f"[{f}:{i+1}] {line.strip()}")
                for j in range(max(0, i-4), min(len(lines), i+8)):
                    print(f"    {lines[j].strip()}")
                print("="*50)

if __name__ == "__main__":
    find_exact_matches()
