import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\hero_level_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

entries = re.findall(r'rarity\s*=\s*(?:nil,\s*)?(\d+).*?level\s*=\s*(?:nil,\s*)?(\d+).*?march_add\s*=\s*(?:nil,\s*)?(\d+)', content, re.DOTALL)
print(f"Total entries: {len(entries)}")

# Print max level (60) for all rarities
for rar, lv, m_add in entries:
    if int(lv) == 60:
        print(f"Rarity {rar}, Level {lv}: march_add = {m_add}")
