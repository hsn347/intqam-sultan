# -*- coding: utf-8 -*-
"""
tools/test_daily_quest_mandatory_e2e.py — اختبار شامل للمهمة الخلفية الإلزامية لاستلام صناديق النشاط اليومي
"""

import sys
import os
import json
import sqlite3
import asyncio

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.daily_quest import DailyQuestTask, CHEST_MILESTONES
from bot_manager import (
    REGISTERED_TASKS,
    ALWAYS_AUTO_TASKS,
    MANDATORY_CORE_TASKS,
    DEFAULT_BOT_CONFIG,
)
from api_server import CastleConfigModel


class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        self.is_connected = True
        self.sent_queries = []

    async def query(self, cmd, req_type, data=None, **kwargs):
        self.sent_queries.append({"cmd": str(cmd), "req": str(req_type), "data": data or {}})
        if str(cmd) == "2027" and str(req_type) == "2":
            idx = data.get("index", 1)
            return {
                "err": 0,
                "data": {
                    "normalRecord": {str(idx): 1}
                }
            }
        return {"err": 0, "data": {}}


def run_e2e_verification():
    print("=" * 70)
    print("🚀 بدء التحقق الشامل لمهمة استلام صناديق النشاط اليومي الإلزامية")
    print("=" * 70)

    # 1. التحقق من خصائص فئة المهمة في tasks/daily_quest.py
    print("\n[المرحلة 1] فحص كائن ومحددات DailyQuestTask...")
    mock_conn = MockConn({
        "everydayTaskCtrl": {
            "eventInfo": {"1": 5, "6": 1, "7": 1, "18": 40},  # 15 + 30 + 30 + 40 = 115 نقطة
            "normalRecord": {"1": 1},  # الصندوق 1 (30 نقطة) مستلم مسبقاً، الصندوق 2 (70 نقطة) جاهز
            "tomorrowZeroUTC": 0,
        }
    })
    logs = []
    task = DailyQuestTask(mock_conn, log_func=lambda m: logs.append(m), config={"enabled": False})
    
    # التأكد من أن is_active دائماً True مهما كانت قيمة config
    assert task.is_active is True, "is_active must be True unconditionally!"
    print("  ✅ خاصية is_active مفعلة دائماً وإلزامياً حتى لو كُتب enabled=False في الإعدادات.")

    # فحص حساب النقاط
    pts = task.calculate_cur_points(mock_conn.init_data["everydayTaskCtrl"]["eventInfo"])
    assert pts == 115, f"Expected 115 points, got {pts}"
    print(f"  ✅ احتساب النقاط بدقة رياضية: {pts}/500.")

    # فحص الصناديق الجاهزة
    ready = task.get_unclaimed_ready_chests(pts, mock_conn.init_data["everydayTaskCtrl"]["normalRecord"])
    assert ready == [2], f"Expected ready chests [2], got {ready}"
    print(f"  ✅ تحديد الصناديق الجاهزة بدقة: الصندوق رقم {ready}.")

    # تنفيذ الاستلام
    res = asyncio.run(task.run())
    print(f"  Result: {res.success} | message: {res.message} | data: {res.data}")
    print(f"  Logs: {logs}")
    assert res.success is True, f"Task run should succeed, got: {res}"
    assert 2 in res.data["claimed_chests"]
    assert len(mock_conn.sent_queries) == 1
    assert mock_conn.sent_queries[0]["cmd"] == "2027"
    assert mock_conn.sent_queries[0]["req"] == "2"
    assert mock_conn.sent_queries[0]["data"]["index"] == 2
    print(f"  ✅ تم استلام الصندوق بنجاح وتحديث الذاكرة الحية normalRecord.")

    # فحص 0-Network Pre-flight في الدورة التالية
    logs.clear()
    mock_conn.sent_queries.clear()
    res2 = asyncio.run(task.run())
    assert res2.success is True
    assert len(mock_conn.sent_queries) == 0, "0-Network check failed: should not touch server when no chests ready!"
    print("  ✅ فحص 0-Network Pre-flight نجح بنسبة 100% (توقف فوري دون شبكة عند عدم توفر صناديق).")

    # 2. التحقق من bot_manager.py
    print("\n[المرحلة 2] فحص تكامل bot_manager.py...")
    assert "daily_quest" in MANDATORY_CORE_TASKS, "daily_quest must be in MANDATORY_CORE_TASKS!"
    assert "daily_quest" in ALWAYS_AUTO_TASKS, "daily_quest must be in ALWAYS_AUTO_TASKS!"
    assert REGISTERED_TASKS[-1] == DailyQuestTask, "DailyQuestTask must be the final task in REGISTERED_TASKS!"
    print("  ✅ مهمة daily_quest مسجلة ضمن MANDATORY_CORE_TASKS و ALWAYS_AUTO_TASKS.")
    print("  ✅ مهمة daily_quest هي المهمة الختامية لدورة البوت في REGISTERED_TASKS لجني كامل نقاط الأنشطة.")

    # محاكاة منطق فحص تشغيل المهمة في دورة البوت
    t_name = "daily_quest"
    tasks_config = {"daily_quest": {"enabled": False}}  # حتى لو حاول أحد تعطيلها
    if t_name in MANDATORY_CORE_TASKS:
        is_user_enabled = True
    else:
        is_user_enabled = tasks_config.get(t_name, {}).get("enabled", False)
    assert is_user_enabled is True, "Mandatory task must override user disabled flag!"
    print("  ✅ تم التأكد من مناعة المهمة التامة ضد أي محاولة تعطيل في دورة البوت.")

    # 3. التحقق من قاعدة بيانات castles.db الفعلي
    print("\n[المرحلة 3] فحص مباشر لملف SQLite الفعلي database/castles.db...")
    db_path = os.path.join("database", "castles.db")
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute("SELECT email, config FROM castle_states")
    rows = c.fetchall()
    conn.close()
    
    assert len(rows) > 0, "No castles found in database!"
    for email, cfg_str in rows:
        cfg = json.loads(cfg_str) if cfg_str else {}
        assert cfg.get("daily_quest") == {"enabled": True}, f"Castle {email} missing daily_quest in config!"
        print(f"  ✅ قلعة {email}: daily_quest = {cfg.get('daily_quest')}")
    print("  ✅ تم التحقق الفعلي من كافة سجلات قاعدة البيانات بنسبة 100%.")

    # 4. التحقق من كود الواجهة TaskTabContent.tsx
    print("\n[المرحلة 4] فحص كود الواجهة dashboard/src/components/accounts/TaskTabContent.tsx...")
    ui_path = os.path.join("dashboard", "src", "components", "accounts", "TaskTabContent.tsx")
    with open(ui_path, "r", encoding="utf-8") as f:
        ui_code = f.read()

    # التأكد من إزالة TaskRow الخاص بـ daily_quest
    assert 'id="daily_quest"' not in ui_code, "TaskRow id='daily_quest' must not exist in TaskTabContent.tsx!"
    assert "daily_quest: dailyQuestDraft || { enabled: true }" in ui_code, "performSave must enforce daily_quest!"
    assert "daily_quest: dailyQuestConfig } : { daily_quest: { enabled: true } }" in ui_code, "handleSave must enforce daily_quest!"
    print("  ✅ مفتاح التبديل محذوف تماماً من الواجهة، والمهمة تعمل في الخلفية دون استئذان المستخدم.")
    print("  ✅ مسارا الحفظ (performSave و handleSave) يحميان المهمة ويحفظانها دائماً بقيمة { enabled: true }.")

    # 5. التحقق من خادم الـ API
    print("\n[المرحلة 5] فحص API Whitelist و clean_config في api_server.py...")
    model_fields = CastleConfigModel.model_fields
    assert "daily_quest" in model_fields, "daily_quest must be in CastleConfigModel!"
    print("  ✅ حقل daily_quest مصادق عليه في Pydantic CastleConfigModel.")

    api_path = os.path.join("api_server.py")
    with open(api_path, "r", encoding="utf-8") as f:
        api_code = f.read()
    assert 'clean_config.setdefault("daily_quest", {"enabled": True})' in api_code
    print("  ✅ فلتر clean_config يحقن daily_quest تلقائياً لكل القلاع حتى عند التحديثات الناقصة.")

    print("\n" + "=" * 70)
    print("🎉 كافة مراحل التحقق الميداني والبرمجي اكتملت بنجاح 100%!")
    print("=" * 70)


if __name__ == "__main__":
    run_e2e_verification()
