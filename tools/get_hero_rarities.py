import re

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

heroes = ['1700', '1701', '1702', '1703', '1704', '1705', '1706', '1707', '1708', '1709', '1710', '1711', '1712', '1713', '1714', '1717', '1718']

for hid in heroes:
    pos = text.find(f'\n{hid}\n')
    if pos == -1:
        pos = text.find(hid)
    sub = text[pos:pos+300]
    m_r = re.search(r'rarity\s*=\s*(?:nil,\s*)?([0-9]+)', sub)
    r = m_r.group(1) if m_r else 'N/A'
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', sub)
    n = m_name.group(1) if m_name else 'N/A'
    print(f"Hero {hid}: rarity = {r}, herName = {n}")
