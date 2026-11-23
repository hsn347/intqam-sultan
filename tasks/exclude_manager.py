# -*- coding: utf-8 -*-
"""
tasks/exclude_manager.py — مدير استبعاد الأهداف المركزي الآمن (Centralized Exclude Manager)
════════════════════════════════════════════════════════════════════════════════════════════════

يحل محل الدوال المكررة (_get_exclude / _add_exclude) المنتشرة في مهام الخريطة (الجمع، الوحوش، الأطلال):
  - gather_resources.py, hunt_monsters.py, explore_ruins.py

الميزات المعمارية:
  1. نمط الحجز والتأكيد والتحرير (Reserve → Confirm → Release pattern):
     - reserve()  : يضيف الهدف للذاكرة المؤقتة (RAM) فقط قبل إرسال المسيرة لمنع التصادم بين القلاع الشقيقة.
     - confirm()  : يثبته في قاعدة بيانات SQLite WAL بعد نجاح الإرسال فعلاً أو تأكد انشغاله.
     - release()  : يزيل الاستبعاد المؤقت عند الفشل أو الإلغاء لإعادة إتاحة الهدف فوراً.

  2. مزامنة آمنة للبيانات والخيوط (Thread & Async Safety):
     - threading.Lock لمنع Race Condition بين الحسابات المتعددة والخيوط المختلفة بأمان تام.

  3. قاعدة بيانات SQLite WAL (Write-Ahead Logging):
     - أمان تام ضد تلف البيانات، تضارب العمليات، أو تسريب المقابض (Zero Handle Leak).

  4. إدارة طول المصفوفة والمدة الزمنية (Fixed Window & Max Age):
     - جدول excluded_targets بحد أقصى 300 هدف للمملكة مرتبة من الأقدم للأحدث (حذف الأقدم تلقائياً).
     - حذف تلقائي ذكي لأي هدف تجاوز عمره 5 ساعات.

  5. سقف أمان صارم للحزمة (Packet Safety Ceiling):
     - حصر الأهداف المعادة في get_exclude_map بحد أقصى (60 هدفاً - الأحدث أولاً)
       وضمن مسافة <= 150 من القلعة.
     - يضمن عدم تجاوز حجم حزمة بروتوكول اللعبة سقف 65,535 بايت ('H' format unsigned short).

  6. تصنيف أنواع الأهداف (target_type):
     - يُستنتج تلقائياً من صيغة target_id (X-Y-mapType-subType-serial).
     - يدعم التمرير الصريح لأنواع خاصة (elite_rebel, pyramid, إلخ).
"""

from __future__ import annotations

from contextlib import contextmanager
import json
import logging
import math
import os
import sqlite3
import threading
import time
from typing import Any, Dict, List, Optional, Tuple

_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_DB_DIR   = os.path.join(_ROOT_DIR, "database")
_DB_PATH  = os.path.join(_DB_DIR, "exclude_history.db")

# مواقع ملف JSON القديم للترحيل (تُفحص مرة واحدة عند الإقلاع)
_LEGACY_JSON_PATHS = [
    os.path.join(_DB_DIR, "exclude_history.json"),
    os.path.join(_ROOT_DIR, "exclude_history.json"),
]

log = logging.getLogger("exclude_manager")


class ExcludeManager:
    """
    مدير استبعاد الأهداف المركزي الآمن.

    - Singleton-like: يُستخدم instance واحد مشترك عبر get_manager().
    - قاعدة البيانات: database/exclude_history.db (SQLite WAL).
    - بحد أقصى 300 هدف لكل مملكة مرتبة من الأقدم للأحدث (يُحذف الأقدم عند الامتلاء).
    - الحجوزات المؤقتة (reserved) تبقى في الذاكرة RAM فقط وتُمسح عند إعادة التشغيل.
    """

    MAX_PER_KINGDOM         = 300        # للإبقاء على التوافق مع الترحيل القديم
    MAX_PER_TYPE            = 150        # حد مستقل لكل نوع داخل كل مملكة (خشب لوحده، ذهب لوحده، وحوش لوحدهم...)
    MAX_RESERVED_PER_POOL   = 30         # الحد الأقصى للحجوزات المؤقتة لكل (مملكة + نوع)
    RESERVED_TTL_SECONDS    = 90.0       # صلاحية الحجز المؤقت في الذاكرة لمنع التصادم بين القلاع الشقيقة
    MAX_EXCLUDE_AGE_SECONDS = 5 * 3600   # 5 ساعات — أقصى عمر للأهداف في الاستبعاد
    MAX_QUERY_EXCLUDES      = 60         # الحد الأقصى للأهداف المعادة في get_exclude_map
    MAX_QUERY_DISTANCE      = 150.0      # أقصى مسافة عن موقع القلعة (x, y)
    NON_EXCLUDABLE_TYPES    = frozenset({"ruins", "escort", "treasure_escort"})  # الأطلال وحراسة الكنز لا تُستبعد

    def __init__(self, db_path: str | None = None):
        self._lock = threading.Lock()
        # pool_key → {target_id_str: {"uid": uid_str, "ts": timestamp}} — محجوزة في الذاكرة فقط
        self._reserved: Dict[str, Dict[str, Any]] = {}
        # uid_str → kingdom_key ("251") — كاش جلسة بسيط
        self._uid_kingdom: Dict[str, str] = {}

        self._db_path = db_path or _DB_PATH
        db_dir = os.path.dirname(self._db_path)
        if db_dir:
            os.makedirs(db_dir, exist_ok=True)
        self._init_db()

    # ────────────────────────────────────────────────────────────────
    #  اتصال SQLite WAL
    # ────────────────────────────────────────────────────────────────

    def _get_conn(self) -> sqlite3.Connection:
        """فتح اتصال WAL جديد مع إعدادات الأداء والأمان."""
        conn = sqlite3.connect(self._db_path, timeout=10.0)
        conn.execute("PRAGMA journal_mode = WAL;")
        conn.execute("PRAGMA synchronous = NORMAL;")
        conn.execute("PRAGMA busy_timeout = 5000;")
        conn.execute("PRAGMA temp_store = MEMORY;")
        conn.row_factory = sqlite3.Row
        return conn

    @contextmanager
    def _db_session(self):
        """مدير سياق آمن يفتح الاتصال ويغلقه تلقائياً لمنع أي تسريب File Handles."""
        conn = self._get_conn()
        try:
            with conn:  # يدير الـ transaction (commit/rollback)
                yield conn
        finally:
            conn.close()  # يضمن إغلاق الاتصال في كل الأحوال بنسبة 100%

    def _init_db(self):
        """إنشاء الجداول والفهارس وترحيل بيانات JSON القديمة إن وُجدت (مرة واحدة عند الإقلاع)."""
        with self._db_session() as conn:
            conn.executescript("""
                CREATE TABLE IF NOT EXISTS excluded_targets (
                    kingdom_id   INTEGER NOT NULL,
                    target_id    TEXT    NOT NULL,
                    target_type  TEXT    NOT NULL DEFAULT 'unknown',
                    x            INTEGER,
                    y            INTEGER,
                    ts           REAL    NOT NULL,
                    PRIMARY KEY (kingdom_id, target_id)
                );
                CREATE INDEX IF NOT EXISTS idx_excl_kingdom_ts
                    ON excluded_targets (kingdom_id, ts DESC);
                CREATE INDEX IF NOT EXISTS idx_excl_kingdom_type_ts
                    ON excluded_targets (kingdom_id, target_type, ts DESC);
                CREATE TABLE IF NOT EXISTS exclude_meta (
                    key   TEXT PRIMARY KEY,
                    value TEXT NOT NULL
                );
            """)
        self._migrate_legacy_json()

    # ────────────────────────────────────────────────────────────────
    #  تصنيف نوع الهدف من صيغة target_id
    # ────────────────────────────────────────────────────────────────

    @staticmethod
    def _infer_target_type(target_id: str) -> str:
        """
        استنتاج نوع الهدف من صيغة target_id: "X-Y-mapType-subType-serial"

        الأنواع المدعومة:
          mapType=5  → مورد: gold(1) | food(2) | wood(3) | iron(4) | silver(5)
          mapType=6  → invader (غازي / وحش)
          mapType=7  → ruins (أطلال)
          mapType=26 → stronghold (معقل)
          mapType=35 → rebel (متمرد)
          أخرى      → unknown
        """
        parts = str(target_id).split("-")
        if len(parts) < 5:
            return "unknown"
        try:
            map_type = int(parts[2])
            sub_type = int(parts[3])
        except (ValueError, IndexError):
            return "unknown"

        if map_type == 5:
            return {1: "gold", 2: "food", 3: "wood", 4: "iron", 5: "silver"}.get(sub_type, "resource")
        return {6: "invader", 7: "ruins", 26: "stronghold", 35: "rebel"}.get(map_type, "unknown")

    @staticmethod
    def _parse_coords(target_id: str) -> Tuple[Optional[int], Optional[int]]:
        """استخراج إحداثيات (x, y) من target_id مع تطبيق إزاحة -1."""
        parts = str(target_id).split("-")
        if len(parts) >= 2 and parts[0].isdigit() and parts[1].isdigit():
            return int(parts[0]) - 1, int(parts[1]) - 1
        return None, None

    @staticmethod
    def _normalize_query_type(target_type: Any) -> str | None:
        """
        تطبيع نوع الهدف للبحث: يقبل رقماً (subType=1..5 للموارد)، أو نصاً إنجليزياً أو عربياً، أو None.
        """
        if target_type is None:
            return None
        raw = str(target_type).strip()
        if not raw:
            return None
        if raw.isdigit():
            sub_id = int(raw)
            return {1: "gold", 2: "food", 3: "wood", 4: "iron", 5: "silver"}.get(sub_id, raw.lower())
        tt = raw.lower()
        ar_map = {
            "قمح": "food", "طعام": "food",
            "خشب": "wood",
            "حديد": "iron",
            "فضة": "silver", "الماس": "silver", "ألماس": "silver", "كوارنز": "silver", "ميثريل": "silver",
            "ذهب": "gold",
            "غازي": "invader", "وحش": "invader",
            "أطلال": "ruins", "اطلال": "ruins",
            "حراسة الكنز": "escort", "حراسة كنز": "escort", "كنز": "escort", "treasure_escort": "escort",
            "معقل": "stronghold",
            "متمرد": "rebel", "متمردين": "rebel",
            "نخبة": "elite_rebel", "نخبة المتمردين": "elite_rebel",
        }
        return ar_map.get(tt, tt)

    # ────────────────────────────────────────────────────────────────
    #  ترحيل JSON القديم (إن وجد)
    # ────────────────────────────────────────────────────────────────

    def _migrate_legacy_json(self):
        """استيراد exclude_history.json القديم إلى SQLite — يُنفَّذ مرة واحدة فقط."""
        with self._db_session() as conn:
            row = conn.execute(
                "SELECT value FROM exclude_meta WHERE key='json_migrated_v1'"
            ).fetchone()
            if row:
                return

        # البحث عن الملف القديم
        json_path = None
        for candidate in _LEGACY_JSON_PATHS:
            if os.path.exists(candidate):
                json_path = candidate
                break

        if not json_path:
            # لا يوجد ملف قديم — سجّل الترحيل فقط
            with self._db_session() as conn:
                conn.execute("INSERT OR IGNORE INTO exclude_meta VALUES ('json_migrated_v1','1')")
            return

        try:
            with open(json_path, "r", encoding="utf-8") as f:
                raw = json.load(f)
        except Exception as e:
            log.warning(f"[ExcludeManager] تعذرت قراءة ملف JSON القديم: {e}")
            return

        rows = []
        for k_key_raw, entries in raw.items():
            kk = str(k_key_raw).strip()
            if kk.startswith("k_"):
                kk = kk[2:].strip()
            if not (kk.isdigit() and int(kk) > 0):
                continue
            kingdom_id = int(kk)
            if not isinstance(entries, list):
                continue
            for entry in entries:
                if not isinstance(entry, dict):
                    continue
                tid = str(entry.get("id", "")).strip()
                if not tid:
                    continue
                try:
                    ts = float(entry.get("ts", 0))
                except (TypeError, ValueError):
                    ts = 0.0
                ttype = ExcludeManager._infer_target_type(tid)
                x, y = ExcludeManager._parse_coords(tid)
                rows.append((kingdom_id, tid, ttype, x, y, ts))

        if rows:
            with self._db_session() as conn:
                conn.executemany(
                    "INSERT OR REPLACE INTO excluded_targets "
                    "(kingdom_id, target_id, target_type, x, y, ts) VALUES (?,?,?,?,?,?)",
                    rows
                )
                kingdoms = set(r[0] for r in rows)
                for kid in kingdoms:
                    conn.execute("""
                        DELETE FROM excluded_targets
                        WHERE kingdom_id = ?
                          AND target_id NOT IN (
                              SELECT target_id FROM excluded_targets
                              WHERE kingdom_id = ?
                              ORDER BY ts DESC LIMIT ?
                          )
                    """, (kid, kid, self.MAX_PER_KINGDOM))
                conn.execute("INSERT OR IGNORE INTO exclude_meta VALUES ('json_migrated_v1','1')")

        try:
            os.rename(json_path, json_path + ".migrated.bak")
        except Exception:
            pass
        log.info("[ExcludeManager] ✅ تم ترحيل بيانات JSON القديمة إلى SQLite بنجاح")

    # ────────────────────────────────────────────────────────────────
    #  مساعدات داخلية (kingdom key / reserved keys)
    # ────────────────────────────────────────────────────────────────

    def _normalize_kingdom_key(self, uid: Any = None, kingdom_id: Any = None) -> str | None:
        """استخراج رقم المملكة الصافي كمفتاح مثل "251" دون إنشاء أي مفاتيح UID في الملف."""
        uid_str = str(uid).strip() if uid not in (None, "", 0, "0") else ""
        if kingdom_id is not None:
            raw = str(kingdom_id).strip()
            if raw.startswith("k_"):
                raw = raw[2:].strip()
            if raw.isdigit() and int(raw) > 0:
                k_key = str(int(raw))
                if uid_str:
                    self._uid_kingdom[uid_str] = k_key
                return k_key
        if uid_str and uid_str in self._uid_kingdom:
            return self._uid_kingdom[uid_str]
        return None

    def _get_reserved_keys(self, uid: Any = None, kingdom_id: Any = None) -> List[str]:
        """تحديد مفاتيح الذاكرة المؤقتة: مفتاح المملكة أولاً، أو مفتاح مؤقت عند غياب المملكة."""
        k_key = self._normalize_kingdom_key(uid, kingdom_id)
        if k_key:
            return [k_key]
        uid_str = str(uid).strip() if uid not in (None, "", 0, "0") else ""
        return [f"_tmp_{uid_str}"] if uid_str else []

    # ────────────────────────────────────────────────────────────────
    #  الواجهة العامة: reserve / confirm / release / get_exclude_map
    # ────────────────────────────────────────────────────────────────

    async def reserve(
        self,
        uid: Any,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
        ttl: float | None = None,
    ) -> bool:
        """
        حجز هدف مؤقتاً وبشكل حصري في حوض مستقل لكل (مملكة + نوع).
        يُتجاهل الاستبعاد تماماً للأطلال وحراسة الكنز (يرجع True دون حفظ).
        """
        tid_str = str(target_id).strip() if target_id is not None else ""
        if not tid_str:
            return False

        ttype = self._normalize_query_type(target_type) or self._infer_target_type(tid_str)
        if ttype in self.NON_EXCLUDABLE_TYPES:
            return True

        uid_str = str(uid).strip() if uid not in (None, "", 0, "0") else ""
        now_ts = time.time()
        effective_ttl = float(ttl) if ttl is not None else self.RESERVED_TTL_SECONDS

        with self._lock:
            base_keys = self._get_reserved_keys(uid, kingdom_id)
            pool_keys = [f"{pk}:{ttype}" for pk in base_keys]

            # 1. فحص التعارض وتنظيف المنتهي في حوض هذا النوع فقط
            for pkey in pool_keys:
                pool = self._reserved.setdefault(pkey, {})
                expired_keys = [
                    tid for tid, entry in pool.items()
                    if (now_ts - float(entry.get("ts", 0))) > float(entry.get("ttl", effective_ttl))
                ]
                for exp_tid in expired_keys:
                    del pool[exp_tid]

                if tid_str in pool:
                    existing = pool[tid_str]
                    reserver_uid = existing.get("uid")
                    reserver_ts = float(existing.get("ts", 0))
                    reserver_ttl = float(existing.get("ttl", effective_ttl))
                    if reserver_uid and reserver_uid != uid_str and (now_ts - reserver_ts) <= reserver_ttl:
                        return False

            # 2. تسجيل الحجز الحصري داخل حوض هذا النوع
            for pkey in pool_keys:
                pool = self._reserved.setdefault(pkey, {})
                pool[tid_str] = {"uid": uid_str, "ts": now_ts, "type": ttype, "ttl": effective_ttl}
                if len(pool) > self.MAX_RESERVED_PER_POOL:
                    oldest_tid = min(pool, key=lambda k: float(pool[k].get("ts", 0)))
                    del pool[oldest_tid]

            return True

    async def confirm(
        self,
        uid: Any,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
    ):
        """
        تثبيت الهدف في SQLite ضمن سجل مستقل لكل (مملكة + نوع) بحد MAX_PER_TYPE.
        لا يتم تثبيت الأطلال أو حراسة الكنز إطلاقاً.
        """
        tid_str = str(target_id).strip() if target_id is not None else ""
        if not tid_str:
            return

        ttype = self._normalize_query_type(target_type) or self._infer_target_type(tid_str)
        if ttype in self.NON_EXCLUDABLE_TYPES:
            return

        with self._lock:
            k_key = self._normalize_kingdom_key(uid, kingdom_id)
            uid_str = str(uid).strip() if uid not in (None, "", 0, "0") else ""
            for rkey in ([k_key] if k_key else []) + ([f"_tmp_{uid_str}"] if uid_str else []):
                pkey = f"{rkey}:{ttype}"
                if pkey in self._reserved:
                    self._reserved[pkey].pop(tid_str, None)

            if not k_key:
                return
            kingdom_id_int = int(k_key)

        x, y = self._parse_coords(tid_str)
        now_ts = time.time()

        with self._db_session() as conn:
            conn.execute(
                "INSERT OR REPLACE INTO excluded_targets "
                "(kingdom_id, target_id, target_type, x, y, ts) VALUES (?,?,?,?,?,?)",
                (kingdom_id_int, tid_str, ttype, x, y, now_ts)
            )
            # تقليم مستقل لهذا النوع فقط داخل المملكة
            conn.execute("""
                DELETE FROM excluded_targets
                WHERE kingdom_id = ?
                  AND target_type = ?
                  AND target_id NOT IN (
                      SELECT target_id FROM excluded_targets
                      WHERE kingdom_id = ? AND target_type = ?
                      ORDER BY ts DESC LIMIT ?
                  )
            """, (kingdom_id_int, ttype, kingdom_id_int, ttype, self.MAX_PER_TYPE))
            # حذف المنتهي (أكثر من 5 ساعات) لهذا النوع
            cutoff_ts = now_ts - self.MAX_EXCLUDE_AGE_SECONDS
            conn.execute(
                "DELETE FROM excluded_targets WHERE kingdom_id = ? AND target_type = ? AND ts < ?",
                (kingdom_id_int, ttype, cutoff_ts)
            )

    async def release(
        self,
        uid: Any,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
    ):
        """تحرير الحجز المؤقت من الذاكرة فقط إذا كان مملوكاً لنفس القلعة (uid)."""
        tid_str = str(target_id).strip() if target_id is not None else ""
        if not tid_str:
            return

        ttype = self._normalize_query_type(target_type) or self._infer_target_type(tid_str)
        if ttype in self.NON_EXCLUDABLE_TYPES:
            return

        with self._lock:
            k_key = self._normalize_kingdom_key(uid, kingdom_id)
            uid_str = str(uid).strip() if uid not in (None, "", 0, "0") else ""
            for rkey in ([k_key] if k_key else []) + ([f"_tmp_{uid_str}"] if uid_str else []):
                pkey = f"{rkey}:{ttype}"
                pool = self._reserved.get(pkey)
                if pool and tid_str in pool:
                    owner = pool[tid_str].get("uid")
                    if not owner or not uid_str or owner == uid_str:
                        pool.pop(tid_str, None)

    async def get_exclude_map(
        self,
        uid: Any,
        kingdom_id: Any = None,
        x: Optional[int] = None,
        y: Optional[int] = None,
        max_distance: float = MAX_QUERY_DISTANCE,
        target_type: Optional[Any] = None,
    ) -> Dict[str, bool]:
        """
        جلب خريطة الاستبعاد لنوع محدد فقط (أو لكل الأنواع القابلة للاستبعاد عند target_type=None).
        يرجع {} فوراً للأطلال وحراسة الكنز، ويتجاهل أي حجز RAM منتهي الصلاحية.
        """
        norm_type = self._normalize_query_type(target_type)
        if norm_type in self.NON_EXCLUDABLE_TYPES:
            return {}

        now_ts = time.time()
        reserved_pool: Dict[str, float] = {}

        with self._lock:
            k_key = self._normalize_kingdom_key(uid, kingdom_id)
            rkey = k_key or (f"_tmp_{str(uid).strip()}" if uid not in (None, "", 0, "0") else None)
            if rkey:
                if norm_type:
                    candidate_pools = [self._reserved.get(f"{rkey}:{norm_type}")]
                else:
                    prefix = f"{rkey}:"
                    candidate_pools = [
                        pool for pk, pool in self._reserved.items()
                        if pk.startswith(prefix) and pk[len(prefix):] not in self.NON_EXCLUDABLE_TYPES
                    ]

                for pool in candidate_pools:
                    if not pool:
                        continue
                    expired = []
                    for tid, entry in pool.items():
                        ts = float(entry.get("ts", 0))
                        ttl = float(entry.get("ttl", self.RESERVED_TTL_SECONDS))
                        if (now_ts - ts) > ttl:
                            expired.append(tid)
                        else:
                            reserved_pool[tid] = ts
                    for exp_tid in expired:
                        pool.pop(exp_tid, None)

        db_ids: List[str] = []
        if k_key:
            kingdom_id_int = int(k_key)
            where_clauses = ["kingdom_id = ?"]
            params: List[Any] = [kingdom_id_int]

            if norm_type:
                where_clauses.append("target_type = ?")
                params.append(norm_type)
            else:
                placeholders = ",".join("?" for _ in self.NON_EXCLUDABLE_TYPES)
                where_clauses.append(f"target_type NOT IN ({placeholders})")
                params.extend(sorted(self.NON_EXCLUDABLE_TYPES))

            cutoff_ts = now_ts - self.MAX_EXCLUDE_AGE_SECONDS
            where_clauses.append("ts >= ?")
            params.append(cutoff_ts)

            if x is not None and y is not None:
                try:
                    ix, iy = int(x), int(y)
                    max_dist = float(max_distance)
                    where_clauses.append("(x IS NULL OR y IS NULL OR (abs(x - ?) <= ? AND abs(y - ?) <= ?))")
                    params.extend([ix, max_dist, iy, max_dist])
                except (ValueError, TypeError):
                    pass

            query = f"""
                SELECT target_id FROM excluded_targets
                WHERE {' AND '.join(where_clauses)}
                ORDER BY ts ASC
            """
            with self._db_session() as conn:
                rows = conn.execute(query, params).fetchall()
                db_ids = [r[0] for r in rows]

        if reserved_pool:
            if x is not None and y is not None:
                try:
                    ix, iy = int(x), int(y)
                    max_dist = float(max_distance)
                    filtered_ram: Dict[str, float] = {}
                    for tid, r_ts in reserved_pool.items():
                        tx, ty = self._parse_coords(tid)
                        if tx is None or ty is None or (abs(tx - ix) <= max_dist and abs(ty - iy) <= max_dist):
                            filtered_ram[tid] = r_ts
                    reserved_pool = filtered_ram
                except (ValueError, TypeError):
                    pass

            if reserved_pool:
                db_ids = [tid for tid in db_ids if tid not in reserved_pool]
                db_ids.extend(sorted(reserved_pool, key=reserved_pool.get))

        return {tid: True for tid in db_ids[-self.MAX_QUERY_EXCLUDES:]}

    # ────────────────────────────────────────────────────────────────
    #  عمليات إدارية وفحص إضافية (Maintenance & Observability)
    # ────────────────────────────────────────────────────────────────

    def clear_kingdom(self, kingdom_id: Any):
        """مسح كامل سجل الاستبعاد لمملكة معينة (قاعدة البيانات والذاكرة RAM)."""
        k_key = self._normalize_kingdom_key(kingdom_id=kingdom_id)
        if not k_key:
            return
        kid = int(k_key)
        with self._lock:
            prefix = f"{k_key}:"
            for pk in [k for k in self._reserved if k == k_key or k.startswith(prefix)]:
                self._reserved.pop(pk, None)
        with self._db_session() as conn:
            conn.execute("DELETE FROM excluded_targets WHERE kingdom_id = ?", (kid,))

    def get_stats(self, kingdom_id: Any = None) -> Dict[str, Any]:
        """إحصائيات فورية عن حالة الأهداف المستبعدة والمحجوزة."""
        k_key = self._normalize_kingdom_key(kingdom_id=kingdom_id)
        stats = {
            "ram_reserved_pools": len(self._reserved),
            "ram_reserved_total": sum(len(p) for p in self._reserved.values()),
            "db_total_count": 0,
            "db_kingdom_count": 0,
        }
        with self._db_session() as conn:
            row = conn.execute("SELECT COUNT(*) FROM excluded_targets").fetchone()
            if row:
                stats["db_total_count"] = row[0]
            if k_key:
                k_row = conn.execute(
                    "SELECT COUNT(*) FROM excluded_targets WHERE kingdom_id = ?",
                    (int(k_key),)
                ).fetchone()
                if k_row:
                    stats["db_kingdom_count"] = k_row[0]
        return stats


# ════════════════════════════════════════════════════════════════════
#  Singleton instance — يُستخدم عبر get_manager() في كل المهام
# ════════════════════════════════════════════════════════════════════

_manager_instance: ExcludeManager | None = None
_manager_lock = threading.Lock()


def get_manager() -> ExcludeManager:
    """جلب المدير المركزي الوحيد (Singleton) بأمان تام عبر الخيوط المتعددة."""
    global _manager_instance
    if _manager_instance is None:
        with _manager_lock:
            if _manager_instance is None:
                _manager_instance = ExcludeManager()
    return _manager_instance