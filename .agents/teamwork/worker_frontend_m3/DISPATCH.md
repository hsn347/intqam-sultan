## 2026-10-31T11:46:15Z
You are Worker 3: Frontend UI, Dual-Save & Trilingual Localization Worker.
Your Working Directory: e:\intqam-sultan\.agents\teamwork\worker_frontend_m3\
Original Request Reference: e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md
Project Reference: e:\intqam-sultan\.agents\teamwork\PROJECT.md
Survey Findings Reference:
- e:\intqam-sultan\.agents\teamwork\explorer_survey_3\handoff.md

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Write Ownership (Strict Boundary):
You own EXCLUSIVELY:
- `dashboard/src/types/index.ts`
- `dashboard/src/hooks/useCastles.ts`
- `dashboard/src/components/accounts/TaskTabContent.tsx`
- `dashboard/src/locales/ar.json`
- `dashboard/src/locales/en.json`
- `dashboard/src/locales/tr.json`
Do NOT touch any other files in the project.

Scope of Work (Milestone 3):
1. Read ORIGINAL_REQUEST.md, PROJECT.md, and `explorer_survey_3/handoff.md` carefully.
2. Update `dashboard/src/types/index.ts`:
   - Add type:
     ```typescript
     export type EquipmentCategory = 'weapon' | 'clothes' | 'helmet' | 'trousers' | 'shoes' | 'ring'
     ```
   - In `CastleConfig` interface, add:
     ```typescript
     forge_equipment?: BaseTaskConfig & { category: EquipmentCategory }
     ```
   - In `DEFAULT_CASTLE_CONFIG`, add:
     ```typescript
     forge_equipment: { enabled: false, category: 'weapon' },
     ```
   - In `FIXED_PRESET_CONFIG`, add:
     ```typescript
     forge_equipment: { enabled: false, category: 'weapon' },
     ```
3. Update `dashboard/src/hooks/useCastles.ts`:
   - In `mergeCastleConfig(fcConfig)` add:
     ```typescript
     forge_equipment: {
       ...(def.forge_equipment || { enabled: false, category: 'weapon' }),
       ...((fc.forge_equipment as Record<string, unknown>) || {}),
     },
     ```
4. Update Trilingual Localization files (`ar.json`, `en.json`, `tr.json`):
   - Under `"tasks"`, add keys for both snake_case and camelCase:
     - `forge_equipment` & `forgeEquipment`
     - `forge_equipment_desc`
     - `forge_category` & `forgeCategory`
     - `equip_weapon` & `equipWeapon`
     - `equip_clothes` & `equipClothes`
     - `equip_helmet` & `equipHelmet`
     - `equip_trousers` & `equipTrousers`
     - `equip_shoes` & `equipShoes`
     - `equip_ring` & `equipRing`
   - ZERO hardcoded strings in code!
5. Update `dashboard/src/components/accounts/TaskTabContent.tsx`:
   - Place `TaskRow` for `forge_equipment` right after `material_synthesis` in daily tasks tab.
   - Set `comingSoon={false}` explicitly (critical: default is true!).
   - Render the 6 categories as responsive buttons (`grid grid-cols-3 sm:grid-cols-6 gap-1.5 pt-2`) showing icon `/images/daily/equip/{cat}.png` and translated title.
   - Dual-Save compliance (GEMINI.md Rules 3 & 5):
     * Update `performSave()` (auto-save): include `forge_equipment: (currentDraft as any)?.forge_equipment`.
     * Update `handleSave()` (manual save): include `forge_equipment` in `payloadToSave`.
6. Run build verification:
   - Run `npm run build` in `dashboard/` directory and ensure exit code 0 without any errors.
7. Write a complete handoff report to: `e:\intqam-sultan\.agents\teamwork\worker_frontend_m3\handoff.md`.
Follow Handoff Protocol: Observation, Logic Chain, Caveats, Conclusion, Verification Method.
When done, send a message to your orchestrator (parent).
