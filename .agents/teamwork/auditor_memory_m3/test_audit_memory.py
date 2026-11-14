# -*- coding: utf-8 -*-
"""
test_audit_memory.py — Independent Memory Path and 0-Network Forensic Verification
"""
import sys
import os
sys.path.insert(0, os.path.abspath("."))

import json
import asyncio
import time
from tasks.building import BuildingTask, VIP_FREE_SPEEDUP_SECONDS, BASE_FREE_SPEEDUP_SECONDS

class DummyConn:
    def __init__(self, init_data):
        self.init_data = init_data
        self.network_calls = []
        
    def get_ctrl(self, name):
        return self.init_data.get(name, {})
        
    async def safe_query(self, cmd, subcmd, data, **kwargs):
        self.network_calls.append((cmd, subcmd, data))
        return {'err': '0', 'data': {}}

async def run_audit():
    for path in ['docs/beetoo1_live_memory.json', 'docs/beetoo3_live_memory.json']:
        print(f"\n==========================================")
        print(f"AUDITING: {path}")
        print(f"==========================================")
        with open(path, 'r', encoding='utf-8') as f:
            init_data = json.load(f)
            
        conn = DummyConn(init_data)
        task = BuildingTask(conn, log_func=lambda msg: None)
        
        # 1. cityCtrl & blist
        buildings = task._get_city_buildings()
        print(f"1. cityCtrl.blist count: {len(buildings)}")
        assert len(buildings) > 0, "No buildings found in cityCtrl.blist!"
        
        # Check castle level extraction
        clv = task._get_castle_level()
        print(f"   Castle Level extracted: {clv}")
        assert clv > 0, "Castle level could not be extracted!"
        
        # Check castle instance
        c_inst = task.get_castle_instance()
        print(f"   Castle instance bid: {c_inst.get('bid')}, lv: {c_inst.get('lv')}, index: {c_inst.get('index')}")
        assert str(c_inst.get('bid')) == '101', "Castle instance bid is not 101!"
        
        # Check open areas
        areas = task._get_open_areas()
        print(f"   Open areas (arealist): {areas}")
        
        # 2. queueCtrl & 0-Network Pre-flight
        conn.network_calls.clear()
        queues = await task.refresh_active_queues(force_query=False)
        print(f"2. refresh_active_queues(force_query=False): {queues}")
        print(f"   Network calls during refresh: {len(conn.network_calls)}")
        assert len(conn.network_calls) == 0, f"VIOLATION: Network query fired! Calls: {conn.network_calls}"
        
        # 3. Builder Slots & cityCtrl.queue["1201"] & VIP level
        slots = task.calculate_max_build_slots()
        lord_vip = init_data.get("lordInfoCtrl", {}).get("vip", {})
        vip_lv = lord_vip.get("level", 0)
        cq1201 = init_data.get("cityCtrl", {}).get("queue", {}).get("1201", {})
        print(f"3. calculate_max_build_slots: {slots} (VIP lv: {vip_lv}, cityCtrl.queue.1201: {cq1201})")
        if vip_lv >= 2:
            assert slots == 2, f"VIP level is {vip_lv} >= 2, but max slots returned was {slots}!"
            
        # 4. VIP Free Speedup Seconds
        free_sec = task.calculate_free_speedup_seconds()
        expected_free_sec = VIP_FREE_SPEEDUP_SECONDS.get(vip_lv, BASE_FREE_SPEEDUP_SECONDS)
        print(f"4. calculate_free_speedup_seconds: {free_sec} (expected: {expected_free_sec})")
        assert free_sec == expected_free_sec, f"Free speedup mismatch: got {free_sec}, expected {expected_free_sec}"
        
        # 5. Building Internal Activity Check
        print(f"5. Internal Activity checks:")
        for bid_check in ["113", "116", "117", "118", "119", "120", "206", "115"]:
            busy, reason = task.is_building_busy_with_activity(bid_check)
            if busy:
                print(f"   Bid {bid_check}: BUSY -> {reason}")
            else:
                print(f"   Bid {bid_check}: IDLE")
                
        # 6. In-Memory Upgrade Sync Verification
        print(f"6. Testing sync_in_memory_upgrade...")
        res_before = dict(init_data.get("cityCtrl", {}).get("reslist", {}))
        test_cost_res = {"1002": 50000, "1003": 25000}
        task.sync_in_memory_upgrade(
            qtype="1200",
            bid="201",
            target_lv=15,
            index="1102",
            cost_time=1800,
            cost_res=test_cost_res
        )
        # Verify queueCtrl was updated
        assert "1200" in init_data.get("queueCtrl", {}), "1200 not in queueCtrl after sync_in_memory_upgrade!"
        q1200 = init_data["queueCtrl"]["1200"]
        assert q1200["data"]["bid"] == "201"
        assert q1200["data"]["lv"] == "15"
        assert q1200["totaltime"] == 1800
        # Verify active_queues was updated
        assert "1200" in task.active_queues
        assert task.active_queues["1200"]["bid"] == "201"
        # Verify cityCtrl.blist was updated
        found_blist = False
        for b in init_data["cityCtrl"]["blist"]:
            bi = b.get("binfo", {})
            if bi.get("bid") == "201" and bi.get("index") == "1102":
                assert bi.get("state") == "2", f"Building state in blist is {bi.get('state')}, expected '2'!"
                found_blist = True
                break
        assert found_blist, "Building not found in blist after sync!"
        # Verify reslist deduction
        res_after = init_data.get("cityCtrl", {}).get("reslist", {})
        for rk, amt in test_cost_res.items():
            if rk in res_before:
                expected_v = max(0.0, float(res_before[rk]) - amt)
                actual_v = float(res_after[rk])
                assert abs(actual_v - expected_v) < 1e-3, f"Res {rk} deduction error: before={res_before[rk]}, after={actual_v}, expected={expected_v}"
        print("   sync_in_memory_upgrade verified 100%!")
        
        # 7. In-Memory Completed Queue Sync Verification
        print(f"7. Testing sync_in_memory_completed_queue...")
        task.sync_in_memory_completed_queue(
            qtype="1200",
            bid="201",
            target_lv=15
        )
        assert "1200" not in init_data.get("queueCtrl", {}), "1200 still in queueCtrl after completion!"
        assert "1200" not in task.active_queues, "1200 still in active_queues after completion!"
        found_completed = False
        for b in init_data["cityCtrl"]["blist"]:
            bi = b.get("binfo", {})
            if bi.get("bid") == "201" and bi.get("index") == "1102":
                assert bi.get("state") == "0", f"Building state in blist is {bi.get('state')}, expected '0'!"
                assert bi.get("lv") == "15", f"Building lv in blist is {bi.get('lv')}, expected '15'!"
                found_completed = True
                break
        assert found_completed, "Building not found in blist after completion!"
        print("   sync_in_memory_completed_queue verified 100%!")
        
        # 8. In-Memory Consumed Items Sync Verification
        print(f"8. Testing sync_in_memory_consumed_items...")
        backpack = init_data.get("backpackCtrl", {})
        sample_item_id = None
        for it_k, it_v in backpack.items():
            if isinstance(it_v, dict) and it_v.get("count", 0) > 2:
                sample_item_id = int(it_k)
                orig_cnt = it_v["count"]
                break
        if sample_item_id:
            task.sync_in_memory_consumed_items([{"id": sample_item_id, "count": 2}])
            new_cnt = backpack[str(sample_item_id)]["count"]
            assert new_cnt == orig_cnt - 2, f"Backpack sync failed! orig={orig_cnt}, new={new_cnt}"
            print(f"   sync_in_memory_consumed_items verified for item {sample_item_id}: {orig_cnt} -> {new_cnt}!")
        else:
            print("   No backpack item with count > 2 found to test.")

if __name__ == '__main__':
    asyncio.run(run_audit())
    print("\nALL AUDIT VERIFICATIONS PASSED SUCCESSFULLY!")
