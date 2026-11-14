# -*- coding: utf-8 -*-
"""
login_sniffer.py — مراقب تسجيل الدخول وتبديل الحسابات (انتقام السلاطين)
═════════════════════════════════════════════════════════════════════════════════
ملف مخصص لالتقاط وتحليل كافة حزم وبيانات تسجيل الدخول وتبديل الحسابات لحظياً:
  1. رصد بيانات SDK Passport فور اختيار أو كتابة الحساب من واجهة اللعبة (SdkEmail.xml).
  2. التقاط مصافحة خادم تسجيل الدخول (Port 10000 - kohlogin.menaapp.net) خطوة بخطوة:
     - S2C_CHALLENGE
     - C2S_PUBKEY (Diffie-Hellman)
     - S2C_SERVERKEY
     - C2S_HMAC
     - S2C_HANDSHAKE
     - C2S_AUTH_TOKEN (فك تشفير التوكن وسلسلة المنصة وطراز الجهاز)
     - S2C_AUTH_TOKEN (استخراج المملكة، UID، SubID، Gate IP & Port)
  3. التقاط مصافحة خادم البوابة (Port 4060 / 4000-4300) وتأكيد الدخول.
  4. التقاط حزمة طلب بيانات القلعة الأولية (CMD 1000) وتلخيص بيانات اللورد.
  5. حفظ الجلسة والمفتاح تلقائياً في session_cache.json و des_key.bin.

الاستخدام:
  python sctipt_test/login_sniffer.py
  python sctipt_test/login_sniffer.py --device emulator-5554
  python sctipt_test/login_sniffer.py --no-frida
"""

import os
import sys
import time
import json
import socket
import struct
import base64
import zlib
import hashlib
import argparse
import threading
import subprocess
import xml.etree.ElementTree as ET
from typing import Optional, Dict, Any, Tuple
from Crypto.Cipher import DES

try:
    import frida
    HAS_FRIDA = True
except ImportError:
    HAS_FRIDA = False

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# ═════════════════════════════════════════════════════════════════════════════
# 1. الإعدادات والمسارات
# ═════════════════════════════════════════════════════════════════════════════
SCRIPT_DIR      = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT    = os.path.dirname(SCRIPT_DIR)
CORE_DIR        = os.path.join(PROJECT_ROOT, "core")
LOG_FILE        = os.path.join(SCRIPT_DIR, "login_sniffer_log.txt")
CACHE_FILE      = os.path.join(CORE_DIR, "session_cache.json")
LOCAL_KEY_FILE  = os.path.join(SCRIPT_DIR, "des_key.bin")
CORE_KEY_FILE   = os.path.join(CORE_DIR, "des_key.bin")

BRIDGE_PORT     = 19877
PACKAGE_NAME    = "and.onemt.war.ar"

# متغيرات الحالة المشتركة
log_f            = None
ACTIVE_DES_KEY   = None
LAST_CHALLENGE   = None   # bytes
LAST_HMAC        = None   # bytes
CURRENT_ACCOUNT  = {}
LAST_SDK_MD5     = ""

# ═════════════════════════════════════════════════════════════════════════════
# 2. الدوال المساعدة والطباعة
# ═════════════════════════════════════════════════════════════════════════════
def out(text: str = ""):
    print(text, flush=True)
    if log_f:
        try:
            log_f.write(text + "\n")
            log_f.flush()
        except Exception:
            pass

def print_banner(device: str):
    out("=" * 66)
    out("  👑 مراقب تسجيل الدخول وتبديل الحسابات — انتقام السلاطين")
    out(f"  📱 الجهاز المستهدف: {device}")
    out(f"  📝 ملف السجل:      {LOG_FILE}")
    out(f"  ⚡ المنفذ المحلي:    {BRIDGE_PORT}")
    out("=" * 66)
    out("[*] المراقب قيد التشغيل والانتظار...")
    out("[*] انتقل في اللعبة إلى: الإعدادات -> الحساب -> تبديل الحساب")
    out("[*] سيتم التقاط وفك تشفير كامل بيانات الجلسة والمفاتيح تلقائياً!\n")

def print_box(title: str, lines: list, color_tag: str = "INFO"):
    out("\n" + "=" * 66)
    out(f"  [{color_tag}] {title}")
    out("=" * 66)
    for l in lines:
        out(f"  {l}")
    out("=" * 66)

# ═════════════════════════════════════════════════════════════════════════════
# 3. خوارزميات التشفير وفك التشفير الرسمية للعبة
# ═════════════════════════════════════════════════════════════════════════════
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
    """حساب توقيع HMAC64 المعتمد في اللعبة للمصادقة وتأكيد المفتاح"""
    ch_lo, ch_hi   = struct.unpack('<2I', challenge)
    sec_lo, sec_hi = struct.unpack('<2I', secret)
    pattern = struct.pack('<4I', ch_hi, ch_lo, sec_hi, sec_lo)
    A, B, C, D = _md5_compress_no_add(pattern * 4)
    return struct.pack('<2I', (C ^ D) & 0xFFFFFFFF, (B ^ A) & 0xFFFFFFFF)

def skynet_des_decode(data: bytes, key: bytes) -> bytes:
    """فك تشفير DES-ECB مع إزالة حشوة ISO 7816-4"""
    try:
        if len(data) % 8 != 0:
            return data
        cipher = DES.new(key[:8], DES.MODE_ECB)
        dec = cipher.decrypt(data)
        idx = dec.rfind(b'\x80')
        if idx != -1:
            return dec[:idx]
        return dec
    except Exception:
        return data

def save_active_key(key: bytes):
    global ACTIVE_DES_KEY
    if not key or len(key) != 8:
        return
    ACTIVE_DES_KEY = key
    for p in (LOCAL_KEY_FILE, CORE_KEY_FILE):
        try:
            os.makedirs(os.path.dirname(p), exist_ok=True)
            with open(p, "wb") as f:
                f.write(key)
        except Exception:
            pass

# ═════════════════════════════════════════════════════════════════════════════
# 4. مراقب ملفات الحسابات السحابية (SdkEmail.xml Watcher)
# ═════════════════════════════════════════════════════════════════════════════
def sync_sdk_account(email: str, user_id: str, session_id: str):
    """تحديث وتخزين بيانات الحساب الجديد في session_cache.json"""
    try:
        os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
        accs = {}
        if os.path.exists(CACHE_FILE):
            try:
                with open(CACHE_FILE, "r", encoding="utf-8") as f:
                    accs = json.load(f).get("accounts", {})
            except Exception:
                accs = {}

        old_entry = accs.get(email, {}) if isinstance(accs.get(email), dict) else {}
        accs[email] = {
            "userId": user_id,
            "sessionId": session_id,
            "deviceId": old_entry.get("deviceId", ""),
            "model": old_entry.get("model", ""),
            "osVersion": old_entry.get("osVersion", "13"),
            "timestamp": time.time(),
            "source": "login_sniffer_sdk"
        }
        with open(CACHE_FILE, "w", encoding="utf-8") as f:
            json.dump({"accounts": accs}, f, indent=2, ensure_ascii=False)
    except Exception as e:
        out(f"[!] خطأ حفظ session_cache.json: {e}")

def sdk_email_watcher(serial: str):
    """خيط خلفي لمراقبة SdkEmail.xml عند اختيار أو كتابة حساب جديد في المحاكي"""
    global LAST_SDK_MD5, CURRENT_ACCOUNT
    cmd = ["adb", "-s", serial, "shell", "su 0 cat /data/data/and.onemt.war.ar/shared_prefs/SdkEmail.xml 2>/dev/null"]

    while True:
        try:
            res = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
            xml_text = res.stdout.strip()
            if xml_text and "<map>" in xml_text:
                curr_md5 = hashlib.md5(xml_text.encode('utf-8')).hexdigest()
                if curr_md5 != LAST_SDK_MD5:
                    LAST_SDK_MD5 = curr_md5
                    try:
                        root = ET.fromstring(xml_text)
                        for s in root.findall('string'):
                            email = s.get('name', '')
                            val = s.text or ''
                            if '@' in email and 'OneMT' in val:
                                parts = val.split('OneMT', 1)
                                uid, sid = parts[0], parts[1]
                                CURRENT_ACCOUNT = {"email": email, "userId": uid, "sessionId": sid}
                                sync_sdk_account(email, uid, sid)
                                print_box(
                                    title="رصد تبديل الحساب في واجهة اللعبة (SDK Passport)",
                                    lines=[
                                        f"📧 البريد الإلكتروني: {email}",
                                        f"👤 User ID:          {uid}",
                                        f"🔑 Session ID (Token): {sid[:30]}...{sid[-10:]}",
                                        "💾 تم حفظ الجلسة وتحديثها فوراً في session_cache.json!"
                                    ],
                                    color_tag="SDK AUTH"
                                )
                    except Exception:
                        pass
        except Exception:
            pass
        time.sleep(1.2)

# ═════════════════════════════════════════════════════════════════════════════
# 5. معالجة وتفسير حزم خادم الدخول (Port 10000)
# ═════════════════════════════════════════════════════════════════════════════
class LoginServerParser:
    """محلل دورة حياة خادم تسجيل الدخول (kohlogin.menaapp.net:10000) بنظام الأسطر"""
    def __init__(self):
        self.step = 0
        self.challenge = None
        self.client_pub = None
        self.server_pub = None
        self.hmac = None

    def handle_line(self, direction: str, line: str):
        global LAST_CHALLENGE, LAST_HMAC, ACTIVE_DES_KEY

        # ── 1. S2C_CHALLENGE ──────────────────────────────────────────
        if direction == 'RECV' and self.step == 0 and len(line) in (12, 16, 24, 32):
            try:
                ch_bytes = base64.b64decode(line)
                if len(ch_bytes) == 8:
                    self.challenge = ch_bytes
                    LAST_CHALLENGE = ch_bytes
                    self.step = 1
                    print_box(
                        title="خادم تسجيل الدخول: التحدي الأولي [S2C_CHALLENGE]",
                        lines=[
                            f"🌐 الاتجاه:          RECV (من السيرفر 10000)",
                            f"🔢 Challenge (B64): {line}",
                            f"🔐 Challenge (HEX): {ch_bytes.hex()}"
                        ],
                        color_tag="LOGIN 1/6"
                    )
                    return
            except Exception:
                pass

        # ── 2. C2S_PUBKEY (Client DH Key) ────────────────────────────
        if direction == 'SEND' and self.step == 1:
            try:
                pub_bytes = base64.b64decode(line)
                if len(pub_bytes) == 8:
                    self.client_pub = pub_bytes
                    self.step = 2
                    print_box(
                        title="مفتاح العميل العام [C2S_PUBKEY (Diffie-Hellman)]",
                        lines=[
                            f"🌐 الاتجاه:           SEND (من العميل)",
                            f"🔑 Client Key (B64): {line}",
                            f"🔐 Client Key (HEX): {pub_bytes.hex()}"
                        ],
                        color_tag="LOGIN 2/6"
                    )
                    return
            except Exception:
                pass

        # ── 3. S2C_SERVERKEY (Server DH Key) ─────────────────────────
        if direction == 'RECV' and self.step == 2:
            try:
                srv_bytes = base64.b64decode(line)
                if len(srv_bytes) == 8:
                    self.server_pub = srv_bytes
                    self.step = 3
                    print_box(
                        title="مفتاح السيرفر العام [S2C_SERVERKEY (Diffie-Hellman)]",
                        lines=[
                            f"🌐 الاتجاه:           RECV (من السيرفر)",
                            f"🔑 Server Key (B64): {line}",
                            f"🔐 Server Key (HEX): {srv_bytes.hex()}"
                        ],
                        color_tag="LOGIN 3/6"
                    )
                    return
            except Exception:
                pass

        # ── 4. C2S_HMAC (توقيع التحقق) ───────────────────────────────
        if direction == 'SEND' and self.step == 3:
            try:
                hmac_bytes = base64.b64decode(line)
                if len(hmac_bytes) == 8:
                    self.hmac = hmac_bytes
                    LAST_HMAC = hmac_bytes
                    self.step = 4
                    print_box(
                        title="توقيع التحقق [C2S_HMAC (Verification Hash)]",
                        lines=[
                            f"🌐 الاتجاه:      SEND (من العميل)",
                            f"🛡️ HMAC (B64):   {line}",
                            f"🔐 HMAC (HEX):   {hmac_bytes.hex()}",
                            f"💡 سيتم استخدامه للتحقق الرياضي الفوري من مفتاح الجلسة النشط!"
                        ],
                        color_tag="LOGIN 4/6"
                    )
                    return
            except Exception:
                pass

        # ── 5. S2C_HANDSHAKE ─────────────────────────────────────────
        if direction == 'RECV' and self.step == 4 and line.startswith('200'):
            self.step = 5
            print_box(
                title="اكتمال المصافحة الأولية بنجاح [S2C_HANDSHAKE]",
                lines=[
                    f"🌐 الاتجاه:  RECV (من السيرفر)",
                    f"✅ الحالة:    {line} OK",
                    f"🚀 تم تأسيس القناة المشفرة والانتقال لطلب توثيق الحساب..."
                ],
                color_tag="LOGIN 5/6"
            )
            return

        # ── 6. C2S_AUTH_TOKEN (طلب التوثيق الصادر من العميل) ────────
        if direction == 'SEND' and '@' in line:
            parts = line.split('@')
            if len(parts) >= 4:
                self.step = 6
                dec_info = {}
                key = ACTIVE_DES_KEY
                
                # فك تشفير الحقول في حال توفر المفتاح
                labels = ["token", "version", "platform", "model", "carrier"]
                for i, p in enumerate(parts):
                    lbl = labels[i] if i < len(labels) else f"field_{i}"
                    if key:
                        try:
                            dec = skynet_des_decode(base64.b64decode(p), key).decode('utf-8', errors='replace')
                            dec_info[lbl] = dec
                        except Exception:
                            dec_info[lbl] = p
                    else:
                        dec_info[lbl] = f"[مشفر بـ DES] {p[:20]}..."

                lines_out = [
                    f"🌐 الاتجاه:           SEND (من العميل)",
                    f"📱 إصدار اللعبة:      {dec_info.get('version', '')}",
                    f"🖥️ سلسلة المنصة:     {dec_info.get('platform', '')}",
                    f"📲 طراز الجوال:       {dec_info.get('model', '')}",
                    f"📶 المشغل:           {dec_info.get('carrier', '')}",
                ]
                tok = dec_info.get('token', '')
                if ':' in tok and '@' in tok:
                    lines_out.append(f"👤 بيانات التوكن المفكوكة: {tok}")

                print_box(
                    title="إرسال طلب توثيق الجلسة للحساب [C2S_AUTH_TOKEN_REQUEST]",
                    lines=lines_out,
                    color_tag="LOGIN 6/6"
                )
                return

        # ── 7. S2C_AUTH_TOKEN (استجابة السيرفر النهائية واعتماد الدخول) ──
        if direction == 'RECV' and (line.startswith('200 ') or line.startswith('50')):
            code = line[:3]
            submsg = line[4:] if len(line) > 4 else ""

            if code == "200" and submsg:
                try:
                    auth_data = base64.b64decode(submsg).decode('utf-8', errors='replace')
                    parts = auth_data.split("@")
                    fields = ['kingdomId', 'servername', 'gateip', 'gateport', 'subid', 'uid', 'proxyHost', 'proxyPort']
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

                    print_box(
                        title="نجاح تسجيل الدخول واعتماد الحساب! [S2C_AUTH_TOKEN_SUCCESS]",
                        lines=[
                            f"🌐 الاتجاه:             RECV (من السيرفر)",
                            f"🏰 رقم المملكة (Kingdom): {info.get('kingdomId')}",
                            f"🎮 اسم السيرفر (Server): {info.get('servername')}",
                            f"🆔 معرف الحساب (UID):     {info.get('uid')}",
                            f"🔢 المعرف الفرعي (SubID): {info.get('subid')}",
                            f"🚪 عنوان البوابة (Gate):  {info.get('gateip')}:{info.get('gateport')}",
                            f"🔀 بروكسي البوابة:        {info.get('proxyHost', 'لا يوجد')}:{info.get('proxyPort', '')}",
                            "✨ تم تسجيل الدخول بنجاح! جاري تحويل الاتصال لخادم البوابة..."
                        ],
                        color_tag="SUCCESS"
                    )
                    self.step = 0
                    return
                except Exception as e:
                    out(f"[!] خطأ فك بيانات AUTH_TOKEN: {e}")

            elif code.startswith("50"):
                reasons = {
                    "501": "السيرفر تحت الصيانة (Server Maintenance)",
                    "502": "الحساب محظور من الإدارة (Account Sealed)",
                    "503": "إصدار اللعبة غير متوافق (Version Mismatch)",
                    "504": "خطأ توكن المصادقة أو حساب محذوف (SDK Token Error)",
                    "505": "خطأ في خادم الربط (Crossing Server Error)"
                }
                desc = reasons.get(code, "رفض تسجيل الدخول")
                print_box(
                    title=f"رفض تسجيل الدخول من السيرفر [{code}]",
                    lines=[
                        f"❌ كود الرفض:   {code}",
                        f"📋 السبب:       {desc}",
                        f"📄 نص الاستجابة: {line}"
                    ],
                    color_tag="LOGIN REJECTED"
                )
                self.step = 0

# ═════════════════════════════════════════════════════════════════════════════
# 6. معالجة وتفسير حزم خادم البوابة (Port 4000-4300 / 4060)
# ═════════════════════════════════════════════════════════════════════════════
def handle_gate_frame(direction: str, frame: bytes, port: int):
    """تفسير حزم البوابة (المصافحة + طلب التهيئة CMD 1000)"""
    global ACTIVE_DES_KEY

    # 1. فحص مصافحة البوابة الصادرة (Gate Handshake SEND)
    if direction == 'SEND':
        try:
            # مصافحة البوابة: JSON يحتوي على username و hmac
            s_idx = frame.find(b'{')
            e_idx = frame.rfind(b'}')
            if s_idx != -1 and e_idx != -1:
                js_str = frame[s_idx:e_idx+1].decode('utf-8', errors='replace')
                d = json.loads(js_str)
                if 'username' in d and 'hmac' in d:
                    u_raw = d.get('username', '')
                    # username: uid_b64@server_b64#subid_b64
                    uid_s, srv_s, sub_s = "", "", ""
                    try:
                        m_at = u_raw.split('@')
                        uid_s = base64.b64decode(m_at[0]).decode('utf-8')
                        m_hash = m_at[1].split('#')
                        srv_s = base64.b64decode(m_hash[0]).decode('utf-8')
                        sub_s = base64.b64decode(m_hash[1]).decode('utf-8')
                    except Exception:
                        pass

                    print_box(
                        title=f"مصافحة خادم البوابة [GATE HANDSHAKE] (المنفذ {port})",
                        lines=[
                            f"🌐 الاتجاه:           SEND (من العميل)",
                            f"🆔 معرف الحساب (UID): {uid_s or u_raw}",
                            f"🎮 السيرفر:          {srv_s}",
                            f"🔢 المعرف الفرعي:    {sub_s}",
                            f"🛡️ توقيع المصافحة:   {d.get('hmac', '')[:30]}..."
                        ],
                        color_tag="GATE HANDSHAKE"
                    )
                    return
        except Exception:
            pass

    # 2. فحص رد مصافحة البوابة (Gate Handshake RECV)
    if direction == 'RECV' and b"200 OK" in frame:
        print_box(
            title=f"تم اعتماد اتصال البوابة بنجاح! [GATE CONNECTED] (المنفذ {port})",
            lines=[
                f"🌐 الاتجاه:   RECV (من سيرفر البوابة)",
                f"✅ الاستجابة: 200 OK",
                f"🏰 تم الدخول رسمياً لعالم القلعة وتجهيز تبادل الحزم التكتيكية!"
            ],
            color_tag="GATE SUCCESS"
        )
        return

    # 3. فحص طلب التهيئة الأولية CMD 1000 أو الرد عليه
    # محاولة فك ZLIB أو JSON
    cand_bytes = frame
    for w in (-15, 15, 31, 47, 32):
        try:
            cand_bytes = zlib.decompress(frame, w)
            break
        except Exception:
            pass

    s_i = cand_bytes.find(b'{')
    e_i = cand_bytes.rfind(b'}')
    if s_i != -1 and e_i != -1:
        try:
            d = json.loads(cand_bytes[s_i:e_i+1].decode('utf-8', errors='replace'))
            cmd_s = str(d.get('cmd', ''))
            sub_s = str(d.get('subcmd', ''))

            if cmd_s in ('1000', 'onemt_1000'):
                if direction == 'SEND':
                    print_box(
                        title="طلب تحميل متحكمات وبيانات القلعة [CMD 1000 / Session 0]",
                        lines=[
                            f"🌐 الاتجاه: SEND (طلب التهيئة الشامل)",
                            f"📦 الأمر:   cmd={cmd_s}, subcmd={sub_s}",
                            "⏳ بانتظار تفريغ مصفوفة القلعة من السيرفر..."
                        ],
                        color_tag="INIT REQUEST"
                    )
                else:
                    # تفريغ بيانات اللورد إن وُجدت
                    c_data = d.get('data', {}) if isinstance(d.get('data'), dict) else {}
                    retdata = c_data.get('retdata', {}) if isinstance(c_data.get('retdata'), dict) else {}
                    lord_info = retdata.get('lordInfoCtrl', {}) if isinstance(retdata.get('lordInfoCtrl'), dict) else {}
                    
                    lines_lord = [
                        f"🌐 الاتجاه:           RECV (استلام الحزمة الشاملة بنجاح)",
                        f"📦 كود الأمر:         cmd={cmd_s}, subcmd={sub_s}",
                    ]
                    if lord_info:
                        lines_lord.extend([
                            f"👑 اسم اللورد:       {lord_info.get('name', 'غير محدد')}",
                            f"🏰 المستوى:           Level {lord_info.get('level', '?')}",
                            f"⚔️ القوة القتالية:    {lord_info.get('power', '?')}",
                            f"🛡️ التحالف:          {lord_info.get('alliancename', 'بدون تحالف')}"
                        ])
                    else:
                        lines_lord.append(f"✓ تم استلام بيانات القلعة بحجم {len(frame)} بايت.")

                    print_box(
                        title="تم تحميل بيانات القلعة بالكامل بنجاح! [CASTLE READY]",
                        lines=lines_lord,
                        color_tag="CASTLE INIT"
                    )
        except Exception:
            pass

# ═════════════════════════════════════════════════════════════════════════════
# 7. محرك ربط التدفق الشبكي المباشر (TCP Stream Bridge & Demux)
# ═════════════════════════════════════════════════════════════════════════════
def read_exact(conn: socket.socket, n: int) -> bytes:
    buf = bytearray()
    while len(buf) < n:
        chunk = conn.recv(n - len(buf))
        if not chunk:
            raise ConnectionResetError("تم إغلاق قناة التدفق من قِبل الجسر")
        buf.extend(chunk)
    return bytes(buf)

def start_stream_bridge(serial: str):
    subprocess.run(["adb", "-s", serial, "reverse", f"tcp:{BRIDGE_PORT}", f"tcp:{BRIDGE_PORT}"], check=True, stdout=subprocess.DEVNULL)

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(('127.0.0.1', BRIDGE_PORT))
    server.listen(1)

    su_test = subprocess.run(["adb", "-s", serial, "shell", "which su"], capture_output=True, text=True)
    has_su = bool(su_test.stdout.strip())

    tcpdump_filter = "tcp and (portrange 4000-4300 or portrange 10000-10100)"
    if has_su:
        inner = f"su -c 'tcpdump -i any -l -U -s 0 -w - \"{tcpdump_filter}\" 2>/dev/null | toybox nc 127.0.0.1 {BRIDGE_PORT}'"
    else:
        inner = f"tcpdump -i any -l -U -s 0 -w - \"{tcpdump_filter}\" 2>/dev/null | toybox nc 127.0.0.1 {BRIDGE_PORT}"

    proc = subprocess.Popen(["adb", "-s", serial, "shell", inner], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    server.settimeout(12.0)
    try:
        conn, addr = server.accept()
    except socket.timeout:
        proc.kill()
        server.close()
        raise TimeoutError("فشل الاتصال بالمحاكي! تأكد من تشغيل المحاكي وصلاحيات Root.")

    conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    server.close()
    return conn, proc

# ═════════════════════════════════════════════════════════════════════════════
# 8. خيط Frida الذكي للتحقق الرياضي من مفتاح DES
# ═════════════════════════════════════════════════════════════════════════════
def start_frida_login_worker(serial: str):
    """التقاط مفتاح DES من الذاكرة والتحقق منه رياضياً باستخدام LAST_CHALLENGE و LAST_HMAC"""
    if not HAS_FRIDA:
        return

    def _worker():
        while True:
            try:
                # معرف العملية
                res = subprocess.run(f"adb -s {serial} shell pidof {PACKAGE_NAME}", shell=True, capture_output=True, text=True)
                pid_str = res.stdout.strip()
                if not pid_str:
                    time.sleep(2)
                    continue
                pid = int(pid_str.split()[0])

                frida_code = """
                (function() {
                    var scanned = false;
                    function scanKey() {
                        var pattern = '08 00 00 00 ?? ?? ?? ?? ?? ?? ?? ?? 00';
                        Process.enumerateRanges('rw-').forEach(function(r) {
                            if (r.size < 4096 || r.size > 16*1024*1024) return;
                            try {
                                Memory.scan(r.base, r.size, pattern, {
                                    onMatch: function(addr, sz) {
                                        try {
                                            var k = addr.add(4).readByteArray(8);
                                            send({type: 'CAND_KEY'}, k);
                                        } catch(e){}
                                    },
                                    onError: function(){},
                                    onComplete: function(){}
                                });
                            } catch(e){}
                        });
                    }

                    // مسح دوري كل 3 ثوان
                    setInterval(function() {
                        scanKey();
                    }, 3000);
                })();
                """

                dev = frida.get_device_manager().get_device(serial)
                session = dev.attach(pid)
                scr = session.create_script(frida_code)

                def on_msg(msg, data):
                    global ACTIVE_DES_KEY, LAST_CHALLENGE, LAST_HMAC
                    if msg.get('type') == 'send' and data:
                        raw8 = bytes(data)
                        if len(raw8) == 8 and len(set(raw8)) >= 4:
                            # 1. إذا توفر التحدي و HMAC: تحقق رياضي قاطع 100%!
                            if LAST_CHALLENGE and LAST_HMAC:
                                if hmac64(LAST_CHALLENGE, raw8) == LAST_HMAC:
                                    if raw8 != ACTIVE_DES_KEY:
                                        save_active_key(raw8)
                                        print_box(
                                            title="تم التحقق الرياضي القاطع من مفتاح التشفير النشط [DES KEY VERIFIED]",
                                            lines=[
                                                f"🔐 المفتاح النشط: {raw8.hex()}",
                                                "✓ تطابق تام 100% مع hmac64(challenge, key) == hmac",
                                                "💾 تم حفظ المفتاح تلقائياً لاستخدامه في فك التشفير الصريح!"
                                            ],
                                            color_tag="KEY SUCCESS"
                                        )

                scr.on('message', on_msg)
                scr.load()
                out("[+] هوك Frida للتحقق من مفتاح التشفير نشط بنجاح.")
                while True:
                    time.sleep(4)
                    res_check = subprocess.run(f"adb -s {serial} shell pidof {PACKAGE_NAME}", shell=True, capture_output=True, text=True)
                    if not res_check.stdout.strip():
                        break
            except Exception:
                time.sleep(3)

    t = threading.Thread(target=_worker, daemon=True)
    t.start()

# ═════════════════════════════════════════════════════════════════════════════
# 9. الدالة الرئيسية (Main Loop)
# ═════════════════════════════════════════════════════════════════════════════
def get_adb_device() -> str:
    try:
        res = subprocess.run("adb devices", shell=True, capture_output=True, text=True)
        lines = [line.split()[0] for line in res.stdout.splitlines()[1:] if '\tdevice' in line]
        for dev in lines:
            if '5554' in dev: return dev
        if lines: return lines[0]
    except Exception:
        pass
    return "emulator-5554"

def main():
    global log_f, ACTIVE_DES_KEY

    parser = argparse.ArgumentParser(description="مراقب تسجيل الدخول وتبديل الحسابات (انتقام السلاطين)")
    parser.add_argument('--device', type=str, default="", help='معرف جهاز المحاكي (افتراضي تلقائي)')
    parser.add_argument('--no-frida', action='store_true', help='تعطيل مساعد Frida')
    args = parser.parse_args()

    serial = args.device if args.device else get_adb_device()
    log_f = open(LOG_FILE, 'w', encoding='utf-8')

    print_banner(serial)

    # تحميل المفتاح المحفوظ مسبقاً إن وُجد
    for k_p in (LOCAL_KEY_FILE, CORE_KEY_FILE):
        if os.path.exists(k_p):
            try:
                with open(k_p, "rb") as kf:
                    k_b = kf.read()
                    if len(k_b) == 8:
                        ACTIVE_DES_KEY = k_b
                        out(f"[*] تم تحميل مفتاح جلسة سابق: {k_b.hex()}\n")
                        break
            except Exception:
                pass

    # تشغيل مراقب SdkEmail في خيط منفصل
    t_sdk = threading.Thread(target=sdk_email_watcher, args=(serial,), daemon=True)
    t_sdk.start()

    # تشغيل Frida إن لم يتم تعطيله
    if not args.no_frida and HAS_FRIDA:
        start_frida_login_worker(serial)

    out("[*] جارٍ تأسيس جسر التقاط الحزم مع المحاكي...")
    try:
        conn, proc = start_stream_bridge(serial)
    except Exception as e:
        out(f"[!] فشل بدء المراقب: {e}")
        return

    out("[+] تم الاتصال بالجسر بنجاح! يتم الآن رصد واعتراض طلبات الدخول والتبديل...")
    out("    (قم الآن بالذهاب إلى شاشة تبديل الحساب داخل اللعبة)\n")

    try:
        pcap_hdr = read_exact(conn, 24)
        magic = pcap_hdr[:4]
        little_endian = (magic in (b'\xd4\xc3\xb2\xa1', b'\x4d\x3c\xb2\xa1'))
        order = '<' if little_endian else '>'
        link_type = struct.unpack(f'{order}I', pcap_hdr[20:24])[0]
        link_hdr_len = 20 if link_type == 276 else (14 if link_type == 1 else 16)

        # مخازن تدفق البيانات المنفصلة لكل اتصال لضمان عدم اختلاط الحزم نهائياً
        login_parser = LoginServerParser()
        login_send_buf = bytearray()
        login_recv_buf = bytearray()
        gate_send_buf  = bytearray()
        gate_recv_buf  = bytearray()

        while True:
            hdr_raw = read_exact(conn, 16)
            ts_sec, ts_usec, incl_len, orig_len = struct.unpack(f'{order}IIII', hdr_raw)
            pkt_data = read_exact(conn, incl_len)

            if len(pkt_data) < link_hdr_len + 40:
                continue

            ip_hdr = pkt_data[link_hdr_len:link_hdr_len+20]
            if (ip_hdr[0] >> 4) != 4:
                continue

            ihl = (ip_hdr[0] & 0x0F) * 4
            if ip_hdr[9] != 6: # TCP فقط
                continue

            tcp_offset = link_hdr_len + ihl
            if len(pkt_data) < tcp_offset + 20:
                continue

            tcp_hdr = pkt_data[tcp_offset:tcp_offset+20]
            src_port, dst_port = struct.unpack('>HH', tcp_hdr[:4])
            data_offset = ((tcp_hdr[12] >> 4) & 0x0F) * 4
            payload = pkt_data[tcp_offset + data_offset:]

            if not payload:
                continue

            # ─────────────────────────────────────────────────────────────
            # 1. تدفق خادم تسجيل الدخول (Port 10000 - kohlogin)
            # ─────────────────────────────────────────────────────────────
            if src_port == 10000 or (10000 <= src_port <= 10100):
                # رد وارد من خادم تسجيل الدخول (RECV)
                login_recv_buf.extend(payload)
                while b'\n' in login_recv_buf:
                    idx = login_recv_buf.index(b'\n')
                    line = login_recv_buf[:idx].decode('utf-8', errors='replace').rstrip('\r')
                    del login_recv_buf[:idx + 1]
                    if line:
                        login_parser.handle_line('RECV', line)

            elif dst_port == 10000 or (10000 <= dst_port <= 10100):
                # طلب صادر إلى خادم تسجيل الدخول (SEND)
                login_send_buf.extend(payload)
                while b'\n' in login_send_buf:
                    idx = login_send_buf.index(b'\n')
                    line = login_send_buf[:idx].decode('utf-8', errors='replace').rstrip('\r')
                    del login_send_buf[:idx + 1]
                    if line:
                        login_parser.handle_line('SEND', line)

            # ─────────────────────────────────────────────────────────────
            # 2. تدفق خادم البوابة (Port 4000-4300 / 4060)
            # ─────────────────────────────────────────────────────────────
            elif (4000 <= src_port <= 4300) or src_port == 4060:
                # رد وارد من خادم البوابة (RECV)
                gate_recv_buf.extend(payload)
                while len(gate_recv_buf) >= 2:
                    sz = gate_recv_buf[0] * 256 + gate_recv_buf[1]
                    head_len = 2
                    if sz == 0xFFFF:
                        if len(gate_recv_buf) < 5: break
                        sz = gate_recv_buf[2]*65536 + gate_recv_buf[3]*256 + gate_recv_buf[4]
                        head_len = 5
                    total_len = head_len + sz
                    if len(gate_recv_buf) < total_len:
                        break
                    frame = bytes(gate_recv_buf[head_len:total_len])
                    del gate_recv_buf[:total_len]
                    handle_gate_frame('RECV', frame, src_port)

            elif (4000 <= dst_port <= 4300) or dst_port == 4060:
                # طلب صادر إلى خادم البوابة (SEND)
                gate_send_buf.extend(payload)
                while len(gate_send_buf) >= 2:
                    sz = gate_send_buf[0] * 256 + gate_send_buf[1]
                    head_len = 2
                    if sz == 0xFFFF:
                        if len(gate_send_buf) < 5: break
                        sz = gate_send_buf[2]*65536 + gate_send_buf[3]*256 + gate_send_buf[4]
                        head_len = 5
                    total_len = head_len + sz
                    if len(gate_send_buf) < total_len:
                        break
                    frame = bytes(gate_send_buf[head_len:total_len])
                    del gate_send_buf[:total_len]
                    handle_gate_frame('SEND', frame, dst_port)

    except KeyboardInterrupt:
        out(f"\n[*] تم إيقاف المراقب. تم حفظ السجل في: {LOG_FILE}")
    except Exception as e:
        out(f"\n[!] حدث خطأ أثناء المراقبة: {e}")
    finally:
        try: proc.kill()
        except Exception: pass
        try: conn.close()
        except Exception: pass
        if log_f:
            try: log_f.close()
            except Exception: pass

if __name__ == '__main__':
    main()
