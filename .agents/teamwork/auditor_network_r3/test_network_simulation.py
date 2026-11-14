import sys
import os
sys.path.insert(0, os.path.abspath("."))

import asyncio
import time
from unittest.mock import MagicMock
from tasks.building import BuildingTask
from tasks.base_task import TaskResult

async def test_queue_busy_prevention():
    mock_conn = MagicMock()
    now = time.time()
    mock_conn.init_data = {
        "lordInfoCtrl": {"vip": {"level": 10, "vipEndTime": 0}},
        "cityCtrl": {
            "level": 25,
            "blist": [{"binfo": {"bid": "101", "lv": 25, "index": "1"}}],
            "queue": {},
            "reslist": {"1": 1000000, "2": 1000000, "3": 1000000, "4": 1000000}
        },
        "queueCtrl": {
            "1200": {"starttime": now - 100, "totaltime": 100000, "data": {"bid": "101", "lv": 26, "index": "1"}}
        },
        "backpackCtrl": {}
    }
    
    # Track network queries
    queried_cmds = []
    async def mock_safe_query(cmd, subcmd, data=None, **kwargs):
        queried_cmds.append((cmd, subcmd, data, kwargs))
        return {"err": "0", "data": {}}
        
    task = BuildingTask(mock_conn)
    task.safe_query = mock_safe_query
    
    # Test case 1: speedup disabled
    task.config = {"castle": True, "buildings": True, "speedup": False}
    res = await task.run()
    print("Test 1 (speedup=False) Result success:", res.success)
    print("Test 1 (speedup=False) Result message:", res.message)
    print("Test 1 (speedup=False) Network queries count:", len(queried_cmds))
    assert len(queried_cmds) == 0, f"Expected 0 queries, got {len(queried_cmds)}"
    
    # Test case 2: speedup enabled, but backpack has no items and remain_time > free_sec
    queried_cmds.clear()
    task.config = {"castle": True, "buildings": True, "speedup": True}
    res2 = await task.run()
    print("Test 2 (speedup=True, no items) Result success:", res2.success)
    print("Test 2 (speedup=True, no items) Result message:", res2.message)
    print("Test 2 (speedup=True, no items) Network queries count:", len(queried_cmds))
    for cmd, subcmd, d, kw in queried_cmds:
        assert not (cmd == "1001" and subcmd in ("2", "3")), f"Illegal upgrade query: {cmd}/{subcmd}"
    assert len(queried_cmds) == 0, f"Expected 0 queries when no speedup items, got {len(queried_cmds)}"
    
    # Test case 3: verify max slots is 1
    slots = task.calculate_max_build_slots()
    assert slots == 1, f"Expected 1 slot for expired VIP, got {slots}"
    print("Test 3: calculate_max_build_slots() correctly returned 1.")

    # Test case 4: speedup finishes building, freeing slot, and enables next upgrade
    mock_conn.init_data["queueCtrl"] = {
        "1200": {"starttime": now - 500, "totaltime": 600, "data": {"bid": "102", "lv": 25, "index": "2"}}
    }
    queried_cmds.clear()
    task.config = {"castle": True, "buildings": False, "speedup": True}
    res4 = await task.run()
    print("\nTest 4 (speedup finishes building and enables upgrade):")
    print("Queries dispatched:")
    for c, sc, d, kw in queried_cmds:
        print(f"  CMD {c} SubCMD {sc}: data={d}, delays=({kw.get('min_delay')}, {kw.get('max_delay')})")
    
    # Verify first query was CMD 1003/2 with mode '0'
    assert len(queried_cmds) > 0, "Expected queries"
    assert queried_cmds[0][0] == "1003" and queried_cmds[0][1] == "2", "First query must be speedup"
    assert queried_cmds[0][2]["mode"] == "0", "Speedup mode must be '0'"
    print("Test 4 PASSED: Free speedup dispatched with mode '0' followed by proper cascade!")

    print("\nALL SIMULATION CHECKS PASSED: Zero Err_QUEUE_BUSY queries dispatched!")

if __name__ == "__main__":
    asyncio.run(test_queue_busy_prevention())

