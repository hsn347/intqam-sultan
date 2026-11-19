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
    init_data = bot.conn.init_data
    await bot.conn.close()

    print("All controllers in init_data:")
    for k in sorted(init_data.keys()):
        val = init_data[k]
        val_type = type(val).__name__
        val_len = len(val) if hasattr(val, '__len__') else 'N/A'
        print(f"  {k:30s}: type={val_type:10s}, len={val_len}")

    # Check warGemCtrl / gem
    for k in init_data.keys():
        if 'gem' in k.lower():
            print(f"Found gem key: {k} -> {init_data[k]}")
        if 'rank' in k.lower() or 'military' in k.lower():
            print(f"Found military/rank key: {k} -> {init_data[k]}")
        if 'pet' in k.lower():
            print(f"Found pet key: {k} -> {init_data[k]}")
        if 'cenotaph' in k.lower():
            print(f"Found cenotaph key: {k} -> {init_data[k]}")
        if 'achievement' in k.lower():
            print(f"Found achievement key: {k} -> {init_data[k]}")

if __name__ == '__main__':
    asyncio.run(main())
