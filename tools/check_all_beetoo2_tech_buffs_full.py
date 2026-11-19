# -*- coding: utf-8 -*-
import json
import re

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d = json.load(f)

tctrl = d.get("technologyCtrl", {})

# Load technology.lua
with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

tech_configs = {}
current_id = None
current_data = {}

for line in lines:
    if "technologyID" in line:
        if current_id and current_data:
            tech_configs[current_id] = current_data
        parts = line.split("=")
        try:
            current_id = int(parts[1].strip())
            current_data = {}
        except:
            current_id = None
    elif current_id is not None:
        if "buffType" in line:
            parts = line.split("=")
            try: current_data["buffType"] = int(parts[1].strip())
            except: pass
        if "powerNum" in line:
            parts = line.split("=")
            try: current_data["powerNum"] = int(parts[1].strip())
            except: pass
        if "buffNumType" in line:
            parts = line.split("=")
            try: current_data["buffNumType"] = int(parts[1].strip())
            except: pass
        if "technologyType" in line:
            parts = line.split("=")
            try: current_data["technologyType"] = int(parts[1].strip())
            except: pass
        if "technologyLevel" in line:
            parts = line.split("=")
            try: current_data["technologyLevel"] = int(parts[1].strip())
            except: pass

if current_id and current_data:
    tech_configs[current_id] = current_data

print(f"Loaded {len(tech_configs)} tech levels from technology.lua")

all_buffs = {}
for tid_str, tinfo in tctrl.items():
    tid = int(tid_str)
    lv = int(tinfo[1])
    full_id = tid * 100 + lv
    cfg = tech_configs.get(full_id, {})
    btype = cfg.get("buffType")
    pnum = cfg.get("powerNum")
    ttype = cfg.get("technologyType")
    if btype:
        if btype not in all_buffs: all_buffs[btype] = []
        all_buffs[btype].append((tid, lv, pnum, ttype))

print("\n=== ALL BUFF TYPES FROM BEETOO2 TECHNOLOGIES ===")
for bt, items in sorted(all_buffs.items()):
    sum_val = sum(x[2] for x in items if x[2] is not None)
    print(f"BuffType {bt}: sum={sum_val}, items={items}")
