# -*- coding: utf-8 -*-
import json

with open('tools/beetoo2_diagnostics.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

heroes = d.get('heroes', [])
print(f"Total heroes: {len(heroes)}")
for h in heroes:
    lvl = h.get('level', 0)
    if lvl > 1:
        hid = h.get('id')
        qual = h.get('quality')
        awake = h.get('isAwake')
        skills = h.get('skillList')
        power = h.get('powerSkill')
        mastery = h.get('masterySkill')
        print(f"Hero {hid} (lvl {lvl}, quality {qual}, awake {awake}):")
        print(f"  skills: {skills}")
        print(f"  powerSkill: {power}")
        print(f"  masterySkill: {mastery}")
