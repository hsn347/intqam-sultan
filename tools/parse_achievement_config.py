import re
import json

with open('game_file/src/app/localtb/config_server/achievement_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern for achievement blocks:
# achievementID = (\d+)
# medalID = (\d+)
# medalBuff[1] = (\d+)
# medalBuff[2] = (\d+)

blocks = text.split(';(nil).achievementID = ')
print(f"Total blocks: {len(blocks)}")

achievements = {}
for b in blocks[1:]:
    lines = b.splitlines()
    aid = int(lines[0].strip())
    
    mid = 0
    m_mid = re.search(r'medalID\s*=\s*(?:nil,\s*)?(\d+)', b)
    if m_mid:
        mid = int(m_mid.group(1))
        
    btype = None
    bval = None
    m_b1 = re.search(r'medalBuff.*?\[1\]\s*=\s*(?:nil,\s*){3}(\d+)', b)
    m_b2 = re.search(r'medalBuff.*?\[2\]\s*=\s*(?:nil,\s*){3}(\d+)', b)
    if m_b1 and m_b2:
        btype = int(m_b1.group(1))
        bval = int(m_b2.group(1))
    
    achievements[aid] = {
        'achievementID': aid,
        'medalID': mid,
        'buffType': btype,
        'buffValue': bval
    }

print(f"Parsed achievements: {len(achievements)}")

# Check achievements with buffType == 14 (gAchieveProperty.MARCH_LIMIT_BOOST)
# or buffType in other march properties
march_achieves = {k: v for k, v in achievements.items() if v['buffType'] in (14, 19, 96)}
print(f"Achievements with march buff: {len(march_achieves)}")
for aid, v in sorted(march_achieves.items()):
    print(f"  ID {aid}: medalID={v['medalID']}, buffType={v['buffType']}, buffValue={v['buffValue']}")

# Now let's calculate the exact achievement buff for beetoo1 and beetoo2!
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

def calc_achieve_buff(data, name):
    ach_ctrl = data.get('achievementctrl', {})
    alist = ach_ctrl.get('list', {})
    print(f"\n--- Calculating Achievement Buffs for {name} ---")
    tot_buff_14 = 0
    all_buffs = {}
    for slot, item in alist.items():
        maxDone = item.get('maxDoneID', 0)
        if maxDone and maxDone in achievements:
            info = achievements[maxDone]
            bt = info['buffType']
            bv = info['buffValue']
            if bt is not None and bv is not None:
                all_buffs[bt] = all_buffs.get(bt, 0) + bv
                if bt == 14:
                    print(f"  Slot {slot} (Medal {item.get('medalID')}): maxDoneID={maxDone}, buffType=14, val={bv}")
                    tot_buff_14 += bv
    print(f"Total buffType 14 (MARCH_LIMIT_BOOST) for {name} = {tot_buff_14} permille ({tot_buff_14/10.0}%)")
    return tot_buff_14

b2_buff = calc_achieve_buff(d2, "beetoo2")
b1_buff = calc_achieve_buff(d1, "beetoo1")
