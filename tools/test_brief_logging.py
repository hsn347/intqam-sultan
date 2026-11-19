# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import asyncio
from core.game_client import (
    get_cmd_metadata,
    is_query_success,
    GameConnection,
    AccountSession,
    GateCredentials,
)
from bot_manager import TASK_METADATA

def test_metadata():
    print("🧪 1. اختبار استخراج البيانات الوصفية (Metadata Test):")
    samples = [
        ("1001", "8", None, "🌾", "حصد الموارد"),
        ("1001", "8", {"bid": 201, "iid": 1}, "🌾", "حصد الموارد"),
        ("1005", "2", {"id": 101, "num": 100}, "⚔️", "تدريب الجنود"),
        ("1005", "4", {}, "🏥", "علاج الجرحى"),
        ("1005", "5", {}, "🎖️", "استلام الجنود"),
        ("1010", "44", {}, "🤝", "مساعدة التحالف"),
        ("1010", "48", {}, "🔬", "تبرع علوم التحالف"),
        ("1010", "45", {}, "🤝", "طلب مساعدة التحالف"),
        ("2015", "1", {}, "💎", "استعلام كنز التحالف"),
        ("2015", "6", {}, "🎁", "استلام كنز التحالف"),
        ("1004", "2", {"itemID": "100201"}, "🌾", "فتح صناديق موارد"),
        ("1004", "2", {"itemID": "200001"}, "⚡", "استخدام حزم الطاقة"),
        ("1004", "2", {"itemID": "100001"}, "🛡️", "تفعيل درع السلام"),
        ("1034", "2", {"shopItemID": "1000046"}, "⚡", "شراء طاقة بالذهب"),
        ("1034", "2", {"shopItemID": "100001"}, "🛡️", "شراء درع بالذهب"),
        ("1003", "1", {}, "🏰", "ترقية مبنى"),
        ("1017", "2", {}, "🔬", "بحث الأكاديمية"),
        ("1033", "2", {}, "⚓", "استلام الميناء"),
        ("1032", "2", {}, "🚢", "تبادل سفينة التجار"),
        ("1018", "2", {}, "🎰", "تدوير عجلة الحظ"),
        ("1045", "3", {}, "🎲", "رمي نرد الضريح"),
        ("1045", "5", {}, "🎁", "جوائز الضريح"),
        ("1059", "2", {}, "🗡️", "غارة محاكمة الأبطال"),
        ("2274", "2", {}, "⬆️", "ترقية قاعة القيادة"),
        ("2274", "8", {}, "🎁", "استلام جوائز مهمة القيادة"),
        ("2274", "9", {}, "🗺️", "تحديث موقع هدف القيادة"),
        ("9999", "1", {}, "📡", "أمر سيرفر"),
    ]
    for cmd, subcmd, data, exp_emoji, exp_desc in samples:
        emoji, desc = get_cmd_metadata(cmd, subcmd, data)
        assert emoji == exp_emoji, f"Mismatch emoji for {cmd}/{subcmd}: got {emoji}, expected {exp_emoji}"
        assert desc == exp_desc, f"Mismatch desc for {cmd}/{subcmd}: got {desc}, expected {exp_desc}"
        print(f"  {emoji} {desc} ({cmd}/{subcmd}) -> OK")
    print("  ✓ كافة اختبارات البيانات الوصفية نجحت بنسبة 100%!\n")

def test_query_success_detection():
    print("🧪 2. اختبار كشف النجاح والفشل (Success & Failure Detection):")
    # حالة النجاح
    ok_samples = [
        {"err": 0, "cmd": "1001"},
        {"err": "0", "cmd": "1001"},
        {"code": 0, "cmd": "1001"},
        {"code": "Err_None", "cmd": "1001"},
        {"cmd": "1003", "subcmd": "1"},
        {"data": {"err": 0}},
    ]
    for s in ok_samples:
        suc, err = is_query_success(s)
        assert suc is True, f"Expected success for {s}"
        assert err is None
    print("  ✓ حالات النجاح تم التعرف عليها بدقة (Status: True).")

    # حالة الفشل
    fail_samples = [
        ({"err": 4002}, "4002"),
        ({"err": "1"}, "1"),
        ({"code": "105"}, "105"),
        ({"_ok": False}, "packet_err"),
        (None, "timeout"),
        ({"data": {"err": 4004}}, "4004"),
    ]
    for s, exp_err in fail_samples:
        suc, err = is_query_success(s)
        assert suc is False, f"Expected failure for {s}"
        assert err == exp_err, f"Expected {exp_err}, got {err}"
    print("  ✓ حالات الفشل وأكواد الخطأ تم التعرف عليها بدقة (Status: False).\n")

async def test_game_conn_brief_logs():
    print("🧪 3. اختبار طباعة السجلات الحية لـ GameConnection (Live Simulated Flow):")
    acc = AccountSession(email="beetoo1@hotmail.com", user_id="12345", session_id="abc")
    creds = GateCredentials(
        kingdom_id="1",
        server_name="k1",
        gate_ip="127.0.0.1",
        gate_port=8000,
        sub_id="1",
        uid="12345",
        secret=b"testsecret123456",
    )
    conn = GameConnection(acc, creds)
    captured = []
    conn.brief_log_callback = lambda line: captured.append(line)

    # 1. محاكاة أمر استعلام ناجح
    # سنحقن استجابة سريعة في Future
    conn._alive = True
    class MockWriter:
        def write(self, data): pass
        async def drain(self): pass
    conn._writer = MockWriter()

    async def mock_recv_ok():
        while not conn._pending:
            await asyncio.sleep(0.005)
        sess_id = list(conn._pending.keys())[-1]
        entry = conn._pending[sess_id]
        fut = entry[1]
        if not fut.done():
            fut.set_result({"err": 0, "cmd": "1001", "subcmd": "8"})

    asyncio.create_task(mock_recv_ok())
    res = await conn.query("1001", "8", {"bid": 201, "iid": 1})
    assert res is not None

    # 2. محاكاة أمر استعلام فاشل بكود سيرفر
    async def mock_recv_fail():
        while not conn._pending:
            await asyncio.sleep(0.005)
        sess_id = list(conn._pending.keys())[-1]
        entry = conn._pending[sess_id]
        fut = entry[1]
        if not fut.done():
            fut.set_result({"err": 4002, "cmd": "1005", "subcmd": "2"})

    asyncio.create_task(mock_recv_fail())
    res_fail = await conn.query("1005", "2", {"id": 101, "num": 100})
    assert res_fail is not None

    # 3. محاكاة نبض القلب 1037 (يجب ألا يظهر أبداً)
    async def mock_recv_hb():
        while not conn._pending:
            await asyncio.sleep(0.005)
        sess_id = list(conn._pending.keys())[-1]
        entry = conn._pending[sess_id]
        fut = entry[1]
        if not fut.done():
            fut.set_result({"err": 0, "cmd": "1037", "subcmd": "2"})

    asyncio.create_task(mock_recv_hb())
    res_hb = await conn.query("1037", "2", {})

    print("\n📋 السجلات الملتقطة من الكولباك:")
    for line in captured:
        print(f"  Captured -> {line}")

    # التحقق
    assert len(captured) == 2, f"Expected 2 lines, got {len(captured)} (Heartbeat might not be skipped!)"
    assert "🌾 [beetoo1] حصد الموارد (1001/8) ✅" in captured[0]
    assert "⚔️ [beetoo1] تدريب الجنود (1005/2) ❌ (كود: 4002)" in captured[1]
    print("\n  ✓ تطابق كامل مع متطلبات المطور بنسبة 100%!")

def test_castle_bot_task_logs():
    print("\n🧪 4. اختبار صياغة سجلات المهام في CastleBot:")
    from bot_manager import CastleBot
    bot = CastleBot(email="oorrnn44@gmail.com", password="pass")
    captured = []
    bot._log_callback = lambda line: captured.append(line)

    # محاكاة إشعار مهمة ناجحة
    emoji, title = TASK_METADATA.get("port", ("📌", "port"))
    bot.log_brief(f"{emoji} [{bot.short_name}] {title}: تم استلام الجوائز بنجاح ✅")

    # محاكاة إشعار مهمة متخطاة
    emoji, title = TASK_METADATA.get("building", ("📌", "building"))
    bot.log_brief(f"{emoji} [{bot.short_name}] {title}: تخطي (طابور البناء مشغول) ⏭️")

    # محاكاة إشعار مهمة فاشلة
    emoji, title = TASK_METADATA.get("shield", ("📌", "shield"))
    bot.log_brief(f"{emoji} [{bot.short_name}] {title}: فشل (رصيد الذهب غير كافٍ) ❌")

    print("\n📋 السجلات الملتقطة للمهام:")
    for line in captured:
        print(f"  Captured -> {line}")

    assert len(captured) == 3
    assert "⚓ [oorrnn44] الميناء: تم استلام الجوائز بنجاح ✅" in captured[0]
    assert "🏰 [oorrnn44] طابور البناء: تخطي (طابور البناء مشغول) ⏭️" in captured[1]
    assert "🛡️ [oorrnn44] درع السلام: فشل (رصيد الذهب غير كافٍ) ❌" in captured[2]
    print("  ✓ سجلات المهام تطابق النمط المطلوب 100%!")

def main():
    test_metadata()
    test_query_success_detection()
    asyncio.run(test_game_conn_brief_logs())
    test_castle_bot_task_logs()

if __name__ == '__main__':
    main()
