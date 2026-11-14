# -*- coding: utf-8 -*-
"""
test_ensure_resources.py — أداة تجربة واختبار دالة توفير الموارد (ensure_resources)
═══════════════════════════════════════════════════════════════════════════════════════
تتيح للمطور تجربة دالة توفير الموارد بمفردها وتمرير أي مورد وكمية يرغب بها:
  - وضع محاكي محلي سريع (Offline): يقرأ من ذاكرة Lucifer أو ينشئ حالة حقيبة افتراضية.
  - وضع الاتصال الحي (Live): يتصل بحساب قلعة حقيقي عبر البوابة ويفحص ويفتح الصناديق فعلياً.

أمثلة الاستخدام من سطر الأوامر:
  1. اختبار سريع محلي بدون إنترنت:
     python test_ensure_resources.py --email beetoo2@hotmail.com --resource بلور --amount 1000000

  2. تمرير المورد بالعربية:
     python test_ensure_resources.py --email LUCIFER@g4.coom --resource قمح --amount 500000

  3. تخصيص المضاعف (افتراضياً 3 أضعاف):
     python test_ensure_resources.py --resource حديد --amount 100000 --multiplier 2

  4. اختبار حي على حساب قلعة حقيقي:
     python test_ensure_resources.py --email LUCIFER@g4.coom --resource بلور --amount 100000

  5. تشغيل تفاعلي (يسألك عن المورد والكمية في التيرمنال):
     python test_ensure_resources.py
"""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys
from typing import Any, Dict, Optional

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# إضافة مسار المشروع للاستيراد
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from tasks.base_task import BaseTask, TaskResult, RESOURCE_CATALOG, RESOURCE_KEY_MAP


# ════════════════════════════════════════════════════════════════════
# مهمة اختبار خفيفة ترث BaseTask للوصول إلى ensure_resources
# ════════════════════════════════════════════════════════════════════

class ResourceTesterTask(BaseTask):
    name = "resource_tester"

    async def run(self) -> TaskResult:
        return TaskResult.ok("ResourceTesterTask ready")


# ════════════════════════════════════════════════════════════════════
# محاكي اتصال محلي للاختبار (Offline Mock Connection)
# ════════════════════════════════════════════════════════════════════

class OfflineMockConnection:
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = init_data
        self.is_connected = True
        self.queries = []
        uid = str(init_data.get("lord", {}).get("uid") or "31596828")
        kid = int(init_data.get("lord", {}).get("kid") or 614)
        self.creds = type("MockCreds", (), {"uid": uid, "kingdom_id": kid, "server_name": "OfflineServer"})()

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        return self.init_data.get(name, {})

    async def query(self, cmd: str, subcmd: str, data: Optional[Dict[str, Any]] = None, **kwargs) -> Dict[str, Any]:
        self.queries.append((cmd, subcmd, data))
        print(f"      📡 [Offline Query Sent] CMD={cmd}, SubCMD={subcmd}, Payload={data}")
        return {"err": 0, "cmd": cmd, "subcmd": subcmd, "data": data}

    async def close(self):
        pass


# ════════════════════════════════════════════════════════════════════
# تشغيل الاختبار
# ════════════════════════════════════════════════════════════════════

async def main():
    parser = argparse.ArgumentParser(description="أداة تجربة دالة توفير الموارد ensure_resources")
    parser.add_argument("--resource", "-r", type=str, help="اسم المورد (wood, food, iron, silver, crystal أو خشب، قمح، حديد، فضة، بلور)")
    parser.add_argument("--amount", "-a", type=int, help="الكمية المطلوبة (مثال: 1000000)")
    parser.add_argument("--multiplier", "-m", type=int, default=3, help="مضاعف الكمية المستهدفة (الافتراضي: 3)")
    parser.add_argument("--email", "-e", type=str, default=None, help="البريد الإلكتروني للقلعة (للاتصال الحي باللعبة)")
    parser.add_argument("--offline", action="store_true", help="إجبار التشغيل في الوضع المحلي الأوفلاين")

    args = parser.parse_args()

    resource_input = args.resource
    amount_input = args.amount
    multiplier = args.multiplier

    # إذا لم يمرر المطور المورد أو الكمية، نطلبهم تفاعلياً
    if not resource_input or not amount_input:
        print("\n" + "═" * 70)
        print(" 🧪 أداة تجربة واختبار دالة توفير الموارد (ensure_resources)")
        print("═" * 70)
        print(" الموارد المتاحة:")
        print("   1. خشب   (wood)")
        print("   2. قمح   (food)")
        print("   3. حديد  (iron)")
        print("   4. فضة   (silver)")
        print("   5. بلور  (crystal)")
        print("─" * 70)

        if not resource_input:
            prompt_res = input("👉 اختر المورد (اكتب اسمه أو رقمه 1-5) [افتراضي: خشب]: ").strip()
            num_map = {"1": "wood", "2": "food", "3": "iron", "4": "silver", "5": "crystal"}
            resource_input = num_map.get(prompt_res, prompt_res or "wood")

        if not amount_input:
            prompt_amt = input("👉 أدخل الكمية المطلوبة [افتراضي: 1000000]: ").strip()
            try:
                amount_input = int(prompt_amt) if prompt_amt else 1_000_000
            except ValueError:
                amount_input = 1_000_000

        prompt_m = input(f"👉 المضاعف المستهدف [افتراضي: {multiplier}]: ").strip()
        if prompt_m:
            try:
                multiplier = int(prompt_m)
            except ValueError:
                pass

    print("\n" + "═" * 70)
    print(f" 🎯 إعدادات الفحص:")
    print(f"   • المورد المطلوب: {resource_input}")
    print(f"   • الكمية الأساسية: {amount_input:,}")
    print(f"   • المضاعف: {multiplier}x  (الرصيد المستهدف المطلوب توفيره: {amount_input * multiplier:,})")
    print("═" * 70)

    # تجهيز الاتصال
    bot = None
    conn = None

    if args.email and not args.offline:
        print(f"\n🌐 جارٍ الاتصال الحي بقلعة: {args.email} عبر البوابة...")
        from bot_manager import CastleBot
        import core.database as db

        bot = CastleBot(email=args.email, log_callback=lambda m: None)
        c_data = db.get_castle_by_id(args.email)
        if c_data and c_data.get("password"):
            bot.password = c_data["password"]

        ok = await bot.connect()
        if not ok or not bot.conn:
            print(f"❌ تعذر الاتصال بقلعة {args.email}!")
            return

        conn = bot.conn
        print(f"✓ تم الاتصال بنجاح بالقلعة! UID={getattr(bot.creds, 'uid', 'N/A')}")
    else:
        print("\n💻 تشغيل في الوضع المحلي الأوفلاين (0-Network Mock)...")
        memory_file = "docs/lucifer_live_memory.json"
        if os.path.exists(memory_file):
            with open(memory_file, "r", encoding="utf-8") as f:
                live_data = json.load(f)
            print(f"✓ تم تحميل بيانات الذاكرة الحية من: {memory_file}")
        else:
            print("ℹ️ تم إنشاء ذاكرة حية نموذجية مع حقيبة موارد افتراضية.")
            live_data = {
                "cityCtrl": {"resList": {"1002": "50000", "1003": "50000", "1004": "10000", "1005": "5000", "1006": "2000", "1027": "1000"}},
                "backpackCtrl": {
                    "100206": {"count": 10}, "100205": {"count": 20},
                    "100306": {"count": 10}, "100305": {"count": 20},
                    "100506": {"count": 10}, "100505": {"count": 20},
                    "100606": {"count": 10}, "100605": {"count": 20},
                    "102704": {"count": 10}, "110607": {"count": 5},
                }
            }
        conn = OfflineMockConnection(live_data)

    # عرض أرصدة القلعة الحالية قبل البدء
    city = conn.init_data.get("cityCtrl", {}) if isinstance(conn.init_data, dict) else {}
    res_raw = city.get("resList", {}) or city.get("reslist", {}) if isinstance(city, dict) else {}
    print("\n📊 أرصدة القلعة الحالية في الذاكرة الحية:")
    print(f"   🌾 القمح:   {int(float(res_raw.get('1002', 0))):,}")
    print(f"   🪵 الخشب:   {int(float(res_raw.get('1003', 0))):,}")
    print(f"   ⛓️ الحديد:  {int(float(res_raw.get('1004', 0))):,}")
    print(f"   🪙 الفضة:   {int(float(res_raw.get('1005', 0))):,}")
    print(f"   ⚔️ الفولاذ: {int(float(res_raw.get('1006', 0))):,}")
    print(f"   💎 البلور:  {int(float(res_raw.get('1027', 0))):,}")
    # إنشاء كائن المهمة وتشغيل ensure_resources
    task = ResourceTesterTask(conn=conn, log_func=print)

    print("\n🚀 تنفيذ دالة ensure_resources الآن:")
    print("─" * 70)
    result = await task.ensure_resources(
        {resource_input: amount_input},
        multiplier=multiplier,
    )
    print("─" * 70)

    print("\n📊 النتيجة النهائية المُرجعة من الدالة:")
    print(json.dumps(result, indent=2, ensure_ascii=False))

    if bot and bot.conn:
        await bot.conn.close()
        print("\n🔒 تم إغلاق الاتصال الحي بأمان.")


if __name__ == "__main__":
    asyncio.run(main())

