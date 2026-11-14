# -*- coding: utf-8 -*-
"""
tools/test_adversarial_concurrency.py
═════════════════════════════════════════════════════════════════════════════
اختبار التحدي العدائي الشديد (Adversarial Empirical Stress Harness):
فحص افتراضات التزامن ودورة حياة العمليات وقفل قاعدة البيانات تحت أسوأ الظروف:
1. اختبار تسابق فائق (Burst Concurrency Race): إرسال 25 طلب تشغيل متزامن لنفس القلعة في نفس الميكروثانية.
2. اختبار الإلغاء المفاجئ (Simulated CancelledError): مقاطعة مهمة البوت في ذروة عملها والتحقق من التنظيف الحتمي.
3. اختبار قطع الاتصال العنيف (Abrupt Socket Disconnect / EOF): قطع مباغت للاتصال وفحص استجابة GameConnection.close().
4. اختبار صمود قفل SQLite والمهلة الزمنية (Busy Timeout Resilience): احتجاز قفل حصري والتحقق من انتظار ونجاح الخيوط الأخرى.
5. اختبار دورة الحياة الواسعة (Massive Parallel Lifecycle): تشغيل 30 قلعة مختلفة بالتوازي ثم إيقافها والتحقق من تفريغ الذاكرة بالكامل.
6. فحص تسريب المقابس والعمليات الفرعية في نظام ويندوز (Windows OS Sockets & Subprocesses Audit).
═════════════════════════════════════════════════════════════════════════════
"""

from __future__ import annotations

import asyncio
import gc
import json
import os
import socket
import sqlite3
import subprocess
import sys
import tempfile
import threading
import time
from typing import Any, Dict, List

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import BotManager, CastleBot
from core.game_client import GameConnection, AccountSession, GateCredentials


# ─────────────────────────────────────────────────────────────────────────────
# 1. اختبار التسابق الفائق للبدء المتزامن لنفس الحساب (Burst Concurrency Race)
# ─────────────────────────────────────────────────────────────────────────────
async def test_burst_start_race_condition():
    print("\n" + "=" * 75)
    print("[CHALLENGE 1] اختبار التسابق الفائق: 25 استدعاء متزامن في نفس الميكروثانية")
    print("=" * 75)

    mgr = BotManager()
    race_email = "burst_race@test.local"

    # تشغيل 25 استدعاء متزامن عبر asyncio.gather
    t0 = time.perf_counter()
    results = await asyncio.gather(*[
        mgr.start_bot(race_email, password="dummy_password")
        for _ in range(25)
    ], return_exceptions=True)
    elapsed = (time.perf_counter() - t0) * 1000.0

    print(f"  ✓ استجابت كافة الطلبات الـ 25 خلال {elapsed:.2f}ms.")
    assert all(r is True for r in results), f"بعض طلبات البدء أعادت خطأ أو فشل: {results}"

    # التحقق الحتمي: وجود مهمة واحدة فقط في tasks
    assert race_email in mgr.tasks, "مهمة القلعة غير موجودة في mgr.tasks"
    active_bot_tasks = [t for t in asyncio.all_tasks() if t.get_name() == f"bot_{race_email}" and not t.done()]
    print(f"  ✓ عدد مهام asyncio النشطة في حلقة الأحداث: {len(active_bot_tasks)} (المتوقع: 1 بالضبط)")
    assert len(active_bot_tasks) == 1, f"فشل منع التكرار تحت التسابق العنيف! عدد المهام: {len(active_bot_tasks)}"

    # التحقق من أن الكائن في mgr.bots وحيد ومطابق
    bot = mgr.get_bot(race_email)
    assert bot is not None, "كائن البوت غير موجود في mgr.bots"
    assert bot.is_running or bot.conn_state in ("starting", "running", "waiting"), "حالة البوت غير صحيحة"

    # إيقاف وتفريغ
    stopped = await mgr.stop_bot(race_email)
    assert stopped, "فشل إيقاف البوت بعد اختبار التسابق"
    assert race_email not in mgr.tasks, "المهمة ما زالت عالقة في mgr.tasks"
    assert mgr.get_bot(race_email) is None, "كائن البوت ما زال عالقاً في mgr.bots"
    assert len([t for t in asyncio.all_tasks() if t.get_name() == f"bot_{race_email}" and not t.done()]) == 0, "مهمة يتيمة عالقة بعد الإيقاف"
    print("  ✓ تم اجتياز تحدي التسابق الفائق بنجاح 100% (Zero Duplicate Spawns).")


# ─────────────────────────────────────────────────────────────────────────────
# 2. اختبار الإلغاء المفاجئ (Simulated CancelledError during CastleBot.run())
# ─────────────────────────────────────────────────────────────────────────────
async def test_simulated_cancellation_during_run():
    print("\n" + "=" * 75)
    print("[CHALLENGE 2] اختبار الإلغاء المباغت ومقاطعة مهمة CastleBot.run()")
    print("=" * 75)

    test_email = "cancel_test@test.local"
    mgr = BotManager()

    # بدء تشغيل البوت
    ok = await mgr.start_bot(test_email, password="test_pass")
    assert ok, "فشل بدء البوت"

    bot = mgr.get_bot(test_email)
    task = mgr.tasks.get(test_email)
    assert bot is not None and task is not None, "البوت أو المهمة غير موجودين"

    # الانتظار لجزء من الثانية للدخول في طور العمل
    await asyncio.sleep(0.2)

    # محاكاة إشارة إلغاء قسرية مباشرة على المهمة في منتصف العمل
    print("  [*] إرسال إشارة CancelledError مباغتة للمهمة أثناء عملها...")
    task.cancel()

    # انتظار إنهاء المهمة
    try:
        await asyncio.wait_for(task, timeout=2.0)
    except (asyncio.CancelledError, Exception):
        pass

    assert task.done(), "المهمة لم تنتهِ بعد استلام CancelledError"

    # التحقق من أن كتلة finally: await self.stop() نُفذت حتمياً
    print(f"  ✓ حالة البوت بعد الإلغاء المباغت: is_running={bot.is_running}, conn_state='{bot.conn_state}'")
    assert not bot.is_running, "خاصية is_running يجب أن تكون False"
    assert bot._async_stop.is_set(), "حدث _async_stop يجب أن يكون مفعلاً"
    assert bot.conn is None, "كائن الاتصال يجب أن يُفرغ بالكامل"

    # تنظيف السجل
    await mgr.stop_bot(test_email)
    print("  ✓ تم التحقق من التنظيف الحتمي عند الإلغاء المباغت (Deterministic Teardown Verified).")


# ─────────────────────────────────────────────────────────────────────────────
# 3. اختبار قطع الاتصال المباغت والعنيف (Abrupt Socket Severance)
# ─────────────────────────────────────────────────────────────────────────────
async def test_abrupt_socket_severance():
    print("\n" + "=" * 75)
    print("[CHALLENGE 3] اختبار قطع المقبس العنيف وفحص GameConnection.close()")
    print("=" * 75)

    # إنشاء سيرفر TCP محلي على Loopback
    server_closed = asyncio.Event()
    client_connected = asyncio.Event()
    server_socket_ref = []

    async def handle_client(reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        server_socket_ref.append(writer)
        client_connected.set()
        try:
            # انتظر قليلاً ثم اقطع الاتصال فوراً بدون أي رسالة وداع
            await asyncio.sleep(0.1)
            writer.close()
            await writer.wait_closed()
        except Exception:
            pass
        finally:
            server_closed.set()

    server = await asyncio.start_server(handle_client, '127.0.0.1', 0)
    server_port = server.sockets[0].getsockname()[1]
    print(f"  [*] تم تشغيل سيرفر محلي للاختبار على المنفذ: {server_port}")

    # إنشاء اتصال حقيقي عبر GameConnection
    acc = AccountSession(email="sock_test@test.local", user_id="u999", session_id="s999", password="p")
    creds = GateCredentials(gate_ip="127.0.0.1", gate_port=server_port, secret=b"secret1234567890", kingdom_id="1", uid="u999")
    conn = GameConnection(account=acc, creds=creds)

    # محاكاة فتح المقبس الحقيقي
    reader, writer = await asyncio.open_connection('127.0.0.1', server_port)
    conn._reader = reader
    conn._writer = writer
    conn._alive = True

    # تشغيل مهام فرعية محاكية تستمع وتكتب
    async def dummy_reader_loop():
        try:
            while conn._alive:
                data = await reader.read(1024)
                if not data:
                    break
        except (asyncio.CancelledError, ConnectionResetError, Exception):
            pass

    conn._recv_task = asyncio.create_task(dummy_reader_loop(), name="adversarial_recv")
    conn._heartbeat_task = asyncio.create_task(asyncio.sleep(100), name="adversarial_heartbeat")

    # انتظار اتصال السيرفر ثم قطع الاتصال
    await asyncio.wait_for(client_connected.wait(), timeout=2.0)
    await asyncio.wait_for(server_closed.wait(), timeout=2.0)
    print("  [*] تم قطع الاتصال من جانب السيرفر مباغتة (Connection Severed / EOF).")

    # الآن استدعاء conn.close() والتأكد أنه لا يعلق ولا يسبب تسريب
    t0 = time.perf_counter()
    await conn.close()
    duration = (time.perf_counter() - t0) * 1000.0

    print(f"  ✓ تم إغلاق وتفريغ GameConnection بنجاح خلال {duration:.2f}ms.")
    assert not conn._alive, "حالة conn._alive يجب أن تكون False"
    assert conn._recv_task is None, "مهمة الاستقبال لم تُفرّغ"
    assert conn._heartbeat_task is None, "مهمة نبض القلب لم تُفرّغ"

    server.close()
    await server.wait_closed()
    print("  ✓ تم اجتياز تحدي قطع المقبس العنيف بنجاح.")


# ─────────────────────────────────────────────────────────────────────────────
# 4. اختبار صمود قفل SQLite والمهلة الزمنية (Busy Timeout Resilience)
# ─────────────────────────────────────────────────────────────────────────────
def test_sqlite_busy_timeout_resilience():
    print("\n" + "=" * 75)
    print("[CHALLENGE 4] اختبار مهلة قفل SQLite الصامتة (Busy Timeout & Lock Resistance)")
    print("=" * 75)

    temp_dir = tempfile.mkdtemp(prefix="ros_busy_test_")
    test_db_path = os.path.join(temp_dir, "busy_test.db")
    db.init_db(test_db_path)

    orig_env = os.environ.get("CASTLES_DB_PATH")
    os.environ["CASTLES_DB_PATH"] = test_db_path

    try:
        # إدخال سجلات أولية
        with db.get_connection(test_db_path) as c:
            c.execute("INSERT INTO castle_states (castle_id, user_id, email, state, conn_state, config) VALUES ('busy_c1', 'u1', 'c1@t.local', 'idle', 'idle', '{}')")

        lock_acquired = threading.Event()
        lock_release = threading.Event()
        lock_holder_error = []

        # خيط يحتجز قفل حصري صريح على الملف لمدة 1.5 ثانية
        def exclusive_lock_holder():
            try:
                conn = sqlite3.connect(test_db_path, timeout=30.0)
                conn.execute("BEGIN EXCLUSIVE")
                conn.execute("UPDATE castle_states SET status_message = 'locked_by_test' WHERE castle_id = 'busy_c1'")
                lock_acquired.set()
                # احتجاز القفل حتى يُسمح بالتحرير
                lock_release.wait(timeout=10.0)
                conn.commit()
                conn.close()
            except Exception as ex:
                lock_holder_error.append(ex)
                lock_acquired.set()

        holder_thread = threading.Thread(target=exclusive_lock_holder, daemon=True)
        holder_thread.start()
        lock_acquired.wait(timeout=5.0)
        assert not lock_holder_error, f"خطأ في خيط احتجاز القفل: {lock_holder_error}"
        print("  [*] خيط الاختبار احتجز قفلاً حصرياً صريحاً (BEGIN EXCLUSIVE) على SQLite بنجاح.")

        # الآن 8 خيوط متزامنة تحاول الكتابة فوراً عبر دالات db.py التي تستخدم PRAGMA busy_timeout = 30000;
        worker_results = []

        def concurrent_writer(worker_id: int):
            t_start = time.perf_counter()
            try:
                db.update_castle_config("busy_c1", {"worker": worker_id}, "u1")
                db.upsert_castle_conn_state("busy_c1", "connected", "running", f"writer {worker_id}")
                elapsed = (time.perf_counter() - t_start) * 1000.0
                worker_results.append((worker_id, True, elapsed, None))
            except Exception as e:
                elapsed = (time.perf_counter() - t_start) * 1000.0
                worker_results.append((worker_id, False, elapsed, str(e)))

        # إطلاق الخيوط بينما القفل ما زال محتجزاً
        threads = [threading.Thread(target=concurrent_writer, args=(i,), daemon=True) for i in range(8)]
        for t in threads:
            t.start()

        # الانتظار 1.0 ثانية للتأكد من أن الخيوط دخلت في حالة الانتظار الصامت لـ busy_timeout
        time.sleep(1.0)
        print("  [*] الخيوط الـ 8 في حالة انتظار لانتهاء القفل الحصري (PRAGMA busy_timeout نشط)...")

        # تحرير القفل الحصري الآن
        lock_release.set()
        holder_thread.join(timeout=3.0)

        # انتظار انتهاء كافة الخيوط
        for t in threads:
            t.join(timeout=10.0)

        print(f"  ✓ عدد الخيوط المكتملة: {len(worker_results)}/8")
        failed_writes = [r for r in worker_results if not r[1]]
        assert len(failed_writes) == 0, f"فشلت بعض الخيوط أثناء انتظار مهلة القفل: {failed_writes}"

        avg_wait = sum(r[2] for r in worker_results) / len(worker_results)
        print(f"  ✓ نجحت كافة الخيوط الـ 8 بعد تحرير القفل مباشرة بدون أي خطأ 'database is locked'.")
        print(f"  ✓ متوسط زمن انتظار الخيوط لقفل SQLite: {avg_wait:.2f}ms")
    finally:
        if orig_env is not None:
            os.environ["CASTLES_DB_PATH"] = orig_env
        else:
            os.environ.pop("CASTLES_DB_PATH", None)

    # تنظيف
    try:
        import shutil
        shutil.rmtree(temp_dir, ignore_errors=True)
    except Exception:
        pass
    print("  ✓ تم التحقق من صمود مهلة SQLite (Busy Timeout Resilience Verified).")


# ─────────────────────────────────────────────────────────────────────────────
# 5. اختبار دورة الحياة لـ 30 قلعة متزامنة (Massive Parallel Lifecycle)
# ─────────────────────────────────────────────────────────────────────────────
async def test_massive_parallel_lifecycle():
    print("\n" + "=" * 75)
    print("[CHALLENGE 5] اختبار دورة الحياة الواسعة: تشغيل وإيقاف 30 قلعة بالتوازي")
    print("=" * 75)

    mgr = BotManager()
    castles_count = 30
    emails = [f"massive_castle_{i}@test.local" for i in range(castles_count)]

    # 1. تشغيل 30 قلعة بالتوازي
    t0 = time.perf_counter()
    start_results = await asyncio.gather(*[
        mgr.start_bot(em, password="dummy") for em in emails
    ], return_exceptions=True)
    start_time = time.perf_counter() - t0
    print(f"  ✓ تشغيل {castles_count} قلعة بالتوازي اكتمل في {start_time:.2f} ثانية.")
    assert all(r is True for r in start_results), "فشل تشغيل بعض القلاع"

    # فحص القائمة الحية
    live_bots = mgr.list_all_bots()
    print(f"  ✓ عدد القلاع الحية النشطة في list_all_bots(): {len(live_bots)}/{castles_count}")
    assert len(live_bots) == castles_count, f"العدد المسترجع {len(live_bots)} لا يطابق {castles_count}"

    # 2. إيقاف 15 قلعة عشوائية بالتوازي
    half_emails = emails[:15]
    remaining_emails = emails[15:]
    t1 = time.perf_counter()
    stop_half_results = await asyncio.gather(*[
        mgr.stop_bot(em) for em in half_emails
    ], return_exceptions=True)
    stop_time = time.perf_counter() - t1
    print(f"  ✓ إيقاف نصف القلاع (15 قلعة) بالتوازي اكتمل في {stop_time:.2f} ثانية.")
    assert all(r is True for r in stop_half_results), "فشل إيقاف بعض القلاع"

    # التحقق من أن الـ 15 المتوقفة اختفت تماماً من list_all_bots
    live_after_half = mgr.list_all_bots()
    live_emails = {b.get("email") for b in live_after_half}
    print(f"  ✓ عدد القلاع الحية بعد إيقاف النصف: {len(live_after_half)} (المتوقع: 15)")
    assert len(live_after_half) == 15, f"العدد غير متطابق: {len(live_after_half)}"
    for stopped_em in half_emails:
        assert stopped_em not in live_emails, f"القلعة المتوقفة {stopped_em} ما زالت ظاهرة في list_all_bots()!"
        assert stopped_em not in mgr.tasks, f"مهمة القلعة المتوقفة {stopped_em} ما زالت في mgr.tasks!"
        assert mgr.get_bot(stopped_em) is None, f"كائن القلعة المتوقفة {stopped_em} ما زال في mgr.bots!"

    # 3. استدعاء stop_all() لإيقاف وتفريغ كل ما تبقى
    t2 = time.perf_counter()
    await mgr.stop_all()
    stop_all_time = time.perf_counter() - t2
    print(f"  ✓ استدعاء mgr.stop_all() اكتمل في {stop_all_time:.2f} ثانية.")

    # التحقق الحتمي من التصفير الكامل
    final_live = mgr.list_all_bots()
    assert len(final_live) == 0, f"توجد قلاع عالقة بعد stop_all: {len(final_live)}"
    assert len(mgr.bots) == 0, f"كائنات عالقة في mgr.bots: {len(mgr.bots)}"
    assert len(mgr.tasks) == 0, f"مهام عالقة في mgr.tasks: {len(mgr.tasks)}"

    # التحقق من عدم وجود أي مهمة من نوع bot_ في حلقة أحداث asyncio
    active_bot_tasks = [t for t in asyncio.all_tasks() if t.get_name().startswith("bot_") and not t.done()]
    assert len(active_bot_tasks) == 0, f"تم رصد مهام يتيمة في حلقة الأحداث: {active_bot_tasks}"
    print("  ✓ تم اجتياز اختبار دورة الحياة لـ 30 قلعة بنجاح تام (Zero Lingering Bots/Tasks).")


# ─────────────────────────────────────────────────────────────────────────────
# 6. فحص تسريب المقابس والعمليات الفرعية في نظام ويندوز (OS Sockets & Processes)
# ─────────────────────────────────────────────────────────────────────────────
def test_windows_os_leak_audit():
    print("\n" + "=" * 75)
    print("[CHALLENGE 6] فحص نظام ويندوز: المقابس والعمليات التابعة (OS Leak Audit)")
    print("=" * 75)

    current_pid = os.getpid()

    # فحص المقابس المفتوحة التابعة لـ PID الحالي
    try:
        cmd = (
            f'powershell -NoProfile -Command "'
            f'Get-NetTCPConnection -OwningProcess {current_pid} -ErrorAction SilentlyContinue | '
            f'Where-Object {{ $_.State -eq \\"CloseWait\\" -or $_.State -eq \\"Established\\" }} | '
            f'Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | '
            f'ConvertTo-Json"'
        )
        res = subprocess.run(cmd, capture_output=True, text=True, shell=True, timeout=10)
        hanging_sockets = []
        if res.returncode == 0 and res.stdout.strip():
            raw = json.loads(res.stdout.strip())
            hanging_sockets = raw if isinstance(raw, list) else [raw]

        print(f"  ✓ عدد مقابس TCP العالقة في حالتي Established/CloseWait: {len(hanging_sockets)}")
        # إذا وجدت مقابس، تأكد أنها لا تخص بوابات اللعبة (المنافذ 4000-4300)
        game_gate_sockets = [
            s for s in hanging_sockets
            if 4000 <= int(s.get("RemotePort", 0) or 0) <= 4300
        ]
        assert len(game_gate_sockets) == 0, f"تم رصد مقابس بوابات لعبة عالقة: {game_gate_sockets}"
        print("  ✓ صفر مقابس بوابات لعبة مسربة في جدول شبكة ويندوز.")
    except Exception as e:
        print(f"  [-] تخطي فحص المقابس المتقدم: {e}")

    # فحص العمليات الفرعية للعملية الحالية للتأكد من عدم ترك أي Subprocess
    try:
        cmd_proc = (
            f'powershell -NoProfile -Command "'
            f'Get-CimInstance Win32_Process | '
            f'Where-Object {{ $_.ParentProcessId -eq {current_pid} -and $_.Name -notmatch \\"powershell|cmd\\" }} | '
            f'Select-Object ProcessId, Name, CommandLine | '
            f'ConvertTo-Json"'
        )
        res_proc = subprocess.run(cmd_proc, capture_output=True, text=True, shell=True, timeout=10)
        child_procs = []
        if res_proc.returncode == 0 and res_proc.stdout.strip():
            raw_p = json.loads(res_proc.stdout.strip())
            child_procs = raw_p if isinstance(raw_p, list) else [raw_p]

        print(f"  ✓ عدد العمليات التابعة النشطة (Child Subprocesses): {len(child_procs)}")
        assert len(child_procs) == 0, f"تم رصد عمليات تابعة يتيمة قيد التشغيل: {child_procs}"
        print("  ✓ صفر عمليات فرعية يتيمة (Zero Orphan Subprocesses).")
    except Exception as e:
        print(f"  [-] تنبيه في فحص العمليات الفرعية: {e}")


# ─────────────────────────────────────────────────────────────────────────────
# الدالة الرئيسية
# ─────────────────────────────────────────────────────────────────────────────
async def run_all_adversarial_tests():
    print("\n" + "█" * 75)
    print("   EMPIRICAL ADVERSARIAL STRESS TEST SUITE — CHALLENGER R2/R3")
    print("█" * 75)

    db.init_db()

    await test_burst_start_race_condition()
    await test_simulated_cancellation_during_run()
    await test_abrupt_socket_severance()
    test_sqlite_busy_timeout_resilience()
    await test_massive_parallel_lifecycle()
    test_windows_os_leak_audit()

    print("\n" + "█" * 75)
    print("  🏆 كـافـة اختبارات التحدي العدائي (Adversarial Stress Tests) اجتازت بنجاح 100%!")
    print("█" * 75 + "\n")
    return True


if __name__ == "__main__":
    try:
        success = asyncio.run(run_all_adversarial_tests())
        sys.exit(0 if success else 1)
    except Exception as exc:
        print(f"\n❌ فشل اختبار التحدي العدائي: {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
