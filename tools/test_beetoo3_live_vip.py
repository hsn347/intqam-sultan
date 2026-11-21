# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.abspath("."))
import json

class MockConn:
    def __init__(self, init_data):
        self.init_data = init_data
    def get_ctrl(self, name):
        return self.init_data.get(name, {})

from tasks.base_task import BaseTask

class DummyTask(BaseTask):
    def __init__(self, init_data):
        super().__init__(conn=MockConn(init_data), config={})

    async def run(self):
        pass

for f in ["docs/beetoo3_live_memory.json", "core/session_cache.json"]:
    if os.path.exists(f):
        print(f"File {f} exists, size: {os.path.getsize(f)}")
        with open(f, "r", encoding="utf-8") as fp:
            data = json.load(fp)
            if "sultan_beetoo3" in data:
                c_data = data["sultan_beetoo3"]
                print("Found sultan_beetoo3 in session cache!")
                task = DummyTask(c_data)
                print("vip_level:", task.vip_level)
                print("vip_end_time:", task.vip_end_time)
                print("is_vip_active:", task.is_vip_active)
                print("can_switch('2'):", task.can_switch_lord_skill_set("2"))
            elif "lordInfoCtrl" in data:
                print(f"Data in {f} has lordInfoCtrl directly!")
                task = DummyTask(data)
                print("vip_level:", task.vip_level)
                print("vip_end_time:", task.vip_end_time)
                print("is_vip_active:", task.is_vip_active)
                print("can_switch('2'):", task.can_switch_lord_skill_set("2"))
                print("lord.vip:", data.get("lordInfoCtrl", {}).get("vip"))
                print("vipCtrl:", data.get("vipCtrl"))
                print("queueCtrl 1219:", data.get("queueCtrl", {}).get("1219") if isinstance(data.get("queueCtrl"), dict) else None)
