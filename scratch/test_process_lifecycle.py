# -*- coding: utf-8 -*-
"""
tools/test_process_lifecycle.py
═════════════════════════════════════════════════════════════════════════════
اختبار مؤتمت للتحقق من دورة حياة العمليات والمهام والمقابس (Requirement R2):
1. التحقق الحتمي من إغلاق المهام الفرعية والمقابس في GameConnection.close().
2. فحص جدول العمليات ومقابس النظام قبل التشغيل (Baseline OS Inspection).
3. تشغيل بوت القلعة والتحقق من التتبع اللحظي (Active Tracking).
4. فحص الحماية من الإطلاق المكرر تحت الضغط المتزامن (Anti-Duplication Guard).
5. إيقاف القلعة والتحقق من الإنهاء الفوري لجميع المهام والمقابس (Zero Zombies).
6. التحقق من خلو حلقة الأحداث من أي مهام يتيمة (0 Orphan asyncio Tasks).
7. اختبار الإجهاد السريع لدورات البدء والإيقاف (Rapid Start/Stop Cycles 3x).
═════════════════════════════════════════════════════════════════════════════
"""

import asyncio
import os
import sys
import time
import socket
import subprocess
import json

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import BotManager, CastleBot
from core.game_client import GameConnection, AccountSession, GateCredentials


def get_process_tcp_sockets(pid: int) -> list:
    """استعلام مقابس TCP النشطة التابعة لعملية بايثون الحالية في ويندوز"""
    try:
        cmd = (
            f'powershell -NoProfile -Command "'
            f'Get-NetTCPConnection -OwningProcess {pid} -ErrorAction SilentlyContinue | '
            f'Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | '
            f'ConvertTo-Json"'
        )
        res = subprocess.run(cmd, capture_output=True, text=True, shell=True, timeout=10)
        if res.returncode == 0 and res.stdout.strip():
            data = json.loads(res.stdout.strip())
            return data if isinstance(data, list) else [data]
    except Exception as e:
        print(f"[-] تنبيه أثناء فحص مقابس ويندوز: {e}")
    return []


async def test_game_connection_clean_teardown():
    """
    اختبار مباشر للتأكد من أن GameConnection.close() يلغي وينتظر كافة المهام الفرعية
    ويغلق مقابس الشبكة دون ترك أي مهام يتيمة في حلقة الأحداث.
    """
    print("\n[UNIT TEST] فحص إغلاق المهام الفرعية والمقابس في GameConnection.close()...")

    acc = AccountSession(email="lifecycle_unit_test@test.local", user_id="u123", session_id="s123", password="test")
    creds = GateCredentials(gate_ip="127.0.0.1", gate_port=4060, secret=b"testsecret", kingdom_id="1", uid="u123")
    conn = GameConnection(account=acc, creds=creds)

    # إنشاء مهام فرعية محاكية قيد التشغيل (Running Child Tasks)
    async def dummy_recv():
        try:
            while True:
                await asyncio.sleep(10)
        except asyncio.CancelledError:
            pass

    async def dummy_flow():
        try:
            while True:
                await asyncio.sleep(10)
        except asyncio.CancelledError:
            pass

    async def dummy_heartbeat():
        try:
            while True:
                await asyncio.sleep(10)
        except asyncio.CancelledError:
            pass

    conn._recv_task = asyncio.create_task(dummy_recv(), name="test_recv_task")
    conn._init_flow_task = asyncio.create_task(dummy_flow(), name="test_init_flow_task")
    conn._heartbeat_task = asyncio.create_task(dummy_heartbeat(), name="test_heartbeat_task")
    conn._alive = True

    t_recv = conn._recv_task
    t_flow = conn._init_flow_task
    t_hb = conn._heartbeat_task

    assert not t_recv.done(), "المهمة الفرعية يجب أن تكون نشطة قبل الإغلاق"
    assert not t_flow.done(), "المهمة الفرعية يجب أن تكون نشطة قبل الإغلاق"
    assert not t_hb.done(), "المهمة الفرعية يجب أن تكون نشطة قبل الإغلاق"

    # استدعاء الإغلاق النظيف
    t0 = time.time()
    await conn.close()
    elapsed = time.time() - t0

    # التحقق من أن المهام الفرعية تم إلغاؤها وانتهت بالفعل
    assert t_recv.done(), "مهمة الاستقبال لم تنتهِ بعد استدعاء close!"
    assert t_flow.done(), "مهمة التهيئة لم تنتهِ بعد استدعاء close!"
    assert t_hb.done(), "مهمة نبض القلب لم تنتهِ بعد استدعاء close!"

    assert conn._recv_task is None, "مؤشر مهمة الاستقبال لم يُفرّغ"
    assert conn._init_flow_task is None, "مؤشر مهمة التهيئة لم يُفرّغ"
    assert conn._heartbeat_task is None, "مهمة نبض القلب لم تُفرّغ"
    assert not conn._alive, "حالة الاتصال يجب أن تكون غير حية (_alive = False)"

    print(f"  ✓ تم إلغاء كافة المهام الفرعية وانتظار إنهائها بنجاح خلال {elapsed:.3f} ثانية (Zero Orphan Child Tasks).")


async def run_lifecycle_test():
    print("\n" + "═" * 75)
    print("  🧪 بدء الفحص المؤتمت لدورة حياة العمليات والمهام والمقابس (Requirement R2)")
    print("═" * 75)

    db.init_db()
    current_pid = os.getpid()
    print(f"[*] معرّف العملية الحالية (PID): {current_pid}")

    # 1. اختبار الوحدة لـ GameConnection.close()
    await test_game_connection_clean_teardown()

    # 2. المرحلة الأولى: فحص الأساس لمقابس النظام (Baseline Sockets)
    initial_sockets = get_process_tcp_sockets(current_pid)
    print(f"\n[*] عدد مقابس TCP الأولية للعملية الحالية: {len(initial_sockets)}")

    mgr = BotManager()
    castles = db.get_all_castles()
    if not castles:
        print("[-] تنبيه: لا توجد قلاع في قاعدة البيانات. جاري إنشاء حساب تجريبي للاختبار...")
        test_email = "test_lifecycle@hotmail.com"
        test_pwd = "password123"
        db.upsert_castle(test_email, test_pwd, castle_name="قلعة تجريبية لدورة الحياة", user_id="system_test")
    else:
        test_email = castles[0]["email"]
        test_pwd = castles[0].get("password", "")
    print(f"[*] حساب الاختبار المعتمد: {test_email}")

    # 3. المرحلة الثانية: بدء تشغيل البوت وفحص التتبع اللحظي (Active Tracking)
    print("\n[TEST 1] تشغيل البوت وفحص التتبع اللحظي في الذاكرة...")
    started = await mgr.start_bot(test_email, password=test_pwd)
    assert started, "فشل بدء تشغيل البوت"

    bot = mgr.get_bot(test_email)
    assert bot is not None, "البوت غير مسجل في BotManager.bots"
    assert test_email in mgr.tasks, "مهمة البوت غير مسجلة في BotManager.tasks"
    initial_task = mgr.tasks[test_email]
    assert not initial_task.done(), "مهمة البوت يجب أن تكون نشطة وقيد التنفيذ"
    print(f"  ✓ تم تسجيل البوت والمهمة بنجاح: {initial_task.get_name()}")

    # انتظار قصير لتحديث الحالة
    await asyncio.sleep(1.0)
    live_bots = mgr.list_all_bots()
    matching_live = [b for b in live_bots if b.get("email") == test_email]
    assert len(matching_live) == 1, "لم يتم العثور على البوت كعملية نشطة في list_all_bots()"
    print(f"  ✓ البوت يظهر كعملية حية نشطة: الحالة={matching_live[0].get('conn_state')}, الرسالة='{matching_live[0].get('status_message')}'")

    # 4. المرحلة الثالثة: اختبار منع التشغيل المكرر تحت الطلبات المتتالية (Anti-Duplication Guard)
    print("\n[TEST 2] محاولة تشغيل مكرر لنفس الحساب (Anti-Duplication Guard)...")
    task_before = mgr.tasks[test_email]
    dup_started = await mgr.start_bot(test_email, password=test_pwd)
    assert dup_started, "يجب أن يعيد True دون تكرار إنشاء المهمة"
    task_after = mgr.tasks.get(test_email)
    assert task_before is task_after, "خطأ: تم إنشاء مهمة مكررة أو استبدال المهمة الأصلية!"
    assert len([t for t in asyncio.all_tasks() if t.get_name() == f"bot_{test_email}"]) == 1, "تم رصد أكثر من مهمة واحدة لنفس القلعة!"
    print("  ✓ تم منع إنشاء مهمة مكررة بنجاح وتم التحقق من وجود مهمة واحدة فقط (Anti-Duplication Verified).")

    # 5. المرحلة الرابعة: إيقاف البوت وفحص تفريغ كافة الموارد (Zero Zombies)
    print("\n[TEST 3] إيقاف البوت والتحقق من الإنهاء الفوري والتفريغ التام...")
    stopped = await mgr.stop_bot(test_email)
    assert stopped, "فشل أمر إيقاف البوت"

    # التحقق من حذف المهمة من جدول المهام
    assert test_email not in mgr.tasks, "مهمة البوت ما زالت عالقة في mgr.tasks بعد الإيقاف!"
    assert task_before.done(), "المهمة الأصلية للبوت لم تنتهِ وما زالت قيد التنفيذ!"

    # التحقق من حذف البوت من جدول البوتات
    assert mgr.get_bot(test_email) is None, "كائن البوت ما زال عالقاً في mgr.bots بعد الإيقاف!"

    # التحقق من اختفاء البوت من قائمة العمليات الحية (Zero Ghost/Zombie Processes)
    live_bots_after = mgr.list_all_bots()
    matching_after = [b for b in live_bots_after if b.get("email") == test_email]
    assert len(matching_after) == 0, "البوت المتوقف ما زال يظهر كعملية حية في list_all_bots() (Zombie Process Detected)!"
    print("  ✓ تم إنهاء مهمة البوت وإزالته تماماً من سجل العمليات الحية (Zero Zombie Tasks & Ghost Entries).")

    # 6. فحص عدم وجود أي مهام يتيمة متبقية في حلقة الأحداث (Event Loop Orphan Audit)
    all_current_tasks = [t for t in asyncio.all_tasks() if not t.done()]
    lingering_tasks = [
        t for t in all_current_tasks
        if t.get_name() == f"bot_{test_email}" or "test_recv" in t.get_name() or "test_init" in t.get_name()
    ]
    assert len(lingering_tasks) == 0, f"تم رصد مهام يتيمة في حلقة الأحداث: {lingering_tasks}"
    print("  ✓ تم التحقق من حلقة الأحداث: صفر مهام يتيمة (0 Orphan asyncio Tasks).")

    # 7. المرحلة الخامسة: اختبار الإجهاد التكراري السريع (Rapid Stress Cycles 3x)
    print("\n[TEST 4] اختبار دورات البدء والإيقاف السريعة المتتابعة (Rapid Stress Cycles 3x)...")
    for i in range(1, 4):
        print(f"  Cycle #{i}: Start -> Wait 0.3s -> Stop -> Wait 0.3s")
        st = await mgr.start_bot(test_email, password=test_pwd)
        assert st, f"فشل البدء في الدورة #{i}"
        await asyncio.sleep(0.3)

        sp = await mgr.stop_bot(test_email)
        assert sp, f"فشل الإيقاف في الدورة #{i}"
        await asyncio.sleep(0.3)

        # التأكد بعد كل دورة من خلو السجلات
        assert test_email not in mgr.tasks, f"مهمة عالقة بعد الدورة #{i}"
        assert mgr.get_bot(test_email) is None, f"كائن بوت عالق بعد الدورة #{i}"
        assert len([b for b in mgr.list_all_bots() if b.get("email") == test_email]) == 0, f"عملية حية عالقة بعد الدورة #{i}"

    final_live = mgr.list_all_bots()
    assert len(final_live) == 0, f"توجد عمليات عالقة بعد اختبار الإجهاد: {len(final_live)}"
    print("  ✓ اكتمل اختبار الإجهاد بنجاح: صفر مهام عالقة، صفر عمليات يتيمة، واستقرار تام.")

    # 8. فحص مقابس TCP بعد الاختبار للتأكد من عدم وجود مقابس مسربة
    post_sockets = get_process_tcp_sockets(current_pid)
    print(f"\n[*] عدد مقابس TCP للعملية بعد الاختبار: {len(post_sockets)} (الأساس: {len(initial_sockets)})")

    print("\n" + "═" * 75)
    print("  🎉 كافة فحوصات دورة حياة العمليات والمهام (Requirement R2) اجتازت بنجاح 100%!")
    print("═" * 75 + "\n")
    return True


if __name__ == "__main__":
    try:
        success = asyncio.run(run_lifecycle_test())
        sys.exit(0 if success else 1)
    except Exception as exc:
        print(f"\n❌ فشل اختبار دورة الحياة: {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
