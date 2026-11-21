import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import json
import math
from tasks.base_task import BaseTask

class DummyTask(BaseTask):
    async def run(self):
        pass

class MockConn:
    def __init__(self, init_data):
        self.init_data = init_data

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

conn1 = MockConn(d1)
task1 = DummyTask(conn1, config={})

# Test beetoo1 with need_available=False
b1_breakdown = task1.get_max_march_capacity(need_available=False, breakdown=True)
print("beetoo1 (need_available=False):", b1_breakdown.get("total_capacity"))
print("Heroes used:")
for h in b1_breakdown.get('heroes', {}).get('details', []):
    print(f"  Hero {h.get('hero_id')} ({h.get('name')}): lv={h.get('level')}, state={h.get('state')} -> total_add={h.get('total_hero_add')}")

# Test with explicit hero list: [1717, 1711, 1710, 1704, 1718]
b1_explicit = task1.get_max_march_capacity(heroes=[1717, 1711, 1710, 1704, 1718])
print("\nbeetoo1 with explicit top 5 heroes:", b1_explicit)
