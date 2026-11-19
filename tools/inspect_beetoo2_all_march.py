import sys
import os
import json
import asyncio

# Add project root to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db

async def inspect():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    if not c_data:
        # try searching
        castles = db.get_all_castles()
        c_data = next((c for c in castles if "beetoo2" in c.get("email", "")), None)
        if c_data:
            email = c_data["email"]

    print(f"Connecting to {email}...")
    b = CastleBot(email=email, password=c_data.get("password") if c_data else None, log_callback=lambda m: None)
    b.is_running = True
    ok = await b.connect()
    if not ok or not b.conn:
        print("Failed to connect!")
        return

    init = b.conn.init_data
    print("=== CONNECTED SUCCESSFULLY ===")
    print("Init keys:", list(init.keys()))

    # 1. Drill grounds & buildLogic
    # Let's inspect cityCtrl or build
    build_ctrl = init.get("cityCtrl") or init.get("build") or {}
    print("City/Build keys or type:", type(build_ctrl))

    # 2. Technology / Science
    tech_ctrl = init.get("technologyCtrl") or {}
    print("technologyCtrl items count:", len(tech_ctrl) if isinstance(tech_ctrl, dict) else 0)
    # Check single troop strength and other march techs:
    # 24016 (single troop strength 1)
    # 25030 (single troop strength 2)
    # 24032 (single troop strength 3)
    # 24037?
    for k, v in tech_ctrl.items() if isinstance(tech_ctrl, dict) else []:
        if any(x in str(k) for x in ["24016", "25030", "24032", "24037", "24011", "24017", "24033", "25017", "25023"]):
            print(f"Tech {k}: {v}")

    # 3. Buffs (buffCtrl)
    buff_ctrl = init.get("buffCtrl") or {}
    print("buffCtrl keys:", list(buff_ctrl.keys()) if isinstance(buff_ctrl, dict) else type(buff_ctrl))
    if isinstance(buff_ctrl, dict):
        for k, v in buff_ctrl.items():
            print(f"  buffCtrl[{k}]: {v}")

    # 4. attributeSystem (attributeSystem or attr)
    attr_ctrl = init.get("attributeSystem") or init.get("attr") or {}
    print("attributeSystem:", attr_ctrl)

    # 5. heroCtrl
    hero_ctrl = init.get("heroCtrl") or {}
    print("heroCtrl keys:", list(hero_ctrl.keys()) if isinstance(hero_ctrl, dict) else type(hero_ctrl))
    if isinstance(hero_ctrl, dict):
        heros = hero_ctrl.get("heros") or hero_ctrl.get("heroList") or {}
        print("heroCtrl heroes count:", len(heros))
        for hid, hdata in heros.items():
            if isinstance(hdata, dict):
                # print state, level, id, etc
                print(f"Hero {hid}: level={hdata.get('level')} state={hdata.get('state')} star={hdata.get('star')} quality={hdata.get('quality')}")
                if "dress" in hdata or "skin" in hdata or "arms" in hdata:
                    print(f"  hero extra: dress={hdata.get('dress')} skin={hdata.get('skin')} arms={hdata.get('arms')}")

    # 6. divineBeastCtrl
    beast_ctrl = init.get("divineBeastCtrl") or {}
    print("divineBeastCtrl:", beast_ctrl)

    # 7. godArmsRuneCtrl
    arms_ctrl = init.get("godArmsRuneCtrl") or init.get("godArmsCtrl") or {}
    print("godArmsCtrl:", arms_ctrl)

    # 8. lordInfoCtrl
    lord_ctrl = init.get("lordInfoCtrl") or {}
    print("lordInfoCtrl:", lord_ctrl)

    # 9. VIP ctrl
    vip_ctrl = init.get("vipCtrl") or {}
    print("vipCtrl:", vip_ctrl)

    # 10. allianceCtrl
    all_ctrl = init.get("allianceCtrl") or {}
    print("allianceCtrl:", all_ctrl)

    # Disconnect
    await b.disconnect()

if __name__ == "__main__":
    asyncio.run(inspect())
