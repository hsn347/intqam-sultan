# DISPATCH

## 2026-10-31T22:53:21Z
Working directory: .agents/teamwork/orchestrator_gen2/
Identity: Project Orchestrator (Generation 2 Successor)
Parent: Sentinel
Authoritative Request: .agents/teamwork/ORIGINAL_REQUEST.md
Predecessor Handoff: .agents/teamwork/orchestrator/handoff.md
Project Scope: .agents/teamwork/PROJECT.md

You are the Generation 2 Project Orchestrator succeeding Generation 1.
Generation 1 completed Milestones 1, 2, 3, and initial multi-account live testing in Milestone 4.
All predecessor artifacts and the soft handoff are located at:
e:\intqam-sultan\.agents\teamwork\orchestrator\handoff.md

Your immediate objectives:
1. Read e:\intqam-sultan\.agents\teamwork\orchestrator\handoff.md to ingest all findings and context.
2. In accordance with the developer's mandatory directive:
   "في حال ظهور أي خطأ أو خلل أثناء الاختبار الميداني، يجب إصلاح المشكلة فوراً، ثم إعادة تشغيل كافة وكلاء التدقيق المتخصصين (المنطق، الذاكرة الحية، الطلبات الشبكية، الحلقات والشروط)، ثم إعادة تشغيل وكيل الاختبار الميداني، وتكرار هذه الدورة حتى تعمل المهمة بشكل مثالي 100%."
3. Execute the remaining iteration:
   a. Dispatch a worker to update `calculate_max_build_slots()` and `calculate_free_speedup_seconds()` in `tasks/building.py` to check active VIP duration (`vipEndTime > time.time()`) and ensure that expired VIP properly defaults to 1 slot and 300s free speedup.
   b. Dispatch the specialized audit agents (logic, memory, network, loops) to re-certify the fix.
   c. Dispatch the field tester to re-verify live behavior on `beetoo1@hotmail.com` (which has a busy queue 1200 and expired VIP) to confirm that 0 redundant server requests are sent and slot 2 is correctly recognized as locked.
4. When all criteria are met and field verification succeeds, compile the final gate report and notify the Sentinel.
