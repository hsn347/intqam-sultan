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
DAILY_QUEST_HELP_TARGET = 20    # الحد المطلوب لإنجاز مهمة مساعدة التحالف اليومية (20 مرة)

DONATE_TYPE_FREE = 1             # نوع التبرع بالموارد العادية (حديد/قمح/خشب) في السيرفر الرسمي
DEFAULT_SCI_ID = 33015           # المعرف الاحتياطي عند تعذر إيجاد تقنية
DONATE_DELAY_RANGE = (1.5, 2.8)  # فاصل بشري عشوائي بين التبرعات لمحاكاة النقر الطبيعي
MAX_CD_LIMIT = 14400             # سقف شريط الانتظار الأقصى (4 ساعات = 14,400 ثانية)
STEP_CD = 720                    # وقت الانتظار المضاف لكل تبرع فردي (12 دقيقة = 720 ثانية)

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
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict):
                helps_today = int(event_info.get(DAILY_QUEST_HELP_TYPE, 0) or 0)
                if helps_today >= DAILY_QUEST_HELP_TARGET:
                    self.log(f"ℹ️ مساعدة التحالف: مكتملة بالنشاط اليومي مسبقاً ({helps_today}/{DAILY_QUEST_HELP_TARGET}) — تم التجاوز بأمان (0-Network).")
                    return False, f"مكتملة بالنشاط اليومي مسبقاً ({helps_today}/{DAILY_QUEST_HELP_TARGET})"

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
            # 5. تحديث الذاكرة الحية فوراً (In-Memory State Sync)
            if isinstance(everyday_ctrl, dict):
                ev_info = everyday_ctrl.setdefault("eventInfo", {})
                if isinstance(ev_info, dict):
                    cur_c = int(ev_info.get(DAILY_QUEST_HELP_TYPE, 0) or 0)
                    ev_info[DAILY_QUEST_HELP_TYPE] = min(DAILY_QUEST_HELP_TARGET, cur_c + pending_helps)

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
            rspdata = r_init.get("rspdata") or r_init.get("data") or {}
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
                    dig["canReceive"] = False
                    actions_done.append(f"استلام كنز #{idx}")

        # 3. طلب مساعدة التحالف للكنوز الخاصة غير المكتملة
        for dig in dig_list:
            if isinstance(dig, dict) and dig.get("canCallHelp") and not dig.get("isHelped"):
                idx = dig.get("index")
                self.log(f"📣 إرسال طلب مساعدة التحالف لكنزك الخاص (صندوق #{idx})...")
                r_help_req = await self.safe_query("2015", "4", {"index": idx})
                if r_help_req and str(r_help_req.get("err", "")) in ("0", 0):
                    dig["canCallHelp"] = False
                    actions_done.append(f"طلب مساعدة لكنز #{idx}")

        # 4. استلام مكافآت مساعدة الأعضاء المكتملة
        help_info = treasure_ctrl.get("helpInfo", []) or []
        for item in list(help_info):
            if isinstance(item, dict) and item.get("canReceive"):
                idx = item.get("index")
                own_uid = item.get("ownUid")
                self.log(f"🎁 استلام جائزة مساعدة عضو التحالف (صندوق #{idx})...")
                r_h_rcv = await self.safe_query("2015", "6", {"receiveType": 2, "ownUid": own_uid, "index": idx})
                if r_h_rcv and str(r_h_rcv.get("err", "")) in ("0", 0):
                    item["canReceive"] = False
                    actions_done.append(f"استلام جائزة مساعدة #{idx}")

        # 5. الاستخراج المجاني (Free Dig)
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
                    other_info["digCount"] = dig_count + 1
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
        is_already_helping = any(
            isinstance(h, dict) and h.get("isHelped") and not h.get("canReceive")
            for h in (treasure_ctrl.get("helpInfo", []) or [])
        )
        max_help = int(other_info.get("maxHelpCount", 10) or 10)
        help_count = int(other_info.get("helpCount", 0) or 0)

        if not is_already_helping and help_count < max_help:
            can_help_map = treasure_ctrl.get("canHelpList", {}) or {}
            target_help = None
            if isinstance(can_help_map, dict):
                for u_id, box_list in can_help_map.items():
                    if str(u_id) == my_uid:
                        continue
                    boxes = box_list if isinstance(box_list, list) else [box_list]
                    for b in boxes:
                        if isinstance(b, dict) and not b.get("isHelped"):
                            target_help = (int(u_id), b.get("index"))
                            break
                    if target_help:
                        break

            if target_help:
                helped_uid, helped_idx = target_help
                self.log(f"🤝 تقديم مساعدة مجانية لكنز عضو التحالف (UID: {helped_uid} - صندوق #{helped_idx})...")
                r_help = await self.safe_query("2015", "5", {"helpedUid": helped_uid, "helpedIndex": helped_idx})
                if r_help and str(r_help.get("err", "")) in ("0", 0):
                    other_info["helpCount"] = help_count + 1
                    self.log(f"✅ تمت مساعدة كنز عضو التحالف بنجاح.")
                    actions_done.append(f"مساعدة عضو UID={helped_uid}")

        if actions_done:
            return True, "تم إنجاز: " + "، ".join(actions_done)
        return True, "لا توجد إجراءات كنز معلقة حالياً"

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
                    "treasure_msg": treasure_msg,
                }
            )

        return TaskResult.skip(
            f"مساعدة التحالف: {help_msg} | التبرع: {science_skip_reason or 'رصيد الانتظار ممتلئ'} | الكنز: {treasure_msg}"
        )
        