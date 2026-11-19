with open(r"e:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print("--- lines 1-60 ---")
for i in range(0, min(len(lines), 60)):
    print(f"{i+1}: {lines[i]}", end="")

print("\n--- lines 200-270 ---")
for i in range(200, min(len(lines), 270)):
    print(f"{i+1}: {lines[i]}", end="")
