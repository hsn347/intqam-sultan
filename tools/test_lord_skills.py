# -*- coding: utf-8 -*-
"""
test_lord_skills.py — أداة فحص واختبار دالة get_lord_skill_status ميدانياً
══════════════════════════════════════════════════════════════════════════════
يفحص هذا الاختبار:
1. مطابقة المعرفات بمرونة (int, str, 7-digit, Arabic names, English names, aliases).
2. فحص مهارات حقيقية على ملفات الذاكرة الحية الحقيقية (beetoo1, lucifer, etc.).
3. فحص المهارات النشطة والمهارات الكامنة.
4. فحص الأطقم المتوفرة والطقم النشط وإمكانية التبديل.
5. فحص حالات التبريد (CDData) والبافات النشطة (buffCtrl/queueCtrl).
"""

import copy
import json
import os
import sys
import time

# ضبط المسار لـ UTF-8 وجذر المشروع
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.base_task import (
    BaseTask,
    LORD_ACTIVE_SKILLS_CATALOG,
    SKILL_ALIAS_TO_ID,
)


class MockConn:
    def __init__(self, init_data):
        self.init_data = init_data
        self.local_queues = []


class DummyTask(BaseTask):
    name = "dummy_task"
    alias = "dummy_task"

    async def run(self):
        return None


def run_tests():
    print("=" * 70)
    print("🚀 بدء اختبارات محرك فحص مهارات ومواهب الأمير (get_lord_skill_status)")
    print("=" * 70)

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 1: فحص مطابقة وتطبيع المعرفات (resolve_lord_skill_id)
    # ─────────────────────────────────────────────────────────────────
    dummy = DummyTask(MockConn({}))
    test_cases = [
        (12008, 12008, "رقم خماسي مباشر"),
        ("12008", 12008, "نص رقمي خماسي"),
        (1200801, 12008, "رقم سباعي رسمي"),
        ("1101102", 11011, "نص سباعي"),
        ("حصاد وافر", 12008, "اسم عربي دقيق"),
        ("حصاد", 12008, "اسم عربي مختصر"),
        ("الإنقاذ", 11028, "اسم عربي مع أل"),
        ("انقاذ", 11028, "اسم عربي بدون همزة"),
        ("rescue", 11028, "رمز إنجليزي"),
        ("harvest", 12008, "رمز إنجليزي"),
        ("bumper_harvest", 12008, "رمز الكتالوج الإنجليزي"),
        ("تسلل", 13032, "تسلل عربي"),
        ("sneak_into", 13032, "تسلل إنجليزي"),
        ("حشد سوبر", 11042, "حشد سوبر"),
        ("عامل ماهر", 13020, "فخاخ فورية"),
        ("الطاقة الوافرة", 13021, "طاقة الأمير"),
        ("زيادة المسيرة", 11029, "تعبئة عامة"),
        ("general_mobilization", 11029, "تعبئة عامة إنجليزي"),
        (99999, 99999, "رقم مهارة غير كتالوجية (يقبله كرقم)"),
        ("invalid_xyz", None, "نص غير صالح نهائياً"),
    ]

    print("\n🔍 [اختبار 1] فحص دالة resolve_lord_skill_id المرنة:")
    passed_1 = 0
    for input_val, expected, note in test_cases:
        res = dummy.resolve_lord_skill_id(input_val)
        ok = (res == expected)
        if ok:
            passed_1 += 1
            print(f"  ✅ {note}: '{input_val}' -> {res}")
        else:
            print(f"  ❌ {note}: '{input_val}' -> حصلنا على {res} بدلاً من {expected}")
    print(f"نتيجة الاختبار 1: {passed_1}/{len(test_cases)} ناجحة.")
    assert passed_1 == len(test_cases), "فشل في اختبارات تطبيع المعرفات!"

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 2: فحص مهارات حقيقية على ذاكرة القلعة lucifer_live_memory.json
    # ─────────────────────────────────────────────────────────────────
    lucifer_path = os.path.join("docs", "lucifer_live_memory.json")
    if os.path.exists(lucifer_path):
        print("\n🏰 [اختبار 2] فحص مهارات حساب LUCIFER الحقيقي من الذاكرة الحية:")
        with open(lucifer_path, "r", encoding="utf-8") as f:
            lucifer_data = json.load(f)

        lucifer_conn = MockConn(lucifer_data)
        lucifer_task = DummyTask(lucifer_conn)

        # حساب لوسيفر لديه طقم 1 وطقم 2، الطقم النشط هو 2
        # في الطقم 2: متعلم مهارات مثل 13019 (20), 13011 (20), 13003 (5), 11003 (5)
        # في الطقم 1: متعلم مهارات مثل 11002 (5), 11046 (1), 11004 (5), 11006 (5), 11042 (1)

        # أ. فحص مهارة "حشد سوبر" 11042 (موجودة في الطقم 1 فقط، بينما النشط هو 2)
        rally_status = lucifer_task.get_lord_skill_status("حشد سوبر")
        print("\n  🛡️ نتيجة فحص 'حشد سوبر' (11042):")
        print(f"     - معرف المهارة: {rally_status['skill_id']} ({rally_status['skill_name']})")
        print(f"     - متوفرة للقلعة: {rally_status['is_available']}")
        print(f"     - في الطقم النشط (Set {rally_status['active_set_id']}): {rally_status['is_in_active_set']} (مستواها: {rally_status['current_level']})")
        print(f"     - الأطقم التي توجد بها: {[s['set_id'] for s in rally_status['sets_found']]}")
        print(f"     - إمكانية التبديل لطقمها: {rally_status['can_switch_to_set']} (الطقم المقترح: {rally_status['target_switch_set_id']})")
        print(f"     - جاهزة للتفعيل الآن: {rally_status['can_activate']}")

        assert rally_status["success"] is True
        assert rally_status["skill_id"] == 11042
        assert rally_status["is_available"] is True
        assert rally_status["is_in_active_set"] is False  # لأنها في طقم 1 والنشط 2
        assert "1" in [s["set_id"] for s in rally_status["sets_found"]]
        assert rally_status["can_switch_to_set"] is True
        assert rally_status["target_switch_set_id"] == "1"

        # ب. فحص مهارة كامنة مثل 13003 (كمية التدريب I - موجودة في الطقم 2 النشط)
        train_status = lucifer_task.get_lord_skill_status(13003)
        print("\n  ⚔️ نتيجة فحص المهارة الكامنة 13003 (كمية التدريب I):")
        print(f"     - معرف المهارة: {train_status['skill_id']}")
        print(f"     - نوع المهارة نشطة: {train_status['is_active_skill']}")
        print(f"     - متوفرة للقلعة: {train_status['is_available']}")
        print(f"     - في الطقم النشط: {train_status['is_in_active_set']} (مستواها: {train_status['current_level']})")
        print(f"     - تأثيرها نشط وسارٍ: {train_status['is_active']}")

        assert train_status["success"] is True
        assert train_status["is_available"] is True
        assert train_status["is_in_active_set"] is True
        assert train_status["current_level"] == 5
        assert train_status["is_active"] is True  # كامنة في الطقم المفعل

        # ج. فحص مهارة غير متعلمة إطلاقاً في القلعة مثل 11056
        unlearned_status = lucifer_task.get_lord_skill_status(11056)
        print("\n  ❌ نتيجة فحص مهارة غير متعلمة (11056 - السم القاتل):")
        print(f"     - متوفرة للقلعة: {unlearned_status['is_available']}")
        print(f"     - في الطقم النشط: {unlearned_status['is_in_active_set']}")
        print(f"     - جاهزة للتفعيل: {unlearned_status['can_activate']}")
        assert unlearned_status["is_available"] is False
        assert unlearned_status["is_in_active_set"] is False
        assert unlearned_status["can_activate"] is False

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 3: فحص مهارات حساب beetoo1_live_memory.json (العودة الفورية 11011)
    # ─────────────────────────────────────────────────────────────────
    beetoo_path = os.path.join("docs", "beetoo1_live_memory.json")
    if os.path.exists(beetoo_path):
        print("\n🏰 [اختبار 3] فحص مهارات حساب beetoo1 الحقيقي من الذاكرة الحية:")
        with open(beetoo_path, "r", encoding="utf-8") as f:
            beetoo_data = json.load(f)

        beetoo_conn = MockConn(beetoo_data)
        beetoo_task = DummyTask(beetoo_conn)

        # حساب beetoo1 لديه في الطقم 1 (النشط): 11011 (العودة الفورية) بمستوى 1
        return_status = beetoo_task.get_lord_skill_status("العودة الفورية")
        print("\n  🐎 نتيجة فحص 'العودة الفورية' (11011):")
        print(f"     - معرف المهارة: {return_status['skill_id']} ({return_status['skill_name']})")
        print(f"     - متوفرة للقلعة: {return_status['is_available']}")
        print(f"     - في الطقم النشط: {return_status['is_in_active_set']} (مستواها: {return_status['current_level']})")
        print(f"     - في فترة تبريد: {return_status['in_cooldown']} (المتبقي: {return_status['cd_remaining_seconds']} ث)")
        print(f"     - سارية المفعول حالياً: {return_status['is_active']}")
        print(f"     - جاهزة للتفعيل فوراً: {return_status['can_activate']}")

        assert return_status["success"] is True
        assert return_status["skill_id"] == 11011
        assert return_status["is_available"] is True
        assert return_status["is_in_active_set"] is True
        assert return_status["current_level"] == 1
        assert return_status["in_cooldown"] is False
        assert return_status["can_activate"] is True

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 4: محاكاة فترات التبريد (Cooldown) والبافات النشطة (Buffs)
    # ─────────────────────────────────────────────────────────────────
    print("\n⏱️ [اختبار 4] محاكاة فترات التبريد وسريان البافات الحية:")
    now_ts = int(time.time())

    # تجهيز ذاكرة افتراضية مع تبريد لمهارة 12008 (حصاد وافر) وباف نشط لمهارة 11028 (الإنقاذ)
    sim_data = {
        "lordSkillCtrl": {
            "activeSetID": "1",
            "pointTotal": 300,
            "setListData": {
                "1": {
                    "title": "حرب وتطوير",
                    "usedPoint": 150,
                    "power": 50000,
                    "list": {
                        "12008": 1,  # حصاد وافر متعلم
                        "11028": 1,  # الإنقاذ متعلم
                        "13020": 1,  # عامل ماهر متعلم
                    }
                }
            },
            "CDData": {
                # مهارة 12008 بدأت تبريد قبل 1000 ثانية ومدة التبريد 14400 ثانية (متبقي 13400)
                "12008": {
                    "beginTime": now_ts - 1000,
                    "CD": 14400,
                }
            }
        },
        "buffCtrl": {
            # باف الإنقاذ (buff_id 4501) نشط ومتبقي له 3600 ثانية
            "4501": {
                "endTime": now_ts + 3600,
            }
        },
        "queueCtrl": {},
        "vipCtrl": {"vipLv": 10},
    }

    sim_task = DummyTask(MockConn(sim_data))

    # أ. فحص مهارة في فترة التبريد (12008)
    cd_test = sim_task.get_lord_skill_status(12008)
    print("\n  ⏳ فحص مهارة في فترة تبريد (12008 - حصاد وافر):")
    print(f"     - in_cooldown: {cd_test['in_cooldown']}")
    print(f"     - cd_remaining_seconds: {cd_test['cd_remaining_seconds']}s")
    print(f"     - can_activate: {cd_test['can_activate']}")
    assert cd_test["in_cooldown"] is True
    assert 13350 <= cd_test["cd_remaining_seconds"] <= 13450
    assert cd_test["can_activate"] is False

    # ب. فحص مهارة بافها نشط وسارٍ حالياً (11028 - الإنقاذ)
    buff_test = sim_task.get_lord_skill_status(11028)
    print("\n  🛡️ فحص مهارة بافها سارٍ حالياً (11028 - الإنقاذ):")
    print(f"     - is_active: {buff_test['is_active']}")
    print(f"     - is_buff_active: {buff_test['is_buff_active']}")
    print(f"     - buff_remaining_seconds: {buff_test['buff_remaining_seconds']}s")
    print(f"     - can_activate: {buff_test['can_activate']}")
    assert buff_test["is_active"] is True
    assert buff_test["is_buff_active"] is True
    assert 3550 <= buff_test["buff_remaining_seconds"] <= 3650
    assert buff_test["can_activate"] is False

    # ج. فحص مهارة جاهزة تماماً للتفعيل (13020 - عامل ماهر)
    ready_test = sim_task.get_lord_skill_status(13020)
    print("\n  ⚡ فحص مهارة جاهزة للتفعيل الفوري (13020 - عامل ماهر):")
    print(f"     - is_available: {ready_test['is_available']}")
    print(f"     - is_in_active_set: {ready_test['is_in_active_set']}")
    print(f"     - in_cooldown: {ready_test['in_cooldown']}")
    print(f"     - is_active: {ready_test['is_active']}")
    print(f"     - can_activate: {ready_test['can_activate']}")
    assert ready_test["is_available"] is True
    assert ready_test["is_in_active_set"] is True
    assert ready_test["in_cooldown"] is False
    assert ready_test["is_active"] is False
    assert ready_test["can_activate"] is True

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 5: فحص دورة التبديل الذكي التلقائي والرجوع للطقم الأصلي (Weave & Revert)
    # ─────────────────────────────────────────────────────────────────
    print("\n🔄 [اختبار 5] محاكاة التبديل الذكي التلقائي لتفعيل المهارة والرجوع الحتمي للطقم السابق:")
    import asyncio

    class MockTaskWithNetwork(DummyTask):
        def __init__(self, conn):
            super().__init__(conn)
            self.queries_log = []
            self.fail_skill_use = False

        async def safe_query(self, cmd, req_type, data=None, **kwargs):
            self.queries_log.append({"cmd": str(cmd), "req": str(req_type), "data": data or {}})
            # محاكاة خطأ تفعيل إذا تم طلب ذلك
            if self.fail_skill_use and str(req_type) == "22":
                return {"err": 100222, "msg": "Simulation Error"}
            # استجابة نجاح افتراضية
            if str(req_type) == "22":
                return {"err": 0, "data": {"skillID": data.get("skillID"), "CD": 14400, "beginTime": int(time.time())}}
            return {"err": 0, "data": {}}

    async def run_weave_tests():
        # ذاكرة تحوي طقمين: الطقم 2 هو النشط، والمهارة (12008) في الطقم 1
        weave_data = {
            "lordSkillCtrl": {
                "activeSetID": 2,
                "pointTotal": 300,
                "setListData": {
                    "1": {"title": "تطوير", "usedPoint": 150, "list": {"12008": 1}},
                    "2": {"title": "حرب", "usedPoint": 150, "list": {"11011": 1}},
                },
                "CDData": {},
            },
            "buffCtrl": {},
            "queueCtrl": {},
            "vipCtrl": {"vipLv": 10},
        }

        # أ. سيناريو النجاح الكامل: تبديل -> تفعيل -> رجوع تلقائي
        task_success = MockTaskWithNetwork(MockConn(weave_data))
        ok, msg = await task_success.trigger_lord_skill_with_revert("حصاد وافر", auto_revert=True, step_delay=0.01)
        print(f"  ✅ نتيجة التفعيل الناجح مع الرجوع: {ok} | {msg}")
        assert ok is True
        # التحقق من ترتيب الطلبات: 1. تبديل لـ 1 -> 2. تفعيل 12008 -> 3. رجوع لـ 2
        reqs = [q["req"] for q in task_success.queries_log]
        print(f"     - مسار الطلبات المرسلة: {reqs} (23=Switch, 22=Use, 23=Switch Back)")
        assert reqs == ["23", "22", "23"]
        assert task_success.queries_log[0]["data"]["setID"] == 1
        assert task_success.queries_log[1]["data"]["skillID"] == 12008
        assert task_success.queries_log[2]["data"]["setID"] == 2
        # التحقق من أن الذاكرة الحية عادت للطقم 2
        final_set = task_success.conn.init_data["lordSkillCtrl"]["activeSetID"]
        assert str(final_set) == "2"
        # التحقق من تحديث الـ CD بالذاكرة
        assert "12008" in task_success.conn.init_data["lordSkillCtrl"]["CDData"]

        # ب. سيناريو الفشل أثناء التفعيل مع التأكد من الرجوع الحتمي للطقم السابق (Zero-Stranded Protocol)
        weave_data_fail = {
            "lordSkillCtrl": {
                "activeSetID": 2,
                "pointTotal": 300,
                "setListData": {
                    "1": {"title": "تطوير", "usedPoint": 150, "list": {"12008": 1}},
                    "2": {"title": "حرب", "usedPoint": 150, "list": {"11011": 1}},
                },
                "CDData": {},
            },
            "buffCtrl": {},
            "queueCtrl": {},
            "vipCtrl": {"vipLv": 10},
        }
        task_fail = MockTaskWithNetwork(MockConn(weave_data_fail))
        task_fail.fail_skill_use = True  # محاكاة رفض السيرفر للتفعيل
        ok_fail, msg_fail = await task_fail.trigger_lord_skill_with_revert("حصاد وافر", auto_revert=True, step_delay=0.01)
        print(f"  🛡️ سيناريو الفشل المحمي: {ok_fail} | {msg_fail}")
        assert ok_fail is False
        # التأكد من أنه رغم فشل التفعيل تم إرسال طلب الرجوع للطقم 2
        reqs_fail = [q["req"] for q in task_fail.queries_log]
        assert reqs_fail == ["23", "22", "23"]
        assert task_fail.queries_log[2]["data"]["setID"] == 2
        assert str(task_fail.conn.init_data["lordSkillCtrl"]["activeSetID"]) == "2"
        # ج. سيناريو استجابة السيرفر بنص رقمي ('0' أو 'Err_None') - فحص الحصانة من أخطاء المطابقة
        class MockTaskWithStringZero(DummyTask):
            async def safe_query(self, cmd, req_type, data=None, **kwargs):
                if str(req_type) == "22":
                    return {"err": "0", "data": {"skillID": data.get("skillID"), "CD": 14400, "beginTime": int(time.time())}}
                return {"err": "0", "data": {}}

        import copy
        fresh_weave_data = copy.deepcopy(weave_data)
        fresh_weave_data["lordSkillCtrl"]["CDData"] = {}
        task_str_zero = MockTaskWithStringZero(MockConn(fresh_weave_data))
        ok_str, msg_str = await task_str_zero.use_lord_skill(12008, auto_revert=True, step_delay=0.01)
        print(f"  ✅ سيناريو استجابة السيرفر بـ '0' نصية: {ok_str} | {msg_str}")
        assert ok_str is True
        assert "تم تفعيل المهارة 'حصاد وافر' بنجاح" in msg_str

        # د. فحص الدالة المساعدة _is_resp_ok مباشرة
        assert DummyTask._is_resp_ok({"err": 0}) is True
        assert DummyTask._is_resp_ok({"err": "0"}) is True
        assert DummyTask._is_resp_ok({"err": "Err_None"}) is True
        assert DummyTask._is_resp_ok({"code": 0}) is True
        assert DummyTask._is_resp_ok({"code": "0"}) is True
        assert DummyTask._is_resp_ok({"data": {}}) is True
        assert DummyTask._is_resp_ok({"err": 1001}) is False
        assert DummyTask._is_resp_ok({"err": "1001"}) is False
        assert DummyTask._is_resp_ok(None) is False
        print("  ✓ تم التحقق بنجاح من حصانة دالة _is_resp_ok مع كافة أنماط الردود (نصوص، أرقام، ورموز).")

    asyncio.run(run_weave_tests())

    # ─────────────────────────────────────────────────────────────────
    # الاختبار 6: فحص واختبار مهارات الحشد التآزرية للأبطال (Hero Rally Skills)
    # ─────────────────────────────────────────────────────────────────
    print("\n⚔️ [اختبار 6] فحص محرك مهارات الحشد التآزرية للأبطال (heroComboSkillCtrl):")

    # أ. فحص دالة resolve_hero_rally_skill_id
    assert sim_task.resolve_hero_rally_skill_id(172308) == 172308
    assert sim_task.resolve_hero_rally_skill_id("172308") == 172308
    assert sim_task.resolve_hero_rally_skill_id(17230801) == 172308
    assert sim_task.resolve_hero_rally_skill_id("17230805") == 172308
    assert sim_task.resolve_hero_rally_skill_id("نداء الحشود") == 172308
    assert sim_task.resolve_hero_rally_skill_id("نداء") == 172308
    assert sim_task.resolve_hero_rally_skill_id("حشد الرماة") == 172308
    assert sim_task.resolve_hero_rally_skill_id("rally_call") == 172308
    assert sim_task.resolve_hero_rally_skill_id("مسيرة صف القوات") == 173608
    assert sim_task.resolve_hero_rally_skill_id("حشد المشاة") == 173608
    assert sim_task.resolve_hero_rally_skill_id("الغارة السريعة") == 174308
    assert sim_task.resolve_hero_rally_skill_id("حشد الفرسان") == 174308
    assert sim_task.resolve_hero_rally_skill_id("unknown_rally") is None
    print("  ✅ فحص المطابقة والتحليل الذكي لمهارات الحشد: 13/13 ناجحة.")

    # ب. فحص قراءة مهارات الحشد من ذاكرة تحوي أبطال المهارة
    rally_mock_memory = {
        "heroSysCtrl": {
            "heroList": {
                "1723": {"heroID": 1723, "quality": 4},  # الأمير القناص (جودة 4 نجوم -> 4 استخدامات يومية)
                "1726": {"heroID": 1726, "quality": 3},  # جسار
            }
        },
        "heroComboSkillCtrl": {
            "skillGroupInfo": {
                "172308": {
                    "useNum": 1,
                    "beginTime": int(time.time()) - 100,
                    "endTime": 0,
                    "cd": 0,
                }
            }
        },
        "local_queues": [],
    }
    rally_task = DummyTask(MockConn(rally_mock_memory))

    # فحص مهارة رماة متوفرة (172308)
    st_rally = rally_task.get_hero_rally_skill_status(172308)
    print(f"  🎯 فحص مهارة نداء الحشود (172308):")
    print(f"     - متوفرة (الأبطال مملوكون): {st_rally['is_available']}")
    print(f"     - جودة البطل: {st_rally['hero_quality']} نجوم")
    print(f"     - الاستخدامات الكلية والمتبقية: {st_rally['remaining_uses_today']}/{st_rally['daily_max_uses']}")
    print(f"     - جاهزة للتفعيل: {st_rally['can_activate']}")
    assert st_rally["is_available"] is True
    assert st_rally["daily_max_uses"] == 4
    assert st_rally["used_today"] == 1
    assert st_rally["remaining_uses_today"] == 3
    assert st_rally["can_activate"] is True

    # فحص مهارة مشاة غير متوفرة (173608)
    st_missing = rally_task.get_hero_rally_skill_status(173608)
    assert st_missing["is_available"] is False
    assert st_missing["has_hero"] is False
    assert st_missing["can_activate"] is False

    # ج. فحص التفعيل والمزامنة في الذاكرة الحية
    class MockRallyNetworkTask(DummyTask):
        def __init__(self, conn):
            super().__init__(conn)
            self.sent_queries = []

        async def safe_query(self, cmd, req_type, data=None, **kwargs):
            self.sent_queries.append({"cmd": str(cmd), "req": str(req_type), "data": data or {}})
            now = int(time.time())
            return {
                "err": "0",
                "rspdata": {
                    "skillData": {
                        "172308": {
                            "useNum": 2,
                            "beginTime": now,
                            "endTime": now + 3600,
                            "cd": 0,
                        }
                    }
                }
            }

    async def run_rally_activation_test():
        task_rally_net = MockRallyNetworkTask(MockConn(copy.deepcopy(rally_mock_memory)))
        ok, msg = await task_rally_net.use_hero_rally_skill("نداء الحشود", step_delay=0.01)
        print(f"  ⚡ نتيجة تفعيل نداء الحشود: {ok} | {msg}")
        assert ok is True
        assert len(task_rally_net.sent_queries) == 1
        assert task_rally_net.sent_queries[0]["cmd"] == "2235"
        assert task_rally_net.sent_queries[0]["req"] == "2"
        assert task_rally_net.sent_queries[0]["data"]["skillGroup"] == 172308

        # التحقق من أن المهارة أصبحت سارية ومتبقي 2 استخدامات بالذاكرة الحية
        after_st = task_rally_net.get_hero_rally_skill_status("نداء الحشود")
        assert after_st["is_active"] is True
        assert after_st["used_today"] == 2
        assert after_st["remaining_uses_today"] == 2
        assert after_st["can_activate"] is False  # لا يمكن تفعيلها وهي سارية المفعول
        print(f"  🛡️ تم التأكد من تحديث الذاكرة: المهارة سارية (is_active={after_st['is_active']}) والمتبقي {after_st['remaining_uses_today']} استخدامات.")

    asyncio.run(run_rally_activation_test())

    print("\n" + "=" * 70)
    print("🎉 كافة الاختبارات والتحققات الميدانية لمحرك المهارات والتبديل اكتملت بنجاح 100%!")
    print("=" * 70)


if __name__ == "__main__":
    run_tests()
