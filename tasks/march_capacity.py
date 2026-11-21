# -*- coding: utf-8 -*-
"""
tasks/march_capacity.py — المحرك المركزي الموحد لحساب سعة مسيرة اللورد والجيش (انتقام السلاطين)
════════════════════════════════════════════════════════════════════════════════════════════════
مطابق لسورس كود اللعبة الأصلي (buildLogic.lua, WorldDispatchArmyViewPanel.lua, heroltCtrl.lua):
  1. سعة ساحة العرض الأساسية (مبنى 121 - DRILL_GROUDS) Lv.1..130 + نجوم قصر المجد (starLv) 1..70.
  2. الثابت الرياضي الافتراضي للعبة (gConstValue.DEFAULT_EXP_ARMY_COUNT = 1000 جندي).
  3. جميع أبحاث القيادة الفردية (16 بحثاً - Buff Type 43) ومجموعات العلوم المئوية (73, 77, 95).
  4. بافات امتلاك مظاهر الأبطال السلبية (dress.list - Effect 96) مع استبعاد الأموات والمأسورين.
  5. وسام القائد 'توحيد القوة' (وسام 9003017 - achievementctrl.list["17"]).
  6. باف امتياز كبار الشخصيات VIP / SVIP (الامتياز 7219) مع التحقق الإلزامي من سريان المدة (vipEndTime > now).
  7. بافات المسيرة النشطة (Effect 19 مئوي + Effect 96 رقمي + بافات الحشد 736/737) مع فحص انتهاء الصلاحية.
  8. سعة الأبطال المرسلين (الندرة المتأصلة rarity × المستوى من hero_level_config.lua + مهارات المعركة +480)
     تُضاف مباشرة بعد حساب سعة القلعة بدون ضربها في المضاعف المئوي (مطابق لـ WorldDispatchArmyViewPanel.lua).
  9. قراءة رونات العتاد الإلهي (godArmsRuneCtrl) والوحوش الإلهية (divineBeastCtrl) إن وُجدت في الذاكرة الحية.
  10. صمام الأمان (enforce_safe_march_troops) وتثبيت السقف المتعلم (record_learned_march_capacity).
  11. تشغيل مستقل من سطر الأوامر (CLI):
      python tasks/march_capacity.py --email LUCIFER@g4.coom
      python tasks/march_capacity.py --email beetoo1 --available
      python tasks/march_capacity.py --email beetoo2 --heroes 1700,1712,1717,1711,1707
      python tasks/march_capacity.py --email beetoo2 --json
      python tasks/march_capacity.py --all
"""

from __future__ import annotations

import argparse
import asyncio
import json
import logging
import math
import os
import sys
import time
from typing import Any, Dict, List, Optional, Set, Tuple, Union

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

log = logging.getLogger("march_capacity")

# ══════════════════════════════════════════════════════════════════════════════
# 1. جداول البيانات الرسمية المدمجة (Official Game Master Tables)
# ══════════════════════════════════════════════════════════════════════════════

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)
MASTER_TABLES_PATH = os.path.join(ROOT_DIR, "tools", "master_march_tables.json")

DEFAULT_EXP_ARMY_COUNT = 1000
DRILL_GROUNDS_BUILDING_ID = 121
CASTLE_BUILDING_ID = 101

G_HERO_STATE_NORMAL = 1
G_HERO_STATE_DEAD = 2
G_HERO_STATE_CAPTURED = 3
G_HERO_STATE_BATTLE = 4
G_HERO_STATE_DEFEND = 5

MASS_MOVE_LINE_TYPES: Set[int] = {3, 4, 7, 8, 9, 13, 14, 21, 29, 30, 36, 38, 48, 53, 56}

# سعة مبنى ساحة العرض الأساسية (build121.lua: Lv.1..130)
DRILL_GROUNDS_CAPACITY: Dict[int, int] = {
    1: 3000, 2: 5000, 3: 7100, 4: 9300, 5: 11600, 6: 14000, 7: 16500, 8: 19100, 9: 21800, 10: 24600,
    11: 27500, 12: 30500, 13: 33600, 14: 36800, 15: 40100, 16: 43500, 17: 47000, 18: 50600, 19: 54300, 20: 58100,
    21: 62000, 22: 66000, 23: 70100, 24: 74300, 25: 78600, 26: 83000, 27: 87500, 28: 92100, 29: 96800, 30: 101600,
    31: 101600, 32: 101600, 33: 101600, 34: 101600, 35: 101600, 36: 101600, 37: 101600, 38: 101600, 39: 101600, 40: 106500,
    41: 106500, 42: 106500, 43: 106500, 44: 106500, 45: 106500, 46: 106500, 47: 106500, 48: 106500, 49: 106500, 50: 112000,
    51: 112000, 52: 112000, 53: 112000, 54: 112000, 55: 112000, 56: 112000, 57: 112000, 58: 112000, 59: 112000, 60: 120000,
    61: 120000, 62: 120000, 63: 120000, 64: 120000, 65: 120000, 66: 120000, 67: 120000, 68: 120000, 69: 120000, 70: 128000,
    71: 128000, 72: 128000, 73: 128000, 74: 128000, 75: 128000, 76: 128000, 77: 128000, 78: 128000, 79: 128000, 80: 136000,
    81: 136000, 82: 136000, 83: 136000, 84: 136000, 85: 136000, 86: 136000, 87: 136000, 88: 136000, 89: 136000, 90: 146000,
    91: 146000, 92: 146000, 93: 146000, 94: 146000, 95: 146000, 96: 146000, 97: 146000, 98: 146000, 99: 146000, 100: 158000,
    101: 158000, 102: 158000, 103: 158000, 104: 158000, 105: 158000, 106: 158000, 107: 158000, 108: 158000, 109: 158000, 110: 172000,
    111: 172000, 112: 172000, 113: 172000, 114: 172000, 115: 172000, 116: 172000, 117: 172000, 118: 172000, 119: 172000, 120: 188000,
    121: 188000, 122: 188000, 123: 188000, 124: 188000, 125: 188000, 126: 188000, 127: 188000, 128: 188000, 129: 188000, 130: 208000,
}

# سعة نجوم قصر المجد لساحة العرض (buildstar121.lua: Star Lv.1..70)
DRILL_GROUNDS_STAR_CAPACITY: Dict[int, int] = {
    1: 1500, 2: 3000, 3: 4500, 4: 6000, 5: 7500, 6: 9000, 7: 13500, 8: 15000, 9: 16500, 10: 18000,
    11: 19500, 12: 21000, 13: 22500, 14: 24000, 15: 25500, 16: 27000, 17: 31500, 18: 33000, 19: 34500, 20: 36000,
    21: 37500, 22: 39000, 23: 40500, 24: 42000, 25: 43500, 26: 45000, 27: 46500, 28: 48000, 29: 49500, 30: 51000,
    31: 55500, 32: 57000, 33: 58500, 34: 60000, 35: 61500, 36: 63000, 37: 64500, 38: 66000, 39: 67500, 40: 69000,
    41: 70500, 42: 72000, 43: 73500, 44: 75000, 45: 76500, 46: 78000, 47: 79500, 48: 81000, 49: 85500, 50: 87000,
    51: 88500, 52: 90000, 53: 91500, 54: 93000, 55: 94500, 56: 96000, 57: 97500, 58: 99000, 59: 100500, 60: 102000,
    61: 103500, 62: 105000, 63: 106500, 64: 108000, 65: 109500, 66: 111000, 67: 112500, 68: 114000, 69: 115500, 70: 120000,
}

# جميع أبحاث القيادة الفردية (technology.lua: buffType=43)
LEADERSHIP_TECH_ADDITIONS: Dict[int, Dict[int, int]] = {
    24016: {1: 2000, 2: 4000, 3: 6000},
    24032: {1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500},
    24048: {1: 3000, 2: 6000, 3: 9000, 4: 12000, 5: 15000, 6: 18000, 7: 21000},
    25030: {1: 1000},
    110027: {1: 2000, 2: 4000, 3: 6000, 4: 8000, 5: 10000},
    170012: {1: 750, 2: 1500, 3: 2250, 4: 3000, 5: 3750, 6: 4500, 7: 5250, 8: 6000, 9: 6750, 10: 7500},
    170013: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170054: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170055: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170092: {
        1: 300, 2: 600, 3: 900, 4: 1200, 5: 1500, 6: 1950, 7: 2400, 8: 2850, 9: 3300, 10: 3750,
        11: 4350, 12: 4950, 13: 5550, 14: 6150, 15: 6750, 16: 7500, 17: 8250, 18: 9000, 19: 9750, 20: 10500,
        21: 11400, 22: 12300, 23: 13200, 24: 14100, 25: 15000,
    },
    170104: {
        1: 400, 2: 800, 3: 1200, 4: 1600, 5: 2000, 6: 2500, 7: 3000, 8: 3500, 9: 4000, 10: 4500,
        11: 5100, 12: 5700, 13: 6300, 14: 6900, 15: 7500, 16: 8200, 17: 8900, 18: 9600, 19: 10300, 20: 11000,
        21: 11800, 22: 12600, 23: 13400, 24: 14200, 25: 15000, 26: 16000, 27: 17000, 28: 18000, 29: 19000, 30: 20000,
    },
    170140: {
        1: 300, 2: 600, 3: 900, 4: 1200, 5: 1500, 6: 1875, 7: 2250, 8: 2625, 9: 3000, 10: 3375,
        11: 3825, 12: 4275, 13: 4725, 14: 5175, 15: 5625, 16: 6150, 17: 6675, 18: 7200, 19: 7725, 20: 8250,
        21: 8850, 22: 9450, 23: 10050, 24: 10650, 25: 11250, 26: 12000, 27: 12750, 28: 13500, 29: 14250, 30: 15000,
    },
    170148: {
        1: 480, 2: 960, 3: 1440, 4: 1920, 5: 2400, 6: 3000, 7: 3600, 8: 4200, 9: 4800, 10: 5400,
        11: 6120, 12: 6840, 13: 7560, 14: 8280, 15: 9000, 16: 9840, 17: 10680, 18: 11520, 19: 12360, 20: 13200,
        21: 14160, 22: 15120, 23: 16080, 24: 17040, 25: 18000, 26: 19200, 27: 20400, 28: 21600, 29: 22800, 30: 24000,
        31: 25200, 32: 26400, 33: 27600, 34: 28800, 35: 30000,
    },
    304071: {
        1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000,
        11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000,
    },
    404071: {
        1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000,
        11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000,
    },
    414071: {
        1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000,
        11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000,
    },
}

# أبحاث مجموعات الحروب المئوية (technology.lua: buffTypes 73, 77, 95 مقاسة بالألف)
TECH_GROUP_MARCH_PERCENT: Dict[int, Dict[str, Any]] = {
    24319: {"buff_type": 77, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
    24320: {"buff_type": 73, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
    24324: {"buff_type": 95, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
}

# جدول سعة المسيرة للأبطال حسب الندرة والمستوى (hero_level_config.lua: rarity 1..5, level 1..120)
HERO_RARE_LEVEL_MARCH_ADD: Dict[int, Dict[int, int]] = {
    1: {
        1: 500, 2: 550, 3: 600, 4: 650, 5: 700, 6: 750, 7: 800, 8: 850, 9: 900, 10: 950,
        11: 1000, 12: 1060, 13: 1120, 14: 1180, 15: 1240, 16: 1300, 17: 1360, 18: 1420, 19: 1480, 20: 1540,
        21: 1600, 22: 1670, 23: 1730, 24: 1800, 25: 1860, 26: 1930, 27: 1990, 28: 2060, 29: 2120, 30: 2190,
        31: 2250, 32: 2330, 33: 2400, 34: 2480, 35: 2550, 36: 2630, 37: 2700, 38: 2780, 39: 2850, 40: 2930,
        41: 3000, 42: 3100, 43: 3200, 44: 3300, 45: 3400, 46: 3500, 47: 3600, 48: 3700, 49: 3800, 50: 3900,
        51: 4000, 52: 4110, 53: 4220, 54: 4330, 55: 4440, 56: 4550, 57: 4660, 58: 4770, 59: 4880, 60: 5000,
        61: 5000, 62: 5000, 63: 5000, 64: 5000, 65: 5000, 66: 5000, 67: 5000, 68: 5000, 69: 5000, 70: 5000,
        71: 5000, 72: 5000, 73: 5000, 74: 5000, 75: 5000, 76: 5000, 77: 5000, 78: 5000, 79: 5000, 80: 5000,
        81: 5000, 82: 5000, 83: 5000, 84: 5000, 85: 5000, 86: 5000, 87: 5000, 88: 5000, 89: 5000, 90: 5000,
        91: 5000, 92: 5000, 93: 5000, 94: 5000, 95: 5000, 96: 5000, 97: 5000, 98: 5000, 99: 5000, 100: 5000,
        101: 5000, 102: 5000, 103: 5000, 104: 5000, 105: 5000, 106: 5000, 107: 5000, 108: 5000, 109: 5000, 110: 5000,
        111: 5000, 112: 5000, 113: 5000, 114: 5000, 115: 5000, 116: 5000, 117: 5000, 118: 5000, 119: 5000, 120: 5000,
    },
    2: {
        1: 600, 2: 660, 3: 720, 4: 780, 5: 840, 6: 900, 7: 960, 8: 1020, 9: 1080, 10: 1140,
        11: 1200, 12: 1272, 13: 1344, 14: 1416, 15: 1488, 16: 1560, 17: 1632, 18: 1704, 19: 1776, 20: 1848,
        21: 1920, 22: 1998, 23: 2076, 24: 2154, 25: 2232, 26: 2310, 27: 2388, 28: 2466, 29: 2544, 30: 2622,
        31: 2700, 32: 2790, 33: 2880, 34: 2970, 35: 3060, 36: 3150, 37: 3240, 38: 3330, 39: 3420, 40: 3510,
        41: 3600, 42: 3720, 43: 3840, 44: 3960, 45: 4080, 46: 4200, 47: 4320, 48: 4440, 49: 4560, 50: 4680,
        51: 4800, 52: 4932, 53: 5064, 54: 5196, 55: 5328, 56: 5460, 57: 5592, 58: 5724, 59: 5856, 60: 6000,
        61: 6000, 62: 6000, 63: 6000, 64: 6000, 65: 6000, 66: 6000, 67: 6000, 68: 6000, 69: 6000, 70: 6000,
        71: 6000, 72: 6000, 73: 6000, 74: 6000, 75: 6000, 76: 6000, 77: 6000, 78: 6000, 79: 6000, 80: 6000,
        81: 6000, 82: 6000, 83: 6000, 84: 6000, 85: 6000, 86: 6000, 87: 6000, 88: 6000, 89: 6000, 90: 6000,
        91: 6000, 92: 6000, 93: 6000, 94: 6000, 95: 6000, 96: 6000, 97: 6000, 98: 6000, 99: 6000, 100: 6000,
        101: 6000, 102: 6000, 103: 6000, 104: 6000, 105: 6000, 106: 6000, 107: 6000, 108: 6000, 109: 6000, 110: 6000,
        111: 6000, 112: 6000, 113: 6000, 114: 6000, 115: 6000, 116: 6000, 117: 6000, 118: 6000, 119: 6000, 120: 6000,
    },
    3: {
        1: 700, 2: 770, 3: 840, 4: 910, 5: 980, 6: 1050, 7: 1120, 8: 1190, 9: 1260, 10: 1330,
        11: 1400, 12: 1484, 13: 1568, 14: 1652, 15: 1736, 16: 1820, 17: 1904, 18: 1988, 19: 2072, 20: 2156,
        21: 2240, 22: 2331, 23: 2422, 24: 2513, 25: 2604, 26: 2695, 27: 2786, 28: 2877, 29: 2968, 30: 3059,
        31: 3150, 32: 3255, 33: 3360, 34: 3465, 35: 3570, 36: 3675, 37: 3780, 38: 3885, 39: 3990, 40: 4095,
        41: 4200, 42: 4340, 43: 4480, 44: 4620, 45: 4760, 46: 4900, 47: 5040, 48: 5180, 49: 5320, 50: 5460,
        51: 5600, 52: 5754, 53: 5908, 54: 6062, 55: 6216, 56: 6370, 57: 6524, 58: 6678, 59: 6832, 60: 7000,
        61: 7000, 62: 7000, 63: 7000, 64: 7000, 65: 7000, 66: 7000, 67: 7000, 68: 7000, 69: 7000, 70: 7000,
        71: 7000, 72: 7000, 73: 7000, 74: 7000, 75: 7000, 76: 7000, 77: 7000, 78: 7000, 79: 7000, 80: 7000,
        81: 7000, 82: 7000, 83: 7000, 84: 7000, 85: 7000, 86: 7000, 87: 7000, 88: 7000, 89: 7000, 90: 7000,
        91: 7000, 92: 7000, 93: 7000, 94: 7000, 95: 7000, 96: 7000, 97: 7000, 98: 7000, 99: 7000, 100: 7000,
        101: 7000, 102: 7000, 103: 7000, 104: 7000, 105: 7000, 106: 7000, 107: 7000, 108: 7000, 109: 7000, 110: 7000,
        111: 7000, 112: 7000, 113: 7000, 114: 7000, 115: 7000, 116: 7000, 117: 7000, 118: 7000, 119: 7000, 120: 7000,
    },
    4: {
        1: 700, 2: 770, 3: 840, 4: 910, 5: 980, 6: 1050, 7: 1120, 8: 1190, 9: 1260, 10: 1330,
        11: 1400, 12: 1484, 13: 1568, 14: 1652, 15: 1736, 16: 1820, 17: 1904, 18: 1988, 19: 2072, 20: 2156,
        21: 2240, 22: 2331, 23: 2422, 24: 2513, 25: 2604, 26: 2695, 27: 2786, 28: 2877, 29: 2968, 30: 3059,
        31: 3150, 32: 3255, 33: 3360, 34: 3465, 35: 3570, 36: 3675, 37: 3780, 38: 3885, 39: 3990, 40: 4095,
        41: 4200, 42: 4340, 43: 4480, 44: 4620, 45: 4760, 46: 4900, 47: 5040, 48: 5180, 49: 5320, 50: 5460,
        51: 5600, 52: 5754, 53: 5908, 54: 6062, 55: 6216, 56: 6370, 57: 6524, 58: 6678, 59: 6832, 60: 7000,
        61: 7000, 62: 7000, 63: 7000, 64: 7000, 65: 7000, 66: 7000, 67: 7000, 68: 7000, 69: 7000, 70: 7000,
        71: 7000, 72: 7000, 73: 7000, 74: 7000, 75: 7000, 76: 7000, 77: 7000, 78: 7000, 79: 7000, 80: 7000,
        81: 7000, 82: 7000, 83: 7000, 84: 7000, 85: 7000, 86: 7000, 87: 7000, 88: 7000, 89: 7000, 90: 7000,
        91: 7000, 92: 7000, 93: 7000, 94: 7000, 95: 7000, 96: 7000, 97: 7000, 98: 7000, 99: 7000, 100: 7000,
        101: 7000, 102: 7000, 103: 7000, 104: 7000, 105: 7000, 106: 7000, 107: 7000, 108: 7000, 109: 7000, 110: 7000,
        111: 7000, 112: 7000, 113: 7000, 114: 7000, 115: 7000, 116: 7000, 117: 7000, 118: 7000, 119: 7000, 120: 7000,
    },
    5: {
        1: 750, 2: 825, 3: 900, 4: 975, 5: 1050, 6: 1125, 7: 1200, 8: 1275, 9: 1350, 10: 1425,
        11: 1500, 12: 1590, 13: 1680, 14: 1770, 15: 1860, 16: 1950, 17: 2040, 18: 2130, 19: 2220, 20: 2310,
        21: 2400, 22: 2498, 23: 2596, 24: 2694, 25: 2792, 26: 2890, 27: 2988, 28: 3086, 29: 3184, 30: 3282,
        31: 3380, 32: 3492, 33: 3604, 34: 3716, 35: 3828, 36: 3940, 37: 4052, 38: 4164, 39: 4276, 40: 4388,
        41: 4500, 42: 4650, 43: 4800, 44: 4950, 45: 5100, 46: 5250, 47: 5400, 48: 5550, 49: 5700, 50: 5850,
        51: 6000, 52: 6165, 53: 6330, 54: 6495, 55: 6660, 56: 6825, 57: 6990, 58: 7155, 59: 7320, 60: 7500,
        61: 7500, 62: 7500, 63: 7500, 64: 7500, 65: 7500, 66: 7500, 67: 7500, 68: 7500, 69: 7500, 70: 7500,
        71: 7500, 72: 7500, 73: 7500, 74: 7500, 75: 7500, 76: 7500, 77: 7500, 78: 7500, 79: 7500, 80: 7500,
        81: 7500, 82: 7500, 83: 7500, 84: 7500, 85: 7500, 86: 7500, 87: 7500, 88: 7500, 89: 7500, 90: 7500,
        91: 7500, 92: 7500, 93: 7500, 94: 7500, 95: 7500, 96: 7500, 97: 7500, 98: 7500, 99: 7500, 100: 7500,
        101: 7500, 102: 7500, 103: 7500, 104: 7500, 105: 7500, 106: 7500, 107: 7500, 108: 7500, 109: 7500, 110: 7500,
        111: 7500, 112: 7500, 113: 7500, 114: 7500, 115: 7500, 116: 7500, 117: 7500, 118: 7500, 119: 7500, 120: 7500,
    },
}

# الندرة المتأصلة لكل بطل (heroltCtrl.herosInfo[v].rarity)
HERO_RARITY_CATALOG: Dict[int, int] = {
    1700: 1, 1701: 1, 1702: 1, 1703: 1, 1704: 2, 1705: 2, 1706: 2, 1707: 2, 1708: 2, 1709: 2,
    1710: 3, 1711: 3, 1712: 3, 1713: 4, 1714: 3, 1716: 4, 1717: 2, 1718: 2, 1719: 4, 1720: 4,
    1721: 4, 1722: 4, 1723: 4, 1724: 3, 1725: 3, 1726: 4, 1727: 4, 1728: 3, 1729: 4, 1730: 4,
    1731: 4, 1732: 4, 1733: 2, 1734: 4, 1735: 4, 1736: 4, 1737: 4, 1738: 4, 1739: 4, 1740: 4,
    1741: 4, 1742: 4, 1743: 4, 1744: 4, 1745: 4, 1746: 4, 1747: 5, 1748: 5, 1749: 5, 1750: 5,
    1751: 4, 1752: 5, 1753: 5, 1754: 5, 1755: 5, 1756: 5, 1757: 5,
}

# الأسماء العربية الرسمية للأبطال (localtb__local_arab.json)
HERO_ARABIC_NAMES: Dict[int, str] = {
    1700: 'امير الصحراء', 1701: 'قاهرة الاعداء', 1702: 'أمير الشرق', 1703: 'الفاتح',
    1704: 'امير الظلام', 1705: 'البارق', 1706: 'صقر المملكه', 1707: 'المرعب',
    1708: 'اميرة الحرب', 1709: 'الاسطورة', 1710: 'أمير الحرب', 1711: 'الانيق',
    1712: 'الغضنفر', 1713: 'السفاح', 1714: 'الزعيم', 1716: 'أميرة الرماة',
    1717: 'المزيونة', 1718: 'المفترس', 1719: 'المستبدة', 1720: 'الكاسر',
    1721: 'صائد الفرسان', 1722: 'الهمام', 1723: 'الأمير القناص', 1724: 'الضرغام',
    1725: 'اليمامة', 1726: 'جسار', 1727: 'المُهاب', 1728: 'الصارم المقدام',
    1729: 'الباسلة', 1730: 'جساس', 1731: 'الحازم البتار', 1732: 'الإمبراطور',
    1733: 'صخر', 1734: 'العنيد', 1735: 'العنقاء', 1736: 'العاصوف',
    1737: 'الصنديد', 1738: 'الشنفرى', 1739: 'الباشق', 1740: 'الجليلة',
    1741: 'فارس الهيجاء', 1742: 'الملاك الساهرة', 1743: 'أميرة وحيد القرن', 1744: 'المدمّر',
    1745: 'أُسيد', 1746: 'الماجدة', 1747: 'هدير اللهب', 1748: 'السهم الصاعق',
    1749: 'سلطان عاصفة الصحراء', 1750: 'قُصي', 1751: 'زُهير', 1752: 'سليل الصوارم',
    1753: 'شاهين', 1754: 'وقاص', 1755: 'ملكة الغابة', 1756: 'صياد الصحراء',
    1757: 'العاصف الرعدي',
}

# مهارات معركة الأبطال التي تزيد سعة المسيرة بحسب جودة ولون البطل Quality 1..6 (hero_skill_conf.lua)
HERO_MARCH_SKILLS_BY_QUALITY: Dict[int, Dict[int, int]] = {
    171601: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172001: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172101: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172201: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172301: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172601: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172701: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173004: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173104: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173204: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173401: {1: 1500, 2: 3000, 3: 6000, 4: 9000, 5: 15000},
    173501: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173601: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173701: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173801: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173901: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174001: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174101: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174201: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174301: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174401: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174501: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174601: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174701: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    174801: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    174901: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175001: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175101: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    175201: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175301: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175401: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175501: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175601: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175701: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
}

# قيم افتراضية لمهارات معركة الأبطال بحسب أعلى جودة (للتوافق القديم)
HERO_MARCH_SKILLS_VAL: Dict[int, int] = {
    k: max(v.values()) for k, v in HERO_MARCH_SKILLS_BY_QUALITY.items()
}

def get_hero_battle_skill_march_add(skill_type: int, quality: int = 1) -> int:
    """استخراج الزيادة الرسمية لمهارة المعركة بحسب جودة البطل من hero_skill_conf.lua."""
    q_dict = HERO_MARCH_SKILLS_BY_QUALITY.get(skill_type)
    if not q_dict:
        return HERO_MARCH_SKILLS_VAL.get(skill_type, 0)
    if quality in q_dict:
        return q_dict[quality]
    max_q = max(q_dict.keys())
    min_q = min(q_dict.keys())
    if quality >= max_q:
        return q_dict[max_q]
    if quality <= min_q:
        return q_dict[min_q]
    return q_dict.get(min_q, 1000)

# بافات مظاهر الأبطال السلبية (hero_dress_server.lua: getBuff Effect 96)
HERO_DRESS_MARCH_FLAT_BUFFS: Dict[int, int] = {
    171602: 2000, 171902: 1500, 172302: 1500, 173402: 1500, 173602: 1500, 173802: 2000,
    173902: 2000, 174002: 2000, 174102: 2000, 174202: 2000, 174302: 2000, 174402: 2000,
    174502: 2000, 174602: 2000, 174702: 2500, 174802: 2500, 174902: 2500, 175002: 2500,
    175102: 2000, 175202: 2500, 175302: 2500, 175402: 2500, 175502: 2500, 175602: 2500,
    175702: 2500,
}

# بافات المسيرة الرسمية المعروفة (Buff ID -> (EffectType, EffectValue))
KNOWN_MARCH_BUFFS: Dict[int, Tuple[int, int]] = {
    4006: (19, 100), 4506: (19, 100), 4569: (19, 100), 4570: (19, 150),
    5010: (19, 250), 5044: (19, 350), 5055: (19, 500), 5056: (19, 500),
    5076: (736, 100), 5077: (736, 200), 5091: (19, 200), 5120: (19, 250),
    5302: (19, 200), 5305: (19, 150), 5333: (19, 80), 5496: (19, 150),
    5499: (19, 80), 5797: (96, 20000), 5921: (96, 5000000),
}

# مستويات وسام القائد 'توحيد القوة' (9003017 - مقاسة بالألف)
ACHIEVEMENT_MARCH_TIERS: Dict[int, int] = {
    5317002: 10, 5317003: 10, 5317004: 20, 5317005: 30, 5317006: 40,
    5317007: 50, 5317008: 60, 5317009: 70, 5317010: 80, 5317011: 90,
    5317012: 100, 5317013: 110, 5317014: 120, 5317015: 140,
}

# جدول امتياز الـ VIP / SVIP لسعة المسيرة (vipbuff.lua: Privilege 7219 مقاسة بالألف)
VIP_MARCH_LIMIT_TABLE: Dict[int, int] = {
    14: 100, 15: 150, 16: 150, 17: 150, 18: 150, 19: 150, 20: 200,
    21: 200, 22: 200, 23: 200, 24: 200, 25: 250, 26: 250, 27: 250,
}

# ══════════════════════════════════════════════════════════════════════════════
# جداول المصادر الدائمة الإضافية لـ buffCtrl (Effect 96) و attributeSystem (Attr 5)
# مستخرجة بدقة 100% من march_capacity_extra_sources.json (سورس اللعبة الرسمي)
# ══════════════════════════════════════════════════════════════════════════════

# 1. أحجار الحرب (warGemCtrl - Effect 96)
WAR_GEM_MARCH_BOOST: Dict[int, int] = {
    12060101: 500, 12060102: 750, 12060103: 1250, 12060104: 1750, 12060105: 2500,
    12060106: 3750, 12060107: 5000, 12060108: 6750, 12060109: 8750, 12060110: 12500,
}

# 2. سيرة الأبطال (heroBiographyCtrl.activeSkillList - Effect 96)
HERO_BIOGRAPHY_MARCH_BOOST: Dict[int, int] = {
    30102: 500, 30202: 1200,
    50102: 500, 50202: 1200,
    80102: 500, 80202: 1200,
}

# 3. مهارات إتقان الأبطال السلبية (heroSysCtrl.heroList - Effect 96)
HERO_MASTERY_MARCH_BOOST: Dict[int, int] = {
    17190701: 1200, 17190702: 1350, 17190703: 1575, 17190704: 1950, 17190705: 2475,
    17190706: 3150, 17190707: 3975, 17190708: 4875, 17190709: 5850, 17190710: 7200,
}

# 4. مهارات الوحوش الإلهية السلبية (divineBeastCtrl - Effect 96)
DIVINE_BEAST_PASSIVE_SKILL_MARCH_BOOST: Dict[int, int] = {
    100201: 4000, 100202: 8000, 100203: 14000, 100204: 20000,
}

# 5. مظاهر القلعة والأطر ومسيرات الجيش (dressCtrl -> attributeSystem Attr 5 / attrID 3)
CASTLE_DRESS_MARCH_BOOST: Dict[int, int] = {
    344: 1000,  # King March Queue Skin
    375: 5000,  # King Star Battle Headframe
    388: 1500,  # Special Castle Skin 388
    422: 1500,  # Special Castle Skin 422
    550: 1500,  # Special Castle Skin 550
    551: 1500,  # Special Castle Skin 551
    553: 1000,  # Special March Skin 553
}

# 6. رنين السلاح الإعجازي (miraculousWeaponCtrl - Resonance 7 >= 2,615,000 -> +24,000)
MIRACULOUS_WEAPON_RESONANCE_7_POWER = 2615000
MIRACULOUS_WEAPON_RESONANCE_7_BOOST = 24000

# خصائص رونات العتاد الإلهي (rune_property_config.lua: Attribute[1]=96)
RUNE_MARCH_PROPERTY_BASE: Dict[int, int] = {
    11103: 60, 11203: 100, 11303: 150, 11403: 200, 11503: 300, 12203: 130, 12303: 195, 12403: 260,
    12503: 390, 21103: 60, 21203: 100, 21303: 150, 21403: 200, 21503: 300, 31103: 60, 31203: 100,
    31303: 150, 31403: 200, 31503: 300, 41102: 60, 41202: 100, 41302: 150, 41402: 200, 41502: 300,
}


def _safe_int(val: Any, default: int = 0) -> int:
    try:
        if val is None or isinstance(val, bool):
            return default
        return int(float(val))
    except Exception:
        return default


def _load_master_tables() -> Dict[str, Any]:
    """تحميل الجداول من ملف tools/master_march_tables.json إن وُجد مع الاعتماد على الجداول المدمجة كمرجع مضمون."""
    for path in (
        MASTER_TABLES_PATH,
        os.path.join(ROOT_DIR, "tools", "march_data_tables.json"),
        os.path.join(ROOT_DIR, "tools", "tables_min.json"),
    ):
        if os.path.exists(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    if isinstance(data, dict):
                        return data
            except Exception as e:
                log.warning(f"Failed to read {path}: {e}")
    return {}


_TABLES_CACHE: Optional[Dict[str, Any]] = None


def get_tables() -> Dict[str, Any]:
    global _TABLES_CACHE
    if _TABLES_CACHE is None:
        _TABLES_CACHE = _load_master_tables()
    return _TABLES_CACHE


def get_castle_level(init_data: dict) -> int:
    """قراءة مستوى القلعة الفعلي من cityCtrl.blist (bid=101) ثم البدائل الاحتياطية."""
    if not isinstance(init_data, dict):
        return 1
    city = init_data.get("cityCtrl")
    if isinstance(city, dict):
        blist = city.get("blist", [])
        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
                if str(binfo.get("bid", "")) == str(CASTLE_BUILDING_ID):
                    lv = _safe_int(binfo.get("lv"), 0)
                    if lv > 0:
                        return lv
        if "level" in city:
            lv = _safe_int(city.get("level"), 0)
            if lv > 0:
                return lv
    lord_base = (init_data.get("lordInfoCtrl") or {}).get("base", {})
    return max(1, _safe_int(lord_base.get("level"), 1))


def get_max_battle_hero_num(init_data: dict) -> int:
    """عدد خانات الأبطال المفتوحة حسب مستوى القلعة (1, 5, 10, 15, 18 -> 1..5 خانات)."""
    castle_lv = get_castle_level(init_data)
    return sum(1 for req in (1, 5, 10, 15, 18) if castle_lv >= req)


# ══════════════════════════════════════════════════════════════════════════════
# 2. دوال استخراج مكونات سعة القلعة بدون أبطال (0-Network Direct Read)
# ══════════════════════════════════════════════════════════════════════════════

def get_drill_grounds_base_capacity(init_data: dict) -> Dict[str, Any]:
    """
    استخراج السعة الأساسية لمبنى ساحة العرض (bid=121) ومستوى نجوم قصر المجد (starLv).
    مطابق لـ buildLogic.getBuildBaseValue(BUILDID.DRILL_GROUDS, "capacity", bcell).
    """
    tables = get_tables()
    drill_levels = dict(DRILL_GROUNDS_CAPACITY)
    for k, v in (tables.get("drill_levels") or {}).items():
        drill_levels[_safe_int(k)] = _safe_int(v)

    drill_stars = dict(DRILL_GROUNDS_STAR_CAPACITY)
    for k, v in (tables.get("drill_stars") or {}).items():
        drill_stars[_safe_int(k)] = _safe_int(v)

    dlv = 0
    star_lv = 0
    found = False
    city_ctrl = init_data.get("cityCtrl") if isinstance(init_data, dict) else {}
    blist = city_ctrl.get("blist", []) if isinstance(city_ctrl, dict) else []

    if isinstance(blist, list):
        for b in blist:
            if not isinstance(b, dict):
                continue
            binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
            if isinstance(binfo, dict) and str(binfo.get("bid", "")) == str(DRILL_GROUNDS_BUILDING_ID):
                dlv = max(dlv, _safe_int(binfo.get("lv"), 0))
                # الحقل الرسمي في الذاكرة الحية هو starLv (مع دعم star كاحتياط)
                star_val = binfo.get("starLv") if binfo.get("starLv") is not None else binfo.get("star", 0)
                star_lv = max(star_lv, _safe_int(star_val, 0))
                found = True

    base_from_lv = drill_levels.get(dlv, 0) if dlv > 0 else 0
    base_from_star = drill_stars.get(star_lv, 0) if star_lv > 0 else 0
    total_base = base_from_lv + base_from_star

    return {
        "level": dlv,
        "star_level": star_lv,
        "base_from_level": base_from_lv,
        "base_from_star": base_from_star,
        "total_base_capacity": total_base,
        "found": found,
    }


def get_castle_available_troops(init_data: dict) -> Dict[str, Any]:
    """
    استخراج عدد القوات المتوفرة بالقلعة والمصابة بالمستشفى (0-Network Direct Read).
    armyCtrl.totalArmy: القوات الحرة الجاهزة للقتال والمسيرات.
    armyCtrl.woundedArmy: القوات المصابة في المستشفى.
    """
    army_ctrl = init_data.get("armyCtrl", {}) if isinstance(init_data, dict) else {}
    total_army = army_ctrl.get("totalArmy", {}) if isinstance(army_ctrl, dict) else {}
    wounded_army = army_ctrl.get("woundedArmy", {}) if isinstance(army_ctrl, dict) else {}

    free_count = 0
    free_details: Dict[str, int] = {}
    if isinstance(total_army, dict):
        for aid, adata in total_army.items():
            cnt = _safe_int(adata if not isinstance(adata, dict) else adata.get("free", adata.get("count", 0)))
            if cnt > 0:
                free_count += cnt
                free_details[str(aid)] = cnt

    wounded_count = 0
    wounded_details: Dict[str, int] = {}
    if isinstance(wounded_army, dict):
        for aid, adata in wounded_army.items():
            cnt = _safe_int(adata if not isinstance(adata, dict) else adata.get("count", 0))
            if cnt > 0:
                wounded_count += cnt
                wounded_details[str(aid)] = cnt

    return {
        "free_troops_total": free_count,
        "free_troops_breakdown": free_details,
        "wounded_troops_total": wounded_count,
        "wounded_troops_breakdown": wounded_details,
    }


def get_technology_march_additions(init_data: dict) -> Dict[str, Any]:
    """
    استخراج إضافات جميع أبحاث القيادة الفردية (Buff Type 43) وأبحاث مجموعات الحروب (73, 77, 95).
    مطابق لـ technologyCtrl:getTechnologyPower() وجدول technology.lua الكامل.
    """
    tech_flat = 0
    tech_group_multiplier = 0.0
    details: List[Dict[str, Any]] = []
    group_details: List[Dict[str, Any]] = []

    tables = get_tables()
    tech_tables = tables.get("techs", {})

    tctrl = init_data.get("technologyCtrl", {}) if isinstance(init_data, dict) else {}
    if isinstance(tctrl, dict):
        for tid_key, tval in tctrl.items():
            if isinstance(tval, (list, tuple)) and len(tval) >= 2:
                tid = _safe_int(tval[0])
                tlv = _safe_int(tval[1])
            elif isinstance(tval, (int, float, str)):
                tid = _safe_int(tid_key)
                tlv = _safe_int(tval)
            else:
                continue

            if tid <= 0 or tlv <= 0:
                continue

            if tid in LEADERSHIP_TECH_ADDITIONS:
                val = LEADERSHIP_TECH_ADDITIONS[tid].get(tlv, 0)
                if val > 0:
                    tech_flat += val
                    details.append({"tech_id": tid, "level": tlv, "buff_type": 43, "power": val})
                continue

            if tid in TECH_GROUP_MARCH_PERCENT:
                tg = TECH_GROUP_MARCH_PERCENT[tid]
                pw = tg["levels"].get(tlv, 0)
                if pw > 0:
                    pct = pw / 1000.0
                    tech_group_multiplier += pct
                    group_details.append({
                        "tech_id": tid,
                        "level": tlv,
                        "buff_type": tg["buff_type"],
                        "multiplier": pct,
                    })
                continue

            # احتياط من الجدول الخارجي إن وُجدت أبحاث أحدث
            lv_info = (tech_tables.get(str(tid)) or {}).get(str(tlv))
            if isinstance(lv_info, dict):
                bt = _safe_int(lv_info.get("buff_type"))
                pw = _safe_int(lv_info.get("power"))
                bnt = _safe_int(lv_info.get("buff_num_type"), 1)
                if bt == 43 and pw > 0:
                    val = int(pw / (1 if bnt == 2 else 1000))
                    tech_flat += val
                    details.append({"tech_id": tid, "level": tlv, "buff_type": 43, "power": val})
                elif bt in (73, 77, 95) and pw > 0:
                    pct = pw / 1000.0
                    tech_group_multiplier += pct
                    group_details.append({"tech_id": tid, "level": tlv, "buff_type": bt, "multiplier": pct})

    return {
        "total_tech_add": tech_flat,
        "tech_group_multiplier": tech_group_multiplier,
        "details": details,
        "tech_group_details": group_details,
    }


def get_hero_dress_passive_march_buff(init_data: dict) -> Dict[str, Any]:
    """
    استخراج بافات سعة المسيرة السلبية من مظاهر الأبطال المملوكة (Effect 96).
    مطابق لـ heroCtrl:getAllActiveBuff() و hero_dress_server.lua:
      - يقرأ من heroInfo["dress"]["list"] (مع دعم dressList كاحتياط).
      - يستبعد الأبطال الأموات (state == 2) والمأسورين (state == 3).
    """
    tables = get_tables()
    dress_buffs = dict(HERO_DRESS_MARCH_FLAT_BUFFS)
    for k, v in (tables.get("hero_dress_march_buffs") or {}).items():
        dress_buffs[_safe_int(k)] = _safe_int(v)

    dress_flat = 0
    active_dresses: List[Dict[str, Any]] = []

    hero_sys = init_data.get("heroSysCtrl", {}) if isinstance(init_data, dict) else {}
    hlist = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
    if isinstance(hlist, dict):
        for hkey, h in hlist.items():
            if not isinstance(h, dict):
                continue
            state = _safe_int(h.get("state"), G_HERO_STATE_NORMAL)
            if state in (G_HERO_STATE_DEAD, G_HERO_STATE_CAPTURED):
                continue

            hid = _safe_int(h.get("heroID"), _safe_int(hkey, 0))
            dress_obj = h.get("dress")
            raw_list = None
            if isinstance(dress_obj, dict) and dress_obj.get("list"):
                raw_list = dress_obj.get("list")
            elif h.get("dressList"):
                raw_list = h.get("dressList")

            if not raw_list:
                continue

            items = raw_list.keys() if isinstance(raw_list, dict) else (raw_list if isinstance(raw_list, list) else [])
            for item in items:
                did = _safe_int(item.get("id") if isinstance(item, dict) else item, 0)
                if did in dress_buffs:
                    val = dress_buffs[did]
                    dress_flat += val
                    active_dresses.append({"hero_id": hid, "dress_id": did, "buff_val": val})

    return {
        "total_dress_add": dress_flat,
        "dresses": active_dresses,
    }


def get_active_march_buffs(
    init_data: dict,
    is_mass: bool = False,
    move_line_type: Optional[int] = None,
    now_ts: Optional[int] = None,
) -> Dict[str, Any]:
    """
    فحص بافات المسيرة النشطة السارية زمنياً من buffCtrl:
      - يتحقق من انتهاء الصلاحية: beginTime + time >= now_ts.
      - يجمع البافات المئوية (Effect 19) والرقمية (Effect 96) وبافات الحشد (736/737).
      - يدعم virtualBuff.marchMaxCount إن وُجد.
    """
    now = int(time.time()) if now_ts is None else int(now_ts)
    is_mass_march = bool(is_mass or (move_line_type in MASS_MOVE_LINE_TYPES))

    tables = get_tables()
    item_buffs_extra = {_safe_int(k): _safe_int(v) for k, v in (tables.get("active_item_buffs") or {}).items()}

    buff_flat = 0
    buff_permille = 0
    virtual_override: Optional[int] = None
    details: List[Dict[str, Any]] = []

    buff_ctrl = init_data.get("buffCtrl") if isinstance(init_data, dict) else []
    if isinstance(buff_ctrl, dict):
        vb = buff_ctrl.get("virtualBuff")
        if isinstance(vb, dict) and vb.get("marchMaxCount") is not None:
            v_cap = _safe_int(vb.get("marchMaxCount"), 0)
            if v_cap > 0:
                virtual_override = v_cap
        b_items = [v for v in buff_ctrl.values() if isinstance(v, dict)]
    elif isinstance(buff_ctrl, list):
        b_items = [v for v in buff_ctrl if isinstance(v, dict)]
    else:
        b_items = []

    for b in b_items:
        bt_start = _safe_int(b.get("beginTime"), 0)
        dur = _safe_int(b.get("time"), 0)
        if dur > 0 and (bt_start + dur) < now:
            continue

        remaining = max(0, (bt_start + dur) - now) if dur > 0 else -1
        bid = _safe_int(b.get("id") or b.get("buffID"), 0)
        et = _safe_int(b.get("effectType"), 0)
        val = _safe_int(b.get("val") or b.get("effect"), 0)

        if et == 0:
            if bid in KNOWN_MARCH_BUFFS:
                et, val = KNOWN_MARCH_BUFFS[bid]
            elif bid in item_buffs_extra:
                et, val = 19, item_buffs_extra[bid]

        if et == 19 and val > 0:
            buff_permille += val
            details.append({"buff_id": bid, "effect_type": 19, "permille": val, "remaining_sec": remaining})
        elif et == 96 and val > 0:
            buff_flat += val
            details.append({"buff_id": bid, "effect_type": 96, "flat": val, "remaining_sec": remaining})
        elif is_mass_march and et == 736 and val > 0:
            buff_permille += val
            details.append({"buff_id": bid, "effect_type": 736, "permille": val, "remaining_sec": remaining})
        elif is_mass_march and et == 737 and val > 0:
            buff_flat += val
            details.append({"buff_id": bid, "effect_type": 737, "flat": val, "remaining_sec": remaining})

    return {
        "buff_flat_val": buff_flat,
        "buff_percent_permille": buff_permille,
        "buff_percent_add": buff_permille / 1000.0,
        "is_mass_march": is_mass_march,
        "virtual_buff_override": virtual_override,
        "details": details,
    }


def get_achievement_march_buff(init_data: dict) -> Dict[str, Any]:
    """
    استخراج نسبة وسام القائد 'توحيد القوة' (وسام 9003017 - البند 17 من achievementctrl).
    يعطي من 1% (+10 بالألف) حتى 14% (+140 بالألف).
    """
    tables = get_tables()
    achieve_tiers = dict(ACHIEVEMENT_MARCH_TIERS)
    for k, v in (tables.get("achievement_march_tiers") or {}).items():
        achieve_tiers[_safe_int(k)] = _safe_int(v)

    achieve_permille = 0
    max_done_id = 0

    ach_ctrl = init_data.get("achievementctrl", {}) if isinstance(init_data, dict) else {}
    if isinstance(ach_ctrl, dict):
        ach_list = ach_ctrl.get("list", {})
        if isinstance(ach_list, dict):
            m17 = ach_list.get("17") or ach_list.get(17)
            if isinstance(m17, dict):
                max_done_id = _safe_int(m17.get("maxDoneID"), 0)
                achieve_permille = achieve_tiers.get(max_done_id, 0)

    return {
        "max_done_id": max_done_id,
        "permille": achieve_permille,
        "percent": achieve_permille / 10.0,
        "multiplier": achieve_permille / 1000.0,
    }


def get_vip_march_buff(init_data: dict, now_ts: Optional[int] = None) -> Dict[str, Any]:
    """
    استخراج باف امتياز كبار الشخصيات VIP / SVIP لسعة المسيرة (Privilege 7219 من vipbuff.lua).
    يشترط سريان مفعول الـ VIP زمنياً (vipEndTime > now_ts).
    """
    now = time.time() if now_ts is None else float(now_ts)
    tables = get_tables()
    vip_table = dict(VIP_MARCH_LIMIT_TABLE)
    for k, v in (tables.get("vip_march_limit_table") or {}).items():
        vip_table[_safe_int(k)] = _safe_int(v)

    v_lv = 0
    vip_end = 0.0

    if isinstance(init_data, dict):
        lord_ctrl = init_data.get("lordInfoCtrl") or {}
        vip_info = lord_ctrl.get("vip") if isinstance(lord_ctrl, dict) else None
        if not isinstance(vip_info, dict) or not vip_info:
            vip_info = init_data.get("vipCtrl") if isinstance(init_data.get("vipCtrl"), dict) else {}

        if isinstance(vip_info, dict):
            v_lv = _safe_int(vip_info.get("vipLev") or vip_info.get("vipLv") or vip_info.get("level"), 0)
            try:
                vip_end = float(vip_info.get("vipEndTime") or vip_info.get("endTime") or 0)
            except Exception:
                vip_end = 0.0

    is_active = bool(vip_end > now)
    vip_permille = 0
    if is_active and v_lv >= 14:
        vip_permille = vip_table.get(v_lv, 250 if v_lv > 27 else 0)

    return {
        "vip_level": v_lv,
        "is_vip_active": is_active,
        "vip_end_time": vip_end,
        "permille": vip_permille,
        "percent": vip_permille / 10.0,
        "multiplier": vip_permille / 1000.0,
    }


def get_extra_permanent_march_buffs(init_data: dict) -> Dict[str, Any]:
    """
    قراءة كافة المصادر الدائمة الإضافية لـ buffCtrl (Effect 96) و attributeSystem (Attr 5)
    من الذاكرة الحية مباشرة (0-Network) وفق march_capacity_extra_sources.json:
      1. أحجار الحرب (warGemCtrl.gemData.panel[actPanelId-1])
      2. مستوى المملكة (playerKingdomLevelCtrl: Lv.18..35 -> +3,000 | Lv.36+ -> +6,000)
      3. برج السديم (nebulaTowerCtrl: +20,000 لكل مرحلة امتياز مفتوحة)
      4. سيرة الأبطال (heroBiographyCtrl.activeSkillList: 30102..80202)
      5. المعدات العسكرية المجهزة (equipmentCtrl.equipment_array: wear==1, prop 78)
      6. مواهب الحيوانات الأليفة (petCtrl: المهارات البادئة بـ 1802 -> Attr 18)
      7. مهارات إتقان الأبطال السلبية (heroSysCtrl: 17190701..17190710)
      8. مهارات الوحوش الإلهية السلبية (divineBeastCtrl.buffDatas[96] / 100201..100204)
      9. رنين السلاح الإعجازي (miraculousWeaponCtrl: resonanceBuff[96] أو قوة >= 2,615,000)
      10. مظاهر القلعة والأطر (dressCtrl.list -> Attr 5 / DISPATCH_TROOP_COUNT_NUM)
    """
    if not isinstance(init_data, dict):
        return {"total_extra_flat": 0, "attr_system_add": 0, "sources": {}}

    # 1. أحجار الحرب (warGemCtrl)
    war_gem_add = 0
    wg = init_data.get("warGemCtrl")
    if isinstance(wg, dict):
        gdata = wg.get("gemData") if isinstance(wg.get("gemData"), dict) else wg
        panels = gdata.get("panel")
        act_id = max(1, _safe_int(gdata.get("actPanelId"), 1))
        if isinstance(panels, list) and len(panels) >= act_id:
            active_panel = panels[act_id - 1]
            if isinstance(active_panel, dict):
                for slots in active_panel.values():
                    if isinstance(slots, list):
                        for gid in slots:
                            war_gem_add += WAR_GEM_MARCH_BOOST.get(_safe_int(gid, 0), 0)

    # 2. مستوى المملكة (playerKingdomLevelCtrl)
    kingdom_lv_add = 0
    pkl = init_data.get("playerKingdomLevelCtrl")
    if isinstance(pkl, dict) and pkl.get("isUnlock", True):
        klv = _safe_int(pkl.get("level"), 0)
        if klv >= 36:
            kingdom_lv_add = 6000
        elif klv >= 18:
            kingdom_lv_add = 3000

    # 3. برج السديم (nebulaTowerCtrl)
    nebula_tower_add = 0
    nt = init_data.get("nebulaTowerCtrl")
    if isinstance(nt, dict) and not nt.get("isLock", False):
        nt_lv = _safe_int(nt.get("level") or nt.get("curFloor"), 0)
        if nt_lv >= 63:
            nebula_tower_add = 60000
        elif nt_lv >= 32:
            nebula_tower_add = 40000
        elif nt_lv >= 1:
            nebula_tower_add = 20000

    # 4. سيرة الأبطال (heroBiographyCtrl)
    hero_bio_add = 0
    hb = init_data.get("heroBiographyCtrl")
    if isinstance(hb, dict):
        act_skills = hb.get("activeSkillList") or {}
        if isinstance(act_skills, dict):
            for sid_str in act_skills.keys():
                hero_bio_add += HERO_BIOGRAPHY_MARCH_BOOST.get(_safe_int(sid_str, 0), 0)
        elif isinstance(act_skills, list):
            for sid in act_skills:
                hero_bio_add += HERO_BIOGRAPHY_MARCH_BOOST.get(_safe_int(sid, 0), 0)

    # 5. المعدات العسكرية (equipmentCtrl - wear == 1, Property 78)
    equipment_add = 0
    eq_ctrl = init_data.get("equipmentCtrl")
    if isinstance(eq_ctrl, dict):
        eq_arr = eq_ctrl.get("equipment_array") or []
        if isinstance(eq_arr, list):
            for eq in eq_arr:
                if not isinstance(eq, dict) or _safe_int(eq.get("wear"), 0) != 1:
                    continue
                extras = eq.get("extra") or []
                if isinstance(extras, list):
                    for prop in extras:
                        if isinstance(prop, (list, tuple)) and len(prop) >= 2:
                            if _safe_int(prop[0], 0) == 78:
                                equipment_add += _safe_int(prop[1], 0)
                        elif isinstance(prop, dict):
                            if _safe_int(prop.get("type") or prop.get("propertyType"), 0) == 78:
                                equipment_add += _safe_int(prop.get("val") or prop.get("value"), 0)

    # 6. مواهب الحيوانات الأليفة (petCtrl - Attr 18 / skillID 1802XXXXXX)
    pet_add = 0
    pet_ctrl = init_data.get("petCtrl")
    if isinstance(pet_ctrl, dict):
        pet_talents = pet_ctrl.get("petTalentData") or {}
        if isinstance(pet_talents, dict):
            for t_info in pet_talents.values():
                if isinstance(t_info, dict) and t_info.get("active", True):
                    if _safe_int(t_info.get("attrType"), 0) == 18:
                        pet_add += _safe_int(t_info.get("value"), 0)
        pet_list = pet_ctrl.get("petList") or {}
        if isinstance(pet_list, dict):
            for p_info in pet_list.values():
                if not isinstance(p_info, dict):
                    continue
                for sk_key in ("talentSkills", "skillList", "skills"):
                    sks = p_info.get(sk_key)
                    if isinstance(sks, (list, dict)):
                        vals = sks.values() if isinstance(sks, dict) else sks
                        for sk in vals:
                            sk_id = _safe_int(sk.get("id") or sk.get("skillID") if isinstance(sk, dict) else sk, 0)
                            if 1802000000 <= sk_id <= 1802999999:
                                pet_add += sk_id % 1000000

    # 7. مهارات إتقان الأبطال السلبية (heroSysCtrl - 17190701..17190710)
    hero_mastery_add = 0
    hero_sys = init_data.get("heroSysCtrl") or {}
    hlist = hero_sys.get("heroList") if isinstance(hero_sys, dict) else {}
    if isinstance(hlist, dict):
        for h in hlist.values():
            if not isinstance(h, dict):
                continue
            if _safe_int(h.get("state"), G_HERO_STATE_NORMAL) in (G_HERO_STATE_DEAD, G_HERO_STATE_CAPTURED):
                continue
            for m_key in ("masterySkill", "advancedSkill"):
                ms = h.get(m_key)
                if isinstance(ms, dict):
                    if "skillID" in ms:
                        hero_mastery_add += HERO_MASTERY_MARCH_BOOST.get(_safe_int(ms.get("skillID"), 0), 0)
                    for k_ms, v_ms in ms.items():
                        sid = _safe_int(v_ms.get("skillID") if isinstance(v_ms, dict) else k_ms, 0)
                        hero_mastery_add += HERO_MASTERY_MARCH_BOOST.get(sid, 0)

    # 8. مهارات الوحوش الإلهية السلبية (divineBeastCtrl)
    divine_passive_add = 0
    db_ctrl = init_data.get("divineBeastCtrl")
    if isinstance(db_ctrl, dict):
        bdatas = db_ctrl.get("buffDatas")
        if isinstance(bdatas, dict):
            divine_passive_add += _safe_int(bdatas.get(96) or bdatas.get("96"), 0)

    # 9. السلاح الإعجازي (miraculousWeaponCtrl)
    miraculous_add = 0
    mw_ctrl = init_data.get("miraculousWeaponCtrl")
    if isinstance(mw_ctrl, dict):
        uinfo = mw_ctrl.get("userInfo") or {}
        if isinstance(uinfo, dict):
            rbuffs = uinfo.get("resonanceBuff") or {}
            rb_iter = rbuffs.values() if isinstance(rbuffs, dict) else (rbuffs if isinstance(rbuffs, list) else [])
            for rb in rb_iter:
                if isinstance(rb, dict) and _safe_int(rb.get("buffType"), 0) == 96:
                    miraculous_add += _safe_int(rb.get("value"), 0)
            if miraculous_add == 0 and _safe_int(uinfo.get("maxWeaponPower"), 0) >= MIRACULOUS_WEAPON_RESONANCE_7_POWER:
                miraculous_add += MIRACULOUS_WEAPON_RESONANCE_7_BOOST

    # 10. مظاهر القلعة والأطر (dressCtrl -> attributeSystem Attr 5)
    castle_dress_add = 0
    dress_ctrl = init_data.get("dressCtrl")
    if isinstance(dress_ctrl, dict):
        dlist = dress_ctrl.get("list") or {}
        if isinstance(dlist, dict):
            for d_key, d_val in dlist.items():
                if isinstance(d_val, dict):
                    stop_t = _safe_int(d_val.get("stopTime"), 0)
                    if stop_t > 0 and stop_t < int(time.time()):
                        continue
                    sub_t = _safe_int(d_val.get("subType") or d_val.get("dressID") or d_key, 0)
                else:
                    sub_t = _safe_int(d_key, 0)
                if sub_t in CASTLE_DRESS_MARCH_BOOST:
                    castle_dress_add += CASTLE_DRESS_MARCH_BOOST[sub_t]

    buff_96_extra = (
        war_gem_add
        + kingdom_lv_add
        + nebula_tower_add
        + hero_bio_add
        + equipment_add
        + pet_add
        + hero_mastery_add
        + divine_passive_add
        + miraculous_add
    )
    total_extra = buff_96_extra + castle_dress_add

    return {
        "total_extra_flat": total_extra,
        "buff_96_extra_flat": buff_96_extra,
        "attr_system_add": castle_dress_add,
        "sources": {
            "war_gems": war_gem_add,
            "kingdom_level": kingdom_lv_add,
            "nebula_tower": nebula_tower_add,
            "hero_biography": hero_bio_add,
            "equipment": equipment_add,
            "pets": pet_add,
            "hero_mastery": hero_mastery_add,
            "divine_beast_passive": divine_passive_add,
            "miraculous_weapon": miraculous_add,
            "castle_dress_attr5": castle_dress_add,
        },
    }


def get_castle_march_capacity_without_heroes(
    init_data: dict,
    move_line_type: Optional[int] = None,
    extra_flat_add: int = 0,
    extra_percent_permille: int = 0,
) -> Dict[str, Any]:
    """
    المعادلة الرياضية الرسمية لسعة مسيرة القلعة بدون أبطال (buildLogic.getExpArmyCount):
      total_flat_add = 1000 + tech_flat + dress_flat + buff_flat + extra_flat_add
      effective_base = base_drill + total_flat_add
      total_mult     = achieve_mult + vip_mult + item_mult + tech_group_mult + (extra_percent_permille / 1000)
      total_capacity = effective_base + math.floor(effective_base * total_mult)
      unchangesize   = math.floor(effective_base * (1.0 + achieve_mult + tech_group_mult))
    """
    drill_data = get_drill_grounds_base_capacity(init_data)
    base_cap = drill_data["total_base_capacity"]

    tech_data = get_technology_march_additions(init_data)
    tech_flat = tech_data["total_tech_add"]
    tech_group_mult = tech_data["tech_group_multiplier"]

    dress_data = get_hero_dress_passive_march_buff(init_data)
    dress_flat = dress_data["total_dress_add"]

    buff_data = get_active_march_buffs(init_data, move_line_type=move_line_type)
    buff_flat = buff_data["buff_flat_val"]
    item_mult = buff_data["buff_percent_add"]
    virtual_override = buff_data["virtual_buff_override"]

    achieve_data = get_achievement_march_buff(init_data)
    achieve_mult = achieve_data["multiplier"]

    vip_data = get_vip_march_buff(init_data)
    vip_mult = vip_data["multiplier"]

    extra_perm = get_extra_permanent_march_buffs(init_data)
    extra_perm_flat = extra_perm["total_extra_flat"]

    total_flat_add = DEFAULT_EXP_ARMY_COUNT + tech_flat + dress_flat + buff_flat + extra_perm_flat + int(extra_flat_add)
    effective_base = base_cap + total_flat_add

    # مطابق لـ buildLogic.lua:2057: unchangesize يشمل achieveadd + techGroupAdd فقط
    unchanged_mult = achieve_mult + tech_group_mult
    total_mult = unchanged_mult + vip_mult + item_mult + (extra_percent_permille / 1000.0)

    percent_troop_add = math.floor(effective_base * total_mult)
    total_capacity = effective_base + percent_troop_add
    unchangesize = math.floor(effective_base * (1.0 + unchanged_mult))

    if virtual_override is not None and virtual_override > 0:
        total_capacity = virtual_override

    return {
        "total_capacity": total_capacity,
        "unchangesize": unchangesize,
        "is_buffed": total_capacity > unchangesize,
        "virtual_buff_override": virtual_override,
        "effective_base": effective_base,
        "base_drill_grounds": base_cap,
        "drill_level": drill_data["level"],
        "drill_star": drill_data["star_level"],
        "default_game_constant": DEFAULT_EXP_ARMY_COUNT,
        "tech_flat_add": tech_flat,
        "tech_group_percent": tech_group_mult * 100.0,
        "hero_dress_flat_add": dress_flat,
        "buff_flat_add": buff_flat,
        "extra_flat_add": extra_perm_flat + int(extra_flat_add),
        "extra_permanent_sources": extra_perm["sources"],
        "total_flat_add": total_flat_add,
        "achievement_percent": achieve_data["percent"],
        "vip_level": vip_data["vip_level"],
        "is_vip_active": vip_data["is_vip_active"],
        "vip_percent": vip_data["percent"],
        "item_buff_percent": buff_data["buff_percent_permille"] / 10.0,
        "total_percent_multiplier": total_mult,
        "percent_troop_add": percent_troop_add,
    }


# ══════════════════════════════════════════════════════════════════════════════
# 3. دوال حساب سعة الأبطال والـ Runes والوحوش الإلهية (Dispatch Additions)
# ══════════════════════════════════════════════════════════════════════════════

def get_all_castle_heroes(init_data: dict) -> List[Dict[str, Any]]:
    """
    استخراج وتقييم كافة الأبطال المملوكين للقلعة من heroSysCtrl.heroList.
    مطابق لـ heroltCtrl:getHerosMarchCapacity():
      - يستخدم الندرة المتأصلة (rarity 1..5) مع مستوى البطل في hero_level_config.lua.
      - يضيف مهارات المعركة النشطة (skillType in HERO_MARCH_SKILLS_VAL -> +480 جندي).
      - لا يكرر باف المظاهر السلبية لأنه محسوب مسبقاً في سعة القلعة.
    """
    tables = get_tables()
    rare_levels = tables.get("rare_levels") or HERO_RARE_LEVEL_MARCH_ADD
    hero_catalog = tables.get("heroes") or {}
    extra_skills = tables.get("hero_battle_march_skills") or {}

    hero_sys = init_data.get("heroSysCtrl", {}) if isinstance(init_data, dict) else {}
    hlist = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
    if not isinstance(hlist, dict):
        return []

    evaluated: List[Dict[str, Any]] = []
    for hid_str, h in hlist.items():
        if not isinstance(h, dict):
            continue
        hid = _safe_int(h.get("heroID") or h.get("id") or hid_str, 0)
        if hid <= 0:
            continue

        state = _safe_int(h.get("state"), G_HERO_STATE_NORMAL)
        level = min(120, max(1, _safe_int(h.get("level"), 1)))
        quality = _safe_int(h.get("quality"), 1)

        cat = hero_catalog.get(str(hid)) or hero_catalog.get(hid) or {}
        rarity = _safe_int(
            HERO_RARITY_CATALOG.get(hid) or cat.get("rarity") or h.get("rarity") or quality,
            1,
        )
        rarity = max(1, min(5, rarity))

        r_lvs = (
            rare_levels.get(str(rarity))
            or rare_levels.get(rarity)
            or HERO_RARE_LEVEL_MARCH_ADD.get(rarity)
            or {}
        )
        level_add = _safe_int(r_lvs.get(str(level), r_lvs.get(level, 0)), 0)

        # مهارات المعركة النشطة (skillType هو رقم المهارة مثل 171601)
        skills_add = 0
        skills = h.get("skillList", {})
        if isinstance(skills, dict):
            for _, s in skills.items():
                if isinstance(s, dict) and s.get("isActive"):
                    st = _safe_int(s.get("skillType"), 0)
                    if st in HERO_MARCH_SKILLS_BY_QUALITY:
                        skills_add += get_hero_battle_skill_march_add(st, quality)
                    elif st in HERO_MARCH_SKILLS_VAL:
                        skills_add += HERO_MARCH_SKILLS_VAL[st]
                    elif str(st) in extra_skills:
                        skills_add += _safe_int(extra_skills[str(st)], 12000)

        name_ar = HERO_ARABIC_NAMES.get(hid) or cat.get("name_ar") or cat.get("name") or f"Hero_{hid}"
        total_hero_add = level_add + skills_add

        evaluated.append({
            "hero_id": hid,
            "name": name_ar,
            "level": level,
            "rarity": rarity,
            "quality": quality,
            "state": state,
            "is_available": (state == G_HERO_STATE_NORMAL),
            "level_add": level_add,
            "skills_add": skills_add,
            "total_hero_add": total_hero_add,
        })

    return evaluated


def get_heroes_march_capacity(
    init_data: dict,
    hero_ids: Optional[List[int]] = None,
    num_heroes: Optional[int] = None,
    need_available: bool = False,
    include_defend: bool = False,
) -> Dict[str, Any]:
    """
    حساب إجمالي الزيادة في السعة الممنوحة من الأبطال المختارين أو أقوى الأبطال بالقلعة.
    يحترم تلقائياً عدد خانات الأبطال المفتوحة حسب مستوى القلعة (1..5).
    """
    max_slots = int(num_heroes) if num_heroes is not None else get_max_battle_hero_num(init_data)
    all_heroes = get_all_castle_heroes(init_data)
    if not all_heroes or max_slots <= 0:
        return {
            "total_heroes_flat": 0,
            "heroes_count": 0,
            "max_hero_slots": max(0, max_slots),
            "selected_heroes": [],
        }

    allowed_states = {G_HERO_STATE_NORMAL}
    if include_defend:
        allowed_states.add(G_HERO_STATE_DEFEND)

    selected: List[Dict[str, Any]] = []
    if hero_ids is not None:
        lookup = {h["hero_id"]: h for h in all_heroes}
        seen: Set[int] = set()
        for raw_hid in hero_ids:
            hid = _safe_int(raw_hid, 0)
            if hid <= 0 or hid in seen:
                continue
            seen.add(hid)
            if hid in lookup:
                h_entry = lookup[hid]
                if need_available and h_entry["state"] not in allowed_states:
                    continue
                selected.append(h_entry)
            if len(selected) >= max_slots:
                break
    else:
        candidates = [h for h in all_heroes if (not need_available or h["state"] in allowed_states)]
        candidates.sort(
            key=lambda x: (x["total_hero_add"], x["level"], x["rarity"], x["quality"], -x["hero_id"]),
            reverse=True,
        )
        selected = candidates[:max_slots]

    return {
        "total_heroes_flat": sum(h["total_hero_add"] for h in selected),
        "heroes_count": len(selected),
        "max_hero_slots": max_slots,
        "selected_heroes": selected,
    }


def get_god_arms_rune_march_buff(init_data: dict, arm_ids: Optional[List[int]] = None) -> int:
    """قراءة زيادة سعة المسيرة من رونات العتاد الإلهي (Effect 96) إن وُجدت في godArmsRuneCtrl."""
    rune_ctrl = init_data.get("godArmsRuneCtrl") if isinstance(init_data, dict) else None
    if not isinstance(rune_ctrl, dict) or not rune_ctrl:
        return 0

    rune_list = rune_ctrl.get("runeList") or {}
    wear_list = rune_ctrl.get("newGodArmsRuneList") or rune_ctrl.get("godArmsRuneList") or {}
    arm_set = {_safe_int(a) for a in arm_ids} if arm_ids is not None else None

    equipped_uids: Set[str] = set()
    if isinstance(wear_list, dict):
        for arm_key, slots in wear_list.items():
            if arm_set is not None and _safe_int(arm_key) not in arm_set:
                continue
            if isinstance(slots, dict):
                for uid in slots.values():
                    if uid:
                        equipped_uids.add(str(uid))
            elif isinstance(slots, list):
                for s in slots:
                    uid = s.get("uid") if isinstance(s, dict) else s
                    if uid:
                        equipped_uids.add(str(uid))

    total = 0
    items = rune_list.values() if isinstance(rune_list, dict) else (rune_list if isinstance(rune_list, list) else [])
    for r in items:
        if not isinstance(r, dict):
            continue
        uid = str(r.get("uid") or "")
        if equipped_uids and uid and uid not in equipped_uids:
            continue
        if not equipped_uids and not r.get("godArmsID") and not r.get("isWear"):
            continue
        props = r.get("property") or r.get("properties") or []
        if isinstance(props, dict):
            props = list(props.values())
        for p in props:
            if not isinstance(p, dict):
                continue
            et = _safe_int(p.get("effectType") or p.get("buffType"), 0)
            pid = _safe_int(p.get("id") or p.get("propertyID"), 0)
            val = _safe_int(p.get("val") or p.get("value") or p.get("num"), 0)
            if et == 96 and val > 0:
                total += val
            elif et == 0 and pid in RUNE_MARCH_PROPERTY_BASE:
                total += val if val > 0 else RUNE_MARCH_PROPERTY_BASE[pid]
    return total


def get_divine_beast_march_buff(
    init_data: dict,
    divine_beast_ids: Optional[List[int]] = None,
    need_in_city: bool = True,
) -> int:
    """قراءة زيادة سعة المسيرة من الوحوش الإلهية المرافقة (Effect 96) إن وُجدت في divineBeastCtrl."""
    beast_ctrl = init_data.get("divineBeastCtrl") if isinstance(init_data, dict) else None
    if not isinstance(beast_ctrl, dict) or not beast_ctrl:
        return 0

    dispatch_buffs = beast_ctrl.get("dispatchBuffDatas") or {}
    beasts = beast_ctrl.get("beast") or {}
    id_filter = {str(_safe_int(b)) for b in divine_beast_ids} if divine_beast_ids is not None else None

    total = 0
    if isinstance(dispatch_buffs, dict):
        for bid_key, b_buffs in dispatch_buffs.items():
            bid_str = str(bid_key)
            if id_filter is not None and bid_str not in id_filter:
                continue
            if need_in_city and isinstance(beasts, dict):
                b_info = beasts.get(bid_str) or beasts.get(_safe_int(bid_str))
                if isinstance(b_info, dict) and _safe_int(b_info.get("state"), 0) in (2, 3, 4):
                    continue
            if isinstance(b_buffs, dict):
                total += _safe_int(b_buffs.get(96) or b_buffs.get("96"), 0)

    # دعم حساب مهارة الإرسال 1002 للوحش 1900 عند عدم شحن dispatchBuffDatas بالسيرفر
    if total == 0 and isinstance(beasts, dict):
        for bid_key, b_info in beasts.items():
            bid_str = str(bid_key)
            if id_filter is not None and bid_str not in id_filter:
                continue
            if not isinstance(b_info, dict):
                continue
            b_state = _safe_int(b_info.get("state"), 0)
            if need_in_city and b_state in (2, 3, 4):
                continue
            if bid_str == "1900":
                star_lv = _safe_int(b_info.get("starLv") or b_info.get("star"), 0)
                if star_lv >= 4:
                    total += 20000
                elif star_lv == 3:
                    total += 14000
                elif star_lv >= 2:
                    total += 8000
                elif star_lv >= 0 and (b_info.get("skills") or b_info.get("skillList")):
                    total += 4000

    # فحص شارات الوحش الإلهي (divineBeastMarkCtrl:getDispatchAddCount / 10)
    mark_ctrl = init_data.get("divineBeastMarkCtrl")
    if isinstance(mark_ctrl, dict):
        db_dispatch = mark_ctrl.get("dispatchBuffDatas")
        if isinstance(db_dispatch, dict):
            for bid_k, b_data in db_dispatch.items():
                if id_filter is not None and str(bid_k) not in id_filter:
                    continue
                if isinstance(b_data, dict):
                    m_val = _safe_int(b_data.get(96) or b_data.get("96"), 0) // 10
                    if m_val > 0:
                        total += m_val

    return total


# ══════════════════════════════════════════════════════════════════════════════
# 4. الدالة المركزية الشاملة لحساب سعة المسيرة القصوى (The Master Calculation)
# ══════════════════════════════════════════════════════════════════════════════

def get_max_march_capacity(
    conn_or_init: Any,
    chosen_heroes: Optional[List[int]] = None,
    need_available: bool = False,
    move_line_type: Optional[int] = None,
    arm_ids: Optional[List[int]] = None,
    divine_beast_ids: Optional[List[int]] = None,
    allow_max_count: Optional[int] = None,
    extra_flat_add: int = 0,
    extra_percent_permille: int = 0,
) -> Dict[str, Any]:
    """
    الدالة المركزية الشاملة لحساب سعة مسيرة اللورد والجيش وفق WorldDispatchArmyViewPanel.lua:
      grand_total = castle_without_heroes["total_capacity"] + heroes_flat + arm_rune_add + divine_beast_add
    (بدون ضرب سعة الأبطال في المضاعف المئوي، مطابقاً 100% لسورس اللعبة).
    """
    if hasattr(conn_or_init, "init_data"):
        conn = conn_or_init
        init_data = getattr(conn, "init_data", {})
    else:
        conn = None
        init_data = conn_or_init if isinstance(conn_or_init, dict) else {}

    # 1. سعة القلعة بدون أبطال (buildLogic.getExpArmyCount)
    castle_res = get_castle_march_capacity_without_heroes(
        init_data,
        move_line_type=move_line_type,
        extra_flat_add=extra_flat_add,
        extra_percent_permille=extra_percent_permille,
    )

    # 2. سعة الأبطال المرسلين
    heroes_res = get_heroes_march_capacity(
        init_data,
        hero_ids=chosen_heroes,
        need_available=need_available,
    )

    # السعة النظرية القصوى لو كانت جميع الأبطال داخل القلعة
    theoretical_heroes = get_heroes_march_capacity(
        init_data,
        hero_ids=None,
        need_available=False,
    )

    # 3. رونات العتاد الإلهي والوحوش الإلهية
    arm_rune_add = get_god_arms_rune_march_buff(init_data, arm_ids=arm_ids)
    divine_beast_add = get_divine_beast_march_buff(
        init_data,
        divine_beast_ids=divine_beast_ids,
        need_in_city=need_available,
    )

    # 4. التجميع الرسمي المطابق لـ WorldDispatchArmyViewPanel:updateCountLabel()
    castle_total = castle_res["total_capacity"]
    grand_total = castle_total + heroes_res["total_heroes_flat"] + arm_rune_add + divine_beast_add
    theoretical_grand_total = castle_total + theoretical_heroes["total_heroes_flat"] + arm_rune_add + divine_beast_add

    if allow_max_count is not None and allow_max_count > 0:
        grand_total = min(grand_total, int(allow_max_count))
        theoretical_grand_total = min(theoretical_grand_total, int(allow_max_count))

    # صمام أمان الجلسة المتعلم
    learned_cap = None
    if conn and hasattr(conn, "learned_march_capacity"):
        l_cap = getattr(conn, "learned_march_capacity", None)
        if isinstance(l_cap, (int, float)) and l_cap > 0:
            learned_cap = int(l_cap)
            grand_total = min(grand_total, learned_cap)

    # 5. جاهزية القوات الحقيقية بالقلعة والمشفى (0-Network Direct Read)
    troops_info = get_castle_available_troops(init_data)
    free_troops = troops_info["free_troops_total"]
    max_sendable_troops = min(grand_total, free_troops)

    return {
        "grand_total": grand_total,
        "theoretical_max": theoretical_grand_total,
        "castle_without_heroes": castle_total,
        "castle_effective_base": castle_res["effective_base"],
        "heroes_flat_add": heroes_res["total_heroes_flat"],
        "theoretical_heroes_flat_add": theoretical_heroes["total_heroes_flat"],
        "arm_rune_add": arm_rune_add,
        "divine_beast_add": divine_beast_add,
        "max_hero_slots": heroes_res["max_hero_slots"],
        "total_percent_multiplier": castle_res["total_percent_multiplier"],
        "learned_march_capacity": learned_cap,
        "free_troops_total": free_troops,
        "wounded_troops_total": troops_info["wounded_troops_total"],
        "max_sendable_troops_now": max_sendable_troops,
        "troops_info": troops_info,
        "castle_breakdown": castle_res,
        "heroes_breakdown": heroes_res,
        "theoretical_heroes_breakdown": theoretical_heroes,
    }


# ══════════════════════════════════════════════════════════════════════════════
# 5. صمامات الأمان وتثبيت السقف المتعلم للجلسة
# ══════════════════════════════════════════════════════════════════════════════

def enforce_safe_march_troops(army_list: List[Dict[str, int]], max_capacity: int) -> List[Dict[str, int]]:
    """
    صمام الأمان الصارم (Strict Troop Guard):
    يضمن بنسبة 100% أن إجمالي الجنود في أي فيلق لا يتجاوز سعة المسيرة المسموح بها أبداً.
    """
    if not army_list or max_capacity <= 0:
        return []

    total_current = sum(int(item.get("num", 0)) for item in army_list)
    if total_current <= max_capacity:
        return army_list

    scale = float(max_capacity) / float(total_current)
    new_army: List[Dict[str, int]] = []
    running_total = 0

    for item in army_list:
        tid = item.get("id")
        orig_num = int(item.get("num", 0))
        scaled_num = max(1, int(math.floor(orig_num * scale)))
        new_army.append({"id": tid, "num": scaled_num})
        running_total += scaled_num

    deficit = max_capacity - running_total
    if deficit > 0:
        orig_map = {item.get("id"): int(item.get("num", 0)) for item in army_list}
        for itm in sorted(new_army, key=lambda x: x["num"], reverse=True):
            if deficit <= 0:
                break
            can_add = orig_map.get(itm["id"], itm["num"]) - itm["num"]
            add_val = min(deficit, can_add)
            if add_val > 0:
                itm["num"] += add_val
                deficit -= add_val

    surplus = sum(x["num"] for x in new_army) - max_capacity
    if surplus > 0:
        for itm in sorted(new_army, key=lambda x: x["num"], reverse=True):
            if surplus <= 0:
                break
            trim = min(surplus, itm["num"] - 1)
            if trim > 0:
                itm["num"] -= trim
                surplus -= trim

    result = [x for x in new_army if x["num"] > 0]
    final_total = sum(x["num"] for x in result)
    if final_total > max_capacity and result:
        result[0]["num"] = max(1, result[0]["num"] - (final_total - max_capacity))

    return result


def record_learned_march_capacity(conn: Any, max_troops: int) -> None:
    """تسجيل سقف السعة المتعلم أثناء الجلسة لحماية جميع المهام اللاحقة لنفس الحساب."""
    if not conn or max_troops <= 0:
        return
    current_learned = getattr(conn, "learned_march_capacity", None)
    if current_learned is None or not isinstance(current_learned, (int, float)) or current_learned <= 0 or max_troops < current_learned:
        setattr(conn, "learned_march_capacity", int(max_troops))
        log.warning(f"🛡️ [صمام الأمان] تم تثبيت سقف أمان المسيرات للجلسة: {max_troops:,} جندي لمنع أي تجاوز.")


# ══════════════════════════════════════════════════════════════════════════════
# 6. جلب بيانات الحسابات من الملفات أو قاعدة البيانات أو الاتصال المباشر
# ══════════════════════════════════════════════════════════════════════════════

def load_account_init_data(target: str, offline: bool = False) -> Tuple[str, dict]:
    """تحميل بيانات init_data لحساب معين (ملف محلي، اتصال حي بالسيرفر، أو نسخة مخبأة)."""
    if os.path.exists(target):
        try:
            with open(target, "r", encoding="utf-8") as f:
                return os.path.basename(target), json.load(f)
        except Exception as e:
            raise ValueError(f"فشل قراءة الملف {target}: {e}")

    raw_target = target.strip()
    if "@" in raw_target:
        alias = raw_target.split("@")[0]
        email = raw_target
    else:
        alias = raw_target
        email = f"{raw_target}@hotmail.com"

    if not offline:
        try:
            import core.database as db
            from bot_manager import CastleBot

            c_data = db.get_castle_by_id(email)
            if not c_data:
                for c in db.get_all_castles():
                    if c.get("email", "").startswith(alias):
                        c_data = c
                        email = c.get("email")
                        break

            pwd = c_data.get("password") if c_data else None
            print(f"🌐 [اتصال حي] جاري الاتصال المباشر بخادم اللعبة لحساب: {email}...")

            async def _connect_live():
                bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
                bot.is_running = True
                ok = await bot.connect()
                if not ok or not bot.conn:
                    return None
                data = dict(bot.conn.init_data)
                uid = getattr(bot.creds, "uid", "N/A")
                kid = getattr(bot.creds, "kingdom_id", "N/A")
                print(f"✓ تم تسجيل الدخول بنجاح! المملكة: {kid} | UID: {uid} ({len(data)} متحكم)")
                await bot.stop()
                return data

            live_data = asyncio.run(_connect_live())
            if live_data:
                return email, live_data
            print(f"⚠️ فشل الاتصال الحي بالسيرفر للحساب: {email}. جاري المحاولة من الذاكرة المحلية...")
        except Exception as e:
            print(f"⚠️ تعذر الاتصال الحي ({e}). جاري البحث في الذاكرة المحلية...")

    candidate_paths = [
        os.path.join(ROOT_DIR, "docs", f"{alias}_live_memory.json"),
        os.path.join(ROOT_DIR, "tools", f"{alias}_full_init_data.json"),
        os.path.join(ROOT_DIR, "scratch", f"{alias}_fresh_dump.json"),
        os.path.join(ROOT_DIR, "docs", f"{email}_live_memory.json"),
        os.path.join(ROOT_DIR, "tools", f"{email}_full_init_data.json"),
    ]
    for p in candidate_paths:
        if os.path.exists(p):
            try:
                with open(p, "r", encoding="utf-8") as f:
                    return alias, json.load(f)
            except Exception:
                pass

    raise FileNotFoundError(f"لم يتم العثور على بيانات الذاكرة للحساب: {target}")


# ══════════════════════════════════════════════════════════════════════════════
# 7. واجهة سطر الأوامر وفحص الذاكرة الحية التفاعلي (Rich Diagnostics & CLI)
# ══════════════════════════════════════════════════════════════════════════════

LEADERSHIP_TECH_ARABIC_NAMES: Dict[int, str] = {
    24016: "القيادة 1 (معهد العلوم)",
    24032: "القيادة 2 (معهد العلوم)",
    24048: "القيادة 3 (معهد العلوم)",
    25030: "الحد الأقصى للمسيرة (معهد العلوم - بطل)",
    110027: "حشد الفيلق (الفنون الحربية)",
    170012: "مسيرة الحرب المتقدمة 1",
    170013: "مسيرة الحرب المتقدمة 2",
    170054: "مسيرة الفيلق 1",
    170055: "مسيرة الفيلق 2",
    170092: "سعة الفيلق المتقدم",
    170104: "فن القيادة العسكرية",
    170140: "التعبئة الإمبراطورية",
    170148: "سعة الفيلق الإمبراطوري",
    304071: "توسيع النخبة 1 (قصر النخبة)",
    404071: "توسيع النخبة 2 (قصر النخبة)",
    414071: "توسيع النخبة 3 (قصر النخبة)",
    24319: "حرب الفتح (Conquest War)",
    24320: "حرب الأهرامات (Pyramid War)",
    24324: "حرب الأساطير (Legend War)",
}


def print_live_memory_diagnostics(
    init_data: dict,
    account_name: str = "",
    chosen_heroes: Optional[List[int]] = None,
    need_available: bool = False,
    no_heroes: bool = False,
) -> None:
    """
    طباعة تفصيلية حية وشاملة لكل خطوة من خطوات جلب وقراءة البيانات من الذاكرة الحية (0-Network Direct Read).
    توضح بدقة:
      - المتحكم المفحوص في الذاكرة الحية (Controller).
      - المفاتيح والقيم الخام المستخرجة من الذاكرة.
      - المقارنة المباشرة مع جداول اللعبة وسورس كود العميل.
      - تمييز القراءة المباشرة بإيموجي 🧠 [ذاكرة حية (0-Network)].
      - تمييز أي استعلام شبكي بإيموجي 🚨⚠️🚨 [استعلام شبكي Network Query].
    """
    print("\n" + "═" * 85)
    print(f"🔍 تقرير فحص واستخراج بيانات الذاكرة الحية لحساب: {account_name}")
    print("═" * 85)

    # 0. مستوى القلعة وخانات الأبطال
    castle_lv = get_castle_level(init_data)
    max_slots = get_max_battle_hero_num(init_data)
    print("🏰 [بيانات القلعة الأساسية]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] فحص مبنى القلعة (cityCtrl.blist -> bid=101):")
    print(f"   • مستوى القلعة الفعلي (Castle Level): Lv.{castle_lv}")
    print(f"   • عدد خانات الأبطال المفتوحة في الفيلق: {max_slots} من 5 خانات رسمية")

    # 1. مبنى ساحة العرض
    drill = get_drill_grounds_base_capacity(init_data)
    print("\n🎪 [1. مبنى ساحة العرض DRILL_GROUNDS - bid=121]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة مبنى ساحة العرض (cityCtrl.blist -> bid=121):")
    print(f"   • تم العثور على المبنى في كائنات الذاكرة الحية: {drill['found']}")
    print(f"   • المستوى الأساسي (lv): {drill['level']} -> السعة الأساسية: {drill['base_from_level']:,} جندي (build121.lua)")
    print(f"   • مستوى نجوم قصر المجد (starLv): {drill['star_level']}★ -> سعة النجوم: +{drill['base_from_star']:,} جندي (buildstar121.lua)")
    print(f"   => إجمالي سعة ساحة العرض الأساسية: {drill['total_base_capacity']:,} جندي")

    # 2. الثابت الافتراضي
    print("\n⚙️ [2. الثابت الرياضي الافتراضي للنظام]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] ثابت النظام الافتراضي (gConstValue.DEFAULT_EXP_ARMY_COUNT):")
    print(f"   => +{DEFAULT_EXP_ARMY_COUNT:,} جندي")

    # 3. أبحاث القيادة الفردية ومجموعات العلوم
    tech = get_technology_march_additions(init_data)
    tctrl = init_data.get("technologyCtrl", {}) if isinstance(init_data, dict) else {}
    print("\n🔬 [3. أبحاث العلوم القيادية ومجموعات الحروب]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة سجل الأبحاث (technologyCtrl):")
    print(f"   • إجمالي عدد الأبحاث المكتشفة في الحساب: {len(tctrl)} بحثاً")
    if tech["details"]:
        print(f"   • أبحاث القيادة الفردية النشطة (Buff Type 43):")
        for td in tech["details"]:
            t_name = LEADERSHIP_TECH_ARABIC_NAMES.get(td["tech_id"], f"بحث #{td['tech_id']}")
            print(f"     - [{td['tech_id']}] {t_name:<26}: Lv.{td['level']} -> +{td['power']:,} جندي")
    else:
        print("   • أبحاث القيادة الفردية (Buff Type 43): لا توجد أبحاث قيادة نشطة (+0)")
    print(f"   => إجمالي زيادة أبحاث القيادة الفردية: +{tech['total_tech_add']:,} جندي")

    if tech["tech_group_details"]:
        print(f"   • أبحاث مجموعات الحروب المئوية (Buff Types 73, 77, 95):")
        for tg in tech["tech_group_details"]:
            tg_name = LEADERSHIP_TECH_ARABIC_NAMES.get(tg["tech_id"], f"مجموعة #{tg['tech_id']}")
            print(f"     - [{tg['tech_id']}] {tg_name:<26}: Lv.{tg['level']} -> +{tg['multiplier']*100:.1f}%")
    else:
        print("   • أبحاث مجموعات الحروب المئوية: لا توجد أبحاث مئوية نشطة (+0.0%)")
    print(f"   => نسبة مضاعف مجموعات العلوم: +{tech['tech_group_multiplier']*100:.1f}%")

    # 4. وسام القائد 'توحيد القوة'
    ach = get_achievement_march_buff(init_data)
    ach_ctrl = init_data.get("achievementctrl", {}) if isinstance(init_data, dict) else {}
    ach_list = ach_ctrl.get("list", {}) if isinstance(ach_ctrl, dict) else {}
    m17 = ach_list.get("17") or ach_list.get(17) or {}
    print("\n🎖️ [4. وسام القائد 'توحيد القوة' - Medal 17 (9003017)]")
    if ach_ctrl and m17:
        print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة بيانات الأوسمة (achievementctrl.list['17']):")
        print(f"   • البيانات المستخرجة: curID={m17.get('curID')}, maxDoneID={m17.get('maxDoneID')}, star={m17.get('star')}, hasBuff={m17.get('hasBuff')}")
        print(f"   • المستوى المنجز (maxDoneID): {ach['max_done_id']} -> الزيادة: +{ach['percent']:.1f}% (+{ach['permille']} بالألف)")
    else:
        print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة بيانات الأوسمة (achievementctrl.list):")
        print("   • وسام 'توحيد القوة' غير مفتوح أو لم ينجز أي مرحلة (+0.0%)")
    print(f"   => نسبة وسام توحيد القوة: +{ach['percent']:.1f}%")

    # 5. امتياز كبار الشخصيات VIP / SVIP
    vip = get_vip_march_buff(init_data)
    now_ts = int(time.time())
    print("\n👑 [5. امتياز كبار الشخصيات VIP / SVIP - Privilege 7219]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة امتيازات VIP (lordInfoCtrl.vip):")
    print(f"   • مستوى الـ VIP الحالي: Lv.{vip['vip_level']}")
    vip_end_str = "منتهي الصلاحية (0)" if vip["vip_end_time"] == 0 else f"{int(vip['vip_end_time'])} (متبقي: {max(0, int(vip['vip_end_time'] - now_ts))} ثانية)"
    st_text = "نشط ومفعّل" if vip["is_vip_active"] else "غير مفعّل / منتهي"
    print(f"   • سريان المدة: {vip_end_str} -> الحالة: {st_text}")
    print(f"   • قاعدة اللعبة: امتياز زيادة سعة المسيرة (7219) يبدأ حصراً من VIP 14 فما فوق ويشترط التفعيل الزمني")
    print(f"   => نسبة امتياز VIP المطبقة: +{vip['percent']:.1f}%")

    # 6. بافات المسيرة المؤقتة من الحقيبة
    buffs = get_active_march_buffs(init_data)
    bctrl = init_data.get("buffCtrl", {}) if isinstance(init_data, dict) else {}
    b_count = len(bctrl) if isinstance(bctrl, (dict, list)) else 0
    print("\n🧳 [6. بافات المسيرة المؤقتة السارية بالحقيبة/القلعة]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة بافات القلعة (buffCtrl):")
    print(f"   • عدد البافات المسجلة بالذاكرة الحية: {b_count}")
    if buffs["details"]:
        print("   • بافات المسيرة المؤقتة السارية:")
        for bd in buffs["details"]:
            rem_str = f"{bd['remaining_sec']} ثانية" if bd["remaining_sec"] >= 0 else "دائم"
            if bd.get("effect_type") == 19:
                print(f"     - [Buff #{bd['buff_id']}] باف مئوي: +{bd['permille']/10.0:.1f}% (متبقي: {rem_str})")
            elif bd.get("effect_type") == 96:
                print(f"     - [Buff #{bd['buff_id']}] باف رقمي: +{bd['flat']:,} جندي (متبقي: {rem_str})")
    else:
        print("   • لا توجد بافات توسيع مسيرة مؤقتة نشطة (النسبة: +0.0% | الثابت: +0)")
    print(f"   => بافات المسيرة المؤقتة: النسبة = +{buffs['buff_percent_permille']/10.0:.1f}% | الثابت = +{buffs['buff_flat_val']:,} جندي")

    # 7. بافات مظاهر الأبطال السلبية
    dresses = get_hero_dress_passive_march_buff(init_data)
    print("\n🥋 [7. بافات مظاهر الأبطال السلبية المملوكة - Effect 96]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة مظاهر الأبطال (heroSysCtrl.heroList[h].dress.list):")
    if dresses["dresses"]:
        for dr in dresses["dresses"]:
            print(f"   - مظهر #{dr['dress_id']} للبطل #{dr['hero_id']}: +{dr['buff_val']:,} جندي")
    else:
        print("   • لا توجد مظاهر أبطال سلبية ذات باف سعة مسيرة (+0)")
    print(f"   => إجمالي بافات مظاهر الأبطال: +{dresses['total_dress_add']:,} جندي")

    # 8. المصادر الدائمة الإضافية ونظام السمات
    extra = get_extra_permanent_march_buffs(init_data)
    srcs = extra["sources"]
    print("\n🔮 [8. المصادر الدائمة الإضافية ونظام السمات - 10 متحكمات]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] فحص المتحكمات الإضافية في الذاكرة الحية:")
    src_labels = [
        ("war_gems", "أحجار الحرب (warGemCtrl)"),
        ("kingdom_level", "مستوى المملكة (playerKingdomLevelCtrl)"),
        ("nebula_tower", "برج السديم (nebulaTowerCtrl)"),
        ("hero_biography", "سيرة الأبطال (heroBiographyCtrl)"),
        ("equipment", "المعدات العسكرية المجهزة (equipmentCtrl)"),
        ("pets", "الحيوانات الأليفة (petCtrl)"),
        ("hero_mastery", "مهارات إتقان الأبطال (heroSysCtrl)"),
        ("divine_beast_passive", "الوحوش الإلهية سلبي (divineBeastCtrl)"),
        ("miraculous_weapon", "السلاح الإعجازي (miraculousWeaponCtrl)"),
        ("castle_dress_attr5", "مظاهر القلعة والأطر Attr 5 (dressCtrl)"),
    ]
    for k, lbl in src_labels:
        val = srcs.get(k, 0)
        print(f"   • {lbl:<46}: +{val:,} جندي")
    print(f"   => إجمالي إضافة المصادر الدائمة الإضافية: +{extra['total_extra_flat']:,} جندي")

    # 9. ملخص معادلة سعة القلعة بدون أبطال
    c_res = get_castle_march_capacity_without_heroes(init_data)
    print("\n" + "═" * 85)
    print("📐 [9. المعادلة الرياضية الرسمية لسعة القلعة بدون أبطال (buildLogic.getExpArmyCount)]")
    print("═" * 85)
    print(f"   • الإجمالي الثابت الأساسي للقلعة =")
    print(f"       {c_res['base_drill_grounds']:>7,} (ساحة العرض Lv.{c_res['drill_level']})")
    print(f"     + {c_res['default_game_constant']:>7,} (ثابت النظام الافتراضي)")
    print(f"     + {c_res['tech_flat_add']:>7,} (أبحاث القيادة الفردية Tech 43)")
    print(f"     + {c_res['hero_dress_flat_add']:>7,} (مظاهر الأبطال السلبية)")
    print(f"     + {c_res['buff_flat_add']:>7,} (بافات الحقيبة الثابتة)")
    print(f"     + {c_res['extra_flat_add']:>7,} (المصادر الدائمة الإضافية)")
    print(f"     ──────────────────────────────────────────")
    print(f"     = {c_res['effective_base']:>7,} جندي (الأساس الفعلي الخاضع للضرب المئوي)")
    print(f"   • إجمالي المضاعف المئوي =")
    print(f"       {c_res['achievement_percent']:>5.1f}% (وسام توحيد القوة)")
    print(f"     + {c_res['vip_percent']:>5.1f}% (امتياز VIP/SVIP)")
    print(f"     + {c_res['tech_group_percent']:>5.1f}% (أبحاث مجموعات العلوم)")
    print(f"     + {c_res['item_buff_percent']:>5.1f}% (باف الحقيبة المؤقت)")
    print(f"     ──────────────────────────────────────────")
    print(f"     = {c_res['total_percent_multiplier']*100:>5.1f}%")
    print(f"   • الزيادة المئوية المحسوبة = floor({c_res['effective_base']:,} × {c_res['total_percent_multiplier']*100:.1f}%) = +{c_res['percent_troop_add']:,} جندي")
    print("   ─────────────────────────────────────────────────────────────────────────────────")
    print(f"   🏰 سعة القلعة وحدها بدون أبطال = {c_res['effective_base']:,} + {c_res['percent_troop_add']:,} = {c_res['total_capacity']:,} جندي")
    print("   ─────────────────────────────────────────────────────────────────────────────────")

    # 10. فحص وتقييم أبطال القلعة
    all_heroes = get_all_castle_heroes(init_data)
    print("\n🦸 [10. جلب وتقييم أبطال القلعة المملوكين (heroSysCtrl.heroList)]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] فحص سجل الأبطال بالذاكرة الحية:")
    print(f"   • إجمالي عدد الأبطال المملوكين في القلعة: {len(all_heroes)} بطل")
    state_names = {
        G_HERO_STATE_NORMAL: "شاغر بالقلعة",
        G_HERO_STATE_DEAD: "ميت",
        G_HERO_STATE_CAPTURED: "مأسور",
        G_HERO_STATE_BATTLE: "خارج القلعة/مسيرة",
        G_HERO_STATE_DEFEND: "حامية السور",
    }
    sorted_all = sorted(
        all_heroes,
        key=lambda x: (x["total_hero_add"], x["level"], x["rarity"], -x["hero_id"]),
        reverse=True,
    )
    for idx, h in enumerate(sorted_all, 1):
        st_label = state_names.get(h["state"], f"حالة {h['state']}")
        print(f"   {idx:>2}. [{h['hero_id']}] {h['name']:<14} | Lv.{h['level']:<3} | ندرة {h['rarity']} | {st_label:<18} -> إضافة مستوى: +{h['level_add']:,} | مهارات: +{h['skills_add']:,} => إجمالي البطل: +{h['total_hero_add']:,} جندي")

    # 11. اختيار أبطال الفيلق
    print("\n🗡️ [11. اختيار أبطال الفيلق للمسيرة]")
    if no_heroes:
        print("   • تم اختيار: إرسال المسيرة بدون أبطال نهائياً (0 أبطال)")
        h_selected = []
        heroes_flat = 0
    else:
        h_res = get_heroes_march_capacity(
            init_data,
            hero_ids=chosen_heroes,
            need_available=need_available,
        )
        h_selected = h_res["selected_heroes"]
        heroes_flat = h_res["total_heroes_flat"]
        mode_text = "الأبطال المتاحون فقط" if need_available else f"أقوى {max_slots} أبطال"
        if chosen_heroes:
            mode_text = f"الأبطال المحددون ({','.join(map(str, chosen_heroes))})"
        print(f"   • نمط الاختيار: {mode_text} ({len(h_selected)}/{max_slots} أبطال):")
        for idx, h in enumerate(h_selected, 1):
            st_label = state_names.get(h["state"], f"حالة {h['state']}")
            print(f"     {idx}. {h['name']} (ID {h['hero_id']}) | Lv.{h['level']} | ندرة {h['rarity']} | {st_label} -> +{h['total_hero_add']:,} جندي")
    print(f"   => إجمالي إضافة الأبطال للفيلق: +{heroes_flat:,} جندي")

    # 12. رونات العتاد والوحوش الإلهية
    arm_rune = get_god_arms_rune_march_buff(init_data)
    divine_beast = get_divine_beast_march_buff(init_data, need_in_city=need_available)
    print("\n⚡ [12. رونات العتاد الإلهي والوحوش الإلهية المرافقة]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] فحص الرونات والوحوش الإلهية:")
    print(f"   • رونات العتاد الإلهي (godArmsRuneCtrl): +{arm_rune:,} جندي")
    print(f"   • الوحوش الإلهية المرافقة (divineBeastCtrl): +{divine_beast:,} جندي")

    # 13. النتيجة الإجمالية النهائية
    grand_total = c_res["total_capacity"] + heroes_flat + arm_rune + divine_beast
    troops_info = get_castle_available_troops(init_data)
    free_troops = troops_info["free_troops_total"]
    wounded_troops = troops_info["wounded_troops_total"]
    max_sendable_now = min(grand_total, free_troops)

    print("\n" + "═" * 85)
    print("👑 [13. النتيجة الإجمالية لسعة المسيرة والجاهزية الميدانية (WorldDispatchArmyViewPanel.lua)]")
    print("═" * 85)
    print(f"   = {c_res['total_capacity']:>7,} جندي (سعة القلعة بدون أبطال)")
    print(f"   + {heroes_flat:>7,} جندي (إضافة أبطال الفيلق)")
    print(f"   + {arm_rune:>7,} جندي (رونات العتاد الإلهي)")
    print(f"   + {divine_beast:>7,} جندي (الوحوش الإلهية)")
    print(f"   ──────────────────────────────────────────")
    print(f"   👑 السعة الاستيعابية القصوى للفيلق (March Capacity Limit): {grand_total:,} جندي")
    print(f"\n💂 [14. فحص الجاهزية الميدانية للقوات المتوفرة بالقلعة (armyCtrl)]")
    print(f"🧠 [ذاكرة حية Direct Live Memory (0-Network)] قراءة سجل القوات الفعلي:")
    print(f"   • إجمالي القوات الحرة الجاهزة بالقلعة (totalArmy)  : {free_troops:,} جندي")
    print(f"   • إجمالي القوات المصابة في المستشفى (woundedArmy) : {wounded_troops:,} جندي مصاب")
    print(f"   ──────────────────────────────────────────")
    print(f"   ★ أقصى عدد جنود يمكنك وضعهم في المسيرة فعلياً الآن:")
    print(f"     min(سعة المسيرة {grand_total:,} ، القوات الجاهزة {free_troops:,}) = {max_sendable_now:,} جندي فقط!")
    print(f"   ℹ️ ملاحظة جمع الموارد (Gathering Field):")
    print(f"     عند الجمع من حقل موارد على الخريطة، اللعبة تحدد عدد الجنود بحسب سعة حمولة المورد فقط")
    print(f"     (كمية المورد ÷ حمولة الجندي 24) ولا ترسل أكثر من طاقة الحقل أو أكثر من {max_sendable_now:,} جندي.")
    print("═" * 85 + "\n")


def format_report(account_name: str, res: Dict[str, Any], show_available_only: bool = False) -> str:
    """تنسيق تقرير عربي واضح يوضح كافة تفاصيل السعة ومكوناتها."""
    c = res["castle_breakdown"]
    h = res["heroes_breakdown"]
    th = res["theoretical_heroes_breakdown"]

    lines = [
        "╔═══════════════════════════════════════════════════════════════════════╗",
        f"║ 🏰  تقرير سعة المسيرة القصوى — حساب: {account_name:<31} ║",
        "╠═══════════════════════════════════════════════════════════════════════╣",
        "║ 1. سعة ساحة العرض والقلعة الأساسية (بدون أبطال):                      ║",
        f"║    • مستوى مبنى ساحة العرض: {c['drill_level']:<3} (نجمة المجد: {c['drill_star']:<2}) -> {c['base_drill_grounds']:,} جندي",
        f"║    • الثابت الافتراضي للعبة: {c['default_game_constant']:,} جندي",
        f"║    • أبحاث القيادة الفردية (Tech 43): +{c['tech_flat_add']:,} جندي",
    ]
    if c["hero_dress_flat_add"] > 0:
        lines.append(f"║    • بافات مظاهر الأبطال السلبية: +{c['hero_dress_flat_add']:,} جندي")
    if c["buff_flat_add"] > 0:
        lines.append(f"║    • بافات الحقيبة الثابتة: +{c['buff_flat_add']:,} جندي")
    if c["extra_flat_add"] > 0:
        lines.append(f"║    • إضافات المصادر الدائمة الأخرى: +{c['extra_flat_add']:,} جندي")
        src_labels = {
            "nebula_tower": "برج السديم",
            "kingdom_level": "مستوى المملكة",
            "war_gems": "أحجار الحرب",
            "hero_biography": "سيرة الأبطال",
            "equipment": "المعدات العسكرية",
            "pets": "الحيوانات الأليفة",
            "hero_mastery": "إتقان الأبطال",
            "divine_beast_passive": "الوحوش الإلهية (سلبي)",
            "miraculous_weapon": "السلاح الإعجازي",
            "castle_dress_attr5": "مظاهر القلعة (Attr 5)",
        }
        for sk, sv in (c.get("extra_permanent_sources") or {}).items():
            if sv > 0:
                lines.append(f"║      - {src_labels.get(sk, sk)}: +{sv:,} جندي")
    lines.extend([
        "║    ─────────────────────────────────────────────────────────────────  ║",
        f"║    • الإجمالي الثابت الأساسي للقلعة: {c['effective_base']:,} جندي",
        "║    • نسب البافات المئوية (تُطبّق على سعة القلعة فقط):",
        f"║      - وسام القائد 'توحيد القوة': +{c['achievement_percent']:.1f}%",
    ])
    if c["tech_group_percent"] > 0:
        lines.append(f"║      - أبحاث مجموعات الحروب: +{c['tech_group_percent']:.1f}%")
    if c["vip_percent"] > 0:
        lines.append(f"║      - امتياز VIP/SVIP (Lv.{c['vip_level']} نشط): +{c['vip_percent']:.1f}%")
    if c["item_buff_percent"] > 0:
        lines.append(f"║      - باف المسيرة المئوي المؤقت: +{c['item_buff_percent']:.1f}%")
    lines.extend([
        f"║      - إجمالي المضاعف المئوي: +{c['total_percent_multiplier']*100:.1f}% (+{c['percent_troop_add']:,} جندي)",
        f"║    ★ سعة القلعة وحدها بدون أبطال: {c['total_capacity']:,} جندي",
        "╠═══════════════════════════════════════════════════════════════════════╣",
    ])

    hero_label = "الأبطال الشاغرين المتاحين فقط" if show_available_only else f"أقوى {h['max_hero_slots']} أبطال في القلعة"
    lines.append(f"║ 2. تفاصيل {hero_label} ({h['heroes_count']}/{h['max_hero_slots']}):")
    if not h["selected_heroes"]:
        lines.append("║    • لم يتم اختيار أي أبطال في المسيرة (0 أبطال)")
    else:
        for idx, hero in enumerate(h["selected_heroes"], 1):
            st_text = "شاغر بالقلعة" if hero["is_available"] else "خارج القلعة/غير متاح"
            lines.append(
                f"║    {idx}. {hero['name']} (ID {hero['hero_id']}) | لفل {hero['level']} | ندرة {hero['rarity']} | {st_text} -> +{hero['total_hero_add']:,} جندي"
            )

    lines.append("║    ─────────────────────────────────────────────────────────────────  ║")
    lines.append(f"║    • إجمالي إضافة الأبطال الميدانية: +{h['total_heroes_flat']:,} جندي")
    if res["arm_rune_add"] > 0:
        lines.append(f"║    • إضافة رونات العتاد الإلهي: +{res['arm_rune_add']:,} جندي")
    if res["divine_beast_add"] > 0:
        lines.append(f"║    • إضافة الوحوش الإلهية: +{res['divine_beast_add']:,} جندي")
    if show_available_only and th["total_heroes_flat"] != h["total_heroes_flat"]:
        lines.append(f"║    • أقصى إضافة نظرية بكافة الأبطال: +{th['total_heroes_flat']:,} جندي")

    lines.extend([
        "╠═══════════════════════════════════════════════════════════════════════╣",
        "║ 3. النتيجة النهائية لسعة المسيرة (سعة القلعة + الأبطال + الرونات):     ║",
        f"║    👑 السعة الإجمالية الفعلية للفيلق:  {res['grand_total']:,} جندي",
    ])
    if res["theoretical_max"] != res["grand_total"]:
        lines.append(f"║    ⚔️  السعة القصوى النظرية الشاملة:   {res['theoretical_max']:,} جندي")

    # إضافة تفاصيل جاهزية القوات الحقيقية
    if "free_troops_total" in res:
        free_tr = res["free_troops_total"]
        w_tr = res.get("wounded_troops_total", 0)
        max_send = res.get("max_sendable_troops_now", min(res["grand_total"], free_tr))
        lines.extend([
            "╠═══════════════════════════════════════════════════════════════════════╣",
            "║ 4. جاهزية القوات الميدانية للإرسال الفعلي الآن:                       ║",
            f"║    • القوات الحرة الجاهزة بالقلعة:     {free_tr:,} جندي",
            f"║    • القوات المصابة في المستشفى:       {w_tr:,} جندي مصاب",
            f"║    ★ أقصى عدد جنود يمكن إرسالهم الآن:  {max_send:,} جندي فقط",
        ])
    lines.append("╚═══════════════════════════════════════════════════════════════════════╝")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(
        description="المحرك المركزي لحساب سعة مسيرة اللورد والجيش (انتقام السلاطين)"
    )
    parser.add_argument("--email", "-e", type=str, default="beetoo2", help="بريد الحساب أو اسمه المستعار")
    parser.add_argument("--file", "-f", type=str, default=None, help="مسار ملف JSON لـ init_data")
    parser.add_argument("--heroes", type=str, default=None, help="معرفات أبطال محددة مفصولة بفواصل")
    parser.add_argument("--available", "-a", action="store_true", help="قصر الحساب على الأبطال الشاغرين داخل القلعة فقط")
    parser.add_argument("--no-heroes", action="store_true", help="حساب سعة القلعة بدون أبطال نهائياً (0 أبطال)")
    parser.add_argument("--json", "-j", action="store_true", help="طباعة المخرجات بتنسيق JSON فقط")
    parser.add_argument("--all", action="store_true", help="فحص كافة الحسابات المسجلة بقاعدة البيانات")
    parser.add_argument("--offline", action="store_true", help="القراءة من الذاكرة المحلية المخبأة دون الاتصال بالسيرفر")

    args = parser.parse_args()

    if args.all:
        import sqlite3
        db_path = os.path.join(ROOT_DIR, "database", "castles.db")
        if not os.path.exists(db_path):
            print(f"❌ قاعدة البيانات غير موجودة: {db_path}")
            return
        conn = sqlite3.connect(db_path)
        cur = conn.cursor()
        cur.execute("SELECT email FROM castle_states")
        rows = cur.fetchall()
        conn.close()

        print(f"📊 فحص سعة المسيرة لكافة القلاع المسجلة ({len(rows)} حساب)...")
        for r in rows:
            em = r[0]
            try:
                _, data = load_account_init_data(em, offline=args.offline)
                res = get_max_march_capacity(data, need_available=args.available)
                print(f"  • {em:<25}: بدون أبطال={res['castle_without_heroes']:,} | بالسعة القصوى={res['grand_total']:,} جندي")
            except Exception as ex:
                print(f"  • {em:<25}: ⚠️ {ex}")
        return

    target = args.file or args.email
    chosen_hero_ids = None
    if args.no_heroes:
        chosen_hero_ids = []
    elif args.heroes:
        chosen_hero_ids = [int(x.strip()) for x in args.heroes.split(",") if x.strip().isdigit()]

    try:
        acc_name, init_data = load_account_init_data(target, offline=args.offline)
    except Exception as e:
        print(f"❌ خطأ في جلب بيانات الحساب ({target}): {e}")
        return

    # طباعة الفحص التشخيصي الميداني للذاكرة الحية خطوة بخطوة
    if not args.json:
        print_live_memory_diagnostics(
            init_data,
            account_name=acc_name,
            chosen_heroes=chosen_hero_ids,
            need_available=args.available,
            no_heroes=args.no_heroes,
        )

    res = get_max_march_capacity(
        init_data,
        chosen_heroes=chosen_hero_ids,
        need_available=args.available,
    )

    if args.json:
        clean_res = {
            "account": acc_name,
            "grand_total": res["grand_total"],
            "theoretical_max": res["theoretical_max"],
            "castle_without_heroes": res["castle_without_heroes"],
            "heroes_flat_add": res["heroes_flat_add"],
            "arm_rune_add": res["arm_rune_add"],
            "divine_beast_add": res["divine_beast_add"],
            "max_hero_slots": res["max_hero_slots"],
            "total_percent_multiplier": res["total_percent_multiplier"],
            "selected_heroes": [
                {
                    "id": h["hero_id"],
                    "name": h["name"],
                    "level": h["level"],
                    "rarity": h["rarity"],
                    "quality": h["quality"],
                    "state": h["state"],
                    "is_available": h["is_available"],
                    "addition": h["total_hero_add"],
                }
                for h in res["heroes_breakdown"]["selected_heroes"]
            ],
            "breakdown": res["castle_breakdown"],
        }
        print(json.dumps(clean_res, ensure_ascii=False, indent=2))
    else:
        print(format_report(acc_name, res, show_available_only=args.available))


if __name__ == "__main__":
    main()