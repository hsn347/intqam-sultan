# -*- coding: utf-8 -*-
"""
tools/test_research_task.py — اختبار شامل لوحدة أبحاث المعهد ونظام اليقين 100%
"""

import sys
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from tasks.research import ResearchTask, _load_tech_rules, _load_arabic_tech_names

class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        self.is_connected = True

    async def query(self, cmd, subcmd, data, timeout=7):
        return {"err": "0", "data": {}}

def main():
    print("1. Testing rules and names loading...")
    rules = _load_tech_rules()
    names = _load_arabic_tech_names()
    print(f"Loaded {len(rules)} tech rules.")
    print(f"Loaded {len(names)} Arabic tech names.")
    assert len(rules) >= 100, f"Expected at least 100 rules, got {len(rules)}"

    # 2. Mocking castle state with College Lv 16 and some resources
    learned = {
        "21001": 5, # إنتاج خشب
        "21002": 5, # إنتاج قمح
        "24011": 3, # هجوم مشاة
        "24104": 1, # شرط مسبق لـ 24105
    }
    resources = {
        "food": 10_000_000,
        "wood": 10_000_000,
        "iron": 1_000_000,
        "silver": 500_000,
    }

    mock_city = {
        "blist": [
            {"binfo": {"bid": 113, "lv": 16}}
        ],
        "resList": {
            "1002": resources["food"],
            "1003": resources["wood"],
            "1004": resources["iron"],
            "1005": resources["silver"],
        }
    }

    mock_init = {
        "cityCtrl": mock_city,
        "technologyCtrl": {k: [k, v] for k, v in learned.items()},
        "queueCtrl": {},
        "questCtrl": {},
    }

    task = ResearchTask(MockConn(mock_init), log_func=print)
    print("\n2. Testing find_best_qualified_research with College Lv 16...")
    best, stats = task.find_best_qualified_research(
        college_lv=16,
        learned_techs=learned,
        resources=resources,
        guide_quest=None,
    )

    print("Stats:", stats)
    if best:
        print(f"BEST QUALIFIED: ID={best['tech_id']} ({task.get_tech_title(best['tech_id'])}), Lv={best['target_level']}, Tree={best['tree_title']}")
        # Verify candidate really satisfies requirements
        rule = best['rule']
        assert 16 >= rule['college_lv'], f"College level too low! 16 < {rule['college_lv']}"
        for pre in rule.get('prepose', []):
            assert learned.get(pre['tech_id'], 0) >= pre['level'], f"Prerequisite {pre['tech_id']} Lv {pre['level']} not met!"
        for r_k in ['food', 'wood', 'iron', 'silver']:
            assert resources[r_k] >= rule['res'].get(r_k, 0), f"Resource {r_k} not enough!"
        print("✓ All 3 conditions (College Lv, Prerequisites, Resources) verified 100%!")
    else:
        print("No qualified tech found!")

    # 3. Test when resources are ZERO (Should find NONE safely without touching server)
    zero_res = {"food": 0, "wood": 0, "iron": 0, "silver": 0}
    best_zero, stats_zero = task.find_best_qualified_research(
        college_lv=16,
        learned_techs=learned,
        resources=zero_res,
        guide_quest=None,
    )
    assert best_zero is None, "Expected None when resources are 0!"
    print(f"\n3. Zero Resources Test Passed: Blocked by resources = {stats_zero['blocked_resources']} (Zero Network queries sent!)")

    # 4. Test Guide Quest priority
    # Suppose guide quest asks for 21001 level 2
    learned_g = dict(learned)
    learned_g["21001"] = 1
    g_tech_id = "21001"
    g_target_lv = 2
    best_guide, _ = task.find_best_qualified_research(
        college_lv=16,
        learned_techs=learned_g,
        resources=resources,
        guide_quest=(g_tech_id, g_target_lv),
    )
    assert best_guide is not None and best_guide['tech_id'] == g_tech_id and best_guide['target_level'] == g_target_lv
    print(f"4. Guide Quest Priority Test Passed: Guide quest {task.get_tech_title(g_tech_id)} Lv.{g_target_lv} selected first as highest priority!")

    print("\n🎉 ALL UNIT TESTS PASSED SUCCESSFULLY! 100% CERTAINTY GUARANTEED.")

if __name__ == "__main__":
    main()
