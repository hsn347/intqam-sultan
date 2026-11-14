# -*- coding: utf-8 -*-
"""
tools/run_three_arena_checks.py — إجراء 3 فحوصات متتابعة للحلبة مع فواصل زمنية بشرية
══════════════════════════════════════════════════════════════════════════════════════
الهدف:
  تنفيذ 3 جولات فحص واستعلام ميداني حقيقي لخصوم الحلبة لحساب beetoo3@hotmail.com
  مع تطبيق فواصل زمنية بشرية طبيعية ومحترمة (Human Jitter) بين كل فحص والآخر،
  وعرض تفاصيل الخصوم والقوى والرتب في كل جولة للمقارنة.
"""

import asyncio
import json
import os
import random
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bot_manager import CastleBot
import core.database as db


async def run_checks():
    email = "beetoo3@hotmail.com"
    print("═" * 78)
    print(f" 🧪 بدء الفحص الميداني الثلاثي لخصوم الحلبة (حساب: {email})")
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
    print(f"✓ متصل بالبوابة بنجاح! UID={getattr(bot.creds, 'uid', 'N/A')} | المملكة={getattr(bot.creds, 'kingdom_id', 'N/A')}\n")

    results = []

    for round_num in range(1, 4):
        now_str = time.strftime("%H:%M:%S")
        print("─" * 78)
        print(f" 🔍 [الفحص رقم {round_num}/3] — التوقيت: {now_str}")
        print("─" * 78)

        if round_num == 1:
            # الفحص الأول: استعلام فتح الحلبة الأساسي (CMD 2056 / SUBCMD 1)
            print("📡 إرسال استعلام فتح الحلبة وجلب الخصوم (CMD 2056 / SUBCMD 1)...")
            r = await conn.query("2056", "1", {"arenaType": 1})
        elif round_num == 2:
            # الفحص الثاني: استعلام تحديث الخصوم مجاناً (CMD 2056 / SUBCMD 9)
            print("🔄 إرسال طلب التحديث المجاني للخصوم (CMD 2056 / SUBCMD 9)...")
            r = await conn.query("2056", "9", {"arenaType": 1})
        else:
            # الفحص الثالث: إعادة استعلام حالة الحلبة للتحقق من ثبات البيانات (CMD 2056 / SUBCMD 1)
            print("📡 إرسال استعلام تأكيدي لحالة الحلبة (CMD 2056 / SUBCMD 1)...")
            r = await conn.query("2056", "1", {"arenaType": 1})

        if not r or str(r.get("err", "0")) != "0":
            err_code = str(r.get("err", "unknown")) if r else "timeout"
            print(f"❌ فشل الاستعلام في الفحص رقم {round_num} (كود السيرفر: {err_code})")
            continue

        rspdata = r.get("rspdata") or r.get("data", {}).get("rspdata", {})
        enemies = rspdata.get("enemyInfo", [])
        top_lord = rspdata.get("rankinfo", {})

        round_data = {
            "round": round_num,
            "time": now_str,
            "enemies_count": len(enemies),
            "enemies": [],
            "top_lord_name": top_lord.get("nickName", "Unknown"),
            "top_lord_power": top_lord.get("fightCapacity", 0),
        }

        print(f"✓ تم استلام البيانات بنجاح: {len(enemies)} خصوم متوفرين.")
        if top_lord.get("nickName"):
            print(f"👑 متصدر الحلبة حالياً: [{top_lord.get('nickName')}] (الرتبة #1 | القوة: {top_lord.get('fightCapacity', 0):,})")

        for idx, enemy in enumerate(enemies, 1):
            e_info = {
                "idx": idx,
                "nick": enemy.get("nickName", "Unknown"),
                "uid": enemy.get("uid"),
                "rank": enemy.get("rank"),
                "power": int(enemy.get("fightCapacity", 0) or 0),
                "robot": enemy.get("robotFlag", False),
                "troops_count": sum(int(a.get("num", 0)) for a in enemy.get("armyInfo", [])) if isinstance(enemy.get("armyInfo"), list) else 0,
            }
            round_data["enemies"].append(e_info)
            print(f"   [{idx}] {e_info['nick']:14} | UID: {e_info['uid']:8} | الرتبة: #{e_info['rank']:<3} | القوة: {e_info['power']:>7,} | الجنود: {e_info['troops_count']} جندي {'🤖 [روبوت]' if e_info['robot'] else '👤 [لاعب]'}")

        # تحديد الخصم الأضعف
        if enemies:
            weakest = min(round_data["enemies"], key=lambda x: x["power"])
            round_data["weakest"] = weakest
            print(f"   🎯 الخصم الأسهل للفوز: [{weakest['nick']}] بقوة {weakest['power']:,} ورتبة #{weakest['rank']}")

        results.append(round_data)

        # تطبيق فاصل بشري محترم بين الفحوصات ما لم يكن الفحص الأخير
        if round_num < 3:
            delay = round(random.uniform(5.5, 8.5), 2)
            print(f"\n⏳ تطبيق فاصل بشري آمن: انتظار {delay} ثوانٍ قبل الفحص التالي...")
            await asyncio.sleep(delay)
            print()

    # إغلاق الاتصال بأمان
    await conn.close()
    print("\n🔒 تم إغلاق الاتصال بأمان.")
    print("═" * 78)
    print(" 🎉 اكتملت الفحوصات الثلاثة بنجاح تام!")
    print("═" * 78 + "\n")


if __name__ == "__main__":
    asyncio.run(run_checks())
