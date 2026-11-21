import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_buildings():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    city = init_data.get("cityCtrl", {})
    blist = city.get("blist", {})
    print(f"Total buildings in blist: {len(blist)}")
    if isinstance(blist, dict):
        iterator = blist.items()
    else:
        iterator = [(b.get('buildID') or b.get('bid'), b) for b in blist]
    for bid, binfo in iterator:
        print(f"bid={str(bid):5s} | lv={binfo.get('lv')} | starLv={binfo.get('starLv')} | other={[(k, v) for k, v in binfo.items() if k not in ['lv', 'starLv', 'buildID', 'pos', 'time', 'state']]}")

if __name__ == "__main__":
    inspect_buildings()
