## 2026-10-31T11:45:57Z
You are Worker 2: API Whitelist & Database Migration Worker.
Your Working Directory: e:\intqam-sultan\.agents\teamwork\worker_database_m2\
Original Request Reference: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Project Reference: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Survey Findings Reference:
- e:\intqam-sultan\.agents\teamwork\explorer_survey_2\handoff.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write Ownership (Strict Boundary):
You own EXCLUSIVELY:
- `api_server.py`
- `database/castles.db` (and migration scripts inside your working directory)
Do NOT touch any other files in the project.

Scope of Work (Milestone 2):
1. Read ORIGINAL_REQUEST.md, PROJECT.md, and `explorer_survey_2/handoff.md` carefully.
2. Update `api_server.py`:
   - Create Pydantic model `ForgeEquipmentConfig`:
     ```python
     class ForgeEquipmentConfig(BaseModel):
         enabled: bool = False
         category: Literal["weapon", "clothes", "helmet", "trousers", "shoes", "ring"] = "weapon"

         @field_validator("category", mode="before")
         @classmethod
         def normalize_category(cls, v: Any) -> str:
             val = str(v or "weapon").lower().strip()
             return val if val in ("weapon", "clothes", "helmet", "trousers", "shoes", "ring") else "weapon"
     ```
   - Add `forge_equipment: Optional[ForgeEquipmentConfig] = None` to `CastleConfigModel`.
   - Verify that `update_castle` and `clean_config` properly validate and store `forge_equipment`.
3. Database Migration for `database/castles.db`:
   - Backup `database/castles.db` to a `.bak` timestamped file.
   - Run a migration script that updates all castle records in `castle_states`:
     * Read each castle row.
     * Parse `config` JSON.
     * If `forge_equipment` not in `config`, set `config["forge_equipment"] = {"enabled": False, "category": "weapon"}`.
     * Save updated JSON back to SQLite.
4. Direct Programmatic SQLite Verification:
   - Run a Python verification script that queries `database/castles.db` directly:
     * Print every castle ID and its `forge_equipment` config.
     * Assert 100% of castles have `forge_equipment`.
     * Assert no other config keys were altered or deleted.
5. Write a complete handoff report to: `e:\intqam-sultan\.agents\teamwork\worker_database_m2\handoff.md`.
Follow Handoff Protocol: Observation, Logic Chain, Caveats, Conclusion, Verification Method.
When done, send a message to your orchestrator (parent).
