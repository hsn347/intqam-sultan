# -*- coding: utf-8 -*-
"""
tools/test_connection_circuit_breaker.py
Comprehensive unit tests verifying the Connection Circuit Breaker (قاطع الاتصال)
across BaseTask, CommandHallTask, and BotManager lifecycle.
"""

import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.base_task import BaseTask, TaskResult, ConnectionCircuitBreakerError
from tasks.command_hall import (
    CommandHallTask,
    TASK_TYPE_SNIPE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_BATTLE,
    TASK_STATUE_READY,
)


class MockCircuitConn:
    def __init__(self, init_data=None, is_connected=True):
        self.init_data = init_data or {}
        if "cityCtrl" not in self.init_data:
            self.init_data["cityCtrl"] = {"level": 30}
        self.is_connected = is_connected
        self.query_count = 0
        self.queries = []
        self.responses = {}
        self.closed = False

    def set_response(self, cmd, subcmd, resp):
        self.responses[(int(cmd), int(subcmd))] = resp

    async def query(self, cmd, subcmd, payload=None, **kwargs):
        if not self.is_connected:
            raise ConnectionResetError("Socket EOF / Disconnected")
        self.query_count += 1
        self.queries.append((int(cmd), int(subcmd), payload or {}))
        return self.responses.get((int(cmd), int(subcmd)), {"err": 0, "rspdata": {}})

    async def close(self):
        self.closed = True
        self.is_connected = False


async def test_can_run_trips_on_disconnected():
    print("--- Test 1: can_run() trips on disconnected socket ---")
    mock_conn = MockCircuitConn(is_connected=False)
    task = CommandHallTask(mock_conn, config={"enabled": True})

    can_exec, reason = await task.can_run()
    assert can_exec is False, "can_run must be False when disconnected"
    assert "قاطع الاتصال" in reason or "اتصال" in reason, f"Expected circuit breaker reason, got: {reason}"
    assert mock_conn.query_count == 0, "No network queries must be sent"
    print(f"✅ PASSED: can_run correctly rejected disconnected socket ({reason})")


async def test_safe_query_raises_circuit_breaker():
    print("\n--- Test 2: safe_query() raises ConnectionCircuitBreakerError on dead socket ---")
    mock_conn = MockCircuitConn(is_connected=False)
    task = CommandHallTask(mock_conn, config={"enabled": True})

    raised = False
    try:
        await task.safe_query("1000", "1", {})
    except ConnectionCircuitBreakerError as e:
        raised = True
        print(f"✅ PASSED: safe_query raised ConnectionCircuitBreakerError: {e}")

    assert raised is True, "safe_query must raise ConnectionCircuitBreakerError when disconnected"
    assert mock_conn.query_count == 0, "No network queries must be sent"


async def test_command_hall_stops_midway_when_connection_drops():
    print("\n--- Test 3: Command Hall stops immediately when connection drops mid-execution ---")
    # Setup: 2 sniper tasks, 2 rescue tasks, 2 dialogue tasks, 2 battle tasks (total 8 tasks)
    mock_conn = MockCircuitConn({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 101, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5},
                {"taskID": 6002, "index": 102, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 4},
                {"taskID": 4001, "index": 103, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_READY, "quality": 4},
                {"taskID": 4002, "index": 104, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_READY, "quality": 3},
            ]
        }
    }, is_connected=True)

    # Responses for Snipe task 101
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 101, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 102, "count": 2}]}})

    # After task 101 executes (queries 1 and 2), simulate connection drop on task 102!
    orig_query = mock_conn.query
    query_num = 0

    async def disconnect_on_task_102(cmd, subcmd, payload=None, **kwargs):
        nonlocal query_num
        query_num += 1
        # Task 101 takes query 1 (SubCMD 5) and query 2 (SubCMD 8)
        if query_num > 2:
            mock_conn.is_connected = False
            raise ConnectionResetError("Socket EOF / Disconnected")
        return await orig_query(cmd, subcmd, payload, **kwargs)

    mock_conn.query = disconnect_on_task_102

    task = CommandHallTask(
        mock_conn,
        config={"enabled": True, "allow_snipe": True, "allow_rescue": True, "allow_marches": False}
    )

    res = await task.run()

    # Verify task result
    assert res.success is True, f"Expected ok result for completed task, got {res}"
    assert res.data["completed_snipe"] == 1, f"Expected 1 snipe completed, got {res.data['completed_snipe']}"
    assert res.data["completed_rescue"] == 0, f"Expected 0 rescues (circuit breaker tripped), got {res.data['completed_rescue']}"
    assert res.data["failed_tasks"] == 0, f"Expected 0 failed tasks (must NOT accumulate fake failures), got {res.data['failed_tasks']}"
    assert res.data["circuit_broken"] is True, "circuit_broken flag must be True"
    assert "قاطع الاتصال" in res.message, f"Expected circuit breaker note in message, got: {res.message}"
    print(f"✅ PASSED: Circuit breaker cleanly stopped remaining 3 tasks without errors ({res.message})")


async def test_command_hall_trips_at_start_without_partial_work():
    print("\n--- Test 4: Command Hall behavior when disconnected with 0 completions ---")
    mock_conn = MockCircuitConn({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 201, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5},
            ]
        }
    }, is_connected=False)

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_snipe": True, "allow_marches": False})

    # Case 4a: Disconnected before can_run -> returns skip safely
    res = await task.run()
    assert res.skipped is True, "Must skip safely when disconnected at start"
    assert "قاطع الاتصال" in res.message
    print(f"✅ PASSED (4a): Safely skipped when disconnected before run: {res.message}")

    # Case 4b: Connection drops right after can_run, on the first query -> raises ConnectionCircuitBreakerError
    mock_conn.is_connected = True
    can_exec, _ = await task.can_run()
    assert can_exec is True

    # Drop connection right after can_run
    mock_conn.is_connected = False
    raised = False
    try:
        # Direct execution of subtask loop
        await task.execute_command_hall_snipe_task({"task_id": 6001, "index": 201, "type": 6})
    except ConnectionCircuitBreakerError as e:
        raised = True
        print(f"✅ PASSED (4b): Raised ConnectionCircuitBreakerError on subtask execution: {e}")

    assert raised is True, "Must raise ConnectionCircuitBreakerError when disconnected during execution"


async def test_bot_manager_circuit_breaker_halts_remaining_tasks():
    print("\n--- Test 5: BotManager execute_tasks halts sequence when circuit breaker trips ---")
    from bot_manager import CastleBot

    mock_conn = MockCircuitConn({
        "lordInfoCtrl": {"base": {"health": 80}},
        "cityCtrl": {"level": 30},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 301, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5},
            ]
        }
    }, is_connected=False)

    bot = CastleBot(email="test@castle.com", config={
        "tasks": {
            "command_hall": {"enabled": True},
            "daily_quest": {"enabled": True},
            "skills": {"enabled": True},
        }
    })
    bot.conn = mock_conn

    tripped = False
    try:
        await bot.execute_tasks()
    except ConnectionCircuitBreakerError as e:
        tripped = True
        print(f"✅ PASSED: BotManager execute_tasks halted with ConnectionCircuitBreakerError: {e}")

    assert tripped is True, "execute_tasks must trip circuit breaker and halt when connection is dead"


async def test_game_client_query_fast_fails_on_disconnected():
    print("\n--- Test 6: GameConnection.query fast-fails on disconnected socket ---")
    from core.game_client import GameConnection, AccountSession, GateCredentials

    acc = AccountSession(email="test@castle.com", user_id="123", session_id="abc")
    creds = GateCredentials(uid="123", server_name="s1", kingdom_id="1", gate_ip="127.0.0.1", gate_port=8000, secret="sec", sub_id="sub")
    conn = GameConnection(acc, creds)
    # Socket is NOT connected (conn._alive = False)
    assert conn.is_connected is False

    fast_failed = False
    try:
        await conn.query("1000", "1", {})
    except ConnectionResetError as e:
        fast_failed = True
        print(f"✅ PASSED: GameConnection.query immediately raised ConnectionResetError: {e}")

    assert fast_failed is True, "GameConnection.query must fast-fail on dead socket without stealth reconnect"


async def test_bot_manager_post_task_disconnect_raises_circuit_breaker():
    print("\n--- Test 7: BotManager raises ConnectionCircuitBreakerError if connection drops after task ---")
    from bot_manager import CastleBot

    mock_conn = MockCircuitConn({
        "lordInfoCtrl": {"base": {"health": 80}},
        "cityCtrl": {"level": 30},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 101, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5},
            ]
        }
    }, is_connected=True)

    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 101, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 102, "count": 2}]}})

    orig_query = mock_conn.query
    q_count = 0
    async def query_and_kill(cmd, subcmd, payload=None, **kwargs):
        nonlocal q_count
        q_count += 1
        res = await orig_query(cmd, subcmd, payload, **kwargs)
        if q_count >= 2:
            mock_conn.is_connected = False
        return res

    mock_conn.query = query_and_kill

    bot = CastleBot(email="test@castle.com", config={
        "tasks": {
            "command_hall": {"enabled": True, "allow_snipe": True, "allow_rescue": False, "allow_marches": False},
            "daily_quest": {"enabled": True},
        }
    })
    bot.conn = mock_conn

    breaker_tripped = False
    try:
        await bot.execute_tasks()
    except ConnectionCircuitBreakerError as e:
        breaker_tripped = True
        print(f"✅ PASSED: BotManager execute_tasks caught post-task dead socket and raised circuit breaker: {e}")

    assert breaker_tripped is True, "execute_tasks must raise ConnectionCircuitBreakerError after task disconnect"


async def main():
    await test_can_run_trips_on_disconnected()
    await test_safe_query_raises_circuit_breaker()
    await test_command_hall_stops_midway_when_connection_drops()
    await test_command_hall_trips_at_start_without_partial_work()
    await test_bot_manager_circuit_breaker_halts_remaining_tasks()
    await test_game_client_query_fast_fails_on_disconnected()
    await test_bot_manager_post_task_disconnect_raises_circuit_breaker()
    print("\n🎉 ALL CONNECTION CIRCUIT BREAKER TESTS PASSED 100%!")


if __name__ == "__main__":
    asyncio.run(main())
