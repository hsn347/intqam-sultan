# -*- coding: utf-8 -*-
"""
tasks/train.py — مهمة تدريب الجنود والفخاخ في الثكنات وحصن الحرب تلقائياً (TrainTask)
══════════════════════════════════════════════════════════════════════════════════════
بروتوكول تدريب الجيش الرسمي للعبة انتقام السلاطين (Army Training Protocol):
  - بدء التدريب:     cmd: "1005", subcmd: "2", data: {"bid": bid, "armyid": armyid, "armycount": count, "mode": "0", "isget": false}
  - جمع/استلام الجنود: cmd: "1005", subcmd: "5", data: {"bid": bid}
  - طوابير التدريب:   queueCtrl['1203'..'1207']

المباني وأنواع القوات:
  1. 🛡️ المشاة (Infantry):    bid = "118" | armyid = 401..410 (مستوى 1..10)
  2. 🐎 الخيالة (Cavalry):     bid = "116" | armyid = 501..510 (مستوى 1..10)
  3. 🏹 الرماة (Archers):      bid = "117" | armyid = 601..610 (مستوى 1..10)
  4. 🚜 العربات (Chariots):    bid = "119" | armyid = 701..710 (مستوى 1..10)
  5. 🏰 حصن الحرب (Fortress):  bid = "120" | armyid = 801..824 (فخاخ)

المزايا المعمارية (Revenge of Sultans Architecture):
  - 0-Network Direct Read: استعلام فوري من الذاكرة الحية بصفر طلبات شبكية استباقية.
  - مهمة اختيارية (User-Configurable): لا تعمل إلا بعد تفعيلها صراحة من قبل المستخدم.
  - حساب سعة الموارد والخيام بدقة 100% مع تصحيح تكيفي ذكي ومحاكاة بشرية (Human Jitter).
"""

from __future__ import annotations

import asyncio
import json
import os
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT_DIR not in sys.path:
    sys.path.insert(0, _ROOT_DIR)

from tasks.base_task import BaseTask, TaskResult

# جدول تكاليف موارد تدريب الوحدات الرسمي المدمج مباشرة في الذاكرة (من armyinfo.lua)
_ARMY_COSTS: Dict[str, Dict[str, int]] = {
    # المشاة (Infantry 401..410)
    "401": {"1002": 60},
    "402": {"1002": 100},
    "403": {"1002": 120, "1003": 30},
    "404": {"1002": 170, "1004": 5},
    "405": {"1002": 170, "1003": 70, "1004": 10},
    "406": {"1002": 330, "1004": 20},
    "407": {"1002": 400, "1004": 30, "1005": 3},
    "408": {"1002": 440, "1003": 100, "1004": 40, "1005": 5},
    "409": {"1002": 510, "1003": 200, "1004": 50, "1005": 8},
    "410": {"1002": 640, "1003": 300, "1004": 70, "1005": 10},
    # الخيالة (Cavalry 501..510)
    "501": {"1002": 60},
    "502": {"1002": 100},
    "503": {"1002": 150},
    "504": {"1002": 170, "1003": 20, "1004": 2},
    "505": {"1002": 230, "1003": 30, "1004": 7},
    "506": {"1002": 300, "1003": 60, "1004": 15},
    "507": {"1002": 340, "1003": 70, "1004": 20, "1005": 5},
    "508": {"1002": 400, "1003": 100, "1004": 35, "1005": 8},
    "509": {"1002": 550, "1003": 150, "1004": 40, "1005": 11},
    "510": {"1002": 700, "1003": 240, "1004": 50, "1005": 15},
    # الرماة (Archers 601..610)
    "601": {"1002": 60},
    "602": {"1002": 90, "1003": 10},
    "603": {"1002": 130, "1003": 20},
    "604": {"1002": 170, "1003": 20, "1004": 2},
    "605": {"1002": 250, "1003": 25, "1004": 4},
    "606": {"1002": 340, "1003": 50, "1004": 10},
    "607": {"1002": 450, "1003": 60, "1004": 15, "1005": 2},
    "608": {"1002": 600, "1003": 110, "1004": 20, "1005": 3},
    "609": {"1002": 800, "1003": 150, "1004": 25, "1005": 4},
    "610": {"1002": 1000, "1003": 300, "1004": 30, "1005": 5},
    # العربات (Chariots 701..710)
    "701": {"1002": 35, "1003": 25},
    "702": {"1002": 60, "1003": 40},
    "703": {"1002": 90, "1003": 60},
    "704": {"1002": 120, "1003": 80},
    "705": {"1002": 160, "1003": 110, "1004": 5},
    "706": {"1002": 210, "1003": 150, "1004": 10},
    "707": {"1002": 270, "1003": 200, "1004": 15, "1005": 2},
    "708": {"1002": 350, "1003": 260, "1004": 20, "1005": 4},
    "709": {"1002": 450, "1003": 340, "1004": 25, "1005": 6},
    "710": {"1002": 600, "1003": 450, "1004": 30, "1005": 8},
    # الفخاخ (Traps 801..824)
    "801": {"1002": 250},
}

# سعة خيام الجيش الرسمية الأساسية من build205.lua
_TENT_BASE_CAPACITIES: Dict[int, int] = {
    1: 20, 2: 20, 3: 25, 4: 25, 5: 30, 6: 30, 7: 40, 8: 40, 9: 50, 10: 50,
    11: 60, 12: 60, 13: 70, 14: 70, 15: 80, 16: 80, 17: 90, 18: 90, 19: 100, 20: 100,
    21: 110, 22: 110, 23: 120, 24: 120, 25: 130, 26: 130, 27: 140, 28: 140, 29: 150, 30: 160,
    31: 160, 32: 160, 33: 160, 34: 160, 35: 160
}

# سعة نجوم الهيبة الإضافية للخيام من buildstar205.lua (تضاف فوق سعة المستوى 30)
_TENT_STAR_CAPACITIES: Dict[int, int] = {
    1: 3, 2: 6, 3: 9, 4: 12, 5: 15, 6: 18, 7: 34, 8: 37, 9: 40, 10: 43,
    11: 46, 12: 49, 13: 52, 14: 55, 15: 58, 16: 61, 17: 77, 18: 80, 19: 83, 20: 86,
    21: 89, 22: 92, 23: 95, 24: 98, 25: 101, 26: 104, 27: 107, 28: 110, 29: 113, 30: 116,
    31: 132, 32: 135, 33: 138, 34: 141, 35: 144, 36: 147, 37: 150, 38: 153, 39: 156, 40: 159,
    41: 162, 42: 165, 43: 168, 44: 171, 45: 174, 46: 177, 47: 180, 48: 183, 49: 199, 50: 202,
    51: 205, 52: 208, 53: 211, 54: 214, 55: 217, 56: 220, 57: 223, 58: 226, 59: 229, 60: 232,
    61: 235, 62: 238, 63: 241, 64: 244, 65: 247, 66: 250, 67: 253, 68: 256, 69: 259, 70: 275
}

# علاقات الأهداف والأنواع الفرعية من attribute_relation.lua و attributeDef.lua
_TARGET_RELATIONS: Dict[int, List[int]] = {
    7: [7, 2, 1],   # مشاة دروع (Infantry Defense - Even: 402, 404, 406, 408, 410)
    8: [8, 2, 1],   # مشاة هجوم/رماح (Infantry Attack - Odd: 401, 403, 405, 407, 409)
    9: [9, 3, 1],   # رماة أسهم/نشاب زوجي (Archers Even: 602, 604, 606, 608, 610)
    10: [10, 3, 1], # رماة أسهم فردي (Archers Odd: 601, 603, 605, 607, 609)
    11: [11, 4, 1], # رماة خيل فردي (Cavalry Odd: 501, 503, 505, 507, 509)
    12: [12, 4, 1], # خيالة اشتباك زوجي (Cavalry Even: 502, 504, 506, 508, 510)
    13: [13, 5, 1], # مركبات حصار فردي (Siege Odd: 701, 703, 705, 707, 709)
    14: [14, 5, 1], # عربات حربية زوجي (Chariots Even: 702, 704, 706, 708, 710)
}

def _get_target_for_armyid(armyid: int) -> int:
    """تحديد الهدف الدقيق للسمات العسكرية بحسب نوع ورتبة الجندي (زوجي/فردي)."""
    aid = int(armyid)
    prefix = aid // 100
    tier = aid % 100
    if prefix == 4:
        return 8 if tier % 2 == 1 else 7
    elif prefix == 5:
        return 11 if tier % 2 == 1 else 12
    elif prefix == 6:
        return 10 if tier % 2 == 1 else 9
    elif prefix == 7:
        return 13 if tier % 2 == 1 else 14
    return 1

# ════════════════════════════════════════════════════════════════════
#  تعريف المباني وأنواع القوات في انتقام السلاطين
# ════════════════════════════════════════════════════════════════════

BUILDING_TROOP_MAP: Dict[str, Dict[str, Any]] = {
    "infantry": {
        "bid": "118",
        "name_ar": "المشاة",
        "name_en": "Infantry",
        "icon": "🛡️",
        "prefix": 400,
        "max_level": 10,
        "queue_type": "1203",
    },
    "cavalry": {
        "bid": "116",
        "name_ar": "الخيالة",
        "name_en": "Cavalry",
        "icon": "🐎",
        "prefix": 500,
        "max_level": 10,
        "queue_type": "1204",
    },
    "archers": {
        "bid": "117",
        "name_ar": "الرماة",
        "name_en": "Archers",
        "icon": "🏹",
        "prefix": 600,
        "max_level": 10,
        "queue_type": "1205",
    },
    "chariots": {
        "bid": "119",
        "name_ar": "العربات",
        "name_en": "Chariots",
        "icon": "🚜",
        "prefix": 700,
        "max_level": 10,
        "queue_type": "1206",
    },
    "fortress": {
        "bid": "120",
        "name_ar": "الفخاخ",
        "name_en": "Traps",
        "icon": "🏰",
        "prefix": 800,
        "max_level": 4,
        "queue_type": "1207",
    },
}

TYPE_ALIASES: Dict[str, str] = {
    # المشاة
    "infantry": "infantry", "مشاة": "infantry", "المشاة": "infantry", "جنود": "infantry", "4": "infantry", "118": "infantry",
    # الخيالة
    "cavalry": "cavalry", "خيالة": "cavalry", "الخيالة": "cavalry", "فرسان": "cavalry", "5": "cavalry", "116": "cavalry",
    # الرماة
    "archers": "archers", "archer": "archers", "اسهم": "archers", "الاسهم": "archers", "الأسهم": "archers", "رماة": "archers", "الرماة": "archers", "6": "archers", "117": "archers",
    # العربات
    "chariots": "chariots", "chariot": "chariots", "عربات": "chariots", "العربات": "chariots", "منجنيق": "chariots", "7": "chariots", "119": "chariots",
    # الفخاخ
    "fortress": "fortress", "traps": "fortress", "trap": "fortress", "فخاخ": "fortress", "الفخاخ": "fortress", "حصن": "fortress", "8": "fortress", "120": "fortress",
}

# مستويات فتح الرتب العسكرية في الثكنات (رسمياً من build118.lua و build119.lua)
TIER_UNLOCK_BUILDING_LEVEL = {
    1: 1, 2: 4, 3: 7, 4: 10, 5: 13,
    6: 16, 7: 19, 8: 22, 9: 26, 10: 30,
    11: 30, 12: 30
}

def get_max_unlocked_tier(building_lv: int) -> int:
    """معرفة أقصى مستوى جندي مفتوح بناءً على مستوى الثكنة."""
    max_t = 1
    for tier, req_lv in TIER_UNLOCK_BUILDING_LEVEL.items():
        if building_lv >= req_lv:
            max_t = max(max_t, tier)
    return max_t


# ════════════════════════════════════════════════════════════════════
#  خرائط الربط ومزامنة الذاكرة الحية (0-Network & Live Memory Sync)
# ════════════════════════════════════════════════════════════════════

# خريطة ربط المباني بأنواع الطوابير الرسمية (من queueTypeDef.lua)
BID_TO_QUEUE_TYPE: Dict[str, str] = {
    "118": "1203",  # مشاة
    "116": "1204",  # خيالة
    "117": "1205",  # رماة
    "119": "1206",  # عربات
    "120": "1207",  # فخاخ / حصن
}

QUEUE_TYPE_TO_BID: Dict[str, str] = {
    "1203": "118",
    "1204": "116",
    "1205": "117",
    "1206": "119",
    "1207": "120",
}

# خريطة ربط المباني بمهام النشاط اليومي الرسمية (من daily_reward_point_config.lua)
BID_TO_DAILY_QUEST: Dict[str, Tuple[str, int]] = {
    "118": ("12", 4100012),  # مشاة
    "117": ("13", 4100013),  # رماة
    "116": ("14", 4100014),  # خيالة
    "119": ("15", 4100015),  # عربات
    "120": ("16", 4100016),  # فخاخ
}


def sync_training_queue_in_memory(
    conn: Any,
    bid: str,
    armyid: int,
    count: int,
    retdata: Optional[Dict[str, Any]] = None,
) -> None:
    """
    مزامنة فورية شاملة لحالة طابور التدريب والنشاط اليومي في الذاكرة الحية (conn.init_data):
      1. إنشاء أو تحديث طابور التدريب في queueCtrl بالمفتاح المناسب (1203..1207).
      2. تحديث كائن armyCtrl.trainArmy لمعرفة وقت الانتهاء والكمية.
      3. خصم الموارد من cityCtrl.reslist.
      4. تحديث عدادات النشاط اليومي في everydayTaskCtrl.eventInfo و questCtrl.point_finish_list.
    """
    if not conn or not hasattr(conn, "init_data") or not isinstance(conn.init_data, dict):
        return

    bid_str = str(bid)
    ret = retdata if isinstance(retdata, dict) else {}
    now_ts = int(time.time())
    qtype = str(ret.get("queuetype") or BID_TO_QUEUE_TYPE.get(bid_str, "1203"))
    total_time = int(ret.get("totaltime") or ret.get("lefttime") or 1800)
    unique_id = ret.get("_uniqueid", int(now_ts * 100))

    # 1. تحديث queueCtrl
    queue_ctrl = conn.init_data.setdefault("queueCtrl", {})
    if isinstance(queue_ctrl, dict):
        queue_entry = {
            "qtype": qtype,
            "starttime": now_ts,
            "totaltime": total_time,
            "ottime": total_time,
            "lefttime": total_time,
            "data": {
                "bid": bid_str,
                "armyid": str(armyid),
                "armycount": str(count),
                "_uniqueid": unique_id,
                "realAddcount": 0,
                "costres": ret.get("costres", []),
            },
        }
        queue_ctrl[qtype] = queue_entry
        # تحديث قائمة queues إذا كانت مستخدمة في الكلاينت
        if "queues" in queue_ctrl and isinstance(queue_ctrl["queues"], list):
            queue_ctrl["queues"] = [
                q for q in queue_ctrl["queues"]
                if isinstance(q, dict) and str(q.get("data", {}).get("bid", "")) != bid_str and str(q.get("qtype", "")) != qtype
            ]
            queue_ctrl["queues"].append(queue_entry)

    # 2. تحديث armyCtrl.trainArmy
    army_ctrl = conn.init_data.setdefault("armyCtrl", {})
    if isinstance(army_ctrl, dict):
        train_map = army_ctrl.setdefault("trainArmy", {})
        if isinstance(train_map, dict):
            train_map[bid_str] = {
                "bid": bid_str,
                "armyid": str(armyid),
                "armycount": str(count),
                "lefttime": total_time,
                "totaltime": total_time,
                "queuetype": qtype,
                "_uniqueid": unique_id,
                "updated_at": now_ts,
            }

    # 3. تحديث وخصم الموارد في cityCtrl
    cost_res = ret.get("costres")
    city = conn.init_data.setdefault("cityCtrl", {})
    if isinstance(city, dict):
        reslist = city.setdefault("reslist", {})
        if isinstance(reslist, dict):
            if isinstance(cost_res, list) and cost_res:
                for cr in cost_res:
                    if isinstance(cr, dict) and "resid" in cr and "curcount" in cr:
                        reslist[str(cr["resid"])] = cr["curcount"]
            else:
                # خصم تقديري بناءً على جدول التكاليف الرسمي المدمج
                costs = _ARMY_COSTS.get(str(armyid), {})
                for resid, per_unit in costs.items():
                    cur_val = float(reslist.get(str(resid), 0) or 0)
                    reslist[str(resid)] = max(0.0, cur_val - (per_unit * count))
            city["resList"] = reslist

    # 4. تحديث everydayTaskCtrl و questCtrl إذا كان التدريب يغطي النشاط اليومي
    ev_type, q_id = BID_TO_DAILY_QUEST.get(bid_str, (None, None))
    if ev_type:
        everyday = conn.init_data.setdefault("everydayTaskCtrl", {})
        if isinstance(everyday, dict):
            ev_info = everyday.setdefault("eventInfo", {})
            if isinstance(ev_info, dict):
                cur_cycles = int(ev_info.get(ev_type, 0) or 0)
                add_cycles = max(1, count // 50)
                new_cycles = min(5, cur_cycles + add_cycles)
                if count >= 250:
                    new_cycles = 5
                ev_info[ev_type] = new_cycles
        if count >= 250 and q_id:
            quest_ctrl = conn.init_data.setdefault("questCtrl", {})
            if isinstance(quest_ctrl, dict):
                pfl = quest_ctrl.setdefault("point_finish_list", [])
                if isinstance(pfl, list):
                    if q_id not in pfl:
                        pfl.append(q_id)
                    if str(q_id) not in pfl:
                        pfl.append(str(q_id))


def clear_harvested_queue_in_memory(conn: Any, bid: str) -> None:
    """
    مسح فوري لطابور التدريب المستلم من الذاكرة الحية (queueCtrl و armyCtrl.trainArmy).
    """
    if not conn or not hasattr(conn, "init_data") or not isinstance(conn.init_data, dict):
        return

    bid_str = str(bid)
    qtype = BID_TO_QUEUE_TYPE.get(bid_str)

    # 1. إزالة من queueCtrl
    queue_ctrl = conn.init_data.get("queueCtrl", {})
    if isinstance(queue_ctrl, dict):
        if qtype and qtype in queue_ctrl:
            queue_ctrl.pop(qtype, None)
        to_del = [
            k for k, v in list(queue_ctrl.items())
            if isinstance(v, dict) and (str(v.get("data", {}).get("bid", "")) == bid_str or str(v.get("qtype", "")) == qtype)
        ]
        for k in to_del:
            queue_ctrl.pop(k, None)

        if "queues" in queue_ctrl and isinstance(queue_ctrl["queues"], list):
            queue_ctrl["queues"] = [
                q for q in queue_ctrl["queues"]
                if isinstance(q, dict) and str(q.get("data", {}).get("bid", "")) != bid_str and str(q.get("qtype", "")) != qtype
            ]

    # 2. إزالة من armyCtrl.trainArmy
    army_ctrl = conn.init_data.get("armyCtrl", {})
    if isinstance(army_ctrl, dict):
        train_map = army_ctrl.get("trainArmy")
        if isinstance(train_map, dict) and bid_str in train_map:
            train_map.pop(bid_str, None)


def check_barracks_busy(conn: Any, bid: str, now_ts: int) -> Tuple[bool, int, str]:
    """
    فحص قبلي شامل ومباشر من الذاكرة الحية (0-Network) هل المبنى مشغول بالتدريب.
    يفحص كلاً من:
      1. queueCtrl (سواء بالنوع 1203..1207 أو bid في data).
      2. armyCtrl.trainArmy (وجود تدريب جارٍ أو لم يستلم بعد).
    يُرجع: (is_busy: bool, remaining_seconds: int, status_description: str)
    """
    bid_str = str(bid)
    qtype = BID_TO_QUEUE_TYPE.get(bid_str)

    if not conn or not hasattr(conn, "init_data") or not isinstance(conn.init_data, dict):
        return False, 0, ""

    # 1. فحص queueCtrl
    queue_ctrl = conn.init_data.get("queueCtrl", {})
    if isinstance(queue_ctrl, dict):
        active_q = None
        if qtype and qtype in queue_ctrl and isinstance(queue_ctrl[qtype], dict):
            active_q = queue_ctrl[qtype]
        if not active_q:
            for k, v in queue_ctrl.items():
                if isinstance(v, dict) and "data" in v:
                    if str(v["data"].get("bid", "")) == bid_str:
                        active_q = v
                        break
        if not active_q and "queues" in queue_ctrl and isinstance(queue_ctrl["queues"], list):
            for q in queue_ctrl["queues"]:
                if isinstance(q, dict) and str(q.get("data", {}).get("bid", "")) == bid_str:
                    active_q = q
                    break

        if active_q:
            st = int(active_q.get("starttime", 0) or 0)
            tt = int(active_q.get("totaltime", 0) or active_q.get("ottime", 0) or 0)
            end_t = st + tt
            if end_t > now_ts:
                rem_s = max(1, end_t - now_ts)
                return True, rem_s, "تدريب نشط في الطابور"
            left_t = int(active_q.get("lefttime", 0) or 0)
            if left_t > 0:
                return True, left_t, "تدريب نشط (lefttime)"
            if st > 0 and end_t <= now_ts:
                return True, 0, "قوات منتهية بانتظار الاستلام"

    # 2. فحص armyCtrl.trainArmy
    army_ctrl = conn.init_data.get("armyCtrl", {})
    if isinstance(army_ctrl, dict):
        train_map = army_ctrl.get("trainArmy", {})
        if isinstance(train_map, dict) and bid_str in train_map:
            t_item = train_map[bid_str]
            if isinstance(t_item, dict):
                left_t = int(t_item.get("lefttime", 0) or 0)
                up_t = int(t_item.get("updated_at", 0) or 0)
                if left_t > 0:
                    if up_t > 0 and now_ts < (up_t + left_t):
                        rem_s = max(1, (up_t + left_t) - now_ts)
                        return True, rem_s, "تدريب نشط (trainArmy)"
                    elif up_t == 0:
                        return True, left_t, "تدريب نشط (trainArmy)"
                return True, 0, "قوات في trainArmy بانتظار الاستلام"

    return False, 0, ""


# ════════════════════════════════════════════════════════════════════
#  كلاس المهمة (TrainTask)
# ════════════════════════════════════════════════════════════════════

class TrainTask(BaseTask):
    """
    مهمة تدريب القوات التلقائية لجميع أنواع الثكنات الأربعة في لعبة انتقام السلاطين:
      - 0 استعلام شبكي قبلي (فحص الذاكرة الحية 100%).
      - جمع واستلام كافة القوات الجاهزة فوراً.
      - تدريب الأنواع المحددة من قبل المستخدم وفق موارده وسعة خيامه.
    """
    name = "train"
    alias = "training"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)
        # استخراج إعدادات التدريب من الإعداد العام أو الخاص
        self.train_cfg = self._extract_train_config()
        self.selected_types, self.target_levels = self._parse_types_and_levels()
        self.requested_count = self.train_cfg.get("count", "max")

    def _extract_train_config(self) -> Dict[str, Any]:
        """استخراج كائن الإعدادات الخاص بمهمة التدريب من config."""
        if not isinstance(self.config, dict):
            return {}
        if "train" in self.config and isinstance(self.config["train"], dict):
            return self.config["train"]
        if "tasks" in self.config and isinstance(self.config["tasks"], dict) and "train" in self.config["tasks"]:
            return self.config["tasks"]["train"]
        return self.config

    def _parse_types_and_levels(self) -> Tuple[List[str], Dict[str, int]]:
        """
        استخراج أنواع القوات والرتبة المطلوبة لكل نوع بدقة وفق رغبة المستخدم:
          - إذا تم تمرير قاموس levels (مثل العثمانية): يتم تدريب كل نوع رتبته > 0 بالرتبة المحددة له تحديداً.
          - إذا كانت القيمة 0، يُعتبر النوع ملغياً ومستبعداً من التدريب.
        """
        levels_cfg = self.train_cfg.get("levels")
        if isinstance(levels_cfg, dict) and levels_cfg:
            selected = []
            target_lvls = {}
            for k, v in levels_cfg.items():
                canon = TYPE_ALIASES.get(str(k).lower())
                if canon and canon in BUILDING_TROOP_MAP:
                    try:
                        lvl_num = int(v)
                        if lvl_num > 0:
                            selected.append(canon)
                            target_lvls[canon] = lvl_num
                    except (ValueError, TypeError):
                        pass
            # إذا تم تمرير قاموس levels صراحة، نعتمد نتيجته بدقة وفق رغبة المستخدم
            return selected, target_lvls

        # طريقة احتياطية في حال تمرير types أو level عام
        default_lvl = int(self.train_cfg.get("level", self.train_cfg.get("unit_level", 10)) or 10)
        raw_types = self.train_cfg.get("types", self.train_cfg.get("type", "all"))
        if not raw_types or str(raw_types).strip().lower() in ("all", "الكل", "all_types"):
            matched_types = list(BUILDING_TROOP_MAP.keys())
        elif isinstance(raw_types, (list, tuple)):
            matched_types = [TYPE_ALIASES.get(str(p).strip().lower()) for p in raw_types if TYPE_ALIASES.get(str(p).strip().lower())]
        elif isinstance(raw_types, str):
            parts = [p.strip().lower() for p in raw_types.replace("،", ",").split(",") if p.strip()]
            matched_types = [TYPE_ALIASES.get(p) for p in parts if TYPE_ALIASES.get(p)]
        else:
            matched_types = list(BUILDING_TROOP_MAP.keys())

        matched_types = [t for t in matched_types if t in BUILDING_TROOP_MAP]
        target_lvls = {t: default_lvl for t in matched_types}
        return matched_types, target_lvls

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع من الذاكرة الحية (0 طلب شبكي)."""
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        if not self.train_cfg.get("enabled", False):
            return False, "مهمة تدريب الجنود معطلة في الإعدادات (اختيارية)"

        if not self.selected_types:
            return False, "لم يتم تحديد أي نوع من القوات للتدريب"

        return True, ""

    def _get_building_info(self, bid: str) -> Tuple[int, int]:
        """استخراج مستوى وحالة المبنى من الذاكرة الحية (cityCtrl.blist)."""
        city_ctrl = self.get_ctrl("cityCtrl")
        blist = city_ctrl.get("blist", []) if isinstance(city_ctrl, dict) else []
        for b in blist:
            if not isinstance(b, dict):
                continue
            binfo = b.get("binfo", b) if isinstance(b.get("binfo"), dict) else b
            if str(binfo.get("bid")) == str(bid):
                return int(binfo.get("lv", 0) or 0), int(binfo.get("state", 0) or 0)
        return 0, 0

    def _calculate_auto_army_count(self, bid: str, armyid: int) -> dict:
        """
        حساب الحد الأقصى التلقائي لعدد القوات الممكن تدريبها بدقة 100% من الذاكرة الحية:
          1. سقف الموارد (طعام، خشب، حديد، فضة).
          2. سعة التدريب القصوى (خيام الجيش + مهارات الأمير + السمات العسكرية).
          3. الناتج = min(canTrain, resTrain).
        """
        aid_str = str(armyid)
        # جدول تكاليف الموارد المعتمد مباشرة في الذاكرة (من armyinfo.lua)
        cost_res = _ARMY_COSTS.get(aid_str, {"1002": 100})

        city_ctrl = self.get_ctrl("cityCtrl")
        reslist = city_ctrl.get("reslist") or city_ctrl.get("resList", {})

        # 1. سقف الموارد (resTrain)
        res_train = 999999999
        missing_res = []
        res_names = {"1002": "طعام", "1003": "خشب", "1004": "حديد", "1005": "فضة", "1006": "ذهب"}

        for resid_str, cost_per_unit in cost_res.items():
            cur_count = float(reslist.get(str(resid_str), 0) or 0)
            if cost_per_unit > 0:
                affordable = int(cur_count // cost_per_unit)
                if affordable < res_train:
                    res_train = affordable
                if affordable == 0:
                    missing_res.append(res_names.get(str(resid_str), str(resid_str)))

        # 2. سعة التدريب القصوى للمبنى (canTrain) وفق خوارزمية اللعبة الرسمية (armyLogic.getMaxTrainCount)
        # خيام الجيش (Military Tents - bid: 205): المستوى الأساسي من build205 + نجوم الهيبة من buildstar205
        tent_cap = 0
        blist = city_ctrl.get("blist", [])
        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                binfo = b.get("binfo", b) if isinstance(b.get("binfo"), dict) else b
                if str(binfo.get("bid")) == "205":
                    lv = int(binfo.get("lv", 1) or 1)
                    slv = int(binfo.get("starLv", 0) or 0)
                    base = _TENT_BASE_CAPACITIES.get(lv, 160 if lv >= 30 else 20)
                    star = _TENT_STAR_CAPACITIES.get(slv, 0)
                    tent_cap += (base + star)

        # مهارات ومواهب الأمير (Lord Skills) للتدريب الفردي (buffType 44) من skill.lua
        lord_skills = self.get_ctrl("lordSkillCtrl")
        active_set = str(lord_skills.get("activeSetID", "1")) if isinstance(lord_skills, dict) else "1"
        set_data = lord_skills.get("setListData", {}) if isinstance(lord_skills, dict) else {}
        curr_set = set_data.get(active_set) or set_data.get(int(active_set) if active_set.isdigit() else 1) or {}
        s_list = curr_set.get("list", {}) if isinstance(curr_set, dict) else {}
        if not s_list:
            sb = self.get_ctrl("lordInfoCtrl").get("skill", {}).get("skillBasic", {})
            s_list = {k: (v[1] if isinstance(v, list) and len(v) > 1 else v) for k, v in sb.items()} if isinstance(sb, dict) else {}

        # 13003: كمية التدريب I (مستويات 1-5 -> 25 إلى 125)
        # 13011: كمية التدريب II (مستويات 1-20 -> 30 إلى 600)
        # 13023: كمية التدريب III (مستويات 1-20 -> 30 إلى 600)
        # 13037: كمية التدريب IV (مستويات 1-30 -> 25 إلى 750)
        skill_add = (
            min(5, int(s_list.get("13003", 0) or 0)) * 25 +
            min(20, int(s_list.get("13011", 0) or 0)) * 30 +
            min(20, int(s_list.get("13023", 0) or 0)) * 30 +
            min(30, int(s_list.get("13037", 0) or 0)) * 25
        )

        # بافات التدريب الفردي النشطة من العتاد و VIP والأوسمة (buffCtrl رمز 322 / 318)
        buff_ctrl = self.get_ctrl("buffCtrl")
        buff_add = 0
        if isinstance(buff_ctrl, dict):
            for k, v in buff_ctrl.items():
                if k in ("322", "318"):
                    try:
                        buff_add += int(float(v))
                    except (ValueError, TypeError):
                        pass
                elif isinstance(v, dict):
                    for sub_k, sub_v in v.items():
                        if sub_k in ("322", "318"):
                            try:
                                buff_add += int(float(sub_v))
                            except (ValueError, TypeError):
                                pass

        # سمات التدريب للمبنى من boeAttributeCtrl (السمة 13: BUILDING_TRAIN_NUM)
        attr_bonus = 0.0
        boe_attr = self.get_ctrl("boeAttributeCtrl")
        if isinstance(boe_attr, dict):
            mod0 = boe_attr.get("0", {})
            if isinstance(mod0, dict):
                b_entry = mod0.get(str(bid), {})
                if isinstance(b_entry, dict):
                    val_13 = b_entry.get("13", {})
                    if isinstance(val_13, dict):
                        attr_bonus += float(val_13.get("2", 0) or 0)

        # أدوات وبنود زيادة التدريب الفردي
        army_ctrl = self.get_ctrl("armyCtrl")
        tool_info = army_ctrl.get("singleTrainAddInfo", {}) if isinstance(army_ctrl, dict) else {}
        tool_add = int(tool_info.get("addCount", 0) or 0) if isinstance(tool_info, dict) and int(tool_info.get("itemCount", 0) or 0) > 0 else 0

        # القيمة الابتدائية الأساسية للعبة
        base_count = 10
        can_train = base_count + tent_cap + skill_add + buff_add + int(attr_bonus) + tool_add
        final_count = min(can_train, res_train)
        has_enough_res = (res_train >= 1)

        return {
            "armyid": armyid,
            "bid": str(bid),
            "can_train_cap": can_train,
            "res_train_cap": res_train,
            "final_armycount": max(1, final_count) if has_enough_res else 0,
            "has_enough_resources": has_enough_res,
            "missing_resources": missing_res,
        }

    async def _harvest_all_ready_barracks(self, now_ts: int) -> List[Dict[str, Any]]:
        """
        فحص شامل لكافة الثكنات واستلام القوات المكتملة فوراً (0-Network Check):
        يقرأ من trainArmy و queueCtrl مباشرة، ويمسح الطابور من الذاكرة الحية فور نجاح الاستلام.
        """
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، إيقاف استلام القوات.")
            return []

        harvested = []
        army_ctrl = self.get_ctrl("armyCtrl")
        train_army = army_ctrl.get("trainArmy", {}) if isinstance(army_ctrl, dict) else {}
        if not isinstance(train_army, dict):
            train_army = {}

        queue_ctrl = self.get_ctrl("queueCtrl")
        queues = queue_ctrl.get("queues", []) if isinstance(queue_ctrl, dict) else []
        # تحويل طوابير التدريب لقائمة يمكن البحث فيها
        q_map: Dict[str, Dict[str, Any]] = {}
        if isinstance(queue_ctrl, dict):
            for k, v in queue_ctrl.items():
                if isinstance(v, dict) and "data" in v:
                    b_id = str(v["data"].get("bid", ""))
                    if b_id:
                        q_map[b_id] = v
        if isinstance(queues, list):
            for q in queues:
                if isinstance(q, dict) and "data" in q:
                    b_id = str(q["data"].get("bid", ""))
                    if b_id:
                        q_map[b_id] = q

        all_bids = ["116", "117", "118", "119", "120"]
        bid_to_meta = {meta["bid"]: meta for meta in BUILDING_TROOP_MAP.values()}

        for bid in all_bids:
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚠️ انقطع الاتصال بالبوابة أثناء استلام القوات، التوقف فوراً.")
                break

            meta = bid_to_meta.get(bid, {})
            b_name = meta.get("name_ar", f"مبنى {bid}")
            b_icon = meta.get("icon", "🏛️")

            is_ready = False
            ready_info = {}

            # 1. فحص trainArmy بالذاكرة الحية
            if bid in train_army and train_army[bid]:
                t_item = train_army[bid]
                if isinstance(t_item, dict):
                    up_t = int(t_item.get("updated_at", 0) or 0)
                    left_t = int(t_item.get("lefttime", 0) or 0)
                    if left_t == 0 or (up_t > 0 and now_ts >= (up_t + left_t)):
                        is_ready = True
                        ready_info = t_item

            # 2. فحص طابور التدريب queueCtrl
            if not is_ready and bid in q_map:
                qdata = q_map[bid]
                st = int(qdata.get("starttime", 0) or 0)
                tt = int(qdata.get("totaltime", 0) or qdata.get("ottime", 0) or 0)
                if st + tt > 0 and now_ts >= (st + tt):
                    is_ready = True
                    ready_info = {
                        str(qdata.get("data", {}).get("armyid", "")): str(qdata.get("data", {}).get("armycount", ""))
                    }

            if is_ready:
                self.log(f"📦 وُجدت قوات جاهزة للاستلام في {b_icon} [{b_name}]! جاري الاستلام...")
                resp = await self.safe_query("1005", "5", {"bid": str(bid)}, min_delay=0.4, max_delay=0.8)
                err = str(resp.get("err", "-1")) if resp else "timeout"

                if err == "0":
                    self.log(f"✅ تم بنجاح جمع واستلام القوات الجاهزة من {b_icon} [{b_name}]! 🎖️")
                    harvested.append({
                        "type": b_name,
                        "bid": bid,
                        "details": ready_info
                    })
                    # تحديث ومسح الطابور فوراً من الذاكرة الحية لإتاحة المبنى للتدريب (In-Memory Harvesting Sync)
                    clear_harvested_queue_in_memory(self.conn, bid)
                    if bid in train_army:
                        del train_army[bid]
                    if bid in q_map:
                        del q_map[bid]
                else:
                    self.log(f"⚠️ فشل استلام القوات من {b_name} (كود: {err})")

                await asyncio.sleep(round(random.uniform(0.8, 1.4), 2))

        return harvested

    async def _train_adaptive(self, bid: str, armyid: int, initial_count: int) -> Tuple[bool, int, str]:
        """
        إرسال طلب بدء التدريب مع حماية الاتصال والسعة والتحديث الفوري للذاكرة الحية:
          - فحص اتصال فوري وإلغاء فوري عند الانقطاع أو انعدام السعة.
          - عند النجاح: مزامنة فورية للذاكرة الحية (queueCtrl, armyCtrl, cityCtrl, everydayTaskCtrl, questCtrl).
          - في حال الخطأ 4004/4003 ينخفض بنسبة 15% ويعيد المحاولة (حد أقصى مرتين).
          - في حال الخطأ 4002 أو 4001: إلغاء فوري بدون تكرار.
        """
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة قبل إرسال طلب التدريب.")
            return False, 0, "انقطاع الاتصال بالبوابة"

        if initial_count <= 0:
            return False, 0, "السعة القصوى المتاحة 0"

        curr_count = initial_count
        attempts = 0
        max_attempts = 3
        last_err = ""

        while curr_count >= 1 and attempts < max_attempts:
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚠️ انقطع الاتصال بالبوابة أثناء محاولة التدريب، التوقف فوراً دون إعادة محاولة.")
                return False, 0, "انقطاع الاتصال بالبوابة"

            attempts += 1
            payload = {
                "bid": str(bid),
                "armyid": str(armyid),
                "armycount": str(curr_count),
                "mode": "0",
                "isget": False,
            }

            resp = await self.safe_query("1005", "2", payload, min_delay=0.4, max_delay=0.8)
            if resp is None:
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    self.log("⚠️ انقطع الاتصال بالبوابة أثناء طلب التدريب، التوقف فوراً.")
                    return False, 0, "انقطاع الاتصال بالبوابة"
                err = "timeout"
            else:
                err = str(resp.get("err", "-1"))
            last_err = err

            if err == "0":
                retdata = resp.get("retdata") if isinstance(resp, dict) else {}
                if not isinstance(retdata, dict):
                    retdata = resp.get("data") if isinstance(resp.get("data"), dict) else {}
                # مزامنة فورية شاملة في الذاكرة الحية
                sync_training_queue_in_memory(self.conn, bid, armyid, curr_count, retdata)
                return True, curr_count, "0"

            elif err == "4002":
                # وضع علامة انشغال فورية بالذاكرة لمنع أي تكرار
                sync_training_queue_in_memory(self.conn, bid, armyid, curr_count, {"lefttime": 1800, "totaltime": 1800})
                return False, 0, "الثكنة مشغولة بعملية تدريب جارية حالياً"

            elif err == "4001":
                return False, 0, "رتبة الجندي غير مفتوحة أو مستوى الثكنة غير كافٍ"

            elif err in ("4004", "4003"):
                step = max(5, int(curr_count * 0.15))
                curr_count = max(0, curr_count - step)
                if curr_count <= 0:
                    return False, 0, f"تجاوز السعة القصوى المتاحة (كود {err})"
                self.log(f"⚠️ تجاوز طاقة السيرفر (كود {err})، إعادة المحاولة بالعدد المخفض: {curr_count}...")

            elif err == "timeout":
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    return False, 0, "انقطاع الاتصال بالبوابة"
                self.log("⚠️ مهلة السيرفر انتهت (timeout)، محاولة تخفيض العدد...")
                curr_count = max(0, curr_count - 10)
                if curr_count <= 0:
                    return False, 0, "تجاوز السعة بعد انتهاء المهلة (timeout)"
            else:
                return False, 0, f"كود سيرفر: {err}"

            await asyncio.sleep(round(random.uniform(1.0, 1.6), 2))

        return False, 0, f"تجاوز السعة القصوى المتاحة (كود: {last_err})"

    async def run(self) -> TaskResult:
        """دورة التدريب العسكري الموحدة (صفر طلبات شبكية استباقية)."""
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، إيقاف مهمة التدريب فوراً.")
            return TaskResult.fail("انقطاع الاتصال بالبوابة")

        now_ts = int(time.time())

        # ════════════════════════════════════════════════════════════════
        # المرحلة 1: جمع واستلام القوات المكتملة في كافة الثكنات
        # ════════════════════════════════════════════════════════════════
        collected_summary = await self._harvest_all_ready_barracks(now_ts)
        if collected_summary:
            self.log(f"🎉 تم جمع القوات الجاهزة من {len(collected_summary)} مبنى بنجاح!")
            await asyncio.sleep(1.0)

        # ════════════════════════════════════════════════════════════════
        # المرحلة 2: بدء تدريب القوات للأنواع المطلوبة من المستخدم
        # ════════════════════════════════════════════════════════════════
        self.log(f"🪖 بدء فحص تدريب الجيش | الثكنات المحددة: {len(self.selected_types)} ثكنة...")

        trained_summary: List[Dict[str, Any]] = []
        busy_summary: List[Dict[str, Any]] = []

        for t_key in self.selected_types:
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، التوقف فوراً عن فحص بقية الثكنات.")
                break

            meta = BUILDING_TROOP_MAP.get(t_key)
            if not meta:
                continue

            bid = meta["bid"]
            b_name = meta["name_ar"]
            b_icon = meta["icon"]

            b_lv, b_state = self._get_building_info(bid)
            if b_lv <= 0:
                self.log(f"⚠️ المبنى {b_icon} [{b_name}] (bid={bid}) غير مبني في القلعة.")
                continue

            # فحص استباقي شامل لانشغال الثكنة من الذاكرة الحية (0-Network Pre-flight لمنع خطأ 4002)
            is_busy, rem_s, busy_desc = check_barracks_busy(self.conn, bid, now_ts)
            if is_busy:
                rem_m = max(1, rem_s // 60) if rem_s > 0 else 0
                if rem_s > 0:
                    self.log(f"⏳ {b_icon} [{b_name}] قيد التدريب حالياً (متبقي: {rem_m} دقيقة) — تم التخطي (0-Network).")
                else:
                    self.log(f"⏳ {b_icon} [{b_name}] غير متاح حالياً ({busy_desc}) — تم التخطي (0-Network).")
                busy_summary.append({"type": b_name, "bid": bid, "remaining_seconds": rem_s})
                continue

            # تحديد رتبة الجندي المتاحة
            target_level = self.target_levels.get(t_key, 10)
            max_unlocked_tier = get_max_unlocked_tier(b_lv)
            effective_tier = min(target_level, max_unlocked_tier)

            prefix = meta["prefix"]
            armyid = prefix + effective_tier

            # حساب الحد الأقصى للموارد والسعة من الذاكرة الحية
            calc = self._calculate_auto_army_count(bid, armyid)
            if not calc["has_enough_resources"]:
                missing_str = ", ".join(calc["missing_resources"]) if calc["missing_resources"] else "الموارد"
                self.log(f"⚠️ تعذر تدريب {b_name} لعدم كفاية الموارد (نقص في: {missing_str})")
                continue

            if str(self.requested_count).lower() == "max":
                initial_count = calc["final_armycount"]
            else:
                try:
                    initial_count = min(int(self.requested_count), calc["final_armycount"])
                except Exception:
                    initial_count = calc["final_armycount"]

            if initial_count <= 0:
                self.log(f"⚠️ العدد المحسوب لتدريب {b_name} هو 0، تم التخطي (0-Network).")
                continue

            self.log(f"🚀 بدء تدريب {b_icon} [{b_name}] (مستوى {effective_tier}) | المستهدف: {initial_count} وحدة...")
            success, actual_count, err_reason = await self._train_adaptive(bid, armyid, initial_count)

            if success:
                self.log(f"✅ تم بدء تدريب {actual_count} وحدة من {b_icon} [{b_name}] (مستوى {effective_tier}) بنجاح! 🎉")
                trained_summary.append({
                    "type": b_name,
                    "bid": bid,
                    "armyid": armyid,
                    "level": effective_tier,
                    "count": actual_count,
                })
            else:
                self.log(f"⚠️ تعذر بدء تدريب {b_name} (السبب: {err_reason})")
                if err_reason == "انقطاع الاتصال بالبوابة":
                    break

            await asyncio.sleep(round(random.uniform(1.2, 2.0), 2))

        parts = []
        if collected_summary:
            parts.append(f"تم جمع القوات من {len(collected_summary)} مبنى")
        if trained_summary:
            parts.append(f"تم تدريب {len(trained_summary)} أنواع قوات جديدة")
        if busy_summary:
            parts.append(f"({len(busy_summary)} مبانٍ قيد التدريب)")

        msg = " | ".join(parts) if parts else "لم يتطلب الأمر أي تدريب (كافة المباني مشغولة أو لا تتوفر موارد)."
        self.log(f"🏁 {msg}")

        return TaskResult.ok(
            msg,
            data={
                "collected": collected_summary,
                "trained": trained_summary,
                "busy": busy_summary,
            }
        )
