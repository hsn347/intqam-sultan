import re
import json

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

tctrl = d1.get('technologyCtrl', {})
print("Checking ALL beetoo1 techs in technology.lua:")
for tid_str, tlv in tctrl.items():
    # search for tid_str in technology.lua
    # e.g. tid = 24021
    m = re.search(r'ID\s*=\s*' + str(tid_str) + r'\b.*?buff_type\s*=\s*(\d+)', text, re.DOTALL)
    if m:
        bt = int(m.group(1))
        if bt in [43, 19, 96, 73, 77, 95]:
            print(f"  FOUND Tech {tid_str} Lv {tlv} with buff_type {bt}!")
print("Done checking.")
