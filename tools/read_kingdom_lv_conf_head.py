with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\kingdom_lv_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
print(f"Total lines in kingdom_lv_config.lua: {len(lines)}")
for idx in range(min(120, len(lines))):
    print(lines[idx])
