import json

for fname, name in [('tools/beetoo1_full_init_data.json', 'beetoo1'), ('tools/beetoo2_full_init_data.json', 'beetoo2')]:
    with open(fname, encoding='utf-8') as f:
        d = json.load(f)
    blist = d.get('cityCtrl', {}).get('blist', [])
    for b in blist:
        binfo = b.get('binfo', b)
        if str(binfo.get('bid')) in ['121', '101', '107']:
            print(f"{name} building {binfo.get('bid')}: lv={binfo.get('lv')}, starLv={binfo.get('starLv')}")
