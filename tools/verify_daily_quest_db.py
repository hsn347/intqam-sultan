# -*- coding: utf-8 -*-
"""
tools/verify_daily_quest_db.py — فحص ترحيل قاعدة البيانات وتدقيق مهمة استلام صناديق النشاط اليومي
"""

import sqlite3
import json
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def migrate_and_verify_db():
    db_path = os.path.join("database", "castles.db")
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    
    updated_count = 0
    print(f"📊 عدد القلاع في قاعدة البيانات: {len(rows)}")
    
    for cid, email, cfg_str in rows:
        cfg = json.loads(cfg_str) if cfg_str else {}
        modified = False
        
        # التأكد من وجود المفتاح بقيمة مفعلة
        if cfg.get("daily_quest") != {"enabled": True}:
            cfg["daily_quest"] = {"enabled": True}
            modified = True
            
        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if cfg["tasks"].get("daily_quest") != {"enabled": True}:
                cfg["tasks"]["daily_quest"] = {"enabled": True}
                modified = True
                
        if modified:
            new_cfg_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute("UPDATE castle_states SET config = ? WHERE castle_id = ?", (new_cfg_str, cid))
            updated_count += 1
            print(f"  ✓ تم تحديث إعدادات القلعة: {email}")
            
    conn.commit()
    print(f"✅ تم تحديث {updated_count} قلعة.")
    
    # التحقق المباشر الصارم من قاعدة البيانات (Zero-Loss Direct DB Inspection)
    cursor.execute("SELECT email, config FROM castle_states")
    verified_rows = cursor.fetchall()
    
    all_ok = True
    for email, cfg_str in verified_rows:
        cfg = json.loads(cfg_str) if cfg_str else {}
        dq = cfg.get("daily_quest")
        if dq != {"enabled": True}:
            print(f"  ❌ فشل التحقق للقلعة: {email} -> {dq}")
            all_ok = False
        else:
            print(f"  ✅ قلعة {email}: daily_quest = {dq} (مفعلة بنجاح)")
            
    conn.close()
    assert all_ok, "فشل فحص قاعدة البيانات المباشر!"
    print("\n🎉 كافة القلاع في database/castles.db محصنة بنسبة 100%!")

if __name__ == "__main__":
    migrate_and_verify_db()
