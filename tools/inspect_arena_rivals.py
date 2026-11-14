# -*- coding: utf-8 -*-
"""
tools/inspect_arena_rivals.py — فحص ميداني حي لخصوم الحلبة وقواهم لحساب beetoo3
══════════════════════════════════════════════════════════════════════════════════
الهدف:
  الاتصال المباشر بحساب beetoo3@hotmail.com واستعلام الخصوم المتاحين في حلبة المملكة،
  وعرض قواهم القتالية ورتبهم وتشكيلاتهم بنفس الطريقة المتبعة تماماً في tasks/arena.py.
"""

import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bot_manager import CastleBot
import core.database as db


async def inspect_beetoo3():
    email = "beetoo3@hotmail.com"
    print("═" * 78)
    print(f" 🏟️ فحص ميداني لبيانات وخصوم الحلبة للحساب: {email}")
    print("═" * 78)

    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print(f"❌ فشل الاتصال بالبوابة للحساب {email}")
        return

    conn = bot.conn
    print(f"✓ متصل بالبوابة بنجاح! UID={getattr(bot.creds, 'uid', 'N/A')} | المملكة={getattr(bot.creds, 'kingdom_id', 'N/A')}")

    # 1. فحص بيانات الحلبة الحالية من الذاكرة الحية (0-Network)
    arena_ctrl = conn.init_data.get("playerArenaCtrl", {})
    local_arena = arena_ctrl.get("localArena", {})
    my_rank = local_arena.get("myRank", 0)
    remain_times = local_arena.get("remainTimes", 0)
    arena_group = local_arena.get("arenaGroup", 0)
    my_power = local_arena.get("fightCapacity", 0)
    rewards_count = len(local_arena.get("rewards", []))
    my_army = local_arena.get("armyInfo", [])

    everyday_ctrl = conn.init_data.get("everydayTaskCtrl", {})
    cur_challenges = 0
    if isinstance(everyday_ctrl, dict):
        event_info = everyday_ctrl.get("eventInfo", {})
        if isinstance(event_info, dict):
            cur_challenges = int(event_info.get("30", 0) or 0)

    print("\n📊 بيانات قلعتك الحالية في الحلبة (من الذاكرة الحية):")
    print(f"   • الترتيب الحالي: #{my_rank} ({'مصنف' if my_rank > 0 else 'غير مصنف'})")
    print(f"   • المحاولات المجانية المتبقية اليوم: {remain_times}")
    print(f"   • مجموعة الحلبة (Tier): {arena_group}")
    print(f"   • القوة القتالية المسجلة للدفاع: {my_power:,}")
    print(f"   • جوائز الترتيب التراكمية المعلقة: {rewards_count} جولة")
    print(f"   • تشكيلة الدفاع الحالية: {my_army}")
    print(f"   • منجز النشاط اليومي: {cur_challenges}/3 تحديات")

    # 2. إرسال استعلام الخصوم المتاحين (REQ_ARENA_GROUND_STATE = "1")
    print("\n⚔️ إرسال استعلام قائمة الخصوم المتاحين (CMD 2056 / SUBCMD 1)...")
    r_ground = await conn.query("2056", "1", {"arenaType": 1})
    if not r_ground or str(r_ground.get("err", "0")) != "0":
        err_code = str(r_ground.get("err", "unknown")) if r_ground else "timeout"
        print(f"❌ فشل استعلام الخصوم (كود السيرفر: {err_code})")
        await conn.close()
        return

    rspdata = r_ground.get("rspdata") or r_ground.get("data", {}).get("rspdata", {})
    enemies = rspdata.get("enemyInfo", [])
    top_lord = rspdata.get("rankinfo", {})

    print(f"✓ تم استلام قائمة الخصوم بنجاح! عدد الخصوم المعروضين: {len(enemies)}")

    print("\n" + "─" * 78)
    print(" 📋 تفاصيل الخصوم الثلاثة المتاحين للتحدي الآن:")
    print("─" * 78)

    for i, enemy in enumerate(enemies, 1):
        e_nick = enemy.get("nickName", "Unknown")
        e_uid = enemy.get("uid")
        e_rank = enemy.get("rank")
        e_power = int(enemy.get("fightCapacity", 0) or 0)
        e_robot = enemy.get("robotFlag", False)
        e_army = enemy.get("armyInfo", [])
        total_troops = sum(int(a.get("num", 0)) for a in e_army) if isinstance(e_army, list) else 0

        print(f" 🔹 الخصم رقم [{i}]:")
        print(f"    • الاسم: {e_nick} {'🤖 (روبوت سهل)' if e_robot else '👤 (لاعب حقيقي)'}")
        print(f"    • المعرف (UID): {e_uid}")
        print(f"    • الرتبة (Rank): #{e_rank}")
        print(f"    • القوة القتالية (Power): {e_power:,}")
        print(f"    • إجمالي عدد الجنود المدافعين: {total_troops:,} جندي")
        if isinstance(e_army, list) and e_army:
            army_desc = ", ".join(f"نوع {a.get('id')}: {a.get('num')}" for a in e_army)
            print(f"    • تفاصيل القوات: [{army_desc}]")
        print()

    # 3. محاكاة اختيار الخصم المستهدف طبقاً لكود المهمة tasks/arena.py
    if enemies:
        sorted_enemies = sorted(enemies, key=lambda e: int(e.get("fightCapacity", 0) or 0))
        target = sorted_enemies[0]
        t_power = int(target.get("fightCapacity", 0) or 0)
        t_nick = target.get("nickName")
        t_rank = target.get("rank")
        t_uid = target.get("uid")

        print("─" * 78)
        print(" 🎯 الخصم الذي يختاره البوت تلقائياً للفوز الساحق:")
        print(f"    • الاسم المختار: [{t_nick}]")
        print(f"    • UID: {t_uid}")
        print(f"    • الرتبة: #{t_rank}")
        print(f"    • القوة: {t_power:,} (الأقل قوة بين جميع الخصوم)")
        print("─" * 78)

    # 4. إغلاق الاتصال بأمان
    await conn.close()
    print("🔒 تم إغلاق الاتصال بأمان.")
    print("═" * 78 + "\n")


if __name__ == "__main__":
    asyncio.run(inspect_beetoo3())
