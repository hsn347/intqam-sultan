import os
import sys
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_buffctrl():
    _, init_data = load_account_init_data("beetoo1", offline=True)
    print("=== Keys in init_data ===")
    print(list(init_data.keys()))
    
    # 1. buffCtrl
    buff_data = init_data.get("buffCtrl", {})
    print("\n=== buffCtrl ===")
    print(json.dumps(buff_data, indent=2, ensure_ascii=False))

    # 2. Check militaryRankCtrl
    mil_data = init_data.get("militaryRankCtrl", {})
    print("\n=== militaryRankCtrl ===")
    print(json.dumps(mil_data, indent=2, ensure_ascii=False))

    # 3. Check warGemCtrl
    wargem_data = init_data.get("warGemCtrl", {})
    print("\n=== warGemCtrl ===")
    print(json.dumps(wargem_data, indent=2, ensure_ascii=False))

    # 4. Check intetiorCtrl / parliament
    parl_data = init_data.get("intetiorCtrl", {})
    print("\n=== intetiorCtrl ===")
    print(json.dumps(parl_data, indent=2, ensure_ascii=False))

    # 5. Check miraculousWeaponCtrl
    mw_data = init_data.get("miraculousWeaponCtrl", {})
    print("\n=== miraculousWeaponCtrl ===")
    print(json.dumps(mw_data, indent=2, ensure_ascii=False))

    # 6. Check heroCenotaphCtrl
    hc_data = init_data.get("heroCenotaphCtrl", {})
    print("\n=== heroCenotaphCtrl ===")
    print(json.dumps(hc_data, indent=2, ensure_ascii=False))

    # 7. Check kingdomLevel
    kl_data = init_data.get("kingdomLevelCtrl", init_data.get("kingdomLevel", {}))
    print("\n=== kingdomLevel ===")
    print(json.dumps(kl_data, indent=2, ensure_ascii=False))

    # 8. Check lordInfoCtrl
    lord_data = init_data.get("lordInfoCtrl", {})
    print("\n=== lordInfoCtrl keys ===")
    print(list(lord_data.keys()))
    print("fcInfo:", lord_data.get("fcInfo"))

if __name__ == "__main__":
    inspect_buffctrl()
