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
    eq = bot.conn.init_data.get('equipmentCtrl', {})
    print("equipmentCtrl:")
    print(json.dumps(eq, indent=2))
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
