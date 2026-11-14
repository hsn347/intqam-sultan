import asyncio
import json
import os
import sys

root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, root_dir)

from tasks.building import BuildingTask

class MockConn:
    def __init__(self, init_data):
        self.is_connected = True
        self.init_data = json.loads(json.dumps(init_data))
        self.captured_packets = []
        self.creds = type("Creds", (), {"uid": "1001001", "kingdom_id": 1, "server_name": "TestServer"})()

    def get_ctrl(self, ctrl_name):
        return self.init_data.get(ctrl_name, {})

    async def query(self, cmd, subcmd, data=None, timeout=8.0):
        packet = {"cmd": str(cmd), "subcmd": str(subcmd), "data": data or {}}
        self.captured_packets.append(packet)
        return {"err": "0", "data": {}}

async def run_construct_test():
    beetoo1_path = os.path.join(root_dir, "docs", "beetoo1_live_memory.json")
    with open(beetoo1_path, "r", encoding="utf-8") as f:
        mem1 = json.load(f)

    conn = MockConn(mem1)
    conn.init_data.setdefault("cityCtrl", {})["reslist"] = {
        "1002": "900000000", "1003": "900000000", "1004": "900000000", "1005": "900000000"
    }
    conn.init_data["queueCtrl"] = {}
    
    # Remove all farm (201) instances from blist to simulate missing building
    blist = conn.init_data["cityCtrl"]["blist"]
    conn.init_data["cityCtrl"]["blist"] = [
        b for b in blist if str(b.get("binfo", {}).get("bid")) != "201"
    ]

    task = BuildingTask(
        conn=conn,
        config={
            "enabled": True,
            "upgrade_castle": False,
            "supportive_buildings": True,
            "target_buildings": {"201": True},
            "auto_open_chests": False,
        }
    )

    print("\n--- Running Construct Missing Building in task.run() ---")
    res = await task.run()
    print(f"Task result: {res}")
    print(f"Captured packets: {conn.captured_packets}")

    # Verify that exactly construct command (CMD 1001 / SubCMD 2) was sent
    construct_packets = [p for p in conn.captured_packets if p["cmd"] == "1001" and p["subcmd"] == "2"]
    assert len(construct_packets) > 0, "No construct packet sent!"
    cp = construct_packets[0]
    assert cp["data"]["bid"] == "201"
    assert cp["data"]["mode"] == "0", "Mode must be '0'!"
    assert "index" in cp["data"]
    
    # Verify no CMD 1003 / 1 query leak occurred
    leak_packets = [p for p in conn.captured_packets if p["cmd"] == "1003" and p["subcmd"] == "1"]
    assert len(leak_packets) == 0, f"Query leak detected! {leak_packets}"
    print("PASS: Construct in task.run() verified with 0 network leaks and Zero-Gold Guarantee.")

if __name__ == "__main__":
    asyncio.run(run_construct_test())
