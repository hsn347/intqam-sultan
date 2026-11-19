# -*- coding: utf-8 -*-
"""
tools/extract_tech_rules.py — استخراج شجرة وقواعد متطلبات الأبحاث بدقة متناهية من ملفات اللعبة
"""

import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TREE_FILE = os.path.join(ROOT, "game_file", "src", "app", "localtb", "config_client", "technologytree.lua")
TECH_FILE = os.path.join(ROOT, "game_file", "src", "app", "localtb", "config_server", "technology.lua")
OUTPUT_FILE = os.path.join(ROOT, "core", "technology_rules.json")

def save_record(cur_rec, tech_rules, all_target_tech_ids, tree_mapping):
    full_id = cur_rec.get("full_id")
    if not full_id:
        return
    s_full = str(full_id)
    base_id = s_full[:-2] if len(s_full) >= 6 else s_full
    if base_id not in all_target_tech_ids:
        return

    lv = cur_rec.get("level", 1)
    preposes = []
    pre_raw = cur_rec.get("pre_id_raw", 0)
    pre_lv = cur_rec.get("pre_lv", 0)
    if pre_raw > 0 and pre_lv > 0:
        s_pre = str(pre_raw)
        pre_base = s_pre[:-2] if len(s_pre) >= 6 else s_pre
        preposes.append({"tech_id": pre_base, "level": pre_lv})

    # فحص إذا كان هناك شرط مسبق ثانٍ [3], [4]
    pre_raw2 = cur_rec.get("pre_id_raw2", 0)
    pre_lv2 = cur_rec.get("pre_lv2", 0)
    if pre_raw2 > 0 and pre_lv2 > 0:
        s_pre2 = str(pre_raw2)
        pre_base2 = s_pre2[:-2] if len(s_pre2) >= 6 else s_pre2
        preposes.append({"tech_id": pre_base2, "level": pre_lv2})

    tech_rules.setdefault(base_id, {})[str(lv)] = {
        "tree": tree_mapping.get(base_id, "unknown"),
        "college_lv": cur_rec.get("college_lv", 1),
        "prepose": preposes,
        "res": cur_rec.get("res", {"food": 0, "wood": 0, "iron": 0, "silver": 0}),
        "time": cur_rec.get("time", 60),
    }

def main():
    print("1. Parsing technology trees...")
    tree_techs = {}
    current_key = None
    with open(TREE_FILE, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            m_key = re.search(r'key\s*=\s*(?:nil,\s*)?"(\w+)"', line)
            if m_key:
                current_key = m_key.group(1)
                if current_key not in tree_techs:
                    tree_techs[current_key] = []
            m_id = re.search(r'tree.*"(\d+)"', line)
            if m_id and current_key:
                tree_techs[current_key].append(m_id.group(1))

    # الأشجار الأربع الرئيسية للمعهد
    target_trees = {
        "military": tree_techs.get("military", []) + tree_techs.get("special", []),
        "defense": tree_techs.get("anchor", []),
        "city": tree_techs.get("cityDevelop", []),
        "resources": tree_techs.get("resource", []),
    }

    all_target_tech_ids = set()
    tree_mapping = {}
    for t_name, t_ids in target_trees.items():
        all_target_tech_ids.update(t_ids)
        for tid in t_ids:
            tree_mapping[tid] = t_name

    print(f"Total target base tech IDs: {len(all_target_tech_ids)}")
    print("2. Parsing technology.lua for requirements...")

    tech_rules = {}
    cur_rec = {}

    with open(TECH_FILE, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            if "technologyID = " in line:
                if cur_rec:
                    save_record(cur_rec, tech_rules, all_target_tech_ids, tree_mapping)
                m = re.search(r'technologyID\s*=\s*(\d+)', line)
                if m:
                    full_id = int(m.group(1))
                    cur_rec = {"full_id": full_id}
                else:
                    cur_rec = {}
                continue

            if not cur_rec:
                continue

            if "=" in line:
                parts = line.split("=")
                lhs = parts[0]
                rhs_vals = [p.strip() for p in parts[1].split(",") if p.strip()]
                val_str = rhs_vals[-1] if rhs_vals else ""
                val_int = int(val_str) if val_str.isdigit() else 0

                if "technologyLevel" in lhs:
                    cur_rec["level"] = val_int
                elif "technologyBuild" in lhs and "[2]" in lhs:
                    cur_rec["college_lv"] = val_int
                elif "technologyTime" in lhs:
                    cur_rec["time"] = val_int
                elif "technologyPrepose" in lhs:
                    if "[1]" in lhs:
                        cur_rec["pre_id_raw"] = val_int
                    elif "[2]" in lhs:
                        cur_rec["pre_lv"] = val_int
                    elif "[3]" in lhs:
                        cur_rec["pre_id_raw2"] = val_int
                    elif "[4]" in lhs:
                        cur_rec["pre_lv2"] = val_int
                elif "technologyResource" in lhs:
                    res_map = cur_rec.setdefault("res", {})
                    if "[2]" in lhs: res_map["food"] = val_int
                    elif "[4]" in lhs: res_map["wood"] = val_int
                    elif "[6]" in lhs: res_map["iron"] = val_int
                    elif "[8]" in lhs: res_map["silver"] = val_int

    # حفظ السجل الأخير
    if cur_rec:
        save_record(cur_rec, tech_rules, all_target_tech_ids, tree_mapping)

    print(f"Extracted rules for {len(tech_rules)} base technologies!")
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(tech_rules, f, ensure_ascii=False, indent=2)
    print(f"Saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
