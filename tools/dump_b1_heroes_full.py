import json

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    d = json.load(f)

hlist = d.get('heroSysCtrl', {}).get('heroList', {})
print(f"Total heroes in beetoo1: {len(hlist)}")
for hid, h in sorted(hlist.items(), key=lambda x: int(x[0])):
    # print all fields
    print(f"\n--- Hero {hid} ---")
    for k, v in h.items():
        print(f"  {k}: {v}")
