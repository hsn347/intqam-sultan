import os
import re

def search_files():
    base_dir = r"e:\intqam-sultan\game_file"
    print("Searching for 36500 in game_file...")
    matches = []
    for root, dirs, files in os.walk(base_dir):
        for f in files:
            if f.endswith(('.lua', '.json', '.xml', '.txt')):
                filepath = os.path.join(root, f)
                try:
                    with open(filepath, 'r', encoding='utf-8', errors='ignore') as fp:
                        content = fp.read()
                        if '36500' in content:
                            matches.append(filepath)
                            print(f"Found 36500 in: {filepath}")
                except Exception as e:
                    pass
    print(f"Done searching. Total matches: {len(matches)}")

if __name__ == "__main__":
    search_files()
