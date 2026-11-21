import sys
sys.path.insert(0, '.')
import json
from tasks.base_task import BaseTask

class DummyTask(BaseTask):
    async def run(self):
        pass

class DummyConn:
    def __init__(self, init_data):
        self.init_data = init_data

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    d1 = json.load(f)

t1 = DummyTask(conn=DummyConn(d1))
r1 = t1.get_max_march_capacity(need_available=False, breakdown=True)
print("beetoo1 buffs:", json.dumps(r1.get('buffs'), indent=2))
print("beetoo1 bare_capacity:", r1.get('bare_capacity'))
