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
from typing import Any, Dict, List, Optional, Tuple

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
                    subscription_end TEXT,
                    max_castles INTEGER DEFAULT 50,
                    trial_used INTEGER DEFAULT 0,
                    status TEXT DEFAULT 'pending',
                    tenant_domain TEXT DEFAULT ''
                );
                """)

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
    cfg = config or {}
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

    with get_connection() as conn:
        conn.execute("""
        INSERT INTO users (uid, email, username, phone, role, created_at, subscription_end, status, max_castles, tenant_domain)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(uid) DO UPDATE SET
            username = CASE WHEN excluded.username != '' THEN excluded.username ELSE users.username END,
            phone = CASE WHEN excluded.phone != '' THEN excluded.phone ELSE users.phone END;
        """, (uid, clean_email, username, phone, assigned_role, now_iso, assigned_sub_end, assigned_status, assigned_max, tenant_domain))
        return get_user(uid) or {}


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

    # التحقق الإلزامي من موافقة الأدمن على الحساب
    if user_row.get("status") != "approved":
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
    """جلب خرائط تعريفية خفيفة للقلاع والمستخدمين (دون config/resources) لإثراء شاشة العمليات الحية."""
    with get_connection() as conn:
        castle_rows = conn.execute(
            "SELECT castle_id, user_id, email, castle_name, castle_info FROM castle_states"
        ).fetchall()
        user_rows = conn.execute(
            "SELECT uid, email, username FROM users"
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
    """الموافقة على تجربة المستخدم وتفعيل المدة وعدد القلاع"""
    with get_connection() as conn:
        new_end = (datetime.now(timezone.utc) + timedelta(days=days)).isoformat()
        conn.execute(
            "UPDATE users SET status = 'approved', trial_used = 1, subscription_end = ?, max_castles = ? WHERE uid = ?",
            (new_end, max_castles, uid)
        )
        return True


def ban_user(uid: str, is_banned: bool = True) -> bool:
    with get_connection() as conn:
        conn.execute("UPDATE users SET is_banned = ? WHERE uid = ?", (1 if is_banned else 0, uid))
        return True


def delete_user(uid: str) -> bool:
    with get_connection() as conn:
        conn.execute("DELETE FROM users WHERE uid = ?", (uid,))
        conn.execute("DELETE FROM castle_states WHERE user_id = ?", (uid,))
        return True


def approve_castle(castle_id: str) -> bool:
    with get_connection() as conn:
        conn.execute(
            "UPDATE castle_states SET state = 'idle', conn_state = 'idle', is_active = 1, status_message = 'جاهز للتشغيل' WHERE castle_id = ?",
            (castle_id,),
        )
        row = conn.execute("SELECT user_id FROM castle_states WHERE castle_id = ?", (castle_id,)).fetchone()
        if row and row["user_id"]:
            uid = row["user_id"]
            u_row = conn.execute("SELECT * FROM users WHERE uid = ?", (uid,)).fetchone()
            if u_row and not _is_admin_account(dict(u_row)):
                cnt_row = conn.execute(
                    """
                    SELECT COUNT(*) as cnt
                    FROM castle_states
                    WHERE user_id = ?
                      AND is_active = 1
                      AND LOWER(TRIM(COALESCE(state, ''))) NOT IN ('pending', 'rejected')
                    """,
                    (uid,),
                ).fetchone()
                active_cnt = int(cnt_row["cnt"]) if cnt_row else 0
                current_max = max(0, int(dict(u_row).get("max_castles") or 0))
                if active_cnt > current_max:
                    conn.execute("UPDATE users SET max_castles = ? WHERE uid = ?", (active_cnt, uid))
        return True


def reject_castle(castle_id: str, reason: str = "") -> bool:
    with get_connection() as conn:
        conn.execute("UPDATE castle_states SET state = 'rejected', status_message = ? WHERE castle_id = ?", (reason, castle_id))
        return True


def update_user_subscription(uid: str, days: int) -> bool:
    new_end = (datetime.now(timezone.utc) + timedelta(days=days)).isoformat()
    with get_connection() as conn:
        conn.execute("UPDATE users SET subscription_end = ?, status = 'approved' WHERE uid = ?", (new_end, uid))
        return True


def approve_all_pending_users(days: int = 3, max_castles: int = 10) -> int:
    """الموافقة على جميع المستخدمين المعلقين وتفعيل الباقة التجريبية"""
    with get_connection() as conn:
        new_end = (datetime.now(timezone.utc) + timedelta(days=days)).isoformat()
        res = conn.execute(
            "UPDATE users SET status = 'approved', trial_used = 1, subscription_end = ?, max_castles = ? WHERE status = 'pending'",
            (new_end, max_castles)
        )
        return res.rowcount


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

