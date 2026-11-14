# Changes Summary: Milestone 1 - Training & Daily Train Synchronization (R1)

## Overview
Resolved training conflicts, eliminated Server Error 4002 (Barracks Busy), implemented 0-Network Pre-flight checks, seamless in-memory synchronization across live memory controllers (`queueCtrl`, `armyCtrl.trainArmy`, `cityCtrl.reslist`, `everydayTaskCtrl.eventInfo`, and `questCtrl.point_finish_list`), and added connection & capacity abort guards.

## Modified Files (Strict Write Ownership)
1. `tasks/train.py`
2. `tasks/daily_train.py`

---

## Detailed File Changes

### 1. `tasks/train.py`
- **Official Queue & Quest Mappings Added**:
  - `BID_TO_QUEUE_TYPE`: Maps `"118" -> "1203"`, `"116" -> "1204"`, `"117" -> "1205"`, `"119" -> "1206"`, `"120" -> "1207"`.
  - `QUEUE_TYPE_TO_BID`: Reverse lookup from queue type to building ID.
  - `BID_TO_DAILY_QUEST`: Maps barracks buildings to daily quest IDs and event types (`"12"` to `"16"`).
- **In-Memory Training Queue Sync (`sync_training_queue_in_memory`)**:
  - Creates or updates `conn.init_data['queueCtrl'][qtype]` with `starttime`, `totaltime`, `lefttime`, and detailed `data` (`bid`, `armyid`, `armycount`, `_uniqueid`, `costres`).
  - Updates `conn.init_data['armyCtrl']['trainArmy'][bid]` with timestamp and queue details.
  - Deducts resources in `conn.init_data['cityCtrl']['reslist']` using server `costres` or fallback `_ARMY_COSTS`.
  - Automatically increments `everydayTaskCtrl.eventInfo` and records quest in `questCtrl.point_finish_list` when >= 250 units trained.
- **In-Memory Harvesting Queue Release (`clear_harvested_queue_in_memory`)**:
  - Completely purges the harvested queue from `conn.init_data['queueCtrl']` (both by `qtype` and `data.bid`) and from `armyCtrl.trainArmy[bid]`.
- **Zero-Network Barracks Busy Pre-Flight (`check_barracks_busy`)**:
  - Comprehensive inspection of both `queueCtrl` and `armyCtrl.trainArmy`.
  - Accurately computes remaining time or detects unharvested troops.
  - Integrated into `TrainTask.run()` to skip busy barracks with ZERO network queries, completely eliminating Error 4002.
- **Connection & Capacity Guard**:
  - Verifies `conn.is_connected` before initiating harvest or training.
  - Aborts immediately if disconnected or if capacity <= 0 without retry loops.
  - In `_train_adaptive`: Handles errors `4002` (busy) and `4001` (tier locked) by immediately returning without infinite retries, while bounding `4004`/`4003` to safe adaptive reductions.

### 2. `tasks/daily_train.py`
- **Robust Configuration Extraction (`_extract_daily_train_config`)**:
  - Safely extracts `daily_train` config whether flat in `config` or nested under `config['tasks']['daily_train']`.
- **Everyday Quest Pre-flight Check (`_is_quest_completed`)**:
  - Inspects `everydayTaskCtrl.eventInfo` for keys `'12'` through `'16'` (and quest IDs `4100012` to `4100016`).
  - Inspects `questCtrl.point_finish_list`.
  - If event count >= 5, immediately skips with 0-Network calls and clean logging.
- **Smart Training Delegation (`_is_type_handled_by_main_train`)**:
  - Checks if user enabled `train` with tier > 0 for this troop type.
  - Seamlessly queries delegated `TrainTask` instance and falls back to config inspection.
  - If user trains this type in main train, daily_train defers to main train, preventing barracks occupancy by low-tier troops.
- **Barracks Busy 0-Network Pre-Flight**:
  - Uses `check_barracks_busy` to prevent sending daily training requests to already busy barracks.
- **Connection & Capacity Guard**:
  - Enforces `conn.is_connected` check before the run loop and inside each troop evaluation.
  - Bounded execution with zero retry loops upon disconnection.
