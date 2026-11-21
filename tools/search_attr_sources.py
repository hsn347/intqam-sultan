import os
import re

GAME_SRC = r"E:\intqam-sultan\game_file\src"

def search_attr_sources():
    pattern = re.compile(r'attributeSystem\.(add|initAttr|resetSourceContainer)')
    for root, dirs, files in os.walk(GAME_SRC):
        for f in files:
            if f.endswith(".lua"):
                p = os.path.join(root, f)
                try:
                    with open(p, "r", encoding="utf-8", errors="ignore") as fl:
                        for idx, line in enumerate(fl, 1):
                            if pattern.search(line):
                                print(f"{p}:{idx}: {line.strip()}")
                except:
                    pass

if __name__ == "__main__":
    search_attr_sources()
