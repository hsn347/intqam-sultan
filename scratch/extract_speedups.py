import re

with open('game_file/src/app/localtb/config_client/itemdescribe.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Let's inspect entries around 500601, 500701, 500801, 500901, 501001, 501101
pattern = re.findall(r'\((\d{6})\)\.num\s*=\s*\"([^\"]+)\"', text)
num_map = {int(item_id): val for item_id, val in pattern}

pattern_name = re.findall(r'\((\d{6})\)\[1\]\s*=\s*\"(item_name_\d+)\"', text)
name_map = {int(item_id): name_key for item_id, name_key in pattern_name}

pattern_des = re.findall(r'\((\d{6})\)\[1\]\s*=\s*\"(item_des_\d+)\"', text)
des_map = {int(item_id): des_key for item_id, des_key in pattern_des}

print(f"Total entries with num: {len(num_map)}")

speedup_items = {}
for item_id, num in num_map.items():
    s_id = str(item_id)
    if s_id.startswith(('5006', '5007', '5008', '5009', '5010', '5011', '5101', '5112', '5113')):
        speedup_items[item_id] = {
            "num": num,
            "name_key": name_map.get(item_id, ""),
            "des_key": des_map.get(item_id, "")
        }

for k in sorted(speedup_items.keys()):
    v = speedup_items[k]
    print(f"  {k}: num={v['num']}, name={v['name_key']}, des={v['des_key']}")
