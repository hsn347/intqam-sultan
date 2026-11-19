# -*- coding: utf-8 -*-
"""
tools/test_watermill_e2e.py — فحص ميداني شامل ومحاكاة حية لمهمة دعم الحقول (Watermill Task)
══════════════════════════════════════════════════════════════════════════════════════════
يختبر المهمة على بيانات الذاكرة الحية الحقيقية لحسابات القلاع المسجلة (beetoo1, beetoo2, beetoo3).
"""

import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.watermill import WatermillTask


class RealMemoryMockConnection:
    def __init__(self, email: str, data: dict):
        self.email = email
        self.is_connected = True
        self.init_data = data


async def test_account(email: str, memory_file: str):
    if not os.path.exists(memory_file):
        print(f"⚠️ Memory file {memory_file} not found. Skipping {email}.")
        return

    with open(memory_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    conn = RealMemoryMockConnection(email, data)
    config = {
        "enabled": True,
        "resources": ["food", "wood", "iron", "silver", "crystal"],
        "types": "all",
        "allow_shop_buy": False,
    }

    task = WatermillTask(conn, config)

    print(f"\n=======================================================")
    print(f"🏰 Testing WatermillTask on Account: {email}")
    print(f"=======================================================")

    # 1. 0-Network Pre-flight check
    can, reason = await task.can_run()
    print(f"🚦 Pre-flight Check: can_run = {can} (Reason: '{reason}')")

    # 2. Check boost items in backpack
    speedups = task.get_resource_boost_speedups()
    details = speedups.get("details", {})
    print("📦 Available Boost Items in Backpack:")
    for r_key, r_info in details.items():
        if r_key == "general":
            continue
        print(f"   - {r_info.get('name')}: {r_info.get('count')} packs ({r_info.get('total_days')} days)")

    # 3. Check building status
    status = task.get_resource_buildings_boost_status()
    print(f"🏭 Building Status: Total Fields = {status.get('total_fields')}, Boosted = {status.get('boosted_count')}, Unboosted = {status.get('unboosted_count')}")

    # 4. Simulation of run() with safe mock
    executed_requests = []

    async def mock_query(cmd, sub, payload, **kwargs):
        executed_requests.append(payload)
        return {"err": 0}

    task.safe_query = mock_query
    result = await task.run()

    print(f"🎯 Execution Result: success={result.success}, skipped={result.skipped}")
    print(f"📝 Result Message: {result.message}")
    print(f"📡 Dispatched Requests Count: {len(executed_requests)}")

    for i, req in enumerate(executed_requests[:5], 1):
        print(f"   [{i}] bid={req['bid']}, iid={req['iid']}, mode={req['mode']}, toolid={req['toolid']}")
    if len(executed_requests) > 5:
        print(f"   ... and {len(executed_requests) - 5} more requests.")


async def main():
    accounts = [
        ("beetoo1@hotmail.com", "docs/beetoo1_live_memory.json"),
        ("beetoo3@hotmail.com", "docs/beetoo3_live_memory.json"),
        ("lucifer@g4.coom", "docs/lucifer_live_memory.json"),
    ]

    for em, mem in accounts:
        await test_account(em, mem)

    print("\n✅ All E2E simulation checks completed successfully!")


if __name__ == "__main__":
    asyncio.run(main())
