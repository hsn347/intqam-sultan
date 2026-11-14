# -*- coding: utf-8 -*-
"""
core/tenants.py — سجل إعدادات التجار والنطاقات المتعددة (Revenge of Sultans)
═════════════════════════════════════════════════════════════════════════════════
يحدد قائمة التجار والدومينات المعتمدة وحسابات المشرفين الخاصة بهم.
"""

from typing import List, Dict, Any, Optional

DEFAULT_TENANT: Dict[str, Any] = {
    "id": "main",
    "domains": ["localhost", "127.0.0.1", "ibrabot.online", "www.ibrabot.online"],
    "brand_name": "Sultan Bot",
    "default_language": "ar",
    "admin_email": "ibraboths@gmail.com",
    "primary_color": "#10b981",
    "logo_url": "/logo.png?v=2",
}

MERCHANTS_CONFIG: List[Dict[str, Any]] = [
    {
        "id": "sultan_main",
        "domains": ["sultanbot.online", "www.sultanbot.online"],
        "brand_name": "Sultan Bot",
        "default_language": "ar",
        "admin_email": "ibraboths@gmail.com",
        "primary_color": "#10b981",
        "logo_url": "/logo.png",
        "tagline": "أقوى نظام إدارة وحقن مباشر للعبة انتقام السلاطين",
    },
]


def clean_domain(domain: str) -> str:
    """تنظيف النطاق من www أو المسافات أو المنافذ"""
    if not domain:
        return ""
    d = domain.strip().lower()
    if ":" in d:
        d = d.split(":")[0]
    if d.startswith("www."):
        d = d[4:]
    return d


def get_all_merchants() -> List[Dict[str, Any]]:
    """إرجاع قائمة بجميع التجار المعتمدين"""
    return MERCHANTS_CONFIG


def get_tenant_by_domain(domain: str) -> Dict[str, Any]:
    """العثور على إعدادات التاجر بناءً على اسم الدومين"""
    c_domain = clean_domain(domain)
    for m in MERCHANTS_CONFIG:
        for d in m.get("domains", []):
            if clean_domain(d) == c_domain:
                return m
    return DEFAULT_TENANT


def get_tenant_by_admin_email(email: str) -> Optional[Dict[str, Any]]:
    """العثور على إعدادات التاجر عبر البريد الإلكتروني للمسؤول"""
    if not email:
        return None
    em = email.strip().lower()
    for m in MERCHANTS_CONFIG:
        if m.get("admin_email", "").strip().lower() == em:
            return m
    return None


def is_merchant_admin(email: str) -> bool:
    """هل البريد الإلكتروني مسجل كمسؤول تاجر؟"""
    return get_tenant_by_admin_email(email) is not None


SUPER_ADMIN_EMAILS = [
    "ibraboths@gmail.com",
]


def is_super_admin(user_or_email: Any) -> bool:
    """التحقق هل المستخدم سوبر أدمن (المسؤول الوحيد ibraboths@gmail.com)"""
    if isinstance(user_or_email, dict):
        email = user_or_email.get("email", "")
    else:
        email = str(user_or_email or "")
    
    clean_em = email.strip().lower()
    return clean_em == "ibraboths@gmail.com"


def is_user_allowed_for_tenant_domain(user_email: str, tenant_domain: str) -> bool:
    """هل مسموح للمستخدم بالدخول لنطاق هذا التاجر"""
    if is_super_admin(user_email):
        return True
    return True
