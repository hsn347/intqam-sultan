# -*- coding: utf-8 -*-
"""
tasks/skills.py — مهمة تفعيل مهارات الأمير النشطة تلقائياً (Lord Active Skills Task)
══════════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. استعلام كامل من الذاكرة الحية (0-Network Pre-flight) عبر متحكمات lordSkillCtrl، buffCtrl، queueCtrl.
  2. فحص حالة التبريد (CDData) وسريان مفعول المهارات قبل إرسال أي طلب للسيرفر.
  3. دعم التبديل التلقائي الذكي للأطقم مع الرجوع الحتمي للطقم الأصلي (Auto Revert).
  4. محاكاة بشرية وفواصل أمان بين تفعيل المهارات المتعددة (1.0 - 1.8 ثانية).
  5. عزل تام للأخطاء وتحديث فوري لحالة التبريد في الذاكرة الحية.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Dict, List, Optional
from tasks.base_task import BaseTask, TaskResult, LORD_ACTIVE_SKILLS_CATALOG


class SkillsTask(BaseTask):
    """مهمة تفعيل مهارات الأمير الـ 16 النشطة وفق تفضيلات المستخدم المحفوظة في الإعدادات."""
    name = "skills"
    alias = "lord_skills"

    async def can_run(self) -> tuple[bool, str]:
        """فحص الشروط المسبقة لتشغيل مهارات الأمير."""
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        target_skills = self.config.get("target_skills", [])
        if not target_skills or not isinstance(target_skills, list):
            return False, "لم يتم اختيار أي مهارة للتفعيل في الإعدادات"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة فحص وتفعيل مهارات الأمير المحددة:
        - فحص حالة كل مهارة محددة من الذاكرة الحية أولاً (0 استهلاك شبكي).
        - تفعيل المهارات الجاهزة فقط مع التبديل التلقائي للأطقم والرجوع الفوري.
        """
        target_skills: List[Any] = self.config.get("target_skills", [])
        if not target_skills:
            return TaskResult.skip("لم يتم تحديد مهارات لتفعيلها")

        self.log(f"👑 بدء دورة فحص مهارات الأمير المحددة ({len(target_skills)} مهارة)...")

        activated_skills: List[str] = []
        skipped_skills: List[str] = []
        failed_skills: List[str] = []

        for skill_entry in target_skills:
            resolved_id = self.resolve_lord_skill_id(skill_entry)
            if not resolved_id or resolved_id not in LORD_ACTIVE_SKILLS_CATALOG:
                self.log(f"⚠️ تجاهل معرف مهارة غير صالح أو غير معروف: {skill_entry}")
                continue

            meta = LORD_ACTIVE_SKILLS_CATALOG[resolved_id]
            skill_name = meta.get("name_ar", str(resolved_id))

            # فحص حالة المهارة من الذاكرة الحية (0-Network)
            status = self.get_lord_skill_status(resolved_id)

            if not status.get("is_learned"):
                self.log(f"ℹ️ المهارة [{skill_name}] غير متعلمة في أي طقم مواهب، تم التخطي.")
                skipped_skills.append(f"{skill_name} (غير متعلمة)")
                continue

            if status.get("in_cooldown"):
                cd_rem = status.get("cd_remaining_seconds", 0)
                cd_min = round(cd_rem / 60, 1)
                self.log(f"⏳ المهارة [{skill_name}] في فترة تبريد (متبقي {cd_min} دقيقة)، تم التخطي.")
                skipped_skills.append(f"{skill_name} (تبريد {cd_min}د)")
                continue

            if status.get("is_buff_active") or status.get("is_active"):
                buff_rem = status.get("buff_remaining_seconds", 0)
                buff_min = round(buff_rem / 60, 1)
                is_untimed = status.get("is_untimed_buff", False)
                if is_untimed or buff_rem == 0:
                    status_desc = "تأثير مستمر حتى المعركة القادمة"
                    skipped_label = "سارية (دائمة حتى المعركة)"
                else:
                    status_desc = f"متبقي {buff_min} دقيقة"
                    skipped_label = f"سارية {buff_min}د"
                self.log(f"🛡️ المهارة [{skill_name}] مفعّلة وتأثيرها سارٍ ({status_desc})، تم التخطي.")
                skipped_skills.append(f"{skill_name} ({skipped_label})")
                continue

            # فحص التعارض التبادلي بين مهارتي السم القاتل (11056) والإكسير الفتاك (11057)
            # تفعيل إحداهما يلغي تأثير الأخرى فوراً في محرك اللعبة
            if resolved_id == 11056:
                other_st = self.get_lord_skill_status(11057)
                if other_st.get("is_buff_active") or other_st.get("is_active"):
                    self.log(f"ℹ️ تم تخطي تفعيل [{skill_name}] لوجود باف متعارض قيد السريان [الإكسير الفتاك].")
                    skipped_skills.append(f"{skill_name} (تعارض مع الإكسير)")
                    continue
            elif resolved_id == 11057:
                other_st = self.get_lord_skill_status(11056)
                if other_st.get("is_buff_active") or other_st.get("is_active"):
                    self.log(f"ℹ️ تم تخطي تفعيل [{skill_name}] لوجود باف متعارض قيد السريان [السم القاتل].")
                    skipped_skills.append(f"{skill_name} (تعارض مع السم)")
                    continue

            # التحقق من إمكانية التفعيل الفوري أو عبر التبديل
            can_activate = status.get("can_activate", False)
            can_switch = status.get("can_switch_to_set", False)

            if not can_activate and not can_switch:
                self.log(f"⚠️ المهارة [{skill_name}] غير جاهزة للتفعيل في الطقم الحالي ولا يمكن التبديل لطقمها.")
                skipped_skills.append(f"{skill_name} (غير جاهزة)")
                continue

            # تفعيل المهارة بأمان مع دعم التبديل التلقائي والرجوع
            self.log(f"⚡ تفعيل المهارة النشطة [{skill_name}]...")
            ok, msg = await self.use_lord_skill(resolved_id, auto_revert=True)

            if ok:
                self.log(f"✅ تم تفعيل المهارة [{skill_name}] بنجاح: {msg}")
                activated_skills.append(skill_name)
                # فاصل زمني أمان بشري قبل فحص وتفعيل المهارة التالية
                await asyncio.sleep(random.uniform(1.0, 1.8))
            else:
                self.log(f"❌ تعذر تفعيل المهارة [{skill_name}]: {msg}")
                failed_skills.append(f"{skill_name} ({msg})")

        total_processed = len(activated_skills) + len(skipped_skills) + len(failed_skills)
        summary_msg = f"مهارات الأمير: تم تفعيل ({len(activated_skills)})، تخطي ({len(skipped_skills)})، تعذر ({len(failed_skills)})"
        self.log(f"🏁 اكتمال دورة مهارات الأمير: {summary_msg}")

        return TaskResult.ok(
            msg=summary_msg,
            data={
                "activated": activated_skills,
                "skipped": skipped_skills,
                "failed": failed_skills,
                "total_checked": total_processed,
            },
        )
