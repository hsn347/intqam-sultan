import asyncio
import json
import os
import sys
import time

root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, root_dir)

from tasks.building import BuildingTask

class TrafficInspectorConnection:
    def __init__(self, init_data):
        self.is_connected = True
        self.init_data = json.loads(json.dumps(init_data))
        self.captured_packets = []
        self.creds = type("Creds", (), {"uid": "1001001", "kingdom_id": 1, "server_name": "TestServer"})()

    def get_ctrl(self, ctrl_name):
        return self.init_data.get(ctrl_name, {})

    async def query(self, cmd, subcmd, data=None, timeout=8.0):
        packet = {
            "timestamp": time.time(),
            "cmd": str(cmd),
            "subcmd": str(subcmd),
            "data": data or {},
        }
        self.captured_packets.append(packet)

        # Behavioral responses matching server logic
        c, sc = str(cmd), str(subcmd)
        if c == "1001" and sc in ("2", "3"):
            return {"err": "0", "data": {"bid": str((data or {}).get("bid")), "mode": (data or {}).get("mode")}}
        elif c == "1003" and sc == "2":
            return {"err": "0", "data": {"qtype": str((data or {}).get("qtype")), "mode": (data or {}).get("mode")}}
        elif c == "1001" and sc == "8":
            return {"err": "0", "data": {"drop": []}}
        elif c == "1003" and sc == "1":
            return {"err": "0", "data": {}}
        return {"err": "0", "data": {}}

async def run_traffic_audit():
    print("=== STARTING FULL END-TO-END NETWORK TRAFFIC RE-AUDIT ===")

    # Test Case 1: Beetoo1 Castle Upgrade & Speedup Cycle
    beetoo1_path = os.path.join(root_dir, "docs", "beetoo1_live_memory.json")
    with open(beetoo1_path, "r", encoding="utf-8") as f:
        mem1 = json.load(f)

    conn1 = TrafficInspectorConnection(mem1)
    # Ensure ample resources & speedup items
    conn1.init_data.setdefault("cityCtrl", {})["reslist"] = {
        "1002": "900000000", "1003": "900000000", "1004": "900000000", "1005": "900000000"
    }
    conn1.init_data["backpackCtrl"] = {
        "501101": {"count": 100}, # 5m
        "501102": {"count": 100}, # 1h
        "501103": {"count": 50},  # 3h
        "501104": {"count": 20},  # 8h
    }
    conn1.init_data["queueCtrl"] = {} # Both queues idle

    task1 = BuildingTask(
        conn=conn1,
        config={
            "enabled": True,
            "upgrade_castle": True,
            "speedup_castle": True,
            "supportive_buildings": True,
            "auto_open_chests": False,
        }
    )

    print("\n--- Executing task1.run() on Beetoo1 Live Memory ---")
    result1 = await task1.run()
    print(f"Task result: success={result1.success}, msg={result1.message}, data={result1.data}")
    print(f"Total network packets captured: {len(conn1.captured_packets)}")

    # Audit all captured packets
    for idx, p in enumerate(conn1.captured_packets):
        cmd, subcmd, data = p["cmd"], p["subcmd"], p["data"]
        print(f"  Packet [{idx+1}]: CMD={cmd}, SubCMD={subcmd}, Data={data}")
        
        # Verify valid CMD / SubCMD
        assert cmd in ("1001", "1003"), f"Unexpected CMD: {cmd}"
        if cmd == "1001":
            assert subcmd in ("2", "3", "8"), f"Unexpected SubCMD for CMD 1001: {subcmd}"
        elif cmd == "1003":
            assert subcmd in ("1", "2"), f"Unexpected SubCMD for CMD 1003: {subcmd}"

        # Verify Zero-Gold Guarantee
        mode = data.get("mode")
        if mode is not None:
            assert mode != "1", f"CRITICAL ZERO-GOLD VIOLATION! Mode '1' found in packet: {p}"
            assert mode in ("0", "2"), f"Invalid mode '{mode}' in packet: {p}"

        # Verify batched items schema
        if cmd == "1003" and subcmd == "2" and mode == "2":
            items = data.get("items")
            assert isinstance(items, list), f"Expected items list, got {type(items)}"
            assert len(items) > 0, "Empty items array in mode 2!"
            for it in items:
                assert isinstance(it["id"], int), f"item id must be int: {it}"
                assert isinstance(it["count"], int), f"item count must be int: {it}"
                assert it["count"] > 0, f"item count must be > 0: {it}"

    # Verify NO CMD 1003/1 was sent during active run (0-network memory pre-flight)
    query_inits = [p for p in conn1.captured_packets if p["cmd"] == "1003" and p["subcmd"] == "1"]
    assert len(query_inits) == 0, f"0-Network violation: unexpected queue query CMD 1003/1: {query_inits}"
    print("PASS: 0 redundant query fallbacks sent during task run.")

    # Test Case 2: Beetoo3 Live Memory
    beetoo3_path = os.path.join(root_dir, "docs", "beetoo3_live_memory.json")
    with open(beetoo3_path, "r", encoding="utf-8") as f:
        mem3 = json.load(f)

    conn3 = TrafficInspectorConnection(mem3)
    conn3.init_data.setdefault("cityCtrl", {})["reslist"] = {
        "1002": "900000000", "1003": "900000000", "1004": "900000000", "1005": "900000000"
    }
    conn3.init_data["queueCtrl"] = {}

    task3 = BuildingTask(
        conn=conn3,
        config={
            "enabled": True,
            "upgrade_castle": True,
            "speedup_castle": False, # No speedup test
            "supportive_buildings": True,
            "auto_open_chests": False,
        }
    )

    print("\n--- Executing task3.run() on Beetoo3 Live Memory (No Speedup) ---")
    result3 = await task3.run()
    print(f"Task result: success={result3.success}, msg={result3.message}, data={result3.data}")
    print(f"Total network packets captured: {len(conn3.captured_packets)}")

    for idx, p in enumerate(conn3.captured_packets):
        cmd, subcmd, data = p["cmd"], p["subcmd"], p["data"]
        print(f"  Packet [{idx+1}]: CMD={cmd}, SubCMD={subcmd}, Data={data}")
        # When speedup is False, NO CMD 1003/2 should EVER be sent!
        assert not (cmd == "1003" and subcmd == "2"), f"Speedup packet sent when speedup disabled! {p}"
        mode = data.get("mode")
        if mode is not None:
            assert mode == "0", f"Unexpected mode {mode} when speedup disabled!"

    print("\n=== FULL END-TO-END NETWORK TRAFFIC RE-AUDIT PASSED (100% CLEAN) ===")

if __name__ == "__main__":
    asyncio.run(run_traffic_audit())
