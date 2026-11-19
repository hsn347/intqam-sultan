import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

ids = re.findall(r'\[(\d+)\]\s*=', content)
print("IDs in equipment_base_property_config:", ids[:30])
