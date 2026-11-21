import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_buildings():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    city_ctrl = init_data.get("cityCtrl", {})
    blist = city_ctrl.get("blist", [])
    print(f"Total buildings in blist: {len(blist)}")
    for b in blist:
        binfo = b.get("binfo", {})
        bid = binfo.get("bid")
        lv = binfo.get("lv")
        slv = binfo.get("starLv")
        iid = binfo.get("iid")
        print(f"BID: {bid:>4} | iid: {iid} | Lv: {lv} | StarLv: {slv}")

if __name__ == "__main__":
    inspect_buildings()
