# -*- coding: utf-8 -*-
with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()
for s in ['13002', '11005', '11015', '11030', '11043']:
    k = f'"lordskill_name_{s}"'
    idx = text.find(k)
    if idx != -1:
        print(text[idx:idx+80])
