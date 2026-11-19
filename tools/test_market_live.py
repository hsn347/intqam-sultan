# -*- coding: utf-8 -*-
"""
tools/test_market_live.py
فحص نتائج get_market_transport_capacity مع التفصيل الكامل (breakdown=True) على قلعة حية.
"""

import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db
from tasks.alliance import AllianceTask


async def main():
    email = "beetoo3@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    try:
        task = AllianceTask(bot.conn, lambda m: None, {"enabled": True})
        
        # 1. السعة الإجمالية بالوزن
        total_weight = task.get_market_transport_capacity()
        print(f"📊 إجمالي سعة الوزن الممكنة في النقل الواحد: {total_weight:,}")

        # 2. فحص سعات الموارد الفردية
        print("\n📦 سعات الموارد الفردية في النقل الواحد:")
        for res_name in ["food", "wood", "iron", "silver", "crystal"]:
            cap = task.get_market_transport_capacity(resource_type=res_name)
            print(f"   • {res_name}: {cap:,} وحدة")

        # 3. التفصيل الشامل (breakdown=True)
        bd = task.get_market_transport_capacity(breakdown=True)
        print("\n🔍 تفاصيل السوق والعلوم والضرائب (Breakdown):")
        print(json.dumps(bd, ensure_ascii=False, indent=2))

    finally:
        await bot.conn.close()


if __name__ == "__main__":
    asyncio.run(main())
