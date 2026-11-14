# -*- coding: utf-8 -*-
"""
tools/test_arena_api_flow.py — اختبار دورة البيانات الكاملة (End-to-End API & DB Cycle)
══════════════════════════════════════════════════════════════════════════════════════
التحقق من تدفق إعدادات تحدي الحلبة عبر:
Pydantic Model -> DB Update -> Direct SQLite Read -> Bot Manager Reload
"""

import json
import os
import sqlite3
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from api_server import CastleConfigModel, ArenaConfigModel
import core.database as db
from bot_manager import CastleBot, DEFAULT_BOT_CONFIG


def test_api_pipeline():
    print("[*] بدء اختبار تدفق بيانات الحلبة عبر Pydantic و Database...")

    # 1. اختبار نموذج Pydantic والتحقق من الحقول والقيم الافتراضية والتطبيع
    arena_model = ArenaConfigModel(enabled=True, arena_type="KINGDOM", auto_claim_rewards=True)
    assert arena_model.enabled is True
    assert arena_model.arena_type == "kingdom", f"فشل التطبيع: {arena_model.arena_type}"
    assert arena_model.auto_claim_rewards is True
    print("  [✓] نموذج ArenaConfigModel وتطبيع القيم: ناجح.")

    castle_cfg = CastleConfigModel(arena=arena_model)
    dumped = castle_cfg.model_dump(exclude_none=True)
    assert "arena" in dumped
    assert dumped["arena"]["enabled"] is True
    print("  [✓] دمج النموذج داخل CastleConfigModel: ناجح.")

    # 2. اختبار القراءة والكتابة في قاعدة البيانات
    all_castles = db.get_all_castles()
    assert len(all_castles) > 0, "لا توجد قلاع في قاعدة البيانات لاختبارها"
    test_castle = all_castles[0]
    cid = test_castle["castle_id"]
    email = test_castle["email"]
    print(f"[*] اختبار القلعة المستهدفة: {email} ({cid})")

    # حفظ إعداد جديد للحلبة
    updated_cfg = dict(test_castle.get("config") or {})
    updated_cfg["arena"] = {
        "enabled": True,
        "arena_type": "global",
        "auto_claim_rewards": True,
    }
    db.update_castle_config(cid, updated_cfg)

    # 3. التحقق المباشر من ملف SQLite الحقيقي
    conn = sqlite3.connect(db.DEFAULT_DB_PATH)
    c = conn.cursor()
    c.execute("SELECT config FROM castle_states WHERE castle_id = ?", (cid,))
    row = c.fetchone()
    conn.close()

    assert row is not None
    saved_cfg = json.loads(row[0]) if isinstance(row[0], str) else row[0]
    assert "arena" in saved_cfg
    assert saved_cfg["arena"]["enabled"] is True
    assert saved_cfg["arena"]["arena_type"] == "global"
    print("  [✓] التحقق المباشر من ملف SQLite الفعلي (Zero-Loss): ناجح.")

    # 4. اختبار إعادة التحميل في CastleBot
    bot = CastleBot(email)
    bot.reload_config_from_db()
    loaded_arena = bot.config.get("tasks", {}).get("arena")
    assert loaded_arena is not None
    assert loaded_arena.get("enabled") is True
    assert loaded_arena.get("arena_type") == "global"
    print("  [✓] إعادة التحميل الفورية في CastleBot: ناجحة تماماً.")

    # إعادة الإعداد للوضع الافتراضي الآمن
    updated_cfg["arena"]["enabled"] = False
    updated_cfg["arena"]["arena_type"] = "kingdom"
    db.update_castle_config(cid, updated_cfg)
    bot.reload_config_from_db()
    print("  [✓] إعادة القلعة للحالة الافتراضية الآمنة: ناجحة.")

    print("\n[🎉] كافة اختبارات دورة الـ API وقاعدة البيانات مكتملة بنجاح بنسبة 100%!")


if __name__ == "__main__":
    test_api_pipeline()
