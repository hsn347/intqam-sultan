# -*- coding: utf-8 -*-
"""
tools/test_treasure_escort.py — اختبارات التحقق الشاملة لمهمة حراسة الكنز (TreasureEscortTask)
═══════════════════════════════════════════════════════════════════════════════════════════════
يتحقق من:
  1. تسجيل المهمة تلقائياً في MarchManagerTask._registered_subtasks.
  2. تسجيل escortCtrl و escortCartCtrl وإشعارات NOTIFY_ESCORT (49/50) في core/live_memory.py.
  3. الفحص القبلي (0-Network): مستوى القلعة، فتح الفعالية 1009، المسيرة النشطة، الحد اليومي.
  4. التحديث المجاني للعربة (1075/2 فقط عندما nextRefreshGold == 0) ومنع صرف الذهب نهائياً (لا 1075/3).
  5. تشكيل الجيش: التشكيلة المحفوظة + التعبئة التلقائية الاحتياطية + اشتراط فيلق كامل (Full Legion).
  6. مطابقة حزمة الإرسال الرسمية CMD 1007/2 (moveLineType=11, matrixType=7) وتحديث escortCount محلياً.
"""

import asyncio
import os
import sys
from typing import Any, Dict, List, Tuple

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from core.live_memory import ALLOWED_INIT_CONTROLLERS, LiveMemoryEngine
from tasks.march_manager import (
    MOVE_LINE_CLIENT_ESCORT,
    MOVE_LINE_MATRIX_ESCORT,
    MarchManagerTask,
)
from tasks.treasure_escort import TreasureEscortTask


class _MockConn:
    def __init__(self, init_data: Dict[str, Any], responses: Dict[Tuple[str, str], List[Dict[str, Any]]]):
        self.is_connected = True
        self.init_data = init_data
        self.memory_engine = None
        self.uid = "10001"
        self._responses = {k: list(v) for k, v in responses.items()}
        self.sent_calls: List[Tuple[str, str, Dict[str, Any]]] = []

    async def query(self, cmd: str, subcmd: str, payload: Dict[str, Any], timeout: float = 10.0) -> Dict[str, Any]:
        self.sent_calls.append((str(cmd), str(subcmd), payload))
        key = (str(cmd), str(subcmd))
        queue = self._responses.get(key, [])
        if queue:
            return queue.pop(0)
        return {"err": "0", "data": {}}


def _base_init_data(
    castle_lv: int = 25,
    escort_count: int = 0,
    soldiers_410: int = 50000,
    has_active_escort: bool = False,
    with_saved_formation: bool = False,
) -> Dict[str, Any]:
    queues = []
    if has_active_escort:
        queues.append({"id": "q1", "uid": "10001", "status": 1, "type": 22, "moveLineType": 11})

    compile_army = {"1": {"410": 10000}, "n1": "تشكيلة الكنز"} if with_saved_formation else {}
    compile_hero = {"1": [{"heroID": 201}]} if with_saved_formation else {}

    return {
        "lordInfoCtrl": {"base": {"uid": "10001", "nickName": "Tester", "vipLv": 10, "health": 100}},
        "cityCtrl": {"blist": [{"binfo": {"bid": 101, "lv": castle_lv}}], "cinfo": {"pos": {"x": 500, "y": 500}}},
        "activityShowCtrl": {"activityList": [{"id": 1009, "isOpen": True}]},
        "escortCtrl": {
            "escortCount": escort_count,
            "ESCORT_CITYLEVEL_MIN": 12,
            "ESCORT_DAY_MAX": 2,
            "closestBuild": {"x": 512, "y": 518, "id": "513-519-16-0-1601"},
        },
        "armyCtrl": {
            "totalArmy": {"410": soldiers_410, "805": 9999},  # 805 فخ حصن حرب يجب استبعاده
            "compileArmy": compile_army,
            "compileHero": compile_hero,
            "compileArms": {},
            "compileDivineBeast": {},
        },
        "heroSysCtrl": {
            "heroList": [
                {"heroID": 201, "state": 1, "level": 60, "quality": 5, "level_exp": 100, "isAwake": True},
                {"heroID": 202, "state": 1, "level": 55, "quality": 4, "level_exp": 50, "isAwake": False},
            ],
            "defendList": [],
        },
        "local_queues": queues,
        "other_local_queues": [],
    }


async def run_tests() -> None:
    # 1. التحقق من التسجيل في الذاكرة الحية ومدير المسيرات
    assert "escortCtrl" in ALLOWED_INIT_CONTROLLERS, "escortCtrl missing from ALLOWED_INIT_CONTROLLERS"
    assert "escortCartCtrl" in ALLOWED_INIT_CONTROLLERS, "escortCartCtrl missing from ALLOWED_INIT_CONTROLLERS"
    assert "49" in LiveMemoryEngine._NOTIFY_ROUTE_TABLE, "NOTIFY_ESCORT (49) missing"
    assert "50" in LiveMemoryEngine._NOTIFY_ROUTE_TABLE, "NOTIFY_ESCORT_CART (50) missing"
    assert TreasureEscortTask in MarchManagerTask.get_registered_subtasks(), "TreasureEscortTask not registered"
    print("[PASS] 1. Registration & LiveMemory controllers/notifies verified.")

    # 2. الفحص القبلي (0-Network)
    conn_low = _MockConn(_base_init_data(castle_lv=10), {})
    t_low = TreasureEscortTask(conn_low, config={"enabled": True})
    ok, reason = await t_low.can_run()
    assert not ok and "12" in reason, f"Expected castle_lv skip, got {(ok, reason)}"
    assert len(conn_low.sent_calls) == 0, "0-Network violated on castle_lv check"

    conn_active = _MockConn(_base_init_data(has_active_escort=True), {})
    t_active = TreasureEscortTask(conn_active, config={"enabled": True})
    ok, _ = await t_active.can_run()
    assert not ok, "Should skip when escort march is already active"

    conn_limit = _MockConn(_base_init_data(escort_count=2), {})
    t_limit = TreasureEscortTask(conn_limit, config={"enabled": True})
    ok, _ = await t_limit.can_run()
    assert not ok, "Should skip when daily limit reached (2/2)"
    print("[PASS] 2. 0-Network pre-flight checks verified.")

    # 3. اختبار التحديث المجاني + منع صرف الذهب + الإرسال بالتشكيلة المحفوظة
    responses = {
        ("1075", "1"): [{"err": "0", "data": {"currCartLv": 1, "nextRefreshGold": 0}}],
        ("1075", "2"): [
            {"err": "0", "data": {"currCartLv": 2, "nextRefreshGold": 0}},
            {"err": "0", "data": {"currCartLv": 3, "nextRefreshGold": 50}},  # الآن أصبح بذهب -> يجب التوقف فوراً!
        ],
        ("1007", "2"): [{"err": "0", "data": {"queueId": "escort_q_99"}}],
    }
    conn_ok = _MockConn(_base_init_data(soldiers_410=50000, with_saved_formation=True), responses)
    task = TreasureEscortTask(
        conn_ok,
        config={
            "enabled": True,
            "free_refresh": True,
            "formation_id": 1,
            "use_saved_formation": True,
            "use_auto_fill": True,
            "require_full_legion": True,
        },
    )
    # تجاوز سعة المسيرة التجريبية لتساوي 10,000
    task._mgr.get_max_attack_march_capacity = lambda **kw: 10000
    task._mgr.get_max_marches_capacity = lambda: 4
    task._mgr.get_active_marches_count = lambda: 0
    task._mgr.get_available_marches_count = lambda: 4

    ok, reason = await task.can_run()
    assert ok, f"can_run failed unexpectedly: {reason}"
    res = await task.run()
    assert res.success, f"run failed: {res.message}"

    cmds = [(c, sc) for c, sc, _ in conn_ok.sent_calls]
    assert cmds == [("1075", "1"), ("1075", "2"), ("1075", "2"), ("1007", "2")], f"Unexpected CMD sequence: {cmds}"
    assert ("1075", "3") not in cmds, "Gold appoint 1075/3 must NEVER be called"

    march_payload = conn_ok.sent_calls[-1][2]
    assert march_payload["moveLineType"] == MOVE_LINE_CLIENT_ESCORT == 11
    assert march_payload["matrixType"] == MOVE_LINE_MATRIX_ESCORT == 7
    assert march_payload["to"]["x"] == 512 and march_payload["to"]["y"] == 518
    assert march_payload["army"] == [{"id": 410, "num": 10000}]
    assert conn_ok.init_data["escortCtrl"]["escortCount"] == 1, "In-memory escortCount not incremented"
    print("[PASS] 3. Free refresh (0 gold), saved formation, CMD 1007/2 payload & memory sync verified.")

    # 4. اختبار اشتراط الفيلق الكامل (رفض الإرسال إذا الجنود < السعة)
    conn_short = _MockConn(_base_init_data(soldiers_410=3000, with_saved_formation=False), {})
    t_short = TreasureEscortTask(
        conn_short,
        config={"enabled": True, "formation_id": 0, "use_auto_fill": True, "require_full_legion": True},
    )
    t_short._mgr.get_max_attack_march_capacity = lambda **kw: 10000
    res_short = await t_short.run()
    assert res_short.skipped, f"Expected skip on partial legion, got {res_short}"
    assert len(conn_short.sent_calls) == 0, "Should not send any network call if full legion cannot be formed"
    print("[PASS] 4. Full-legion requirement enforcement verified (0 network calls on shortage).")

    print("\nALL TREASURE ESCORT TESTS PASSED 100%!")


if __name__ == "__main__":
    asyncio.run(run_tests())
