import os
import re

p = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_config.lua"
with open(p, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

done_ids = {
    5309005, 5307005, 5308006, 5305017, 5306006, 5303018, 5304005,
    5315003, 5323006, 5313006, 5311003, 5301011, 5302009, 5320005,
    5322002, 5314003, 5324005, 5321004, 5312002, 5310006, 5318005,
    5317003
}

# split by achievementID =
blocks = re.split(r'achievementID\s*=\s*', text)
print(f"Total blocks: {len(blocks)}")

for b in blocks[1:]:
    m = re.match(r'(\d+)', b)
    if not m:
        continue
    aid = int(m.group(1))
    if aid in done_ids:
        # find medalBuff
        mb_lines = [l.strip() for l in b.splitlines() if "medalBuff" in l]
        print(f"Achievement {aid}: {mb_lines}")
