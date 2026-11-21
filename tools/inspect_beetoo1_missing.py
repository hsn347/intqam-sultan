# -*- coding: utf-8 -*-
"""فحص المكونات الناقصة لحساب سعة المسيرة لـ beetoo1"""

import asyncio
import sys
import json
import math

sys.path.insert(0, 'e:/intqam-sultan')


async def main():
    from bot_manager import CastleBot
    import core.database as db
    c_data = db.get_castle_by_id('beetoo1@hotmail.com')
    pwd = c_data.get('password') if c_data else None
    bot = CastleBot(email='beetoo1@hotmail.com', password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print('CONNECTION FAILED')
        return
    bot.reload_config_from_db()
    conn = bot.conn
    init = conn.init_data

    # ══════════════════════════════════
    # 1. boeAttributeCtrl (Lord Talents / بوفات اللورد)
    # ══════════════════════════════════
    boe = init.get('boeAttributeCtrl', {})
    print('=== boeAttributeCtrl ===')
    if isinstance(boe, dict):
        print(json.dumps(boe, ensure_ascii=False, indent=2)[:2000])
    else:
        print(f'  NOT DICT: {type(boe)}')

    # ══════════════════════════════════
    # 2. VIP Level
    # ══════════════════════════════════
    vip = init.get('vipCtrl', {})
    print('\n=== VIP ===')
    if isinstance(vip, dict):
        vlv = vip.get('vipLv', vip.get('level', 0))
        print(f'  VIP level = {vlv}')

    # ══════════════════════════════════
    # 3. Equipment (Lord Weapon EID 6110000)
    # ══════════════════════════════════
    eq_ctrl = init.get('equipmentCtrl', {})
    print('\n=== Equipment ===')
    if isinstance(eq_ctrl, dict):
        eq_arr = eq_ctrl.get('equipment_array', [])
        if isinstance(eq_arr, list):
            print(f'  Total equipments: {len(eq_arr)}')
            for eq in eq_arr:
                if isinstance(eq, dict):
                    eid = eq.get('eid', 0)
                    print(f'  EID={eid}, slv={eq.get("slv")}, rlv={eq.get("rlv")}, pos={eq.get("pos")}')

    # ══════════════════════════════════
    # 4. تقنيات القيادة كاملة
    # ══════════════════════════════════
    tech = init.get('technologyCtrl', {})
    print('\n=== ALL Leadership Techs ===')
    LEADERSHIP_BUFF_TYPES = {43, 73, 77, 95}
    if isinstance(tech, dict):
        for k, v in tech.items():
            if isinstance(v, (list, tuple)) and len(v) >= 2:
                tid = int(v[0])
                tlv = int(v[1])
                # طباعة كل التقنيات المرتبطة بالقيادة
                if tid in (24016, 24032, 24048, 25030, 110027, 24011, 24017, 24033):
                    print(f'  Tech {tid} Lv.{tlv}')

    # ══════════════════════════════════
    # 5. Pet (الحيوانات - march capacity)
    # ══════════════════════════════════
    pet_ctrl = init.get('petCtrl', {}) or init.get('breedCtrl', {})
    print('\n=== Pet Ctrl (march capacity) ===')
    if isinstance(pet_ctrl, dict):
        # البحث عن بوفات المسيرة في الحيوانات
        for k, v in pet_ctrl.items():
            if isinstance(v, dict) and 'buff' in str(v).lower():
                print(f'  key={k}: {str(v)[:200]}')
    else:
        print(f'  petCtrl type: {type(pet_ctrl)}')

    # ══════════════════════════════════
    # 6. Lord Skills (مهارات اللورد)
    # ══════════════════════════════════
    lord_skill = init.get('lordSkillCtrl', {}) or init.get('talentCtrl', {})
    print('\n=== Lord Skill / Talent ===')
    if isinstance(lord_skill, dict):
        print(json.dumps(lord_skill, ensure_ascii=False, indent=2)[:1000])

    # ══════════════════════════════════
    # 7. المحاكاة الكاملة كما يفعلها بوت العثمانية
    # ══════════════════════════════════
    print('\n=== OSMANLI FORMULA SIMULATION ===')

    # سعة ميدان العرض Lv.27
    BUILD121_CAPACITY = {
        27: 59800, 28: 64400, 29: 67900, 30: 70400,
    }
    city_ctrl = init.get('cityCtrl', {})
    blist = city_ctrl.get('blist', []) if isinstance(city_ctrl, dict) else []
    drill_lv = 0
    for b in blist:
        if isinstance(b, dict):
            binfo = b.get('binfo', b)
            if isinstance(binfo, dict) and str(binfo.get('bid', '')) == '121':
                drill_lv = int(binfo.get('lv', 1))
                break

    base_cap = BUILD121_CAPACITY.get(drill_lv, 0)
    print(f'  Drill Lv={drill_lv}, base_cap={base_cap}')

    # الافتراضي 100 (عثمانية) أم 1000 (intqam)؟
    print(f'  OSMANLI default=100, INTQAM default=1000')

    # أبحاث
    tech_add = 0
    if isinstance(tech, dict):
        for k, v in tech.items():
            if isinstance(v, (list, tuple)) and len(v) >= 2:
                tid = int(v[0])
                tlv = int(v[1])
                if tid == 24016:
                    tech_add += tlv * 2000
                    print(f'  Tech 24016 Lv.{tlv} -> +{tlv * 2000}')
                elif tid == 24032:
                    tech_add += tlv * 2500
                    print(f'  Tech 24032 Lv.{tlv} -> +{tlv * 2500} (العثمانية: *2000)')
                elif tid == 24048:
                    tech_add += tlv * 3000
                elif tid == 110027:
                    tech_add += tlv * 2000

    print(f'  tech_add(osmanli)={tech_add}')

    # VIP bonus
    vip_lv = 0
    if isinstance(vip, dict):
        vip_lv = int(vip.get('vipLv', vip.get('level', 0)) or 0)
    vip_bonus = 30000 if vip_lv >= 15 else (20000 if vip_lv == 14 else (10000 if vip_lv == 13 else 0))
    print(f'  VIP Lv.{vip_lv} bonus={vip_bonus}')

    # boe multiplier
    multiplier = 0.0
    boe_flat = 0.0
    if isinstance(boe, dict):
        v5 = boe.get('1', {}).get('1', {}).get('5', {})
        if isinstance(v5, dict):
            multiplier = float(v5.get('1', 0)) / 1000.0
            boe_flat = float(v5.get('2', 0))
    print(f'  boe multiplier={multiplier}, boe_flat={boe_flat}')

    # محاكاة الحساب الكامل
    default100 = 100
    buff_value_add = vip_bonus + boe_flat  # weapon bonus ignored for now
    inner = math.floor(default100 + tech_add + buff_value_add)
    buff_add = math.floor((base_cap + inner) * multiplier)
    osmanli_base = base_cap + inner + buff_add
    print(f'  OSMANLI base = {osmanli_base}')
    print(f'  INTQAM base  = {base_cap + 1000 + 12000 + 1350} (with 1% buff)')


asyncio.run(main())
