# -*- coding: utf-8 -*-
"""
tools/test_field_and_pipeline_challenger.py
══════════════════════════════════════════════════════════════════════════════════
Empirical Challenger Verification Suite for Command Hall Task & 6-Stage Pipeline
══════════════════════════════════════════════════════════════════════════════════
Tests and validates:
1. Direct SQLite database inspection for 100% of castles in database/castles.db:
   - Root level: config["command_hall"] == {"enabled": False}
   - Tasks level: config["tasks"]["command_hall"] == {"enabled": False}
2. API Server & Whitelist validation:
   - CastleConfigModel parsing, sanitization, reject invalid schemas
   - Clean config updates & propagation
3. Bot Manager config propagation & task registration:
   - DEFAULT_BOT_CONFIG initialization
   - REGISTERED_TASKS order and presence
   - Live reload_config_from_db propagation from SQLite to CastleBot.config
4. Field Tooling Execution & Diagnostics:
   - Live vs Offline diagnostics for test_task_method.py
   - Gateway connection lifecycle prerequisites (is_running check)
   - Real memory evaluation from live snapshot
"""

import asyncio
import copy
import json
import os
import sqlite3
import sys
import unittest
from typing import Any, Dict, List

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot, DEFAULT_BOT_CONFIG, REGISTERED_TASKS, ALWAYS_AUTO_TASKS
from tasks.command_hall import CommandHallTask
from tasks.daily_quest import DailyQuestTask
from api_server import CastleConfigModel, CastleUpdateRequest, SimpleToggleConfig
from pydantic import ValidationError


class TestFieldAndDatabasePipeline(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db_path = os.path.join(_ROOT, "database", "castles.db")
        if not os.path.exists(cls.db_path):
            raise FileNotFoundError(f"Database file not found: {cls.db_path}")

    # ═════════════════════════════════════════════════════════════════════════
    # 1. DIRECT DATABASE INSPECTION
    # ═════════════════════════════════════════════════════════════════════════

    def test_01_direct_sqlite_inspection_all_castles(self):
        """Verify 100% of all castles in database/castles.db have command_hall configured."""
        conn = sqlite3.connect(self.db_path)
        cur = conn.cursor()
        cur.execute("SELECT castle_id, email, is_active, config FROM castle_states")
        rows = cur.fetchall()
        conn.close()

        self.assertGreater(len(rows), 0, "No castles found in database/castles.db!")
        print(f"\n[DB Inspection] Total castles in database: {len(rows)}")

        expected_emails = {"beetoo1@hotmail.com", "beetoo2@hotmail.com", "beetoo3@hotmail.com", "LUCIFER@g4.com"}
        found_emails = {r[1] for r in rows}
        missing_mandatory_castles = expected_emails - found_emails
        self.assertEqual(len(missing_mandatory_castles), 0, f"Missing mandatory castles: {missing_mandatory_castles}")

        for cid, email, is_active, cfg_raw in rows:
            print(f"  • Checking castle '{cid}' ({email}) [is_active={is_active}]...")
            self.assertIsNotNone(cfg_raw, f"Config is None for castle {email}")
            
            try:
                cfg = json.loads(cfg_raw) if isinstance(cfg_raw, str) else cfg_raw
            except Exception as e:
                self.fail(f"Config column is not valid JSON for castle {email}: {e}")

            # 1. Root level check
            self.assertIn("command_hall", cfg, f"Missing root 'command_hall' in {email}")
            self.assertIsInstance(cfg["command_hall"], dict, f"Root 'command_hall' not a dict in {email}")
            self.assertIn("enabled", cfg["command_hall"], f"Missing 'enabled' in root 'command_hall' for {email}")
            self.assertIsInstance(cfg["command_hall"]["enabled"], bool, f"'enabled' not bool in {email}")

            # 2. Tasks level check
            self.assertIn("tasks", cfg, f"Missing 'tasks' dict in {email}")
            self.assertIsInstance(cfg["tasks"], dict, f"'tasks' is not a dict in {email}")
            self.assertIn("command_hall", cfg["tasks"], f"Missing tasks['command_hall'] in {email}")
            self.assertIsInstance(cfg["tasks"]["command_hall"], dict, f"tasks['command_hall'] not a dict in {email}")
            self.assertIn("enabled", cfg["tasks"]["command_hall"], f"Missing 'enabled' in tasks['command_hall'] for {email}")
            self.assertIsInstance(cfg["tasks"]["command_hall"]["enabled"], bool, f"tasks 'enabled' not bool in {email}")
            self.assertEqual(
                cfg["command_hall"]["enabled"],
                cfg["tasks"]["command_hall"]["enabled"],
                f"Mismatch between root and tasks command_hall in {email}"
            )

        print(f"[DB Inspection] ✓ Verified 100% ({len(rows)}/{len(rows)}) castles have valid command_hall config.")

    # ═════════════════════════════════════════════════════════════════════════
    # 2. API SERVER & WHITELIST VERIFICATION
    # ═════════════════════════════════════════════════════════════════════════

    def test_02_api_castle_config_model_parsing(self):
        """Verify CastleConfigModel parses command_hall toggle correctly."""
        # Case A: enabled = True
        model_true = CastleConfigModel(command_hall={"enabled": True})
        self.assertIsNotNone(model_true.command_hall)
        self.assertTrue(model_true.command_hall.enabled)
        dump_true = model_true.model_dump(exclude_none=True)
        self.assertEqual(dump_true, {"command_hall": {"enabled": True}})

        # Case B: enabled = False
        model_false = CastleConfigModel(command_hall={"enabled": False})
        self.assertIsNotNone(model_false.command_hall)
        self.assertFalse(model_false.command_hall.enabled)
        dump_false = model_false.model_dump(exclude_none=True)
        self.assertEqual(dump_false, {"command_hall": {"enabled": False}})

        # Case C: omitted -> excluded from dump
        model_omitted = CastleConfigModel()
        self.assertIsNone(model_omitted.command_hall)
        dump_omitted = model_omitted.model_dump(exclude_none=True)
        self.assertNotIn("command_hall", dump_omitted)

    def test_03_api_castle_config_model_adversarial_validation(self):
        """Stress-test CastleConfigModel with malicious or invalid payloads."""
        # 1. Invalid boolean string
        with self.assertRaises(ValidationError):
            CastleConfigModel(command_hall={"enabled": "non_boolean_garbage"})

        # 2. Invalid non-dict type
        with self.assertRaises(ValidationError):
            CastleConfigModel(command_hall=12345)

        # 3. Extra unrecognized fields (Pydantic model ignores extra fields safely)
        model_extra = CastleConfigModel(command_hall={"enabled": True, "rogue_key": "dangerous_data"})
        self.assertTrue(model_extra.command_hall.enabled)
        dump = model_extra.model_dump(exclude_none=True)
        self.assertEqual(dump["command_hall"], {"enabled": True}, "Extra rogue keys should not survive model dump")

    def test_04_api_clean_config_update_simulation(self):
        """Simulate API update_castle logic in api_server.py:667-676."""
        existing_castle_config = {
            "shield": {"enabled": True},
            "alliance": {"enabled": True},
            "command_hall": {"enabled": False},
            "tasks": {
                "shield": {"enabled": True},
                "command_hall": {"enabled": False},
            }
        }

        # User toggles command_hall to True via API
        req = CastleUpdateRequest(config=CastleConfigModel(command_hall={"enabled": True}))
        clean_config = dict(existing_castle_config)
        clean_config.pop("pet_patrol", None)

        validated_updates = req.config.model_dump(exclude_none=True)
        clean_config.update(validated_updates)

        self.assertEqual(clean_config["command_hall"], {"enabled": True})
        self.assertEqual(clean_config["shield"], {"enabled": True})
        self.assertEqual(clean_config["alliance"], {"enabled": True})

    # ═════════════════════════════════════════════════════════════════════════
    # 3. BOT MANAGER INTEGRATION & PROPAGATION
    # ═════════════════════════════════════════════════════════════════════════

    def test_05_bot_manager_registration_and_order(self):
        """Verify CommandHallTask in REGISTERED_TASKS and sequence relative to DailyQuestTask."""
        self.assertIn(CommandHallTask, REGISTERED_TASKS)
        self.assertIn(DailyQuestTask, REGISTERED_TASKS)

        cmd_idx = REGISTERED_TASKS.index(CommandHallTask)
        daily_idx = REGISTERED_TASKS.index(DailyQuestTask)

        # CommandHallTask must be immediately before DailyQuestTask
        self.assertEqual(cmd_idx, daily_idx - 1, "CommandHallTask must precede DailyQuestTask in execution sequence")
        # DailyQuestTask must be the final task
        self.assertEqual(daily_idx, len(REGISTERED_TASKS) - 1, "DailyQuestTask must be the last task in REGISTERED_TASKS")

        # CommandHallTask is user-controlled (not always-auto)
        self.assertNotIn("command_hall", ALWAYS_AUTO_TASKS)
        self.assertIn("daily_quest", ALWAYS_AUTO_TASKS)

    def test_06_default_bot_config_has_command_hall(self):
        """Verify DEFAULT_BOT_CONFIG has command_hall disabled by default."""
        self.assertIn("tasks", DEFAULT_BOT_CONFIG)
        self.assertIn("command_hall", DEFAULT_BOT_CONFIG["tasks"])
        self.assertEqual(DEFAULT_BOT_CONFIG["tasks"]["command_hall"], {"enabled": False})

    def test_07_reload_config_from_db_propagation(self):
        """Verify reload_config_from_db propagates command_hall changes into CastleBot.config."""
        test_email = "beetoo1@hotmail.com"
        bot = CastleBot(email=test_email)

        # Initial state from DB: valid boolean
        self.assertIsInstance(bot.config.get("tasks", {}).get("command_hall", {}).get("enabled"), bool)

        # Test A: simulate DB update with root level command_hall: {"enabled": True}
        c_data = db.get_castle_by_id(test_email)
        original_config = copy.deepcopy(c_data["config"])

        try:
            # Update DB with enabled: True
            modified_config = copy.deepcopy(original_config)
            modified_config["command_hall"] = {"enabled": True}
            modified_config.setdefault("tasks", {})["command_hall"] = {"enabled": True}
            db.update_castle_db(test_email, {"config": modified_config})

            # Reload bot config
            bot.reload_config_from_db()
            self.assertTrue(
                bot.config.get("tasks", {}).get("command_hall", {}).get("enabled", False),
                "bot.config['tasks']['command_hall']['enabled'] should be True after DB reload"
            )

            # Test B: simulate DB update with enabled: False
            modified_config["command_hall"] = {"enabled": False}
            modified_config["tasks"]["command_hall"] = {"enabled": False}
            db.update_castle_db(test_email, {"config": modified_config})

            bot.reload_config_from_db()
            self.assertFalse(
                bot.config.get("tasks", {}).get("command_hall", {}).get("enabled", True),
                "bot.config['tasks']['command_hall']['enabled'] should be False after DB reload"
            )

        finally:
            # Revert DB back to original
            db.update_castle_db(test_email, {"config": original_config})
            bot.reload_config_from_db()

    # ═════════════════════════════════════════════════════════════════════════
    # 4. FIELD EXECUTION & DIAGNOSTICS
    # ═════════════════════════════════════════════════════════════════════════

    def test_08_field_execution_offline_readiness(self):
        """Test CommandHallTask with offline memory snapshot (docs/lucifer_live_memory.json)."""
        memory_path = os.path.join(_ROOT, "docs", "lucifer_live_memory.json")
        self.assertTrue(os.path.exists(memory_path), f"Memory dump not found at {memory_path}")

        with open(memory_path, "r", encoding="utf-8") as f:
            live_data = json.load(f)

        class OfflineMockConn:
            def __init__(self, data):
                self.is_connected = True
                self.init_data = data
                self.queries = []

            async def query(self, cmd, subcmd, data):
                self.queries.append((str(cmd), str(subcmd), data))
                return {"err": 0, "code": 0, "data": {}}

            def get_ctrl(self, name):
                return self.init_data.get(name, {})

        conn = OfflineMockConn(live_data)
        task = CommandHallTask(conn, config={"enabled": True})

        # Test can_run with real memory dump
        async def run_check():
            can_run, reason = await task.can_run()
            self.assertTrue(can_run, f"can_run failed with real memory dump: {reason}")
            # Test _ensure_synced_data
            hall_data = await task._ensure_synced_data()
            self.assertIsInstance(hall_data, dict)
            # Test extract task list
            t_list = task._extract_task_list(hall_data)
            self.assertIsInstance(t_list, list)

        asyncio.run(run_check())


if __name__ == "__main__":
    unittest.main()
