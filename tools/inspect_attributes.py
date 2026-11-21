import json

for fname, name in [('tools/beetoo1_full_init_data.json', 'beetoo1'), ('tools/beetoo2_full_init_data.json', 'beetoo2')]:
    with open(fname, encoding='utf-8') as f:
        d = json.load(f)
    print(f"=== {name} ===")
    print("boeAttributeCtrl:", d.get('boeAttributeCtrl'))
    print("vip:", d.get('lordInfoCtrl', {}).get('vip'))
    print("achieveInfo:", d.get('lordInfoCtrl', {}).get('achieveInfo'))
    print("militaryRankInfo:", d.get('lordInfoCtrl', {}).get('militaryRankInfo'))
    print("equipmentCtrl:", len(d.get('equipmentCtrl', {})))
    print("petCtrl:", len(d.get('petCtrl', {})))
