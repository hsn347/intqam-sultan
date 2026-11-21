import os
import sys
import re

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data, parse_technology_table

def check_all_techs():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    tech_ctrl = init_data.get("technologyCtrl", {})
    tech_table = parse_technology_table()
    
    print(f"Total researched techs in beetoo1: {len(tech_ctrl)}")
    by_buff_type = {}
    
    for tech_id, lvl in tech_ctrl.items():
        # mosaic ID: e.g. tech_id * 100 + lvl or tech_id * 10 + lvl
        # Let's search tech_table for keys matching tech_id
        matching_keys = [k for k in tech_table if str(k).startswith(str(tech_id))]
        # Find exact level
        found = False
        for mk in matching_keys:
            entry = tech_table[mk]
            if entry.get("level") == int(lvl):
                found = True
                btype = entry.get("buffType")
                power = entry.get("powerNum", 0)
                by_buff_type.setdefault(btype, []).append((tech_id, lvl, power, entry.get("buffNumType")))
                break
        if not found:
            # try formatted
            pass
            
    print("\nResearched Techs Grouped by buffType:")
    for btype, items in sorted(by_buff_type.items(), key=lambda x: str(x[0])):
        total_p = sum(x[2] for x in items)
        print(f"BuffType {btype}: total power = {total_p} ({len(items)} techs)")
        for it in items:
            print(f"   • tech {it[0]} Lv {it[1]} -> power {it[2]} (buffNumType={it[3]})")

if __name__ == "__main__":
    check_all_techs()
