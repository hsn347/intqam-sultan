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
        if not isinstance(my_arena_data, dict) or not my_arena_data:
            self.log(f"ℹ️ بيانات {arena_name} غير متوفرة بالذاكرة — تم التجاوز بأمان.")
            return TaskResult.skip("بيانات نوع الحلبة غير متوفرة")

        # ═════════════════════════════════════════════════════════════════════
        # 2. استلام جوائز الترتيب التراكمية (كل 6 ساعات)
        # ═════════════════════════════════════════════════════════════════════
        auto_claim = bool(self.config.get("auto_claim_rewards", True))
        pending_rewards = my_arena_data.get("rewards", [])
        claimed_rank_rewards = False
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
                claimed_rank_rewards = True
                self.log(f"✅ تم استلام جوائز ترتيب {arena_name} بنجاح.")
            else:
                err_code = str(r_reward.get("err", "unknown")) if r_reward else "timeout"
                self.log(f"⚠️ تعذر استلام جوائز الحلبة (كود السيرفر: {err_code}).")

        # ═════════════════════════════════════════════════════════════════════
        # 3. فحص تقدم النشاط اليومي والمحاولات المتبقية (0-Network Pre-flight)
        # ═════════════════════════════════════════════════════════════════════
        arena_mode = str(self.config.get("mode", "daily") or "daily").lower().strip()
        if arena_mode not in ("daily", "per_cycle"):
            arena_mode = "daily"

        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        cur_challenges = 0
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict):
                cur_challenges = int(event_info.get(DAILY_QUEST_TYPE_ARENA, 0) or 0)

        # في وضع daily فقط نتوقف عند اكتمال 3/3، أما في per_cycle ننفذ تحدياً واحداً كل دورة
        if arena_mode == "daily" and cur_challenges >= TARGET_DAILY_CHALLENGES:
            if claimed_rank_rewards:
                return TaskResult.ok(
                    f"تم استلام جوائز ترتيب {arena_name} التراكمية (تحديات النشاط اليومي مكتملة {cur_challenges}/{TARGET_DAILY_CHALLENGES})"
                )
            self.log(
                f"ℹ️ تم إنجاز تحديات الحلبة بالنشاط اليومي مسبقاً ({cur_challenges}/{TARGET_DAILY_CHALLENGES}) — تم التجاوز بأمان (0-Network)."
            )
            return TaskResult.skip(f"مكتملة بالنشاط اليومي مسبقاً ({cur_challenges}/{TARGET_DAILY_CHALLENGES})")

        remain_times = int(my_arena_data.get("remainTimes", 0) or 0)
        if remain_times <= 0:
            if claimed_rank_rewards:
                return TaskResult.ok(f"تم استلام جوائز ترتيب {arena_name} التراكمية (لا توجد محاولات تحدٍ متبقية اليوم)")
            self.log(f"ℹ️ لا توجد محاولات تحدٍ مجانية متبقية في {arena_name} اليوم — تم التجاوز بأمان (0-Network).")
            return TaskResult.skip("لا توجد محاولات مجانية متبقية")

        # ═════════════════════════════════════════════════════════════════════
        # 3.5 بناء أقوى تشكيلة هجوم ديناميكياً (ملء 100% من سعة الحلبة عبر march_capacity)
        # ═════════════════════════════════════════════════════════════════════
        from tasks.march_manager import MarchManagerTask
        from tasks.march_capacity import get_march_capacity

        mgr = MarchManagerTask(self.conn, self.log)
        live_mem = mgr._get_live_snapshot()
        saved_army = my_arena_data.get("armyInfo", [])
        saved_heroes = my_arena_data.get("heroInfo", [])
        arms_info = my_arena_data.get("armsInfo", [])
        divine_beast_info = my_arena_data.get("divineBeastInfo", {})
        arena_group = int(my_arena_data.get("arenaGroup", 1) or 1)
        saved_fc = int(my_arena_data.get("fightCapacity", 0) or 0)

        # اختيار أقوى الأبطال المتاحين (بمن فيهم أبطال السور)
        max_heroes = self.get_max_battle_hero_num() if hasattr(self, "get_max_battle_hero_num") else 5
        avail_heroes = mgr.get_available_heroes(exclude_defend=False)
        selected_hero_ids = [int(h["hero_id"]) for h in avail_heroes[:max_heroes] if int(h.get("hero_id", 0)) > 0]
        if selected_hero_ids:
            hero_info = [{"heroID": hid} for hid in selected_hero_ids]
        else:
            hero_info = saved_heroes if isinstance(saved_heroes, list) else []
            selected_hero_ids = [
                int(h.get("heroID") or h.get("id") or 0)
                for h in hero_info if isinstance(h, dict) and int(h.get("heroID") or h.get("id") or 0) > 0
            ]

        # حساب سعة الحلبة الحقيقية (is_arena=True يستثني برج السديم مطابقاً للعبة)
        arena_cap = int(get_march_capacity(live_mem, hero_ids=selected_hero_ids or None, is_arena=True) or 0)

        # ملء 100% من سعة الحلبة بأقوى الجنود المتاحين في القلعة تنازلياً حسب القوة
        avail_soldiers = mgr.get_available_soldiers()
        enriched = []
        for s in avail_soldiers:
            sid = int(s.get("army_id") or 0)
            cnt = int(s.get("count") or 0)
            lv = int(s.get("level") or 1)
            if sid > 0 and cnt > 0:
                enriched.append((mgr._get_soldier_combat_power(sid, lv), lv, sid, cnt))
        enriched.sort(reverse=True)

        army_info: List[Dict[str, int]] = []
        remaining_cap = arena_cap
        dynamic_army_power = 0.0
        total_arena_soldiers = 0
        for unit_pwr, _lv, sid, cnt in enriched:
            if remaining_cap <= 0:
                break
            take = min(cnt, remaining_cap)
            if take > 0:
                army_info.append({"id": sid, "num": take})
                dynamic_army_power += take * unit_pwr
                total_arena_soldiers += take
                remaining_cap -= take

        # احتياطي: إذا لم يوجد جنود بالداخل لحظياً نستخدم التشكيلة المحفوظة إن وجدت
        if not army_info:
            if isinstance(saved_army, list) and len(saved_army) > 0:
                army_info = saved_army
                for itm in saved_army:
                    if isinstance(itm, dict):
                        sid = int(itm.get("id") or 0)
                        num = int(itm.get("num") or 0)
                        dynamic_army_power += num * mgr._get_soldier_combat_power(sid, sid % 100)
                        total_arena_soldiers += num
            else:
                self.log("ℹ️ لا توجد قوات متاحة ولا تشكيلة حلبة محفوظة — تم التجاوز بأمان.")
                return TaskResult.skip("لا توجد قوات لتشكيل جيش الحلبة")

        # تقدير قوتنا الجديدة (my_dynamic_fc) على نفس مقياس fightCapacity الرسمي في الحلبة
        saved_army_power = 0.0
        if isinstance(saved_army, list):
            for itm in saved_army:
                if isinstance(itm, dict):
                    sid = int(itm.get("id") or 0)
                    num = int(itm.get("num") or 0)
                    saved_army_power += num * mgr._get_soldier_combat_power(sid, sid % 100)
        heroes_base_fc = max(0.0, float(saved_fc) - saved_army_power)
        my_dynamic_fc = int(max(saved_fc, dynamic_army_power + heroes_base_fc))

        self.log(
            f"🛡️ [الحلبة] تجهيز أقوى تشكيلة هجوم: {total_arena_soldiers:,}/{arena_cap:,} جندي "
            f"| أبطال: {selected_hero_ids} | القوة التقديرية: {my_dynamic_fc:,}"
        )

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
        # 5. حلقة التحديات (انتقاء خصم قابل للهزيمة حسابياً + إيقاف فوري عند أول هزيمة)
        # ═════════════════════════════════════════════════════════════════════
        MIN_ARENA_WIN_MARGIN = 1.15  # هامش أمان حسابي (+15% فوق قوة الخصم)
        success_battles = 0
        defeated_stop = False

        def _pick_beatable_target(enemies: List[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
            valid = [e for e in enemies if isinstance(e, dict)]
            if not valid:
                return None
            # 1) الأولوية القصوى لأضعف روبوت قابل للهزيمة
            robots = [
                e for e in valid
                if (e.get("robotFlag") is True or str(e.get("robotFlag", "")).lower() == "true")
            ]
            robots.sort(key=lambda e: int(e.get("fightCapacity", 0) or 0))
            for r in robots:
                r_pwr = int(r.get("fightCapacity", 0) or 0)
                if r_pwr <= 0 or my_dynamic_fc >= r_pwr * MIN_ARENA_WIN_MARGIN:
                    return r
            # 2) إن لم يوجد روبوت قابل للهزيمة، نختار أضعف خصم في القائمة بشرط تفوقنا الحسابي عليه
            valid.sort(key=lambda e: int(e.get("fightCapacity", 0) or 0))
            weakest = valid[0]
            w_pwr = int(weakest.get("fightCapacity", 0) or 0)
            if w_pwr <= 0 or my_dynamic_fc >= w_pwr * MIN_ARENA_WIN_MARGIN:
                return weakest
            return None

        initial_challenges = cur_challenges
        max_battles_this_cycle = 1 if arena_mode == "per_cycle" else max(0, TARGET_DAILY_CHALLENGES - cur_challenges)
        battles_attempted_this_cycle = 0

        while battles_attempted_this_cycle < max_battles_this_cycle and remain_times > 0 and len(enemy_list) > 0:
            if not self.is_connected:
                self.log("⚡ [الحلبة] انقطع الاتصال ببوابة اللعبة — إيقاف التحديات فوراً.")
                break

            target = _pick_beatable_target(enemy_list)

            # إذا لم نجد خصماً قابلاً للهزيمة حسابياً، نحدث القائمة مجاناً حتى 3 محاولات
            refresh_attempts = 0
            while target is None and refresh_attempts < MAX_ROBOT_REFRESH_ATTEMPTS:
                if not self.is_connected:
                    break
                refresh_attempts += 1
                weakest_now = min(
                    (int(e.get("fightCapacity", 0) or 0) for e in enemy_list if isinstance(e, dict)),
                    default=0,
                )
                self.log(
                    f"🔄 جميع الخصوم الحاليين أقوى حسابياً (أضعف خصم: {weakest_now:,} | قوتنا: {my_dynamic_fc:,}) — "
                    f"تحديث قائمة الخصوم مجاناً ({refresh_attempts}/{MAX_ROBOT_REFRESH_ATTEMPTS})..."
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
                        target = _pick_beatable_target(enemy_list)
                else:
                    self.log("⚠️ تعذر تحديث قائمة خصوم الحلبة من السيرفر.")
                    break

            if target is None:
                self.log(
                    f"🛡️ لم يُعثر على خصم يمكن هزيمته حسابياً بعد {refresh_attempts} تحديثات "
                    f"(قوتنا: {my_dynamic_fc:,}) — تخطي المهمة بأمان."
                )
                break

            target_power = int(target.get("fightCapacity", 0) or 0)
            target_uid = target.get("uid")
            if target_uid is not None:
                try:
                    target_uid = int(target_uid)
                except (ValueError, TypeError):
                    pass
            target_rank = int(target.get("rank", 0) or 0)
            target_nick = str(target.get("nickName", "خصم"))
            is_robot = target.get("robotFlag") is True or str(target.get("robotFlag", "")).lower() == "true"
            kind_lbl = "الروبوت" if is_robot else "الخصم"

            self.log(
                f"🗡️ بدء تحدي الحلبة ({cur_challenges + 1}/{TARGET_DAILY_CHALLENGES}) ضد {kind_lbl} [{target_nick}] "
                f"(الرتبة: #{target_rank} | قوة الخصم: {target_power:,} | قوتنا: {my_dynamic_fc:,})..."
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

            remain_times = int(server_remain) if server_remain is not None else max(0, remain_times - 1)
            my_arena_data["remainTimes"] = remain_times
            if b_win and new_rank:
                my_arena_data["myRank"] = new_rank

            battles_attempted_this_cycle += 1
            cur_challenges += 1
            # مزامنة آمنة غير قابلة للمضاعفة مع NOTIFY_EVERYDAY_TASK (55)
            cur_ev_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
            if isinstance(cur_ev_ctrl, dict):
                ev_map = cur_ev_ctrl.setdefault("eventInfo", {})
                if isinstance(ev_map, dict):
                    expected_c = min(TARGET_DAILY_CHALLENGES, initial_challenges + battles_attempted_this_cycle)
                    ev_map["30"] = max(int(ev_map.get("30", 0) or 0), expected_c)

            if not b_win:
                defeated_stop = True
                self.log(
                    f"🛑 هزيمة في الحلبة ضد [{target_nick}] (قوة الخصم: {target_power:,}) — "
                    f"إيقاف مهمة الحلبة بالكامل وتخطي باقي التحديات فوراً وفق قواعد الحماية."
                )
                break

            success_battles += 1
            self.log(
                f"✅ اكتمال التحدي: فوز ساحق 🏆 | الرتبة: #{new_rank} | "
                f"إنجاز النشاط اليومي: {cur_challenges}/{TARGET_DAILY_CHALLENGES} | المحاولات المتبقية: {remain_times}"
            )

            if new_enemies and isinstance(new_enemies, list):
                enemy_list = new_enemies

            if battles_attempted_this_cycle < max_battles_this_cycle and remain_times > 0:
                await asyncio.sleep(random.uniform(2.0, 3.5))

        if success_battles > 0:
            stop_note = " (توقف بعد رصد هزيمة)" if defeated_stop else ""
            return TaskResult.ok(
                f"تم الفوز في {success_battles} تحديات بـ {arena_name}{stop_note} ({cur_challenges}/{TARGET_DAILY_CHALLENGES})"
            )
        if claimed_rank_rewards:
            return TaskResult.ok(f"تم استلام جوائز ترتيب {arena_name} التراكمية وتخطي التحديات بأمان")
        if defeated_stop:
            return TaskResult.skip("تم إيقاف وتخطي مهمة الحلبة فوراً بعد رصد هزيمة في التحدي الأول")
        return TaskResult.skip("لم يتم تنفيذ أي تحديات في الحلبة (لا يوجد خصم قابل للهزيمة حسابياً)")