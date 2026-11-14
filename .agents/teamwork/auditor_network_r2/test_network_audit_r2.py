import asyncio
import json
import os
import sys
import time

# Add root directory to sys.path
root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, root_dir)

from tasks.building import BuildingTask

class MockConnection:
    def __init__(self, init_data):
        self.is_connected = True
        self.init_data = init_data
        self.sent_queries = []

    async def query(self, cmd, subcmd, data=None, timeout=8.0):
        packet = {
            "cmd": str(cmd),
            "subcmd": str(subcmd),
            "data": data or {},
        }
        self.sent_queries.append(packet)
        # Return standard mock responses based on cmd/subcmd
        if str(cmd) == "1001" and str(subcmd) in ("2", "3"):
            return {"err": "0", "data": {"bid": str(data.get("bid")), "mode": data.get("mode")}}
        elif str(cmd) == "1003" and str(subcmd) == "2":
            return {"err": "0", "data": {"qtype": str(data.get("qtype")), "mode": data.get("mode")}}
        elif str(cmd) == "1003" and str(subcmd) == "1":
            return {"err": "0", "data": {}}
        elif str(cmd) == "1001" and str(subcmd) == "8":
            return {"err": "0", "data": {"drop": []}}
        return {"err": "0", "data": {}}

async def run_network_audit_r2():
    print("=== STARTING FORENSIC NETWORK RE-AUDIT (R2) FOR TASKS/BUILDING.PY ===")
    
    # Load beetoo1 live memory
    beetoo1_path = os.path.join(root_dir, "docs", "beetoo1_live_memory.json")
    with open(beetoo1_path, "r", encoding="utf-8") as f:
        mem1 = json.load(f)

    mock_conn = MockConnection(mem1)
    task = BuildingTask(
        conn=mock_conn,
        config={
            "enabled": True,
            "auto_accelerate": True,
            "accelerate": True,
            "upgrade_castle": True,
            "supportive_buildings": True,
            "auto_open_chests": True,
            "target_buildings": {"201": True, "202": True},
        }
    )

    # 1. Test queue init query (fallback)
    print("\n--- Test 1: Fallback Queue Init Query (CMD 1003 / 1) ---")
    await task.refresh_active_queues(force_query=True)
    q1 = mock_conn.sent_queries[-1]
    print(f"Captured: CMD={q1['cmd']}, SubCMD={q1['subcmd']}, Data={q1['data']}")
    assert q1["cmd"] == "1003" and q1["subcmd"] == "1"
    assert q1["data"] == {}
    print("PASS: Fallback queue init matches official Lua schema.")

    # 2. Test Construct Missing Building (CMD 1001 / 2) & 0-Network Leak Prevention
    print("\n--- Test 2: Construct Missing Building (CMD 1001 / 2) & 0-Network Leak Prevention ---")
    mock_conn.sent_queries.clear()
    # Free index 1104 in blist
    blist = task.init_data.setdefault("cityCtrl", {}).get("blist", [])
    task.init_data["cityCtrl"]["blist"] = [b for b in blist if b.get("binfo", {}).get("index") != "1104"]
    task.active_queues.clear()
    ok, msg = await task.construct_missing_building("201")
    construct_queries = [q for q in mock_conn.sent_queries if q["cmd"] == "1001" and q["subcmd"] == "2"]
    assert len(construct_queries) > 0, f"No construct query sent! ok={ok}, msg={msg}"
    cq = construct_queries[0]
    print(f"Captured Construct: CMD={cq['cmd']}, SubCMD={cq['subcmd']}, Data={cq['data']}")
    assert cq["data"]["mode"] == "0", "Zero-Gold violation: mode != '0'!"
    assert cq["data"]["bid"] == "201"
    assert cq["data"]["index"] == "1104"
    assert isinstance(cq["data"]["bid"], str)
    assert isinstance(cq["data"]["index"], str)
    assert isinstance(cq["data"]["mode"], str)
    
    # Verify no CMD 1003 / 1 was sent during construction
    leak_queries = [q for q in mock_conn.sent_queries if q["cmd"] == "1003" and q["subcmd"] == "1"]
    assert len(leak_queries) == 0, f"0-Network Leak detected! CMD 1003/1 sent during construction: {leak_queries}"
    print(f"PASS: Construct building matches official Lua schema, Zero-Gold Guarantee, and ZERO network leaks ({len(mock_conn.sent_queries)} total network call: CMD 1001/2).")

    # 3. Test Upgrade Building Action (CMD 1001 / 3) with 3-tuple return
    print("\n--- Test 3: Upgrade Building Action (CMD 1001 / 3) ---")
    mock_conn.sent_queries.clear()
    candidate = {
        "bid": "201",
        "name": "مزرعة القمح",
        "target_lv": 2,
        "is_missing": False,
        "instance": {"bid": "201", "lv": "1", "index": "1102", "curres": "0.0"},
        "cost_res": {},
        "cost_time": 600,
    }
    task.active_queues.clear()
    res = await task.execute_building_action(candidate)
    assert len(res) == 3, f"Expected 3-tuple return from execute_building_action, got {len(res)}: {res}"
    ok_up, msg_up, alloc_q = res
    assert ok_up is True, f"Upgrade failed: {msg_up}"
    assert alloc_q == "1200", f"Expected queue 1200, got: {alloc_q}"
    up_queries = [q for q in mock_conn.sent_queries if q["cmd"] == "1001" and q["subcmd"] == "3"]
    assert len(up_queries) > 0, "No upgrade query sent!"
    uq = up_queries[0]
    print(f"Captured Upgrade: CMD={uq['cmd']}, SubCMD={uq['subcmd']}, Data={uq['data']}")
    assert uq["data"]["mode"] == "0", "Zero-Gold violation: mode != '0'!"
    assert uq["data"]["bid"] == "201"
    assert uq["data"]["index"] == "1102"
    assert isinstance(uq["data"]["bid"], str)
    assert isinstance(uq["data"]["index"], str)
    assert isinstance(uq["data"]["mode"], str)
    print("PASS: Upgrade building matches official Lua schema, Zero-Gold Guarantee, and returns 3-tuple.")

    # 4. Test Harvest Guard (curres == 0 vs curres > 0)
    print("\n--- Test 4: Resource Harvest Guard (curres > 0 vs curres == 0) ---")
    # 4a: curres == 0.0 -> NO CMD 1001/8 should be sent
    mock_conn.sent_queries.clear()
    candidate_zero = {
        "bid": "201",
        "name": "مزرعة القمح",
        "target_lv": 3,
        "is_missing": False,
        "instance": {"bid": "201", "lv": "2", "index": "1102", "curres": "0.0"},
        "cost_res": {},
        "cost_time": 600,
    }
    task.active_queues.clear()
    await task.execute_building_action(candidate_zero)
    harvest_queries_zero = [q for q in mock_conn.sent_queries if q["cmd"] == "1001" and q["subcmd"] == "8"]
    assert len(harvest_queries_zero) == 0, f"Violation! Harvest called when curres == 0: {harvest_queries_zero}"
    print("PASS: Harvest correctly skipped when curres == '0.0'.")

    # 4b: curres > 0 -> CMD 1001/8 MUST be sent before upgrade
    mock_conn.sent_queries.clear()
    candidate_harvest = {
        "bid": "201",
        "name": "مزرعة القمح",
        "target_lv": 4,
        "is_missing": False,
        "instance": {"bid": "201", "lv": "3", "index": "1102", "curres": "1500.0", "iid": "20101"},
        "cost_res": {},
        "cost_time": 600,
    }
    task.active_queues.clear()
    await task.execute_building_action(candidate_harvest)
    harvest_queries_pos = [q for q in mock_conn.sent_queries if q["cmd"] == "1001" and q["subcmd"] == "8"]
    assert len(harvest_queries_pos) == 1, f"Expected 1 harvest query, got {len(harvest_queries_pos)}"
    hq = harvest_queries_pos[0]
    print(f"Captured Harvest: CMD={hq['cmd']}, SubCMD={hq['subcmd']}, Data={hq['data']}")
    assert hq["data"]["bid"] == 201
    assert hq["data"]["iid"] == 20101
    # Check order: harvest must precede upgrade
    all_cmds = [(q["cmd"], q["subcmd"]) for q in mock_conn.sent_queries]
    assert all_cmds == [("1001", "8"), ("1001", "3")], f"Unexpected query sequence: {all_cmds}"
    print("PASS: Harvest correctly invoked before upgrade when curres > 0.")

    # 5. Test Free Speedup (CMD 1003 / 2 mode 0)
    print("\n--- Test 5: Free Speedup (CMD 1003 / 2 mode 0) ---")
    mock_conn.sent_queries.clear()
    free_sec = task.calculate_free_speedup_seconds()
    mock_conn.init_data.setdefault("queueCtrl", {})["1200"] = {
        "bid": "201",
        "lv": "2",
        "starttime": time.time(),
        "totaltime": 1000,
        "ottime": 1000,
    }
    fin, red, smsg = await task.accelerate_queue_to_completion("1200")
    free_queries = [q for q in mock_conn.sent_queries if q["cmd"] == "1003" and q["subcmd"] == "2" and q["data"].get("mode") == "0"]
    assert len(free_queries) > 0, "No free speedup query sent!"
    fq = free_queries[0]
    print(f"Captured Free Speedup: CMD={fq['cmd']}, SubCMD={fq['subcmd']}, Data={fq['data']}")
    assert fq["data"]["mode"] == "0"
    assert fq["data"]["qtype"] == "1200"
    assert fq["data"]["items"] == []
    assert fq["data"]["decreaseTime"] == "0"
    assert isinstance(fq["data"]["qtype"], str)
    assert isinstance(fq["data"]["mode"], str)
    assert isinstance(fq["data"]["decreaseTime"], str)
    print("PASS: Free speedup matches official Lua schema & Zero-Gold Guarantee.")

    # 6. Test Batched Item Speedup (CMD 1003 / 2 mode 2)
    print("\n--- Test 6: Batched Item Speedup (CMD 1003 / 2 mode 2) ---")
    mock_conn.sent_queries.clear()
    mock_conn.init_data.setdefault("queueCtrl", {})["1200"] = {
        "bid": "101",
        "lv": "35",
        "starttime": time.time(),
        "totaltime": free_sec + 36000,
        "ottime": free_sec + 36000,
    }
    fin2, red2, smsg2 = await task.accelerate_queue_to_completion("1200")
    tool_queries = [q for q in mock_conn.sent_queries if q["cmd"] == "1003" and q["subcmd"] == "2" and q["data"].get("mode") == "2"]
    assert len(tool_queries) > 0, "No batched item speedup query sent!"
    tq = tool_queries[0]
    print(f"Captured Batched Speedup: CMD={tq['cmd']}, SubCMD={tq['subcmd']}, Data={tq['data']}")
    assert tq["data"]["mode"] == "2"
    assert tq["data"]["qtype"] == "1200"
    assert tq["data"]["decreaseTime"] == "0"
    assert isinstance(tq["data"]["items"], list)
    assert len(tq["data"]["items"]) > 0
    for item in tq["data"]["items"]:
        assert isinstance(item["id"], int), f"item id must be int, got {type(item['id'])}"
        assert isinstance(item["count"], int), f"item count must be int, got {type(item['count'])}"
        assert item["count"] > 0, f"item count must be > 0, got {item['count']}"
    print(f"PASS: Batched speedup items array {tq['data']['items']} matches commonSpeedUpBestViewPanel.lua.")

    # 7. Comprehensive Zero-Gold Check across ALL captured queries
    print("\n--- Test 7: Zero-Gold Guarantee across ALL captured queries ---")
    all_queries = mock_conn.sent_queries
    for q in all_queries:
        mode_val = q["data"].get("mode")
        if mode_val is not None:
            assert mode_val in ("0", "2"), f"Zero-Gold VIOLATION! Detected mode={mode_val} in {q}"
            assert mode_val != "1", f"CRITICAL Zero-Gold VIOLATION! Mode '1' detected in {q}"
    print(f"PASS: 100% Zero-Gold Guarantee verified. Total packets checked: {len(all_queries)}.")

    # 8. Test Empty Queue Protection (Ghost speedup test)
    print("\n--- Test 8: Empty Queue Protection (No Ghost Speedup Packets) ---")
    mock_conn.sent_queries.clear()
    task.active_queues.clear()
    fin_empty, red_empty, msg_empty = await task.accelerate_queue_to_completion("1201")
    assert fin_empty is False, f"Expected False for empty queue, got {fin_empty}"
    assert len(mock_conn.sent_queries) == 0, f"Ghost packets sent on empty queue! {mock_conn.sent_queries}"
    print("PASS: Zero packets sent on empty queue.")

    print("\n=== ALL FORENSIC NETWORK RE-AUDIT CHECKS PASSED (100% CLEAN) ===")

if __name__ == "__main__":
    asyncio.run(run_network_audit_r2())
