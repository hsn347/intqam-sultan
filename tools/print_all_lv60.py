import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

lines = text.split('\n')
cur_id = None
cur_rarity = None
cur_level = None
cur_march = None

r_60 = {}

for line in lines:
    m_id = re.search(r'ID\s*=\s*(\d+)', line)
    if m_id:
        cur_id = m_id.group(1)
    m_rar = re.search(r'rarity\s*=\s*(\d+)', line)
    if m_rar:
        cur_rarity = int(m_rar.group(1))
    m_lvl = re.search(r'level\s*=\s*(\d+)', line)
    if m_lvl:
        cur_level = int(m_lvl.group(1))
    m_mar = re.search(r'march_add\s*=\s*(\d+)', line)
    if m_mar:
        cur_march = int(m_mar.group(1))
    if 'power' in line and cur_rarity is not None and cur_level == 60:
        r_60[cur_rarity] = cur_march

for r, m in sorted(r_60.items()):
    print(f"Rarity {r} Lv 60: march_add = {m}")
