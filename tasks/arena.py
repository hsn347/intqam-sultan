# -*- coding: utf-8 -*-
"""
python tools/test_task_method.py --email beetoo3@hotmail.com --task arena run
"""

from __future__ import annotations

import asyncio
import random
from typing import Any, Callable, Dict, List, Optional

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية للحلبة
CMD_ARENA_MODULE = "2056"
REQ_ARENA_GROUND_STATE = "1"         # فتح الحلبة واستعلام الخصوم والترتيب
REQ_ARENA_SET_DEFEND = "4"           # تعيين تشكيلة الدفاع
REQ_ARENA_GET_REWARD = "5"           # استلام جوائز الترتيب التراكمية
REQ_ARENA_ARENA_CHALLENGE = "6"      # خوض التحدي القتالي ضد الخصم
REQ_ARENA_REFRESH_RIVAL = "9"        # تحديث قائمة الخصوم مجاناً

# أنواع الحلبات الرسمية (arenaDef.lua)
ARENA_TYPE_LOCAL = 1   # حلبة المملكة
ARENA_TYPE_GLOBAL = 2  # حلبة العالم

# ثوابت المهمة
DAILY_QUEST_TYPE_ARENA = "30"  # معرف مهمة تحدي الحلبة بالنشاط اليومي (4100030)
TARGET_DAILY_CHALLENGES = 3    # الحد الأقصى المطلوب لإنجاز النشاط اليومي بالكامل (15 نقطة)
MIN_REQ_CASTLE_LEVEL = 16      # مستوى القلعة / ساحة التدريب الأدنى لدخول الحلبة
MAX_ROBOT_REFRESH_ATTEMPTS = 3 # الحد الأقصى لمحاولات تحديث الخصوم للبحث عن روبوت لكل معركة


class ArenaTask(BaseTask):
    """مهمة تحدي الحلبة واستلام جوائز الترتيب التراكمية للنشاط اليومي"""
    name = "arena"
    alias = "arena_challenge"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    @property
    def is_active(self) -> bool:
        """المهمة اختيارية وتعتمد على تفعيل المستخدم لها في الواجهة."""
        return bool(self.config.get("enabled", False))

    async def run(self) -> TaskResult:
        # ═════════════════════════════════════════════════════════════════════
        # 1. الفحص القبلي من الذاكرة الحية (0-Network Pre-flight Checks)
        # ═════════════════════════════════════════════════════════════════════

        # أ. فحص مستوى القلعة
        c_lv = self.castle_level
        if c_lv < MIN_REQ_CASTLE_LEVEL:
            self.log(
                f"ℹ️ الحلبة غير متاحة (تتطلب قلعة مستوى {MIN_REQ_CASTLE_LEVEL} على الأقل، الحالي: Lv.{c_lv}) — تم التجاوز بأمان (0-Network)."
            )
            return TaskResult.skip(f"تتطلب قلعة مستوى {MIN_REQ_CASTLE_LEVEL} (الحالي: {c_lv})")

        # ب. فحص متحكم الحلبة في الذاكرة الحية
        arena_ctrl = self.get_ctrl("playerArenaCtrl")
        if not isinstance(arena_ctrl, dict):
            self.log("ℹ️ بيانات الحلبة غير متوفرة في الذاكرة الحية — تم التجاوز بأمان.")
            return TaskResult.skip("بيانات الحلبة غير متوفرة")

        # ج. تحديد نوع الحلبة المفضل وسلوك التبديل الذكي
        preferred_mode = str(self.config.get("arena_type", "kingdom")).lower()
        battle_type = ARENA_TYPE_LOCAL
        arena_key = "localArena"
        arena_name = "حلبة المملكة"

        if preferred_mode == "global":
            global_data = arena_ctrl.get("globalArena", {})
            if isinstance(global_data, dict) and int(global_data.get("arenaStatus", 0) or 0) == 1:
                battle_type = ARENA_TYPE_GLOBAL
                arena_key = "globalArena"
                arena_name = "حلبة العالم"
            else:
                self.log("ℹ️ حلبة العالم مغلقة حالياً (تفتح أيام الأحد) — التبديل التلقائي لحلبة المملكة لضمان إنجاز النشاط اليومي.")
                battle_type = ARENA_TYPE_LOCAL
                arena_key = "localArena"
                arena_name = "حلبة المملكة"

        my_arena_data = arena_ctrl.get(arena_key, {})
        if not isinstance(my_arena_data, dict) or None:
            self.log(f"ℹ️ بيانات {arena_name} غير متوفرة بالذاكرة — تم التجاوز بأمان.")
            return TaskResult.skip("بيانات نوع الحلبة غير متوفرة")

        # ═════════════════════════════════════════════════════════════════════
        # 2. استلام جوائز الترتيب التراكمية (كل 6 ساعات)
        # ═════════════════════════════════════════════════════════════════════
        auto_claim = bool(self.config.get("auto_claim_rewards", True))
        pending_rewards = my_arena_data.get("rewards", [])
        if auto_claim and isinstance(pending_rewards, list) and len(pending_rewards) > 0:
            self.log(f"🎁 استلام جوائز ترتيب {arena_name} التراكمية ({len(pending_rewards)} جولة متراكمة)...")
            r_reward = await self.safe_query(
                CMD_ARENA_MODULE,
                REQ_ARENA_GET_REWARD,
                {"arenaType": battle_type},
                min_delay=0.4,
                max_delay=0.8,
            )
            if r_reward and str(r_reward.get("err", "0")) == "0":
                my_arena_data["rewards"] = []
                self.log(f"✅ تم استلام جوائز ترتيب {arena_name} بنجاح.")
            else:
                err_code = str(r_reward.get("err", "unknown")) if r_reward else "timeout"
                self.log(f"⚠️ تعذر استلام جوائز الحلبة (كود السيرفر: {err_code}).")

        # ═════════════════════════════════════════════════════════════════════
        # 3. فحص تقدم النشاط اليومي والمحاولات المتبقية (0-Network Pre-flight)
        # ═════════════════════════════════════════════════════════════════════
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        cur_challenges = 0
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict):
                cur_challenges = int(event_info.get(DAILY_QUEST_TYPE_ARENA, 0) or 0)

        # إذا اكتملت تحديات النشاط اليومي الثلاثة
        if cur_challenges >= TARGET_DAILY_CHALLENGES:
            self.log(
                f"ℹ️ تم إنجاز تحديات الحلبة بالنشاط اليومي مسبقاً ({cur_challenges}/{TARGET_DAILY_CHALLENGES}) — تم التجاوز بأمان (0-Network)."
            )
            return TaskResult.skip(f"مكتملة بالنشاط اليومي مسبقاً ({cur_challenges}/{TARGET_DAILY_CHALLENGES})")

        # فحص عدد المحاولات المجانية المتبقية
        remain_times = int(my_arena_data.get("remainTimes", 0) or 0)
        if remain_times <= 0:
            self.log(f"ℹ️ لا توجد محاولات تحدٍ مجانية متبقية في {arena_name} اليوم — تم التجاوز بأمان (0-Network).")
            return TaskResult.skip("لا توجد محاولات مجانية متبقية")

        # فحص التشكيلة الدفاعية (إذا لم تكن مجهزة مسبقاً، نتجاوز بأمان)
        army_info = my_arena_data.get("armyInfo", {})
        if not army_info or (isinstance(army_info, (dict, list)) and len(army_info) == 0):
            self.log("ℹ️ لم يتم تجهيز تشكيلة الحلبة يدوياً في اللعبة مسبقاً — تم التجاوز بأمان لحماية الحساب.")
            return TaskResult.skip("لم يتم تجهيز تشكيلة الحلبة مسبقاً")

        hero_info = my_arena_data.get("heroInfo", [])
        arms_info = my_arena_data.get("armsInfo", [])
        divine_beast_info = my_arena_data.get("divineBeastInfo", {})
        arena_group = int(my_arena_data.get("arenaGroup", 1) or 1)
        my_power = int(my_arena_data.get("fightCapacity", 0) or 0)

        # ═════════════════════════════════════════════════════════════════════
        # 4. استعلام قائمة الخصوم (Ground State)
        # ═════════════════════════════════════════════════════════════════════
        self.log(
            f"⚔️ استعلام خصوم {arena_name} (المحاولات المتاحة: {remain_times}، المنجز بالنشاط: {cur_challenges}/{TARGET_DAILY_CHALLENGES})..."
        )
        r_ground = await self.safe_query(
            CMD_ARENA_MODULE,
            REQ_ARENA_GROUND_STATE,
            {"arenaType": battle_type},
            min_delay=0.5,
            max_delay=1.0,
        )
        if not r_ground or str(r_ground.get("err", "0")) != "0":
            err_code = str(r_ground.get("err", "unknown")) if r_ground else "timeout"
            self.log(f"⚠️ تعذر استعلام خصوم الحلبة (كود السيرفر: {err_code}).")
            return TaskResult.fail(f"فشل استعلام الخصوم ({err_code})")

        rspdata = r_ground.get("data", {}).get("rspdata") or r_ground.get("rspdata", {})
        enemy_list = rspdata.get("enemyInfo", [])
        if not enemy_list or not isinstance(enemy_list, list):
            self.log("⚠️ قائمة خصوم الحلبة فارغة — تم التجاوز.")
            return TaskResult.skip("قائمة الخصوم فارغة")

        # ═════════════════════════════════════════════════════════════════════
        # 5. حلقة التحديات (حتى 3 تحديات لإكمال النشاط اليومي ضد الروبوتات فقط)
        # ═════════════════════════════════════════════════════════════════════
        success_battles = 0

        while cur_challenges < TARGET_DAILY_CHALLENGES and remain_times > 0 and len(enemy_list) > 0:
            # تصفية الخصوم لحصرهم على الروبوتات فقط (robotFlag == True)
            robot_enemies = [
                e for e in enemy_list
                if (e.get("robotFlag") is True or str(e.get("robotFlag", "")).lower() == "true")
            ]

            # إذا لم يتوفر أي روبوت في القائمة الحالية، نقوم بتحديث القائمة (حتى 3 محاولات كحد أقصى لكل معركة)
            refresh_attempts = 0
            while not robot_enemies and refresh_attempts < MAX_ROBOT_REFRESH_ATTEMPTS:
                refresh_attempts += 1
                self.log(
                    f"🔄 لا توجد روبوتات في قائمة الخصوم — محاولة تحديث القائمة مجاناً ({refresh_attempts}/{MAX_ROBOT_REFRESH_ATTEMPTS})..."
                )
                r_refresh = await self.safe_query(
                    CMD_ARENA_MODULE,
                    REQ_ARENA_REFRESH_RIVAL,
                    {"arenaType": battle_type},
                    min_delay=0.8,
                    max_delay=1.5,
                )
                if r_refresh and str(r_refresh.get("err", "0")) == "0":
                    refresh_data = r_refresh.get("data", {}).get("rspdata") or r_refresh.get("rspdata", {})
                    refreshed_enemies = refresh_data.get("enemyInfo", [])
                    if refreshed_enemies and isinstance(refreshed_enemies, list):
                        enemy_list = refreshed_enemies
                        robot_enemies = [
                            e for e in enemy_list
                            if (e.get("robotFlag") is True or str(e.get("robotFlag", "")).lower() == "true")
                        ]
                else:
                    self.log("⚠️ تعذر تحديث قائمة خصوم الحلبة من السيرفر.")
                    break

            # إذا لم نجد أي روبوت بعد استنفاد محاولات التحديث الـ 3، نتوقف ونتخطى فوراً لحماية القلعة
            if not robot_enemies:
                self.log(
                    f"🛡️ لم يتم العثور على أي خصم روبوت بعد {refresh_attempts} محاولات تحديث — تخطي بأمان لمنع مهاجمة اللاعبين البشريين."
                )
                break

            # فرز الروبوتات تصاعدياً حسب القوة القتالية لاختيار الأضعف دائماً وضمان الفوز 100%
            sorted_robots = sorted(
                robot_enemies,
                key=lambda e: int(e.get("fightCapacity", 0) or 0)
            )
            target = sorted_robots[0]
            target_power = int(target.get("fightCapacity", 0) or 0)
            target_uid = target.get("uid")
            if target_uid is not None:
                try:
                    target_uid = int(target_uid)
                except (ValueError, TypeError):
                    pass
            target_rank = int(target.get("rank", 0) or 0)
            target_nick = str(target.get("nickName", "خصم روبوت"))

            # خوض التحدي القتالي ضد الروبوت المختار
            self.log(
                f"🗡️ بدء تحدي الحلبة ({cur_challenges + 1}/{TARGET_DAILY_CHALLENGES}) ضد الروبوت [{target_nick}] (الرتبة: #{target_rank}، القوة: {target_power:,})..."
            )
            challenge_payload = {
                "targetUid": target_uid,
                "targetRank": target_rank,
                "nickName": target_nick,
                "arenaType": battle_type,
                "arenaGroup": arena_group,
                "armyInfo": army_info,
                "heroInfo": hero_info,
                "armsInfo": arms_info,
                "divineBeastInfo": divine_beast_info,
            }

            r_fight = await self.safe_query(
                CMD_ARENA_MODULE,
                REQ_ARENA_ARENA_CHALLENGE,
                challenge_payload,
                min_delay=1.5,
                max_delay=2.8,
            )

            if not r_fight or str(r_fight.get("err", "0")) != "0":
                err_code = str(r_fight.get("err", "unknown")) if r_fight else "timeout"
                self.log(f"⚠️ فشل تنفيذ تحدي الحلبة (كود السيرفر: {err_code}).")
                break

            fight_rsp = r_fight.get("data", {}).get("rspdata") or r_fight.get("rspdata", {})
            b_win = bool(fight_rsp.get("bWin", False))
            new_rank = fight_rsp.get("rank", target_rank)
            server_remain = fight_rsp.get("remainTimes")
            new_enemies = fight_rsp.get("enemyInfo", [])

            # تحديث الذاكرة الحية فورياً (In-Memory State Sync)
            remain_times = int(server_remain) if server_remain is not None else max(0, remain_times - 1)
            my_arena_data["remainTimes"] = remain_times
            if b_win and new_rank:
                my_arena_data["myRank"] = new_rank

            cur_challenges += 1
            success_battles += 1

            if isinstance(everyday_ctrl, dict):
                event_info = everyday_ctrl.get("eventInfo", {})
                if isinstance(event_info, dict):
                    event_info[DAILY_QUEST_TYPE_ARENA] = cur_challenges

            result_txt = "فوز ساحق 🏆" if b_win else "هزيمة ⚠️"
            self.log(
                f"✅ اكتمال التحدي: {result_txt} | الرتبة: #{new_rank} | إنجاز النشاط اليومي: {cur_challenges}/{TARGET_DAILY_CHALLENGES} | المحاولات المتبقية: {remain_times}"
            )

            # تجديد قائمة الخصوم من رد السيرفر للجولة القادمة إن وُجدت
            if new_enemies and isinstance(new_enemies, list):
                enemy_list = new_enemies

            # فاصل زمني بشري عشوائي قبل التحدي التالي
            if cur_challenges < TARGET_DAILY_CHALLENGES and remain_times > 0:
                await asyncio.sleep(random.uniform(2.0, 3.5))

        if success_battles > 0:
            return TaskResult.ok(
                f"تم تنفيذ {success_battles} تحديات في {arena_name} بنجاح ({cur_challenges}/{TARGET_DAILY_CHALLENGES})"
            )
        return TaskResult.skip("لم يتم تنفيذ أي تحديات جديدة في الحلبة (لا توجد روبوتات متاحة للتحدي بأمان)")
