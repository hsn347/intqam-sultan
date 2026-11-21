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
t1 = DummyTask(b1)
best = t1.get_best_march_heroes(num_heroes=5, need_available=False)
print("Best heroes (need_available=False):", best)

best_avail = t1.get_best_march_heroes(num_heroes=5, need_available=True)
print("Best heroes (need_available=True):", best_avail)
