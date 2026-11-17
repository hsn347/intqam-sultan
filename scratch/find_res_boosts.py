import re

with open('game_file/src/app/localtb/config_server/local_arab.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

name_pattern = dict(re.findall(r'\[\"(item_name_\d+)\"\]\s*=\s*\"([^\"]+)\"', text))
desc_pattern = dict(re.findall(r'\[\"(item_des_\d+)\"\]\s*=\s*\"([^\"]+)\"', text))

matches = []
for k, v in desc_pattern.items():
    if "إنتاج" in v or "انتاج" in v:
        item_id = int(k.replace("item_des_", ""))
        name = name_pattern.get(f"item_name_{item_id}", "")
        matches.append((item_id, name, v))

matches.sort(key=lambda x: x[0])
print(f"Total matching descs with إنتاج: {len(matches)}")
for item_id, name, desc in matches:
    print(f"  {item_id}: {name} -> {desc}")
