# -*- coding: utf-8 -*-
"""
test_task_method.py — أداة اختبار دوال المهام الفردية والمتعددة ميدانياً
══════════════════════════════════════════════════════════════════════════════════════

تتيح هذه الأداة تشغيل دالة أو أكثر داخل أي مهمة على حساب معين مباشرة،
سواء بالاتصال الحي الحقيقي بالبوابة أو عبر تفريغ الذاكرة الحية (Offline).

أمثلة على الاستخدام من سطر الأوامر:
  1. اختبار دالة واحدة في مهمة التحالف لحساب LUCIFER:
     python test_task_method.py --email LUCIFER@g4.com --task alliance _help_alliance_members

  2. اختبار عدة دوال دفعة واحدة:
     python test_task_method.py --email LUCIFER@g4.com --task alliance _treasure_alliance

     python test_task_method.py --email beetoo1@hotmail.com --task alliance _treasure_alliance

     python test_task_method.py --email LUCIFER@g4.com --task alliance _treasure_alliance

  3. الاستخدام المختصر:
     python test_task_method.py alliance _treasure_alliance

  4. اختبار دوال الذاكرة الحية فورياً دون اتصال شبكي (Offline Mode):
     python test_task_method.py --offline --task alliance _get_alliance_id _find_recommended_science

  5. عرض كافة الدوال المتاحة في المهمة:
     python test_task_method.py --task alliance
"""

from __future__ import annotations

import argparse
import asyncio
import inspect
import json
import os
import sqlite3
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

# استيراد المهام الأساسية
import tasks
from tasks.base_task import BaseTask, TaskResult


# ════════════════════════════════════════════════════════════════════
#  قاموس المهام المسجلة
# ════════════════════════════════════════════════════════════════════

def get_registered_tasks() -> Dict[str, type]:
    """استخراج كافة فئات المهام المتاحة في مشروع البوت"""
    task_map = {}
    for attr in dir(tasks):
        cls = getattr(tasks, attr)
        if isinstance(cls, type) and issubclass(cls, BaseTask) and cls is not BaseTask:
            # ربط باسم المهمة البرمجي (مثل: alliance) واسم الفئة (مثل: AllianceTask)
            task_name = getattr(cls, "name", "").lower()
            if task_name:
                task_map[task_name] = cls
            task_map[attr.lower()] = cls
    return task_map


def get_default_email() -> str:
    """استرجاع أول بريد حساب نشط من قاعدة البيانات كافتراضي"""
    try:
        db_path = os.path.join(os.path.dirname(__file__), "database", "castles.db")
        if os.path.exists(db_path):
            conn = sqlite3.connect(db_path)
            cur = conn.cursor()
            cur.execute("SELECT email FROM castle_states WHERE is_active = 1 LIMIT 1")
            row = cur.fetchone()
            conn.close()
            if row and row[0]:
                return row[0]
    except Exception:
        pass
    return "LUCIFER@g4.com"


# ════════════════════════════════════════════════════════════════════
#  محاكي الاتصال المحلي (Offline Mock Connection)
# ════════════════════════════════════════════════════════════════════

class OfflineMockConnection:
    """محاكي اتصال يعتمد على ملف الذاكرة الحية المحلي للاختبار السريع (0-Network)"""
    def __init__(self, init_data: Dict[str, Any], email: str = "offline@bot.com"):
        self.init_data = init_data
        self.email = email
        uid = str(init_data.get("lord", {}).get("uid") or "31596828")
        kid = int(init_data.get("lord", {}).get("kid") or 614)
        self.creds = type("MockCreds", (), {"uid": uid, "kingdom_id": kid, "server_name": "OfflineServer"})()

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        return self.init_data.get(name, {})

    async def safe_query(self, cmd: str, subcmd: str, data: Optional[Dict[str, Any]] = None, **kwargs) -> Dict[str, Any]:
        print(f"      📡 [Offline Mock Query] إرسال محاكى: CMD={cmd}, SubCMD={subcmd}, Data={data}")
        return {"err": 0, "data": {}}

    async def close(self):
        pass


# ════════════════════════════════════════════════════════════════════
#  تنفيذ الاختبار
# ════════════════════════════════════════════════════════════════════

async def run_method_tests(
    task_name_or_cls: str,
    method_names: List[str],
    email: Optional[str] = None,
    offline: bool = False,
    memory_file: str = "docs/lucifer_live_memory.json",
):
    print("\n" + "═" * 78)
    print(f" 🧪 أداة فحص واختبار دوال مهام البوت (Task Method Test Runner)")
    print("═" * 78)

    # 1. مطابقة فئة المهمة
    task_registry = get_registered_tasks()
    key = task_name_or_cls.strip().lower()
    task_cls = task_registry.get(key)

    if not task_cls:
        # محاولة البحث عن جزء من الاسم
        for k, v in task_registry.items():
            if key in k:
                task_cls = v
                break

    if not task_cls:
        print(f"❌ لم يتم العثور على مهمة باسم: '{task_name_or_cls}'")
        print(f"   المهام المتاحة: {', '.join(sorted(set(k for k in task_registry.keys() if not k.endswith('task'))))}")
        return

    print(f"📌 المهمة المستهدفة: {task_cls.__name__} (مفتاح: '{getattr(task_cls, 'name', 'unknown')}')")

    # 2. إعداد الاتصال والذاكرة الحية (Live أو Offline)
    conn = None
    bot = None
    target_email = email or get_default_email()

    if offline:
        print(f"⚡ نمط الفحص المحلي (Offline Mode): جلب الذاكرة من {memory_file}...")
        if not os.path.exists(memory_file):
            # محاولة ملفات بديلة
            for alt in ["docs/sample_live_memory.json", "scratch/init_LUCIFER.json"]:
                if os.path.exists(alt):
                    memory_file = alt
                    break

        if not os.path.exists(memory_file):
            print(f"❌ تعذر العثور على ملف ذاكرة حية محلي ({memory_file})!")
            return

        with open(memory_file, "r", encoding="utf-8") as f:
            live_data = json.load(f)

        conn = OfflineMockConnection(live_data, email=target_email)
        print(f"✓ تم تحميل الذاكرة الحية المحلية بنجاح ({len(live_data)} متحكم).")
    else:
        print(f"🌐 الاتصال الحي بالحساب: {target_email}...")
        from bot_manager import CastleBot
        import core.database as db

        bot = CastleBot(email=target_email, log_callback=lambda m: None)
        c_data = db.get_castle_by_id(target_email)
        if c_data and c_data.get("password"):
            bot.password = c_data["password"]

        ok = await bot.connect()
        if not ok or not bot.conn:
            print(f"❌ فشل الاتصال بالبوابة لحساب: {target_email}")
            return

        conn = bot.conn
        print(f"✓ متصل بالبوابة بنجاح! UID={getattr(bot.creds, 'uid', 'N/A')} | المملكة={getattr(bot.creds, 'kingdom_id', 'N/A')}")
        print(f"✓ تم تفريغ وتجهيز {len(conn.init_data)} متحكم حي في الذاكرة.")

    # 3. إنشاء كائن المهمة
    task_logs: List[str] = []

    def task_logger(msg: str):
        task_logs.append(msg)

    # تكوين افتراضي مفعل للمهمة
    cfg = {"enabled": True}
    if bot and bot.config:
        t_name = getattr(task_cls, "name", "alliance")
        cfg = bot.config.get("tasks", {}).get(t_name) or bot.config.get(t_name) or {"enabled": True}

    task_instance = task_cls(conn, task_logger, cfg)

    # إذا لم يُحدد أي اسم دالة، نعرض الدوال المتوفرة في الكلاس للمطور
    if not method_names:
        print("\n📋 الدوال العامة المتاحة للاختبار في هذه المهمة:")
        methods = [
            m for m in dir(task_instance)
            if not m.startswith("__") and callable(getattr(task_instance, m))
        ]
        for m in sorted(methods):
            is_async = asyncio.iscoroutinefunction(getattr(task_instance, m))
            prefix = "async def" if is_async else "def"
            doc = (getattr(task_instance, m).__doc__ or "").strip().split("\n")[0]
            print(f"   • {prefix} {m}() - {doc}")
        print("\n💡 للاختبار، مرر اسم الدالة بعد اسم المهمة، مثال:")
        print(f"   python test_task_method.py --task {task_name_or_cls} {methods[0] if methods else 'run'}\n")
        if bot and bot.conn:
            await bot.conn.close()
        return

    # 4. تشغيل وفحص كل دالة مطلوبة
    print("\n" + "─" * 78)
    print(f" 🎯 بدء تشغيل واختبار الدوال المحددة ({len(method_names)} دالة)")
    print("─" * 78)

    for idx, func_name in enumerate(method_names, 1):
        print(f"\n▶ [{idx}/{len(method_names)}] اختبار الدالة: `{func_name}`")
        if not hasattr(task_instance, func_name):
            print(f"   ❌ خطأ: الدالة `{func_name}` غير موجودة في فئة `{task_cls.__name__}`!")
            continue

        method = getattr(task_instance, func_name)
        if not callable(method):
            print(f"   ⚠️ تنبيه: `{func_name}` هي خاصية (Property/Variable) وليست دالة قابلة للاستدعاء!")
            print(f"   القيمة الحالية: {repr(method)}")
            continue

        is_async = asyncio.iscoroutinefunction(method)
        task_logs.clear()
        t_start = time.perf_counter()
        exception_occured = False
        result = None

        try:
            if is_async:
                result = await method()
            else:
                result = method()
        except Exception as e:
            exception_occured = True
            t_exec = (time.perf_counter() - t_start) * 1000
            print(f"   💥 حدث خطأ برمجى أثناء التنفيذ (في {t_exec:.2f} ms):")
            import traceback
            traceback.print_exc()
            continue

        t_exec = (time.perf_counter() - t_start) * 1000

        # عرض السجلات التي طبعتها الدالة
        if task_logs:
            print("   📝 سجلات الدالة أثناء التشغيل (Logs):")
            for log_msg in task_logs:
                print(f"      {log_msg}")

        # عرض الناتج المرتجع
        print(f"   ⏱️ وقت التنفيذ: {t_exec:.2f} ms | نمط الاستدعاء: {'غير متزامن (async)' if is_async else 'متزامن (sync)'}")
        print(f"   📦 القيمة المرجعة (Return Value) [نوع: {type(result).__name__}]:")

        if isinstance(result, TaskResult):
            status_symbol = "✅ نجاح" if result.success and not result.skipped else ("⏭️ تخطي" if result.skipped else "❌ فشل")
            print(f"      • حالة النتيجة: {status_symbol}")
            print(f"      • الرسالة: {result.message}")
            if result.data:
                print(f"      • البيانات المرفقة: {json.dumps(result.data, ensure_ascii=False, indent=8)}")
        elif isinstance(result, (dict, list)):
            print("      " + json.dumps(result, ensure_ascii=False, indent=6).replace("\n", "\n      "))
        elif isinstance(result, tuple):
            print(f"      {repr(result)}")
        else:
            print(f"      {repr(result)}")

    # 5. إغلاق الاتصال بأمان
    if bot and bot.conn:
        print("\n" + "─" * 78)
        print("🔒 جاري إغلاق اتصال البوابة بأمان...")
        try:
            await bot.conn.close()
            print("✓ تم إغلاق الاتصال بأمان.")
        except Exception:
            pass

    print("═" * 78 + "\n")


# ════════════════════════════════════════════════════════════════════
#  نقطة الدخول الرئيسية (CLI Parser)
# ════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="أداة فحص واختبار دوال المهام الفردية والمتعددة في مشروع البوت",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "positional_args",
        nargs="*",
        help="يمكن تمرير: [اسم_المهمة] [اسم_الدالة_1] [اسم_الدالة_2] ...",
    )
    parser.add_argument(
        "-t", "--task",
        dest="task",
        help="اسم المهمة المستهدفة (مثال: alliance, port, flower)",
    )
    parser.add_argument(
        "-e", "--email",
        dest="email",
        help="بريد الحساب المراد الاتصال به وتشغيل الفحص عليه (افتراضي: أول حساب نشط)",
    )
    parser.add_argument(
        "-o", "--offline",
        dest="offline",
        action="store_true",
        help="وضع الفحص المحلي دون أي اتصال شبكي (يستخدم ملف الذاكرة docs/lucifer_live_memory.json)",
    )
    parser.add_argument(
        "-m", "--memory-file",
        dest="memory_file",
        default="docs/lucifer_live_memory.json",
        help="مسار ملف الذاكرة الحية لنمط الـ offline",
    )

    args = parser.parse_args()

    # معالجة الوسائط المرنة
    pos_args = list(args.positional_args)
    task_name = args.task
    methods = []

    if not task_name:
        if pos_args:
            task_name = pos_args.pop(0)
        else:
            # مهمة افتراضية alliance
            task_name = "alliance"

    methods.extend(pos_args)

    asyncio.run(
        run_method_tests(
            task_name_or_cls=task_name,
            method_names=methods,
            email=args.email,
            offline=args.offline,
            memory_file=args.memory_file,
        )
    )


if __name__ == "__main__":
    main()

