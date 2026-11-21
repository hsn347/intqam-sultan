# -*- coding: utf-8 -*-
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from tasks.march_capacity import load_account_init_data, LEADERSHIP_TECH_ADDITIONS, TECH_GROUP_MARCH_PERCENT

tables_path = os.path.join(ROOT, "tools", "master_march_tables.json")
with open(tables_path, "r", encoding="utf-8") as f:
    master = json.load(f)
techs_info = master.get("techs", {})

for acc in ["beetoo1", "beetoo2", "beetoo3", "LUCIFER@g4.coom"]:
    _, d = load_account_init_data(acc, offline=True)
    tctrl = d.get("technologyCtrl", {})
    print(f"=== Tech check for {acc} ({len(tctrl)} techs) ===")
    for tid_str, tval in tctrl.items():
        if isinstance(tval, (list, tuple)) and len(tval) >= 2:
            tid, tlv = int(tval[0]), int(tval[1])
        else:
            tid, tlv = int(tid_str), int(tval)

        t_meta = techs_info.get(str(tid), {}).get(str(tlv), {})
        buff_type = t_meta.get("buff_type")
        if buff_type in (43, 73, 77, 95):
            is_known = (tid in LEADERSHIP_TECH_ADDITIONS or tid in TECH_GROUP_MARCH_PERCENT)
            print(f"  March Tech {tid} Lv {tlv} -> buff_type={buff_type}, power={t_meta.get('power')}, is_known={is_known}")
