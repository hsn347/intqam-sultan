# -*- coding: utf-8 -*-
"""
deploy.py — أداة النشر والتحديث الذكي السلس لخادم انتقام السلاطين (Intqam-Sultan)
══════════════════════════════════════════════════════════════════════════════

python deploy_logic/deploy.py --frontend          # تحديث الواجهة فقط
python deploy_logic/deploy.py --full              # تحديث شامل + استئناف تلقائي
python deploy_logic/deploy.py --backend           # تحديث الباك إند فقط + استئناف
python deploy_logic/deploy.py --check             # فحص حالة السيرفر
python deploy_logic/deploy.py --start-all         # تشغيل الحسابات من لوحة التحكم
python deploy_logic/deploy.py --stop-all          # إيقاف البوتات من لوحة التحكم
python deploy_logic/deploy.py --stopped           # تحديث شامل مع إيقاف كل البوتات
python deploy_logic/deploy.py --gradual-start     # تشغيل تدريجي عشوائي (5-10 ثوانٍ + خلط)
python deploy_logic/deploy.py --gradual-stop      # إيقاف جميع البوتات فوراً
python deploy_logic/deploy.py --upload-only       # رفع الملفات فقط بدون لمس البوتات
python deploy_logic/deploy.py --cancel-queue      # إلغاء التشغيل التدريجي (الشغالة تبقى)
python deploy_logic/deploy.py --restart-all       # إيقاف الكل + إعادة تشغيل تدريجي

يدعم القائمة التفاعلية أيضاً: python deploy_logic/deploy.py
"""

from __future__ import annotations

import argparse
import json
import os
import shlex
import sys

DEPLOY_DIR = os.path.dirname(os.path.abspath(__file__))
LOCAL_DIR = os.path.dirname(DEPLOY_DIR)
if LOCAL_DIR not in sys.path:
    sys.path.insert(0, LOCAL_DIR)

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

from deploy_logic.config import (
    DeployConfig,
    RESUME_BATCH_DELAY_AVG,
    RESUME_BATCH_SIZE,
    RESUME_ITEM_DELAY_AVG,
    build_frontend_dist,
    call_internal_api,
    create_backend_bundle,
    deploy_lock,
    deploy_unlock,
    get_ssh_client,
    load_deploy_config,
    restart_service_and_wait,
    ssh_run,
    stop_service_cleanly,
    upload_frontend_bundle,
    wait_for_api_health,
)


def upload_backend_files(client, cfg: DeployConfig) -> None:
    """تجميع وضغط ورفع ملفات الباك إند مع تطبيق الاستثناءات وتحديث ملفات الخدمة."""
    print("\n📦 [1/3] تجميع وضغط حزمة الباك إند الذرية (مع حماية القواعد والبروكسي)...")
    tar_path, packed_count = create_backend_bundle(bundle_name="backend_dist.tar.gz", exclude_proxy_json=True)
    file_size_mb = os.path.getsize(tar_path) / (1024 * 1024)
    print(f"   ✅ تم حزم {packed_count} ملفاً بنجاح ({file_size_mb:.2f} MB)")
    print("   🚫 تم استثناء: game_file و docs و tools وقواعد البيانات و proxy/*.json و deploy_config.json.")

    print("\n🚀 [2/3] رفع الحزمة الذرية إلى السيرفر عبر SFTP...")
    r_dir_q = shlex.quote(cfg.remote_dir)
    ssh_run(client, f"mkdir -p {r_dir_q}", timeout=20)
    sftp = client.open_sftp()
    remote_tar = f"{cfg.remote_dir}/backend_dist.tar.gz"
    sftp.put(tar_path, remote_tar)
    sftp.close()

    try:
        os.remove(tar_path)
    except Exception:
        pass

    print("\n⚡ [3/3] فك الضغط الذري وتحديث إعدادات النظام على السيرفر...")
    svc_src = shlex.quote(f"{cfg.remote_dir}/deploy_logic/{cfg.service_name}")
    svc_dst = shlex.quote(f"/etc/systemd/system/{cfg.service_name}")
    ngx_src = shlex.quote(f"{cfg.remote_dir}/deploy_logic/{cfg.nginx_conf_name}")
    ngx_dst = shlex.quote(f"{cfg.remote_dir}/{cfg.nginx_conf_name}")
    ngx_avail = shlex.quote(f"/etc/nginx/sites-available/{cfg.nginx_conf_name}")
    ngx_enabled = shlex.quote(f"/etc/nginx/sites-enabled/{cfg.nginx_conf_name}")
    remote_tar_q = shlex.quote(remote_tar)
    extract_cmd = (
        f"tar -xzf {remote_tar_q} -C {r_dir_q} && "
        f"rm -f {remote_tar_q} && "
        f"if [ -f {svc_src} ]; then cp -f {svc_src} {svc_dst}; fi && "
        f"if [ -f {ngx_src} ]; then cp -f {ngx_src} {ngx_dst} && cp -f {ngx_src} {ngx_avail} && ln -sf {ngx_avail} {ngx_enabled} && (nginx -t && systemctl reload nginx || true); fi"
    )
    ssh_run(client, extract_cmd, timeout=60)

    print("   📦 تثبيت وتحديث مكتبات البايثون في بيئة السيرفر (pip install)...")
    pip_q = shlex.quote(f"{cfg.remote_dir}/venv/bin/pip")
    req_q = shlex.quote(f"{cfg.remote_dir}/requirements.txt")
    ssh_run(client, f"{pip_q} install -q -r {req_q}", timeout=240)
    ssh_run(client, "systemctl daemon-reload", timeout=20)
    print("✅ تم رفع وتحديث كافة ملفات الباك إند وإعدادات النظام بنجاح تام.")


def _save_active_bots_before_restart(client, cfg: DeployConfig) -> int:
    """حفظ حالة البوتات النشطة عبر /api/internal/save-running-state مع استرجاع احتياطي."""
    save_resp = call_internal_api(client, cfg, "POST", "/api/internal/save-running-state", timeout=20)
    saved_count = 0
    try:
        res_data = json.loads(save_resp)
        saved_count = int(res_data.get("count", 0))
        print(f"   ✅ تم حفظ حالة {saved_count} بوت نشط بنجاح في السيرفر.")
    except Exception:
        preview = save_resp[:120] if save_resp else "تجاوز المهلة الزمنية (انتقال للاسترجاع الاحتياطي)"
        print(f"   ⚠️ استجابة الحفظ: {preview}")

    if saved_count == 0:
        resume_file_q = shlex.quote(f"{cfg.remote_dir}/auto_resume.json")
        cat_resp = ssh_run(client, f"cat {resume_file_q} 2>/dev/null || true", timeout=15)
        try:
            prev_data = json.loads(cat_resp)
            if isinstance(prev_data, list) and len(prev_data) > 0:
                saved_count = len(prev_data)
                print(f"   ✅ تم استرجاع {saved_count} بوت محفوظ مسبقاً من auto_resume.json.")
        except Exception:
            pass
    return saved_count


def _report_gradual_resume_estimate(client, cfg: DeployConfig, saved_count: int, fallback_endpoint: str) -> None:
    """عرض تقدير وقت الاستئناف أو إطلاق البدء التدريجي إن لم توجد قائمة محفوظة."""
    if saved_count > 0:
        batches = (saved_count + RESUME_BATCH_SIZE - 1) // RESUME_BATCH_SIZE
        est_sec = int(saved_count * RESUME_ITEM_DELAY_AVG)
        print(f"\n⏳ الاستئناف التدريجي التلقائي: {saved_count} بوت (~{batches} دفعة بفاصل عشوائي 5-10 ثوانٍ وخلط للمستخدمين)")
        print(f"   الوقت التقديري للاستئناف الكامل: ~{est_sec}ث ({est_sec // 60}د {est_sec % 60}ث)")
    else:
        print("\n🔄 لم تكن هناك بوتات نشطة مسجلة لحظياً — جاري بدء التشغيل التدريجي الآمن...")
        resume_resp = call_internal_api(client, cfg, "POST", fallback_endpoint, timeout=25)
        print(f"   ✅ استجابة التشغيل التدريجي: {resume_resp}")


def deploy_frontend_only() -> None:
    print("\n" + "=" * 65)
    print("🌐 خيار 1: تحديث الواجهة الأمامية فقط (Frontend Only)")
    print("⚡ ميزة: 0% انقطاع — البوتات الشغالة حالياً لن تتأثر إطلاقاً!")
    print("=" * 65)

    cfg = load_deploy_config()
    if not build_frontend_dist():
        return

    client = get_ssh_client(cfg)
    try:
        upload_frontend_bundle(client, cfg, reload_nginx=True)
    finally:
        client.close()

    print("\n" + "═" * 65)
    print("🎉 اكتمل تحديث الواجهة بنجاح تام! يمكنك فحص الموقع الآن.")
    print("═" * 65)


def _deploy_server_update(include_frontend: bool) -> None:
    """تحديث مشترك للخادم (كامل أو باك إند فقط) مع القفل، حفظ الحالة، والاستئناف التلقائي."""
    title = "تحديث شامل ذكي (Full Deploy + Auto-Resume)" if include_frontend else "تحديث الباك إند فقط (Backend Only + Auto-Resume)"
    print("\n" + "=" * 65)
    print(f"🚀 {title}")
    print("🔄 استئناف تدريجي عشوائي (5-10 ثوانٍ بين كل حساب مع خلط المستخدمين)")
    print("=" * 65)

    cfg = load_deploy_config()
    if include_frontend and not build_frontend_dist():
        return

    client = get_ssh_client(cfg)
    try:
        print("\n🔒 تفعيل وضع النشر (Deploy Lock) — تعليق تشغيل أي بوت جديد...")
        deploy_lock(client, cfg)

        print("\n💾 حفظ قائمة البوتات النشطة حالياً عبر Auto-Resume...")
        saved_count = _save_active_bots_before_restart(client, cfg)

        print(f"\n🛑 إغلاق خدمة البوت ({cfg.service_name}) على السيرفر...")
        stop_status = stop_service_cleanly(client, cfg)
        print(f"   حالة الخدمة الآن: {stop_status or 'inactive'} (متوقفة تماماً)")

        print("\n⬆️  رفع ملفات الباك إند المحدثة إلى السيرفر...")
        upload_backend_files(client, cfg)

        if include_frontend:
            print("\n⬆️  رفع حزمة الواجهة الأمامية وتحديث Nginx...")
            upload_frontend_bundle(client, cfg, reload_nginx=True)

        print(f"\n🔄 إعادة تشغيل خدمة البايثون ({cfg.service_name})...")
        svc_q = shlex.quote(cfg.service_name)
        ssh_run(client, f"systemctl daemon-reload && systemctl restart {svc_q}; sleep 2", timeout=30)
        status_resp = ssh_run(client, f"systemctl is-active {svc_q} || true", timeout=15)
        print(f"   حالة الخدمة: {status_resp}")

        print("\n🔍 فحص صحة الخدمة بعد الإقلاع...")
        ok, health_resp = wait_for_api_health(client, cfg, max_wait_sec=20)
        print(f"   الصحة ({'OK' if ok else 'WARN'}): {health_resp}")

        fallback = "/api/internal/gradual-start" if include_frontend else "/api/internal/resume-all-from-db"
        _report_gradual_resume_estimate(client, cfg, saved_count, fallback_endpoint=fallback)
    finally:
        client.close()

    print("\n" + "═" * 65)
    print("🎉 تم التحديث بنجاح! البوتات تستأنف تلقائياً بشكل متدرج.")
    print("═" * 65)


def deploy_full_smart() -> None:
    _deploy_server_update(include_frontend=True)


def deploy_backend_only() -> None:
    _deploy_server_update(include_frontend=False)


def check_status() -> None:
    print("\n" + "=" * 65)
    print("🔍 خيار 3: فحص حالة السيرفر والبوتات الشغالة")
    print("=" * 65)

    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        svc_q = shlex.quote(cfg.service_name)
        svc_state = ssh_run(client, f"systemctl is-active {svc_q} || true", timeout=15)
        health = call_internal_api(client, cfg, "GET", "/api/health", timeout=12)
        dbg = call_internal_api(client, cfg, "GET", "/api/internal/debug-state", timeout=12)
        print(f"\nحالة الخدمة: {svc_state}\nالصحة: {health}\nالحالة الداخلية: {dbg}\n")
    finally:
        client.close()


def resume_all_castles() -> None:
    print("\n" + "=" * 65)
    print("🚀 تشغيل/استئناف جميع الحسابات الموافق عليها تدريجياً وبأمان...")
    print("=" * 65)
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        if not restart_service_and_wait(client, cfg):
            print("❌ تعذر التأكد من جاهزية الخدمة — لم يتم إرسال أمر التشغيل التدريجي.")
            return
        resp = call_internal_api(client, cfg, "POST", "/api/internal/gradual-start", timeout=30)
        print(f"   الرد: {resp}")
    finally:
        client.close()
    print("✅ تم إرسال أمر التشغيل التدريجي لكافة الحسابات بنجاح!")


def stop_all_castles() -> None:
    print("\n" + "=" * 65)
    print("🛑 إيقاف جميع البوتات النشطة فوراً على السيرفر...")
    print("=" * 65)
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        resp = call_internal_api(client, cfg, "POST", "/api/internal/stop-all", timeout=30)
        print(f"   الرد: {resp}")
    finally:
        client.close()
    print("✅ تم إرسال أمر إيقاف كافة البوتات وتصفير حالتها بنجاح!")


def deploy_with_all_stopped() -> None:
    print("\n" + "=" * 65)
    print("🚀 تحديث شامل للباك إند والواجهة مع إيقاف كافة البوتات بالكامل")
    print("🛑 لن يتم تشغيل أي بوت تلقائياً (ستبقى جميع الحسابات متوقفة)")
    print("=" * 65)

    cfg = load_deploy_config()
    if not build_frontend_dist():
        return

    client = get_ssh_client(cfg)
    try:
        print("\n🔒 [1/7] تفعيل وضع النشر (Deploy Lock)...")
        deploy_lock(client, cfg)

        print(f"\n🛑 [2/7] إغلاق خدمة البوت ({cfg.service_name}) على السيرفر...")
        stop_service_cleanly(client, cfg)

        print("\n⬆️  [3/7] رفع حزمة الواجهة الأمامية...")
        upload_frontend_bundle(client, cfg, reload_nginx=True)

        print("\n⬆️  [4/7] رفع ملفات الباك إند المحدثة إلى السيرفر...")
        upload_backend_files(client, cfg)

        print("\n🧹 [5/7] حذف ملف الاستئناف وتصفير القلاع غير المحظورة إلى idle...")
        resume_file_q = shlex.quote(f"{cfg.remote_dir}/auto_resume.json")
        py_bin = shlex.quote(f"{cfg.remote_dir}/venv/bin/python3")
        r_dir = shlex.quote(cfg.remote_dir)
        ssh_run(client, f"rm -f {resume_file_q}", timeout=15)
        reset_cmd = (
            f"{py_bin} -c \"import sys; sys.path.insert(0, {r_dir!r}); "
            "from core import database as db; "
            "n = db.stop_all_castles_idle_db('تم إيقاف البوت بواسطة المشرف'); "
            "print('DB Reset Done:', n)\""
        )
        out = ssh_run(client, reset_cmd, timeout=30)
        print(f"   {out or 'DB Reset Executed'}")

        print(f"\n🔄 [6/7] إعادة تشغيل خدمة البايثون ({cfg.service_name})...")
        svc_q = shlex.quote(cfg.service_name)
        ssh_run(client, f"systemctl daemon-reload && systemctl restart {svc_q}; sleep 2", timeout=30)

        print("\n🔍 [7/7] فحص صحة الخدمة وإلغاء قفل النشر...")
        wait_for_api_health(client, cfg, max_wait_sec=20)
        deploy_unlock(client, cfg)
    finally:
        client.close()

    print("\n" + "═" * 65)
    print("🎉 تم التحديث والرفع بنجاح! جميع البوتات متوقفة الآن وجاهزة.")
    print("═" * 65)


def gradual_start_all() -> None:
    resume_all_castles()


def gradual_stop_all() -> None:
    stop_all_castles()


def upload_only() -> None:
    print("\n" + "=" * 65)
    print("⬆️  رفع ملفات الباك إند فقط (بدون إيقاف/تشغيل أي بوت)")
    print("⚡ الملفات الجديدة ستُستخدم عند إعادة تشغيل الخدمة لاحقاً")
    print("=" * 65)
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        upload_backend_files(client, cfg)
    finally:
        client.close()
    print("\n" + "═" * 65)
    print("🎉 تم رفع ملفات الباك إند بنجاح! البوتات الشغالة لم تتأثر.")
    print("👉 لتطبيق التحديثات، نفذ: python deploy_logic/deploy.py --restart-all")
    print("═" * 65)


def cancel_queue() -> None:
    print("\n" + "=" * 65)
    print("🛑 إلغاء عملية التشغيل التدريجي الجارية (الشغالة تبقى)")
    print("=" * 65)
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        resp = call_internal_api(client, cfg, "POST", "/api/internal/cancel-start-queue", timeout=15)
        print(f"   الرد: {resp}")
    finally:
        client.close()
    print("✅ تم إرسال أمر الإلغاء بنجاح!")


def restart_all() -> None:
    print("\n" + "=" * 65)
    print("🔄 إيقاف جميع البوتات + إعادة تشغيل تدريجي بالتحديثات")
    print("📦 فاصل 5-10 ثوانٍ عشوائي + خلط عشوائي")
    print("=" * 65)
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        if not restart_service_and_wait(client, cfg):
            print("❌ تعذر التأكد من جاهزية الخدمة — لم يتم إرسال أمر إعادة التشغيل.")
            return
        resp = call_internal_api(client, cfg, "POST", "/api/internal/restart-all", timeout=30)
        print(f"   الرد: {resp}")
    finally:
        client.close()
    print("✅ تم إرسال أمر إعادة التشغيل التدريجي بنجاح!")


def main() -> None:
    parser = argparse.ArgumentParser(description="أداة النشر والتحديث والتحكم لسيرفر انتقام السلاطين")
    parser.add_argument("--frontend", "-1", action="store_true", help="تحديث الواجهة فقط بدون لمس البوتات")
    parser.add_argument("--full", "-2", action="store_true", help="تحديث شامل مع استئناف ذكي للبوتات")
    parser.add_argument("--backend", "-4", action="store_true", help="تحديث الباك إند فقط واستئناف البوتات")
    parser.add_argument("--check", "-3", action="store_true", help="فحص حالة السيرفر والبوتات")
    parser.add_argument("--start-all", "--resume", "--resume-all", "-5", dest="start_all", action="store_true", help="تشغيل جميع الحسابات المؤهلة تدريجياً")
    parser.add_argument("--stop-all", "-6", dest="stop_all", action="store_true", help="إيقاف جميع البوتات النشطة فوراً")
    parser.add_argument("--stopped", "-7", dest="stopped", action="store_true", help="تحديث شامل مع إيقاف كافة البوتات دون تشغيلها")
    parser.add_argument("--gradual-start", dest="gradual_start", action="store_true", help="تشغيل تدريجي عشوائي للحسابات المؤهلة")
    parser.add_argument("--gradual-stop", dest="gradual_stop", action="store_true", help="إيقاف جميع البوتات النشطة فوراً")
    parser.add_argument("--upload-only", dest="upload_only", action="store_true", help="رفع ملفات الباك إند فقط بدون إعادة تشغيل")
    parser.add_argument("--cancel-queue", dest="cancel_queue", action="store_true", help="إلغاء التشغيل التدريجي الجاري")
    parser.add_argument("--restart-all", dest="restart_all", action="store_true", help="إيقاف الكل + إعادة تشغيل تدريجي بالتحديثات")
    args = parser.parse_args()

    flag_actions = [
        (args.frontend, deploy_frontend_only),
        (args.full, deploy_full_smart),
        (args.backend, deploy_backend_only),
        (args.check, check_status),
        (args.start_all, resume_all_castles),
        (args.stop_all, stop_all_castles),
        (args.stopped, deploy_with_all_stopped),
        (args.gradual_start, gradual_start_all),
        (args.gradual_stop, gradual_stop_all),
        (args.upload_only, upload_only),
        (args.cancel_queue, cancel_queue),
        (args.restart_all, restart_all),
    ]
    for enabled, handler in flag_actions:
        if enabled:
            handler()
            return

    print("\n" + "═" * 65)
    print("🚀 نظام نشر وتحديث والتحكم في سيرفر انتقام السلاطين")
    print("═" * 65)
    print("  [1] تحديث الواجهة فقط (Frontend) - [0% انقطاع]")
    print("  [2] تحديث شامل ذكي (Full Deploy + Auto-Resume)")
    print("  [3] فحص حالة السيرفر والبوتات النشطة")
    print("  [4] تحديث الباك إند فقط (Backend Only + Auto-Resume)")
    print("  [5] تشغيل الحسابات تدريجياً (Resume All)")
    print("  [6] إيقاف جميع البوتات فوراً (Stop All)")
    print("  [7] تحديث شامل + إيقاف كافة البوتات (Clean Deploy)")
    print("  ─────────────────────────────────────────────")
    print("  [8] تشغيل تدريجي عشوائي لجميع الحسابات المؤهلة")
    print("  [9] إيقاف جميع البوتات فوراً")
    print(" [10] رفع ملفات الباك إند فقط (بدون إعادة تشغيل)")
    print(" [11] إلغاء التشغيل التدريجي (الشغالة تبقى)")
    print(" [12] إيقاف الكل + إعادة تشغيل تدريجي بالتحديثات")
    print("  [0] إلغاء وخروج")
    print("═" * 65)

    try:
        choice = input("👉 اختر رقم العملية: ").strip()
    except (KeyboardInterrupt, EOFError):
        print("\nتم الإلغاء.")
        return

    menu_actions = {
        "1": deploy_frontend_only,
        "2": deploy_full_smart,
        "3": check_status,
        "4": deploy_backend_only,
        "5": resume_all_castles,
        "6": stop_all_castles,
        "7": deploy_with_all_stopped,
        "8": gradual_start_all,
        "9": gradual_stop_all,
        "10": upload_only,
        "11": cancel_queue,
        "12": restart_all,
    }
    action = menu_actions.get(choice)
    if action:
        action()
    elif choice == "0":
        print("تم الخروج.")
    else:
        print("❌ خيار غير صحيح.")


if __name__ == "__main__":
    main()
