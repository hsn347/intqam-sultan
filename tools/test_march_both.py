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

# 1. TEST BEETOO2
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

conn2 = MockConn(d2)
task2 = DummyTask(conn2, config={})

b2_max = task2.get_max_march_capacity()
b2_base = task2.get_castle_base_march_capacity()
b2_castle = task2.get_castle_march_capacity()
b2_breakdown = task2.get_max_march_capacity(breakdown=True)

print("=== BEETOO2 RESULTS ===")
print("Max march capacity:", b2_max)
print("Base march capacity:", b2_base)
print("Castle march capacity:", b2_castle)
print("Breakdown total:", b2_breakdown.get("total_capacity"))
print("Is beetoo2 == 138,370?:", b2_max == 138370)

# 2. TEST BEETOO1
with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

conn1 = MockConn(d1)
task1 = DummyTask(conn1, config={})

b1_max = task1.get_max_march_capacity()
b1_base = task1.get_castle_base_march_capacity()
b1_castle = task1.get_castle_march_capacity()
b1_breakdown = task1.get_max_march_capacity(breakdown=True)

print("\n=== BEETOO1 RESULTS ===")
print("Max march capacity:", b1_max)
print("Base march capacity:", b1_base)
print("Castle march capacity:", b1_castle)
print("Breakdown total:", b1_breakdown.get("total_capacity"))

print("\n--- Detailed breakdown beetoo1 ---")
for k, v in b1_breakdown.items():
    if k != 'heroes':
        print(f"  {k}: {v}")
print("  Heroes in beetoo1:")
for h in b1_breakdown.get('heroes', {}).get('details', []):
    print(f"    Hero {h.get('hero_id')} ({h.get('name')}): lv={h.get('level')}, tier={h.get('effective_tier')}, state={h.get('state')} -> total_add={h.get('total_hero_add')}")
