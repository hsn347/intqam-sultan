# -*- coding: utf-8 -*-
"""
tools/verify_skills_db.py — فحص مباشر وتدقيق 100% لوجود مفتاح skills في قاعدة البيانات
"""

import json
import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

def verify():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    
    all_ok = True
    print(f"=== DB SKILLS VERIFICATION REPORT ===")
    for castle_id, email, cfg_raw in rows:
        cfg = json.loads(cfg_raw)
        has_root_skills = "skills" in cfg
        has_tasks_skills = "skills" in cfg.get("tasks", {})
        skills_val = cfg.get("skills")
        
        ok = has_root_skills and isinstance(skills_val, dict) and "enabled" in skills_val and "target_skills" in skills_val
        print(f"Castle {email} ({castle_id}): {'✅ PASS' if ok else '❌ FAIL'}")
        print(f"   Root skills: {skills_val}")
        print(f"   Tasks skills: {cfg.get('tasks', {}).get('skills')}")
        if not ok:
            all_ok = False
            
    conn.close()
    if all_ok:
        print("\n🎉 ALL CASTLES VERIFIED 100% WITH VALID SKILLS CONFIG!")
    else:
        print("\n❌ SOME CASTLES FAILED VERIFICATION!")
    return all_ok

if __name__ == "__main__":
    verify()
