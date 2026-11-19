# -*- coding: utf-8 -*-
import os
import re

path = r"game_file\src\app\localtb\config_server\hero_skill_conf.lua"
with open(path, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Let's find all entries where buffType = 96 or buffType = 19 or buffType = 5
print("Searching for march-related buffTypes in hero_skill_conf.lua...")
matches = re.finditer(r'skillID\s*=\s*(\d+)', text)
entries = []
for m in matches:
    sid = m.group(1)
    pos = m.start()
    snippet = text[pos:pos+400]
    m_bt = re.search(r'buffType[^\n=]*=\s*(\d+)', snippet)
    m_bv = re.search(r'buffValue[^\n=]*=\s*([\d\.]+)', snippet)
    m_at = re.search(r'activeType[^\n=]*=\s*(\d+)', snippet)
    m_hid = re.search(r'heroID[^\n=]*=\s*(\d+)', snippet)
    m_q = re.search(r'quality[^\n=]*=\s*(\d+)', snippet)
    if m_bt:
        bt = int(m_bt.group(1))
        if bt in (96, 19, 5, 43):
            bv = m_bv.group(1) if m_bv else "0"
            hid = m_hid.group(1) if m_hid else "0"
            q = m_q.group(1) if m_q else "0"
            at = m_at.group(1) if m_at else "0"
            print(f"Skill {sid}: heroID={hid}, quality={q}, activeType={at}, buffType={bt}, buffValue={bv}")
