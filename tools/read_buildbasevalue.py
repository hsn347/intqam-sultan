with open(r"E:\intqam-sultan\game_file\src\app\module\city\buildLogic.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
start = False
for idx, line in enumerate(lines):
    if "function buildLogic.getBuildBaseValue" in line:
        start = True
        print(f"Line {idx+1}:")
    if start:
        print(line)
        if line.startswith("end") and idx > 50:
            if line == "end":
                break
