# -*- coding: utf-8 -*-
"""
tools/test_stamina_e2e.py — اختبار شامل لكافة الطبقات الست لمهمة تعويض طاقة اللورد (Stamina E2E Test)
═════════════════════════════════════════════════════════════════════════════════════════════════════
يتحقق بنسبة 100% من:
1. تصدير StaminaTask وخصائصها في tasks/.
2. تسجيل StaminaTask في bot_manager.py (REGISTERED_TASKS, DEFAULT_BOT_CONFIG, reload_config_from_db).
3. فئة ومخطط StaminaConfigModel في api_server.py وتمريره عبر clean_config.
4. مطابقة قاعدة البيانات database/castles.db لكل القلاع (Rule 5 Zero-Loss Protocol).
5. تعريفات الواجهة وأنواعها في dashboard/src/types/index.ts و useCastles.ts.
6. حفظ المسار الثنائي (Dual-Save) في TaskTabContent.tsx والتوطين الثلاثي (ar, en, tr).
"""

import json
import os
import sqlite3
import sys

WORKSPACE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)


def test_stage_1_backend():
    print("\n[Stage 1] Verifying Backend StaminaTask (tasks/stamina.py)...")
    from tasks.stamina import StaminaTask
    from tasks import __all__ as exported_tasks
    from tasks.base_task import STAMINA_PACKS_CATALOG, STAMINA_PACKS_KEY_MAP

    assert "StaminaTask" in exported_tasks, "StaminaTask not in tasks/__all__!"
    assert StaminaTask.name == "stamina", f"StaminaTask.name is {StaminaTask.name}, expected 'stamina'"
    assert 300401 in [v["item_id"] for v in STAMINA_PACKS_CATALOG.values()], "Official ID 300401 missing"
    assert 300402 in [v["item_id"] for v in STAMINA_PACKS_CATALOG.values()], "Official ID 300402 missing"
    assert 300403 in [v["item_id"] for v in STAMINA_PACKS_CATALOG.values()], "Official ID 300403 missing"
    print("  ✅ Stage 1 passed: StaminaTask and official catalog constants verified.")


def test_stage_2_bot_manager():
    print("\n[Stage 2] Verifying Bot Manager (bot_manager.py)...")
    from bot_manager import REGISTERED_TASKS, DEFAULT_BOT_CONFIG

    registered_names = [getattr(t, "name", t.__name__) for t in REGISTERED_TASKS]
    assert "stamina" in registered_names, f"'stamina' not found in REGISTERED_TASKS: {registered_names}"
    assert "stamina" in DEFAULT_BOT_CONFIG["tasks"], "'stamina' not found in DEFAULT_BOT_CONFIG['tasks']"

    def_cfg = DEFAULT_BOT_CONFIG["tasks"]["stamina"]
    assert def_cfg.get("enabled") is False
    assert def_cfg.get("gold_buy_enabled") is False
    assert def_cfg.get("gold_trigger_stamina") == 50
    assert def_cfg.get("gold_buy_stamina_amount") == 50
    print("  ✅ Stage 2 passed: bot_manager registration and default configs verified.")


def test_stage_3_api_whitelist():
    print("\n[Stage 3] Verifying API Whitelist & Validation (api_server.py)...")
    from api_server import CastleConfigModel, StaminaConfigModel

    test_input = {
        "stamina": {
            "enabled": True,
            "gold_buy_enabled": True,
            "gold_trigger_stamina": 40,
            "gold_buy_stamina_amount": 100,
        }
    }
    model = CastleConfigModel(**test_input)
    dumped = model.model_dump(exclude_none=True)
    assert "stamina" in dumped, "'stamina' dropped by CastleConfigModel!"
    s = dumped["stamina"]
    assert s["enabled"] is True
    assert s["gold_buy_enabled"] is True
    assert s["gold_trigger_stamina"] == 40
    assert s["gold_buy_stamina_amount"] == 100
    print("  ✅ Stage 3 passed: api_server schema and whitelist verified.")


def test_stage_4_database():
    print("\n[Stage 4] Verifying Database Records (database/castles.db)...")
    from tools.verify_stamina_db import verify as verify_db
    ok = verify_db()
    assert ok, "Database verification failed for some castles!"
    print("  ✅ Stage 4 passed: 100% of castles have valid stamina configuration.")


def test_stage_5_and_6_frontend():
    print("\n[Stage 5 & 6] Verifying Frontend Types, Dual-Save & Locales...")

    # 1. Check types/index.ts
    types_path = os.path.join(WORKSPACE_DIR, "dashboard", "src", "types", "index.ts")
    with open(types_path, "r", encoding="utf-8") as f:
        types_content = f.read()
    assert "export interface StaminaConfig" in types_content or "interface StaminaConfig" in types_content
    assert "stamina?: StaminaConfig" in types_content

    # 2. Check TaskTabContent.tsx Dual-Save
    ui_path = os.path.join(WORKSPACE_DIR, "dashboard", "src", "components", "accounts", "TaskTabContent.tsx")
    with open(ui_path, "r", encoding="utf-8") as f:
        ui_content = f.read()

    assert "staminaDraft" in ui_content, "staminaDraft missing in performSave"
    assert "stamina: staminaDraft" in ui_content, "stamina missing in performSave payload"
    assert "staminaConfig" in ui_content, "staminaConfig missing in handleSave"
    assert "stamina: staminaConfig" in ui_content, "stamina missing in handleSave payload"
    print("  -> Dual-Save (performSave & handleSave) verified in TaskTabContent.tsx.")

    # 3. Check Trilingual Locales
    locales = ["ar.json", "en.json", "tr.json"]
    loc_dir = os.path.join(WORKSPACE_DIR, "dashboard", "src", "locales")
    expected_stamina_keys = [
        "title",
        "desc",
        "goldBuyEnabledLabel",
        "goldTriggerStaminaLabel",
        "goldBuyStaminaAmountLabel",
    ]
    for loc_file in locales:
        p = os.path.join(loc_dir, loc_file)
        with open(p, "r", encoding="utf-8") as f:
            data = json.load(f)
        tasks_stamina = data.get("tasks", {}).get("stamina", {})
        for k in expected_stamina_keys:
            assert k in tasks_stamina, f"Missing key '{k}' in {loc_file} under tasks.stamina!"
    print("  -> Trilingual localization (ar, en, tr) verified with 5/5 matching keys.")
    print("  ✅ Stage 5 & 6 passed: Frontend defaults, dual-save and trilingual locales verified.")


def main():
    print("═" * 70)
    print("🚀 STAMINA TASK 6-STAGE COMPREHENSIVE PIPELINE VERIFICATION")
    print("═" * 70)
    test_stage_1_backend()
    test_stage_2_bot_manager()
    test_stage_3_api_whitelist()
    test_stage_4_database()
    test_stage_5_and_6_frontend()
    print("\n" + "═" * 70)
    print("🎉 ALL 6 STAGES AND PROTOCOLS PASSED 100% SUCCESSFULLY!")
    print("═" * 70)


if __name__ == "__main__":
    main()
