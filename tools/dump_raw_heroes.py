# -*- coding: utf-8 -*-
import json

d1 = json.load(open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8'))
d2 = json.load(open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8'))

print("=== HERO KEYS IN RAW DATA ===")
h2_sample = list(d2['heroSysCtrl']['heroList'].values())[0]
print("Hero keys:", list(h2_sample.keys()))

print("\n=== BEETOO 2 HEROES RAW DUMP ===")
for hid, h in sorted(d2['heroSysCtrl']['heroList'].items(), key=lambda x: int(x[0])):
    # print relevant fields
    print(f"Hero {hid}: lv={h.get('level')}, qual={h.get('quality')}, star={h.get('star')}, isAwake={h.get('isAwake')}, skills={h.get('skill')}, dress={h.get('dress')}, weapon={h.get('weapon')}, state={h.get('state')}")

print("\n=== BEETOO 1 HEROES RAW DUMP ===")
for hid, h in sorted(d1['heroSysCtrl']['heroList'].items(), key=lambda x: int(x[0])):
    print(f"Hero {hid}: lv={h.get('level')}, qual={h.get('quality')}, star={h.get('star')}, isAwake={h.get('isAwake')}, skills={h.get('skill')}, dress={h.get('dress')}, weapon={h.get('weapon')}, state={h.get('state')}")
