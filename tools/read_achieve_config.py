with open("game_file/src/app/localtb/config_server/achievement_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re

# find properties in achievement_config.lua
# e.g. property = 14 (which is MARCH_LIMIT_BOOST)
matches = re.findall(r"achievementID\s*=\s*(\d+).*?property\s*=\s*(\d+).*?powerNum\s*=\s*([0-9.]+)", text, re.DOTALL)
print(f"Total matching achievements: {len(matches)}")
for aid, prop, pnum in matches:
    if prop == "14":
        print(f"March Limit Medal achievementID={aid}: property={prop}, powerNum={pnum}")
