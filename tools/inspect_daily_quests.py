import re

with open('game_file/src/app/localtb/config_client/daily_reward_data.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Let's inspect sections
blocks = text.split(';(nil).ID = ')
for b in blocks[1:]:
    lines = b.split('\n')
    qid = lines[0].strip()
    img_m = re.search(r'image\s*=\s*"([^"]+)"', b)
    name_m = re.search(r'name\s*=\s*"([^"]+)"', b)
    point_m = re.search(r'point\s*=\s*"([^"]+)"', b)
    img = img_m.group(1) if img_m else ""
    name = name_m.group(1) if name_m else ""
    point = point_m.group(1) if point_m else ""
    print(f"ID={qid} | point={point} | name={name} | image={img}")
