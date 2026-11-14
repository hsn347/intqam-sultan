# -*- coding: utf-8 -*-
"""
tasks/pet.py — مهمة رعاية وجوائز الحيوانات (Pet Task) - النسخة المصححة المعمقة
═══════════════════════════════════════════════════════════════════════════════
البروتوكول الشبكي للعبة:
  - CMD: "2036" (CMD_PET_MODULE)
  - SubCMD: "4" (REQ_GET_SPECIAL_SKILL_TOOL - استلام جوائز المهارات الخاصة)
  - SubCMD: "2" (REQ_FEED_PET - إطعام الحيوان)

الميزات وصمامات الأمان:
  1. حصر استلام جوائز المهارات بالحيوانات الـ 5 التي تمتلك مهارة إرسال الهدايا فقط
     (1251 الحصان، 1252 الفهد، 1253 الصقر، 1257 الوشق، 1263 اللآما).
  2. التحقق الدقيق من رمز الاستجابة الرسمي للسيرفر (str(res.get("err")) == "0").
  3. خوارزمية التبديل الذكي التلقائي (Smart Fallback): فحص الذاكرة (0-Network)؛
     إذا كان الحيوان المحدد غير مفتوح أو وصل لأعلى مستوى لرتبته الحالية (Max Level)،
     يتم توجيه الإطعام المجاني تلقائياً لأول حيوان مفتوح آخر يحتاج ترقية.
  4. حظر تام وقطعي لاستهلاك الذهب (0 Gold Consumption) بتثبيت feedType: 1 دائماً.
  5. التخطي الفوري في can_run() بأقل من 0.01ms عند عدم وجود ما يمكن إنجازه.
"""

from __future__ import annotations

import time
from typing import Any, Dict, Optional, Tuple, Set

from tasks.base_task import BaseTask, TaskResult

# ثوابت نظام الحيوانات في لعبة انتقام السلاطين
CMD_PET_MODULE = "2036"
REQ_FEED_PET = "2"
REQ_GET_SPECIAL_SKILL_TOOL = "4"

# أنواع الإطعام (مأخوذة من gPetFeedType الأصلي في اللعبة)
FEED_TYPE_FREE = 1  # مجاني حصراً
MAX_FREE_FEED = 2   # الحد الأقصى للإطعام المجاني يومياً

# الحيوان الافتراضي (أسد عربي)
DEFAULT_TARGET_PET = 1256

# الحيوانات الـ 5 الوحيدة في اللعبة التي تمتلك مهارة إرسال الجوائز اليومية (special_skill_send)
# وفق جدول اللعبة الرسمي pet_rank_conf.lua (كافة الحيوانات الـ 13 الأخرى send_time = 0)
PETS_WITH_SKILL_GIFTS: Set[int] = {1251, 1252, 1253, 1257, 1263}

# سقوف المستويات حسب الرتبة المستخرجة من جدول اللعبة الرسمي pet_rank_conf.lua
PET_RANK_MAX_LEVEL: Dict[Tuple[int, int], int] = {
    (1251, 1): 30, (1251, 2): 30,
    (1252, 1): 30, (1252, 2): 60, (1252, 3): 60,
    (1253, 1): 30, (1253, 2): 60, (1253, 3): 90, (1253, 4): 90,
    (1254, 1): 30, (1254, 2): 60, (1254, 3): 60,
    (1255, 1): 30, (1255, 2): 60, (1255, 3): 60,
    (1256, 1): 30, (1256, 2): 60, (1256, 3): 90, (1256, 4): 90,
    (1257, 1): 30, (1257, 2): 60, (1257, 3): 60,
    (1258, 1): 30, (1258, 2): 60, (1258, 3): 60, (1258, 4): 90,
    (1259, 1): 30, (1259, 2): 60, (1259, 3): 90, (1259, 4): 90,
    (1260, 1): 30, (1260, 2): 60, (1260, 3): 90, (1260, 4): 90,
    (1261, 1): 30, (1261, 2): 60, (1261, 3): 60, (1261, 4): 90,
    (1262, 1): 30, (1262, 2): 60, (1262, 3): 60,
    (1263, 1): 30, (1263, 2): 60, (1263, 3): 60,
    (1264, 1): 30, (1264, 2): 60, (1264, 3): 60, (1264, 4): 90,
    (1265, 1): 30, (1265, 2): 60, (1265, 3): 90, (1265, 4): 90,
    (1266, 1): 30, (1266, 2): 60, (1266, 3): 90, (1266, 4): 90,
    (1267, 1): 30, (1267, 2): 60, (1267, 3): 90, (1267, 4): 90,
    (1268, 1): 30, (1268, 2): 60, (1268, 3): 90, (1268, 4): 90,
}


class PetTask(BaseTask):
    """
    مهمة فحص واستلام جوائز الحيوانات والإطعام المجاني مع التبديل الذكي.
    """
    name: str = "pet"

    def get_pet_max_level(self, pid: int, rank: int) -> int:
        """إرجاع سقف المستوى لرتبة الحيوان الحالية من جدول اللعبة الرسمي."""
        if (pid, rank) in PET_RANK_MAX_LEVEL:
            return PET_RANK_MAX_LEVEL[(pid, rank)]
        if rank <= 1:
            return 30
        elif rank == 2:
            return 60
        return 90

    def is_pet_feedable(self, pid: int, pdata: Dict[str, Any]) -> bool:
        """
        التحقق في الذاكرة (0-Network) هل الحيوان مفتوح وقابل للإطعام والترقية:
        - مفتوح: لديه رتبة rank >= 1 أو مستوى level >= 1.
        - قابل للإطعام: مستواه أقل من الحد الأقصى لرتبته الحالية (level < max_level).
        """
        if not isinstance(pdata, dict):
            return False
        rank = int(pdata.get("rank", 0) or 0)
        level = int(pdata.get("level", 0) or 0)
        if rank < 1 and level < 1:
            return False
        max_lv = self.get_pet_max_level(pid, rank)
        return level < max_lv

    def get_effective_feed_target(
        self, preferred_id: int, pet_list: Dict[str, Any]
    ) -> Tuple[Optional[int], str]:
        """
        تحديد الحيوان المستهدف الفعلي للإطعام المجاني بالتبديل الذكي (0-Network):
        1. فحص الحيوان المفضل المحدد بالواجهة أولاً.
        2. إذا كان غير مفتوح أو كامل المستوى، البحث عن أفضل بديل مفتوح يحتاج ترقية.
        3. إذا كانت كل الحيوانات مكتملة، التوقف بصفر استعلامات شبكية.
        """
        target_data = pet_list.get(str(preferred_id))
        if target_data and self.is_pet_feedable(preferred_id, target_data):
            return preferred_id, "preferred"

        # تحديد سبب عدم الأهلية
        if not target_data or (int(target_data.get("rank", 0) or 0) < 1 and int(target_data.get("level", 0) or 0) < 1):
            reason = "غير مفتوح في القلعة"
        else:
            rank = int(target_data.get("rank", 1) or 1)
            lvl = int(target_data.get("level", 1) or 1)
            max_lvl = self.get_pet_max_level(preferred_id, rank)
            reason = f"وصل لأعلى مستوى للرتبة الحالية ({lvl}/{max_lvl})"

        # البحث عن بديل مفتوح يحتاج ترقية
        candidates = []
        for pid_str, pdata in pet_list.items():
            try:
                pid = int(pid_str)
            except (ValueError, TypeError):
                continue
            if self.is_pet_feedable(pid, pdata):
                cur_lvl = int(pdata.get("level", 1) or 1)
                candidates.append((cur_lvl, pid))

        if candidates:
            # ترتيب البدائل حسب الأقل مستوى لتعظيم الاستفادة وتوزيع الخبرة
            candidates.sort()
            fallback_id = candidates[0][1]
            return fallback_id, f"الحيوان المحدد #{preferred_id} {reason} -> تم التوجيه تلقائياً للحيوان المفتوح #{fallback_id}"

        return None, f"الحيوان المحدد #{preferred_id} {reason}، وكافة الحيوانات المفتوحة الأخرى مكتملة المستوى"

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي فائق السرعة في الذاكرة الحية (0-Network Pre-flight):
        - هل المهمة مفعلة بالواجهة وفق رغبة المستخدم؟
        - هل كائن petCtrl متوفر في الذاكرة؟
        - هل يتوفر إطعام مجاني وهل يوجد حيوان مفتوح قابل للإطعام؟
        - هل تتوفر جوائز معلقة للحيوانات الـ 5 المانحة فقط؟
        """
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة وفق رغبة المستخدم"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        pet_ctrl = self.get_ctrl("petCtrl")
        if not pet_ctrl or not isinstance(pet_ctrl, dict):
            return False, "بيانات كائن الحيوانات (petCtrl) غير متوفرة في الذاكرة"

        pet_list = pet_ctrl.get("petList", {})
        if not isinstance(pet_list, dict):
            return False, "قائمة الحيوانات (petList) غير متوفرة بالذاكرة"

        # 1. فحص توفر الإطعام المجاني ووجود حيوان مؤهل للإطعام
        feed_info = pet_ctrl.get("feedInfo", {})
        free_used = int(feed_info.get("curFreeFeed", 0) or 0)
        free_available = (free_used < MAX_FREE_FEED)

        can_feed = False
        if free_available:
            preferred_pet = int(self.config.get("target_pet", DEFAULT_TARGET_PET))
            feed_target, _ = self.get_effective_feed_target(preferred_pet, pet_list)
            can_feed = (feed_target is not None)

        # 2. فحص جوائز المهارات المعلقة للحيوانات الـ 5 المانحة فقط (0-Network)
        now = int(time.time())
        can_claim = False

        for pid in PETS_WITH_SKILL_GIFTS:
            pdata = pet_list.get(str(pid))
            if not isinstance(pdata, dict):
                continue
            is_unlocked = (int(pdata.get("rank", 0) or 0) >= 1) or (int(pdata.get("level", 0) or 0) >= 1)
            if not is_unlocked:
                continue

            q = pdata.get("queue", {}).get("QUEUE_KEY_PET_SPECIAL_SKILL", {}) if isinstance(pdata.get("queue"), dict) else {}
            if q and isinstance(q, dict):
                st = int(q.get("starttime", 0) or 0)
                tt = int(q.get("totaltime", 0) or 0)
                if st > 0 and (now >= st + tt):
                    can_claim = True
                    break
            else:
                # إذا لم يكن هناك مؤقت وكان الحيوان المانح مفتوحاً، تتوفر الجائزة
                can_claim = True
                break

        # شرط التخطي التلقائي الفوري لتوفير RAM و CPU والشبكة
        if not can_feed and not can_claim:
            feed_reason = f"الإطعام مكتمل ({free_used}/{MAX_FREE_FEED})" if not free_available else "لا يوجد حيوان مفتوح مؤهل للإطعام"
            return False, f"لا توجد جوائز مهارات جاهزة، و {feed_reason}"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة مهمة الحيوان:
          المرحلة 1: استلام جوائز المهارات الخاصة المتاحة للحيوانات الـ 5 المانحة فقط.
          المرحلة 2: تنفيذ الإطعام المجاني مع التبديل الذكي حتى استنفاد الحد اليومي (2).
        """
        pet_ctrl = self.get_ctrl("petCtrl")
        if not pet_ctrl or not isinstance(pet_ctrl, dict):
            return TaskResult.skip("بيانات petCtrl مفقودة أثناء التنفيذ")

        now = int(time.time())
        claimed_rewards = 0
        pet_list = pet_ctrl.get("petList", {})
        if not isinstance(pet_list, dict):
            pet_list = {}

        # ═════════════════════════════════════════════════════════════════════
        # المرحلة 1: استلام جوائز المهارات الخاصة (فقط للحيوانات الـ 5 المانحة)
        # ═════════════════════════════════════════════════════════════════════
        for pid in PETS_WITH_SKILL_GIFTS:
            pdata = pet_list.get(str(pid))
            if not isinstance(pdata, dict):
                continue

            is_unlocked = (int(pdata.get("rank", 0) or 0) >= 1) or (int(pdata.get("level", 0) or 0) >= 1)
            if not is_unlocked:
                continue

            q = pdata.get("queue", {}).get("QUEUE_KEY_PET_SPECIAL_SKILL", {}) if isinstance(pdata.get("queue"), dict) else {}
            is_ready = False
            if q and isinstance(q, dict):
                st = int(q.get("starttime", 0) or 0)
                tt = int(q.get("totaltime", 0) or 0)
                if st > 0 and (now >= st + tt):
                    is_ready = True
            else:
                is_ready = True

            if is_ready:
                res = await self.safe_query(
                    CMD_PET_MODULE,
                    REQ_GET_SPECIAL_SKILL_TOOL,
                    {"petid": pid},
                    min_delay=0.5,
                    max_delay=1.0,
                )

                # التحقق الصارم من رمز الرد الرسمي للسيرفر (err == 0)
                if res and str(res.get("err", "-1")) == "0":
                    claimed_rewards += 1
                    self.log(f"✓ تم استلام جائزة المهارة الخاصة بنجاح للحيوان #{pid}")
                    # تحديث مؤقت الذاكرة محلياً لمنع تكرار الطلب في الدورة ذاتها
                    if "queue" not in pdata or not isinstance(pdata["queue"], dict):
                        pdata["queue"] = {}

                    rdata = res.get("data", {}).get("retdata", {}) if isinstance(res.get("data"), dict) else (res.get("retdata", {}) if isinstance(res.get("retdata"), dict) else {})
                    st_val = int(rdata.get("starttime", time.time()) or time.time())
                    tt_val = int(rdata.get("totaltime", 86400) or 86400)
                    pdata["queue"]["QUEUE_KEY_PET_SPECIAL_SKILL"] = {
                        "starttime": st_val,
                        "totaltime": tt_val,
                    }
                else:
                    err_code = res.get("err") if res else "timeout"
                    self.log(f"ℹ️ تعذر استلام جائزة الحيوان #{pid}: استجابة السيرفر ({err_code})")

        # ═════════════════════════════════════════════════════════════════════
        # المرحلة 2: الإطعام المجاني مع التبديل الذكي التلقائي (0 ذهب)
        # ═════════════════════════════════════════════════════════════════════
        preferred_pet_raw = self.config.get("target_pet", DEFAULT_TARGET_PET)
        try:
            preferred_pet = int(preferred_pet_raw)
        except (ValueError, TypeError):
            preferred_pet = DEFAULT_TARGET_PET

        feed_info = pet_ctrl.setdefault("feedInfo", {})
        cur_free = int(feed_info.get("curFreeFeed", 0) or 0)
        fed_count = 0
        last_target_used = preferred_pet

        while cur_free < MAX_FREE_FEED:
            # التحقق بالذاكرة (0-Network) قبل كل محاولة إطعام
            target_pet, reason_msg = self.get_effective_feed_target(preferred_pet, pet_list)
            if target_pet is None:
                self.log(f"ℹ️ توقف الإطعام: {reason_msg}")
                break

            if target_pet != preferred_pet:
                self.log(f"⚠️ {reason_msg}")

            last_target_used = target_pet

            # صمام أمان صارم ضد استهلاك الذهب وضد الحظر: تثبيت feedType: 1 ومطابقة العميل الرسمي
            payload = {
                "petid": target_pet,
                "feedType": FEED_TYPE_FREE,  # 1 = FREE ONLY
                "other": {},                 # هيكل إلزامي مطابق للعميل الرسمي لمنع الخطأ 7
            }

            res = await self.safe_query(
                CMD_PET_MODULE,
                REQ_FEED_PET,
                payload,
                min_delay=0.6,
                max_delay=1.2,
            )

            if not res or not isinstance(res, dict):
                self.log(f"⚠️ انقطاع أو عدم استجابة أثناء إطعام الحيوان #{target_pet}")
                break

            # فحص رمز الرد الحقيقي للسيرفر
            err_code = str(res.get("err", "-1"))
            if err_code != "0":
                self.log(f"⚠️ توقف الإطعام للحيوان #{target_pet}: رفض السيرفر (كود الخطأ: {err_code})")
                feed_info["curFreeFeed"] = MAX_FREE_FEED
                break

            cur_free += 1
            fed_count += 1
            feed_info["curFreeFeed"] = cur_free
            self.log(f"🍖 تم الإطعام المجاني بنجاح للحيوان #{target_pet} (محاولة {cur_free}/{MAX_FREE_FEED})")

            # مزامنة بيانات الحيوان في الذاكرة الحية إن وردت في استجابة السيرفر
            rdata = res.get("data", {}).get("retdata", {}) if isinstance(res.get("data"), dict) else (res.get("retdata", {}) if isinstance(res.get("retdata"), dict) else {})
            pet_update = rdata.get("petInfo", {})
            if pet_update and str(target_pet) in pet_list:
                pet_list[str(target_pet)].update(pet_update)

        msg = f"مهمة الحيوان: تم استلام {claimed_rewards} جوائز، وإطعام الحيوان #{last_target_used} ({fed_count} مرات مجانية)"
        return TaskResult.ok(
            msg,
            data={
                "claimed_rewards": claimed_rewards,
                "fed_count": fed_count,
                "target_pet": last_target_used,
            },
        )
