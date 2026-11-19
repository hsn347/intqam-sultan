# -*- coding: utf-8 -*-
"""فحص جميع المصادر المحتملة المفقودة لسعة المسيرة في ذاكرة beetoo2 الحية."""
import sys, os, json, time, asyncio
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
    now = int(time.time())

    # 1. Check buffCtrl for Effect 19 (MARCH_LIMIT_BOOST %) and Effect 96 (MARCH_VALUE_LIMIT_BOOST flat)
    print("=" * 60)
    print("1. buffCtrl - Active march-related buffs")
    print("=" * 60)
    buffs = d.get("buffCtrl", [])
    if isinstance(buffs, list):
        for bi in buffs:
            if not isinstance(bi, dict):
                continue
            et = bi.get("effectType")
            bid = bi.get("id") or bi.get("buffID")
            val = bi.get("val") or bi.get("effect") or 0
            bt = int(bi.get("beginTime", 0) or 0)
            dur = int(bi.get("time", 0) or 0)
            if dur > 0 and (bt + dur) < now:
                continue  # expired
            if et in (19, 96, "19", "96"):
                remaining = (bt + dur) - now if dur > 0 else "permanent"
                print(f"  MATCH: id={bid}, effectType={et}, val={val}, remaining={remaining}s")
        # Also show ALL active buffs for inspection
        active_count = 0
        for bi in buffs:
            if not isinstance(bi, dict):
                continue
            bt = int(bi.get("beginTime", 0) or 0)
            dur = int(bi.get("time", 0) or 0)
            if dur > 0 and (bt + dur) < now:
                continue
            active_count += 1
        print(f"  Total active buffs: {active_count}")

    # 2. Check lordInfoCtrl.skill (lord skills that might give march capacity)
    print("\n" + "=" * 60)
    print("2. lordInfoCtrl.skill - Lord skills")
    print("=" * 60)
    lord = d.get("lordInfoCtrl", {})
    skill = lord.get("skill", {})
    if isinstance(skill, dict):
        for sid, sdata in skill.items():
            print(f"  Skill {sid}: {json.dumps(sdata, ensure_ascii=False)[:200]}")

    # 3. Check militaryRankInfo (military rank buffs)
    print("\n" + "=" * 60)
    print("3. lordInfoCtrl.militaryRankInfo")
    print("=" * 60)
    mil = lord.get("militaryRankInfo", {})
    print(f"  {json.dumps(mil, ensure_ascii=False)[:500]}")

    # 4. Check dressCtrl (lord equipment/dress) 
    print("\n" + "=" * 60)
    print("4. dressCtrl (lord dress/equipment)")
    print("=" * 60)
    dress = d.get("dressCtrl", {})
    print(f"  Type: {type(dress)}")
    if isinstance(dress, dict):
        print(f"  Keys: {list(dress.keys())[:20]}")
        # Check for equipped items
        wear = dress.get("wearList") or dress.get("equipList") or dress.get("wear")
        if wear:
            print(f"  wearList: {json.dumps(wear, ensure_ascii=False)[:300]}")

    # 5. Check equipCtrl
    print("\n" + "=" * 60)
    print("5. equipCtrl (equipment)")
    print("=" * 60)
    equip = d.get("equipCtrl", {})
    print(f"  Type: {type(equip)}")
    if isinstance(equip, dict):
        print(f"  Keys: {list(equip.keys())[:20]}")
        wl = equip.get("wearList") or equip.get("equipedList") or equip.get("lordEquip")
        if wl:
            print(f"  Equipped: {json.dumps(wl, ensure_ascii=False)[:300]}")

    # 6. Check petCtrl (pet/divine beast)
    print("\n" + "=" * 60)
    print("6. petCtrl / divineBeastCtrl")
    print("=" * 60)
    pet = d.get("petCtrl") or d.get("divineBeastCtrl") or {}
    print(f"  Type: {type(pet)}")
    if isinstance(pet, dict):
        print(f"  Keys: {list(pet.keys())[:20]}")
        # Check for active pet buffs
        plist = pet.get("petList") or pet.get("list")
        if plist:
            print(f"  Pet list (first 300 chars): {json.dumps(plist, ensure_ascii=False)[:300]}")

    # 7. Check godArmsCtrl / runeCtrl
    print("\n" + "=" * 60)
    print("7. godArmsCtrl / warGemCtrl / runeCtrl")
    print("=" * 60)
    for key in ["godArmsCtrl", "warGemCtrl", "runeCtrl", "godArmsRuneCtrl"]:
        ctrl = d.get(key)
        if ctrl:
            print(f"  {key}: type={type(ctrl)}, keys={list(ctrl.keys())[:10] if isinstance(ctrl, dict) else 'N/A'}")

    # 8. Check heroSysCtrl for hero active buffs (heroCtrl:getTheActiveBuff)
    print("\n" + "=" * 60)
    print("8. heroSysCtrl - Hero active/passive buffs for MARCH_VALUE_LIMIT_BOOST")
    print("=" * 60)
    hero_sys = d.get("heroSysCtrl", {})
    if isinstance(hero_sys, dict):
        hl = hero_sys.get("heroList", {})
        # Check each hero's skillList for skills with effectType 96 or march-related
        for hid, hdata in (hl.items() if isinstance(hl, dict) else []):
            skills = hdata.get("skillList", {}) if isinstance(hdata, dict) else {}
            if isinstance(skills, dict):
                for sk_id, sk_info in skills.items():
                    if isinstance(sk_info, dict):
                        st = sk_info.get("skillType")
                        if st and int(st) in (96, 19):
                            print(f"  Hero {hid} Skill {sk_id}: type={st}, isActive={sk_info.get('isActive')}")

    # 9. All init_data controller keys
    print("\n" + "=" * 60)
    print("9. All init_data controller keys")
    print("=" * 60)
    print(f"  Keys ({len(d)}): {sorted(d.keys())}")

asyncio.run(main())
