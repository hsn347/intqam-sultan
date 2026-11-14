# -*- coding: utf-8 -*-
import asyncio
import sys
import core.database as db
from bot_manager import CastleBot


async def inspect_account(email: str):
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    ok = await bot.connect()
    if not ok or not bot.conn:
        print(f"❌ Failed to connect to {email}")
        return

    conn = bot.conn
    init_data = conn.init_data
    base = init_data.get("lordInfoCtrl", {}).get("base", {})
    vip = init_data.get("lordInfoCtrl", {}).get("vip", {})
    gold = base.get("gold", "N/A")
    uid = getattr(bot.creds, "uid", "N/A")
    kingdom = getattr(bot.creds, "kingdom_id", "N/A")
    queue_data = init_data.get("cityCtrl", {}).get("queue", {})
    queue_ctrl = init_data.get("queueCtrl", {})

    print(f"Account: {email}")
    print(f"  UID: {uid} | Kingdom: {kingdom}")
    print(f"  Gold: {gold}")
    print(f"  VIP: {vip}")
    print(f"  cityCtrl.queue: {queue_data}")
    print(f"  queueCtrl: {queue_ctrl}")

    await bot.conn.close()


async def main():
    emails = sys.argv[1:] if len(sys.argv) > 1 else [
        "beetoo1@hotmail.com",
        "beetoo2@hotmail.com",
        "beetoo3@hotmail.com",
        "LUCIFER@g4.coom",
    ]
    for email in emails:
        print("─" * 60)
        try:
            await inspect_account(email)
        except Exception as e:
            print(f"Error checking {email}: {e}")
    print("─" * 60)


if __name__ == "__main__":
    asyncio.run(main())
