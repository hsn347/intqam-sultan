# -*- coding: utf-8 -*-
"""
tools/test_vip_talent_switch_preflight.py — اختبار شامل وصارم لفحص VIP والتحقق المسبق من تبديل أطقم المواهب
"""

import asyncio
import json
import os
import sys
import time

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if root_dir not in sys.path:
    sys.path.insert(0, root_dir)

from tasks.base_task import BaseTask
from tasks.skills import SkillsTask


class DummyTask(BaseTask):
    async def run(self):
        return None


class MockConn:
    def __init__(self, init_data=None):
        self.is_connected = True
        self.init_data = init_data or {}
        self.queries_sent = []

    async def query(self, cmd, subcmd, data=None, **kwargs):
        self.queries_sent.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data})
        return {"code": 0, "err": 0}


async def test_vip_properties():
    print("\n--- 1. Testing VIP Properties (0-Network) ---")
    now_ts = int(time.time())

    # Case A: VIP expired (level 9, vipEndTime == 0 like beetoo3)
    conn_a = MockConn({
        "lordInfoCtrl": {
            "vip": {"level": 9, "vipEndTime": 0, "loginDay": 5}
        }
    })
    task_a = DummyTask(conn=conn_a)
    assert task_a.vip_level == 9, f"Expected vip_level 9, got {task_a.vip_level}"
    assert task_a.is_vip_active is False, "Expected is_vip_active to be False when vipEndTime == 0"
    assert task_a.vip_remaining_seconds == 0, f"Expected 0 remaining seconds, got {task_a.vip_remaining_seconds}"
    print("  ✅ Case A (VIP expired, vipEndTime == 0) passed.")

    # Case B: VIP expired in past
    conn_b = MockConn({
        "lordInfoCtrl": {
            "vip": {"level": 10, "vipEndTime": now_ts - 500}
        }
    })
    task_b = DummyTask(conn=conn_b)
    assert task_b.vip_level == 10
    assert task_b.is_vip_active is False
    assert task_b.vip_remaining_seconds == 0
    print("  ✅ Case B (VIP past timestamp) passed.")

    # Case C: VIP active (future timestamp)
    conn_c = MockConn({
        "lordInfoCtrl": {
            "vip": {"level": 9, "vipEndTime": now_ts + 7200}
        }
    })
    task_c = DummyTask(conn=conn_c)
    assert task_c.vip_level == 9
    assert task_c.is_vip_active is True
    assert 7100 <= task_c.vip_remaining_seconds <= 7200
    print("  ✅ Case C (VIP active, future timestamp) passed.")

    # Case D: VIP active in queueCtrl (qtype 1219)
    conn_d = MockConn({
        "lordInfoCtrl": {
            "vip": {"level": 8, "vipEndTime": 0}
        },
        "queueCtrl": {
            "1219": {"qtype": "1219", "ottime": now_ts + 3600}
        }
    })
    task_d = DummyTask(conn=conn_d)
    assert task_d.vip_level == 8
    assert task_d.is_vip_active is True
    assert 3500 <= task_d.vip_remaining_seconds <= 3600
    print("  ✅ Case D (VIP active in queueCtrl 1219) passed.")

    # Case E: Millisecond timestamp
    conn_e = MockConn({
        "lordInfoCtrl": {
            "vip": {"level": 12, "vipEndTime": (now_ts + 1800) * 1000}
        }
    })
    task_e = DummyTask(conn=conn_e)
    assert task_e.vip_level == 12
    assert task_e.is_vip_active is True
    assert 1700 <= task_e.vip_remaining_seconds <= 1800
    print("  ✅ Case E (VIP millisecond timestamp) passed.")

    # Case F: String formats ("0", "1764613513")
    conn_f1 = MockConn({"lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": "0"}}})
    assert DummyTask(conn=conn_f1).is_vip_active is False
    conn_f2 = MockConn({"lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": str(now_ts + 900)}}})
    assert DummyTask(conn=conn_f2).is_vip_active is True
    print("  ✅ Case F (VIP string formats) passed.")

    # Case G: Malformed queueCtrl values (invalid, None, empty) -> must not raise ValueError
    conn_g = MockConn({
        "lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": 0}},
        "queueCtrl": {
            "1219": {"qtype": "1219", "ottime": "invalid_string", "totaltime": None, "starttime": " "}
        }
    })
    task_g = DummyTask(conn=conn_g)
    assert task_g.vip_end_time == 0.0
    assert task_g.is_vip_active is False
    print("  ✅ Case G (Malformed queueCtrl resilient handling) passed.")


async def test_can_switch_talent_set():
    print("\n--- 2. Testing can_switch_lord_skill_set ---")
    now_ts = int(time.time())

    # Set 1: always allowed
    conn = MockConn({"lordInfoCtrl": {"vip": {"level": 0, "vipEndTime": 0}}})
    task = DummyTask(conn=conn)
    ok, msg = task.can_switch_lord_skill_set(1)
    assert ok is True
    ok, msg = task.can_switch_lord_skill_set("1")
    assert ok is True
    print("  ✅ Set 1 always allowed.")

    # Set 2: VIP < 9 -> rejected
    conn_v8 = MockConn({"lordInfoCtrl": {"vip": {"level": 8, "vipEndTime": now_ts + 3600}}})
    task_v8 = DummyTask(conn=conn_v8)
    ok, msg = task_v8.can_switch_lord_skill_set(2)
    assert ok is False and "مستوى VIP 9 على الأقل" in msg
    print("  ✅ Set 2 rejected for VIP < 9.")

    # Set 2: VIP 9 but expired -> rejected
    conn_v9_exp = MockConn({"lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": 0}}})
    task_v9_exp = DummyTask(conn=conn_v9_exp)
    ok, msg = task_v9_exp.can_switch_lord_skill_set(2)
    assert ok is False and "منتهي الصلاحية" in msg
    print("  ✅ Set 2 rejected for VIP 9 with expired VIP.")

    # Set 2: VIP 9 and active -> allowed
    conn_v9_act = MockConn({"lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": now_ts + 3600}}})
    task_v9_act = DummyTask(conn=conn_v9_act)
    ok, msg = task_v9_act.can_switch_lord_skill_set(2)
    assert ok is True and "نشط" in msg
    print("  ✅ Set 2 allowed for VIP 9 with active VIP.")

    # Set 3: VIP 9 active -> rejected (needs 13)
    ok, msg = task_v9_act.can_switch_lord_skill_set(3)
    assert ok is False and "مستوى VIP 13 على الأقل" in msg
    print("  ✅ Set 3 rejected for VIP < 13.")

    # Set 3: VIP 13 expired -> rejected
    conn_v13_exp = MockConn({"lordInfoCtrl": {"vip": {"level": 13, "vipEndTime": 0}}})
    task_v13_exp = DummyTask(conn=conn_v13_exp)
    ok, msg = task_v13_exp.can_switch_lord_skill_set(3)
    assert ok is False and "منتهي الصلاحية" in msg
    print("  ✅ Set 3 rejected for VIP 13 with expired VIP.")

    # Set 3: VIP 13 active -> allowed
    conn_v13_act = MockConn({"lordInfoCtrl": {"vip": {"level": 13, "vipEndTime": now_ts + 3600}}})
    task_v13_act = DummyTask(conn=conn_v13_act)
    ok, msg = task_v13_act.can_switch_lord_skill_set(3)
    assert ok is True and "نشط" in msg
    print("  ✅ Set 3 allowed for VIP 13 with active VIP.")

    # Sets 4, 5, 6 without exalted privilege -> rejected
    ok, msg = task_v13_act.can_switch_lord_skill_set(4)
    assert ok is False and "امتيازات كبار الشخصيات" in msg
    ok, msg = task_v13_act.can_switch_lord_skill_set(5)
    assert ok is False and "امتيازات كبار الشخصيات" in msg
    ok, msg = task_v13_act.can_switch_lord_skill_set(6)
    assert ok is False and "امتيازات كبار الشخصيات" in msg
    print("  ✅ Sets 4, 5, 6 rejected when exalted privilege not met.")

    # Sets 4, 5 with Exalted Privilege list and dict formats -> allowed
    conn_ex_list = MockConn({
        "exaltedPrivilegeCtrl": {
            "privileges": [{"id": "10", "value": 2}]
        }
    })
    task_ex_list = DummyTask(conn=conn_ex_list)
    ok4, msg4 = task_ex_list.can_switch_lord_skill_set(4)
    assert ok4 is True, f"Expected Set 4 allowed with rank 2, got: {msg4}"
    ok5, msg5 = task_ex_list.can_switch_lord_skill_set(5)
    assert ok5 is True, f"Expected Set 5 allowed with rank 2, got: {msg5}"
    ok6, msg6 = task_ex_list.can_switch_lord_skill_set(6)
    assert ok6 is False, f"Expected Set 6 rejected with rank 2 (needs 3), got: {msg6}"
    print("  ✅ Sets 4, 5, 6 correctly verified against Exalted Privilege list format.")

    conn_ex_dict = MockConn({
        "exaltedPrivilegeCtrl": {
            "privileges": {"10": 3}
        }
    })
    task_ex_dict = DummyTask(conn=conn_ex_dict)
    assert task_ex_dict.can_switch_lord_skill_set(6)[0] is True
    print("  ✅ Sets 4, 5, 6 correctly verified against Exalted Privilege dict format.")


async def test_switch_lord_skill_set_preflight():
    print("\n--- 3. Testing switch_lord_skill_set Pre-flight Cancellation ---")
    now_ts = int(time.time())

    # Case A: Trying to switch to Set 2 with expired VIP -> MUST NOT SEND NETWORK QUERY
    conn_exp = MockConn({
        "lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": 0}},
        "lordSkillCtrl": {"activeSetID": 1}
    })
    task_exp = DummyTask(conn=conn_exp)
    ok, msg = await task_exp.switch_lord_skill_set(2)
    assert ok is False, "switch_lord_skill_set should return False!"
    assert "منتهي الصلاحية" in msg, f"Expected expired message, got: {msg}"
    assert len(conn_exp.queries_sent) == 0, f"ZERO network queries expected! Found: {conn_exp.queries_sent}"
    print("  ✅ ZERO network queries sent when switching to locked Set 2.")

    # Case B: Already on target set -> no network query
    ok, msg = await task_exp.switch_lord_skill_set(1)
    assert ok is True
    assert "مفعل بالفعل" in msg
    assert len(conn_exp.queries_sent) == 0
    print("  ✅ ZERO network queries when target set is already active.")

    # Case C: Switching to Set 2 with active VIP -> safe_query sent and in-memory updated
    conn_act = MockConn({
        "lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": now_ts + 3600}},
        "lordSkillCtrl": {"activeSetID": 1}
    })
    task_act = DummyTask(conn=conn_act)
    ok, msg = await task_act.switch_lord_skill_set(2)
    assert ok is True
    assert len(conn_act.queries_sent) == 1
    assert conn_act.queries_sent[0]["cmd"] == "1002"
    assert conn_act.queries_sent[0]["subcmd"] == "23"
    assert conn_act.queries_sent[0]["data"] == {"setID": 2}
    assert conn_act.init_data["lordSkillCtrl"]["activeSetID"] == 2
    print("  ✅ Valid switch sends network query and syncs memory.")


async def test_get_lord_skill_status_smart_selection():
    print("\n--- 4. Testing get_lord_skill_status candidate set logic ---")
    now_ts = int(time.time())

    # Skill 12008 (حصاد وافر) is learned in Set 2 ONLY, active set is 1, VIP 9 expired
    conn = MockConn({
        "lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": 0}},
        "lordSkillCtrl": {
            "activeSetID": "1",
            "setListData": {
                "1": {"list": {}},
                "2": {"list": {"12008": 1}}
            }
        }
    })
    task = DummyTask(conn=conn)
    st = task.get_lord_skill_status(12008)
    assert st["is_learned"] is True
    assert st["is_in_active_set"] is False
    assert st["can_activate"] is False
    assert st["can_switch_to_set"] is False, "can_switch_to_set must be False when VIP expired!"
    assert st["target_switch_set_id"] is None
    assert "منتهي الصلاحية" in st["switch_blocked_reason"]
    print("  ✅ Skill learned only in locked Set 2 correctly marked non-switchable with clear reason.")

    # Skill learned in Set 1 (lvl 1) and Set 2 (lvl 2), active set is 3, VIP 9 expired
    conn2 = MockConn({
        "lordInfoCtrl": {"vip": {"level": 9, "vipEndTime": 0}},
        "lordSkillCtrl": {
            "activeSetID": "3",
            "setListData": {
                "1": {"list": {"12008": 1}},
                "2": {"list": {"12008": 2}}
            }
        }
    })
    task2 = DummyTask(conn=conn2)
    st2 = task2.get_lord_skill_status(12008)
    assert st2["can_switch_to_set"] is True
    assert st2["target_switch_set_id"] == "1", "Should pick switchable Set 1 instead of locked Set 2!"
    print("  ✅ Candidate selection successfully bypasses locked set and selects switchable set.")


async def test_skills_task_end_to_end_with_real_json():
    print("\n--- 5. Testing SkillsTask with real beetoo2_full_init_data.json ---")
    json_path = os.path.join(root_dir, "tools", "beetoo2_full_init_data.json")
    if os.path.exists(json_path):
        with open(json_path, "r", encoding="utf-8") as f:
            real_init_data = json.load(f)

        # Sub-case 5.1: Real account state (skills not learned)
        conn = MockConn(real_init_data)
        logs = []
        cfg = {
            "enabled": True,
            "target_skills": ["12008", "11011", "13020"]
        }
        task = SkillsTask(conn=conn, log_func=lambda m: logs.append(m), config=cfg)
        res = await task.run()
        print(f"  Result (not learned): {res}")
        assert len(conn.queries_sent) == 0

        # Sub-case 5.2: Simulating beetoo3 (Skill 12008 learned in Set 2, VIP 9 expired)
        simulated_data = json.loads(json.dumps(real_init_data))
        simulated_data["lordSkillCtrl"]["setListData"]["2"] = {
            "setID": "2",
            "list": {"12008": 1},
            "usedPoint": 1
        }
        sim_conn = MockConn(simulated_data)
        sim_logs = []
        sim_task = SkillsTask(conn=sim_conn, log_func=lambda m: sim_logs.append(m), config=cfg)
        sim_res = await sim_task.run()
        print(f"  Result (simulated beetoo3 with skill in Set 2): {sim_res}")
        print("  Logs:")
        for l in sim_logs:
            print("    ", l)

        # Verify NO illegal switch was sent
        for q in sim_conn.queries_sent:
            assert not (q["cmd"] == "1002" and q["subcmd"] == "23" and q["data"] == {"setID": 2}), \
                "ILLEGAL SWITCH TO SET 2 WAS SENT!"
        assert len(sim_conn.queries_sent) == 0, f"Expected 0 queries sent, got {len(sim_conn.queries_sent)}"

        # Verify the log clearly explained VIP is expired
        vip_expired_logged = any("منتهي الصلاحية" in l for l in sim_logs)
        assert vip_expired_logged, "Expected log message indicating VIP is expired!"
        print("  ✅ Real init_data simulation passed: Zero illegal switch packets sent, VIP expiration clearly logged!")
    else:
        print("  ⚠️ beetoo2_full_init_data.json not found, skipping real json check.")


async def main():
    print("=" * 65)
    print("🔬 COMPREHENSIVE VIP TALENT SET PRE-FLIGHT VERIFICATION SUITE")
    print("=" * 65)
    await test_vip_properties()
    await test_can_switch_talent_set()
    await test_switch_lord_skill_set_preflight()
    await test_get_lord_skill_status_smart_selection()
    await test_skills_task_end_to_end_with_real_json()
    print("\n" + "=" * 65)
    print("🎉 ALL VIP TALENT SWITCH PRE-FLIGHT TESTS PASSED 100%!")
    print("=" * 65)


if __name__ == "__main__":
    asyncio.run(main())
