import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.abspath("."))

from bot_manager import BotManager

async def inspect():
    bm = BotManager()
    account = bm.db.get_castle_by_email("beetoo1@hotmail.com")
    conn = await bm.get_connection(account)
    if not conn:
        print("Failed to connect!")
        return

    init_data = conn.init_data
    
    # 1. CityCtrl blist
    city_ctrl = init_data.get("cityCtrl", {})
    blist = city_ctrl.get("blist", {})
    b121 = blist.get("121") or blist.get(121)
    b101 = blist.get("101") or blist.get(101)
    print("b121 (Drill Grounds):", b121)
    print("b101 (Castle):", b101)

    # 2. TechnologyCtrl
    tech_ctrl = init_data.get("technologyCtrl", {})
    tech_list = tech_ctrl.get("list", {})
    print(f"Total techs in tech_ctrl: {len(tech_list)}")
    for tid, val in tech_list.items():
        if str(tid) in ["24016", "24032", "25030", "25011"]:
            print(f"Tech {tid}: {val}")

    # 3. AchievementCtrl
    ach_ctrl = init_data.get("achievementctrl", {})
    ach_list = ach_ctrl.get("list", {})
    print("Achievement 17:", ach_list.get("17") or ach_list.get(17))

    await bm.stop_all()

asyncio.run(inspect())
