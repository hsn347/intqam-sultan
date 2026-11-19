# -*- coding: utf-8 -*-
"""
tools/test_flower_targets.py — اختبار إلغاء استعلام التحالف والاعتماد على ترتيب المملكة فقط
"""

import sys
import os
import asyncio

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from tasks.flower import FlowerTask

class MockConn:
    def __init__(self):
        self.is_connected = True
        self.init_data = {"lordInfoCtrl": {"base": {"uid": "111111", "kingdom_id": 150}}}
        self.queried_cmds = []

    async def query(self, cmd, subcmd, data, timeout=7, **kwargs):
        self.queried_cmds.append((str(cmd), str(subcmd)))
        if str(cmd) == "1029" and str(subcmd) == "2":
            return {
                "err": "0",
                "data": {
                    "data": [
                        {"uid": "222222", "nickName": "أمير المملكة 1"},
                        {"uid": "333333", "nickName": "أمير المملكة 2"},
                    ]
                }
            }
        return {"err": "-1"}

async def main():
    conn = MockConn()
    task = FlowerTask(conn, log_func=print)

    print("1. Testing _resolve_targets...")
    targets, source = await task._resolve_targets("111111")

    print(f"Targets found: {len(targets)} from '{source}'")
    for t in targets:
        print(f" - {t['name']} (UID: {t['uid']})")

    print("Commands queried:", conn.queried_cmds)
    assert ("1010", "6") not in conn.queried_cmds, "Alliance members (1010/6) was queried!"
    assert ("1010", "1") not in conn.queried_cmds, "Alliance data (1010/1) was queried!"
    assert ("1029", "2") in conn.queried_cmds, "Kingdom ranking (1029/2) was not queried!"
    assert source == "ترتيب الزهور (مملكة)"
    print("\n✓ SUCCESS: Gifting targets strictly and directly rely on Kingdom Flower Rankings (CMD 1029/2) without touching alliance endpoints!")

if __name__ == "__main__":
    asyncio.run(main())
