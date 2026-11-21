# -*- coding: utf-8 -*-
import json
import os
import sys

sys.path.insert(0, os.path.abspath('.'))

from tasks.base_task import BaseTask

class MockConn:
    def __init__(self, init_data):
        self.init_data = init_data

class TestTask(BaseTask):
    async def run(self):
        pass

for tag, p in [('beetoo1', 'tools/beetoo1_full_init_data.json'), ('beetoo2', 'tools/beetoo2_full_init_data.json')]:
    with open(p, 'r', encoding='utf-8') as f:
        d = json.load(f)
    conn = MockConn(d)
    task = TestTask(conn, log_func=lambda m: None)
    
    # 1. auto
    cap_auto = task.get_max_march_capacity(heroes=None, breakdown=True)
    # 2. bare
    cap_bare = task.get_max_march_capacity(heroes="none", breakdown=True)
    
    print(f"\n=================== {tag} ===================")
    print(f"Auto Total Capacity: {cap_auto['total_capacity']}")
    print(f"Bare Total Capacity: {cap_bare['total_capacity']}")
    print(f"Drill Ground: {cap_auto['drill_grounds']}")
    print(f"Tech: {cap_auto['technology']}")
    print(f"Buffs: {cap_auto['buffs']}")
    print(f"Heroes count: {cap_auto['heroes']['hero_count']}, total_hero_add: {cap_auto['heroes']['total_hero_add']}")
    for h in cap_auto['heroes']['details']:
        print(f"  Hero {h.get('hero_id')}: level={h.get('level')}, march={h.get('march_add')}")
