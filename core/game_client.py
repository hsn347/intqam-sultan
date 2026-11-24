# -*- coding: utf-8 -*-
"""
game_client.py — العميل الموحد المستقل للعبة انتقام السلاطين (Revenge of Sultans)
═════════════════════════════════════════════════════════════════════════════════
محدث بالكامل للعمل ببروتوكول تسجيل الدخول الرسمي المطابق 100% لملفي:
  • login.lua (S2C_CHALLENGE -> S2C_SERVERKEY -> S2C_HANDSHAKE -> S2C_AUTH_TOKEN)
  • loginCtrl.lua (دعم gateProxyHost والاتصال الاحتياطي المباشر Fallback)
  • تخصيص بصمة جوال حقيقية ومستقلة لكل حساب تلقائياً لمنع الحظر الجماعي.

python core/game_client.py --email oorrnn44@gmail.com --password asdfghjkl150

"""

import argparse
import asyncio
import base64
import hashlib
import json
import logging
import os
import random
import re
import socket
import struct
import sys
import time
import urllib.parse
import urllib.request
from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Set, Tuple
from Crypto.Cipher import DES

from core.live_memory import LiveMemoryEngine

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

log = logging.getLogger("game_client")

# ═════════════════════════════════════════════════════════════════════════════
# 1. الثوابت والإعدادات الأساسية المستخرجة من login.lua و loginCtrl.lua
# ═════════════════════════════════════════════════════════════════════════════

LOGIN_SERVER       = ("170.33.13.16", 10000)   # kohlogin.menaapp.net
GAME_VERSION       = "2.86.004"                 # GAME_VERSION
SYSTEM_PLATFORM    = "android"                  # systemPlatform
DEFAULT_OS_VER     = "13"                       # systemVersion
STORE              = "google"                   # store
PACKAGE_NAME       = "and.onemt.war.ar"         # packageName
LANGUAGE           = "ar"                       # device.language
DEFAULT_MODEL      = "V2338A"                   # model
DEFAULT_CARRIER    = "Android"                  # SoraDGetCarrier()

DEFAULT_TOKEN_USER = "3rdid"
DEFAULT_TOKEN_PASS = "password"

# قائمة طرازات هواتف حقيقية شائعة مع إصدارات أندرويد متوافقة معها (بصمة مستقلة لكل حساب)
REAL_DEVICES = [
    ("SM-S918B", "13"),       # Samsung Galaxy S23 Ultra
    ("SM-A546E", "13"),       # Samsung Galaxy A54 5G
    ("SM-G998B", "12"),       # Samsung Galaxy S21 Ultra
    ("2210132G", "13"),       # Xiaomi 13
    ("M2102J20SG", "11"),     # POCO X3 Pro
    ("2201116SG", "12"),      # Redmi Note 11 Pro 5G
    ("V2338A", "13"),         # Vivo X100
    ("V2227A", "13"),         # Vivo X90 Pro+
    ("CPH2449", "13"),        # OnePlus 11
    ("CPH2305", "12"),        # OPPO Find X5 Pro
    ("RMX3301", "12"),        # Realme GT 2 Pro
    ("ALT-NX1", "13"),        # Honor 90
    ("Pixel 7 Pro", "13"),    # Google Pixel 7 Pro
    ("SM-A736B", "12"),       # Samsung Galaxy A73 5G
    ("23049PCD8G", "13"),     # POCO F5
]

# مفاتيح توثيق ONEMT SDK Passport السحابية الرسمية (انتقام السلاطين)
AUTH_APP_ID        = "100000601"
AUTH_APP_KEY_STR   = "c350813b0b965a8c477739d488ea811c"
AUTH_APP_SIGN_MD5  = "47965E93AD48A1D34F9EF116405AA6CF"
AUTH_API_URL       = "https://apiuc.menaapp.net/v5/passport/login"

# أكواد استجابة السيرفر الرسمية (login.lua Error Codes)
ERR_HANDSHAKE_FAILED    = 400
ERR_AUTH_TOKEN_SUCCESS  = 200
ERR_UNAUTHORIZED        = 401
ERR_FORBIDDEN           = 403
ERR_NOT_ACCEPTABLE      = 406
ERR_NOT_EXIST_SERVER    = 501
ERR_BE_SEALED           = 502
ERR_VERSION_ERROR       = 503
ERR_SDK_TOKEN_ERROR     = 504
ERR_CROSSING_SVR_ERROR  = 505

# مفتاح التشفير وبادئة الحزم الرسمية لمحرك البوابة (Cocos2d-Lua gate.lua)
XOR_KEY            = "OSxHP.!-wd?'lao5"
CMD_PREFIX         = "onemt_"

# معاملات تبادل مفاتيح ديفي-هيلمان (Diffie-Hellman Little-Endian)
DH_P = 0xFFFFFFFFFFFFFFC5   # 2^64 - 59 (prime)
DH_G = 5

CORE_DIR   = os.path.dirname(os.path.abspath(__file__))
CACHE_FILE = os.path.join(CORE_DIR, "session_cache.json")
KEY_FILE   = os.path.join(CORE_DIR, "des_key.bin")

ERROR_CODES = {
    "0":    "تمت العملية بنجاح (Success)",
    "1":    "فشل التحقق أو المعامل غير صالح",
    "2":    "المبنى غير مؤهل أو المستوى غير كافٍ للعملية",
    "7":    "البيانات غير متوفرة أو المعامل غير صحيح",
    "4001": "رتبة الجندي غير مفتوحة أو مستوى الثكنة غير كافٍ",
    "4002": "الثكنة مشغولة حالياً بعملية تدريب جارية (Barracks Busy)",
    "4003": "نقص في كمية الموارد المطلوبة للتدريب",
    "4004": "تجاوز السعة القصوى لخيام الجيش",
    "4008": "عملية التدريب قيد التنفيذ ولم تكتمل بعد للاستلام",
}

SEAL_TYPES = {
    "0":  "حظر عام (Default Seal)",
    "1":  "حظر بسبب بيع أو نقل موارد (Sell Resource)",
    "2":  "حظر بسبب فتح حسابات متعددة غير مسموحة (Too Many Accounts)",
    "3":  "حظر بسبب مخالفة الدردشة أو الشتائم (Curse/Chat Violation)",
    "5":  "حظر تجميد الحساب من إدارة اللعبة (Account Suspended / Sealed)",
    "99": "حظر بصمة الجهاز (Device Signature Blocked)",
}

# ═════════════════════════════════════════════════════════════════════════════
# خريطة الأوامر والطلبات الشبكية الرسمية (CMD & SubCMD Metadata Map)
# مع الإيموجي والوصف الدقيق والموجز جداً لظهورها الشفاف في التيرمنال
# ═════════════════════════════════════════════════════════════════════════════

CMD_METADATA_MAP: Dict[Tuple[str, str], Tuple[str, str]] = {
    # ── 1. التهيئة والمزامنة (Init & Sync) ──
    ("1000", "1"): ("🌐", "تهيئة اللعبة"),
    ("1000", "2"): ("🔄", "مزامنة الحساب"),
    ("1007", "1000"): ("🏇", "مزامنة الفيالق"),
    ("1007", "2"): ("🏇", "إرسال مسير"),
    ("1007", "1"): ("🏇", "إرسال مسير"),
    ("1008", "1"): ("🗺️", "خريطة العالم"),

    # ── 2. الموارد والمدينة والبناء (City & Resources) ──
    ("1001", "8"): ("🌾", "حصد الموارد"),
    ("1001", "2"): ("🏗️", "تشييد مبنى"),
    ("1001", "3"): ("🔨", "ترقية مبنى"),
    ("1003", "1"): ("⏳", "استعلام الطوابير"),
    ("1003", "2"): ("⏩", "تسريع طابور"),
    ("1003", "4"): ("⏩", "تسريع بناء"),
    ("1003", "8"): ("🔨", "إتمام بناء مجاني"),
    ("1004", "1"): ("🌾", "استعلام الموارد"),
    ("1004", "2"): ("📦", "استخدام عنصر"),

    # ── 3. الجيش والقتال والمستشفى (Army & Hospital) ──
    ("1005", "2"): ("⚔️", "تدريب الجنود"),
    ("1005", "5"): ("🎖️", "استلام الجنود"),
    ("1005", "4"): ("🏥", "علاج الجرحى"),
    ("1012", "1"): ("⚔️", "تدريب الجنود"),
    ("1012", "2"): ("🎖️", "استلام الجنود"),
    ("1012", "4"): ("⏩", "تسريع التدريب"),
    ("1014", "1"): ("🏥", "علاج الجرحى"),

    # ── 4. التحالف والعلوم والمساعدات (Alliance & Science) ──
    ("1010", "1"): ("🤝", "بيانات التحالف"),
    ("1010", "6"): ("🤝", "أعضاء التحالف"),
    ("1010", "44"): ("🤝", "مساعدة التحالف"),
    ("1010", "45"): ("🤝", "طلب مساعدة التحالف"),
    ("1010", "47"): ("🤝", "مساعدة الكل"),
    ("1010", "48"): ("🔬", "تبرع علوم التحالف"),
    ("1010", "49"): ("🔬", "بحث علوم التحالف"),
    ("1010", "51"): ("🏆", "ترتيب متبرعي التحالف"),
    ("2015", "1"): ("💎", "استعلام كنز التحالف"),
    ("2015", "3"): ("⛏️", "حفر كنز التحالف"),
    ("2015", "4"): ("🤝", "طلب مساعدة كنز التحالف"),
    ("2015", "5"): ("🤝", "مساعدة كنز عضو التحالف"),
    ("2015", "6"): ("🎁", "استلام كنز التحالف"),

    # ── 5. الأبحاث والأكاديمية (Academy Research) ──
    ("1011", "1"): ("🔬", "بحث الأكاديمية"),
    ("1011", "4"): ("⏩", "تسريع البحث"),
    ("1017", "2"): ("🔬", "بحث الأكاديمية"),

    # ── 6. الميناء وسفينة التجار والعجلة (Port, Ship, Wheel) ──
    ("1033", "2"): ("⚓", "استلام الميناء"),
    ("1032", "2"): ("🚢", "تبادل سفينة التجار"),
    ("1018", "2"): ("🎰", "تدوير عجلة الحظ"),
    ("1021", "2"): ("🎰", "تدوير عجلة الحظ"),

    # ── 7. المتجر والدروع والطاقة (Shop, Shield, Stamina) ──
    ("1034", "2"): ("🪙", "شراء من المتجر"),
    ("1002", "1"): ("🛡️", "درع السلام"),

    # ── 8. مهارات اللورد ودمج الأبطال (Lord Skills & Combo) ──
    ("1002", "20"): ("⚡", "ترقية مهارة اللورد"),
    ("1002", "21"): ("⚡", "إعادة تعيين مهارات اللورد"),
    ("1002", "22"): ("⚡", "استخدام مهارة اللورد"),
    ("1002", "23"): ("🔄", "تبديل طقم المهارات"),
    ("1002", "24"): ("🏷️", "تسمية طقم المهارات"),
    ("2235", "1"): ("🌟", "استعلام دمج الأبطال"),
    ("2235", "2"): ("🌟", "تفعيل دمج الأبطال"),

    # ── 9. الحدادة والورش والعتاد (Forge & Workshop) ──
    ("1047", "1"): ("🔨", "ورشة الحدادة"),
    ("1047", "2"): ("🔨", "تصنيع عتاد"),
    ("1047", "3"): ("💎", "دمج المواد"),
    ("1047", "10"): ("💎", "دمج المواد"),
    ("2021", "1"): ("🧵", "ورشة المواد"),
    ("2021", "2"): ("🧵", "جمع مواد الورشة"),
    ("2021", "4"): ("🧵", "استلام مواد الورشة"),

    # ── 10. محاكمة الأبطال والضريح والحلبة (Trials, Mausoleum, Arena) ──
    ("1059", "1"): ("🗡️", "محاكمة الأبطال"),
    ("1059", "2"): ("🗡️", "غارة محاكمة الأبطال"),
    ("1059", "3"): ("🗡️", "فتح محاكمة الأبطال"),
    ("1059", "4"): ("🗡️", "بدء محاكمة الأبطال"),
    ("1045", "1"): ("🏛️", "استعلام الضريح"),
    ("1045", "3"): ("🎲", "رمي نرد الضريح"),
    ("1045", "5"): ("🎁", "جوائز الضريح"),
    ("2056", "1"): ("🏟️", "استعلام الحلبة"),
    ("2056", "2"): ("🏟️", "تحدي الحلبة"),
    ("2056", "4"): ("🏟️", "تحدي الحلبة"),
    ("2056", "5"): ("🔄", "تجديد خصوم الحلبة"),
    ("2056", "6"): ("🏆", "جوائز الحلبة"),

    # ── 11. قاعة القيادة (Command Hall) ──
    ("2274", "1"): ("🏛️", "استعلام قاعة القيادة"),
    ("2274", "2"): ("⬆️", "ترقية قاعة القيادة"),
    ("2274", "3"): ("⚡", "ترقية قوة القيادة"),
    ("2274", "5"): ("📜", "إنجاز مهمة القيادة"),
    ("2274", "6"): ("🛡️", "تعيين دفاع القيادة"),
    ("2274", "7"): ("⚔️", "هجوم فيلق القيادة"),
    ("2274", "8"): ("🎁", "استلام جوائز مهمة القيادة"),
    ("2274", "9"): ("🗺️", "تحديث موقع هدف القيادة"),
    ("2274", "10"): ("🗺️", "مزامنة موقع هدف القيادة"),

    # ── 12. المهام اليومية والوحش الأليف والزهور والوسام وتاجر العجائب ──
    ("2027", "1"): ("📋", "المهام اليومية"),
    ("2027", "2"): ("🎁", "صندوق المهام اليومية"),
    ("2027", "4"): ("📋", "استلام المهمة اليومية"),
    ("2027", "5"): ("🎁", "صندوق المهام اليومية"),
    ("2036", "1"): ("🦅", "استعلام الوحش الأليف"),
    ("2036", "2"): ("🦅", "مداعبة الوحش الأليف"),
    ("2036", "4"): ("🦅", "مكافأة الوحش الأليف"),
    ("1024", "2"): ("👳", "شراء تاجر العجائب"),
    ("1024", "3"): ("👳", "استعلام تاجر العجائب"),
    ("1029", "2"): ("🌸", "إرسال زهور"),
    ("2030", "10"): ("🌸", "بستان الزهور"),
    ("1067", "2"): ("🎖️", "ترقية ميدالية الحرب"),
    ("1040", "1"): ("👑", "استعلام VIP"),
    ("1040", "2"): ("👑", "استلام نقاط VIP"),
    ("1001", "10"): ("📦", "فحص سقف استلام الموارد"),
}

CMD_MODULE_MAP: Dict[str, Tuple[str, str]] = {
    "1000": ("🌐", "تهيئة اللعبة"),
    "1001": ("🏰", "مباني المدينة"),
    "1002": ("⚡", "شؤون اللورد"),
    "1003": ("🏰", "طابور البناء"),
    "1004": ("🌾", "الموارد والحقيبة"),
    "1005": ("⚔️", "الثكنات والجيش"),
    "1007": ("🏇", "طوابير المسير"),
    "1008": ("🗺️", "خريطة العالم"),
    "1010": ("🤝", "شؤون التحالف"),
    "1011": ("🔬", "الأكاديمية والبحوث"),
    "1012": ("⚔️", "تدريب الجنود"),
    "1014": ("🏥", "مشفى القلعة"),
    "1015": ("🎒", "حقيبة العناصر"),
    "1017": ("🔬", "أبحاث الأكاديمية"),
    "1018": ("🎰", "عجلة الحظ"),
    "1020": ("🚢", "سفينة التجار"),
    "1021": ("🎰", "عجلة الحظ"),
    "1024": ("👳", "تاجر العجائب"),
    "1029": ("🌸", "إرسال زهور"),
    "1032": ("🚢", "سفينة التجار"),
    "1033": ("⚓", "مكافأة الميناء"),
    "1034": ("🪙", "المتجر والدروع"),
    "1040": ("👑", "امتيازات VIP"),
    "1045": ("🏛️", "الضريح الإمبراطوري"),
    "1047": ("🔨", "ورشة الحدادة"),
    "1059": ("🗡️", "محاكمة الأبطال"),
    "1067": ("🎖️", "ميدالية الحرب"),
    "2015": ("💎", "كنز التحالف"),
    "2021": ("🧵", "ورشة المواد"),
    "2027": ("📋", "المهام اليومية"),
    "2030": ("🌸", "بستان الزهور"),
    "2036": ("🦅", "الوحش الأليف"),
    "2056": ("🏟️", "حلبة الفرسان"),
    "2235": ("🌟", "دمج الأبطال"),
    "2274": ("🏛️", "قاعة القيادة"),
}


def get_cmd_metadata(cmd: str, subcmd: str, data: Optional[dict] = None) -> Tuple[str, str]:
    """
    استخراج الإيموجي المعبر والوصف العربي الموجز جداً لأي طلب يرسل عبر البوت.
    """
    c_str = str(cmd).strip()
    s_str = str(subcmd).strip()

    if isinstance(data, dict):
        if c_str == "1034" and s_str == "2":
            shop_id = str(data.get("shopItemID", ""))
            if shop_id == "1000046":
                return ("⚡", "شراء طاقة بالذهب")
            if any(k in shop_id for k in ("100001", "100002", "100003")):
                return ("🛡️", "شراء درع بالذهب")
            return ("🪙", "شراء من المتجر")
        elif c_str == "1004" and s_str == "2":
            item_id = str(data.get("itemID", ""))
            if any(item_id.startswith(p) for p in ("1002", "1003", "1004", "1005", "1006", "1027", "1100", "1101", "1102", "1103", "1106")):
                return ("🌾", "فتح صناديق موارد")
            if item_id in ("200001", "200002", "200003", "200004", "200005", "300401", "300402", "300403"):
                return ("⚡", "استخدام حزم الطاقة")
            if item_id in ("100001", "100002", "100003"):
                return ("🛡️", "تفعيل درع السلام")
            return ("📦", "استخدام عنصر")
        elif c_str == "1001" and s_str == "8":
            return ("🌾", "حصد الموارد")
        elif c_str == "1001" and s_str == "2":
            return ("🏗️", "تشييد مبنى")
        elif c_str == "1001" and s_str == "3":
            return ("🔨", "ترقية مبنى")
        elif c_str == "1003" and s_str == "2":
            if str(data.get("mode", "")) == "0":
                return ("⚡", "تسريع مجاني")
            return ("⏩", "تسريع طابور بالأدوات")
        elif c_str == "1005" and s_str == "2":
            return ("⚔️", "تدريب الجنود")
        elif c_str == "1005" and s_str == "4":
            return ("🏥", "علاج الجرحى")
        elif c_str == "1005" and s_str == "5":
            return ("🎖️", "استلام الجنود")
        elif c_str == "1010" and s_str == "48":
            return ("🔬", "تبرع علوم التحالف")
        elif c_str == "2015" and s_str == "6":
            return ("🎁", "استلام كنز التحالف")

    if (c_str, s_str) in CMD_METADATA_MAP:
        return CMD_METADATA_MAP[(c_str, s_str)]
    if c_str in CMD_MODULE_MAP:
        return CMD_MODULE_MAP[c_str]
    return ("📡", "أمر سيرفر")


def is_query_success(res: Any) -> Tuple[bool, Optional[str]]:
    """
    فحص نجاح استجابة السيرفر:
    يعتبر ناجحاً إذا كان قاموساً ولم يحتوي على كود خطأ (err / code) يخالف الصفر.
    """
    if not isinstance(res, dict):
        return False, "timeout"
    if res.get("_ok") is False:
        return False, "packet_err"
    err = res.get("err")
    if err is None:
        err = res.get("code")
    if err is None:
        inner_d = res.get("data")
        if isinstance(inner_d, dict):
            err = inner_d.get("err")
            if err is None:
                err = inner_d.get("code")
    if err is None:
        return True, None
    err_str = str(err).strip()
    if err_str in ("0", "Err_None", "None"):
        return True, None
    return False, err_str



def build_platform_string(
    device_id: str,
    sys_platform: str = SYSTEM_PLATFORM,
    sys_version: str = DEFAULT_OS_VER,
    store: str = STORE,
    package_name: str = PACKAGE_NAME,
    language: str = LANGUAGE
) -> str:
    """
    مطابق لبناء متغير plateform في دالة login:S2C_HANDSHAKE داخل login.lua:
    local plateform = systemPlatform .. " " .. systemVersion .. " " .. deviceId .. " " .. store .. " " .. packageName .. " " .. device.language
    """
    sys_platform = str(sys_platform) if sys_platform else "NONE"
    sys_version  = str(sys_version) if sys_version else "NONE"
    device_id    = str(device_id) if device_id else "NONE"
    return f"{sys_platform} {sys_version} {device_id} {store} {package_name} {language}"


def get_default_device_id(email: str) -> str:
    """توليد معرف جهاز ثابت وموحد لكل حساب لضمان تطابق البصمة بين الـ SDK وخادم الدخول"""
    return hashlib.md5(f"onemt_{email}".encode('utf-8')).hexdigest()


def get_account_device_profile(email: str) -> Dict[str, str]:
    """توليد بصمة جوال حقيقية وثابتة لكل إيميل"""
    clean_email = (email or "default").lower().strip()
    hash_bytes = hashlib.md5(f"onemt_profile_{clean_email}".encode('utf-8')).digest()
    idx = int.from_bytes(hash_bytes[:4], 'little') % len(REAL_DEVICES)
    model, os_ver = REAL_DEVICES[idx]
    dev_id = get_default_device_id(email or "default")
    return {
        "deviceId": dev_id,
        "model": model,
        "osVersion": os_ver,
        "carrier": DEFAULT_CARRIER,
        "platform": build_platform_string(device_id=dev_id, sys_version=os_ver),
    }


# ═════════════════════════════════════════════════════════════════════════════
# 2. خوارزميات التشفير المعتمدة (Cryptographic Primitives)
# ═════════════════════════════════════════════════════════════════════════════

def encrypt_sdk_pwd(pwd: str) -> str:
    """تشفير كلمة المرور المزدوج بخوارزمية MD5 الخاصة بشركة ONEMT SDK"""
    inner = hashlib.md5(f"gqY6DBt{pwd}Oed76U0".encode('utf-8')).hexdigest()
    return hashlib.md5(inner.encode('utf-8')).hexdigest()

def dh_exchange(priv_key_bytes: bytes) -> bytes:
    """حساب المفتاح العام الصادر = pow(G, priv, P) بتنسيق Little-Endian"""
    priv_int = int.from_bytes(priv_key_bytes, 'little')
    return pow(DH_G, priv_int, DH_P).to_bytes(8, 'little')

def dh_secret(server_pub_bytes: bytes, priv_key_bytes: bytes) -> bytes:
    """حساب المفتاح المشترك السري = pow(server_pub, priv, P) بتنسيق Little-Endian"""
    server_pub_int = int.from_bytes(server_pub_bytes, 'little')
    priv_int       = int.from_bytes(priv_key_bytes, 'little')
    if server_pub_int >= DH_P:
        server_pub_int -= DH_P
    return pow(server_pub_int, priv_int, DH_P).to_bytes(8, 'little')

def random_key() -> bytes:
    return os.urandom(8)

def _md5_compress_no_add(block64: bytes):
    """جولة ضغط MD5 واحدة بدون إضافة القيم الابتدائية (مستخرجة من libcocos2dlua)"""
    K = [
        0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
        0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
        0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
        0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
        0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
        0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
        0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
        0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
        0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
        0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
        0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
        0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
        0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
        0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
        0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
        0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    ]
    S = [
        7,12,17,22, 7,12,17,22, 7,12,17,22, 7,12,17,22,
        5, 9,14,20, 5, 9,14,20, 5, 9,14,20, 5, 9,14,20,
        4,11,16,23, 4,11,16,23, 4,11,16,23, 4,11,16,23,
        6,10,15,21, 6,10,15,21, 6,10,15,21, 6,10,15,21,
    ]
    M = struct.unpack('<16I', block64)
    A, B, C, D = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476
    for i in range(64):
        if i < 16:   F = (B & C) | (~B & D); g = i
        elif i < 32: F = (D & B) | (~D & C); g = (5*i+1) % 16
        elif i < 48: F = B ^ C ^ D;           g = (3*i+5) % 16
        else:        F = C ^ (B | ~D);         g = (7*i) % 16
        F = (F + A + K[i] + M[g]) & 0xFFFFFFFF
        A = D; D = C; C = B
        rs = S[i]
        B = (B + ((F << rs) | (F >> (32-rs)))) & 0xFFFFFFFF
    return A, B, C, D

def hmac64(challenge: bytes, secret: bytes) -> bytes:
    """Custom HMAC64 المستخدم في مصادقة خادم الدخول والبوابة"""
    ch_lo, ch_hi   = struct.unpack('<2I', challenge)
    sec_lo, sec_hi = struct.unpack('<2I', secret)
    pattern = struct.pack('<4I', ch_hi, ch_lo, sec_hi, sec_lo)
    A, B, C, D = _md5_compress_no_add(pattern * 4)
    return struct.pack('<2I', (C ^ D) & 0xFFFFFFFF, (B ^ A) & 0xFFFFFFFF)

def skynet_hashkey(data: bytes) -> bytes:
    djb_hash = 5381
    js_hash  = 1315423911
    for b in data:
        djb_hash = (djb_hash + (djb_hash << 5) + b) & 0xFFFFFFFF
        js_hash  = (js_hash ^ ((js_hash << 5) + b + (js_hash >> 2))) & 0xFFFFFFFF
    return struct.pack('<2I', djb_hash, js_hash)

def skynet_des_encode(data: bytes, key: bytes) -> bytes:
    """تشفير DES-ECB بحشوة ISO 7816-4 المطلوبة لسيرفرات اللعبة"""
    textsz = len(data)
    chunksz = (textsz + 8) & ~7
    padded = bytearray(chunksz)
    padded[:textsz] = data
    padded[textsz] = 0x80
    cipher = DES.new(key[:8], DES.MODE_ECB)
    return cipher.encrypt(bytes(padded))

def skynet_des_decode(data: bytes, key: bytes) -> bytes:
    cipher = DES.new(key[:8], DES.MODE_ECB)
    dec = cipher.decrypt(data)
    idx = dec.rfind(b'\x80')
    if idx != -1: return dec[:idx]
    return dec

def encode_token(token: dict) -> str:
    """
    مطابق لدالة encodetoken(token) في login.lua:
    string.format("%s@%s:%s", crypt.base64encode(token.user), crypt.base64encode(token.pass), crypt.base64encode(token.subtoken))
    """
    user_b64 = base64.b64encode(str(token.get("user", DEFAULT_TOKEN_USER)).encode('utf-8')).decode('utf-8')
    pass_b64 = base64.b64encode(str(token.get("pass", DEFAULT_TOKEN_PASS)).encode('utf-8')).decode('utf-8')
    sub_b64  = base64.b64encode(str(token.get("subtoken", "")).encode('utf-8')).decode('utf-8')
    return f"{user_b64}@{pass_b64}:{sub_b64}"

def xor_crypt(data: bytes) -> bytes:
    """تشفير وفك تشفير XOR بالمفتاح الثابت المعتمد في اللعبة الرسمية (gate.lua)"""
    key = XOR_KEY.encode('latin1')
    return bytes(b ^ key[i % len(key)] for i, b in enumerate(data))

def pack_gate_request(cmd: str, subcmd: str = "2", data: dict = None, session: int = 1, secret: bytes = None, client_data: list = None) -> bytes:
    """
    تغليف طلب البوابة بتنسيق البروتوكول الرسمي للعبة انتقام السلاطين:
    [2-byte/5-byte Length (Big-Endian)] + [DES-Base64 Encrypted JSON Body] + [4-byte Session ID (Big-Endian)]
    """
    cmd_str = str(cmd)
    msg = {"cmd": cmd_str, "subcmd": str(subcmd), "data": data if data is not None else {}}
    if client_data is not None:
        msg["clientData"] = client_data
    raw_json = json.dumps(msg, ensure_ascii=False, separators=(',', ':')).encode('utf-8')
    if secret:
        enc = skynet_des_encode(raw_json, secret)
        body_bytes = base64.b64encode(enc)
    else:
        body_bytes = raw_json
    sz = len(body_bytes) + 4
    if sz >= 0xFFFF:
        hdr = struct.pack('>BBI', 0xFF, 0xFF, sz)
    else:
        hdr = struct.pack('>H', sz)
    return hdr + body_bytes + struct.pack('>I', session)

def unpack_stream(buf: bytes):
    """تفريغ تدفق حزم TCP بناءً على طول الرأس (Big-Endian)"""
    pkts = []
    while len(buf) >= 2:
        s = buf[0] * 256 + buf[1]
        head = 2
        if s == 0xFFFF:
            if len(buf) < 5: break
            s = buf[2] * 65536 + buf[3] * 256 + buf[4]
            head = 5
        if len(buf) < head + s: break
        pkts.append(buf[head:head+s])
        buf = buf[head+s:]
    return pkts, buf

def try_decompress(raw: bytes) -> bytes:
    import zlib
    for w in (-15, 15, 31, 47, 32):
        try:
            return zlib.decompress(raw, w)
        except Exception:
            pass
    return raw

def decode_gate_packet(frame: bytes, secret: bytes = None) -> Optional[dict]:
    """
    فك محتوى حزمة الرد الواردة من السيرفر (بروتوكول انتقام السلاطين الرسمي: JSON صريح أو ZLIB مضغوط أو DES-ECB)
    مع دعم كامل لـ session 0 والنبضات والإشعارات والتحقق العكسي.
    """
    if not frame:
        return None

    import zlib

    session = 0
    ok = True
    raw = frame

    if len(frame) >= 5:
        ok_code = frame[-5]
        session = struct.unpack('>I', frame[-4:])[0]
        raw = frame[:-5]
        ok = (ok_code != 0)
    elif len(frame) >= 4:
        session = struct.unpack('>I', frame[-4:])[0]
        raw = frame[:-4]

    for w in (15, -15, 31, 47, 32):
        try:
            inflated = zlib.decompress(raw, w)
            s_idx = inflated.find(b'{')
            e_idx = inflated.rfind(b'}')
            if s_idx != -1 and e_idx != -1:
                parsed = json.loads(inflated[s_idx:e_idx+1].decode('utf-8', errors='replace'))
                if isinstance(parsed, dict):
                    parsed['_session'] = session
                    parsed['_ok'] = ok
                    return parsed
        except Exception:
            pass

    s_idx = raw.find(b'{')
    e_idx = raw.rfind(b'}')
    if s_idx != -1 and e_idx != -1:
        try:
            parsed = json.loads(raw[s_idx:e_idx+1].decode('utf-8', errors='replace'))
            if isinstance(parsed, dict):
                parsed['_session'] = session
                parsed['_ok'] = ok
                inner_data = parsed.get('data')
                if secret and isinstance(inner_data, str) and inner_data:
                    try:
                        raw_ct = base64.b64decode(inner_data)
                        pt = skynet_des_decode(raw_ct, secret)
                        si = pt.find(b'{')
                        ei = pt.rfind(b'}')
                        if si != -1 and ei != -1:
                            parsed['data'] = json.loads(pt[si:ei+1].decode('utf-8', errors='replace'))
                    except Exception:
                        pass
                return parsed
        except Exception:
            pass

    if secret:
        try:
            raw_ct = base64.b64decode(raw)
            pt = skynet_des_decode(raw_ct, secret)
            for cand in (pt, try_decompress(pt)):
                s_idx = cand.find(b'{')
                e_idx = cand.rfind(b'}')
                if s_idx != -1 and e_idx != -1:
                    d = json.loads(cand[s_idx:e_idx+1].decode('utf-8', errors='replace'))
                    if isinstance(d, dict):
                        d['_session'] = session
                        d['_ok'] = ok
                        return d
        except Exception:
            pass

    try:
        de_xor = xor_crypt(raw)
        for cand in (de_xor, try_decompress(de_xor)):
            s_idx = cand.find(b'{')
            e_idx = cand.rfind(b'}')
            if s_idx != -1 and e_idx != -1:
                parsed = json.loads(cand[s_idx:e_idx+1].decode('utf-8', errors='replace'))
                if isinstance(parsed, dict):
                    cmd = str(parsed.get('cmd', ''))
                    if cmd.startswith(CMD_PREFIX):
                        parsed['cmd'] = cmd[len(CMD_PREFIX):]
                    parsed['_session'] = session
                    parsed['_ok'] = ok
                    return parsed
    except Exception:
        pass

    return None

# ═════════════════════════════════════════════════════════════════════════════
# 3. إدارة التوثيق السحابي والجلسات (Cloud Auth & Session Cache)
# ═════════════════════════════════════════════════════════════════════════════

def sdk_login(email: str, password: str, device_id: str = None, proxy_url: str = None) -> dict:
    """
    تسجيل الدخول السحابي المباشر عبر بروتوكول ONEMT الرسمي بواسطة الإيميل وكلمة المرور
    مع توحيد معرف الجهاز مع بصمة الحساب الخاصة.
    """
    if not device_id:
        device_id = get_default_device_id(email)

    pwd_hash = encrypt_sdk_pwd(password)
    reqdata_obj = {
        "name": email,
        "password": pwd_hash,
        "identifytype": "email"
    }
    reqdata_json = json.dumps(reqdata_obj, separators=(',', ':'), ensure_ascii=False)
    reqdata_encoded = urllib.parse.quote(reqdata_json, safe='')

    ts = str(int(time.time()))
    body_map = {
        "platform": SYSTEM_PLATFORM,
        "appid": AUTH_APP_ID,
        "timestamp": ts,
        "packagename": PACKAGE_NAME,
        "lang": LANGUAGE,
        "sdid": "",
        "channel": "googleplay",
        "rstatus": "0",
        "clientversion": "5.33.0",
        "sessionid": "",
        "originalid": "",
        "deviceid": device_id,
        "reqdata": reqdata_encoded,
        "securemode": "MD5"
    }

    sorted_map = {k: body_map[k] for k in sorted(body_map.keys())}
    json_to_sign = json.dumps(sorted_map, separators=(',', ':'), ensure_ascii=False)
    sign_str = json_to_sign + AUTH_APP_KEY_STR + AUTH_APP_SIGN_MD5
    sorted_map["sign"] = hashlib.md5(sign_str.encode('utf-8')).hexdigest()

    final_json = json.dumps(sorted_map, separators=(',', ':'), ensure_ascii=False).encode('utf-8')
    headers = {
        "Content-Type": "application/json;charset=UTF-8",
        "appid": AUTH_APP_ID,
        "User-Agent": "okhttp/3.14.9"
    }

    try:
        req = urllib.request.Request(AUTH_API_URL, data=final_json, headers=headers)
        opener = urllib.request.build_opener()
        if proxy_url:
            opener.add_handler(urllib.request.ProxyHandler({'http': proxy_url, 'https': proxy_url}))

        with opener.open(req, timeout=15) as resp:
            data = json.loads(resp.read().decode('utf-8'))

        rtncode = str(data.get('rtncode', ''))
        if rtncode in ('0', '00000', 'SUCCESS', 0):
            rspdata = data.get('rspdata')
            if isinstance(rspdata, str) and rspdata:
                rspdata = json.loads(urllib.parse.unquote(rspdata))
            return {
                "success": True,
                "userId": rspdata.get('userid') or rspdata.get('userId'),
                "sessionId": rspdata.get('sessionid') or rspdata.get('sessionId'),
                "deviceId": device_id,
                "raw": data
            }
        else:
            err_msg = data.get('rtnmsg', 'Login failed')
            is_pwd_err = (
                'PASSWORD' in rtncode.upper()
                or 'EMAIL_NOT_EXISTS' in rtncode.upper()
                or 'BUSINESS_ACCOUNT_PASSWORD_LIMIT' in rtncode
                or 'كلمة' in err_msg
                or 'password' in err_msg.lower()
            )
            return {
                "success": False,
                "is_password_error": is_pwd_err,
                "error_code": rtncode,
                "error_msg": err_msg,
                "raw": data
            }
    except Exception as e:
        return {
            "success": False,
            "error_msg": f"خطأ أثناء الاتصال بسيرفر المصادقة السحابي: {e}",
            "raw": None
        }

class SessionCache:
    """مدير محلي نقي للجلسات وقراءة/كتابة session_cache.json مع حفظ بصمة جوال كل حساب"""
    @staticmethod
    def load_all() -> Dict[str, dict]:
        if not os.path.exists(CACHE_FILE):
            return {}
        try:
            with open(CACHE_FILE, "r", encoding="utf-8") as f:
                return json.load(f).get("accounts", {})
        except Exception:
            return {}

    @staticmethod
    def save(accounts: Dict[str, dict]):
        try:
            os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
            with open(CACHE_FILE, "w", encoding="utf-8") as f:
                json.dump({"accounts": accounts}, f, indent=2, ensure_ascii=False)
        except Exception as e:
            log.error(f"فشل حفظ session_cache.json: {e}")

    @classmethod
    def get_account(cls, email: Optional[str] = None) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        accs = cls.load_all()
        if not accs:
            return None, None, None

        if email:
            if email in accs:
                return accs[email].get('userId'), accs[email].get('sessionId'), email
            for k in accs:
                if email.lower() in k.lower():
                    return accs[k].get('userId'), accs[k].get('sessionId'), k
            return None, None, None

        first_key = list(accs.keys())[0]
        return accs[first_key].get('userId'), accs[first_key].get('sessionId'), first_key

    @classmethod
    def set_account(
        cls,
        email: str,
        user_id: str,
        session_id: str,
        device_id: Optional[str] = None,
        model: Optional[str] = None,
        os_version: Optional[str] = None
    ):
        accs = cls.load_all()
        prof = get_account_device_profile(email)
        old_entry = accs.get(email, {}) if isinstance(accs.get(email), dict) else {}

        entry = {
            "userId": user_id,
            "sessionId": session_id,
            "deviceId": device_id or old_entry.get("deviceId") or prof["deviceId"],
            "model": model or old_entry.get("model") or prof["model"],
            "osVersion": os_version or old_entry.get("osVersion") or prof["osVersion"],
            "timestamp": time.time(),
            "source": "sdk_passport"
        }
        accs[email] = entry
        cls.save(accs)

    @classmethod
    def sync_from_emulator(cls, serial: str = "emulator-5554") -> Dict[str, dict]:
        """مزامنة الجلسات الشرعية المسجلة داخل المحاكي وحفظها في session_cache.json"""
        try:
            import subprocess
            cmd = f"adb -s {serial} shell \"su 0 cat /data/data/and.onemt.war.ar/shared_prefs/SdkEmail.xml\""
            res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if res.returncode != 0 or not res.stdout.strip():
                return cls.load_all()
            import xml.etree.ElementTree as ET
            root = ET.fromstring(res.stdout)
            accs = cls.load_all()
            count = 0
            for s in root.findall('string'):
                name = s.get('name', '')
                val = s.text or ''
                if '@' in name and 'OneMT' in val:
                    parts = val.split('OneMT', 1)
                    prof = get_account_device_profile(name)
                    old_d = accs.get(name, {}) if isinstance(accs.get(name), dict) else {}
                    accs[name] = {
                        "userId": parts[0],
                        "sessionId": parts[1],
                        "deviceId": old_d.get("deviceId") or prof["deviceId"],
                        "model": old_d.get("model") or prof["model"],
                        "osVersion": old_d.get("osVersion") or prof["osVersion"],
                        "timestamp": time.time(),
                        "source": "emulator_sync"
                    }
                    count += 1
            if count > 0:
                cls.save(accs)
                print(f"[+] تم مزامنة {count} حساب شرعي من المحاكي بنجاح تام إلى session_cache.json")
            return accs
        except Exception as e:
            log.warning(f"[SessionCache] تعذر المزامنة من المحاكي: {e}")
            return cls.load_all()

# ═════════════════════════════════════════════════════════════════════════════
# 4. هياكل البيانات (Data Models)
# ═════════════════════════════════════════════════════════════════════════════

@dataclass
class AccountSession:
    email:              str
    user_id:            str
    session_id:         str
    password:           Optional[str] = None
    is_sealed:          bool = False
    seal_reason:        str = ""
    is_password_error:  bool = False
    auth_error_msg:     str = ""

@dataclass
class GateCredentials:
    kingdom_id:        str = ""
    server_name:       str = ""
    gate_ip:           str = ""
    gate_port:         int = 0
    sub_id:            str = ""
    uid:               str = ""
    secret:            bytes = b""
    proxy_host:        str = ""
    proxy_port:        str = ""
    fallback_gate_ip:  str = ""
    fallback_gate_port: int = 0


class ConcurrentLoginError(Exception):
    """استثناء يطلق عند رصد تسجيل دخول للقلعة من جهاز آخر (404 User Not Found) لمنع طرد اللاعب الحقيقي"""
    pass

# ═════════════════════════════════════════════════════════════════════════════
# 5. العميل المتزامن المباشر (Synchronous Direct Client — RosClient)
#    مطابق 100% لملفي login.lua و loginCtrl.lua
# ═════════════════════════════════════════════════════════════════════════════

class RosClient:
    """
    عميل متزامن يتبع دورة حياة login.lua و loginCtrl.lua الرسمية:
      1. S2C_CHALLENGE
      2. S2C_SERVERKEY
      3. S2C_HANDSHAKE (مع بصمة الجوال المخصصة لكل حساب)
      4. S2C_AUTH_TOKEN (مع دعم gateProxyHost والاتصال الاحتياطي المباشر)
    """
    def __init__(
        self,
        user_id=None,
        session_id=None,
        email=None,
        password=None,
        device_profile: Optional[Dict[str, str]] = None,
        force_refresh: bool = False,
        proxy_url: Optional[str] = None,
        use_3rdid_user: bool = False
    ):
        self.password = password
        self.proxy_url = proxy_url
        self.use_3rdid_user = use_3rdid_user
        found_email = None
        from_cache = False

        # 1. استخدام الجلسة المخزنة مسبقاً إذا وُجدت
        if not force_refresh and email:
            c_uid, c_sid, found_email = SessionCache.get_account(email)
            if c_uid and c_sid:
                user_id = c_uid
                session_id = c_sid
                self.email = found_email or email
                from_cache = True
                log.info(f"[RosClient] تم استرجاع جلسة الحساب ({self.email}) من session_cache.json بنجاح.")

        self.email = found_email or email or "custom_session"
        prof = get_account_device_profile(self.email)

        # استرجاع بصمة الجوال المحفوظة في الكاش لهذا الحساب إن وجدت
        accs = SessionCache.load_all()
        if self.email in accs and isinstance(accs[self.email], dict):
            acc_entry = accs[self.email]
            prof["deviceId"]  = acc_entry.get("deviceId") or prof["deviceId"]
            prof["model"]     = acc_entry.get("model") or prof["model"]
            prof["osVersion"] = acc_entry.get("osVersion") or prof["osVersion"]
            prof["platform"]  = build_platform_string(device_id=prof["deviceId"], sys_version=prof["osVersion"])

        # 2. إذا لم تكن هناك جلسة مخزنة وتوفرت كلمة المرور، نقوم بالمصادقة السحابية
        if not user_id or not session_id:
            if email and password:
                print(f"[*] جاري تسجيل الدخول عبر خادم ONEMT SDK السحابي ({email} | الجوال: {prof['model']})...")
                auth_res = sdk_login(email, password, device_id=prof["deviceId"], proxy_url=self.proxy_url)
                if not auth_res["success"]:
                    if auth_res.get("is_password_error"):
                        self.is_password_error = True
                        self.error_msg = auth_res.get("error_msg", "كلمة المرور غير صحيحة")
                    raise ValueError(f"فشلت مصادقة الحساب: {auth_res.get('error_msg')} (كود: {auth_res.get('error_code')})")
                user_id = auth_res["userId"]
                session_id = auth_res["sessionId"]
                SessionCache.set_account(
                    email, user_id, session_id,
                    device_id=prof["deviceId"],
                    model=prof["model"],
                    os_version=prof["osVersion"]
                )
                self.email = email
            else:
                user_id, session_id, found_email = SessionCache.get_account(email)
                if not user_id or not session_id:
                    raise ValueError(
                        f"الحساب '{email or 'الافتراضي'}' غير مسجل في session_cache.json!\n"
                        "يرجى تسجيله لأول مرة بتمرير كلمة المرور: --email <email> --password <pass>"
                    )
                self.email = found_email

        self.user_id = str(user_id)
        self.session_id = str(session_id)
        self._from_cache = from_cache
        self.secret: Optional[bytes] = None
        self.gate_info: Dict[str, Any] = {}
        self.gate_sock: Optional[socket.socket] = None
        self.session_counter = 1
        self.buffer = b""

        # حالة الحساب (محظور / صيانة / خطأ مصادقة / خطأ كلمة مرور)
        self.is_password_error: bool = False
        self.is_sealed: bool = False
        self.seal_type: Optional[int] = None
        self.seal_reason: str = ""
        self.is_maintenance: bool = False
        self.is_version_error: bool = False
        self.is_account_deleted: bool = False
        self.is_auth_error: bool = False
        self.error_code: Optional[int] = None
        self.error_msg: str = ""

        if not device_profile:
            self.device_profile = prof
        else:
            self.device_profile = {
                "deviceId": device_profile.get("deviceId") or prof["deviceId"],
                "model": device_profile.get("model") or prof["model"],
                "osVersion": device_profile.get("osVersion") or prof["osVersion"],
                "carrier": device_profile.get("carrier") or DEFAULT_CARRIER,
                "platform": device_profile.get("platform") or build_platform_string(
                    device_id=device_profile.get("deviceId") or prof["deviceId"],
                    sys_version=device_profile.get("osVersion") or prof["osVersion"]
                )
            }

    def login(self, max_retries: int = 2) -> bool:
        """
        مصادقة خادم تسجيل الدخول وفق آلة الحالة الرسمية في login.lua و loginCtrl.lua:
        S2C_CHALLENGE -> S2C_SERVERKEY -> S2C_HANDSHAKE -> S2C_AUTH_TOKEN
        """
        if self.is_sealed:
            return False

        for attempt in range(1, max_retries + 1):
            s = None
            try:
                model_val    = self.device_profile.get("model", DEFAULT_MODEL)
                os_ver_val   = self.device_profile.get("osVersion", DEFAULT_OS_VER)
                device_id    = self.device_profile.get("deviceId", get_default_device_id(self.email))
                carrier_val  = self.device_profile.get("carrier", DEFAULT_CARRIER)
                platform_val = self.device_profile.get("platform") or build_platform_string(
                    device_id=device_id,
                    sys_version=os_ver_val
                )

                print(f"[*] الاتصال بخادم تسجيل الدخول {LOGIN_SERVER[0]}:{LOGIN_SERVER[1]} (محاولة {attempt}/{max_retries} | الجوال: {model_val})...")
                if self.proxy_url:
                    from python_socks.sync import Proxy
                    proxy = Proxy.from_url(self.proxy_url)
                    s = proxy.connect(dest_host=LOGIN_SERVER[0], dest_port=LOGIN_SERVER[1], timeout=15)
                else:
                    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    s.settimeout(15)
                    s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                    s.connect(LOGIN_SERVER)

                buf = b""

                def recv_line() -> str:
                    nonlocal buf
                    while b"\n" not in buf:
                        chunk = s.recv(4096)
                        if not chunk:
                            raise ConnectionError("تم إغلاق الاتصال من قِبل خادم تسجيل الدخول")
                        buf += chunk
                    idx = buf.index(b"\n")
                    line = buf[:idx].decode('utf-8', errors='replace').rstrip('\r')
                    buf = buf[idx + 1:]
                    return line

                def send_line(line_str: str):
                    s.sendall((line_str + "\n").encode('utf-8'))

                # ── 1. S2C_CHALLENGE ──────────────────────────────────────────
                ch_b64 = recv_line()
                challenge = base64.b64decode(ch_b64)
                priv_key = os.urandom(8)
                pub_key = dh_exchange(priv_key)
                send_line(base64.b64encode(pub_key).decode('utf-8'))

                # ── 2. S2C_SERVERKEY ──────────────────────────────────────────
                srv_key_b64 = recv_line()
                server_key = base64.b64decode(srv_key_b64)
                secret = dh_secret(server_key, priv_key)
                self.secret = secret

                mac = hmac64(challenge, secret)
                send_line(base64.b64encode(mac).decode('utf-8'))

                # ── 3. S2C_HANDSHAKE ──────────────────────────────────────────
                hs_resp = recv_line()
                hs_code = int(hs_resp[:3]) if hs_resp[:3].isdigit() else 0
                if hs_code == ERR_HANDSHAKE_FAILED or hs_code != 200:
                    print(f"[-] فشلت مصادقة Handshake الأولية: {hs_resp}")
                    s.close()
                    return False

                      # مطابق 100% للعميل الرسمي (loginCtrl.lua): token.user = "3rdid" دائما
                # إرسال userId الحقيقي يكشف البوت فوراً من السيرفر
                token_dict = {
                    "user": self.user_id,   # دائما "3rdid"
                    "pass": DEFAULT_TOKEN_PASS,   # دائما "password"
                    "subtoken": self.session_id   # sessionId فقط
                }
                token_str = encode_token(token_dict)

                b64token = base64.b64encode(skynet_des_encode(token_str.encode('utf-8'), secret)).decode('utf-8')
                b64ver   = base64.b64encode(skynet_des_encode((GAME_VERSION or "NONE").encode('utf-8'), secret)).decode('utf-8')
                b64plat  = base64.b64encode(skynet_des_encode((platform_val or "NONE").encode('utf-8'), secret)).decode('utf-8')
                b64model = base64.b64encode(skynet_des_encode((model_val or "NONE").encode('utf-8'), secret)).decode('utf-8')
                b64carr  = base64.b64encode(skynet_des_encode((carrier_val or "NONE").encode('utf-8'), secret)).decode('utf-8')

                msg = "@".join([b64token, b64ver, b64plat, b64model, b64carr])
                send_line(msg)

                # ── 4. S2C_AUTH_TOKEN ─────────────────────────────────────────
                auth_resp = recv_line()
                s.close()
                s = None

                code_str = auth_resp[:3]
                code = int(code_str) if code_str.isdigit() else 0
                self.error_code = code

                if code == ERR_AUTH_TOKEN_SUCCESS:
                    submsg = auth_resp[4:] if len(auth_resp) > 4 else ""
                    auth_data = base64.b64decode(submsg).decode('utf-8', errors='replace')
                    parts = auth_data.split("@")
                    fields = [
                        'kingdomId', 'servername', 'gateip', 'gateport',
                        'subid', 'uid', 'gateProxyHost', 'gateProxyPort'
                    ]
                    info = {}
                    for i, f in enumerate(fields):
                        raw_val = parts[i] if i < len(parts) else ""
                        if raw_val:
                            try:
                                info[f] = base64.b64decode(raw_val).decode('utf-8')
                            except Exception:
                                info[f] = raw_val
                        else:
                            info[f] = ""

                    # منطق loginCtrl:loginSuccess() لاختيار البروكسي أو البوابة المباشرة
                    proxy_host = info.get('gateProxyHost', '')
                    proxy_port = info.get('gateProxyPort', '')
                    direct_ip  = info.get('gateip', '')
                    direct_port = int(info.get('gateport', 0)) if str(info.get('gateport', '')).isdigit() else 0

                    if proxy_host and proxy_port and proxy_port != "0" and str(proxy_port).isdigit():
                        info['target_gate_ip']   = proxy_host
                        info['target_gate_port'] = int(proxy_port)
                    else:
                        info['target_gate_ip']   = direct_ip
                        info['target_gate_port'] = direct_port

                    info['fallback_gate_ip']   = direct_ip
                    info['fallback_gate_port'] = direct_port

                    self.gate_info = info
                    print(
                        f"[+] تم تسجيل الدخول بنجاح! المملكة: {info.get('kingdomId')} | "
                        f"UID: {info.get('uid')} | البوابة: {info.get('target_gate_ip')}:{info.get('target_gate_port')}"
                    )

                    try:
                        os.makedirs(os.path.dirname(KEY_FILE), exist_ok=True)
                        with open(KEY_FILE, "wb") as f:
                            f.write(secret)
                    except Exception:
                        pass

                    return True

                elif code == ERR_BE_SEALED or "502" in auth_resp or "Be Sealed" in auth_resp:
                    m_seal = re.search(r"(\d+)\s+(\d+)", auth_resp)
                    seal_code_str = m_seal.group(2) if m_seal else "0"
                    reason = SEAL_TYPES.get(seal_code_str, f"حظر حساب بكود ({seal_code_str})")
                    print(f"\n❌ [حساب محظور 502] تم حظر هذا الحساب من قِبل إدارة اللعبة!")
                    print(f"   • البريد:    {self.email}")
                    print(f"   • نوع الحظر: {reason} (الكود: {auth_resp})")
                    self.is_sealed = True
                    self.seal_type = int(seal_code_str) if seal_code_str.isdigit() else 0
                    self.seal_reason = reason
                    self.error_msg = reason
                    return False

                elif code == ERR_NOT_EXIST_SERVER:
                    self.is_maintenance = True
                    self.error_msg = f"السيرفر تحت الصيانة حالياً (501): {auth_resp}"
                    print(f"🛠️ [صيانة السيرفر 501] {self.error_msg}")
                    return False

                elif code == ERR_VERSION_ERROR:
                    self.is_version_error = True
                    self.error_msg = f"إصدار اللعبة ({GAME_VERSION}) غير متوافق (503)"
                    print(f"⚠️ [خطأ إصدار 503] {self.error_msg}")
                    return False

                elif code == ERR_NOT_ACCEPTABLE or "406" in auth_resp:
                    self.is_auth_error = True
                    self.error_msg = "الحساب قيد الدخول حالياً من جهاز آخر (406 multilogin)"
                    print(f"\n⚠️ [تعارض جلسات 406] {self.error_msg}\n")
                    return False

                elif code in (ERR_SDK_TOKEN_ERROR, ERR_UNAUTHORIZED, ERR_FORBIDDEN) or "504" in auth_resp or "401" in auth_resp:
                    arr = auth_resp.split(" ")
                    if len(arr) >= 5 and arr[4] == "BUSINESS_USER_DELETED":
                        self.is_account_deleted = True
                        self.is_auth_error = True
                        self.error_msg = "تم حذف هذا الحساب نهائياً (BUSINESS_USER_DELETED)"
                        print(f"\n❌ [حساب محذوف 504] {self.error_msg}\n")
                        return False

                    # تجديد التوكن تلقائياً إذا توفرت كلمة المرور
                    if self.password:
                        print(f"[*] الجلسة منتهية للحساب ({self.email})، جاري تجديد التوكن عبر ONEMT SDK بنفس بصمة الجوال...")
                        refresh_res = sdk_login(self.email, self.password, device_id=device_id, proxy_url=self.proxy_url)
                        if refresh_res.get("success"):
                            self.user_id = str(refresh_res["userId"])
                            self.session_id = str(refresh_res["sessionId"])
                            SessionCache.set_account(
                                self.email,
                                self.user_id,
                                self.session_id,
                                device_id=device_id,
                                model=model_val,
                                os_version=os_ver_val
                            )
                            self.password = None  # تجنب التكرار اللانهائي
                            if attempt < max_retries:
                                time.sleep(0.8)
                                continue
                        elif refresh_res.get("is_password_error"):
                            self.is_password_error = True
                            self.is_auth_error = True
                            self.error_msg = refresh_res.get("error_msg") or "كلمة المرور غير صحيحة"
                            print(f"\n🛑 [خطأ كلمة المرور] {self.error_msg}\n")
                            return False

                    self.is_auth_error = True
                    self.error_msg = f"تعذر التحقق من توكن الحساب ({self.email}): {auth_resp}"
                    print(f"\n❌ [خطأ توثيق] {self.error_msg}\n")
                    return False

                else:
                    self.error_msg = f"فشلت مصادقة الجلسة: {auth_resp}"
                    print(f"[-] {self.error_msg}")
                    if attempt < max_retries:
                        time.sleep(1.0)
                        continue
                    return False

            except (socket.timeout, ConnectionError, OSError) as e:
                if s:
                    try:
                        s.close()
                    except Exception:
                        pass
                if attempt < max_retries:
                    time.sleep(1.0)
                else:
                    self.error_msg = f"تعذر الاتصال بخادم تسجيل الدخول بعد {max_retries} محاولات: {e}"
                    print(f"[-] {self.error_msg}")
                    return False
        return False

    def _handshake_gate_socket(self, ip: str, port: int) -> Optional[socket.socket]:
        """فتح مقبس البوابة وإرسال مصافحة HMAC (مطابق لـ loginCtrl:gatePortSuccess)"""
        s = None
        try:
            print(f"[*] الاتصال بمقبس البوابة {ip}:{port}...")
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(15)
            s.connect((ip, port))
            s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)

            uid_b64 = base64.b64encode(self.gate_info['uid'].encode('utf-8')).decode('utf-8')
            srv_b64 = base64.b64encode(self.gate_info['servername'].encode('utf-8')).decode('utf-8')
            sub_b64 = base64.b64encode(self.gate_info['subid'].encode('utf-8')).decode('utf-8')
            username = f"{uid_b64}@{srv_b64}#{sub_b64}"

            index = 1
            key_mat = f"{username}:{index}".encode('utf-8')
            hash_key = skynet_hashkey(key_mat)
            hmac_val = base64.b64encode(hmac64(hash_key, self.secret)).decode('utf-8')

            payload = json.dumps({"username": username, "index": index, "hmac": hmac_val}, separators=(',', ':')).encode('utf-8')
            hs_pkt = bytes([(len(payload) >> 8) & 0xFF, len(payload) & 0xFF]) + payload
            s.sendall(hs_pkt)

            resp = s.recv(512)
            if b"200" not in resp:
                print(f"[-] فشلت مصافحة البوابة ({ip}:{port}): {resp!r}")
                s.close()
                return None

            return s
        except Exception as e:
            print(f"[-] تعذر الاتصال بالبوابة ({ip}:{port}): {e}")
            if s:
                try:
                    s.close()
                except Exception:
                    pass
            return None

    def connect_gate(self) -> bool:
        """
        الاتصال بالبوابة ومصافحتها عبر HMAC، مع دعم التبديل التلقائي (Fallback)
        من gateProxyHost إلى gateip المباشر تماماً كما في loginCtrl:gateConnected().
        """
        if self.is_sealed:
            return False

        if not self.gate_info or not self.secret:
            if not self.login(max_retries=2):
                return False

        target_ip   = self.gate_info.get('target_gate_ip') or self.gate_info.get('gateip')
        target_port = int(self.gate_info.get('target_gate_port') or self.gate_info.get('gateport') or 0)
        direct_ip   = self.gate_info.get('fallback_gate_ip') or self.gate_info.get('gateip')
        direct_port = int(self.gate_info.get('fallback_gate_port') or self.gate_info.get('gateport') or 0)

        s = self._handshake_gate_socket(target_ip, target_port)
        if not s and direct_ip and (direct_ip != target_ip or direct_port != target_port):
            print(f"[*] جاري التبديل التلقائي للبوابة المباشرة (Fallback): {direct_ip}:{direct_port}...")
            s = self._handshake_gate_socket(direct_ip, direct_port)

        if not s:
            return False

        print("[+] تم توثيق اتصال البوابة بنجاح (Gate Authenticated)!")
        self.gate_sock = s
        self.session_counter = 1
        self.buffer = b""
        return True

    def send_cmd(self, cmd: str, subcmd: str = "2", data: dict = None) -> int:
        if not self.gate_sock:
            raise ConnectionError("مقبس البوابة غير متصل")

        current_sess = self.session_counter
        self.session_counter += 1
        pkt = pack_gate_request(cmd, subcmd, data, session=current_sess, secret=self.secret)
        self.gate_sock.sendall(pkt)
        return current_sess

    def recv_responses(self, timeout: float = 6.0) -> List[dict]:
        if not self.gate_sock:
            return []
        self.gate_sock.settimeout(timeout)
        start_t = time.time()
        responses = []

        while time.time() - start_t < timeout:
            try:
                chunk = self.gate_sock.recv(4096)
                if not chunk:
                    break
                self.buffer += chunk
                pkts, self.buffer = unpack_stream(self.buffer)
                for pkt in pkts:
                    parsed = decode_gate_packet(pkt, self.secret)
                    if parsed:
                        responses.append(parsed)
                if responses:
                    break
            except socket.timeout:
                break
            except Exception:
                break
        return responses

    def execute_command(self, cmd: str, subcmd: str = "2", data: dict = None) -> List[dict]:
        if self.is_sealed:
            return []
        if not self.gate_sock:
            ok = self.connect_gate()
            if not ok:
                if self.is_sealed:
                    return []
                raise ConnectionError("تعذر فتح قناة الاتصال بسيرفر البوابة")
        sess_id = self.send_cmd(cmd, subcmd, data)
        print(f"[*] تم إرسال الطلب (cmd={cmd}, subcmd={subcmd}, session={sess_id})")
        return self.recv_responses(timeout=6.0)

    def close(self):
        if self.gate_sock:
            try:
                self.gate_sock.shutdown(socket.SHUT_RDWR)
            except Exception:
                pass
            try:
                self.gate_sock.close()
            except Exception:
                pass
            self.gate_sock = None

# ═════════════════════════════════════════════════════════════════════════════
# 6. المحرك غير المتزامن لإدارة الحسابات (Async Engine & Multi-Account)
# ═════════════════════════════════════════════════════════════════════════════

async def async_login(account: AccountSession) -> Optional[GateCredentials]:
    """المصادقة اللاتزامنية مع خادم تسجيل الدخول باستخدام البروتوكول الرسمي الجديد"""
    loop = asyncio.get_event_loop()

    def _sync_login():
        client = RosClient(
            user_id=account.user_id,
            session_id=account.session_id,
            email=account.email,
            password=account.password
        )
        ok = client.login(max_retries=2)
        if not ok or not client.gate_info:
            if client.is_sealed:
                account.is_sealed = True
                account.seal_reason = client.seal_reason
            if getattr(client, "is_password_error", False):
                account.is_password_error = True
                account.auth_error_msg = getattr(client, "error_msg", "كلمة المرور غير صحيحة")
            return None
        account.user_id = client.user_id
        account.session_id = client.session_id
        return GateCredentials(
            kingdom_id         = client.gate_info.get('kingdomId', ''),
            server_name        = client.gate_info.get('servername', ''),
            gate_ip            = client.gate_info.get('target_gate_ip') or client.gate_info.get('gateip', ''),
            gate_port          = int(client.gate_info.get('target_gate_port') or client.gate_info.get('gateport', 0)),
            sub_id             = client.gate_info.get('subid', ''),
            uid                = client.gate_info.get('uid', ''),
            secret             = client.secret,
            proxy_host         = client.gate_info.get('gateProxyHost', ''),
            proxy_port         = client.gate_info.get('gateProxyPort', ''),
            fallback_gate_ip   = client.gate_info.get('fallback_gate_ip') or client.gate_info.get('gateip', ''),
            fallback_gate_port = int(client.gate_info.get('fallback_gate_port') or client.gate_info.get('gateport', 0)),
        )

    try:
        return await loop.run_in_executor(None, _sync_login)
    except Exception as e:
        log.error(f"[AsyncLogin] {account.email}: {e}")
        return None

class GameConnection:
    """
    اتصال بوابة تفاعلي غير متزامن (Async Gate Client) مزود بـ Heartbeat
    وطابور استجابات غير متزامن وإدارة الذاكرة الحية (Live init_data).
    """
    def __init__(self, account: AccountSession, creds: GateCredentials):
        self.account = account
        self.creds = creds
        self._reader: Optional[asyncio.StreamReader] = None
        self._writer: Optional[asyncio.StreamWriter] = None
        self._session = 1
        self._alive = False
        self._pending: Dict[int, asyncio.Future] = {}
        self._recv_task: Optional[asyncio.Task] = None
        self._heartbeat_task: Optional[asyncio.Task] = None
        self._init_flow_task: Optional[asyncio.Task] = None
        self._buffer = b""

        owner_uid = getattr(self.account, "uid", None) or getattr(self.creds, "uid", None) or getattr(self.account, "user_id", None)
        self.memory_engine: LiveMemoryEngine = LiveMemoryEngine(owner_uid=owner_uid)
        self.init_data: Dict[str, Any] = self.memory_engine.init_data
        self.spy_mode: bool = False
        self.is_other_device: bool = False
        self.controllers_ready: asyncio.Event = asyncio.Event()
        self.notify_log_callback: Optional[Callable[[str], None]] = None
        self.brief_log_callback: Optional[Callable[[str], None]] = None
        self._seen_unhandled_notifies: Set[str] = set()
        # تعطيل طباعة إشعارات السوكت في التيرمنال مؤقتاً بناءً على رغبة المطور
        self.enable_notification_logging: bool = False

    @property
    def account_short_name(self) -> str:
        """اسم الحساب المختصر النظيف بدون نطاق الإيميل"""
        em = getattr(self.account, "email", "") or getattr(self.account, "user_id", "Bot")
        if "@" in str(em):
            return str(em).split("@")[0]
        return str(em)

    def emit_brief_log(self, line: str) -> None:
        """
        طباعة سطر الطلب الموجز في التيرمنال فوراً وتمريره لموجه السجلات إن وجد
        """
        print(line, flush=True)
        if hasattr(self, "brief_log_callback") and callable(self.brief_log_callback):
            try:
                self.brief_log_callback(line)
            except Exception:
                pass

    @property
    def local_queues(self) -> list:
        return self.memory_engine.get_own_local_queues()

    @local_queues.setter
    def local_queues(self, val: Any) -> None:
        if isinstance(val, list):
            self.memory_engine._sync_local_queues_from_list(val)

    @property
    def other_local_queues(self) -> list:
        return self.memory_engine.get_other_local_queues()

    @property
    def heroes(self) -> list:
        h = self.init_data.get("heroCtrl")
        if isinstance(h, list):
            return h
        if isinstance(h, dict) and isinstance(h.get("heroes"), list):
            return h["heroes"]
        return []

    @heroes.setter
    def heroes(self, val: Any) -> None:
        if isinstance(val, list):
            self.init_data["heroCtrl"] = val

    @property
    def is_connected(self) -> bool:
        return self._alive and self._writer is not None

    def _log_notification(self, report: Dict[str, Any]) -> None:
        """
        طباعة وتوثيق وصول الإشعارات اللحظية في التيرمنال مع فحص الدمج في الذاكرة الحية.
        (تم تعطيل الطباعة مؤقتاً لحذف إشعارات السوكت من التيرمنال بناءً على طلب المطور)
        """
        if not getattr(self, "enable_notification_logging", False):
            return

        if not report or not report.get("is_notification"):
            return

        from core.live_memory import ALLOWED_CONTROLLERS

        # 1. استخراج اسم ومعرف الإشعار
        notify_name = report.get("notify_id") or report.get("cmd") or "إشعار غير مسمى"

        # 2. استخراج المتحكمات المتأثرة وفحص هل تنتمي للمتحكمات المعتمدة (الـ 26)
        all_targets = list(dict.fromkeys(
            (report.get("notify_controllers") or []) +
            (report.get("merged_controllers") or []) +
            (report.get("updated_keys") or [])
        ))
        allowed_targets = [t for t in all_targets if t in ALLOWED_CONTROLLERS]

        log_fn = self.notify_log_callback or (lambda msg: log.info(f"[{getattr(self.account, 'email', 'Client')}] {msg}"))

        # حالة أ: الإشعار يخص متحكماً من المتحكمات المعتمدة
        if allowed_targets:
            ctrls_str = ", ".join(allowed_targets)
            new_val = report.get("new_value_summary") or "تم استلام وتحديث البيانات"
            is_ok = report.get("verify_success", False)
            v_status = "ناجح 100%" if is_ok else "فاشل"
            v_detail = report.get("verify_detail", "")
            v_icon = "✅" if is_ok else "❌"

            msg = (
                f"\n🔔 [إشعار وارد: {notify_name}]\n"
                f"   📦 المتحكم المتأثر: {ctrls_str}\n"
                f"   🔄 القيمة المستحدثة: {new_val}\n"
                f"   {v_icon} التحقق من الدمج في الذاكرة الحية: {v_status} ({v_detail})"
            )
            try:
                log_fn(msg)
            except Exception:
                pass

        # حالة ب: الإشعار خارج قائمة المتحكمات المعتمدة
        else:
            if notify_name not in self._seen_unhandled_notifies:
                self._seen_unhandled_notifies.add(notify_name)
                try:
                    log_fn(f"ℹ️ [إشعار غير مخصص لأول مرة]: {notify_name}")
                except Exception:
                    pass

    async def _try_open_and_handshake(self, ip: str, port: int) -> bool:
        """محاولة فتح الاتصال وإجراء مصافحة HMAC مع عنوان بوابة محدد"""
        try:
            self._reader, self._writer = await asyncio.wait_for(
                asyncio.open_connection(ip, port),
                timeout=12
            )
        except Exception as e:
            log.error(f"[{self.account.email}] فشل الاتصال بالبوابة ({ip}:{port}): {e}")
            return False

        uid_b64 = base64.b64encode(self.creds.uid.encode('utf-8')).decode('utf-8')
        srv_b64 = base64.b64encode(self.creds.server_name.encode('utf-8')).decode('utf-8')
        sub_b64 = base64.b64encode(self.creds.sub_id.encode('utf-8')).decode('utf-8')
        username = f"{uid_b64}@{srv_b64}#{sub_b64}"

        index = 1
        key_mat = f"{username}:{index}".encode('utf-8')
        hash_key = skynet_hashkey(key_mat)
        hmac_val = base64.b64encode(hmac64(hash_key, self.creds.secret)).decode('utf-8')

        payload = json.dumps({"username": username, "index": index, "hmac": hmac_val}, separators=(',', ':')).encode('utf-8')
        hs_pkt = bytes([(len(payload) >> 8) & 0xFF, len(payload) & 0xFF]) + payload
        self._writer.write(hs_pkt)
        await self._writer.drain()

        try:
            head = await asyncio.wait_for(self._reader.read(512), timeout=10)
            if b'404' in head or b'User Not Found' in head:
                self.is_other_device = True
                log.warning(f"[{self.account.email}] ⚠️ تم رصد تسجيل دخول للقلعة من جهاز آخر (404 User Not Found).")
            if b'200' not in head:
                log.error(f"[{self.account.email}] فشلت مصافحة البوابة ({ip}:{port}): {head!r}")
                self._writer.close()
                return False
            return True
        except Exception as e:
            log.error(f"[{self.account.email}] خطأ مصافحة البوابة ({ip}:{port}): {e}")
            try:
                self._writer.close()
            except Exception:
                pass
            return False

    async def connect(self) -> bool:
        if self._alive:
            return True

        self.is_other_device = False
        ok = await self._try_open_and_handshake(self.creds.gate_ip, self.creds.gate_port)
        # تطبيق منطق loginCtrl:gateConnected() للعودة إلى العنوان المباشر عند فشل البروكسي
        if not ok and not self.is_other_device and self.creds.fallback_gate_ip and (
            self.creds.fallback_gate_ip != self.creds.gate_ip or self.creds.fallback_gate_port != self.creds.gate_port
        ):
            log.info(f"[{self.account.email}] محاولة الاتصال المباشر بالبوابة الاحتياطية {self.creds.fallback_gate_ip}:{self.creds.fallback_gate_port}...")
            ok = await self._try_open_and_handshake(self.creds.fallback_gate_ip, self.creds.fallback_gate_port)

        if not ok:
            return False

        self._alive = True
        self._recv_task = asyncio.create_task(self._recv_loop())
        self._init_flow_task = asyncio.create_task(self._init_flow())
        self._heartbeat_task = asyncio.create_task(self._heartbeat_loop())
        log.info(f"[{self.account.email}] ✓ متصل بالبوابة بنجاح (UID={self.creds.uid})")
        return True

    async def _init_flow(self):
        """
        إرسال طلب التهيئة الشامل الرسمي للعبة (CMD_LOGIN_DATA_INIT = 1000 / 1)
        مع session = 0 المطابق تماماً لعميل Cocos2d-Lua الرسمي.
        وبمجرد اكتمال التهيئة، إرسال حزمة تفعيل نبض القلب الرسمية (1037/2 HEARTBEAT_SWITCH).
        """
        try:
            # تأخير بشري عشوائي قبل إرسال CMD 1000 (العميل الرسمي ينتظر تحميل UI كامل)
            await asyncio.sleep(random.uniform(1.5, 3.0))
            if not self._alive:
                return

            log.info(f"[{self.account.email}] 📡 إرسال طلب التهيئة الشامل الرسمي (CMD=1000, SUBCMD=1, Session=0)...")
            self.send_request("1000", "1", {}, session=0)
            if self._writer:
                try:
                    await self._writer.drain()
                except Exception:
                    pass

            try:
                await asyncio.wait_for(self.controllers_ready.wait(), timeout=22.0)
                self.emit_brief_log(f"🌐 [{self.account_short_name}] تهيئة اللعبة والذاكرة الحية (1000/1) ✅")
                log.info(f"[{self.account.email}] ✓ تم تحميل كامل متحكمات القلعة بنجاح ({len(self.init_data)} متحكم متوفر).")

                # إرسال تفعيل نبض القلب الرسمي المطابق لـ linkCtrl:sendHeartbeatSwitch (CMD 1037 SUBCMD 2)
                await asyncio.sleep(random.uniform(0.3, 0.8))
                if self._alive and self.is_connected and self._writer:
                    self.send_nowait("1037", "2", {"switch": True, "sn": 1})
                    try:
                        await self._writer.drain()
                        log.info(f"[{self.account.email}] ✓ تم إرسال حزمة تفعيل نبض القلب الرسمية (CMD=1037, SUBCMD=2, switch=True).")
                    except Exception:
                        pass

                    # مزامنة طوابير المسيرات النشطة مرة واحدة عند الدخول (CMD 1007 / 1000)
                if self._alive and self.is_connected:
                    try:
                        await asyncio.sleep(random.uniform(0.2, 0.5))
                        await self.query("1007", "1000", {}, timeout=8.0)
                        log.info(f"[{self.account.email}] ✓ تمت مزامنة طوابير المسيرات النشطة (CMD=1007/1000).")
                    except Exception as e:
                        log.warning(f"[{self.account.email}] تعذرت مزامنة طوابير المسيرات (1007/1000): {e}")
                
            except asyncio.TimeoutError:
                self.emit_brief_log(f"🌐 [{self.account_short_name}] تهيئة اللعبة والذاكرة الحية (1000/1) ❌")
                log.warning(f"[{self.account.email}] لم يتم استلام حزمة session 0 خلال 12 ثانية.")
        except Exception as e:
            log.error(f"[{self.account.email}] خطأ في تدفق التهيئة: {e}")

    async def _recv_loop(self):
        while self._alive and self._reader:
            try:
                chunk = await self._reader.read(4096)
                if not chunk:
                    log.warning(f"[{self.account.email}] انتهى الاتصال من جهة السيرفر (EOF / Empty chunk)")
                    break
                self._buffer += chunk
                pkts, self._buffer = unpack_stream(self._buffer)
                for pkt in pkts:
                    parsed = decode_gate_packet(pkt, self.creds.secret)
                    if parsed and isinstance(parsed, dict):
                        sess_id = parsed.get('_session', 0)
                        cmd_s = str(parsed.get('cmd', ''))
                        sub_s = str(parsed.get('subcmd', ''))
                        c_data = parsed.get('data') if isinstance(parsed.get('data'), dict) else {}

                        if self.spy_mode:
                            log.info(f"👁️ [SPY RECV] cmd={cmd_s}/{sub_s} sess={sess_id} keys={list(parsed.keys())}")

                        # معالجة وتحديث الذاكرة الحية عبر محرك الذاكرة الموحد (LiveMemoryEngine)
                        init_data, report = self.memory_engine.ingest_packet_with_report(parsed)
                        if report.get("is_notification"):
                            self._log_notification(report)
                            n_id = str(report.get("notify_id", "")).upper()
                            if "SERVER_STATUS" in n_id:
                                n_items = report.get("notify_data") or []
                                items_list = n_items if isinstance(n_items, list) else [n_items]
                                for itm in items_list:
                                    if isinstance(itm, dict):
                                        st_val = str(itm.get("status", "")).lower().strip()
                                        if st_val == "kick":
                                            self.is_other_device = True
                                            log.warning(f"[{self.account.email}] ⚠️ تم رصد طرد من السيرفر بسبب دخول متزامن من جهاز آخر (NOTIFY_SERVER_STATUS: kick).")
                                            self._alive = False
                                        elif st_val == "seal":
                                            self.is_sealed = True
                                            log.error(f"[{self.account.email}] 🛑 تم رصد إشعار إغلاق أو حظر الحساب من اللعبة (NOTIFY_SERVER_STATUS: seal).")
                                            self._alive = False
                                        elif st_val == "server_maintenance":
                                            log.warning(f"[{self.account.email}] 🛠️ تم رصد إشعار صيانة السيرفر (NOTIFY_SERVER_STATUS: server_maintenance).")
                                            self._alive = False

                        # إشعار اكتمال تحميل المتحكمات الأساسية
                        if sess_id == 0 or cmd_s in ('1000', 'onemt_1000'):
                            self.controllers_ready.set()
                            log.info(f"[{self.account.email}] ✓ تم تفريغ وتحديث {len(self.init_data)} متحكم في الذاكرة الحية بنجاح.")
                        elif not self.controllers_ready.is_set() and self.memory_engine.is_memory_ready()[0]:
                            self.controllers_ready.set()

                        data_obj = c_data if isinstance(c_data, dict) else {}
                        notify_id = str(data_obj.get('notifyID', ''))

                        resp_cmd = str(parsed.get('cmd', ''))
                        if sess_id and sess_id in self._pending:
                            entry = self._pending.pop(sess_id)
                            fut = entry[1] if isinstance(entry, tuple) else entry
                            if not fut.done():
                                fut.set_result(parsed)
                        elif not notify_id and resp_cmd not in ('1037', '1005', '1002', '1004'):
                            for sess_num, entry in list(self._pending.items()):
                                exp_cmd = entry[0] if isinstance(entry, tuple) else None
                                fut = entry[1] if isinstance(entry, tuple) else entry
                                if not fut.done() and (exp_cmd is None or exp_cmd == resp_cmd):
                                    fut.set_result(parsed)
                                    del self._pending[sess_num]
                                    break
            except asyncio.CancelledError:
                break
            except Exception as e:
                log.error(f"[{self.account.email}] استثناء في حلقة الاستقبال: {e}", exc_info=True)
                break
        self._alive = False
        # إلغاء كافة الطلبات المعلقة فوراً دون انتظار التايم أوت (Fast Fail on Disconnect)
        for sess_num, entry in list(self._pending.items()):
            fut = entry[1] if isinstance(entry, tuple) else entry
            if not fut.done():
                fut.set_exception(ConnectionResetError("انقطع اتصال البوابة (EOF / Server Disconnect)"))
        self._pending.clear()

    def send_request(self, cmd: str, subcmd: str = "1", data: dict = None, session: Optional[int] = None):
        if not self.is_connected or not self._writer:
            return
        if session is None:
            sess_id = self._session
            self._session += 1
        else:
            sess_id = session
        pkt = pack_gate_request(cmd, subcmd, data, session=sess_id, secret=self.creds.secret)
        self._writer.write(pkt)

    def send_nowait(self, cmd: str, subcmd: str = "1", data: dict = None):
        self.send_request(cmd, subcmd, data)

    async def _heartbeat_loop(self):
        # لا نبدأ إرسال النبضات إلا بعد اكتمال تهيئة اللعبة وتفعيل النبض 1037/2
        try:
            await self.controllers_ready.wait()
        except asyncio.CancelledError:
            return

        while self._alive:
            try:
                # الفاصل الزمني الرسمي لنبض القلب في انتقام السلاطين (constValue.lua: HEARTBEAT_INV = 20)
                await asyncio.sleep(20 + random.uniform(0.5, 2.0))
                if self.is_connected and self._writer:
                    # النبض الرسمي 1037/1 بدون حقول إضافية وهمية (مطابق لـ linkCtrl:sendHeartbeat)
                    self.send_nowait("1037", "1", None)
                    await self._writer.drain()
            except asyncio.CancelledError:
                break
            except Exception:
                pass

    async def reconnect_full(self) -> bool:
        """إعادة المصادقة الكاملة مع خادم الدخول ثم البوابة عند انتهاء صلاحية الجلسة (404 User Not Found)"""
        await self.close()
        new_creds = await async_login(self.account)
        if not new_creds:
            return False
        self.creds = new_creds
        return await self.connect()

    async def query(
        self,
        cmd: str,
        subcmd: str = "2",
        data: dict = None,
        timeout: float = 8.0,
        action: Optional[str] = None,
    ) -> Optional[dict]:
        if not self.is_connected:
            raise ConnectionResetError(f"[{self.account.email}] لا يوجد اتصال نشط بالبوابة لإرسال الاستعلام ({cmd}/{subcmd})")

        sess_id = self._session
        self._session += 1
        pkt = pack_gate_request(cmd, subcmd, data, session=sess_id, secret=self.creds.secret)

        fut = asyncio.get_event_loop().create_future()
        self._pending[sess_id] = (str(cmd), fut)

        self._writer.write(pkt)
        await self._writer.drain()

        res = None
        try:
            res = await asyncio.wait_for(fut, timeout=timeout)
        except asyncio.TimeoutError:
            self._pending.pop(sess_id, None)
            res = None
        except Exception:
            self._pending.pop(sess_id, None)
            res = None
            raise
        finally:
            # استثناء نبض القلب الدوري التلقائي (Heartbeat 1037) من الطباعة تماماً
            if str(cmd) != "1037":
                try:
                    success, err_code = is_query_success(res)
                    emoji, default_desc = get_cmd_metadata(str(cmd), str(subcmd), data)
                    desc = action if action else default_desc
                    if str(cmd) == "1001" and str(subcmd) == "10" and str(err_code) == "1022":
                        status_mark = "ℹ️ (بدون سقف استلام)"
                    else:
                        status_mark = "✅" if success else (f"❌ (كود: {err_code})" if err_code and err_code != "timeout" else "❌")
                    acc_name = self.account_short_name
                    line = f"{emoji} [{acc_name}] {desc} ({cmd}/{subcmd}) {status_mark}"
                    self.emit_brief_log(line)
                except Exception:
                    pass

        return res

    async def close(self):
        """إغلاق الاتصال النظيف الحتمي: إلغاء المهام الفرعية وإغلاق مقبس الويندوز بأمان"""
        if not self._alive and not self._writer:
            return

        # إرسال إشعار الخروج النظيف للسيرفر (CMD 1037 SUBCMD 2 مع switch=False) المطابق لـ linkCtrl:sendHeartbeatSwitch(false)
        if self._alive and self._writer and not self._writer.is_closing():
            try:
                self.send_nowait("1037", "2", {"switch": False})
                await asyncio.wait_for(self._writer.drain(), timeout=0.6)
            except Exception:
                pass

        self._alive = False

        # إلغاء وانتظار كافة المهام الفرعية (Zero Orphan Child Tasks)
        child_tasks = [t for t in (self._init_flow_task, self._heartbeat_task, self._recv_task) if t and not t.done()]
        for task in child_tasks:
            task.cancel()
        if child_tasks:
            try:
                await asyncio.wait_for(asyncio.gather(*child_tasks, return_exceptions=True), timeout=2.0)
            except Exception:
                pass
        self._init_flow_task = None
        self._heartbeat_task = None
        self._recv_task = None

        # إغلاق مقبس الشبكة على مستوى الويندوز (OS Socket Clean Shutdown)
        if self._writer:
            sock = None
            try:
                sock = self._writer.get_extra_info('socket')
                if sock:
                    try:
                        sock.shutdown(socket.SHUT_RDWR)
                    except Exception:
                        pass
                self._writer.close()
                try:
                    await asyncio.wait_for(self._writer.wait_closed(), timeout=1.0)
                except Exception:
                    # في حال تعليق wait_closed في ويندوز، إغلاق المقبس الخام فوراً
                    if sock:
                        try:
                            sock.close()
                        except Exception:
                            pass
            except Exception:
                if sock:
                    try:
                        sock.close()
                    except Exception:
                        pass
            self._writer = None

        self._reader = None
        self._buffer = b""
        self.memory_engine.clear()

GateClient = GameConnection

class MultiAccountManager:
    """مدير مركزي غير متزامن لإدارة وتنسيق اتصالات مئات الحسابات بالتوازي"""
    def __init__(self):
        self.accounts: Dict[str, AccountSession] = {}
        self.connections: Dict[str, GameConnection] = {}

    def load_from_cache(self):
        accs = SessionCache.load_all()
        for em, d in accs.items():
            self.accounts[em] = AccountSession(
                email=em,
                user_id=d.get('userId', ''),
                session_id=d.get('sessionId', '')
            )
        log.info(f"[MultiManager] تم تحميل {len(self.accounts)} حساب من session_cache.json")

    async def connect_account(self, email: str) -> bool:
        if email not in self.accounts:
            return False
        acc = self.accounts[email]
        creds = await async_login(acc)
        if not creds:
            return False
        conn = GameConnection(acc, creds)
        ok = await conn.connect()
        if ok:
            self.connections[email] = conn
            return True
        return False

    async def connect_all(self, delay: float = 1.2):
        success_count = 0
        for em in self.accounts:
            try:
                ok = await self.connect_account(em)
                if ok:
                    success_count += 1
            except Exception as e:
                log.error(f"[MultiManager] خطأ في ربط {em}: {e}")
            await asyncio.sleep(delay + random.uniform(0.2, 0.8))
        log.info(f"[MultiManager] تم ربط {success_count}/{len(self.accounts)} حساب بنجاح.")

    async def query_all(self, cmd: str, subcmd: str = "2", data: dict = None) -> Dict[str, Optional[dict]]:
        tasks = {em: conn.query(cmd, subcmd, data) for em, conn in self.connections.items()}
        results = {}
        for em, t in tasks.items():
            try:
                results[em] = await t
            except Exception as e:
                results[em] = {"error": str(e)}
        return results

    async def close_all(self):
        for conn in self.connections.values():
            await conn.close()
        self.connections.clear()

# ═════════════════════════════════════════════════════════════════════════════
# 7. سطر الأوامر للاختبار المباشر (CLI Interface)
# ═════════════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(description="العميل الموحد المستقل للعبة انتقام السلاطين (game_client.py)")
    parser.add_argument("--login", action="store_true", help="تسجيل الدخول واختبار البوابة")
    parser.add_argument("--list", action="store_true", help="عرض قائمة الحسابات المحفوظة")
    parser.add_argument("--sync", action="store_true", help="مزامنة كافة الجلسات الشرعية من المحاكي مباشرة إلى الكاش")
    parser.add_argument("--email", type=str, default="", help="البريد الإلكتروني")
    parser.add_argument("--password", type=str, default="", help="كلمة المرور")
    parser.add_argument("--proxy", type=str, default="", help="بروكسي SOCKS5 أو HTTP")
    parser.add_argument("--add-account", type=str, default="", help="إضافة وتوثيق حساب جديد (يتطلب --password)")
    parser.add_argument("--cmd", type=str, default="", help="معرف الأمر")
    parser.add_argument("--sub", type=str, default="2", help="معرف الأمر الفرعي")
    parser.add_argument("--data", type=str, default="{}", help="بيانات JSON")
    parser.add_argument("--async-test", action="store_true", help="اختبار محرك asyncio وتعدد الحسابات")
    parser.add_argument("--force-login", action="store_true", help="إجبار إعادة المصادقة السحابية وتجديد التوكن عبر خادم SDK")
    args = parser.parse_args()

    if args.list:
        accs = SessionCache.load_all()
        print("\n" + "=" * 65)
        print("  📋 قائمة الحسابات المسجلة في session_cache.json:")
        print("=" * 65)
        for i, (em, d) in enumerate(accs.items(), 1):
            prof = get_account_device_profile(em)
            mdl = d.get("model") or prof["model"]
            os_v = d.get("osVersion") or prof["osVersion"]
            print(f" [{i}] الحساب:      {em}")
            print(f"     UserID:    {d.get('userId')}")
            print(f"     الجوال:     {mdl} (Android {os_v})")
            print(f"     SessionId: {d.get('sessionId', '')[:30]}...")
            print("-" * 65)
        print(f"💡 الإجمالي: {len(accs)} حساب مسجل.\n")
        return

    if args.sync:
        print("[*] جاري مزامنة الجلسات الشرعية من المحاكي (emulator-5554)...")
        SessionCache.sync_from_emulator()
        return

    if args.add_account:
        if not args.password:
            print("[-] خطأ: يجب تمرير كلمة المرور (--password) لتوثيق الحساب الجديد.")
            return
        prof = get_account_device_profile(args.add_account)
        print(f"[*] جاري مصادقة الحساب الجديد ({args.add_account} | الجوال: {prof['model']})...")
        res = sdk_login(args.add_account, args.password, device_id=prof["deviceId"], proxy_url=args.proxy or None)
        if res["success"]:
            SessionCache.set_account(
                args.add_account,
                res["userId"],
                res["sessionId"],
                device_id=prof["deviceId"],
                model=prof["model"],
                os_version=prof["osVersion"]
            )
            print(f"[+] ✓ تم توثيق وحفظ الحساب بنجاح في session_cache.json (UID: {res['userId']} | Device: {prof['model']})")
        else:
            print(f"[-] فشلت المصادقة: {res.get('error_msg')} (كود: {res.get('error_code')})")
        return

    if args.async_test:
        async def _test():
            mgr = MultiAccountManager()
            mgr.load_from_cache()
            if not mgr.accounts:
                print("[-] لا توجد حسابات مسجلة لاختبار الـ Async.")
                return
            target_email = args.email or list(mgr.accounts.keys())[0]
            if args.password and target_email in mgr.accounts:
                mgr.accounts[target_email].password = args.password
            print(f"[*] اختبار المحرك غير المتزامن لحساب: {target_email}...")
            ok = await mgr.connect_account(target_email)
            if ok:
                print("[+] تم الاتصال غير المتزامن بنجاح! جاري إرسال استعلام 1001...")
                res = await mgr.connections[target_email].query("1001", "2", {})
                print(f"[+] استجابة السيرفر: {json.dumps(res, ensure_ascii=False, indent=2)[:1500]}")
                await mgr.close_all()
            else:
                print("[-] فشل الاتصال غير المتزامن.")
        asyncio.run(_test())
        return

    try:
        client = RosClient(
            email=args.email or None,
            password=args.password or None,
            force_refresh=args.force_login,
            proxy_url=args.proxy or None
        )
    except Exception as e:
        print(f"[-] خطأ أثناء تهيئة العميل: {e}")
        return

    try:
        if client.is_sealed:
            return

        if args.cmd:
            custom_data = json.loads(args.data) if args.data else {}
            resps = client.execute_command(args.cmd, args.sub, custom_data)
            print("\n" + "=" * 65)
            print("  📡 نتائج تنفيذ الأمر المخصص:")
            print("=" * 65)
            for r in (resps or []):
                print(json.dumps(r, indent=2, ensure_ascii=False))
        else:
            ok = client.connect_gate()
            if ok:
                print("\n" + "=" * 65)
                print("  👑 تم التحقق وتسجيل الدخول بنجاح تام!")
                print("=" * 65)
                print(f"  • الحساب:          {client.email}")
                print(f"  • الجوال المخصص:   {client.device_profile.get('model')} (Android {client.device_profile.get('osVersion')})")
                print(f"  • المعرف (UID):    {client.gate_info.get('uid')}")
                print(f"  • رقم المملكة:     {client.gate_info.get('kingdomId')}")
                print(f"  • اسم السيرفر:     {client.gate_info.get('servername')}")
                print(f"  • سيرفر البوابة:   {client.gate_info.get('target_gate_ip')}:{client.gate_info.get('target_gate_port')}")
                print("=" * 65 + "\n")
            elif not client.is_sealed:
                print(f"[-] تعذر الاتصال بسيرفر البوابة للحساب: {client.email}")
    except ConnectionError as e:
        if not client.is_sealed:
            print(f"[-] خطأ في الاتصال: {e}")
    except Exception as e:
        if not client.is_sealed:
            print(f"[-] حدث خطأ غير متوقع: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    main()