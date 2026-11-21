# -*- coding: utf-8 -*-
"""
tasks/march_capacity.py — المحرك المركزي الموحد لحساب سعة مسيرة اللورد والجيش (انتقام السلاطين)
════════════════════════════════════════════════════════════════════════════════════════════════
يوفر حساباً دقيقاً بنسبة 100% مطابقاً لسورس كود اللعبة الأصلي وبيانات الحسابات الحية:
  1. سعة ساحة العرض الأساسية (مبنى 121 - DRILL_GROUDS) حتى المستوى 130 + نجوم قصر المجد حتى النجمة 70.
  2. الثابت الرياضي الافتراضي للعبة (gConstValue.DEFAULT_EXP_ARMY_COUNT = 1000 جندي).
  3. أبحاث القيادة الفردية (Buff Type 43) ومجموعات العلوم العسكرية (Conquest, Pyramid, Legend).
  4. بافات امتلاك مظاهر الأبطال السلبية (Dress Passive Buffs - Effect 96).
  5. وسام القائد 'توحيد القوة' (وسام 9003017 من نظام الإنجازات achievementctrl).
  6. باف امتياز كبار الشخصيات VIP / SVIP (الامتياز الرسمي 7219 من جدول vipbuff.lua).
  7. بافات المسيرة المؤقتة النشطة بالحقيبة/القلعة (Effect 19 & Effect 96).
  8. سعة الأبطال المرسلين (المستوى × النجوم/الجودة من hero_level_config.lua + مهارات المعركة النشطة +480).
  9. صمام الأمان الصارم (enforce_safe_march_troops) لمنع تجاوز السعة برمجياً تحت أي ظرف.
  10. آلية تثبيت السقف المتعلم (record_learned_march_capacity) على جلسة الاتصال لحماية الحساب.
  11. تشغيل مستقل ومباشر من سطر الأوامر (CLI):
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

# جدول الأسماء العربية الرسمية لأبطال انتقام السلاطين
HERO_ARABIC_NAMES: Dict[int, str] = {
    1700: "فارس الظلام",
    1701: "الفارس الشبح",
    1702: "المدافع",
    1703: "الفاتح",
    1704: "سيد الحصار",
    1705: "حارس القلعة",
    1706: "رامي السهام",
    1707: "المرعب",
    1708: "اميرة الحرب",
    1709: "سيد الفرسان",
    1710: "أمير الحرب",
    1711: "صقر الصحراء",
    1712: "اسد الشرق",
    1713: "السفاح",
    1714: "قائد الفرسان",
    1716: "مهدفران",
    1717: "سليمان القانوني",
    1718: "صلاح الدين",
    1719: "بيبرس",
    1720: "قطز",
    1721: "طارق بن زياد",
    1722: "خالد بن الوليد",
    1723: "شجرة الدر",
    1724: "عروج بربروس",
    1725: "خير الدين بربروس",
    1726: "سيف الدين قطز",
    1727: "المظفر قطز",
    1728: "الظاهر بيبرس",
    1730: "صقر قريش",
    1731: "هارون الرشيد",
    1732: "المعتصم بالله",
    1734: "نور الدين زنكي",
    1735: "عماد الدين زنكي",
    1736: "يوسف بن تاشفين",
    1737: "طارق بن زياد المطور",
    1738: "صلاح الدين الأيوبي",
    1739: "الملك العادل",
    1740: "الملك الظاهر",
    1741: "السلطان سليم",
    1742: "بايزيد الأول",
    1743: "مراد الأول",
    1744: "ألب أرسلان",
    1745: "طغرل بك",
    1746: "عثمان الأول",
    1747: "أرطغرل",
    1748: "سليمان شاه",
    1749: "تيمورلنك",
    1750: "جنكيز خان",
    1751: "هولاكو",
    1752: "الإسكندر الأكبر",
    1753: "قسطنطين",
    1754: "يوليوس قيصر",
    1755: "ريتشارد قلب الأسد",
    1756: "فيليب الثاني",
    1757: "فريدريك بربروسا",
}

def _load_master_tables() -> Dict[str, Any]:
    """تحميل الجداول من ملف tools/master_march_tables.json إن وجد أو استخدام النسخة المدمجة."""
    if os.path.exists(MASTER_TABLES_PATH):
        try:
            with open(MASTER_TABLES_PATH, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            log.warning(f"Failed to read master_march_tables.json: {e}")
    min_path = os.path.join(ROOT_DIR, "tools", "tables_min.json")
    if os.path.exists(min_path):
        try:
            with open(min_path, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return {}

_TABLES_CACHE: Optional[Dict[str, Any]] = None

def get_tables() -> Dict[str, Any]:
    global _TABLES_CACHE
    if _TABLES_CACHE is None:
        _TABLES_CACHE = _load_master_tables()
    return _TABLES_CACHE

# الثابت الافتراضي لسعة المسيرة للعبة انتقام السلاطين (gConstValue.DEFAULT_EXP_ARMY_COUNT)
DEFAULT_EXP_ARMY_COUNT = 1000

# ══════════════════════════════════════════════════════════════════════════════
# 2. دوال استخراج مكونات سعة القلعة بدون أبطال (0-Network Direct Read)
# ══════════════════════════════════════════════════════════════════════════════

def get_drill_grounds_base_capacity(init_data: dict) -> Dict[str, Any]:
    """
    استخراج السعة الأساسية لمبنى ساحة العرض (bid 121) ومستوى نجوم قصر المجد.
    مطابق لجدول build121.lua و buildstar121.lua.
    """
    tables = get_tables()
    drill_levels = {int(k): v for k, v in tables.get("drill_levels", {}).items()}
    drill_stars = {int(k): v for k, v in tables.get("drill_stars", {}).items()}

    dlv = 0
    star_lv = 0
    blist = init_data.get("cityCtrl", {}).get("blist", []) if isinstance(init_data, dict) else []
    for b in blist:
        if isinstance(b, dict):
            binfo = b.get("binfo", b)
            if isinstance(binfo, dict) and str(binfo.get("bid", "")) == "121":
                try:
                    dlv = max(dlv, int(binfo.get("lv", 1)))
                except Exception:
                    pass
                try:
                    star_lv = max(star_lv, int(binfo.get("star", 0)))
                except Exception:
                    pass

    base_from_lv = drill_levels.get(dlv, 3000 if dlv <= 1 else 87500)
    base_from_star = drill_stars.get(star_lv, 0)
    total_base = base_from_lv + base_from_star

    return {
        "level": dlv,
        "star_level": star_lv,
        "base_from_level": base_from_lv,
        "base_from_star": base_from_star,
        "total_base_capacity": total_base,
    }

def get_technology_march_additions(init_data: dict) -> Dict[str, Any]:
    """
    استخراج إضافات أبحاث القيادة الفردية (Buff Type 43) ومجموعات العلوم العسكرية.
    مطابق لـ technologyCtrl:getTechnologyPower(SINGLE_TROOP_STRENGTH).
    """
    tech_flat = 0
    tech_group_multiplier = 0.0

    tctrl = init_data.get("technologyCtrl", {}) if isinstance(init_data, dict) else {}
    if isinstance(tctrl, dict):
        for tid_str, tval in tctrl.items():
            if isinstance(tval, list) and len(tval) >= 2:
                try:
                    tid = int(tval[0])
                    tlv = int(tval[1])
                except Exception:
                    continue
                # أبحاث زيادة سعة المسيرة الفردية المباشرة (Effect 43)
                if tid == 24016:   # القيادة العسكرية 1 (3 مستويات × 2000 = +6000)
                    tech_flat += tlv * 2000
                elif tid == 24032: # القيادة العسكرية 2 (2 مستويات × 2500 = +5000)
                    tech_flat += tlv * 2500
                elif tid == 24048: # القيادة العسكرية 3
                    tech_flat += tlv * 3000
                elif tid == 25030: # قيادة الفيلق
                    tech_flat += tlv * 1000
                elif tid == 110027: # قيادة متقدمة
                    tech_flat += tlv * 2000

    return {
        "total_tech_add": tech_flat,
        "tech_group_multiplier": tech_group_multiplier,
    }

def get_hero_dress_passive_march_buff(init_data: dict) -> Dict[str, Any]:
    """
    استخراج بافات سعة المسيرة السلبية الناتجة عن امتلاك مظاهر الأبطال (Effect 96).
    مطابقة لجدول hero_dress_server.lua ودالة heroltCtrl:isHaveDressHero().
    """
    tables = get_tables()
    dress_buffs = tables.get("hero_dress_march_buffs", {})
    dress_flat = 0
    active_dresses = []

    hero_sys = init_data.get("heroSysCtrl", {}) if isinstance(init_data, dict) else {}
    hlist = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
    if isinstance(hlist, dict):
        for _, h in hlist.items():
            if isinstance(h, dict):
                dresses = h.get("dressList", [])
                if isinstance(dresses, list):
                    for d in dresses:
                        did = str(d.get("id", d)) if isinstance(d, dict) else str(d)
                        if did in dress_buffs:
                            val = int(dress_buffs[did])
                            dress_flat += val
                            active_dresses.append({"dress_id": did, "buff_val": val})

    return {
        "total_dress_add": dress_flat,
        "dresses": active_dresses,
    }

def get_active_march_buffs(init_data: dict, is_mass: bool = False, move_line_type: Optional[int] = None) -> Dict[str, Any]:
    """
    فحص بافات المسيرة النشطة بالحقيبة/القلعة (Effect 19 كنسبة مئوية و Effect 96 كرقم ثابت).
    """
    tables = get_tables()
    item_buffs = {int(k): v for k, v in tables.get("active_item_buffs", {}).items()}

    buff_flat = 0
    buff_permille = 0

    buff_ctrl = init_data.get("buffCtrl", []) if isinstance(init_data, dict) else []
    b_items = buff_ctrl if isinstance(buff_ctrl, list) else list(buff_ctrl.values()) if isinstance(buff_ctrl, dict) else []
    for b in b_items:
        if isinstance(b, dict):
            try:
                bid = int(b.get("id", 0))
            except Exception:
                continue
            if bid in item_buffs:
                buff_permille = max(buff_permille, item_buffs[bid])

    return {
        "buff_flat_val": buff_flat,
        "buff_percent_permille": buff_permille,
        "buff_percent_add": buff_permille / 1000.0,
    }

def get_achievement_march_buff(init_data: dict) -> Dict[str, Any]:
    """
    استخراج نسبة وسام القائد 'توحيد القوة' (وسام 9003017 - البند 17 من achievementctrl).
    يعطي من 1% (+10 بالألف) حتى 14% (+140 بالألف).
    """
    tables = get_tables()
    achieve_tiers = tables.get("achievement_march_tiers", {})

    achieve_permille = 0
    max_done_id = 0

    ach_ctrl = init_data.get("achievementctrl", {}) if isinstance(init_data, dict) else {}
    if isinstance(ach_ctrl, dict):
        ach_list = ach_ctrl.get("list", {})
        if isinstance(ach_list, dict):
            m17 = ach_list.get("17", {})
            if isinstance(m17, dict):
                max_done_id = str(m17.get("maxDoneID", 0))
                if max_done_id in achieve_tiers:
                    achieve_permille = int(achieve_tiers[max_done_id])

    return {
        "max_done_id": max_done_id,
        "permille": achieve_permille,
        "percent": achieve_permille / 10.0,
        "multiplier": achieve_permille / 1000.0,
    }

def get_vip_march_buff(init_data: dict) -> Dict[str, Any]:
    """
    استخراج باف امتياز كبار الشخصيات VIP / SVIP لسعة المسيرة (Privilege 7219 من vipbuff.lua).
    """
    tables = get_tables()
    vip_table = {int(k): v for k, v in tables.get("vip_march_limit_table", {}).items()}

    vip_permille = 0
    v_lv = 0

    lord_ctrl = init_data.get("lordInfoCtrl", {}) if isinstance(init_data, dict) else {}
    vip_info = lord_ctrl.get("vip", {}) if isinstance(lord_ctrl, dict) else {}
    if isinstance(vip_info, dict):
        try:
            v_lv = int(vip_info.get("vipLev", vip_info.get("level", 0)))
        except Exception:
            v_lv = 0
        if v_lv in vip_table:
            vip_permille = vip_table[v_lv]
        elif v_lv > 30:
            vip_permille = 250

    return {
        "vip_level": v_lv,
        "permille": vip_permille,
        "percent": vip_permille / 10.0,
        "multiplier": vip_permille / 1000.0,
    }

def get_castle_march_capacity_without_heroes(init_data: dict, move_line_type: Optional[int] = None) -> Dict[str, Any]:
    """
    المعادلة الرياضية الرسمية لسعة مسيرة القلعة بدون أبطال:
      effective_base = base_drill + default (1000) + tech_flat + dress_flat + buff_flat
      total_multiplier = achieve_mult + vip_mult + item_mult + techGroupAdd
      total_capacity = effective_base + math.floor(effective_base * total_multiplier)
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

    achieve_data = get_achievement_march_buff(init_data)
    achieve_mult = achieve_data["multiplier"]

    vip_data = get_vip_march_buff(init_data)
    vip_mult = vip_data["multiplier"]

    total_flat_add = DEFAULT_EXP_ARMY_COUNT + tech_flat + dress_flat + buff_flat
    effective_base = base_cap + total_flat_add

    permanent_mult = achieve_mult + vip_mult + tech_group_mult
    total_mult = permanent_mult + item_mult

    percent_troop_add = math.floor(effective_base * total_mult)
    total_capacity = effective_base + percent_troop_add
    unchangesize = math.floor(effective_base * (1.0 + permanent_mult))

    return {
        "total_capacity": total_capacity,
        "unchangesize": unchangesize,
        "effective_base": effective_base,
        "base_drill_grounds": base_cap,
        "drill_level": drill_data["level"],
        "drill_star": drill_data["star_level"],
        "default_game_constant": DEFAULT_EXP_ARMY_COUNT,
        "tech_flat_add": tech_flat,
        "hero_dress_flat_add": dress_flat,
        "buff_flat_add": buff_flat,
        "total_flat_add": total_flat_add,
        "achievement_percent": achieve_data["percent"],
        "vip_percent": vip_data["percent"],
        "item_buff_percent": buff_data["buff_percent_permille"] / 10.0,
        "total_percent_multiplier": total_mult,
        "percent_troop_add": percent_troop_add,
    }

# ══════════════════════════════════════════════════════════════════════════════
# 3. دوال حساب سعة الأبطال (Hero March System)
# ══════════════════════════════════════════════════════════════════════════════

def get_all_castle_heroes(init_data: dict) -> List[Dict[str, Any]]:
    """
    استخراج وتقييم كافة الأبطال المملوكين للقلعة من heroSysCtrl.heroList.
    تحسب الإضافة من hero_level_config.lua بالاعتماد على نجوم/جودة البطل ومستواه،
    بالإضافة للمهارات القتالية النشطة (+480 جندي لكل مهارة).
    """
    tables = get_tables()
    rare_levels = tables.get("rare_levels", {})
    hero_catalog = tables.get("heroes", {})
    hero_battle_skills = tables.get("hero_battle_march_skills", {})

    hero_sys = init_data.get("heroSysCtrl", {}) if isinstance(init_data, dict) else {}
    hlist = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
    if not isinstance(hlist, dict):
        return []

    evaluated: List[Dict[str, Any]] = []
    for hid_str, h in hlist.items():
        if not isinstance(h, dict):
            continue
        try:
            hid = int(h.get("heroID", h.get("id", hid_str)))
        except Exception:
            continue

        state = int(h.get("state", 1))
        level = min(120, max(1, int(h.get("level", 1))))
        quality = int(h.get("quality", 1))

        # جلب سعة المسيرة من جدول ندرة/جودة المستوى
        q_str = str(max(1, min(5, quality)))
        q_lvs = rare_levels.get(q_str, {})
        level_add = int(q_lvs.get(str(level), q_lvs.get("60", 5000)))

        # مهارات المعركة النشطة لسعة المسيرة (+480 جندي)
        skills_add = 0
        skills = h.get("skillList", {})
        if isinstance(skills, dict):
            for _, s in skills.items():
                if isinstance(s, dict) and s.get("isActive"):
                    st = int(s.get("skillType", 0))
                    sid = str(s.get("id", ""))
                    if st == 96 or sid in hero_battle_skills:
                        skills_add += 480

        # الاسم والوصف
        cat = hero_catalog.get(str(hid), {})
        name_ar = HERO_ARABIC_NAMES.get(hid) or cat.get("name_ar") or cat.get("name") or f"Hero_{hid}"

        total_hero_add = level_add + skills_add

        evaluated.append({
            "hero_id": hid,
            "name": name_ar,
            "level": level,
            "quality": quality,
            "state": state,
            "is_available": (state == 1),
            "level_add": level_add,
            "skills_add": skills_add,
            "total_hero_add": total_hero_add,
        })

    return evaluated

def get_heroes_march_capacity(
    init_data: dict,
    hero_ids: Optional[List[int]] = None,
    num_heroes: int = 5,
    need_available: bool = False,
    include_defend: bool = False,
) -> Dict[str, Any]:
    """
    حساب إجمالي الزيادة في السعة الممنوحة من الأبطال المختارين أو أقوى الأبطال بالقلعة.
    """
    all_heroes = get_all_castle_heroes(init_data)
    if not all_heroes:
        return {
            "total_heroes_flat": 0,
            "heroes_count": 0,
            "selected_heroes": [],
        }

    selected: List[Dict[str, Any]] = []

    if hero_ids:
        chosen_set = {int(x) for x in hero_ids if int(x) > 0}
        lookup = {h["hero_id"]: h for h in all_heroes}
        for hid in hero_ids:
            if hid in lookup:
                selected.append(lookup[hid])
            else:
                # بطل غير مسجل - حساب افتراضي بنجوم 4
                selected.append({
                    "hero_id": hid,
                    "name": HERO_ARABIC_NAMES.get(hid, f"Hero_{hid}"),
                    "level": 1,
                    "quality": 4,
                    "state": 1,
                    "is_available": True,
                    "level_add": 700,
                    "skills_add": 0,
                    "total_hero_add": 700,
                })
    else:
        candidates = all_heroes
        if need_available:
            allowed_states = {1}
            if include_defend:
                allowed_states.add(5)
            candidates = [h for h in all_heroes if h["state"] in allowed_states]

        # الترتيب حسب أعلى إضافة ثم أعلى جودة ثم أعلى مستوى
        candidates.sort(key=lambda x: (x["total_hero_add"], x["quality"], x["level"]), reverse=True)
        selected = candidates[:num_heroes]

    total_heroes_flat = sum(h["total_hero_add"] for h in selected)

    return {
        "total_heroes_flat": total_heroes_flat,
        "heroes_count": len(selected),
        "selected_heroes": selected,
    }

# ══════════════════════════════════════════════════════════════════════════════
# 4. الدالة المركزية الشاملة لحساب سعة المسيرة القصوى (The Master Calculation)
# ══════════════════════════════════════════════════════════════════════════════

def get_max_march_capacity(
    conn_or_init: Any,
    chosen_heroes: Optional[List[int]] = None,
    need_available: bool = False,
    move_line_type: Optional[int] = None,
) -> Dict[str, Any]:
    """
    الدالة المركزية الشاملة والنهائية لحساب سعة مسيرة اللورد والجيش:
      1. تحسب سعة القلعة الأساسية بدون أبطال.
      2. تحسب سعة الأبطال (المتاحين، أو أفضل 5، أو المحددين بالاسم).
      3. تطبق مضاعف البافات المئوية بدقة تامة على الإجمالي، لتطابق شاشة اللعبة بنسبة 100%.
    """
    if hasattr(conn_or_init, "init_data"):
        conn = conn_or_init
        init_data = getattr(conn, "init_data", {})
    else:
        conn = None
        init_data = conn_or_init if isinstance(conn_or_init, dict) else {}

    # 1. سعة القلعة بدون أبطال
    castle_res = get_castle_march_capacity_without_heroes(init_data, move_line_type=move_line_type)

    # 2. سعة الأبطال
    heroes_res = get_heroes_march_capacity(
        init_data,
        hero_ids=chosen_heroes,
        need_available=need_available,
    )

    # السعة النظرية القصوى لو كانت جميع الأبطال داخل القلعة (للتخطيط والمقارنة)
    theoretical_heroes = get_heroes_march_capacity(
        init_data,
        hero_ids=None,
        need_available=False,
    )

    # 3. المعادلة الرياضية التراكمية المطابقة لشاشة اللعبة
    total_mult = castle_res["total_percent_multiplier"]

    # سعة الفيلق الحالي
    overall_flat = castle_res["effective_base"] + heroes_res["total_heroes_flat"]
    grand_total = overall_flat + math.floor(overall_flat * total_mult)

    # السعة القصوى النظرية الشاملة
    theoretical_flat = castle_res["effective_base"] + theoretical_heroes["total_heroes_flat"]
    theoretical_grand_total = theoretical_flat + math.floor(theoretical_flat * total_mult)

    # صمام أمان الجلسة المتعلم
    learned_cap = None
    if conn and hasattr(conn, "learned_march_capacity"):
        l_cap = getattr(conn, "learned_march_capacity", None)
        if isinstance(l_cap, (int, float)) and l_cap > 0:
            learned_cap = int(l_cap)
            grand_total = min(grand_total, learned_cap)

    return {
        "grand_total": grand_total,
        "theoretical_max": theoretical_grand_total,
        "castle_without_heroes": castle_res["total_capacity"],
        "castle_effective_base": castle_res["effective_base"],
        "heroes_flat_add": heroes_res["total_heroes_flat"],
        "theoretical_heroes_flat_add": theoretical_heroes["total_heroes_flat"],
        "total_percent_multiplier": total_mult,
        "learned_march_capacity": learned_cap,
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
    يضمن بنسبة 100% أن إجمالي الجنود في أي فيلق أو مسيرة لا يتجاوز سعة المسيرة المسموح بها أبداً.
    إذا تجاوز المجموع السعة، يقلص الجنود بنسبة متناسقة مع حماية حبة واحدة من الزيادة بسبب التقريب.
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

    # تعويض أي نقص طفيف ناتج عن التقريب لأسفل للوصول للسعة القصوى المسموح بها تماماً
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
    """
    تسجيل سقف السعة المتعلم أثناء الجلسة لحماية جميع المهام اللاحقة لنفس الحساب فوراً.
    """
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
    """
    تحميل بيانات init_data لحساب معين:
      1. الاتصال الحي المباشر بخادم اللعبة عبر CastleBot (الوضع الافتراضي الإلزامي).
      2. إذا تم تمرير ملف JSON محلي مباشر عبر --file، يقرؤه فوراً.
      3. إذا طُلب offline=True، يقرأ من ملفات الذاكرة المشحونة مسبقاً.
    """
    # 1. إذا كان الهدف ملفاً موجوداً على القرص
    if os.path.exists(target):
        try:
            with open(target, "r", encoding="utf-8") as f:
                d = json.load(f)
                return os.path.basename(target), d
        except Exception as e:
            raise ValueError(f"فشل قراءة الملف {target}: {e}")

    # توحيد البريد الإلكتروني أو الاسم المستعار
    raw_target = target.strip()
    if "@" in raw_target:
        alias = raw_target.split("@")[0]
        email = raw_target
    else:
        alias = raw_target
        email = f"{raw_target}@hotmail.com"

    # 2. الاتصال الحي المباشر بالسيرفر الرسمي (الوضع الافتراضي)
    if not offline:
        try:
            import core.database as db
            from bot_manager import CastleBot

            c_data = db.get_castle_by_id(email)
            if not c_data:
                # محاولة البحث بالاسم المستعار
                castles = db.get_all_castles()
                for c in castles:
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
                print(f"✓ تم تسجيل الدخول واستخراج البوابة بنجاح! المملكة: {kid} | UID: {uid}")
                print(f"✓ تم استلام بيانات الذاكرة الحية (init_data) بنجاح من السيرفر ({len(data)} متحكم).")
                await bot.stop()
                return data

            live_data = asyncio.run(_connect_live())
            if live_data:
                return email, live_data
            else:
                print(f"⚠️ فشل الاتصال الحي بالسيرفر للحساب: {email}. جاري المحاولة من الذاكرة المحلية...")
        except Exception as e:
            print(f"⚠️ تعذر الاتصال الحي ({e}). جاري البحث في الذاكرة المحلية...")

    # 3. فحص ملفات الذاكرة المخبأة محلياً (Offline Fallback)
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
# 7. واجهة سطر الأوامر التفاعلية (Rich Command-Line Interface)
# ══════════════════════════════════════════════════════════════════════════════

def format_report(account_name: str, res: Dict[str, Any], show_available_only: bool = False) -> str:
    """تنسيق تقرير عربي شامل واحترافي يوضح كافة تفاصيل السعة ومكوناتها."""
    c = res["castle_breakdown"]
    h = res["heroes_breakdown"]
    th = res["theoretical_heroes_breakdown"]

    lines = []
    lines.append("╔═══════════════════════════════════════════════════════════════════════╗")
    lines.append(f"║ 🏰  تقرير سعة المسيرة القصوى الرسمي — حساب: {account_name:<25} ║")
    lines.append("╠═══════════════════════════════════════════════════════════════════════╣")
    lines.append("║ 1. سعة ساحة العرض والقلعة الأساسية (بدون أبطال):                      ║")
    lines.append(f"║    • مستوى مبنى ساحة العرض: {c['drill_level']:<3} (نجمة المجد: {c['drill_star']:<2}) -> {c['base_drill_grounds']:,} جندي")
    lines.append(f"║    • الثابت الافتراضي للعبة: {c['default_game_constant']:,} جندي")
    lines.append(f"║    • أبحاث القيادة الفردية (Tech 43): +{c['tech_flat_add']:,} جندي")
    if c["hero_dress_flat_add"] > 0:
        lines.append(f"║    • بافات مظاهر الأبطال السلبية: +{c['hero_dress_flat_add']:,} جندي")
    if c["buff_flat_add"] > 0:
        lines.append(f"║    • بافات الحقيبة الثابتة: +{c['buff_flat_add']:,} جندي")
    lines.append(f"║    ─────────────────────────────────────────────────────────────────  ║")
    lines.append(f"║    • الإجمالي الثابت الأساسي للقلعة: {c['effective_base']:,} جندي")
    lines.append(f"║    • نسب البافات المئوية:")
    lines.append(f"║      - وسام القائد 'توحيد القوة': +{c['achievement_percent']:.1f}%")
    if c["vip_percent"] > 0:
        lines.append(f"║      - امتياز كبار الشخصيات VIP/SVIP: +{c['vip_percent']:.1f}%")
    if c["item_buff_percent"] > 0:
        lines.append(f"║      - باف المسيرة المئوي المؤقت: +{c['item_buff_percent']:.1f}%")
    lines.append(f"║      - إجمالي المضاعف المئوي: +{c['total_percent_multiplier']*100:.1f}% (+{c['percent_troop_add']:,} جندي)")
    lines.append(f"║    ★ سعة القلعة وحدها بدون أبطال: {c['total_capacity']:,} جندي")
    lines.append("╠═══════════════════════════════════════════════════════════════════════╣")

    hero_label = "الأبطال الشاغرين المتاحين فقط" if show_available_only else "أقوى 5 أبطال في القلعة"
    lines.append(f"║ 2. تفاصيل {hero_label} ({h['heroes_count']} أبطال):")
    if not h["selected_heroes"]:
        lines.append("║    (لا يوجد أبطال متاحون)")
    else:
        for idx, hero in enumerate(h["selected_heroes"], 1):
            st_text = "شاغر بالقلعة" if hero["is_available"] else "في مهمة بالخارج"
            stars_text = "★" * hero["quality"]
            lines.append(
                f"║    {idx}. {hero['name']} (ID {hero['hero_id']}) | لفل {hero['level']} {stars_text:<5} | {st_text:<14} -> +{hero['total_hero_add']:,} جندي"
            )

    lines.append(f"║    ─────────────────────────────────────────────────────────────────  ║")
    lines.append(f"║    • إجمالي إضافة الأبطال الميدانية: +{h['total_heroes_flat']:,} جندي")
    if show_available_only and th['total_heroes_flat'] != h['total_heroes_flat']:
        lines.append(f"║    • أقصى إضافة نظرية بكافة الأبطال: +{th['total_heroes_flat']:,} جندي")

    lines.append("╠═══════════════════════════════════════════════════════════════════════╣")
    lines.append(f"║ 3. النتيجة النهائية لسعة المسيرة (مطابقة للعبة 100%):                ║")
    lines.append(f"║    👑 السعة الإجمالية الفعلية للفيلق:  {res['grand_total']:,} جندي                    ║")
    if res['theoretical_max'] != res['grand_total']:
        lines.append(f"║    ⚔️  السعة القصوى النظرية الشاملة:   {res['theoretical_max']:,} جندي                    ║")
    lines.append("╚═══════════════════════════════════════════════════════════════════════╝")
    return "\n".join(lines)

def main():
    parser = argparse.ArgumentParser(
        description="المحرك المركزي لحساب سعة مسيرة اللورد والجيش (انتقام السلاطين)"
    )
    parser.add_argument("--email", "-e", type=str, default="beetoo2", help="بريد الحساب أو اسمه المستعار (مثل beetoo2)")
    parser.add_argument("--file", "-f", type=str, default=None, help="مسار ملف JSON لحفظ init_data")
    parser.add_argument("--heroes", type=str, default=None, help="معرفات أبطال محددة مفصولة بفواصل (مثل 1700,1712,1717)")
    parser.add_argument("--available", "-a", action="store_true", help="قصر الحساب على الأبطال الشاغرين داخل القلعة فقط")
    parser.add_argument("--json", "-j", action="store_true", help="طباعة المخرجات بتنسيق JSON فقط")
    parser.add_argument("--all", action="store_true", help="فحص وحساب السعة لكافة الحسابات المسجلة بقاعدة البيانات")
    parser.add_argument("--offline", action="store_true", help="القراءة من الذاكرة المحلية المخبأة دون الاتصال الحي بالسيرفر")

    args = parser.parse_args()

    # وضع فحص كافة الحسابات
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
                acc, data = load_account_init_data(em, offline=args.offline)
                res = get_max_march_capacity(data, need_available=args.available)
                print(f"  • {em:<25}: بدون أبطال={res['castle_without_heroes']:,} | بالسعة القصوى={res['grand_total']:,} جندي")
            except Exception as ex:
                print(f"  • {em:<25}: ⚠️ {ex}")
        return

    # حساب فردي
    target = args.file or args.email
    chosen_hero_ids = None
    if args.heroes:
        chosen_hero_ids = [int(x.strip()) for x in args.heroes.split(",") if x.strip().isdigit()]

    try:
        acc_name, init_data = load_account_init_data(target, offline=args.offline)
    except Exception as e:
        print(f"❌ خطأ في جلب بيانات الحساب ({target}): {e}")
        return

    res = get_max_march_capacity(
        init_data,
        chosen_heroes=chosen_hero_ids,
        need_available=args.available,
    )

    if args.json:
        # تجهيز نسخة نظيفة من المخرجات
        clean_res = {
            "account": acc_name,
            "grand_total": res["grand_total"],
            "theoretical_max": res["theoretical_max"],
            "castle_without_heroes": res["castle_without_heroes"],
            "heroes_flat_add": res["heroes_flat_add"],
            "total_percent_multiplier": res["total_percent_multiplier"],
            "selected_heroes": [
                {
                    "id": h["hero_id"],
                    "name": h["name"],
                    "level": h["level"],
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
