# -*- coding: utf-8 -*-
"""
tools/migrate_and_verify_march_manager.py
سكربت الترحيل والتحقق الفعلي الصارم لقاعدة البيانات لمهمة march_manager:
1. يقرأ سجلات القلاع من جدول castle_states في database/castles.db.
2. يدمج الإعدادات الافتراضية لمهمة march_manager (enabled: False, max_duration_minutes: 20)
   لكافة القلاع مع الحفاظ التام على باقي الإعدادات الموجودة مسبقاً.
3. يجري فحصاً برمجياً مباشراً للتحقق بنسبة 100% من وجود المفتاح في ملف قاعدة البيانات الفعلي.
"""

import json
import os
import sqlite3
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_DB_PATH = os.path.join(_ROOT, "database", "castles.db")


def migrate_march_manager():
    if not os.path.exists(_DB_PATH):
        print(f"❌ ملف قاعدة البيانات غير موجود في: {_DB_PATH}")
        sys.exit(1)

    conn = sqlite3.connect(_DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"📊 عدد القلاع المسجلة في قاعدة البيانات: {len(rows)}")

    updated_count = 0
    default_mm_config = {
        "enabled": False,
        "max_duration_minutes": 20,
    }

    for row in rows:
        cid = row["castle_id"]
        email = row["email"]
        raw_cfg = row["config"]
        try:
            cfg = json.loads(raw_cfg) if raw_cfg else {}
        except Exception:
            cfg = {}

        needs_update = False
        if "march_manager" not in cfg:
            cfg["march_manager"] = default_mm_config.copy()
            needs_update = True
        else:
            # التأكد من اكتمال الحقول الافتراضية
            if not isinstance(cfg["march_manager"], dict):
                cfg["march_manager"] = default_mm_config.copy()
                needs_update = True
            else:
                if "enabled" not in cfg["march_manager"]:
                    cfg["march_manager"]["enabled"] = False
                    needs_update = True
                if "max_duration_minutes" not in cfg["march_manager"]:
                    cfg["march_manager"]["max_duration_minutes"] = 20
                    needs_update = True

        # الحفاظ على tasks الفرعي إن وجد
        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "march_manager" not in cfg["tasks"]:
                cfg["tasks"]["march_manager"] = default_mm_config.copy()
                needs_update = True

        if needs_update:
            new_cfg_json = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (new_cfg_json, cid),
            )
            updated_count += 1
            print(f"  ✓ تم تحديث القلعة: {email} (ID: {cid})")

    conn.commit()
    print(f"💾 تم حفظ التعديلات في قاعدة البيانات: {updated_count} قلاع تم تحديثها.")

    # ═════════════════════════════════════════════════════════════════════════
    # التدقيق الفعلي الصارم (Strict Direct DB Inspection - Rule 5)
    # ═════════════════════════════════════════════════════════════════════════
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    verify_rows = cursor.fetchall()
    conn.close()

    all_verified = True
    print("\n🔍 نتيجة الفحص البرمجي المباشر لملف database/castles.db الفعلي:")
    for row in verify_rows:
        cid = row["castle_id"]
        email = row["email"]
        cfg = json.loads(row["config"]) if row["config"] else {}
        mm = cfg.get("march_manager")
        if isinstance(mm, dict) and "enabled" in mm and "max_duration_minutes" in mm:
            print(f"  ✅ [نجاح] {email}: march_manager موجود بالقيم الافتراضية -> {mm}")
        else:
            print(f"  ❌ [فشل] {email}: march_manager غير موجود أو غير مكتمل!")
            all_verified = False

    if all_verified:
        print("\n🎉 تم التحقق بنسبة 100%: كل القلاع في قاعدة البيانات تحتوي على march_manager.")
    else:
        print("\n❌ فشل التحقق في بعض القلاع!")
        sys.exit(1)


if __name__ == "__main__":
    migrate_march_manager()
