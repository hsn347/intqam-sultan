import os
import re

p = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua"
with open(p, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

blocks = re.split(r'skillID\s*=\s*', text)
print(f"Total blocks: {len(blocks)}")

type43_skills = {}
for b in blocks[1:]:
    m = re.match(r'(\d+)', b)
    if not m:
        continue
    sid = int(m.group(1))
    m_prop = re.search(r'skillProperty\s*=\s*"([^"]+)"', b)
    if m_prop and m_prop.group(1).startswith("43"):
        prop = m_prop.group(1)
        base_sid = sid // 100
        lv = sid % 100
        val = int(prop[4:])
        if base_sid not in type43_skills:
            type43_skills[base_sid] = []
        type43_skills[base_sid].append((lv, val))

for base_sid, levels in sorted(type43_skills.items()):
    print(f"Skill {base_sid}: {levels[:3]} ... max {levels[-1]}")
