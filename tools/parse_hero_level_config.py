import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

cfg = {}
cur_rarity = None
cur_level = None
cur_march = None

for line in text.split('\n'):
    m_rar = re.search(r'rarity\s*=\s*(\d+)', line)
    if m_rar:
        cur_rarity = int(m_rar.group(1))
    m_lvl = re.search(r'level\s*=\s*(\d+)', line)
    if m_lvl:
        cur_level = int(m_lvl.group(1))
    m_mar = re.search(r'march_add\s*=\s*(\d+)', line)
    if m_mar:
        cur_march = int(m_mar.group(1))
    if 'power' in line and cur_rarity is not None and cur_level is not None and cur_march is not None:
        if cur_rarity not in cfg:
            cfg[cur_rarity] = {}
        cfg[cur_rarity][cur_level] = cur_march
        cur_rarity = None
        cur_level = None
        cur_march = None

print("Rarities in hero_level_config:", sorted(cfg.keys()))
for r in sorted(cfg.keys()):
    levels = sorted(cfg[r].keys())
    print(f"Rarity {r}: levels {min(levels)}..{max(levels)}, lv60 march_add={cfg[r].get(60)}")
