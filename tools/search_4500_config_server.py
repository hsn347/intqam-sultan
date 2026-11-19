import os
import re

cfg_server_dir = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
matches = {}

for fname in os.listdir(cfg_server_dir):
    if fname.endswith(".lua"):
        fpath = os.path.join(cfg_server_dir, fname)
        try:
            with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
                # Find occurrences of 4500 as an integer or in strings
                found_lines = []
                for line in content.splitlines():
                    if re.search(r'\b4500\b', line):
                        found_lines.append(line.strip()[:100])
                if found_lines:
                    matches[fname] = found_lines
        except Exception:
            pass

print(f"Total config_server files with 4500: {len(matches)}")
for fname, lines in sorted(matches.items()):
    print(f"\n[{fname}] ({len(lines)} lines)")
    for l in lines[:5]:
        print("  ", l)
