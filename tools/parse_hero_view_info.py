import re

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8') as f:
    text = f.read()

heroes = {}
cur_id = None
cur_rarity = None
cur_type = None

for line in text.split('\n'):
    m_id = re.search(r'heroID\s*=\s*(\d+)', line)
    if m_id:
        cur_id = int(m_id.group(1))
    m_rar = re.search(r'rarity\s*=\s*(?:nil,\s*)?(\d+)', line)
    if m_rar:
        cur_rarity = int(m_rar.group(1))
    m_type = re.search(r'heroType[^=]*=\s*(?:nil,\s*)?(\d+)', line)
    if m_type:
        cur_type = int(m_type.group(1))
    m_end = re.search(r'\(nil\)\[(\d+)\]', line)
    if m_end and cur_id:
        heroes[cur_id] = {'rarity': cur_rarity, 'heroType': cur_type}
        cur_id = None
        cur_rarity = None
        cur_type = None

print(f"Total heroes parsed: {len(heroes)}")
for hid, info in sorted(heroes.items()):
    print(f"Hero {hid}: rarity={info['rarity']}, heroType={info['heroType']}")
