import os
import re

p = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_config.lua"
with open(p, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

done_ids = [
    5309005, 5307005, 5308006, 5305017, 5306006, 5303018, 5304005,
    5315003, 5323006, 5313006, 5311003, 5301011, 5302009, 5320005,
    5322002, 5314003, 5324005, 5321004, 5312002, 5310006, 5318005,
    5317003
]

print("Scanning done achievement IDs in achievement_config.lua...")
lines = text.splitlines()
current_id = None
buff_info = {}

for line in lines:
    m_id = re.search(r'achievementID\s*=\s*(\d+)', line)
    if m_id:
        current_id = int(m_id.group(1))
        continue
    if current_id in done_ids and "buff" in line:
        print(f"ID {current_id}: {line.strip()}")
