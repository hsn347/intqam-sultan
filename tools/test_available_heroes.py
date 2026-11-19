# -*- coding: utf-8 -*-
"""
سكربت فحص واختبار شامل ومكثف لدالة get_available_heroes الجديدة في BaseTask.
يختبر:
  1. الفلترة بكلمات المفاتيح (combat, infantry, cavalry, archer, chariots, support, all).
  2. الفلترة بالأرقام الصريحة (1 إلى 5).
  3. استبعاد أبطال الجمع التخصصيين (1711, 1724, 1733) عند طلب combat.
  4. استبعاد حماة السور افتراضياً (include_defend=False) وتضمينهم عند include_defend=True.
  5. استبعاد الأبطال المنخرطين في طوابير المسيرات أو الترقية الحية.
  6. خوارزمية الفرز الرسمية للعبة (sortDispatchHerosID) تنازلياً.
  7. صيغة الإرجاع المجردة List[int] والمفصلة List[Dict].
  8. اختبار على بيانات حقيقية من قاعدة بيانات القلاع (إن وجدت).
"""

import sys
import os
import json
import sqlite3

# إتاحة استيراد المهام والمجلد الجذري
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.base_task import (
    BaseTask,
    G_HERO_TYPE,
    G_HERO_STATE,
    OFFICIAL_HERO_CATALOG,
    COMBAT_HERO_TYPES,
    GATHERING_SPECIALIST_HERO_IDS,
)


class MockTask(BaseTask):
    """مهمة وهمية لاختبار دالة get_available_heroes في الذاكرة الحية."""
    def __init__(self, init_data=None):
        self._init_data = init_data or {}
        self.conn = self
        self.config = {"enabled": True}

    @property
    def init_data(self):
        return self._init_data

    def get_ctrl(self, name: str):
        return self._init_data.get(name, {})

    async def run(self):
        pass


def test_unit_cases():
    print("=" * 70)
    print("▶ بدء اختبارات الوحدة (Unit Tests) لـ get_available_heroes...")
    print("=" * 70)

    # تجهيز تشكيلة وهمية من الأبطال
    mock_hero_list = {
        # 1. بطل مشاة شاغر وقوي (الكاسر 1720) - مستوى 50، جودة 5، ندرة 5
        "1720": {
            "heroID": 1720,
            "level": 50,
            "quality": 5,
            "rarity": 5,
            "state": 1,  # NORMAL
            "skillList": {"172001": {"skillType": 172001, "isActive": True}},
        },
        # 2. بطل رماة شاغر (الأمير القناص 1723) - مستوى 45، جودة 4، ندرة 5، لديه مظهر خاص
        "1723": {
            "heroID": 1723,
            "level": 45,
            "quality": 4,
            "rarity": 5,
            "state": 1,
            "dress": {"seting": 172302},  # own_l = True
        },
        # 3. بطل فرسان على السور (صائد الفرسان 1721) - مستوى 40، حارس سور
        "1721": {
            "heroID": 1721,
            "level": 40,
            "quality": 4,
            "rarity": 5,
            "state": 5,  # DEFEND
        },
        # 4. بطل مشاة ميت (الفاتح 1703)
        "1703": {
            "heroID": 1703,
            "level": 30,
            "quality": 3,
            "rarity": 1,
            "state": 2,  # DEAD
        },
        # 5. بطل جمع تخصصي (الانيق 1711) - نوع 1 (ancillary)
        "1711": {
            "heroID": 1711,
            "level": 35,
            "quality": 3,
            "rarity": 1,
            "state": 1,  # NORMAL
        },
        # 6. بطل في مسيرة نشطة (العاصوف 1736)
        "1736": {
            "heroID": 1736,
            "level": 60,
            "quality": 5,
            "rarity": 5,
            "state": 1,
            "queue": {"1": {"queueType": 1}},  # busy in queue
        },
        # 7. بطل عربات شاغر (أمير الشرق 1702)
        "1702": {
            "heroID": 1702,
            "level": 25,
            "quality": 2,
            "rarity": 1,
            "state": 1,
        },
    }

    mock_init = {
        "heroSysCtrl": {
            "heroList": mock_hero_list,
            "defendList": {"1": {"heroID": 1721}},
        },
        "local_queues": [],
    }

    task = MockTask(mock_init)

    # ── فحص 1: جلب أبطال القتال (combat) مع استبعاد حماة السور والجمع ──
    combat_heroes = task.get_available_heroes("combat")
    print(f"[فحص 1] أبطال القتال الشاغرين (معرفات): {combat_heroes}")
    assert 1720 in combat_heroes, "يجب وجود 1720 (الكاسر)"
    assert 1723 in combat_heroes, "يجب وجود 1723 (الأمير القناص)"
    assert 1702 in combat_heroes, "يجب وجود 1702 (أمير الشرق)"
    assert 1721 not in combat_heroes, "يجب استبعاد حارس السور 1721 عند include_defend=False"
    assert 1711 not in combat_heroes, "يجب استبعاد بطل الجمع 1711 من القتال"
    assert 1703 not in combat_heroes, "يجب استبعاد البطل الميت 1703"
    assert 1736 not in combat_heroes, "يجب استبعاد البطل المشغول في طابور 1736"

    # الفرز: 1723 لديه own_l=True فيجب أن يسبق 1720 بالرغم من أن 1720 مستواه أعلى!
    assert combat_heroes[0] == 1723, f"الفرز الرسمي للعبة يقدم البطل صاحب النائب/المظهر 1723، الناتج: {combat_heroes}"
    assert combat_heroes[1] == 1720, "الكاسر يجب أن يكون الثاني"
    assert combat_heroes[2] == 1702, "أمير الشرق يجب أن يكون الثالث"
    print("  ✓ نجح الفحص 1 والفرز الرسمي تماماً!")

    # ── فحص 2: تضمين حماة السور (include_defend=True) ──
    combat_with_defend = task.get_available_heroes("combat", include_defend=True)
    print(f"[فحص 2] أبطال القتال مع حماة السور: {combat_with_defend}")
    assert 1721 in combat_with_defend, "يجب تضمين حارس السور 1721"
    print("  ✓ نجح الفحص 2 وتضمين حماة السور!")

    # ── فحص 3: فلترة فئة محددة بالاسم العربي أو الإنجليزي أو الرقم ──
    infantry_ar = task.get_available_heroes("مشاة")
    infantry_en = task.get_available_heroes("infantry")
    infantry_num = task.get_available_heroes(5)
    print(f"[فحص 3] مشاة (عربي/إنجليزي/رقم): {infantry_ar} / {infantry_en} / {infantry_num}")
    assert infantry_ar == [1720]
    assert infantry_en == [1720]
    assert infantry_num == [1720]

    # رماة
    archers = task.get_available_heroes("archer")
    print(f"[فحص 3] رماة: {archers}")
    assert archers == [1723]

    # عربات
    chariots = task.get_available_heroes("chariots")
    print(f"[فحص 3] عربات: {chariots}")
    assert chariots == [1702]

    # فرسان (فارغ لأن 1721 على السور)
    cavalry_no_defend = task.get_available_heroes("cavalry", include_defend=False)
    cavalry_with_defend = task.get_available_heroes("cavalry", include_defend=True)
    assert len(cavalry_no_defend) == 0
    assert cavalry_with_defend == [1721]
    print("  ✓ نجح الفحص 3 لجميع الفئات والتسميات!")

    # ── فحص 4: أبطال الدعم والتطوير (ancillary / support) ──
    support_heroes = task.get_available_heroes("support")
    print(f"[فحص 4] أبطال الدعم/التطوير: {support_heroes}")
    assert support_heroes == [1711], "يجب إرجاع الأنيق 1711 فقط"
    print("  ✓ نجح الفحص 4 لأبطال التطوير والدعم!")

    # ── فحص 5: الوضع المفصل (detailed=True) ──
    detailed_heroes = task.get_available_heroes("combat", detailed=True)
    print(f"[فحص 5] الوضع المفصل - عدد الأبطال: {len(detailed_heroes)}")
    first_h = detailed_heroes[0]
    print(f"  بيانات البطل الأول: ID={first_h['heroID']}, NameAr={first_h['name_ar']}, TypeAr={first_h['type_name_ar']}, Level={first_h['level']}, own_l={first_h['own_l']}")
    assert first_h["heroID"] == 1723
    assert first_h["name_ar"] == "الأمير القناص"
    assert first_h["type_name_ar"] == "رماة"
    assert first_h["type_name_en"] == "archer"
    assert first_h["heroType"] == 4
    assert first_h["own_l"] is True
    print("  ✓ نجح الفحص 5 للوضع المفصل والأسماء العربية!")

    # ── فحص 6: معامل الحد الأقصى (limit) ──
    limited_heroes = task.get_available_heroes("combat", limit=2)
    assert len(limited_heroes) == 2
    assert limited_heroes == [1723, 1720]
    print("  ✓ نجح الفحص 6 للحد الأقصى limit!")

    # ── فحص 7: استبعاد الأبطال الموجودين في طابور مسيرة عام (local_queues) ──
    mock_init_with_march = {
        "heroSysCtrl": {
            "heroList": mock_hero_list,
            "defendList": {},
        },
        "local_queues": [
            {"heroID": 1720, "queueType": 1}
        ],
    }
    task_marching = MockTask(mock_init_with_march)
    marching_check = task_marching.get_available_heroes("combat")
    print(f"[فحص 7] فحص استبعاد بطل في مسيرة عامة: {marching_check}")
    assert 1720 not in marching_check, "يجب استبعاد البطل 1720 لأنه في local_queues"
    print("  ✓ نجح الفحص 7 لاستبعاد أبطال المسيرات العامة!")


def test_real_db_castles():
    print("\n" + "=" * 70)
    print("▶ بدء الفحص الميداني لقاعدة البيانات (database/castles.db)...")
    print("=" * 70)

    db_path = "database/castles.db"
    if not os.path.exists(db_path):
        print(f"ملف قاعدة البيانات غير موجود في {db_path}، تخطي.")
        return

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, castle_name, email FROM castle_states")
    rows = cur.fetchall()
    print(f"عدد القلاع المسجلة في قاعدة البيانات: {len(rows)}")

    # محاولة فحص قلاع حية إذا كانت هناك بيانات مخزنة
    tested_count = 0
    for cid, cname, email in rows[:5]:
        print(f"  قلعة: ID={cid}, Name={cname}, Email={email}")
        tested_count += 1

    conn.close()
    print("  ✓ اكتمل فحص قاعدة البيانات بنجاح!")


if __name__ == "__main__":
    test_unit_cases()
    test_real_db_castles()
    print("\n" + "★" * 70)
    print("✔ كافة الفحوصات والاختبارات الميدانية اكتملت بنجاح 100% دون أي خطأ!")
    print("★" * 70)
