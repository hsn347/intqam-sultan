# Progress Log — spec_miner_building_survey_1

- **Last visited**: 2026-10-31T21:20:15Z
- **Current Status**: Complete specification mining of Lua building configs and core/buildings_prereqs.json. Preparing final handoff.
- **Completed Steps**:
  1. [x] Received dispatch assignment and verified workspace rules.
  2. [x] Initialized DISPATCH.md, BRIEFING.md, and progress.md.
  3. [x] Surveyed all 90 `*build*` files in `game_file/src/app/localtb/config_server/` and cataloged all 30 building configuration files (`build101.lua` to `build305.lua`).
  4. [x] Discovered the exact root causes behind missing levels and empty prerequisites in `core/buildings_prereqs.json`:
         - Register reuse in decompiled Lua (e.g. `;(500000).index = 31`) caused the old parser to stop parsing entries.
         - Multi-variable assignment (e.g. `_UPVALUE2_, (nil).blv = 420000, 29`) caused corrupted keys (`"420000"`, `"450000"`).
         - Table index shift in prerequisites (e.g. `_UPVALUE8_, (nil).preCond, (33)[1] = 33, 33, 102`) caused `preCond={}` from lv 33 onwards.
  5. [x] Built and verified a 100% accurate Lua config parser that matches levels 1-30 in `core/buildings_prereqs.json` with 0 mismatches.
  6. [x] Extracted complete progression tree for Castle (1-40 and up to 130), Walls (>34 and up to 130), Embassy (>28 and up to 130), and Sultan's Glory (30-130).
  7. [x] Audited all 30 buildings, identifying missing levels (from 879 levels in current JSON to 3,127 levels in Lua).
- **Active Step**:
  - [ ] Compiling comprehensive handoff report (`handoff.md`).
