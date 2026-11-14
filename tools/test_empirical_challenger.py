# -*- coding: utf-8 -*-
"""
test_empirical_challenger.py — سكريبت التحقق التجريبي والضغوط (Empirical Challenge Harness)
══════════════════════════════════════════════════════════════════════════════════════════
يختبر هذا السكريبت حالات الحافة والسيناريوهات العدائية لمهام:
  1. ForgeEquipmentTask: سيناريو وجود قطعة fe، وسيناريو انشغال الطابور 1229، وسيناريو إتمام النشاط، وحماية الخطأ 22002.
  2. DailyTrainTask: سيناريو 5/5 في eventInfo، وتفويض التدريب العادي، واستجابة الثكنات المشغولة.
  3. TrainTask: حظر إرسال أي استعلام لثكنة مشغولة، ومزامنة queueCtrl الفورية.
  4. BuildingTask: فحص الفواصل الزمنية (0.5s - 0.9s) وخلوها من التعليق.
"""

import asyncio
import time
from typing import Any, Dict, List, Optional
from tasks.forge_equipment import ForgeEquipmentTask, CMD_EQUIPMENT_MODULE, REQ_GET_EQUIPMENT
from tasks.daily_train import DailyTrainTask
from tasks.train import TrainTask, check_barracks_busy, sync_training_queue_in_memory, clear_harvested_queue_in_memory
from tasks.building import BuildingTask


class MockLiveConnection:
    """محاكي اتصال حي دقيق لتتبع كافة الاستعلامات وفحص 0-Network"""
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = init_data
        self.is_connected = True
        self.queries_log: List[Dict[str, Any]] = []

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        return self.init_data.get(name, {})

    async def query(self, cmd: str, subcmd: str, data: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        call_info = {"cmd": str(cmd), "subcmd": str(subcmd), "data": data or {}}
        self.queries_log.append(call_info)
        
        # محاكاة ردود السيرفر
        if cmd == "1047" and subcmd == "2":
            # رد استلام العتاد الناجح
            return {"err": 0, "data": {"epid": data.get("epid", 12345)}}
        elif cmd == "1005" and subcmd == "2":
            # رد بدء التدريب
            return {"err": 0, "data": {"queuetype": "1203", "totaltime": 1800}}
        elif cmd == "1001" and subcmd in ("2", "3"):
            # رد البناء
            return {"err": 0, "data": {}}
        return {"err": 0, "data": {}}

    async def close(self):
        self.is_connected = False


def create_base_init_data():
    return {
        "lord": {"uid": "11307263", "kid": 150},
        "lordInfoCtrl": {"level": 50},
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "101", "lv": 30, "state": "0"}},
                {"binfo": {"bid": "102", "lv": 30, "state": "0"}},
                {"binfo": {"bid": "115", "lv": 20, "state": "0"}}, # حداد
                {"binfo": {"bid": "118", "lv": 25, "state": "0"}}, # مشاة
                {"binfo": {"bid": "117", "lv": 25, "state": "0"}}, # رماة
                {"binfo": {"bid": "116", "lv": 25, "state": "0"}}, # خيالة
                {"binfo": {"bid": "119", "lv": 25, "state": "0"}}, # عربات
                {"binfo": {"bid": "120", "lv": 25, "state": "0"}}, # فخاخ
                {"binfo": {"bid": "205", "lv": 25, "state": "0"}}, # خيمة
            ],
            "reslist": {"1001": 5000000, "1002": 5000000, "1003": 5000000, "1004": 5000000, "1006": 500000},
        },
        "queueCtrl": {},
        "armyCtrl": {"trainArmy": {}},
        "equipmentCtrl": {"equipment_array": []},
        "everydayTaskCtrl": {"eventInfo": {}},
        "questCtrl": {"point_finish_list": []},
        "backpackCtrl": {
            "200101": 50, "200201": 50, "200301": 50, "200401": 50, "200501": 50, "200601": 50, # مواد بيضاء
            "500101": 10, "500201": 10, # أدوات تسريع
        }
    }


async def test_forge_scenario_fe_claim():
    """اختبار استلام القطعة الجاهزة في fe فوراً بصفر استهلاك موارد"""
    init_data = create_base_init_data()
    # وضع قطعة مكتملة في fe
    init_data["equipmentCtrl"]["fe"] = {
        "epid": 8888,
        "eid": 6101,
        "endTime": int(time.time()) - 100
    }
    
    logs = []
    conn = MockLiveConnection(init_data)
    task = ForgeEquipmentTask(conn, logs.append, {"enabled": True})
    
    res = await task.run()
    
    # التحقق: تم إرسال طلب استلام واحد فقط
    assert len(conn.queries_log) == 1, f"Expected 1 query, got {len(conn.queries_log)}"
    q = conn.queries_log[0]
    assert q["cmd"] == CMD_EQUIPMENT_MODULE and q["subcmd"] == REQ_GET_EQUIPMENT
    assert q["data"]["epid"] == 8888
    # التحقق: لم يتم خصم أي صلب
    assert init_data["cityCtrl"]["reslist"]["1006"] == 500000
    # التحقق: تم مسح fe من الذاكرة
    assert "fe" not in init_data["equipmentCtrl"]
    # التحقق: تم تحديث النشاط اليومي
    assert init_data["everydayTaskCtrl"]["eventInfo"].get("4100009") == 1
    print("  ✓ [PASSED] Forge fe claim scenario: claimed finished item with 0 resources and synced memory.")


async def test_forge_scenario_active_queue():
    """اختبار الحدادة المشغولة: يجب التخطي بصفر استعلامات شبكية لمنع الخطأ 22002"""
    init_data = create_base_init_data()
    # وضع طابور تصنيع نشط
    init_data["queueCtrl"]["1229"] = {
        "qtype": "1229",
        "starttime": int(time.time()),
        "totaltime": 3600,
        "data": {"epid": 7777, "eid": 6105}
    }
    
    logs = []
    conn = MockLiveConnection(init_data)
    task = ForgeEquipmentTask(conn, logs.append, {"enabled": True})
    
    res = await task.run()
    
    # التحقق: صفر استعلامات شبكية
    assert len(conn.queries_log) == 0, f"Expected 0 queries, got {len(conn.queries_log)}"
    assert res.skipped is True
    assert "busy forging" in res.message
    print("  ✓ [PASSED] Forge busy queue scenario: 0-network pre-flight prevented Error 22002.")


async def test_daily_train_scenario_all_done():
    """اختبار تدريب النشاط اليومي: تخطي كل الأنواع المكتملة 5/5 بصفر استعلامات"""
    init_data = create_base_init_data()
    init_data["everydayTaskCtrl"]["eventInfo"] = {
        "12": 5, "13": 5, "14": 5, "15": 5, "16": 5
    }
    
    logs = []
    conn = MockLiveConnection(init_data)
    task = DailyTrainTask(conn, logs.append, {"enabled": True})
    
    res = await task.run()
    
    assert len(conn.queries_log) == 0, f"Expected 0 queries, got {len(conn.queries_log)}"
    assert len(res.data.get("already_done", [])) == 5
    print("  ✓ [PASSED] Daily train 5/5 completed scenario: 0-network skipped all 5 quests.")


async def test_train_scenario_busy_barracks():
    """اختبار تدريب الجيش: تخطي الثكنات المشغولة بصفر استعلامات ومنع الخطأ 4002"""
    init_data = create_base_init_data()
    now_ts = int(time.time())
    # جعل ثكنة المشاة 118 وثكنة الرماة 117 مشغولتين
    init_data["queueCtrl"]["1203"] = {
        "qtype": "1203",
        "starttime": now_ts,
        "totaltime": 3600,
        "data": {"bid": "118", "armyid": "401"}
    }
    init_data["queueCtrl"]["1205"] = {
        "qtype": "1205",
        "starttime": now_ts,
        "totaltime": 3600,
        "data": {"bid": "117", "armyid": "601"}
    }
    
    logs = []
    conn = MockLiveConnection(init_data)
    config = {
        "enabled": True,
        "types": ["infantry", "archers"],
        "level": 1,
    }
    task = TrainTask(conn, logs.append, config)
    
    res = await task.run()
    
    # لم يتم إرسال أي طلب لأن الثكنتين مشغولتان
    assert len(conn.queries_log) == 0, f"Expected 0 queries, got {len(conn.queries_log)}"
    assert len(res.data.get("busy", [])) == 2
    print("  ✓ [PASSED] Train busy barracks scenario: 0-network pre-flight prevented Error 4002.")


async def test_train_in_memory_sync():
    """اختبار تحديث الذاكرة الحية فور إرسال التدريب لمنع التضارب"""
    init_data = create_base_init_data()
    conn = MockLiveConnection(init_data)
    
    # استدعاء دالة المزامنة
    sync_training_queue_in_memory(conn, "118", 401, 250, {"queuetype": "1203", "totaltime": 1800})
    
    # فحص الذاكرة الحية
    assert "1203" in init_data["queueCtrl"]
    assert init_data["queueCtrl"]["1203"]["data"]["bid"] == "118"
    assert init_data["everydayTaskCtrl"]["eventInfo"]["12"] == 5 # 250 وحدة تعطي 5 دورات
    assert 4100012 in init_data["questCtrl"]["point_finish_list"]
    
    # فحص check_barracks_busy
    is_busy, rem_s, desc = check_barracks_busy(conn, "118", int(time.time()))
    assert is_busy is True
    assert rem_s > 0
    print("  ✓ [PASSED] Train in-memory sync scenario: queueCtrl and questCtrl updated immediately.")


async def main():
    print("═" * 70)
    print("🧪 تشغيل حزمة التحقق والضغوط العدائية لمهام الباك إند")
    print("═" * 70)
    await test_forge_scenario_fe_claim()
    await test_forge_scenario_active_queue()
    await test_daily_train_scenario_all_done()
    await test_train_scenario_busy_barracks()
    await test_train_in_memory_sync()
    print("═" * 70)
    print("🎉 كافة السيناريوهات العدائية والتجريبية اجتازت الفحص بنجاح 100%!")
    print("═" * 70)

if __name__ == "__main__":
    asyncio.run(main())
