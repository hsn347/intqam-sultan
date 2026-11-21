import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

print("Buildings in beetoo1:")
for b in d1.get('cityCtrl', {}).get('blist', []):
    binfo = b.get('binfo', b)
    bid = binfo.get('bid')
    lv = binfo.get('lv')
    star = binfo.get('starLv')
    if str(bid) in ['101', '121', '109', '110', '111', '112']:
        print(f"  BID {bid}: lv={lv}, starLv={star}")
