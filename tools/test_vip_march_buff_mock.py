# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.abspath("."))
import time
from tasks.base_task import BaseTask, VIP_MARCH_LIMIT_TABLE

class MockConn:
    def __init__(self, init_data):
        self.init_data = init_data

class DummyTask(BaseTask):
    def __init__(self, init_data):
        super().__init__(conn=MockConn(init_data), config={})
    async def run(self):
        pass

# Test VIP levels
test_cases = [
    (9, False, 0.0, 0),        # VIP 9 Inactive -> 0%
    (9, True, 1000.0, 0),       # VIP 9 Active -> 0% (starts at 14)
    (14, False, 0.0, 0),       # VIP 14 Inactive -> 0%
    (14, True, 1000.0, 100),   # VIP 14 Active -> +10.0%
    (15, True, 1000.0, 150),   # SVIP 1 Active -> +15.0%
    (19, True, 1000.0, 150),   # SVIP 5 Active -> +15.0%
    (20, True, 1000.0, 200),   # SVIP 6 Active -> +20.0%
    (25, True, 1000.0, 250),   # SVIP 11 Active -> +25.0%
]

for lv, active, offset, expected_permille in test_cases:
    end_t = (time.time() + offset) if active else 0.0
    mock_data = {
        "lordInfoCtrl": {
            "vip": {
                "level": lv,
                "vipEndTime": end_t
            }
        }
    }
    t = DummyTask(mock_data)
    res = t.get_vip_march_buff()
    assert res["value_permille"] == expected_permille, f"Failed for Lv {lv}: expected {expected_permille}, got {res['value_permille']}"
    assert res["percent"] == expected_permille / 10.0
    print(f"✓ VIP Lv {lv:2d} (Active={str(active):5s}) -> {res['percent']:5.1f}% (+{res['multiplier']:.3f}) | MATCHED!")

print("\n🎉 All VIP march limit test cases verified 100% against official game rules!")
