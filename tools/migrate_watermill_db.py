# -*- coding: utf-8 -*-
"""
tools/migrate_watermill_db.py — سكربت ترحيل وتدقيق قاعدة البيانات لمهمة مكافأة الحقول (Watermill)
══════════════════════════════════════════════════════════════════════════════════════════════════
يطبق بروتوكول حماية قاعدة البيانات (Zero-Loss Protocol):
1. يفحص كافة القلاع في جدول castle_states داخل database/castles.db.
2. يضمن وجود مفتاح watermill بكامل خصائصه المحدثة (بما في ذلك دعم crystal).
3. يتحقق بنسبة 100% عبر قراءة مباشرة من القرص وطباعة النتيجة.
"""

import json
import sqlite3
import sys

DB_PATH = "database/castles.db"

DEFAULT_WATERMILL = {
    "enabled": False,
    "resources": ["food", "wood", "iron", "silver", "crystal"],
    "types": "all",
    "allow_shop_buy": False,
}

def migrate():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"📊 Found {len(rows)} castles in database.")

    updated_count = 0
    for email, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception as e:
            print(f"⚠️ Error parsing JSON for {email}: {e}")
            cfg = {}

        wm = cfg.get("watermill")
        needs_update = False

        if not isinstance(wm, dict):
            cfg["watermill"] = dict(DEFAULT_WATERMILL)
            needs_update = True
        else:
            # التأكد من وجود crystal في resources
            res = wm.get("resources")
            if not isinstance(res, list):
                wm["resources"] = ["food", "wood", "iron", "silver", "crystal"]
                needs_update = True
            else:
                if "crystal" not in res:
                    res.append("crystal")
                    needs_update = True

            if "enabled" not in wm:
                wm["enabled"] = False
                needs_update = True
            if "types" not in wm:
                wm["types"] = "all"
                needs_update = True
            if "allow_shop_buy" not in wm:
                wm["allow_shop_buy"] = False
                needs_update = True

        if needs_update:
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE email = ?",
                (json.dumps(cfg, ensure_ascii=False), email)
            )
            updated_count += 1

    conn.commit()
    print(f"✅ Migration complete: updated {updated_count} castles.")

    # فحص مباشر إلزامي (Direct DB Inspection)
    print("\n🔍 Direct DB Verification:")
    cursor.execute("SELECT email, config FROM castle_states")
    verified_rows = cursor.fetchall()
    all_ok = True
    for email, config_raw in verified_rows:
        cfg = json.loads(config_raw)
        wm = cfg.get("watermill", {})
        res = wm.get("resources", [])
        is_ok = isinstance(wm, dict) and "crystal" in res and "food" in res
        status = "✅ OK" if is_ok else "❌ MISSING"
        if not is_ok:
            all_ok = False
        print(f"  [{status}] {email}: watermill = {wm}")

    conn.close()
    if not all_ok:
        print("❌ Error: Some castles failed verification!")
        sys.exit(1)
    else:
        print("\n🎉 Zero-Loss Protocol Passed 100%! All castles verified.")

if __name__ == "__main__":
    migrate()
