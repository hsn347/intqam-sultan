# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db

async def inspect(email):
    print(f"\n==========================================")
    print(f"       LIVE INSPECTION: {email}")
    print(f"==========================================")
    c = db.get_castle_by_id(email)
    bot = CastleBot(email, c.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return
    conn = bot.conn

    # 1. Drill grounds
    blist = conn.init_data.get("cityCtrl", {}).get("blist", [])
    found_drill = False
    for b in blist:
        binfo = b.get("binfo", b)
        if str(binfo.get("bid")) == "121":
            print(f"1. Drill Grounds (bid 121): {binfo}")
            found_drill = True
            break
    if not found_drill:
        print("1. Drill Grounds: NOT FOUND in cityCtrl.blist!")

    # 2. Techs
    tctrl = conn.init_data.get("technologyCtrl", {})
    print(f"2. Technology count: {len(tctrl)}")
    # Find all techs with bt=43 or keywords
    for k, v in tctrl.items():
        tid = v[0] if isinstance(v, list) else k
        tlv = v[1] if isinstance(v, list) else v
        if str(tid) in ["24016", "24032", "25030", "21016", "21032", "25016", "24033"]:
            print(f"   Tech {tid}: lv={tlv}")

    # 3. Medals
    ach = conn.init_data.get("achievementctrl", {})
    alist = ach.get("list", {})
    print(f"3. Achievements in achievementctrl: {len(alist)}")
    m17 = alist.get("17") or alist.get(17)
    print(f"   Medal 17: {m17}")

    # 4. VIP
    vip = conn.init_data.get("lordInfoCtrl", {}).get("vip")
    print(f"4. VIP: {vip}")

    # 5. Heroes
    hero_sys = conn.init_data.get("heroSysCtrl", {})
    hl = hero_sys.get("heroList", {})
    defend = hero_sys.get("defendList", {})
    print(f"5. Total heroes: {len(hl)}, defendList: {defend}")
    for hid_str, h in list(hl.items()):
        lv = h.get("level")
        q = h.get("quality")
        r = h.get("rarity")
        st = h.get("state")
        sk = h.get("skillList", {})
        print(f"   Hero {hid_str}: lv={lv}, rarity={r}, quality={q}, state={st}, skills={len(sk)}")

    await bot.stop()

async def main():
    target = sys.argv[1] if len(sys.argv) > 1 else "LUCIFER@g4.coom"
    await inspect(target)

if __name__ == "__main__":
    asyncio.run(main())
