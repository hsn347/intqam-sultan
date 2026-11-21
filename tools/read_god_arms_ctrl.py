with open(r"E:\intqam-sultan\game_file\src\app\module\equipment\godArmsCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
print(f"Total lines in godArmsCtrl: {len(lines)}")
for idx in range(min(120, len(lines))):
    print(lines[idx])
