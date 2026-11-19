import re, json

def parse_tech():
    with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()

    current_tech = {}
    techs = {}

    for line in lines:
        line = line.strip()
        m_id = re.search(r'\.technologyID\s*=\s*([0-9]+)', line)
        if m_id:
            if 'technologyID' in current_tech:
                techs[current_tech['technologyID']] = current_tech
            current_tech = {'technologyID': int(m_id.group(1))}
            continue
        
        m_buff = re.search(r'\.buffType\s*=\s*([0-9]+)', line)
        if m_buff and current_tech:
            current_tech['buffType'] = int(m_buff.group(1))
            continue

        m_pow = re.search(r'\.powerNum\s*=\s*([0-9]+)', line)
        if m_pow and current_tech:
            current_tech['powerNum'] = int(m_pow.group(1))
            continue

        m_numtype = re.search(r'\.buffNumType\s*=\s*([0-9]+)', line)
        if m_numtype and current_tech:
            current_tech['buffNumType'] = int(m_numtype.group(1))
            continue

    if 'technologyID' in current_tech:
        techs[current_tech['technologyID']] = current_tech

    print(f"Total parsed techs: {len(techs)}")

    # Filter by buffType in 43, 73, 77, 95, 19, 96
    target_buffs = {43: "SINGLE_TROOP_STRENGTH", 73: "CONQUEST_WAR_SINGLE_TROOP", 77: "PYRAMID_SINGLE_TROOP", 95: "LEGEND_SINGLE_TROOP", 19: "MARCH_LIMIT_BOOST", 96: "MARCH_VALUE_LIMIT_BOOST"}
    
    march_techs = {}
    for tid, data in techs.items():
        btype = data.get('buffType')
        if btype in target_buffs:
            march_techs[tid] = data
            data['buffName'] = target_buffs[btype]

    print(f"Found {len(march_techs)} march tech entries.")
    
    # Save to file
    with open('tools/parsed_march_techs.json', 'w', encoding='utf-8') as out:
        json.dump(march_techs, out, indent=2)

    # Now let's test beetoo2's technologies!
    beetoo2_techs = {
        "24021": 2, "24018": 5, "24004": 3, "24033": 1, "24027": 2, "24104": 2,
        "24017": 1, "24016": 3, "24002": 3, "25009": 4, "24112": 1, "24116": 1,
        "24117": 3, "24011": 1, "24001": 2, "22003": 5, "24006": 3, "24022": 2,
        "24019": 2, "21002": 5, "24009": 3, "25002": 5, "25029": 1, "22005": 8,
        "25007": 4, "24111": 1, "24106": 1, "25011": 1, "24113": 1, "21001": 5,
        "21006": 1, "21003": 1, "25006": 1, "24101": 2, "24115": 1, "24010": 3,
        "25030": 1, "22002": 5, "24032": 2, "22007": 2, "24110": 1, "24007": 3,
        "24023": 3, "24012": 3, "24014": 3, "25004": 2, "24103": 2, "24107": 2,
        "22001": 10, "24015": 3, "22006": 1, "21004": 9, "24003": 3, "25005": 1,
        "21005": 3, "25010": 4, "22009": 10, "25001": 5, "24020": 2, "22008": 5,
        "24105": 2, "25008": 4, "24008": 3, "24114": 1, "25003": 2, "22004": 2,
        "24109": 1, "24005": 3, "24013": 3, "24108": 1
    }

    print("\n--- BEETOO2 TECH CONTRIBUTIONS ---")
    total_tech_add = 0
    total_tech_group = 0
    for tid_str, lvl in beetoo2_techs.items():
        if lvl <= 0:
            continue
        full_id = int(f"{tid_str}{lvl:02d}")
        if full_id in march_techs:
            info = march_techs[full_id]
            btype = info['buffType']
            pnum = info['powerNum']
            cardinal = 1000 if info.get('buffNumType') == 1 else 1
            power = pnum / cardinal
            print(f"Tech {tid_str} Lv.{lvl} (full_id {full_id}): {info['buffName']} (btype {btype}) -> power = {power} (powerNum={pnum}, cardinal={cardinal})")
            if btype == 43:
                total_tech_add += power
            elif btype in (73, 77, 95):
                total_tech_group += power

    print(f"\nTotal SINGLE_TROOP_STRENGTH (43): {total_tech_add}")
    print(f"Total TECH_GROUP (73, 77, 95): {total_tech_group}")

if __name__ == '__main__':
    parse_tech()
