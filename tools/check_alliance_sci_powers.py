import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\alliance_science_lv.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

powers = re.findall(r'technologyPower\s*=\s*"(\d+)"', content)
print(f"Total powers: {len(powers)}")
for p in set(powers):
    attr = int(p[:2])
    val = int(p[4:])
    if attr in (18, 19, 43, 96, 5) or val == 4500:
        print(f"Power string: {p} -> attr={attr}, val={val}")
