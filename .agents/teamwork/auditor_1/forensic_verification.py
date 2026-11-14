# -*- coding: utf-8 -*-
"""
Forensic Integrity Verification Script
Executed independently by Auditor 1
"""
import ast
import asyncio
import copy
import json
import os
import sqlite3
import sys
import time

PROJECT_ROOT = r"e:\intqam-sultan"
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from tasks.base_task import BaseTask, TaskResult
from tasks.forge_equipment import (
    ForgeEquipmentTask,
    CATEGORY_PREFIX_MAP,
    CATEGORY_MATERIAL_PAIRS,
    EQUIPMENT_LEVELS_DESC,
    LEVEL_SPECS,
    CMD_EQUIPMENT_MODULE,
    REQ_FORGE_EQUIPMENT,
    REQ_GET_EQUIPMENT,
    DAILY_QUEST_FORGE_ID,
    DAILY_QUEST_FORGE_TYPE,
    RES_STEEL_ID,
)
import bot_manager
from api_server import ForgeEquipmentConfig, CastleConfigModel, CastleUpdateRequest

class ForensicAuditorRunner:
    def __init__(self):
        self.results = {}
        self.evidence = {}

    def log_check(self, name, passed, detail=""):
        self.results[name] = "PASS" if passed else "FAIL"
        self.evidence[name] = detail
        status_icon = "✓ PASS" if passed else "✗ FAIL"
        print(f"[{status_icon}] {name}: {detail}")

    def audit_ast_and_source(self):
        """Phase 1: Source code & AST analysis to detect facades, hardcoded outputs, or dummy returns."""
        file_path = os.path.join(PROJECT_ROOT, "tasks", "forge_equipment.py")
        with open(file_path, "r", encoding="utf-8") as f:
            source = f.read()

        parsed = ast.parse(source)
        
        # Check class existence and inheritance
        classes = [node for node in parsed.body if isinstance(node, ast.ClassDef)]
        task_classes = [c for c in classes if c.name == "ForgeEquipmentTask"]
        if not task_classes:
            self.log_check("AST: ForgeEquipmentTask class definition", False, "Class not found")
            return
        
        task_class = task_classes[0]
        base_names = [b.id for b in task_class.bases if isinstance(b, ast.Name)]
        has_base = "BaseTask" in base_names
        self.log_check("AST: Inherits from BaseTask", has_base, f"Bases: {base_names}")

        # Check methods
        methods = [m for m in task_class.body if isinstance(m, (ast.FunctionDef, ast.AsyncFunctionDef))]
        method_names = [m.name for m in methods]
        
        required_methods = [
            "_is_daily_quest_completed",
            "_get_blacksmith_level",
            "_get_item_count_in_bag",
            "_get_current_steel",
            "_ensure_steel_balance",
            "_find_base_item_in_bag",
            "_select_materials_for_recipe",
            "can_run",
            "run",
        ]
        has_all_methods = all(m in method_names for m in required_methods)
        self.log_check("AST: Method implementation completeness", has_all_methods, f"Methods found: {len(method_names)}")

        # Check for facade / dummy return patterns in methods
        facades = []
        for m in methods:
            # Check if body is just 'pass' or just 'return <constant>'
            if len(m.body) == 1:
                stmt = m.body[0]
                if isinstance(stmt, ast.Pass):
                    facades.append(f"{m.name} is pass")
                elif isinstance(stmt, ast.Return) and isinstance(stmt.value, ast.Constant):
                    facades.append(f"{m.name} returns constant {stmt.value.value}")
        self.log_check("AST: Facade detection", len(facades) == 0, f"Facades found: {facades}")

        # Check for hardcoded test shortcuts (looking for test/mock branches)
        suspicious = []
        for node in ast.walk(parsed):
            if isinstance(node, ast.Compare):
                # Check if comparing against suspicious test strings
                for comp in node.comparators:
                    if isinstance(comp, ast.Constant) and isinstance(comp.value, str):
                        if comp.value.lower() in ("test", "mock", "dummy", "fake"):
                            suspicious.append(comp.value)
        self.log_check("AST: Hardcoded test branch detection", len(suspicious) == 0, f"Suspicious comparisons: {suspicious}")

    def audit_bot_manager_integration(self):
        """Verify bot_manager registration, default config, and reload logic."""
        reg_ok = ForgeEquipmentTask in bot_manager.REGISTERED_TASKS
        self.log_check("BotManager: REGISTERED_TASKS registration", reg_ok, "Present in REGISTERED_TASKS")

        cfg_ok = "forge_equipment" in bot_manager.DEFAULT_BOT_CONFIG["tasks"]
        def_cfg = bot_manager.DEFAULT_BOT_CONFIG["tasks"].get("forge_equipment", {})
        val_ok = def_cfg.get("enabled") is False and def_cfg.get("category") == "weapon"
        self.log_check("BotManager: DEFAULT_BOT_CONFIG presence and defaults", cfg_ok and val_ok, f"Default config: {def_cfg}")

        # Verify bot_manager task execution cycle recognizes task
        task_instance = ForgeEquipmentTask(None, None, {"enabled": False})
        self.log_check("BotManager: Task naming protocol", task_instance.name == "forge_equipment", f"Task name: {task_instance.name}")

    def audit_api_server_integration(self):
        """Verify api_server schema, normalization, and update clean_config."""
        m_def = ForgeEquipmentConfig()
        def_ok = m_def.enabled is False and m_def.category == "weapon"
        self.log_check("API: ForgeEquipmentConfig defaults", def_ok, f"enabled={m_def.enabled}, category={m_def.category}")

        m_norm = ForgeEquipmentConfig(category="  HELMET  ")
        norm_ok = m_norm.category == "helmet"
        m_fallback = ForgeEquipmentConfig(category="INVALID_CAT")
        fallback_ok = m_fallback.category == "weapon"
        self.log_check("API: Category normalization & fallback", norm_ok and fallback_ok, f"norm={m_norm.category}, fallback={m_fallback.category}")

        ccm = CastleConfigModel(forge_equipment={"enabled": True, "category": "ring"})
        dumped = ccm.model_dump(exclude_none=True)
        dump_ok = dumped.get("forge_equipment") == {"enabled": True, "category": "ring"}
        self.log_check("API: CastleConfigModel integration", dump_ok, f"dumped={dumped.get('forge_equipment')}")

    def audit_database_castles(self):
        """Direct SQLite inspection of database/castles.db."""
        db_path = os.path.join(PROJECT_ROOT, "database", "castles.db")
        conn = sqlite3.connect(db_path)
        cur = conn.cursor()
        cur.execute("SELECT email, config FROM castle_states")
        rows = cur.fetchall()
        total = len(rows)
        valid = 0
        for email, cfg_raw in rows:
            cfg = json.loads(cfg_raw) if cfg_raw else {}
            fe = cfg.get("forge_equipment")
            if isinstance(fe, dict) and "enabled" in fe and "category" in fe:
                valid += 1
        conn.close()
        db_ok = (total > 0 and valid == total)
        self.log_check("Database: Direct SQLite castles.db verification", db_ok, f"{valid}/{total} castles have valid forge_equipment config")

    def audit_frontend_dual_save_and_locales(self):
        """Verify frontend types, hooks, dual-save in TaskTabContent, and translations."""
        # 1. Check locales
        keys = ['forgeEquipment', 'forgeEquipmentDesc', 'forgeCategory', 'equipWeapon', 'equipClothes', 'equipHelmet', 'equipTrousers', 'equipShoes', 'equipRing']
        locales_ok = True
        missing_report = {}
        for lang in ['ar', 'en', 'tr']:
            loc_path = os.path.join(PROJECT_ROOT, "dashboard", "src", "locales", f"{lang}.json")
            with open(loc_path, "r", encoding="utf-8") as f:
                d = json.load(f)
            t_tasks = d.get("tasks", {})
            miss = [k for k in keys if k not in t_tasks]
            if miss:
                locales_ok = False
                missing_report[lang] = miss
        self.log_check("Frontend: Trilingual localization", locales_ok, f"Missing: {missing_report if missing_report else 'None'}")

        # 2. Check TaskTabContent.tsx dual-save paths
        ttc_path = os.path.join(PROJECT_ROOT, "dashboard", "src", "components", "accounts", "TaskTabContent.tsx")
        with open(ttc_path, "r", encoding="utf-8") as f:
            ttc = f.read()

        has_perform_save = "forge_equipment: forgeEquipmentDraft" in ttc
        has_handle_save = "forge_equipment: forgeEquipmentConfig" in ttc
        has_ui_control = 'id="forge_equipment"' in ttc and 'comingSoon={false}' in ttc
        self.log_check("Frontend: Dual-save & UI controls", has_perform_save and has_handle_save and has_ui_control,
                       f"performSave={has_perform_save}, handleSave={has_handle_save}, UI={has_ui_control}")

    def audit_behavioral_execution(self):
        """Behavioral execution of ForgeEquipmentTask with zero-network pre-flight and state sync."""
        class MockConn:
            def __init__(self, init_data):
                self.init_data = copy.deepcopy(init_data)
                self.is_connected = True
                self.queries = []
            def get_ctrl(self, name):
                return self.init_data.get(name, {})
            async def query(self, cmd, subcmd, data):
                self.queries.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data})
                return {"err": "0", "data": {"equipment": {"epid": 54321, "qly": 1}, "costTime": 360}}

        # Case A: 0-Network Pre-flight when quest completed
        init_a = {"everydayTaskCtrl": {"eventInfo": {"4100009": 1}}}
        conn_a = MockConn(init_a)
        task_a = ForgeEquipmentTask(conn_a, config={"enabled": True, "category": "weapon"})
        res_a = asyncio.run(task_a.safe_execute())
        a_ok = res_a.skipped is True and len(conn_a.queries) == 0
        self.log_check("Behavior: 0-Network Pre-flight on completed quest", a_ok, f"skipped={res_a.skipped}, queries={len(conn_a.queries)}")

        # Case B: Collection of ready piece (CMD 1047 SubCMD 2)
        now_ts = int(time.time())
        init_b = {
            "equipmentCtrl": {"equipment_array": [{"epid": 8888, "eid": 6100101, "wear": 0, "endTime": now_ts - 100}]},
            "everydayTaskCtrl": {"eventInfo": {}}
        }
        conn_b = MockConn(init_b)
        task_b = ForgeEquipmentTask(conn_b, config={"enabled": True, "category": "weapon"})
        res_b = asyncio.run(task_b.safe_execute())
        b_ok = (
            res_b.success is True
            and len(conn_b.queries) == 1
            and conn_b.queries[0]["cmd"] == "1047"
            and conn_b.queries[0]["subcmd"] == "2"
            and conn_b.queries[0]["data"] == {"epid": 8888}
            and conn_b.init_data["equipmentCtrl"]["equipment_array"][0]["endTime"] == 0
            and conn_b.init_data["everydayTaskCtrl"]["eventInfo"].get("4100009") == 1
        )
        self.log_check("Behavior: Ready piece collection & memory sync", b_ok, f"queries={len(conn_b.queries)}, memory_synced={b_ok}")

        # Case C: Genuine forging of Lv.1 weapon (CMD 1047 SubCMD 1)
        init_c = {
            "cityCtrl": {"reslist": {"1006": 500}, "blist": [{"binfo": {"bid": "115", "lv": "1"}}]},
            "equipmentCtrl": {"equipment_array": []},
            "backpackCtrl": {
                "200601": {"count": 5, "id": 200601},
                "200301": {"count": 5, "id": 200301},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        }
        conn_c = MockConn(init_c)
        task_c = ForgeEquipmentTask(conn_c, config={"enabled": True, "category": "weapon"})
        res_c = asyncio.run(task_c.safe_execute())
        c_ok = (
            res_c.success is True
            and len(conn_c.queries) == 1
            and conn_c.queries[0]["cmd"] == "1047"
            and conn_c.queries[0]["subcmd"] == "1"
            and conn_c.queries[0]["data"]["eid"] == 6100101
            and conn_c.queries[0]["data"]["materialArray"] == [200601, 200301]
            and conn_c.queries[0]["data"]["mainMaterialID"] == 0
            and conn_c.init_data["cityCtrl"]["reslist"]["1006"] == 400
            and conn_c.init_data["backpackCtrl"]["200601"]["count"] == 4
            and conn_c.init_data["backpackCtrl"]["200301"]["count"] == 4
        )
        self.log_check("Behavior: Genuine Lv.1 forging & full resource/state sync", c_ok, f"queries={len(conn_c.queries)}, steel_synced={conn_c.init_data['cityCtrl']['reslist']['1006']}")

    def run_all(self):
        print("==================================================================")
        print("STARTING INDEPENDENT FORENSIC AUDIT (Auditor 1)")
        print("==================================================================")
        self.audit_ast_and_source()
        self.audit_bot_manager_integration()
        self.audit_api_server_integration()
        self.audit_database_castles()
        self.audit_frontend_dual_save_and_locales()
        self.audit_behavioral_execution()

        failed_checks = [k for k, v in self.results.items() if v != "PASS"]
        total = len(self.results)
        passed = total - len(failed_checks)
        print("==================================================================")
        print(f"FORENSIC AUDIT SUMMARY: {passed}/{total} CHECKS PASSED")
        if failed_checks:
            print(f"FAILED CHECKS: {failed_checks}")
            verdict = "INTEGRITY VIOLATION"
        else:
            verdict = "CLEAN"
        print(f"VERDICT: {verdict}")
        print("==================================================================")
        return verdict == "CLEAN"

if __name__ == "__main__":
    runner = ForensicAuditorRunner()
    ok = runner.run_all()
    sys.exit(0 if ok else 1)
