import json
import re

# Load technology.lua
with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's parse technology.lua to map technologyID -> {buffType, powerNum, buffNumType}
# In technology.lua:
# ;(nil).technologyID = 2401601
# ;(nil).buffType = 43
# ;(nil).powerNum = 2000
# ;(nil).buffNumType = 2
tech_map = {}
cur_id = None
cur_buff = None
cur_power = None
cur_num_type = None

for line in text.split('\n'):
    m_id = re.search(r'technologyID\s*=\s*(\d+)', line)
    if m_id:
        cur_id = int(m_id.group(1))
    m_b = re.search(r'buffType\s*=\s*(\d+)', line)
    if m_b:
        cur_buff = int(m_b.group(1))
    m_p = re.search(r'powerNum\s*=\s*(\d+)', line)
    if m_p:
        cur_power = int(m_p.group(1))
    m_nt = re.search(r'buffNumType\s*=\s*(\d+)', line)
    if m_nt:
        cur_num_type = int(m_nt.group(1))
    if 'index' in line and cur_id:
        tech_map[cur_id] = {'buffType': cur_buff, 'powerNum': cur_power, 'buffNumType': cur_num_type}
        cur_id = None
        cur_buff = None
        cur_power = None
        cur_num_type = None

print(f"Total technology details parsed: {len(tech_map)}")

def check_account_tech(json_path, label):
    with open(json_path, encoding='utf-8') as f:
        d = json.load(f)
    tlist = d.get('technologyCtrl', {})
    print(f"\n=== {label} Technology Powers ===")
    total_43 = 0
    total_73 = 0
    total_77 = 0
    total_95 = 0
    for tid, tval in tlist.items():
        if isinstance(tval, list) and len(tval) >= 2:
            base_id = int(tval[0])
            lv = int(tval[1])
            # mosaicTechnologyId: base_id * 100 + lv
            full_id = base_id * 100 + lv
            detail = tech_map.get(full_id, {})
            btype = detail.get('buffType')
            power = detail.get('powerNum', 0)
            if btype == 43:
                total_43 += power
                print(f"  Single Troop Strength: {full_id} -> +{power}")
            elif btype == 73:
                total_73 += power
                print(f"  Conquest War: {full_id} -> +{power}")
            elif btype == 77:
                total_77 += power
                print(f"  Pyramid: {full_id} -> +{power}")
            elif btype == 95:
                total_95 += power
                print(f"  Legend: {full_id} -> +{power}")
    print(f"Total 43: {total_43}, Total 73: {total_73}, Total 77: {total_77}, Total 95: {total_95}")

check_account_tech('tools/beetoo1_full_init_data.json', 'beetoo1')
check_account_tech('tools/beetoo2_full_init_data.json', 'beetoo2')
