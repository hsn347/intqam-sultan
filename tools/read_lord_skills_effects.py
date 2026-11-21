import os
import re

p = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua"
with open(p, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

skills = {
    13011: 20, 11011: 1, 13029: 20, 13003: 5, 13025: 20, 13015: 20,
    13005: 5, 13033: 10, 13020: 1, 11001: 5, 13017: 20, 13010: 20,
    13031: 20, 11004: 5, 13007: 5, 13019: 20, 13022: 1, 13009: 20,
    13002: 5, 13023: 20, 13027: 20, 13001: 5, 13032: 1, 11002: 5,
    13021: 1, 13013: 20
}

blocks = re.split(r'skillID\s*=\s*', text)
print(f"Total skill blocks: {len(blocks)}")

for b in blocks[1:]:
    m = re.match(r'(\d+)', b)
    if not m:
        continue
    sid = int(m.group(1))
    # sid in skill.lua has level attached, or base id?
    # e.g. 1301101 or 13011?
    # Let's check:
    base_sid = sid // 100 if sid > 100000 else sid
    if base_sid in skills:
        lv = sid % 100 if sid > 100000 else 1
        if lv == skills[base_sid]:
            # find property / buff / value in b
            lines = [l.strip() for l in b.splitlines()[:20]]
            print(f"Skill {base_sid} Lv {lv}:")
            for l in lines:
                if any(k in l for k in ["skillPower", "property", "buff", "power", "type"]):
                    print(f"   {l}")
