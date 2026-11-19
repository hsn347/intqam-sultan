with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_read\equipmentltCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "suit_list" in l:
        print(f"Line {i+1}: {l.strip()}")
