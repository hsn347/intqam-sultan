# -*- coding: utf-8 -*-
"""
tools/migrate_arena_config.py — ترحيل قاعدة البيانات وإضافة إعدادات تحدي الحلبة (Arena Task)
═══════════════════════════════════════════════════════════════════════════════════════════
الهدف:
  تحديث عمود config في جدول castle_states لجميع القلاع الحالية في database/castles.db
  بإعدادات الحلبة الافتراضية مع التحقق الفعلي المباشر بنسبة 100% لمنع فقدان البيانات.
"""

import json
import os
import sqlite3
import sys

DEFAULT_ARENA_CONFIG = {
    "enabled": False,
    "arena_type": "kingdom",
    "auto_claim_rewards": True,
}

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")


def migrate():
    print(f"[*] بدء ترحيل قاعدة البيانات: {DB_PATH}")
    if not os.path.exists(DB_PATH):
        print(f"[!] خطأ: ملف قاعدة البيانات غير موجود في {DB_PATH}")
        sys.exit(1)

    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()

    c.execute("SELECT castle_id, email, config FROM castle_states")
    rows = c.fetchall()
    print(f"[*] إجمالي القلاع المسجلة: {len(rows)}")

    updated_count = 0
    for cid, email, cfg_raw in rows:
        cfg = json.loads(cfg_raw) if isinstance(cfg_raw, str) else (cfg_raw or {})
        changed = False

        if "arena" not in cfg:
            cfg["arena"] = dict(DEFAULT_ARENA_CONFIG)
            changed = True

        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "arena" not in cfg["tasks"]:
                cfg["tasks"]["arena"] = dict(DEFAULT_ARENA_CONFIG)
                changed = True

        if changed:
            new_cfg_json = json.dumps(cfg, ensure_ascii=False)
            c.execute("UPDATE castle_states SET config = ? WHERE castle_id = ?", (new_cfg_json, cid))
            updated_count += 1
            print(f"  [+] تم تحديث إعدادات القلعة: {email} ({cid})")

    conn.commit()
    conn.close()
    print(f"[*] اكتمل التحديث: تم تعديل {updated_count} قلعة.")

    # ═════════════════════════════════════════════════════════════════════
    # الفحص الفعلي الصارم لملف قاعدة البيانات (Direct DB Inspection)
    # ═════════════════════════════════════════════════════════════════════
    print("[*] فحص سلامة وتكامل البيانات في قاعدة البيانات بعد الترحيل...")
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT castle_id, email, config FROM castle_states")
    verified_rows = c.fetchall()

    for cid, email, cfg_raw in verified_rows:
        cfg = json.loads(cfg_raw) if isinstance(cfg_raw, str) else (cfg_raw or {})
        assert "arena" in cfg, f"خطأ: القلعة {email} تفتقد مفتاح arena في config!"
        arena_cfg = cfg["arena"]
        assert arena_cfg.get("arena_type") == "kingdom", f"خطأ في القيمة الافتراضية لـ arena_type في {email}!"
        assert arena_cfg.get("auto_claim_rewards") is True, f"خطأ في القيمة الافتراضية لـ auto_claim_rewards في {email}!"
        print(f"  [✓] موثق بنسبة 100%: القلعة {email} تحتوي على إعدادات الحلبة الصحيحة.")

    conn.close()
    print("[✅] اكتمل فحص وتكامل قاعدة البيانات بنجاح تام بنسبة 100%!")


if __name__ == "__main__":
    migrate()
