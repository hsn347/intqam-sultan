with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_read\equipmentltCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "getEquipmentSuitID" in l:
        for j in range(max(0, i-5), min(len(lines), i+25)):
            print(f"{j+1}: {lines[j]}", end="")
        break
