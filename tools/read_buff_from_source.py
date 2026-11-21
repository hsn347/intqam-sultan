with open(r"E:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
start = False
for idx, line in enumerate(lines):
    if "function buffCtrl:getBuffEffectFromSource" in line:
        start = True
        print(f"Line {idx+1}:")
    if start:
        print(line)
        if line.startswith("end") and idx > 150: # find the matching end
            # check if indentation is 0
            if line == "end":
                break
