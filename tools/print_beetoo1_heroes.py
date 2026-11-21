import json

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    d = json.load(f)['heroSysCtrl']['heroList']

for k, v in sorted(d.items(), key=lambda x: int(x[0])):
    print(f"Hero {k}: level={v.get('level')} quality={v.get('quality')} state={v.get('state')}")
