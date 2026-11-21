import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern: ID, rarity, level, exp, march_add
# ;(nil).ID = (\d+)\n;(nil).rarity = (\d+)\n;(nil).level = (\d+)\n;(nil).exp = (\d+)\n;(nil).march_add = (\d+)

entries = re.findall(r'rarity\s*=\s*(\d+).*?level\s*=\s*(\d+).*?march_add\s*=\s*(\d+)', text, re.DOTALL)
print(f"Total entries matched: {len(entries)}")

cfg = {}
for r, l, m in entries:
    cfg[(int(r), int(l))] = int(m)

# Let's print march_add for rarity 1..5 at level 60, and level 48
for r in range(1, 6):
    print(f"Rarity {r}, Level 60 -> march_add = {cfg.get((r, 60))}")
    print(f"Rarity {r}, Level 48 -> march_add = {cfg.get((r, 48))}")
    print(f"Rarity {r}, Level 41 -> march_add = {cfg.get((r, 41))}")
    print(f"Rarity {r}, Level 28 -> march_add = {cfg.get((r, 28))}")
