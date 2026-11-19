import asyncio
import sys
import re
import os
sys.path.append('.')

from bot_manager import CastleBot
from core.database import get_castle_by_id

# Let's parse technology details from technology details lua files
# Where are technology details? Let's find files
tech_files = [
    r"e:\intqam-sultan\game_file\src\app\localtb\config_client\technologydetails.lua",
    r"e:\intqam-sultan\game_file\src\app\localtb\config_client\wartechnologydetails.lua",
    r"e:\intqam-sultan\game_file\src\app\localtb\config_client\legendtechnologydetails.lua",
    r"e:\intqam-sultan\game_file\src\app\localtb\config_client\civtechnologydetails.lua",
]

def load_tech_details():
    tech_map = {}
    for path in tech_files:
        if not os.path.exists(path):
            continue
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        # Find entries: [id] = { ... } or id = { ... }
        # Let's extract entries with buffType and powerNum
        # Example pattern: (nil)[2401603] or ["2401603"] or id = 2401603
        chunks = content.split(';')
        for ch in chunks:
            # Look for id, buffType, powerNum
            m_id = re.search(r'\[(\d+)\]', ch)
            m_buff = re.search(r'buffType\s*=\s*(\d+)', ch)
            m_power = re.search(r'powerNum\s*=\s*([\d\.]+)', ch)
            m_card = re.search(r'buffNumType\s*=\s*(\d+)', ch)
            # Or table format
            pass
    return tech_map

async def main():
    email = "beetoo2@hotmail.com"
    c_data = get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    tech = bot.conn.init_data.get("technologyCtrl", {})
    print("beetoo2 tech keys:", tech)
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
