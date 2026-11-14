# -*- coding: utf-8 -*-
"""
tasks/research.py — مهمة إجراء الأبحاث الموصى بها تلقائياً في المعهد (College Research Task)
════════════════════════════════════════════════════════════════════════════════════════════
المزايا الرئيسية:
  1. صفر استهلاك للشبكة (0-Network Direct Read):
     - قراءة حالة طابور أبحاث المعهد (1212) مباشرة من الذاكرة الحية queueCtrl.
     - قراءة مستويات الأبحاث المكتسبة من technologyCtrl ومستوى المعهد (bid 113) من cityCtrl.
  2. تحديد البحث الموصى به تلقائياً بدون تدخل المستخدم:
     - التوافق مع مهمة الدليل الرسمية للعبة (Guide Quest) إن وجدت.
     - اعتماد سلم الأولويات الاستراتيجية (العسكرية -> الدفاع -> تنمية المدينة -> الموارد).
     - ترقية الأبحاث الأقل مستوى لضمان استمرار الدوران ورفع قوة القلعة بأعلى كفاءة.
  3. تنفيذ مباشر وآمن لطلب البحث بالسيرفر عبر (CMD 1017 / SUBCMD 2).
"""

from __future__ import annotations

import asyncio
import os
import random
import sys
import time
from typing import Any, Dict, List, Optional, Tuple

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

# معرف مبنى المعهد ومعرف طابور أبحاث المعهد في محرك اللعبة
COLLEGE_BUILDING_ID = 113
RESEARCH_QUEUE_ID = "1212"

# تصنيف أشجار الأبحاث حسب الأولوية الاستراتيجية في اللعبة
RESEARCH_TREES: List[Dict[str, Any]] = [
    {
        "tree": "military",
        "name": "⚔️ الشؤون العسكرية",
        "root_ids": ["24011", "24001", "24101"],
        "tech_ids": [str(x) for x in range(24001, 24049)] + [str(x) for x in range(24101, 24119)],
    },
    {
        "tree": "defense",
        "name": "🛡️ الدفاع والتحصينات",
        "root_ids": ["23001"],
        "tech_ids": [str(x) for x in range(23001, 23019)],
    },
    {
        "tree": "city",
        "name": "🏛️ تنمية وتطوير المدينة",
        "root_ids": ["22001"],
        "tech_ids": [str(x) for x in range(22001, 22015)],
    },
    {
        "tree": "resources",
        "name": "🌾 الموارد والإنتاج",
        "root_ids": ["21001", "21002"],
        "tech_ids": [str(x) for x in range(21001, 21021)],
    },
]

# قاموس التخزين المؤقت لأسماء الأبحاث بالعربية
_TECH_NAMES_CACHE: Dict[str, str] = {}


def _load_arabic_tech_names() -> Dict[str, str]:
    """تحميل أسماء الأبحاث بالعربية من ملف تعريب اللعبة عند أول تشغيل فقط."""
    global _TECH_NAMES_CACHE
    if _TECH_NAMES_CACHE:
        return _TECH_NAMES_CACHE

    arab_lua_path = os.path.join(
        _ROOT_DIR, "game_file", "src", "app", "localtb", "config_client", "local_arab.lua"
    )
    if os.path.exists(arab_lua_path):
        try:
            with open(arab_lua_path, "rb") as f:
                for line in f:
                    if b"technology_name_" in line:
                        parts = line.split(b"=")
                        if len(parts) == 2:
                            k_raw = parts[0].strip().strip(b"[").strip(b"]").strip(b"\"")
                            v_raw = parts[1].strip().strip(b",").strip(b"\"")
                            k = k_raw.decode("ascii", "ignore")
                            # استخراج المعرف الرقمي من technology_name_24011
                            tid = k.replace("technology_name_", "").strip()
                            if tid.isdigit():
                                _TECH_NAMES_CACHE[tid] = v_raw.decode("utf-8", "ignore")
        except Exception:
            pass

    return _TECH_NAMES_CACHE


def format_duration(seconds: float) -> str:
    """تنسيق المدة بالثواني إلى صيغة مقروءة بالعربية."""
    total_sec = int(max(0, seconds))
    hours = total_sec // 3600
    minutes = (total_sec % 3600) // 60
    secs = total_sec % 60
    parts = []
    if hours > 0:
        parts.append(f"{hours} س")
    if minutes > 0 or hours > 0:
        parts.append(f"{minutes} د")
    parts.append(f"{secs} ث")
    return " و ".join(parts)


class ResearchTask(BaseTask):
    """
    مهمة إجراء الأبحاث الموصى بها تلقائياً في مبنى المعهد.
    """
    name = "research"
    alias = "research"

    def __init__(self, conn: Any, log_func: Optional[Any] = None, config: Optional[Dict[str, Any]] = None):
        super().__init__(conn, log_func, config)
        self.tech_names = _load_arabic_tech_names()

    def get_tech_title(self, tech_id: Any) -> str:
        """إرجاع الاسم العربي للبحث ورقم المعرف."""
        s_id = str(tech_id).strip()
        name_ar = self.tech_names.get(s_id, "")
        if name_ar:
            return f"[{s_id}] {name_ar}"
        return f"بحث #{s_id}"

    def _get_queue_status(self) -> Dict[str, Any]:
        """
        فحص حالة طابور أبحاث المعهد (1212) بصفر استهلاك شبكي من الذاكرة الحية.
        """
        queue_ctrl = self.get_ctrl("queueCtrl")
        if not isinstance(queue_ctrl, dict):
            return {"is_busy": False, "remain_time": 0}

        q = queue_ctrl.get(RESEARCH_QUEUE_ID) or queue_ctrl.get(int(RESEARCH_QUEUE_ID))
        if isinstance(q, dict):
            start_time = float(q.get("starttime", 0) or 0)
            total_time = float(q.get("totaltime", q.get("ottime", 0)) or 0)
            if start_time > 0 and total_time > 0:
                remain_time = max(0.0, (start_time + total_time) - time.time())
            else:
                remain_time = float(q.get("remainTime", q.get("lefttime", 0)) or 0)

            if remain_time > 0:
                extra_data = q.get("data") or q.get("extraData") or {}
                tech_id = ""
                target_level = 1
                if isinstance(extra_data, dict):
                    keys = [k for k in extra_data.keys() if str(k).isdigit()]
                    if keys:
                        tech_id = str(keys[0])
                        info = extra_data.get(tech_id)
                        if isinstance(info, list) and len(info) > 1:
                            target_level = int(info[1])
                return {
                    "is_busy": True,
                    "remain_time": remain_time,
                    "tech_id": tech_id,
                    "target_level": target_level,
                }

        return {"is_busy": False, "remain_time": 0}

    def _get_learned_techs(self) -> Dict[str, int]:
        """
        استخراج الأبحاث المكتسبة ومستوياتها بصفر استهلاك شبكي من الذاكرة الحية.
        """
        learned: Dict[str, int] = {}
        tech_ctrl = self.get_ctrl("technologyCtrl")
        if isinstance(tech_ctrl, dict):
            for k, v in tech_ctrl.items():
                s_k = str(k)
                if isinstance(v, list) and len(v) > 1:
                    try:
                        learned[s_k] = int(v[1])
                    except (ValueError, TypeError):
                        learned[s_k] = 1
                elif isinstance(v, (int, str)):
                    try:
                        learned[s_k] = int(v)
                    except (ValueError, TypeError):
                        learned[s_k] = 1
        return learned

    def _get_college_level(self) -> int:
        """
        استخراج مستوى مبنى المعهد (bid 113) من الذاكرة الحية.
        """
        city_ctrl = self.get_ctrl("cityCtrl")
        if isinstance(city_ctrl, dict):
            blist = city_ctrl.get("blist", [])
            if isinstance(blist, list):
                for b in blist:
                    if not isinstance(b, dict):
                        continue
                    binfo = b.get("binfo", b) if isinstance(b.get("binfo"), dict) else b
                    if str(binfo.get("bid")) == str(COLLEGE_BUILDING_ID):
                        return int(binfo.get("lv", 0) or 0)
        return 0

    def _get_guide_quest_tech(self) -> Optional[Tuple[str, int]]:
        """
        فحص مهمة الدليل الحالية في اللعبة (Guide Quest):
        إذا كانت تطلب إجراء بحث معين، يتم اعتماده كأعلى أولوية.
        """
        quest_ctrl = self.get_ctrl("questCtrl")
        if isinstance(quest_ctrl, dict):
            guide = quest_ctrl.get("guideQuest") or quest_ctrl.get("pGuideQuest")
            if isinstance(guide, dict):
                qtype = int(guide.get("questType", 0) or 0)
                # نوع 38 = ترقية بحث معين
                if qtype == 38:
                    tid = guide.get("techID") or guide.get("technologyId")
                    tlv = guide.get("targetLevel") or guide.get("level") or 1
                    if tid:
                        return str(tid), int(tlv)
        return None

    def determine_candidate_techs(self, learned_techs: Dict[str, int]) -> List[Tuple[str, int, str]]:
        """
        توليد قائمة الأبحاث المرشحة مرتبة حسب الأولوية الذكية للتوصية.
        تعيد قائمة من: [(tech_id, target_level, tree_name)]
        """
        candidates: List[Tuple[str, int, str]] = []

        # 1. إذا وجدت مهمة دليل تطالب ببحث معين
        guide_rec = self._get_guide_quest_tech()
        if guide_rec:
            g_tid, g_tlv = guide_rec
            candidates.append((g_tid, g_tlv, "🌟 مهمة الدليل الموصى بها"))

        # 2. فحص الأشجار حسب الأولوية الاستراتيجية (العسكرية -> الدفاع -> التنمية -> الموارد)
        for tree_info in RESEARCH_TREES:
            t_name = tree_info["name"]
            tech_ids = tree_info["tech_ids"]
            root_ids = tree_info.get("root_ids", [])

            # أ) الأبحاث المفتوحة سابقاً ومستواها أقل من الحد الأقصى (الأقل مستوى أولاً)
            tree_learned = [
                (tid, learned_techs[tid] + 1)
                for tid in tech_ids
                if tid in learned_techs and learned_techs[tid] < 30
            ]
            tree_learned.sort(key=lambda item: item[1])
            for tid, next_lv in tree_learned:
                candidates.append((tid, next_lv, t_name))

            # ب) الأبحاث الجذرية المتاحة كبداية للشجرة إذا لم تُبحث بعد
            for root_id in root_ids:
                if root_id not in learned_techs:
                    candidates.append((root_id, 1, t_name))

            # ج) باقي أبحاث الشجرة المتبقية
            for tid in tech_ids:
                if tid not in learned_techs and tid not in root_ids:
                    candidates.append((tid, 1, t_name))

        return candidates

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع من الذاكرة الحية لتجنب أي استهلاك غير ضروري."""
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        college_lv = self._get_college_level()
        if college_lv <= 0:
            return False, "مبنى المعهد (College) غير موجود أو لم يتم تشييده بعد"

        queue_status = self._get_queue_status()
        if queue_status["is_busy"]:
            cur_title = self.get_tech_title(queue_status["tech_id"])
            rem_str = format_duration(queue_status["remain_time"])
            return False, f"طابور أبحاث المعهد مشغول حالياً ببحث {cur_title} (متبقي: {rem_str})"

        return True, ""

    async def run(self) -> TaskResult:
        self.log("🔬 بدء فحص أبحاث المعهد التلقائية (البحث الموصى به)...")

        # 1. التأكد من حالة الطابور
        queue_status = self._get_queue_status()
        if queue_status["is_busy"]:
            cur_title = self.get_tech_title(queue_status["tech_id"])
            rem_str = format_duration(queue_status["remain_time"])
            msg = f"⏳ طابور المعهد مشغول حالياً ببحث {cur_title} للمستوى {queue_status['target_level']} (متبقي: {rem_str})"
            self.log(msg)
            return TaskResult.skip(msg)

        # 2. التأكد من وجود مبنى المعهد ومستواه
        college_lv = self._get_college_level()
        if college_lv <= 0:
            msg = "⚠️ مبنى المعهد (College) غير موجود في القلعة بعد."
            self.log(msg)
            return TaskResult.skip(msg)

        # 3. جلب الأبحاث المكتسبة وتوليد المرشحين
        learned_techs = self._get_learned_techs()
        candidates = self.determine_candidate_techs(learned_techs)

        if not candidates:
            msg = "🎉 تم إكمال كافة الأبحاث المتاحة بالمعهد حالياً."
            self.log(msg)
            return TaskResult.ok(msg)

        # 4. محاولة إجراء البحث الموصى به الأنسب
        # يجرب المرشحين حتى يوافق السيرفر على الشروط والموارد
        max_attempts = min(len(candidates), 5)
        for i in range(max_attempts):
            tech_id, target_lv, tree_title = candidates[i]
            tech_title = self.get_tech_title(tech_id)

            payload = {
                "type": 1,
                "technologyId": str(tech_id),
                "rtype": 1,
            }

            resp = await self.conn.query(
                "1017",
                "2",
                payload,
                timeout=7,
            )

            err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"
            if err == "0":
                # تحديث الذاكرة الحية لطابور الأبحاث فوراً
                queue_ctrl = self.get_ctrl("queueCtrl")
                if isinstance(queue_ctrl, dict):
                    queue_ctrl[RESEARCH_QUEUE_ID] = {
                        "starttime": time.time(),
                        "totaltime": 3600,
                        "data": {str(tech_id): [str(tech_id), target_lv]},
                    }

                msg = f"✅ تم بدء بحث {tech_title} (مستوى {target_lv}) بنجاح! | الشجرة: {tree_title} 🎉"
                self.log(msg)
                return TaskResult.ok(msg, data={"tech_id": tech_id, "level": target_lv})

            # إذا كان الخطأ نقص موارد أو متطلبات مسبقة، يجرب المرشح التالي
            await asyncio.sleep(0.4)

        msg = f"⚠️ تعذر بدء البحث الموصى به حالياً (قد تلزم ترقية المعهد Lv.{college_lv} أو توفير موارد إضافية)."
        self.log(msg)
        return TaskResult.skip(msg)

