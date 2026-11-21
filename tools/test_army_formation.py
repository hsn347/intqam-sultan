# -*- coding: utf-8 -*-
"""
أداة فحص واختبار دالة تشكيلات الجيش get_army_formation و get_all_army_formations
مطابقة للمعيار الصارم للدوال (القاعدة 14 في الدستور)
"""

import sys
import os
import json
import asyncio

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.base_task import BaseTask, TaskResult


class MockConnection:
    def __init__(self, init_data):
        self.init_data = init_data
        self.is_connected = True
        self.queries_log = []

    async def query(self, cmd, subcmd=0, data=None, **kwargs):
        self.queries_log.append((cmd, subcmd, data))
        # المحاكاة عند طلب تحديث armyCtrl
        if str(cmd) == "1005":
            return {"data": self.init_data.get("armyCtrl", {})}
        return {}


class ConcreteTestTask(BaseTask):
    name = "test_task"

    async def run(self) -> TaskResult:
        return TaskResult.ok()


def run_tests():
    print("═" * 70)
    print("اختبار دالة get_army_formation و get_all_army_formations (BaseTask)")
    print("═" * 70)

    # 1. اختبار الحساب scratch/init_LUCIFER.json
    lucifer_path = os.path.join("scratch", "init_LUCIFER.json")
    if os.path.exists(lucifer_path):
        with open(lucifer_path, "r", encoding="utf-8") as f:
            lucifer_data = json.load(f)

        conn_lucifer = MockConnection(lucifer_data)
        task_lucifer = ConcreteTestTask(conn=conn_lucifer)

        print("\n--- [1] اختبار حساب LUCIFER (تشكيلة 1 - جنود وأبطال) ---")
        f1 = task_lucifer.get_army_formation_sync(1)
        assert f1["success"] is True, f"فشل فحص تشكيلة 1: {f1}"
        assert f1["formation_id"] == 1
        assert f1["total_preset_soldiers"] == 19674
        assert len(f1["heroes"]) == 5, f"عدد الأبطال المتوقع 5، الفعلي: {len(f1['heroes'])}"
        print(f"  [✓] تشكيلة 1: جنود={f1['total_preset_soldiers']} | أبطال={len(f1['heroes'])} | can_march_full={f1['can_march_full']}")
        for h in f1["heroes"]:
            print(f"      - بطل: ID={h['id']} | الاسم={h['name_ar']} | النوع={h['type_ar']}")

        print("\n--- [2] اختبار حساب LUCIFER (تشكيلة 2 - جنود متعددون وسلاح خارق) ---")
        f2 = task_lucifer.get_army_formation_sync(2)
        assert f2["success"] is True, f"فشل فحص تشكيلة 2: {f2}"
        assert f2["formation_id"] == 2
        assert f2["total_preset_soldiers"] == (1000 + 20000 + 2500 + 13000)
        assert f2["arms"] == [6100131]
        print(f"  [✓] تشكيلة 2: جنود={f2['total_preset_soldiers']} | سلاح خارق={f2['arms']} | تفاصيل الجنود={len(f2['soldiers'])} أنواع")

        print("\n--- [3] اختبار حساب LUCIFER (تشكيلة غير موجودة رقم 99) ---")
        f99 = task_lucifer.get_army_formation_sync(99)
        assert f99["success"] is False, "يجب أن تفشل التشكيلة 99 غير المعرفة"
        assert "غير موجودة أو فارغة" in f99["reason"]
        print(f"  [✓] التشكيلة 99: أرجعت فشل منظم كما هو مطلوب -> reason: '{f99['reason']}'")

    # 2. اختبار الحساب tools/beetoo2_full_init_data.json (اسم مخصص "جندي")
    b2_path = os.path.join("tools", "beetoo2_full_init_data.json")
    if os.path.exists(b2_path):
        with open(b2_path, "r", encoding="utf-8") as f:
            b2_data = json.load(f)

        conn_b2 = MockConnection(b2_data)
        task_b2 = ConcreteTestTask(conn=conn_b2)

        print("\n--- [4] اختبار حساب beetoo2 (البحث برقم 2 وبالاسم المخصص 'جندي') ---")
        f2_by_id = task_b2.get_army_formation_sync(2)
        assert f2_by_id["success"] is True
        assert f2_by_id["name"] == "جندي"
        print(f"  [✓] تشكيلة 2 بالرقم: الاسم المخصص = '{f2_by_id['name']}' | جنود = {f2_by_id['total_preset_soldiers']}")

        f2_by_name = task_b2.get_army_formation_sync("جندي")
        assert f2_by_name["success"] is True
        assert f2_by_name["formation_id"] == 2
        assert f2_by_name["name"] == "جندي"
        print(f"  [✓] تشكيلة 2 بالاسم 'جندي': نجح التعرف التلقائي -> formation_id = {f2_by_name['formation_id']}")

        print("\n--- [5] اختبار get_all_army_formations على beetoo2 ---")
        all_f = task_b2.get_all_army_formations()
        assert len(all_f) == 2, f"المتوقع تشكيلتان، الفعلي: {len(all_f)}"
        print(f"  [✓] تم استخراج كافة التشكيلات الجاهزة: {list(all_f.keys())}")

    # 3. اختبار القاعدة 14: الاستعلام الاحتياطي المشروط بطباعة تحذيرية صارخة
    print("\n--- [6] اختبار القاعدة 14: الاستعلام الاحتياطي المشروط بالتحذير الصارخ ---")
    async def test_fallback():
        empty_data = {}  # الذاكرة الحية فارغة تماماً من armyCtrl
        conn_empty = MockConnection(empty_data)
        
        # عند إرسال الاستعلام للسيرفر، يرجع السيرفر البيانات
        async def mock_server_response(cmd, subcmd=0, data=None, **kwargs):
            conn_empty.queries_log.append((cmd, subcmd, data))
            return {"data": {"compileArmy": {"1": {"501": 500}}}}
        
        conn_empty.query = mock_server_response
        task_empty = ConcreteTestTask(conn=conn_empty)
        
        # تخزين مخرجات السجل
        logs = []
        task_empty._log_func = lambda m: logs.append(m)

        res = await task_empty.get_army_formation(1)
        assert len(conn_empty.queries_log) == 1, f"يجب إرسال استعلام احتياطي واحد للسيرفر، الفعلي: {len(conn_empty.queries_log)}"
        assert str(conn_empty.queries_log[0][0]) == "1005", "رقم أمر السيرفر يجب أن يكون CMD 1005"
        
        # التأكد من وجود الطباعة التحذيرية الصارخة بإيموجيات واضحة
        assert any("🚨⚠️🚨" in log for log in logs), f"لم يتم العثور على الإيموجي التحذيري الصارخ في السجلات: {logs}"
        print(f"  [✓] تم إطلاق الاستعلام الاحتياطي بنجاح مع السجل التحذيري الصارخ:")
        for l in logs:
            print(f"      {l}")
        assert res["success"] is True
        assert res["total_preset_soldiers"] == 500
        print(f"  [✓] نجح استلام البيانات وتحديث الذاكرة عبر الاستعلام الاحتياطي بنسبة 100%.")

    asyncio.run(test_fallback())

    print("\n" + "═" * 70)
    print("🎉 كافة الاختبارات نجحت بنسبة 100% بتطابق تام مع القاعدة 14 والدستور!")
    print("═" * 70)


if __name__ == "__main__":
    run_tests()
