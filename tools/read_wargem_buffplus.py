with open(r"E:\intqam-sultan\game_file\src\app\module\warGem\warGemCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines):
    if "function warGemCtrl:getBuffPlus" in line or "getBuffPlus" in line:
        for i in range(max(0, idx-2), min(len(lines), idx+30)):
            print(f"{i+1}: {lines[i]}")
        break
