import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

done_ids = [
    5301011, 5302009, 5303018, 5304004, 5305017, 5306002, 5307006, 5308007,
    5309004, 5310006, 5311001, 5312002, 5313006, 5314003, 5315003, 5316002,
    5317003, 5318005, 5319001, 5320005, 5321004, 5322002, 5323006, 5324005
]

print("Checking achievementID in config...")
for did in done_ids:
    idx = content.find(f"achievementID = {did}")
    if idx != -1:
        snippet = content[idx:idx+400]
        # find medalBuff lines
        print(f"Achievement {did}:")
        for line in snippet.splitlines()[:10]:
            if "medalBuff" in line or "medalID" in line or "achievementCondition" in line:
                print("  ", line.strip())
