# -*- coding: utf-8 -*-
"""
tasks/war_medal.py — مهمة متجر وسام الحرب (War Medal Exchange)
══════════════════════════════════════════════════════════════════
تنجز مهمة النشاط اليومي رقم 27 بتبادل وسام الحرب مرة واحدة يومياً،
بأقل تكلفة موارد ممكنة وبأولوية (قمح -> خشب -> حديد -> صلب)،
مع حظر قطعي لأي استهلاك للذهب وحماية بنسبة 100% من الحظر.
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional, Tuple
from tasks.base_task import BaseTask, TaskResult

# ثوابت المهمة الرسمية
DAILY_QUEST_TYPE_MEDAL = "27"  # معرف مهمة متجر وسام الحرب بالنشاط اليومي
REQ_CASTLE_LEVEL = 30          # مستوى القلعة الأدنى لفتح المتجر رسمياً
BADGE_TYPE_COMMON = 1          # وسام الحرب العادي (badgeType = 1)

# سلسلة أولويات الموارد وتكاليف التبادل الأول (من جدول اللعبة الرسمي badge_exchange.lua)
EXCHANGE_PRIORITIES = [
    (1002, 350000, "قمح"),
    (1003, 350000, "خشب"),
    (1004, 58330,  "حديد"),
    (1005, 14580,  "صلب"),
]


class WarMedalTask(BaseTask):
    """مهمة متجر وسام الحرب للنشاط اليومي"""
    name = "war_medal"

    async def run(self) -> TaskResult:
        # 1. فحص النشاط اليومي (0-Network Pre-flight)
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict) and int(event_info.get(DAILY_QUEST_TYPE_MEDAL, 0) or 0) >= 1:
                self.log("ℹ️ مكتملة بالنشاط اليومي مسبقاً (1/1) — تم التجاوز بأمان (0-Network).")
                return TaskResult.skip("مكتملة بالنشاط اليومي مسبقاً (1/1)")

        # 2. فحص مستوى القلعة (0-Network Pre-flight)
        c_lv = self.castle_level
        if c_lv < REQ_CASTLE_LEVEL:
            self.log(f"ℹ️ غير متاحة (تتطلب قلعة مستوى {REQ_CASTLE_LEVEL} على الأقل، الحالي: Lv.{c_lv}) — تم التجاوز بأمان.")
            return TaskResult.skip(f"تتطلب قلعة مستوى {REQ_CASTLE_LEVEL} (الحالي: {c_lv})")

        # 3. اختيار المورد الأنسب حسب تسلسل الأولويات الصارم مع احتساب تصاعد التكلفة اليومي (curExchangeNumMap)
        badge_ctrl = self.get_ctrl("badgeExchangeCtrl")
        cur_num = 0
        if isinstance(badge_ctrl, dict):
            ex_map = badge_ctrl.get("curExchangeNumMap")
            if isinstance(ex_map, dict):
                cur_num = max(0, int(ex_map.get(str(BADGE_TYPE_COMMON), 0) or 0))
        cost_mult = cur_num + 1

        res_dict = self.resources
        chosen_type = None
        chosen_cost = 0
        chosen_name = ""

        for res_id, base_cost, name in EXCHANGE_PRIORITIES:
            req_cost = base_cost * cost_mult
            avail = int(float(res_dict.get(str(res_id), 0) or 0))
            if avail >= req_cost:
                chosen_type = res_id
                chosen_cost = req_cost
                chosen_name = name
                break

        if not chosen_type:
            self.log("⚠️ لا توجد موارد كافية للتبادل (قمح/خشب/حديد/صلب) — تم التجاوز لحماية الذهب والمخزون.")
            return TaskResult.skip("الموارد غير كافية للتبادل")

        # 4. إرسال أمر التبادل الرسمي (CMD 1067 / SubCMD 2)
        self.log(f"🪙 تبادل وسام الحرب مقابل {chosen_cost:,} {chosen_name}...")
        r = await self.safe_query("1067", "2", {
            "nType": chosen_type,
            "exchangeNum": 1,
            "badgeType": BADGE_TYPE_COMMON
        }, min_delay=0.4, max_delay=0.8)

        if not r or str(r.get("err", "0")) != "0":
            err_code = str(r.get("err", "unknown")) if r else "timeout"
            self.log(f"⚠️ تعذر تبادل وسام الحرب (كود السيرفر: {err_code}).")
            return TaskResult.fail(f"فشل السيرفر ({err_code})")

        # 5. مزامنة الذاكرة الحية فورياً (In-Memory State Sync)
        cur_ev_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(cur_ev_ctrl, dict):
            ev_info = cur_ev_ctrl.setdefault("eventInfo", {})
            if isinstance(ev_info, dict):
                ev_info[DAILY_QUEST_TYPE_MEDAL] = max(int(ev_info.get(DAILY_QUEST_TYPE_MEDAL, 0) or 0), 1)

        badge_ctrl = self.get_ctrl("badgeExchangeCtrl")
        if isinstance(badge_ctrl, dict):
            srv_data = r.get("data") if isinstance(r.get("data"), dict) else {}
            srv_map = srv_data.get("curExchangeNumMap")
            if isinstance(srv_map, dict):
                badge_ctrl["curExchangeNumMap"] = dict(srv_map)
            else:
                ex_map = badge_ctrl.setdefault("curExchangeNumMap", {})
                if not isinstance(ex_map, dict):
                    ex_map = {}
                    badge_ctrl["curExchangeNumMap"] = ex_map
                ex_map[str(BADGE_TYPE_COMMON)] = cur_num + 1

        self.log(f"✅ تم إنجاز تبادل وسام الحرب بنجاح مقابل {chosen_name} (إنجاز النشاط اليومي 1/1).")
        return TaskResult.ok(f"تم تبادل وسام الحرب بنجاح ({chosen_name})")
