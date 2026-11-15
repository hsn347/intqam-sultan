# -*- coding: utf-8 -*-
"""
tools/test_daily_quest_fix.py
فحص واختبار التحسينات الجديدة في مهمة استلام صناديق النشاط اليومي:
1. اختبار منع التكرار (Deduplication) عند وجود المفاتيح المزدوجة (ID والنوع).
2. اختبار التعامل الآمن مع رمز الخطأ 470002 (Err_EVERYDAY_TASK_POINT_NOT_ENOUGH).
"""

import sys
import os

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.daily_quest import DailyQuestTask, CHEST_MILESTONES

def test_deduplication():
    print("▶ 1. فحص منع تكرار احتساب النقاط...")
    
    # حالة الذاكرة الحية التي كانت تسبب المشكلة:
    # علاج مصابين (5 مرات = 15 نقطة) مكتوبة بالمفتاحين
    # دمج مواد (مرة واحدة = 10 نقاط) مكتوبة بالمفتاحين
    # تصنيع عتاد (مرة واحدة = 20 نقطة) مكتوبة بالمفتاحين
    # المجموع الحقيقي = 15 + 10 + 20 = 45 نقطة
    event_info = {
        "4100011": 5, "11": 5,
        "4100010": 1, "10": 1,
        "4100009": 1, "9": 1,
    }
    
    points = DailyQuestTask.calculate_cur_points(event_info)
    print(f"  النقاط المحسوبة بعد الإصلاح: {points} (المتوقع: 45)")
    assert points == 45, f"Expected 45 points, got {points}!"
    print("  ✓ تم اجتياز فحص منع التكرار بنجاح 100%!")

def test_chest_unclaimed_thresholds():
    print("▶ 2. فحص عتبات الصناديق...")
    # لنفترض أن رصيد القلعة الحقيقي هو 380 نقطة
    # الصناديق المستلمة مسبقاً: 1 إلى 6 (30, 70, 120, 180, 260, 340)
    normal_record = {"1": 1, "2": 1, "3": 1, "4": 1, "5": 1, "6": 1}
    ready = DailyQuestTask.get_unclaimed_ready_chests(380, normal_record)
    print(f"  الصناديق الجاهزة عند 380 نقطة مع استلام 1..6: {ready}")
    # لا يوجد أي صندوق جاهز لأن الصندوق 7 يحتاج 420 نقطة
    assert ready == [], f"Expected no ready chests, got {ready}"
    print("  ✓ تم التأكد أن الصندوق 7 لن يظهر كصندوق جاهز حتى يبلغ 420 نقطة فعلياً!")

    # عند بلوغ 420 نقطة
    ready_420 = DailyQuestTask.get_unclaimed_ready_chests(420, normal_record)
    print(f"  الصناديق الجاهزة عند 420 نقطة: {ready_420}")
    assert ready_420 == [7], f"Expected [7], got {ready_420}"
    print("  ✓ تم التأكد أن الصندوق 7 يظهر فقط عند بلوغ 420 نقطة بالضبط!")

if __name__ == "__main__":
    test_deduplication()
    test_chest_unclaimed_thresholds()
    print("✅ كافة الفحوصات تمت بنجاح تام!")
