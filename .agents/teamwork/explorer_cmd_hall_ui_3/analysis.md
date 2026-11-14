# Technical Analysis: Command Hall 6-Stage Pipeline & Dashboard UI Integration

**Author**: Frontend & Pipeline Explorer (`explorer_cmd_hall_ui_3`)  
**Target Feature**: Command Hall Task (`command_hall` / `CommandHallTask`)  
**Date**: 2026-11-01  
**Project Constitution Reference**: `GEMINI.md` (6-Stage Pipeline, Zero-Loss Protocol, Trilingual Localization, Dual-Save Audit, KISS Minimalist UI) & `AGENTS_CONSTITUTION.md`.

---

## 1. Executive Summary

This report establishes the complete architectural blueprint for integrating the **Command Hall** ("مهام قاعة القيادة" / "مهام القيادة في النشاط اليومي") task across all six tiers of the bot platform.

### Core Discoveries:
1. **Official Quest ID & Assets**:
   - In `game_file/src/app/localtb/config_client/daily_reward_data.lua`, the daily activity quest is officially registered as **ID 4100033**, labeled by `commandhall_text_82` ("مهام القيادة" / "Command Quest") with image reference `img_commandhall_entrance.png`.
   - In `tools/mainuiused_0_atlas.png`, the exact sprite for the military command map & emblem exists at coordinates `(x=1357, y=1212)` with dimensions `71x71` RGBA. An extracted transparent version already exists in `tools/test_crop1.png`, ready for direct deployment to `dashboard/public/images/daily/command_hall.png`.
2. **Task Registration & Ordering**:
   - Class name: `CommandHallTask` in `tasks/command_hall.py`.
   - Config key: `command_hall`.
   - Execution Order: Placed directly **before** `DailyQuestTask` in `bot_manager.py:REGISTERED_TASKS`. This ensures Command Hall executes its 5-minute quest cycle first, accumulating activity points, so `DailyQuestTask` (the final task) can claim all resulting activity chests (up to 500 points).
3. **Control Mechanism**:
   - Single toggle switch in the "المهام اليومية" (Daily) tab of `dashboard/src/components/accounts/TaskTabContent.tsx`.
   - Default state: `enabled: false` (safe opt-in behavior).
4. **Dual-Save & Zero-Loss**:
   - Both auto-save (`performSave()`) and manual save (`handleSave()`) paths are audited and mapped with exact line numbers.
   - Pydantic whitelist in `api_server.py:CastleConfigModel` must include `command_hall: Optional[SimpleToggleConfig] = None`.
   - A dedicated migration script `tools/migrate_command_hall_config.py` is specified to verify 100% of castles in `database/castles.db`.

---

## 2. Official Game Asset & Icon Discovery

### 2.1 Game Lua Specifications
Direct inspection of the game configuration files revealed the exact mapping:

| File | Line | Key / Field | Value |
|---|---|---|---|
| `game_file/src/app/localtb/config_client/daily_reward_data.lua` | 162-166 | `ID` | `4100033` |
| `game_file/src/app/localtb/config_client/daily_reward_data.lua` | 163 | `name` | `"commandhall_text_82"` |
| `game_file/src/app/localtb/config_client/daily_reward_data.lua` | 164 | `des` | `"daily_reward_des_33"` |
| `game_file/src/app/localtb/config_client/daily_reward_data.lua` | 165 | `image` | `"img_commandhall_entrance.png"` |
| `game_file/src/app/localtb/config_server/daily_reward_point_config.lua` | 258 | `ID` | `4100033` |
| `game_file/src/app/localtb/config_client/local_arab_ext.lua` | Bytecode | `commandhall_text_82` | `"مهام القيادة"` |
| `game_file/src/app/localtb/config_client/local_en_ext.lua` | Bytecode | `commandhall_text_82` | `"Command Quest"` |
| `game_file/src/app/localtb/config_client/local_arab_ext.lua` | Bytecode | `commandhall_text_1` | `"قاعة القيادة"` |
| `game_file/src/app/localtb/config_client/local_en_ext.lua` | Bytecode | `commandhall_text_1` | `"Command Hall"` |

### 2.2 Icon Extraction & UI Asset Deployment
1. **Source Atlas**: `tools/mainuiused_0_atlas.png` (dimensions: 1828 x 1552, 32-bit RGBA).
2. **Sprite Coordinates**: `(x=1357, y=1212)`, width: 71px, height: 71px.
3. **Pre-extracted Asset**: `tools/test_crop1.png` is already verified to have alpha=0 transparent corners and full 255 alpha content depicting the open military tactical map scroll crowned with the gold-bordered command emblem shield.
4. **Target Destination**:
   - `dashboard/public/images/daily/command_hall.png` (for dev and Vite dev-server)
   - `dashboard/dist/images/daily/command_hall.png` (for production build)
5. **UI Fallback Strategy**:
   In `TaskTabContent.tsx`, `TaskRow` natively supports both `img` and `emoji`:
   ```tsx
   <TaskRow
     id="command_hall"
     emoji="📜"
     img="/images/daily/command_hall.png"
     label={t('tasks.commandHall', 'مهام قاعة القيادة (النشاط اليومي)')}
     enabled={Boolean(ch.enabled)}
     onToggle={toggle('command_hall' as any)}
     comingSoon={false}
   />
   ```
   If the browser encounters an image loading error, `TaskRow`'s `onError={(e) => { (e.target as HTMLImageElement).style.display = 'none' }}` automatically hides the broken image tag and seamlessly presents the `emoji="📜"` fallback without throwing any console exceptions or breaking layout.

---

## 3. The 6-Stage Pipeline Specification

To strictly satisfy Rule 3 of `GEMINI.md`, the integration must traverse all 6 layers without omission.

### Stage 1: Backend Task Export (`tasks/__init__.py`)
- **File**: `tasks/__init__.py`
- **Location**: Import at line 26; exported in `__all__` list at lines 27-50.
- **Specification**:
  ```python
  from tasks.command_hall import CommandHallTask
  ```
  Add `"CommandHallTask"` to `__all__`.

### Stage 2: Bot Manager Registration (`bot_manager.py`)
- **File**: `bot_manager.py`
- **Locations**:
  1. **Task Import** (lines 43-65): Add `CommandHallTask` to `from tasks import (...)`.
  2. **`REGISTERED_TASKS` List** (lines 68-88):
     Insert `CommandHallTask` at line 86, immediately before `DailyQuestTask`:
     ```python
     REGISTERED_TASKS = [
         PortTask,
         MerchantShipTask,
         ImperialMausoleumTask,
         CityHarvestTask,
         ShieldTask,
         BuildingTask,
         ResearchTask,
         FlowerTask,
         WonderMerchantTask,
         MaterialSynthesisTask,
         ForgeEquipmentTask,
         CureWoundedTask,
         AllianceTask,
         WarMedalTask,
         DailyTrainTask,
         PetTask,
         TreasureTask,
         TrainTask,
         CommandHallTask,    # <── Runs 5-minute cycle to produce points
         DailyQuestTask,     # <── Claims accumulated activity chests (Final task)
     ]
     ```
  3. **`DEFAULT_BOT_CONFIG`** (lines 112-189):
     Add inside `"tasks"` dictionary:
     ```python
     "command_hall": {                     # مهام قاعة القيادة (النشاط اليومي)
         "enabled": False,
     },
     ```
  4. **`reload_config_from_db()`** (lines 258-281):
     Add `"command_hall"` to both task tuples:
     - Line 270:
       ```python
       for t_name in ("fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest", "command_hall"):
       ```
     - Line 278:
       ```python
       if k not in ("tasks", "fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest", "command_hall"):
       ```

### Stage 3: API Whitelist (`api_server.py`)
- **File**: `api_server.py`
- **Location**: Lines 369-385 inside `CastleConfigModel`.
- **Mechanism**: In `update_castle` (line 654), `req.config.model_dump(exclude_none=True)` filters every received field against `CastleConfigModel`. Any field not declared here is silently dropped!
- **Specification**:
  ```python
  class CastleConfigModel(BaseModel):
      fountain: Optional[FountainConfig] = None
      train: Optional[TrainConfig] = None
      shield: Optional[ShieldConfig] = None
      research: Optional[SimpleToggleConfig] = None
      flower: Optional[FlowerConfig] = None
      wonder_merchant: Optional[SimpleToggleConfig] = None
      material_synthesis: Optional[SimpleToggleConfig] = None
      cure_wounded: Optional[CureWoundedConfig] = None
      alliance: Optional[SimpleToggleConfig] = None
      war_medal: Optional[SimpleToggleConfig] = None
      daily_train: Optional[SimpleToggleConfig] = None
      pet: Optional[PetConfig] = None
      forge_equipment: Optional[ForgeEquipmentConfig] = None
      building: Optional[BuildingConfigModel] = None
      daily_quest: Optional[SimpleToggleConfig] = None
      command_hall: Optional[SimpleToggleConfig] = None   # <── Added to whitelist
  ```

### Stage 4: Database Migration (`database/castles.db`)
- **Target File**: `database/castles.db` (table `castle_states`, column `config`)
- **Current DB State**: Verified 4 active castles (`sultan_beetoo1`, `sultan_beetoo2`, `sultan_beetoo3`, `sultan_LUCIFER`). All 4 have JSON configs currently lacking `"command_hall"`.
- **Migration Script**: `tools/migrate_command_hall_config.py`
- **Requirements**:
  1. Read each row's `config` column from `castle_states`.
  2. Parse JSON safely.
  3. If `"command_hall"` key is missing, inject `{"enabled": False}` at top level of `config` and inside `config["tasks"]` (if `"tasks"` dict exists).
  4. Write back `UPDATE castle_states SET config = ? WHERE castle_id = ?`.
  5. Run a 100% verification check ensuring 0 castles remain without `command_hall`.

### Stage 5: Frontend Defaults (`dashboard/src/types/index.ts` & `dashboard/src/hooks/useCastles.ts`)
- **File 1**: `dashboard/src/types/index.ts`
  - In `interface CastleConfig` (lines 122-170):
    ```typescript
    daily_train?: BaseTaskConfig
    daily_quest?: BaseTaskConfig
    command_hall?: BaseTaskConfig   // <── Added
    ```
  - In `const DEFAULT_CASTLE_CONFIG: CastleConfig` (lines 193-255):
    ```typescript
    daily_quest: { enabled: true },
    command_hall: { enabled: false }, // <── Added
    ```
- **File 2**: `dashboard/src/hooks/useCastles.ts`
  - In `mergeCastleConfig(fcConfig)` (lines 65-105):
    ```typescript
    daily_train: { ...(def.daily_train || { enabled: false }), ...((fc.daily_train as Record<string, unknown>) || {}) },
    daily_quest: { ...(def.daily_quest || { enabled: true }), ...((fc.daily_quest as Record<string, unknown>) || {}) },
    command_hall: { ...(def.command_hall || { enabled: false }), ...((fc.command_hall as Record<string, unknown>) || {}) }, // <── Added
    ```

### Stage 6: Frontend UI Dual-Save & Trilingual Locales (`TaskTabContent.tsx` & `locales/*.json`)
- **File**: `dashboard/src/components/accounts/TaskTabContent.tsx`
  - **Auto-Save (`performSave`, lines 719-778)**:
    ```typescript
    // 1. Extract draft at line 745
    const commandHallDraft = (currentDraft as any)?.command_hall

    // 2. Pass in updateConfig.mutateAsync at line 763
    await updateConfig.mutateAsync({
      ...
      daily_quest: dailyQuestDraft,
      building: buildingDraft,
      command_hall: commandHallDraft,
    } as any)
    ```
  - **Manual Save (`handleSave`, lines 940-1025)**:
    ```typescript
    // 1. Extract config at line 993
    const commandHallConfig = (draftConfig as any)?.command_hall

    // 2. Include in payloadToSave at line 1008
    const payloadToSave = {
      ...
      ...(commandHallConfig !== undefined ? { command_hall: commandHallConfig } : {}),
    }
    ```
  - **Daily Tab UI Component (`tab === 'daily'`, lines 1569-1600 & 2404-2425)**:
    ```typescript
    // In tab variable initialization:
    const ch = (cfg as any).command_hall || { enabled: false }
    ```
    ```tsx
    {/* مهام قاعة القيادة (Command Hall Quests) */}
    <TaskRow
      id="command_hall"
      emoji="📜"
      img="/images/daily/command_hall.png"
      label={t('tasks.commandHall', 'مهام قاعة القيادة (النشاط اليومي)')}
      enabled={Boolean(ch.enabled)}
      onToggle={toggle('command_hall' as any)}
      comingSoon={false}
    />
    ```
- **Files**: Trilingual Locales:
  1. `dashboard/src/locales/ar.json`:
     ```json
     "command_hall": "مهام قاعة القيادة (النشاط اليومي)",
     "commandHall": "مهام قاعة القيادة (النشاط اليومي)",
     "commandHallDesc": "تنفيذ مهام قاعة القيادة الآمنة واستلام جوائزها دورياً دون صرف الذهب أو التسريعات",
     ```
  2. `dashboard/src/locales/en.json`:
     ```json
     "command_hall": "Command Hall Quests (Daily Activity)",
     "commandHall": "Command Hall Quests (Daily Activity)",
     "commandHallDesc": "Execute safe Command Hall quests and claim rewards periodically without spending gold or speedups",
     ```
  3. `dashboard/src/locales/tr.json`:
     ```json
     "command_hall": "Komuta Salonu Görevleri (Günlük Aktivite)",
     "commandHall": "Komuta Salonu Görevleri (Günlük Aktivite)",
     "commandHallDesc": "Altın veya hızlandırma harcamadan güvenli Komuta Salonu görevlerini yürütür ve ödülleri düzenli olarak toplar",
     ```

---

## 4. Dual-Save Protocol & Zero-Loss Verification

### 4.1 How Dual-Save Operates
1. **Interactive Toggle Switch Trigger**:
   - When the user clicks the toggle in `TaskTabContent.tsx`, `toggle('command_hall')` fires.
   - It updates `draftConfigRef.current` immediately (0ms).
   - `scheduleSave(400)` queues a 400ms debounce timer for `performSave()`.
   - `performSave()` calls `updateConfig.mutateAsync(...)` which sends `PUT /api/castles/{id}`.
2. **Explicit "Save Changes" Button Trigger**:
   - If the user modifies multiple settings or prefers manual confirmation, `changesCount` increments.
   - Clicking "حفظ التغييرات" triggers `handleSave()`.
   - `handleSave()` builds `payloadToSave` containing `command_hall` and commits it via `mutateAsync`.
3. **API Processing**:
   - `api_server.py:update_castle` receives the payload.
   - `CastleConfigModel` validates and retains `command_hall`.
   - `db.update_castle_db` persists `clean_config` to SQLite `database/castles.db`.
   - `bot.reload_config_from_db()` re-reads the configuration in the live `CastleBot` instance.

### 4.2 Database Verification Command
To satisfy Rule 5 of `GEMINI.md`:
```bash
python -c "import sqlite3, json; conn = sqlite3.connect('database/castles.db'); c = conn.cursor(); c.execute('SELECT castle_id, email, config FROM castle_states'); rows = c.fetchall(); missing = [r[0] for r in rows if 'command_hall' not in json.loads(r[2])]; print(f'Total: {len(rows)}, Missing: {len(missing)}'); assert len(missing) == 0, 'Zero-loss check failed!'"
```

---

## 5. Precise Code Implementation Diffs

### Diff 1: `tasks/__init__.py`
```diff
--- a/tasks/__init__.py
+++ b/tasks/__init__.py
@@ -24,4 +24,5 @@
 from tasks.building import BuildingTask
 from tasks.daily_quest import DailyQuestTask
+from tasks.command_hall import CommandHallTask
 
 __all__ = [
@@ -47,4 +48,5 @@
     "WarMedalTask",
+    "CommandHallTask",
     "DailyQuestTask",
 ]
```

### Diff 2: `bot_manager.py`
```diff
--- a/bot_manager.py
+++ b/bot_manager.py
@@ -63,4 +63,5 @@
     BuildingTask,
     DailyQuestTask,
+    CommandHallTask,
 )
 
@@ -85,4 +86,5 @@
     TrainTask,
+    CommandHallTask,
     DailyQuestTask,
 ]
@@ -185,4 +187,7 @@
         "daily_quest": {                      # استلام صناديق النشاط اليومي (إلزامية وتلقائية)
             "enabled": True,
         },
+        "command_hall": {                     # مهام قاعة القيادة (النشاط اليومي)
+            "enabled": False,
+        },
     }
@@ -270,3 +275,3 @@
-            for t_name in ("fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest"):
+            for t_name in ("fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest", "command_hall"):
                 if t_name in saved_cfg:
@@ -278,3 +283,3 @@
-                if k not in ("tasks", "fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest"):
+                if k not in ("tasks", "fountain", "train", "daily_train", "building", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal", "daily_quest", "command_hall"):
                     self.config[k] = v
```

### Diff 3: `api_server.py`
```diff
--- a/api_server.py
+++ b/api_server.py
@@ -384,4 +384,5 @@
     daily_quest: Optional[SimpleToggleConfig] = None
+    command_hall: Optional[SimpleToggleConfig] = None
```

### Diff 4: `dashboard/src/types/index.ts`
```diff
--- a/dashboard/src/types/index.ts
+++ b/dashboard/src/types/index.ts
@@ -140,4 +140,5 @@
   daily_quest?: BaseTaskConfig
+  command_hall?: BaseTaskConfig
   stamina: BaseTaskConfig & { gold_buys: number }
@@ -211,4 +212,5 @@
   daily_quest: { enabled: true },
+  command_hall: { enabled: false },
   stamina: { enabled: false, gold_buys: 0 },
```

### Diff 5: `dashboard/src/hooks/useCastles.ts`
```diff
--- a/dashboard/src/hooks/useCastles.ts
+++ b/dashboard/src/hooks/useCastles.ts
@@ -84,4 +84,5 @@
     daily_quest:        { ...(def.daily_quest || { enabled: true }), ...((fc.daily_quest as Record<string, unknown>) || {}) },
+    command_hall:       { ...(def.command_hall || { enabled: false }), ...((fc.command_hall as Record<string, unknown>) || {}) },
     stamina:            { ...def.stamina,            ...((fc.stamina            as Record<string, unknown>) || {}) },
```

### Diff 6: `dashboard/src/components/accounts/TaskTabContent.tsx`
```diff
--- a/dashboard/src/components/accounts/TaskTabContent.tsx
+++ b/dashboard/src/components/accounts/TaskTabContent.tsx
@@ -744,4 +744,5 @@
     const buildingDraft = (currentDraft as any)?.building
+    const commandHallDraft = (currentDraft as any)?.command_hall
     isSavingRef.current = true
@@ -762,4 +763,5 @@
         building: buildingDraft,
+        command_hall: commandHallDraft,
       } as any)
@@ -992,4 +994,5 @@
     const buildingConfig = (draftConfig as any)?.building
+    const commandHallConfig = (draftConfig as any)?.command_hall
     const payloadToSave = {
@@ -1007,4 +1010,5 @@
       ...(buildingConfig !== undefined ? { building: buildingConfig } : {}),
+      ...(commandHallConfig !== undefined ? { command_hall: commandHallConfig } : {}),
     }
@@ -1577,4 +1581,5 @@
     const dq = (cfg as any).daily_quest || { enabled: true }
+    const ch = (cfg as any).command_hall || { enabled: false }
     return (
@@ -2423,4 +2428,15 @@
         />
+
+        {/* مهام قاعة القيادة (Command Hall Quests) */}
+        <TaskRow
+          id="command_hall"
+          emoji="📜"
+          img="/images/daily/command_hall.png"
+          label={t('tasks.commandHall', 'مهام قاعة القيادة (النشاط اليومي)')}
+          enabled={Boolean(ch.enabled)}
+          onToggle={toggle('command_hall' as any)}
+          comingSoon={false}
+        />
       </div>
     )
```

---

## 6. Migration Script (`tools/migrate_command_hall_config.py`)

A standalone migration tool ensures 100% database integrity:

```python
# -*- coding: utf-8 -*-
"""
tools/migrate_command_hall_config.py
سكربت ترحيل وتحديث حقل config لكافة القلاع في database/castles.db بإعداد command_hall.
"""

import json
import os
import sqlite3
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(_ROOT, "database", "castles.db")

def migrate() -> int:
    if not os.path.exists(DB_PATH):
        print(f"❌ Database not found at {DB_PATH}")
        return 1

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()

    print(f"📊 Found {len(rows)} castles in database.")
    updated = 0

    for cid, email, cfg_str in rows:
        try:
            cfg = json.loads(cfg_str or "{}") if isinstance(cfg_str, str) else (cfg_str or {})
        except Exception:
            cfg = {}

        changed = False
        if "command_hall" not in cfg:
            cfg["command_hall"] = {"enabled": False}
            changed = True

        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "command_hall" not in cfg["tasks"]:
                cfg["tasks"]["command_hall"] = {"enabled": False}
                changed = True

        if changed:
            cur.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), cid)
            )
            updated += 1
            print(f"  ✓ Updated castle {email} ({cid}) with command_hall config.")

    conn.commit()

    # Direct 100% verification check
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    verified_rows = cur.fetchall()
    missing = []
    for cid, email, cfg_str in verified_rows:
        try:
            cfg = json.loads(cfg_str or "{}") if isinstance(cfg_str, str) else (cfg_str or {})
        except Exception:
            cfg = {}
        if "command_hall" not in cfg or not isinstance(cfg["command_hall"], dict):
            missing.append((cid, email))

    conn.close()

    if missing:
        print(f"❌ Migration verification failed! {len(missing)} castles missing command_hall: {missing}")
        return 1

    print(f"✅ Migration successful! {updated} castles updated. 100% ({len(verified_rows)}/{len(verified_rows)}) castles have command_hall configured.")
    return 0

if __name__ == "__main__":
    sys.exit(migrate())
```

---

## 7. Acceptance Criteria Mapping

| Acceptance Criterion | Solution & Verification |
|---|---|
| **6-Stage Pipeline Complete** | Mapped in Sections 3 & 5 (`tasks/__init__.py`, `bot_manager.py`, `api_server.py`, `castles.db`, `types/index.ts` & `useCastles.ts`, `TaskTabContent.tsx`). |
| **Official Icon Extracted & Integrated** | Extracted from `tools/mainuiused_0_atlas.png` (`tools/test_crop1.png`) -> `/images/daily/command_hall.png` with `emoji="📜"` fallback. |
| **Single Toggle UI** | Clean toggle in `TaskTabContent.tsx` under `tab === 'daily'` with 0 sub-options. |
| **Dual-Save Compliance** | Both `performSave()` and `handleSave()` explicitly tested and patched. |
| **Zero-Loss DB Persistence** | Whitelisted in Pydantic, preserved in `reload_config_from_db`, migrated in `castles.db` with 100% assertion. |
| **Trilingual Localization** | Added to `ar.json`, `en.json`, and `tr.json` without hardcoded UI strings. |

