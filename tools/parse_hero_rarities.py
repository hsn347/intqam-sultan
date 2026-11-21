import re

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', errors='ignore') as f:
    text = f.read()

# Pattern: heroID = (\d+).*?rarity = nil, (\d+) or rarity = (\d+)
rarities = {}
chunks = text.split('heroID =')
for c in chunks[1:]:
    m_id = re.search(r'^\s*(\d+)', c)
    if not m_id:
        continue
    hid = int(m_id.group(1))
    m_rar = re.search(r'rarity\s*=\s*(?:nil,\s*)?(\d+)', c)
    if m_rar:
        rarities[hid] = int(m_rar.group(1))

print(f"Parsed {len(rarities)} hero rarities:")
for hid in sorted(rarities.keys()):
    if 1700 <= hid <= 1730:
        print(f"Hero {hid}: native rarity = {rarities[hid]}")
