# -*- coding: utf-8 -*-
"""
test_bot_achievement_sync.py — فحص تحققي مباشر لدورة حياة CastleBot الحقيقية ومزامنة الإنجازات
"""
import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import core.database as db
from bot_manager import CastleBot
from tasks.base_task import BaseTask


class DummyTask(BaseTask):
    async def run(self):
        pass


async def main():
    target_email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(target_email)
    pwd = c_data.get("password") if c_data else None

    bot = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True

    print(f"🔄 جاري محاكاة تشغيل البوت العام عبر CastleBot.connect() للحساب {target_email}...")
    ok = await bot.connect()
    print(f"✓ نتيجة الاتصال: {ok}")

    if ok and bot.conn:
        task = DummyTask(bot.conn, bot.log, bot.config)
        
        # 1. فحص محتوى achievementctrl في الذاكرة الحية بعد اتصال البوابة (0-Network)
        ach_ctrl_init = bot.conn.init_data.get("achievementctrl")
        print(f"\n1. هل متحكم الإنجازات موجود بالذاكرة الحية فور الاتصال بمجرد وصول CMD 1000؟ {bool(ach_ctrl_init)}")
        if isinstance(ach_ctrl_init, dict):
            print(f"   • المفاتيح المستلمة من السيرفر: {list(ach_ctrl_init.keys())}")
            if "list" in ach_ctrl_init:
                print(f"   • عدد الأوسمة المستلمة: {len(ach_ctrl_init['list'])}")
                print(f"   • وسام 17 بالذاكرة: {ach_ctrl_init['list'].get('17') or ach_ctrl_init['list'].get(17)}")

        # 2. الاستدعاء الأول: الدالة تفحص الذاكرة وتجلب البيانات كإجراء احتياطي وتحدث الذاكرة
        print("\n2. استدعاء get_achievement_march_buff() لأول مرة (فحص الذاكرة ثم استعلام احتياطي إن لزم)...")
        buff1 = await task.get_achievement_march_buff()
        print("📊 ناتج الاستدعاء الأول:")
        print(json.dumps(buff1, indent=2, ensure_ascii=False))

        # 3. التأكد أن البيانات شُحنت الآن في الذاكرة الحية
        in_memory_after = "achievementctrl" in bot.conn.init_data
        print(f"\n3. هل تم شحن متحكم الإنجازات بالذاكرة الحية الآن؟ {in_memory_after}")

        # 4. الاستدعاء الثاني المتزامن (0-Network) مباشرة من الذاكرة الحية
        print("\n4. استدعاء get_achievement_march_buff_sync() للمرة الثانية (0-Network من الذاكرة الحية حصراً)...")
        buff2 = task.get_achievement_march_buff_sync()
        print("📊 ناتج الاستدعاء الثاني (من الذاكرة):")
        print(json.dumps(buff2, indent=2, ensure_ascii=False))

        await bot.conn.close()


if __name__ == "__main__":
    asyncio.run(main())
