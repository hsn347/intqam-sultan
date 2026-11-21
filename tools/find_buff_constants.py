import os
import re

GAME_SRC = r"E:\intqam-sultan\game_file\src"

def find_buff_constants():
    for root, dirs, files in os.walk(GAME_SRC):
        for f in files:
            if f.endswith(".lua"):
                filepath = os.path.join(root, f)
                try:
                    with open(filepath, "r", encoding="utf-8", errors="ignore") as file:
                        content = file.read()
                        if "gBuffEffect" in content and ("AT_EXPEDITION" in content or "AT_MARCH" in content):
                            print(f"Found in: {filepath}")
                            for line in content.splitlines():
                                if "AT_EXPEDITION" in line or "AT_MARCH" in line:
                                    print(f"   {line.strip()}")
                except Exception as e:
                    pass

if __name__ == "__main__":
    find_buff_constants()
