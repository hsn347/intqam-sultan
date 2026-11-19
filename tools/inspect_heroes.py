import re
import json

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

entries = re.split(r'heroID\s*=\s*', text)[1:]
results = {}
for e in entries:
    m_id = re.match(r'(\d+)', e)
    # in lua: ;(nil).heroType, (nil)[1] = nil, 3
    # or heroType = ...
    m_type = re.search(r'heroType[^\n]*?=\s*(?:nil,\s*)?(\d+)', e)
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', e)
    m_code_name = re.search(r'name\s*=\s*"([^"]+)"', e)
    m_rarity = re.search(r'rarity\s*=\s*(\d+)', e)
    if m_id:
        hid = int(m_id.group(1))
        results[hid] = {
            'heroID': hid,
            'heroType': int(m_type.group(1)) if m_type else None,
            'herName': m_name.group(1) if m_name else '',
            'name': m_code_name.group(1) if m_code_name else '',
            'rarity': int(m_rarity.group(1)) if m_rarity else 1,
        }

print('Parsed total heroes:', len(results))
type_counts = {}
for h in results.values():
    t = h['heroType']
    type_counts[t] = type_counts.get(t, 0) + 1
print('Hero types count:', type_counts)

# Let's inspect each type
by_type = {}
for h in results.values():
    t = h['heroType']
    by_type.setdefault(t, []).append(h)

for t, hs in sorted(by_type.items(), key=lambda x: str(x[0])):
    print(f"\nType {t} (count {len(hs)}):")
    for h in hs[:4]:
        print(f"  ID {h['heroID']}: {h['name']} ({h['herName']})")
