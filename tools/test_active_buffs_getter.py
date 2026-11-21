import json
import os
import sys
import time

sys.path.insert(0, os.path.abspath("."))

from tasks.base_task import BaseTask

class MockConnection:
    def __init__(self, init_data):
        self.init_data = init_data

class DummyTask(BaseTask):
    async def run(self):
        pass

def test_active_buffs_getter():
    print("Testing get_active_march_buffs on beetoo1 and mock active buffs...")

    # 1. Beetoo1 (real cached memory)
    with open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
        b1_data = json.load(f)
    conn1 = MockConnection(b1_data)
    task1 = DummyTask(conn=conn1, log_func=print)
    res1 = task1.get_active_march_buffs()
    print("Beetoo1 Result:", json.dumps(res1, ensure_ascii=False, indent=2))
    assert "buff_flat_val" in res1
    assert "buff_percent_permille" in res1

    # 2. Mock Castle with active 20% troop expansion (EffectType 19, val 200) and +5000 troops (EffectType 96)
    now = int(time.time())
    mock_buffs = [
        {"id": 3001, "effectType": 19, "val": 200, "beginTime": now - 100, "time": 3600},
        {"id": 3002, "effectType": 96, "val": 5000, "beginTime": now - 100, "time": 3600},
        {"id": 9999, "effectType": 19, "val": 500, "beginTime": now - 5000, "time": 3600},  # expired
    ]
    mock_data = {"buffCtrl": mock_buffs}
    conn2 = MockConnection(mock_data)
    task2 = DummyTask(conn=conn2, log_func=print)
    res2 = task2.get_active_march_buffs()
    print("\nMock Active Buffs Result:", json.dumps(res2, ensure_ascii=False, indent=2))
    assert res2["buff_percent_permille"] == 200
    assert res2["buff_percent_add"] == 0.20
    assert res2["buff_flat_val"] == 5000
    assert res2["active_buff_count"] == 2  # expired buff excluded

    # 3. Test Mass March Buffs (EffectType 736 and 737)
    mock_mass_buffs = [
        {"id": 4001, "effectType": 736, "val": 100, "beginTime": now - 100, "time": 3600},
        {"id": 4002, "effectType": 737, "val": 10000, "beginTime": now - 100, "time": 3600},
    ]
    mock_mass_data = {"buffCtrl": mock_mass_buffs}
    conn3 = MockConnection(mock_mass_data)
    task3 = DummyTask(conn=conn3, log_func=print)
    
    # Regular march (is_mass=False): should not include mass buffs
    res3_regular = task3.get_active_march_buffs(is_mass=False)
    assert res3_regular["buff_percent_permille"] == 0
    assert res3_regular["buff_flat_val"] == 0

    # Mass march (is_mass=True): should include mass buffs
    res3_mass = task3.get_active_march_buffs(is_mass=True)
    print("\nMock Mass Buffs Result:", json.dumps(res3_mass, ensure_ascii=False, indent=2))
    assert res3_mass["buff_percent_permille"] == 100
    assert res3_mass["buff_flat_val"] == 10000

    print("\nALL ACTIVE MARCH BUFFS TESTS PASSED SUCCESSFULLY! ✓")

if __name__ == "__main__":
    test_active_buffs_getter()
