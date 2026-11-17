# -*- coding: utf-8 -*-
"""
test_task_method.py — أداة اختبار دوال المهام الفردية والمتعددة ميدانياً (نمط حي دائم)
══════════════════════════════════════════════════════════════════════════════════════

تتيح هذه الأداة تشغيل دالة أو أكثر داخل أي مهمة على حساب معين مباشرة بالاتصال الحي الحقيقي بالبوابة الرسمية (Live Mode).

أمثلة على الاستخدام من سطر الأوامر:
  1. اختبار دالة واحدة في مهمة قاعة القيادة لحساب beetoo3:
     python tools/test_task_method.py --email beetoo3@hotmail.com --task command_hall get_command_hall_tasks
                      
  2. اختبار عدة دوال دفعة واحدة:
     python tools/test_task_method.py --email beetoo1@hotmail.com --task alliance _treasure_alliance

  3. الاستخدام المختصر:
     python tools/test_task_method.py alliance _treasure_alliance

  4. عرض كافة الدوال المتاحة في المهمة:
     python tools/test_task_method.py --task alliance
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

# ضبط إخراج التيرمنال لـ UTF-8 على ويندوز
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

# تحديد مسارات المشروع بدقة
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
DOCS_DIR = os.path.join(WORKSPACE_DIR, "docs")
DB_PATH = os.path.join(WORKSPACE_DIR, "database", "castles.db")

if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

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
            # ربط باسم المهمة البرمجي (مثل: arena) واسم الفئة (مثل: ArenaTask)
            task_name = getattr(cls, "name", "").lower()
            if task_name:
                task_map[task_name] = cls
            task_map[attr.lower()] = cls
    return task_map


def get_default_email() -> str:
    """استرجاع أول بريد حساب نشط من قاعدة البيانات كافتراضي"""
    try:
        if os.path.exists(DB_PATH):
            conn = sqlite3.connect(DB_PATH)
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
#  تنفيذ الاختبار (نمط حي دائم)
# ════════════════════════════════════════════════════════════════════

async def run_method_tests(
    task_name_or_cls: str,
    method_names: List[str],
    email: Optional[str] = None,
    run_full_task: bool = False,
    task_mode: Optional[str] = None,
    allow_marches: Optional[bool] = None,
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

    # 2. إعداد الاتصال والذاكرة الحية (Live Mode)
    conn = None
    bot = None
    target_email = email or get_default_email()

    print(f"🌐 الاتصال الحي بالحساب: {target_email}...")
    from bot_manager import CastleBot
    import core.database as db

    bot = CastleBot(email=target_email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(target_email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True  # إلزامي لتمكين اتصال البوابة
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
        print(f"   [LOG] {msg}")

    # تكوين افتراضي مفعل للمهمة
    cfg = {"enabled": True}
    if bot and bot.config:
        t_name = getattr(task_cls, "name", "hero_trial")
        cfg = bot.config.get("tasks", {}).get(t_name) or bot.config.get(t_name) or {"enabled": True}
        cfg["enabled"] = True

    if task_mode:
        cfg["mode"] = task_mode
    if allow_marches is not None:
        cfg["allow_marches"] = allow_marches

    task_instance = task_cls(conn, task_logger, cfg)

    # إذا طُلب تشغيل المهمة كاملة عبر --run أو عبر تمرير run_full_task
    if run_full_task and not method_names:
        method_names = ["safe_execute"]

    # إذا لم يُحدد أي اسم دالة ولم يُطلب --run، نعرض الدوال المتوفرة في الكلاس
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
        print("\n💡 لتشغيل المهمة بالكامل (Full Task Run):")
        print(f"   python tools/test_task_method.py --task {task_name_or_cls} run")
        print(f"   أو:")
        print(f"   python tools/test_task_method.py --task {task_name_or_cls} safe_execute")
        print(f"   أو مباشرة:")
        print(f"   python tools/test_task_method.py {task_name_or_cls} --run\n")
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
        "-r", "--run",
        dest="run",
        action="store_true",
        help="تشغيل دورة المهمة الكاملة فوراً (safe_execute)",
    )
    parser.add_argument(
        "--mode",
        dest="mode",
        choices=["daily", "full"],
        help="نمط تشغيل المهمة: daily (النشاط اليومي) أو full (دورة كاملة)",
    )
    parser.add_argument(
        "--full",
        dest="full",
        action="store_true",
        help="اختصار لتشغيل دورة كاملة للمهمة (--mode full)",
    )
    parser.add_argument(
        "--allow-marches",
        dest="allow_marches",
        action="store_true",
        help="السماح بالمسيرات القتالية في دورة المهام الكاملة",
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
            # مهمة افتراضية hero_trial
            task_name = "hero_trial"

    methods.extend(pos_args)

    mode = "full" if args.full else args.mode
    asyncio.run(
        run_method_tests(
            task_name_or_cls=task_name,
            method_names=methods,
            email=args.email,
            run_full_task=args.run,
            task_mode=mode,
            allow_marches=args.allow_marches if args.allow_marches else None,
        )
    )


if __name__ == "__main__":
    main()

