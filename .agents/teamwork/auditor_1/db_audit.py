# -*- coding: utf-8 -*-
import sqlite3
import json
import sys

def audit_db():
    conn = sqlite3.connect('database/castles.db')
    cursor = conn.cursor()

    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [r[0] for r in cursor.fetchall()]
    print("TABLES:", tables)

    for t in tables:
        cursor.execute(f"SELECT count(*) FROM {t}")
        print(f"Count in {t}: {cursor.fetchone()[0]}")

    cursor.execute("SELECT email, castle_name, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"\n--- Total castles in castle_states: {len(rows)} ---")
    
    missing_count = 0
    valid_count = 0
    for email, name, cfg_raw in rows:
        try:
            cfg = json.loads(cfg_raw) if cfg_raw else {}
        except Exception as e:
            print(f"ERROR: Corrupted JSON in castle {email}: {e}")
            missing_count += 1
            continue
            
        fe = cfg.get("forge_equipment")
        if fe is None:
            print(f"MISSING: Castle {email} does not have forge_equipment")
            missing_count += 1
        elif not isinstance(fe, dict):
            print(f"INVALID TYPE: Castle {email} forge_equipment is {type(fe)}")
            missing_count += 1
        elif "enabled" not in fe or "category" not in fe:
            print(f"MISSING KEYS: Castle {email} forge_equipment = {fe}")
            missing_count += 1
        else:
            valid_count += 1
            print(f"OK: Castle {email} | Name: {name} | forge_equipment: {fe}")

    print(f"\nSummary: {valid_count} valid, {missing_count} missing/invalid out of {len(rows)} castles.")
    conn.close()

if __name__ == "__main__":
    audit_db()
