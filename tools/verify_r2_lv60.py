import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's find exactly the block for rarity=2, level=60
lines = text.split('\n')
cur_id = None
cur_rarity = None
cur_level = None
cur_march = None
cur_exp = None

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
    m_exp = re.search(r'exp\s*=\s*(\d+)', line)
    if m_exp:
        cur_exp = int(m_exp.group(1))
        
    if cur_rarity == 2 and cur_level == 60 and cur_march is not None:
        print(f"Rarity 2, Level 60 (ID {cur_id}): march_add = {cur_march}, exp = {cur_exp}")
        break
