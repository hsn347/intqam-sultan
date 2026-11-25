# -*- coding: utf-8 -*-
"""
api_server.py — خادم FastAPI لإدارة ومراقبة بوتات انتقام السلاطين (Revenge of Sultans)
═════════════════════════════════════════════════════════════════════════════════════
يستقبل أوامر من لوحة التحكم (React / Vite) ويدير دورة حياة الحسابات عبر bot_manager.py.
يعتمد كلياً على SQLite المحلية (database/castles.db) و session_cache.json.
مستقل بنسبة 100% عن المحاكيات ولا يحتاج أي ADB أو Frida.

التشغيل:
  python api_server.py
  python api_server.py --port 8765
═════════════════════════════════════════════════════════════════════════════════════
"""

from __future__ import annotations

import argparse
import asyncio
from collections import defaultdict
from contextlib import asynccontextmanager
import copy
import json
import logging
import os
import queue
import random
import re
import sys
import threading
import time
from datetime import datetime, timezone, timedelta
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

_ROOT = os.path.dirname(os.path.abspath(__file__))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from fastapi import (
    FastAPI,
    Request,
    WebSocket,
    WebSocketDisconnect,
    HTTPException,
    Depends,
    Security,
    Query,
    status,
)
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel, Field
import uvicorn

import core.database as db
from core.tenants import (
    get_all_merchants,
    get_tenant_by_domain,
    get_tenant_by_id,
    get_tenant_by_admin_email,
    is_merchant_admin,
    is_super_admin,
    clean_domain,
    is_user_allowed_for_tenant_domain,
)
from bot_manager import BotManager, CastleBot
from core.game_client import RosClient, SessionCache, ERROR_CODES

# ── Logging ───────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s][%(levelname)s][%(name)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("api_server")

_LOGS_DIR = os.path.join(_ROOT, "logs")
os.makedirs(_LOGS_DIR, exist_ok=True)

# ── تهيئة قاعدة البيانات المحلية ────────────────────────────────────
db.init_db()

# ── إدارة النشر الذكي والتشغيل التدريجي الآمن (Deploy & Auto-Resume) ──
_AUTO_RESUME_FILE = os.path.join(_ROOT, "auto_resume.json")
INTERNAL_API_SECRET = os.environ.get("INTERNAL_API_SECRET", "sultan_internal_secret_key_2026")
_deploy_mode: bool = False
_gradual_running: bool = False
_deploying_cids: Set[str] = set()
_deploying_emails: Set[str] = set()
_gradual_cancel_event: Optional[asyncio.Event] = None
_gradual_task: Optional[asyncio.Task] = None
_auto_resume_task: Optional[asyncio.Task] = None


def _read_auto_resume_file() -> List[Dict[str, Any]]:
    if not os.path.exists(_AUTO_RESUME_FILE):
        return []
    try:
        with open(_AUTO_RESUME_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except Exception as exc:
        log.warning(f"⚠️ تعذر قراءة auto_resume.json: {exc}")
        return []


# ── تسوية وتصفير حالات القلاع السابقة مع حفظ القلاع المجدولة في auto_resume.json ──
try:
    _startup_resume_items = _read_auto_resume_file()
    _startup_resume_cids = [str(x.get("castle_id")).strip() for x in _startup_resume_items if isinstance(x, dict) and x.get("castle_id")]
    if _startup_resume_cids:
        _deploy_mode = True
        _deploying_cids.update(_startup_resume_cids)
        _deploying_emails.update(
            str(x.get("email")).strip().lower()
            for x in _startup_resume_items
            if isinstance(x, dict) and x.get("email")
        )
    _cleaned = db.reset_stuck_castles_db(exclude_castle_ids=_startup_resume_cids or None)
    log.info(
        f"✓ تمت تسوية حالات القلاع العالقة عند بدء التشغيل (تنظيف: {_cleaned}، بانتظار الاستئناف: {len(_startup_resume_cids)})."
    )
except Exception as _reconcile_err:
    log.warning(f"تعذر تصفير حالات القلاع العالقة عند بدء التشغيل: {_reconcile_err}")

# ── إدارة البوتات المركزية ─────────────────────────────────────────
bot_manager = BotManager()

# طوابير السجلات الحية للـ WebSockets
_log_queues: Dict[str, "queue.Queue[str]"] = {}
_log_lock = threading.Lock()
# كاش الذاكرة اللحظي لحالات القلاع الخاملة لحماية SQLite من الاستعلام المتكرر كل ثانيتين
_ws_idle_status_cache: Dict[str, Tuple[float, Dict[str, Any]]] = {}


def _invalidate_ws_status_cache(castle_ids: Optional[Iterable[str]] = None) -> None:
    if castle_ids is None:
        _ws_idle_status_cache.clear()
        return
    for cid in castle_ids:
        _ws_idle_status_cache.pop(str(cid), None)


def _set_deploying_marks(castles: Iterable[Dict[str, Any]], message: str) -> List[str]:
    cids: List[str] = []
    for c in castles:
        cid = str(c.get("castle_id", "")).strip()
        em = str(c.get("email", "")).strip().lower()
        if cid:
            cids.append(cid)
            _deploying_cids.add(cid)
        if em:
            _deploying_emails.add(em)
    if cids:
        db.set_castles_deploying_db(cids, message=message)
        _invalidate_ws_status_cache(cids)
    return cids


def _clear_deploying_mark(castle_id: Optional[str] = None, email: Optional[str] = None) -> None:
    if castle_id:
        _deploying_cids.discard(str(castle_id).strip())
        _invalidate_ws_status_cache([str(castle_id).strip()])
    if email:
        _deploying_emails.discard(str(email).strip().lower())


def _get_or_create_log_queue(identifier: str) -> "queue.Queue[str]":
    with _log_lock:
        if identifier not in _log_queues:
            _log_queues[identifier] = queue.Queue(maxsize=1000)
        return _log_queues[identifier]

def _push_log(identifier: str, msg: str):
    with _log_lock:
        q = _log_queues.get(identifier)
        if q:
            try:
                q.put_nowait(msg)
            except queue.Full:
                try:
                    q.get_nowait()
                    q.put_nowait(msg)
                except Exception:
                    pass

# ══════════════════════════════════════════════════════════════════
# دوال التشغيل التدريجي والاستئناف التلقائي بعد النشر (Async Deploy Logic)
# ══════════════════════════════════════════════════════════════════

def _interleave_shuffle(castles: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """خلط عشوائي ذكي بنظام Round-Robin لمنع تتالي حسابات نفس المستخدم عند الإقلاع."""
    groups: Dict[str, List[Dict[str, Any]]] = defaultdict(list)
    for c in castles:
        groups[str(c.get("user_id") or "unknown")].append(c)
    for g in groups.values():
        random.shuffle(g)
    queues = list(groups.values())
    random.shuffle(queues)
    result: List[Dict[str, Any]] = []
    while queues:
        for q in queues:
            if q:
                result.append(q.pop(0))
        queues = [q for q in queues if q]
    return result


def _collect_eligible_castles() -> List[Dict[str, Any]]:
    """جمع جميع الحسابات المؤهلة للتشغيل التدريجي (موافق عليها + اشتراك صالح + نشطة + غير محظورة)."""
    eligible: List[Dict[str, Any]] = []
    sub_cache: Dict[str, Tuple[bool, str]] = {}
    user_cache: Dict[str, Optional[Dict[str, Any]]] = {}
    per_user_eligible_count: Dict[str, int] = defaultdict(int)
    for c in db.get_all_castles():
        cid = str(c.get("castle_id", "")).strip()
        uid = str(c.get("user_id", "")).strip()
        em = str(c.get("email", "")).strip()
        if not cid or not em or not c.get("is_active", 1):
            continue
        c_st = str(c.get("state", "")).lower()
        conn_st = str(c.get("conn_state", "")).lower()
        if c_st in ("pending", "rejected", "error", "sealed", "banned"):
            continue
        if conn_st in ("error", "sealed", "sealed_banned", "banned"):
            continue
        if uid:
            if uid not in sub_cache:
                sub_cache[uid] = db.check_user_subscription_db(uid)
            if not sub_cache[uid][0]:
                continue
            if uid not in user_cache:
                user_cache[uid] = db.get_user(uid)
            owner = user_cache[uid]
            if owner and not is_super_admin(owner):
                max_allowed = max(0, int(owner.get("max_castles") or 0))
                if per_user_eligible_count[uid] >= max_allowed:
                    continue
                per_user_eligible_count[uid] += 1
        raw_cfg = c.get("config") or {}
        if isinstance(raw_cfg, str):
            try:
                raw_cfg = json.loads(raw_cfg) if raw_cfg.strip() else {}
            except Exception:
                raw_cfg = {}
        eligible.append({
            "castle_id": cid,
            "user_id": uid,
            "email": em,
            "password": c.get("password", ""),
            "config": raw_cfg,
            "loop_interval": db.normalize_loop_interval(c.get("loop_interval")),
        })
    return eligible


async def _launch_castle_via_manager(castle: Dict[str, Any]) -> bool:
    """تشغيل قلعة واحدة عبر bot_manager مع تحديث الحالة في الذاكرة و SQLite."""
    cid = str(castle.get("castle_id", "")).strip()
    em = str(castle.get("email", "")).strip()
    uid = str(castle.get("user_id", "")).strip()
    if not cid or not em:
        return False

    existing = bot_manager.get_bot(em)
    if existing and existing.is_running:
        _clear_deploying_mark(cid, em)
        return False

    _get_or_create_log_queue(cid)
    _clear_deploying_mark(cid, em)
    started = await bot_manager.start_bot(
        em,
        config=castle.get("config") if isinstance(castle.get("config"), dict) else {},
        password=castle.get("password", ""),
        castle_id=cid,
        user_id=uid,
        loop_interval=castle.get("loop_interval"),
        log_callback=lambda m, cid_ref=cid, em_ref=em: (
            _push_log(cid_ref, m),
            _push_log(em_ref, m) if cid_ref != em_ref else None,
        ),
    )
    if started:
        db.upsert_castle_conn_state(
            castle_id=cid,
            conn_state="starting",
            state="running",
            status_message="جاري الاتصال واستئناف العمل...",
        )
        _invalidate_ws_status_cache([cid])
    return bool(started)


async def _wait_gradual_delay(cancel_event: asyncio.Event, delay_sec: float) -> bool:
    """انتظار قابل للإلغاء الفوري بين الحسابات. يُعيد True إذا تم الإلغاء."""
    try:
        await asyncio.wait_for(cancel_event.wait(), timeout=delay_sec)
        return True
    except asyncio.TimeoutError:
        return cancel_event.is_set()


async def _gradual_start_worker(castles: List[Dict[str, Any]], cancel_event: asyncio.Event) -> None:
    """مهمة خلفية غير متزامنة لتشغيل الحسابات واحداً تلو الآخر بفاصل عشوائي 5-10 ثوانٍ."""
    global _gradual_running, _deploy_mode
    started = 0
    skipped = 0
    total = len(castles)
    try:
        for idx, c in enumerate(castles):
            if cancel_event.is_set():
                log.info(f"🛑 [Gradual] تم إلغاء التشغيل التدريجي بعد {started}/{total} حساب.")
                break

            cid = str(c.get("castle_id", "")).strip()
            em = str(c.get("email", "")).strip()
            try:
                ok = await _launch_castle_via_manager(c)
                if ok:
                    started += 1
                    log.info(f"✅ [Gradual] ({started}/{total}) بدأ: {em or cid[:8]}")
                else:
                    skipped += 1
            except Exception as exc:
                skipped += 1
                _clear_deploying_mark(cid, em)
                log.warning(f"⚠️ [Gradual] تعذر تشغيل {em or cid}: {exc}")

            if idx < total - 1 and not cancel_event.is_set():
                delay = random.uniform(5.0, 10.0)
                if await _wait_gradual_delay(cancel_event, delay):
                    log.info(f"🛑 [Gradual] توقف الانتظار بسبب إشارة الإلغاء ({started}/{total}).")
                    break

        log.info(f"🎉 [Gradual] اكتمل: شُغّل {started}، تخطي {skipped} من أصل {total}.")
    except asyncio.CancelledError:
        log.info(f"🛑 [Gradual] تم إلغاء مهمة التشغيل التدريجي ({started}/{total}).")
        raise
    finally:
        _gradual_running = False
        _deploy_mode = False
        _deploying_cids.clear()
        _deploying_emails.clear()
        _invalidate_ws_status_cache()
        log.info("🔓 [Gradual] تم فتح قفل النشر وإنهاء التشغيل التدريجي.")


async def _handle_auto_resume() -> None:
    """استئناف البوتات المحفوظة في auto_resume.json تلقائياً وتدريجياً بعد إعادة التشغيل."""
    global _deploy_mode, _gradual_running, _gradual_cancel_event
    try:
        await asyncio.sleep(1.0)
        to_resume = _read_auto_resume_file()
        if os.path.exists(_AUTO_RESUME_FILE):
            try:
                os.remove(_AUTO_RESUME_FILE)
            except Exception as exc:
                log.warning(f"⚠️ تعذر حذف auto_resume.json بعد قراءته: {exc}")

        if not to_resume:
            return

        _deploy_mode = True
        _gradual_running = True
        cancel_ev = asyncio.Event()
        _gradual_cancel_event = cancel_ev

        eligible_to_resume: List[Dict[str, Any]] = []
        for item in to_resume:
            if not isinstance(item, dict):
                continue
            cid = str(item.get("castle_id", "")).strip()
            uid = str(item.get("user_id", "")).strip()
            if not cid:
                continue
            c = db.get_castle_by_id(cid, uid or None)
            if not c or not c.get("is_active", 1):
                _clear_deploying_mark(cid, item.get("email"))
                db.upsert_castle_conn_state(cid, conn_state="idle", state="idle", status_message="غير نشط")
                continue
            effective_uid = uid or str(c.get("user_id", "")).strip()
            if effective_uid:
                valid, reason = db.check_user_subscription_db(effective_uid)
                if not valid:
                    _clear_deploying_mark(cid, c.get("email"))
                    db.upsert_castle_conn_state(cid, conn_state="idle", state="idle", status_message=f"متوقف: {reason}")
                    continue
            raw_cfg = c.get("config") or {}
            if isinstance(raw_cfg, str):
                try:
                    raw_cfg = json.loads(raw_cfg) if raw_cfg.strip() else {}
                except Exception:
                    raw_cfg = {}
            eligible_to_resume.append({
                "castle_id": cid,
                "user_id": effective_uid,
                "email": c.get("email", item.get("email", "")),
                "password": c.get("password", ""),
                "config": raw_cfg,
                "loop_interval": db.normalize_loop_interval(c.get("loop_interval")),
            })

        if not eligible_to_resume:
            _gradual_running = False
            _deploy_mode = False
            _deploying_cids.clear()
            _deploying_emails.clear()
            return

        shuffled = _interleave_shuffle(eligible_to_resume)
        log.info(f"🔄 [Auto-Resume] بدء استئناف {len(shuffled)} بوت تدريجياً (5-10 ثوانٍ عشوائياً)...")
        await _gradual_start_worker(shuffled, cancel_ev)
    except asyncio.CancelledError:
        _gradual_running = False
        _deploy_mode = False
        raise
    except Exception as exc:
        log.error(f"⚠️ [Auto-Resume] خطأ غير متوقع أثناء الاستئناف التلقائي: {exc}", exc_info=True)
        _gradual_running = False
        _deploy_mode = False
        _deploying_cids.clear()
        _deploying_emails.clear()


# ══════════════════════════════════════════════════════════════════
# FastAPI App & CORS & Lifespan
# ══════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(app: FastAPI):
    """إدارة دورة حياة خادم API: استئناف ما قبل التحديث عند الإقلاع وإيقاف آمن عند الإغلاق."""
    global _auto_resume_task, _gradual_task
    if _startup_resume_cids or os.path.exists(_AUTO_RESUME_FILE):
        _auto_resume_task = asyncio.create_task(_handle_auto_resume(), name="sys-auto-resume")
    yield
    log.info("خادم API يستعد للإغلاق، جارٍ إيقاف كافة البوتات النشطة بأمان...")
    for bg_task in (_gradual_task, _auto_resume_task):
        if bg_task and not bg_task.done():
            bg_task.cancel()
            try:
                await asyncio.wait_for(bg_task, timeout=2.0)
            except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
                pass
    try:
        await bot_manager.stop_all()
        log.info("✓ تم إيقاف كافة البوتات النشطة بنجاح.")
    except Exception as e:
        log.error(f"خطأ أثناء إيقاف البوتات عند الإغلاق: {e}")

app = FastAPI(
    title="Revenge of Sultans Bot API",
    version="2.1.0",
    description="خادم REST API الموحد لإدارة ومراقبة بوتات انتقام السلاطين",
    lifespan=lifespan,
)

_cors_origins_env = os.environ.get(
    "CORS_ORIGINS",
    "https://sultan.ibraabot.online,http://sultan.ibraabot.online,https://www.sultan.ibraabot.online,http://localhost,http://localhost:80,http://localhost:81,http://localhost:5173,http://localhost:3000,http://localhost:8000,http://localhost:8001,http://localhost:8765,http://127.0.0.1,http://127.0.0.1:80,http://127.0.0.1:81,http://127.0.0.1:5173,http://127.0.0.1:3000,http://127.0.0.1:8000,http://127.0.0.1:8001,http://127.0.0.1:8765"
)
_allowed_origins = [o.strip() for o in _cors_origins_env.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_allowed_origins,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    max_age=86400,
)

# ══════════════════════════════════════════════════════════════════
# المصادقة والتحقق (Authentication / Security)
# ══════════════════════════════════════════════════════════════════

security_scheme = HTTPBearer(auto_error=False)

_fb_app = None
_fb_lock = threading.Lock()

def _ensure_firebase():
    """تهيئة آمنة لـ Firebase Admin SDK لمشروع intqam-sultan"""
    global _fb_app
    with _fb_lock:
        if _fb_app:
            return _fb_app
        try:
            import firebase_admin
            from firebase_admin import credentials
            sak_path = os.path.join(_ROOT, "firebase_service_account.json")
            if os.path.exists(sak_path):
                try:
                    _fb_app = firebase_admin.get_app()
                except ValueError:
                    cred = credentials.Certificate(sak_path)
                    _fb_app = firebase_admin.initialize_app(cred)
                log.info("✓ تم تفعيل وتوثيق Firebase Admin SDK بنجاح لمشروع intqam-sultan")
                return _fb_app
            elif firebase_admin._apps:
                _fb_app = firebase_admin.get_app()
                return _fb_app
        except Exception as e:
            log.warning(f"تعذر تهيئة Firebase Admin SDK: {e}")
    return None

_ensure_firebase()

def get_current_user(
    request: Request,
    credentials: Optional[HTTPAuthorizationCredentials] = Security(security_scheme)
) -> Dict[str, Any]:
    """
    التحقق من هوية المستخدم:
    1. محلياً/للتطوير: إذا لم يُرسل توكن أو أُرسل توكن تجريبي، يتم تفعيل حساب المدير الافتراضي.
    2. إن وُجد Firebase Admin، يتم فك تشفير الـ ID Token والتحقق الصارم.
    """
    token = credentials.credentials if credentials else None
    
    # محاولة فحص Firebase إذا كانت التهيئات متوفرة
    if token and token != "dev-token":
        try:
            _ensure_firebase()
            import firebase_admin
            from firebase_admin import auth as fb_auth
            if firebase_admin._apps:
                # إضافة clock_skew_seconds=60 لحل مشكلة فرق توقيت الساعة في ويندوز التي ترفض التوكن الجديد بـ 401!
                decoded = fb_auth.verify_id_token(token, clock_skew_seconds=60)
                uid = str(decoded.get("uid", "")).strip()
                email = str(decoded.get("email", "")).strip().lower()
                user_rec = db.get_user(uid)
                if not user_rec:
                    user_rec = db.create_or_update_user(uid, email, role="admin" if is_super_admin(email) else "user")
                return user_rec
        except Exception as e:
            log.warning(f"Firebase token verification error: {e}")
            # إذا كان الطلب من localhost للتطوير المحلي، لا نوقف الواجهة بـ 401
            client_host = request.client.host if request.client else ""
            if client_host not in ("127.0.0.1", "localhost", "::1"):
                raise HTTPException(status_code=401, detail="رمز التوثيق غير صالح أو منتهي الصلاحية")

    # إذا لم يُرسل توكن وكان الاتصال من خارج الجهاز المحلي، نرفض الطلب
    if not token:
        client_host = request.client.host if request.client else ""
        if client_host not in ("127.0.0.1", "localhost", "::1"):
            _ensure_firebase()
            import firebase_admin
            if firebase_admin._apps:
                raise HTTPException(status_code=401, detail="جلسة الدخول غير مصرح بها (يرجى تسجيل الدخول)")

    # التراجع التلقائي للتطوير المحلي (Local Dev Fallback فقط عند استخدام dev-token أو غياب Firebase)
    admin_user = db.get_user("admin_default")
    if admin_user:
        return admin_user

    return {
        "uid": "admin_default",
        "email": "ibraboths@gmail.com",
        "username": "Admin Sultan",
        "role": "admin",
        "is_banned": 0,
        "status": "approved",
    }


def require_admin(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
    if not is_super_admin(current_user):
        raise HTTPException(status_code=403, detail="هذه العملية مخصصة لمدير النظام فقط")
    return current_user


def verify_internal_access(
    request: Request,
    credentials: Optional[HTTPAuthorizationCredentials] = Security(security_scheme),
) -> Dict[str, Any]:
    """
    حماية المسارات الداخلية (/api/internal/*) لنظام النشر والاستئناف التدريجي:
    1. مطابقة ترويسة X-Internal-Token مع INTERNAL_API_SECRET.
    2. اتصال محلي مباشر (Loopback) مع التحقق من غياب ترويسات البروكسي الخارجية X-Real-IP / X-Forwarded-For.
    3. مصادقة Bearer Token لمشرف النظام (Super Admin).
    """
    internal_token = request.headers.get("x-internal-token")
    if internal_token and internal_token.strip() == INTERNAL_API_SECRET:
        return {"source": "internal_token", "authorized": True}

    client_host = getattr(request.client, "host", "") if request.client else ""
    x_real_ip = (request.headers.get("x-real-ip") or "").strip()
    x_forwarded_for = (request.headers.get("x-forwarded-for") or "").strip()
    loopback_hosts = ("127.0.0.1", "::1", "localhost", "testclient")
    is_direct_loopback = (
        client_host in loopback_hosts
        and (not x_real_ip or x_real_ip in loopback_hosts)
        and (not x_forwarded_for or x_forwarded_for in loopback_hosts)
    )
    if is_direct_loopback:
        return {"source": "loopback", "authorized": True}

    if credentials and credentials.credentials:
        try:
            user = get_current_user(request, credentials)
            if is_super_admin(user):
                return user
        except Exception:
            pass

    log.warning(f"🚨 محاولة وصول غير مصرح بها لمسار داخلي ({request.url.path}) من IP: {client_host}")
    raise HTTPException(
        status_code=403,
        detail="Forbidden: Internal endpoint requires admin role, internal token, or direct local loopback access",
    )


# ══════════════════════════════════════════════════════════════════
# نماذج البيانات (Pydantic Request Models)
# ══════════════════════════════════════════════════════════════════

class UserRegisterRequest(BaseModel):
    uid: str
    email: str
    username: str = ""
    phone: str = ""
    tenant_domain: str = ""

class UserProfileUpdateRequest(BaseModel):
    username: Optional[str] = None
    phone: Optional[str] = None

class CastleCreateRequest(BaseModel):
    castle_id: Optional[str] = None
    email: str
    password: Optional[str] = ""
    castle_name: Optional[str] = ""
    config: Optional[Dict[str, Any]] = None

from typing import Literal
from pydantic import BaseModel, Field, field_validator, model_validator

class FountainConfig(BaseModel):
    enabled: bool = False
    resources: List[str] = ["food", "wood", "iron", "steel", "mithril", "crystal"]
    gold_times: int = Field(default=0, ge=0)

class TrainLevelsConfig(BaseModel):
    infantry: int = Field(default=0, ge=0, le=12)
    cavalry: int = Field(default=0, ge=0, le=12)
    archers: int = Field(default=0, ge=0, le=12)
    chariots: int = Field(default=0, ge=0, le=12)

class TrainConfig(BaseModel):
    enabled: bool = False
    levels: TrainLevelsConfig = Field(default_factory=TrainLevelsConfig)
    level: int = Field(default=10, ge=1, le=12)
    count: str = "max"

class ShieldConfig(BaseModel):
    enabled: bool = False
    duration: Literal["8h", "24h", "3d"] = "8h"
    allow_gold: bool = False

    @field_validator("duration", mode="before")
    @classmethod
    def normalize_duration(cls, v: Any) -> str:
        val = str(v or "8h").lower().strip()
        return val if val in ("8h", "24h", "3d") else "8h"

class SimpleToggleConfig(BaseModel):
    enabled: bool = False

class FlowerConfig(BaseModel):
    enabled: bool = False
    allow_gold: bool = False

class CureWoundedConfig(BaseModel):
    enabled: bool = False
    mode: Literal["daily", "all"] = "daily"

    @field_validator("mode", mode="before")
    @classmethod
    def normalize_mode(cls, v: Any) -> str:
        val = str(v or "daily").lower().strip()
        return val if val in ("daily", "all") else "daily"

class PetConfig(BaseModel):
    enabled: bool = False
    target_pet: int = 1256

    @model_validator(mode="before")
    @classmethod
    def handle_legacy_destination(cls, data: Any) -> Any:
        if isinstance(data, dict):
            raw_target = data.get("target_pet") or data.get("destination") or 1256
            try:
                data["target_pet"] = int(raw_target)
            except (ValueError, TypeError):
                data["target_pet"] = 1256
        return data

class ForgeEquipmentConfig(BaseModel):
    enabled: bool = False
    category: Literal["weapon", "clothes", "helmet", "trousers", "shoes", "ring"] = "weapon"

    @field_validator("category", mode="before")
    @classmethod
    def normalize_category(cls, v: Any) -> str:
        val = str(v or "weapon").lower().strip()
        return val if val in ("weapon", "clothes", "helmet", "trousers", "shoes", "ring") else "weapon"

class BuildingConfigModel(BaseModel):
    enabled: bool = False
    upgrade_castle: bool = True
    speedup_castle: bool = False
    auto_open_chests: bool = True
    upgrade_support_buildings: bool = True
    max_castle_level: Optional[int] = 130
    target_buildings: Optional[Dict[str, bool]] = None

class ArenaConfigModel(BaseModel):
    enabled: bool = False
    mode: Literal["daily", "per_cycle"] = "daily"
    arena_type: Literal["kingdom", "global"] = "kingdom"
    auto_claim_rewards: bool = True

    @field_validator("mode", mode="before")
    @classmethod
    def normalize_arena_mode(cls, v: Any) -> str:
        val = str(v or "daily").lower().strip()
        return val if val in ("daily", "per_cycle") else "daily"

    @field_validator("arena_type", mode="before")
    @classmethod
    def normalize_arena_type(cls, v: Any) -> str:
        val = str(v or "kingdom").lower().strip()
        return val if val in ("kingdom", "global") else "kingdom"

class CommandHallConfigModel(BaseModel):
    enabled: bool = False
    mode: Literal["daily", "full"] = "daily"
    allow_marches: bool = True
    allow_snipe: bool = True
    allow_rescue: bool = True
    allow_dialogue: bool = True
    allow_army_group: bool = True
    auto_claim_rewards: bool = True
    auto_upgrade_hall: bool = True
    min_safety_stamina: int = 10

    @field_validator("mode", mode="before")
    @classmethod
    def normalize_mode(cls, v: Any) -> str:
        val = str(v or "daily").lower().strip()
        return val if val in ("daily", "full") else "daily"

class WatermillConfigModel(BaseModel):
    enabled: bool = False
    resources: Optional[List[str]] = None
    types: Optional[Any] = "all"
    allow_shop_buy: Optional[bool] = False

class SkillsConfigModel(BaseModel):
    enabled: bool = False
    target_skills: Optional[List[str]] = Field(default_factory=list)

class MaterialWorkshopConfigModel(BaseModel):
    enabled: bool = False
    selected_materials: Optional[List[int]] = Field(default_factory=lambda: [200101, 200201, 200301, 200401, 200501, 200601])

class StaminaConfigModel(BaseModel):
    enabled: bool = False
    gold_buy_enabled: bool = False
    gold_trigger_stamina: int = Field(default=50, ge=0)
    gold_buy_stamina_amount: int = Field(default=50, ge=1)

class TreasureEscortConfigModel(BaseModel):
    enabled: bool = False

class MarchManagerConfigModel(BaseModel):
    enabled: bool = False
    max_duration_minutes: int = Field(default=20, ge=1, le=120)
    treasure_escort: Optional[TreasureEscortConfigModel] = None

    model_config = {"extra": "allow"}

class CastleConfigModel(BaseModel):
    fountain: Optional[FountainConfig] = None
    train: Optional[TrainConfig] = None
    shield: Optional[ShieldConfig] = None
    research: Optional[SimpleToggleConfig] = None
    flower: Optional[FlowerConfig] = None
    wonder_merchant: Optional[SimpleToggleConfig] = None
    material_synthesis: Optional[SimpleToggleConfig] = None
    cure_wounded: Optional[CureWoundedConfig] = None
    alliance: Optional[SimpleToggleConfig] = None
    war_medal: Optional[SimpleToggleConfig] = None
    daily_train: Optional[SimpleToggleConfig] = None
    pet: Optional[PetConfig] = None
    forge_equipment: Optional[ForgeEquipmentConfig] = None
    building: Optional[BuildingConfigModel] = None
    arena: Optional[ArenaConfigModel] = None
    hero_trial: Optional[SimpleToggleConfig] = None
    command_hall: Optional[CommandHallConfigModel] = None
    daily_quest: Optional[SimpleToggleConfig] = None
    watermill: Optional[WatermillConfigModel] = None
    skills: Optional[SkillsConfigModel] = None
    material_workshop: Optional[MaterialWorkshopConfigModel] = None
    stamina: Optional[StaminaConfigModel] = None
    caravan: Optional[SimpleToggleConfig] = None
    march_manager: Optional[MarchManagerConfigModel] = None

    @model_validator(mode="before")
    @classmethod
    def map_pet_patrol_alias(cls, data: Any) -> Any:
        if isinstance(data, dict) and "pet_patrol" in data:
            if "pet" not in data:
                data["pet"] = data["pet_patrol"]
            data.pop("pet_patrol", None)
        return data

class CastleUpdateRequest(BaseModel):
    castle_name: Optional[str] = None
    config: Optional[CastleConfigModel] = None
    loop_interval: Optional[int] = None

class CastlesLoopIntervalsRequest(BaseModel):
    intervals: Dict[str, int]

class CastleCredentialsRequest(BaseModel):
    email: str
    password: Optional[str] = None

class CastleToggleRequest(BaseModel):
    is_active: bool

class BotStartPayload(BaseModel):
    castle_id: str
    user_id: Optional[str] = "admin_default"
    email: str
    password: Optional[str] = ""
    config: Optional[Dict[str, Any]] = None
    loop_interval: Optional[int] = None

class AdminApproveUserPayload(BaseModel):
    days: Optional[int] = 3
    max_castles: Optional[int] = 10

class AdminUpdateSubscriptionPayload(BaseModel):
    plan_id: Optional[str] = None
    plan_name: Optional[str] = None
    subscription_status: Optional[str] = None
    expires_at: Optional[str] = None
    max_castles_allowed: Optional[int] = None
    days: Optional[int] = None

class AdminBanUserPayload(BaseModel):
    is_banned: Optional[bool] = None
    reason: Optional[str] = ""

class SendCmdPayload(BaseModel):
    email: str
    cmd: int
    subcmd: int = 1
    data: Optional[Dict[str, Any]] = None


# ══════════════════════════════════════════════════════════════════
# 1. فحوصات النظام والصحة (Health & System APIs)
# ══════════════════════════════════════════════════════════════════

@app.get("/api/system/health")
@app.get("/api/health")
def health_check():
    """فحص جاهزية الخادم وحالة النظام"""
    summary = bot_manager.get_status_summary()
    return {
        "status": "ok",
        "game": "Revenge of Sultans",
        "version": "2.1.0",
        "deploy_mode": _deploy_mode,
        "gradual_running": _gradual_running,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "summary": summary,
    }

@app.get("/")
def root():
    return {"message": "Revenge of Sultans API Server is running."}

@app.get("/api/manifest.json")
@app.get("/manifest.json")
def get_manifest(request: Request, tenant: Optional[str] = Query(None)):
    """توفير ملف manifest.json ديناميكياً لتطبيق الـ PWA بحسب النطاق أو التاجر"""
    if tenant:
        t_cfg = get_tenant_by_id(tenant)
    else:
        host = (
            request.headers.get("x-tenant-domain")
            or request.headers.get("x-forwarded-host")
            or request.headers.get("host")
            or ""
        )
        t_cfg = get_tenant_by_domain(host)

    icons_cfg = t_cfg.get("pwa_icons") or {}
    brand = t_cfg.get("brand_name") or "IBRA BOT"
    manifest_payload = {
        "id": "/",
        "name": brand,
        "short_name": brand,
        "description": t_cfg.get("tagline") or brand,
        "start_url": "/",
        "scope": "/",
        "display": "standalone",
        "orientation": "portrait-primary",
        "background_color": "#0a0f0a",
        "theme_color": t_cfg.get("primary_color") or "#10b981",
        "lang": t_cfg.get("default_language") or "ar",
        "dir": "ltr",
        "categories": ["utilities", "productivity"],
        "icons": [
            {"src": icons_cfg.get("any_192", "/pwa-192x192.png"), "sizes": "192x192", "type": "image/png", "purpose": "any"},
            {"src": icons_cfg.get("any_512", "/pwa-512x512.png"), "sizes": "512x512", "type": "image/png", "purpose": "any"},
            {"src": icons_cfg.get("maskable_192", "/pwa-maskable-192x192.png"), "sizes": "192x192", "type": "image/png", "purpose": "maskable"},
            {"src": icons_cfg.get("maskable_512", "/pwa-maskable-512x512.png"), "sizes": "512x512", "type": "image/png", "purpose": "maskable"},
        ],
    }
    return JSONResponse(
        content=manifest_payload,
        media_type="application/manifest+json",
        headers={"Cache-Control": "no-cache, must-revalidate"},
    )
# ══════════════════════════════════════════════════════════════════
# 2. إدارة المستخدمين والملف الشخصي (Users APIs)
# ══════════════════════════════════════════════════════════════════

@app.get("/api/users/profile")
@app.get("/api/user/profile")
def get_user_profile(current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب بيانات الملف الشخصي للمستخدم الحالي"""
    user_out = dict(current_user)
    if user_out.get("uid"):
        user_out.update(db.get_user_castle_counts(user_out["uid"]))
    return {"status": "ok", "user": user_out}

@app.post("/api/users/register")
@app.post("/api/user/register")
def register_user(req: UserRegisterRequest):
    """تسجيل مستخدم جديد في النظام"""
    user = db.create_or_update_user(
        uid=req.uid,
        email=req.email,
        username=req.username,
        phone=req.phone,
        tenant_domain=req.tenant_domain,
    )
    return {"status": "ok", "user": user}

@app.put("/api/users/profile")
@app.put("/api/user/profile")
def update_user_profile_api(req: UserProfileUpdateRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """تحديث الاسم ورقم الهاتف للمستخدم الحالي"""
    db.update_user_profile(current_user["uid"], username=req.username, phone=req.phone)
    updated = db.get_user(current_user["uid"])
    return {"status": "ok", "user": updated}

@app.get("/api/users/subscription")
@app.get("/api/user/subscription")
def get_user_subscription(current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب تفاصيل صلاحية اشتراك المستخدم"""
    valid, reason = db.check_user_subscription_db(current_user["uid"])
    return {
        "valid": valid,
        "reason": reason,
        "subscription_end": current_user.get("subscription_end"),
        "max_castles": current_user.get("max_castles", 50),
        "role": current_user.get("role", "user"),
    }


# ══════════════════════════════════════════════════════════════════
# 3. إدارة القلاع والحسابات (Castles & Accounts APIs)
# ══════════════════════════════════════════════════════════════════

def _extract_seal_details(
    status_message: Optional[str],
    seal_type: Optional[int] = None,
    seal_reason: Optional[str] = None,
) -> Tuple[Optional[int], str]:
    """استخراج نوع الحظر وسببه الصافي من البيانات الحية أو رسالة الحالة."""
    raw_msg = str(status_message or "").strip()
    clean_reason = str(seal_reason or "").strip()
    if not clean_reason and raw_msg:
        clean_reason = raw_msg
        for prefix in (
            "❌ [حساب محظور] الحساب مجمد أو محظور من إدارة اللعبة:",
            "❌ [حساب محظور]",
        ):
            if clean_reason.startswith(prefix):
                clean_reason = clean_reason[len(prefix):].strip()
                break

    inferred_type = seal_type
    if inferred_type is None and (clean_reason or raw_msg):
        txt = f"{clean_reason} {raw_msg}"
        if "بيع أو نقل" in txt or "Sell Resource" in txt:
            inferred_type = 1
        elif "حسابات متعددة" in txt or "Too Many Accounts" in txt:
            inferred_type = 2
        elif "الدردشة" in txt or "الشتائم" in txt or "Curse" in txt:
            inferred_type = 3
        elif "محذوف" in txt or "Account Deleted" in txt or "ملغى" in txt:
            inferred_type = 4
        elif "تجميد" in txt or "Suspended" in txt:
            inferred_type = 5
        elif "شحن غير قانوني" in txt or "Illegal Recharge" in txt:
            inferred_type = 10
        elif "دعوة" in txt or "Invite" in txt:
            inferred_type = 11
        elif "بصمة الجهاز" in txt or "Device Signature" in txt:
            inferred_type = 99
        elif "حظر" in txt:
            inferred_type = 0
    return inferred_type, clean_reason


def _hydrate_castle_runtime_state(castle_obj: Dict[str, Any], bot: Optional[Any]) -> None:
    """مزامنة حالة التشغيل الفعلية وحالة الحظر والخطأ لبطاقة القلعة من الذاكرة الحية أو قاعدة البيانات."""
    if bot:
        live = bot.get_live_info()
        castle_obj["conn_state"] = live.get("conn_state", castle_obj.get("conn_state"))
        if live.get("is_password_error") or live.get("conn_state") == "error":
            castle_obj["state"] = "error"
            castle_obj["conn_state"] = "error"
            castle_obj["is_password_error"] = True
        elif live.get("is_sealed") or live.get("conn_state") == "sealed":
            castle_obj["state"] = "sealed"
            castle_obj["conn_state"] = "sealed"
            castle_obj["is_sealed"] = True
            s_type, s_reason = _extract_seal_details(
                live.get("status_message") or castle_obj.get("status_message"),
                live.get("seal_type"),
                live.get("seal_reason"),
            )
            castle_obj["seal_type"] = s_type
            castle_obj["seal_reason"] = s_reason
        else:
            castle_obj["state"] = "running" if live.get("is_running") else "idle"
        castle_obj["status_message"] = live.get("status_message", castle_obj.get("status_message"))
        castle_obj["conn_message"] = castle_obj["status_message"]
        castle_obj["next_run_time"] = live.get("next_run_time", castle_obj.get("next_run_time"))
    else:
        raw_state = str(castle_obj.get("state") or "").strip().lower()
        if castle_obj.get("conn_state") == "error" or raw_state == "error":
            castle_obj["state"] = "error"
            castle_obj["conn_state"] = "error"
            if "كلمة" in str(castle_obj.get("status_message", "")) or "password" in str(castle_obj.get("status_message", "")).lower():
                castle_obj["is_password_error"] = True
        elif castle_obj.get("conn_state") == "sealed" or raw_state == "sealed":
            castle_obj["state"] = "sealed"
            castle_obj["conn_state"] = "sealed"
            castle_obj["is_sealed"] = True
            s_type, s_reason = _extract_seal_details(castle_obj.get("status_message"))
            castle_obj["seal_type"] = s_type
            castle_obj["seal_reason"] = s_reason
            castle_obj["conn_message"] = castle_obj.get("status_message")
        elif raw_state == "rejected":
            castle_obj["state"] = "rejected"
            castle_obj["conn_state"] = "idle"
        elif raw_state == "pending" or not bool(castle_obj.get("is_active", True)):
            castle_obj["state"] = "pending"
            castle_obj["conn_state"] = "idle"
        else:
            castle_obj["state"] = "idle"
            castle_obj["conn_state"] = "idle"
            if castle_obj.get("status_message") in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة..."):
                castle_obj["status_message"] = "متوقف"


@app.get("/api/castles")
def list_castles(
    user_id: Optional[str] = None,
    summary: bool = Query(False, description="إرجاع ملخص خفيف بدون تفريغ إعدادات config الضخمة لتسريع العرض بالقوائم"),
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """جلب جميع القلاع التابعة للمستخدم أو كافة القلاع للمشرف (مع دعم ملخص خفيف)"""
    caller_uid = current_user.get("uid", "")
    is_admin = is_super_admin(current_user)

    target_uid = user_id if (is_admin and user_id) else (None if is_admin and not user_id else caller_uid)
    
    if summary:
        castles = db.get_user_castles_summary(target_uid) if target_uid else db.get_all_castles_summary()
    else:
        castles = db.get_user_castles(target_uid) if target_uid else db.get_all_castles()

    # دمج الحالة الحية من الذاكرة اللحظية (In-Memory Live Status)
    for c in castles:
        em = c.get("email", "")
        _hydrate_castle_runtime_state(c, bot_manager.get_bot(em))

    return {"status": "ok", "castles": castles}

@app.get("/api/castles/{castle_id}/config")
def get_castle_config(castle_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب إعدادات المهام حصراً عند فتح بطاقة القلعة"""
    is_admin = is_super_admin(current_user)
    cfg = db.get_castle_config_only(castle_id, None if is_admin else current_user["uid"])
    if cfg is None:
        raise HTTPException(status_code=404, detail="إعدادات القلعة غير موجودة")
    return {"status": "ok", "config": cfg}

@app.get("/api/castles/{castle_id}")
def get_castle_detail(castle_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب تفاصيل قلعة محددة بالمعرف"""
    is_admin = is_super_admin(current_user)
    castle = db.get_castle_by_id(castle_id, None if is_admin else current_user["uid"])
    if not castle:
        raise HTTPException(status_code=404, detail="القلعة غير موجودة")

    _hydrate_castle_runtime_state(castle, bot_manager.get_bot(castle.get("email", "")))

    return {"status": "ok", "castle": castle}

@app.post("/api/castles")
def create_castle(req: CastleCreateRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """إضافة حساب قلعة جديد إلى النظام"""
    uid = current_user.get("uid", "admin_default")
    is_admin = is_super_admin(current_user)
    if not is_admin and current_user.get("is_banned"):
        raise HTTPException(status_code=403, detail="حسابك محظور من قبل الإدارة، لا يمكنك إضافة قلاع جديدة")

    clean_email = (req.email or "").strip()
    if db.castle_exists_by_email(clean_email):
        raise HTTPException(status_code=400, detail="هذا البريد الإلكتروني مسجل مسبقاً في النظام")

    is_pending = False
    if not is_admin:
        is_sub_valid, _ = db.check_user_subscription_db(uid)
        max_castles = max(0, int(current_user.get("max_castles") or 0))
        active_count = db.count_user_active_castles(uid)
        is_pending = (not is_sub_valid) or (active_count >= max_castles)

    # إذا توفرت كلمة المرور ولم تكن القلعة معلقة، نحاول توثيق الحساب فوراً واستخراج الجلسة عبر البروكسي المعتمد
    if not is_pending and clean_email and req.password:
        try:
            from core.game_client import sdk_login
            from proxy import get_proxy_for_account, is_proxy_enabled

            req_proxy: Optional[str] = None
            if is_proxy_enabled():
                req_proxy = get_proxy_for_account(clean_email, user_id=uid)
            if not is_proxy_enabled() or req_proxy:
                auth_res = sdk_login(clean_email, req.password, proxy_url=req_proxy)
                if auth_res.get("success"):
                    SessionCache.set_account(clean_email, auth_res["userId"], auth_res["sessionId"])
                    log.info(f"✓ تم توثيق الحساب {clean_email} فورياً عند إضافته.")
            else:
                log.warning(f"تعذر تخصيص بروكسي للتوثيق الفوري للحساب {clean_email} — تم تأجيل المصادقة لمنع التسريب.")
        except Exception as e:
            log.warning(f"تعذر التوثيق الفوري للحساب {clean_email}: {e}")

    created = db.create_castle_db(
        user_id=uid,
        email=clean_email,
        password=req.password or "",
        castle_name=req.castle_name or "",
        config={},
        castle_id=req.castle_id,
        is_active=not is_pending,
        state="pending" if is_pending else "idle",
        conn_state="idle",
        status_message="بانتظار موافقة الإدارة لتفعيل القلعة" if is_pending else "جاهز للتشغيل",
    )
    try:
        from proxy import sync_castle_proxy_index
        sync_castle_proxy_index(clean_email, user_id=uid)
    except Exception:
        pass
    return {"status": "ok", "castle": created}

@app.put("/api/castles/loop-intervals")
def update_castles_loop_intervals_endpoint(
    req: CastlesLoopIntervalsRequest,
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """تحديث مدة دورة البوت (loop_interval) لمجموعة قلاع دفعة واحدة وتطبيقها فوراً على البوتات النشطة."""
    uid = current_user.get("uid", "")
    is_admin = is_super_admin(current_user)

    if not req.intervals:
        return {"status": "ok", "message": "لا توجد تعديلات"}

    target_uid = None if is_admin else uid
    ok = db.update_castles_loop_interval(req.intervals, user_id=target_uid)
    if not ok:
        raise HTTPException(status_code=500, detail="فشل تحديث أوقات دورات القلاع")

    # تحديث فوري للبوتات الشغالة حالياً لتطبيق المدة الجديدة بدءاً من الدورة القادمة دون إعادة تشغيل
    live_updated = 0
    for cid in req.intervals.keys():
        c_rec = db.get_castle_by_id(str(cid), target_uid)
        if c_rec and c_rec.get("email"):
            bot = bot_manager.get_bot(c_rec["email"])
            if bot:
                bot.reload_config_from_db()
                live_updated += 1

    return {
        "status": "ok",
        "message": "تم تحديث أوقات دورات القلاع بنجاح",
        "live_updated": live_updated,
    }


@app.put("/api/castles/{castle_id}")
def update_castle(castle_id: str, req: CastleUpdateRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """تحديث اسم وإعدادات مهام القلعة"""
    is_admin = is_super_admin(current_user)
    castle = db.get_castle_by_id(castle_id, None if is_admin else current_user["uid"])
    if not castle:
        raise HTTPException(status_code=404, detail="القلعة غير موجودة")

    updates = {}
    if req.castle_name is not None:
        updates["castle_name"] = req.castle_name

    if req.loop_interval is not None:
        updates["loop_interval"] = db.normalize_loop_interval(req.loop_interval)

    if req.config is not None:
        # دالة _row_to_castle في database.py تعيد config كـ dict جاهز دائماً
        clean_config = dict(castle.get("config") or {})
        clean_config.pop("pet_patrol", None)

        # استخراج الحقول المرسلة فقط بعد فحصها وتصفيتها تلقائياً عبر Pydantic
        validated_updates = req.config.model_dump(exclude_none=True)
        clean_config.update(validated_updates)
        # ضمان وجود مهمة استلام صناديق النشاط اليومي الإلزامية دائماً في الإعدادات
        clean_config.setdefault("daily_quest", {"enabled": True})
        # مزامنة كائن tasks الفرعي إن وجد لمنع أي تعارض مع الإعدادات المحدثة
        if "tasks" in clean_config and isinstance(clean_config["tasks"], dict):
            for t_k, t_v in validated_updates.items():
                if t_k in clean_config["tasks"]:
                    clean_config["tasks"][t_k] = t_v
            clean_config["tasks"].setdefault("daily_quest", {"enabled": True})
        updates["config"] = clean_config

    updated = db.update_castle_db(castle_id, updates, None if is_admin else current_user["uid"])
    
    em = castle.get("email") or (updated.get("email") if updated else "")
    bot = bot_manager.get_bot(em)
    if bot:
        bot.reload_config_from_db()

    return {"status": "ok", "castle": updated}

@app.put("/api/castles/{castle_id}/credentials")
def update_castle_credentials(castle_id: str, req: CastleCredentialsRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """تحديث بيانات الاعتماد للقلعة"""
    is_admin = is_super_admin(current_user)
    castle = db.get_castle_by_id(castle_id, None if is_admin else current_user["uid"])
    if not castle:
        raise HTTPException(status_code=404, detail="القلعة غير موجودة")

    db.update_castle_credentials(castle_id, req.email, req.password, None if is_admin else current_user["uid"])

    # مسح الجلسة القديمة من session_cache.json عند تغيير كلمة المرور لإعادة المصادقة من الصفر
    if req.password:
        try:
            from core.game_client import SessionCache
            accs = SessionCache.load_all()
            changed = False
            for target_em in (req.email, castle.get("email")):
                if target_em and target_em in accs:
                    del accs[target_em]
                    changed = True
            if changed:
                SessionCache.save(accs)
        except Exception:
            pass

        # إعادة تهيئة كائن البوت النشط في الذاكرة ومسح خطأ كلمة المرور
        try:
            em = req.email or castle.get("email")
            bot = bot_manager.get_bot(em)
            if bot:
                bot.is_password_error = False
                bot.password = req.password
                bot.conn_state = "disconnected"
                bot.status_message = ""
        except Exception:
            pass

    return {"status": "ok", "message": "تم تحديث بيانات الدخول بنجاح"}

@app.post("/api/castles/{castle_id}/toggle")
@app.post("/api/castles/{castle_id}/toggle-active")
def toggle_castle_active(castle_id: str, req: CastleToggleRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """تفعيل أو تعطيل القلعة"""
    is_admin = is_super_admin(current_user)
    castle = db.get_castle_by_id(castle_id, None if is_admin else current_user["uid"])
    if not castle:
        raise HTTPException(status_code=404, detail="القلعة غير موجودة")

    if not is_admin and req.is_active:
        if str(castle.get("state") or "").strip().lower() in ("pending", "rejected"):
            raise HTTPException(status_code=403, detail="هذه القلعة بانتظار موافقة الإدارة ولا يمكن تفعيلها يدوياً")
        if not castle.get("is_active"):
            active_count = db.count_user_active_castles(current_user["uid"])
            max_castles = max(0, int(current_user.get("max_castles") or 0))
            if active_count >= max_castles:
                raise HTTPException(
                    status_code=403,
                    detail=f"وصلت للحد الأقصى من القلاع المسموح بها في باقتك ({max_castles})",
                )

    db.toggle_castle_active(castle_id, req.is_active, None if is_admin else current_user["uid"])
    return {"status": "ok", "is_active": req.is_active}

@app.delete("/api/castles/{castle_id}")
async def delete_castle(castle_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """حذف القلعة وإيقاف البوت المرتبط بها وتفريغ طابور سجلاتها"""
    is_admin = is_super_admin(current_user)
    castle = db.get_castle_by_id(castle_id, None if is_admin else current_user["uid"])
    if not castle:
        raise HTTPException(status_code=404, detail="القلعة غير موجودة")

    await bot_manager.stop_bot(castle["email"])
    
    # تنظيف طوابير السجلات من الذاكرة
    with _log_lock:
        _log_queues.pop(castle_id, None)
        _log_queues.pop(castle["email"], None)

    db.delete_castle(castle_id, None if is_admin else current_user["uid"])
    try:
        from proxy import remove_castle_proxy
        if castle.get("email"):
            remove_castle_proxy(castle["email"])
    except Exception:
        pass
    return {"status": "ok", "message": "تم حذف القلعة بنجاح"}

@app.get("/api/castles/data/{email:path}")
@app.get("/api/castle-data/{email:path}")
def get_castle_live_data(email: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """استعلام بيانات القلعة اللحظية من الذاكرة أو قاعدة البيانات"""
    bot = bot_manager.get_bot(email)
    if bot:
        return {"status": "ok", "data": bot.get_live_info()}
    castle = db.get_castle_by_id(email)
    if castle:
        return {"status": "ok", "data": castle}
    raise HTTPException(status_code=404, detail="بيانات الحساب غير متوفرة")

@app.get("/api/castles/{castle_id}/avatar")
def get_castle_avatar(castle_id: str):
    """إرجاع الصورة الشخصية الحقيقية للقلعة أو الأيقونة الرمزية"""
    from fastapi.responses import RedirectResponse
    c = db.get_castle_by_id(castle_id)
    if c and isinstance(c.get("castle_info"), dict):
        avatar_url = c["castle_info"].get("avatar")
        if avatar_url:
            avatar_str = str(avatar_url).strip()
            if avatar_str.startswith("http://") or avatar_str.startswith("https://"):
                return RedirectResponse(url=avatar_str)
            if "customAvatar" in avatar_str:
                clean_path = avatar_str.lstrip("/")
                return RedirectResponse(url=f"https://hayyaimage.onemt.co/{clean_path}")
    # SVG افتراضي أنيق لشعار السلطان
    svg_data = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
      <defs>
        <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#d4af37;stop-opacity:1" />
          <stop offset="100%" style="stop-color:#8b0000;stop-opacity:1" />
        </linearGradient>
      </defs>
      <circle cx="50" cy="50" r="48" fill="url(#grad)" stroke="#fff" stroke-width="2"/>
      <path d="M50 20 L58 38 L78 38 L62 50 L68 70 L50 58 L32 70 L38 50 L22 38 L42 38 Z" fill="#fff"/>
    </svg>"""
    return Response(content=svg_data, media_type="image/svg+xml")


# ══════════════════════════════════════════════════════════════════
# 4. التحكم في تشغيل البوتات (Bot Control APIs)
# ══════════════════════════════════════════════════════════════════

@app.post("/api/bots/start")
@app.post("/api/bot/start")
async def start_bot_api(payload: BotStartPayload, current_user: Dict[str, Any] = Depends(get_current_user)):
    """بدء تشغيل بوت لحساب معين والاتصال بخادم اللعبة"""
    if _deploy_mode:
        raise HTTPException(
            status_code=503,
            detail="🚧 السيرفر في وضع التحديث حالياً. يرجى الانتظار قليلاً حتى يكتمل النشر وتستأنف البوتات تلقائياً.",
        )

    cid = payload.castle_id
    email = payload.email

    # التحقق من صلاحية الاشتراك
    valid, reason = db.check_user_subscription_db(current_user["uid"])
    if not valid:
        raise HTTPException(status_code=403, detail=f"لا يمكن تشغيل البوت: {reason}")

    # التحقق من أن القلعة موجودة ومفعلة
    c = db.get_castle_by_id(cid) or db.get_castle_by_id(email)
    if not c:
        if not is_super_admin(current_user):
            raise HTTPException(status_code=404, detail="القلعة غير موجودة")
        # للمشرف فقط: إذا لم تكن موجودة، ننشئها تلقائياً بالبريد المحدد
        c = db.create_castle_db(user_id=current_user["uid"], email=email, castle_id=cid)

    if not c.get("is_active") or str(c.get("state") or "").strip().lower() in ("pending", "rejected"):
        raise HTTPException(status_code=403, detail="هذه القلعة مجمدة أو غير مفعلة حالياً")

    # فرض حد الحصة (max_castles) على عدد البوتات النشطة لنفس المالك
    owner_uid = str(c.get("user_id") or current_user.get("uid") or "").strip()
    owner = db.get_user(owner_uid) if owner_uid else None
    if owner and not is_super_admin(owner):
        max_allowed = max(0, int(owner.get("max_castles") or 0))
        owner_castles = db.get_user_castles_summary(owner_uid)
        owner_emails = {str(oc.get("email") or "").strip().lower() for oc in owner_castles if oc.get("email")}
        owner_cids = {str(oc.get("castle_id") or "").strip() for oc in owner_castles if oc.get("castle_id")}
        current_em = str(c.get("email") or email or "").strip().lower()
        current_cid = str(c.get("castle_id") or cid or "").strip()
        running_other_count = 0
        for b_em, bot in list(bot_manager.bots.items()):
            norm_em = str(b_em or "").strip().lower()
            b_cid = str(getattr(bot, "castle_id", "") or "").strip()
            if norm_em == current_em or (b_cid and b_cid == current_cid):
                continue
            b_uid = str(getattr(bot, "user_id", "") or "").strip()
            belongs_to_owner = (
                (b_uid and b_uid == owner_uid)
                or norm_em in owner_emails
                or (b_cid and b_cid in owner_cids)
            )
            if not belongs_to_owner:
                continue
            task = bot_manager.tasks.get(b_em)
            if getattr(bot, "is_running", False) or (task and not task.done()):
                running_other_count += 1
        if running_other_count >= max_allowed:
            raise HTTPException(
                status_code=403,
                detail=f"وصلت للحد الأقصى من القلاع المسموح بها في باقتك ({max_allowed})",
            )

    # تكوين الإعدادات المدمجة
    effective_config = copy.deepcopy(c.get("config") or {})
    if payload.config:
        effective_config.update(payload.config)
    if "tasks" in effective_config and isinstance(effective_config["tasks"], dict):
        for t_k, t_v in effective_config.items():
            if t_k != "tasks" and t_k in effective_config["tasks"]:
                effective_config["tasks"][t_k] = t_v

    log.info(f"▶️ بدء تشغيل البوت للحساب: {email} (castle_id: {cid})")

    # تجهيز طابور السجلات وربطه بالبوت منذ لحظة الانطلاق
    target_cid = c["castle_id"]
    _get_or_create_log_queue(target_cid)
    _clear_deploying_mark(target_cid, email)

    # إطلاق البوت عبر bot_manager مع تمرير كلمة المرور ومعرّف القلعة والمستخدم وكولباك السجلات
    pwd = payload.password or (c.get("password") if c else "")
    target_interval = db.normalize_loop_interval(
        c.get("loop_interval") if c and c.get("loop_interval") is not None else payload.loop_interval
    )
    started = await bot_manager.start_bot(
        email,
        config=effective_config,
        password=pwd,
        castle_id=target_cid,
        user_id=c.get("user_id") or current_user.get("uid"),
        loop_interval=target_interval,
        log_callback=lambda m, cid_ref=target_cid, em_ref=email: (
            _push_log(cid_ref, m),
            _push_log(em_ref, m) if cid_ref != em_ref else None
        ),
    )
    # تحديث الحالة في SQLite
    db.upsert_castle_conn_state(
        castle_id=c["castle_id"],
        conn_state="starting",
        state="running",
        status_message="جاري الاتصال بخادم اللعبة...",
    )
    _invalidate_ws_status_cache([target_cid])

    return {"status": "starting", "castle_id": cid, "email": email}

@app.post("/api/bots/stop/{castle_id}")
@app.post("/api/bot/stop/{castle_id}")
async def stop_bot_api(castle_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """إيقاف بوت القلعة بأمان وإغلاق الاتصال"""
    c = db.get_castle_by_id(castle_id)
    email = c.get("email") if c else castle_id

    log.info(f"🛑 طلب إيقاف البوت: {email} ({castle_id})")
    stopped = await bot_manager.stop_bot(email)

    db.upsert_castle_conn_state(
        castle_id=castle_id,
        conn_state="idle",
        state="idle",
        status_message="متوقف بناءً على طلب المستخدم",
    )
    _invalidate_ws_status_cache([castle_id])
    return {"status": "stopped", "castle_id": castle_id, "email": email}

@app.post("/api/bots/stop-user/{user_id}")
@app.post("/api/bot/stop-user/{user_id}")
async def stop_user_bots_api(user_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """إيقاف جميع بوتات مستخدم محدد"""
    is_admin = is_super_admin(current_user)
    if not is_admin and current_user["uid"] != user_id:
        raise HTTPException(status_code=403, detail="غير مصرح بإيقاف بوتات مستخدم آخر")

    user_castles = db.get_user_castles(user_id)
    stopped_count = 0
    for c in user_castles:
        em = c.get("email")
        if em:
            await bot_manager.stop_bot(em)
            db.upsert_castle_conn_state(
                castle_id=c["castle_id"],
                conn_state="idle",
                state="idle",
                status_message="تم الإيقاف الشامل",
            )
            stopped_count += 1

    return {"status": "ok", "stopped_count": stopped_count}

@app.post("/api/bots/start-all")
async def start_all_bots_api(current_user: Dict[str, Any] = Depends(require_admin)):
    """تشغيل جميع الحسابات المتاحة دفعة واحدة (للأدمن)"""
    castles = db.get_all_castles()
    count = 0
    for c in castles:
        if c.get("is_active"):
            cid = c["castle_id"]
            em = c["email"]
            _get_or_create_log_queue(cid)
            await bot_manager.start_bot(
                em,
                config=c.get("config"),
                password=c.get("password", ""),
                castle_id=cid,
                user_id=c.get("user_id"),
                loop_interval=db.normalize_loop_interval(c.get("loop_interval")),
                log_callback=lambda m, cid_ref=cid, em_ref=em: (
                    _push_log(cid_ref, m),
                    _push_log(em_ref, m) if cid_ref != em_ref else None
                ),
            )
            count += 1
    return {"status": "starting_all", "count": count}

@app.post("/api/bots/stop-all")
async def stop_all_bots_api(current_user: Dict[str, Any] = Depends(require_admin)):
    """إيقاف جميع البوتات العاملة دفعة واحدة (للأدمن)"""
    await bot_manager.stop_all()
    _invalidate_ws_status_cache()
    return {"status": "stopped_all"}

@app.get("/api/bots/status/{castle_id}")
@app.get("/api/bot/status/{castle_id}")
def get_bot_status_api(castle_id: str, current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب الحالة التشغيلية اللحظية لقلعة محددة"""
    c = db.get_castle_by_id(castle_id)
    email = c.get("email") if c else castle_id
    bot = bot_manager.get_bot(email)

    if bot:
        live = bot.get_live_info()
        is_sealed_bot = bool(live.get("is_sealed") or live.get("conn_state") == "sealed")
        s_type, s_reason = _extract_seal_details(live.get("status_message"), live.get("seal_type"), live.get("seal_reason")) if is_sealed_bot else (None, "")
        return {
            "castle_id": castle_id,
            "is_password_error": bool(c and ("كلمة" in str(c.get("status_message", "")) or "password" in str(c.get("status_message", "")).lower())),
            "is_sealed": is_sealed_bot,
            "seal_type": s_type,
            "seal_reason": s_reason,
            "email": email,
            "status": "running" if live["is_running"] else ("error" if (live.get("is_password_error") or live.get("conn_state") == "error") else ("sealed" if is_sealed_bot else "idle")),
            "conn_state": live["conn_state"],
            "status_message": live["status_message"],
            "uptime_seconds": live["uptime_seconds"],
            "iteration": live["iteration"],
            "next_run_time": live["next_run_time"],
        }

    c_st = (c.get("conn_state") if c else "idle") or "idle"
    c_msg = (c.get("status_message") if c else "غير قيد التشغيل") or "غير قيد التشغيل"
    is_deploying_row = (castle_id in _deploying_cids) or (c_st == "deploying") or bool(c and c.get("state") == "deploying")
    if is_deploying_row:
        return {
            "castle_id": castle_id,
            "is_password_error": False,
            "is_sealed": False,
            "seal_type": None,
            "seal_reason": "",
            "email": email,
            "status": "deploying",
            "conn_state": "deploying",
            "status_message": c_msg if c_st == "deploying" else "جاري رفع التغييرات إلى السيرفر... سيتم استئناف البوت تلقائياً",
        }
    is_sealed_db = (c_st == "sealed")
    s_type, s_reason = _extract_seal_details(c_msg) if is_sealed_db else (None, "")
    return {
        "castle_id": castle_id,
        "is_password_error": bool(c and ("كلمة" in str(c_msg) or "password" in str(c_msg).lower())),
        "is_sealed": is_sealed_db,
        "seal_type": s_type,
        "seal_reason": s_reason,
        "email": email,
        "status": c_st if c_st in ("error", "sealed", "deploying") else "idle",
        "conn_state": c_st,
        "status_message": c_msg
    }

@app.get("/api/bots/status")
@app.get("/api/bot/status")
def get_all_bots_status_api(current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب الحالات التشغيلية لجميع القلاع لتغذية لوحة المراقبة"""
    statuses: Dict[str, str] = {}
    castles = db.get_all_castles() if is_super_admin(current_user) else db.get_user_castles(current_user["uid"])

    for c in castles:
        cid = c["castle_id"]
        em = c["email"]
        bot = bot_manager.get_bot(em)
        if bot and bot.is_running:
            statuses[cid] = "running"
        elif cid in _deploying_cids or c.get("conn_state") == "deploying" or c.get("state") == "deploying":
            statuses[cid] = "deploying"
        elif c.get("conn_state") in ("error", "sealed"):
            statuses[cid] = c["conn_state"]
        else:
            statuses[cid] = "idle"

    return {"status": "ok", "bots": statuses}


# ══════════════════════════════════════════════════════════════════
# 4.5 واجهات النشر الداخلية والتحكم التدريجي (Internal Deploy APIs)
# ══════════════════════════════════════════════════════════════════

@app.post("/api/internal/deploy-lock", dependencies=[Depends(verify_internal_access)])
def deploy_lock_endpoint():
    """قفل وضع النشر لمنع أي تشغيل يدوي جديد أثناء رفع التحديثات."""
    global _deploy_mode
    _deploy_mode = True
    log.warning("🔒 [Deploy Lock] وضع النشر مُفعّل — تم تعليق تشغيل أي بوت جديد حتى انتهاء النشر.")
    return {"status": "locked", "deploy_mode": True}


@app.post("/api/internal/deploy-unlock", dependencies=[Depends(verify_internal_access)])
def deploy_unlock_endpoint():
    """إلغاء وضع النشر والسماح بتشغيل البوتات مجدداً."""
    global _deploy_mode
    _deploy_mode = False
    log.info("🔓 [Deploy Unlock] وضع النشر أُلغي — يمكن تشغيل البوتات مجدداً.")
    return {"status": "unlocked", "deploy_mode": False}


@app.post("/api/internal/save-running-state", dependencies=[Depends(verify_internal_access)])
async def save_running_state_endpoint():
    """حفظ جميع البوتات النشطة حالياً في auto_resume.json، وسمها بـ deploying، وإيقافها بأمان قبل الريستارت."""
    global _deploy_mode, _gradual_running
    _deploy_mode = True

    if _gradual_cancel_event is not None:
        _gradual_cancel_event.set()
    if _gradual_task and not _gradual_task.done():
        _gradual_task.cancel()
        try:
            await asyncio.wait_for(_gradual_task, timeout=2.0)
        except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
            pass
    _gradual_running = False

    active_entries: List[Dict[str, Any]] = []
    seen_cids: Set[str] = set()
    for em, bot in list(bot_manager.bots.items()):
        task = bot_manager.tasks.get(em)
        is_alive = bool(
            bot.is_running
            or bot.conn_state in ("starting", "running", "connected", "waiting", "reconnecting")
            or (task and not task.done())
        )
        if not is_alive:
            continue
        cid = getattr(bot, "castle_id", None) or ""
        uid = getattr(bot, "user_id", None) or ""
        if not cid or not uid:
            c_rec = db.get_castle_by_id(em)
            if c_rec:
                cid = cid or str(c_rec.get("castle_id", ""))
                uid = uid or str(c_rec.get("user_id", ""))
        if cid and cid not in seen_cids:
            seen_cids.add(cid)
            active_entries.append({"castle_id": cid, "user_id": uid, "email": em})

    deploy_msg = "جاري رفع التغييرات إلى السيرفر... سيتم استئناف البوت تلقائياً"
    if active_entries:
        _set_deploying_marks(active_entries, deploy_msg)
        tmp_path = f"{_AUTO_RESUME_FILE}.tmp"
        with open(tmp_path, "w", encoding="utf-8") as f:
            json.dump(active_entries, f, ensure_ascii=False, indent=2)
        os.replace(tmp_path, _AUTO_RESUME_FILE)
        log.info(f"💾 [Auto-Resume Prep] تم حفظ {len(active_entries)} بوت نشط ووسمها بـ deploying.")
    elif os.path.exists(_AUTO_RESUME_FILE):
        prev_entries = _read_auto_resume_file()
        if prev_entries:
            active_entries = prev_entries
            log.info(f"💾 [Auto-Resume Prep] تم الاحتفاظ بـ {len(active_entries)} بوت من auto_resume.json السابق.")

    try:
        await bot_manager.stop_all()
    except Exception as exc:
        log.warning(f"⚠️ [Auto-Resume Prep] خطأ أثناء إيقاف البوتات: {exc}")

    return {
        "status": "success",
        "count": len(active_entries),
        "castles": [x["castle_id"] for x in active_entries],
    }


@app.post("/api/internal/gradual-start", dependencies=[Depends(verify_internal_access)])
async def gradual_start_endpoint():
    """تشغيل تدريجي عشوائي لجميع الحسابات المؤهلة بفاصل 5-10 ثوانٍ وخلط ذكي للمستخدمين."""
    global _gradual_running, _deploy_mode, _gradual_cancel_event, _gradual_task

    if _gradual_running and _gradual_task and not _gradual_task.done():
        return {"status": "rejected", "message": "عملية تشغيل تدريجي جارية بالفعل — انتظر انتهاءها أو ألغِها أولاً"}

    eligible = _collect_eligible_castles()
    if not eligible:
        return {"status": "empty", "message": "لا توجد حسابات مؤهلة للتشغيل"}

    _gradual_running = True
    _deploy_mode = True
    cancel_ev = asyncio.Event()
    _gradual_cancel_event = cancel_ev

    _set_deploying_marks(eligible, "جاري استئناف البوت تدريجياً... (وضع التحديث)")
    shuffled = _interleave_shuffle(eligible)
    _gradual_task = asyncio.create_task(_gradual_start_worker(shuffled, cancel_ev), name="gradual-start")

    return {
        "status": "started",
        "total": len(shuffled),
        "message": f"بدأ التشغيل التدريجي لـ {len(shuffled)} حساب (5-10 ثوانٍ بين كل حساب)",
    }


@app.post("/api/internal/resume-all-from-db", dependencies=[Depends(verify_internal_access)])
async def resume_all_from_db_endpoint():
    """تفويض استئناف الحسابات من قاعدة البيانات إلى محرك التشغيل التدريجي الآمن."""
    return await gradual_start_endpoint()


@app.post("/api/internal/stop-all", dependencies=[Depends(verify_internal_access)])
async def internal_stop_all_endpoint():
    """إيقاف جميع البوتات النشطة وإلغاء أي طابور تشغيل تدريجي وتصفير الحالات في SQLite."""
    global _gradual_running, _deploy_mode

    if _gradual_cancel_event is not None:
        _gradual_cancel_event.set()
    if _gradual_task and not _gradual_task.done():
        _gradual_task.cancel()
        try:
            await asyncio.wait_for(_gradual_task, timeout=2.0)
        except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
            pass
    _gradual_running = False

    running_count = len(bot_manager.bots)
    await bot_manager.stop_all()
    reset_count = db.stop_all_castles_idle_db("تم إيقاف البوت بواسطة المشرف")

    _deploy_mode = False
    _deploying_cids.clear()
    _deploying_emails.clear()
    _invalidate_ws_status_cache()

    log.info(f"🛑 [Stop-All] تم إيقاف {running_count} بوت وتصفير {reset_count} سجل في SQLite.")
    return {
        "status": "stopped",
        "count": running_count or reset_count,
        "message": f"تم إيقاف البوتات بنجاح ({running_count} نشط)",
    }


@app.post("/api/internal/cancel-start-queue", dependencies=[Depends(verify_internal_access)])
async def cancel_start_queue_endpoint():
    """إلغاء التشغيل التدريجي الجاري مع إبقاء البوتات التي بدأت فعلاً قيد التشغيل."""
    global _gradual_running, _deploy_mode

    was_running = bool(_gradual_running and _gradual_task and not _gradual_task.done())
    if _gradual_cancel_event is not None:
        _gradual_cancel_event.set()
    if _gradual_task and not _gradual_task.done():
        try:
            await asyncio.wait_for(_gradual_task, timeout=2.0)
        except (asyncio.CancelledError, asyncio.TimeoutError, Exception):
            _gradual_task.cancel()

    _gradual_running = False
    _deploy_mode = False
    _deploying_cids.clear()
    _deploying_emails.clear()
    db.reset_deploying_castles_to_idle_db("تم إلغاء التشغيل التدريجي")
    _invalidate_ws_status_cache()

    if was_running:
        log.info("🛑 [Cancel-Queue] تم إلغاء التشغيل التدريجي مع إبقاء الحسابات الشغالة.")
        return {"status": "cancelled", "message": "تم إلغاء التشغيل التدريجي. الحسابات التي بدأت بالفعل مستمرة في العمل."}
    return {"status": "no_op", "message": "لا توجد عملية تشغيل تدريجي جارية حالياً. تم تصفير أي حسابات متبقية."}


@app.post("/api/internal/restart-all", dependencies=[Depends(verify_internal_access)])
async def internal_restart_all_endpoint():
    """إيقاف البوتات العاملة حالياً ثم إعادة تشغيلها تدريجياً بأحدث الإعدادات."""
    global _gradual_running, _deploy_mode, _gradual_cancel_event, _gradual_task

    if _gradual_running and _gradual_task and not _gradual_task.done():
        return {"status": "rejected", "message": "عملية تشغيل تدريجي جارية بالفعل — انتظر انتهاءها أو ألغِها أولاً"}

    running_castles: List[Dict[str, Any]] = []
    seen_cids: Set[str] = set()
    for em, bot in list(bot_manager.bots.items()):
        task = bot_manager.tasks.get(em)
        if not (bot.is_running or (task and not task.done())):
            continue
        cid = getattr(bot, "castle_id", None) or ""
        c_rec = db.get_castle_by_id(cid) if cid else db.get_castle_by_id(em)
        if c_rec:
            rcid = str(c_rec.get("castle_id", "")).strip()
            if rcid and rcid not in seen_cids:
                seen_cids.add(rcid)
                raw_cfg = c_rec.get("config") or {}
                if isinstance(raw_cfg, str):
                    try:
                        raw_cfg = json.loads(raw_cfg) if raw_cfg.strip() else {}
                    except Exception:
                        raw_cfg = {}
                running_castles.append({
                    "castle_id": rcid,
                    "user_id": str(c_rec.get("user_id", "")),
                    "email": str(c_rec.get("email", em)),
                    "password": c_rec.get("password", ""),
                    "config": raw_cfg,
                    "loop_interval": db.normalize_loop_interval(c_rec.get("loop_interval")),
                })

    if not running_castles:
        return {"status": "empty", "message": "لا توجد بوتات شغالة حالياً لإعادة تشغيلها"}

    _gradual_running = True
    _deploy_mode = True
    cancel_ev = asyncio.Event()
    _gradual_cancel_event = cancel_ev

    await bot_manager.stop_all()
    _set_deploying_marks(running_castles, "جاري إعادة تشغيل البوت تدريجياً...")
    shuffled = _interleave_shuffle(running_castles)

    async def _delayed_restart() -> None:
        if await _wait_gradual_delay(cancel_ev, 2.0):
            return
        await _gradual_start_worker(shuffled, cancel_ev)

    _gradual_task = asyncio.create_task(_delayed_restart(), name="gradual-restart")
    return {
        "status": "restarting",
        "total": len(shuffled),
        "message": f"جاري إعادة تشغيل {len(shuffled)} بوت تدريجياً (5-10 ثوانٍ بين كل حساب)",
    }


@app.post("/api/internal/direct-start", dependencies=[Depends(verify_internal_access)])
async def internal_direct_start_endpoint(payload: BotStartPayload):
    """تشغيل مباشر لبوت واحد داخلياً (محمي بالوصول الداخلي)."""
    c = db.get_castle_by_id(payload.castle_id) or db.get_castle_by_id(payload.email)
    target_cid = str(c["castle_id"]) if c else payload.castle_id
    target_email = str(c["email"]) if c else payload.email
    effective_cfg = copy.deepcopy((c.get("config") if c else {}) or {})
    if payload.config:
        effective_cfg.update(payload.config)
    pwd = payload.password or (c.get("password", "") if c else "")
    ok = await _launch_castle_via_manager({
        "castle_id": target_cid,
        "user_id": (c.get("user_id") if c else payload.user_id) or "admin_default",
        "email": target_email,
        "password": pwd,
        "config": effective_cfg,
    })
    return {"status": "started" if ok else "already_running", "castle_id": target_cid, "email": target_email}


@app.get("/api/internal/debug-state", dependencies=[Depends(verify_internal_access)])
def debug_state_endpoint():
    """استعراض الحالة الداخلية للبوتات ووضع النشر للتشخيص السريع."""
    return {
        "deploy_mode": _deploy_mode,
        "gradual_running": _gradual_running,
        "deploying_count": len(_deploying_cids),
        "deploying_cids": sorted(_deploying_cids),
        "auto_resume_pending": os.path.exists(_AUTO_RESUME_FILE),
        "active_bots_count": len(bot_manager.bots),
        "active_emails": list(bot_manager.bots.keys()),
        "tasks_alive": {em: (not t.done()) for em, t in bot_manager.tasks.items()},
    }


# ══════════════════════════════════════════════════════════════════
# 5. حقن الأوامر المباشرة والفحص (Direct Command Injection API)
# ══════════════════════════════════════════════════════════════════

@app.post("/api/cmd/send")
async def send_game_command_api(payload: SendCmdPayload, current_user: Dict[str, Any] = Depends(require_admin)):
    """
    إرسال أمر مباشر ومخصص إلى خادم اللعبة واستلام الرد اللحظي فوراً:
    مثال: cmd=1005 (تدريب أو جمع جنود), cmd=1037 (نبض), cmd=1002 (بيانات القلعة)
    """
    # 1. إذا كان البوت متصلاً في الذاكرة الحية، نستخدم دالة query غير المتزامنة
    bot = bot_manager.get_bot(payload.email)
    if bot and bot.conn and bot.conn.is_connected:
        try:
            resp = await bot.conn.query(
                str(payload.cmd),
                str(payload.subcmd),
                payload.data or {},
                timeout=8.0
            )
            return {"status": "ok", "source": "live_connection", "response": resp}
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"فشل إرسال الأمر عبر الاتصال الحي: {e}")

    # 2. إذا لم يكن البوت متصلاً في الذاكرة، نرسل عبر العميل المباشر RosClient
    try:
        def _exec_direct():
            client = RosClient(email=payload.email)
            try:
                res = client.execute_command(
                    str(payload.cmd),
                    str(payload.subcmd),
                    payload.data or {}
                )
                return res
            finally:
                client.close()

        loop = asyncio.get_running_loop()
        resp = await loop.run_in_executor(None, _exec_direct)
        return {"status": "ok", "source": "direct_client", "response": resp}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"فشل تنفيذ الأمر المباشر: {e}")

# ══════════════════════════════════════════════════════════════════
# 6. واجهات لوحة تحكم المشرف (Admin APIs)
# ══════════════════════════════════════════════════════════════════

@app.get("/api/admin/stats")
def admin_stats(admin: Dict[str, Any] = Depends(require_admin)):
    """إحصائيات المنظومة الفعلية للعملاء (باستبعاد المشرفين) وربطها بحالة البوتات الحية."""
    admin_email = (admin.get("email") or "").strip().lower()
    live_bots = bot_manager.list_all_bots()
    stats = db.get_admin_stats(
        exclude_admin=True,
        exclude_email=admin_email,
        live_bots=live_bots,
    )
    return {
        "status": "ok",
        **stats,
        "active_bots": stats["running_castles"],
    }

@app.get("/api/admin/users")
def admin_users(admin: Dict[str, Any] = Depends(require_admin)):
    """قائمة المستخدمين مع أعداد القلاع الفعلية والقلاع الشغالة الآن لكل مستخدم."""
    admin_email = (admin.get("email") or "").strip().lower()
    live_bots = bot_manager.list_all_bots()
    users = db.get_all_users(
        exclude_admin=True,
        exclude_email=admin_email,
        live_bots=live_bots,
    )
    return {"status": "ok", "users": users}

@app.get("/api/admin/merchants/overview")
def admin_merchants(admin: Dict[str, Any] = Depends(require_admin)):
    """قائمة التجار والنطاقات"""
    return {"status": "ok", "merchants": get_all_merchants()}

@app.post("/api/admin/users/{uid}/subscription")
@app.put("/api/admin/users/{uid}/subscription")
@app.post("/api/admin/user/{uid}/subscription")
@app.put("/api/admin/user/{uid}/subscription")
def admin_update_subscription(
    uid: str,
    payload: Optional[AdminUpdateSubscriptionPayload] = None,
    days: Optional[int] = Query(None),
    admin: Dict[str, Any] = Depends(require_admin)
):
    """تعديل أو تمديد اشتراك مستخدم"""
    if payload and (payload.expires_at or payload.subscription_status or payload.max_castles_allowed is not None):
        with db.get_connection() as conn:
            updates = []
            params = []
            if payload.expires_at:
                updates.append("subscription_end = ?")
                params.append(payload.expires_at)
            if payload.subscription_status:
                st = "approved" if payload.subscription_status == "active" else ("pending" if payload.subscription_status == "pending_approval" else "approved")
                updates.append("status = ?")
                params.append(st)
            if payload.max_castles_allowed is not None:
                updates.append("max_castles = ?")
                params.append(payload.max_castles_allowed)
            if updates:
                params.append(uid)
                conn.execute(f"UPDATE users SET {', '.join(updates)} WHERE uid = ?", params)
    else:
        d = (payload.days if payload and payload.days else None) or days or 30
        db.update_user_subscription(uid, d)

    updated = db.get_user(uid)
    return {"status": "ok", "message": "تم تحديث الاشتراك بنجاح", "user": updated}

@app.post("/api/admin/users/{uid}/ban")
@app.post("/api/admin/user/{uid}/ban")
async def admin_ban_user(
    uid: str,
    payload: Optional[AdminBanUserPayload] = None,
    is_banned: Optional[bool] = Query(None),
    admin: Dict[str, Any] = Depends(require_admin),
):
    """حظر أو فك حظر مستخدم مع إيقاف بوتاته النشطة عند الحظر."""
    target = db.get_user(uid)
    if not target:
        raise HTTPException(status_code=404, detail="المستخدم غير موجود")
    if is_super_admin(target):
        raise HTTPException(status_code=400, detail="لا يمكن حظر حساب المشرف")

    effective_ban = (
        payload.is_banned
        if (payload and payload.is_banned is not None)
        else (is_banned if is_banned is not None else True)
    )
    db.ban_user(uid, effective_ban)

    if effective_ban:
        try:
            for c in db.get_user_castles_summary(uid):
                em = c.get("email")
                if em:
                    try:
                        await bot_manager.stop_bot(em)
                    except Exception:
                        pass
        except Exception:
            pass

    updated = db.get_user(uid)
    return {"status": "ok", "is_banned": effective_ban, "user": updated}

@app.delete("/api/admin/users/{uid}")
@app.delete("/api/admin/user/{uid}")
async def admin_delete_user(uid: str, admin: Dict[str, Any] = Depends(require_admin)):
    """حذف مستخدم بالكامل مع إيقاف بوتاته وتنظيف ارتباطات البروكسي الخاصة به وبقلاعه."""
    target_emails: List[str] = []
    try:
        user_castles = db.get_user_castles_summary(uid)
        for c in user_castles:
            em = c.get("email")
            if em:
                target_emails.append(em)
                try:
                    await bot_manager.stop_bot(em)
                except Exception:
                    pass
    except Exception:
        pass

    db.delete_user(uid)

    try:
        from proxy import remove_user_proxy_bindings
        remove_user_proxy_bindings(uid, target_emails)
    except Exception:
        pass

    return {"status": "ok", "message": "تم حذف المستخدم"}

@app.post("/api/admin/users/{uid}/approve")
@app.post("/api/admin/user/{uid}/approve")
def admin_approve_user(
    uid: str,
    payload: Optional[AdminApproveUserPayload] = None,
    admin: Dict[str, Any] = Depends(require_admin)
):
    """الموافقة على تجربة مستخدم وتفعيل الباقة التجريبية"""
    d = payload.days if payload and payload.days else 3
    mc = payload.max_castles if payload and payload.max_castles else 10
    db.approve_user_trial(uid, days=d, max_castles=mc)
    updated = db.get_user(uid)
    return {"status": "ok", "message": "تمت الموافقة وتفعيل الباقة بنجاح", "user": updated}

@app.post("/api/admin/users/approve-all")
def admin_approve_all(admin: Dict[str, Any] = Depends(require_admin)):
    """الموافقة على جميع المستخدمين المعلقين وتفعيل الباقة التجريبية 3 أيام / 10 قلاع"""
    count = db.approve_all_pending_users(days=3, max_castles=10)
    return {"status": "ok", "approved_count": count}

@app.post("/api/admin/castles/{castle_id}/approve")
@app.post("/api/admin/castle/{castle_id}/approve")
def admin_approve_castle(castle_id: str, admin: Dict[str, Any] = Depends(require_admin)):
    """الموافقة على القلعة"""
    db.approve_castle(castle_id)
    return {"status": "ok", "message": "تمت الموافقة على القلعة"}

@app.post("/api/admin/castles/{castle_id}/reject")
@app.post("/api/admin/castle/{castle_id}/reject")
def admin_reject_castle(castle_id: str, reason: str = "", admin: Dict[str, Any] = Depends(require_admin)):
    """رفض القلعة"""
    db.reject_castle(castle_id, reason)
    return {"status": "ok", "message": "تم رفض القلعة"}

@app.get("/api/admin/live-bots")
@app.get("/api/admin/live-processes")
def admin_live_bots(admin: Dict[str, Any] = Depends(require_admin)):
    """جلب قائمة البوتات النشطة في الذاكرة حالياً مع ربط بيانات القلعة والمالك الفعلية ومعلومات البروكسي."""
    bots = bot_manager.list_all_bots()
    try:
        by_cid, by_email, users_by_uid = db.get_live_castles_metadata()
    except Exception:
        by_cid, by_email, users_by_uid = {}, {}, {}

    for p in bots:
        cid = str(p.get("castle_id") or "").strip()
        em = str(p.get("email") or "").strip().lower()
        c_row = by_cid.get(cid) or by_email.get(em) or {}
        c_info = c_row.get("castle_info") if isinstance(c_row.get("castle_info"), dict) else {}
        owner_uid = str(c_row.get("user_id") or p.get("user_id") or "").strip()
        owner_row = users_by_uid.get(owner_uid) or {}

        if c_row.get("castle_id") and (not cid or cid == em):
            p["castle_id"] = c_row["castle_id"]
        if owner_uid and not p.get("user_id"):
            p["user_id"] = owner_uid
        p["user_email"] = owner_row.get("email") or p.get("user_email") or ""
        p["owner_name"] = owner_row.get("username") or ""
        p["castle_name"] = c_info.get("castle_name") or c_row.get("castle_name") or ""
        p["lord_name"] = c_info.get("lord_name") or ""
        p["server_id"] = c_info.get("server_id") or (p.get("gate_info") or {}).get("kingdom_id") or None
        if not p.get("max_reconnect_attempts"):
            p["max_reconnect_attempts"] = 2

        if not p.get("real_ip"):
            try:
                from proxy import get_proxy_ip_for_email, is_proxy_enabled
                if is_proxy_enabled():
                    em = p.get("email") or ""
                    resolved_ip = get_proxy_ip_for_email(em) or "direct"
                    p["real_ip_type"] = "socks5" if resolved_ip != "direct" else "direct"
                    p["is_proxied"] = (resolved_ip != "direct")
                else:
                    from proxy import get_server_public_ip
                    resolved_ip = get_server_public_ip()
                    p["real_ip_type"] = "direct"
                    p["is_proxied"] = False
                p["real_ip"] = resolved_ip
                p["proxy_ip"] = resolved_ip
            except Exception:
                p["real_ip"] = "direct"
                p["proxy_ip"] = "direct"
                p["real_ip_type"] = "direct"
                p["is_proxied"] = False

    summary = {
        "total_active": len(bots),
        "running": sum(1 for p in bots if p.get("live_category") == "running"),
        "waiting": sum(1 for p in bots if p.get("live_category") == "waiting"),
        "other_login": sum(1 for p in bots if p.get("live_category") == "other_login"),
        "reconnecting": sum(1 for p in bots if p.get("live_category") == "reconnecting"),
        "starting": sum(1 for p in bots if p.get("live_category") == "starting"),
    }
    return {
        "status": "ok",
        "source": "live_memory",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "summary": summary,
        "processes": bots,
        "count": len(bots),
    }

@app.get("/api/admin/users-castles")
def admin_users_castles(admin: Dict[str, Any] = Depends(require_admin)):
    """جلب جميع المستخدمين مع تفاصيل قلاعهم"""
    data = db.get_all_users_with_castles()
    return {"status": "ok", "users": data}

@app.get("/api/admin/banned-castles")
def admin_banned_castles(admin: Dict[str, Any] = Depends(require_admin)):
    """القلاع المحظورة من إدارة اللعبة مع السبب وبيانات المالك (للمشرف الأعلى فقط). قراءة من SQLite والذاكرة الحية بلا أي اتصال بالسيرفر."""
    items: List[Dict[str, Any]] = []
    for c in db.get_banned_castles():
        game_email = c.get("email") or ""
        bot = bot_manager.get_bot(game_email) if game_email else None
        is_live_sealed = bool(bot and getattr(bot, "is_sealed", False))
        s_type, s_reason = _extract_seal_details(
            c.get("status_message"),
            getattr(bot, "seal_type", None) if is_live_sealed else None,
            getattr(bot, "seal_reason", None) if is_live_sealed else None,
        )
        info = c.get("castle_info") or {}
        items.append({
            "castle_id": c.get("castle_id"),
            "game_email": game_email,
            "castle_name": c.get("castle_name") or info.get("castle_name") or "",
            "lord_name": info.get("lord_name") or "",
            "castle_level": info.get("castle_level"),
            "lord_level": info.get("lord_level"),
            "power": info.get("power") or info.get("lord_power"),
            "server_id": info.get("server_id") or "",
            "alliance_name": info.get("alliance_name") or "",
            "is_active": c.get("is_active", True),
            "state": c.get("state") or "",
            "conn_state": c.get("conn_state") or "",
            "seal_type": s_type,
            "seal_reason": s_reason,
            "status_message": c.get("status_message") or "",
            "banned_at": c.get("updated_at") or "",
            "created_at": c.get("created_at") or "",
            "proxy_index": c.get("proxy_index"),
            "owner": {
                "uid": c.get("user_id") or "",
                "email": c.get("owner_email") or "",
                "username": c.get("owner_username") or "",
                "phone": c.get("owner_phone") or "",
                "tenant_domain": c.get("owner_tenant") or "",
                "is_banned": bool(c.get("owner_banned")),
                "subscription_end": c.get("owner_subscription_end") or "",
            },
        })
    return {"status": "ok", "castles": items}

@app.get("/api/admin/proxies")
def admin_proxies(admin: Dict[str, Any] = Depends(require_admin)):
    """استعلام قائمة البروكسيات مع عدد القلاع والمستخدمين المربوطين بكل IP."""
    from proxy import proxy_status
    return proxy_status()

@app.post("/api/admin/proxies/test")
async def admin_test_proxy(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """فحص نفق SOCKS5 لعنوان بروكسي معين وقياس البينج فوراً."""
    proxy_url = str(payload.get("proxy_url", "") or "").strip()
    from proxy import test_single_proxy
    return await test_single_proxy(proxy_url)


def _count_running_bots(emails: List[str]) -> int:
    """عدد القلاع الشغالة حالياً من قائمة إيميلات (قراءة من الذاكرة الحية فقط)."""
    running = 0
    for em in emails:
        bot = bot_manager.get_bot(em)
        if bot and getattr(bot, "is_running", False):
            running += 1
    return running


def _proxy_op_response(result: Dict[str, Any]) -> Dict[str, Any]:
    """توحيد رد عمليات البروكسي اليدوية: خطأ 400 عند الفشل، وإلا إضافة عدد القلاع الشغالة المتأثرة (للتحذير)."""
    if not result.get("ok"):
        raise HTTPException(status_code=400, detail=result.get("msg") or "فشلت العملية")
    result["running_count"] = _count_running_bots(result.get("emails") or [])
    result.pop("emails", None)
    return {"status": "ok", **result}


@app.get("/api/admin/proxies/lookup")
def admin_proxy_lookup(q: str = Query(""), admin: Dict[str, Any] = Depends(require_admin)):
    """بحث بالإيميل أو اسم المستخدم/القلعة لمعرفة البروكسي المخصص لكل قلعة."""
    from proxy import get_proxy_ips
    ips = get_proxy_ips()
    items: List[Dict[str, Any]] = []
    for c in db.search_castles_with_owner(q, limit=20):
        idx = c.get("proxy_index")
        has_idx = idx is not None and int(idx) >= 0 and len(ips) > 0
        info = c.get("castle_info") or {}
        bot = bot_manager.get_bot(c.get("email") or "")
        items.append({
            "castle_id": c.get("castle_id"),
            "email": c.get("email") or "",
            "castle_name": c.get("castle_name") or "",
            "lord_name": info.get("lord_name") or "",
            "state": c.get("state") or "",
            "is_running": bool(bot and getattr(bot, "is_running", False)),
            "proxy_index": (int(idx) % len(ips)) if has_idx else None,
            "proxy_ip": ips[int(idx) % len(ips)] if has_idx else "",
            "owner": {
                "uid": c.get("user_id") or "",
                "email": c.get("owner_email") or "",
                "username": c.get("owner_username") or "",
            },
        })
    return {"status": "ok", "items": items}


@app.post("/api/admin/proxies/assign-castle")
def admin_proxy_assign_castle(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """نقل قلعة واحدة إلى بروكسي يختاره الأدمن يدوياً (يسري عند أول اتصال جديد للقلعة)."""
    from proxy import assign_castle_to_proxy
    return _proxy_op_response(assign_castle_to_proxy(
        str(payload.get("castle_email", "") or ""), payload.get("proxy_index")
    ))


@app.post("/api/admin/proxies/assign-user")
def admin_proxy_assign_user(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """نقل كل قلاع مستخدم إلى بروكسي يختاره الأدمن يدوياً."""
    from proxy import assign_user_to_proxy
    return _proxy_op_response(assign_user_to_proxy(
        str(payload.get("user_id", "") or ""), payload.get("proxy_index")
    ))


@app.post("/api/admin/proxies/drain")
def admin_proxy_drain(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """إخلاء بروكسي: نقل كل قلاعه لبقية البروكسيات بتوزيع متوازن."""
    from proxy import drain_proxy
    return _proxy_op_response(drain_proxy(payload.get("proxy_index")))


@app.post("/api/admin/proxies/unbind")
def admin_proxy_unbind(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """إزالة ارتباط قلعة أو مستخدم ليُعاد تخصيصه تلقائياً عند أول اتصال."""
    from proxy import unbind_castle, unbind_user
    castle_email = str(payload.get("castle_email", "") or "").strip()
    user_id = str(payload.get("user_id", "") or "").strip()
    if castle_email:
        return _proxy_op_response(unbind_castle(castle_email))
    if user_id:
        return _proxy_op_response(unbind_user(user_id))
    raise HTTPException(status_code=400, detail="يجب تحديد قلعة أو مستخدم")

@app.get("/api/admin/network-mode")
def admin_network_mode(admin: Dict[str, Any] = Depends(require_admin)):
    """استعلام نمط الشبكة المعتمد (residential أو free أو direct)."""
    from proxy import get_network_mode, is_proxy_enabled, proxy_status
    status = proxy_status()
    return {
        "status": "ok",
        "network_mode": get_network_mode(),
        "server_ip": status.get("server_ip", ""),
        "enabled": is_proxy_enabled(),
        "total_proxies": status.get("total_proxies", 0),
        "residential_count": status.get("residential_count", 0),
        "free_count": status.get("free_count", 0),
        "active_pool_name": status.get("active_pool_name", ""),
        "total_bound_castles": status.get("total_bound_castles", 0),
        "total_bound_users": status.get("total_bound_users", 0),
    }

@app.post("/api/admin/network-mode/toggle")
def admin_toggle_network_mode(payload: Dict[str, Any], admin: Dict[str, Any] = Depends(require_admin)):
    """تبديل نمط الاتصال بين البروكسيات السكنية والمجانية والاتصال المباشر."""
    mode = str(payload.get("mode", "")).strip().lower()
    if mode not in ("direct", "socks5", "residential", "free"):
        raise HTTPException(status_code=400, detail="نمط الشبكة غير صالح (يجب أن يكون residential أو free أو direct)")

    from proxy import set_network_mode
    active_mode = set_network_mode(mode)
    if active_mode == "residential":
        label = "البروكسيات السكنية المدفوعة (Static Residential)"
    elif active_mode == "free":
        label = "البروكسيات المجانية الاحتياطية (Free Datacenter)"
    else:
        label = "IP السيرفر المباشر"

    return {
        "status": "ok",
        "network_mode": active_mode,
        "message": f"تم تفعيل نمط {label} بنجاح"
    }


# ══════════════════════════════════════════════════════════════════
# 7. قنوات الـ WebSockets اللحظية (Real-time Sockets)
# ══════════════════════════════════════════════════════════════════

@app.websocket("/ws/logs/{castle_id}")
async def ws_logs(websocket: WebSocket, castle_id: str):
    """بث سجلات البوت اللحظية عبر WebSocket إلى واجهة المستخدم"""
    await websocket.accept()
    log_q = _get_or_create_log_queue(castle_id)

    # إرسال رسالة ترحيبية فورية
    await websocket.send_text(f"[{datetime.now().strftime('%H:%M:%S')}] تم الاتصال بقناة سجلات القلعة ({castle_id})")

    c = db.get_castle_by_id(castle_id)
    email = c.get("email") if c else castle_id

    try:
        while True:
            # التأكد المستمر من ربط كولباك السجل بالبوت الحالي في الذاكرة
            bot = bot_manager.get_bot(email)
            if bot and bot._log_callback is None:
                bot._log_callback = lambda m, cid_ref=castle_id: _push_log(cid_ref, m)

            # فحص إذا وُجدت أسطر سجلات في الطابور
            lines = []
            while not log_q.empty() and len(lines) < 20:
                try:
                    lines.append(log_q.get_nowait())
                except queue.Empty:
                    break

            for line in lines:
                await websocket.send_text(line)

            await asyncio.sleep(0.5)
    except (WebSocketDisconnect, asyncio.CancelledError):
        pass


@app.websocket("/ws/status/{castle_id}")
async def ws_single_castle_status(websocket: WebSocket, castle_id: str):
    """بث حالة قلعة محددة للواجهة عبر WebSocket بأقل استهلاك للموارد"""
    await websocket.accept()
    # فحص الذاكرة الحية أولاً لتجنب استعلام SQLite غير الضروري
    bot = bot_manager.get_bot(castle_id)
    if bot:
        email = castle_id
    else:
        c = db.get_castle_by_id(castle_id)
        email = c.get("email") if c else castle_id
    last_sent_status = None
    heartbeat_counter = 0
    try:
        while True:
            bot = bot_manager.get_bot(email)
            if bot and bot.is_running:
                status_str = bot.conn_state if bot.conn_state in ("running", "starting", "waiting", "reconnecting", "disconnected") else "running"
                payload = {
                    "status": status_str,
                    "conn_state": bot.conn_state,
                    "status_message": bot.status_message,
                    "next_run_time": bot.next_run_time,
                    "is_password_error": getattr(bot, "is_password_error", False),
                }
            elif bot and (getattr(bot, "is_password_error", False) or bot.conn_state == "error"):
                payload = {
                    "status": "error",
                    "conn_state": "error",
                    "status_message": bot.status_message or "كلمة المرور غير صحيحة",
                    "next_run_time": None,
                    "is_password_error": True,
                }
            elif bot and (getattr(bot, "is_sealed", False) or bot.conn_state == "sealed"):
                s_type, s_reason = _extract_seal_details(
                    bot.status_message,
                    getattr(bot, "seal_type", None),
                    getattr(bot, "seal_reason", None),
                )
                payload = {
                    "status": "sealed",
                    "conn_state": "sealed",
                    "status_message": bot.status_message or "الحساب محظور",
                    "next_run_time": None,
                    "is_password_error": False,
                    "is_sealed": True,
                    "seal_type": s_type,
                    "seal_reason": s_reason,
                }
            else:
                # القراءة من كاش الذاكرة اللحظي لتجنب استعلام SQLite المتكرر في كل ثانية
                now_ts = time.time()
                cached_entry = _ws_idle_status_cache.get(castle_id)
                if cached_entry and (now_ts - cached_entry[0] < 15.0):
                    c_data = cached_entry[1]
                else:
                    c_data = db.get_castle_by_id(castle_id) or c
                    if c_data:
                        _ws_idle_status_cache[castle_id] = (now_ts, c_data)

                c_st = (c_data.get("conn_state") if c_data else "idle") or "idle"
                c_msg = (c_data.get("status_message") if c_data else "غير قيد التشغيل") or "غير قيد التشغيل"
                is_deploying_db = (castle_id in _deploying_cids) or (c_st == "deploying") or bool(c_data and c_data.get("state") == "deploying")
                if is_deploying_db:
                    payload = {
                        "status": "deploying",
                        "conn_state": "deploying",
                        "status_message": c_msg if c_st == "deploying" else "جاري رفع التغييرات إلى السيرفر... سيتم استئناف البوت تلقائياً",
                        "is_password_error": False,
                        "is_sealed": False,
                        "seal_type": None,
                        "seal_reason": "",
                        "next_run_time": None,
                    }
                else:
                    is_pwd = bool("كلمة" in c_msg or "password" in c_msg.lower())
                    is_sealed_db = (c_st == "sealed")
                    status_str = c_st if c_st in ("error", "sealed") else "idle"
                    s_type, s_reason = _extract_seal_details(c_msg) if is_sealed_db else (None, "")
                    payload = {
                        "status": status_str,
                        "conn_state": c_st if c_st in ("error", "sealed") else "idle",
                        "status_message": c_msg if c_st in ("error", "sealed") else ("متوقف" if c_msg in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة...") else c_msg),
                        "is_password_error": is_pwd,
                        "is_sealed": is_sealed_db,
                        "seal_type": s_type,
                        "seal_reason": s_reason,
                        "next_run_time": None,
                    }

            payload_str = json.dumps(payload, ensure_ascii=False)
            # إرسال التحديث فقط عند تغير الحالة أو كنبض تأكيدي كل 30 ثانية
            if payload_str != last_sent_status or heartbeat_counter >= 15:
                await websocket.send_text(payload_str)
                last_sent_status = payload_str
                heartbeat_counter = 0
            else:

                heartbeat_counter += 1

            await asyncio.sleep(2.0)
    except (WebSocketDisconnect, asyncio.CancelledError):
        pass


@app.websocket("/ws/status")
@app.websocket("/ws/user-status/{user_id}")
async def ws_status(websocket: WebSocket, user_id: Optional[str] = None):
    """بث التحديثات الدورية لكافة البوتات مع تجنب الإرسال المكرر لتقليل استهلاك المعالج والشبكة"""
    await websocket.accept()
    last_payload = None
    heartbeat_counter = 0
    try:
        while True:
            statuses: Dict[str, str] = {}
            for em in list(_deploying_emails):
                statuses[em] = "deploying"
            for email, bot in bot_manager.bots.items():
                if bot.is_running:
                    statuses[email] = "running"
                elif email.lower() in _deploying_emails:
                    statuses[email] = "deploying"
                else:
                    statuses[email] = "idle"

            payload = json.dumps({"type": "status_update", "bots": statuses}, sort_keys=True)
            if payload != last_payload or heartbeat_counter >= 15:
                await websocket.send_text(payload)
                last_payload = payload
                heartbeat_counter = 0
            else:

                heartbeat_counter += 1

            await asyncio.sleep(2.0)
    except (WebSocketDisconnect, asyncio.CancelledError):
        pass


# ══════════════════════════════════════════════════════════════════
# نقطة التشغيل الرئيسية (CLI Entry Point)
# ══════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(description="Revenge of Sultans Bot API Server")
    parser.add_argument("--host", default="0.0.0.0", help="Host IP to bind (default: 0.0.0.0)")
    default_port = int(os.environ.get("PORT", "8765"))
    parser.add_argument("--port", type=int, default=default_port, help=f"Port to listen on (default: {default_port})")
    parser.add_argument("--reload", action="store_true", help="Enable auto-reload for development")
    args = parser.parse_args()

    print(f"""
    ╔══════════════════════════════════════════════════════════════════╗
    ║       👑 Revenge of Sultans Bot API Server (v2.1.0) 👑          ║
    ╠══════════════════════════════════════════════════════════════════╣
    ║  Local URL:    http://localhost:{args.port}                          ║
    ║  Health check: http://localhost:{args.port}/api/system/health        ║
    ║  Dashboard:    http://localhost:5173                             ║
    ║  Database:     SQLite WAL (database/castles.db)                  ║
    ╚══════════════════════════════════════════════════════════════════╝
    """, flush=True)

    uvicorn.run("api_server:app", host=args.host, port=args.port, reload=args.reload)


if __name__ == "__main__":
    main()
