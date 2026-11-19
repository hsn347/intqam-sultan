with open(r"e:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(115, min(len(lines), 200)):
    print(f"{i+1}: {lines[i]}", end="")
