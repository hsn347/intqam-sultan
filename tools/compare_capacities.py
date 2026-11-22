import json
import os
import sys

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import get_max_march_capacity, get_castle_march_capacity_without_heroes

def test_file(path, label):
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    cap_no_heroes = get_castle_march_capacity_without_heroes(data)
    cap_with_available = get_max_march_capacity(data, need_available=True)
    cap_theoretical = get_max_march_capacity(data, need_available=False)
    
    print(f"================ {label} ================")
    print("Castle without heroes:", cap_no_heroes["total_capacity"])
    print("  Base drill:", cap_no_heroes["base_drill_grounds"])
    print("  Default const:", cap_no_heroes["default_game_constant"])
    print("  Tech flat:", cap_no_heroes["tech_flat_add"])
    print("  Hero dress flat:", cap_no_heroes["hero_dress_flat_add"])
    print("  Buff flat:", cap_no_heroes["buff_flat_add"])
    print("  Extra perm flat:", cap_no_heroes["extra_flat_add"])
    print("    Sources:", json.dumps(cap_no_heroes["extra_permanent_sources"], indent=2))
    print("  Total flat add:", cap_no_heroes["total_flat_add"])
    print("  Effective base:", cap_no_heroes["effective_base"])
    print("  Total mult:", cap_no_heroes["total_percent_multiplier"])
    print("  Percent troop add:", cap_no_heroes["percent_troop_add"])
    print("  Unchangesize:", cap_no_heroes["unchangesize"])
    print("--- With Heroes ---")
    print("Grand total (need_available=True):", cap_with_available.get("grand_total"))
    print("Heroes flat add:", cap_with_available.get("heroes_flat_add"))
    print("Grand total (theoretical all heroes):", cap_theoretical.get("grand_total"))
    print("Theoretical heroes flat add:", cap_theoretical.get("theoretical_heroes_flat_add"))

if __name__ == "__main__":
    test_file("docs/beetoo1_live_memory.json", "BEETOO1 (Confirmed 138,370 in-game)")
    test_file("docs/lucifer_live_memory.json", "LUCIFER")
