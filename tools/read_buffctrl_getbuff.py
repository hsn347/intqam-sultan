with open(r"E:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# search for function buffCtrl:getBuffEffect
lines = text.splitlines()
start = False
for idx, line in enumerate(lines):
    if "function buffCtrl:getBuffEffect" in line:
        start = True
        print(f"Line {idx+1}:")
    if start:
        print(line)
        if line.startswith("end") or (idx > 10 and line.startswith("function ")):
            if line.startswith("end"):
                break
