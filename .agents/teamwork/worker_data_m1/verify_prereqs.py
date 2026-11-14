import json
import os
import sys

def verify_buildings_prereqs():
    workspace_root = r"e:\intqam-sultan"
    json_path = os.path.join(workspace_root, "core", "buildings_prereqs.json")

    print("=== Milestone 1: Automated Verification of core/buildings_prereqs.json ===")
    assert os.path.exists(json_path), f"File not found: {json_path}"

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 1. Total buildings check
    print("\n[Test 1] Building Count & Root Structure Check...")
    assert isinstance(data, dict), "Root must be a JSON object"
    assert len(data) == 30, f"Expected exactly 30 buildings, got {len(data)}"
    expected_bids = {
        "101", "102", "103", "104", "105",
        "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125",
        "201", "202", "203", "204", "205", "206", "207",
        "301", "302", "305"
    }
    actual_bids = set(data.keys())
    assert actual_bids == expected_bids, f"BIDs mismatch: diff = {actual_bids ^ expected_bids}"
    print(f"  PASS: Exactly 30 expected building IDs found: {sorted([int(b) for b in actual_bids])}")

    # 2. Total level count & ceilings check
    print("\n[Test 2] Level Count & Ceiling Check...")
    expected_ceilings = {
        "101": (1, 130, 130),
        "102": (1, 130, 130),
        "103": (1, 130, 130),
        "104": (1, 30, 30),
        "105": (1, 130, 130),
        "111": (1, 130, 130),
        "112": (1, 30, 30),
        "113": (1, 130, 130),
        "114": (1, 130, 130),
        "115": (1, 30, 30),
        "116": (1, 130, 130),
        "117": (1, 130, 130),
        "118": (1, 130, 130),
        "119": (1, 130, 130),
        "120": (1, 30, 30),
        "121": (1, 130, 130),
        "122": (1, 130, 130),
        "123": (1, 30, 30),
        "124": (1, 130, 130),
        "125": (1, 130, 130),
        "201": (1, 130, 130),
        "202": (1, 130, 130),
        "203": (1, 130, 130),
        "204": (1, 130, 130),
        "205": (1, 130, 130),
        "206": (1, 130, 130),
        "207": (1, 130, 130),
        "301": (30, 130, 101),
        "302": (1, 5, 5),
        "305": (1, 11, 11),
    }

    total_levels = 0
    for bid, (exp_min, exp_max, exp_count) in expected_ceilings.items():
        b_levels = data[bid]
        act_count = len(b_levels)
        total_levels += act_count
        int_keys = [int(k) for k in b_levels.keys()]
        act_min = min(int_keys)
        act_max = max(int_keys)
        assert act_min == exp_min, f"BID {bid} min level mismatch: expected {exp_min}, got {act_min}"
        assert act_max == exp_max, f"BID {bid} max level mismatch: expected {exp_max}, got {act_max}"
        assert act_count == exp_count, f"BID {bid} count mismatch: expected {exp_count}, got {act_count}"
        assert sorted(int_keys) == list(range(exp_min, exp_max + 1)), f"BID {bid} has level gaps!"

    assert total_levels == 3127, f"Expected 3127 total levels, got {total_levels}"
    print(f"  PASS: Total levels across all 30 buildings = {total_levels} (exactly matches 3,127 expected).")

    # 3. Corrupted keys check
    print("\n[Test 3] Corrupted Keys Elimination Check...")
    corrupt_candidates = ["420000", "450000", "640000", "880000", "1350", "260", "270", "280", "290", "580", "64500"]
    for bid, b_levels in data.items():
        for bad_k in corrupt_candidates:
            assert bad_k not in b_levels, f"Found corrupted key '{bad_k}' in building {bid}!"
        for k in b_levels.keys():
            assert k.isdigit(), f"Non-numeric level key '{k}' found in building {bid}!"
            assert 1 <= int(k) <= 130, f"Out-of-range level key '{k}' found in building {bid}!"
    print(f"  PASS: 0 corrupted keys found. All keys strictly between 1 and 130.")

    # 4. Schema and Type Integrity Check
    print("\n[Test 4] Schema & Data Field Integrity Check...")
    for bid, b_levels in data.items():
        for lv_str, lv_data in b_levels.items():
            assert "preCond" in lv_data, f"Missing preCond in {bid}:{lv_str}"
            assert "costRes" in lv_data, f"Missing costRes in {bid}:{lv_str}"
            assert "costTools" in lv_data, f"Missing costTools in {bid}:{lv_str}"
            assert "costWEs" in lv_data, f"Missing costWEs in {bid}:{lv_str}"
            assert "costTime" in lv_data, f"Missing costTime in {bid}:{lv_str}"

            # Validate preCond types
            for p_bid, p_lv in lv_data["preCond"].items():
                assert isinstance(p_bid, str) and p_bid.isdigit(), f"Invalid preCond bid {p_bid} in {bid}:{lv_str}"
                assert isinstance(p_lv, int) and p_lv > 0, f"Invalid preCond level {p_lv} in {bid}:{lv_str}"

            # Validate costRes types
            for r_id, r_amt in lv_data["costRes"].items():
                assert isinstance(r_id, str) and r_id.isdigit(), f"Invalid costRes id {r_id} in {bid}:{lv_str}"
                assert isinstance(r_amt, int) and r_amt > 0, f"Invalid costRes amount {r_amt} in {bid}:{lv_str}"

            # Validate costTools types
            for t_id, t_count in lv_data["costTools"].items():
                assert isinstance(t_id, str) and t_id.isdigit(), f"Invalid costTools id {t_id} in {bid}:{lv_str}"
                assert isinstance(t_count, int) and t_count > 0, f"Invalid costTools count {t_count} in {bid}:{lv_str}"

            # Validate costWEs types
            for w_id, w_count in lv_data["costWEs"].items():
                assert isinstance(w_id, str) and w_id.isdigit(), f"Invalid costWEs id {w_id} in {bid}:{lv_str}"
                assert isinstance(w_count, int) and w_count > 0, f"Invalid costWEs count {w_count} in {bid}:{lv_str}"

            assert isinstance(lv_data["costTime"], int) and lv_data["costTime"] >= 0, f"Invalid costTime in {bid}:{lv_str}"

    print("  PASS: All 3,127 level schemas, types, and values are 100% compliant.")

    # 5. Milestone Specific Spot Checks
    print("\n[Test 5] Milestone 1 Specific Spot Checks...")
    
    # Castle 40
    c40 = data["101"]["40"]
    assert c40["preCond"] == {"102": 30, "301": 30}, f"Castle 40 prereqs mismatch: {c40['preCond']}"
    assert c40["costWEs"] == {"301101": 100}, f"Castle 40 costWEs mismatch: {c40['costWEs']}"
    assert c40["costTime"] == 241200, f"Castle 40 costTime mismatch: {c40['costTime']}"
    print("  PASS: Castle Lv 40 correctly requires Walls Lv 30 and Sultan's Glory Lv 30, +100 War Badges.")

    # Castle 50
    c50 = data["101"]["50"]
    assert c50["preCond"] == {"102": 40, "301": 40}, f"Castle 50 prereqs mismatch: {c50['preCond']}"
    assert c50["costWEs"] == {"301101": 280}, f"Castle 50 costWEs mismatch: {c50['costWEs']}"
    print("  PASS: Castle Lv 50 correctly requires Walls Lv 40 and Sultan's Glory Lv 40, +280 War Badges.")

    # Walls 35 (resolving missing > 34)
    w35 = data["102"]["35"]
    assert w35["preCond"] == {"101": 40}, f"Walls 35 prereqs mismatch: {w35['preCond']}"
    assert w35["costWEs"] == {"301101": 15}, f"Walls 35 costWEs mismatch: {w35['costWEs']}"
    assert w35["costTime"] == 100800, f"Walls 35 costTime mismatch: {w35['costTime']}"
    print("  PASS: Walls Lv 35 correctly populated (resolving missing > 34 gap) requiring Castle Lv 40.")

    # Walls 50
    w50 = data["102"]["50"]
    assert w50["preCond"] == {"101": 50}, f"Walls 50 prereqs mismatch: {w50['preCond']}"
    assert w50["costWEs"] == {"301101": 84}, f"Walls 50 costWEs mismatch: {w50['costWEs']}"
    print("  PASS: Walls Lv 50 correctly requires Castle Lv 50, +84 War Badges.")

    # Embassy 29 & 30 (resolving missing > 28)
    e29 = data["111"]["29"]
    e30 = data["111"]["30"]
    e31 = data["111"]["31"]
    assert e29["preCond"] == {"101": 29}, f"Embassy 29 prereqs mismatch: {e29['preCond']}"
    assert e30["preCond"] == {"101": 30}, f"Embassy 30 prereqs mismatch: {e30['preCond']}"
    assert e31["preCond"] == {"101": 40}, f"Embassy 31 prereqs mismatch: {e31['preCond']}"
    assert e31["costWEs"] == {"301101": 3}, f"Embassy 31 costWEs mismatch: {e31['costWEs']}"
    print("  PASS: Embassy Lv 29, 30, 31 correctly populated (resolving missing > 28 gap).")

    # Sultan's Glory 31
    g31 = data["301"]["31"]
    assert g31["preCond"] == {"101": 40, "111": 40}, f"Glory 31 prereqs mismatch: {g31['preCond']}"
    assert g31["costWEs"] == {"301101": 3}, f"Glory 31 costWEs mismatch: {g31['costWEs']}"
    print("  PASS: Sultan's Glory Lv 31 correctly requires Castle Lv 40 and Embassy Lv 40.")

    # Defense Turret (103) Lv 1 costTools
    t1 = data["103"]["1"]
    assert t1["costTools"] == {"300501": 1}, f"Defense Turret 1 costTools mismatch: {t1['costTools']}"
    print("  PASS: Defense Turret Lv 1 has correct tool requirement {'300501': 1} (Golden Arrows).")

    # 6. Integration Test with tasks/building.py
    print("\n[Test 6] Integration with tasks/building.py...")
    sys.path.insert(0, workspace_root)
    # Clear cache if any
    import tasks.building as tb
    tb._BUILDINGS_CONFIG_CACHE = None
    all_cfg = tb.load_all_building_configs()
    assert len(all_cfg) == 30, f"tasks.building loaded {len(all_cfg)} buildings, expected 30"
    
    cfg_c40 = tb.get_building_level_config("101", 40)
    assert cfg_c40.get("preCond") == {"102": 30, "301": 30}, "tasks.building get_building_level_config mismatch for Castle 40"
    
    cfg_w35 = tb.get_building_level_config("102", 35)
    assert cfg_w35.get("preCond") == {"101": 40}, "tasks.building get_building_level_config mismatch for Walls 35"
    
    cfg_e35 = tb.get_building_level_config("111", 35)
    assert cfg_e35.get("preCond") == {"101": 40}, "tasks.building get_building_level_config mismatch for Embassy 35"
    
    print("  PASS: tasks.building.load_all_building_configs and get_building_level_config work seamlessly!")

    print("\n============================================================")
    print("ALL VERIFICATION CHECKS PASSED PERFECTLY (100% SUCCESS)!")
    print("============================================================")

if __name__ == "__main__":
    verify_buildings_prereqs()
