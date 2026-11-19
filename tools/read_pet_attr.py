with open(r"e:\intqam-sultan\game_file\src\app\module\pet\petCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "getPetAttributeAdd" in l:
        for j in range(max(0, i-5), min(len(lines), i+40)):
            print(f"{j+1}: {lines[j]}", end="")
        break
