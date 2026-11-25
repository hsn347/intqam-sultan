# -*- coding: utf-8 -*-
"""
proxy/proxy_manager.py — مدير بروكسيات SOCKS5 الذكي
══════════════════════════════════════════════════════════════════════════════════════
- دعم البروكسيات السكنية المدفوعة (Static Residential) كخيار معتمد.
- دعم البروكسيات المجانية (Free Datacenter) كخيار احتياطي.
- النمط الافتراضي الأولي عند الإطلاق هو 'direct' حتى يتم تفعيل البروكسي يدوياً من لوحة الأدمن.
- كاش محلي دائم لكل فئة (Permanent Caches): استهلاك صفر API أثناء التشغيل اليومي.
- حظر التسريب الصارم (Strict Anti-Leak): لا يسمح بالاتصال المباشر إطلاقاً عند تفعيل أي نمط بروكسي.
- توحيد IP قلاع نفس المستخدم (User-Centric Grouping) لتبدو كشبكة منزلية طبيعية.
- توزيع متوازن ومتساوٍ للحمولة (Least-Loaded Balancing) على جميع الـ IPs.
- دعم الفحص المباشر للبروكسي من لوحة التحكم (Live Proxy Health Test).
"""

from __future__ import annotations

import asyncio
import json
import logging
import os
import socket
import threading
import time
import urllib.request
from typing import Any, Dict, List, Optional

log = logging.getLogger("proxy_manager")

WEBSHARE_API_KEY = os.environ.get("WEBSHARE_API_KEY", "2jvvi0xryjubgg224ub15mrk7sdb1y9g5zp7x5mw")
WEBSHARE_API_URL = "https://proxy.webshare.io/api/v2/proxy/list/?mode=direct&page=1&page_size=100"

_DIR = os.path.dirname(os.path.abspath(__file__))

# ملفات الكاش المنفصلة
_RESIDENTIAL_CACHE_FILE = os.path.join(_DIR, "static_residential_proxies.json")
_FREE_CACHE_FILE = os.path.join(_DIR, "webshare_free_proxies.json")
_CACHE_FILE = os.path.join(_DIR, "webshare_proxies.json")
_USER_BINDINGS_FILE = os.path.join(_DIR, "user_proxy_bindings.json")

# الذاكرة الحية لمجموعات البروكسيات
_residential_proxies: List[Dict[str, Any]] = []
_free_proxies: List[Dict[str, Any]] = []
_proxies: List[Dict[str, Any]] = []  # توافق عكسي للباقة النشطة

# قواميس الارتباطات لكل فئة: {"residential": {...}, "free": {...}}
_user_bindings: Dict[str, Dict[str, str]] = {"residential": {}, "free": {}}
_castle_bindings: Dict[str, Dict[str, str]] = {"residential": {}, "free": {}}

_manager_lock = threading.Lock()
_lock = _manager_lock
_proxy_enabled: bool = False  # البداية الافتراضية 'direct' حتى التفعيل من لوحة الأدمن
_cached_server_ip: Optional[str] = None


def _detect_local_outbound_ip() -> str:
    """كشف IP الواجهة المحلية دون إرسال حزم خارجية."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            if ip and not ip.startswith("127."):
                return ip
    except Exception:
        pass
    return "direct"


def get_server_public_ip() -> str:
    """استرجاع IP السيرفر الحقيقي العام وتخزينه في الذاكرة لتجنب أي تأخير."""
    global _cached_server_ip
    if _cached_server_ip:
        return _cached_server_ip
    try:
        req = urllib.request.Request("https://api.ipify.org", headers={"User-Agent": "IntqamSultanBot/1.0"})
        with urllib.request.urlopen(req, timeout=2.5) as resp:
            val = resp.read().decode("utf-8").strip()
            if val:
                _cached_server_ip = val
    except Exception:
        pass
    if not _cached_server_ip:
        _cached_server_ip = _detect_local_outbound_ip()
    return _cached_server_ip or "direct"


def get_network_mode() -> str:
    """
    استرجاع نمط الاتصال:
      - 'direct': IP السيرفر المباشر (افتراضي عند التشغيل الأولي)
      - 'residential': بروكسيات سكنية ثابتة مدفوعة (Static Residential)
      - 'free': بروكسيات مجانية (Free Datacenter)
    """
    try:
        from core.database import get_system_setting
        val = get_system_setting("network_mode", default="direct")
        if val in ("direct", "free", "residential"):
            return val
        if val == "socks5":
            return "residential"
    except Exception:
        pass
    return "residential" if _proxy_enabled else "direct"


def set_network_mode(mode: str) -> str:
    """تحديد نمط الاتصال وحفظه في قاعدة البيانات وتحميل الباقة المطلوبة."""
    global _proxy_enabled
    target = str(mode or "").strip().lower()
    if target == "socks5":
        target = "residential"
    elif target not in ("direct", "free", "residential"):
        target = "direct"

    try:
        from core.database import set_system_setting
        set_system_setting("network_mode", target)
    except Exception as e:
        log.warning(f"[ProxyMgr] فشل حفظ نمط الشبكة في قاعدة البيانات: {e}")

    _proxy_enabled = (target != "direct")

    # إعادة تحميل الباقة النشطة فوراً
    with _manager_lock:
        _ensure_loaded(force=False)
        _sync_active_proxies_legacy()

    if target == "direct":
        log.warning("[ProxyMgr] 🌐 تم تفعيل نمط الاتصال المباشر (Direct Server IP) — البروكسيات معطلة.")
    elif target == "free":
        log.info("[ProxyMgr] 🛡️ تم تفعيل نمط البروكسيات المجانية الاحتياطية (Free Datacenter).")
    else:
        log.info("[ProxyMgr] 🌟 تم تفعيل نمط البروكسيات السكنية المدفوعة المعتمدة (Static Residential).")
    return target


def is_proxy_enabled() -> bool:
    return get_network_mode() in ("residential", "free", "socks5")


def disable_proxy():
    set_network_mode("direct")


def enable_proxy():
    set_network_mode("residential")


def _fetch_from_api() -> List[Dict[str, Any]]:
    """جلب قائمة البروكسيات السكنية من Webshare API."""
    if not WEBSHARE_API_KEY:
        log.warning("[ProxyMgr] لم يتم تعيين مفتاح Webshare API!")
        return []

    try:
        req = urllib.request.Request(
            WEBSHARE_API_URL,
            headers={
                "Authorization": f"Token {WEBSHARE_API_KEY}",
                "User-Agent": "IntqamSultan-ProxyManager/1.0"
            }
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            results = data.get("results", [])
            log.info(f"[ProxyMgr] ✓ تم جلب {len(results)} بروكسي بنجاح من Webshare API")
            return results
    except Exception as e:
        log.warning(f"[ProxyMgr] فشل الاتصال بـ Webshare API: {e}")
        return []


def _load_pool(pool_name: str) -> List[Dict[str, Any]]:
    """قراءة البروكسيات المخزنة لفئة محددة ('residential' أو 'free')."""
    if pool_name == "free":
        targets = [_FREE_CACHE_FILE, _CACHE_FILE]
    else:
        targets = [_RESIDENTIAL_CACHE_FILE, _CACHE_FILE]

    for target in targets:
        if os.path.exists(target):
            try:
                with open(target, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    proxies = data.get("proxies", [])
                    if proxies:
                        return proxies
            except Exception as e:
                log.debug(f"[ProxyMgr] تعذرت قراءة الكاش ({target}): {e}")
    return []


def _save_pool(pool_name: str, proxies: List[Dict[str, Any]]):
    """حفظ قائمة البروكسيات لفئة محددة في ملف الكاش المخصص لها."""
    target = _FREE_CACHE_FILE if pool_name == "free" else _RESIDENTIAL_CACHE_FILE
    try:
        payload = {
            "saved_at": time.time(),
            "count": len(proxies),
            "type": "free_datacenter" if pool_name == "free" else "static_residential",
            "proxies": proxies
        }
        with open(target, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=2)
    except Exception as e:
        log.warning(f"[ProxyMgr] فشل حفظ كاش البروكسي ({pool_name}): {e}")


def _load_bindings():
    """تحميل ارتباطات القلاع والمستخدمين مع دعم العزل بين المدفوع والمجاني."""
    global _user_bindings, _castle_bindings
    target = _USER_BINDINGS_FILE
    if os.path.exists(target):
        try:
            with open(target, "r", encoding="utf-8") as f:
                data = json.load(f)
                if "residential" in data and isinstance(data["residential"], dict):
                    _user_bindings["residential"] = data["residential"].get("users", {}) or {}
                    _castle_bindings["residential"] = data["residential"].get("castles", {}) or {}
                    _user_bindings["free"] = data.get("free", {}).get("users", {}) or {}
                    _castle_bindings["free"] = data.get("free", {}).get("castles", {}) or {}
                else:
                    old_users = data.get("users", {}) or {}
                    old_castles = data.get("castles", {}) or {}
                    _user_bindings["free"] = dict(old_users)
                    _castle_bindings["free"] = dict(old_castles)
                    _user_bindings["residential"] = {}
                    _castle_bindings["residential"] = {}
        except Exception as e:
            log.warning(f"[ProxyMgr] فشل قراءة ملف الارتباطات: {e}")


def _save_bindings():
    """حفظ ارتباطات القلاع والمستخدمين بشكل معزول وآمن."""
    try:
        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"
        payload = {
            "residential": {
                "users": _user_bindings.get("residential", {}),
                "castles": _castle_bindings.get("residential", {}),
            },
            "free": {
                "users": _user_bindings.get("free", {}),
                "castles": _castle_bindings.get("free", {}),
            },
            # توافق عكسي
            "users": _user_bindings.get(pool_key, {}),
            "castles": _castle_bindings.get(pool_key, {}),
            "active_mode": mode,
            "updated_at": time.time()
        }
        with open(_USER_BINDINGS_FILE, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=2)
    except Exception as e:
        log.warning(f"[ProxyMgr] فشل حفظ الارتباطات: {e}")


def _format_proxy_url(item: Dict[str, Any]) -> Optional[str]:
    host = item.get("proxy_address", "")
    port = item.get("socks5_port") or item.get("port", 0)
    user = item.get("username", "")
    pwd = item.get("password", "")
    if not host or not port:
        return None
    if user and pwd:
        return f"socks5://{user}:{pwd}@{host}:{port}"
    return f"socks5://{host}:{port}"


def _ensure_loaded(force: bool = False):
    """التأكد من تحميل كلا الكاشين (السكني المدفوع والمجاني الاحتياطي)."""
    global _residential_proxies, _free_proxies

    if force or not _residential_proxies:
        cached_res = _load_pool("residential")
        if cached_res and not force:
            _residential_proxies = cached_res
        else:
            api_res = _fetch_from_api()
            if api_res:
                _residential_proxies = api_res
                _save_pool("residential", api_res)
            elif cached_res:
                _residential_proxies = cached_res

    if force or not _free_proxies:
        _free_proxies = _load_pool("free")


def get_active_proxies() -> List[Dict[str, Any]]:
    """استرجاع قائمة البروكسيات النشطة بحسب النمط المختار مع العودة للبديل إن لزم."""
    _ensure_loaded()
    mode = get_network_mode()
    if mode == "free":
        if _free_proxies:
            return _free_proxies
        return _residential_proxies
    else:
        if _residential_proxies:
            return _residential_proxies
        return _free_proxies


def _sync_active_proxies_legacy():
    """مزامنة القائمة العامة _proxies للتوافق مع أي استدعاءات قديمة."""
    global _proxies
    _proxies = get_active_proxies()


def _resolve_user_id_for_email(email: str) -> Optional[str]:
    try:
        from core.database import resolve_user_id_by_email
        return resolve_user_id_by_email(email)
    except Exception:
        return None


def get_proxy_for_account(account_key: str, user_id: Optional[str] = None) -> Optional[str]:
    """
    تخصيص بروكسي دائم ومستقر يعتمد فهرس البروكسي (proxy_index) المسجل في قاعدة البيانات
    مع توحيد قلاع نفس المستخدم والتوزيع المتوازن، لضمان عدم تغير موقع القلعة حتى عند تجديد البروكسيات.
    """
    if not is_proxy_enabled():
        return None

    clean_email = (account_key or "").strip().lower()
    if not clean_email:
        return None

    with _manager_lock:
        active_proxies = get_active_proxies()
        if not active_proxies:
            log.error("[ProxyMgr] 🛑 لا توجد أي بروكسيات متاحة في الباقة النشطة!")
            return None

        total_proxies = len(active_proxies)
        _load_bindings()
        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"

        c_bindings = _castle_bindings.setdefault(pool_key, {})
        u_bindings = _user_bindings.setdefault(pool_key, {})

        effective_user_id = (user_id or _resolve_user_id_for_email(clean_email) or "").strip() or None
        proxy_urls = [_format_proxy_url(p) for p in active_proxies]
        valid_urls = {u for u in proxy_urls if u}

        # ── 1. فحص قاعدة البيانات: هل القلعة تمتلك proxy_index محفوظ مسبقاً؟ ──
        db_proxy_idx: Optional[int] = None
        try:
            from core.database import get_castle_proxy_index
            db_proxy_idx = get_castle_proxy_index(clean_email)
        except Exception as e:
            log.debug(f"[ProxyMgr] تعذرت قراءة proxy_index من قاعدة البيانات: {e}")

        if db_proxy_idx is not None and db_proxy_idx >= 0:
            safe_idx = db_proxy_idx % total_proxies
            selected_url = _format_proxy_url(active_proxies[safe_idx])
            if selected_url:
                c_bindings[clean_email] = selected_url
                if effective_user_id:
                    u_bindings[effective_user_id] = selected_url
                return selected_url

        # ── 2. فحص قلاع نفس المستخدم: توحيد البروكسي لكل قلاع المستخدم الواحد ──
        if effective_user_id:
            try:
                from core.database import get_user_proxy_index, set_castle_proxy_index
                user_proxy_idx = get_user_proxy_index(effective_user_id)
                if user_proxy_idx is not None and user_proxy_idx >= 0:
                    safe_idx = user_proxy_idx % total_proxies
                    selected_url = _format_proxy_url(active_proxies[safe_idx])
                    if selected_url:
                        set_castle_proxy_index(clean_email, safe_idx)
                        c_bindings[clean_email] = selected_url
                        u_bindings[effective_user_id] = selected_url
                        _save_bindings()
                        log.info(f"[ProxyMgr] 🔗 [قاعدة البيانات] تم ضم القلعة {clean_email} لبروكسي المستخدم {effective_user_id} المشترك (فهرس: {safe_idx}).")
                        return selected_url
            except Exception as e:
                log.debug(f"[ProxyMgr] تعذر استعلام proxy_index للمستخدم: {e}")

            # fallback: إن كان للمستخدم ارتباط محفوظ في الذاكرة/JSON قبل حفظ صف القلعة الأولى في DB
            if effective_user_id in u_bindings and u_bindings[effective_user_id] in valid_urls:
                bound_u_url = u_bindings[effective_user_id]
                try:
                    matched_idx = proxy_urls.index(bound_u_url)
                    from core.database import set_castle_proxy_index
                    set_castle_proxy_index(clean_email, matched_idx)
                except Exception:
                    pass
                c_bindings[clean_email] = bound_u_url
                _save_bindings()
                return bound_u_url

        # ── 3. التوافق العكسي: فحص الارتباط المسجل مسبقاً في ملف JSON إن وجد وترقيته لقاعدة البيانات ──
        if clean_email in c_bindings and c_bindings[clean_email] in valid_urls:
            bound_url = c_bindings[clean_email]
            try:
                matched_idx = proxy_urls.index(bound_url)
                from core.database import set_castle_proxy_index
                set_castle_proxy_index(clean_email, matched_idx)
            except Exception:
                pass
            if effective_user_id:
                u_bindings[effective_user_id] = bound_url
            return bound_url

        # ── 4. تخصيص جديد ذكي: اختيار الفهرس الأقل حمولة وحفظه في قاعدة البيانات ──
        counts: Dict[int, int] = {i: 0 for i in range(total_proxies)}
        try:
            from core.database import get_all_castle_proxy_counts
            counts = get_all_castle_proxy_counts(total_proxies)
        except Exception:
            for bound_url in c_bindings.values():
                for i, u in enumerate(proxy_urls):
                    if u == bound_url:
                        counts[i] = counts.get(i, 0) + 1

        least_loaded_idx = min(range(total_proxies), key=lambda i: counts.get(i, 0))
        selected_url = _format_proxy_url(active_proxies[least_loaded_idx])
        if not selected_url:
            return None

        try:
            from core.database import set_castle_proxy_index
            set_castle_proxy_index(clean_email, least_loaded_idx)
        except Exception as e:
            log.warning(f"[ProxyMgr] تعذر حفظ proxy_index للقلعة ({clean_email}): {e}")

        c_bindings[clean_email] = selected_url
        if effective_user_id:
            u_bindings[effective_user_id] = selected_url

        _save_bindings()
        new_count = counts.get(least_loaded_idx, 0) + 1
        log.info(f"[ProxyMgr] ⚖️ [توزيع DB] ربط القلعة {clean_email} بالبروكسي رقم [{least_loaded_idx}] (الحمولة: {new_count} قلعة).")
        return selected_url


def sync_castle_proxy_index(email: str, user_id: Optional[str] = None) -> Optional[int]:
    """
    مزامنة وتثبيت proxy_index في قاعدة البيانات لقلعة تم إنشاؤها للتو إذا كان نمط البروكسي مفعلاً.
    """
    if not is_proxy_enabled():
        return None
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return None
    selected_url = get_proxy_for_account(clean_email, user_id=user_id)
    if not selected_url:
        return None
    with _manager_lock:
        active_proxies = get_active_proxies()
        proxy_urls = [_format_proxy_url(p) for p in active_proxies]
        if selected_url in proxy_urls:
            idx = proxy_urls.index(selected_url)
            try:
                from core.database import set_castle_proxy_index
                set_castle_proxy_index(clean_email, idx)
                return idx
            except Exception:
                pass
    return None


def get_proxy_ip_for_email(email: str) -> str:
    """استرجاع عنوان الـ IP المخصص للقلعة في الباقة النشطة (أو IP السيرفر إذا كان النمط مباشر)."""
    if not is_proxy_enabled():
        return get_server_public_ip()
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return ""
    with _manager_lock:
        try:
            from core.database import get_castle_proxy_index
            db_idx = get_castle_proxy_index(clean_email)
            if db_idx is not None and db_idx >= 0:
                active = get_active_proxies()
                if active:
                    p = active[db_idx % len(active)]
                    ip = p.get("proxy_address", "")
                    if ip:
                        return ip
        except Exception:
            pass

        _load_bindings()
        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"
        url = _castle_bindings.get(pool_key, {}).get(clean_email, "")
        if not url:
            other_key = "residential" if pool_key == "free" else "free"
            url = _castle_bindings.get(other_key, {}).get(clean_email, "")
        if not url:
            return ""
        try:
            return url.split("@")[-1].split(":")[0]
        except Exception:
            return ""


def remove_castle_proxy(email: str) -> bool:
    """إزالة ارتباط البروكسي للقلعة المحذوفة من كلا الباقتين وقاعدة البيانات."""
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return False
    with _manager_lock:
        try:
            from core.database import set_castle_proxy_index
            set_castle_proxy_index(clean_email, -1)
        except Exception:
            pass
        _load_bindings()
        changed = False
        for pool in ("residential", "free"):
            if clean_email in _castle_bindings.get(pool, {}):
                del _castle_bindings[pool][clean_email]
                changed = True
        if changed:
            _save_bindings()
            log.info(f"[ProxyMgr] 🗑️ تم حذف ارتباط البروكسي للقلعة: {clean_email}")
            return True
    return False


def set_castle_proxy(email: str, proxy_url: str) -> None:
    """ربط قلعة ببروكسي محدد في الباقة النشطة وتحديث الارتباطات."""
    clean_email = (email or "").strip().lower()
    with _manager_lock:
        _load_bindings()
        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"
        _castle_bindings.setdefault(pool_key, {})[clean_email] = proxy_url
        _save_bindings()


def get_castle_proxy(email: str) -> Optional[str]:
    """استرجاع رابط البروكسي المرتبط بالقلعة في الباقة النشطة."""
    clean_email = (email or "").strip().lower()
    with _manager_lock:
        _load_bindings()
        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"
        return _castle_bindings.get(pool_key, {}).get(clean_email)


def remove_user_proxy_bindings(user_id: str, castle_emails: Optional[List[str]] = None) -> None:
    """إزالة ارتباطات البروكسي لمستخدم وجميع قلاعه المحذوفة من كلا الباقتين."""
    clean_uid = (user_id or "").strip()
    with _manager_lock:
        _load_bindings()
        changed = False
        for pool in ("residential", "free"):
            u_b = _user_bindings.get(pool, {})
            c_b = _castle_bindings.get(pool, {})
            if clean_uid and clean_uid in u_b:
                del u_b[clean_uid]
                changed = True
            if castle_emails:
                for em in castle_emails:
                    clean_em = (em or "").strip().lower()
                    if clean_em in c_b:
                        del c_b[clean_em]
                        changed = True
        if changed:
            _save_bindings()
            log.info(f"[ProxyMgr] 🗑️ تم حذف ارتباطات البروكسي للمستخدم {clean_uid}")


# ══════════════════════════════════════════════════════════════════════════════
# التعيين اليدوي من لوحة الأدمن (Manual Assignment)
# المصدر الأساسي للحقيقة هو proxy_index في SQLite؛ يُحدَّث معه ملف الارتباطات لتبقى البطاقات متسقة.
# التغيير يسري على القلعة عند أول connect() جديد (القلاع الشغالة تبقى على IP الحالي حتى ذلك الحين).
# ══════════════════════════════════════════════════════════════════════════════

def get_proxy_ips() -> List[str]:
    """عناوين IP للبروكسيات النشطة بترتيب الفهارس (لعرض IP كل proxy_index في الواجهة)."""
    with _manager_lock:
        return [str(p.get("proxy_address", "")) for p in get_active_proxies()]


def _bind_emails_locked(emails: List[str], url: str, user_id: Optional[str] = None) -> None:
    """تحديث ملف الارتباطات لقلاع معيّنة (يُستدعى والقفل ممسوك)."""
    _load_bindings()
    pool_key = "free" if get_network_mode() == "free" else "residential"
    c_b = _castle_bindings.setdefault(pool_key, {})
    for em in emails:
        c_b[em] = url
    if user_id:
        _user_bindings.setdefault(pool_key, {})[user_id] = url
    _save_bindings()


def _validated_target_locked(proxy_index: Any) -> tuple:
    """يتحقق من فهرس البروكسي الهدف. يرجع (idx, url, host, total) أو (None, None, msg, total)."""
    active = get_active_proxies()
    total = len(active)
    try:
        idx = int(proxy_index)
    except (TypeError, ValueError):
        return None, None, "فهرس البروكسي غير صالح", total
    if total == 0:
        return None, None, "لا توجد بروكسيات في الباقة النشطة", total
    if not (0 <= idx < total):
        return None, None, "فهرس البروكسي خارج النطاق", total
    url = _format_proxy_url(active[idx])
    if not url:
        return None, None, "بيانات البروكسي المختار غير مكتملة", total
    return idx, url, str(active[idx].get("proxy_address", "")), total


def assign_castle_to_proxy(email: str, proxy_index: Any) -> Dict[str, Any]:
    """نقل قلعة واحدة إلى بروكسي محدد يدوياً."""
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return {"ok": False, "msg": "إيميل القلعة مطلوب"}
    with _manager_lock:
        idx, url, host_or_msg, _total = _validated_target_locked(proxy_index)
        if idx is None:
            return {"ok": False, "msg": host_or_msg}
        from core.database import set_castles_proxy_index_bulk
        if set_castles_proxy_index_bulk([clean_email], idx) == 0:
            return {"ok": False, "msg": "القلعة غير موجودة"}
        _bind_emails_locked([clean_email], url)
    log.info(f"[ProxyMgr] 🔀 [يدوي] نقل القلعة {clean_email} إلى البروكسي [{idx}] ({host_or_msg}).")
    return {"ok": True, "moved": 1, "emails": [clean_email], "proxy_index": idx, "ip": host_or_msg}


def assign_user_to_proxy(user_id: str, proxy_index: Any) -> Dict[str, Any]:
    """نقل كل قلاع مستخدم إلى بروكسي محدد يدوياً (يبقون معاً على نفس الـ IP)."""
    clean_uid = (user_id or "").strip()
    if not clean_uid:
        return {"ok": False, "msg": "معرّف المستخدم مطلوب"}
    with _manager_lock:
        idx, url, host_or_msg, _total = _validated_target_locked(proxy_index)
        if idx is None:
            return {"ok": False, "msg": host_or_msg}
        from core.database import get_user_castle_emails, set_castles_proxy_index_bulk
        emails = get_user_castle_emails(clean_uid)
        if not emails:
            return {"ok": False, "msg": "لا توجد قلاع لهذا المستخدم"}
        set_castles_proxy_index_bulk(emails, idx)
        _bind_emails_locked(emails, url, user_id=clean_uid)
    log.info(f"[ProxyMgr] 🔀 [يدوي] نقل {len(emails)} قلعة للمستخدم {clean_uid} إلى البروكسي [{idx}] ({host_or_msg}).")
    return {"ok": True, "moved": len(emails), "emails": emails, "proxy_index": idx, "ip": host_or_msg}


def drain_proxy(proxy_index: Any) -> Dict[str, Any]:
    """إخلاء بروكسي: نقل كل قلاعه لبقية البروكسيات بتوزيع متوازن (قلاع المستخدم الواحد تبقى معاً)."""
    with _manager_lock:
        src, _url, src_host_or_msg, total = _validated_target_locked(proxy_index)
        if src is None:
            return {"ok": False, "msg": src_host_or_msg}
        if total < 2:
            return {"ok": False, "msg": "لا يوجد بروكسي بديل للنقل إليه"}

        from core.database import (
            get_castles_by_proxy_index, get_all_castle_proxy_counts, set_castles_proxy_index_bulk,
        )
        castles = get_castles_by_proxy_index(src, total)
        if not castles:
            return {"ok": True, "moved": 0, "emails": [], "targets": {}}

        # تجميع بحسب المستخدم (قلعة بلا مستخدم = مجموعة مستقلة)
        groups: Dict[str, List[str]] = {}
        for c in castles:
            key = c["user_id"] or f"__castle__{c['email']}"
            groups.setdefault(key, []).append(c["email"])

        active = get_active_proxies()
        counts = get_all_castle_proxy_counts(total)
        candidates = [i for i in range(total) if i != src and _format_proxy_url(active[i])]
        if not candidates:
            return {"ok": False, "msg": "لا يوجد بروكسي بديل صالح"}

        targets: Dict[str, int] = {}
        moved_emails: List[str] = []
        for key, emails in sorted(groups.items(), key=lambda kv: -len(kv[1])):
            dst = min(candidates, key=lambda i: counts.get(i, 0))
            set_castles_proxy_index_bulk(emails, dst)
            counts[dst] = counts.get(dst, 0) + len(emails)
            uid = None if key.startswith("__castle__") else key
            _bind_emails_locked(emails, _format_proxy_url(active[dst]) or "", user_id=uid)
            host = str(active[dst].get("proxy_address", dst))
            targets[host] = targets.get(host, 0) + len(emails)
            moved_emails.extend(emails)
    log.info(f"[ProxyMgr] 🚧 [يدوي] إخلاء البروكسي [{src}] ({src_host_or_msg}): نقل {len(moved_emails)} قلعة → {targets}")
    return {"ok": True, "moved": len(moved_emails), "emails": moved_emails, "targets": targets}


def unbind_castle(email: str) -> Dict[str, Any]:
    """إزالة ارتباط قلعة ليُعاد تخصيصها تلقائياً عند أول اتصال (أقل بروكسي حمولة أو بروكسي قلاع مستخدمها)."""
    clean_email = (email or "").strip().lower()
    if not clean_email:
        return {"ok": False, "msg": "إيميل القلعة مطلوب"}
    remove_castle_proxy(clean_email)
    return {"ok": True, "moved": 1, "emails": [clean_email]}


def unbind_user(user_id: str) -> Dict[str, Any]:
    """إزالة ارتباط كل قلاع مستخدم ليُعاد تخصيصها تلقائياً."""
    clean_uid = (user_id or "").strip()
    if not clean_uid:
        return {"ok": False, "msg": "معرّف المستخدم مطلوب"}
    from core.database import get_user_castle_emails, set_castles_proxy_index_bulk
    emails = get_user_castle_emails(clean_uid)
    if not emails:
        return {"ok": False, "msg": "لا توجد قلاع لهذا المستخدم"}
    set_castles_proxy_index_bulk(emails, -1)
    remove_user_proxy_bindings(clean_uid, emails)
    return {"ok": True, "moved": len(emails), "emails": emails}


async def test_single_proxy(proxy_url: str) -> Dict[str, Any]:
    """فحص نفق SOCKS5 لعنوان معين باتجاه سيرفر انتقام السلاطين وحساب الـ Ping."""
    if not proxy_url:
        return {"ok": False, "msg": "عنوان البروكسي فارغ"}

    dest_host, dest_port = ("170.33.13.16", 10000)
    try:
        from core.game_client import LOGIN_SERVER
        dest_host, dest_port = LOGIN_SERVER
    except Exception:
        pass

    t0 = time.time()
    try:
        from python_socks.async_.asyncio import Proxy
        proxy = Proxy.from_url(proxy_url)
        sock = await asyncio.wait_for(
            proxy.connect(dest_host=dest_host, dest_port=dest_port),
            timeout=8
        )
        sock.close()
        ping_ms = int((time.time() - t0) * 1000)
        return {"ok": True, "ping": ping_ms, "msg": "متصل ومؤمن بنجاح"}
    except Exception as e:
        return {"ok": False, "msg": str(e)}


def reload_proxies() -> int:
    """إعادة جلب وتحديث قائمة البروكسيات السكنية من Webshare API."""
    with _manager_lock:
        _ensure_loaded(force=True)
        _sync_active_proxies_legacy()
        active = get_active_proxies()
        return len(active)


def proxy_status() -> Dict[str, Any]:
    """تقرير شامل يُظهر تفاصيل الـ IPs والقلاع والمستخدمين المربوطين لعرضها في صفحة AdminProxies."""
    with _manager_lock:
        _ensure_loaded()
        _load_bindings()
        _sync_active_proxies_legacy()

        mode = get_network_mode()
        pool_key = "free" if mode == "free" else "residential"
        active_proxies = get_active_proxies()
        total_p = len(active_proxies)
        c_bindings = _castle_bindings.get(pool_key, {})
        u_bindings = _user_bindings.get(pool_key, {})

        db_castle_map: Dict[int, List[str]] = {}
        db_user_map: Dict[int, List[str]] = {}
        try:
            from core.database import get_all_castle_proxy_assignments
            db_castle_map, db_user_map = get_all_castle_proxy_assignments(total_p)
        except Exception:
            pass

        proxies_list = []
        all_bound_users = set(u_bindings.keys())
        for idx, p in enumerate(active_proxies):
            url = _format_proxy_url(p)
            if url:
                host = p.get("proxy_address", "")
                port = p.get("socks5_port") or p.get("port")
                assigned = [em for em, u in c_bindings.items() if u == url]
                for db_em in db_castle_map.get(idx, []):
                    if db_em not in assigned:
                        assigned.append(db_em)

                users = [uid for uid, u in u_bindings.items() if u == url]
                for db_uid in db_user_map.get(idx, []):
                    if db_uid not in users:
                        users.append(db_uid)
                    all_bound_users.add(db_uid)

                proxies_list.append({
                    "index": idx,
                    "ip": host,
                    "port": port,
                    "country": p.get("country_code", "??"),
                    "city": p.get("city_name", ""),
                    "asn": p.get("asn_name", ""),
                    "type": pool_key,
                    "assigned_castles": assigned,
                    "assigned_users": users,
                    "full_url": url
                })

        all_bound_castles = set(c_bindings.keys())
        for ems in db_castle_map.values():
            all_bound_castles.update(ems)

        return {
            "enabled": is_proxy_enabled(),
            "network_mode": mode,
            "server_ip": get_server_public_ip(),
            "total_proxies": len(active_proxies),
            "residential_count": len(_residential_proxies),
            "free_count": len(_free_proxies),
            "active_pool_name": "سكنية مدفوعة (Static Residential)" if mode == "residential" else ("مجانية (Free Datacenter)" if mode == "free" else "IP السيرفر المباشر"),
            "total_bound_castles": len(all_bound_castles),
            "total_bound_users": len(all_bound_users),
            "proxies_list": proxies_list
        }
