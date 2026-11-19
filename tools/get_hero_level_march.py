import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Parse all rarity and level entries
entries = re.split(r'\n(?=;\(nil\)\.ID\s*=)', text)
rare_level_march = {}

for entry in entries:
    m_r = re.search(r'\.rarity\s*=\s*([0-9]+)', entry)
    m_l = re.search(r'\.level\s*=\s*([0-9]+)', entry)
    m_m = re.search(r'\.march_add\s*=\s*([0-9]+)', entry)
    if m_r and m_l and m_m:
        r = int(m_r.group(1))
        l = int(m_l.group(1))
        m = int(m_m.group(1))
        if r not in rare_level_march:
            rare_level_march[r] = {}
        rare_level_march[r][l] = m

print("March additions for level 60:")
for r in sorted(rare_level_march.keys()):
    print(f"Rarity {r}: Lv.60 -> march_add = {rare_level_march[r].get(60)}")

print("\nMarch additions for level 59:")
for r in sorted(rare_level_march.keys()):
    print(f"Rarity {r}: Lv.59 -> march_add = {rare_level_march[r].get(59)}")

print("\nMarch additions for level 52:")
for r in sorted(rare_level_march.keys()):
    print(f"Rarity {r}: Lv.52 -> march_add = {rare_level_march[r].get(52)}")
