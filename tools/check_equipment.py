import json

for path, name in [('tools/beetoo1_full_init_data.json', 'beetoo1'), ('tools/beetoo2_full_init_data.json', 'beetoo2')]:
    with open(path, encoding='utf-8') as f:
        d = json.load(f)
    eq_ctrl = d.get('equipmentCtrl', {})
    eq_arr = eq_ctrl.get('equipment_array', [])
    print(f"=== {name} Equipment ({len(eq_arr)}) ===")
    for eq in eq_arr:
        eid = eq.get('eid')
        slv = eq.get('slv')
        rlv = eq.get('rlv')
        suit = eq.get('suitId')
        print(f"  Equip eid={eid}, slv={slv}, rlv={rlv}, suit={suit}")
