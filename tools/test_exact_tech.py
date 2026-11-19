# -*- coding: utf-8 -*-
import json
import os
import sys

tools_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(tools_dir)

# Read beetoo2 technologyCtrl from saved session / memory dump or connect
from bot_manager import CastleBot
import core.database as db
import asyncio

async def test_tech():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        return
    await asyncio.sleep(2.0)
    tech_data = bot.conn.init_data.get("technologyCtrl", {})
    await bot.conn.close()
    
    print(f"tech_data count: {len(tech_data)}")
    # Load all technology tables
    # Let's inspect technology_config or technology.lua
    tech_file = os.path.join(root_dir, "game_file", "src", "app", "localtb", "config_server", "technology.lua")
    print(f"tech_file exists: {os.path.exists(tech_file)}")
    
    # Let's search all technologies in tech_data that have buffType == 43
    # Or let's parse technology.lua
    with open(tech_file, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
        
    print(f"technology.lua size: {len(content)} bytes")
    # Check if there are other technologies
    # In Ros, technology IDs for leadership:
    # 24016 (قيادة 1), 24032 (قيادة 2), 24048 (قيادة 3), 25030 (قيادة متقدمة)...
    # What did beetoo2 have?
    for k, v in tech_data.items():
        tid = v[0] if isinstance(v, list) else k
        tlv = v[1] if isinstance(v, list) else v
        # Let's search for tid in technology.lua
        pattern = f'["{tid}{tlv:02d}"]'
        alt = f'["{tid}_{tlv}"]'
        if f'technologyId = {tid}' in content or f'technologyId = "{tid}"' in content or f'{tid}' in content:
            # Let's see if this tech has buffType 43
            pass

if __name__ == "__main__":
    asyncio.run(test_tech())
