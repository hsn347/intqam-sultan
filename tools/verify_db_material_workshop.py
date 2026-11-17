# -*- coding: utf-8 -*-
import sqlite3
import json
import os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

def verify():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()

    all_ok = True
    print(f"Total castles checked: {len(rows)}")
    for cid, em, cfg_raw in rows:
        cfg = json.loads(cfg_raw) if cfg_raw else {}
        mw = cfg.get("material_workshop")
        tasks_mw = cfg.get("tasks", {}).get("material_workshop")
        print(f"Castle: {em} ({cid})")
        print(f"  root material_workshop: {mw}")
        print(f"  tasks material_workshop: {tasks_mw}")

        if not mw or not tasks_mw:
            all_ok = False
            print("  -> ERROR: Missing material_workshop config!")
        elif mw.get("enabled") is not False or not isinstance(mw.get("selected_materials"), list):
            all_ok = False
            print("  -> ERROR: Invalid config values!")
        else:
            print("  -> OK")

    conn.close()
    if all_ok:
        print("\n=== ALL CASTLES VERIFIED 100% OK ===")
    else:
        print("\n=== VERIFICATION FAILED ===")
        raise SystemExit(1)

if __name__ == "__main__":
    verify()
