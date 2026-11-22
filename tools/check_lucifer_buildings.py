import json

with open('docs/lucifer_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

print("=== Buildings in LUCIFER ===")
for b in d.get('cityCtrl', {}).get('blist', []):
    binfo = b.get('binfo', b)
    bid = str(binfo.get('bid'))
    lv = binfo.get('lv')
    star = binfo.get('starLv')
    if bid in ('101', '121', '109', '114', '115', '116', '117', '120', '301', '305', '4220'):
        print(f"  bid: {bid}, lv: {lv}, starLv: {star}")
