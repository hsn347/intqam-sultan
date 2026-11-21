import json
import sys
sys.path.insert(0, '.')

from tasks.base_task import BaseTask

class DummyConn:
    def __init__(self, init_data):
        self.init_data = init_data
        self.learned_march_capacity = None

class DummyTask(BaseTask):
    def __init__(self, init_data):
        self.conn = DummyConn(init_data)
        self.config = {}
        self.castle_data = {}

    async def run(self):
        pass

b1 = json.load(open('tools/beetoo1_full_init_data.json', encoding='utf-8'))
b2 = json.load(open('tools/beetoo2_full_init_data.json', encoding='utf-8'))

# Case 1: need_available = False (all heroes considered)
t1 = DummyTask(b1)
res1_all = t1.get_max_march_capacity(breakdown=True, need_available=False)
print("=== BEETOO 1 (need_available=False) ===")
print("Total:", res1_all.get('total_capacity'))
print("Bare:", res1_all.get('bare_capacity'))
print("Hero add:", res1_all.get('heroes', {}).get('total_hero_add'))
for h in res1_all.get('heroes', {}).get('heroes_used', []):
    print("  ", h)

# Case 2: need_available = True (only available heroes)
res1_avail = t1.get_max_march_capacity(breakdown=True, need_available=True)
print("\n=== BEETOO 1 (need_available=True) ===")
print("Total:", res1_avail.get('total_capacity'))
print("Bare:", res1_avail.get('bare_capacity'))
print("Hero add:", res1_avail.get('heroes', {}).get('total_hero_add'))
for h in res1_avail.get('heroes', {}).get('heroes_used', []):
    print("  ", h)

# Beetoo 2
t2 = DummyTask(b2)
res2 = t2.get_max_march_capacity(breakdown=True, need_available=False)
print("\n=== BEETOO 2 (need_available=False) ===")
print("Total:", res2.get('total_capacity'))
print("Bare:", res2.get('bare_capacity'))
print("Hero add:", res2.get('heroes', {}).get('total_hero_add'))
for h in res2.get('heroes', {}).get('heroes_used', []):
    print("  ", h)
