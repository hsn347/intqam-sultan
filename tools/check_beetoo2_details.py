# -*- coding: utf-8 -*-
import json

with open('tools/beetoo2_diagnostics.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

print("=== Lord Info ===")
for k in d.get('lord_info_keys', []):
    print(f"lordInfo.{k}:", str(d.get(k))[:100])

print("=== VIP ===")
print("vip:", d.get('vip'))

print("=== Pet Ctrl ===")
print("pet_ctrl_keys:", d.get('pet_ctrl_keys'))

print("=== Army Ctrl ===")
print("army_compile:", d.get('army_compile'))
print("team_info:", d.get('team_info'))
