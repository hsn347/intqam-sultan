with open(r"e:\intqam-sultan\game_file\src\app\module\city\cityCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "function cityCtrl:getBuffEffect" in l:
        for j in range(i, min(len(lines), i+30)):
            print(f"{j+1}: {lines[j]}", end="")
        break
