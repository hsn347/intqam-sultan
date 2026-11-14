import json
import re

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_arab = json.load(f)

with open('game_file/src/app/localtb/config_client/daily_reward_data.lua', 'r', encoding='utf-8') as f:
    text = f.read()

matches = re.findall(r'ID = (\d+).*?name = ["\'](.*?)["\'].*?des = ["\'](.*?)["\']', text, re.DOTALL)
for mid, name_k, des_k in matches:
    name_v = local_arab.get(name_k, name_k)
    des_v = local_arab.get(des_k, des_k)
    print(f'{mid}: {name_v} | {des_v}')

