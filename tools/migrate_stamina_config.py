# -*- coding: utf-8 -*-
"""
tools/migrate_stamina_config.py — ترحيل قاعدة البيانات لإضافة إعدادات تعويض طاقة اللورد (stamina)
══════════════════════════════════════════════════════════════════════════════════════════════
يضمن هذا السكربت تحديث كافة سجلات القلاع في جدول castle_states داخل قاعدة البيانات
المحلية database/castles.db بإدراج مفتاح stamina وقيمه الافتراضية لمنع أي فقدان للبيانات.
"""

import json
import os
import sqlite3
import sys

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

DEFAULT_STAMINA_CONFIG = {
    "enabled": False,
    "min_stamina": 100,
    "mode": "auto",
    "pack_tier": "50",
    "pack_count": 1,
    "allow_buy": False,
    "max_gold_daily": 1000,
}


def migrate():
    print(f"Connecting to database: {DB_PATH}")
    if not os.path.exists(DB_PATH):
        print(f"Error: Database file not found at {DB_PATH}")
        sys.exit(1)

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"Total castles found: {len(rows)}")

    updated_count = 0

    for castle_id, email, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception:
            cfg = {}

        needs_update = False

        if "stamina" not in cfg:
            cfg["stamina"] = dict(DEFAULT_STAMINA_CONFIG)
            needs_update = True
        else:
            # التأكد من اكتمال كافة الحقول الافتراضية
            for k, v in DEFAULT_STAMINA_CONFIG.items():
                if k not in cfg["stamina"]:
                    cfg["stamina"][k] = v
                    needs_update = True

        tasks_dict = cfg.setdefault("tasks", {})
        if not isinstance(tasks_dict, dict):
            tasks_dict = {}
            cfg["tasks"] = tasks_dict
            needs_update = True

        if "stamina" not in tasks_dict:
            tasks_dict["stamina"] = dict(DEFAULT_STAMINA_CONFIG)
            needs_update = True
        else:
            for k, v in DEFAULT_STAMINA_CONFIG.items():
                if k not in tasks_dict["stamina"]:
                    tasks_dict["stamina"][k] = v
                    needs_update = True

        if needs_update:
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), castle_id),
            )
            updated_count += 1
            print(f"✓ Updated castle: {email} ({castle_id})")

    conn.commit()
    conn.close()
    print(f"\nMigration completed successfully. Updated {updated_count}/{len(rows)} castles.")


def verify():
    """فحص فعلي مباشر للتأكد بنسبة 100% أن مفتاح stamina موجود في كل القلاع (Rule 5)."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    all_valid = True
    print("\n--- Verifying database records ---")
    for castle_id, email, config_raw in rows:
        cfg = json.loads(config_raw) if config_raw else {}
        has_root = "stamina" in cfg
        has_tasks = "stamina" in cfg.get("tasks", {})
        if has_root and has_tasks:
            stamina_cfg = cfg["stamina"]
            print(f"✓ Castle '{email}' [{castle_id}] stamina config verified: {stamina_cfg}")
        else:
            print(f"❌ Castle '{email}' [{castle_id}] MISSING stamina config! root={has_root}, tasks={has_tasks}")
            all_valid = False
    conn.close()
    return all_valid


if __name__ == "__main__":
    migrate()
    if verify():
        print("\n[SUCCESS] 100% of castles have verified stamina config!")
    else:
        print("\n[FAILED] Verification failed for one or more castles!")
        sys.exit(1)
