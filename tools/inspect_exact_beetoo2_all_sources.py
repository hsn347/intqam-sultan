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
from tools.test_base_task import BaseTaskHarness

async def main():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return

    task = BaseTaskHarness(bot.conn, log_func=lambda m: None, config=bot.config)
    await task.sync_local_queues(timeout=3.0)
    await task.sync_achievements(timeout=3.0)
    
    conn = task.conn
    
    # 1. achievementctrl
    print("=== ACHIEVEMENT CTRL ===")
    ach = conn.init_data.get('achievementctrl') or getattr(conn, 'achievement_data', None)
    print(json.dumps(ach, indent=2, ensure_ascii=False))

    # 2. petCtrl
    print("\n=== PET CTRL ===")
    pet = conn.init_data.get('petCtrl', {})
    print(json.dumps(pet, indent=2, ensure_ascii=False))

    # 3. allianceCtrl sciencelist
    print("\n=== ALLIANCE SCIENCE ===")
    al = conn.init_data.get('allianceCtrl', {})
    print("sciencelist:", al.get('sciencelist'))

    # 4. lordInfoCtrl (VIP, lordInfo, etc.)
    print("\n=== LORD INFO CTRL KEYS ===")
    lic = conn.init_data.get('lordInfoCtrl', {})
    for k, v in lic.items():
        if isinstance(v, dict):
            print(f"  {k}: dict keys={list(v.keys())[:10]}")
        else:
            print(f"  {k}: {v}")

    # VIP details:
    print("VIP in lordInfoCtrl:", lic.get('vip'))
    print("lordInfo:", lic.get('lordInfo'))

    # 5. heroSysCtrl
    print("\n=== HERO SYS CTRL ===")
    hero_sys = conn.init_data.get('heroSysCtrl', {})
    print("heroSysCtrl keys:", list(hero_sys.keys()))
    for hk, hv in hero_sys.items():
        if isinstance(hv, dict):
            print(f"  {hk}: dict len={len(hv)}, sample keys={list(hv.keys())[:5]}")
        elif isinstance(hv, list):
            print(f"  {hk}: list len={len(hv)}, sample={hv[:3]}")
        else:
            print(f"  {hk}: {hv}")

    if 'heros' in hero_sys:
        for hid, h in hero_sys['heros'].items():
            if str(hid) in ['1712', '1711', '1717', '1707', '1708']:
                print(f"Hero {hid}: {h}")

    if bot.conn:
        bot.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
