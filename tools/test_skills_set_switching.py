# -*- coding: utf-8 -*-
"""
tools/test_skills_set_switching.py — اختبار شامل وصارم لقواعد تبديل أطقم المواهب وفحص مهارات الأمير
══════════════════════════════════════════════════════════════════════════════════════════════════════
الهدف:
  1. التحقق من عدم ترشيح أو تفعيل أي مهارة من طقم مقفل (مثل مهارات الطقم 2 في beetoo3 عند انتهاء VIP).
  2. التحقق من فحص 0-Network Pre-flight الصارم لدالة can_switch_lord_skill_set ودالة switch_lord_skill_set.
  3. التحقق من أن المهارة لا تعتبر مرشحة إلا إذا كانت متعلمة فعلياً بنقاط > 0 و usedPoint > 0 في طقم مفتوح.
  4. التحقق من دعم كافة تنويعات مفاتيح المتحكم في الذاكرة الحية (curSet, sets, skillList, skillSets).
"""

import asyncio
import copy
import json
import os
import sys
import time
from typing import Any, Dict, List, Optional, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.base_task import BaseTask, TaskResult, CMD_LORD_MODULE, REQ_LORD_SKILL_SWITCH, REQ_LORD_SKILL_USE
from tasks.skills import SkillsTask


class MockConn:
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = init_data
        self.is_connected = True
        self.local_queues = []


class TestTask(BaseTask):
    name = "test_skills_task"
    alias = "test_skills_task"

    def __init__(self, conn: MockConn, config: Optional[Dict[str, Any]] = None):
        super().__init__(conn=conn, log_func=None, config=config or {})
        self.queries_log: List[Dict[str, Any]] = []
        self.fail_network = False

    async def run(self) -> TaskResult:
        return TaskResult.ok()

    async def safe_query(self, cmd: Any, req_type: Any, data: Any = None, **kwargs) -> Dict[str, Any]:
        self.queries_log.append({
            "cmd": str(cmd),
            "req": str(req_type),
            "data": data or {},
        })
        if self.fail_network:
            return {"err": 6, "msg": "Err_CLIENT_EXCEPTION"}

        if str(req_type) == str(REQ_LORD_SKILL_SWITCH):
            return {"err": 0, "code": 0, "data": {"setID": (data or {}).get("setID")}}
        if str(req_type) == str(REQ_LORD_SKILL_USE):
            return {"err": 0, "code": 0, "data": {"skillID": (data or {}).get("skillID"), "CD": 14400, "beginTime": int(time.time())}}
        return {"err": 0, "data": {}}


class TestSkillsTaskRunner(SkillsTask):
    def __init__(self, conn: MockConn, config: Optional[Dict[str, Any]] = None):
        super().__init__(conn=conn, log_func=None, config=config or {})
        self.queries_log: List[Dict[str, Any]] = []

    async def safe_query(self, cmd: Any, req_type: Any, data: Any = None, **kwargs) -> Dict[str, Any]:
        self.queries_log.append({
            "cmd": str(cmd),
            "req": str(req_type),
            "data": data or {},
        })
        if str(req_type) == str(REQ_LORD_SKILL_SWITCH):
            return {"err": 0, "code": 0, "data": {"setID": (data or {}).get("setID")}}
        if str(req_type) == str(REQ_LORD_SKILL_USE):
            return {"err": 0, "code": 0, "data": {"skillID": (data or {}).get("skillID"), "CD": 14400, "beginTime": int(time.time())}}
        return {"err": 0, "data": {}}


def run_all_tests():
    print("=" * 80)
    print("🚀 بدء الاختبار الشامل لمحرك فحص مهارات الأمير وشروط تبديل الأطقم (0-Network Pre-flight)")
    print("=" * 80)

    # ─────────────────────────────────────────────────────────────────
    # اختبار 1: فحص حساب beetoo3 الحقيقي مع VIP منتهي (vipEndTime=0)
    # ─────────────────────────────────────────────────────────────────
    print("\n🏰 [اختبار 1] فحص قلعة beetoo3@hotmail.com من الذاكرة الحية الحقيقية:")
    beetoo3_path = os.path.join("docs", "beetoo3_live_memory.json")
    assert os.path.exists(beetoo3_path), f"ملف beetoo3_live_memory.json غير موجود في {beetoo3_path}"

    with open(beetoo3_path, "r", encoding="utf-8") as f:
        beetoo3_data = json.load(f)

    conn_b3 = MockConn(beetoo3_data)
    task_b3 = TestTask(conn_b3)

    # 1. التأكد من حالة الـ VIP: المستوى 9 ولكن غير مفعّل (vipEndTime=0)
    vip_info = task_b3.get_vip_info()
    print(f"   VIP Info: level={vip_info['level']}, is_active={vip_info['is_active']}, end_time={vip_info['end_time']}")
    assert vip_info["level"] == 9, "مستوى VIP يجب أن يكون 9"
    assert vip_info["is_active"] is False, "VIP يجب أن يكون غير مفعّل لأن vipEndTime=0"
    assert task_b3.is_vip_active is False

    # 2. فحص صلاحية التبديل للأطقم (can_switch_lord_skill_set):
    # الطقم 1 متاح دائماً
    ok_set1, reason_1 = task_b3.can_switch_lord_skill_set("1")
    assert ok_set1 is True, "الطقم 1 يجب أن يكون متاحاً دائماً"
    print(f"   ✅ الطقم 1: متاح={ok_set1} ({reason_1})")

    # الطقم 2 ممنوع لانتهاء VIP
    ok_set2, reason_2 = task_b3.can_switch_lord_skill_set("2")
    assert ok_set2 is False, "الطقم 2 يجب أن يكون مرفوضاً لأن VIP غير مفعل"
    assert "منتهي" in reason_2 or "غير مفعّل" in reason_2
    print(f"   ✅ الطقم 2: متاح={ok_set2} ({reason_2})")

    # الطقم 3 ممنوع
    ok_set3, reason_3 = task_b3.can_switch_lord_skill_set("3")
    assert ok_set3 is False, "الطقم 3 يجب أن يكون مرفوضاً"
    print(f"   ✅ الطقم 3: متاح={ok_set3} ({reason_3})")

    # 3. فحص المهارات الثلاث التي سببت المشكلة (12008 حصاد وافر، 12022 الجمع السريع، 12023 الجمع الآمن):
    for sid, sname in [(12008, "حصاد وافر"), (12022, "الجمع السريع"), (12023, "الجمع الآمن")]:
        st = task_b3.get_lord_skill_status(sid)
        print(f"\n   🔍 فحص المهارة [{sname}] ({sid}):")
        print(f"      - is_in_active_set: {st['is_in_active_set']}")
        print(f"      - is_available: {st['is_available']}")
        print(f"      - is_learned: {st['is_learned']}")
        print(f"      - can_activate: {st['can_activate']}")
        print(f"      - can_switch_to_set: {st['can_switch_to_set']}")
        print(f"      - target_switch_set_id: {st['target_switch_set_id']}")
        print(f"      - switch_blocked_reason: {st['switch_blocked_reason']}")

        # المهارة ليست في الطقم النشط (Set 1)
        assert st["is_in_active_set"] is False
        # المهارة غير متاحة وغير متعلمة في أي طقم مفتوح
        assert st["is_available"] is False
        assert st["is_learned"] is True  # المهارة متعلمة في الطقم 2 ولكن الطقم مقفل
        assert st["can_activate"] is False
        # يمنع قطعياً التبديل للطقم 2
        assert st["can_switch_to_set"] is False
        assert st["target_switch_set_id"] is None
        assert st["switch_blocked_reason"] != ""
        print(f"      ✅ تم التحقق بنجاح من حجب المهارة ومنع التبديل لطقمها المقفل بنسبة 100%!")

    # 4. محاولة استدعاء switch_lord_skill_set مباشرة للطقم 2 -> يجب الرفض 0-Network دون أي طلب
    sw_ok, sw_msg = asyncio.run(task_b3.switch_lord_skill_set("2"))
    assert sw_ok is False, "switch_lord_skill_set للطقم 2 يجب أن تفشل"
    assert len(task_b3.queries_log) == 0, f"يجب عدم إرسال أي طلب شبكي إطلاقاً! الطلبات: {task_b3.queries_log}"
    print(f"   ✅ فحص 0-Network Pre-flight عند طلب التبديل: فشل بأمان ({sw_msg}) دون أي استهلاك شبكي.")

    # 5. محاولة استدعاء use_lord_skill لمهارة 12008 -> يجب الرفض دون أي طلب شبكي
    use_ok, use_msg = asyncio.run(task_b3.use_lord_skill(12008))
    assert use_ok is False
    assert len(task_b3.queries_log) == 0
    print(f"   ✅ فحص 0-Network Pre-flight عند محاولة استخدام 12008: فشل بأمان ({use_msg}) دون أي استهلاك شبكي.")

    # 6. فحص المهارات النشطة في الطقم 1 (النشط) في beetoo3 -> يجب أن تكون جاهزة ومتوفرة
    st_active = task_b3.get_lord_skill_status(11011)  # العودة الفورية
    assert st_active["is_in_active_set"] is True
    assert st_active["is_available"] is True
    assert st_active["is_learned"] is True
    assert st_active["can_activate"] is True
    print(f"   ✅ المهارة النشطة في الطقم الحالي (11011 العودة الفورية): متوفرة={st_active['is_available']}، جاهزة للتفعيل={st_active['can_activate']}")

    # 7. تشغيل SkillsTask الكاملة على حساب beetoo3 للتأكد من تخطي مهارات الطقم 2 بأمان تام
    cfg = {
        "enabled": True,
        "target_skills": ["12008", "12022", "12023", "11011"],
    }
    runner = TestSkillsTaskRunner(MockConn(copy.deepcopy(beetoo3_data)), cfg)
    res = asyncio.run(runner.run())
    print(f"\n   🏁 نتيجة دورة SkillsTask الكاملة: {res.message}")
    print(f"      - مفعلة: {res.data.get('activated')}")
    print(f"      - متخطاة: {res.data.get('skipped')}")
    print(f"      - فاشلة: {res.data.get('failed')}")

    # يجب تفعيل 11011 فقط
    assert "العودة الفورية" in res.data.get("activated", [])
    # يجب تخطي مهارات الطقم 2
    skipped_str = " ".join(res.data.get("skipped", []))
    assert "حصاد وافر" in skipped_str
    assert "الجمع السريع" in skipped_str
    assert "الجمع الآمن" in skipped_str
    assert len(res.data.get("failed", [])) == 0, f"يجب عدم وجود أي فشل! الفاشلة: {res.data.get('failed')}"
    # التأكد من عدم إرسال أي طلب تبديل طقم (23) للطقم 2
    switch_queries = [q for q in runner.queries_log if str(q["req"]) == str(REQ_LORD_SKILL_SWITCH)]
    assert len(switch_queries) == 0, f"يجب عدم إرسال أي طلب تبديل طقم! استعلامات التبديل: {switch_queries}"
    print(f"   ✅ نجحت دورة SkillsTask في تفعيل المهارات الصالحة وتخطي مهارات الطقم المقفل بـ 0 استعلام شبكي زائد!")

    # ─────────────────────────────────────────────────────────────────
    # اختبار 2: سيناريو VIP نشط مع الطقم 2 -> يجب أن يسمح بالتبديل والتفعيل
    # ─────────────────────────────────────────────────────────────────
    print("\n👑 [اختبار 2] سيناريو تفعيل باف VIP نشط على الطقم 2:")
    data_vip_active = copy.deepcopy(beetoo3_data)
    # جعل VIP 9 نشط مع سريان لمدة 24 ساعة قادمة
    data_vip_active["lordInfoCtrl"]["vip"]["vipEndTime"] = int(time.time()) + 86400

    conn_vip = MockConn(data_vip_active)
    task_vip = TestTask(conn_vip)

    assert task_vip.is_vip_active is True
    ok_set2_active, reason_active = task_vip.can_switch_lord_skill_set("2")
    assert ok_set2_active is True, f"الطقم 2 يجب أن يكون متاحاً عند تفعيل VIP: {reason_active}"
    print(f"   ✅ فحص الطقم 2 مع VIP نشط: متاح={ok_set2_active} ({reason_active})")

    st_harvest = task_vip.get_lord_skill_status(12008)
    assert st_harvest["is_available"] is True
    assert st_harvest["is_learned"] is True
    assert st_harvest["can_switch_to_set"] is True
    assert st_harvest["target_switch_set_id"] == "2"
    print(f"   ✅ مهارة حصاد وافر (12008): متوفرة={st_harvest['is_available']}، يمكن التبديل لطقمها={st_harvest['can_switch_to_set']} (طقم {st_harvest['target_switch_set_id']})")

    # محاكاة التفعيل والتبديل والرجوع التلقائي
    use_ok_active, use_msg_active = asyncio.run(task_vip.use_lord_skill(12008, auto_revert=True, step_delay=0.01))
    assert use_ok_active is True
    req_sequence = [q["req"] for q in task_vip.queries_log]
    print(f"   ✅ مسار الطلبات عند VIP نشط: {req_sequence} (23=Switch, 22=Use, 23=Revert)")
    assert req_sequence == [str(REQ_LORD_SKILL_SWITCH), str(REQ_LORD_SKILL_USE), str(REQ_LORD_SKILL_SWITCH)]
    # التأكد من استعادة الطقم 1
    assert str(task_vip.conn.init_data["lordSkillCtrl"]["activeSetID"]) == "1"
    print(f"   ✅ تم التبديل للطقم 2 والتفعيل والرجوع الحتمي للطقم 1 بنجاح تام!")

    # ─────────────────────────────────────────────────────────────────
    # اختبار 3: فحص متطلبات VIP 13 للطقم 3
    # ─────────────────────────────────────────────────────────────────
    print("\n⭐ [اختبار 3] فحص شروط الطقم 3 (VIP 13 نشط):")
    data_vip9 = copy.deepcopy(beetoo3_data)
    data_vip9["lordInfoCtrl"]["vip"]["level"] = 12
    data_vip9["lordInfoCtrl"]["vip"]["vipEndTime"] = int(time.time()) + 86400
    task_v12 = TestTask(MockConn(data_vip9))
    ok_s3_v12, r_s3_v12 = task_v12.can_switch_lord_skill_set("3")
    assert ok_s3_v12 is False, "VIP 12 يجب ألا يفتح الطقم 3"
    print(f"   ✅ VIP 12 نشط: متاح للطقم 3={ok_s3_v12} ({r_s3_v12})")

    data_vip13 = copy.deepcopy(beetoo3_data)
    data_vip13["lordInfoCtrl"]["vip"]["level"] = 13
    data_vip13["lordInfoCtrl"]["vip"]["vipEndTime"] = int(time.time()) + 86400
    task_v13 = TestTask(MockConn(data_vip13))
    ok_s3_v13, r_s3_v13 = task_v13.can_switch_lord_skill_set("3")
    assert ok_s3_v13 is True, "VIP 13 نشط يجب أن يفتح الطقم 3"
    print(f"   ✅ VIP 13 نشط: متاح للطقم 3={ok_s3_v13} ({r_s3_v13})")

    # ─────────────────────────────────────────────────────────────────
    # اختبار 4: فحص الطقم المصفر (usedPoint == 0) والمهارات بمستوى 0
    # ─────────────────────────────────────────────────────────────────
    print("\n🚫 [اختبار 4] فحص الأطقم المصفرة (usedPoint=0) والمهارات غير المخصصة بنقاط:")
    data_zero = copy.deepcopy(beetoo3_data)
    data_zero["lordInfoCtrl"]["vip"]["vipEndTime"] = int(time.time()) + 86400
    # تصفير الطقم 2 بالكامل
    data_zero["lordSkillCtrl"]["setListData"]["2"]["usedPoint"] = 0
    data_zero["lordSkillCtrl"]["setListData"]["2"]["list"] = {"12008": 0}  # مستوى صفر

    task_zero = TestTask(MockConn(data_zero))
    st_zero = task_zero.get_lord_skill_status(12008)
    assert st_zero["is_available"] is False
    assert st_zero["is_learned"] is False
    assert st_zero["can_switch_to_set"] is False
    assert len(st_zero["sets_found"]) == 0
    print(f"   ✅ تم تجاهل المهارة بنجاح عندما كان usedPoint=0 ومستوى المهارة=0.")

    # ─────────────────────────────────────────────────────────────────
    # اختبار 5: فحص مرونة دعم المفاتيح البديلة (curSet, sets, skillList, skillSets)
    # ─────────────────────────────────────────────────────────────────
    print("\n🔧 [اختبار 5] فحص التوافقية والمرونة العالية مع تنويعات مفاتيح المتحكم (curSet, sets, skillList):")
    alt_data = {
        "lordSkillCtrl": {
            "curSet": "1",
            "point_total": 250,
            "sets": {
                "1": {
                    "usedPoints": 100,
                    "skillList": {"13021": 1},  # الطاقة الوافرة
                },
                "2": {
                    "usedPoints": 100,
                    "skillList": {"12008": 1},  # حصاد وافر
                },
            },
            "cdData": {},
        },
        "lordInfoCtrl": {
            "vip": {"level": 10, "vipEndTime": int(time.time()) + 86400}
        },
    }
    task_alt = TestTask(MockConn(alt_data))
    # 1. فحص المهارة في الطقم النشط عبر curSet و skillList
    st_energy = task_alt.get_lord_skill_status(13021)
    assert st_energy["is_in_active_set"] is True
    assert st_energy["can_activate"] is True
    print(f"   ✅ نجحت قراءة الطقم النشط والمهارة (13021) عبر curSet و skillList.")

    # 2. فحص المهارة في الطقم 2 عبر sets و skillList مع VIP نشط
    st_alt_harvest = task_alt.get_lord_skill_status(12008)
    assert st_alt_harvest["is_available"] is True
    assert st_alt_harvest["can_switch_to_set"] is True
    assert st_alt_harvest["target_switch_set_id"] == "2"
    print(f"   ✅ نجحت قراءة الطقم 2 والمهارة (12008) عبر sets و skillList وإمكانية التبديل لطقمها.")

    print("\n" + "=" * 80)
    print("🎉 كافة اختبارات محرك مهارات الأمير وقواعد تبديل الأطقم نجحت بنسبة 100%!")
    print("=" * 80)


if __name__ == "__main__":
    run_all_tests()
