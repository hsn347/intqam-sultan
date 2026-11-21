with open(r'game_file\src\app\localtb\config_server\technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

techs_43 = {}
cur_tid = None
cur_bt = None
cur_pn = None

for line in lines:
    if '.technologyID = ' in line:
        parts = line.split('.technologyID = ')
        cur_tid = parts[1].strip().split(';')[0].split(',')[0].strip()
        cur_bt = None
        cur_pn = None
    elif '.buffType = ' in line and cur_tid:
        cur_bt = line.split('.buffType = ')[1].strip().split(';')[0].split(',')[0].strip()
    elif '.powerNum = ' in line and cur_tid:
        cur_pn = line.split('.powerNum = ')[1].strip().split(';')[0].split(',')[0].strip()
        if cur_bt == '43' and cur_tid:
            base_id = cur_tid[:-2]
            lv = int(cur_tid[-2:])
            techs_43.setdefault(base_id, {})[lv] = int(cur_pn)

print(f"Total base technologies with buffType 43: {len(techs_43)}")
for base_id, lvs in sorted(techs_43.items()):
    print(f"Tech {base_id}: max_lv={max(lvs.keys())}, max_power={lvs[max(lvs.keys())]}")
