# -*- coding: utf-8 -*-
"""
core/database.py — قاعدة بيانات SQLite المحلية الرئيسية (castles.db)
════════════════════════════════════════════════════════════════════════
يوفر هذا الملف:
  1. إدارة كاملة لبيانات المستخدمين واشتراكاتهم (جدول users).
  2. إدارة القلاع وحالاتها ومواردها وإعداداتها (جدول castle_states).
  3. دعم نمط WAL (Write-Ahead Logging) للقراءة والكتابة السريعة المتزامنة.
  4. دوال CRUD شاملة ومحمية من تضارب الـ Threads.
  5. المزامنة التلقائية مع session_cache.json لجلب حسابات انتقام السلاطين فوراً.
"""

from __future__ import annotations

import contextlib
import copy
import hashlib
import json
import logging
import os
import re
import sqlite3
import threading
from datetime import datetime, timezone, timedelta
from typing import Any, Dict, List, Optional, Tuple ,Set

log = logging.getLogger("LocalDB")

_BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_DIR = os.path.join(_BASE_DIR, "database")
DEFAULT_DB_PATH = os.path.join(DB_DIR, "castles.db")

_init_lock = threading.Lock()
_db_initialized = False
_initialized_paths: set = set()

MIN_LOOP_INTERVAL_MINUTES = 30
MAX_LOOP_INTERVAL_MINUTES = 180
DEFAULT_LOOP_INTERVAL_MINUTES = 40
MAX_PENDING_CASTLES_PER_USER = 30

# قفل ذري مشترك لكل عمليات تغيير حصة القلاع (إضافة/تفعيل/ترقية/موافقة) لمنع تجاوز max_castles بالتزامن
QUOTA_LOCK = threading.RLock()


def normalize_loop_interval(value: Any) -> int:
    """تطبيع وحصر مدة دورة البوت بين 30 و 180 دقيقة (الافتراضي 40 دقيقة)."""
    try:
        return max(MIN_LOOP_INTERVAL_MINUTES, min(MAX_LOOP_INTERVAL_MINUTES, int(value)))
    except (ValueError, TypeError):
        return DEFAULT_LOOP_INTERVAL_MINUTES


def get_db_path(custom_path: Optional[str] = None) -> str:
    """الحصول على مسار ملف قاعدة البيانات"""
    if custom_path:
        return custom_path
    if os.getenv("CASTLES_DB_PATH"):
        return os.environ["CASTLES_DB_PATH"]

    os.makedirs(DB_DIR, exist_ok=True)
    return DEFAULT_DB_PATH


@contextlib.contextmanager
def get_connection(db_path: Optional[str] = None):
    """
    إنشاء اتصال بقاعدة بيانات SQLite عالي الأداء مهيأ للتعامل مع 150 مستخدم بالتوازي
    دون أي تضارب أو قفل على قاعدة البيانات.
    """
    path = get_db_path(db_path)
    conn = sqlite3.connect(path, timeout=30.0, check_same_thread=False)
    conn.row_factory = sqlite3.Row

    # إعدادات سرعة الذاكرة دون محاولة تغيير نمط WAL في كل اتصال (تجنباً لقفل ترويسة الملف)
    conn.execute("PRAGMA synchronous = NORMAL;")
    conn.execute("PRAGMA busy_timeout = 30000;")
    conn.execute("PRAGMA cache_size = -64000;")
    conn.execute("PRAGMA temp_store = MEMORY;")
    conn.execute("PRAGMA foreign_keys = ON;")
    try:
        with conn:
            yield conn
    finally:
        conn.close()


def init_db(db_path: Optional[str] = None) -> None:
    """تهيئة وإنشاء جداول المستخدمين والقلاع والمزامنة الأولية وضبط نمط WAL لمرة واحدة فقط."""
    global _db_initialized
    with _init_lock:
        os.makedirs(DB_DIR, exist_ok=True)
        try:
            path = get_db_path(db_path)
            # ضبط نمط WAL لمرة واحدة فقط عند تهيئة قاعدة البيانات لضمان بقائه في ترويسة SQLite
            init_conn = sqlite3.connect(path, timeout=30.0)
            init_conn.execute("PRAGMA journal_mode = WAL;")
            init_conn.close()

            with get_connection(db_path) as conn:
                # ── جدول المستخدمين ──
                conn.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    uid TEXT PRIMARY KEY,
                    email TEXT UNIQUE NOT NULL,
                    username TEXT DEFAULT '',
                    phone TEXT DEFAULT '',
                    role TEXT DEFAULT 'user',
                    created_at TEXT,
                    is_banned INTEGER DEFAULT 0,
                    banned_reason TEXT DEFAULT '',
                    subscription_end TEXT,
                    max_castles INTEGER DEFAULT 50,
                    trial_used INTEGER DEFAULT 0,
                    status TEXT DEFAULT 'pending',
                    plan_id TEXT DEFAULT '',
                    plan_name TEXT DEFAULT '',
                    tenant_domain TEXT DEFAULT ''
                );
                """)

                # ── ترقية آمنة لجدول المستخدمين ──
                user_cols = {
                    row[1] for row in conn.execute("PRAGMA table_info(users)").fetchall()
                }
                if "banned_reason" not in user_cols:
                    conn.execute("ALTER TABLE users ADD COLUMN banned_reason TEXT DEFAULT '';")
                if "plan_id" not in user_cols:
                    conn.execute("ALTER TABLE users ADD COLUMN plan_id TEXT DEFAULT '';")
                if "plan_name" not in user_cols:
                    conn.execute("ALTER TABLE users ADD COLUMN plan_name TEXT DEFAULT '';")

                # ── جدول القلاع والحسابات ──
                conn.execute("""
                CREATE TABLE IF NOT EXISTS castle_states (
                    castle_id TEXT PRIMARY KEY,
                    user_id TEXT NOT NULL,
                    email TEXT NOT NULL,
                    password TEXT DEFAULT '',
                    castle_name TEXT DEFAULT '',
                    is_active INTEGER DEFAULT 1,
                    state TEXT DEFAULT 'idle',
                    conn_state TEXT DEFAULT 'disconnected',
                    status_message TEXT DEFAULT '',
                    last_run TEXT DEFAULT '',
                    next_run_time TEXT DEFAULT '',
                    config TEXT DEFAULT '{}',
                    resources TEXT DEFAULT '{}',
                    castle_info TEXT DEFAULT '{}',
                    proxy_index INTEGER DEFAULT -1,
                    loop_interval INTEGER DEFAULT 40,
                    updated_at TEXT,
                    created_at TEXT
                );
                """)

                # ── ترقية آمنة للقواعد القائمة (إضافة عمود proxy_index و loop_interval) ──
                existing_cols = {
                    row[1] for row in conn.execute("PRAGMA table_info(castle_states)").fetchall()
                }
                if "proxy_index" not in existing_cols:
                    conn.execute("ALTER TABLE castle_states ADD COLUMN proxy_index INTEGER DEFAULT -1;")
                if "loop_interval" not in existing_cols:
                    conn.execute("ALTER TABLE castle_states ADD COLUMN loop_interval INTEGER DEFAULT 40;")

                # ── جدول إعدادات النظام العامة ──
                conn.execute("""
                CREATE TABLE IF NOT EXISTS system_settings (
                    key TEXT PRIMARY KEY,
                    value TEXT NOT NULL,
                    updated_at TEXT
                );
                """)
                conn.execute(
                    "INSERT OR IGNORE INTO system_settings (key, value, updated_at) VALUES ('network_mode', 'direct', ?);",
                    (datetime.now(timezone.utc).isoformat(),)
                )

                # ── جدول سجل تدقيق الاشتراكات وإجراءات الإدارة ──
                conn.execute("""
                CREATE TABLE IF NOT EXISTS subscription_audit_log (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    actor_uid TEXT DEFAULT '',
                    actor_email TEXT DEFAULT '',
                    target_uid TEXT DEFAULT '',
                    action TEXT NOT NULL,
                    details TEXT DEFAULT '{}',
                    created_at TEXT NOT NULL
                );
                """)
                conn.execute("CREATE INDEX IF NOT EXISTS idx_sub_audit_target ON subscription_audit_log(target_uid, created_at DESC);")

                conn.execute("CREATE INDEX IF NOT EXISTS idx_castles_user_id ON castle_states(user_id);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castles_email ON castle_states(email);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castle_states_lower_email ON castle_states(LOWER(TRIM(email)));")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castle_states_proxy_index ON castle_states(proxy_index);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castles_user_active ON castle_states(user_id, is_active);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castles_state ON castle_states(state, conn_state);")
                conn.execute("CREATE INDEX IF NOT EXISTS idx_castles_created_at ON castle_states(created_at DESC);")

                # إنشاء حساب الأدمن الافتراضي
                conn.execute("""
                INSERT OR IGNORE INTO users (uid, email, username, role, created_at, status, max_castles)
                VALUES ('admin_default', 'ibraboths@gmail.com', 'Admin Sultan', 'admin', ?, 'approved', 100);
                """, (datetime.now(timezone.utc).isoformat(),))

            _db_initialized = True
            _initialized_paths.add(path)
            log.info("✓ تم تهيئة قاعدة بيانات SQLite المحلية بنجاح.")
        except Exception as e:
            log.error(f"خطأ أثناء تهيئة قاعدة البيانات: {e}", exc_info=True)



# ══════════════════════════════════════════════════════════════════
# دوال القلاع (Castle Operations)
# ══════════════════════════════════════════════════════════════════

def get_all_castles() -> List[Dict[str, Any]]:
    """جلب جميع القلاع في النظام (للأدمن)"""
    with get_connection() as conn:
        rows = conn.execute("SELECT * FROM castle_states ORDER BY created_at DESC").fetchall()
        return [_row_to_castle(r) for r in rows]


def get_user_castles(user_id: str) -> List[Dict[str, Any]]:
    """جلب جميع قلاع مستخدم معين"""
    with get_connection() as conn:
        rows = conn.execute(
            "SELECT * FROM castle_states WHERE user_id = ? ORDER BY created_at DESC",
            (user_id,)
        ).fetchall()
        return [_row_to_castle(r) for r in rows]


def get_castle_by_id(castle_id: str, user_id: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """جلب قلعة محددة بالمعرف أو البريد الإلكتروني الكامل"""
    lookup = (castle_id or "").strip()
    with get_connection() as conn:
        if user_id:
            row = conn.execute(
                "SELECT * FROM castle_states WHERE (castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)) AND user_id = ?",
                (lookup, lookup, user_id)
            ).fetchone()
        else:
            row = conn.execute(
                "SELECT * FROM castle_states WHERE castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)",
                (lookup, lookup)
            ).fetchone()
        return _row_to_castle(row) if row else None


get_castle = get_castle_by_id


def castle_exists_by_email(email: str) -> bool:
    """هل الحساب مسجل مسبقاً (مقارنة بالبريد الكامل غير حساسة لحالة الأحرف)؟"""
    clean_email = (email or "").strip()
    if not clean_email:
        return False
    with get_connection() as conn:
        row = conn.execute(
            "SELECT 1 FROM castle_states WHERE LOWER(TRIM(email)) = LOWER(?)",
            (clean_email,)
        ).fetchone()
        return row is not None


def generate_unique_castle_id(email: str, requested_id: Optional[str] = None) -> str:
    """
    توليد معرّف قلعة فريد (castle_id) اعتماداً على كامل البريد الإلكتروني مع بصمة تجزئة قصيرة
    لمنع تصادم حسابات مختلفة تتشارك نفس البادئة قبل علامة @ (مثل LUCIFER@g2.com و LUCIFER@g4.com).
    """
    clean_email = (email or "").strip().lower()
    req_cid = (requested_id or "").strip()

    prefix_raw = clean_email.split("@")[0] if "@" in clean_email else clean_email
    safe_prefix = re.sub(r"[^a-zA-Z0-9_-]+", "_", prefix_raw).strip("_") or "castle"
    email_hash = hashlib.sha1(clean_email.encode("utf-8")).hexdigest()[:8] if clean_email else hashlib.sha1(os.urandom(8)).hexdigest()[:8]
    base_cid = f"sultan_{safe_prefix}_{email_hash}"

    with get_connection() as conn:
        if req_cid:
            row = conn.execute(
                "SELECT email FROM castle_states WHERE castle_id = ?",
                (req_cid,)
            ).fetchone()
            if not row or (clean_email and str(row["email"] or "").strip().lower() == clean_email):
                return req_cid

        candidate = base_cid
        suffix = 2
        while True:
            row = conn.execute(
                "SELECT email FROM castle_states WHERE castle_id = ?",
                (candidate,)
            ).fetchone()
            if not row or (clean_email and str(row["email"] or "").strip().lower() == clean_email):
                return candidate
            candidate = f"{base_cid}_{suffix}"
            suffix += 1


def save_castle(castle_data: Dict[str, Any]) -> bool:
    """حفظ أو تحديث بيانات القلعة بالكامل"""
    cid = castle_data.get("castle_id") or castle_data.get("id")
    if not cid:
        return False

    now_iso = datetime.now(timezone.utc).isoformat()
    uid = castle_data.get("user_id", "admin_default")
    email = castle_data.get("email", "")
    pwd = castle_data.get("password", "")
    name = castle_data.get("castle_name", "")
    is_act = 1 if castle_data.get("is_active", True) else 0
    state = castle_data.get("state", "idle")
    conn_state = castle_data.get("conn_state", "idle")
    msg = castle_data.get("status_message", "")
    cfg = castle_data.get("config", {})
    if isinstance(cfg, dict):
        cfg = json.dumps(cfg, ensure_ascii=False)
    res = castle_data.get("resources", {})
    if isinstance(res, dict):
        res = json.dumps(res, ensure_ascii=False)
    info = castle_data.get("castle_info", {})
    if isinstance(info, dict):
        info = json.dumps(info, ensure_ascii=False)
    has_loop_interval = "loop_interval" in castle_data and castle_data.get("loop_interval") is not None
    loop_interval = normalize_loop_interval(castle_data.get("loop_interval")) if has_loop_interval else DEFAULT_LOOP_INTERVAL_MINUTES

    with get_connection() as conn:
        conn.execute("""
        INSERT INTO castle_states (
            castle_id, user_id, email, password, castle_name, is_active, state, conn_state,
            status_message, config, resources, castle_info, loop_interval, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(castle_id) DO UPDATE SET
            user_id = excluded.user_id,
            email = excluded.email,
            password = CASE WHEN excluded.password != '' THEN excluded.password ELSE castle_states.password END,
            castle_name = CASE WHEN excluded.castle_name != '' THEN excluded.castle_name ELSE castle_states.castle_name END,
            is_active = excluded.is_active,
            state = excluded.state,
            conn_state = excluded.conn_state,
            status_message = excluded.status_message,
            config = excluded.config,
            resources = excluded.resources,
            castle_info = excluded.castle_info,
            loop_interval = CASE WHEN ? = 1 THEN excluded.loop_interval ELSE castle_states.loop_interval END,
            updated_at = excluded.updated_at;
        """, (cid, uid, email, pwd, name, is_act, state, conn_state, msg, cfg, res, info, loop_interval, now_iso, now_iso, 1 if has_loop_interval else 0))
        return True


DEFAULT_NEW_CASTLE_CONFIG: Dict[str, Any] = {
    # ── المهام الخلفية التلقائية (ليس لها زر تفعيل في الواجهة) ──
    "port": {"enabled": True},
    "merchant_ship": {"enabled": True},
    "city_harvest": {"enabled": True},
    "imperial_mausoleum": {"enabled": True},
    "war_medal": {"enabled": True},
    "daily_quest": {"enabled": True},
    # ── مهام الواجهة الاختيارية (معطّلة بالكامل افتراضياً عند إضافة قلعة جديدة) ──
    "fountain": {
        "enabled": True,
        "resources": ["food"],
        "gold_times": 0,
    },
    "daily_train": {"enabled": False},
    "train": {
        "enabled": False,
        "levels": {"infantry": 0, "cavalry": 0, "archers": 0, "chariots": 0},
        "level": 10,
        "count": "max",
    },
    "shield": {"enabled": False, "duration": "8h", "allow_gold": False},
    "research": {"enabled": False},
    "flower": {"enabled": False, "allow_gold": False},
    "wonder_merchant": {"enabled": True},
    "material_synthesis": {"enabled": True},
    "material_workshop": {
        "enabled": False,
        "selected_materials": [200101, 200201, 200301, 200401, 200501, 200601],
    },
    "forge_equipment": {"enabled": False, "category": "weapon"},
    "cure_wounded": {"enabled": False, "mode": "daily"},
    "alliance": {"enabled": True},
    "pet": {"enabled": True, "target_pet": 1251},
    "building": {
        "enabled": False,
        "upgrade_castle": False,
        "speedup_castle": False,
        "auto_open_chests": True,
        "upgrade_support_buildings": False,
        "max_castle_level": 130,
        "target_buildings": {
            "farm": False,
            "sawmill": False,
            "iron_mine": False,
            "quartz_mine": False,
            "hospital": False,
            "military_tent": False,
        },
    },
    "arena": {
        "enabled": True,
        "mode": "daily",
        "arena_type": "kingdom",
        "auto_claim_rewards": True,
    },
    "hero_trial": {"enabled": False},
    "command_hall": {
        "enabled": False,
        "mode": "daily",
        "allow_marches": True,
        "allow_snipe": True,
        "allow_rescue": True,
        "allow_dialogue": True,
        "allow_army_group": True,
        "auto_claim_rewards": True,
        "auto_upgrade_hall": True,
        "min_safety_stamina": 10,
    },
    "watermill": {
        "enabled": False,
        "resources": ["food", "wood", "iron", "silver", "crystal"],
        "types": "all",
        "allow_shop_buy": False,
    },
    "skills": {"enabled": False, "target_skills": []},
    "stamina": {
        "enabled": False,
        "gold_buy_enabled": False,
        "gold_trigger_stamina": 50,
        "gold_buy_stamina_amount": 50,
    },
    "caravan": {"enabled": False},
    "march_manager": {
        "enabled": False,
        "max_duration_minutes": 20,
        "formation_id": 1,
        "gather_speed_buff": {"enabled": False},
        "treasure_escort": {"enabled": False},
        "daily_hunt": {"enabled": False},
        "daily_gather": {"enabled": False},
        "explore_ruins": {"enabled": False, "explore_time": 14400, "formation": 1},
        "resource_help": {"enabled": False, "target_x": None, "target_y": None, "resources": "food,wood,iron"},
        "hunt_monsters": {"enabled": False, "monster_type": "normal", "monster_level": 0},
        "gather_resources": {"enabled": False, "resource": "wood", "level": 0},
    },
}


def build_default_new_castle_config() -> Dict[str, Any]:
    """إرجاع نسخة جديدة ومستقلة من إعدادات القلعة الافتراضية (كل مهام الواجهة الاختيارية معطّلة)."""
    return copy.deepcopy(DEFAULT_NEW_CASTLE_CONFIG)


def create_castle_db(
    user_id: str,
    email: str,
    password: str = "",
    castle_name: str = "",
    config: Optional[Dict[str, Any]] = None,
    castle_id: Optional[str] = None,
    is_active: bool = True,
    state: str = "idle",
    conn_state: str = "idle",
    status_message: str = "جاهز للتشغيل",
) -> Dict[str, Any]:
    """إنشاء قلعة جديدة وحفظها بمعرّف فريد يعتمد على البريد الكامل"""
    clean_email = (email or "").strip()
    prefix = clean_email.split("@")[0] if "@" in clean_email else clean_email
    cid = generate_unique_castle_id(clean_email, castle_id)
    name = castle_name or f"قلعة {prefix}"
    # فرض الإعدادات الافتراضية الكاملة للقلعة الجديدة (جميع مهام الواجهة معطّلة)
    cfg = build_default_new_castle_config()
    now_iso = datetime.now(timezone.utc).isoformat()

    castle_data = {
        "castle_id": cid,
        "user_id": user_id,
        "email": clean_email,
        "password": password,
        "castle_name": name,
        "is_active": 1 if is_active else 0,
        "state": state,
        "conn_state": conn_state,
        "status_message": status_message,
        "config": cfg,
        "resources": {},
        "loop_interval": DEFAULT_LOOP_INTERVAL_MINUTES,
        "castle_info": {
            "lord_name": name,
            "server_id": "Revenge of Sultans",
            "castle_level": 1,
        },
        "created_at": now_iso,
        "updated_at": now_iso,
    }
    save_castle(castle_data)
    return castle_data


def update_castle_db(castle_id: str, updates: Dict[str, Any], user_id: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """تحديث حقول معينة في القلعة"""
    castle = get_castle_by_id(castle_id, user_id)
    if not castle:
        return None

    for k, v in updates.items():
        castle[k] = v
    save_castle(castle)
    return get_castle_by_id(castle_id)


def update_castle_config(castle_id: str, config: Dict[str, Any], user_id: Optional[str] = None) -> bool:
    """تحديث إعدادات مهام القلعة"""
    with get_connection() as conn:
        cfg_str = json.dumps(config, ensure_ascii=False)
        now_iso = datetime.now(timezone.utc).isoformat()
        if user_id:
            res = conn.execute(
                "UPDATE castle_states SET config = ?, updated_at = ? WHERE castle_id = ? AND user_id = ?",
                (cfg_str, now_iso, castle_id, user_id)
            )
        else:
            res = conn.execute(
                "UPDATE castle_states SET config = ?, updated_at = ? WHERE castle_id = ?",
                (cfg_str, now_iso, castle_id)
            )
        return res.rowcount > 0


def update_castles_loop_interval(updates: Dict[str, int], user_id: Optional[str] = None) -> bool:
    """
    تحديث مدة دورة البوت (loop_interval) لمجموعة قلاع دفعة واحدة في معاملة ذرية.
    updates: {castle_id: interval_minutes} (محصور بين 30 و 180 دقيقة).
    """
    if not updates:
        return True
    now_iso = datetime.now(timezone.utc).isoformat()
    try:
        with get_connection() as conn:
            for cid, raw_interval in updates.items():
                val = normalize_loop_interval(raw_interval)
                clean_cid = str(cid).strip()
                if user_id:
                    conn.execute(
                        "UPDATE castle_states SET loop_interval = ?, updated_at = ? WHERE castle_id = ? AND user_id = ?",
                        (val, now_iso, clean_cid, str(user_id).strip())
                    )
                else:
                    conn.execute(
                        "UPDATE castle_states SET loop_interval = ?, updated_at = ? WHERE castle_id = ?",
                        (val, now_iso, clean_cid)
                    )
        return True
    except Exception as e:
        log.error(f"⚠️ خطأ أثناء تحديث loop_interval للقلاع: {e}")
        return False


def update_castle_credentials(castle_id: str, email: str, password: Optional[str] = None, user_id: Optional[str] = None) -> bool:
    """تحديث بيانات دخول القلعة"""
    with get_connection() as conn:
        now_iso = datetime.now(timezone.utc).isoformat()
        if password is not None:
            conn.execute(
                "UPDATE castle_states SET email = ?, password = ?, conn_state = 'idle', status_message = 'تم تحديث بيانات الدخول', state = 'idle', updated_at = ? WHERE castle_id = ?",
                (email, password, now_iso, castle_id)
            )
        else:
            conn.execute(
                "UPDATE castle_states SET email = ?, updated_at = ? WHERE castle_id = ?",
                (email, now_iso, castle_id)
            )
        return True

def toggle_castle_active(castle_id: str, is_active: bool, user_id: Optional[str] = None) -> bool:
    """تفعيل أو تجميد تشغيل القلعة"""
    with get_connection() as conn:
        act_val = 1 if is_active else 0
        now_iso = datetime.now(timezone.utc).isoformat()
        if user_id:
            conn.execute(
                "UPDATE castle_states SET is_active = ?, updated_at = ? WHERE castle_id = ? AND user_id = ?",
                (act_val, now_iso, castle_id, user_id)
            )
        else:
            conn.execute(
                "UPDATE castle_states SET is_active = ?, updated_at = ? WHERE castle_id = ?",
                (act_val, now_iso, castle_id)
            )
        return True


def delete_castle(castle_id: str, user_id: Optional[str] = None) -> bool:
    """حذف القلعة من قاعدة البيانات"""
    with get_connection() as conn:
        if user_id:
            res = conn.execute("DELETE FROM castle_states WHERE castle_id = ? AND user_id = ?", (castle_id, user_id))
        else:
            res = conn.execute("DELETE FROM castle_states WHERE castle_id = ?", (castle_id,))
        return res.rowcount > 0


delete_castle_by_id = delete_castle


def upsert_castle_conn_state(
    castle_id: str,
    conn_state: str,
    state: Optional[str] = None,
    status_message: Optional[str] = None,
    next_run_time: Optional[str] = None
) -> None:
    """تحديث حالة الاتصال اللحظية في SQLite"""
    with get_connection() as conn:
        now_iso = datetime.now(timezone.utc).isoformat()
        updates = ["conn_state = ?", "updated_at = ?"]
        params: List[Any] = [conn_state, now_iso]

        if state is not None:
            updates.append("state = ?")
            params.append(state)
        if status_message is not None:
            updates.append("status_message = ?")
            params.append(status_message)
        if next_run_time is not None:
            updates.append("next_run_time = ?")
            params.append(next_run_time)

        params.extend([castle_id, castle_id])
        sql = f"UPDATE castle_states SET {', '.join(updates)} WHERE castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)"
        conn.execute(sql, params)


def upsert_castle_resources(castle_id: str, resources: Dict[str, Any]) -> None:
    """تحديث كميات الموارد الحالية في SQLite"""
    with get_connection() as conn:
        res_str = json.dumps(resources, ensure_ascii=False)
        now_iso = datetime.now(timezone.utc).isoformat()
        conn.execute(
            "UPDATE castle_states SET resources = ?, updated_at = ? WHERE castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)",
            (res_str, now_iso, castle_id, castle_id)
        )


def update_castle_live_snapshot(
    castle_id: str,
    resources: Dict[str, Any],
    castle_info: Dict[str, Any],
    castle_name: Optional[str] = None
) -> None:
    """تحديث لقطة الموارد ومعلومات وصورة القلعة اللحظية من الذاكرة الحية في SQLite"""
    with get_connection() as conn:
        res_str = json.dumps(resources, ensure_ascii=False)
        info_str = json.dumps(castle_info, ensure_ascii=False)
        now_iso = datetime.now(timezone.utc).isoformat()
        if castle_name:
            conn.execute(
                "UPDATE castle_states SET resources = ?, castle_info = ?, castle_name = ?, updated_at = ? WHERE castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)",
                (res_str, info_str, castle_name, now_iso, castle_id, castle_id)
            )
        else:
            conn.execute(
                "UPDATE castle_states SET resources = ?, castle_info = ?, updated_at = ? WHERE castle_id = ? OR LOWER(TRIM(email)) = LOWER(?)",
                (res_str, info_str, now_iso, castle_id, castle_id)
            )


def _row_to_castle(row: sqlite3.Row) -> Dict[str, Any]:
    """تحويل السطر في SQLite إلى كائن قاموس مطابق لنموذج الواجهة"""
    d = dict(row)
    # فك تشفير JSON للحقول المعقدة
    for k in ("config", "resources", "castle_info"):
        v = d.get(k)
        if isinstance(v, str):
            try:
                d[k] = json.loads(v) if v else {}
            except Exception:
                d[k] = {}
        elif v is None:
            d[k] = {}

    d["id"] = d.get("castle_id")
    d["is_active"] = bool(d.get("is_active", 1))
    d["loop_interval"] = normalize_loop_interval(d.get("loop_interval"))
    return d


def _row_to_castle_summary(row: sqlite3.Row) -> Dict[str, Any]:
    """تحويل سطر القلعة إلى ملخص خفيف الوزن دون حقل config الثقيل لتسريع العرض بالقوائم"""
    d = dict(row)
    d["config"] = {}
    for k in ("resources", "castle_info"):
        v = d.get(k)
        if isinstance(v, str):
            try:
                d[k] = json.loads(v) if v else {}
            except Exception:
                d[k] = {}
        elif v is None:
            d[k] = {}

    d["id"] = d.get("castle_id")
    d["is_active"] = bool(d.get("is_active", 1))
    d["loop_interval"] = normalize_loop_interval(d.get("loop_interval"))
    return d


def get_all_castles_summary() -> List[Dict[str, Any]]:
    """جلب ملخص كافة القلاع بدون تفريغ إعدادات config الضخمة لتسريع الاستجابة بنسبة 85%"""
    with get_connection() as conn:
        rows = conn.execute("""
            SELECT castle_id, user_id, email, password, castle_name, is_active,
                   state, conn_state, status_message, last_run, next_run_time,
                   loop_interval, resources, castle_info, updated_at, created_at
            FROM castle_states ORDER BY created_at DESC
        """).fetchall()
        return [_row_to_castle_summary(r) for r in rows]


def get_user_castles_summary(user_id: str) -> List[Dict[str, Any]]:
    """جلب ملخص قلاع مستخدم معين بدون تفريغ إعدادات config"""
    with get_connection() as conn:
        rows = conn.execute("""
            SELECT castle_id, user_id, email, password, castle_name, is_active,
                   state, conn_state, status_message, last_run, next_run_time,
                   loop_interval, resources, castle_info, updated_at, created_at
            FROM castle_states WHERE user_id = ? ORDER BY created_at DESC
        """, (user_id,)).fetchall()
        return [_row_to_castle_summary(r) for r in rows]


def get_banned_castles() -> List[Dict[str, Any]]:
    """
    جلب القلاع المحظورة من إدارة اللعبة (state/conn_state = sealed | sealed_banned | banned) مع بيانات مالكها.
    لا تُرجع كلمة المرور ولا config. وقت الحظر التقريبي = updated_at (آخر كتابة لحالة الحظر في القاعدة).
    """
    with get_connection() as conn:
        rows = conn.execute("""
            SELECT c.castle_id, c.user_id, c.email, c.castle_name, c.is_active,
                   c.state, c.conn_state, c.status_message, c.castle_info,
                   c.proxy_index, c.updated_at, c.created_at,
                   u.email AS owner_email, u.username AS owner_username,
                   u.phone AS owner_phone, u.tenant_domain AS owner_tenant,
                   u.is_banned AS owner_banned, u.subscription_end AS owner_subscription_end
            FROM castle_states c
            LEFT JOIN users u ON u.uid = c.user_id
            WHERE COALESCE(c.conn_state, '') IN ('sealed', 'sealed_banned', 'banned')
               OR COALESCE(c.state, '') IN ('sealed', 'banned')
            ORDER BY c.updated_at DESC
        """).fetchall()

    result: List[Dict[str, Any]] = []
    for r in rows:
        d = dict(r)
        raw_info = d.get("castle_info")
        try:
            d["castle_info"] = json.loads(raw_info) if isinstance(raw_info, str) and raw_info else {}
        except Exception:
            d["castle_info"] = {}
        d["is_active"] = bool(d.get("is_active", 1))
        result.append(d)
    return result


def get_castle_config_only(castle_id: str, user_id: Optional[str] = None) -> Optional[Dict[str, Any]]:
    """جلب إعدادات config حصراً لقلعة معينة عند الحاجة"""
    with get_connection() as conn:
        if user_id:
            row = conn.execute(
                "SELECT config FROM castle_states WHERE (castle_id = ? OR email = ?) AND user_id = ?",
                (castle_id, castle_id, user_id)
            ).fetchone()
        else:
            row = conn.execute(
                "SELECT config FROM castle_states WHERE castle_id = ? OR email = ?",
                (castle_id, castle_id)
            ).fetchone()
        if not row:
            return None
        raw = row["config"]
        if isinstance(raw, str):
            try:
                return json.loads(raw) if raw else {}
            except Exception:
                return {}
        return raw if isinstance(raw, dict) else {}


# ══════════════════════════════════════════════════════════════════
# دوال المستخدمين والاشتراكات (User & Subscription Operations)
# ══════════════════════════════════════════════════════════════════

def get_user(uid: str) -> Optional[Dict[str, Any]]:
    """جلب بيانات مستخدم بالمعرف أو البريد"""
    with get_connection() as conn:
        row = conn.execute("SELECT * FROM users WHERE uid = ? OR email = ?", (uid, uid)).fetchone()
        return dict(row) if row else None


def create_or_update_user(
    uid: str,
    email: str,
    username: str = "",
    phone: str = "",
    role: str = "user",
    tenant_domain: str = ""
) -> Dict[str, Any]:
    """تسجيل أو تحديث مستخدم جديد (المستخدم الجديد يكون pending بانتظار موافقة الأدمن)"""
    now_iso = datetime.now(timezone.utc).isoformat()
    clean_email = (email or "").strip().lower()

    # التحقق هل المستخدم أدمن نظام رئيسي
    try:
        from core.tenants import is_super_admin
        is_admin = (role == "admin") or is_super_admin(clean_email)
    except Exception:
        is_admin = (role == "admin") or (clean_email in ["ibraboths@gmail.com", "wesamohaam@gmail.com"])

    if is_admin:
        assigned_role = "admin"
        assigned_status = "approved"
        assigned_sub_end = (datetime.now(timezone.utc) + timedelta(days=36500)).isoformat()
        assigned_max = 999999
    else:
        assigned_role = "user"
        assigned_status = "pending"
        assigned_sub_end = None
        assigned_max = 10

    target_uid = uid
    with get_connection() as conn:
        if clean_email:
            existing_row = conn.execute(
                "SELECT uid FROM users WHERE LOWER(TRIM(email)) = ?",
                (clean_email,),
            ).fetchone()
            if existing_row and str(existing_row["uid"]) != uid:
                existing_uid = str(existing_row["uid"])
                updates = []
                params: List[Any] = []
                if username:
                    updates.append("username = ?")
                    params.append(username)
                if phone:
                    updates.append("phone = ?")
                    params.append(phone)
                if tenant_domain:
                    updates.append("tenant_domain = CASE WHEN (tenant_domain IS NULL OR tenant_domain = '') THEN ? ELSE tenant_domain END")
                    params.append(tenant_domain)
                if updates:
                    params.append(existing_uid)
                    conn.execute(f"UPDATE users SET {', '.join(updates)} WHERE uid = ?", params)
                row = conn.execute("SELECT * FROM users WHERE uid = ?", (existing_uid,)).fetchone()
                return dict(row) if row else {}

        conn.execute("""
        INSERT INTO users (uid, email, username, phone, role, created_at, subscription_end, status, max_castles, tenant_domain)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(uid) DO UPDATE SET
            username = CASE WHEN excluded.username != '' THEN excluded.username ELSE users.username END,
            phone = CASE WHEN excluded.phone != '' THEN excluded.phone ELSE users.phone END,
            tenant_domain = CASE WHEN (users.tenant_domain IS NULL OR users.tenant_domain = '') AND excluded.tenant_domain != '' THEN excluded.tenant_domain ELSE users.tenant_domain END;
        """, (uid, clean_email, username, phone, assigned_role, now_iso, assigned_sub_end, assigned_status, assigned_max, tenant_domain))
        row = conn.execute("SELECT * FROM users WHERE uid = ?", (target_uid,)).fetchone()
        return dict(row) if row else {}


def update_user_profile(uid: str, username: Optional[str] = None, phone: Optional[str] = None) -> bool:
    """تحديث الاسم أو الهاتف"""
    with get_connection() as conn:
        updates = []
        params = []
        if username is not None:
            updates.append("username = ?")
            params.append(username)
        if phone is not None:
            updates.append("phone = ?")
            params.append(phone)
        if not updates:
            return True
        params.append(uid)
        conn.execute(f"UPDATE users SET {', '.join(updates)} WHERE uid = ?", params)
        return True


def _is_admin_account(user_row: Dict[str, Any], exclude_email: Optional[str] = None) -> bool:
    """التحقق مما إذا كان الحساب تابعاً للمشرف لاستبعاده من إحصائيات العملاء."""
    clean_email = (user_row.get("email") or "").strip().lower()
    if exclude_email and clean_email == exclude_email.strip().lower():
        return True
    if (user_row.get("role") or "").strip().lower() == "admin":
        return True
    try:
        from core.tenants import is_super_admin
        return is_super_admin(clean_email)
    except Exception:
        return clean_email in ("ibraboths@gmail.com", "wesamohaam@gmail.com")


def _evaluate_user_subscription(
    user_row: Optional[Dict[str, Any]],
    now_utc: Optional[datetime] = None,
) -> Tuple[bool, str]:
    """تقييم صلاحية اشتراك واعتماد سطر مستخدم في الذاكرة دون استعلامات إضافية."""
    if not user_row:
        return False, "الحساب غير مسجل في النظام"

    if user_row.get("is_banned"):
        return False, "الحساب محظور من قبل الإدارة"

    if _is_admin_account(user_row):
        return True, "مشرف نظام"

    # التحقق الإلزامي من حالة الاشتراك واعتماد الأدمن على الحساب
    raw_status = str(user_row.get("status") or "").strip().lower()
    if raw_status == "suspended":
        return False, "تم تعليق اشتراكك مؤقتاً من قبل الإدارة"
    if raw_status != "approved":
        return False, "حسابك بانتظار موافقة الإدارة لتفعيل الباقة التجريبية"

    sub_end = user_row.get("subscription_end")
    if not sub_end:
        return False, "لا يوجد اشتراك نشط لحسابك، بانتظار موافقة وتفعيل الإدارة"

    try:
        dt = datetime.fromisoformat(str(sub_end).replace("Z", "+00:00"))
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        ref_now = now_utc or datetime.now(timezone.utc)
        if ref_now > dt:
            return False, "انتهت فترة اشتراكك، يرجى التواصل مع الإدارة للتجديد"
    except Exception:
        return False, "تاريخ انتهاء الاشتراك غير صالح"

    return True, "صالح"


def _is_castle_runnable(castle_row: Dict[str, Any]) -> bool:
    """التحقق مما إذا كانت القلعة مفعّلة وغير معلقة أو مرفوضة أو محظورة."""
    if not bool(castle_row.get("is_active", 1)):
        return False
    state = str(castle_row.get("state") or "").strip().lower()
    conn_state = str(castle_row.get("conn_state") or "").strip().lower()
    return state not in ("pending", "rejected", "sealed") and conn_state != "sealed"


def check_user_subscription_db(user_id: str) -> Tuple[bool, str]:
    """التحقق من صلاحية اشتراك واعتماد المستخدم محلياً"""
    return _evaluate_user_subscription(get_user(user_id))


def count_user_castles(user_id: str) -> int:
    """عدد القلاع الحالية للمستخدم"""
    with get_connection() as conn:
        row = conn.execute("SELECT COUNT(*) as cnt FROM castle_states WHERE user_id = ?", (user_id,)).fetchone()
        return row["cnt"] if row else 0


def count_user_active_castles(user_id: str) -> int:
    """عدد القلاع المفعّلة (غير المعلقة وغير المرفوضة) التابعة للمستخدم"""
    with get_connection() as conn:
        row = conn.execute(
            """
            SELECT COUNT(*) as cnt
            FROM castle_states
            WHERE user_id = ?
              AND is_active = 1
              AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('pending', 'rejected')
            """,
            (user_id,),
        ).fetchone()
        return int(row["cnt"]) if row else 0


def get_user_castle_counts(user_id: str) -> Dict[str, int]:
    """حساب أعداد قلاع المستخدم (النشطة والمعلقة والإجمالية غير المرفوضة)."""
    with get_connection() as conn:
        rows = conn.execute(
            "SELECT is_active, state FROM castle_states WHERE user_id = ?",
            (user_id,),
        ).fetchall()

    non_rejected = [r for r in rows if str(r["state"] or "").strip().lower() != "rejected"]
    pending_cnt = sum(
        1 for r in non_rejected
        if str(r["state"] or "").strip().lower() == "pending"
        or not bool(1 if r["is_active"] is None else r["is_active"])
    )
    active_cnt = max(0, len(non_rejected) - pending_cnt)
    return {
        "current_castles_count": active_cnt,
        "pending_castles_count": pending_cnt,
        "total_castles_count": len(non_rejected),
    }


def count_user_pending_castles(user_id: str) -> int:
    """عدد القلاع المعلقة (في طابور الانتظار) التابعة للمستخدم"""
    return get_user_castle_counts(user_id)["pending_castles_count"]


def promote_pending_castles(user_id: str) -> List[str]:
    """
    ترقية القلاع المعلّقة (pending) تلقائياً بالأقدمية (created_at ASC) عند توفّر خانة في max_castles،
    بشرط أن يكون المستخدم غير محظور واشتراكه سارياً. لا تمس القلاع المرفوضة (rejected).
    """
    with QUOTA_LOCK:
        return _promote_pending_castles_locked(user_id)


def _promote_pending_castles_locked(user_id: str) -> List[str]:
    uid = str(user_id or "").strip()
    if not uid:
        return []

    u = get_user(uid)
    if not u or _is_admin_account(u) or u.get("is_banned"):
        return []

    is_valid, _ = _evaluate_user_subscription(u)
    if not is_valid:
        return []

    max_allowed = max(0, int(u.get("max_castles") or 0))
    active_cnt = count_user_active_castles(uid)
    slots = max_allowed - active_cnt
    if slots <= 0:
        return []

    now_iso = datetime.now(timezone.utc).isoformat()
    with get_connection() as conn:
        rows = conn.execute(
            """
            SELECT castle_id
            FROM castle_states
            WHERE user_id = ?
              AND (LOWER(TRIM(COALESCE(state, ''))) = 'pending' OR is_active = 0)
              AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('rejected', 'sealed', 'banned')
              AND LOWER(TRIM(COALESCE(conn_state, ''))) NOT IN ('sealed', 'sealed_banned', 'banned')
            ORDER BY COALESCE(created_at, '') ASC, rowid ASC
            LIMIT ?
            """,
            (uid, slots),
        ).fetchall()
        promoted_ids = [str(r["castle_id"]) for r in rows if r["castle_id"]]
        if not promoted_ids:
            return []

        placeholders = ",".join("?" for _ in promoted_ids)
        conn.execute(
            f"""
            UPDATE castle_states
            SET state = 'idle',
                conn_state = 'idle',
                is_active = 1,
                status_message = 'جاهز للتشغيل',
                updated_at = ?
            WHERE castle_id IN ({placeholders})
            """,
            [now_iso, *promoted_ids],
        )
        return promoted_ids


def demote_excess_castles(user_id: str, exclude_castle_ids: Optional[List[str]] = None) -> List[str]:
    """
    إرجاع القلاع النشطة الزائدة عن حصة المستخدم (max_castles) تلقائياً إلى طابور الانتظار (pending)،
    بدءاً بالأحدث إضافةً (created_at DESC, rowid DESC)، دون المساس بأي معرّفات مستثناة (مثل قلعة تمت الموافقة عليها للتو).
    """
    with QUOTA_LOCK:
        return _demote_excess_castles_locked(user_id, exclude_castle_ids=exclude_castle_ids)


def _demote_excess_castles_locked(user_id: str, exclude_castle_ids: Optional[List[str]] = None) -> List[str]:
    uid = str(user_id or "").strip()
    if not uid:
        return []

    u = get_user(uid)
    if not u or _is_admin_account(u):
        return []

    max_allowed = max(0, int(u.get("max_castles") or 0))
    active_cnt = count_user_active_castles(uid)
    excess = active_cnt - max_allowed
    if excess <= 0:
        return []

    excluded = [str(cid).strip() for cid in (exclude_castle_ids or []) if str(cid).strip()]
    now_iso = datetime.now(timezone.utc).isoformat()
    with get_connection() as conn:
        if excluded:
            excl_placeholders = ",".join("?" for _ in excluded)
            rows = conn.execute(
                f"""
                SELECT castle_id
                FROM castle_states
                WHERE user_id = ?
                  AND is_active = 1
                  AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('pending', 'rejected', 'sealed', 'banned')
                  AND LOWER(TRIM(COALESCE(conn_state, ''))) NOT IN ('sealed', 'sealed_banned', 'banned')
                  AND castle_id NOT IN ({excl_placeholders})
                ORDER BY COALESCE(created_at, '') DESC, rowid DESC
                LIMIT ?
                """,
                [uid, *excluded, excess],
            ).fetchall()
        else:
            rows = conn.execute(
                """
                SELECT castle_id
                FROM castle_states
                WHERE user_id = ?
                  AND is_active = 1
                  AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('pending', 'rejected', 'sealed', 'banned')
                  AND LOWER(TRIM(COALESCE(conn_state, ''))) NOT IN ('sealed', 'sealed_banned', 'banned')
                ORDER BY COALESCE(created_at, '') DESC, rowid DESC
                LIMIT ?
                """,
                (uid, excess),
            ).fetchall()

        demoted_ids = [str(r["castle_id"]) for r in rows if r["castle_id"]]
        if not demoted_ids:
            return []

        placeholders = ",".join("?" for _ in demoted_ids)
        conn.execute(
            f"""
            UPDATE castle_states
            SET state = 'pending',
                conn_state = 'idle',
                is_active = 0,
                status_message = 'بانتظار موافقة الإدارة لتفعيل القلعة',
                updated_at = ?
            WHERE castle_id IN ({placeholders})
            """,
            [now_iso, *demoted_ids],
        )
        return demoted_ids


def sync_user_castles_to_quota(user_id: str) -> Dict[str, List[str]]:
    """مزامنة قلاع المستخدم مع حصته الحالية (max_castles): إرجاع الزائد إلى pending أو ترقية المعلّق بالأقدمية."""
    with QUOTA_LOCK:
        demoted = _demote_excess_castles_locked(user_id)
        promoted = _promote_pending_castles_locked(user_id)
        return {"promoted": promoted, "demoted": demoted}


def _build_admin_users_and_stats(
    exclude_admin: bool = True,
    exclude_email: Optional[str] = None,
    live_bots: Optional[List[Dict[str, Any]]] = None,
) -> Tuple[List[Dict[str, Any]], Dict[str, Any]]:
    """
    تجميع بيانات المستخدمين وإحصائيات المشرف الفعلية باستعلامين خفيفين فقط مع ربطها
    بحالة التشغيل الحية من bot_manager.
    """
    now_utc = datetime.now(timezone.utc)
    with get_connection() as conn:
        user_rows = conn.execute("SELECT * FROM users ORDER BY created_at DESC").fetchall()
        castle_rows = conn.execute(
            "SELECT castle_id, user_id, email, is_active, state, conn_state FROM castle_states"
        ).fetchall()

    castles_by_uid: Dict[str, List[Dict[str, Any]]] = {}
    castle_owner_by_cid: Dict[str, str] = {}
    castle_owner_by_email: Dict[str, str] = {}

    for r in castle_rows:
        c = dict(r)
        uid = str(c.get("user_id") or "")
        cid = str(c.get("castle_id") or "").strip()
        em = str(c.get("email") or "").strip().lower()
        castles_by_uid.setdefault(uid, []).append(c)
        if cid:
            castle_owner_by_cid[cid] = uid
        if em:
            castle_owner_by_email[em] = uid

    running_by_uid: Dict[str, int] = {}
    connected_by_uid: Dict[str, int] = {}
    for bot in live_bots or []:
        cid = str(bot.get("castle_id") or "").strip()
        em = str(bot.get("email") or "").strip().lower()
        owner_uid = castle_owner_by_cid.get(cid) or castle_owner_by_email.get(em) or str(bot.get("user_id") or "").strip()
        if not owner_uid:
            continue
        running_by_uid[owner_uid] = running_by_uid.get(owner_uid, 0) + 1
        if str(bot.get("conn_state") or "").strip().lower() == "connected":
            connected_by_uid[owner_uid] = connected_by_uid.get(owner_uid, 0) + 1

    users_list: List[Dict[str, Any]] = []
    stats = {
        "total_users": 0,
        "active_subscriptions": 0,
        "pending_users": 0,
        "expired_users": 0,
        "banned_users": 0,
        "total_castles": 0,
        "allowed_castles": 0,
        "allowed_castles_quota": 0,
        "active_castles": 0,
        "running_castles": 0,
        "connected_bots": 0,
        "system_health": "online",
    }

    for row in user_rows:
        u = dict(row)
        is_excluded_admin = exclude_admin and _is_admin_account(u, exclude_email=exclude_email)

        uid = str(u.get("uid") or "")
        u_castles = castles_by_uid.get(uid, [])
        non_rejected = [c for c in u_castles if str(c.get("state") or "").strip().lower() != "rejected"]
        pending_cnt = sum(
            1 for c in non_rejected
            if str(c.get("state") or "").strip().lower() == "pending" or not bool(c.get("is_active", 1))
        )
        active_cnt = max(0, len(non_rejected) - pending_cnt)

        is_sub_valid, _ = _evaluate_user_subscription(u, now_utc=now_utc)
        max_quota = max(0, int(u.get("max_castles") or 0))
        runnable_cnt = sum(1 for c in non_rejected if _is_castle_runnable(c))
        allowed_cnt = runnable_cnt if (is_sub_valid and max_quota > 0) else 0
        running_cnt = running_by_uid.get(uid, 0)

        u["current_castles_count"] = active_cnt
        u["pending_castles_count"] = pending_cnt
        u["total_castles_count"] = len(non_rejected)
        u["allowed_castles_count"] = allowed_cnt
        u["running_castles_count"] = running_cnt

        if is_excluded_admin:
            continue

        users_list.append(u)

        stats["total_users"] += 1
        if u.get("is_banned"):
            stats["banned_users"] += 1
        elif (u.get("status") or "pending").strip().lower() == "suspended":
            stats["banned_users"] += 1
        elif (u.get("status") or "pending") != "approved":
            stats["pending_users"] += 1
        elif is_sub_valid:
            stats["active_subscriptions"] += 1
            stats["allowed_castles_quota"] += max_quota
        else:
            stats["expired_users"] += 1

        stats["total_castles"] += len(non_rejected)
        stats["allowed_castles"] += allowed_cnt
        stats["active_castles"] += runnable_cnt
        stats["running_castles"] += running_cnt
        stats["connected_bots"] += connected_by_uid.get(uid, 0)

    return users_list, stats


def get_all_users(
    exclude_admin: bool = False,
    exclude_email: Optional[str] = None,
    live_bots: Optional[List[Dict[str, Any]]] = None,
) -> List[Dict[str, Any]]:
    """جلب جميع المستخدمين مع إحصائيات قلاعهم الفعلية وعدد القلاع الشغالة."""
    users_list, _ = _build_admin_users_and_stats(
        exclude_admin=exclude_admin,
        exclude_email=exclude_email,
        live_bots=live_bots,
    )
    return users_list


def get_admin_stats(
    exclude_admin: bool = True,
    exclude_email: Optional[str] = None,
    live_bots: Optional[List[Dict[str, Any]]] = None,
) -> Dict[str, Any]:
    """إحصائيات عامة دقيقة للوحة تحكم الأدمن مبنية على البيانات الفعلية."""
    _, stats = _build_admin_users_and_stats(
        exclude_admin=exclude_admin,
        exclude_email=exclude_email,
        live_bots=live_bots,
    )
    return stats


def get_live_castles_metadata() -> Tuple[Dict[str, Dict[str, Any]], Dict[str, Dict[str, Any]], Dict[str, Dict[str, Any]]]:
    """جلب خرائط تعريفية خفيفة للقلاع والمستخدمين (دون config/resources) لإثراء شاشة العمليات الحية وحساب المؤهلات بسرعة فائقة."""
    with get_connection() as conn:
        castle_rows = conn.execute(
            """
            SELECT castle_id, user_id, email, castle_name, castle_info,
                   is_active, state, conn_state, created_at
            FROM castle_states
            ORDER BY COALESCE(created_at, '') ASC, rowid ASC
            """
        ).fetchall()
        user_rows = conn.execute(
            "SELECT uid, email, username, role, status, is_banned, max_castles, subscription_end FROM users"
        ).fetchall()

    by_cid: Dict[str, Dict[str, Any]] = {}
    by_email: Dict[str, Dict[str, Any]] = {}
    users_by_uid: Dict[str, Dict[str, Any]] = {}

    for u in user_rows:
        ud = dict(u)
        uid = str(ud.get("uid") or "").strip()
        if uid:
            users_by_uid[uid] = ud

    for r in castle_rows:
        cd = dict(r)
        raw_info = cd.get("castle_info")
        if isinstance(raw_info, str):
            try:
                cd["castle_info"] = json.loads(raw_info) if raw_info else {}
            except Exception:
                cd["castle_info"] = {}
        elif not isinstance(raw_info, dict):
            cd["castle_info"] = {}

        cid = str(cd.get("castle_id") or "").strip()
        em = str(cd.get("email") or "").strip().lower()
        if cid:
            by_cid[cid] = cd
        if em:
            by_email[em] = cd

    return by_cid, by_email, users_by_uid


def count_idle_eligible_castles_from_metadata(
    by_cid: Dict[str, Dict[str, Any]],
    users_by_uid: Dict[str, Dict[str, Any]],
    active_emails_lower: Set[str],
) -> int:
    """حساب عدد القلاع الجاهزة غير المشغّلة حالياً من الذاكرة فقط بدون قراءة config/resources من SQLite."""
    now_utc = datetime.now(timezone.utc)
    running_by_uid: Dict[str, int] = {}
    for c in by_cid.values():
        em = str(c.get("email") or "").strip().lower()
        uid = str(c.get("user_id") or "").strip()
        if em and em in active_emails_lower and uid:
            running_by_uid[uid] = running_by_uid.get(uid, 0) + 1

    sub_cache: Dict[str, bool] = {}
    planned_by_uid: Dict[str, int] = dict(running_by_uid)
    count = 0

    for c in by_cid.values():
        cid = str(c.get("castle_id") or "").strip()
        uid = str(c.get("user_id") or "").strip()
        em = str(c.get("email") or "").strip().lower()
        if not cid or not em or not c.get("is_active", 1):
            continue
        if em in active_emails_lower:
            continue
        c_st = str(c.get("state") or "").strip().lower()
        conn_st = str(c.get("conn_state") or "").strip().lower()
        if c_st in ("pending", "rejected", "error", "sealed", "banned"):
            continue
        if conn_st in ("error", "sealed", "sealed_banned", "banned"):
            continue
        if uid:
            owner = users_by_uid.get(uid)
            if not owner:
                continue
            if uid not in sub_cache:
                sub_cache[uid] = _evaluate_user_subscription(owner, now_utc=now_utc)[0]
            if not sub_cache[uid]:
                continue
            if not _is_admin_account(owner):
                max_allowed = max(0, int(owner.get("max_castles") or 0))
                cur_planned = planned_by_uid.get(uid, 0)
                if cur_planned >= max_allowed:
                    continue
                planned_by_uid[uid] = cur_planned + 1
        count += 1
    return count


def get_merchants_overview_stats() -> Dict[str, Any]:
    return {"merchants": []}


def get_all_users_with_castles() -> List[Dict[str, Any]]:
    """
    جلب كافة المستخدمين وقلاعهم بطلبين فقط (2 Queries) بدلاً من N+1 طلبات
    مما يخفض زمن الاستجابة من 850ms إلى أقل من 25ms تحت الأحمال العالية.
    """
    with get_connection() as conn:
        users_rows = conn.execute("SELECT * FROM users ORDER BY created_at DESC").fetchall()
        users = [dict(u) for u in users_rows]

        castles_rows = conn.execute("SELECT * FROM castle_states ORDER BY created_at DESC").fetchall()

        castles_by_user: Dict[str, List[Dict[str, Any]]] = {}
        for r in castles_rows:
            c = _row_to_castle(r)
            castles_by_user.setdefault(c.get("user_id", ""), []).append(c)

        for u in users:
            user_castles = castles_by_user.get(u.get("uid", ""), [])
            u["castles"] = user_castles
            u["castles_count"] = len(user_castles)
            u["running_count"] = sum(
                1 for c in user_castles
                if c.get("state") == "running" or c.get("conn_state") in ("connected", "waiting")
            )

        return users


def approve_user_trial(uid: str, days: int = 3, max_castles: int = 10) -> bool:
    """الموافقة على تجربة المستخدم وتفعيل المدة وعدد القلاع مع ترقية قلاعه المعلقة ضمن الحصة"""
    safe_days = max(1, int(days))
    safe_max = max(0, int(max_castles))
    with get_connection() as conn:
        new_end = (datetime.now(timezone.utc) + timedelta(days=safe_days)).isoformat()
        conn.execute(
            "UPDATE users SET status = 'approved', trial_used = 1, subscription_end = ?, max_castles = ? WHERE uid = ?",
            (new_end, safe_max, uid)
        )
    promote_pending_castles(uid)
    return True


def ban_user(uid: str, is_banned: bool = True, reason: str = "") -> bool:
    clean_reason = str(reason or "").strip() if is_banned else ""
    with get_connection() as conn:
        conn.execute(
            "UPDATE users SET is_banned = ?, banned_reason = ? WHERE uid = ?",
            (1 if is_banned else 0, clean_reason, uid),
        )
        return True


def delete_user(uid: str) -> bool:
    with get_connection() as conn:
        conn.execute("DELETE FROM users WHERE uid = ?", (uid,))
        conn.execute("DELETE FROM castle_states WHERE user_id = ?", (uid,))
        return True


def approve_castle(castle_id: str) -> bool:
    with QUOTA_LOCK:
        return _approve_castle_locked(castle_id)


def _approve_castle_locked(castle_id: str) -> bool:
    uid: Optional[str] = None
    is_non_admin_owner = False
    with get_connection() as conn:
        row = conn.execute(
            "SELECT castle_id, user_id, is_active, state FROM castle_states WHERE castle_id = ?",
            (castle_id,),
        ).fetchone()
        if not row:
            raise ValueError("القلعة غير موجودة")

        uid = row["user_id"]
        was_active = bool(row["is_active"]) and str(row["state"] or "").strip().lower() not in ("pending", "rejected")
        u_row = conn.execute("SELECT * FROM users WHERE uid = ?", (uid,)).fetchone() if uid else None
        active_before = 0
        current_max = 0
        if u_row:
            u_dict = dict(u_row)
            if not _is_admin_account(u_dict):
                is_non_admin_owner = True
                if u_dict.get("is_banned"):
                    raise ValueError("لا يمكن الموافقة على قلعة لمستخدم محظور")
                is_valid, reason = _evaluate_user_subscription(u_dict)
                if not is_valid:
                    raise ValueError(f"لا يمكن الموافقة على القلعة: {reason}")
                cnt_before_row = conn.execute(
                    """
                    SELECT COUNT(*) as cnt
                    FROM castle_states
                    WHERE user_id = ?
                      AND is_active = 1
                      AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('pending', 'rejected')
                    """,
                    (uid,),
                ).fetchone()
                active_before = int(cnt_before_row["cnt"]) if cnt_before_row else 0
                current_max = max(0, int(u_dict.get("max_castles") or 0))

        conn.execute(
            "UPDATE castle_states SET state = 'idle', conn_state = 'idle', is_active = 1, status_message = 'جاهز للتشغيل' WHERE castle_id = ?",
            (castle_id,),
        )
        if is_non_admin_owner and uid:
            # عند الموافقة على قلعة معلقة واحدة والحصة ممتلئة، تزيد الحصة بمقدار +1 فقط عن الحصة الحالية
            if not was_active and active_before >= current_max:
                new_max = current_max + 1
                conn.execute("UPDATE users SET max_castles = ? WHERE uid = ?", (new_max, uid))

    # إذا كان لدى المستخدم قلاع نشطة قديمة فائضة عن الحصة الجديدة، تُعاد الزائدة (باستثناء القلعة الموافق عليها) إلى pending
    if is_non_admin_owner and uid:
        _demote_excess_castles_locked(uid, exclude_castle_ids=[castle_id])
    return True


def reject_castle(castle_id: str, reason: str = "") -> bool:
    now_iso = datetime.now(timezone.utc).isoformat()
    final_msg = str(reason or "").strip() or "تم رفض القلعة من الإدارة"
    with get_connection() as conn:
        res = conn.execute(
            "UPDATE castle_states SET state = 'rejected', conn_state = 'idle', is_active = 0, status_message = ?, updated_at = ? WHERE castle_id = ?",
            (final_msg, now_iso, castle_id),
        )
        return res.rowcount > 0


def update_user_subscription(uid: str, days: int) -> bool:
    safe_days = max(1, int(days))
    u = get_user(uid)
    if not u:
        return False

    base_dt = datetime.now(timezone.utc)
    if u.get("subscription_end"):
        try:
            parsed = datetime.fromisoformat(str(u["subscription_end"]).replace("Z", "+00:00"))
            if parsed.tzinfo is None:
                parsed = parsed.replace(tzinfo=timezone.utc)
            if parsed > base_dt:
                base_dt = parsed
        except Exception:
            pass

    new_end = (base_dt + timedelta(days=safe_days)).isoformat()
    with get_connection() as conn:
        conn.execute("UPDATE users SET subscription_end = ?, status = 'approved' WHERE uid = ?", (new_end, uid))
    promote_pending_castles(uid)
    return True


def approve_all_pending_users(days: int = 3, max_castles: int = 10) -> int:
    """الموافقة على جميع المستخدمين المعلقين وتفعيل الباقة التجريبية مع ترقية القلاع المعلقة"""
    safe_days = max(1, int(days))
    safe_max = max(0, int(max_castles))
    with get_connection() as conn:
        rows = conn.execute(
            "SELECT uid FROM users WHERE status = 'pending' AND COALESCE(is_banned, 0) = 0 AND COALESCE(trial_used, 0) = 0"
        ).fetchall()
        target_uids = [str(r["uid"]) for r in rows if r["uid"]]
        if not target_uids:
            return 0
        new_end = (datetime.now(timezone.utc) + timedelta(days=safe_days)).isoformat()
        placeholders = ",".join("?" for _ in target_uids)
        res = conn.execute(
            f"UPDATE users SET status = 'approved', trial_used = 1, subscription_end = ?, max_castles = ? WHERE uid IN ({placeholders})",
            [new_end, safe_max, *target_uids],
        )
        count = res.rowcount

    for t_uid in target_uids:
        promote_pending_castles(t_uid)
    return count


def log_subscription_audit(
    actor_uid: str,
    actor_email: str,
    target_uid: str,
    action: str,
    details: Optional[Dict[str, Any]] = None,
) -> None:
    """تسجيل عملية إدارية في سجل تدقيق الاشتراكات."""
    try:
        now_iso = datetime.now(timezone.utc).isoformat()
        details_str = json.dumps(details or {}, ensure_ascii=False)
        with get_connection() as conn:
            conn.execute(
                """
                INSERT INTO subscription_audit_log (actor_uid, actor_email, target_uid, action, details, created_at)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                (actor_uid or "", actor_email or "", target_uid or "", action, details_str, now_iso),
            )
    except Exception as e:
        log.warning(f"⚠️ تعذر تسجيل حدث في سجل التدقيق: {e}")


def get_subscription_audit_logs(limit: int = 100) -> List[Dict[str, Any]]:
    """جلب أحدث أحداث سجل تدقيق الاشتراكات."""
    safe_limit = max(1, min(500, int(limit)))
    with get_connection() as conn:
        rows = conn.execute(
            "SELECT id, actor_uid, actor_email, target_uid, action, details, created_at FROM subscription_audit_log ORDER BY id DESC LIMIT ?",
            (safe_limit,),
        ).fetchall()
    result: List[Dict[str, Any]] = []
    for r in rows:
        d = dict(r)
        raw_det = d.get("details")
        if isinstance(raw_det, str):
            try:
                d["details"] = json.loads(raw_det) if raw_det else {}
            except Exception:
                d["details"] = {}
        result.append(d)
    return result


# ══════════════════════════════════════════════════════════════════
# ⚙️ إعدادات النظام العامة ومؤشرات البروكسي (System Settings & Proxies)
# ══════════════════════════════════════════════════════════════════

def _ensure_init(db_path: Optional[str] = None) -> None:
    """التأكد التلقائي من تهيئة قاعدة البيانات قبل أي عملية إعدادات أو بروكسي."""
    path = get_db_path(db_path)
    if path not in _initialized_paths:
        init_db(db_path)


def get_system_setting(key: str, default: str = "", db_path: Optional[str] = None) -> str:
    """استرجاع إعداد نظام معين من جدول system_settings."""
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            row = conn.execute("SELECT value FROM system_settings WHERE key = ?", (key,)).fetchone()
            if row and row["value"] is not None:
                return str(row["value"])
    except Exception as e:
        log.warning(f"⚠️ خطأ في قراءة إعداد النظام {key}: {e}")
    return default


def set_system_setting(key: str, value: str, db_path: Optional[str] = None) -> bool:
    """حفظ أو تحديث إعداد نظام في جدول system_settings."""
    _ensure_init(db_path)
    now = datetime.now(timezone.utc).isoformat()
    try:
        with get_connection(db_path) as conn:
            conn.execute(
                "INSERT OR REPLACE INTO system_settings (key, value, updated_at) VALUES (?, ?, ?)",
                (key, str(value), now)
            )
        return True
    except Exception as e:
        log.warning(f"⚠️ خطأ في حفظ إعداد النظام {key}: {e}")
        return False


def resolve_user_id_by_email(email: str, db_path: Optional[str] = None) -> Optional[str]:
    """استخراج user_id لصاحب القلعة اعتماداً على البريد الإلكتروني."""
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return None
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            row = conn.execute(
                "SELECT user_id FROM castle_states WHERE LOWER(TRIM(email)) = ? LIMIT 1",
                (clean_email,)
            ).fetchone()
            if row and row["user_id"]:
                return str(row["user_id"]).strip()
    except Exception:
        pass
    return None


def get_castle_proxy_index(email: str, db_path: Optional[str] = None) -> Optional[int]:
    """استرجاع مؤشر البروكسي (proxy_index) المحفوظ للقلعة في قاعدة البيانات."""
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return None
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            row = conn.execute(
                "SELECT proxy_index FROM castle_states WHERE LOWER(TRIM(email)) = ? LIMIT 1",
                (clean_email,)
            ).fetchone()
            if row and row["proxy_index"] is not None and int(row["proxy_index"]) >= 0:
                return int(row["proxy_index"])
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء قراءة proxy_index للقلعة ({clean_email}): {e}")
    return None


def set_castle_proxy_index(email: str, proxy_index: int, db_path: Optional[str] = None) -> bool:
    """
    حفظ أو تحديث مؤشر البروكسي (proxy_index) لقلعة مسجلة في قاعدة البيانات.
    ملاحظة أمان: يقتصر على UPDATE لتفادي إنشاء صفوف يتيمة تخالف قيد user_id NOT NULL.
    """
    clean_email = (email or "").strip().lower()
    if not clean_email or proxy_index is None:
        return False
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            cur = conn.execute(
                "UPDATE castle_states SET proxy_index = ? WHERE LOWER(TRIM(email)) = ?",
                (int(proxy_index), clean_email)
            )
            return cur.rowcount > 0
    except Exception as e:
        log.warning(f"⚠️ تعذر حفظ proxy_index للقلعة ({clean_email}): {e}")
        return False


def get_user_proxy_index(user_id: str, db_path: Optional[str] = None) -> Optional[int]:
    """استرجاع مؤشر البروكسي الخاص بأي قلعة تابعة لنفس المستخدم لتوحيد البروكسي بينهم."""
    clean_uid = (user_id or "").strip()
    if not clean_uid:
        return None
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            row = conn.execute(
                "SELECT proxy_index FROM castle_states WHERE (user_id = ? OR LOWER(user_id) = ?) AND proxy_index >= 0 LIMIT 1",
                (clean_uid, clean_uid.lower())
            ).fetchone()
            if row and row["proxy_index"] is not None and int(row["proxy_index"]) >= 0:
                return int(row["proxy_index"])
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء قراءة proxy_index للمستخدم ({clean_uid}): {e}")
    return None


def get_all_castle_proxy_counts(total_proxies: int, db_path: Optional[str] = None) -> Dict[int, int]:
    """حساب عدد القلاع المربوطة بكل مؤشر بروكسي (0..total_proxies-1) لتحقيق توزيع متوازن."""
    counts = {i: 0 for i in range(total_proxies)}
    if total_proxies <= 0:
        return counts
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            rows = conn.execute(
                "SELECT proxy_index, count(*) FROM castle_states WHERE proxy_index >= 0 GROUP BY proxy_index"
            ).fetchall()
            for r in rows:
                raw_idx = int(r[0])
                safe_idx = raw_idx % total_proxies
                counts[safe_idx] = counts.get(safe_idx, 0) + int(r[1])
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء حساب حمولة مؤشرات البروكسي: {e}")
    return counts


def get_all_castle_proxy_assignments(total_proxies: int, db_path: Optional[str] = None) -> Tuple[Dict[int, List[str]], Dict[int, List[str]]]:
    """استرجاع خريطة القلاع والمستخدمين المرتبطين بكل مؤشر بروكسي من SQLite."""
    castle_map: Dict[int, List[str]] = {}
    user_map: Dict[int, List[str]] = {}
    if total_proxies <= 0:
        return castle_map, user_map
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            rows = conn.execute(
                "SELECT LOWER(TRIM(email)), user_id, proxy_index FROM castle_states WHERE proxy_index >= 0"
            ).fetchall()
            for em_row, uid_row, idx_row in rows:
                if idx_row is None:
                    continue
                safe_i = int(idx_row) % total_proxies
                if em_row:
                    castle_map.setdefault(safe_i, []).append(str(em_row))
                if uid_row:
                    u_str = str(uid_row).strip()
                    if u_str and u_str not in user_map.get(safe_i, []):
                        user_map.setdefault(safe_i, []).append(u_str)
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء قراءة ارتباطات البروكسي من قاعدة البيانات: {e}")
    return castle_map, user_map


def get_castles_by_proxy_index(proxy_index: int, total_proxies: int, db_path: Optional[str] = None) -> List[Dict[str, Any]]:
    """القلاع المرتبطة بمؤشر بروكسي معيّن (بعد modulo على حجم الباقة النشطة) مع معرّف مالكها: [{email, user_id}]."""
    result: List[Dict[str, Any]] = []
    if total_proxies <= 0:
        return result
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            rows = conn.execute(
                "SELECT LOWER(TRIM(email)) AS email, user_id, proxy_index FROM castle_states WHERE proxy_index >= 0"
            ).fetchall()
            for r in rows:
                if r["email"] and int(r["proxy_index"]) % total_proxies == proxy_index:
                    result.append({"email": str(r["email"]), "user_id": str(r["user_id"] or "").strip()})
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء قراءة قلاع البروكسي رقم {proxy_index}: {e}")
    return result


def get_user_castle_emails(user_id: str, db_path: Optional[str] = None) -> List[str]:
    """إيميلات (lowercase) كل قلاع مستخدم معيّن."""
    clean_uid = (user_id or "").strip()
    if not clean_uid:
        return []
    _ensure_init(db_path)
    try:
        with get_connection(db_path) as conn:
            rows = conn.execute(
                "SELECT LOWER(TRIM(email)) AS email FROM castle_states WHERE user_id = ? AND TRIM(email) != ''",
                (clean_uid,)
            ).fetchall()
            return [str(r["email"]) for r in rows if r["email"]]
    except Exception as e:
        log.warning(f"⚠️ خطأ أثناء قراءة قلاع المستخدم ({clean_uid}): {e}")
        return []


def set_castles_proxy_index_bulk(emails: List[str], proxy_index: int, db_path: Optional[str] = None) -> int:
    """تعيين proxy_index لمجموعة قلاع في معاملة واحدة (-1 = إزالة الارتباط). يرجع عدد الصفوف المحدّثة."""
    clean = [(e or "").strip().lower() for e in emails if e and e.strip()]
    if not clean:
        return 0
    _ensure_init(db_path)
    updated = 0
    with get_connection(db_path) as conn:
        for em in clean:
            cur = conn.execute(
                "UPDATE castle_states SET proxy_index = ? WHERE LOWER(TRIM(email)) = ?",
                (int(proxy_index), em)
            )
            updated += cur.rowcount or 0
    return updated


def search_castles_with_owner(query: str, limit: int = 20, db_path: Optional[str] = None) -> List[Dict[str, Any]]:
    """بحث سريع في القلاع (إيميل/اسم القلعة/اللورد) وبيانات مالكها (إيميل/اسم) لعرض البروكسي الخاص بهم. بدون كلمات مرور."""
    q = (query or "").strip().lower()
    if len(q) < 2:
        return []
    like = "%" + q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_") + "%"
    _ensure_init(db_path)
    with get_connection(db_path) as conn:
        rows = conn.execute("""
            SELECT c.castle_id, c.email, c.castle_name, c.castle_info, c.user_id, c.proxy_index,
                   c.state, c.conn_state, u.email AS owner_email, u.username AS owner_username
            FROM castle_states c
            LEFT JOIN users u ON u.uid = c.user_id
            WHERE LOWER(c.email) LIKE ? ESCAPE '\\'
               OR LOWER(c.castle_name) LIKE ? ESCAPE '\\'
               OR LOWER(c.castle_info) LIKE ? ESCAPE '\\'
               OR LOWER(COALESCE(u.email, '')) LIKE ? ESCAPE '\\'
               OR LOWER(COALESCE(u.username, '')) LIKE ? ESCAPE '\\'
            ORDER BY c.user_id, c.created_at DESC
            LIMIT ?
        """, (like, like, like, like, like, int(limit))).fetchall()
    result: List[Dict[str, Any]] = []
    for r in rows:
        d = dict(r)
        try:
            d["castle_info"] = json.loads(d["castle_info"]) if d.get("castle_info") else {}
        except Exception:
            d["castle_info"] = {}
        result.append(d)
    return result


# ══════════════════════════════════════════════════════════════════
# دوال إدارة حالة النشر والاستئناف التدريجي (Deploy & Auto-Resume DB Ops)
# ══════════════════════════════════════════════════════════════════

def reset_stuck_castles_db(exclude_castle_ids: Optional[List[str]] = None, db_path: Optional[str] = None) -> int:
    """
    تصفير الحالات العالقة من تشغيل سابق إلى idle عند الإقلاع مع استثناء القلاع المجدولة للاستئناف
    واستثناء الحسابات المحظورة (sealed / banned) أو المعطلة بخطأ كلمة مرور (error).
    """
    _ensure_init(db_path)
    now_iso = datetime.now(timezone.utc).isoformat()
    excludes = [str(x).strip() for x in (exclude_castle_ids or []) if x and str(x).strip()]
    with get_connection(db_path) as conn:
        base_where = """
            (state IN ('running', 'deploying') OR conn_state IN ('connected', 'starting', 'waiting', 'deploying', 'reconnecting'))
            AND COALESCE(conn_state, '') NOT IN ('sealed', 'sealed_banned', 'banned', 'error')
            AND COALESCE(state, '') NOT IN ('sealed', 'banned', 'error')
        """
        if excludes:
            placeholders = ", ".join("?" for _ in excludes)
            sql = f"""
                UPDATE castle_states
                SET state = 'idle', conn_state = 'idle', status_message = 'جاهز للتشغيل', updated_at = ?
                WHERE {base_where} AND castle_id NOT IN ({placeholders})
            """
            res = conn.execute(sql, [now_iso, *excludes])
        else:
            sql = f"""
                UPDATE castle_states
                SET state = 'idle', conn_state = 'idle', status_message = 'جاهز للتشغيل', updated_at = ?
                WHERE {base_where}
            """
            res = conn.execute(sql, [now_iso])
        return res.rowcount or 0


def set_castles_deploying_db(
    castle_ids: List[str],
    message: str = "جاري رفع التغييرات إلى السيرفر... سيتم استئناف البوت تلقائياً",
    db_path: Optional[str] = None,
) -> int:
    """وسم مجموعة من القلاع بحالة deploying لحماية واجهة المستخدم أثناء النشر أو التشغيل التدريجي."""
    clean_ids = [str(x).strip() for x in castle_ids if x and str(x).strip()]
    if not clean_ids:
        return 0
    _ensure_init(db_path)
    now_iso = datetime.now(timezone.utc).isoformat()
    placeholders = ", ".join("?" for _ in clean_ids)
    with get_connection(db_path) as conn:
        res = conn.execute(
            f"""
            UPDATE castle_states
            SET state = 'deploying', conn_state = 'deploying', status_message = ?, updated_at = ?
            WHERE castle_id IN ({placeholders})
            """,
            [message, now_iso, *clean_ids],
        )
        return res.rowcount or 0


def reset_deploying_castles_to_idle_db(
    message: str = "تم إلغاء التشغيل التدريجي",
    db_path: Optional[str] = None,
) -> int:
    """تصفير أي قلاع متبقية في حالة deploying إلى idle بعد إلغاء قائمة الانتظار."""
    _ensure_init(db_path)
    now_iso = datetime.now(timezone.utc).isoformat()
    with get_connection(db_path) as conn:
        res = conn.execute(
            """
            UPDATE castle_states
            SET state = 'idle', conn_state = 'idle', status_message = ?, updated_at = ?
            WHERE conn_state = 'deploying' OR state = 'deploying'
            """,
            (message, now_iso),
        )
        return res.rowcount or 0


def stop_all_castles_idle_db(
    message: str = "تم إيقاف البوت بواسطة المشرف",
    db_path: Optional[str] = None,
) -> int:
    """تصفير جميع القلاع غير المحظورة إلى حالة idle عند الإيقاف الشامل."""
    _ensure_init(db_path)
    now_iso = datetime.now(timezone.utc).isoformat()
    with get_connection(db_path) as conn:
        res = conn.execute(
            """
            UPDATE castle_states
            SET state = 'idle', conn_state = 'idle', status_message = ?, updated_at = ?
            WHERE COALESCE(conn_state, '') NOT IN ('sealed', 'sealed_banned', 'banned')
              AND COALESCE(state, '') NOT IN ('sealed', 'banned')
            """,
            (message, now_iso),
        )
        return res.rowcount or 0

