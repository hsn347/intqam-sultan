import re
import json

with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Let's inspect all occurrences of .id = \d+
ids = re.findall(r'\.id\s*=\s*(\d+)', text)
names = re.findall(r'\.name\s*=\s*"([^"]+)"', text)
descs = re.findall(r'\.des\s*=\s*"([^"]+)"', text)
icons = re.findall(r'\.icon\s*=\s*(?:[^,\n]*,)*\s*"([^"]+\.png)"', text)

print(f"Counts: ids={len(ids)}, names={len(names)}, descs={len(descs)}, icons={len(icons)}")

# Also let's check by splitting on id = 
entries = re.split(r'\.id\s*=\s*', text)[1:]
print(f"Total entries by split: {len(entries)}")
parsed = []
for e in entries:
    m_id = re.match(r'(\d+)', e)
    m_name = re.search(r'\.name\s*=\s*"([^"]+)"', e)
    m_des = re.search(r'\.des\s*=\s*"([^"]+)"', e)
    m_icon = re.search(r'icon\s*=\s*(?:[^;\n]*,)?\s*"([^"]+\.png)"', e)
    if m_id and m_name and m_des and m_icon:
        parsed.append({
            'id': int(m_id.group(1)),
            'name': m_name.group(1),
            'des': m_des.group(1),
            'icon': m_icon.group(1)
        })

print(f"Successfully parsed entries: {len(parsed)}")
if len(parsed) > 0:
    print("First 3:", parsed[:3])
    print("Last 3:", parsed[-3:])
