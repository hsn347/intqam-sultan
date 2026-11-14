# -*- coding: utf-8 -*-
import json
import re

locales = {}
for lang in ['ar', 'en', 'tr']:
    with open(f'dashboard/src/locales/{lang}.json', 'r', encoding='utf-8') as f:
        locales[lang] = json.load(f)

def get_nested_key(data, key_path):
    parts = key_path.split('.')
    cur = data
    for p in parts:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return None
    return cur

# Scan CastleCard.tsx and TaskTabContent.tsx for t('...')
t_pattern = re.compile(r"t\(\s*['\"]([a-zA-Z0-9_\.]+)['\"]")

files = [
    'dashboard/src/components/accounts/CastleCard.tsx',
    'dashboard/src/components/accounts/TaskTabContent.tsx'
]

keys_found = set()
for fp in files:
    with open(fp, 'r', encoding='utf-8') as f:
        content = f.read()
    for m in t_pattern.finditer(content):
        keys_found.add(m.group(1))

print(f"Total unique translation keys scanned: {len(keys_found)}")

missing = {lang: [] for lang in ['ar', 'en', 'tr']}
for k in sorted(keys_found):
    for lang in ['ar', 'en', 'tr']:
        val = get_nested_key(locales[lang], k)
        if val is None:
            missing[lang].append(k)

for lang in ['ar', 'en', 'tr']:
    print(f"Language {lang}: {len(missing[lang])} missing keys")
    if missing[lang]:
        print(f"  Missing in {lang}: {missing[lang][:10]}...")

if not any(missing.values()):
    print("ALL SCANNED UI TRANSLATION KEYS EXIST ACROSS ALL 3 LANGUAGES (ar, en, tr)!")
