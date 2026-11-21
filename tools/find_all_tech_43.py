import re

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Match technologyID = (\d+), buffType = (\d+), powerNum = (\d+)
pattern = re.compile(r'technologyID\s*=\s*(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+)', re.DOTALL)
tech_43 = {}
for m in pattern.finditer(text):
    tid = int(m.group(1))
    bt = int(m.group(2))
    pw = int(m.group(3))
    if bt == 43:
        tech_43[tid] = pw

print(f"Total technology levels with buffType 43: {len(tech_43)}")
# Group by base tech id (first 5 digits)
base_techs = {}
for tid, pw in tech_43.items():
    bid = str(tid)[:5]
    lv = str(tid)[5:]
    if bid not in base_techs:
        base_techs[bid] = {}
    base_techs[bid][int(lv)] = pw

for bid, lvs in sorted(base_techs.items()):
    print(f"Tech Base {bid}: max_lv={max(lvs.keys())}, powers={lvs}")
