# -*- coding: utf-8 -*-
import os
import sys
import json
import glob

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import get_max_march_capacity as mc_get_cap
from tasks.base_task import BaseTask

class TestTask(BaseTask):
    async def run(self):
        pass

class DummyConn:
    def __init__(self, d):
        self.init_data = d

def run_tests():
    files = sorted(glob.glob("docs/*live_memory.json"))
    print(f"Testing {len(files)} live memory files...")
    all_passed = True
    for f in files:
        with open(f, "r", encoding="utf-8") as fp:
            data = json.load(fp)
        task = TestTask(DummyConn(data))

        mc_avail = mc_get_cap(data, need_available=True)
        mc_all = mc_get_cap(data, need_available=False)

        bt_avail = task.get_max_attack_march_capacity(need_available_heroes=True)
        bt_all = task.get_max_attack_march_capacity(need_available_heroes=False)

        castle_match = (mc_all["castle_without_heroes"] == bt_all["castle_capacity_without_heroes"])
        avail_match = (mc_avail["grand_total"] == bt_avail["total_capacity"])
        all_match = (mc_all["grand_total"] == bt_all["total_capacity"])

        if not (castle_match and avail_match and all_match):
            all_passed = False
            print(f"❌ MISMATCH in {f}:")
            print(f"   Castle without heroes: MC={mc_all['castle_without_heroes']} vs BT={bt_all['castle_capacity_without_heroes']}")
            print(f"   Available: MC={mc_avail['grand_total']} vs BT={bt_avail['total_capacity']}")
            print(f"   All: MC={mc_all['grand_total']} vs BT={bt_all['total_capacity']}")
        else:
            print(f"✓ {f:<32}: Base={mc_all['castle_without_heroes']:,} | Avail={mc_avail['grand_total']:,} | Max={mc_all['grand_total']:,}")

    if all_passed:
        print("\n🎉 ALL TESTS PASSED! 100% Exact match between march_capacity.py and BaseTask across all accounts!")

if __name__ == "__main__":
    run_tests()
