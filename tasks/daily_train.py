# -*- coding: utf-8 -*-
"""
tasks/daily_train.py — مهمة تدريب جنود النشاط اليومي بالحد الأدنى (DailyTrainTask)
══════════════════════════════════════════════════════════════════════════════════════
الهدف:
  - إتمام مهام التدريب الخمس في "النشاط اليومي" بالحد الأدنى المطلوب تماماً (250 وحدة رتبة 1):
    1. المشاة (Infantry):    4100012 | النوع 12 | مبنى 118 | رتبة 1 (401)
    2. الرماة (Archers):     4100013 | النوع 13 | مبنى 117 | رتبة 1 (601)
    3. الخيالة (Cavalry):    4100014 | النوع 14 | مبنى 116 | رتبة 1 (501)
    4. العربات (Chariots):   4100015 | النوع 15 | مبنى 119 | رتبة 1 (701)
    5. الفخاخ (Traps):       4100016 | النوع 16 | مبنى 120 | رتبة 1 (801 صخور)

القاعدة الذكية لعدم التعارض (Conflict Resolution):
  - فحص تكوين مهمة التدريب العادية للمستخدم (train):
    إذا كان نوع الجيش مفعلاً في التدريب العادي (train.enabled and train.levels[type] > 0)،
    يتم استبعاده وتجاوزه تلقائياً ليتكفل به التدريب العادي برتبته وسعته المطلوبة.

الاعتماد المعماري:
  - تعتمد هذه الفئة اعتماداً كلياً على منطق وآليات TrainTask من tasks.train دون تكرار الكود.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult
from tasks.train import (
    BID_TO_QUEUE_TYPE,
    BID_TO_DAILY_QUEST,
    BUILDING_TROOP_MAP,
    TrainTask,
    check_barracks_busy,
    sync_training_queue_in_memory,
    TYPE_ALIASES,
)

# خريطة مهام النشاط اليومي للتدريب الرسمية
DAILY_TRAIN_QUESTS: Dict[str, Dict[str, Any]] = {
    "infantry": {
        "bid": "118",
        "armyid": 401,
        "quest_id": 4100012,
        "event_type": "12",
        "name_ar": "المشاة",
        "icon": "🛡️",
    },
    "archers": {
        "bid": "117",
        "armyid": 601,
        "quest_id": 4100013,
        "event_type": "13",
        "name_ar": "الرماة",
        "icon": "🏹",
    },
    "cavalry": {
        "bid": "116",
        "armyid": 501,
        "quest_id": 4100014,
        "event_type": "14",
        "name_ar": "الخيالة",
        "icon": "🐎",
    },
    "chariots": {
        "bid": "119",
        "armyid": 701,
        "quest_id": 4100015,
        "event_type": "15",
        "name_ar": "العربات",
        "icon": "🚜",
    },
    "fortress": {
        "bid": "120",
        "armyid": 801,
        "quest_id": 4100016,
        "event_type": "16",
        "name_ar": "الفخاخ",
        "icon": "🏰",
    },
}

DAILY_TARGET_COUNT = 250


class DailyTrainTask(BaseTask):
    """
    مهمة تدريب جنود النشاط اليومي بالحد الأدنى (250 وحدة رتبة 1).
    """
    name = "daily_train"
    alias = "daily_army_train"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)
        # تفويض محرك التدريب الأساسي من TrainTask مع استخراج إعدادات التدريب العادي صراحة
        main_train_cfg = self._extract_main_train_config()
        self._train_engine = TrainTask(conn, log_func, main_train_cfg)

    def _extract_daily_train_config(self) -> Dict[str, Any]:
        """استخراج كائن إعدادات تدريب النشاط اليومي بأمان."""
        if not isinstance(self.config, dict):
            return {}
        if "daily_train" in self.config and isinstance(self.config["daily_train"], dict):
            return self.config["daily_train"]
        if "tasks" in self.config and isinstance(self.config["tasks"], dict) and "daily_train" in self.config["tasks"]:
            return self.config["tasks"]["daily_train"]
        return self.config

    def _extract_main_train_config(self) -> Dict[str, Any]:
        """استخراج كائن إعدادات التدريب العادي الصريحة بأمان."""
        if not isinstance(self.config, dict):
            return {}
        if "train" in self.config and isinstance(self.config["train"], dict):
            return self.config["train"]
        if "tasks" in self.config and isinstance(self.config["tasks"], dict) and isinstance(self.config["tasks"].get("train"), dict):
            return self.config["tasks"]["train"]
        return {}

    @property
    def is_active(self) -> bool:
        """قراءة حالة التفعيل من إعدادات المهمة."""
        cfg = self._extract_daily_train_config()
        if isinstance(cfg, dict):
            return bool(cfg.get("enabled", False))
        return False

    def _is_quest_completed(self, quest_id: int, event_type: str) -> bool:
        """
        فحص مسبق من الذاكرة الحية (0-Network) هل اكتملت مهمة النشاط اليومي لهذا النوع.
        الهدف: 250 وحدة = 5 دورات (كل 50 وحدة تزيد العداد بمقدار 1 في eventInfo).
        يفحص everydayTaskCtrl.eventInfo (المفاتيح '12' إلى '16' أو أرقام المهام)
        وكذلك questCtrl.point_finish_list.
        """
        everyday = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if not isinstance(everyday, dict) and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
            everyday = self.conn.init_data.get("everydayTaskCtrl") or self.conn.init_data.get("everydayTask")

        if isinstance(everyday, dict):
            ev_info = everyday.get("eventInfo", {})
            if isinstance(ev_info, dict):
                # فحص بنوع الحدث (12..16) كـ str أو int
                for key in (str(event_type), int(event_type) if str(event_type).isdigit() else None):
                    if key is not None and int(ev_info.get(key, 0) or 0) >= 5:
                        return True
                # فحص برقم المهمة (4100012..4100016)
                for key in (str(quest_id), quest_id):
                    if int(ev_info.get(key, 0) or 0) >= 5:
                        return True

        return False

    def _is_type_handled_by_main_train(self, troop_key: str) -> bool:
        """
        القاعدة الذكية (Smart Training Delegation):
        فحص هل نوع القوة مفعّل صراحة في التدريب العادي للمستخدم برتبة > 0.
        إذا كان مفعلاً: يتم تفويضه واستبعاده ليتكفل به التدريب العادي برتبته وسعته
        (لأن التدريب العادي سينتج >= 250 وحدة ويتمم مهمة النشاط اليومي تلقائياً).
        """
        # 1. التحقق من وجود إعدادات صريحة لمهمة التدريب العادي (train أو tasks.train)
        if not isinstance(self.config, dict):
            return False
        has_train_key = ("train" in self.config and isinstance(self.config["train"], dict)) or (
            "tasks" in self.config
            and isinstance(self.config["tasks"], dict)
            and isinstance(self.config["tasks"].get("train"), dict)
        )
        if not has_train_key:
            return False

        train_cfg = self._extract_main_train_config()
        if not train_cfg.get("enabled", False):
            return False

        # 2. فحص قاموس الرتب الصريح (levels)
        levels = train_cfg.get("levels")
        if isinstance(levels, dict) and levels:
            for k, v in levels.items():
                canon = TYPE_ALIASES.get(str(k).lower(), str(k).lower())
                if canon == troop_key:
                    try:
                        return int(v or 0) > 0
                    except (ValueError, TypeError):
                        return False
            return False

        # 3. فحص القائمة الصريحة للأنواع (types / type)
        raw_types = train_cfg.get("types", train_cfg.get("type"))
        if not raw_types:
            return False

        unit_lvl = 10
        try:
            unit_lvl = int(train_cfg.get("level", train_cfg.get("unit_level", 10)) or 10)
        except (ValueError, TypeError):
            pass

        if unit_lvl <= 0:
            return False

        if str(raw_types).strip().lower() in ("all", "الكل", "all_types"):
            return True

        if isinstance(raw_types, (list, tuple)):
            for p in raw_types:
                canon = TYPE_ALIASES.get(str(p).strip().lower(), str(p).strip().lower())
                if canon == troop_key or str(p).strip().lower() == troop_key:
                    return True
            return False

        if isinstance(raw_types, str):
            parts = [p.strip().lower() for p in raw_types.replace("،", ",").split(",") if p.strip()]
            for p in parts:
                canon = TYPE_ALIASES.get(p, p)
                if canon == troop_key or p == troop_key:
                    return True
            return False

        return False

    async def run(self) -> TaskResult:
        """دورة تدريب النشاط اليومي بالحد الأدنى مع حماية الاتصال وفحص الذاكرة الحية 100%."""
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، إيقاف تدريب النشاط اليومي فوراً.")
            return TaskResult.fail("انقطاع الاتصال بالبوابة")

        now_ts = int(time.time())

        # 1. استلام القوات الجاهزة أولاً عبر محرك التدريب المعتمد
        collected = await self._train_engine._harvest_all_ready_barracks(now_ts)
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة بعد استلام القوات، إيقاف تدريب النشاط اليومي فوراً.")
            return TaskResult.fail("انقطاع الاتصال بالبوابة")

        if collected:
            self.log(f"🎉 تم جمع القوات الجاهزة من {len(collected)} مبنى بنجاح!")
            await asyncio.sleep(0.8)

        trained_list: List[Dict[str, Any]] = []
        skipped_handled_list: List[str] = []
        already_done_list: List[str] = []
        busy_list: List[str] = []
        is_disconnected = False

        # 2. فحص وتدريب كل نوع من القوات الخمس
        for t_key, q_info in DAILY_TRAIN_QUESTS.items():
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، التوقف فوراً عن تدريب بقية القوات.")
                is_disconnected = True
                break

            bid = q_info["bid"]
            armyid = q_info["armyid"]
            q_id = q_info["quest_id"]
            ev_type = q_info["event_type"]
            t_name = q_info["name_ar"]
            t_icon = q_info["icon"]

            # أ) فحص إتمام مهمة النشاط اليومي مسبقاً (0-Network Pre-flight)
            if self._is_quest_completed(q_id, ev_type):
                self.log(f"✅ {t_icon} [{t_name}] مكتمل مسبقاً في النشاط اليومي (5/5) — تم التخطي (0-Network).")
                already_done_list.append(t_name)
                continue

            # ب) القاعدة الذكية: هل هذا النوع مفعّل في التدريب العادي للمستخدم؟ (Smart Training Delegation)
            if self._is_type_handled_by_main_train(t_key):
                self.log(f"⏭️ {t_icon} [{t_name}] مفعل في التدريب العادي للمستخدم — تم التجاوز بذكاء ليتكفل به التدريب العادي.")
                skipped_handled_list.append(t_name)
                continue

            # ج) التحقق من وجود المبنى ومستواه
            b_lv, _ = self._train_engine._get_building_info(bid)
            if b_lv <= 0:
                self.log(f"⚠️ المبنى {t_icon} [{t_name}] (bid={bid}) غير مبني في القلعة.")
                continue

            # د) فحص انشغال المبنى بالتدريب حالياً من الذاكرة الحية (0-Network Pre-flight)
            is_busy, rem_s, busy_desc = check_barracks_busy(self.conn, bid, now_ts)
            if is_busy:
                rem_m = max(1, rem_s // 60) if rem_s > 0 else 0
                if rem_s > 0:
                    self.log(f"⏳ {t_icon} [{t_name}] قيد التدريب حالياً (متبقي: {rem_m} دقيقة) — تم التخطي (0-Network).")
                else:
                    self.log(f"⏳ {t_icon} [{t_name}] غير متاح حالياً ({busy_desc}) — تم التخطي (0-Network).")
                busy_list.append(t_name)
                continue

            # هـ) حساب السعة والموارد لتدريب 250 وحدة رتبة 1
            calc = self._train_engine._calculate_auto_army_count(bid, armyid)
            if not calc["has_enough_resources"]:
                missing_str = ", ".join(calc["missing_resources"]) if calc["missing_resources"] else "الموارد"
                self.log(f"⚠️ تعذر تدريب {t_name} للنشاط اليومي لنقص {missing_str}.")
                continue

            # تدريب الحد الأدنى بالضبط: 250 وحدة
            target_count = min(DAILY_TARGET_COUNT, calc["final_armycount"])
            if target_count <= 0:
                self.log(f"⚠️ السعة المتاحة لتدريب {t_name} هي 0، تم التخطي (0-Network).")
                continue

            self.log(f"🚀 بدء تدريب النشاط اليومي: {t_icon} [{t_name}] رتبة 1 | المستهدف: {target_count} وحدة...")
            success, actual_count, err_reason = await self._train_engine._train_adaptive(bid, armyid, target_count)

            if success:
                self.log(f"✅ تم بدء تدريب {actual_count} وحدة من {t_icon} [{t_name}] (مستوى 1) للنشاط اليومي بنجاح! 🎉")
                trained_list.append({
                    "type": t_name,
                    "bid": bid,
                    "armyid": armyid,
                    "count": actual_count,
                })
            else:
                self.log(f"⚠️ تعذر بدء تدريب {t_name} للنشاط اليومي (السبب: {err_reason})")
                if err_reason == "انقطاع الاتصال بالبوابة" or not self.conn or not getattr(self.conn, "is_connected", False):
                    is_disconnected = True
                    break

            if not self.conn or not getattr(self.conn, "is_connected", False):
                is_disconnected = True
                break

            await asyncio.sleep(round(random.uniform(1.0, 1.8), 2))

        # فحص انقطاع الاتصال النهائي
        if is_disconnected or not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ تم إنهاء تدريب النشاط اليومي بسبب انقطاع الاتصال بالبوابة.")
            return TaskResult.fail("انقطاع الاتصال بالبوابة")

        # بناء رسالة النتيجة النهائية
        parts = []
        if trained_list:
            parts.append(f"تم بدء تدريب {len(trained_list)} أنواع بنجاح (250 وحدة Lv.1)")
        if already_done_list:
            parts.append(f"{len(already_done_list)} أنواع مكتملة مسبقاً (0-Network)")
        if skipped_handled_list:
            parts.append(f"{len(skipped_handled_list)} أنواع متروكة للتدريب العادي")
        if busy_list:
            parts.append(f"{len(busy_list)} مبانٍ مشغولة")

        summary_msg = " | ".join(parts) if parts else "لم يتطلب الأمر أي تدريب نشاط يومي."
        self.log(f"🏁 [تدريب النشاط اليومي] {summary_msg}")

        return TaskResult.ok(
            summary_msg,
            data={
                "trained": trained_list,
                "already_done": already_done_list,
                "handled_by_main": skipped_handled_list,
                "busy": busy_list,
            }
        )

