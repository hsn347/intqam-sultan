import json
import os
import sys

# Add root directory to sys.path
sys.path.insert(0, os.path.abspath("."))

from tasks.base_task import BaseTask

class MockConnection:
    def __init__(self, init_data):
        self.init_data = init_data

class DummyTask(BaseTask):
    async def run(self):
        pass

def test_drill_grounds_getter():
    print("Testing get_drill_grounds_base_capacity on beetoo1 and beetoo2...")
    
    # 1. Beetoo1
    with open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
        b1_data = json.load(f)
    conn1 = MockConnection(b1_data)
    task1 = DummyTask(conn=conn1, log_func=print)
    res1 = task1.get_drill_grounds_base_capacity()
    print("Beetoo1 Result:", json.dumps(res1, ensure_ascii=False, indent=2))
    assert res1["found"] is True
    assert res1["bid"] == 121
    assert res1["lv"] == 27
    assert res1["base_capacity"] == 87500
    assert res1["total_base_capacity"] == 87500

    # 2. Beetoo2
    with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
        b2_data = json.load(f)
    conn2 = MockConnection(b2_data)
    task2 = DummyTask(conn=conn2, log_func=print)
    res2 = task2.get_drill_grounds_base_capacity()
    print("Beetoo2 Result:", json.dumps(res2, ensure_ascii=False, indent=2))
    assert res2["found"] is True
    assert res2["bid"] == 121
    assert res2["lv"] == 27
    assert res2["base_capacity"] == 87500

    # 3. Castle with starLv
    mock_star_data = {
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "121", "lv": "30", "starLv": "5"}}
            ]
        }
    }
    conn3 = MockConnection(mock_star_data)
    task3 = DummyTask(conn=conn3, log_func=print)
    res3 = task3.get_drill_grounds_base_capacity()
    print("Star Castle Result:", json.dumps(res3, ensure_ascii=False, indent=2))
    assert res3["lv"] == 30
    assert res3["star_lv"] == 5
    assert res3["base_capacity"] == 101600
    assert res3["star_capacity"] == 7500
    assert res3["total_base_capacity"] == 109100

    print("\nALL DRILL GROUNDS GETTER TESTS PASSED SUCCESSFULLY! ✓")

if __name__ == "__main__":
    test_drill_grounds_getter()
