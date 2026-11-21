with open(r"E:\intqam-sultan\game_file\src\app\game\lordView\lordLevelUpView.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
print(f"Total lines: {len(lines)}")
for idx in range(min(100, len(lines))):
    print(lines[idx])
