import os
import json
from test_parse import parse_lua_build_file

def compare_with_existing():
    with open(r'e:\intqam-sultan\core\buildings_prereqs.json', 'r', encoding='utf-8') as f:
        old_data = json.load(f)

    dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
    
    # We will spot check across buildings
    # For Castle 1..30:
    bid = 101
    _, new_levels = parse_lua_build_file(os.path.join(dir_path, f"build{bid}.lua"))
    
    mismatches = 0
    checked = 0
    for lv in range(1, 31):
        lv_str = str(lv)
        old_entry = old_data.get(str(bid), {}).get(lv_str)
        new_entry = new_levels.get(lv_str)
        if not old_entry or not new_entry:
            print(f"Missing lv {lv_str} in old or new!")
            mismatches += 1
            continue
        
        # Check preCond
        if old_entry.get("preCond") != new_entry.get("preCond"):
            print(f"BID {bid} Lv {lv_str} preCond mismatch: Old={old_entry.get('preCond')} vs New={new_entry.get('preCond')}")
            mismatches += 1
        
        # Check costRes
        if old_entry.get("costRes") != new_entry.get("costRes"):
            print(f"BID {bid} Lv {lv_str} costRes mismatch: Old={old_entry.get('costRes')} vs New={new_entry.get('costRes')}")
            mismatches += 1

        # Check costTime
        if old_entry.get("costTime") != new_entry.get("costTime"):
            print(f"BID {bid} Lv {lv_str} costTime mismatch: Old={old_entry.get('costTime')} vs New={new_entry.get('costTime')}")
            mismatches += 1

        checked += 1

    print(f"Checked {checked} levels of Castle 1..30 against existing JSON: {mismatches} mismatches.")

    # Check Walls 1..28
    bid = 102
    _, new_levels = parse_lua_build_file(os.path.join(dir_path, f"build{bid}.lua"))
    mismatches = 0
    checked = 0
    for lv in range(1, 29):
        lv_str = str(lv)
        old_entry = old_data.get(str(bid), {}).get(lv_str)
        new_entry = new_levels.get(lv_str)
        if not old_entry or not new_entry:
            print(f"Missing lv {lv_str} in old or new!")
            mismatches += 1
            continue
        
        if old_entry.get("preCond") != new_entry.get("preCond"):
            print(f"BID {bid} Lv {lv_str} preCond mismatch: Old={old_entry.get('preCond')} vs New={new_entry.get('preCond')}")
            mismatches += 1
        if old_entry.get("costRes") != new_entry.get("costRes"):
            print(f"BID {bid} Lv {lv_str} costRes mismatch: Old={old_entry.get('costRes')} vs New={new_entry.get('costRes')}")
            mismatches += 1
        if old_entry.get("costTime") != new_entry.get("costTime"):
            print(f"BID {bid} Lv {lv_str} costTime mismatch: Old={old_entry.get('costTime')} vs New={new_entry.get('costTime')}")
            mismatches += 1
        checked += 1
    print(f"Checked {checked} levels of Walls 1..28 against existing JSON: {mismatches} mismatches.")

    # Check Embassy 1..28
    bid = 111
    _, new_levels = parse_lua_build_file(os.path.join(dir_path, f"build{bid}.lua"))
    mismatches = 0
    checked = 0
    for lv in range(1, 29):
        lv_str = str(lv)
        old_entry = old_data.get(str(bid), {}).get(lv_str)
        new_entry = new_levels.get(lv_str)
        if not old_entry or not new_entry:
            print(f"Missing lv {lv_str} in old or new!")
            mismatches += 1
            continue
        
        if old_entry.get("preCond") != new_entry.get("preCond"):
            print(f"BID {bid} Lv {lv_str} preCond mismatch: Old={old_entry.get('preCond')} vs New={new_entry.get('preCond')}")
            mismatches += 1
        if old_entry.get("costRes") != new_entry.get("costRes"):
            print(f"BID {bid} Lv {lv_str} costRes mismatch: Old={old_entry.get('costRes')} vs New={new_entry.get('costRes')}")
            mismatches += 1
        if old_entry.get("costTime") != new_entry.get("costTime"):
            print(f"BID {bid} Lv {lv_str} costTime mismatch: Old={old_entry.get('costTime')} vs New={new_entry.get('costTime')}")
            mismatches += 1
        checked += 1
    print(f"Checked {checked} levels of Embassy 1..28 against existing JSON: {mismatches} mismatches.")

if __name__ == "__main__":
    compare_with_existing()
