"""
أداة فحص تفصيلية لاستخراج كافة البيانات والمتحكمات المرتبطة بسعة المسيرة لحساب beetoo1
"""
import os
import sys
import json
import logging

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from tasks.march_capacity import load_account_init_data

def inspect_account(email: str = "beetoo1"):
    print(f"[*] جاري الاتصال المباشر وفحص بيانات الحساب: {email}")
    acc_name, init_data = load_account_init_data(email, offline=False)
    print(f"\n[+] تم جلب الذاكرة الحية بنجاح! عدد المتحكمات: {len(init_data)}")

    # 1. قائمة بجميع المفاتيح في الذاكرة الحية
    print("\n--- قائمة المتحكمات المتوفرة في init_data ---")
    for k in sorted(init_data.keys()):
        val_type = type(init_data[k]).__name__
        val_len = len(init_data[k]) if hasattr(init_data[k], '__len__') else ''
        print(f"  • {k} ({val_type} {val_len})")

    # 2. فحص buffCtrl بالكامل
    print("\n--- فحص buffCtrl بالتفصيل ---")
    buff_ctrl = init_data.get("buffCtrl", {})
    if isinstance(buff_ctrl, dict):
        for bk, bv in buff_ctrl.items():
            print(f"  • {bk}: {json.dumps(bv, ensure_ascii=False) if isinstance(bv, (dict, list)) else bv}")
    else:
        print(f"  • {buff_ctrl}")

    # 3. فحص dress / dressCtrl / appearance
    print("\n--- فحص dress / dressCtrl / appearance / skins ---")
    for k in init_data:
        if any(w in k.lower() for w in ["dress", "skin", "avatar", "frame", "appear", "cloth", "fashion"]):
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 4. فحص divineBeast
    print("\n--- فحص divineBeastCtrl / beast ---")
    for k in init_data:
        if "beast" in k.lower() or "divine" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 5. فحص godArms / arms / weapon
    print("\n--- فحص godArms / weapon ---")
    for k in init_data:
        if "arm" in k.lower() or "weapon" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 6. فحص VIP
    print("\n--- فحص VIP ---")
    for k in init_data:
        if "vip" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 7. فحص militaryRank / military
    print("\n--- فحص military ---")
    for k in init_data:
        if "military" in k.lower() or "rank" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 8. فحص alliance / union
    print("\n--- فحص alliance / science ---")
    for k in init_data:
        if any(w in k.lower() for w in ["alli", "union", "league"]):
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 9. فحص talent / skill
    print("\n--- فحص talent / skill ---")
    for k in init_data:
        if "talent" in k.lower() or "skill" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 10. فحص commandHall
    print("\n--- فحص commandHall ---")
    for k in init_data:
        if "command" in k.lower() or "hall" in k.lower() or "pioneer" in k.lower():
            print(f"  • {k}: {json.dumps(init_data[k], ensure_ascii=False)[:500]}")

    # 11. فحص lordInfo
    print("\n--- فحص lordInfoCtrl ---")
    lord_info = init_data.get("lordInfoCtrl", {})
    if isinstance(lord_info, dict):
        for lk, lv in lord_info.items():
            if isinstance(lv, dict):
                print(f"  • {lk} keys: {list(lv.keys())}")
            else:
                print(f"  • {lk}: {lv}")

    print("\n[✓] تم انتهاء الفحص بنجاح.")

if __name__ == "__main__":
    email = sys.argv[1] if len(sys.argv) > 1 else "beetoo1"
    inspect_account(email)
