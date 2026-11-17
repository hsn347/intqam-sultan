# -*- coding: utf-8 -*-
"""
tools/test_skills_e2e.py — اختبار شامل للمراحل الست لإضافة وتكامل مهارات الأمير (Skills E2E Test)
"""

import asyncio
import json
import sqlite3
import os
import sys

def run_e2e_tests():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if root_dir not in sys.path:
        sys.path.insert(0, root_dir)
    print("=" * 60)
    print("🔬 RUNNING SKILLS 6-STAGE E2E VERIFICATION SUITE")
    print("=" * 60)
    
    # Stage 1: Backend Task verification
    print("\n[Stage 1] Verifying SkillsTask in tasks/skills.py...")
    from tasks.skills import SkillsTask
    from tasks import __all__ as exported_tasks
    assert "SkillsTask" in exported_tasks, "SkillsTask not exported in tasks/__init__.py!"
    assert SkillsTask.name == "skills", "SkillsTask name mismatch!"
    assert SkillsTask.alias == "lord_skills", "SkillsTask alias mismatch!"
    print("  ✅ Stage 1 passed: SkillsTask successfully imported and verified.")

    # Stage 2: Bot Manager verification
    print("\n[Stage 2] Verifying bot_manager.py registration...")
    from bot_manager import REGISTERED_TASKS, DEFAULT_BOT_CONFIG, CastleBot
    registered_names = [getattr(t, "name", t.__name__) for t in REGISTERED_TASKS]
    assert "skills" in registered_names, "skills not found in REGISTERED_TASKS!"
    assert "skills" in DEFAULT_BOT_CONFIG["tasks"], "skills not in DEFAULT_BOT_CONFIG['tasks']!"
    assert DEFAULT_BOT_CONFIG["tasks"]["skills"]["enabled"] is False, "skills default enabled should be False!"
    print("  ✅ Stage 2 passed: bot_manager registration verified.")

    # Stage 3: API Whitelist & Validation verification
    print("\n[Stage 3] Verifying api_server.py CastleConfigModel...")
    from api_server import CastleConfigModel, SkillsConfigModel
    test_payload = {
        "skills": {
            "enabled": True,
            "target_skills": ["11011", "12008", "13020"]
        }
    }
    model = CastleConfigModel(**test_payload)
    dumped = model.model_dump(exclude_none=True)
    assert "skills" in dumped, "skills was dropped by CastleConfigModel!"
    assert dumped["skills"]["enabled"] is True, "skills enabled value mismatch!"
    assert dumped["skills"]["target_skills"] == ["11011", "12008", "13020"], "target_skills value mismatch!"
    print("  ✅ Stage 3 passed: API Pydantic model successfully validated and whitelisted.")

    # Stage 4: Database Migration & Persistence verification
    print("\n[Stage 4] Verifying database/castles.db actual rows...")
    db_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()
    assert len(rows) > 0, "No castles found in database!"
    for cid, em, cfg_str in rows:
        cfg = json.loads(cfg_str)
        assert "skills" in cfg, f"Castle {em} ({cid}) missing root 'skills' in config!"
        assert isinstance(cfg["skills"], dict), f"Castle {em} 'skills' is not a dict!"
        assert "enabled" in cfg["skills"] and "target_skills" in cfg["skills"], f"Castle {em} 'skills' missing keys!"
    conn.close()
    print(f"  ✅ Stage 4 passed: All {len(rows)} castles in SQLite have valid skills config.")

    # Stage 5 & 6: Frontend & Localization consistency
    print("\n[Stage 5 & 6] Verifying localization files sync...")
    locales = ["ar.json", "en.json", "tr.json"]
    loc_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "dashboard", "src", "locales")
    expected_keys = [
        "lordSkills", "lordSkillsDesc",
        "skillCategoryBattle", "skillCategoryDevelop", "skillCategoryAuxiliary",
        "skill11011", "skill11028", "skill11029", "skill11042", "skill11056", "skill11057",
        "skill12008", "skill12022", "skill12023", "skill12031", "skill12042",
        "skill13020", "skill13021", "skill13022", "skill13032", "skill13040"
    ]
    for loc_file in locales:
        p = os.path.join(loc_dir, loc_file)
        with open(p, "r", encoding="utf-8") as f:
            data = json.load(f)
            tasks_data = data.get("tasks", {})
            for ek in expected_keys:
                assert ek in tasks_data, f"Key '{ek}' missing from {loc_file} under 'tasks'!"
    print("  ✅ Stage 5 & 6 passed: All 21 keys present across Arabic, English, and Turkish locales.")

    print("\n" + "=" * 60)
    print("🎉 ALL 6 STAGES VERIFIED 100% SUCCESSFULLY!")
    print("=" * 60)

if __name__ == "__main__":
    run_e2e_tests()
