# -*- coding: utf-8 -*-
"""فحص عميق لمصادر سعة المسيرة المفقودة: equipmentCtrl, lordSkillCtrl, petCtrl, attributeSystem."""
import sys, os, json, asyncio
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from bot_manager import CastleBot
import core.database as db

async def main():
    c = db.get_castle_by_id("beetoo2@hotmail.com")
    b = CastleBot("beetoo2@hotmail.com", c.get("password"), config={}, log_callback=lambda m: None)
    b.is_running = True
    ok = await b.connect()
    if not ok or not b.conn:
        print("Failed to connect")
        return
    d = b.conn.init_data

    # 1. equipmentCtrl
    print("=" * 60)
    print("1. equipmentCtrl")
    print("=" * 60)
    equip = d.get("equipmentCtrl", {})
    if isinstance(equip, dict):
        print("Keys:", list(equip.keys())[:30])
        wear = equip.get("wearList") or equip.get("equipedList") or equip.get("lordEquip") or equip.get("wear")
        if wear:
            print("Wear:", json.dumps(wear, ensure_ascii=False)[:800])
        else:
            for k, v in list(equip.items())[:8]:
                val_str = json.dumps(v, ensure_ascii=False)[:300]
                print("  %s: %s" % (k, val_str))

    # 2. lordSkillCtrl
    print("\n" + "=" * 60)
    print("2. lordSkillCtrl")
    print("=" * 60)
    lord_skill = d.get("lordSkillCtrl", {})
    if isinstance(lord_skill, dict):
        print("Keys:", list(lord_skill.keys())[:30])
        for k, v in list(lord_skill.items())[:10]:
            val_str = json.dumps(v, ensure_ascii=False)[:300]
            print("  %s: %s" % (k, val_str))

    # 3. petCtrl - all pets with their details
    print("\n" + "=" * 60)
    print("3. petCtrl - all pets detail")
    print("=" * 60)
    pet = d.get("petCtrl", {})
    if isinstance(pet, dict):
        plist = pet.get("petList", {})
        if isinstance(plist, dict):
            for pid, pdata in plist.items():
                pd_str = json.dumps(pdata, ensure_ascii=False)[:200]
                print("  Pet %s: %s" % (pid, pd_str))

    # 4. Check lordInfoCtrl.skill.skillBasic for lord skill tree points
    print("\n" + "=" * 60)
    print("4. lordInfoCtrl.skill.skillBasic (Lord skill tree)")
    print("=" * 60)
    lord = d.get("lordInfoCtrl", {})
    skill = lord.get("skill", {})
    if isinstance(skill, dict):
        sb = skill.get("skillBasic", {})
        print("skillBasic:", json.dumps(sb, ensure_ascii=False))
        print("skillPoints:", skill.get("skillPoints"))

    # 5. Check buffCtrl - ALL active buffs (not just effect 19/96)
    print("\n" + "=" * 60)
    print("5. ALL active buffs in buffCtrl")
    print("=" * 60)
    import time
    now = int(time.time())
    buffs = d.get("buffCtrl", [])
    if isinstance(buffs, list):
        print("Total buff entries:", len(buffs))
        for bi in buffs:
            if not isinstance(bi, dict):
                continue
            bt = int(bi.get("beginTime", 0) or 0)
            dur = int(bi.get("time", 0) or 0)
            if dur > 0 and (bt + dur) < now:
                continue
            bid = bi.get("id") or bi.get("buffID")
            et = bi.get("effectType")
            val = bi.get("val") or bi.get("effect") or 0
            remaining = (bt + dur) - now if dur > 0 else "permanent"
            print("  Active buff: id=%s effectType=%s val=%s remaining=%s" % (bid, et, val, remaining))

    # 6. Check all init_data keys for anything related to attributes
    print("\n" + "=" * 60)
    print("6. Looking for attribute-related controllers")
    print("=" * 60)
    for key in sorted(d.keys()):
        if any(x in key.lower() for x in ("attr", "mastery", "garden", "gem", "craft", "magic")):
            ctrl = d[key]
            tp = type(ctrl).__name__
            ks = list(ctrl.keys())[:10] if isinstance(ctrl, dict) else "N/A"
            print("  %s: type=%s keys=%s" % (key, tp, ks))

asyncio.run(main())
