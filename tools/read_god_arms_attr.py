with open(r"E:\intqam-sultan\game_file\src\app\module\equipment\godArmsCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx in range(120, min(300, len(lines))):
    print(f"{idx+1}: {lines[idx]}")
