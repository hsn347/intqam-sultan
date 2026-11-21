import json
import sys
sys.path.insert(0, '.')
from tasks.base_task import BaseTask

class DummyTask(BaseTask):
    name = "dummy"
    async def run(self):
        pass

class DummyConn:
    def __init__(self, init_data):
        self.init_data = init_data

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

conn = DummyConn(d1)
task = DummyTask(conn=conn)
res = task.get_max_march_capacity(need_available=False, breakdown=True)
print("beetoo1 result with need_available=False:")
print(f"Total: {res['total_capacity']}")
print(f"Drill: {res['drill_grounds']}")
print(f"Game Default: {res['game_default']}")
print(f"Tech: {res['technology']}")
print(f"Buffs: {res['buffs']}")
print(f"Heroes count: {res['heroes']['hero_count']}")
for h in res['heroes']['details']:
    print(f"  Hero {h['hero_id']} ({h['name']}): lv={h['level']}, q={h['quality']}, tier={h['effective_tier']}, base_add={h['level_march_add']}, total_add={h['total_hero_add']}")
