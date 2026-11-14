## 2026-11-01T09:13:31Z
Your identity: Frontend Implementation Agent (teamwork_worker).
Your assigned working directory: e:\intqam-sultan\.agents\teamwork\worker_cmd_hall_frontend\
Mandatory: Read the full authoritative user request at:
e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md

Also read the survey synthesis and architecture blueprint at:
- e:\intqam-sultan\.agents\teamwork\orchestrator_3\SURVEY_SYNTHESIS.md
- e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_ui_3\analysis.md

Files you own exclusively:
- dashboard/src/types/index.ts
- dashboard/src/hooks/useCastles.ts
- dashboard/src/components/accounts/TaskTabContent.tsx
- dashboard/src/locales/ar.json
- dashboard/src/locales/en.json
- dashboard/src/locales/tr.json
- dashboard/public/images/daily/command_hall.png
- dashboard/dist/images/daily/command_hall.png

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A teamwork_auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Your Tasks:
1. Deploy official icon:
   Copy image from `tools/test_crop1.png` to:
   - `dashboard/public/images/daily/command_hall.png`
   - `dashboard/dist/images/daily/command_hall.png`
2. Update `dashboard/src/types/index.ts`:
   Add `command_hall?: SimpleToggleConfig;` to `TaskConfig` / `CastleConfig` interfaces.
3. Update `dashboard/src/hooks/useCastles.ts`:
   Add `command_hall: { enabled: false }` to the default bot config object.
4. Update `dashboard/src/components/accounts/TaskTabContent.tsx`:
   - Add single toggle control in `tab === 'daily'` using `<TaskRow id="command_hall" emoji="📜" img="/images/daily/command_hall.png" ... />`.
   - DUAL-SAVE AUDIT: update BOTH `performSave()` (auto-save on toggle) AND `handleSave()` (manual save button) to extract and save `command_hall`.
   - ZERO hardcoded strings: use `t('tasks.command_hall.title')` and `t('tasks.command_hall.desc')`.
5. Update trilingual locales:
   - `dashboard/src/locales/ar.json`: add `"command_hall": { "title": "مهام القيادة", "desc": "تنفيذ مهام قاعة القيادة بالنشاط اليومي واستلام جوائزها دورياً" }` under `tasks`.
   - `dashboard/src/locales/en.json`: add `"command_hall": { "title": "Command Quest", "desc": "Execute daily command hall quests and claim rewards periodically" }` under `tasks`.
   - `dashboard/src/locales/tr.json`: add `"command_hall": { "title": "Komuta Görevleri", "desc": "Günlük komuta merkezi görevlerini yürüt ve ödülleri düzenli topla" }` under `tasks`.
6. Run frontend validation:
   - Run `npx tsc --noEmit` or `npm run build` in `dashboard` to verify zero compile or TypeScript errors.
   - Verify layout responsiveness and clean rendering in dark and light modes.
