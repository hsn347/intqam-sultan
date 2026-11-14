# -*- coding: utf-8 -*-
"""
tasks/shield.py — مهمة درع السلام التلقائي (Peace Shield Task) للعبة انتقام السلاطين
══════════════════════════════════════════════════════════════════════════════════════

أنواع الدروع المعتمدة في محرك اللعبة:
  1. 🛡️ درع 8 ساعات:
     - في الحقيبة (مجاني): 300701
     - في المتجر بالذهب: 1000024 (500 ذهب)
  2. 🛡️ درع 24 ساعة (يوم كامل):
     - في الحقيبة (مجاني): 300702
     - في المتجر بالذهب: 1000025 (1000 ذهب)
  3. 🛡️ درع 3 أيام:
     - في الحقيبة (مجاني): 300703
     - في المتجر بالذهب: 1000026 (2500 ذهب)

المزايا المعمارية (Revenge of Sultans Architecture):
  - 0-Network Direct Read: فحص مباشر لحالة الأمان kingdomMapCtrl.isSafe ومخزون الحقيبة backpackCtrl في RAM.
  - مهمة اختيارية (User-Configurable): لا تعمل إلا بعد تفعيلها صراحة من قبل المستخدم في الإعدادات.
  - خيار الشراء بالذهب: اختياري بالكامل بحسب رغبة المستخدم (allow_gold).
  - منع الإهدار: فحص دقيق لمنع إعادة تفعيل الدرع في حال كانت القلعة محمية بالفعل.
"""

from __future__ import annotations

import asyncio
import json
import logging
import os
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

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
from core.game_client import GameConnection

# ════════════════════════════════════════════════════════════════════
#  قاموس الدروع وتهيئتها الرسمية
# ════════════════════════════════════════════════════════════════════

SHIELD_TYPES: Dict[str, Dict[str, Any]] = {
    "8h": {
        "name": "🛡️ درع السلام (8 ساعات)",
        "duration_key": "8h",
        "hours": 8,
        "seconds": 8 * 3600,
        "bag_item_id": 300701,
        "shop_item_id": 1000024,
        "gold_price": 500,
    },
    "24h": {
        "name": "🛡️ درع السلام (24 ساعة / يوم)",
        "duration_key": "24h",
        "hours": 24,
        "seconds": 24 * 3600,
        "bag_item_id": 300702,
        "shop_item_id": 1000025,
        "gold_price": 1000,
    },
    "3d": {
        "name": "🛡️ درع السلام (3 أيام / 72 ساعة)",
        "duration_key": "3d",
        "hours": 72,
        "seconds": 72 * 3600,
        "bag_item_id": 300703,
        "shop_item_id": 1000026,
        "gold_price": 2500,
    },
}

# تطبيع المدخلات المختلفة
DURATION_ALIASES = {
    "8": "8h", "8h": "8h", "8hour": "8h", "8hours": "8h",
    "24": "24h", "24h": "24h", "1d": "24h", "1day": "24h", "day": "24h",
    "72": "3d", "3d": "3d", "3day": "3d", "3days": "3d", "3": "3d",
}


# ════════════════════════════════════════════════════════════════════
#  كلاس المهمة (ShieldTask)
# ════════════════════════════════════════════════════════════════════

class ShieldTask(BaseTask):
    """
    مهمة تفعيل وتجديد درع السلام التلقائي لحماية القلعة من الاستطلاع والهجوم.
    """
    name = "shield"
    alias = "peaceshield"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)
        self.shield_cfg = self._extract_shield_config()

    def _extract_shield_config(self) -> Dict[str, Any]:
        """استخراج كائن الإعدادات الخاص بمهمة الدرع بدقة."""
        if not isinstance(self.config, dict):
            return {}
        if "shield" in self.config and isinstance(self.config["shield"], dict):
            return self.config["shield"]
        if "tasks" in self.config and isinstance(self.config["tasks"], dict) and "shield" in self.config["tasks"]:
            return self.config["tasks"]["shield"]
        return self.config

    def _record_shield_activation(self, shield_info: Dict[str, Any]):
        """تسجيل تفعيل الدرع بنجاح في كائن الاتصال والذاكرة الحية لتفادي إعادة التفعيل وتحديث مؤقت الحماية."""
        now = time.time()
        self.conn.shield_expire_ts = now + shield_info["seconds"]
        if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
            km = self.conn.init_data.setdefault("kingdomMapCtrl", {})
            if isinstance(km, dict):
                km["isSafe"] = True

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي استباقي بصفر طلبات شبكية."""
        cfg = self.shield_cfg
        if not cfg.get("enabled", False):
            return False, "المهمة معطلة في الإعدادات وفق رغبة المستخدم"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        raw_dur = str(cfg.get("duration", "8h")).lower().strip()
        dur_key = DURATION_ALIASES.get(raw_dur, "8h")
        shield_info = SHIELD_TYPES.get(dur_key, SHIELD_TYPES["8h"])

        # فحص مباشر في الذاكرة الحية: هل القلعة محمية بالفعل؟
        is_active = self.is_shielded
        if is_active:
            return False, f"القلعة محمية بالفعل"

        return True, ""

    async def run(self) -> TaskResult:
        cfg = self.shield_cfg
        raw_dur = str(cfg.get("duration", "8h")).lower().strip()
        dur_key = DURATION_ALIASES.get(raw_dur, "8h")
        shield_info = SHIELD_TYPES.get(dur_key, SHIELD_TYPES["8h"])
        allow_gold = bool(cfg.get("allow_gold", False))

        self.log(f"🛡️ بدء مهمة الدرع التلقائي [{shield_info['name']}] (الشراء بالذهب: {allow_gold})")

        # 0. التحقق الاستباقي: هل القلعة محمية بالفعل بدرع سلام نشط؟
        is_active = self.is_shielded
        if is_active:
            self.log(f"🛡️  — تم تخطي المهمة بنجاح لتوفير الدروع وعدم إهدارها.")
            return TaskResult.ok(
                f"🛡️ القلعة محمية بالفعل بدرع سلام نشط",
                data={"shield_active": True}
            )

        target_item_id = shield_info["bag_item_id"]

        # 1. فحص مخزون الحقيبة من الذاكرة الحية أولاً (0-Network Direct Read)
        bag_count = 0
        backpack_ctrl = self.get_ctrl("backpackCtrl")
        if isinstance(backpack_ctrl, dict) and str(target_item_id) in backpack_ctrl:
            item_entry = backpack_ctrl[str(target_item_id)]
            if isinstance(item_entry, dict):
                bag_count = int(item_entry.get("count", 0))

        # إذا لم تكن الحقيبة في الذاكرة الحية، نقوم باستعلامها من البوابة
        if bag_count == 0 and not backpack_ctrl:
            r_bag = await self.safe_query("1004", "1", {}, min_delay=0.2, max_delay=0.4)
            if r_bag and isinstance(r_bag, dict):
                items = r_bag.get("data", {}).get("itemList", r_bag.get("data", {}))
                if isinstance(items, dict):
                    for k, v in items.items():
                        if isinstance(v, dict):
                            iid = int(v.get("id", v.get("itemID", k)))
                            if iid == target_item_id:
                                bag_count = int(v.get("count", v.get("num", 0)))
                                break
                elif isinstance(items, list):
                    for v in items:
                        if isinstance(v, dict):
                            iid = int(v.get("id", v.get("itemID", 0)))
                            if iid == target_item_id:
                                bag_count = int(v.get("count", v.get("num", 0)))
                                break

        self.log(f"🎒 المخزون المتوفر في الحقيبة من {shield_info['name']}: {bag_count} درع")

        # 2. تفعيل الدرع من الحقيبة (مجاناً) إذا كان متوفراً
        if bag_count > 0:
            self.log(f"🚀 جاري استخدام 1 من {shield_info['name']} من الحقيبة مجاناً...")
            payload = {
                "itemID": target_item_id,
                "count": 1,
            }

            r_use = await self.safe_query("1004", "2", payload, min_delay=0.3, max_delay=0.6)
            err_code = str(r_use.get("err", "0")) if isinstance(r_use, dict) else "0"

            if err_code in ("0", "Err_None", "None") or not r_use:
                # تسجيل الدرع وتحديث مؤشر الحماية في الجلسة والذاكرة
                self._record_shield_activation(shield_info)

                # خصم الدرع من الذاكرة الحية للحقيبة
                if isinstance(backpack_ctrl, dict) and str(target_item_id) in backpack_ctrl:
                    curr_c = int(backpack_ctrl[str(target_item_id)].get("count", 1))
                    if curr_c > 1:
                        backpack_ctrl[str(target_item_id)]["count"] = curr_c - 1
                    else:
                        backpack_ctrl.pop(str(target_item_id), None)

                success_msg = f"تم تفعيل {shield_info['name']} بنجاح من الحقيبة مجاناً"
                self.log(f"✅ {success_msg} 🎉")
                return TaskResult.ok(
                    success_msg,
                    data={
                        "status": "activated_free",
                        "duration": shield_info["duration_key"],
                        "method": "backpack",
                    }
                )
            else:
                self.log(f"⚠️ فشل استخدام الدرع من الحقيبة (كود الخطأ: {err_code})")

        # 3. شراء وتفعيل الدرع بالذهب من المتجر (1034/2) إذا كان الشراء مسموحاً
        if allow_gold:
            gold_price = shield_info["gold_price"]
            curr_gold = self.gold

            if curr_gold < gold_price:
                fail_msg = f"رصيد الذهب غير كافٍ لشراء {shield_info['name']} (المتوفر: {curr_gold}، المطلوب: {gold_price})"
                self.log(f"⚠️ {fail_msg}")
                return TaskResult.fail(fail_msg)

            self.log(f"🪙 الدرع المجاني غير متوفر. جاري شراء وتفعيل {shield_info['name']} بالذهب ({gold_price} ذهب)...")
            payload = {
                "shopItemID": shield_info["shop_item_id"],
                "num": 1,
                "use": True,
            }

            r_buy = await self.safe_query("1034", "2", payload, min_delay=0.4, max_delay=0.8)
            err_code = str(r_buy.get("err", "0")) if isinstance(r_buy, dict) else "0"

            if err_code in ("0", "Err_None", "None") or not r_buy:
                # تسجيل الدرع وتحديث مؤشر الحماية في الجلسة والذاكرة
                self._record_shield_activation(shield_info)

                # خصم الذهب من الذاكرة الحية
                lord_base = self.get_ctrl("lordInfoCtrl").get("base", {})
                if isinstance(lord_base, dict) and "gold" in lord_base:
                    lord_base["gold"] = max(0, int(lord_base["gold"]) - gold_price)

                success_msg = f"تم شراء وتفعيل {shield_info['name']} بنجاح بالذهب ({gold_price} ذهب)"
                self.log(f"✅ {success_msg} 🎉")
                return TaskResult.ok(
                    success_msg,
                    data={
                        "status": "activated_gold",
                        "duration": shield_info["duration_key"],
                        "gold_spent": gold_price,
                        "method": "gold_shop",
                    }
                )
            else:
                fail_msg = f"فشل شراء الدرع من المتجر بالذهب (كود: {err_code})"
                self.log(f"⚠️ {fail_msg}")
                return TaskResult.fail(fail_msg)
        else:
            fail_msg = f"لا يوجد {shield_info['name']} مجاني في الحقيبة والشراء بالذهب معطل وفق الإعدادات"
            self.log(f"⚠️ {fail_msg}")
            return TaskResult.fail(fail_msg)


# ════════════════════════════════════════════════════════════════════
#  التشغيل المباشر كملف مستقل (CLI Standalone Execution)
# ════════════════════════════════════════════════════════════════════
