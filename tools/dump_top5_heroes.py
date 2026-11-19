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
    await bot.connect()
    await asyncio.sleep(2.0)
    h_ctrl = bot.conn.init_data.get('heroSysCtrl', {})
    hlist = h_ctrl.get('heroList', {})
    top5 = ['1712', '1711', '1717', '1707', '1708', '1700']
    for hid in top5:
        if hid in hlist:
            print(f"=== HERO {hid} ===")
            print(json.dumps(hlist[hid], indent=2))
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
