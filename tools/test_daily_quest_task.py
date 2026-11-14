# -*- coding: utf-8 -*-
"""
tools/test_daily_quest_task.py
اختبار برمجي شامل ومستقل لمهمة استلام صناديق النشاط اليومي (DailyQuestTask)
══════════════════════════════════════════════════════════════════════════════════
يتحقق هذا الفحص من:
  1. دقة حساب النقاط التراكمية (Point Calculation & Task Limit Rules)
  2. استخراج الصناديق الجاهزة غير المستلمة (Chest Milestones 30..500)
  3. فحص الذاكرة المسبق ومبدأ 0-Network (Zero-Network Pre-flight Exit)
  4. آلية الاستلام عبر CMD 2027 / SUBCMD 2 ومزامنة الذاكرة الفورية
  5. الاستعلام الاحتياطي الآمن (Safe Fallback Query CMD 2027 / SUBCMD 1)
  6. الترتيب الحتمي كآخر مهمة في REGISTERED_TASKS والتسجيل في ALWAYS_AUTO_TASKS
  7. نموذج API Whitelist في api_server.py
  8. فحص مباشر لقاعدة البيانات castles.db للتأكد من شمول 100% من القلاع
"""

import asyncio
import json
import os
import sqlite3
import sys
import time
from typing import Any, Dict, List, Optional

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# إضافة مسار المشروع
_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.daily_quest import (
    DailyQuestTask,
    CMD_EVERYDAY_TASK_MODULE,
    REQ_EVERYDAY_TASK_INIT,
    REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
    CHEST_MILESTONES,
    DAILY_QUEST_POINT_RULES,
)
from bot_manager import REGISTERED_TASKS, ALWAYS_AUTO_TASKS, DEFAULT_BOT_CONFIG
from api_server import CastleConfigModel


class MockGameConnection:
    """محاكي اتصال اللعبة لاختبار طلبات الشبكة والذاكرة الحية بدقة بالغة."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.init_data = init_data or {}
        self.is_connected = True
        self.sent_queries: List[Dict[str, Any]] = []
        self.query_responses: Dict[str, Any] = {}

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        call_info = {"cmd": str(cmd), "subcmd": str(subcmd), "data": data}
        self.sent_queries.append(call_info)
        key = f"{cmd}_{subcmd}"
        if key in self.query_responses:
            resp = self.query_responses[key]
            if callable(resp):
                return resp(data)
            return resp
        return {"err": 0, "data": {}}


def test_point_calculation():
    print("▶ 1. Testing calculate_cur_points...")
    # Empty
    assert DailyQuestTask.calculate_cur_points({}) == 0, "Empty eventInfo should yield 0 points"
    assert DailyQuestTask.calculate_cur_points(None) == 0, "None eventInfo should yield 0 points"

    # Single event within limit
    # Event 1: Wheat gather (3 pts per action, max limit 5)
    assert DailyQuestTask.calculate_cur_points({"1": 2}) == 6, "2 * 3 = 6 pts"
    # Event 1 exceeding limit
    assert DailyQuestTask.calculate_cur_points({"1": 10}) == 15, "10 * 3 capped at 5 * 3 = 15 pts"

    # Full task ID format (4100006 -> building upgrade: 30 pts, limit 1)
    assert DailyQuestTask.calculate_cur_points({"4100006": 1}) == 30, "Task 4100006 should map to 6 (30 pts)"
    assert DailyQuestTask.calculate_cur_points({"4100006": 5}) == 30, "Task 4100006 capped at 1 (30 pts)"

    # Real memory files test
    sample_path = os.path.join(_ROOT, "docs", "sample_live_memory.json")
    if os.path.exists(sample_path):
        sample_d = json.load(open(sample_path, encoding="utf-8"))
        pts = DailyQuestTask.calculate_cur_points(sample_d["everydayTaskCtrl"]["eventInfo"])
        # eventInfo: {'21': 1 (1 pt), '11': 5 (15 pts), '26': 1 (15 pts), '22': 4 (8 pts), '17': 1 (10 pts)} = 49
        assert pts == 49, f"sample_live_memory expected 49 pts, got {pts}"

    beetoo_path = os.path.join(_ROOT, "docs", "beetoo1_live_memory.json")
    if os.path.exists(beetoo_path):
        beetoo_d = json.load(open(beetoo_path, encoding="utf-8"))
        pts = DailyQuestTask.calculate_cur_points(beetoo_d["everydayTaskCtrl"]["eventInfo"])
        # eventInfo: {'7': 1 (30 pts)} = 30
        assert pts == 30, f"beetoo1 expected 30 pts, got {pts}"

    lucifer_path = os.path.join(_ROOT, "docs", "lucifer_live_memory.json")
    if os.path.exists(lucifer_path):
        lucifer_d = json.load(open(lucifer_path, encoding="utf-8"))
        pts = DailyQuestTask.calculate_cur_points(lucifer_d["everydayTaskCtrl"]["eventInfo"])
        # eventInfo: {'18': 1 (1 pt)} = 1
        assert pts == 1, f"lucifer expected 1 pt, got {pts}"

    print("  ✓ calculate_cur_points passed flawlessly!")


def test_unclaimed_ready_chests():
    print("▶ 2. Testing get_unclaimed_ready_chests...")
    # 0 points
    assert DailyQuestTask.get_unclaimed_ready_chests(0, {}) == []
    # 29 points (below threshold 1: 30)
    assert DailyQuestTask.get_unclaimed_ready_chests(29, {}) == []
    # 30 points (exactly threshold 1)
    assert DailyQuestTask.get_unclaimed_ready_chests(30, {}) == [1]
    # 30 points with chest 1 already claimed
    assert DailyQuestTask.get_unclaimed_ready_chests(30, {"1": 1}) == []
    # 150 points (chests 1, 2, 3: 30, 70, 120)
    assert DailyQuestTask.get_unclaimed_ready_chests(150, {}) == [1, 2, 3]
    # 150 points with chest 2 already claimed
    assert DailyQuestTask.get_unclaimed_ready_chests(150, {"2": 1}) == [1, 3]
    # 500 points (all 8 chests)
    assert DailyQuestTask.get_unclaimed_ready_chests(500, {}) == [1, 2, 3, 4, 5, 6, 7, 8]
    # 500 points with all claimed
    all_claimed = {str(i): 1 for i in range(1, 9)}
    assert DailyQuestTask.get_unclaimed_ready_chests(500, all_claimed) == []

    print("  ✓ get_unclaimed_ready_chests passed flawlessly!")


async def test_zero_network_preflight():
    print("▶ 3. Testing 0-Network Pre-flight check...")
    # Case A: Points = 15 (< 30) -> No chests ready -> 0 queries sent!
    conn_a = MockGameConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {"1": 5},  # 15 points
            "normalRecord": {},
        }
    })
    logs_a = []
    task_a = DailyQuestTask(conn=conn_a, log_func=logs_a.append)
    res_a = await task_a.run()
    assert res_a.success is True
    assert "0-Network" in res_a.message
    assert len(conn_a.sent_queries) == 0, f"Expected 0 network queries, sent: {conn_a.sent_queries}"

    # Case B: Points = 40 (Chest 1 ready), but Chest 1 is already in normalRecord -> 0 queries sent!
    conn_b = MockGameConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {"6": 1, "1": 3},  # 30 + 9 = 39 points
            "normalRecord": {"1": 1},        # Chest 1 already claimed
        }
    })
    task_b = DailyQuestTask(conn=conn_b)
    res_b = await task_b.run()
    assert res_b.success is True
    assert "0-Network" in res_b.message
    assert len(conn_b.sent_queries) == 0, f"Expected 0 network queries, sent: {conn_b.sent_queries}"

    print("  ✓ 0-Network Pre-flight successfully verified: ZERO network packets emitted when no chests are claimable!")


async def test_chest_claiming_and_memory_sync():
    print("▶ 4. Testing chest claiming & in-memory sync...")
    # Points = 130 -> Chests 1, 2, 3 ready (30, 70, 120 pts). Chest 1 is already claimed.
    # Unclaimed ready chests: [2, 3].
    init_ctrl = {
        "tomorrowZeroUTC": int(time.time()) + 3600,
        "eventInfo": {"6": 1, "7": 1, "12": 5, "13": 5, "1": 5}, # 30 + 30 + 25 + 25 + 15 = 125 pts
        "normalRecord": {"1": 1},
    }
    conn = MockGameConnection(init_data={"everydayTaskCtrl": init_ctrl})
    logs = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)

    res = await task.run()
    assert res.success is True, f"Task run failed: {res.message}"
    assert res.data.get("claimed_chests") == [2, 3], f"Expected chests [2, 3], got {res.data.get('claimed_chests')}"

    # Verify query payload
    assert len(conn.sent_queries) == 2, f"Expected exactly 2 queries, got {len(conn.sent_queries)}"
    assert conn.sent_queries[0] == {"cmd": "2027", "subcmd": "2", "data": {"index": 2}}
    assert conn.sent_queries[1] == {"cmd": "2027", "subcmd": "2", "data": {"index": 3}}

    # Verify immediate in-memory sync
    normal_record = conn.init_data["everydayTaskCtrl"]["normalRecord"]
    assert str(normal_record.get("2")) == "1", "Chest 2 was not synced in memory"
    assert str(normal_record.get("3")) == "1", "Chest 3 was not synced in memory"

    # Immediate second run should make 0 network queries because memory was updated!
    res_second = await task.run()
    assert res_second.success is True
    assert "0-Network" in res_second.message
    assert len(conn.sent_queries) == 2, "Second run made unnecessary queries!"

    print("  ✓ Chest claiming & in-memory sync verified: Official CMD 2027/2 sent and memory synchronized!")


async def test_safe_fallback_query():
    print("▶ 5. Testing safe fallback query...")
    # Case: everydayTaskCtrl missing from memory
    conn = MockGameConnection(init_data={})
    # Configure mock response for fallback init query (CMD 2027 / SUBCMD 1)
    conn.query_responses["2027_1"] = {
        "err": 0,
        "data": {
            "tomorrowZeroUTC": int(time.time()) + 7200,
            "eventInfo": {"7": 1},  # 30 pts -> Chest 1 ready
            "normalRecord": {},
        }
    }

    logs = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)
    res = await task.run()

    assert res.success is True
    # Queries sent: 1st fallback query (2027/1), 2nd claim query (2027/2 for index 1)
    assert len(conn.sent_queries) == 2
    assert conn.sent_queries[0] == {"cmd": "2027", "subcmd": "1", "data": {}}
    assert conn.sent_queries[1] == {"cmd": "2027", "subcmd": "2", "data": {"index": 1}}
    assert "everydayTaskCtrl" in conn.init_data
    assert conn.init_data["everydayTaskCtrl"]["normalRecord"]["1"] == 1

    print("  ✓ Safe fallback query verified: Missing memory triggers safe CMD 2027/1 and syncs state!")


def test_bot_manager_registration():
    print("▶ 6. Testing bot_manager task sequencing & config...")
    # Verify DailyQuestTask is the LAST element in REGISTERED_TASKS
    assert REGISTERED_TASKS[-1] == DailyQuestTask, (
        f"DailyQuestTask MUST be the absolute last task in REGISTERED_TASKS! Last task is currently: {REGISTERED_TASKS[-1]}"
    )
    assert len(REGISTERED_TASKS) == 19, f"Expected 19 registered tasks, found {len(REGISTERED_TASKS)}"

    # Verify ALWAYS_AUTO_TASKS
    assert "daily_quest" in ALWAYS_AUTO_TASKS, "'daily_quest' must be in ALWAYS_AUTO_TASKS"

    # Verify DEFAULT_BOT_CONFIG
    assert "daily_quest" in DEFAULT_BOT_CONFIG["tasks"], "'daily_quest' must be in DEFAULT_BOT_CONFIG['tasks']"
    assert DEFAULT_BOT_CONFIG["tasks"]["daily_quest"]["enabled"] is True

    print("  ✓ Bot Manager registration verified: DailyQuestTask is guaranteed LAST in cycle!")


def test_api_whitelist():
    print("▶ 7. Testing API CastleConfigModel whitelist...")
    model = CastleConfigModel(daily_quest={"enabled": True})
    dumped = model.model_dump(exclude_none=True)
    assert "daily_quest" in dumped
    assert dumped["daily_quest"] == {"enabled": True}

    print("  ✓ API CastleConfigModel whitelist verified!")


def test_database_integrity():
    print("▶ 8. Testing database integrity (castles.db)...")
    db_path = os.path.join(_ROOT, "database", "castles.db")
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()
    conn.close()

    assert len(rows) > 0, "No castles found in database!"
    for cid, email, cfg_str in rows:
        cfg = json.loads(cfg_str or "{}")
        assert "daily_quest" in cfg, f"Castle {email} ({cid}) missing 'daily_quest'!"
        assert cfg["daily_quest"].get("enabled") is True, f"Castle {email} 'daily_quest' not enabled!"

    print(f"  ✓ Database verified: 100% of castles ({len(rows)}/{len(rows)}) have daily_quest enabled!")


async def run_all_tests():
    print("═" * 70)
    print("🧪 Running Independent Verification Suite for DailyQuestTask (M1)")
    print("═" * 70)

    test_point_calculation()
    test_unclaimed_ready_chests()
    await test_zero_network_preflight()
    await test_chest_claiming_and_memory_sync()
    await test_safe_fallback_query()
    test_bot_manager_registration()
    test_api_whitelist()
    test_database_integrity()

    print("═" * 70)
    print("🎉 ALL 8 TEST SUITES PASSED FLAWLESSLY WITH 100% SUCCESS!")
    print("═" * 70)


if __name__ == "__main__":
    asyncio.run(run_all_tests())
