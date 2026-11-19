# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/vipbuff.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Each VIP level starts with point = ... or similar
levels = re.split(r'point\s*=\s*(?:nil,\s*)?(\d+)', text)

vip_limits = {}
# level 1 is index 0 or 1
for i, chunk in enumerate(levels[1:], 1):
    m = re.search(r'limit.*?\[3\]\s*=\s*(?:nil,\s*nil,\s*)?(\d+)', chunk)
    val = int(m.group(1)) if m else 0
    m_pt = re.search(r'point\s*=\s*(\d+)', chunk)
    vip_limits[i] = val
    print(f"VIP level {i}: limit (7219) = {val}")
