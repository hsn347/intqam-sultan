with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_read\heroltCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "heroDressSerCfg" in l:
        print(f"{i+1}: {l.strip()}")
