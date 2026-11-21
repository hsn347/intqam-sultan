import json

def inspect_castle(path, label):
    with open(path, encoding='utf-8') as f:
        d = json.load(f)
    print(f"=== {label} ===")
    
    # cityCtrl (buildings)
    city = d.get('cityCtrl', {})
    buildings = city.get('buildingList', {}) or city.get('buildList', {})
    print(f"City buildings count: {len(buildings)}")
    # Find drill ground or parade ground
    for bid, binfo in buildings.items():
        btype = binfo.get('buildType') or binfo.get('type')
        level = binfo.get('level')
        # print if level > 20 or type relates to army/drill
        if btype in [1007, 1008, 1009, 1010, 1002, 1001]:
            print(f"  Building {bid}: type={btype}, level={level}")
            
    # technologyCtrl
    tech = d.get('technologyCtrl', {})
    tech_list = tech.get('techList', {}) or tech.get('technologyList', {})
    print(f"Tech count: {len(tech_list)}")
    march_techs = {k: v for k, v in tech_list.items() if k in ['24016', '24032', '25030', 24016, 24032, 25030]}
    print(f"March techs: {march_techs}")
    
    # lordInfoCtrl
    lord = d.get('lordInfoCtrl', {})
    vip = lord.get('vipInfo', {})
    print(f"VIP level={vip.get('vipLevel')}, end_time={vip.get('vipEndTime')}")
    print(f"Lord level={lord.get('level')}, medals={lord.get('medalList')}")
    
    # buffCtrl
    buffs = d.get('buffCtrl', {})
    print(f"Buffs: {buffs}")

if __name__ == "__main__":
    inspect_castle('tools/beetoo1_full_init_data.json', 'beetoo1')
    print("\n" + "="*50 + "\n")
    inspect_castle('tools/beetoo2_full_init_data.json', 'beetoo2')
