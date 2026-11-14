# -*- coding: utf-8 -*-
import json

with open('dashboard/src/locales/ar.json', 'r', encoding='utf-8') as f:
    ar = json.load(f)
with open('dashboard/src/locales/en.json', 'r', encoding='utf-8') as f:
    en = json.load(f)
with open('dashboard/src/locales/tr.json', 'r', encoding='utf-8') as f:
    tr = json.load(f)

check_keys = [
    'accounts.botStoppedSuccess',
    'accounts.botStopError',
    'tasks.daily_train',
    'tasks.forge_equipment',
    'tasks.building',
    'tasks.buildingMasterNotice',
    'tasks.castleOnly',
]

def check(data, path):
    cur = data
    for p in path.split('.'):
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return None
    return cur

for k in check_keys:
    print(f"Key: {k}")
    print(f"  AR: {check(ar, k)}")
    print(f"  EN: {check(en, k)}")
    print(f"  TR: {check(tr, k)}")
