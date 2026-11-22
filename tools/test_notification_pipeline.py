# -*- coding: utf-8 -*-
"""
tools/test_notification_pipeline.py — فحص واختبار حقيقي لنظام تدقيق ودمج الإشعارات اللحظية
══════════════════════════════════════════════════════════════════════════════════════
يختبر هذا السكربت كفاءة ودقة:
  1. كشف ومعالجة الإشعارات الواردة في الذاكرة الحية (LiveMemoryEngine).
  2. استخراج المتحكمات المتأثرة من الـ 26 متحكماً المعتمدة.
  3. إنتاج الملخص الذكي المقتضب (Smart Summary).
  4. التحقق العكسي الفعلي من نجاح الدمج في الذاكرة الحية (Empirical Read-back Verification).
  5. تصفية الإشعارات غير المعتمدة وطباعتها لأول مرة فقط مع كتم أي تكرار لاحق 100%.
"""

from __future__ import annotations

import os
import sys
import time
from typing import Any, Dict, List

# ضبط مسار المشروع
WORKSPACE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from core.live_memory import LiveMemoryEngine, ALLOWED_CONTROLLERS
from core.game_client import GameConnection, AccountSession, GateCredentials


def test_allowed_notification_merge():
    """اختبار إشعار يخص متحكماً معتمداً (cityCtrl / الموارد) والتحقق الفعلي من الذاكرة الحية."""
    print("\n--- [1] اختبار إشعار متحكم معتمد (cityCtrl) ---")
    logged_messages: List[str] = []

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.enable_notification_logging = True
    conn.notify_log_callback = lambda msg: logged_messages.append(msg)

    # تهيئة أولية لـ cityCtrl
    conn.init_data["cityCtrl"] = {"resList": {"1002": 100000, "1003": 50000}}

    # محاكاة إشعار قادم بتحديث الموارد (notifyID = CITY)
    city_notify_packet = {
        "cmd": "1009",
        "subcmd": "9",
        "_session": 0,
        "notifyID": "CITY",
        "notifyData": [
            {
                "res": {
                    "1002": 25000,
                    "1003": 15000,
                }
            }
        ]
    }

    # معالجة الحزمة عبر محرك الذاكرة ومسار العميل
    init_data, report = conn.memory_engine.ingest_packet_with_report(city_notify_packet)
    conn._log_notification(report)

    # 1. التأكد من تصنيف الحزمة كإشعار
    assert report["is_notification"] is True, "فشل: لم يتم تصنيف الحزمة كإشعار!"
    # 2. التأكد من نجاح التحقق العكسي
    assert report["verify_success"] is True, f"فشل التحقق من الدمج: {report.get('verify_detail')}"
    # 3. التأكد من أن الذاكرة الحية تم تحديثها فعلياً (100000 + 25000 = 125000)
    cur_food = conn.init_data["cityCtrl"]["resList"].get("1002")
    assert cur_food == 125000, f"فشل الدمج الفعلي: القمح المتوقع 125000، الفعلي {cur_food}"

    # 4. التأكد من طباعة التنسيق الرباعي المعتمد
    assert len(logged_messages) == 1, "فشل: لم يتم تسجيل رسالة الإشعار!"
    msg = logged_messages[0]
    print(msg)
    assert "🔔 [إشعار وارد: CITY]" in msg
    assert "📦 المتحكم المتأثر: cityCtrl" in msg
    assert "🔄 القيمة المستحدثة:" in msg
    assert "✅ التحقق من الدمج في الذاكرة الحية: ناجح 100%" in msg

    print("✓ تم بنجاح: تم دمج الموارد وفحصها في init_data وطباعة التقرير بدقة.")


def test_queue_notification_merge():
    """اختبار إشعار طوابير البناء (queueCtrl)."""
    print("\n--- [2] اختبار إشعار طابور البناء (queueCtrl) ---")
    logged_messages: List[str] = []

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.enable_notification_logging = True
    conn.notify_log_callback = lambda msg: logged_messages.append(msg)

    conn.init_data["queueCtrl"] = {}
    conn.init_data["cityCtrl"] = {"blist": []}

    queue_notify_packet = {
        "cmd": "1009",
        "subcmd": "14",
        "_session": 0,
        "notifyID": "QUEUE",
        "notifyData": [
            {
                "dispatchQueueEvent": {
                    "queuetype": "1200",
                    "bid": 101,
                    "totaltime": 1800,
                    "optype": "1",
                }
            }
        ]
    }

    init_data, report = conn.memory_engine.ingest_packet_with_report(queue_notify_packet)
    conn._log_notification(report)

    assert report["is_notification"] is True
    assert report["verify_success"] is True
    assert len(logged_messages) == 1
    msg = logged_messages[0]
    print(msg)
    assert "🔔 [إشعار وارد: QUEUE]" in msg
    assert "queueCtrl" in msg
    assert "✅ التحقق من الدمج في الذاكرة الحية: ناجح 100%" in msg

    print("✓ تم بنجاح: تم دمج طابور البناء والتحقق منه في init_data.")


def test_reward_notification_merge():
    """اختبار إشعار مكافأة الوقت (NOTIFY_REWARD) والتأكد من عدم ظهوره كإشعار غير مخصص."""
    print("\n--- [3] اختبار إشعار مكافأة الوقت (NOTIFY_REWARD) ---")
    logged_messages: List[str] = []

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.enable_notification_logging = True
    conn.notify_log_callback = lambda msg: logged_messages.append(msg)

    conn.init_data["timeRewardCtrl"] = {"isReceive": 1, "isAllReceive": 0}

    reward_packet = {
        "cmd": "1009",
        "subcmd": "16",
        "_session": 0,
        "notifyID": "NOTIFY_REWARD",
        "notifyData": {}
    }

    init_data, report = conn.memory_engine.ingest_packet_with_report(reward_packet)
    conn._log_notification(report)

    assert report["is_notification"] is True, "فشل: لم يتم تصنيف الحزمة كإشعار!"
    assert report["verify_success"] is True, f"فشل التحقق: {report.get('verify_detail')}"
    assert conn.init_data["timeRewardCtrl"]["isReceive"] == 2, "فشل: لم يتم تحديث isReceive إلى 2!"
    assert len(logged_messages) == 1
    msg = logged_messages[0]
    print(msg)
    assert "🔔 [إشعار وارد: NOTIFY_REWARD]" in msg
    assert "timeRewardCtrl" in msg
    assert "جاهزة للاستلام" in msg or "مكافأة الوقت" in msg
    assert "✅ التحقق من الدمج في الذاكرة الحية: ناجح 100%" in msg
    print("✓ تم بنجاح: تم دمج NOTIFY_REWARD مع timeRewardCtrl وتأكيده في الذاكرة الحية 100%.")


def test_everyday_task_notification_merge():
    """اختبار إشعار مهام النشاط اليومي (NOTIFY_EVERYDAY_TASK) مع everydayTaskCtrl."""
    print("\n--- [4] اختبار إشعار النشاط اليومي (NOTIFY_EVERYDAY_TASK) ---")
    logged_messages: List[str] = []

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.enable_notification_logging = True
    conn.notify_log_callback = lambda msg: logged_messages.append(msg)

    conn.init_data["everydayTaskCtrl"] = {"chestRecord": 0}

    task_packet = {
        "cmd": "1009",
        "subcmd": "55",
        "_session": 0,
        "notifyID": "NOTIFY_EVERYDAY_TASK",
        "notifyData": [
            {
                "tomorrowZeroUTC": 1700000000,
                "chestRecord": 3,
                "eventInfo": {"task1": 100}
            }
        ]
    }

    init_data, report = conn.memory_engine.ingest_packet_with_report(task_packet)
    conn._log_notification(report)

    assert report["is_notification"] is True
    assert report["verify_success"] is True
    assert conn.init_data["everydayTaskCtrl"]["chestRecord"] == 3
    assert len(logged_messages) == 1
    msg = logged_messages[0]
    print(msg)
    assert "🔔 [إشعار وارد: NOTIFY_EVERYDAY_TASK]" in msg
    assert "everydayTaskCtrl" in msg
    assert "✅ التحقق من الدمج في الذاكرة الحية: ناجح 100%" in msg
    print("✓ تم بنجاح: تم دمج NOTIFY_EVERYDAY_TASK في everydayTaskCtrl بنجاح.")


def test_base_task_attributes():
    """اختبار دالتي shield_remaining_seconds و available_marches في BaseTask."""
    print("\n--- [5] اختبار BaseTask: shield_remaining_seconds و available_marches ---")
    from tasks.base_task import BaseTask

    class DummyTask(BaseTask):
        name = "dummy"
        async def run(self):
            return None

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.init_data["kingdomMapCtrl"] = {"isSafe": True}
    conn.init_data["cityCtrl"] = {"blist": []}
    conn.init_data["queueCtrl"] = {}

    task = DummyTask(conn, {})
    assert task.is_shielded is True
    assert task.shield_remaining_seconds == 1
    assert hasattr(task, "available_marches")
    assert isinstance(task.available_marches, int)
    print(f"✓ BaseTask.is_shielded={task.is_shielded}, shield_remaining_seconds={task.shield_remaining_seconds}, available_marches={task.available_marches}")


def test_unhandled_notification_filtering():
    """اختبار تصفية الإشعارات غير المعتمدة: ذكرها لأول مرة فقط وكتمها تماماً في المرات اللاحقة."""
    print("\n--- [6] اختبار تصفية الإشعارات غير المعتمدة (First Time Only) ---")
    logged_messages: List[str] = []

    acc = AccountSession(email="test@bot.local", user_id="12345", session_id="sess_abc", password="pass")
    creds = GateCredentials(uid="12345", gate_ip="127.0.0.1", gate_port=4084, secret=b"12345678", kingdom_id=150)
    conn = GameConnection(acc, creds)
    conn.enable_notification_logging = True
    conn.notify_log_callback = lambda msg: logged_messages.append(msg)

    untracked_packet = {
        "cmd": "1009",
        "subcmd": "9999",
        "_session": 0,
        "notifyID": "UNKNOWN_EVENT_NOTIFY_9999",
        "notifyData": {"foo": "bar"}
    }

    # المرة الأولى
    init_data, report1 = conn.memory_engine.ingest_packet_with_report(untracked_packet)
    conn._log_notification(report1)

    assert len(logged_messages) == 1, "فشل: كان يجب طباعة الإشعار في المرة الأولى!"
    print(f"المرة الأولى: {logged_messages[0]}")
    assert "ℹ️ [إشعار غير مخصص لأول مرة]: UNKNOWN_EVENT_NOTIFY_9999" in logged_messages[0]
    assert "UNKNOWN_EVENT_NOTIFY_9999" in conn._seen_unhandled_notifies

    # المرة الثانية: يجب كتمه تماماً
    init_data, report2 = conn.memory_engine.ingest_packet_with_report(untracked_packet)
    conn._log_notification(report2)
    assert len(logged_messages) == 1, "فشل: تم تكرار طباعة الإشعار غير المعتمد في المرة الثانية!"

    # المرة الثالثة: يجب كتمه تماماً أيضاً
    init_data, report3 = conn.memory_engine.ingest_packet_with_report(untracked_packet)
    conn._log_notification(report3)
    assert len(logged_messages) == 1, "فشل: تم تكرار طباعة الإشعار غير المعتمد في المرة الثالثة!"

    print("✓ تم بنجاح: ظهر الإشعار غير المعتمد لمرة واحدة فقط وتم كتم كافة التكرارات اللاحقة 100%.")


def main():
    print("══════════════════════════════════════════════════════════════════════")
    print(" 🚀 بدء فحص واختبار نظام تدقيق ودمج الإشعارات اللحظية في البوت العام")
    print("══════════════════════════════════════════════════════════════════════")

    test_allowed_notification_merge()
    test_queue_notification_merge()
    test_reward_notification_merge()
    test_everyday_task_notification_merge()
    test_base_task_attributes()
    test_unhandled_notification_filtering()

    print("\n══════════════════════════════════════════════════════════════════════")
    print(" ✅ كافة اختبارات تدقيق الإشعارات والتحقق العكسي والفلترة اجتازت بنجاح 100%!")
    print("══════════════════════════════════════════════════════════════════════\n")


if __name__ == "__main__":
    main()
