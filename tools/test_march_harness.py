# -*- coding: utf-8 -*-
import asyncio
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db
from tasks.base_task import BaseTask

class TestHarness(BaseTask):
    def __init__(self, conn):
        super().__init__(conn, log_func=print)
    async def run(self):
        pass

class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}

async def test_live_account(email: str):
    c_data = db.get_castle_by_id(email)
    if not c_data:
        print(f"Account {email} not found in database")
        return
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print(f"Failed to connect to {email}")
        return
    await asyncio.sleep(2.0)
    task = TestHarness(bot.conn)
    
    print(f"\n=======================================================")
    print(f"=== TESTING LIVE ACCOUNT: {email} ===")
    print(f"=======================================================")
    
    # 1. Bare castle capacity
    bare = task.get_max_march_capacity(heroes="none", breakdown=True)
    print(f"[1] Bare Capacity: {bare['total_capacity']}")
    print(f"    Building Lv.{bare['drill_grounds']['level']}: {bare['drill_grounds']['total_building_capacity']}")
    print(f"    Tech Add: {bare['technology']['tech_add']}")
    print(f"    Buffs: +{bare['buffs']['percent_bonus_troops']} troops ({bare['buffs']['percent_add']*100:.1f}%)")
    
    # 2. Auto selected best heroes
    auto = task.get_max_march_capacity(heroes=None, breakdown=True)
    print(f"\n[2] Auto Best Heroes Capacity: {auto['total_capacity']}")
    print(f"    Hero additions: +{auto['heroes']['total_hero_add']} from {auto['heroes']['hero_count']} heroes")
    for h in auto['heroes']['details']:
        print(f"      - Hero {h['hero_id']} ({h['name']}): Lv.{h['level']} Rarity {h['rarity']} Quality {h['quality']} -> +{h['total_hero_add']}")
        
    # 3. Specific heroes passed
    spec = task.get_max_march_capacity(heroes=[1712, 1711], breakdown=True)
    print(f"\n[3] Specific Heroes [1712, 1711] Capacity: {spec['total_capacity']}")
    print(f"    Hero additions: +{spec['heroes']['total_hero_add']}")
    
    # 4. Target parameter with allow_max_count
    target_obj = {
        "toPoint": 123456,
        "instanceType": 1,
        "allow_max_count": 50000,
        "move_line_type": 1,
    }
    tgt_res = task.get_max_march_capacity(target=target_obj, breakdown=True)
    print(f"\n[4] Target with allow_max_count=50,000 Capacity: {tgt_res['total_capacity']} (Capped: {tgt_res['total_capacity'] == 50000})")
    
    # 5. Target parameter as mass march
    target_mass = {
        "toPoint": 654321,
        "is_mass": True,
    }
    mass_res = task.get_max_march_capacity(target=target_mass, breakdown=True)
    print(f"\n[5] Target Mass March Capacity: {mass_res['total_capacity']} (is_mass={mass_res['is_mass']}, moveLine={mass_res['move_line_type']})")
    
    await bot.conn.close()

def test_mock_edge_cases():
    print(f"\n=======================================================")
    print(f"=== TESTING MOCK EDGE CASES ===")
    print(f"=======================================================")
    
    # Empty memory
    empty_task = TestHarness(MockConn({}))
    cap_empty = empty_task.get_max_march_capacity()
    print(f"[Mock 1] Empty memory default capacity: {cap_empty} (Expected 1000: {cap_empty == 1000})")
    assert cap_empty == 1000
    
    # allow_max_count cap
    cap_capped = empty_task.get_max_march_capacity(allow_max_count=450)
    print(f"[Mock 2] Capped capacity with allow_max_count=450: {cap_capped} (Expected 450: {cap_capped == 450})")
    assert cap_capped == 450
    
    # Target parameter on empty memory
    tgt_cap = empty_task.get_max_march_capacity(target={"allow_max_count": 700})
    print(f"[Mock 3] Target allow_max_count=700: {tgt_cap} (Expected 700: {tgt_cap == 700})")
    assert tgt_cap == 700
    
    # Custom hero dict
    custom_hero = [{"hero_id": 1712, "level": 60, "quality": 5, "rarity": 3}]
    cap_hero = empty_task.get_max_march_capacity(heroes=custom_hero)
    print(f"[Mock 4] Custom hero 1712 (Lv.60 Quality 5): {cap_hero} (Expected 1000 + 7500 = 8500: {cap_hero == 8500})")
    assert cap_hero == 8500
    
    # Unowned hero ID should be ignored
    cap_unowned = empty_task.get_max_march_capacity(heroes=[999999])
    print(f"[Mock 5] Unowned hero ID ignored: {cap_unowned} (Expected 1000: {cap_unowned == 1000})")
    assert cap_unowned == 1000
    
    print("ALL MOCK TESTS PASSED SUCCESSFULLY!")

async def main():
    test_mock_edge_cases()
    await test_live_account("beetoo2@hotmail.com")
    await test_live_account("beetoo1@hotmail.com")
    await test_live_account("beetoo3@hotmail.com")

if __name__ == "__main__":
    asyncio.run(main())
