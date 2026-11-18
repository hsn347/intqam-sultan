# -*- coding: utf-8 -*-
"""
tools/migrate_stamina_config.py — ترحيل قاعدة البيانات لتحديث إعدادات تعويض طاقة اللورد (stamina)
══════════════════════════════════════════════════════════════════════════════════════════════
يضمن هذا السكربت تحديث كافة سجلات القلاع في جدول castle_states داخل قاعدة البيانات
المحلية database/castles.db بالهيكل الجديد لمهمة stamina:
{
    "enabled": False,
    "gold_buy_enabled": False,
    "gold_trigger_stamina": 50,
    "gold_buy_stamina_amount": 50
}
مع تنظيف أي حقول قديمة وتطبيق بروتوكول حماية قاعدة البيانات (Rule 5 Zero-Loss Protocol).
"""

import json
import os
import sqlite3
import sys

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

DEFAULT_STAMINA_CONFIG = {
    "enabled": False,
    "gold_buy_enabled": False,
    "gold_trigger_stamina": 50,
    "gold_buy_stamina_amount": 50,
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

        # معالجة كائن stamina في الجذر
        old_root = cfg.get("stamina", {})
        if not isinstance(old_root, dict):
            old_root = {}

        new_stamina_root = {
            "enabled": bool(old_root.get("enabled", DEFAULT_STAMINA_CONFIG["enabled"])),
            "gold_buy_enabled": bool(old_root.get("gold_buy_enabled", DEFAULT_STAMINA_CONFIG["gold_buy_enabled"])),
            "gold_trigger_stamina": int(old_root.get("gold_trigger_stamina", DEFAULT_STAMINA_CONFIG["gold_trigger_stamina"])),
            "gold_buy_stamina_amount": int(old_root.get("gold_buy_stamina_amount", DEFAULT_STAMINA_CONFIG["gold_buy_stamina_amount"])),
        }

        if old_root != new_stamina_root:
            cfg["stamina"] = new_stamina_root
            needs_update = True

        # معالجة كائن stamina داخل tasks الفرعي
        tasks_dict = cfg.setdefault("tasks", {})
        if not isinstance(tasks_dict, dict):
            tasks_dict = {}
            cfg["tasks"] = tasks_dict
            needs_update = True

        old_tasks_stamina = tasks_dict.get("stamina", {})
        if not isinstance(old_tasks_stamina, dict):
            old_tasks_stamina = {}

        new_stamina_tasks = {
            "enabled": bool(old_tasks_stamina.get("enabled", new_stamina_root["enabled"])),
            "gold_buy_enabled": bool(old_tasks_stamina.get("gold_buy_enabled", new_stamina_root["gold_buy_enabled"])),
            "gold_trigger_stamina": int(old_tasks_stamina.get("gold_trigger_stamina", new_stamina_root["gold_trigger_stamina"])),
            "gold_buy_stamina_amount": int(old_tasks_stamina.get("gold_buy_stamina_amount", new_stamina_root["gold_buy_stamina_amount"])),
        }

        if old_tasks_stamina != new_stamina_tasks:
            tasks_dict["stamina"] = new_stamina_tasks
            needs_update = True

        if needs_update:
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), castle_id),
            )
            updated_count += 1
            print(f"✓ Updated castle: {email} ({castle_id}) -> {new_stamina_root}")

    conn.commit()
    conn.close()
    print(f"\nMigration completed successfully. Updated {updated_count}/{len(rows)} castles.")


def verify():
    """فحص فعلي مباشر للتأكد بنسبة 100% أن مفتاح stamina موجود بالهيكل الجديد في كل القلاع (Rule 5)."""
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
        stamina_cfg = cfg.get("stamina", {})
        tasks_stamina = cfg.get("tasks", {}).get("stamina", {})

        is_valid = True
        for k in ("enabled", "gold_buy_enabled", "gold_trigger_stamina", "gold_buy_stamina_amount"):
            if k not in stamina_cfg or k not in tasks_stamina:
                is_valid = False
                break

        if has_root and has_tasks and is_valid:
            print(f"✓ Castle '{email}' [{castle_id}] stamina config verified: {stamina_cfg}")
        else:
            print(f"❌ Castle '{email}' [{castle_id}] INVALID stamina config! root={stamina_cfg}, tasks={tasks_stamina}")
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
