path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
# let's find the blocks
cur_blv = None
for i, line in enumerate(lines):
    if "blv =" in line:
        cur_blv = line.strip()
    if "capacity =" in line:
        print(f"{cur_blv} -> {line.strip()}")
    if i > 250:
        break
