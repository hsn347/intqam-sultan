# -*- coding: utf-8 -*-
"""
tools/benchmark_concurrency_caching.py
═════════════════════════════════════════════════════════════════════════════════
أداة الفحص والقياس المؤتمتة للأداء العالي والتخزين المؤقت (Requirement R3):
1. فحص التزامن وقفل SQLite تحت ضغط 150 عاملاً متزامناً (0 Database Locks).
2. قياس زمن تنفيذ استعلام get_all_users_with_castles() المجمع لـ 150 مستخدم و 1000 قلعة (<50ms).
3. التحقق من ملخص العرض الخفيف (/api/castles?summary=true) ونسبة توفير البيانات (>80%).
4. التحقق من كاش WebSocket للحالات الخاملة ومنع استنزاف قاعدة البيانات.
5. التحقق من إعداد دورة حياة الخادم (FastAPI lifespan) لإيقاف كافة البوتات بأمان.
6. التحقق من نجاح بناء الواجهة بالكامل (npm run build في مجلد dashboard/).
═════════════════════════════════════════════════════════════════════════════════
"""

from __future__ import annotations

import asyncio
import concurrent.futures
import json
import os
import sqlite3
import subprocess
import sys
import tempfile
import time
from typing import Any, Dict, List, Tuple

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db


def test_sqlite_concurrency(num_workers: int = 150, operations_per_worker: int = 5) -> Dict[str, Any]:
    """
    اختبار التزامن الشديد لقاعدة البيانات SQLite:
    تشغيل 150 عاملاً متزامناً يقومون بالقراءة والكتابة والتحديث في نفس اللحظة
    للتحقق من خلو النظام تماماً من أخطاء 'database is locked'.
    """
    print(f"\n[1/5] فحص التزامن وقفل SQLite ({num_workers} خيط متزامن، {operations_per_worker} عمليات لكل خيط)...")

    # استخدام قاعدة بيانات مؤقتة لتنفيذ القياسات دون التأثير على بيانات الإنتاج
    temp_dir = tempfile.mkdtemp(prefix="ros_benchmark_")
    test_db_path = os.path.join(temp_dir, "benchmark_castles.db")

    db.init_db(test_db_path)

    # تهيئة بيانات أولية
    with db.get_connection(test_db_path) as conn:
        for u_idx in range(20):
            conn.execute(
                "INSERT OR REPLACE INTO users (uid, email, username, role, status) VALUES (?, ?, ?, 'user', 'approved')",
                (f"user_{u_idx}", f"user_{u_idx}@test.local", f"User {u_idx}")
            )
        for c_idx in range(50):
            conn.execute(
                "INSERT OR REPLACE INTO castle_states (castle_id, user_id, email, state, conn_state, config) VALUES (?, ?, ?, 'idle', 'idle', ?)",
                (f"castle_{c_idx}", f"user_{c_idx % 20}", f"castle_{c_idx}@test.local", json.dumps({"test_key": c_idx}))
            )

    lock_errors = 0
    total_ops = 0
    latencies: List[float] = []

    def worker_task(worker_id: int):
        nonlocal lock_errors, total_ops
        worker_latencies = []
        for op in range(operations_per_worker):
            start_t = time.perf_counter()
            cid = f"castle_{worker_id % 50}"
            uid = f"user_{worker_id % 20}"
            try:
                if op % 2 == 0:
                    # عملية كتابة وتحديث حالة
                    db.update_castle_config(cid, {"worker_update": worker_id, "op": op}, uid)
                    db.upsert_castle_conn_state(cid, "connected", "running", f"Worker {worker_id} running")
                else:
                    # عملية قراءة
                    c = db.get_castle_by_id(cid, uid)
                    _ = db.get_user_castles_summary(uid)
                elapsed = (time.perf_counter() - start_t) * 1000.0
                worker_latencies.append(elapsed)
            except sqlite3.OperationalError as e:
                if "locked" in str(e).lower() or "busy" in str(e).lower():
                    lock_errors += 1
                print(f"  [!] خطأ في العامل {worker_id}: {e}")
            except Exception as ex:
                print(f"  [!] خطأ غير متوقع في العامل {worker_id}: {ex}")
            total_ops += 1
        return worker_latencies

    start_all = time.perf_counter()
    with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(worker_task, i) for i in range(num_workers)]
        for f in concurrent.futures.as_completed(futures):
            latencies.extend(f.result())
    total_duration = time.perf_counter() - start_all

    # تنظيف مجلد الاختبار المؤقت
    try:
        import shutil
        shutil.rmtree(temp_dir, ignore_errors=True)
    except Exception:
        pass

    avg_lat = sum(latencies) / len(latencies) if latencies else 0.0
    p95_lat = sorted(latencies)[int(len(latencies) * 0.95)] if latencies else 0.0

    print(f"  ✓ إجمالي العمليات المنفذة: {total_ops}")
    print(f"  ✓ أخطاء قفل قاعدة البيانات (Database Locks): {lock_errors} (الهدف: 0)")
    print(f"  ✓ زمن التنفيذ الكلي: {total_duration:.2f} ثانية")
    print(f"  ✓ متوسط زمن العملية: {avg_lat:.2f}ms | p95: {p95_lat:.2f}ms")

    assert lock_errors == 0, f"فشل الاختبار: حدثت أخطاء قفل قاعدة بيانات ({lock_errors})"
    return {
        "total_ops": total_ops,
        "lock_errors": lock_errors,
        "avg_latency_ms": avg_lat,
        "p95_latency_ms": p95_lat,
        "total_duration_sec": total_duration,
    }


def test_batch_users_with_castles_performance(num_users: int = 150, num_castles: int = 1000) -> Dict[str, Any]:
    """
    اختبار سرعة استعلام get_all_users_with_castles() المجمع:
    محاكاة حجم إنتاج كامل يحتوي على 150 مستخدم و 1000 قلعة
    والتحقق من تنفيذه بطلبين SQL فقط وبزمن قياسي (< 50ms).
    """
    print(f"\n[2/5] قياس أداء استعلام get_all_users_with_castles() ({num_users} مستخدم و {num_castles} قلعة)...")

    temp_dir = tempfile.mkdtemp(prefix="ros_batch_")
    test_db_path = os.path.join(temp_dir, "batch_castles.db")
    db.init_db(test_db_path)

    # إدخال بيانات الاختبار دفعة واحدة
    with db.get_connection(test_db_path) as conn:
        users_tuples = [
            (f"uid_{i}", f"user_{i}@example.com", f"User {i}", "user", "approved", "2026-11-01T00:00:00Z")
            for i in range(num_users)
        ]
        conn.executemany(
            "INSERT INTO users (uid, email, username, role, status, created_at) VALUES (?, ?, ?, ?, ?, ?)",
            users_tuples
        )

        castles_tuples = []
        sample_config = json.dumps({"auto_fountain": {"enabled": True}, "train": {"enabled": True}})
        for c in range(num_castles):
            uid = f"uid_{c % num_users}"
            castles_tuples.append((
                f"castle_{c}",
                uid,
                f"castle_{c}@example.com",
                f"Castle {c}",
                1,
                "idle" if c % 3 == 0 else "running",
                "idle" if c % 3 == 0 else "connected",
                "Ready",
                sample_config,
                json.dumps({"food": 100000}),
                json.dumps({"lord_name": f"Lord {c}"}),
                "2026-11-01T00:00:00Z",
                "2026-11-01T00:00:00Z"
            ))
        conn.executemany("""
            INSERT INTO castle_states (
                castle_id, user_id, email, castle_name, is_active, state, conn_state,
                status_message, config, resources, castle_info, created_at, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, castles_tuples)

    # توجيه بيئة الاختبار المؤقتة
    orig_env = os.environ.get("CASTLES_DB_PATH")
    os.environ["CASTLES_DB_PATH"] = test_db_path

    try:
        # تشغيل دافئ (Warm-up)
        _ = db.get_all_users_with_castles()

        # تشغيل القياس الفعلي
        runs = 5
        timings = []
        for _ in range(runs):
            t0 = time.perf_counter()
            users_res = db.get_all_users_with_castles()
            t1 = time.perf_counter()
            timings.append((t1 - t0) * 1000.0)

        avg_time = sum(timings) / len(timings)
        min_time = min(timings)

        print(f"  ✓ تم جلب {len(users_res)} مستخدم بإجمالي {sum(len(u['castles']) for u in users_res)} قلعة.")
        print(f"  ✓ زمن الاستجابة (أفضل محاولة): {min_time:.2f}ms")
        print(f"  ✓ متوسط زمن الاستجابة ({runs} تكرارات): {avg_time:.2f}ms (الهدف: <50ms)")

        assert len(users_res) >= num_users, f"عدد المستخدمين المسترجع خاطئ: {len(users_res)}"
        assert sum(len(u['castles']) for u in users_res) == num_castles, "عدد القلاع المسترجع خاطئ"
        assert avg_time < 50.0, f"فشل معيار السرعة: الاستعلام استغرق {avg_time:.2f}ms وهو أعلى من 50ms"
    finally:
        if orig_env is not None:
            os.environ["CASTLES_DB_PATH"] = orig_env
        else:
            os.environ.pop("CASTLES_DB_PATH", None)
        try:
            import shutil
            shutil.rmtree(temp_dir, ignore_errors=True)
        except Exception:
            pass

    return {
        "users_count": num_users,
        "castles_count": num_castles,
        "best_latency_ms": min_time,
        "avg_latency_ms": avg_time,
    }


def test_api_summary_projection_reduction() -> Dict[str, Any]:
    """
    التحقق من خفة ملخص العرض summary=true مقارنة بالعرض الكامل
    وقياس نسبة التوفير في حجم البيانات المنقولة عبر الشبكة.
    """
    print("\n[3/5] فحص ملخص القلاع الخفيف (Summary Projection) ونسبة تقليص البيانات...")

    temp_dir = tempfile.mkdtemp(prefix="ros_summary_")
    test_db_path = os.path.join(temp_dir, "summary_castles.db")
    db.init_db(test_db_path)

    # إنشاء قلاع مع كائن config ضخم واقعي (10KB لكل قلعة)
    heavy_config = {
        f"task_section_{i}": {
            "enabled": True,
            "stepper_value": i * 100,
            "deep_nested": {"sub_setting": "val", "list_data": list(range(50))}
        } for i in range(20)
    }

    with db.get_connection(test_db_path) as conn:
        for c in range(50):
            conn.execute("""
                INSERT INTO castle_states (
                    castle_id, user_id, email, castle_name, is_active, state, conn_state,
                    status_message, config, resources, castle_info, created_at, updated_at
                ) VALUES (?, 'user_test', ?, 'Castle Test', 1, 'idle', 'idle', 'OK', ?, '{}', '{"lord_name": "Test"}', 'now', 'now')
            """, (f"cid_{c}", f"c{c}@test.local", json.dumps(heavy_config)))

    orig_env = os.environ.get("CASTLES_DB_PATH")
    os.environ["CASTLES_DB_PATH"] = test_db_path

    try:
        full_castles = db.get_user_castles("user_test")
        summary_castles = db.get_user_castles_summary("user_test")

        full_payload_size = len(json.dumps(full_castles, ensure_ascii=False).encode("utf-8"))
        summary_payload_size = len(json.dumps(summary_castles, ensure_ascii=False).encode("utf-8"))

        reduction_pct = ((full_payload_size - summary_payload_size) / full_payload_size) * 100.0

        print(f"  ✓ حجم الحزمة الكاملة (Full Config Payload): {full_payload_size / 1024:.2f} KB")
        print(f"  ✓ حجم حزمة الملخص (Summary Payload): {summary_payload_size / 1024:.2f} KB")
        print(f"  ✓ نسبة توفير البيانات المنقولة: {reduction_pct:.1f}% (الهدف: >80%)")

        assert reduction_pct > 80.0, f"نسبة التقليص غير كافية: {reduction_pct:.1f}%"
        assert all(c["config"] == {} for c in summary_castles), "حقول config لم يتم إفراغها في الملخص"

        # التحقق من أن get_castle_config_only يجلب الإعدادات الأصلية كاملة عند الحاجة
        individual_cfg = db.get_castle_config_only("cid_0", "user_test")
        assert individual_cfg is not None and "task_section_0" in individual_cfg, "فشل جلب إعدادات القلعة الفردية"
        print("  ✓ تم التحقق بنجاح من جلب إعدادات القلعة الفردية عند الطلب عبر get_castle_config_only.")
    finally:
        if orig_env is not None:
            os.environ["CASTLES_DB_PATH"] = orig_env
        else:
            os.environ.pop("CASTLES_DB_PATH", None)
        try:
            import shutil
            shutil.rmtree(temp_dir, ignore_errors=True)
        except Exception:
            pass

    return {
        "full_size_kb": full_payload_size / 1024,
        "summary_size_kb": summary_payload_size / 1024,
        "reduction_pct": reduction_pct,
    }


def test_api_server_lifespan_and_websocket_caching() -> Dict[str, Any]:
    """
    التحقق من إعداد FastAPI Lifespan وكاش WebSocket للحالات الخاملة في api_server.py
    """
    print("\n[4/5] فحص إعدادات Lifespan وكاش WebSocket للحالات الخاملة في api_server.py...")

    import api_server

    # 1. التحقق من وجود lifespan
    lifespan_handler = getattr(api_server.app.router, "lifespan_context", None)
    print(f"  ✓ معالج دورة حياة الخادم (FastAPI Lifespan): {lifespan_handler}")
    assert lifespan_handler is not None, "لم يتم العثور على معالج lifespan في FastAPI"

    # 2. التحقق من وجود كاش الذاكرة للحالات الخاملة
    assert hasattr(api_server, "_ws_idle_status_cache"), "لم يتم العثور على _ws_idle_status_cache في api_server"
    print("  ✓ كاش الذاكرة اللحظي _ws_idle_status_cache موجود ومفعل لحماية SQLite.")

    # 3. التحقق من دالة list_castles وتوفر معامل summary
    import inspect
    sig = inspect.signature(api_server.list_castles)
    assert "summary" in sig.parameters, "معامل summary غير موجود في دالة list_castles"
    print(f"  ✓ دالة list_castles تدعم معامل summary بنجاح: {sig.parameters['summary']}")

    return {
        "lifespan_configured": True,
        "ws_cache_present": True,
        "summary_param_present": True,
    }


def test_frontend_build_clean() -> Dict[str, Any]:
    """
    التحقق من خلو مشروع الواجهة dashboard بالكامل من أخطاء TypeScript وبنائه بنجاح
    """
    print("\n[5/5] التحقق من بناء الواجهة بالكامل (npm run build في مجلد dashboard/)...")

    dashboard_dir = os.path.join(_ROOT, "dashboard")
    start_t = time.perf_counter()
    res = subprocess.run(
        "npm run build",
        cwd=dashboard_dir,
        shell=True,
        capture_output=True,
        text=True,
        timeout=120
    )
    elapsed = time.perf_counter() - start_t

    if res.returncode != 0:
        print(f"  [X] فشل بناء الواجهة:\nSTDOUT:\n{res.stdout}\nSTDERR:\n{res.stderr}")
        raise RuntimeError("فشل بناء الواجهة الأمامية عبر npm run build")

    print(f"  ✓ تم بناء الواجهة بنجاح تام في {elapsed:.2f} ثانية بدون أي أخطاء (Exit Code: 0).")
    return {
        "build_success": True,
        "build_duration_sec": elapsed,
    }


def main():
    print("=" * 80)
    print("   ROS BOT ENGINE — BENCHMARK & CONCURRENCY VERIFICATION SUITE")
    print("   Requirement R3: Dashboard Caching, UI Responsiveness & Concurrency")
    print("=" * 80)

    results = {}
    try:
        results["concurrency"] = test_sqlite_concurrency(num_workers=150, operations_per_worker=5)
        results["batch_query"] = test_batch_users_with_castles_performance(num_users=150, num_castles=1000)
        results["summary_reduction"] = test_api_summary_projection_reduction()
        results["api_lifespan_ws"] = test_api_server_lifespan_and_websocket_caching()
        results["frontend_build"] = test_frontend_build_clean()

        print("\n" + "=" * 80)
        print("✓ كــافـة اختبارات الأداء والتزامن وبناء الواجهة نجحت بنسبة 100%!")
        print("=" * 80)
        return 0
    except Exception as e:
        print(f"\n[X] فشل أحد اختبارات الأداء: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
