with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_read\equipmentltCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines[:100]):
    if "equipmentCfg" in l or "defineValue" in l:
        print(f"{i+1}: {l.strip()}")
