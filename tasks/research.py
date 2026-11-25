# -*- coding: utf-8 -*-
"""
tasks/research.py — مهمة إجراء أبحاث المعهد بيقين 100% وبصفر تخمين (Zero-Guessing Research Task)
══════════════════════════════════════════════════════════════════════════════════════════════════
المزايا الرئيسية:
  1. صفر تخمين ومحاكاة دقيقة لشروط اللعبة (Zero-Guessing Pre-flight):
     - فحص مستوى المعهد (College Level / bid 113) المطلوب للبحث بالدقة الكاملة.
     - فحص كافة الأبحاث المسبقة (Prerequisites) ومستوياتها المطلوبة من الذاكرة الحية.
     - فحص الموارد الحرة الحالية في القلعة ومطابقتها التامة قبل إرسال أي طلب.
  2. صفر استهلاك شبكي زائد (0-Network Guarantee):
     - لا توجد أي محاولات تجريبية أو أخطاء شبكية (Zero Trial-and-Error).
     - يتم إرسال طلب واحد فقط للبحث المؤهل قطعياً، والتوقف الآمن إذا لم تتوفر الشروط.
  3. سلم الأولويات الاستراتيجية الهجينة:
     - مهمة الدليل الرسمية (Guide Quest) أولاً إن كانت مستوفية للشروط بنسبة 100%.
     - الشؤون العسكرية -> الدفاع والتحصينات -> تنمية المدينة -> الموارد.
     - تفضيل الأبحاث الأقل مستوى والأقصر وقتاً لتسريع دوران الطابور ونقاط النشاط.
"""

from __future__ import annotations

import asyncio
import json
import os
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

# قاموس التخزين المؤقت لقواعد الأبحاث وأسمائها بالعربية
_TECH_RULES_CACHE: Dict[str, Dict[str, Any]] = {}
_TECH_NAMES_CACHE: Dict[str, str] = {}

# ترتيب أولويات أشجار الأبحاث في اللعبة
TREE_PRIORITY: Dict[str, int] = {
    "military": 1,
    "defense": 2,
    "city": 3,
    "resources": 4,
}

TREE_TITLES_AR: Dict[str, str] = {
    "military": "⚔️ الشؤون العسكرية",
    "defense": "🛡️ الدفاع والتحصينات",
    "city": "🏛️ تنمية وتطوير المدينة",
    "resources": "🌾 الموارد والإنتاج",
}


def _load_tech_rules() -> Dict[str, Dict[str, Any]]:
    """تحميل قواعد ومتطلبات أبحاث اللعبة من core/technology_rules.json مرة واحدة في الذاكرة."""
    global _TECH_RULES_CACHE
    if _TECH_RULES_CACHE:
        return _TECH_RULES_CACHE

    rules_path = os.path.join(_ROOT_DIR, "core", "technology_rules.json")
    if os.path.exists(rules_path):
        try:
            with open(rules_path, "r", encoding="utf-8") as f:
                _TECH_RULES_CACHE = json.load(f)
        except Exception:
            _TECH_RULES_CACHE = {}

    return _TECH_RULES_CACHE


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
    مهمة إجراء أبحاث المعهد بيقين 100% وبصفر تخمين.
    """
    name = "research"
    alias = "research"

    def __init__(self, conn: Any, log_func: Optional[Any] = None, config: Optional[Dict[str, Any]] = None):
        super().__init__(conn, log_func, config)
        self.tech_rules = _load_tech_rules()
        self.tech_names = _load_arabic_tech_names()

    def get_tech_title(self, tech_id: Any) -> str:
        """إرجاع الاسم العربي للبحث ورقم المعرف."""
        s_id = str(tech_id).strip()
        name_ar = self.tech_names.get(s_id, "")
        if name_ar:
            return f"[{s_id}] {name_ar}"
        return f"بحث #{s_id}"

    def _get_queue_status(self) -> Dict[str, Any]:
        """فحص حالة طابور أبحاث المعهد (1212) بصفر استهلاك شبكي من الذاكرة الحية."""
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

            if remain_time > 0:
                return {
                    "is_busy": True,
                    "remain_time": remain_time,
                    "tech_id": tech_id,
                    "target_level": target_level,
                }

            # اكتمل الطابور زمنياً: ترقية مستوى البحث في technologyCtrl وحذف الطابور المنتهي
            if tech_id:
                tech_ctrl = self.get_ctrl("technologyCtrl")
                if isinstance(tech_ctrl, dict):
                    cur_entry = tech_ctrl.get(tech_id)
                    cur_lv = int(cur_entry[1]) if isinstance(cur_entry, list) and len(cur_entry) > 1 else 0
                    if target_level > cur_lv:
                        tech_ctrl[tech_id] = [tech_id, target_level]
            queue_ctrl.pop(RESEARCH_QUEUE_ID, None)
            queue_ctrl.pop(int(RESEARCH_QUEUE_ID), None)

        return {"is_busy": False, "remain_time": 0}

    def _get_learned_techs(self) -> Dict[str, int]:
        """استخراج الأبحاث المكتسبة ومستوياتها الحالية بصفر استهلاك شبكي من الذاكرة الحية."""
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
        """استخراج مستوى مبنى المعهد (bid 113) من الذاكرة الحية."""
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

    def _get_current_resources(self) -> Dict[str, int]:
        """استخراج الموارد الحرة الحالية في القلعة من الذاكرة الحية بصفر استهلاك شبكي."""
        city = self.get_ctrl("cityCtrl")
        res_raw = city.get("resList", {}) or city.get("reslist", {}) if isinstance(city, dict) else {}
        return {
            "food": int(float(res_raw.get("1002", res_raw.get("food", 0)))),
            "wood": int(float(res_raw.get("1003", res_raw.get("wood", 0)))),
            "iron": int(float(res_raw.get("1004", res_raw.get("iron", 0)))),
            "silver": int(float(res_raw.get("1005", res_raw.get("silver", 0)))),
        }

    def _get_guide_quest_tech(self) -> Optional[Tuple[str, int]]:
        """فحص مهمة الدليل الحالية في اللعبة (Guide Quest) إن وجدت."""
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

    def find_best_qualified_research(
        self,
        college_lv: int,
        learned_techs: Dict[str, int],
        resources: Dict[str, int],
        guide_quest: Optional[Tuple[str, int]],
    ) -> Tuple[Optional[Dict[str, Any]], Dict[str, int]]:
        """
        محرك الفحص المسبق الشامل بيقين 100% (Zero-Guessing Engine):
        يفحص كافة الأبحاث ويتحقق من:
          1. مستوى المعهد المطلوب.
          2. الأبحاث المسبقة ومستوياتها المطلوبة.
          3. الموارد الحرة المتوفرة.
        يرتب المؤهلين بنسبة 100% فقط ويختار أفضل بحث قطعي النجاح.
        """
        qualified: List[Tuple[Tuple[int, int, int, int], Dict[str, Any]]] = []
        stats = {"total_evaluated": 0, "blocked_college": 0, "blocked_prepose": 0, "blocked_resources": 0, "max_reached": 0}

        for base_id, levels_map in self.tech_rules.items():
            stats["total_evaluated"] += 1
            cur_lv = learned_techs.get(base_id, 0)
            next_lv = cur_lv + 1
            rule = levels_map.get(str(next_lv))

            if not rule:
                stats["max_reached"] += 1
                continue

            # 1. فحص مستوى المعهد
            req_college_lv = int(rule.get("college_lv", 1))
            if college_lv < req_college_lv:
                stats["blocked_college"] += 1
                continue

            # 2. فحص الأبحاث المسبقة
            preposes = rule.get("prepose", [])
            prepose_ok = True
            for pre in preposes:
                p_id = str(pre.get("tech_id", ""))
                p_req_lv = int(pre.get("level", 1))
                if learned_techs.get(p_id, 0) < p_req_lv:
                    prepose_ok = False
                    break

            if not prepose_ok:
                stats["blocked_prepose"] += 1
                continue

            # 3. فحص الموارد الحرة بالقلعة
            req_res = rule.get("res", {})
            req_food = int(req_res.get("food", 0))
            req_wood = int(req_res.get("wood", 0))
            req_iron = int(req_res.get("iron", 0))
            req_silver = int(req_res.get("silver", 0))

            if (
                resources["food"] < req_food
                or resources["wood"] < req_wood
                or resources["iron"] < req_iron
                or resources["silver"] < req_silver
            ):
                stats["blocked_resources"] += 1
                continue

            # البحث مستوفٍ للشروط بنسبة 100% ويقين تام!
            tree = rule.get("tree", "military")
            tree_rank = TREE_PRIORITY.get(tree, 99)
            res_time = int(rule.get("time", 60))

            is_guide = False
            if guide_quest:
                g_tid, g_tlv = guide_quest
                if str(g_tid) == str(base_id) and int(g_tlv) == next_lv:
                    is_guide = True

            # معيار الفرز: (مهمة الدليل، أولوية الشجرة، المستوى الأقل، الوقت الأقصر)
            score_tuple = (0 if is_guide else 1, tree_rank, next_lv, res_time)
            candidate_item = {
                "tech_id": base_id,
                "target_level": next_lv,
                "tree": tree,
                "tree_title": TREE_TITLES_AR.get(tree, tree),
                "rule": rule,
                "is_guide": is_guide,
            }
            qualified.append((score_tuple, candidate_item))

        if not qualified:
            return None, stats

        # ترتيب تصاعدي لأفضل بحث مؤهل
        qualified.sort(key=lambda x: x[0])
        best_candidate = qualified[0][1]
        return best_candidate, stats

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
        self.log("🔬 بدء فحص أبحاث المعهد (نظام اليقين التام 0-Guessing)...")

        # 1. التأكد من حالة الطابور
        queue_status = self._get_queue_status()
        if queue_status["is_busy"]:
            cur_title = self.get_tech_title(queue_status["tech_id"])
            rem_str = format_duration(queue_status["remain_time"])
            msg = f"⏳ طابور المعهد مشغول حالياً ببحث {cur_title} للمستوى {queue_status['target_level']} (متبقي: {rem_str})"
            self.log(msg)
            return TaskResult.skip(msg)

        # 2. التأكد من مستوى مبنى المعهد
        college_lv = self._get_college_level()
        if college_lv <= 0:
            msg = "⚠️ مبنى المعهد (College) غير موجود في القلعة بعد."
            self.log(msg)
            return TaskResult.skip(msg)

        # 3. قراءة كائنات الذاكرة الحية (0-Network)
        learned_techs = self._get_learned_techs()
        current_res = self._get_current_resources()
        guide_quest = self._get_guide_quest_tech()

        # 4. محرك الفحص المسبق الشامل واختيار البحث المؤهل بيقين
        best_tech, stats = self.find_best_qualified_research(
            college_lv=college_lv,
            learned_techs=learned_techs,
            resources=current_res,
            guide_quest=guide_quest,
        )

        if not best_tech:
            detail_msg = (
                f"لا توجد أبحاث مكتملة الشروط حالياً (المعهد Lv.{college_lv} | "
                f"حجب معهد: {stats['blocked_college']}، حجب متطلبات سابقة: {stats['blocked_prepose']}، "
                f"حجب موارد حرة: {stats['blocked_resources']}) — تخطي بأمان."
            )
            self.log(f"ℹ️ [الأكاديمية] {detail_msg}")
            return TaskResult.skip(detail_msg)

        tech_id = best_tech["tech_id"]
        target_lv = best_tech["target_level"]
        tree_title = best_tech["tree_title"]
        tech_title = self.get_tech_title(tech_id)
        req_res = best_tech["rule"].get("res", {})
        res_time = best_tech["rule"].get("time", 60)

        guide_tag = " [🌟 مهمة دليل]" if best_tech["is_guide"] else ""
        self.log(
            f"🎯 [يقين 100%] تم التحقق واختيار البحث: {tech_title} (مستوى {target_lv}){guide_tag} | "
            f"الشجرة: {tree_title} | المدة: {format_duration(res_time)} — جاري إرسال أمر البدء..."
        )

        # 5. إرسال الطلب الرسمي الوحيد المؤكد النجاح بنسبة 100%
        payload = {
            "type": 1,
            "technologyId": str(tech_id),
            "rtype": 1,
        }

        resp = await self.conn.query("1017", "2", payload, timeout=7)
        err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"

        if err == "0":
            # تحديث طابور البحث 1212 بالمدة الفعلية المخفضة من السيرفر (تحديث الموارد يتم عبر NOTIFY_CITY، ومستوى التقنية عند اكتمال البحث/NOTIFY 494)
            r_data = resp.get("data") if isinstance(resp.get("data"), dict) else {}
            ret_q = r_data.get("retdata") if isinstance(r_data.get("retdata"), dict) else r_data
            actual_time = int(ret_q.get("totaltime") or ret_q.get("lefttime") or res_time)
            start_ts = int(ret_q.get("starttime") or time.time())

            queue_ctrl = self.get_ctrl("queueCtrl")
            if isinstance(queue_ctrl, dict):
                queue_ctrl[RESEARCH_QUEUE_ID] = {
                    "qtype": RESEARCH_QUEUE_ID,
                    "starttime": start_ts,
                    "totaltime": actual_time,
                    "ottime": actual_time,
                    "data": {str(tech_id): [str(tech_id), target_lv]},
                }

            msg = f"✅ تم بدء بحث {tech_title} (مستوى {target_lv}){guide_tag} بنجاح! | الشجرة: {tree_title} 🎉"
            self.log(msg)
            return TaskResult.ok(msg, data={"tech_id": tech_id, "level": target_lv})

        # في حال وجود أي رد غير متوقع من السيرفر، يتم تسجيله وعزله بأمان
        err_msg = f"❌ تعذر بدء البحث {tech_title} من السيرفر (كود: {err})"
        self.log(err_msg)
        return TaskResult.fail(err_msg)
