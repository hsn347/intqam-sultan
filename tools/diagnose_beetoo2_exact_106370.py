# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db
from tasks.base_task import BaseTask

class DiagnosticTask(BaseTask):
    def __init__(self, conn, config=None):
        super().__init__(conn, log_func=print, config=config or {})
        self.name = "diagnostic"

    async def run(self):
        # 1. Check buff module 1019, 1
        print("=== Checking CMD 1019, 1 ===")
        resp_buff = await self.safe_query("1019", "1", {})
        print("1019, 1 result:", resp_buff)

        lic = self.conn.init_data.get("lordInfoCtrl", {})
        eqc = self.conn.init_data.get("equipmentCtrl", {})
        pet = self.conn.init_data.get("petCtrl", {})
        ach = self.conn.init_data.get("achievementctrl", {})
        al = self.conn.init_data.get("allianceCtrl", {})
        # Dump full diagnostics to json
        diag = {
            "resp_buff": resp_buff,
            "lordInfoCtrl": lic,
            "equipmentCtrl": eqc,
            "petCtrl": pet,
            "achievementctrl": ach,
            "allianceCtrl": al,
        }
        with open("tools/beetoo2_live_diag.json", "w", encoding="utf-8") as f:
            json.dump(diag, f, indent=2, ensure_ascii=False)
        print("Saved to tools/beetoo2_live_diag.json")

async def main():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return

    task = DiagnosticTask(bot.conn, config=bot.config)
    await task.run()

    await bot.stop()

if __name__ == "__main__":
    asyncio.run(main())
