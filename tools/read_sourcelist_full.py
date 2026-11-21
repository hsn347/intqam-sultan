with open(r"E:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx in range(0, 60):
    print(f"{idx+1}: {lines[idx]}")
