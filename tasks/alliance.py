# -*- coding: utf-8 -*-
"""
tasks/alliance.py — مهمة التحالف الشاملة (مساعدة التحالف + التبرع المجاني للعلوم)
══════════════════════════════════════════════════════════════════════════════════════

ملف موحد لكافة مهام التحالف الحالية والمستقبلية وفق المعيار الهيكلي الموحد (BaseTask).
المهام المنفذة:
  1. التحقق من عضوية التحالف (0-Network Pre-flight).
  2. مساعدة أعضاء التحالف (مساعدة الجميع - Help All عبر 1010/47):
     - فحص إنجاز النشاط اليومي (everydayTaskCtrl.eventInfo['18'] >= 20).
     - فحص قائمة المساعدات الحية (allianceCtrl.helplist) وتخطي فوري (0-Network) عند عدم توفر طلبات.
  3. استعلام رصيد تبرعات علوم التحالف المتاحة بدقة رياضية من شريط الانتظار donateCD (0-Network).
  4. الاكتشاف الذكي للتقنية المستهدفة من الذاكرة الحية (الموصى بها -> قيد التطوير -> غير المكتملة).
  5. تنفيذ التبرعات المجانية بالمتاح بالموارد العادية حصراً دون أي استهلاك للذهب (1010/48 | donatetype: 1).
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# ════════════════════════════════════════════════════════════════════
#  ثوابت مساعدة التحالف والتبرع المجاني
# ════════════════════════════════════════════════════════════════════

DAILY_QUEST_HELP_TYPE = "18"     # معرف نوع مهمة مساعدة التحالف في everydayTaskCtrl.eventInfo
DAILY_QUEST_HELP_TARGET = 40    # الحد المطلوب لإنجاز مهمة مساعدة التحالف اليومية (40 مرة وفق daily_reward_point_config.lua)
DAILY_QUEST_DONATE_TYPE = "21"   # معرف نوع مهمة تبرع التحالف في everydayTaskCtrl.eventInfo (ID=4100021)
DAILY_QUEST_DONATE_TARGET = 20   # الحد المطلوب لإنجاز مهمة تبرع التحالف اليومية (limitTime=20 وفق daily_reward_point_config.lua)

DONATE_TYPE_FREE = 1             # نوع التبرع بالموارد العادية (حديد/قمح/خشب) في السيرفر الرسمي
DEFAULT_SCI_ID = 33015           # المعرف الاحتياطي عند تعذر إيجاد تقنية
DONATE_DELAY_RANGE = (1.5, 2.8)  # فاصل بشري عشوائي بين التبرعات لمحاكاة النقر الطبيعي
MAX_CD_LIMIT = 14400             # سقف شريط الانتظار الأقصى (4 ساعات = 14,400 ثانية)
STEP_CD = 720                    # وقت الانتظار المضاف لكل تبرع فردي (12 دقيقة = 720 ثانية)

# ثوابت تبرع ازدهار/شعبية التحالف (Alliance Prosperity / Popularity)
# موثقة حرفياً من alliance_prosperous.lua + constant.lua + allianceScience.lua
PROSPERITY_DONATE_CMD_SUB = "91"       # REQ_ALLIANCE_DONATE_POPULARITY (cmdDef.lua:872)
PROSPERITY_REWARD_CMD_SUB = "93"       # REQ_ALLIANCE_RECIEVE_PROSPERITY_REWARD (cmdDef.lua:874)
PROSPERITY_DONATE_TYPE_JUNIOR = 1      # Junior: juniorUse = [1002, 15000, 1000] (100% قمح، 0 ذهب)
PROSPERITY_JUNIOR_RES_ID = "1002"      # معرف مورد القمح (Food)
PROSPERITY_JUNIOR_FOOD_COST = 15000    # تكلفة التبرع الفردي بالقمح من alliance_prosperous.lua
PROSPERITY_DONATE_MAX_NUM = 500        # السقف اليومي PROSPERITY_DONATE_MAX_NUM من constant.lua
PROSPERITY_JOIN_WAIT_SECONDS = 14400   # مدة الانتظار بعد الانضمام ALLIANCE_PROSPERITY_DONATE_TIME (4 ساعات)
PROSPERITY_REWARD_STEP = 300           # عتبة كل مكافأة ازدهار (allianceScience.lua:580)

# الحدود الرسمية لعلوم التحالف من ملف اللعبة (id: (maxLv, maxStar))
ALLIANCE_SCI_LIMITS: Dict[int, Tuple[int, int]] = {
    31001: (4, 3), 31002: (10, 5), 31003: (5, 2), 31004: (20, 2), 31005: (5, 5),
    32001: (20, 5), 32002: (20, 5), 32003: (20, 5), 32004: (20, 5), 32005: (20, 5),
    32006: (20, 5), 32007: (20, 5), 32008: (20, 5), 32009: (10, 2), 32010: (10, 5), 32011: (10, 3),
    33001: (10, 5), 33002: (10, 3), 33003: (10, 3), 33004: (20, 3), 33005: (20, 4), 33006: (20, 4),
    33007: (20, 4), 33008: (20, 4), 33009: (4, 4), 33010: (20, 5), 33011: (5, 5),
    34001: (10, 4), 34002: (10, 5), 34003: (1, 3), 34004: (10, 4), 34005: (1, 3), 34006: (1, 3), 34007: (10, 3),
    35001: (10, 4), 35002: (10, 4), 35003: (10, 5), 35004: (3, 5), 35005: (5, 5),
    36001: (20, 5), 36002: (20, 5), 36003: (20, 5),
    37001: (10, 5), 37002: (20, 5), 37003: (10, 5), 37004: (20, 5), 37005: (20, 4), 37006: (20, 4),
    37007: (20, 4), 37008: (20, 4), 37009: (20, 4), 37010: (10, 4), 37011: (10, 5)
}


class AllianceTask(BaseTask):
    """
    مهمة التحالف الشاملة:
    ترث من BaseTask وتتطابق بدقة مع المعيار الهيكلي الموحد لمهام المشروع.
    """
    name = "alliance"

    def _get_alliance_id(self) -> int:
        """
        فحص الذاكرة الحية (0-Network) لاستخراج معرف التحالف دون أي طلب شبكي.
        يتحقق من كافة المسارات الرسمية المؤكدة في الذاكرة الحية.
        """
        alliance_ctrl = self.get_ctrl('allianceCtrl')
        if isinstance(alliance_ctrl, dict) and alliance_ctrl:
            # 1. المسار الأساسي من بيانات العضوية
            minfo = alliance_ctrl.get('memberinfo', {}).get('minfo', {})
            if isinstance(minfo, dict) and int(minfo.get('aid', 0)) > 0:
                return int(minfo.get('aid', 0))

            # 2. من خصائص التحالف الرسمية
            prop = alliance_ctrl.get('allianceInfo', {}).get('property', {})
            if isinstance(prop, dict) and int(prop.get('aid', 0)) > 0:
                return int(prop.get('aid', 0))

            # 3. مسارات إضافية من بيانات الأراضي أو المباني أو السطح المباشر
            for sub_key in ('territoryData', 'buildData'):
                sub_val = alliance_ctrl.get(sub_key, {})
                if isinstance(sub_val, dict) and int(sub_val.get('aid', 0)) > 0:
                    return int(sub_val.get('aid', 0))

            if int(alliance_ctrl.get('aid', 0)) > 0:
                return int(alliance_ctrl.get('aid', 0))

        return 0

    def _is_science_donateable(self, item: dict) -> bool:
        """التحقق من أهلية التقنية للتبرع (0-Network): المستوى والنجوم أقل من الحد الأقصى"""
        sid = int(item.get('id', 0))
        max_lv, max_star = ALLIANCE_SCI_LIMITS.get(sid, (20, 5))
        return int(item.get('lv', 0)) < max_lv and int(item.get('star', 0)) < max_star

    def _find_recommended_science(self) -> Optional[int]:
        """
        اختيار التقنية الأنسب للتبرع من الذاكرة الحية بالترتيب الذكي الدقيق للعبة:
        1. فحص قائمة التوصيات الرسمية من قائد التحالف (scienceRecommendList).
        2. التقنية قيد التطوير النشط وتحتوي على نقاط مودعة ونجومها غير مكتملة.
        3. أي تقنية مؤهلة غير مكتملة النجوم والمستوى.
        """
        alliance_ctrl = self.init_data.get('allianceCtrl', {})
        if not isinstance(alliance_ctrl, dict):
            return None

        scilist = alliance_ctrl.get('sciencelist', {}).get('scilist', {})
        if not scilist or not isinstance(scilist, dict):
            return None

        # 1. البحث في قائمة التقنيات الموصى بها رسمياً من قائد التحالف (scienceRecommendList)
        rec_list = alliance_ctrl.get('scienceRecommendList', {})
        if isinstance(rec_list, dict) and rec_list:
            # أ) تفضيل تقنية موصى بها وقيد التطوير النشط (point > 0)
            for cat, items in scilist.items():
                if isinstance(items, list):
                    for item in items:
                        sid = str(item.get('id', ''))
                        if sid in rec_list and int(item.get('point', 0)) > 0 and self._is_science_donateable(item):
                            self.log(f"⭐ تم اختيار التقنية الموصى بها وقيد التطوير: ID={sid} (Lv.{item.get('lv')})")
                            return int(sid)

            # ب) أي تقنية موصى بها نجومها غير مكتملة
            for cat, items in scilist.items():
                if isinstance(items, list):
                    for item in items:
                        sid = str(item.get('id', ''))
                        if sid in rec_list and self._is_science_donateable(item):
                            self.log(f"⭐ تم اختيار التقنية الموصى بها من القائد: ID={sid} (Lv.{item.get('lv')})")
                            return int(sid)

        # 2. البحث عن تقنية قيد التطوير النشط (point > 0) ونجومها غير مكتملة
        for cat, items in scilist.items():
            if isinstance(items, list):
                for item in items:
                    if isinstance(item, dict) and int(item.get('point', 0)) > 0 and self._is_science_donateable(item):
                        sci_id = int(item.get('id', 0))
                        if sci_id > 0:
                            self.log(f"🔬 تم اختيار تقنية قيد التطوير كبديل: ID={sci_id} (Lv.{item.get('lv')})")
                            return sci_id

        # 3. البحث عن أي تقنية مؤهلة غير مكتملة النجوم
        for cat, items in scilist.items():
            if isinstance(items, list):
                for item in items:
                    if isinstance(item, dict) and self._is_science_donateable(item):
                        sci_id = int(item.get('id', 0))
                        if sci_id > 0:
                            self.log(f"💡 تم اختيار تقنية بديلة مؤهلة: ID={sci_id} (Lv.{item.get('lv')})")
                            return sci_id

        return None

    async def _help_alliance_members(self) -> Tuple[bool, str]:
        """
        روتين مساعدة أعضاء التحالف (مساعدة الجميع - Help All):
        1. فحص النشاط اليومي (0-Network Pre-flight): إذا اكتملت 20/20، يتم التجاوز فوراً دون أي استعلام.
        2. الاستعلام الرسمي لجلب قائمة المساعدات الحية (CMD 1010 / SubCMD 44 | REQ_ALLIANCE_INIT_HELP).
        3. التحقق الرياضي الدقيق من وجود طلبات مساعدة نشطة ومؤهلة لأعضاء التحالف.
        4. إرسال أمر مساعدة الجميع الرسمي (CMD 1010 / SubCMD 47) فقط في حال وجود طلبات فعلية.
        5. تحديث الذاكرة الحية فوراً (In-Memory State Sync).
        """
        # 1. فحص النشاط اليومي (0-Network Pre-flight)
        helps_today_before = 0
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict):
                helps_today_before = int(event_info.get(DAILY_QUEST_HELP_TYPE, 0) or 0)
                if helps_today_before >= DAILY_QUEST_HELP_TARGET:
                    self.log(f"ℹ️ مساعدة التحالف: مكتملة بالنشاط اليومي مسبقاً ({helps_today_before}/{DAILY_QUEST_HELP_TARGET}) — تم التجاوز بأمان (0-Network).")
                    return False, f"مكتملة بالنشاط اليومي مسبقاً ({helps_today_before}/{DAILY_QUEST_HELP_TARGET})"

        # 2. الاستعلام الرسمي عن قائمة طلبات المساعدة الحية (1010 / 44)
        r_query = await self.safe_query("1010", "44", {}, min_delay=0.3, max_delay=0.5)
        if not r_query or str(r_query.get("err", "0")) != "0":
            err_code = str(r_query.get("err", "unknown")) if r_query else "timeout"
            self.log(f"ℹ️ مساعدة التحالف: تعذر استعلام قائمة المساعدات (كود السيرفر: {err_code}).")
            return False, f"فشل الاستعلام ({err_code})"

        retdata = r_query.get("data", {}).get("retdata", {})

        # مزامنة القائمة الحية المسترجعة في الذاكرة الحية
        alliance_ctrl = self.init_data.get("allianceCtrl", {})
        if isinstance(alliance_ctrl, dict):
            alliance_ctrl["helplist"] = retdata

        # 3. التحقق من وجود طلبات مساعدة نشطة ومؤهلة
        my_uid = self.uid

        items_to_check = (
            list(retdata.values()) if isinstance(retdata, dict)
            else retdata if isinstance(retdata, list)
            else []
        )

        pending_helps = 0
        for item in items_to_check:
            if not isinstance(item, dict):
                continue
            req_uid = str(item.get("uid", "")).strip()
            if req_uid == my_uid:
                continue

            helpers = item.get("helper") or []
            if isinstance(helpers, dict):
                helpers = list(helpers.values())
            helpers_str = [str(h).strip() for h in helpers]
            if my_uid in helpers_str:
                continue

            cur_hp = int(item.get("curHp", 0) or 0)
            total_hp = int(item.get("totalHp", 1) or 1)
            if cur_hp < total_hp:
                pending_helps += 1

        if pending_helps == 0:
            self.log("ℹ️ مساعدة التحالف: لا توجد طلبات مساعدة نشطة حالياً بالتحالف — تم التجاوز بأمان.")
            return False, "لا توجد طلبات مساعدة نشطة حالياً بالتحالف"

        # 4. إرسال أمر مساعدة الجميع الرسمي (1010 / 47) لوجود طلبات مؤهلة فعلية
        self.log(f"🤝 تم العثور على {pending_helps} طلب مساعدة معلق — إرسال مساعدة الجميع (1010/47)...")
        r_help = await self.safe_query("1010", "47", {}, min_delay=0.3, max_delay=0.6)

        if r_help and str(r_help.get("err", "0")) == "0":
            # 5. تحديث الذاكرة الحية فوراً دون مضاعفة بعد NOTIFY_EVERYDAY_TASK (55)
            cur_ev_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
            if isinstance(cur_ev_ctrl, dict):
                ev_info = cur_ev_ctrl.setdefault("eventInfo", {})
                if isinstance(ev_info, dict):
                    expected_after = min(DAILY_QUEST_HELP_TARGET, helps_today_before + pending_helps)
                    ev_info[DAILY_QUEST_HELP_TYPE] = max(
                        int(ev_info.get(DAILY_QUEST_HELP_TYPE, 0) or 0),
                        expected_after,
                    )

            # وسم الطلبات كمكتملة في helplist محلياً
            for item in items_to_check:
                if isinstance(item, dict) and str(item.get("uid", "")).strip() != my_uid:
                    helpers = item.setdefault("helper", [])
                    if isinstance(helpers, list) and my_uid not in helpers:
                        helpers.append(my_uid)
                    item["curHp"] = int(item.get("curHp", 0) or 0) + 1

            self.log(f"✅ تم إنجاز مساعدة {pending_helps} طلب لأعضاء التحالف بنجاح.")
            return True, f"تمت مساعدة {pending_helps} طلب بنجاح"
        else:
            err_code = str(r_help.get("err", "unknown")) if r_help else "timeout"
            self.log(f"⚠️ تعذر تنفيذ مساعدة التحالف (كود السيرفر: {err_code}).")
            return False, f"فشل السيرفر ({err_code})"

    @staticmethod
    def _extract_treasure_rsp(resp: Any) -> Dict[str, Any]:
        """استخراج حمولة استجابة كنز التحالف بأمان سواء كانت داخل data.rspdata أو rspdata أو data."""
        if not isinstance(resp, dict):
            return {}
        data_obj = resp.get("data")
        if isinstance(data_obj, dict) and isinstance(data_obj.get("rspdata"), dict):
            return data_obj["rspdata"]
        if isinstance(resp.get("rspdata"), dict):
            return resp["rspdata"]
        if isinstance(data_obj, dict):
            return data_obj
        return {}

    async def _treasure_alliance(self) -> Tuple[bool, str]:
        """
        روتين كنز التحالف (Alliance Treasure) في مبنى المخزن:
        1. تهيئة بيانات الكنز عبر CMD 2015/1 إذا لم تكن محملة في الذاكرة الحية (Lazy Load).
        2. استلام الكنوز الخاصة المكتملة أولاً (لتفادي منع السيرفر للحفر الجديد).
        3. طلب مساعدة التحالف للكنوز الخاصة المعلقة.
        4. استلام جوائز مساعدة أعضاء التحالف المكتملة.
        5. الاستخراج المجاني لأعلى كنز جودة متاح (0 ذهب حصراً).
        6. تقديم مساعدة مجانية واحدة لعضو بالتحالف (إذا كان متاحاً).
        """
        # 1. التحقق من الذاكرة الحية والتهيئة الكسولة (Lazy Loading)
        treasure_ctrl = self.get_ctrl("allianceTreasureCtrl") or {}
        if not treasure_ctrl.get("otherInfo"):
            self.log("📡 جلب بيانات كنز التحالف من السيرفر (CMD 2015/1)...")
            r_init = await self.safe_query("2015", "1", {}, min_delay=0.3, max_delay=0.6)
            if not r_init or str(r_init.get("err", "")) not in ("0", 0):
                self.log("⚠️ تعذر تهيئة بيانات كنز التحالف من السيرفر.")
                return False, "فشل تهيئة بيانات كنز التحالف"
            rspdata = self._extract_treasure_rsp(r_init)
            self.init_data["allianceTreasureCtrl"] = rspdata
            treasure_ctrl = rspdata

        my_uid = self.uid
        actions_done = []

        # 2. استلام الكنوز الخاصة المكتملة أولاً (لتجنب خطأ Err_ALLIANCE_TREASURE_PLEASE_RECEIVE_FIRST)
        dig_list = treasure_ctrl.get("digListInfo", []) or []
        for dig in list(dig_list):
            if isinstance(dig, dict) and dig.get("canReceive"):
                idx = dig.get("index")
                self.log(f"🎁 استلام مكافأة كنز خاص مكتمل (صندوق #{idx})...")
                r_rcv = await self.safe_query("2015", "6", {"receiveType": 1, "ownUid": my_uid, "index": idx})
                if r_rcv and str(r_rcv.get("err", "")) in ("0", 0):
                    rsp = self._extract_treasure_rsp(r_rcv)
                    if isinstance(rsp.get("digListInfo"), list):
                        treasure_ctrl["digListInfo"] = rsp["digListInfo"]
                    else:
                        treasure_ctrl["digListInfo"] = [
                            d for d in (treasure_ctrl.get("digListInfo") or [])
                            if not (isinstance(d, dict) and d.get("index") == idx)
                        ]
                    if isinstance(rsp.get("otherInfo"), dict):
                        treasure_ctrl["otherInfo"] = rsp["otherInfo"]
                    actions_done.append(f"استلام كنز #{idx}")

        # 3. طلب مساعدة التحالف للكنوز الخاصة غير المكتملة
        dig_list = treasure_ctrl.get("digListInfo", []) or []
        for dig in dig_list:
            if isinstance(dig, dict) and dig.get("canCallHelp") and not dig.get("isHelped"):
                idx = dig.get("index")
                self.log(f"📣 إرسال طلب مساعدة التحالف لكنزك الخاص (صندوق #{idx})...")
                r_help_req = await self.safe_query("2015", "4", {"index": idx})
                if r_help_req and str(r_help_req.get("err", "")) in ("0", 0):
                    dig["canCallHelp"] = False
                    actions_done.append(f"طلب مساعدة لكنز #{idx}")

        # 4. استلام مكافآت مساعدة الأعضاء المكتملة (وحذفها من helpInfo لفتح خانة المساعدة التالية)
        help_info = treasure_ctrl.get("helpInfo", []) or []
        for item in list(help_info):
            if isinstance(item, dict) and item.get("canReceive"):
                idx = item.get("index")
                own_uid = item.get("ownUid")
                self.log(f"🎁 استلام جائزة مساعدة عضو التحالف (صندوق #{idx})...")
                r_h_rcv = await self.safe_query("2015", "6", {"receiveType": 2, "ownUid": own_uid, "index": idx})
                if r_h_rcv and str(r_h_rcv.get("err", "")) in ("0", 0):
                    rsp = self._extract_treasure_rsp(r_h_rcv)
                    if isinstance(rsp.get("helpInfo"), list):
                        treasure_ctrl["helpInfo"] = rsp["helpInfo"]
                    else:
                        treasure_ctrl["helpInfo"] = [
                            h for h in (treasure_ctrl.get("helpInfo") or [])
                            if not (isinstance(h, dict) and str(h.get("ownUid")) == str(own_uid) and h.get("index") == idx)
                        ]
                    if isinstance(rsp.get("canHelpList"), dict):
                        treasure_ctrl["canHelpList"] = rsp["canHelpList"]
                    elif isinstance(treasure_ctrl.get("canHelpList"), dict) and str(own_uid) in treasure_ctrl["canHelpList"]:
                        u_boxes = treasure_ctrl["canHelpList"].get(str(own_uid))
                        if isinstance(u_boxes, list):
                            treasure_ctrl["canHelpList"][str(own_uid)] = [
                                b for b in u_boxes if not (isinstance(b, dict) and b.get("index") == idx)
                            ]
                    if isinstance(rsp.get("otherInfo"), dict):
                        treasure_ctrl["otherInfo"] = rsp["otherInfo"]
                    actions_done.append(f"استلام جائزة مساعدة #{idx}")

        # 5. الاستخراج المجاني (Free Dig) مع مزامنة صارمة لـ nextFreeDigTime لحماية الذهب 100%
        other_info = treasure_ctrl.get("otherInfo", {}) or {}
        now = int(time.time())
        next_free = int(other_info.get("nextFreeDigTime", 0) or 0)
        max_dig = int(other_info.get("maxDigCount", 8) or 8)
        dig_count = int(other_info.get("digCount", 0) or 0)

        is_free = (next_free == 0 or next_free <= now)
        if is_free and dig_count < max_dig:
            treasure_info = treasure_ctrl.get("treasureInfo", []) or []
            valid_boxes = [b for b in treasure_info if isinstance(b, dict)]
            if valid_boxes:
                # فرز تنازلي لاختيار الكنز الأعلى جودة (quality)
                valid_boxes.sort(key=lambda x: int(x.get("quality", 0) or 0), reverse=True)
                target_box = valid_boxes[0]
                box_idx = target_box.get("index")
                box_qual = target_box.get("quality", 1)

                self.log(f"⛏️ استخراج كنز تحالف مجاني (جودة {box_qual} - صندوق #{box_idx})...")
                r_dig = await self.safe_query("2015", "3", {"index": box_idx}, min_delay=0.5, max_delay=1.0)
                if r_dig and str(r_dig.get("err", "")) in ("0", 0):
                    rsp = self._extract_treasure_rsp(r_dig)
                    if isinstance(rsp.get("otherInfo"), dict):
                        treasure_ctrl["otherInfo"] = rsp["otherInfo"]
                        other_info = treasure_ctrl["otherInfo"]
                    else:
                        other_info["digCount"] = dig_count + 1
                        # صمام أمان ذهبي احتياطي عند غياب otherInfo من الرد لمنع إرسال 2015/3 مدفوع بالذهب في الدورة التالية
                        other_info["nextFreeDigTime"] = int(time.time()) + 3600

                    if isinstance(rsp.get("treasureInfo"), list):
                        treasure_ctrl["treasureInfo"] = rsp["treasureInfo"]
                    else:
                        rem_idx = rsp.get("removeIndex", box_idx)
                        treasure_ctrl["treasureInfo"] = [
                            b for b in (treasure_ctrl.get("treasureInfo") or [])
                            if not (isinstance(b, dict) and b.get("index") == rem_idx)
                        ]

                    if isinstance(rsp.get("digListInfo"), list):
                        treasure_ctrl["digListInfo"] = rsp["digListInfo"]
                    elif isinstance(rsp.get("newDigInfo"), dict):
                        d_list = treasure_ctrl.setdefault("digListInfo", [])
                        if isinstance(d_list, list):
                            d_list.append(rsp["newDigInfo"])

                    self.log(f"✅ تم استخراج كنز التحالف المجاني بنجاح (جودة {box_qual}).")
                    actions_done.append(f"استخراج كنز مجاني جودة {box_qual}")
                else:
                    err_c = r_dig.get("err") if r_dig else "timeout"
                    self.log(f"⚠️ فشل استخراج الكنز من السيرفر (كود: {err_c}).")
        else:
            if dig_count >= max_dig:
                self.log(f"ℹ️ كنز التحالف: اكتملت محاولات الحفر اليومية ({dig_count}/{max_dig}).")
            elif not is_free:
                rem_sec = max(0, next_free - now)
                self.log(f"ℹ️ كنز التحالف: الاستخراج المجاني قيد الانتظار (متبقي {rem_sec // 60} دقيقة) — تم التجاوز لحماية الذهب.")

        # 6. مساعدة عضو في التحالف مجاناً (Help Alliance Member)
        # قاعدة اللعبة الرسمية: يمكن مساعدة كنز واحد فقط في نفس الوقت
        other_info = treasure_ctrl.get("otherInfo", {}) or {}
        is_already_helping = any(
            isinstance(h, dict) and h.get("isHelped") and not h.get("canReceive")
            for h in (treasure_ctrl.get("helpInfo", []) or [])
        )
        max_help = int(other_info.get("maxHelpCount", 10) or 10)
        help_count = int(other_info.get("helpCount", 0) or 0)

        if not is_already_helping and help_count < max_help:
            can_help_map = treasure_ctrl.get("canHelpList", {}) or {}
            target_help = None
            target_box_ref = None
            if isinstance(can_help_map, dict):
                for u_id, box_list in can_help_map.items():
                    if str(u_id) == my_uid:
                        continue
                    boxes = box_list if isinstance(box_list, list) else [box_list]
                    for b in boxes:
                        if isinstance(b, dict) and not b.get("isHelped"):
                            target_help = (int(u_id), b.get("index"))
                            target_box_ref = b
                            break
                    if target_help:
                        break

            if target_help:
                helped_uid, helped_idx = target_help
                self.log(f"🤝 تقديم مساعدة مجانية لكنز عضو التحالف (UID: {helped_uid} - صندوق #{helped_idx})...")
                r_help = await self.safe_query("2015", "5", {"helpedUid": helped_uid, "helpedIndex": helped_idx})
                if r_help and str(r_help.get("err", "")) in ("0", 0):
                    rsp = self._extract_treasure_rsp(r_help)
                    if isinstance(rsp.get("otherInfo"), dict):
                        treasure_ctrl["otherInfo"] = rsp["otherInfo"]
                    else:
                        other_info["helpCount"] = help_count + 1

                    if isinstance(rsp.get("canHelpList"), dict):
                        treasure_ctrl["canHelpList"] = rsp["canHelpList"]
                    elif isinstance(target_box_ref, dict):
                        target_box_ref["isHelped"] = True

                    if isinstance(rsp.get("helpInfo"), list):
                        treasure_ctrl["helpInfo"] = rsp["helpInfo"]
                    elif isinstance(rsp.get("newHelpInfo"), dict):
                        h_list = treasure_ctrl.setdefault("helpInfo", [])
                        if isinstance(h_list, list):
                            h_list.append(rsp["newHelpInfo"])
                    else:
                        h_list = treasure_ctrl.setdefault("helpInfo", [])
                        if isinstance(h_list, list):
                            h_list.append({
                                "ownUid": helped_uid,
                                "index": helped_idx,
                                "isHelped": True,
                                "canReceive": False,
                            })

                    self.log(f"✅ تمت مساعدة كنز عضو التحالف بنجاح.")
                    actions_done.append(f"مساعدة عضو UID={helped_uid}")

        if actions_done:
            return True, "تم إنجاز: " + "، ".join(actions_done)
        return True, "لا توجد إجراءات كنز معلقة حالياً"

    # ═════════════════════════════════════════════════════════════════════════
    # دوال الذاكرة الحية الخاصة بازدهار/شعبية التحالف (0-Network Read-Only)
    # ═════════════════════════════════════════════════════════════════════════

    def _get_alliance_member_info(self) -> Optional[Dict[str, Any]]:
        """قراءة بيانات عضو التحالف minfo من الذاكرة الحية allianceCtrl (0-Network Read-Only)."""
        alliance_ctrl = self.get_ctrl("allianceCtrl")
        if not isinstance(alliance_ctrl, dict):
            return None
        member_wrap = alliance_ctrl.get("memberinfo")
        if not isinstance(member_wrap, dict):
            return None
        minfo = member_wrap.get("minfo")
        return minfo if isinstance(minfo, dict) and minfo else None

    def _get_alliance_science_container(self) -> Optional[Dict[str, Any]]:
        """قراءة حاوية علوم وازدهار التحالف sciencelist من allianceCtrl (0-Network Read-Only)."""
        alliance_ctrl = self.get_ctrl("allianceCtrl")
        if not isinstance(alliance_ctrl, dict):
            return None
        sci_container = alliance_ctrl.get("sciencelist")
        return sci_container if isinstance(sci_container, dict) and sci_container else None

    def _is_prosperity_unlocked(self) -> bool:
        """
        التحقق المطابق حرفياً لدالة allianceScience:isProsperityUnlock() (allianceScience.lua:561-573):
        يُفتح ازدهار التحالف حصراً عند اكتمال كافة التقنيات الـ 53 في alliance_prosperous_unlock.lua
        إلى أقصى مستوى (lv >= maxLv و star >= 0).
        """
        sci_container = self._get_alliance_science_container()
        if not sci_container:
            return False
        scilist = sci_container.get("scilist")
        if not isinstance(scilist, dict) or not scilist:
            return False

        sci_by_id: Dict[int, Tuple[int, int]] = {}
        for group_items in scilist.values():
            if not isinstance(group_items, list):
                continue
            for item in group_items:
                if not isinstance(item, dict):
                    continue
                sid = self._safe_int(item.get("id"), 0)
                if sid > 0:
                    sci_by_id[sid] = (
                        self._safe_int(item.get("lv"), 0),
                        self._safe_int(item.get("star"), 0),
                    )

        for req_id, (req_max_lv, _) in ALLIANCE_SCI_LIMITS.items():
            state = sci_by_id.get(req_id)
            if state is None:
                return False
            cur_lv, cur_star = state
            if cur_lv < req_max_lv or cur_star < 0:
                return False
        return True

    def _get_prosperity_join_wait_remaining(self, now_ts: Optional[int] = None) -> int:
        """
        حساب الثواني المتبقية قبل استيفاء شرط الانضمام (4 ساعات) لتبرع الازدهار (0-Network Read-Only).
        مطابق لدالة AllianceProsperityDonatePanel.lua:73-79: يتطلب (now - joinTime) > 14400.
        """
        minfo = self._get_alliance_member_info()
        if not minfo:
            return PROSPERITY_JOIN_WAIT_SECONDS
        join_time = self._safe_int(minfo.get("joinTime"), 0)
        if join_time <= 0:
            return PROSPERITY_JOIN_WAIT_SECONDS
        cur_ts = now_ts if now_ts is not None else self.get_server_time()
        elapsed = cur_ts - join_time
        if elapsed <= PROSPERITY_JOIN_WAIT_SECONDS:
            return max(1, (PROSPERITY_JOIN_WAIT_SECONDS - elapsed) + 1)
        return 0

    def _get_prosperity_daily_remaining(self, now_ts: Optional[int] = None) -> int:
        """
        حساب عدد تبرعات الازدهار المتبقية لليوم من donatePopularityState (0-Network Read-Only).
        مطابق لدالة allianceScience:getProsperityRemainCount() (allianceScience.lua:654-665).
        """
        minfo = self._get_alliance_member_info()
        if not minfo:
            return 0
        dp_state = minfo.get("donatePopularityState")
        cur_ts = now_ts if now_ts is not None else self.get_server_time()
        donated_today = 0
        if isinstance(dp_state, dict):
            reset_time = self._safe_int(dp_state.get("resetTime"), 0)
            if reset_time > 0 and self.is_same_utc_day(reset_time, cur_ts):
                donated_today = max(0, self._safe_int(dp_state.get("donateTimes"), 0))
        return max(0, PROSPERITY_DONATE_MAX_NUM - donated_today)

    def _get_prosperity_daily_quest_remaining(self, now_ts: Optional[int] = None) -> Tuple[bool, int, int]:
        """
        فحص تقدم مهمة تبرع التحالف في النشاط اليومي (type=21، الهدف=20) من الذاكرة الحية (0-Network Read-Only):
          - عند غياب everydayTaskCtrl يُعيد (False, 0, 0) للتخطي الآمن دون تخمين.
          - عند عبور tomorrowZeroUTC يعتمد التقدم الفعلي 0 مع التقاطع الاحترازي ضد donatePopularityState لليوم الجديد.
        يُعيد: (is_loaded, effective_done, remaining_to_target).
        """
        cur_ts = now_ts if now_ts is not None else self.get_server_time()
        is_loaded, ev_done = self.get_daily_quest_state(DAILY_QUEST_DONATE_TYPE, cur_ts)
        if not is_loaded:
            return False, 0, 0

        dp_donated_today = 0
        minfo = self._get_alliance_member_info()
        if minfo:
            dp_state = minfo.get("donatePopularityState")
            if isinstance(dp_state, dict):
                reset_time = self._safe_int(dp_state.get("resetTime"), 0)
                if reset_time > 0 and self.is_same_utc_day(reset_time, cur_ts):
                    dp_donated_today = max(0, self._safe_int(dp_state.get("donateTimes"), 0))

        effective_done = max(ev_done, dp_donated_today)
        remaining = max(0, DAILY_QUEST_DONATE_TARGET - effective_done)
        return True, effective_done, remaining

    def _get_prosperity_cd_status(self, now_ts: Optional[int] = None) -> Tuple[bool, int, int]:
        """
        قراءة حالة قفل وشريط انتظار تبرع الازدهار من الذاكرة الحية (0-Network Read-Only).
        مطابق لدالتي isDonatePopularityLock و getDonatePopularityRemainTime (allianceScience.lua:666-686).
        يُعيد: (is_locked, remain_cd_seconds, available_slots).
        """
        minfo = self._get_alliance_member_info()
        if not minfo:
            return True, MAX_CD_LIMIT, 0
        cur_ts = now_ts if now_ts is not None else self.get_server_time()
        dp_lock = self._safe_int(minfo.get("donatePopularityLock"), 0)
        dp_cd = minfo.get("donatePopularityCD")
        remain_cd = 0
        if isinstance(dp_cd, dict):
            starttime = self._safe_int(dp_cd.get("starttime"), 0)
            totaltime = self._safe_int(dp_cd.get("totaltime"), 0)
            if starttime > 0 and totaltime > 0:
                remain_cd = max(0, (starttime + totaltime) - cur_ts)

        is_locked = (dp_lock == 1 and remain_cd > 0)
        if is_locked or remain_cd >= MAX_CD_LIMIT:
            return is_locked, remain_cd, 0
        available_slots = min(20, max(0, (MAX_CD_LIMIT - remain_cd) // STEP_CD))
        return False, remain_cd, available_slots

    def _get_prosperity_rewards_count(self) -> int:
        """
        حساب عدد مكافآت ازدهار التحالف الجاهزة للاستلام (0-Network Read-Only).
        مطابق لدالة allianceScience:getProsperityRewardsCount() (allianceScience.lua:574-581).
        """
        minfo = self._get_alliance_member_info()
        sci_container = self._get_alliance_science_container()
        if not minfo or not sci_container:
            return 0
        if "lastProsperity" not in minfo:
            return 0
        prosperity = self._safe_int(sci_container.get("prosperity"), 0)
        last_prosperity = self._safe_int(minfo.get("lastProsperity"), -1)
        if prosperity <= 0 or last_prosperity < 0 or last_prosperity >= prosperity:
            return 0
        return (prosperity - last_prosperity) // PROSPERITY_REWARD_STEP

    # ═════════════════════════════════════════════════════════════════════════
    # الروتين الاحتياطي: تبرع ازدهار/شعبية التحالف (1010/91) + المكافآت (1010/93)
    # ═════════════════════════════════════════════════════════════════════════

    async def _donate_alliance_prosperity(
        self,
        max_donations_override: Optional[int] = None,
        claim_rewards: bool = True,
    ) -> Dict[str, Any]:
        """
        مسار التبرع الاحتياطي لازدهار/شعبية التحالف عند اكتمال جميع علوم التحالف (53 تقنية).
        يلتزم بالكامل بالدستور الرسمي:
          - 0-Query: يقرأ حصراً من الذاكرة الحية دون أي استعلام شبكي مسبق.
          - 0-Manual-Mutation: لا يعدل conn.init_data يدوياً، ويعتمد على LiveMemoryEngine._handle_cmd_1010.
          - 0-Gold: يرسل donatetype=1 (Junior: 15,000 قمح فقط).
          - 0-Rejected-Requests: يفحص كل بوابة قبل بدء الحلقة وقبل كل تبرع فردي.
        """
        result: Dict[str, Any] = {
            "donated": 0,
            "honor": 0,
            "score": 0,
            "popularity": 0,
            "rewards_claimed": 0,
            "skip_reason": "",
        }

        if not self._get_alliance_member_info() or not self._get_alliance_science_container():
            result["skip_reason"] = "بيانات التحالف غير مكتملة في الذاكرة الحية"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
            return result

        if not self._is_prosperity_unlocked():
            result["skip_reason"] = "ازدهار التحالف غير مفتوح (لم تكتمل جميع العلوم الـ 53)"
            return result

        now_ts = self.get_server_time()
        quest_loaded, quest_done, quest_remain = self._get_prosperity_daily_quest_remaining(now_ts)
        join_wait = self._get_prosperity_join_wait_remaining(now_ts)
        is_locked, remain_cd, cd_slots = self._get_prosperity_cd_status(now_ts)
        daily_remain = self._get_prosperity_daily_remaining(now_ts)
        initial_food = self.get_resource_balance(PROSPERITY_JUNIOR_RES_ID)
        affordable = initial_food // PROSPERITY_JUNIOR_FOOD_COST

        if not quest_loaded:
            result["skip_reason"] = "بيانات النشاط اليومي (everydayTaskCtrl) غير متوفرة في الذاكرة الحية"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم تخطي التبرع بأمان (0-Network).")
        elif quest_remain <= 0:
            result["skip_reason"] = f"مهمة تبرع التحالف مكتملة بالنشاط اليومي ({quest_done}/{DAILY_QUEST_DONATE_TARGET})"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم تخطي التبرع بأمان (0-Network).")
        elif join_wait > 0:
            result["skip_reason"] = f"لم تمضِ 4 ساعات على الانضمام للتحالف (متبقي {join_wait // 60} دقيقة)"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
        elif is_locked:
            result["skip_reason"] = f"تبرع الازدهار مقفل حالياً (متبقي {remain_cd // 60} دقيقة)"
            self.log(f"⏳ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
        elif cd_slots <= 0:
            result["skip_reason"] = f"شريط انتظار تبرع الازدهار ممتلئ (متبقي {remain_cd // 60} دقيقة)"
            self.log(f"⏳ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
        elif daily_remain <= 0:
            result["skip_reason"] = f"اكتمل الحد اليومي لتبرع الازدهار ({PROSPERITY_DONATE_MAX_NUM}/{PROSPERITY_DONATE_MAX_NUM})"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
        elif affordable <= 0:
            result["skip_reason"] = f"رصيد القمح غير كافٍ ({initial_food:,} < {PROSPERITY_JUNIOR_FOOD_COST:,})"
            self.log(f"ℹ️ [ازدهار التحالف] {result['skip_reason']} — تم التخطي بأمان (0-Network).")
        else:
            planned = min(quest_remain, cd_slots, daily_remain, affordable)
            if max_donations_override is not None:
                planned = min(planned, max(0, int(max_donations_override)))

            if planned > 0:
                self.log(
                    f"🏛️ [ازدهار التحالف] كافة علوم التحالف مكتملة — بدء مسار تبرع الازدهار الاحتياطي "
                    f"(المخطط: {planned} تبرع بالقمح | النشاط اليومي: {quest_done}/{DAILY_QUEST_DONATE_TARGET} | "
                    f"انتظار الشريط: {remain_cd // 60} دقيقة)."
                )

            for idx in range(planned):
                # إعادة التحقق المباشر من الذاكرة الحية المحدّثة عبر LiveMemoryEngine قبل كل طلب
                if idx > 0:
                    loop_now = self.get_server_time()
                    loop_q_loaded, loop_q_done, _ = self._get_prosperity_daily_quest_remaining(loop_now)
                    effective_q_done = max(loop_q_done, quest_done + result["donated"])
                    loop_locked, loop_rem_cd, _ = self._get_prosperity_cd_status(loop_now)
                    loop_daily_rem = self._get_prosperity_daily_remaining(loop_now)
                    live_food = self.get_resource_balance(PROSPERITY_JUNIOR_RES_ID)
                    est_food = max(0, initial_food - (result["donated"] * PROSPERITY_JUNIOR_FOOD_COST))
                    effective_food = min(live_food, est_food)

                    if not loop_q_loaded or effective_q_done >= DAILY_QUEST_DONATE_TARGET:
                        self.log(
                            f"✅ [ازدهار التحالف] اكتملت مهمة التبرع بالنشاط اليومي ({effective_q_done}/{DAILY_QUEST_DONATE_TARGET}) — توقف آمن."
                        )
                        break
                    if loop_locked or loop_rem_cd >= MAX_CD_LIMIT:
                        self.log(
                            f"⏳ [ازدهار التحالف] وصل مؤقت الازدهار إلى حالة القفل/الامتلاء بعد {result['donated']} تبرع — توقف آمن."
                        )
                        break
                    if loop_daily_rem <= 0:
                        self.log(f"ℹ️ [ازدهار التحالف] اكتمل السقف اليومي بعد {result['donated']} تبرع — توقف آمن.")
                        break
                    if effective_food < PROSPERITY_JUNIOR_FOOD_COST:
                        self.log(f"ℹ️ [ازدهار التحالف] رصيد القمح لم يعد كافياً ({effective_food:,}) — توقف آمن.")
                        break

                r_pop = await self.safe_query(
                    "1010",
                    PROSPERITY_DONATE_CMD_SUB,
                    {"donatetype": PROSPERITY_DONATE_TYPE_JUNIOR},
                    min_delay=0.4,
                    max_delay=0.8,
                    action="تبرع ازدهار التحالف",
                )

                if self._is_resp_ok(r_pop):
                    result["donated"] += 1
                    ret_data = (
                        r_pop.get("data", {}).get("retdata", {})
                        if isinstance(r_pop, dict) and isinstance(r_pop.get("data"), dict)
                        else {}
                    )
                    get_info = ret_data.get("get", {}) if isinstance(ret_data, dict) and isinstance(ret_data.get("get"), dict) else {}
                    result["honor"] += self._safe_int(get_info.get("honor"), 0)
                    result["score"] += self._safe_int(get_info.get("score"), 0)
                    result["popularity"] += self._safe_int(get_info.get("addPopularity"), 0)
                else:
                    err_code = str(r_pop.get("err", "unknown")) if isinstance(r_pop, dict) else "timeout"
                    if err_code == "7162":
                        self.log(f"⏳ [ازدهار التحالف] تبرع الازدهار دخل مرحلة القفل (كود 7162) بعد {result['donated']} تبرع.")
                    elif err_code == "7164":
                        self.log(f"ℹ️ [ازدهار التحالف] اكتمل السقف اليومي للازدهار (كود 7164).")
                    elif err_code == "7159":
                        self.log("ℹ️ [ازدهار التحالف] لم تكتمل مدة الـ 4 ساعات بعد الانضمام (كود 7159).")
                    elif err_code == "7160":
                        self.log("ℹ️ [ازدهار التحالف] ميزة الازدهار غير مفتوحة بعد (كود 7160).")
                    else:
                        self.log(f"⚠️ [ازدهار التحالف] توقف التبرع عند المحاولة #{idx + 1} (كود السيرفر: {err_code}).")
                    break

                if idx + 1 < planned:
                    await asyncio.sleep(round(random.uniform(*DONATE_DELAY_RANGE), 2))

            if result["donated"] > 0:
                self.log(
                    f"✅ [ازدهار التحالف] تم تنفيذ {result['donated']} تبرع بنجاح "
                    f"(شرف +{result['honor']:,} | شعبية +{result['popularity']:,})."
                )

        # الجزء الثاني: استلام مكافآت ازدهار التحالف الجاهزة (CMD 1010/93)
        if claim_rewards:
            rewards_ready = self._get_prosperity_rewards_count()
            if rewards_ready > 0:
                self.log(f"🎁 [ازدهار التحالف] توجد {rewards_ready} مكافأة ازدهار جاهزة — جارٍ الاستلام (1010/93)...")
                r_rew = await self.safe_query(
                    "1010",
                    PROSPERITY_REWARD_CMD_SUB,
                    {},
                    min_delay=0.4,
                    max_delay=0.8,
                    action="استلام مكافأة ازدهار التحالف",
                )
                if self._is_resp_ok(r_rew):
                    result["rewards_claimed"] = rewards_ready
                    self.log(f"✅ [ازدهار التحالف] تم استلام {rewards_ready} مكافأة ازدهار بنجاح.")
                else:
                    err_code = str(r_rew.get("err", "unknown")) if isinstance(r_rew, dict) else "timeout"
                    self.log(f"⚠️ [ازدهار التحالف] تعذر استلام مكافأة الازدهار (كود السيرفر: {err_code}).")

        return result

    async def run(self) -> TaskResult:
        # 1. فحص الذاكرة الحية لعضوية التحالف (0-Network Pre-flight)
        alliance_id = self._get_alliance_id()
        if alliance_id == 0:
            self.log("ℹ️ القلعة ليست عضواً في أي تحالف — تم تخطي المهمة بأمان.")
            return TaskResult.skip("القلعة ليست عضواً في تحالف")

        self.log(f"🏛️ بدء مهمة التحالف (التحالف ID: {alliance_id})")

        # ══════════════════════════════════════════════════════════════
        #  الروتين 1: مساعدة التحالف (Alliance Help)
        # ══════════════════════════════════════════════════════════════
        help_ok, help_msg = await self._help_alliance_members()

        # ══════════════════════════════════════════════════════════════
        #  الروتين 2: التبرع المجاني لعلوم التحالف (Science Donation)
        # ══════════════════════════════════════════════════════════════
        total_donated_free = 0
        total_honor_earned = 0
        total_scipoints = 0
        target_sciid = None
        science_skip_reason = ""

        alliance_ctrl = self.init_data.get('allianceCtrl', {})
        minfo = alliance_ctrl.get('memberinfo', {}).get('minfo', {}) if isinstance(alliance_ctrl, dict) else {}

        if minfo.get('donateLock', 0) != 0:
            science_skip_reason = "التبرع لعلوم التحالف مقفل حالياً"
            self.log(f"ℹ️ {science_skip_reason} (donateLock != 0).")
        else:
            donate_cd = minfo.get('donateCD', {})
            starttime = int(donate_cd.get('starttime', 0)) if isinstance(donate_cd, dict) else 0
            totaltime = int(donate_cd.get('totaltime', 0)) if isinstance(donate_cd, dict) else 0
            now_ts = int(time.time())

            elapsed = max(0, now_ts - starttime) if starttime > 0 else 0
            current_cd = max(0, totaltime - elapsed)

            if current_cd >= MAX_CD_LIMIT:
                science_skip_reason = f"شريط الانتظار ممتلئ (متبقي {current_cd}s)"
                self.log(f"⏳ شريط انتظار التبرع ممتلئ بالكامل (متبقي {current_cd} ثانية / ~{current_cd // 60} دقيقة) — تم التخطي بأمان (0-Network).")
            else:
                available_count = min(20, max(0, (MAX_CD_LIMIT - current_cd) // STEP_CD))
                if available_count <= 0:
                    science_skip_reason = "رصيد التبرع المتاح حالياً هو 0"
                    self.log("ℹ️ رصيد التبرعات المتاح حالياً هو 0 — بانتظار تبريد عداد الانتظار.")
                else:
                    self.log(f"📊 الرصيد المتاح للتبرع حالياً: {available_count} تبرع (شريط الانتظار المشغول: {current_cd // 60} دقيقة).")
                    target_sciid = self._find_recommended_science()
                    if not target_sciid:
                        self.log("ℹ️ جميع تقنيات التحالف مكتملة النجوم وبانتظار ترقية البحث من القائد (R4/R5) — تم التجاوز بأمان.")
                    else:
                        self.log(f"🚀 بدء تنفيذ {available_count} تبرع بالموارد للتقنية #{target_sciid}...")
                        for i in range(available_count):
                            r_donate = await self.safe_query('1010', '48', {
                                "sciid": target_sciid,
                                "donatetype": DONATE_TYPE_FREE
                            }, min_delay=0.4, max_delay=0.8, action="تبرع علوم التحالف")

                            if r_donate and str(r_donate.get('err', '0')) == '0':
                                total_donated_free += 1
                                ret = r_donate.get('data', {}).get('retdata', {})
                                ret_dict = ret if isinstance(ret, dict) else {}
                                get_info = ret_dict.get('get', {}) if isinstance(ret_dict.get('get'), dict) else {}
                                total_honor_earned += int(get_info.get('honor', 0))
                                total_scipoints += int(get_info.get('scipoint', 0))

                                new_minfo = ret_dict.get('memberinfo', {})
                                if isinstance(new_minfo, dict) and new_minfo:
                                    if 'memberinfo' in alliance_ctrl and isinstance(alliance_ctrl['memberinfo'], dict):
                                        alliance_ctrl['memberinfo']['minfo'] = new_minfo

                                remain = ret_dict.get('donateCount')
                                if remain is not None and int(remain) <= 0:
                                    self.log(f"ℹ️ استُهلك كامل الرصيد المتاح عند التبرع {total_donated_free}.")
                                    break
                            else:
                                err_code = str(r_donate.get('err', 'unknown')) if r_donate else 'timeout'
                                if err_code == '7034':
                                    self.log(f"⏳ وصل شريط الانتظار إلى الحد الأقصى (كود 7034).")
                                elif err_code == '7036':
                                    self.log("ℹ️ جميع تقنيات التحالف مكتملة النجوم وبانتظار ترقية البحث من القائد (R4/R5) — تم التجاوز بأمان.")
                                elif total_donated_free == 0:
                                    self.log(f"ℹ️ تعذر التبرع حالياً (كود السيرفر: {err_code}).")
                                else:
                                    self.log(f"✅ اكتملت التبرعات المتاحة: {total_donated_free} تبرع (كود السيرفر: {err_code}).")
                                break

                            await asyncio.sleep(round(random.uniform(*DONATE_DELAY_RANGE), 2))

        # ══════════════════════════════════════════════════════════════
        #  الروتين 2B: المسار الاحتياطي — تبرع ازدهار/شعبية التحالف (1010/91 & 1010/93)
        # ══════════════════════════════════════════════════════════════
        prosperity_res: Dict[str, Any] = {
            "donated": 0,
            "honor": 0,
            "score": 0,
            "popularity": 0,
            "rewards_claimed": 0,
            "skip_reason": "",
        }
        if total_donated_free == 0 and self._is_prosperity_unlocked():
            prosperity_res = await self._donate_alliance_prosperity()

        # ══════════════════════════════════════════════════════════════
        #  الروتين 3: كنز التحالف (Alliance Treasure)
        # ══════════════════════════════════════════════════════════════
        treasure_ok, treasure_msg = await self._treasure_alliance()

        # ══════════════════════════════════════════════════════════════
        #  تجميع النتائج الموحدة (Consolidated Task Result)
        # ══════════════════════════════════════════════════════════════
        summary_parts = []
        if help_ok:
            summary_parts.append(help_msg)
        if total_donated_free > 0:
            summary_parts.append(f"{total_donated_free} تبرع مجاني للتحالف (شرف +{total_honor_earned:,})")
        if prosperity_res["donated"] > 0:
            summary_parts.append(
                f"{prosperity_res['donated']} تبرع ازدهار للتحالف (شرف +{prosperity_res['honor']:,})"
            )
        if prosperity_res["rewards_claimed"] > 0:
            summary_parts.append(f"استلام {prosperity_res['rewards_claimed']} مكافأة ازدهار")
        if treasure_ok and "تم إنجاز" in treasure_msg:
            summary_parts.append(treasure_msg)

        if summary_parts:
            final_msg = " | ".join(summary_parts)
            self.log(f"✅ [alliance] {final_msg}")
            return TaskResult.ok(
                final_msg,
                data={
                    "help_done": help_ok,
                    "free_donated": total_donated_free,
                    "honor_earned": total_honor_earned,
                    "sci_points": total_scipoints,
                    "sciid": target_sciid,
                    "prosperity_donated": prosperity_res["donated"],
                    "prosperity_honor": prosperity_res["honor"],
                    "prosperity_popularity": prosperity_res["popularity"],
                    "prosperity_rewards_claimed": prosperity_res["rewards_claimed"],
                    "treasure_msg": treasure_msg,
                }
            )

        donate_skip_text = prosperity_res["skip_reason"] or science_skip_reason or "رصيد الانتظار ممتلئ"
        return TaskResult.skip(
            f"مساعدة التحالف: {help_msg} | التبرع: {donate_skip_text} | الكنز: {treasure_msg}"
        )
        