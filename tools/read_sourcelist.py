with open(r"E:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines[:88], 1):
    if "_sourceList" in line or "getBuffEffectFromSource" in line:
        print(f"{idx}: {line}")

# print lines around _sourceList definition
for idx, line in enumerate(lines):
    if "_sourceList =" in line or "_sourceList=" in line or "local _sourceList" in line:
        for i in range(max(0, idx-5), min(len(lines), idx+40)):
            print(f"{i+1}: {lines[i]}")
        break
