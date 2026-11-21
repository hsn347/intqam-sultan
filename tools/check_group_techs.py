import re
import json

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

# find all technologyID with buffType in (73, 77, 95)
pattern = re.compile(r'technologyID\s*=\s*(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+)', re.DOTALL)
group_techs = {}
for m in pattern.finditer(text):
    tid = int(m.group(1))
    bt = int(m.group(2))
    pw = int(m.group(3))
    if bt in (73, 77, 95):
        group_techs[tid] = (bt, pw)

print(f"Total group tech levels: {len(group_techs)}")

tctrl = d1.get('technologyCtrl', {})
print("Checking beetoo1 for group techs:")
for tid_str, tlv in tctrl.items():
    if isinstance(tlv, list):
        tid = int(tlv[0])
        lv = int(tlv[1])
    else:
        tid = int(tid_str)
        lv = int(tlv)
    full_id = tid * 100 + lv
    if full_id in group_techs:
        bt, pw = group_techs[full_id]
        print(f"  beetoo1 has Tech {full_id}: buffType={bt}, powerNum={pw}")
