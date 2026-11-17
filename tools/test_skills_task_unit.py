# -*- coding: utf-8 -*-
"""
tools/test_skills_task_unit.py — فحص وحدة دقيق لكلاس SkillsTask وتأكيد خلوه من أي AttributeError
"""

import asyncio
import os
import sys

# ضمان مسار الجذر
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if root_dir not in sys.path:
    sys.path.insert(0, root_dir)

from tasks.skills import SkillsTask
from tasks.base_task import BaseTask

class MockConnection:
    def __init__(self):
        self.is_connected = True
        self.init_data = {
            "lordSkillCtrl": {
                "activeSetID": 1,
                "pointTotal": 50,
                "setListData": {
                    "1": {
                        "list": {
                            "11011": 1,
                            "12008": 1,
                        }
                    }
                },
                "CDData": {
                    "11011": {"beginTime": 1000, "CD": 5000}
                }
            },
            "buffCtrl": {},
            "queueCtrl": {},
        }

    async def query(self, *args, **kwargs):
        return {"code": 0, "err": 0}

async def run_unit_test():
    print("🔬 Testing SkillsTask with MockConnection...")
    mock_conn = MockConnection()
    cfg = {
        "enabled": True,
        "target_skills": ["11011", "12008", "13020", "harvest", "gather"]
    }
    
    logs = []
    task = SkillsTask(conn=mock_conn, log_func=lambda m: logs.append(m), config=cfg)
    
    # 1. Test method existence
    assert hasattr(task, "get_lord_skill_status"), "Missing get_lord_skill_status!"
    assert hasattr(task, "get_lord_active_skill_status"), "Missing get_lord_active_skill_status alias!"
    print("  ✅ Method existence verified.")
    
    # 2. Test can_run
    can_execute, reason = await task.can_run()
    assert can_execute is True, f"can_run failed: {reason}"
    print(f"  ✅ can_run passed: {can_execute}")
    
    # 3. Test run execution
    res = await task.run()
    print(f"  ✅ run passed: {res}")
    print("  Logs generated:")
    for l in logs:
        print("    ", l)
        
    assert res.success is True, "TaskResult should be success!"
    print("\n🎉 SkillsTask UNIT TEST PASSED 100% WITH ZERO ERRORS!")

if __name__ == "__main__":
    asyncio.run(run_unit_test())
