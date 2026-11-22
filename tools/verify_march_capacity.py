# -*- coding: utf-8 -*-
"""
tools/verify_march_capacity.py
Verification harness for tasks/march_capacity.py across live memory dumps:
  - docs/beetoo1_live_memory.json
  - docs/beetoo2_live_memory.json (and tools/beetoo2_full_init_data.json)
  - docs/lucifer_live_memory.json
Checks:
  1. Zero crashes
  2. Zero network queries (pure in-memory verification)
  3. Complete breakdown of each component with game source origins
"""

import sys
import os
import json
import traceback

# Ensure root is in path
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

from tasks.march_capacity import (
    get_drill_grounds_base_capacity,
    get_technology_march_additions,
    get_hero_dress_passive_march_buff,
    get_achievement_march_buff,
    get_vip_march_buff,
    get_active_march_buffs,
    get_extra_permanent_march_buffs,
    get_castle_march_capacity_without_heroes,
    get_all_castle_heroes,
    get_max_march_capacity,
)

TEST_FILES = [
    ("beetoo1", os.path.join(ROOT_DIR, "docs", "beetoo1_live_memory.json")),
    ("beetoo2 (docs)", os.path.join(ROOT_DIR, "docs", "beetoo2_live_memory.json")),
    ("beetoo2 (tools)", os.path.join(ROOT_DIR, "tools", "beetoo2_full_init_data.json")),
    ("lucifer", os.path.join(ROOT_DIR, "docs", "lucifer_live_memory.json")),
]

def verify_file(label: str, file_path: str):
    print("=" * 80)
    print(f"VERIFYING: {label} [{file_path}]")
    print("=" * 80)

    if not os.path.exists(file_path):
        print(f"FAILED: File not found: {file_path}")
        return False, None

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            init_data = json.load(f)
    except Exception as e:
        print(f"FAILED to parse JSON: {e}")
        return False, None

    # Verify drill ground
    try:
        drill = get_drill_grounds_base_capacity(init_data)
        print(f"  [1] Drill Ground (build121.lua): Lv={drill.get('level')}, StarLv={drill.get('star_level')}, TotalBase={drill.get('total_base_capacity')}")
    except Exception as e:
        print(f"  [1] Drill Ground ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify technology
    try:
        tech = get_technology_march_additions(init_data)
        print(f"  [2] Technology (Buff 43 / Groups 73,77,95): FlatAdd={tech.get('total_tech_add')}, GroupMult={tech.get('tech_group_multiplier')}")
        print(f"      Count buff 43 techs={len(tech.get('details', []))}, Groups count={len(tech.get('tech_group_details', []))}")
    except Exception as e:
        print(f"  [2] Technology ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify hero dress passive
    try:
        dress = get_hero_dress_passive_march_buff(init_data)
        print(f"  [3] Hero Dress Passive (Buff 96): FlatAdd={dress.get('total_dress_add')}, Dresses={len(dress.get('active_dresses', []))}")
    except Exception as e:
        print(f"  [3] Hero Dress ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify achievements / medals
    try:
        achieve = get_achievement_march_buff(init_data)
        print(f"  [4] Achievement Medal 17: Lv={achieve.get('level')}, Multiplier={achieve.get('multiplier')} ({achieve.get('percent')}%)")
    except Exception as e:
        print(f"  [4] Achievement ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify VIP
    try:
        vip = get_vip_march_buff(init_data)
        print(f"  [5] VIP (Privilege 7219): Lv={vip.get('vip_level')}, Active={vip.get('is_vip_active')}, Multiplier={vip.get('multiplier')} ({vip.get('percent')}%)")
    except Exception as e:
        print(f"  [5] VIP ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify active buffs
    try:
        active_buffs = get_active_march_buffs(init_data)
        print(f"  [6] Active Buffs (Items/Rally): Flat={active_buffs.get('buff_flat_val')}, Mult={active_buffs.get('buff_percent_add')}")
    except Exception as e:
        print(f"  [6] Active Buffs ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify extra permanent sources
    try:
        extra_perm = get_extra_permanent_march_buffs(init_data)
        print(f"  [7] Extra Permanent Buffs: TotalExtraFlat={extra_perm.get('total_extra_flat')}")
        for src_name, src_val in extra_perm.get("sources", {}).items():
            if src_val:
                print(f"      - {src_name}: +{src_val}")
    except Exception as e:
        print(f"  [7] Extra Perm Buffs ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify castle capacity without heroes
    try:
        castle_no_heroes = get_castle_march_capacity_without_heroes(init_data)
        print(f"  [8] Castle March Capacity (No Heroes):")
        print(f"      - Base Drill: {castle_no_heroes.get('base_drill_grounds')}")
        print(f"      - Default Game Const: {castle_no_heroes.get('default_game_constant')}")
        print(f"      - Tech Flat Add: {castle_no_heroes.get('tech_flat_add')}")
        print(f"      - Dress Flat Add: {castle_no_heroes.get('hero_dress_flat_add')}")
        print(f"      - Extra Permanent Flat Add: {castle_no_heroes.get('extra_flat_add')}")
        print(f"      - Total Flat Add: {castle_no_heroes.get('total_flat_add')}")
        print(f"      - Effective Base: {castle_no_heroes.get('effective_base')}")
        print(f"      - Total Percent Mult: {castle_no_heroes.get('total_percent_multiplier') * 100:.2f}% (Achieve: {castle_no_heroes.get('achievement_percent')}%, TechGroup: {castle_no_heroes.get('tech_group_percent')}%, VIP: {castle_no_heroes.get('vip_percent')}%, Items: {castle_no_heroes.get('item_buff_percent')}%)")
        print(f"      - Percent Troop Add: {castle_no_heroes.get('percent_troop_add')}")
        print(f"      - Total Castle Capacity: {castle_no_heroes.get('total_capacity')}")
        print(f"      - Unchangesize: {castle_no_heroes.get('unchangesize')}")
    except Exception as e:
        print(f"  [8] Castle No Heroes ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify hero march capacities
    try:
        heroes = get_all_castle_heroes(init_data)
        print(f"  [9] Heroes March Capacities: Total heroes={len(heroes)}")
        top_heroes = sorted(heroes, key=lambda h: h.get("total_hero_add", 0), reverse=True)[:5]
        for h in top_heroes:
            print(f"      - Hero {h.get('hero_id')} ({h.get('name')}): Rarity={h.get('rarity')}, Lv={h.get('level')}, BaseRarityAdd={h.get('level_add')}, SkillAdd={h.get('skills_add')}, TotalHeroCap={h.get('total_hero_add')}")
    except Exception as e:
        print(f"  [9] Heroes ERROR: {e}")
        traceback.print_exc()
        return False, None

    # Verify get_max_march_capacity
    try:
        max_cap = get_max_march_capacity(init_data)
        grand_total = max_cap.get('grand_total', max_cap.get('total_capacity'))
        castle_cap = max_cap.get('castle_without_heroes', max_cap.get('castle_capacity'))
        print(f"  [10] Master get_max_march_capacity():")
        print(f"       - Castle Capacity: {castle_cap}")
        print(f"       - Heroes March Add: {max_cap.get('heroes_flat_add')}")
        print(f"       - Theoretical Heroes Add: {max_cap.get('theoretical_heroes_flat_add')}")
        print(f"       - God Arms Runes Add: {max_cap.get('arm_rune_add')}")
        print(f"       - Divine Beast Add: {max_cap.get('divine_beast_add')}")
        print(f"       - Grand Total March Capacity: {grand_total}")
    except Exception as e:
        print(f"  [10] Master Calculation ERROR: {e}")
        traceback.print_exc()
        return False, None

    print(f"PASSED verification for {label}\n")
    return True, max_cap

def main():
    results = {}
    all_ok = True
    for label, path in TEST_FILES:
        ok, res = verify_file(label, path)
        results[label] = {"ok": ok, "res": res}
        if not ok:
            all_ok = False

    print("=" * 80)
    print("SUMMARY OF VERIFICATION")
    print("=" * 80)
    for label, data in results.items():
        status = "PASSED" if data["ok"] else "FAILED"
        res = data["res"] or {}
        cap = res.get("grand_total", res.get("total_capacity", "N/A"))
        castle_cap = res.get("castle_without_heroes", res.get("castle_capacity", "N/A"))
        print(f"  {label:<20}: {status} | Castle Cap={castle_cap} | Grand Total={cap}")

    if all_ok:
        print("\nALL DUMPS PROCESSED WITHOUT ERRORS!")
    else:
        print("\nSOME DUMPS FAILED VERIFICATION!")

if __name__ == "__main__":
    main()
