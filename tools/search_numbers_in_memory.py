"""
Search all numbers and values in beetoo2 conn.init_data
"""
import asyncio, json, os, sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot

async def search_init_data():
    bot = CastleBot(email='beetoo2@hotmail.com', password=None, log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    d = bot.conn.init_data

    def scan(obj, path=""):
        if isinstance(obj, dict):
            for k, v in obj.items():
                scan(v, f"{path}.{k}")
        elif isinstance(obj, list):
            for i, v in enumerate(obj):
                scan(v, f"{path}[{i}]")
        elif isinstance(obj, (int, float)):
            if 80000 <= obj <= 250000:
                print(f"Number match: {path} = {obj}")
        elif isinstance(obj, str):
            if obj.isdigit():
                val = int(obj)
                if 80000 <= val <= 250000:
                    print(f"String number match: {path} = '{obj}'")

    print("--- SCANNING FOR NUMBERS BETWEEN 80,000 AND 250,000 ---")
    scan(d)

    await bot.stop()

asyncio.run(search_init_data())
