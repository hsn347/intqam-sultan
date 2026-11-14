# -*- coding: utf-8 -*-
"""
test_forensic_deep.py — Deep Forensic and Adversarial Verification Suite
Auditor: auditor_memory_r2
Milestone 3 Iteration 2: Live Memory & 0-Network Re-Audit
"""
import sys
import os
import json
import asyncio
import time

sys.path.insert(0, os.path.abspath("."))
from tasks.building import BuildingTask, BUILDING_INFO

class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        self.network_calls = []
        self.is_connected = True
        self.creds = type("Creds", (), {"uid": "1001", "kingdom_id": 1, "server_name": "K1"})()

    def get_ctrl(self, name):
        return self.init_data.get(name, {})

    async def safe_query(self, cmd, subcmd, data, **kwargs):
        self.network_calls.append((cmd, subcmd, data))
        return {"err": "0", "data": {}}

    async def query(self, cmd, subcmd, data, **kwargs):
        self.network_calls.append((cmd, subcmd, data))
        return {"err": "0", "data": {}}


async def test_multi_instance_sync():
    """Verify multi-instance building state sync when multiple instances of same bid exist."""
    print("--- Testing Multi-Instance In-Memory Sync ---")
    blist = [
        {"binfo": {"bid": "201", "lv": "10", "index": "1101", "state": "0", "curres": "100"}},
        {"binfo": {"bid": "201", "lv": "12", "index": "1102", "state": "0", "curres": "200"}},
        {"binfo": {"bid": "201", "lv": "14", "index": "1103", "state": "0", "curres": "300"}},
        {"binfo": {"bid": "201", "lv": "8",  "index": "1104", "state": "0", "curres": "400"}},
        # Malformed entries to test robustness
        None,
        {"binfo": None},
        "not_a_dict",
    ]
    init_data = {
        "cityCtrl": {
            "level": 20,
            "blist": blist,
            "reslist": {"1002": "5000000", "1003": "5000000"},
            "queue": {}
        },
        "queueCtrl": {},
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 5}}
    }
    conn = MockConn(init_data)
    task = BuildingTask(conn, log_func=lambda m: None)

    # 1. Upgrade instance at index 1102 to Lv.13
    task.sync_in_memory_upgrade(
        qtype="1200",
        bid="201",
        target_lv=13,
        index="1102",
        cost_time=1200,
        cost_res={"1002": 10000}
    )

    # Verify blist states
    b_1101 = next(b["binfo"] for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and b["binfo"].get("index") == "1101")
    b_1102 = next(b["binfo"] for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and b["binfo"].get("index") == "1102")
    b_1103 = next(b["binfo"] for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and b["binfo"].get("index") == "1103")
    
    assert b_1101["state"] == "0", f"1101 mutated to state {b_1101['state']}"
    assert b_1102["state"] == "2", f"1102 not state 2: {b_1102['state']}"
    assert b_1103["state"] == "0", f"1103 mutated to state {b_1103['state']}"

    # 2. Complete queue 1200 with explicit index
    task.sync_in_memory_completed_queue(qtype="1200", bid="201", target_lv=13, index="1102")
    assert b_1102["state"] == "0", f"1102 failed to revert to state 0: {b_1102['state']}"
    assert b_1102["lv"] == "13", f"1102 failed to upgrade to lv 13: {b_1102['lv']}"
    assert b_1101["lv"] == "10", f"1101 level mutated: {b_1101['lv']}"
    assert b_1103["lv"] == "14", f"1103 level mutated: {b_1103['lv']}"
    print("  [PASS] Explicit index sync verified.")

    # 3. Upgrade instance at index 1104 without passing index to completion (fallback to queueCtrl data index)
    task.sync_in_memory_upgrade(
        qtype="1201",
        bid="201",
        target_lv=9,
        index="1104",
        cost_time=600,
        cost_res={"1002": 5000}
    )
    b_1104 = next(b["binfo"] for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and b["binfo"].get("index") == "1104")
    assert b_1104["state"] == "2", f"1104 not state 2: {b_1104['state']}"

    # Complete WITHOUT passing index (target_index resolved from queueCtrl["1201"]["data"]["index"])
    task.sync_in_memory_completed_queue(qtype="1201", bid="201", target_lv=9)
    assert b_1104["state"] == "0", f"1104 failed to revert to state 0: {b_1104['state']}"
    assert b_1104["lv"] == "9", f"1104 failed to upgrade to lv 9: {b_1104['lv']}"
    print("  [PASS] Implicit queueCtrl index sync verified.")

    # 4. Fallback test: What if queueCtrl has no index, but one building is state == "2"?
    task.sync_in_memory_upgrade(
        qtype="1200",
        bid="201",
        target_lv=15,
        index="1103",
        cost_time=1800
    )
    assert b_1103["state"] == "2"
    # Artificially remove index from queueCtrl and active_queues
    init_data["queueCtrl"]["1200"]["data"].pop("index", None)
    task.active_queues["1200"].pop("index", None)
    task.active_queues["1200"]["raw"]["data"].pop("index", None)

    task.sync_in_memory_completed_queue(qtype="1200", bid="201", target_lv=15, index=None)
    assert b_1103["state"] == "0", f"1103 fallback state == '2' failed: {b_1103['state']}"
    assert b_1103["lv"] == "15", f"1103 fallback level failed: {b_1103['lv']}"
    print("  [PASS] Fallback to state == '2' verified.")


async def test_construct_0_network_leak():
    """Verify construct_missing_building makes exactly 1 network call (CMD 1001/2) and 0 query leaks."""
    print("--- Testing Construct 0-Network Leak Removal ---")
    init_data = {
        "cityCtrl": {
            "level": 15,
            "blist": [
                {"binfo": {"bid": "101", "lv": "15", "index": "1050", "state": "0"}},
                {"binfo": {"bid": "102", "lv": "14", "index": "1053", "state": "0"}},
            ],
            "reslist": {"1002": "50000000", "1003": "50000000", "1004": "50000000", "1005": "50000000"},
            "queue": {},
            "arealist": [1220]
        },
        "queueCtrl": {},
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 5}}
    }
    conn = MockConn(init_data)
    task = BuildingTask(conn, log_func=lambda m: None)

    # Construct missing Barracks (bid "116")
    ok, msg = await task.construct_missing_building("116")
    assert ok, f"Construct failed: {msg}"

    # Verify network calls
    print(f"  Network calls made during construct: {conn.network_calls}")
    assert len(conn.network_calls) == 1, f"Expected exactly 1 network call, got {len(conn.network_calls)}: {conn.network_calls}"
    cmd, subcmd, payload = conn.network_calls[0]
    assert cmd == "1001" and subcmd == "2", f"Unexpected network call: {cmd}/{subcmd}"
    assert payload.get("bid") == "116"
    assert payload.get("mode") == "0"

    # Verify in-memory state after construct
    assert "1200" in task.active_queues, "1200 not in active_queues!"
    assert "1200" in init_data["queueCtrl"], "1200 not in queueCtrl!"
    q_data = init_data["queueCtrl"]["1200"]["data"]
    assert q_data["bid"] == "116"
    assert q_data["lv"] == "1"

    # Check blist has new building in state 2
    blist = init_data["cityCtrl"]["blist"]
    found = [b for b in blist if b.get("binfo", {}).get("bid") == "116"]
    assert len(found) == 1, f"Expected 1 entry for bid 116 in blist, found {len(found)}"
    assert found[0]["binfo"]["state"] == "2"
    assert found[0]["binfo"]["lv"] == "1"
    print("  [PASS] Construct 0-network leak completely absent; in-memory sync verified.")


async def test_harvest_curres_check():
    """Verify harvest_building_resource is bypassed when curres <= 0 and invoked when curres > 0."""
    print("--- Testing Harvest curres > 0 Check ---")
    # Case A: curres == "0.0" -> NO harvest network call
    init_data_a = {
        "cityCtrl": {
            "level": 15,
            "blist": [
                {"binfo": {"bid": "201", "lv": "10", "index": "1101", "state": "0", "curres": "0.0", "iid": "10001"}},
            ],
            "reslist": {"1002": "50000000", "1003": "50000000", "1004": "50000000", "1005": "50000000"},
            "queue": {},
        },
        "queueCtrl": {},
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 5}}
    }
    conn_a = MockConn(init_data_a)
    task_a = BuildingTask(conn_a, log_func=lambda m: None)

    cand_a = {
        "bid": "201",
        "target_lv": 11,
        "current_lv": 10,
        "action": "upgrade",
        "instance": {"bid": "201", "lv": "10", "index": "1101", "curres": "0.0", "iid": "10001"}
    }
    ok, msg, qtype = await task_a.execute_building_action(cand_a)
    assert ok, f"Upgrade failed: {msg}"
    print(f"  Calls with curres='0.0': {conn_a.network_calls}")
    assert not any(c[0] == "1001" and c[1] == "8" for c in conn_a.network_calls), "VIOLATION: harvest (1001/8) sent when curres is 0.0!"
    print("  [PASS] Harvest bypassed for curres='0.0'.")

    # Case B: curres == 0 (int) -> NO harvest network call
    conn_b = MockConn(init_data_a)
    task_b = BuildingTask(conn_b, log_func=lambda m: None)
    cand_b = {
        "bid": "201",
        "target_lv": 11,
        "current_lv": 10,
        "action": "upgrade",
        "instance": {"bid": "201", "lv": "10", "index": "1101", "curres": 0, "iid": "10001"}
    }
    ok, msg, qtype = await task_b.execute_building_action(cand_b)
    assert not any(c[0] == "1001" and c[1] == "8" for c in conn_b.network_calls), "VIOLATION: harvest sent when curres is int 0!"
    print("  [PASS] Harvest bypassed for curres=0.")

    # Case C: curres == "15000.5" -> Harvest MUST be called before upgrade
    conn_c = MockConn(init_data_a)
    task_c = BuildingTask(conn_c, log_func=lambda m: None)
    cand_c = {
        "bid": "201",
        "target_lv": 11,
        "current_lv": 10,
        "action": "upgrade",
        "instance": {"bid": "201", "lv": "10", "index": "1101", "curres": "15000.5", "iid": "10001"}
    }
    ok, msg, qtype = await task_c.execute_building_action(cand_c)
    print(f"  Calls with curres='15000.5': {conn_c.network_calls}")
    assert any(c[0] == "1001" and c[1] == "8" for c in conn_c.network_calls), "Harvest was NOT called when curres > 0!"
    assert conn_c.network_calls[0] == ("1001", "8", {"bid": 201, "iid": 10001}), "Harvest call parameters incorrect!"
    assert conn_c.network_calls[1][0] == "1001" and conn_c.network_calls[1][1] == "3", "Upgrade not called after harvest!"
    print("  [PASS] Harvest correctly dispatched when curres > 0.")


async def test_0_network_preflight_idle_and_busy():
    """Verify 0-network pre-flight on idle and busy queues under task.run()."""
    print("--- Testing 0-Network Pre-Flight (Idle & Busy Queues) ---")
    now_ts = time.time()

    # Case 1: Idle Queues, speedup=False -> 0 network calls for queue refresh
    init_data_idle = {
        "cityCtrl": {
            "level": 30,
            "blist": [{"binfo": {"bid": "101", "lv": "30", "index": "1050", "state": "0"}}],
            "reslist": {},
            "queue": {}
        },
        "queueCtrl": {},
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 10}}
    }
    conn_idle = MockConn(init_data_idle)
    task_idle = BuildingTask(conn_idle, config={"upgrade_castle": False, "upgrade_support_buildings": False}, log_func=lambda m: None)
    res_idle = await task_idle.run()
    assert len(conn_idle.network_calls) == 0, f"VIOLATION: Network calls during idle pre-flight: {conn_idle.network_calls}"
    print("  [PASS] 0-Network preflight for idle queues verified.")

    # Case 2: Busy Queues (both 1200 and 1201 busy > 60s), speedup=False -> immediate return with 0 network calls
    init_data_busy = {
        "cityCtrl": {
            "level": 30,
            "blist": [
                {"binfo": {"bid": "101", "lv": "30", "index": "1050", "state": "0"}},
                {"binfo": {"bid": "102", "lv": "29", "index": "1053", "state": "2"}}
            ],
            "reslist": {},
            "queue": {}
        },
        "queueCtrl": {
            "1200": {"starttime": now_ts, "totaltime": 3600, "data": {"bid": "102", "lv": "30", "index": "1053"}},
            "1201": {"starttime": now_ts, "totaltime": 7200, "data": {"bid": "116", "lv": "25", "index": "1064"}}
        },
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 10}}
    }
    conn_busy = MockConn(init_data_busy)
    task_busy = BuildingTask(conn_busy, config={"upgrade_castle": True, "speedup_castle": False}, log_func=lambda m: None)
    res_busy = await task_busy.run()
    print(f"  Result message for busy queues: {res_busy.message}")
    print(f"  Network calls made: {len(conn_busy.network_calls)}")
    assert len(conn_busy.network_calls) == 0, f"VIOLATION: Network calls during busy queue pre-flight: {conn_busy.network_calls}"
    assert "مشغولة بالكامل" in res_busy.message
    print("  [PASS] 0-Network exit guard for busy queues verified.")


async def test_resource_deficit_preflight():
    """Verify in-memory resource deficit check prevents box opening when resources are sufficient."""
    print("--- Testing In-Memory Resource Deficit Pre-Flight ---")
    init_data = {
        "cityCtrl": {
            "level": 15,
            "blist": [{"binfo": {"bid": "102", "lv": "14", "index": "1053", "state": "0"}}],
            "reslist": {
                "1002": "100000000",  # 100M Wood (sufficient)
                "1003": "100000000",  # 100M Food (sufficient)
                "1004": "100000000",  # 100M Iron (sufficient)
                "1005": "100000000",  # 100M Silver (sufficient)
            },
            "queue": {}
        },
        "queueCtrl": {},
        "backpackCtrl": {},
        "lordInfoCtrl": {"vip": {"level": 5}}
    }
    conn = MockConn(init_data)
    task = BuildingTask(conn, log_func=lambda m: None)

    cand = {
        "bid": "102",
        "target_lv": 15,
        "current_lv": 14,
        "action": "upgrade",
        "instance": {"bid": "102", "lv": "14", "index": "1053"}
    }
    ok, msg, qtype = await task.execute_building_action(cand)
    assert ok, f"Upgrade failed: {msg}"
    # Verify no ensure_resources query (e.g. backpack query or chest opening) was called
    assert len(conn.network_calls) == 1, f"Expected 1 call (upgrade), got {len(conn.network_calls)}: {conn.network_calls}"
    assert conn.network_calls[0][0] == "1001" and conn.network_calls[0][1] == "3"
    print("  [PASS] 0 box opens when in-memory balance is sufficient.")


async def run_all():
    await test_multi_instance_sync()
    await test_construct_0_network_leak()
    await test_harvest_curres_check()
    await test_0_network_preflight_idle_and_busy()
    await test_resource_deficit_preflight()
    print("\n>>> ALL FORENSIC DEEP AUDIT CHECKS PASSED WITH 0 DEFECTS! <<<")

if __name__ == "__main__":
    asyncio.run(run_all())
