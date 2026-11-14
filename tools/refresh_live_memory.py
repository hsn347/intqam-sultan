# -*- coding: utf-8 -*-
"""
refresh_live_memory.py — أداة تجديد وتحديث ملفات تفريغ الذاكرة الحية (Live Memory Dumper)
══════════════════════════════════════════════════════════════════════════════════════

تتيح هذه الأداة استخراج الذاكرة الحية لأي حساب وتحديث ملفات الـ JSON في مجلد docs/ تلقائياً.
يمكن تمرير مسار ملف JSON قائم ليتم تجديده، أو تمرير بريد الحساب ليتم استخراج ذاكرته،
أو تشغيل الأداة مباشرة بدون وسائط لتحديث حساب Lucifer الافتراضي أو الاختيار من القائمة.

أمثلة على الاستخدام من سطر الأوامر:
  1. تجديد ملف موجود بالفعل في docs/:
     python refresh_live_memory.py docs/lucifer_live_memory.json
     أو:
     python refresh_live_memory.py lucifer_live_memory.json

  2. استخراج الذاكرة عبر تحديد البريد مباشرة:
     python refresh_live_memory.py LUCIFER@g4.com
     أو:
     python refresh_live_memory.py beetoo3@hotmail.com

  3. تحديد مسار مخصص لحفظ الملف الناتج:
     python refresh_live_memory.py LUCIFER@g4.com -o docs/my_dump.json

  4. عرض قائمة الحسابات والملفات المتاحة في المشروع:
     python refresh_live_memory.py --list
"""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import re
import sqlite3
import sys
import time
from typing import Any, Dict, List, Optional, Tuple

from bot_manager import CastleBot

WORKSPACE_DIR = os.path.dirname(os.path.abspath(__file__))
DOCS_DIR = os.path.join(WORKSPACE_DIR, "docs")
DB_PATH = os.path.join(WORKSPACE_DIR, "database", "castles.db")


# ════════════════════════════════════════════════════════════════════
#  مساعدات فحص قاعدة البيانات وملفات الـ JSON
# ════════════════════════════════════════════════════════════════════

def get_all_db_accounts() -> List[Dict[str, Any]]:
    """جلب كافة الحسابات المسجلة في قاعدة بيانات القلاع"""
    accounts = []
    if not os.path.exists(DB_PATH):
        return accounts

    try:
        conn = sqlite3.connect(DB_PATH)
        cur = conn.cursor()
        cur.execute("SELECT email, password, is_active, castle_info FROM castle_states")
        for row in cur.fetchall():
            email, pwd, active, c_info = row
            info_dict = {}
            if c_info:
                try:
                    info_dict = json.loads(c_info) if isinstance(c_info, str) else c_info
                except Exception:
                    pass
            accounts.append({
                "email": email,
                "password": pwd,
                "is_active": bool(active),
                "lord_name": info_dict.get("lord_name", ""),
                "castle_name": info_dict.get("castle_name", ""),
                "kid": info_dict.get("kid", 0),
            })
        conn.close()
    except Exception as e:
        print(f"⚠️ خطأ أثناء قراءة قاعدة البيانات: {e}")

    return accounts


def get_existing_docs_dumps() -> List[Dict[str, Any]]:
    """جلب كافة ملفات تفريغ الذاكرة الحية الموجودة في مجلد docs/"""
    dumps = []
    if not os.path.exists(DOCS_DIR):
        return dumps

    for fname in os.listdir(DOCS_DIR):
        if fname.endswith(".json"):
            full_path = os.path.join(DOCS_DIR, fname)
            size_kb = os.path.getsize(full_path) / 1024
            mtime = os.path.getmtime(full_path)
            time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(mtime))
            
            # محاولة قراءة بيانات اللورد من الملف
            lord_name = ""
            uid = ""
            try:
                with open(full_path, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    lord_info = data.get("lordInfoCtrl", {})
                    base = lord_info.get("base", {}) if isinstance(lord_info, dict) else {}
                    lord_name = base.get("nickName") or base.get("name") or ""
                    uid = str(base.get("uid", ""))
                    if not uid:
                        lord = data.get("lord", {})
                        uid = str(lord.get("uid", ""))
            except Exception:
                pass

            dumps.append({
                "filename": fname,
                "path": full_path,
                "size_kb": size_kb,
                "mtime": time_str,
                "lord_name": lord_name,
                "uid": uid,
            })
    return dumps


def resolve_account_and_output(target: Optional[str], custom_out: Optional[str] = None) -> Tuple[str, str, str]:
    """
    تحليل المدخل بذكاء لتحديد (البريد الإلكتروني، كلمة المرور، ومسار ملف الحفظ):
    - إذا كان target مسار ملف JSON: يكتشف الحساب المناسب ويحدد نفس الملف كوجهة.
    - إذا كان target بريد أو اسم حساب: يحدد الحساب وينشئ اسم ملف في docs/.
    - إذا كان target فارغاً: يختار أول حساب نشط (أو LUCIFER).
    """
    accounts = get_all_db_accounts()
    if not accounts:
        raise ValueError("❌ لم يتم العثور على أي حسابات في قاعدة البيانات database/castles.db!")

    # 1. إذا تم تمرير مسار ملف .json
    if target and (target.lower().endswith(".json") or os.path.exists(target)):
        file_path = target if os.path.isabs(target) else os.path.join(DOCS_DIR, os.path.basename(target))
        if not os.path.exists(file_path) and os.path.exists(target):
            file_path = os.path.abspath(target)

        # استخراج بيانات من الملف القديم إن وُجد لمطابقته
        matched_acc = None
        if os.path.exists(file_path):
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    old_data = json.load(f)
                    lord_info = old_data.get("lordInfoCtrl", {})
                    base = lord_info.get("base", {}) if isinstance(lord_info, dict) else {}
                    lord_name = str(base.get("nickName") or base.get("name") or "").lower()
                    lord_uid = str(base.get("uid") or old_data.get("lord", {}).get("uid", ""))
                    
                    # مطابقة عبر UID أو اسم اللورد مع حسابات القاعدة
                    for acc in accounts:
                        acc_lord = str(acc.get("lord_name", "")).lower()
                        if lord_name and acc_lord and (lord_name == acc_lord or lord_name in acc_lord or acc_lord in lord_name):
                            matched_acc = acc
                            break
            except Exception:
                pass

        # إذا لم يتطابق من داخل الملف، نطابق باسم الملف نفسه
        if not matched_acc:
            base_stem = os.path.splitext(os.path.basename(file_path))[0].lower()
            clean_stem = base_stem.replace("_live_memory", "").replace("sample_", "")
            for acc in accounts:
                email_prefix = acc["email"].split("@")[0].lower()
                if clean_stem in email_prefix or email_prefix in clean_stem:
                    matched_acc = acc
                    break
                if clean_stem in str(acc.get("lord_name", "")).lower():
                    matched_acc = acc
                    break

        if not matched_acc:
            # افتراض الحساب النشط أو الأول
            matched_acc = next((a for a in accounts if a["is_active"]), accounts[0])

        return matched_acc["email"], matched_acc["password"], file_path

    # 2. إذا تم تمرير بريد أو اسم حساب
    if target:
        target_clean = target.strip().lower()
        matched_acc = None
        for acc in accounts:
            if acc["email"].lower() == target_clean:
                matched_acc = acc
                break
            if acc["email"].split("@")[0].lower() == target_clean:
                matched_acc = acc
                break
            if target_clean in str(acc.get("lord_name", "")).lower():
                matched_acc = acc
                break

        if not matched_acc:
            raise ValueError(f"❌ لم يتم العثور على حساب يطابق '{target}' في قاعدة البيانات!")

        # مسار الملف الافتراضي
        out_path = custom_out
        if not out_path:
            prefix = matched_acc["email"].split("@")[0].lower()
            # فحص إذا كان هناك ملف مخصص موجود مسبقاً لهذا الحساب
            candidate = os.path.join(DOCS_DIR, f"{prefix}_live_memory.json")
            out_path = candidate

        return matched_acc["email"], matched_acc["password"], os.path.abspath(out_path)

    # 3. إذا لم يمرر المستخدم أي وسيط (الافتراضي: الحساب النشط الحالي)
    active_acc = next((a for a in accounts if a["is_active"] and "lucifer" in a["email"].lower()), None)
    if not active_acc:
        active_acc = next((a for a in accounts if a["is_active"]), accounts[0])

    prefix = active_acc["email"].split("@")[0].lower()
    default_out = os.path.join(DOCS_DIR, f"{prefix}_live_memory.json")
    return active_acc["email"], active_acc["password"], os.path.abspath(default_out)


# ════════════════════════════════════════════════════════════════════
#  عملية استخراج وتحديث الذاكرة الحية
# ════════════════════════════════════════════════════════════════════

async def refresh_live_memory(email: str, password: str, output_path: str, fetch_lazy: bool = True) -> bool:
    """
    الاتصال بالبوابة الرسمية للحساب، تفريغ الذاكرة الحية وتحديث الوحدات الكسولة، ثم حفظها في ملف JSON
    """
    start_time = time.time()
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    prev_size_kb = 0.0
    if os.path.exists(output_path):
        prev_size_kb = os.path.getsize(output_path) / 1024.0

    print(f"\n📡 بدء الاتصال بالبوابة الرسمية لتجديد الذاكرة الحية...")
    print(f"   📧 الحساب: {email}")
    print(f"   🎯 مسار الإخراج: {output_path}")

    bot = CastleBot(email=email, password=password)

    try:
        # الاتصال بالحساب (يستفيد تلقائياً من session_cache.json إن وُجد)
        connected = await bot.connect()
        if not connected or not bot.conn:
            print("❌ فشل الاتصال بالبوابة أو مصافحة تسجيل الدخول.")
            return False

        # انتظار تفريغ الـ 277+ متحكم في الذاكرة الحية (CMD 1000)
        try:
            await asyncio.wait_for(bot.conn.controllers_ready.wait(), timeout=12.0)
        except asyncio.TimeoutError:
            print("⚠️ مهلة استقبال متحكمات القلعة انتهت، سيتم استخدام ما وصل بالفعل.")

        live_data = bot.conn.init_data
        ctrl_count = len(live_data)
        print(f"✓ تم استلام وتفريغ {ctrl_count} متحكم في الذاكرة الحية بنجاح.")

        # استخراج بيانات اللورد والقلعة بدقة (من lordInfoCtrl و cityCtrl)
        lord_info = live_data.get("lordInfoCtrl", {})
        base = lord_info.get("base", {}) if isinstance(lord_info, dict) else {}
        lord_name = base.get("nickName") or base.get("name") or "Unknown"
        lord_level = int(base.get("level", 0))

        city_ctrl = live_data.get("cityCtrl", {})
        castle_level = int(city_ctrl.get("level", 1)) if isinstance(city_ctrl, dict) else 1
        blist = city_ctrl.get("blist", []) if isinstance(city_ctrl, dict) else []
        if isinstance(blist, list):
            for b in blist:
                if isinstance(b, dict):
                    binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
                    if str(binfo.get("bid", "")) == "101":
                        castle_level = int(binfo.get("lv", castle_level))
                        break

        uid = bot.creds.uid if bot.creds else base.get("uid", "")
        kid = bot.creds.kingdom_id if bot.creds else base.get("kid", "")

        # التحقق من عضوية التحالف
        alliance_ctrl = live_data.get("allianceCtrl", {})
        minfo = alliance_ctrl.get("memberinfo", {}).get("minfo", {}) if isinstance(alliance_ctrl, dict) else {}
        aid = int(minfo.get("aid", 0)) if isinstance(minfo, dict) else 0

        # جلب بيانات كنز التحالف (Lazy Load عبر CMD 2015 SubCMD 1) لملء allianceTreasureCtrl
        if fetch_lazy and aid > 0:
            print("📦 جلب بيانات كنز التحالف الميدانية (CMD 2015 / 1) لتضمينها في الذاكرة...")
            try:
                res_treasure = await bot.conn.query("2015", "1")
                if res_treasure and str(res_treasure.get("err", "")) in ("0", 0):
                    rspdata = res_treasure.get("rspdata") or res_treasure.get("data") or {}
                    live_data["allianceTreasureCtrl"] = rspdata
                    print("   ✓ تم تحديث بيانات `allianceTreasureCtrl` بالكامل بنجاح.")
                else:
                    err_c = res_treasure.get("err") if res_treasure else "none"
                    print(f"   ⚠️ استجابة كنز التحالف بكود غير صفري: {err_c}")
            except Exception as e:
                print(f"   ⚠️ تعذر جلب كنز التحالف: {e}")

        saved_ctrl_count = len(live_data)

        # حفظ الذاكرة الحية بصيغة JSON منسق ونظيف
        print(f"💾 جاري كتابة ملف الذاكرة الحية الجديد إلى القرص...")
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(live_data, f, indent=2, ensure_ascii=False)

        elapsed = time.time() - start_time
        new_size_kb = os.path.getsize(output_path) / 1024.0

        # إغلاق الاتصال بأمان
        if bot.conn:
            await bot.conn.close()

        # طباعة التقرير النهائي
        print("\n" + "═" * 78)
        print(" 🎉 اكتمل تجديد واستخراج الذاكرة الحية بنجاح!")
        print("═" * 78)
        print(f" 🏰 اللورد: {lord_name} (Lv.{lord_level}) | القصر: Lv.{castle_level} | المملكة: {kid} | UID: {uid}")
        print(f" 🏛️ التحالف: {'AID=' + str(aid) if aid > 0 else 'بدون تحالف'}")
        print(f" 📊 عدد المتحكمات المحفوظة: {saved_ctrl_count} متحكم")
        if prev_size_kb > 0:
            print(f" 📦 حجم الملف: {new_size_kb:.1f} KB (الحجم السابق: {prev_size_kb:.1f} KB)")
        else:
            print(f" 📦 حجم الملف الجديد: {new_size_kb:.1f} KB")
        print(f" ⏱️ استغرق التحديث: {elapsed:.2f} ثانية")
        print(f" 📁 المسار: {output_path}")
        print("═" * 78 + "\n")
        return True

    except Exception as e:
        print(f"\n❌ حدث خطأ غير متوقع أثناء تفريغ الذاكرة: {e}")
        import traceback
        traceback.print_exc()
        if bot.conn:
            try:
                await bot.conn.close()
            except Exception:
                pass
        return False


# ════════════════════════════════════════════════════════════════════
#  نقطة الدخول الرئيسية (CLI Interface)
# ════════════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="أداة تجديد واستخراج الذاكرة الحية للعبة (Live Memory Refresh Utility)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "target",
        nargs="?",
        default=None,
        help="مسار ملف JSON موجود للتجديد (مثل: docs/lucifer_live_memory.json) أو بريد الحساب (مثل: LUCIFER@g4.com)",
    )
    parser.add_argument(
        "-e", "--email",
        type=str,
        default=None,
        help="تحديد بريد الحساب صراحة",
    )
    parser.add_argument(
        "-o", "--output",
        type=str,
        default=None,
        help="مسار ملف الإخراج المخصص (افتراضياً: docs/<name>_live_memory.json)",
    )
    parser.add_argument(
        "--no-lazy",
        action="store_true",
        help="تعطيل جلب الوحدات الكسولة الإضافية (مثل كنز التحالف)",
    )
    parser.add_argument(
        "-l", "--list",
        action="store_true",
        help="عرض قائمة الحسابات والملفات المتاحة في المشروع فقط",
    )

    args = parser.parse_args()

    # إذا طُلبت القائمة فقط
    if args.list:
        print("\n📋 الحسابات المسجلة في قاعدة البيانات:")
        accounts = get_all_db_accounts()
        for i, acc in enumerate(accounts, 1):
            act_str = "🟢 نشط" if acc["is_active"] else "⚪ متوقف"
            print(f"   {i}. {acc['email']} | اللورد: {acc['lord_name']} (K:{acc['kid']}) | {act_str}")

        print("\n📁 ملفات الذاكرة الحية الموجودة في مجلد docs/:")
        dumps = get_existing_docs_dumps()
        if not dumps:
            print("   (لا توجد ملفات حالياً)")
        for d in dumps:
            print(f"   • {d['filename']} ({d['size_kb']:.1f} KB) - معدل: {d['mtime']} | اللورد: {d['lord_name']}")
        print()
        return

    target = args.email or args.target

    try:
        email, password, output_path = resolve_account_and_output(target, args.output)
    except Exception as e:
        print(f"\n{e}\n")
        sys.exit(1)

    fetch_lazy = not args.no_lazy
    asyncio.run(refresh_live_memory(email, password, output_path, fetch_lazy=fetch_lazy))


if __name__ == "__main__":
    main()
