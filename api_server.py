# -*- coding: utf-8 -*-
"""
api_server.py — خادم FastAPI لإدارة ومراقبة بوتات انتقام السلاطين (Revenge of Sultans)
═════════════════════════════════════════════════════════════════════════════════════
يستقبل أوامر من لوحة التحكم (React / Vite) ويدير دورة حياة الحسابات عبر bot_manager.py.
يعتمد كلياً على SQLite المحلية (database/castles.db) و session_cache.json.
مستقل بنسبة 100% عن المحاكيات ولا يحتاج أي ADB أو Frida.

التشغيل:
  python api_server.py
  python api_server.py --port 8080
═════════════════════════════════════════════════════════════════════════════════════
"""

from __future__ import annotations

import argparse
import asyncio
from contextlib import asynccontextmanager
import copy
import json
import logging
import os
import queue
import re
import sys
import threading
import time
from datetime import datetime, timezone, timedelta
from typing import Any, Dict, List, Optional, Set, Tuple

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

# ── تسوية وتصفير حالات القلاع السابقة في قاعدة البيانات عند بدء التشغيل ──
try:
    with db.get_connection() as _startup_conn:
        _startup_conn.execute("""
            UPDATE castle_states 
            SET state = 'idle', conn_state = 'idle', status_message = 'جاهز للتشغيل' 
            WHERE state = 'running' OR conn_state IN ('connected', 'starting', 'waiting', 'deploying', 'reconnecting')
        """)
    log.info("✓ تمت تسوية وتصفير حالات القلاع السابقة في قاعدة البيانات إلى 'idle'.")
except Exception as _reconcile_err:
    log.warning(f"تعذر تصفير حالات القلاع العالقة عند بدء التشغيل: {_reconcile_err}")

# ── إدارة البوتات المركزية ─────────────────────────────────────────
bot_manager = BotManager()

# طوابير السجلات الحية للـ WebSockets
_log_queues: Dict[str, "queue.Queue[str]"] = {}
_log_lock = threading.Lock()
# كاش الذاكرة اللحظي لحالات القلاع الخاملة لحماية SQLite من الاستعلام المتكرر كل ثانيتين
_ws_idle_status_cache: Dict[str, Tuple[float, Dict[str, Any]]] = {}

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
# FastAPI App & CORS & Lifespan
# ══════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(app: FastAPI):
    """إدارة دورة حياة خادم API مع ضمان الإيقاف الآمن لكافة البوتات النشطة عند الإغلاق"""
    yield
    log.info("خادم API يستعد للإغلاق، جارٍ إيقاف كافة البوتات النشطة بأمان...")
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
    "http://localhost,http://localhost:80,http://localhost:81,http://localhost:5173,http://localhost:3000,http://localhost:8000,http://localhost:8001,http://localhost:8080,http://127.0.0.1,http://127.0.0.1:80,http://127.0.0.1:81,http://127.0.0.1:5173,http://127.0.0.1:3000,http://127.0.0.1:8000,http://127.0.0.1:8001,http://127.0.0.1:8080"
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
    arena_type: Literal["kingdom", "global"] = "kingdom"
    auto_claim_rewards: bool = True

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

class MarchManagerConfigModel(BaseModel):
    enabled: bool = False
    max_duration_minutes: int = Field(default=20, ge=1, le=120)

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
    loop_interval: Optional[int] = 60

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
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "summary": summary,
    }

@app.get("/")
def root():
    return {"message": "Revenge of Sultans API Server is running."}

@app.get("/api/manifest.json")
@app.get("/manifest.json")
def get_manifest():
    """توفير ملف manifest.json لتطبيق الـ PWA"""
    manifest_path = os.path.join(_ROOT, "dashboard", "public", "manifest.json")
    if os.path.exists(manifest_path):
        try:
            with open(manifest_path, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            pass
    return {
        "name": "Empire Bot",
        "short_name": "Empire Bot",
        "start_url": "/",
        "scope": "/",
        "display": "standalone",
        "orientation": "portrait-primary",
        "background_color": "#0a0f0a",
        "theme_color": "#10b981",
        "icons": [
            {"src": "/pwa-192x192.png", "sizes": "192x192", "type": "image/png", "purpose": "any"},
            {"src": "/pwa-512x512.png", "sizes": "512x512", "type": "image/png", "purpose": "any"},
            {"src": "/pwa-maskable-192x192.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable"},
            {"src": "/pwa-maskable-512x512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable"},
        ]
    }
# ══════════════════════════════════════════════════════════════════
# 2. إدارة المستخدمين والملف الشخصي (Users APIs)
# ══════════════════════════════════════════════════════════════════

@app.get("/api/users/profile")
@app.get("/api/user/profile")
def get_user_profile(current_user: Dict[str, Any] = Depends(get_current_user)):
    """جلب بيانات الملف الشخصي للمستخدم الحالي"""
    return {"status": "ok", "user": current_user}

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
        bot = bot_manager.get_bot(em)
        if bot:
            live = bot.get_live_info()
            c["conn_state"] = live.get("conn_state", c.get("conn_state"))
            if live.get("is_password_error") or live.get("conn_state") == "error":
                c["state"] = "error"
                c["conn_state"] = "error"
                c["is_password_error"] = True
            elif live.get("is_sealed") or live.get("conn_state") == "sealed":
                c["state"] = "sealed"
                c["conn_state"] = "sealed"
            else:
                c["state"] = "running" if live.get("is_running") else "idle"
            c["status_message"] = live.get("status_message", c.get("status_message"))
            c["conn_message"] = c["status_message"]
            c["next_run_time"] = live.get("next_run_time", c.get("next_run_time"))
        else:
            if c.get("conn_state") == "error" or c.get("state") == "error":
                c["state"] = "error"
                c["conn_state"] = "error"
                if "كلمة" in str(c.get("status_message", "")) or "password" in str(c.get("status_message", "")).lower():
                    c["is_password_error"] = True
            elif c.get("conn_state") == "sealed" or c.get("state") == "sealed":
                c["state"] = "sealed"
                c["conn_state"] = "sealed"
            else:
                c["state"] = "idle"
                c["conn_state"] = "idle"
                if c.get("status_message") in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة..."):
                    c["status_message"] = "متوقف"

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

    bot = bot_manager.get_bot(castle.get("email", ""))
    if bot:
        live = bot.get_live_info()
        castle["conn_state"] = live.get("conn_state", castle.get("conn_state"))
        if live.get("is_password_error") or live.get("conn_state") == "error":
            castle["state"] = "error"
            castle["conn_state"] = "error"
            castle["is_password_error"] = True
        elif live.get("is_sealed") or live.get("conn_state") == "sealed":
            castle["state"] = "sealed"
            castle["conn_state"] = "sealed"
        else:
            castle["state"] = "running" if live.get("is_running") else "idle"
        castle["status_message"] = live.get("status_message", castle.get("status_message"))
        castle["conn_message"] = castle["status_message"]
        castle["next_run_time"] = live.get("next_run_time", castle.get("next_run_time"))
    else:
        if castle.get("conn_state") == "error" or castle.get("state") == "error":
            castle["state"] = "error"
            castle["conn_state"] = "error"
            if "كلمة" in str(castle.get("status_message", "")) or "password" in str(castle.get("status_message", "")).lower():
                castle["is_password_error"] = True
        elif castle.get("conn_state") == "sealed" or castle.get("state") == "sealed":
            castle["state"] = "sealed"
            castle["conn_state"] = "sealed"
        else:
            castle["state"] = "idle"
            castle["conn_state"] = "idle"
            if castle.get("status_message") in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة..."):
                castle["status_message"] = "متوقف"

    return {"status": "ok", "castle": castle}

@app.post("/api/castles")
def create_castle(req: CastleCreateRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
    """إضافة حساب قلعة جديد إلى النظام"""
    uid = current_user.get("uid", "admin_default")
    if db.castle_exists_by_email(req.email):
        raise HTTPException(status_code=400, detail="هذا البريد الإلكتروني مسجل مسبقاً في النظام")

    # إذا توفرت كلمة المرور، نحاول توثيق الحساب فوراً واستخراج الجلسة
    if req.email and req.password:
        try:
            from core.game_client import sdk_login
            auth_res = sdk_login(req.email, req.password)
            if auth_res.get("success"):
                SessionCache.set_account(req.email, auth_res["userId"], auth_res["sessionId"])
                log.info(f"✓ تم توثيق الحساب {req.email} فورياً عند إضافته.")
        except Exception as e:
            log.warning(f"تعذر التوثيق الفوري للحساب {req.email}: {e}")

    created = db.create_castle_db(
        user_id=uid,
        email=req.email,
        password=req.password or "",
        castle_name=req.castle_name or "",
        config={},
        castle_id=req.castle_id,
    )
    return {"status": "ok", "castle": created}

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
    cid = payload.castle_id
    email = payload.email

    # التحقق من صلاحية الاشتراك
    valid, reason = db.check_user_subscription_db(current_user["uid"])
    if not valid:
        raise HTTPException(status_code=403, detail=f"لا يمكن تشغيل البوت: {reason}")

    # التحقق من أن القلعة موجودة ومفعلة
    c = db.get_castle_by_id(cid)
    if not c:
        # إذا لم تكن موجودة، ننشئها تلقائياً بالبريد المحدد
        c = db.create_castle_db(user_id=current_user["uid"], email=email, castle_id=cid)

    if not c.get("is_active"):
        raise HTTPException(status_code=403, detail="هذه القلعة مجمدة أو غير مفعلة حالياً")

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

    # إطلاق البوت عبر bot_manager مع تمرير كلمة المرور وكولباك السجلات
    pwd = payload.password or (c.get("password") if c else "")
    started = await bot_manager.start_bot(
        email,
        config=effective_config,
        password=pwd,
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
        return {
            "castle_id": castle_id,
            "is_password_error": bool(c and ("كلمة" in str(c.get("status_message", "")) or "password" in str(c.get("status_message", "")).lower())),
            "email": email,
            "status": "running" if live["is_running"] else ("error" if (live.get("is_password_error") or live.get("conn_state") == "error") else ("sealed" if (live.get("is_sealed") or live.get("conn_state") == "sealed") else "idle")),
            "conn_state": live["conn_state"],
            "status_message": live["status_message"],
            "uptime_seconds": live["uptime_seconds"],
            "iteration": live["iteration"],
            "next_run_time": live["next_run_time"],
        }

    return {
        "castle_id": castle_id,
        "is_password_error": bool(c and ("كلمة" in str(c.get("status_message", "")) or "password" in str(c.get("status_message", "")).lower())),
        "email": email,
        "status": (c.get("conn_state") if c else "idle") if (c and c.get("conn_state") in ("error", "sealed")) else "idle",
        "conn_state": (c.get("conn_state") if c else "idle") or "idle",
        "status_message": (c.get("status_message") if c else "غير قيد التشغيل") or "غير قيد التشغيل"
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
        else:
            statuses[cid] = "idle"

    return {"status": "ok", "bots": statuses}


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
    """إحصائيات المنظومة الكاملة"""
    db_stats = db.get_admin_stats()
    mgr_stats = bot_manager.get_status_summary()
    return {
        "status": "ok",
        "total_users": db_stats["total_users"],
        "total_castles": db_stats["total_castles"],
        "active_bots": mgr_stats["running_bots"],
        "connected_bots": mgr_stats["connected_bots"],
        "system_health": "online",
    }

@app.get("/api/admin/users")
def admin_users(admin: Dict[str, Any] = Depends(require_admin)):
    """قائمة المستخدمين"""
    return {"status": "ok", "users": db.get_all_users()}

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
def admin_ban_user(uid: str, is_banned: bool = Query(True), admin: Dict[str, Any] = Depends(require_admin)):
    """حظر أو فك حظر مستخدم"""
    db.ban_user(uid, is_banned)
    return {"status": "ok", "is_banned": is_banned}

@app.delete("/api/admin/users/{uid}")
@app.delete("/api/admin/user/{uid}")
def admin_delete_user(uid: str, admin: Dict[str, Any] = Depends(require_admin)):
    """حذف مستخدم بالكامل"""
    db.delete_user(uid)
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
    """جلب قائمة البوتات النشطة في الذاكرة حالياً"""
    bots = bot_manager.list_all_bots()
    return {"status": "ok", "processes": bots, "count": len(bots)}

@app.get("/api/admin/users-castles")
def admin_users_castles(admin: Dict[str, Any] = Depends(require_admin)):
    """جلب جميع المستخدمين مع تفاصيل قلاعهم"""
    data = db.get_all_users_with_castles()
    return {"status": "ok", "users": data}

@app.get("/api/admin/proxies")
def admin_proxies():
    return {"proxies": [], "status": "ok"}

@app.post("/api/admin/proxies/test")
def admin_test_proxy():
    return {"status": "ok", "latency_ms": 120}

@app.get("/api/admin/network-mode")
def admin_network_mode():
    return {"mode": "direct", "status": "ok"}

@app.post("/api/admin/network-mode/toggle")
def admin_toggle_network_mode():
    return {"mode": "direct", "status": "ok"}

@app.post("/api/admin/castles/disable-elf-all")
def admin_disable_elf_all():
    return {"status": "ok", "message": "Disabled"}


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
                payload = {
                    "status": "error",
                    "conn_state": "sealed",
                    "status_message": bot.status_message or "الحساب محظور",
                    "next_run_time": None,
                    "is_password_error": False,
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
                is_pwd = bool("كلمة" in c_msg or "password" in c_msg.lower())
                status_str = c_st if c_st in ("error", "sealed") else "idle"
                payload = {
                    "status": status_str,
                    "conn_state": c_st if c_st in ("error", "sealed") else "idle",
                    "status_message": c_msg if c_st in ("error", "sealed") else ("متوقف" if c_msg in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة...") else c_msg),
                    "is_password_error": is_pwd,
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
            for email, bot in bot_manager.bots.items():
                statuses[email] = "running" if bot.is_running else "idle"

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
    default_port = int(os.environ.get("PORT", "8080"))
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
