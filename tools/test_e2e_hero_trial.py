# -*- coding: utf-8 -*-
"""
tools/test_e2e_hero_trial.py — اختبار دورة الحفظ المتكاملة (End-to-End Verification)
══════════════════════════════════════════════════════════════════════════════════
يختبر انتقال البيانات بسلاسة:
API/Database -> SQLite كتابة وقراءة -> bot_manager.reload_config_from_db()
"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import core.database as db
from bot_manager import CastleBot


def test_e2e():
    print("Testing End-to-End cycle for hero_trial...")
    test_email = "beetoo1@hotmail.com"

    castle = db.get_castle_by_id(test_email)
    assert castle is not None, f"Castle {test_email} not found!"

    # 1. تحديث الإعداد بتمكين hero_trial
    curr_cfg = dict(castle.get("config") or {})
    curr_cfg["hero_trial"] = {"enabled": True}
    db.update_castle_db(test_email, {"config": curr_cfg})

    # 2. الفحص المباشر من قاعدة البيانات
    reloaded_castle = db.get_castle_by_id(test_email)
    reloaded_cfg = reloaded_castle.get("config") or {}
    assert reloaded_cfg.get("hero_trial", {}).get("enabled") is True, "DB did not retain hero_trial=True"
    print("✓ Step 1 & 2 passed: Database successfully stored and verified hero_trial=True")

    # 3. التحقق من تحميل الإعداد في bot_manager
    bot = CastleBot(test_email)
    bot.reload_config_from_db()
    task_cfg = bot.config.get("tasks", {}).get("hero_trial", {})
    assert task_cfg.get("enabled") is True, f"bot_manager did not load hero_trial=True! config={bot.config.get('tasks', {})}"
    print("✓ Step 3 passed: bot_manager.reload_config_from_db() successfully loaded hero_trial=True")

    # 4. إعادة الإعداد لحالته الأصلية
    curr_cfg["hero_trial"] = {"enabled": False}
    db.update_castle_db(test_email, {"config": curr_cfg})
    bot.reload_config_from_db()
    assert bot.config.get("tasks", {}).get("hero_trial", {}).get("enabled") is False
    print("✓ Step 4 passed: Cleanly restored hero_trial=False")

    print("\nEnd-to-End Cycle Verification: 100% SUCCESS!")


if __name__ == "__main__":
    test_e2e()

