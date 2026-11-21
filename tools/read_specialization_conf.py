with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\specialization_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
print(f"Total lines in specialization_conf.lua: {len(lines)}")
for idx in range(min(50, len(lines))):
    print(lines[idx])
