# -*- coding: utf-8 -*-
"""
deploy_logic/config.py — الإعدادات المشتركة وأدوات SSH/SFTP والضغط لنظام نشر انتقام السلاطين
═══════════════════════════════════════════════════════════════════════════════════════════
يوفر:
  1. تحميل والتحقق من إعدادات النشر عبر deploy_config.json أو متغيرات البيئة (مع عزل تام عن مشاريع أخرى).
  2. دوال SSH/SFTP مشتركة، استدعاء نقاط /api/internal/* المحمية، وفحص جاهزية الخادم.
  3. تجميع وبناء حزم الواجهة (Vite dist) والباك إند (tar.gz) مع استثناء صارم لقواعد البيانات والأسرار وملفات البروكسي.
"""

from __future__ import annotations

import json
import os
import shlex
import socket
import subprocess
import sys
import tarfile
import time
from dataclasses import dataclass
from typing import Any, Dict, Iterable, Optional, Set, Tuple

DEPLOY_DIR = os.path.dirname(os.path.abspath(__file__))
LOCAL_DIR = os.path.dirname(DEPLOY_DIR)
DEFAULT_CONFIG_PATH = os.path.join(DEPLOY_DIR, "deploy_config.json")

# ── إعدادات التدرج والتشغيل الآمن ─────────────────────────────────
RESUME_BATCH_SIZE = 10
RESUME_BATCH_DELAY_AVG = 210
RESUME_ITEM_DELAY_AVG = 12.5  # متوسط الفاصل العشوائي 10 إلى 15 ثانية

# ── قواعد استثناء المجلدات والملفات الحساسة ─────────────────────────
EXCLUDE_DIRS: Set[str] = {
    "game_file",
    "game file",
    "game files",
    "game_files",
    "scratch",
    "tests",
    "test",
    "tools",
    "sctipt_test",
    "script_test",
    "game_listener",
    "tcp_learning",
    "dashboard",
    "database",
    "docs",
    "logs",
    "reports",
    "node_modules",
    ".git",
    ".github",
    ".idea",
    ".vscode",
    "venv",
    ".venv",
    "__pycache__",
    "dumps",
    "apk_libs",
    "lua_src",
    "lua_src_backup",
    ".agents",
    "temp",
}

EXCLUDE_EXTENSIONS: Set[str] = {
    ".pyc",
    ".pyo",
    ".pyd",
    ".log",
    ".tmp",
    ".bak",
    ".apk",
    ".zip",
    ".tar",
    ".gz",
}

EXCLUDE_EXACT_FILES: Set[str] = {
    # قواعد بيانات الإنتاج وملفات الجلسات والأسرار المحلية
    "castles.db",
    "castles.db-wal",
    "castles.db-shm",
    "bot_storage.db",
    "exclude_history.db",
    "session_cache.json",
    ".env",
    "auto_resume.json",
    "deploy_config.json",
    "sniffer_log.txt",
    "exclude_history.json",
    "shared_gather_history.json",
    "user_proxy_bindings.json",
    "static_residential_proxies.json",
    "webshare_free_proxies.json",
    "webshare_proxies.json",
    "backend_dist.tar.gz",
    "backend_init.tar.gz",
    "dist.tar.gz",
}


@dataclass
class DeployConfig:
    """إعدادات الاتصال بالسيرفر المستهدف لمشروع انتقام السلاطين."""

    server_host: str = ""
    server_port: int = 22
    server_user: str = "root"
    server_password: str = ""
    ssh_key_path: str = ""
    remote_dir: str = "/var/www/intqam-sultan"
    service_name: str = "sultan-bot.service"
    nginx_conf_name: str = "nginx-sultan.conf"
    domain_name: str = "sultan.ibraabot.online"
    api_port: int = 8765
    internal_api_secret: str = ""


def _read_config_file(config_path: str = DEFAULT_CONFIG_PATH) -> Dict[str, Any]:
    if not os.path.exists(config_path):
        return {}
    try:
        with open(config_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        return data if isinstance(data, dict) else {}
    except Exception as exc:
        raise RuntimeError(f"تعذر قراءة ملف إعدادات النشر ({config_path}): {exc}") from exc


def load_deploy_config(config_path: str = DEFAULT_CONFIG_PATH, validate_target: bool = True) -> DeployConfig:
    """تحميل إعدادات النشر من deploy_config.json مع أولوية متغيرات البيئة."""
    raw = _read_config_file(config_path)

    def _pick(env_key: str, json_key: str, default: Any = "") -> Any:
        env_val = os.environ.get(env_key)
        if env_val is not None and str(env_val).strip() != "":
            return str(env_val).strip()
        val = raw.get(json_key, default)
        return default if val is None else val

    cfg = DeployConfig(
        server_host=str(_pick("SULTAN_DEPLOY_HOST", "server_host", "")).strip(),
        server_port=int(_pick("SULTAN_DEPLOY_PORT", "server_port", 22) or 22),
        server_user=str(_pick("SULTAN_DEPLOY_USER", "server_user", "root")).strip(),
        server_password=str(_pick("SULTAN_DEPLOY_PASS", "server_password", "")),
        ssh_key_path=str(_pick("SULTAN_SSH_KEY", "ssh_key_path", "")).strip(),
        remote_dir=str(_pick("SULTAN_DEPLOY_DIR", "remote_dir", "/var/www/intqam-sultan")).strip().rstrip("/") or "/var/www/intqam-sultan",
        service_name=str(_pick("SULTAN_SERVICE_NAME", "service_name", "sultan-bot.service")).strip(),
        nginx_conf_name=str(_pick("SULTAN_NGINX_CONF", "nginx_conf_name", "nginx-sultan.conf")).strip(),
        domain_name=str(_pick("SULTAN_DOMAIN", "domain_name", "sultan.ibraabot.online")).strip() or "sultan.ibraabot.online",
        api_port=int(_pick("SULTAN_API_PORT", "api_port", 8765) or 8765),
        internal_api_secret=str(_pick("SULTAN_INTERNAL_TOKEN", "internal_api_secret", "") or os.environ.get("INTERNAL_API_SECRET", "")).strip(),
    )

    if validate_target:
        validate_deploy_config(cfg)
    return cfg


def validate_deploy_config(cfg: DeployConfig) -> None:
    """التحقق الصارم من سلامة إعدادات النشر ومنع استهداف سيرفرات مشاريع أخرى بالخطأ."""
    if not cfg.server_host:
        raise RuntimeError(
            "لم يتم تحديد عنوان السيرفر (server_host) في deploy_logic/deploy_config.json!\n"
            "يرجى تعبئة بيانات خادم انتقام السلاطين في deploy_logic/deploy_config.json أو عبر SULTAN_DEPLOY_HOST قبل التنفيذ."
        )

    lowered_dir = cfg.remote_dir.lower()
    lowered_srv = cfg.service_name.lower()
    if "osmanli" in lowered_dir or lowered_srv == "empire-bot.service":
        raise RuntimeError(
            "🛑 حظر أمان: إعدادات النشر تشير إلى مسار أو خدمة بوت العثمانية! "
            "يُمنع منعاً باتاً استهداف بيئة العثمانية من مشروع انتقام السلاطين."
        )

    if not cfg.server_password and not cfg.ssh_key_path:
        raise RuntimeError(
            "لم يتم تحديد كلمة مرور (server_password) أو مسار مفتاح SSH (ssh_key_path) في deploy_logic/deploy_config.json."
        )


def get_ssh_client(cfg: DeployConfig, retries: int = 10, timeout: int = 8):
    """إنشاء اتصال SSH آمن بسيرفر انتقام السلاطين مع دعم كلمة المرور أو مفتاح SSH."""
    import paramiko

    validate_deploy_config(cfg)
    last_err: Optional[Exception] = None
    for attempt in range(1, retries + 1):
        sock = None
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(timeout)
            sock.connect((cfg.server_host, cfg.server_port))

            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            connect_kwargs: Dict[str, Any] = {
                "hostname": cfg.server_host,
                "port": cfg.server_port,
                "username": cfg.server_user,
                "sock": sock,
                "banner_timeout": 35,
                "timeout": 15,
            }
            if cfg.ssh_key_path:
                connect_kwargs["key_filename"] = os.path.expanduser(cfg.ssh_key_path)
            if cfg.server_password:
                connect_kwargs["password"] = cfg.server_password

            client.connect(**connect_kwargs)
            return client
        except Exception as exc:
            last_err = exc
            if sock:
                try:
                    sock.close()
                except Exception:
                    pass
            if attempt < retries:
                time.sleep(2)
    raise RuntimeError(f"❌ فشل الاتصال بالسيرفر ({cfg.server_host}:{cfg.server_port}) بعد {retries} محاولات: {last_err}")


def ssh_run(client, cmd: str, timeout: int = 35, include_stderr: bool = False) -> str:
    """تنفيذ أمر SSH وإرجاع الناتج النصي مع مهلة زمنية صارمة."""
    try:
        _stdin, stdout, stderr = client.exec_command(cmd, timeout=timeout)
        stdout.channel.recv_exit_status()
        out = stdout.read().decode("utf-8", errors="replace").strip()
        if include_stderr and not out:
            return stderr.read().decode("utf-8", errors="replace").strip()
        return out
    except Exception:
        return ""


def call_internal_api(
    client,
    cfg: DeployConfig,
    method: str,
    path: str,
    timeout: int = 20,
) -> str:
    """تنفيذ طلب HTTP محلي على الباك إند داخل السيرفر عبر curl مع ترويسة الحماية الداخلية إن وجدت."""
    clean_path = path if path.startswith("/") else f"/{path}"
    url = f"http://127.0.0.1:{cfg.api_port}{clean_path}"
    method_flag = "-X POST " if method.upper() == "POST" else ""
    token_hdr = ""
    if cfg.internal_api_secret:
        token_hdr = f"-H {shlex.quote(f'X-Internal-Token: {cfg.internal_api_secret}')} "
    cmd = f"curl -s -m {max(5, timeout - 3)} {method_flag}{token_hdr}{shlex.quote(url)} || true"
    return ssh_run(client, cmd, timeout=timeout)


def deploy_lock(client, cfg: DeployConfig) -> str:
    """تفعيل وضع النشر (Deploy Lock) — يمنع أي تشغيل جديد أثناء التحديث."""
    resp = call_internal_api(client, cfg, "POST", "/api/internal/deploy-lock", timeout=15)
    print(f"   🔒 Deploy Lock: {resp}")
    return resp


def deploy_unlock(client, cfg: DeployConfig) -> str:
    """فتح وضع النشر (Deploy Unlock)."""
    resp = call_internal_api(client, cfg, "POST", "/api/internal/deploy-unlock", timeout=15)
    print(f"   🔓 Deploy Unlock: {resp}")
    return resp


def stop_service_cleanly(client, cfg: DeployConfig) -> str:
    """إيقاف خدمة المشروع فقط بأمان دون المساس بأي عمليات لمشاريع أخرى."""
    proc_pattern = shlex.quote(f"{cfg.remote_dir}/api_server.py")
    svc = shlex.quote(cfg.service_name)
    ssh_run(client, f"systemctl stop {svc} || true; pkill -9 -f {proc_pattern} || true; sleep 1", timeout=30)
    return ssh_run(client, f"systemctl is-active {svc} || true", timeout=15)


def wait_for_api_health(client, cfg: DeployConfig, max_wait_sec: int = 35) -> Tuple[bool, str]:
    """الانتظار حتى إقلاع FastAPI واستجابة /api/health بنجاح."""
    health = ""
    for sec in range(1, max_wait_sec + 1):
        time.sleep(1)
        health = call_internal_api(client, cfg, "GET", "/api/health", timeout=12)
        if health and ('"ok"' in health or '"online"' in health):
            return True, health
        if sec % 5 == 0:
            print(f"   ⏳ جاري انتظار إقلاع الخادم... ({sec}/{max_wait_sec}ث)")
    return False, health


def restart_service_and_wait(client, cfg: DeployConfig) -> bool:
    """إعادة تشغيل خدمة systemd لتحميل آخر كود والانتظار حتى الجاهزية."""
    print(f"\n🔄 إعادة تشغيل الخدمة ({cfg.service_name}) لتحميل آخر كود...")
    svc = shlex.quote(cfg.service_name)
    proc_pattern = shlex.quote(f"{cfg.remote_dir}/api_server.py")
    ssh_run(client, f"systemctl daemon-reload; pkill -9 -f {proc_pattern} 2>/dev/null || true; systemctl restart {svc}; sleep 2", timeout=40)
    status = ssh_run(client, f"systemctl is-active {svc} || true", timeout=15)
    print(f"   حالة الخدمة: {status}")
    print(f"🔍 انتظار اكتمال إقلاع الخدمة على المنفذ {cfg.api_port}...")
    ok, health = wait_for_api_health(client, cfg, max_wait_sec=35)
    if ok:
        print(f"   ✅ الخدمة جاهزة ومستقرة: {health}")
        return True
    print(f"   ❌ الخدمة لم تستجب خلال المهلة ({health or 'no response'}).")
    return False


def build_frontend_dist() -> bool:
    """بناء حزمة الواجهة الأمامية محلياً عبر Vite (dashboard/dist)."""
    print("\n📦 [1/3] جاري بناء حزمة الواجهة الأمامية (Vite)...")
    dash_dir = os.path.join(LOCAL_DIR, "dashboard")
    cmd = "npm run build" if sys.platform != "win32" else "cmd.exe /c npm run build"
    res = subprocess.run(cmd, cwd=dash_dir, shell=True, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if res.returncode != 0:
        print(f"❌ فشل بناء الواجهة الأمامية:\n{res.stderr or res.stdout}")
        return False
    print("✅ تم بناء الواجهة بنجاح في مجلد dashboard/dist.")
    return True


def upload_frontend_bundle(client, cfg: DeployConfig, reload_nginx: bool = True) -> bool:
    """ضغط مجلد dashboard/dist ورفعه وفك ضغطه على السيرفر."""
    print("\n🚀 ضغط ورفع حزمة الواجهة إلى السيرفر...")
    local_dist = os.path.join(LOCAL_DIR, "dashboard", "dist")
    tar_path = os.path.join(LOCAL_DIR, "dashboard", "dist.tar.gz")

    if not os.path.exists(local_dist):
        print("❌ مجلد dashboard/dist غير موجود! نفّذ npm run build أولاً.")
        return False

    if os.path.exists(tar_path):
        try:
            os.remove(tar_path)
        except Exception:
            pass

    with tarfile.open(tar_path, "w:gz") as tar:
        tar.add(local_dist, arcname=".")

    remote_dash = f"{cfg.remote_dir}/dashboard"
    ssh_run(client, f"mkdir -p {shlex.quote(remote_dash + '/dist')}", timeout=20)
    sftp = client.open_sftp()
    remote_tar = f"{remote_dash}/dist.tar.gz"
    sftp.put(tar_path, remote_tar)
    sftp.close()

    try:
        os.remove(tar_path)
    except Exception:
        pass

    reload_cmd = " && systemctl reload nginx" if reload_nginx else ""
    extract_cmd = (
        f"mkdir -p {shlex.quote(remote_dash + '/dist')} && "
        f"tar -xzf {shlex.quote(remote_tar)} -C {shlex.quote(remote_dash + '/dist')} && "
        f"rm -f {shlex.quote(remote_tar)}{reload_cmd}"
    )
    ssh_run(client, extract_cmd, timeout=60)
    print("✅ تم استخراج الواجهة بنجاح على السيرفر.")
    return True


def should_exclude_dir(dir_name: str) -> bool:
    d = dir_name.lower().strip()
    return d in EXCLUDE_DIRS or d.startswith(".git") or d.startswith("__pycache__")


def should_exclude_file(file_name: str, extra_exact: Optional[Iterable[str]] = None) -> bool:
    fn = file_name.lower().strip()
    if fn in EXCLUDE_EXACT_FILES:
        return True
    if extra_exact and fn in extra_exact:
        return True
    if any(fn.endswith(ext) for ext in EXCLUDE_EXTENSIONS):
        return True
    if fn.endswith(".sqlite3") or fn.endswith(".db") or fn.endswith(".db-wal") or fn.endswith(".db-shm"):
        return True
    if ".db.bak" in fn:
        return True
    return False


def create_backend_bundle(bundle_name: str = "backend_dist.tar.gz", exclude_proxy_json: bool = True) -> Tuple[str, int]:
    """تجميع ذري مضغوط لملفات الباك إند مع تطبيق قواعد الاستبعاد الصارمة."""
    tar_path = os.path.join(DEPLOY_DIR, bundle_name)
    if os.path.exists(tar_path):
        try:
            os.remove(tar_path)
        except Exception:
            pass

    packed_count = 0
    with tarfile.open(tar_path, "w:gz") as tar:
        for root, dirs, files in os.walk(LOCAL_DIR):
            dirs[:] = [d for d in dirs if not should_exclude_dir(d)]

            rel_root = os.path.relpath(root, LOCAL_DIR)
            if rel_root != "." and any(should_exclude_dir(part) for part in rel_root.replace("\\", "/").split("/")):
                continue

            for fname in files:
                if should_exclude_file(fname):
                    continue

                full_path = os.path.join(root, fname)
                rel_path = os.path.relpath(full_path, LOCAL_DIR).replace("\\", "/")

                path_parts = rel_path.split("/")
                if any(should_exclude_dir(p) for p in path_parts[:-1]):
                    continue

                # منع استبدال ملفات الكاش وارتباطات البروكسي الحية في بيئة الإنتاج أثناء التحديثات
                if exclude_proxy_json and rel_path.startswith("proxy/") and rel_path.endswith(".json"):
                    continue

                tar.add(full_path, arcname=rel_path)
                packed_count += 1

    return tar_path, packed_count
