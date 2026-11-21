import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_buffs():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    
    print("=== buffCtrl ===")
    buff_data = init_data.get("buffCtrl", {})
    print("Keys in buffCtrl:", list(buff_data.keys()))
    for k, v in buff_data.items():
        print(f"buffCtrl[{k}]: {v}")

    print("\n=== militaryRankInfo in lordInfoCtrl ===")
    lord_data = init_data.get("lordInfoCtrl", {})
    print("militaryRankInfo:", lord_data.get("militaryRankInfo"))

    print("\n=== militaryRankCtrl ===")
    mil = init_data.get("militaryRankCtrl", {})
    print("Keys in militaryRankCtrl:", list(mil.keys()))
    for k, v in mil.items():
        if v and v != {}:
            print(f"militaryRankCtrl[{k}]: {v}")

if __name__ == "__main__":
    inspect_buffs()
