import os
import re

CONFIG_DIR = r"E:\intqam-sultan\game_file\src\app\localtb\config_server"

def scan_as_powers():
    as_lv = os.path.join(CONFIG_DIR, "alliance_science_lv.lua")
    with open(as_lv, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    # Each entry in alliance_science_lv has:
    # ;(nil).id = <id>
    # ;(nil).level = <lv>
    # ;(nil).technologyPower = "<power>"
    
    entries = re.findall(r';\(nil\)\.id\s*=\s*(\d+)\s*;\(nil\)\.level\s*=\s*(\d+)\s*;\(nil\)\.technologyPower\s*=\s*"([^"]+)"', content)
    print(f"Total entries parsed: {len(entries)}")
    
    # Beetoo1 sciences:
    # Group 1: 31005 (lv 5), 31001 (lv 4), 31002 (lv 4), 31003 (lv 5), 31004 (lv 6)
    # Group 2: 32001 (lv 4), 32005 (lv 5), 32011 (lv 1)
    beetoo_sciences = {
        31001: 4,
        31002: 4,
        31003: 5,
        31004: 6,
        31005: 5,
        32001: 4,
        32005: 5,
        32011: 1
    }
    
    print("\n--- Beetoo1 Alliance Sciences ---")
    for (sid, lv, pwr) in entries:
        sid_int = int(sid)
        lv_int = int(lv)
        if sid_int in beetoo_sciences and lv_int == beetoo_sciences[sid_int]:
            prop_type = pwr[:2]
            dtype = pwr[2:4]
            val = int(pwr[4:])
            print(f"Science ID {sid_int} Lv {lv_int}: power={pwr} -> prop_type={prop_type}, dtype={dtype}, val={val}")
            
    print("\n--- Check all science IDs that have prop_type = '43' or '96' or '05' or val >= 1000 ---")
    for (sid, lv, pwr) in entries:
        prop_type = pwr[:2]
        dtype = pwr[2:4]
        val = int(pwr[4:])
        if prop_type in ['43', '96', '05', '5']:
            print(f"Science {sid} Lv {lv}: {pwr}")

if __name__ == "__main__":
    scan_as_powers()
