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

for b in blocks[1:]:
    m = re.match(r'(\d+)', b)
    if not m:
        continue
    sid = int(m.group(1))
    base_sid = sid // 100
    lv = sid % 100
    if base_sid in skills and lv == skills[base_sid]:
        m_prop = re.search(r'skillProperty\s*=\s*"([^"]+)"', b)
        if m_prop:
            prop = m_prop.group(1)
            ptype = prop[:2]
            mode = prop[2:4]
            val = int(prop[4:])
            print(f"Skill {base_sid} Lv {lv:2d}: prop={prop} -> type={ptype}, mode={mode}, val={val}")
