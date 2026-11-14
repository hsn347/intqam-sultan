#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
send_cmd.py — أداة إرسال الأوامر المباشرة المشفرة (انتقام السلاطين)
═══════════════════════════════════════════════════════════════════════
مطابق تماماً لمشروع العثمانية (E:\\osmanli) ويعتمد على العميل الموحد (core.game_client).
يعمل عبر بروتوكول البوابة المشفر مباشرة — بدون أي محاكي أو ADB أو Frida.
"""

import sys
import os
import re
import json
import argparse

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR   = os.path.dirname(SCRIPT_DIR)
CORE_DIR   = os.path.join(ROOT_DIR, "core")

for _p in (ROOT_DIR, CORE_DIR):
    if _p not in sys.path:
        sys.path.insert(0, _p)

try:
    from core.game_client import RosClient, ERROR_CODES, SessionCache
except ImportError:
    from core.game_client import RosClient, ERROR_CODES, SessionCache

JS_FILE = os.path.join(SCRIPT_DIR, "simple_cmd.js")

def read_cmd_from_js():
    cmd, sub, data = "1005", "2", {
        "isget": False,
        "armycount": "100",
        "bid": "117",
        "mode": "0",
        "armyid": "609"
    }
    if not os.path.exists(JS_FILE):
        return cmd, sub, data
    try:
        with open(JS_FILE, "r", encoding="utf-8") as f:
            txt = f.read()
        m = re.search(r"^var\s+CMD\s*=\s*'(\w+)'", txt, re.MULTILINE)
        if m: cmd = m.group(1)
        m = re.search(r"^var\s+SUBCMD\s*=\s*'(\w+)'", txt, re.MULTILINE)
        if m: sub = m.group(1)
        m = re.search(r"^var\s+DATA\s*=\s*(\{[\s\S]*?\});", txt, re.MULTILINE)
        if m: data = json.loads(m.group(1))
    except Exception:
        pass
    return cmd, sub, data

def main():
    parser = argparse.ArgumentParser(description="أداة إرسال أوامر انتقام السلاطين المباشرة (بدون محاكي)")
    parser.add_argument("--cmd",   type=str, default="", help="معرف الأمر الأساسي")
    parser.add_argument("--sub",   type=str, default="", help="معرف الأمر الفرعي")
    parser.add_argument("--data",  type=str, default="", help="بيانات الطلب بصيغة JSON")
    parser.add_argument("--email", type=str, default="", help="تحديد حساب معين من session_cache.json")
    parser.add_argument("--list",  action="store_true",  help="عرض الحسابات المسجلة")
    args = parser.parse_args()

    if args.list:
        accs = SessionCache.load_all()
        print("\n" + "=" * 60)
        print("  📋 الحسابات المتاحة في session_cache.json:")
        print("=" * 60)
        for i, (em, d) in enumerate(accs.items(), 1):
            print(f" [{i}] {em} (UID: {d.get('userId')})")
        print("=" * 60 + "\n")
        return

    print("=" * 60)
    print("  📡 أداة تنفيذ الأوامر المباشرة المشفرة (انتقام السلاطين)")
    print("=" * 60)

    def_cmd, def_sub, def_data = read_cmd_from_js()
    cmd  = args.cmd  or def_cmd
    sub  = args.sub  or def_sub
    data = json.loads(args.data) if args.data else def_data

    print(f"[*] cmd={cmd} | subcmd={sub}")
    print(f"[*] data={json.dumps(data, ensure_ascii=False)}")

    try:
        client = RosClient(email=args.email or None)
        print(f"[*] الحساب المعتمد: {client.email}")
        resps = client.execute_command(cmd, sub, data)
        print("\n" + "=" * 60)
        print("  📡 نتيجة تنفيذ الطلب من السيرفر:")
        print("=" * 60)
        matched = False
        for r in (resps or []):
            if str(r.get("cmd")) == str(cmd):
                matched = True
                err = str(r.get("err", "0"))
                err_desc = ERROR_CODES.get(err, f"كود غير معروف ({err})")
                print(f"[+] كود الحالة: {err} -> {err_desc}")
                print(f"[+] الرد الكامل: {json.dumps(r, ensure_ascii=False, indent=2)}")
            elif "notifyID" in str(r):
                print(f"[*] إشعار سيرفر: {json.dumps(r, ensure_ascii=False)}")
        if not matched and not resps:
            print("[!] لم يتم استلام رد، قد يكون الأمر تم بدون إشعار أو انتهت المهلة.")
        client.close()
    except Exception as e:
        print(f"[-] خطأ أثناء تنفيذ الأمر: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
