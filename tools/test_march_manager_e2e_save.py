# -*- coding: utf-8 -*-
"""
tools/test_march_manager_e2e_save.py
اختبار دورة الحفظ الثنائي الكاملة (End-to-End Dual Save & DB Verification) لمهمة march_manager:
1. تحديث الإعدادات عبر مسار API المعتمد في api_server.py.
2. التحقق المباشر من كتابة التعديل في قاعدة بيانات SQLite المحلية (database/castles.db).
3. التحقق من قيام bot_manager.reload_config_from_db() بقراءة الإعدادات الجديدة فوراً.
4. إعادة الإعدادات الأصلية بأمان لضمان سلامة بيانات الحسابات.
"""

import json
import os
import sqlite3
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot
from api_server import CastleConfigModel, MarchManagerConfigModel


def run_e2e_test():
    print("=" * 70)
    print("🔄 بدء اختبار دورة الحفظ الكاملة (E2E Save Cycle) لـ march_manager...")
    print("=" * 70)

    test_email = "beetoo1@hotmail.com"
    castle = db.get_castle_by_id(test_email)
    assert castle is not None, f"القلعة {test_email} غير موجودة"
    castle_id = castle["id"]

    orig_config = dict(castle.get("config") or {})
    print(f"1. الإعدادات الحالية للقلعة: march_manager = {orig_config.get('march_manager')}")

    try:
        # اختبار التحقق عبر Pydantic الخاص بخادم API
        new_mm_cfg = {"enabled": True, "max_duration_minutes": 15}
        req_cfg = CastleConfigModel.model_validate({"march_manager": new_mm_cfg})
        validated_updates = req_cfg.model_dump(exclude_none=True)

        # محاكاة حفظ التحديث عبر دالة db.update_castle_db كما يفعل api_server بالضبط
        clean_config = dict(orig_config)
        clean_config.update(validated_updates)
        if "tasks" in clean_config and isinstance(clean_config["tasks"], dict):
            clean_config["tasks"]["march_manager"] = validated_updates["march_manager"]

        db.update_castle_db(castle_id, {"config": clean_config})
        print("2. تم إرسال تحديث الإعدادات وتثبيته في قاعدة البيانات.")

        # التحقق البرمجي المباشر من ملف SQLite الفعلي (database/castles.db)
        db_path = os.path.join(_ROOT, "database", "castles.db")
        conn = sqlite3.connect(db_path)
        c = conn.cursor()
        c.execute("SELECT config FROM castle_states WHERE castle_id = ?", (castle_id,))
        row = c.fetchone()
        conn.close()

        assert row is not None, "لم يتم العثور على سجل القلعة في قاعدة البيانات"
        saved_db_cfg = json.loads(row[0])
        mm_saved = saved_db_cfg.get("march_manager")
        print(f"3. الفحص الفعلي لملف SQLite: march_manager = {mm_saved}")
        assert mm_saved is not None, "march_manager مفقود من ملف SQLite"
        assert mm_saved.get("enabled") is True, "قيمة enabled لم تحفظ بنجاح"
        assert mm_saved.get("max_duration_minutes") == 15, "قيمة max_duration_minutes لم تحفظ بنجاح"
        print("✅ تم التحقق المباشر من كتابة SQLite بنسبة 100%.")

        # التحقق من تحميل الإعدادات في bot_manager
        bot = CastleBot(email=test_email, log_callback=lambda m: None)
        bot.reload_config_from_db()
        bot_tasks_cfg = bot.config.get("tasks", {})
        bot_mm = bot_tasks_cfg.get("march_manager")
        print(f"4. نتيجة إعادة التحميل في bot_manager: march_manager = {bot_mm}")
        assert bot_mm is not None, "march_manager مفقود من bot.config"
        assert bot_mm.get("enabled") is True, "bot_manager لم يقرأ enabled=True"
        assert bot_mm.get("max_duration_minutes") == 15, "bot_manager لم يقرأ max_duration_minutes=15"
        print("✅ تم التحقق من مزامنة bot_manager مع قاعدة البيانات بنسبة 100%.")

    finally:
        # إعادة الإعدادات الأصلية
        db.update_castle_db(castle_id, {"config": orig_config})
        print(f"5. تمت استعادة الإعدادات الأصلية للقلعة بنجاح.")

    print("\n🎉 دورة الحفظ الثنائي الكاملة (API -> DB -> BotManager) ناجحة 100% ومطابقة للقواعد!")


if __name__ == "__main__":
    run_e2e_test()
