import asyncio
import sys
import json
sys.path.append('.')

from bot_manager import CastleBot
from core.database import get_castle_by_id

async def main():
    email = "beetoo2@hotmail.com"
    c_data = get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    init_data = bot.conn.init_data
    print("Connected successfully!")
    
    # 1. Drill Grounds
    builds = init_data.get("cityCtrl", {}).get("build", {})
    # Drill grounds is bid 121
    drill_grounds = []
    for k, v in builds.items():
        if v.get("bid") == 121 or str(k) == "121":
            drill_grounds.append(v)
    print("\n--- 1. DRILL GROUNDS (121) ---")
    print(json.dumps(drill_grounds, indent=2))
    
    # 2. Castle building (bid 101)
    castle = [v for k, v in builds.items() if v.get("bid") == 101 or str(k) == "101"]
    print("\n--- 2. CASTLE (101) ---")
    print(json.dumps(castle, indent=2))

    # 3. Technologies
    tech = init_data.get("technologyCtrl", {})
    print("\n--- 3. TECHNOLOGY CTRL ---")
    print("Keys in tech:", list(tech.keys()))
    print("Tech list:", json.dumps(tech.get("techList", {}), indent=2))

    # 4. Buffs
    buffs = init_data.get("buffCtrl", {})
    print("\n--- 4. BUFF CTRL ---")
    print(json.dumps(buffs, indent=2))

    # 5. Lord Skill
    lord_skill = init_data.get("lordSkillCtrl", {})
    print("\n--- 5. LORD SKILL CTRL ---")
    print(json.dumps(lord_skill, indent=2))

    # 6. VIP
    vip = init_data.get("vipCtrl", {})
    print("\n--- 6. VIP CTRL ---")
    print(json.dumps(vip, indent=2))

    # 7. God Arms & Runes
    god_arms = init_data.get("godArmsCtrl", {})
    god_arms_rune = init_data.get("godArmsRuneCtrl", {})
    print("\n--- 7. GOD ARMS & RUNES ---")
    print("godArmsCtrl:", json.dumps(god_arms, indent=2))
    print("godArmsRuneCtrl:", json.dumps(god_arms_rune, indent=2))

    # 8. Divine Beast
    divine_beast = init_data.get("divineBeastCtrl", {})
    print("\n--- 8. DIVINE BEAST CTRL ---")
    print(json.dumps(divine_beast, indent=2))

    # 9. Army Ctrl & Compiles
    army = init_data.get("armyCtrl", {})
    print("\n--- 9. ARMY CTRL ---")
    print("Army compileArmy:", json.dumps(army.get("compileArmy", {}), indent=2))
    print("Army compileHero:", json.dumps(army.get("compileHero", {}), indent=2))
    print("Army defCompileInfo:", json.dumps(army.get("defCompileInfo", {}), indent=2))

    # 10. Player Info / Castle Mastery / Titles
    player = init_data.get("playerCtrl", {})
    print("\n--- 10. PLAYER CTRL ---")
    print("Titles / Office:", player.get("officeID"), player.get("kingId"), player.get("title"))

    # 11. Attributes
    attr = init_data.get("attributeSystem", {})
    print("\n--- 11. ATTRIBUTE SYSTEM ---")
    print(json.dumps(attr, indent=2))

    # 12. City Mastery
    city = init_data.get("cityCtrl", {})
    print("\n--- 12. CITY CTRL MASTERY ---")
    print("Mastery:", city.get("mastery", {}))

    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
