import asyncio
import sys
import os
import json

sys.path.insert(0, os.path.abspath("."))
from bot_manager import CastleBot
import core.database as db

async def main():
    c_data = db.get_castle_by_id("beetoo2@hotmail.com")
    b = CastleBot(email="beetoo2@hotmail.com", password=c_data.get("password"), log_callback=lambda m: None)
    b.is_running = True
    await b.connect()
    init = b.conn.init_data
    
    rarities = {
        1700: 1, 1701: 1, 1702: 1, 1703: 1,
        1704: 2, 1705: 2, 1706: 2, 1707: 2, 1708: 2, 1709: 2, 1717: 2, 1718: 2,
        1710: 3, 1711: 3, 1712: 3, 1714: 3,
        1713: 4
    }
    
    def get_march_num(hid, lv):
        r = rarities.get(hid, 1)
        if lv == 60:
            return {1: 5000, 2: 6000, 3: 7000, 4: 7000}.get(r, 5000)
        elif lv == 59:
            return 4880 if r == 1 else 5856
        elif lv == 52:
            return 4932 if r == 2 else 4110
        elif lv == 1:
            return {1: 500, 2: 600, 3: 700, 4: 700}.get(r, 500)
        return 0

    hero_list = init.get("heroSysCtrl", {}).get("heroList", {})
    parsed = []
    for hid_str, h in hero_list.items():
        hid = int(hid_str)
        lv = int(h.get("level", 1))
        state = int(h.get("state", 1))
        q = int(h.get("quality", 1))
        r = rarities.get(hid, 1)
        mn = get_march_num(hid, lv)
        V = 1 if state == 1 else 0
        parsed.append({
            "hid": hid, "lv": lv, "state": state, "quality": q,
            "rarity": r, "MarchNum": mn, "V": V, "ownL": False
        })
        
    def sort_key(x):
        return (
            -x["V"],
            0 if not x["ownL"] else -1,
            -x["MarchNum"],
            -x["lv"],
            -x["rarity"],
            -x["quality"],
            x["hid"]
        )
        
    parsed.sort(key=sort_key)
    print("Sorted heroes for dispatch:")
    for i, p in enumerate(parsed, 1):
        print(f"{i:2d}. Hero {p['hid']}: MarchNum={p['MarchNum']} lv={p['lv']} rarity={p['rarity']} quality={p['quality']}")
        
    if b.conn:
        await b.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
