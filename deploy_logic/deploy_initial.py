# -*- coding: utf-8 -*-
"""
deploy_initial.py — أداة النشر والتهيئة الأولية لخادم انتقام السلاطين الجديد
═════════════════════════════════════════════════════════════════════════════
طريقة الاستخدام:
  python deploy_logic/deploy_initial.py --init           # تهيئة ونشر أولي شامل من الصفر
  python deploy_logic/deploy_initial.py --db-only        # رفع وتحديث قاعدة البيانات وملفات التهيئة فقط
  python deploy_logic/deploy_initial.py --backend-only   # رفع وتحديث كود الباك إند فقط
  python deploy_logic/deploy_initial.py --frontend-only  # بناء ورفع الواجهة الأمامية فقط
  python deploy_logic/deploy_initial.py --resume         # تشغيل واستئناف الحسابات المؤهلة تدريجياً
  python deploy_logic/deploy_initial.py --check          # فحص حالة السيرفر والخدمات
"""

from __future__ import annotations

import argparse
import os
import shlex
import sys
import tarfile
import time

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
    build_frontend_dist,
    call_internal_api,
    get_ssh_client,
    load_deploy_config,
    should_exclude_dir,
    should_exclude_file,
    ssh_run,
    stop_service_cleanly,
    upload_frontend_bundle,
    wait_for_api_health,
)


def setup_system_prerequisites(client, cfg: DeployConfig) -> None:
    """تثبيت الحزم الأساسية للنظام وإعداد البيئة من الصفر على السيرفر الجديد."""
    print("\n🛠️ [1/7] تثبيت الحزم الأساسية وإعداد نظام التشغيل (Nginx, Python3, Venv, SQLite3)...")
    r_dir = shlex.quote(cfg.remote_dir)
    cmd = (
        "export DEBIAN_FRONTEND=noninteractive && "
        "apt-get update -y && "
        "apt-get install -y python3 python3-pip python3-venv python3-dev nginx curl git build-essential sqlite3 libsqlite3-dev && "
        f"mkdir -p {r_dir}/database {r_dir}/dashboard/dist {r_dir}/core {r_dir}/tasks {r_dir}/proxy"
    )
    ssh_run(client, cmd, timeout=300)
    print("✅ تم تثبيت حزم النظام وإنشاء مسارات المشروع الرئيسية.")

    print("🐍 [2/7] إنشاء البيئة الافتراضية للبايثون (venv)...")
    venv_q = shlex.quote(f"{cfg.remote_dir}/venv")
    venv_cmd = (
        f"if [ ! -d {venv_q} ]; then python3 -m venv {venv_q}; fi && "
        f"{shlex.quote(cfg.remote_dir + '/venv/bin/pip')} install --upgrade pip"
    )
    ssh_run(client, venv_cmd, timeout=180)
    print(f"✅ تم تجهيز البيئة الافتراضية {cfg.remote_dir}/venv بنجاح.")


def create_and_upload_backend(client, cfg: DeployConfig) -> None:
    """حزم ملفات الباك إند الأساسية والخدمة ورفعها ذرياً في التهيئة الأولية."""
    print("\n🐍 [3/7] حزم ورفع ملفات الباك إند والملفات المرجعية...")
    tar_path = os.path.join(DEPLOY_DIR, "backend_init.tar.gz")
    if os.path.exists(tar_path):
        try:
            os.remove(tar_path)
        except Exception:
            pass

    included_folders = ["core", "tasks", "proxy"]
    included_root_files = [
        "api_server.py",
        "bot_manager.py",
        "firebase_service_account.json",
        "GEMINI.md",
        "PROJECT_STRUCTURE.md",
        "requirements.txt",
    ]

    packed_count = 0
    with tarfile.open(tar_path, "w:gz") as tar:
        for rf in included_root_files:
            lpath = os.path.join(LOCAL_DIR, rf)
            if os.path.exists(lpath):
                tar.add(lpath, arcname=rf)
                packed_count += 1

        for cfg_name in (cfg.nginx_conf_name, cfg.service_name):
            cfg_path = os.path.join(DEPLOY_DIR, cfg_name)
            if os.path.exists(cfg_path):
                tar.add(cfg_path, arcname=cfg_name)
                packed_count += 1

        for folder in included_folders:
            folder_path = os.path.join(LOCAL_DIR, folder)
            if not os.path.exists(folder_path):
                continue
            for root, dirs, files in os.walk(folder_path):
                dirs[:] = [d for d in dirs if not should_exclude_dir(d)]
                for fname in files:
                    if should_exclude_file(fname):
                        continue
                    # حماية ارتباطات البروكسي الشخصية من التسرب لبيئة جديدة عند التهيئة الأولية
                    if folder == "proxy" and fname == "user_proxy_bindings.json":
                        continue
                    full_f = os.path.join(root, fname)
                    rel_f = os.path.relpath(full_f, LOCAL_DIR).replace("\\", "/")
                    tar.add(full_f, arcname=rel_f)
                    packed_count += 1

    tar_size_mb = os.path.getsize(tar_path) / (1024 * 1024)
    print(f"   تم حزم {packed_count} ملفاً بحجم إجمالي: {tar_size_mb:.2f} MB")

    print("🚀 رفع حزمة الباك إند إلى السيرفر...")
    r_dir_q = shlex.quote(cfg.remote_dir)
    ssh_run(client, f"mkdir -p {r_dir_q}", timeout=20)
    sftp = client.open_sftp()
    remote_tar = f"{cfg.remote_dir}/backend_init.tar.gz"
    sftp.put(tar_path, remote_tar)
    sftp.close()

    try:
        os.remove(tar_path)
    except Exception:
        pass

    remote_tar_q = shlex.quote(remote_tar)
    ssh_run(client, f"tar -xzf {remote_tar_q} -C {r_dir_q} && rm -f {remote_tar_q}", timeout=60)
    print("✅ تم استخراج وتحديث كافة ملفات الباك إند على السيرفر بنجاح.")


def upload_database_and_data_files(client, cfg: DeployConfig) -> None:
    """رفع database/castles.db وملفات التهيئة مع تصفير الحالات العالقة بأسماء أعمدة المشروع."""
    print("\n🗄️ [4/7] رفع قاعدة البيانات وملفات التهيئة المرجعية (database/)...")
    db_dir = os.path.join(LOCAL_DIR, "database")
    remote_db_dir = f"{cfg.remote_dir}/database"
    ssh_run(client, f"mkdir -p {shlex.quote(remote_db_dir)}", timeout=20)

    sftp = client.open_sftp()
    local_db = os.path.join(db_dir, "castles.db")
    if not os.path.exists(local_db) or os.path.getsize(local_db) == 0:
        local_db = os.path.join(LOCAL_DIR, "castles.db")

    if os.path.exists(local_db) and os.path.getsize(local_db) > 0:
        file_size = os.path.getsize(local_db)
        size_mb = file_size / (1024 * 1024)
        print(f"   ⬆️ قاعدة البيانات الرئيسية (castles.db) بحجم: {size_mb:.2f} MB")

        last_printed = [0]

        def _progress(transferred: int, total: int) -> None:
            pct = int((transferred / max(1, total)) * 100)
            if pct >= last_printed[0] + 15 or pct == 100:
                last_printed[0] = pct
                mb_done = transferred / (1024 * 1024)
                sys.stdout.write(f"\r      التقدم: {pct}% ({mb_done:.1f}/{size_mb:.1f} MB)")
                sys.stdout.flush()

        sftp.put(local_db, f"{remote_db_dir}/castles.db", callback=_progress)
        print("\n   ✅ تم رفع castles.db بنجاح.")
    else:
        print("⚠️ لم يتم العثور على castles.db صالحة محلياً!")

    if os.path.exists(db_dir):
        for fname in os.listdir(db_dir):
            if fname in ("castles.db", "bot.db", "bot_storage.db") or should_exclude_file(fname):
                continue
            lf = os.path.join(db_dir, fname)
            if os.path.isfile(lf):
                sftp.put(lf, f"{remote_db_dir}/{fname}")
                print(f"   📄 database/{fname}")
    sftp.close()

    remote_db_q = shlex.quote(f"{remote_db_dir}/castles.db")
    clean_sql = (
        f"sqlite3 {remote_db_q} \""
        "UPDATE castle_states SET state='idle', conn_state='idle', status_message='جاهز للتشغيل' "
        "WHERE conn_state IN ('connecting', 'connected', 'running', 'starting', 'waiting', 'deploying', 'reconnecting') "
        "OR state IN ('running', 'deploying');\" 2>/dev/null || true"
    )
    ssh_run(client, clean_sql, timeout=20)
    print("✅ تم تصفير أي حالات اتصال قديمة عالقة لتشغيل هادئ.")


def install_python_requirements(client, cfg: DeployConfig) -> None:
    """تثبيت مكتبات البايثون في بيئة venv على السيرفر."""
    print("\n📦 [5/7] تثبيت متطلبات البايثون (pip requirements)...")
    pip_q = shlex.quote(f"{cfg.remote_dir}/venv/bin/pip")
    req_q = shlex.quote(f"{cfg.remote_dir}/requirements.txt")
    ssh_run(client, f"{pip_q} install --no-cache-dir -r {req_q}", timeout=300)
    print("✅ تم تثبيت مكتبات البايثون بنجاح.")


def configure_and_start_services(client, cfg: DeployConfig) -> None:
    """إعداد وتشغيل خدمات Nginx و Systemd على السيرفر."""
    print("\n⚙️ [6/7] إعداد وتشغيل خدمات النظام (Nginx & Systemd)...")
    svc_src = shlex.quote(f"{cfg.remote_dir}/{cfg.service_name}")
    svc_dst = shlex.quote(f"/etc/systemd/system/{cfg.service_name}")
    svc_q = shlex.quote(cfg.service_name)
    ssh_run(
        client,
        f"cp {svc_src} {svc_dst} && systemctl daemon-reload && systemctl enable {svc_q} && systemctl restart {svc_q}",
        timeout=45,
    )

    ngx_src = shlex.quote(f"{cfg.remote_dir}/{cfg.nginx_conf_name}")
    ngx_avail = shlex.quote(f"/etc/nginx/sites-available/{cfg.nginx_conf_name}")
    ngx_enabled = shlex.quote(f"/etc/nginx/sites-enabled/{cfg.nginx_conf_name}")
    ssh_run(
        client,
        f"cp -f {ngx_src} {ngx_avail} && ln -sf {ngx_avail} {ngx_enabled} && nginx -t && (systemctl reload nginx || systemctl restart nginx)",
        timeout=30,
    )

    time.sleep(2)
    status = ssh_run(client, f"systemctl is-active {svc_q} || true", timeout=15)
    print(f"   حالة خدمة البوت ({cfg.service_name}): {status}")

    print("\n🔍 [7/7] التحقق من استجابة خادم البوت والواجهة...")
    ok, health = wait_for_api_health(client, cfg, max_wait_sec=20)
    print(f"   استجابة فحص الصحة (/api/health -> {'OK' if ok else 'WAIT'}): {health}")


def launch_approved_castles(client, cfg: DeployConfig) -> None:
    """تشغيل كافة الحسابات المؤهلة تدريجياً وبأمان (فاصل عشوائي 5-10 ثوانٍ)."""
    print("\n🚀 تشغيل واستئناف الحسابات المؤهلة تدريجياً وبأمان...")
    resume_resp = call_internal_api(client, cfg, "POST", "/api/internal/gradual-start", timeout=35)
    print(f"   استجابة خادم التشغيل التدريجي: {resume_resp}")

    db_path_q = shlex.quote(f"{cfg.remote_dir}/database/castles.db")
    count_active = ssh_run(client, f"sqlite3 {db_path_q} \"SELECT COUNT(*) FROM castle_states WHERE is_active=1;\" 2>/dev/null || true", timeout=15)
    try:
        active_num = int(count_active)
        print(f"📊 إجمالي الحسابات المؤهلة في قاعدة البيانات: {active_num} حساب")
        print("⏳ التشغيل التدريجي الآمن: حساب كل 5 إلى 10 ثوانٍ لمنع ضغط السيرفر أو حظر الحسابات.")
    except Exception:
        pass
    print("✅ تم إطلاق مهمة التشغيل التدريجي بنجاح في الخلفية على السيرفر.")


def run_full_initial_deployment() -> None:
    cfg = load_deploy_config()
    print("\n" + "═" * 70)
    print(f"🌐 بدء النشر والتهيئة الأولية الشاملة لسيرفر انتقام السلاطين: {cfg.server_host}")
    print("═" * 70)

    client = get_ssh_client(cfg)
    try:
        setup_system_prerequisites(client, cfg)
        if build_frontend_dist():
            upload_frontend_bundle(client, cfg, reload_nginx=False)
        create_and_upload_backend(client, cfg)
        upload_database_and_data_files(client, cfg)
        install_python_requirements(client, cfg)
        configure_and_start_services(client, cfg)
    finally:
        client.close()

    print("\n" + "═" * 70)
    print(f"🎉 اكتمل النشر الأولي للسيرفر الجديد {cfg.server_host} بنجاح تام!")
    print("🛑 جميع البوتات متوقفة حالياً وهادئة (idle).")
    print(f"🌐 لوحة التحكم متاحة عبر: https://{cfg.domain_name}")
    print("👉 لتشغيل الحسابات تدريجياً وبأمان، نفذ:")
    print("   python deploy_logic/deploy_initial.py --resume")
    print("═" * 70)


def upload_db_only() -> None:
    cfg = load_deploy_config()
    print("\n" + "═" * 70)
    print(f"🗄️ رفع قاعدة البيانات وملفات التهيئة إلى {cfg.server_host} فقط...")
    print("═" * 70)
    client = get_ssh_client(cfg)
    try:
        print("🛑 إيقاف خدمة البوت مؤقتاً لضمان سلامة النقل...")
        stop_service_cleanly(client, cfg)
        upload_database_and_data_files(client, cfg)
        print("🔄 إعادة تشغيل خدمة البوت...")
        ssh_run(client, f"systemctl restart {shlex.quote(cfg.service_name)}", timeout=30)
    finally:
        client.close()
    print("\n✅ تم تحديث قاعدة البيانات بنجاح.")


def upload_backend_only() -> None:
    cfg = load_deploy_config()
    print("\n" + "═" * 70)
    print(f"🐍 رفع وتحديث كود الباك إند فقط إلى {cfg.server_host}...")
    print("═" * 70)
    client = get_ssh_client(cfg)
    try:
        create_and_upload_backend(client, cfg)
        print(f"🔄 إعادة تشغيل خدمة {cfg.service_name}...")
        ssh_run(client, f"systemctl restart {shlex.quote(cfg.service_name)}", timeout=30)
    finally:
        client.close()
    print("\n✅ تم تحديث كود الباك إند بنجاح.")


def upload_frontend_only() -> None:
    cfg = load_deploy_config()
    print("\n" + "═" * 70)
    print(f"📦 بناء ورفع الواجهة الأمامية فقط إلى {cfg.server_host}...")
    print("═" * 70)
    if not build_frontend_dist():
        return
    client = get_ssh_client(cfg)
    try:
        upload_frontend_bundle(client, cfg, reload_nginx=True)
    finally:
        client.close()
    print("\n✅ تم تحديث الواجهة الأمامية بنجاح.")


def check_server_status() -> None:
    cfg = load_deploy_config()
    print("\n" + "═" * 70)
    print(f"🔍 فحص حالة السيرفر الجديد {cfg.server_host}...")
    print("═" * 70)
    client = get_ssh_client(cfg)
    try:
        svc_q = shlex.quote(cfg.service_name)
        db_q = shlex.quote(f"{cfg.remote_dir}/database/castles.db")
        svc_st = ssh_run(client, f"systemctl is-active {svc_q} || true", timeout=15)
        health = call_internal_api(client, cfg, "GET", "/api/health", timeout=12)
        db_st = ssh_run(client, f"sqlite3 {db_q} 'SELECT conn_state, count(*) FROM castle_states GROUP BY conn_state;' 2>/dev/null || true", timeout=15)
        print(f"\nالخدمة: {svc_st}\nالصحة: {health}\nقاعدة البيانات:\n{db_st}\n")
    finally:
        client.close()


def _resume_action() -> None:
    cfg = load_deploy_config()
    client = get_ssh_client(cfg)
    try:
        launch_approved_castles(client, cfg)
    finally:
        client.close()


def main() -> None:
    parser = argparse.ArgumentParser(description="أداة النشر والتهيئة الأولية لسيرفر انتقام السلاطين")
    parser.add_argument("--init", "-1", action="store_true", help="تهيئة ونشر أولي شامل للسيرفر الجديد")
    parser.add_argument("--db-only", "-2", action="store_true", help="رفع وتحديث قاعدة البيانات وملفات التهيئة فقط")
    parser.add_argument("--backend-only", "-3", action="store_true", help="رفع وتحديث كود الباك إند فقط")
    parser.add_argument("--frontend-only", "-4", action="store_true", help="بناء ورفع الواجهة الأمامية فقط")
    parser.add_argument("--resume", "-5", action="store_true", help="تشغيل واستئناف الحسابات المؤهلة تدريجياً")
    parser.add_argument("--check", "-6", action="store_true", help="فحص حالة السيرفر والخدمات")
    args = parser.parse_args()

    flag_actions = [
        (args.init, run_full_initial_deployment),
        (args.db_only, upload_db_only),
        (args.backend_only, upload_backend_only),
        (args.frontend_only, upload_frontend_only),
        (args.resume, _resume_action),
        (args.check, check_server_status),
    ]
    for enabled, handler in flag_actions:
        if enabled:
            handler()
            return

    print("\n" + "═" * 70)
    print("🚀 أداة النشر والتهيئة الأولية لسيرفر انتقام السلاطين")
    print("═" * 70)
    print("  [1] تهيئة ونشر أولي شامل (Setup + Frontend + Backend + DB + Services)")
    print("  [2] رفع وتحديث قاعدة البيانات المحلية وملفات التهيئة فقط")
    print("  [3] رفع وتحديث كود الباك إند فقط")
    print("  [4] بناء ورفع الواجهة الأمامية (Dashboard Dist) فقط")
    print("  [5] تشغيل واستئناف الحسابات المؤهلة تدريجياً الآن")
    print("  [6] فحص حالة السيرفر والخدمات والبوتات")
    print("  [0] إلغاء وخروج")
    print("═" * 70)

    try:
        choice = input("👉 اختر رقم العملية: ").strip()
    except (KeyboardInterrupt, EOFError):
        print("\nتم الإلغاء.")
        return

    menu_actions = {
        "1": run_full_initial_deployment,
        "2": upload_db_only,
        "3": upload_backend_only,
        "4": upload_frontend_only,
        "5": _resume_action,
        "6": check_server_status,
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
