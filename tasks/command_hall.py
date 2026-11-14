# -*- coding: utf-8 -*-
"""
tasks/command_hall.py — مهمة قاعة القيادة بالنشاط اليومي (CommandHallTask)
══════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. تعمل ضمن دورة النشاط اليومي وتمنح نقاط المهمة اليومية (4100033).
  2. فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight):
     - فحص كائن commandHall في conn.init_data.
     - استعلام مزامنة أولي آمن (CMD 2274 / SUBCMD 1) عند غياب البيانات وتخزينها بالذاكرة.
  3. دورة عمل متواصلة لمدة 5 دقائق (300 ثانية) مع فواصل بشرية (4.0s - 7.0s).
  4. أولوية 1: استلام الجوائز المكتملة فوراً (statue == 3 عبر CMD 2274 / SUBCMD 8).
  5. أولوية 2: ترقية مستوى قاعة القيادة التلقائي واستلام جوائز الترقية (CMD 2274 / SUBCMD 2).
  6. أولوية 3: تصفية صارمة لمنع صرف الذهب أو التسريعات (0-Gold, 0-Speedup).
  7. أولوية 4: تنفيذ المهام الفورية المجانية (حوار 3، إنقاذ 4، قنص 6) عبر CMD 2274 / SUBCMD 5.
  8. أولوية 5: فحص شاغرية الفيالق والجنود والطاقة 0-Network؛ عند تعذر إرسال الفيلق،
     إكمال باقي المهام الفورية واستلام الجوائز والخروج بأمان.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية لقاعة القيادة
CMD_COMMAND_HALL_MODULE = "2274"
REQ_COMMAND_HALL_INIT = "1"                 # مزامنة بيانات قاعة القيادة
REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"   # ترقية مستوى قاعة القيادة واستلام الجوائز
REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"     # ترقية مستوى القوة
REQ_COMMAND_HALL_FINISH_TASK = "5"          # إنجاز المهام الفورية (حوار / إنقاذ / قنص)
REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"    # شن هجوم استباقي على فيلق الغزاة المهاجم (Type 1)
REQ_COMMAND_HALL_COMMIT_TASK = "8"          # استلام جوائز المهام المنجزة (statue == 3)

# أمر إرسال الفيلق الرسمي على الخريطة
CMD_KINGDOM_QUEUE_MODULE = "1007"
REQ_ADD_KINGDOM_QUEUE = "2"
MOVE_LINE_TYPE_COMMAND_HALL_NPC = 15        # moveLineTypeCommandHallNpc
MOVE_LINE_MATRIX_TYPE_TROOP = 1             # moveLineMatrixTypeTroop

# أنواع المهام الفرعية لقاعة القيادة (gCommandHallTaskType)
TASK_TYPE_REBEL_GROUP = 1    # جيش المتمردين الجماعي
TASK_TYPE_REBEL_PIONEER = 2  # طليعة جيش المتمردين (تتطلب فيلق)
TASK_TYPE_DIALOGUE = 3       # مهمة الحوار (فورية آمنة بدون جيش)
TASK_TYPE_RESCUE = 4         # مهمة الإنقاذ (فورية آمنة بدون جيش)
TASK_TYPE_BATTLE = 5         # مهمة المعركة (تتطلب فيلق)
TASK_TYPE_SNIPE = 6          # مهمة القنص (لعبة مصغرة فورية آمنة بدون جيش)

TASK_TYPE_NAMES: Dict[int, str] = {
    TASK_TYPE_REBEL_GROUP: "جيش المتمردين الجماعي",
    TASK_TYPE_REBEL_PIONEER: "طليعة جيش المتمردين",
    TASK_TYPE_DIALOGUE: "المعلومات العسكرية (حوار)",
    TASK_TYPE_RESCUE: "إنقاذ القرويين",
    TASK_TYPE_BATTLE: "فريق الغزاة (معركة)",
    TASK_TYPE_SNIPE: "القناص الصامت (لعبة مصغرة)",
}

# حالات المهام الفرعية (gCommandHallTaskStatue)
TASK_STATUE_PREPARE = 1  # قيد الإعداد
TASK_STATUE_BEGIN = 2    # جاهزة للتنفيذ
TASK_STATUE_FINISH = 3   # مكتملة وبانتظار استلام الجوائز

# أقصى مدة لتشغيل حلقة قاعة القيادة بالثواني (مهلة أمان قصوى - دقيقة واحدة كحد أقصى)
SAFETY_TIMEOUT_SECONDS = 60
LOOP_MAX_DURATION_SECONDS = SAFETY_TIMEOUT_SECONDS

# ثوابت سرعة مسير الفيالق وفق كود اللعبة الرسمي (queueTimeUtil.lua & commandHallUtil.lua)
COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5   # وقت مسير فيلق المتمردين بالثواني
COMMANDHALL_COMMON_TASK_MARCH_TIME = 2  # وقت مسير المهام الشائعة بالثواني
MARCH_DYNAMIC_WAIT_MIN = 6.0            # أدنى مدة لانتظار وصول الفيلق وحسم المعركة (ثوانٍ)
MARCH_DYNAMIC_WAIT_MAX = 8.5            # أقصى مدة لانتظار وصول الفيلق وحسم المعركة (ثوانٍ)

# جدول متطلبات الخبرة للترقية حسب المستوى (مستخرج من newcommandhalllv.lua)
COMMAND_HALL_EXP_BY_LV: Dict[int, int] = {
    1: 200, 2: 300, 3: 400, 4: 500, 5: 600, 6: 800,
    7: 1600, 8: 1600, 9: 1600, 10: 1600, 11: 2400,
    12: 2400, 13: 2400, 14: 2400, 15: 2400, 16: 3200,
    17: 3200, 18: 3200, 19: 3200, 20: 3200, 21: 4800,
}
COMMAND_HALL_MAX_LEVEL = 21

# أبطال الدعم والجمع المستبعدين من مسير القتال (heroType == 1)
# 1711: الأنيق, 1717: المزيونة, 1724: الضرغام, 1733: صخر
GATHERING_HERO_IDS: Set[int] = {1711, 1717, 1724, 1733}

# حالات الأبطال المؤهلة للمسير (1: متفرغ بالقلعة، 5: حارس السور)
HERO_STATE_NORMAL = 1
HERO_STATE_DEFEND = 5
ELIGIBLE_HERO_STATES: Set[int] = {HERO_STATE_NORMAL, HERO_STATE_DEFEND}



class CommandHallTask(BaseTask):
    """
    مهمة قاعة القيادة التلقائية في النشاط اليومي:
    تنفذ المهام الفورية المجانية، تستلم الجوائز، ترقي المستوى،
    وتخرج بمرونة وأمان عند تعذر إرسال الفيالق بعد إتمام المهام الأخرى.
    """
    name: str = "command_hall"
    alias: str = "command_hall"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        # دعم الترتيب المرن في حال تم تمرير config في المعامل الثاني
        if isinstance(log_func, dict) and config is None:
            config = log_func
            log_func = None
        super().__init__(conn, log_func, config)
        self.name = "command_hall"
        self._is_synced: bool = False
        self._attacked_rebel_groups: Set[Any] = set()
        self._claimed_tasks: Set[Any] = set()
        self._group_claimed_count: int = 0

    @property
    def is_active(self) -> bool:
        """المهمة اختيارية برأي المستخدم ومضبوطة عبر الواجهة."""
        return bool(self.config.get("enabled", False))

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع لتأكيد تفعيل المهمة وجهوزية الاتصال والذاكرة."""
        if not self.is_active:
            return False, "مهمة قاعة القيادة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        return True, ""

    @staticmethod
    def _safe_int(v: Any, default: int = 0) -> int:
        """تحويل آمن إلى عدد صحيح مع معالجة السلاسل النصية والقيم غير الصالحة ومنع رفع الأخطاء."""
        if v is None or isinstance(v, bool):
            return default
        try:
            if isinstance(v, str):
                v_clean = v.strip()
                if not v_clean:
                    return default
                return int(float(v_clean))
            return int(v)
        except (ValueError, TypeError, OverflowError):
            return default

    @classmethod
    def _is_costly_task(cls, task: Dict[str, Any]) -> bool:
        """
        تصفية صارمة ومحكمة لمنع استهلاك الذهب أو التسريعات أو العناصر (0-Gold, 0-Speedup).
        يفحص الحقول التالية:
        - consumeGold, gold: إذا كانت > 0.
        - consumeSpeedup, speedup: إذا كانت موجودة وبقيمة صحيحة.
        - consumeItem, consumeItems, item, items:
          * إذا كانت نصاً يحتوي على 'speedup' أو 'gold' أو أي عنصر غير فارغ.
          * إذا كانت عدداً موجباً (> 0).
          * إذا كانت قائمة أو قاموساً غير فارغ.
        """
        if not isinstance(task, dict):
            return False

        # 1. فحص استهلاك الذهب
        if cls._safe_int(task.get("consumeGold")) > 0:
            return True
        if cls._safe_int(task.get("gold")) > 0:
            return True

        # 2. فحص استهلاك التسريعات الصريح
        if bool(task.get("consumeSpeedup")) or bool(task.get("speedup")):
            return True

        # 3. فحص فخاخ العناصر (consumeItem / consumeItems / item / items)
        for field_name in ("consumeItem", "consumeItems", "item", "items"):
            val = task.get(field_name)
            if val is not None:
                if isinstance(val, str):
                    v_lower = val.lower().strip()
                    if "speedup" in v_lower or "gold" in v_lower:
                        return True
                    if v_lower not in ("", "0", "false", "none", "null"):
                        return True
                elif isinstance(val, (int, float)) and val > 0:
                    return True
                elif isinstance(val, (list, dict)) and len(val) > 0:
                    return True
                elif isinstance(val, bool) and val:
                    return True

        return False

    @property
    def current_stamina(self) -> int:
        """استخراج طاقة اللورد الحالية من الذاكرة الحية (0-Network)."""
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            base = lord.get("base", {})
            if isinstance(base, dict) and "health" in base:
                return self._safe_int(base.get("health", 0))
            if "health" in lord:
                return self._safe_int(lord.get("health", 0))
            if "power" in lord:
                return self._safe_int(lord.get("power", 0))
            if "stamina" in lord:
                return self._safe_int(lord.get("stamina", 0))
        return self.stamina

    @property
    def available_troops_count(self) -> int:
        """
        استخراج إجمالي الجنود المقاتلين المتاحين بالقلعة من الذاكرة الحية (0-Network).
        يستبعد أفخاخ السور (801..825) لضمان عدم إرسال فيلق خادع بدون جنود حقيقيين.
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not isinstance(army_ctrl, dict):
            return 0
        total_army = army_ctrl.get("totalArmy") or {}
        if isinstance(total_army, dict):
            return sum(
                self._safe_int(v)
                for k, v in total_army.items()
                if self._safe_int(k) < 800 and self._safe_int(v) > 0
            )
        return 0

    def _calculate_march_capacity(self) -> int:
        """
        حساب سعة مسير الجيش الرسمية من الذاكرة الحية (0-Network):
        1. السعة الأساسية: 3,000 كحد أدنى آمن.
        2. قراءة مستوى مبنى ساحة التدريب (Drill Grounds, bid: 121 أو 4220) من cityCtrl.blist.
        3. حساب إضافة مستوى ساحة التدريب (مستوى 1: 3000، وكل مستوى إضافي يضيف 1500 جندي).
        4. إضافة بونص الـ VIP من lordInfoCtrl.vip.level.
        """
        base_capacity = 3000
        drill_capacity = 0

        city_ctrl = self.get_ctrl("cityCtrl")
        if isinstance(city_ctrl, dict):
            blist = city_ctrl.get("blist")
            if isinstance(blist, list):
                for b in blist:
                    if isinstance(b, dict):
                        bid = self._safe_int(b.get("bid"))
                        if bid in (121, 4220):
                            level = self._safe_int(b.get("level"), 1)
                            drill_capacity = max(drill_capacity, 3000 + (level - 1) * 1500)
            elif isinstance(blist, dict):
                for b in blist.values():
                    if isinstance(b, dict):
                        bid = self._safe_int(b.get("bid"))
                        if bid in (121, 4220):
                            level = self._safe_int(b.get("level"), 1)
                            drill_capacity = max(drill_capacity, 3000 + (level - 1) * 1500)

        capacity = max(base_capacity, drill_capacity)

        lord_ctrl = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord_ctrl, dict):
            vip = lord_ctrl.get("vip", {})
            if isinstance(vip, dict):
                vip_lv = self._safe_int(vip.get("level"), 0)
                if vip_lv > 0:
                    vip_bonus = int(capacity * (vip_lv * 0.01))
                    capacity += vip_bonus

        return max(3000, capacity)

    def _select_combat_heroes(self, max_heroes: int = 1) -> List[Dict[str, int]]:
        """
        انتقاء أبطال القتال المؤهلين واستبعاد أبطال الجمع والدعم (0-Network):
        1. قراءة قائمة الأبطال من heroSysCtrl أو heroCtrl في conn.init_data.
        2. استبعاد أبطال الجمع والدعم (heroType == 1): المعرفات [1711, 1717, 1724, 1733].
        3. التحقق من جاهزية البطل: state in (1, 5) وعدم انشغاله بطابور مسير آخر (not hero.get("queue")).
        4. فرز الأبطال تنازلياً حسب الجودة (quality) ثم المستوى (level).
        5. إعادة قائمة بصيغة: [{"heroID": hero_id}, ...] حتى الحد الأقصى المطلوب.
        """
        hero_ctrl = self.get_ctrl("heroSysCtrl")
        if not isinstance(hero_ctrl, dict):
            hero_ctrl = self.get_ctrl("heroCtrl")
        if not isinstance(hero_ctrl, dict):
            return []

        hero_list_raw = hero_ctrl.get("heroList")
        if not hero_list_raw:
            return []

        heroes_to_check: List[Dict[str, Any]] = []
        if isinstance(hero_list_raw, dict):
            for k, v in hero_list_raw.items():
                if isinstance(v, dict):
                    if "heroID" not in v:
                        v["heroID"] = self._safe_int(k)
                    heroes_to_check.append(v)
        elif isinstance(hero_list_raw, list):
            for item in hero_list_raw:
                if isinstance(item, dict):
                    heroes_to_check.append(item)

        eligible: List[Dict[str, Any]] = []
        for hero in heroes_to_check:
            hid = self._safe_int(hero.get("heroID"))
            if hid <= 0 or hid in GATHERING_HERO_IDS:
                continue

            state = self._safe_int(hero.get("state"), HERO_STATE_NORMAL)
            if state not in ELIGIBLE_HERO_STATES:
                continue

            # التحقق من عدم مشاركته في طابور نشط
            queue = hero.get("queue")
            if queue and isinstance(queue, (dict, list)) and len(queue) > 0:
                continue

            quality = self._safe_int(hero.get("quality"), 0)
            level = self._safe_int(hero.get("level"), 0)

            eligible.append({
                "heroID": hid,
                "quality": quality,
                "level": level,
            })

        # الترتيب تنازلياً حسب الرتبة ثم المستوى
        eligible.sort(key=lambda h: (h["quality"], h["level"]), reverse=True)

        return [{"heroID": h["heroID"]} for h in eligible[:max_heroes]]

    def _select_march_troops(self, max_capacity: Optional[int] = None) -> List[Dict[str, int]]:
        """
        انتقاء تشكيلة القوات المؤهلة للمسير وحساب السعة القصوى (0-Network):
        1. قراءة armyCtrl.totalArmy.
        2. استبعاد أفخاخ السور تماماً (801..825).
        3. تجميع الوحدات العسكرية المؤهلة:
           مشاة (401..412)، رماة (501..512)، فرسان (601..612)، عربات (701..712).
        4. الفرز تنازلياً حسب رتبة الوحدة لاختيار أقوى الوحدات أولاً.
        5. ضبط العدد الإجمالي بحيث لا يتجاوز min(available_troops, march_capacity).
        6. إعادة قائمة بصيغة: [{"id": unit_id, "num": count}, ...].
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not isinstance(army_ctrl, dict):
            return []

        total_army = army_ctrl.get("totalArmy") or {}
        if not isinstance(total_army, dict):
            return []

        capacity = max_capacity if max_capacity is not None else self._calculate_march_capacity()
        if capacity <= 0:
            return []

        # استخراج الوحدات العسكرية المؤهلة واستبعاد الأفخاخ (801..825)
        candidates: List[Tuple[int, int]] = []
        for k, v in total_army.items():
            uid = self._safe_int(k)
            count = self._safe_int(v)
            if count <= 0:
                continue
            # استبعاد الأفخاخ (801..825)
            if uid >= 800:
                continue
            # قبول الوحدات القتالية
            if 400 <= uid <= 799 or (uid > 0 and uid < 800):
                candidates.append((uid, count))

        if not candidates:
            return []

        # فرز الوحدات تنازلياً حسب المعرف (المستوى الأعلى أولاً)
        candidates.sort(key=lambda x: x[0], reverse=True)

        selected: List[Dict[str, int]] = []
        rem_cap = capacity

        for uid, count in candidates:
            if rem_cap <= 0:
                break
            take = min(count, rem_cap)
            selected.append({"id": uid, "num": take})
            rem_cap -= take

        return selected

    def _deduct_march_resources_in_memory(self, troops: List[Dict[str, int]], stamina_cost: int = 5) -> None:
        """خصم القوات والطاقة والطوابير محلياً في الذاكرة الحية (In-Memory State Sync)."""
        # 1. خصم الطاقة
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            base = lord.get("base")
            if isinstance(base, dict) and "health" in base:
                base["health"] = max(0, self._safe_int(base["health"]) - stamina_cost)

        # 2. خصم القوات من totalArmy
        army_ctrl = self.get_ctrl("armyCtrl")
        if isinstance(army_ctrl, dict):
            total_army = army_ctrl.get("totalArmy")
            if isinstance(total_army, dict):
                for tr in troops:
                    uid = str(tr.get("id"))
                    num = self._safe_int(tr.get("num"))
                    if uid in total_army:
                        cur = self._safe_int(total_army[uid])
                        total_army[uid] = max(0, cur - num)

        # 3. خصم طابور مسير
        queue_ctrl = self.get_ctrl("queueCtrl")
        if isinstance(queue_ctrl, dict):
            queues = queue_ctrl.get("queues")
            if isinstance(queues, list):
                queues.append({"id": int(time.time()), "type": 1})
            if "1221" in queue_ctrl and isinstance(queue_ctrl["1221"], dict):
                cur_q = self._safe_int(queue_ctrl["1221"].get("count", 0))
                queue_ctrl["1221"]["count"] = cur_q + 1

    def _deduct_stamina_in_memory(self, stamina_cost: int) -> None:
        """خصم طاقة اللورد محلياً في الذاكرة الحية."""
        if stamina_cost <= 0:
            return
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            base = lord.get("base")
            if isinstance(base, dict) and "health" in base:
                base["health"] = max(0, self._safe_int(base["health"]) - stamina_cost)

    def _purge_defeated_group_from_memory(self, hall_data: Dict[str, Any]) -> None:
        """
        تطهير فيلق الغزاة المهزوم (Type 1) من الذاكرة الحية (hall_data و conn.init_data['commandHall'])
        لمنع تكرار الاستلام أو الدخول في حلقة استلام لانهائية عند استنفاذ مهام اليوم أو غياب وحش جديد.
        """
        if isinstance(hall_data, dict):
            hall_data.pop("armyGroupTaskData", None)
        if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
            cmd_ctrl = self.conn.init_data.get("commandHall")
            if isinstance(cmd_ctrl, dict):
                cmd_ctrl.pop("armyGroupTaskData", None)

    def _update_hall_data_from_response(self, hall_data: Dict[str, Any], res: Any) -> None:
        """تحديث بيانات قاعة القيادة في الذاكرة الحية بعد استجابة السيرفر الرسمية."""
        if not isinstance(res, dict):
            return
        init_data = None
        rspdata = res.get("rspdata")
        if isinstance(rspdata, dict) and "initData" in rspdata:
            init_data = rspdata.get("initData")
        elif isinstance(res.get("data"), dict) and len(res.get("data")) > 0:
            init_data = res.get("data")
        elif "commandLv" in res or "armyGroupTaskData" in res or "taskList" in res or "commonTaskData" in res:
            init_data = res

        if isinstance(init_data, dict):
            if "commonTaskData" in init_data or "armyGroupTaskData" in init_data:
                hall_data.pop("taskList", None)
                if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                    cmd_ctrl = self.conn.init_data.get("commandHall")
                    if isinstance(cmd_ctrl, dict):
                        cmd_ctrl.pop("taskList", None)
            hall_data.update(init_data)
            if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                if "commandHall" in self.conn.init_data and isinstance(self.conn.init_data["commandHall"], dict):
                    self.conn.init_data["commandHall"].update(init_data)
                else:
                    self.conn.init_data["commandHall"] = hall_data

            # إذا استلمنا بيانات الغد أو وحش فارغ أو حالته 0، يتم تطهير فيلق الغزاة فورياً
            if "tomorrowArmyGroupTaskData" in init_data:
                self._purge_defeated_group_from_memory(hall_data)
            elif "armyGroupTaskData" in init_data:
                new_ag = init_data.get("armyGroupTaskData")
                if not isinstance(new_ag, dict) or not new_ag or self._safe_int(new_ag.get("statue", 0)) == 0:
                    self._purge_defeated_group_from_memory(hall_data)

    def _handle_wave_progression_after_claim(self, hall_data: Dict[str, Any], res: Any) -> None:
        """
        معالجة وتتبع انتقال الدفعة (Wave Progression) عند هزيمة فيلق الغزاة الجماعي (Type 1):
        - تحديث كائن الذاكرة الحية ببيانات الموجة الجديدة (armyGroupID + 1).
        - تطهير فيلق الغزاة المهزوم إذا لم توفر الاستجابة وحشاً جديداً نشطاً أو إذا كانت statue == 0.
        - الحفاظ على سجل المهام المستلمة موزعاً بالموجة وعدم مسحه عشوائياً.
        """
        old_wave = self._safe_int(hall_data.get("armyGroupID", 0))
        self._update_hall_data_from_response(hall_data, res)
        new_wave = self._safe_int(hall_data.get("armyGroupID", 0))

        # استخراج init_data للتحقق هل وفر السيرفر وحشاً نشطاً جديداً
        init_data = None
        if isinstance(res, dict):
            rspdata = res.get("rspdata")
            if isinstance(rspdata, dict) and "initData" in rspdata:
                init_data = rspdata.get("initData")
            elif isinstance(res.get("data"), dict) and len(res.get("data")) > 0:
                init_data = res.get("data")
            elif "armyGroupID" in res or "armyGroupTaskData" in res or "tomorrowArmyGroupTaskData" in res:
                init_data = res

        has_new_group = False
        if isinstance(init_data, dict):
            new_ag = init_data.get("armyGroupTaskData")
            if isinstance(new_ag, dict) and new_ag:
                st = self._safe_int(new_ag.get("statue", 0))
                if st != 0:
                    has_new_group = True

        if not has_new_group or (isinstance(init_data, dict) and "tomorrowArmyGroupTaskData" in init_data):
            self._purge_defeated_group_from_memory(hall_data)
        else:
            ag = hall_data.get("armyGroupTaskData")
            if isinstance(ag, dict) and self._safe_int(ag.get("statue", 0)) == 0:
                self._purge_defeated_group_from_memory(hall_data)

        # تصفير سجل الهجوم للموجة السابقة فقط دون تصفير سجل الاستلام الموجي
        self._attacked_rebel_groups.clear()

        if new_wave > 0 and (new_wave != old_wave or old_wave == 0):
            self.log(f"[CommandHall] 🌊 تقدم الدفعة: تم الانتقال إلى دفعة الغزاة رقم {new_wave} بنجاح!")

    @classmethod
    def _extract_task_list(cls, hall_data: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        استخراج وتجميع كافة المهام الفرعية لقاعة القيادة:
        1. armyGroupTaskData (مهمة جيش المتمردين الجماعي)
        2. armyPioneerTaskData (مهمة طليعة المتمردين)
        3. commonTaskData (مهام الحوار، الإنقاذ، المعارك، القنص)
        4. finishTaskData (المهام المكتملة الجاهزة للاستلام)
        5. taskList / tasks (دعم التوافق القديم واختبارات المحاكاة)
        مع تطبيع الحقول الرقمية: index, type, statue.
        """
        if not isinstance(hall_data, dict):
            return []

        collected: List[Dict[str, Any]] = []

        # 1. armyGroupTaskData
        ag = hall_data.get("armyGroupTaskData")
        if isinstance(ag, dict) and ag:
            collected.append(ag)

        # 2. armyPioneerTaskData
        ap = hall_data.get("armyPioneerTaskData")
        if isinstance(ap, dict) and ap:
            collected.append(ap)

        # 3. commonTaskData (قائمة أو قاموس)
        ct = hall_data.get("commonTaskData")
        if isinstance(ct, list):
            for item in ct:
                if isinstance(item, dict) and item:
                    collected.append(item)
        elif isinstance(ct, dict):
            for item in ct.values():
                if isinstance(item, dict) and item:
                    collected.append(item)

        # 4. finishTaskData (قائمة أو قاموس مهام مكتملة)
        ft = hall_data.get("finishTaskData")
        if isinstance(ft, list):
            for item in ft:
                if isinstance(item, dict) and item:
                    if cls._safe_int(item.get("statue")) == 0:
                        item["statue"] = TASK_STATUE_FINISH
                    collected.append(item)
        elif isinstance(ft, dict):
            for item in ft.values():
                if isinstance(item, dict) and item:
                    if cls._safe_int(item.get("statue")) == 0:
                        item["statue"] = TASK_STATUE_FINISH
                    collected.append(item)

        # 5. التوافق العكسي: taskList / tasks
        legacy = hall_data.get("taskList") or hall_data.get("tasks")
        if isinstance(legacy, list):
            for item in legacy:
                if isinstance(item, dict) and item:
                    collected.append(item)
        elif isinstance(legacy, dict):
            for item in legacy.values():
                if isinstance(item, dict) and item:
                    collected.append(item)

        # تطبيع الحقول وإزالة التكرار (إن وجد نفس الكائن في أكثر من موضع)
        seen_keys = set()
        result: List[Dict[str, Any]] = []

        for task in collected:
            idx = cls._safe_int(task.get("index"), 0)
            ttype = cls._safe_int(task.get("type"), 0)
            statue = cls._safe_int(task.get("statue"), 0)

            task["index"] = idx
            task["type"] = ttype
            task["statue"] = statue

            dedup_key = (idx, ttype) if idx > 0 else id(task)
            if dedup_key not in seen_keys:
                seen_keys.add(dedup_key)
                result.append(task)

        return result

    @staticmethod
    def _get_target_coordinates(task: Dict[str, Any]) -> Optional[Tuple[int, int]]:
        """استخراج إحداثيات الهدف على الخريطة لمهمة الفيلق."""
        if not isinstance(task, dict):
            return None
        x = task.get("x")
        y = task.get("y")
        if x is not None and y is not None:
            try:
                return int(x), int(y)
            except (ValueError, TypeError):
                pass
        obj = task.get("obj")
        if isinstance(obj, dict):
            ox = obj.get("x")
            oy = obj.get("y")
            if ox is not None and oy is not None:
                try:
                    return int(ox), int(oy)
                except (ValueError, TypeError):
                    pass
        return None

    async def _ensure_synced_data(self, force_network: bool = False) -> Optional[Dict[str, Any]]:
        """
        0-Network Pre-flight Check مع دعم المزامنة الإلزامية عند الطلب (force_network=True):
        - إذا كانت force_network=False: فحص وجود بيانات قاعة القيادة بالذاكرة الحية أولاً وإعادتها فوراً (0-Network).
        - إذا كانت force_network=True: إرسال استعلام المزامنة الرسمي CMD 2274 / SUBCMD 1 وتحديث الذاكرة الحية فورياً.
        """
        hall_data = self.get_ctrl("commandHall")
        if not force_network:
            if self._is_synced and hall_data is not None and isinstance(hall_data, dict):
                return hall_data

            if isinstance(hall_data, dict) and (
                hall_data.get("taskList")
                or "commandLv" in hall_data
                or "armyGroupTaskData" in hall_data
                or "armyPioneerTaskData" in hall_data
                or "commonTaskData" in hall_data
            ):
                self._is_synced = True
                return hall_data

        # الاستعلام الأولي عند غياب البيانات أو عند طلب المزامنة الإلزامية بعد الفيلق/الموجة
        self.log("[CommandHall] 📡 جاري مزامنة بيانات قاعة القيادة من السيرفر (CMD 2274 / SUBCMD 1)...")
        res = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_INIT,
            {},
            min_delay=0.5,
            max_delay=0.9,
        )
        if isinstance(res, dict):
            # فك حزمة الاستجابة الرسمية للسيرفر (CMD 2274 / SUBCMD 1)
            init_data: Any = None
            rspdata = res.get("rspdata")
            if isinstance(rspdata, dict) and "initData" in rspdata:
                init_data = rspdata.get("initData")
            elif isinstance(res.get("data"), dict) and len(res.get("data")) > 0:
                init_data = res.get("data")
            elif "commandLv" in res or "taskList" in res or "armyGroupTaskData" in res or "commonTaskData" in res:
                init_data = res
            elif isinstance(res.get("data"), dict):
                init_data = res.get("data")
            else:
                init_data = res

            if not isinstance(init_data, dict):
                init_data = {}

            if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                existing = self.conn.init_data.get("commandHall")
                if isinstance(existing, dict):
                    existing.clear()
                    existing.update(init_data)
                else:
                    self.conn.init_data["commandHall"] = init_data
            self._is_synced = True
            return init_data

        return self.get_ctrl("commandHall")

    async def _claim_finished_tasks(self, hall_data: Dict[str, Any]) -> int:
        """
        الأولوية 1: فحص واستلام جوائز المهام المنجزة (statue == 3)
        أو فيلق الغزاة المهزوم (hurtHp >= rabelHp) فورياً عبر الأمر الرسمي CMD 2274 / SUBCMD 8.
        """
        claimed = 0
        wave_id = self._safe_int(hall_data.get("armyGroupID", 0))
        tasks = self._extract_task_list(hall_data)
        for task in tasks:
            status = self._safe_int(task.get("statue", 0))
            commit_type = self._safe_int(task.get("type", 1), 1)
            task_index = self._safe_int(task.get("index", 1), 1)

            # فحص صارم: إذا كانت المهمة مستلمة سلفاً أو ملغاة (status == 0) يتم تخطيها فوراً
            if status == 0:
                continue

            # فحص إذا كانت المهمة مكتملة أو مهزومة ومؤهلة للاستلام مع التأكد من status != 0
            is_claimable = (status != 0 and status == TASK_STATUE_FINISH)
            if not is_claimable and status != 0 and commit_type == TASK_TYPE_REBEL_GROUP:
                rabel_hp = self._safe_int(task.get("rabelHp") or task.get("rebelHp") or task.get("totalHp"), 0)
                hurt_hp = self._safe_int(task.get("hurtHp") or task.get("damageHp"), 0)
                if rabel_hp > 0 and hurt_hp >= rabel_hp:
                    is_claimable = True

            if is_claimable:
                task_key = (wave_id, commit_type, task_index)
                if task_key in self._claimed_tasks or (commit_type, task_index) in self._claimed_tasks:
                    continue

                task_name = TASK_TYPE_NAMES.get(commit_type, f"مهمة نوع {commit_type}")
                self.log(f"[CommandHall] 🎁 جاري استلام مكافأة المهمة المكتملة: {task_name} (فهرس: {task_index})...")
                res = await self.safe_query(
                    CMD_COMMAND_HALL_MODULE,
                    REQ_COMMAND_HALL_COMMIT_TASK,
                    {"commitType": commit_type, "index": task_index},
                    min_delay=0.5,
                    max_delay=0.9,
                )
                if res is not None:
                    claimed += 1
                    self._claimed_tasks.add(task_key)
                    task["statue"] = 0  # وسم المهمة كمكتملة في الذاكرة المحلية
                    if commit_type == TASK_TYPE_REBEL_GROUP:
                        self._handle_wave_progression_after_claim(hall_data, res)
                    else:
                        self._update_hall_data_from_response(hall_data, res)
                    self.log(f"[CommandHall] ✓ تم استلام مكافأة المهمة بنجاح: {task_name} (فهرس: {task_index}).")
                else:
                    self.log(f"[CommandHall] ⚠️ تعذر استلام مكافأة المهمة (فهرس: {task_index}).")
        return claimed

    async def _check_and_upgrade_level(self, hall_data: Dict[str, Any]) -> bool:
        """
        الأولوية 2: فحص مستوى قاعة القيادة والترقية التلقائية
        إذا كانت curExp >= needExp عبر الأمر الرسمي CMD 2274 / SUBCMD 2.
        """
        cur_lv = self._safe_int(hall_data.get("commandLv", 1), 1)
        if cur_lv >= COMMAND_HALL_MAX_LEVEL:
            return False

        cur_exp = self._safe_int(hall_data.get("commandExp", 0) or hall_data.get("curExp", 0))
        need_exp = self._safe_int(hall_data.get("needExp") or COMMAND_HALL_EXP_BY_LV.get(cur_lv, 999999), 999999)

        if cur_exp >= need_exp:
            self.log(f"[CommandHall] ⬆️ الخبرة كافية للترقية ({cur_exp}/{need_exp}) — جاري ترقية قاعة القيادة إلى Lv.{cur_lv + 1}...")
            res = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_UPGRADE_COMMAND_LV,
                {},
                min_delay=0.5,
                max_delay=0.9,
            )
            if res is not None:
                hall_data["commandLv"] = cur_lv + 1
                hall_data["commandExp"] = max(0, cur_exp - need_exp)
                self.log(f"[CommandHall] 🎉 تم ترقية مستوى قاعة القيادة بنجاح إلى Lv.{cur_lv + 1} واستلام جوائز المستوى!")
                return True
            else:
                self.log(f"[CommandHall] ⚠️ تعذر ترقية قاعة القيادة إلى Lv.{cur_lv + 1}.")
        return False

    async def _handle_rebel_group_attack(self, hall_data: Dict[str, Any]) -> bool:
        """
        الأولوية 3: النوع 1: فيلق الغزاة المهاجمين (REBEL_ARMY_GROUP_TASK).
        1. فحص وجود مهمة جيش الغزاة (armyGroupTaskData أو من قائمة المهام).
        2. فحص حالة المهمة ونقاط الحياة:
           - إذا كانت statue == 0 أو مسجلة في سجل الاستلام: الخروج الفوري لمنع التكرار.
           - إذا هُزم الفيلق (hurtHp >= rabelHp أو statue == TASK_STATUE_FINISH):
             تفويض الاستلام لدالة _claim_finished_tasks الموحدة (CMD 2274 / SubCMD 8)
             لمنع تكرار طلبات الاستلام وضمان استلام الجائزة مرة واحدة فقط وتجديد المهام.
           - إذا كانت statue == TASK_STATUE_BEGIN و rabelHp > hurtHp:
             شن الهجوم عبر CMD 2274 / SubCMD 7 (REQ_COMMAND_HALL_ATTACK_ARMY_GROUP)
             مع حمولة الجيش والأبطال (أو {} إذا لم تتوفر قوات)، وتكلفة الطاقة 0.
        """
        group_task = hall_data.get("armyGroupTaskData")
        if not isinstance(group_task, dict) or not group_task:
            for t in self._extract_task_list(hall_data):
                if self._safe_int(t.get("type")) == TASK_TYPE_REBEL_GROUP:
                    group_task = t
                    break

        if not isinstance(group_task, dict) or not group_task:
            return False

        task_index = self._safe_int(group_task.get("index"), 1)
        status = self._safe_int(group_task.get("statue"), 0)
        rabel_hp = self._safe_int(group_task.get("rabelHp") or group_task.get("rebelHp") or group_task.get("totalHp"), 0)
        hurt_hp = self._safe_int(group_task.get("hurtHp") or group_task.get("damageHp"), 0)
        wave_id = self._safe_int(hall_data.get("armyGroupID", 0))
        task_key = (wave_id, TASK_TYPE_REBEL_GROUP, task_index)

        # 0. التحقق الصارم من عدم الاستلام المسبق وعدم إلغاء المهمة (status != 0)
        if status == 0 or task_key in self._claimed_tasks or (TASK_TYPE_REBEL_GROUP, task_index) in self._claimed_tasks:
            return False

        # 1. إذا كان الفيلق مهزوماً أو مكتملاً، تفويض الاستلام لدالة الاستلام المركزية _claim_finished_tasks
        if status != 0 and (status == TASK_STATUE_FINISH or (rabel_hp > 0 and hurt_hp >= rabel_hp)):
            claimed = await self._claim_finished_tasks(hall_data)
            if claimed > 0:
                self._group_claimed_count += claimed
                return True
            return False

        # 2. إذا كانت المهمة جاهزة ولم يكتمل الضرر، شن الهجوم المباشر (تكلفة 0 طاقة)
        if status == TASK_STATUE_BEGIN:
            if self._is_costly_task(group_task):
                self.log(f"[CommandHall] ⏭️ تخطي هجوم فيلق الغزاة {task_index} لاحتوائه على ذهب أو تسريع.")
                return False

            task_key_atk = (wave_id, task_index, hurt_hp)
            if (task_key_atk in self._attacked_rebel_groups or (task_index, hurt_hp) in self._attacked_rebel_groups) and rabel_hp > 0 and hurt_hp < rabel_hp:
                return False

            army_info = self._select_march_troops()
            hero_info = self._select_combat_heroes()

            payload = {
                "armyInfo": army_info,
                "heroInfo": hero_info,
                "armsInfo": [],
                "divineBeastInfo": [],
            }
            self.log(
                f"[CommandHall] ⚔️ جاري شن هجوم استباقي على فيلق الغزاة "
                f"(0 طاقة, جنود: {sum(t['num'] for t in army_info)}, أبطال: {len(hero_info)})..."
            )
            res = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_ATTACK_ARMY_GROUP,
                payload,
                min_delay=0.5,
                max_delay=0.9,
            )
            self._attacked_rebel_groups.add(task_key_atk)
            self._attacked_rebel_groups.add((task_index, hurt_hp))

            if res is not None:
                self.log(f"[CommandHall] ✓ تم تنفيذ الهجوم على فيلق الغزاة بنجاح!")
                self._update_hall_data_from_response(hall_data, res)

                # إعادة قراءة بيانات الفيلق المحدثة من الذاكرة
                refreshed_group = hall_data.get("armyGroupTaskData")
                if isinstance(refreshed_group, dict):
                    group_task = refreshed_group
                else:
                    for t in self._extract_task_list(hall_data):
                        if self._safe_int(t.get("type")) == TASK_TYPE_REBEL_GROUP:
                            group_task = t
                            break

                # فحص حالة الفيلق بعد الهجوم
                new_status = self._safe_int(group_task.get("statue"), status)
                new_rabel = self._safe_int(group_task.get("rabelHp") or group_task.get("rebelHp"), rabel_hp)
                new_hurt = self._safe_int(group_task.get("hurtHp") or group_task.get("damageHp"), hurt_hp)

                if new_status == TASK_STATUE_FINISH or (new_rabel > 0 and new_hurt >= new_rabel):
                    group_task["statue"] = TASK_STATUE_FINISH
                    claimed = await self._claim_finished_tasks(hall_data)
                    if claimed > 0:
                        self._group_claimed_count += claimed
                    return True
                return True
            else:
                self.log(f"[CommandHall] ⚠️ تعذر الهجوم على فيلق الغزاة (فهرس: {task_index}).")

        return False

    async def _execute_instant_tasks(self, hall_data: Dict[str, Any]) -> int:
        """
        الأولوية 4: تنفيذ المهام الفورية الآمنة المجانية بدون جيش
        (حوار 3، إنقاذ 4، قنص 6) عبر CMD 2274 / SUBCMD 5.
        مع تطبيق تصفية الأمان (0-Gold, 0-Speedup) وفحص الطاقة.
        """
        executed = 0
        tasks = self._extract_task_list(hall_data)
        stamina = self.current_stamina

        for task in tasks:
            status = self._safe_int(task.get("statue", 0))
            task_type = self._safe_int(task.get("type", 0))
            task_index = self._safe_int(task.get("index", 0))

            if status != TASK_STATUE_BEGIN:
                continue

            # التحقق من أن المهمة فورية وبدون جيش
            if task_type not in (TASK_TYPE_DIALOGUE, TASK_TYPE_RESCUE, TASK_TYPE_SNIPE):
                continue

            # تصفية 0-Gold و 0-Speedup الصارمة
            if self._is_costly_task(task):
                self.log(f"[CommandHall] ⏭️ تخطي المهمة {task_index} لأنها تتطلب ذهباً أو تسريعات (سياسة 0-Gold/Speedup).")
                continue

            # فحص الطاقة (تستهلك 0 أو 5 طاقة لورد)
            stamina_cost = self._safe_int(task.get("consume", 0), 0)
            if stamina_cost > 0 and stamina < max(5, stamina_cost):
                self.log(f"[CommandHall] ⏭️ تخطي المهمة {task_index} لعدم كفاية طاقة اللورد ({stamina}/{max(5, stamina_cost)}) دون صرف ذهب.")
                continue

            task_name = TASK_TYPE_NAMES.get(task_type, f"مهمة فورية {task_type}")
            self.log(f"[CommandHall] ⚡ جاري إنجاز المهمة الفورية: {task_name} (فهرس: {task_index})...")

            res = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_FINISH_TASK,
                {"index": task_index},
                min_delay=0.5,
                max_delay=0.9,
            )
            if res is not None:
                executed += 1
                task["statue"] = TASK_STATUE_FINISH  # جاهزة الآن لاستلام الجائزة
                self._deduct_stamina_in_memory(stamina_cost)
                self._update_hall_data_from_response(hall_data, res)
                if stamina_cost > 0:
                    stamina = max(0, stamina - stamina_cost)
                self.log(f"[CommandHall] ✓ تم إنجاز المهمة الفورية بنجاح: {task_name} (فهرس: {task_index}).")
            else:
                self.log(f"[CommandHall] ⚠️ تعذر إنجاز المهمة الفورية (فهرس: {task_index}).")

        return executed

    async def _handle_march_tasks(self, hall_data: Dict[str, Any]) -> Tuple[int, bool]:
        """
        الأولوية 5: فحص ومعالجة مهام الفيالق (طليعة 2، معركة 5).
        - انتقاء القوات العسكرية الحقيقية عبر _select_march_troops() مع استبعاد أفخاخ السور.
        - انتقاء أبطال القتال المؤهلين عبر _select_combat_heroes() مع استبعاد أبطال الجمع والدعم.
        - إرسال حزمة CMD 1007 / SubCMD 2 الرسمية بالبنية المتشعبة والكاملة.
        - مزامنة واستهلاك الموارد في الذاكرة الحية (0-Network Sync).
        - يُعاد (عدد الفيالق المرسلة، هل تعذر الإرسال بسبب حظر الفيالق/الجنود/الطاقة).
        """
        dispatched = 0
        blocked_on_march = False
        tasks = self._extract_task_list(hall_data)

        for task in tasks:
            status = self._safe_int(task.get("statue", 0))
            task_type = self._safe_int(task.get("type", 0))
            task_index = self._safe_int(task.get("index", 0))
            task_id = self._safe_int(task.get("id") or task.get("taskId") or task.get("taskID"), task_index)

            if status != TASK_STATUE_BEGIN:
                continue

            # مهام الفيالق فقط (طليعة 2، معركة 5)
            if task_type not in (TASK_TYPE_REBEL_PIONEER, TASK_TYPE_BATTLE):
                continue

            # تصفية 0-Gold و 0-Speedup
            if self._is_costly_task(task):
                self.log(f"[CommandHall] ⏭️ تخطي مهمة الفيلق {task_index} لأنها تتطلب ذهباً أو تسريعات.")
                continue

            # فحص الذاكرة المسبق 0-Network لشاغرية الفيالق والجنود وطاقة اللورد
            marches = self.available_marches
            troops = self.available_troops_count
            stamina = self.current_stamina

            if marches <= 0 or troops <= 0 or stamina < 5:
                blocked_on_march = True
                self.log(
                    f"[CommandHall] ⚠️ متطلب فيلق على الخريطة غير متاح حالياً "
                    f"(طوابير شاغرة: {marches}, جنود: {troops}, طاقة: {stamina})."
                )
                break

            coords = self._get_target_coordinates(task)
            if not coords:
                self.log(f"[CommandHall] ⚠️ لم يتم العثور على إحداثيات هدف المهمة {task_index} على الخريطة.")
                continue

            server_x, server_y = coords
            target_x, target_y = max(0, server_x - 1), max(0, server_y - 1)

            # انتقاء القوات العسكرية الحقيقية
            selected_troops = self._select_march_troops()
            if not selected_troops:
                blocked_on_march = True
                self.log(f"[CommandHall] ⚠️ تعذر تشكيل فرقة جنود للمهمة {task_index} (لا توجد قوات مقاتلة).")
                break

            # انتقاء بطل القتال المؤهل (مع استبعاد أبطال الجمع)
            selected_heroes = self._select_combat_heroes()

            task_name = TASK_TYPE_NAMES.get(task_type, f"مهمة فيلق {task_type}")
            hero_desc = f", بطل: {selected_heroes[0]['heroID']}" if selected_heroes else ""
            total_selected_num = sum(t["num"] for t in selected_troops)
            self.log(
                f"[CommandHall] ⚔️ جاري إرسال فيلق إلى ({target_x}, {target_y}) للمهمة: {task_name} "
                f"(جنود: {total_selected_num}{hero_desc})..."
            )

            # استخراج معرف الهدف
            target_obj = task.get("obj")
            target_id = (
                task.get("instanceId")
                or task.get("id")
                or (target_obj.get("id") if isinstance(target_obj, dict) else None)
                or f"1-{task_id}-{target_x}-{target_y}"
            )

            march_payload = {
                "to": {"x": target_x, "y": target_y},
                "moveLineType": MOVE_LINE_TYPE_COMMAND_HALL_NPC,
                "matrixType": MOVE_LINE_MATRIX_TYPE_TROOP,
                "taskIndex": task_index,
                "taskType": task_type,
                "commandHallTaskType": task_type,
                "commandHallTaskID": task_id,
                "army": selected_troops,
                "heroInfo": selected_heroes,
                "armsInfo": [],
                "divineBeastInfo": [],
                "data": {
                    "to": {"x": target_x, "y": target_y, "id": str(target_id)},
                    "data": {
                        "commandHallTaskType": task_type,
                        "commandHallTaskID": task_id,
                    },
                    "army": selected_troops,
                    "heroInfo": selected_heroes,
                    "armsInfo": [],
                    "divineBeastInfo": [],
                    "mapId": 1,
                    "isDuel": False,
                    "isKillLeaderNpc": False,
                    "killNormalNpcLv": 0,
                    "isForbidSpeed": False,
                    "isSecondaryLock": False,
                },
            }
            res = await self.safe_query(
                CMD_KINGDOM_QUEUE_MODULE,
                REQ_ADD_KINGDOM_QUEUE,
                march_payload,
                min_delay=0.6,
                max_delay=1.0,
            )
            is_success = (
                isinstance(res, dict)
                and str(res.get("err", "0")) in ("0", "", "None")
                and (res.get("queueId") or not res.get("err") or str(res.get("err")) == "0")
            )
            if is_success:
                dispatched += 1
                task["statue"] = TASK_STATUE_PREPARE
                # مزامنة واستهلاك الموارد في الذاكرة الحية لمنع التكرار
                self._deduct_march_resources_in_memory(selected_troops, stamina_cost=5)
                self._update_hall_data_from_response(hall_data, res)
                self.log(f"[CommandHall] ✓ تم إرسال الفيلق بنجاح إلى ({target_x}, {target_y}).")
            else:
                err_code = res.get("err") if isinstance(res, dict) else "لا توجد استجابة"
                self.log(f"[CommandHall] ⚠️ تعذر إرسال الفيلق للمهمة {task_index} (رمز الخطأ: {err_code}).")

        return dispatched, blocked_on_march

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة مهام قاعة القيادة الديناميكية بالكامل:
        - فحص ومزامنة الذاكرة الحية (0-Network Pre-flight).
        - استلام مكافآت المهام المنجزة أولاً (statue == 3 أو هزيمة جيش الغزاة).
        - ترقية مستوى قاعة القيادة التلقائي عند توفر الخبرة.
        - مهاجمة جيش الغزاة الجماعي (Type 1) واستلام جوائز الفوز وتجديد الموجة التالية فورياً.
        - تنفيذ المهام الفورية المجانية (حوار / إنقاذ / قنص) واستلام مكافآتها فوراً.
        - إرسال مهام الفيالق والتتبع الديناميكي (6-8 ثوانٍ وفق ثوابت كود اللعبة الرسمي:
          COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5s) ثم المزامنة الإلزامية بالسيرفر
          (CMD 2274 / SUBCMD 1) واستلام مكافآت الفوز فورياً دون نوم أو جمود.
        - الخروج النظيف الفوري بمجرد إنجاز المهام أو تعذر إرسال الفيالق.
        """
        start_time = time.time()
        total_claimed = 0
        total_executed = 0
        total_marches = 0
        upgraded_levels = 0
        exit_reason = "تم إنجاز كافة المهام المتاحة بالكامل"

        self.log("🏰 [CommandHall] بدء دورة مهام قاعة القيادة (النشاط اليومي)...")

        try:
            while (time.time() - start_time) < LOOP_MAX_DURATION_SECONDS:
                # التحقق من استمرار الاتصال والذاكرة
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    exit_reason = "انقطاع الاتصال بالبوابة"
                    break

                hall_data = await self._ensure_synced_data()
                if not isinstance(hall_data, dict):
                    self.log("[CommandHall] ⚠️ تعذر جلب بيانات قاعة القيادة من الذاكرة أو السيرفر.")
                    exit_reason = "بيانات قاعة القيادة غير متوفرة"
                    break

                progress_in_iteration = False

                # 1. الأولوية الأولى: استلام جوائز أي مهام مكتملة سلفاً (statue == 3 أو هزيمة جيش الغزاة)
                claimed = await self._claim_finished_tasks(hall_data)
                if claimed > 0:
                    total_claimed += claimed
                    progress_in_iteration = True

                # 2. الأولوية الثانية: ترقية مستوى قاعة القيادة إن توفرت الخبرة
                if await self._check_and_upgrade_level(hall_data):
                    upgraded_levels += 1
                    progress_in_iteration = True

                # 3. الأولوية الثالثة: مهاجمة فيلق الغزاة المهاجمين (Type 1) أو استلام جائزته وتجديد الموجة
                group_action = await self._handle_rebel_group_attack(hall_data)
                if self._group_claimed_count > 0:
                    total_claimed += self._group_claimed_count
                    self._group_claimed_count = 0
                    progress_in_iteration = True
                if group_action:
                    progress_in_iteration = True

                # 4. الأولوية الرابعة: إنجاز المهام الفورية المجانية (حوار / إنقاذ / قنص)
                executed = await self._execute_instant_tasks(hall_data)
                if executed > 0:
                    total_executed += executed
                    progress_in_iteration = True
                    # استلام مكافآتها فوراً دون تأخير
                    claimed_after = await self._claim_finished_tasks(hall_data)
                    if claimed_after > 0:
                        total_claimed += claimed_after

                # 5. الأولوية الخامسة: فحص ومعالجة مهام الفيالق (طليعة 2، معركة 5)
                dispatched, blocked_on_march = await self._handle_march_tasks(hall_data)
                if dispatched > 0:
                    total_marches += dispatched
                    progress_in_iteration = True

                    # تتبع الفيالق ديناميكياً: انتظار وصول الفيلق وحسم المعركة (6-8 ثوانٍ وفق ثوابت اللعبة الرسمية)
                    wait_sec = random.uniform(MARCH_DYNAMIC_WAIT_MIN, MARCH_DYNAMIC_WAIT_MAX)
                    self.log(
                        f"[CommandHall] ⏳ تم إرسال {dispatched} فيلق — جاري تتبع المسير وحسم المعركة "
                        f"({wait_sec:.1f} ثوانٍ وفق COMMANDHALL_REBEL_ARMY_MARCH_TIME)..."
                    )
                    await asyncio.sleep(wait_sec)

                    # مزامنة فورية لحالة قاعة القيادة عبر السيرفر (CMD 2274 / SUBCMD 1)
                    self.log("[CommandHall] 🔄 حسمت معركة الفيلق — جاري تحديث الذاكرة الحية بالسيرفر (CMD 2274 / SUBCMD 1)...")
                    hall_data = await self._ensure_synced_data(force_network=True)
                    if not isinstance(hall_data, dict):
                        hall_data = self.get_ctrl("commandHall") or {}

                    # استلام مكافأة المهمة المنجزة فورياً
                    claimed_march = await self._claim_finished_tasks(hall_data)
                    if claimed_march > 0:
                        total_claimed += claimed_march

                    # فحص إذا تم هزيمة جيش الغزاة (Type 1) نتيجة ضرر الطليعة أو المعركة واستلامه فوراً
                    if await self._handle_rebel_group_attack(hall_data):
                        if self._group_claimed_count > 0:
                            total_claimed += self._group_claimed_count
                            self._group_claimed_count = 0
                        claimed_after_group = await self._claim_finished_tasks(hall_data)
                        if claimed_after_group > 0:
                            total_claimed += claimed_after_group

                # فحص الخروج إذا كان مسار الفيلق محظوراً بعد إتمام كافة المهام الفورية
                if blocked_on_march:
                    self.log(
                        "[CommandHall] ⚠️ تعذر إرسال فيلق على الخريطة لعدم توفر فيالق أو جنود أو طاقة — "
                        "تم إنجاز كافة المهام الفرعية المتاحة والخروج بأمان طبقاً لتعليمات التشغيل."
                    )
                    exit_reason = "تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)"
                    break

                # فحص هل توجد أي مهام معلقة قابلة للتنفيذ في الدفعة الحالية
                tasks = self._extract_task_list(hall_data)

                def is_task_actionable(t: Dict[str, Any]) -> bool:
                    st = self._safe_int(t.get("statue", 0))
                    tp = self._safe_int(t.get("type", 0))
                    idx = self._safe_int(t.get("index", 0))
                    wave_id = self._safe_int(hall_data.get("armyGroupID", 0))

                    # 1. إذا كانت المهمة مستلمة سلفاً أو ملغاة (st == 0) فهي غير قابلة للتنفيذ
                    if st == 0:
                        return False

                    # 2. فحص سجل المهام المستلمة بالموجة
                    if (wave_id, tp, idx) in self._claimed_tasks or (tp, idx) in self._claimed_tasks:
                        return False
                    if self._is_costly_task(t):
                        return False
                    if st == TASK_STATUE_FINISH:
                        return True
                    if tp == TASK_TYPE_REBEL_GROUP:
                        rhp = self._safe_int(t.get("rabelHp") or t.get("rebelHp"), 0)
                        hhp = self._safe_int(t.get("hurtHp") or t.get("damageHp"), 0)
                        if rhp > 0 and hhp >= rhp:
                            return True
                        if (wave_id, idx, hhp) in self._attacked_rebel_groups or (idx, hhp) in self._attacked_rebel_groups:
                            return False
                        return st == TASK_STATUE_BEGIN
                    return st == TASK_STATUE_BEGIN

                has_pending_actions = any(is_task_actionable(t) for t in tasks)

                # إذا لم يتم تحقيق أي تقدم في هذه الدورة ولا توجد مهام معلقة قابلة للتنفيذ، الخروج فوراً
                if not progress_in_iteration or not has_pending_actions:
                    self.log("[CommandHall] ✓ تم إنجاز كافة مهام قاعة القيادة المتاحة واستلام جوائزها بنجاح.")
                    exit_reason = "تم إنجاز كافة المهام المتاحة بالكامل"
                    break

                # التحقق من مهلة الأمان للحلقة
                remaining_time = LOOP_MAX_DURATION_SECONDS - (time.time() - start_time)
                if remaining_time <= 0:
                    exit_reason = "انتهاء مهلة الأمان (60 ثانية)"
                    break

                # فاصل خفيف بين الموجات المتتالية (0.5s - 1.5s)
                await asyncio.sleep(min(random.uniform(0.5, 1.5), max(0.2, remaining_time)))

            else:
                exit_reason = "انتهاء مهلة الأمان (60 ثانية)"

        except asyncio.CancelledError:
            self.log("[CommandHall] 🛑 تم إلغاء مهمة قاعة القيادة بناءً على إشارة إيقاف.")
            raise
        except Exception as e:
            self.log(f"[CommandHall] ❌ خطأ غير متوقع أثناء تشغيل قاعة القيادة: {e}")
            return TaskResult.fail(f"خطأ في قاعة القيادة: {e}")

        summary = (
            f"تم إنهاء دورة قاعة القيادة ({exit_reason}): "
            f"استلام {total_claimed} مكافأة، إنجاز {total_executed} مهمة فورية، "
            f"إرسال {total_marches} فيلق، ترقية {upgraded_levels} مستوى."
        )
        self.log(f"[CommandHall] 🏁 {summary}")
        return TaskResult.ok(
            summary,
            data={
                "claimed": total_claimed,
                "executed": total_executed,
                "marches": total_marches,
                "upgraded_levels": upgraded_levels,
                "exit_reason": exit_reason,
            },
            exec_time=time.time() - start_time,
        )

    async def execute(self) -> TaskResult:
        """واجهة تشغيل بديلة كمرادف لدالة run."""
        return await self.run()
