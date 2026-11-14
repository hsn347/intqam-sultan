# -*- coding: utf-8 -*-
"""
tools/test_adversarial_daily_quest.py
Empirical Adversarial Verification & Stress Test Harness for Requirement R1 (DailyQuestTask)
══════════════════════════════════════════════════════════════════════════════════════════════
Developed by: Empirical Challenger (challenger_task_protocol_r2)
Target: Comprehensive empirical stress-testing of protocol fidelity, 0-network checks,
        edge cases, error containment, bot manager sequencing, and database integrity.
"""

import ast
import asyncio
import json
import os
import sqlite3
import sys
import time
from typing import Any, Dict, List, Optional, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

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
import bot_manager
from bot_manager import REGISTERED_TASKS, ALWAYS_AUTO_TASKS, DEFAULT_BOT_CONFIG


class AdversarialMockConnection:
    """
    Adversarial Game Connection Mock with protocol interception,
    query counting, and strict assertion against forbidden commands (e.g. SubCMD 4).
    """

    def __init__(self, init_data: Any = None):
        self.init_data = init_data
        self.is_connected = True
        self.sent_queries: List[Dict[str, Any]] = []
        self.forbidden_commands_caught: List[Dict[str, Any]] = []
        self.custom_handlers: Dict[Tuple[str, str], Any] = {}

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        record = {"cmd": str(cmd), "subcmd": str(subcmd), "data": data, "timestamp": time.time()}
        self.sent_queries.append(record)

        # STRICT PROTOCOL CHECK: SubCMD 4 (Gold treasure purchase) MUST NEVER BE CALLED!
        if str(cmd) == CMD_EVERYDAY_TASK_MODULE and str(subcmd) == "4":
            self.forbidden_commands_caught.append(record)
            raise RuntimeError(f"CRITICAL VIOLATION: SubCMD '4' (gold treasure purchase) was invoked! Packet: {record}")

        key = (str(cmd), str(subcmd))
        if key in self.custom_handlers:
            handler = self.custom_handlers[key]
            if callable(handler):
                return handler(data)
            return handler

        # Default success
        return {"err": 0, "data": {}}


# ─────────────────────────────────────────────────────────────────────────────
# Test 1: 0 Points -> Verify 0 Packets Sent (0-Network Pre-flight)
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_0_points():
    print("▶ Case 1: Synthetic memory with 0 points (0 packets sent)")
    conn = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {},
            "normalRecord": {},
        }
    })
    logs: List[str] = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)
    result = await task.run()

    assert result.success is True, f"Expected success=True, got {result.success}"
    assert len(conn.sent_queries) == 0, f"Expected 0 queries, got {len(conn.sent_queries)}: {conn.sent_queries}"
    assert "0-Network" in result.message, f"Expected '0-Network' in message: {result.message}"
    print(f"  ✓ Case 1 PASSED: 0 packets emitted. Result: {result.message}")


# ─────────────────────────────────────────────────────────────────────────────
# Test 2: 500 Points & All 8 Chests Claimed -> Verify 0 Packets Sent
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_500_points_all_claimed():
    print("▶ Case 2: Synthetic memory with 500 points & all 8 chests claimed (0 packets sent)")
    # Generate 500 points via eventInfo:
    # 6: 1 (30), 7: 1 (30), 32: 1 (30), 25: 1 (20), 27: 1 (20), 28: 1 (20),
    # 9: 1 (20), 10: 1 (10), 17: 1 (10), 19: 1 (10), 20: 1 (10), 33: 1 (10),
    # 26: 1 (15), 12..15: 4*25 = 100, 1..5: 5*15 = 75, 11: 15, 16: 15, 8: 20, 22: 20, 24: 20 -> > 500
    event_info = {str(i): 50 for i in range(1, 34)}
    all_claimed = {str(i): 1 for i in range(1, 9)}
    conn = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 7200,
            "eventInfo": event_info,
            "normalRecord": all_claimed,
        }
    })
    logs: List[str] = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)
    result = await task.run()

    cur_pts = DailyQuestTask.calculate_cur_points(event_info)
    assert cur_pts >= 500, f"Expected >= 500 points, calculated: {cur_pts}"
    assert result.success is True, f"Expected success=True, got {result.success}"
    assert len(conn.sent_queries) == 0, f"Expected 0 queries, got {len(conn.sent_queries)}: {conn.sent_queries}"
    assert "0-Network" in result.message, f"Expected '0-Network' in message: {result.message}"
    print(f"  ✓ Case 2 PASSED: Points={cur_pts}, all 8 chests claimed -> 0 packets emitted.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 3: 180 Points & Chests 1..3 Unclaimed -> Verify Exact Commands & Memory Update
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_180_points_chests_1_to_3_unclaimed():
    print("▶ Case 3: Synthetic memory with 180 points & chests 1..3 unclaimed")
    # At 180 points:
    # Chest 1: 30 pts
    # Chest 2: 70 pts
    # Chest 3: 120 pts
    # Chest 4: 180 pts (already marked as claimed to test exactly unclaimed 1..3)
    # Event info to reach exactly 180 points:
    # 6: 1 (30), 7: 1 (30), 32: 1 (30), 12: 5 (25), 13: 5 (25), 14: 5 (25), 1: 5 (15) -> 30*3 + 25*3 + 15 = 90 + 75 + 15 = 180 points!
    event_info = {"6": 1, "7": 1, "32": 1, "12": 5, "13": 5, "14": 5, "1": 5}
    calculated = DailyQuestTask.calculate_cur_points(event_info)
    assert calculated == 180, f"Setup error: expected exactly 180 pts, got {calculated}"

    # Chest 4 is already claimed, chests 1, 2, 3 are unclaimed
    initial_normal_record = {"4": 1}
    conn = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": event_info,
            "normalRecord": dict(initial_normal_record),
        }
    })
    logs: List[str] = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)
    result = await task.run()

    assert result.success is True, f"Expected success=True, got {result.message}"
    assert len(conn.sent_queries) == 3, f"Expected exactly 3 queries, got {len(conn.sent_queries)}"

    # Check exact commands sent: CMD 2027, SUBCMD 2 with index 1, 2, 3
    for idx, expected_index in enumerate([1, 2, 3]):
        q = conn.sent_queries[idx]
        assert q["cmd"] == "2027", f"Query {idx} cmd expected '2027', got {q['cmd']}"
        assert q["subcmd"] == "2", f"Query {idx} subcmd expected '2', got {q['subcmd']}"
        assert q["data"] == {"index": expected_index}, f"Query {idx} data expected {{'index': {expected_index}}}, got {q['data']}"

    # Verify memory updated with keys '1', '2', '3' and preserving '4'
    updated_record = conn.init_data["everydayTaskCtrl"]["normalRecord"]
    for i in [1, 2, 3, 4]:
        assert str(i) in updated_record or i in updated_record, f"Chest {i} missing from updated in-memory record: {updated_record}"

    # Verify second run immediately causes 0 packets
    res_second = await task.run()
    assert res_second.success is True
    assert "0-Network" in res_second.message
    assert len(conn.sent_queries) == 3, f"Second run should not emit queries, count is {len(conn.sent_queries)}"

    print("  ✓ Case 3 PASSED: Exact packets CMD 2027/2 (index 1, 2, 3) sent, memory updated and idempotency verified.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 4: Completely Empty / None conn.init_data -> Safe Fallback Query
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_empty_and_none_init_data():
    print("▶ Case 4: Completely empty and None conn.init_data (safe fallback query)")

    # 4A: init_data = {}
    conn_empty = AdversarialMockConnection(init_data={})
    conn_empty.custom_handlers[("2027", "1")] = {
        "err": 0,
        "data": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {"6": 1},  # 30 pts -> chest 1 ready
            "normalRecord": {},
        }
    }
    task_empty = DailyQuestTask(conn=conn_empty)
    res_empty = await task_empty.run()

    assert res_empty.success is True
    assert len(conn_empty.sent_queries) == 2
    assert conn_empty.sent_queries[0] == {"cmd": "2027", "subcmd": "1", "data": {}, "timestamp": conn_empty.sent_queries[0]["timestamp"]}
    assert conn_empty.sent_queries[1] == {"cmd": "2027", "subcmd": "2", "data": {"index": 1}, "timestamp": conn_empty.sent_queries[1]["timestamp"]}
    assert conn_empty.init_data["everydayTaskCtrl"]["normalRecord"]["1"] == 1

    # 4B: init_data = None
    class NoneDataConn(AdversarialMockConnection):
        def __init__(self):
            super().__init__(init_data=None)

    conn_none = NoneDataConn()
    conn_none.custom_handlers[("2027", "1")] = {
        "err": 0,
        "data": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {},
            "normalRecord": {},
        }
    }
    task_none = DailyQuestTask(conn=conn_none)
    res_none = await task_none.run()
    # When init_data is None, fallback queries and handles without crash
    assert len(conn_none.sent_queries) >= 1
    assert conn_none.sent_queries[0]["cmd"] == "2027" and conn_none.sent_queries[0]["subcmd"] == "1"

    print("  ✓ Case 4 PASSED: Empty and None init_data triggered safe fallback query CMD 2027/1 without crashing.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 5: Expired tomorrowZeroUTC -> Verify Day Reset Triggers Fallback
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_expired_tomorrow_zero_utc():
    print("▶ Case 5: Expired tomorrowZeroUTC (day reset triggers safe fallback query)")
    now = int(time.time())
    expired_ts = now - 300  # 5 minutes in the past

    conn = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": expired_ts,
            "eventInfo": {"6": 1},   # Old points from yesterday
            "normalRecord": {"1": 1}, # Old claimed chest from yesterday
        }
    })

    # The server responds with refreshed today's state:
    conn.custom_handlers[("2027", "1")] = {
        "err": 0,
        "data": {
            "tomorrowZeroUTC": now + 86400,
            "eventInfo": {"7": 1, "6": 1, "12": 5}, # 30 + 30 + 25 = 85 pts -> chests 1 & 2 ready
            "normalRecord": {},                      # Today's fresh reset record
        }
    }

    logs: List[str] = []
    task = DailyQuestTask(conn=conn, log_func=logs.append)
    result = await task.run()

    assert result.success is True
    # The first query MUST be CMD 2027 / SUBCMD 1 because tomorrowZeroUTC is expired!
    assert len(conn.sent_queries) >= 1, "Expected at least 1 query"
    first_q = conn.sent_queries[0]
    assert first_q["cmd"] == "2027" and first_q["subcmd"] == "1", f"First query should be 2027/1, got {first_q}"

    # Next queries should claim chests 1 and 2
    claim_queries = conn.sent_queries[1:]
    assert len(claim_queries) == 2, f"Expected 2 claim queries, got {len(claim_queries)}"
    assert claim_queries[0]["data"] == {"index": 1}
    assert claim_queries[1]["data"] == {"index": 2}

    print("  ✓ Case 5 PASSED: Day reset detected (expired tomorrowZeroUTC); triggered CMD 2027/1 and updated state.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 6: Strict Prohibition of SubCMD "4" (Gold Treasure Purchase)
# ─────────────────────────────────────────────────────────────────────────────
def test_case_confirm_subcmd_4_never_called():
    print("▶ Case 6: Confirm SubCMD '4' is NEVER called and not present in task source code")

    # Static AST analysis of tasks/daily_quest.py
    task_file = os.path.join(_ROOT, "tasks", "daily_quest.py")
    with open(task_file, "r", encoding="utf-8") as f:
        source_code = f.read()

    tree = ast.parse(source_code)
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            # Check arguments to safe_query or query
            func_name = getattr(node.func, "id", None) or getattr(node.func, "attr", None)
            if func_name in ("safe_query", "query"):
                # Check positional args: (cmd, subcmd, ...)
                if len(node.args) >= 2:
                    subcmd_arg = node.args[1]
                    if isinstance(subcmd_arg, ast.Constant):
                        assert subcmd_arg.value != "4", f"FORBIDDEN: Literal SubCMD '4' found in call to {func_name}!"
                    elif isinstance(subcmd_arg, ast.Name):
                        assert subcmd_arg.id != "REQ_EVERYDAY_TASK_RECEIVE_GOLD", f"FORBIDDEN constant {subcmd_arg.id} used!"

    # Verify no REQ_EVERYDAY_TASK_RECEIVE_GOLD or subcmd 4 in source
    assert 'REQ_EVERYDAY_TASK_RECEIVE_GOLD' not in source_code
    assert 'REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"' in source_code
    assert 'REQ_EVERYDAY_TASK_INIT = "1"' in source_code

    print("  ✓ Case 6 PASSED: SubCMD '4' is completely absent from DailyQuestTask source code.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 7: Adversarial Network Failure Handling (Fault Injection)
# ─────────────────────────────────────────────────────────────────────────────
async def test_case_network_fault_injection():
    print("▶ Case 7: Adversarial Network Fault Injection & State Isolation")

    # 7A: Fallback query fails (returns None) on empty memory
    # Empirically tests whether task crashes or safely isolates the failure
    conn_fail = AdversarialMockConnection(init_data={})
    conn_fail.custom_handlers[("2027", "1")] = None
    task_fail = DailyQuestTask(conn=conn_fail)
    res_fail = await task_fail.run()
    # Task should not crash; it returns TaskResult
    assert res_fail is not None, "Task returned None!"
    print(f"  • Sub-case 7A (Empty memory + fallback query None): Handled without crashing -> {res_fail.message}")

    # 7B: Probing Vulnerability V-01: Expired tomorrowZeroUTC when fallback query returns None
    now = int(time.time())
    conn_vuln = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": now - 3600,  # Expired 1 hour ago
            "eventInfo": {"6": 1},          # 30 pts from yesterday
            "normalRecord": {},
        }
    })
    conn_vuln.custom_handlers[("2027", "1")] = None
    task_vuln = DailyQuestTask(conn=conn_vuln)
    res_vuln = await task_vuln.run()
    
    # Check if stale points were erroneously used to send a claim packet:
    emitted_claims = [q for q in conn_vuln.sent_queries if q["cmd"] == "2027" and q["subcmd"] == "2"]
    assert len(emitted_claims) == 0, f"Vulnerability V-01: Fallback query failed, but task emitted {len(emitted_claims)} claim packet(s) using expired yesterday points: {emitted_claims}"
    print(f"  • Sub-case 7B (Expired memory + fallback query None): Safely refrained from claiming (0 claim packets emitted).")

    # 7C: Partial chest failure (Chest 1 succeeds, Chest 2 returns error code 9999)
    conn_partial = AdversarialMockConnection(init_data={
        "everydayTaskCtrl": {
            "tomorrowZeroUTC": int(time.time()) + 3600,
            "eventInfo": {"6": 1, "7": 1, "32": 1, "12": 5}, # 30 + 30 + 30 + 25 = 115 pts -> chests 1 & 2 ready
            "normalRecord": {},
        }
    })
    def handle_claim(data):
        if data.get("index") == 2:
            return {"err": 9999, "data": {}}  # Simulated server error on chest 2
        return {"err": 0, "data": {}}

    conn_partial.custom_handlers[("2027", "2")] = handle_claim
    task_partial = DailyQuestTask(conn=conn_partial)
    res_partial = await task_partial.run()

    assert res_partial.success is True, "Task run failed unexpectedly"
    assert res_partial.data["claimed_chests"] == [1], f"Expected only chest 1 claimed, got: {res_partial.data}"
    # normalRecord must have 1, but NOT 2
    normal_record = conn_partial.init_data["everydayTaskCtrl"]["normalRecord"]
    assert "1" in normal_record or 1 in normal_record, "Chest 1 missing from memory"
    assert "2" not in normal_record and 2 not in normal_record, "Failed chest 2 was erroneously marked claimed in memory!"

    print("  ✓ Case 7 PASSED: Fault injection behavior and state isolation thoroughly characterized.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 8: Bot Manager Sequencing & Auto Configurations
# ─────────────────────────────────────────────────────────────────────────────
def test_case_bot_manager_sequencing():
    print("▶ Case 8: Bot Manager Sequencing & Auto Configurations")

    # 1. REGISTERED_TASKS[-1] == DailyQuestTask
    assert REGISTERED_TASKS[-1] == DailyQuestTask, (
        f"VIOLATION: DailyQuestTask must be at index -1 in REGISTERED_TASKS. Found: {REGISTERED_TASKS[-1]}"
    )
    last_idx = len(REGISTERED_TASKS) - 1
    print(f"  • REGISTERED_TASKS length: {len(REGISTERED_TASKS)} | Last item [{last_idx}]: {REGISTERED_TASKS[-1].__name__}")

    # 2. ALWAYS_AUTO_TASKS
    assert "daily_quest" in ALWAYS_AUTO_TASKS, f"VIOLATION: 'daily_quest' missing from ALWAYS_AUTO_TASKS: {ALWAYS_AUTO_TASKS}"
    print("  • 'daily_quest' verified in ALWAYS_AUTO_TASKS.")

    # 3. DEFAULT_BOT_CONFIG
    assert "daily_quest" in DEFAULT_BOT_CONFIG["tasks"], "VIOLATION: 'daily_quest' missing from DEFAULT_BOT_CONFIG['tasks']"
    assert DEFAULT_BOT_CONFIG["tasks"]["daily_quest"]["enabled"] is True, "VIOLATION: 'daily_quest' enabled must be True"
    print("  • DEFAULT_BOT_CONFIG['tasks']['daily_quest'] verified as {'enabled': True}.")

    print("  ✓ Case 8 PASSED: Bot Manager sequencing and registration verified 100%.")


# ─────────────────────────────────────────────────────────────────────────────
# Test 9: Database Integrity (Direct SQLite query)
# ─────────────────────────────────────────────────────────────────────────────
def test_case_database_integrity():
    print("▶ Case 9: Database Integrity in database/castles.db (100% check)")

    db_path = os.path.join(_ROOT, "database", "castles.db")
    assert os.path.exists(db_path), f"Database not found at {db_path}"

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()
    conn.close()

    total_castles = len(rows)
    assert total_castles > 0, "No castles in castle_states table!"

    verified_count = 0
    for castle_id, email, raw_cfg in rows:
        cfg = json.loads(raw_cfg or "{}")
        assert "daily_quest" in cfg, f"Castle {email} ({castle_id}) is missing 'daily_quest'!"
        dq_cfg = cfg["daily_quest"]
        assert isinstance(dq_cfg, dict), f"Castle {email} 'daily_quest' is not a dict: {dq_cfg}"
        assert dq_cfg.get("enabled") is True, f"Castle {email} 'daily_quest.enabled' is not True: {dq_cfg}"
        verified_count += 1
        print(f"  • Verified castle: {email} (ID: {castle_id}) -> daily_quest: {dq_cfg}")

    assert verified_count == total_castles, f"Mismatch: verified {verified_count} of {total_castles}"
    print(f"  ✓ Case 9 PASSED: 100% of castles ({verified_count}/{total_castles}) have daily_quest.enabled == True.")


# ─────────────────────────────────────────────────────────────────────────────
# Main Runner
# ─────────────────────────────────────────────────────────────────────────────
async def run_adversarial_suite():
    print("=" * 80)
    print("🛡️  EMPIRICAL ADVERSARIAL STRESS TEST SUITE — REQUIREMENT R1")
    print("=" * 80)

    await test_case_0_points()
    await test_case_500_points_all_claimed()
    await test_case_180_points_chests_1_to_3_unclaimed()
    await test_case_empty_and_none_init_data()
    await test_case_expired_tomorrow_zero_utc()
    test_case_confirm_subcmd_4_never_called()
    await test_case_network_fault_injection()
    test_case_bot_manager_sequencing()
    test_case_database_integrity()

    print("=" * 80)
    print("🏆 ALL 9 EMPIRICAL ADVERSARIAL CHALLENGES COMPLETED WITH 100% PASS RATE!")
    print("=" * 80)


if __name__ == "__main__":
    asyncio.run(run_adversarial_suite())
