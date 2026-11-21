import json
import os
import sys

sys.path.insert(0, os.path.abspath("."))

from tasks.base_task import BaseTask

class MockConnection:
    def __init__(self, init_data):
        self.init_data = init_data

class DummyTask(BaseTask):
    async def run(self):
        pass

def test_tech_getter():
    print("Testing get_leadership_technology_additions on beetoo1 and beetoo2...")

    # 1. Beetoo1
    with open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
        b1_data = json.load(f)
    conn1 = MockConnection(b1_data)
    task1 = DummyTask(conn=conn1, log_func=print)
    res1 = task1.get_leadership_technology_additions()
    print("Beetoo1 Result:", json.dumps(res1, ensure_ascii=False, indent=2))
    assert res1["total_tech_add"] == 12000
    assert res1["researched_count"] > 0

    # 2. Beetoo2
    with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
        b2_data = json.load(f)
    conn2 = MockConnection(b2_data)
    task2 = DummyTask(conn=conn2, log_func=print)
    res2 = task2.get_leadership_technology_additions()
    print("Beetoo2 Result:", json.dumps(res2, ensure_ascii=False, indent=2))
    assert res2["total_tech_add"] == 12000

    print("\nALL LEADERSHIP TECH GETTER TESTS PASSED SUCCESSFULLY! ✓")

if __name__ == "__main__":
    test_tech_getter()
