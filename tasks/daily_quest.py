# -*- coding: utf-8 -*-
"""
tasks/daily_quest.py — مهمة استلام صناديق النشاط اليومي وجوائز مهام التنمية (DailyQuestTask)
═════════════════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. تعمل كآخر مهمة في دورة البوت بعد إنجاز كافة الأنشطة اليومية الأخرى.
  2. القسم الأول — صناديق النشاط اليومي (everydayTaskCtrl | CMD 2027):
     - فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight):
       احتساب مجموع نقاط النشاط الحالية من everydayTaskCtrl.eventInfo ومقارنة
       الصناديق الجاهزة بسجل الصناديق المستلمة everydayTaskCtrl.normalRecord.
     - استعلام احتياطي آمن (CMD 2027 / SUBCMD 1) فقط عند غياب المتحكم أو انتهاء اليوم (tomorrowZeroUTC).
     - استلام الصناديق الثمانية المجانية حصراً عبر CMD 2027 / SUBCMD 2 مع فواصل بشرية ومزامنة فورية.
  3. القسم الثاني — جوائز مهام التنمية (questCtrl | CMD 1028):
     - فحص مسبق من الذاكرة الحية (0-Network Pre-flight) لمهام التوجيه (guideQuest / pGuideQuest)
       والمهام العادية (questArray) والمهام التشغيلية (oQuestArray) مع منع التكرار حسب questID.
     - التحقق من استحقاق الجائزة وفق كود اللعبة الرسمي (questDef.lua / questCell.lua):
       status == 3 (gQuestStatus.COMMIT) أو (status == 2 و aim > 0 و progress >= aim).
     - استلام المهام العادية والتوجيهية عبر CMD 1028 / SUBCMD 2 (REQ_COMMIT_QUEST)
       والمهام التشغيلية الجاهزة عبر CMD 1028 / SUBCMD 4 (REQ_COMMIT_OPERATIONAL_QUEST).
     - دعم استلام السلاسل المتتابعة (Chain Claims) إذا أعاد السيرفر مهمة تالية جاهزة للاستلام،
       مع سقف أمان ومزامنة فورية للذاكرة الحية.
  4. استقلالية القسمين: تعذر أحد القسمين أو خلوه لا يمنع تنفيذ القسم الآخر.
"""

from __future__ import annotations

import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

from tasks.base_task import BaseTask, TaskResult

# ── أكواد وحدة المهام اليومية الرسمية (cmdDef.lua / errDef.lua) ──
CMD_EVERYDAY_TASK_MODULE = "2027"
REQ_EVERYDAY_TASK_INIT = "1"            # استعلام المزامنة الشامل الاحتياطي
REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"  # استلام الصناديق اليومية الثمانية المجانية

ERR_EVERYDAY_TASK_INDEX_ILLEGAL = "470001"
ERR_EVERYDAY_TASK_POINT_NOT_ENOUGH = "470002"
ERR_EVERYDAY_TASK_ALREADY_RECEIVE = "470003"

# ── أكواد وحدة مهام التنمية الرسمية (cmdDef.lua / questDef.lua) ──
CMD_QUEST_MODULE = "1028"
REQ_INIT_QUESTDATA = "1"                # استعلام مزامنة مهام التنمية الاحتياطي
REQ_COMMIT_QUEST = "2"                  # استلام جائزة مهمة تنمية (عادية أو توجيهية)
REQ_COMMIT_OPERATIONAL_QUEST = "4"      # استلام جائزة مهمة تشغيلية (oQuestArray)

QUEST_STATUS_NONE = 0
QUEST_STATUS_NOT_BEGIN = 1
QUEST_STATUS_PERFORMING = 2
QUEST_STATUS_COMMIT = 3                 # جاهزة لاستلام الجائزة (questCell:canCommit())
QUEST_STATUS_FINISH = 4

MAX_QUEST_CLAIMS_PER_CYCLE = 25         # سقف أمان لمنع الحلقات اللانهائية في سلاسل المهام

# جدول الصناديق الثمانية وعتبات النقاط المطلوبة لكل صندوق (من daily_reward_point_items.lua)
CHEST_MILESTONES: List[Tuple[int, int]] = [
    (1, 30),
    (2, 70),
    (3, 120),
    (4, 180),
    (5, 260),
    (6, 340),
    (7, 420),
    (8, 500),
]
CHEST_THRESHOLD_MAP: Dict[int, int] = dict(CHEST_MILESTONES)

# جدول إعدادات نقاط المهام الـ 33 الرسمية: {task_type: (points_per_action, max_limit_time)}
# مستخرج ومطابق تماماً لـ daily_reward_point_config.lua
DAILY_QUEST_POINT_RULES: Dict[int, Tuple[int, int]] = {
    1: (3, 5),      # جمع قمح (4100001)
    2: (3, 5),      # جمع خشب (4100002)
    3: (3, 5),      # جمع حديد (4100003)
    4: (3, 5),      # جمع فضة (4100004)
    5: (3, 5),      # قتل وحوش (4100005)
    6: (30, 1),     # تطوير مبنى (4100006)
    7: (30, 1),     # بحث معهد (4100007)
    8: (2, 10),     # إهداء زهور (4100008)
    9: (20, 1),     # تصنيع عتاد (4100009)
    10: (10, 1),    # تجميع مواد (4100010)
    11: (3, 5),     # علاج مصابين (4100011)
    12: (5, 5),     # تدريب مشاة (4100012)
    13: (5, 5),     # تدريب رماة (4100013)
    14: (5, 5),     # تدريب فرسان (4100014)
    15: (5, 5),     # تدريب عربات (4100015)
    16: (3, 5),     # تصنيع فخاخ (4100016)
    17: (10, 1),    # قلب بطاقة دعم الموارد (4100017)
    18: (1, 40),    # مساعدة أعضاء التحالف (4100018)
    19: (10, 1),    # دعم التحالف بالقوات (4100019)
    20: (10, 1),    # دعم التحالف بالموارد (4100020)
    21: (1, 20),    # تبرع لعلوم التحالف (4100021)
    22: (2, 10),    # استلام بضائع الميناء (4100022)
    23: (1, 20),    # استكشاف نافورة الكنوز (4100023)
    24: (2, 10),    # الشراء من التاجر العجيب (4100024)
    25: (20, 1),    # كفاءة الجندي (4100025)
    26: (15, 1),    # استكشاف الهرم (4100026)
    27: (20, 1),    # متجر وسام الحرب (4100027)
    28: (20, 1),    # إطعام الحيوان (4100028)
    29: (10, 5),    # استهلاك الذهب (4100029)
    30: (5, 3),     # تحدي الحلبة (4100030)
    31: (5, 5),     # الحرب الملحمية (4100031)
    32: (30, 1),    # تقوية المباني (4100032)
    33: (10, 1),    # قاعة الأوامر (4100033)
}


class DailyQuestTask(BaseTask):
    """
    مهمة فحص واستلام صناديق النشاط اليومي الجاهزة (صناديق الـ 500 نقطة)
    إضافة إلى جمع جوائز مهام التنمية الجاهزة (questCtrl).
    """
    name = "daily_quest"
    alias = "daily_activity"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    @property
    def is_active(self) -> bool:
        """المهمة إلزامية ودائمة وتعمل تلقائياً في الخلفية لجميع القلاع دون أخذ رأي المستخدم."""
        return True

    # ══════════════════════════════════════════════════════════════════
    # أدوات مساعدة عامة
    # ══════════════════════════════════════════════════════════════════

    @staticmethod
    def _extract_err(res: Any) -> Tuple[bool, str]:
        """استخراج حالة الاستجابة ورمز الخطأ بشكل موحد وآمن."""
        if not isinstance(res, dict):
            return False, "NoResponse"
        err_raw = res.get("err")
        if err_raw is None and "code" in res:
            err_raw = res.get("code")
        err_str = str(err_raw).strip() if err_raw is not None else "-1"
        return True, err_str

    @classmethod
    def _is_success_response(cls, res: Any) -> bool:
        ok, err_str = cls._extract_err(res)
        return ok and err_str in ("0", "Err_None")

    @staticmethod
    def _as_dict(val: Any) -> Dict[str, Any]:
        """تحويل القواميس أو المصفوفات الفارغة القادمة من Lua/JSON إلى dict آمن."""
        return val if isinstance(val, dict) else {}

    @staticmethod
    def _safe_int(val: Any, default: int = 0) -> int:
        try:
            if val is None or val == "":
                return default
            return int(val)
        except (ValueError, TypeError):
            return default

    # ══════════════════════════════════════════════════════════════════
    # القسم الأول: صناديق النشاط اليومي (everydayTaskCtrl | CMD 2027)
    # ══════════════════════════════════════════════════════════════════

    @staticmethod
    def calculate_cur_points(event_info: Any) -> int:
        """
        احتساب مجموع نقاط النشاط اليومي الحالية من سجل eventInfo.
        يطابق دالة everydayTaskCtrl:calCurPoint() الرسمية مع تفادي التكرار التام
        في حال احتواء الذاكرة الحية على كل من معرف المهمة الكامل (4100001..4100033) ونوعها القصير (1..33).
        """
        if not isinstance(event_info, dict):
            return 0

        task_counts: Dict[int, int] = {}
        for raw_k, raw_count in event_info.items():
            try:
                k_int = int(raw_k)
                task_type = k_int % 4100000 if k_int > 4100000 else k_int
                count = max(0, int(raw_count or 0))
                task_counts[task_type] = max(task_counts.get(task_type, 0), count)
            except (ValueError, TypeError):
                continue

        total = 0
        for task_type, count in task_counts.items():
            rule = DAILY_QUEST_POINT_RULES.get(task_type)
            if rule:
                point, limit_time = rule
                total += point * min(count, limit_time)
        return total

    @staticmethod
    def get_unclaimed_ready_chests(cur_points: int, normal_record: Any) -> List[int]:
        """
        استخراج قائمة فهارس الصناديق الجاهزة للاستلام التي لم تُستلم اليوم بعد.
        يتجاهل القيم الصفرية أو الفارغة إن وُجدت في normalRecord.
        """
        claimed_keys: Set[str] = set()
        if isinstance(normal_record, dict):
            for k, v in normal_record.items():
                if v not in (None, False, 0, "0", ""):
                    claimed_keys.add(str(k))

        ready: List[int] = []
        for index, threshold in CHEST_MILESTONES:
            if cur_points >= threshold and str(index) not in claimed_keys:
                ready.append(index)
        return ready

    async def _ensure_synced_memory(self) -> Tuple[Optional[Dict[str, Any]], bool]:
        """
        التحقق من جاهزية متحكم everydayTaskCtrl في الذاكرة الحية.
        إذا كان مفقوداً أو منتهي الصلاحية، يتم إرسال الاستعلام الاحتياطي الآمن (CMD 2027 / SUBCMD 1).
        يعيد: (everyday_ctrl, was_queried_over_network)
        """
        ctrl = self.get_ctrl("everydayTaskCtrl")
        now_ts = int(time.time())

        # فحص صلاحية البيانات الحالية مع قبول المصفوفات الفارغة [] أو None الناتجة عن Lua JSON
        if isinstance(ctrl, dict) and any(
            k in ctrl for k in ("eventInfo", "normalRecord", "tomorrowZeroUTC", "chestReward")
        ):
            event_info_raw = ctrl.get("eventInfo")
            normal_rec_raw = ctrl.get("normalRecord")
            valid_event = event_info_raw is None or isinstance(event_info_raw, (dict, list))
            valid_normal = normal_rec_raw is None or isinstance(normal_rec_raw, (dict, list))

            if valid_event and valid_normal:
                tomorrow_zero = self._safe_int(ctrl.get("tomorrowZeroUTC"), 0)
                if tomorrow_zero == 0 or now_ts < tomorrow_zero:
                    if not isinstance(event_info_raw, dict):
                        ctrl["eventInfo"] = {}
                    if not isinstance(normal_rec_raw, dict):
                        ctrl["normalRecord"] = {}
                    return ctrl, False

        # تنفيذ الاستعلام الاحتياطي الآمن عند نقص البيانات أو تجدد اليوم
        self.log("📡 [صناديق النشاط] استعلام احتياطي لتحديث بيانات المهام اليومية من السيرفر (CMD 2027/1)...")
        resp = await self.safe_query(CMD_EVERYDAY_TASK_MODULE, REQ_EVERYDAY_TASK_INIT, {})
        if self._is_success_response(resp) and isinstance(resp.get("data"), dict):
            srv_data = resp["data"]
            if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                ctrl = self.conn.init_data.setdefault("everydayTaskCtrl", {})
                if not isinstance(ctrl, dict):
                    ctrl = {}
                    self.conn.init_data["everydayTaskCtrl"] = ctrl
            else:
                ctrl = {}

            # استبدال الحقول الرسمية كما في everydayTaskCtrl:everydayTaskInitResp
            # لمنع بقاء سجلات اليوم السابق عند تجدد اليوم
            ctrl["eventInfo"] = self._as_dict(srv_data.get("eventInfo"))
            ctrl["normalRecord"] = self._as_dict(srv_data.get("normalRecord"))
            if "chestRecord" in srv_data:
                ctrl["chestRecord"] = self._as_dict(srv_data.get("chestRecord"))
            if "chestReward" in srv_data:
                ctrl["chestReward"] = self._as_dict(srv_data.get("chestReward"))
            if "serverLv" in srv_data:
                ctrl["serverLv"] = srv_data.get("serverLv")

            # تجديد tomorrowZeroUTC إذا لم يرسله السيرفر في رد 2027/1 لمنع تكرار الاستعلام في كل دورة
            srv_tomorrow = self._safe_int(srv_data.get("tomorrowZeroUTC"), 0)
            if srv_tomorrow > now_ts:
                ctrl["tomorrowZeroUTC"] = srv_tomorrow
            else:
                ctrl["tomorrowZeroUTC"] = ((now_ts // 86400) + 1) * 86400

            return ctrl, True

        self.log("⚠️ [صناديق النشاط] تعذر تحديث بيانات المهام اليومية عبر الاستعلام الاحتياطي.")
        return None, True

    async def _run_daily_activity_chests(self) -> Dict[str, Any]:
        """تنفيذ قسم صناديق النشاط اليومي وإعادة ملخص منظم دون إيقاف بقية المهام."""
        everyday_ctrl, queried = await self._ensure_synced_memory()
        if not isinstance(everyday_ctrl, dict):
            return {
                "status": "unavailable",
                "queried": queried,
                "cur_points": 0,
                "claimed_indices": [],
                "already_claimed_indices": [],
                "failed_indices": [],
                "hit_points_not_enough": False,
                "summary": "تعذر الحصول على بيانات النشاط اليومي",
            }

        event_info = self._as_dict(everyday_ctrl.get("eventInfo"))
        normal_record = self._as_dict(everyday_ctrl.get("normalRecord"))
        everyday_ctrl["eventInfo"] = event_info
        everyday_ctrl["normalRecord"] = normal_record

        cur_points = self.calculate_cur_points(event_info)
        ready_chests = self.get_unclaimed_ready_chests(cur_points, normal_record)

        if not ready_chests:
            network_status = "بعد المزامنة" if queried else "0-Network"
            return {
                "status": "none_ready",
                "queried": queried,
                "cur_points": cur_points,
                "claimed_indices": [],
                "already_claimed_indices": [],
                "failed_indices": [],
                "hit_points_not_enough": False,
                "summary": f"لا توجد صناديق نشاط جاهزة ({network_status} | {cur_points}/500)",
            }

        self.log(
            f"🎁 [صناديق النشاط] تم رصد {len(ready_chests)} صندوق جاهز للاستلام "
            f"(النقاط: {cur_points}/500 | الصناديق: {ready_chests})."
        )

        claimed_indices: List[int] = []
        already_claimed_indices: List[int] = []
        failed_indices: List[int] = []
        hit_points_not_enough = False

        for index in ready_chests:
            threshold = CHEST_THRESHOLD_MAP.get(index, 0)
            self.log(f"📦 [صناديق النشاط] جاري استلام الصندوق {index} ({threshold} نقطة)...")

            res = await self.safe_query(
                CMD_EVERYDAY_TASK_MODULE,
                REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
                {"index": index},
                min_delay=0.6,
                max_delay=1.2,
            )

            is_dict_res, err_str = self._extract_err(res)

            if is_dict_res and err_str in ("0", "Err_None"):
                claimed_indices.append(index)

                # استبدال normalRecord بالكامل من رد السيرفر إن وُجد (مطابق لـ everydayTaskReceiveNormalResp)
                srv_data = res.get("data") if isinstance(res.get("data"), dict) else {}
                srv_normal_rec = srv_data.get("normalRecord")
                if isinstance(srv_normal_rec, dict):
                    normal_record = dict(srv_normal_rec)
                else:
                    normal_record[str(index)] = 1

                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")

            elif is_dict_res and err_str == ERR_EVERYDAY_TASK_ALREADY_RECEIVE:
                # الصندوق مستلم مسبقاً اليوم على السيرفر — نحدّث الذاكرة ولا نعدّه استلاماً جديداً
                already_claimed_indices.append(index)
                normal_record[str(index)] = 1
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"ℹ️ [صناديق النشاط] الصندوق {index} مستلم مسبقاً اليوم على السيرفر — تم تحديث الذاكرة الحية.")

            elif is_dict_res and err_str == ERR_EVERYDAY_TASK_POINT_NOT_ENOUGH:
                hit_points_not_enough = True
                self.log(
                    f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index}: نقاط النشاط على السيرفر "
                    f"لم تبلغ عتبة هذا الصندوق ({threshold} نقطة) بعد (رمز الخطأ: {ERR_EVERYDAY_TASK_POINT_NOT_ENOUGH})."
                )
                # التوقف الفوري لمنع إرسال طلبات لصناديق أعلى غير مستحقة
                break

            elif is_dict_res and err_str == ERR_EVERYDAY_TASK_INDEX_ILLEGAL:
                failed_indices.append(index)
                self.log(
                    f"⚠️ [صناديق النشاط] فهرس الصندوق {index} غير صالح على السيرفر "
                    f"(رمز الخطأ: {ERR_EVERYDAY_TASK_INDEX_ILLEGAL})."
                )

            else:
                failed_indices.append(index)
                self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_str}).")

        if claimed_indices:
            summary = f"صناديق النشاط: استلام {len(claimed_indices)} ({claimed_indices}) | {cur_points}/500"
            status = "claimed"
        elif already_claimed_indices and not failed_indices:
            summary = f"صناديق النشاط: مزامنة {len(already_claimed_indices)} مستلمة مسبقاً ({already_claimed_indices}) | {cur_points}/500"
            status = "synced_already_claimed"
        elif hit_points_not_enough:
            summary = f"صناديق النشاط: نقاط السيرفر لم تبلغ عتبة الصندوق {ready_chests[0]} بعد ({cur_points}/500)"
            status = "not_enough_points"
        else:
            summary = f"صناديق النشاط: فشل استلام {failed_indices or ready_chests}"
            status = "failed"

        return {
            "status": status,
            "queried": queried,
            "cur_points": cur_points,
            "claimed_indices": claimed_indices,
            "already_claimed_indices": already_claimed_indices,
            "failed_indices": failed_indices,
            "hit_points_not_enough": hit_points_not_enough,
            "summary": summary,
        }

    # ══════════════════════════════════════════════════════════════════
    # القسم الثاني: جوائز مهام التنمية (questCtrl | CMD 1028)
    # ══════════════════════════════════════════════════════════════════

    @classmethod
    def _is_quest_claimable(cls, quest: Any) -> bool:
        """
        التحقق من استحقاق مهمة تنمية للاستلام وفق questDef.lua و questCell.lua:
          - status == 3 (gQuestStatus.COMMIT) => جاهزة للاستلام مباشرة.
          - status == 2 (PERFORMING) مع aim > 0 و progress >= aim => مكتملة وجاهزة (questCell:setProgress).
          - استبعاد المهام المقفلة (lock=True) أو المنتهية (status == 4) أو غير الصالحة.
        """
        if not isinstance(quest, dict):
            return False
        if quest.get("lock"):
            return False

        qid = cls._safe_int(quest.get("questID"), 0)
        if qid <= 0:
            return False

        status = cls._safe_int(quest.get("status"), QUEST_STATUS_NONE)
        if status == QUEST_STATUS_COMMIT:
            return True

        if status == QUEST_STATUS_PERFORMING:
            aim = cls._safe_int(quest.get("aim"), 0)
            progress = cls._safe_int(quest.get("progress"), 0)
            if aim > 0 and progress >= aim:
                return True

        return False

    @classmethod
    def _apply_pending_quest_notify_patch(cls, quest_ctrl: Dict[str, Any]) -> None:
        """
        في حال وصل إشعار NOTIFY_QUEST (12) من نوع 'update' ودُمج سطحياً عبر live_memory،
        نطبّق التقدم الجديد على المهمة المطابقة في questArray/guideQuest/pGuideQuest.
        """
        if quest_ctrl.get("notifyType") != "update":
            return
        updated_qid = cls._safe_int(quest_ctrl.get("questID"), 0)
        if updated_qid <= 0 or "progress" not in quest_ctrl:
            return
        new_progress = cls._safe_int(quest_ctrl.get("progress"), 0)

        def _patch_entry(entry: Any) -> None:
            if not isinstance(entry, dict):
                return
            if cls._safe_int(entry.get("questID"), 0) == updated_qid:
                cur_prog = cls._safe_int(entry.get("progress"), 0)
                if new_progress > cur_prog:
                    entry["progress"] = new_progress
                aim = cls._safe_int(entry.get("aim"), 0)
                if aim > 0 and cls._safe_int(entry.get("progress"), 0) >= aim:
                    if cls._safe_int(entry.get("status"), 0) == QUEST_STATUS_PERFORMING:
                        entry["status"] = QUEST_STATUS_COMMIT

        _patch_entry(quest_ctrl.get("guideQuest"))
        _patch_entry(quest_ctrl.get("pGuideQuest"))
        qa = quest_ctrl.get("questArray")
        if isinstance(qa, list):
            for item in qa:
                _patch_entry(item)

    @classmethod
    def _collect_claimable_quests(
        cls,
        quest_ctrl: Dict[str, Any],
        exclude_ids: Optional[Set[int]] = None,
    ) -> List[Tuple[int, bool]]:
        """
        جمع كل مهام التنمية الجاهزة للاستلام بدون تكرار (مرتبة: التوجيهية -> العادية -> التشغيلية).
        يعيد قائمة من الأزواج: [(quest_id, is_operational), ...]
        """
        cls._apply_pending_quest_notify_patch(quest_ctrl)

        excluded = exclude_ids or set()
        seen: Set[int] = set()
        result: List[Tuple[int, bool]] = []

        def _try_add(entry: Any, is_operational: bool) -> None:
            if not cls._is_quest_claimable(entry):
                return
            qid = cls._safe_int(entry.get("questID"), 0)
            if qid <= 0 or qid in seen or qid in excluded:
                return
            seen.add(qid)
            result.append((qid, is_operational))

        # 1. مهمة التوجيه الموصى بها (guideQuest / pGuideQuest)
        _try_add(quest_ctrl.get("guideQuest"), False)
        _try_add(quest_ctrl.get("pGuideQuest"), False)

        # 2. قائمة مهام التنمية العادية (questArray)
        quest_array = quest_ctrl.get("questArray")
        if isinstance(quest_array, list):
            for q in quest_array:
                _try_add(q, False)

        # 3. المهام التشغيلية الجاهزة فقط (oQuestArray -> SUBCMD 4)
        o_quest_array = quest_ctrl.get("oQuestArray")
        if isinstance(o_quest_array, list):
            for q in o_quest_array:
                _try_add(q, True)

        return result

    async def _ensure_synced_quest_memory(self) -> Tuple[Optional[Dict[str, Any]], bool]:
        """
        التحقق من وجود متحكم questCtrl في الذاكرة الحية (0-Network).
        عند غيابه بالكامل فقط يُرسل الاستعلام الاحتياطي الرسمي (CMD 1028 / SUBCMD 1).
        """
        ctrl = self.get_ctrl("questCtrl")
        if isinstance(ctrl, dict) and any(
            k in ctrl for k in ("questArray", "guideQuest", "pGuideQuest", "oQuestArray")
        ):
            return ctrl, False

        self.log("📡 [مهام التنمية] استعلام احتياطي لجلب بيانات مهام التنمية من السيرفر (CMD 1028/1)...")
        resp = await self.safe_query(CMD_QUEST_MODULE, REQ_INIT_QUESTDATA, {})
        if self._is_success_response(resp) and isinstance(resp.get("data"), dict):
            srv_data = resp["data"]
            if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                ctrl = self.conn.init_data.setdefault("questCtrl", {})
                if not isinstance(ctrl, dict):
                    ctrl = {}
                    self.conn.init_data["questCtrl"] = ctrl
            else:
                ctrl = {}

            if isinstance(srv_data.get("questArray"), list):
                ctrl["questArray"] = srv_data["questArray"]
            if isinstance(srv_data.get("guideQuest"), dict):
                ctrl["guideQuest"] = srv_data["guideQuest"]
            if isinstance(srv_data.get("pGuideQuest"), dict):
                ctrl["pGuideQuest"] = srv_data["pGuideQuest"]
            if isinstance(srv_data.get("oQuestArray"), list):
                ctrl["oQuestArray"] = srv_data["oQuestArray"]
            return ctrl, True

        self.log("⚠️ [مهام التنمية] تعذر تحديث بيانات مهام التنمية عبر الاستعلام الاحتياطي.")
        return None, True

    @classmethod
    def _sync_quest_memory_after_commit(
        cls,
        quest_ctrl: Dict[str, Any],
        claimed_qid: int,
        is_operational: bool,
        resp_data: Dict[str, Any],
    ) -> None:
        """
        مزامنة questCtrl في الذاكرة الحية مباشرة بعد استلام جائزة مهمة بنجاح،
        بشكل مطابق تماماً لـ questCtrl.lua (commitQuestRsp / commitOperationalQuestRsp).
        """
        if is_operational:
            oqa = quest_ctrl.get("oQuestArray")
            if isinstance(oqa, list):
                quest_ctrl["oQuestArray"] = [
                    q for q in oqa
                    if not (isinstance(q, dict) and cls._safe_int(q.get("questID"), 0) == claimed_qid)
                ]
            return

        # إزالة المهمة المستلمة من questArray وإضافة المهمة التالية (data.property) إن وُجدت
        qa = quest_ctrl.get("questArray")
        new_qa: List[Any] = []
        if isinstance(qa, list):
            new_qa = [
                q for q in qa
                if not (isinstance(q, dict) and cls._safe_int(q.get("questID"), 0) == claimed_qid)
            ]

        next_prop = resp_data.get("property")
        if isinstance(next_prop, dict) and cls._safe_int(next_prop.get("questID"), 0) > 0:
            next_qid = cls._safe_int(next_prop.get("questID"), 0)
            new_qa = [
                q for q in new_qa
                if not (isinstance(q, dict) and cls._safe_int(q.get("questID"), 0) == next_qid)
            ]
            new_qa.append(next_prop)

        quest_ctrl["questArray"] = new_qa

        # تحديث guideQuest
        if "guideQuest" in resp_data:
            quest_ctrl["guideQuest"] = resp_data.get("guideQuest")
        elif (
            isinstance(quest_ctrl.get("guideQuest"), dict)
            and cls._safe_int(quest_ctrl["guideQuest"].get("questID"), 0) == claimed_qid
        ):
            quest_ctrl["guideQuest"] = None

        # تحديث pGuideQuest
        if "pGuideQuest" in resp_data:
            quest_ctrl["pGuideQuest"] = resp_data.get("pGuideQuest")
        elif (
            isinstance(quest_ctrl.get("pGuideQuest"), dict)
            and cls._safe_int(quest_ctrl["pGuideQuest"].get("questID"), 0) == claimed_qid
        ):
            quest_ctrl["pGuideQuest"] = None

    async def _run_development_quests(self) -> Dict[str, Any]:
        """
        تنفيذ قسم جمع جوائز مهام التنمية (questCtrl) مع دعم استلام السلاسل المتتابعة
        بشكل آمن ومحدود وبفواصل بشرية.
        """
        quest_ctrl, queried = await self._ensure_synced_quest_memory()
        if not isinstance(quest_ctrl, dict):
            return {
                "status": "unavailable",
                "queried": queried,
                "claimed_quests": [],
                "claimed_operational_quests": [],
                "failed_quests": [],
                "summary": "تعذر الحصول على بيانات مهام التنمية",
            }

        attempted_ids: Set[int] = set()
        claimed_quests: List[int] = []
        claimed_operational: List[int] = []
        failed_quests: List[int] = []

        initial_ready = self._collect_claimable_quests(quest_ctrl)
        if not initial_ready:
            network_status = "بعد المزامنة" if queried else "0-Network"
            return {
                "status": "none_ready",
                "queried": queried,
                "claimed_quests": [],
                "claimed_operational_quests": [],
                "failed_quests": [],
                "summary": f"لا توجد جوائز مهام تنمية جاهزة ({network_status})",
            }

        self.log(
            f"🏆 [مهام التنمية] تم رصد {len(initial_ready)} جائزة جاهزة للاستلام "
            f"(المهام: {[qid for qid, _ in initial_ready]})."
        )

        # حلقة آمنة تدعم استلام المهام المتتابعة التي تُفتح مكتملة فور استلام السابقة
        while len(attempted_ids) < MAX_QUEST_CLAIMS_PER_CYCLE:
            batch = self._collect_claimable_quests(quest_ctrl, exclude_ids=attempted_ids)
            if not batch:
                break

            qid, is_operational = batch[0]
            attempted_ids.add(qid)

            subcmd = REQ_COMMIT_OPERATIONAL_QUEST if is_operational else REQ_COMMIT_QUEST
            kind_label = "مهمة تشغيلية" if is_operational else "مهمة تنمية"
            self.log(f"🎖️ [مهام التنمية] جاري جمع جائزة {kind_label} #{qid} (CMD 1028/{subcmd})...")

            res = await self.safe_query(
                CMD_QUEST_MODULE,
                subcmd,
                {"questID": qid},
                min_delay=0.6,
                max_delay=1.2,
            )

            is_dict_res, err_str = self._extract_err(res)
            if is_dict_res and err_str in ("0", "Err_None"):
                resp_data = res.get("data") if isinstance(res.get("data"), dict) else {}
                self._sync_quest_memory_after_commit(quest_ctrl, qid, is_operational, resp_data)
                if is_operational:
                    claimed_operational.append(qid)
                else:
                    claimed_quests.append(qid)
                self.log(f"✅ [مهام التنمية] تم جمع جائزة {kind_label} #{qid} بنجاح!")
            else:
                failed_quests.append(qid)
                self.log(f"⚠️ [مهام التنمية] تعذر جمع جائزة {kind_label} #{qid} (رمز الخطأ: {err_str}).")

        total_claimed = len(claimed_quests) + len(claimed_operational)
        if total_claimed > 0:
            all_ids = claimed_quests + claimed_operational
            return {
                "status": "claimed",
                "queried": queried,
                "claimed_quests": claimed_quests,
                "claimed_operational_quests": claimed_operational,
                "failed_quests": failed_quests,
                "summary": f"مهام التنمية: استلام {total_claimed} جائزة ({all_ids})",
            }

        return {
            "status": "failed",
            "queried": queried,
            "claimed_quests": [],
            "claimed_operational_quests": [],
            "failed_quests": failed_quests,
            "summary": f"مهام التنمية: فشل جمع الجوائز {failed_quests}",
        }

    # ══════════════════════════════════════════════════════════════════
    # نقطة الدخول الرئيسية للمهمة
    # ══════════════════════════════════════════════════════════════════

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة فحص واستلام:
          1. صناديق النشاط اليومي الجاهزة (everydayTaskCtrl | CMD 2027).
          2. جوائز مهام التنمية الجاهزة (questCtrl | CMD 1028).
        """
        daily_res = await self._run_daily_activity_chests()
        quest_res = await self._run_development_quests()

        result_data: Dict[str, Any] = {
            "claimed_chests": daily_res["claimed_indices"],
            "already_claimed_chests": daily_res["already_claimed_indices"],
            "total_points": daily_res["cur_points"],
            "claimed_quests": quest_res["claimed_quests"],
            "claimed_operational_quests": quest_res["claimed_operational_quests"],
        }

        combined_msg = f"{daily_res['summary']} | {quest_res['summary']}"

        # إذا تعذر الحصول على بيانات كلا المتحكمين معاً
        if daily_res["status"] == "unavailable" and quest_res["status"] == "unavailable":
            return TaskResult.skip("تعذر الحصول على بيانات everydayTaskCtrl و questCtrl من الذاكرة أو السيرفر.")

        # إذا لم يُستلم شيء وحدث فشل شبكي/سيرفر فعلي في أحد القسمين دون أي نجاح
        any_claimed = bool(
            daily_res["claimed_indices"]
            or quest_res["claimed_quests"]
            or quest_res["claimed_operational_quests"]
        )
        any_failed = daily_res["status"] == "failed" or quest_res["status"] == "failed"

        if any_failed and not any_claimed:
            return TaskResult(
                success=False,
                skipped=False,
                message=combined_msg,
                data=result_data,
            )

        return TaskResult.ok(combined_msg, data=result_data)