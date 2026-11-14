# -*- coding: utf-8 -*-
"""
tools/test_arena_task.py — اختبار شامل لوحدة مهمة تحدي الحلبة (Arena Task)
═════════════════════════════════════════════════════════════════════════════
يختبر كافة سيناريوهات الأمان، فحص الذاكرة المسبق (0-Network Pre-flight)،
استراتيجية اختيار الخصم الأضعف، استلام الجوائز التراكمية، ومزامنة الذاكرة.
"""

import asyncio
import copy
import os
import sys
from typing import Any, Dict, Optional

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.arena import ArenaTask, ARENA_TYPE_LOCAL, ARENA_TYPE_GLOBAL


class MockConnection:
    """محاكي اتصال لاختبار استعلامات الحلبة دون ملامسة السيرفر الحقيقي"""
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = copy.deepcopy(init_data)
        self.is_connected = True
        self.queries_log = []

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        self.queries_log.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data})

        # رد استلام الجوائز (Subcmd 5)
        if str(cmd) == "2056" and str(subcmd) == "5":
            return {
                "err": "0",
                "data": {
                    "rspdata": {
                        "rewards": [],
                        "rewardinfo": [{"id": 1603, "num": 500}],
                    }
                }
            }

        # رد استعلام الخصوم (Subcmd 1)
        if str(cmd) == "2056" and str(subcmd) == "1":
            return {
                "err": "0",
                "data": {
                    "rspdata": {
                        "enemyInfo": [
                            {"uid": "user_human", "rank": 10, "nickName": "فارس بشري", "fightCapacity": 50000, "robotFlag": False},
                            {"uid": 13801, "rank": 25, "nickName": "0000013801", "fightCapacity": 20400, "robotFlag": True},
                            {"uid": 13802, "rank": 18, "nickName": "0000013802", "fightCapacity": 45000, "robotFlag": True},
                        ],
                        "rankinfo": {"rank": 30},
                    }
                }
            }

        # رد تحديث الخصوم مجاناً (Subcmd 9)
        if str(cmd) == "2056" and str(subcmd) == "9":
            return {
                "err": "0",
                "data": {
                    "rspdata": {
                        "enemyInfo": [
                            {"uid": 13803, "rank": 28, "nickName": "0000013803", "fightCapacity": 18000, "robotFlag": True},
                        ]
                    }
                }
            }

        # رد خوض التحدي (Subcmd 6)
        if str(cmd) == "2056" and str(subcmd) == "6":
            return {
                "err": "0",
                "data": {
                    "rspdata": {
                        "bWin": True,
                        "rank": data.get("targetRank", 25),
                        "remainTimes": 4,
                        "enemyInfo": [],
                    }
                }
            }

        return {"err": "0", "data": {}}


async def run_tests():
    print("[*] بدء اختبارات مهمة تحدي الحلبة (Arena Task Test Suite)...")

    base_init_data = {
        "cityCtrl": {"level": 25},
        "playerArenaCtrl": {
            "localArena": {
                "remainTimes": 5,
                "myRank": 50,
                "arenaGroup": 4,
                "fightCapacity": 200000,
                "armyInfo": [{"armyId": 101, "count": 50000}],
                "heroInfo": [1001],
                "armsInfo": [],
                "divineBeastInfo": {},
                "rewards": [{"group": 4, "rank": 50, "time": 1700000000}],
            },
            "globalArena": {
                "arenaStatus": 0,  # مغلقة
                "remainTimes": 5,
                "armyInfo": {},
            },
        },
        "everydayTaskCtrl": {
            "eventInfo": {"30": 0},
        },
    }

    logs = []
    def logger(msg):
        logs.append(msg)

    # 1. اختبار مستوى القلعة أقل من 16 (0-Network)
    low_lv_data = copy.deepcopy(base_init_data)
    low_lv_data["cityCtrl"]["level"] = 12
    conn1 = MockConnection(low_lv_data)
    task1 = ArenaTask(conn1, logger, {"enabled": True})
    res1 = await task1.run()
    assert res1.skipped, "فشل: يجب تخطي القلعة ذات المستوى الأقل من 16"
    assert len(conn1.queries_log) == 0, "فشل: تم إرسال طلب شبكي لقلعة منخفضة المستوى (خرق 0-Network)"
    print("  [✓] فحص مستوى القلعة (0-Network Pre-flight): ناجح.")

    # 2. اختبار عدم تجهيز التشكيلة الدفاعية يدوياً مسبقاً (0-Network)
    no_army_data = copy.deepcopy(base_init_data)
    no_army_data["playerArenaCtrl"]["localArena"]["armyInfo"] = {}
    no_army_data["playerArenaCtrl"]["localArena"]["rewards"] = []
    conn2 = MockConnection(no_army_data)
    task2 = ArenaTask(conn2, logger, {"enabled": True})
    res2 = await task2.run()
    assert res2.skipped, "فشل: يجب تخطي الحساب إذا لم تكن التشكيلة مجهزة مسبقاً"
    assert len(conn2.queries_log) == 0, "فشل: تم إرسال طلب شبكي دون تشكيلة دفاعية"
    print("  [✓] فحص التشكيلة الدفاعية الفارغة (0-Network Pre-flight): ناجح.")

    # 3. اختبار اكتمال النشاط اليومي مسبقاً 3/3 (0-Network)
    done_daily_data = copy.deepcopy(base_init_data)
    done_daily_data["everydayTaskCtrl"]["eventInfo"]["30"] = 3
    done_daily_data["playerArenaCtrl"]["localArena"]["rewards"] = []
    conn3 = MockConnection(done_daily_data)
    task3 = ArenaTask(conn3, logger, {"enabled": True})
    res3 = await task3.run()
    assert res3.skipped, "فشل: يجب تخطي المهمة إذا كانت 3/3 مكتملة مسبقاً"
    assert len(conn3.queries_log) == 0, "فشل: تم إرسال طلب شبكي رغم اكتمال النشاط اليومي"
    print("  [✓] فحص اكتمال النشاط اليومي 3/3 (0-Network Pre-flight): ناجح.")

    # 4. اختبار التبديل التلقائي من حلبة العالم إلى حلبة المملكة عند إغلاق حلبة العالم
    global_closed_data = copy.deepcopy(base_init_data)
    conn4 = MockConnection(global_closed_data)
    task4 = ArenaTask(conn4, logger, {"enabled": True, "arena_type": "global"})
    res4 = await task4.run()
    assert res4.success, f"فشل: {res4.message}"
    # التحقق من أن الطلب أُرسل بنوع الحلبة المحلية (ARENA_TYPE_LOCAL = 1)
    ground_query = next(q for q in conn4.queries_log if q["subcmd"] == "1")
    assert ground_query["data"]["arenaType"] == ARENA_TYPE_LOCAL, "فشل: لم يتم التبديل لحلبة المملكة عند إغلاق حلبة العالم"
    print("  [✓] التبديل الذكي من حلبة العالم للمملكة عند الإغلاق: ناجح.")

    # 5. اختبار استلام الجوائز التراكمية تلقائياً
    reward_query = next((q for q in conn4.queries_log if q["subcmd"] == "5"), None)
    assert reward_query is not None, "فشل: لم يتم إرسال طلب استلام الجوائز التراكمية"
    assert conn4.init_data["playerArenaCtrl"]["localArena"]["rewards"] == [], "فشل: لم يتم تصفير الجوائز بالذاكرة"
    print("  [✓] استلام وتصفير جوائز الترتيب التراكمية: ناجح.")

    # 6. اختبار استراتيجية قصر الهجوم على الروبوتات واختيار الروبوت الأضعف
    challenge_query = next((q for q in conn4.queries_log if q["subcmd"] == "6"), None)
    assert challenge_query is not None, "فشل: لم يتم إرسال طلب التحدي"
    assert challenge_query["data"]["targetUid"] == 13801, f"فشل: تم استهداف {challenge_query['data']['targetUid']} بدلاً من الروبوت 13801 الأضعف قوة وتجاهل اللاعب البشري!"
    print("  [✓] استراتيجية قصر الهجوم على الروبوت الأضعف (Weakest Robot Selection): ناجحة تماماً.")

    # 7. اختبار تحديث الذاكرة الحية بعد التحدي
    updated_challenges = conn4.init_data["everydayTaskCtrl"]["eventInfo"]["30"]
    assert updated_challenges > 0, "فشل: لم يتم تحديث عداد النشاط اليومي 30 في الذاكرة الحية"
    print("  [✓] مزامنة الذاكرة الحية فورياً (In-Memory State Sync): ناجحة.")

    # 8. اختبار حماية التخطي الآمن عند عدم وجود روبوتات بعد 3 محاولات تحديث
    class NoRobotConnection(MockConnection):
        async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
            self.queries_log.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data})
            if str(cmd) == "2056" and str(subcmd) == "1":
                return {
                    "err": "0",
                    "data": {
                        "rspdata": {
                            "enemyInfo": [
                                {"uid": "human_1", "rank": 10, "nickName": "لاعب 1", "fightCapacity": 1000, "robotFlag": False},
                                {"uid": "human_2", "rank": 20, "nickName": "لاعب 2", "fightCapacity": 2000, "robotFlag": False},
                            ]
                        }
                    }
                }
            if str(cmd) == "2056" and str(subcmd) == "9":
                return {
                    "err": "0",
                    "data": {
                        "rspdata": {
                            "enemyInfo": [
                                {"uid": "human_3", "rank": 15, "nickName": "لاعب 3", "fightCapacity": 3000, "robotFlag": False},
                            ]
                        }
                    }
                }
            return {"err": "0", "data": {}}

    no_robot_data = copy.deepcopy(base_init_data)
    no_robot_data["playerArenaCtrl"]["localArena"]["rewards"] = []
    conn5 = NoRobotConnection(no_robot_data)
    task5 = ArenaTask(conn5, logger, {"enabled": True})
    res5 = await task5.run()
    assert res5.skipped, "فشل: كان يجب التخطي بأمان عند انعدام الروبوتات"
    # التحقق من إرسال 3 طلبات تحديث (subcmd 9) كحد أقصى وعدم إرسال أي طلب قتال (subcmd 6)
    refresh_queries = [q for q in conn5.queries_log if q["subcmd"] == "9"]
    fight_queries = [q for q in conn5.queries_log if q["subcmd"] == "6"]
    assert len(refresh_queries) == 3, f"فشل: كان يجب محاولة التحديث 3 مرات، الحالي: {len(refresh_queries)}"
    assert len(fight_queries) == 0, f"فشل: تم إرسال طلب هجوم على لاعب بشري! {fight_queries}"
    print("  [✓] حماية التخطي الآمن ومحاولات التحديث الـ 3 (Safe 3-Refresh Limit & Zero Human Attacks): ناجحة 100%.")

    print("\n[🎉] كافة اختبارات مهمة تحدي الحلبة (Arena Task) مرت بنجاح بنسبة 100%!")


if __name__ == "__main__":
    asyncio.run(run_tests())
