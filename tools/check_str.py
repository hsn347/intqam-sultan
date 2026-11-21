# -*- coding: utf-8 -*-
with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()
idx = text.find('common_text_1911')
if idx != -1:
    print(text[idx-5:idx+80])
