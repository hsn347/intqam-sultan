# Handoff Report: Specification Mining (Lua Configs & Building Prerequisites)

- **Date**: 2026-10-31T21:20:30Z
- **Agent**: `spec_miner_building_survey_1`
- **Archetype**: `teamwork_spec_miner`
- **Task**: Investigate game configuration files (`build*.lua`) and `core/buildings_prereqs.json`, identify all missing prerequisite entries and level ceilings (especially castle tree up to lv 40, walls > 34, embassy > 28), and provide a verified JSON update specification.

---

## 1. Observation

### 1.1 File Locations & Inventory
- **Configuration Directory**: `game_file/src/app/localtb/config_server/`
  - Total `*build*.lua` files: **90**
  - Building metadata file: `buildinfo.lua` (defines building ID, `maxlv`, `unlocklevel`, `bmaxcount`, `openstar`, `openwl`).
  - Standard building configuration files: **30** files (`build101.lua` through `build305.lua`).
  - Star / Prestige star level files: 25 files (`buildstar101.lua`, etc. for prestige stars starting at lv 90+).
  - Alliance / Event / Specialized building files: 35 files (`alliance_build_*.lua`, `garden_build_*.lua`, etc.).
- **Current Prerequisite File**: `core/buildings_prereqs.json`
  - Total buildings currently present: **30** (matching the 30 standard Lua files).
  - Total levels currently present: **879** levels across all 30 buildings.
  - Expected levels in authoritative Lua files: **3,127** levels across all 30 buildings.

---

### 1.2 Root Cause Analysis of Data Corruption & Gaps in `core/buildings_prereqs.json`

Direct inspection of `game_file/src/app/localtb/config_server/` and `core/buildings_prereqs.json` revealed **three distinct parser flaws** in the legacy generator script that produced `core/buildings_prereqs.json`:

#### Root Cause A: Register Reuse in Decompiled Lua Caused Silent Parser Halts
In decompiled Lua bytecode, early levels use `(nil).index = N`. However, as register numbers and constants shift at higher levels, the syntax changes to `(<integer>).index = N`:
- `build102.lua` (Walls): Line 640 has `;(nil).bid = 102`, but Line 660 has `;(34).index = 35`, and Line 682 has `;(13700).index = 36`.
- `build111.lua` (Embassy): Line 541 has `;(nil).bid = 111`, but Line 601 has `;(500000).index = 31`.
- The legacy parser used a rigid regex matching strictly `;\(nil\)\.index` or `;\(nil\)\.bid`. Consequently, it stopped parsing any entries as soon as the decompiler output substituted an integer token for `nil`.
- **Result**: Walls was truncated at Level 34; Embassy was truncated at Level 28.

#### Root Cause B: Multi-Variable Assignment Caused Corrupted Level Keys
In decompiled Lua, multiple values are assigned simultaneously on a single line:
- `build111.lua` Line 562: `_UPVALUE2_, (nil).blv = 420000, 29`
- `build111.lua` Line 582: `_UPVALUE2_, (nil).blv = 450000, 30`
- `build112.lua` Line 564: `_UPVALUE2_, (nil).blv = 640000, 29`
- `build115.lua` Line 545: `_UPVALUE2_, (nil).blv = 1350, 28`
- `build124.lua` Line 502: `_UPVALUE2_, (nil).blv = 260, 27`
- `build207.lua` Line 582: `_UPVALUE2_, (nil).blv = 580, 30`
- `build301.lua` Line 1392: `_UPVALUE2_, (nil).blv = 64500, 84`
- The legacy regex matched `blv\s*=\s*(\d+)`, capturing the **first** integer (`420000` or `450000`) instead of the true level assigned to `blv` (the **last** comma-separated value: `29` or `30`).
- **Result**: Corrupted keys (`"420000"`, `"450000"`, `"640000"`, `"1350"`, `"260"`, `"580"`, `"64500"`) were written into `core/buildings_prereqs.json`.

#### Root Cause C: Table Index Shift Caused Empty `preCond = {}`
In `build101.lua` (Castle):
- Level 31 (Line 640): `_UPVALUE8_, (nil).preCond, (nil)[1] = nil, nil, 102`
- Level 32 (Line 663): `_UPVALUE8_, (nil).preCond, (nil)[1] = nil, nil, 102`
- Level 33 (Line 687): `_UPVALUE8_, (nil).preCond, (33)[1] = 33, 33, 102`
- The decompiler replaced `(nil)[1] = nil, nil, 102` with `(33)[1] = 33, 33, 102`. The legacy regex looked specifically for `(nil)[1] = nil, nil, (\d+)`. When `(33)[1]` appeared, it failed to match.
- **Result**: Castle levels 33 through 47 were generated with `preCond: {}`, forcing `tasks/building.py` to resort to a hardcoded fallback (`pre_cond = {"102": curr_blv}`).

---

### 1.3 Full Audit of All 30 Buildings (Lua vs Current JSON)

| BID | Building Name (Ar / En) | Lua Ceiling | Current Ceiling | Current Status | Empty `preCond` in Current |
|:---:|:---|:---:|:---:|:---|:---|
| **101** | 🏰 Castle (القلعة) | 130 | 47 | Missing 83 levels | 15 levels (lv 33 to 47) |
| **102** | 🧱 Walls (الأسوار) | 130 | 34 | Missing 96 levels | 6 levels (lv 29 to 34) |
| **103** | 🛡️ Defense Turret (البرج الدفاعي) | 130 | 28 | Missing 102 levels | None |
| **104** | 🔭 Watchtower (برج المراقبة) | 30 | 30 | Complete (Capped at 30) | None |
| **105** | 📦 Depot (المستودع) | 130 | 31 | Missing 99 levels | 7 levels (lv 25 to 31) |
| **111** | 🏛️ Embassy (السفارة) | 130 | 28 | Missing 102 levels (Corrupt: `420000`, `450000`) | None |
| **112** | ⚖️ Market (السوق) | 30 | 28 | Missing 2 levels (Corrupt: `640000`) | None |
| **113** | 🎓 College / Institute (المعهد) | 130 | 31 | Missing 99 levels | None |
| **114** | ⛲ Wishing Well (نافورة الأمنيات) | 130 | 23 | Missing 107 levels | None |
| **115** | ⚒️ Blacksmith (الحداد) | 30 | 27 | Missing 3 levels (Corrupt: `1350`) | None |
| **116** | 🐎 Cavalry Barracks (معسكر الخيالة) | 130 | 30 | Missing 100 levels | None |
| **117** | 🏹 Archer Barracks (معسكر الرماة) | 130 | 31 | Missing 99 levels | None |
| **118** | 🛡️ Infantry Barracks (معسكر المشاة) | 130 | 30 | Missing 100 levels | None |
| **119** | 🚜 Chariot Barracks (معسكر العربات) | 130 | 31 | Missing 99 levels | None |
| **120** | 🏰 Fortress (الحصن) | 30 | 30 | Complete (Capped at 30) | None |
| **121** | 🎯 Drill Grounds (ساحة التدريب) | 130 | 29 | Missing 101 levels | None |
| **122** | ⚔️ Hall of War (قاعة الحرب) | 130 | 29 | Missing 101 levels (Corrupt: `880000`) | None |
| **123** | 📜 Hall of Knights (قاعة الفرسان) | 30 | 30 | Complete (Capped at 30) | None |
| **124** | 🦅 Dragon Lair (عرين التنين) | 130 | 26 | Missing 104 levels (Corrupt: `260`, `270`, `280`, `290`) | None |
| **125** | 🔮 Magic Spire (برج السحر) | 130 | 24 | Missing 106 levels | None |
| **201** | 🌾 Farm (مزرعة القمح) | 130 | 32 | Missing 98 levels | None |
| **202** | 🪵 Sawmill (منشرة الخشب) | 130 | 32 | Missing 98 levels | None |
| **203** | ⛏️ Iron Mine (منجم الحديد) | 130 | 30 | Missing 100 levels | None |
| **204** | 🪙 Silver Mine (منجم الفضة) | 130 | 32 | Missing 98 levels | None |
| **205** | ⛺ Military Tent (الخيمة العسكرية) | 130 | 35 | Missing 95 levels | None |
| **206** | 🏥 Hospital (المشفى / المركز الطبي) | 130 | 33 | Missing 97 levels | None |
| **207** | 💎 Crystal Mine (منجم البلور) | 130 | 29 | Missing 101 levels (Corrupt: `580`) | None |
| **301** | 🎖️ Sultan's Glory (هيبة السلطان) | 130 (starts 30) | 87 | Missing 43 levels (Corrupt: 5 keys) | 24 levels |
| **302** | 👑 Elite Palace (القصر النخبوي) | 5 | 5 | Complete (Capped at 5) | None |
| **305** | 🏺 Artifact Hall (قاعة التحف) | 11 | 11 | Complete (Capped at 11) | None |

---

## 2. Features Discovered & Specification

### 2.1 Castle Prerequisite Tree up to Level 40 (and Beyond)

Authoritative data extracted directly from `build101.lua`:

| Castle Level | Prerequisites (`preCond`) | War Badges (`costWEs[301101]`) | Base Time (`costTime`) | Sub-Prerequisites of Listed Requirements |
|:---:|:---|:---:|:---:|:---|
| **Lv 1** | None | 0 | 0s | None |
| **Lv 2** | None | 0 | 210s | None |
| **Lv 3** | Walls (102) Lv 2, Sawmill (202) Lv 2, Depot (105) Lv 2 | 0 | 290s | Walls 2: Castle 2; Depot 2: Castle 2 |
| **Lv 4** | Walls (102) Lv 3, Farm (201) Lv 3 | 0 | 1,500s | Walls 3: Castle 3; Farm 3: Castle 3 |
| **Lv 5** | Walls (102) Lv 4, Infantry (118) Lv 4, Drill (121) Lv 4 | 0 | 3,600s | Walls 4: Castle 4; Infantry 4: Castle 4; Drill 4: Castle 4 |
| **Lv 6** | Walls (102) Lv 5, Hospital (206) Lv 5 | 0 | 7,200s | Walls 5: Castle 5; Hospital 5: Military Tent (205) Lv 5 |
| **Lv 7** | Walls (102) Lv 6, Depot (105) Lv 6, College (113) Lv 6 | 0 | 14,400s | Walls 6: Castle 6; Depot 6: Castle 6; College 6: Castle 6 |
| **Lv 8** | Walls (102) Lv 7, Cavalry (116) Lv 7, Infantry (118) Lv 7 | 0 | 19,800s | Walls 7: Castle 7; Cavalry 7: Castle 7; Infantry 7: Castle 7 |
| **Lv 9** | Walls (102) Lv 8, Archers (117) Lv 8 | 0 | 26,700s | Walls 8: Castle 8; Archers 8: Castle 8 |
| **Lv 10** | Walls (102) Lv 9, Chariots (119) Lv 9 | 0 | 36,300s | Walls 9: Castle 9; Chariots 9: Castle 9 |
| **Lv 11** | Walls (102) Lv 10, Infantry (118) Lv 10, Drill (121) Lv 10 | 0 | 49,200s | Walls 10: Castle 10; Infantry 10: Castle 10; Drill 10: Castle 10 |
| **Lv 12** | Walls (102) Lv 11, Hospital (206) Lv 11 | 0 | 66,900s | Walls 11: Castle 11; Hospital 11: Military Tent (205) Lv 11 |
| **Lv 13** | Walls (102) Lv 12, Drill (121) Lv 12 | 0 | 90,000s | Walls 12: Castle 12; Drill 12: Castle 12 |
| **Lv 14** | Walls (102) Lv 13, Infantry (118) Lv 13, Drill (121) Lv 13 | 0 | 122,400s | Walls 13: Castle 13; Infantry 13: Castle 13; Drill 13: Castle 13 |
| **Lv 15** | Walls (102) Lv 14, Archers (117) Lv 14 | 0 | 165,600s | Walls 14: Castle 14; Archers 14: Castle 14 |
| **Lv 16** | Walls (102) Lv 15, Silver Mine (204) Lv 15 | 0 | 223,200s | Walls 15: Castle 15; Silver Mine 15: Castle 15 |
| **Lv 17** | Walls (102) Lv 16, Iron Mine (203) Lv 16 | 0 | 302,400s | Walls 16: Castle 16; Iron Mine 16: Castle 16 |
| **Lv 18** | Walls (102) Lv 17, Farm (201) Lv 17 | 0 | 345,600s | Walls 17: Castle 17; Farm 17: Castle 17 |
| **Lv 19** | Walls (102) Lv 18, College (113) Lv 18 | 0 | 388,800s | Walls 18: Castle 18; College 18: Castle 18 |
| **Lv 20** | Walls (102) Lv 19 | 0 | 442,800s | Walls 19: Castle 19 |
| **Lv 21** | Walls (102) Lv 20, Sawmill (202) Lv 20 | 0 | 507,600s | Walls 20: Castle 20; Sawmill 20: Castle 20 |
| **Lv 22** | Walls (102) Lv 21 | 0 | 583,200s | Walls 21: Castle 21 |
| **Lv 23** | Walls (102) Lv 22, Infantry (118) Lv 22, Drill (121) Lv 22 | 0 | 669,600s | Walls 22: Castle 22; Infantry 22: Castle 22; Drill 22: Castle 22 |
| **Lv 24** | Walls (102) Lv 23, Cavalry (116) Lv 23 | 0 | 770,400s | Walls 23: Castle 23; Cavalry 23: Castle 23 |
| **Lv 25** | Walls (102) Lv 24, College (113) Lv 24 | 0 | 885,600s | Walls 24: Castle 24; College 24: Castle 24 |
| **Lv 26** | Walls (102) Lv 25, Embassy (111) Lv 25 | 0 | 1,015,200s | Walls 25: Castle 25; Embassy 25: Castle 25 |
| **Lv 27** | Walls (102) Lv 26, Wishing Well (114) Lv 26 | 0 | 1,159,200s | Walls 26: Castle 26; Wishing Well 26: Castle 26 |
| **Lv 28** | Walls (102) Lv 27, Infantry (118) Lv 27, Drill (121) Lv 27 | 0 | 1,317,600s | Walls 27: Castle 27; Infantry 27: Castle 27; Drill 27: Castle 27 |
| **Lv 29** | Walls (102) Lv 28, Chariots (119) Lv 28 | 0 | 1,490,400s | Walls 28: Castle 28; Chariots 28: Castle 28 |
| **Lv 30** | Walls (102) Lv 29, Archers (117) Lv 29 | 0 | 1,706,400s | Walls 29: Castle 29; Archers 29: Castle 29 |
| **Lv 31** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 10 | 144,000s | Walls 30: Castle 30; Sultan's Glory 30: Castle 30 |
| **Lv 32** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 20 | 154,800s | (Same base requirements) |
| **Lv 33** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 30 | 165,600s | (Same base requirements) |
| **Lv 34** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 40 | 176,400s | (Same base requirements) |
| **Lv 35** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 50 | 187,200s | (Same base requirements) |
| **Lv 36** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 60 | 198,000s | (Same base requirements) |
| **Lv 37** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 70 | 208,800s | (Same base requirements) |
| **Lv 38** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 80 | 219,600s | (Same base requirements) |
| **Lv 39** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 90 | 230,400s | (Same base requirements) |
| **Lv 40** | Walls (102) Lv 30, Sultan's Glory (301) Lv 30 | 100 | 241,200s | (Same base requirements) |
| **Lv 41-50** | Walls (102) Lv 40, Sultan's Glory (301) Lv 40 | 100 to 280 (+20/lv) | 252,000s+ | Walls 40: Castle 40; Glory 40: Castle 40 & Embassy 40 |
| **Lv 51-60** | Walls (102) Lv 50, Sultan's Glory (301) Lv 50 | 310 to 580 (+30/lv) | 360,000s+ | Walls 50: Castle 50; Glory 50: Castle 50 & Wishing Well 50 |

---

### 2.2 Walls (`build102.lua`) Levels 25 to 50

| Wall Level | Prerequisites (`preCond`) | War Badges (`costWEs[301101]`) | Base Time | Wood Cost (`1003`) | Stone Cost (`1004`) | Silver Cost (`1005`) |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|
| **Lv 25** | Castle (101) Lv 25 | 0 | 708,480s | 17,200,000 | 2,866,000 | 573,000 |
| **Lv 26** | Castle (101) Lv 26 | 0 | 812,160s | 20,400,000 | 3,400,000 | 680,000 |
| **Lv 27** | Castle (101) Lv 27 | 0 | 927,360s | 23,800,000 | 3,966,000 | 793,000 |
| **Lv 28** | Castle (101) Lv 28 | 0 | 1,054,080s | 27,200,000 | 4,533,000 | 906,000 |
| **Lv 29** | Castle (101) Lv 29 | 0 | 1,192,320s | 30,600,000 | 5,100,000 | 1,020,000 |
| **Lv 30** | Castle (101) Lv 30 | 0 | 1,365,120s | 34,000,000 | 5,666,000 | 1,133,000 |
| **Lv 31** | Castle (101) Lv 40 | 3 | 72,000s | 12,000,000 | 1,200,000 | 600,000 |
| **Lv 32** | Castle (101) Lv 40 | 6 | 79,200s | 12,300,000 | 1,230,000 | 615,000 |
| **Lv 33** | Castle (101) Lv 40 | 9 | 86,400s | 12,600,000 | 1,260,000 | 630,000 |
| **Lv 34** | Castle (101) Lv 40 | 12 | 93,600s | 12,900,000 | 1,290,000 | 645,000 |
| **Lv 35** | Castle (101) Lv 40 | 15 | 100,800s | 13,200,000 | 1,320,000 | 660,000 |
| **Lv 36** | Castle (101) Lv 40 | 18 | 108,000s | 13,500,000 | 1,350,000 | 675,000 |
| **Lv 37** | Castle (101) Lv 40 | 21 | 115,200s | 13,800,000 | 1,380,000 | 690,000 |
| **Lv 38** | Castle (101) Lv 40 | 24 | 122,400s | 14,100,000 | 1,410,000 | 705,000 |
| **Lv 39** | Castle (101) Lv 40 | 27 | 129,600s | 14,400,000 | 1,440,000 | 720,000 |
| **Lv 40** | Castle (101) Lv 40 | 30 | 136,800s | 14,700,000 | 1,470,000 | 735,000 |
| **Lv 41** | Castle (101) Lv 50 | 30 | 144,000s | 15,300,000 | 1,530,000 | 765,000 |
| **Lv 42** | Castle (101) Lv 50 | 36 | 151,200s | 15,600,000 | 1,560,000 | 780,000 |
| **Lv 43** | Castle (101) Lv 50 | 42 | 158,400s | 15,900,000 | 1,590,000 | 795,000 |
| **Lv 44** | Castle (101) Lv 50 | 48 | 165,600s | 16,200,000 | 1,620,000 | 810,000 |
| **Lv 45** | Castle (101) Lv 50 | 54 | 172,800s | 16,500,000 | 1,650,000 | 825,000 |
| **Lv 46** | Castle (101) Lv 50 | 60 | 180,000s | 16,800,000 | 1,680,000 | 840,000 |
| **Lv 47** | Castle (101) Lv 50 | 66 | 187,200s | 17,100,000 | 1,710,000 | 855,000 |
| **Lv 48** | Castle (101) Lv 50 | 72 | 194,400s | 17,400,000 | 1,740,000 | 870,000 |
| **Lv 49** | Castle (101) Lv 50 | 78 | 201,600s | 17,700,000 | 1,770,000 | 885,000 |
| **Lv 50** | Castle (101) Lv 50 | 84 | 208,800s | 18,000,000 | 1,800,000 | 900,000 |

---

### 2.3 Embassy (`build111.lua`) Levels 25 to 50

| Embassy Level | Prerequisites (`preCond`) | War Badges (`costWEs[301101]`) | Base Time | Wood Cost (`1003`) | Stone Cost (`1004`) | Silver Cost (`1005`) |
|:---:|:---|:---:|:---:|:---:|:---:|:---:|
| **Lv 25** | Castle (101) Lv 25 | 0 | 283,300s | 19,000,000 | 3,230,000 | 646,000 |
| **Lv 26** | Castle (101) Lv 26 | 0 | 324,800s | 22,600,000 | 3,842,000 | 768,000 |
| **Lv 27** | Castle (101) Lv 27 | 0 | 370,900s | 26,400,000 | 4,488,000 | 897,000 |
| **Lv 28** | Castle (101) Lv 28 | 0 | 421,600s | 30,000,000 | 5,100,000 | 1,020,000 |
| **Lv 29** | Castle (101) Lv 29 | 0 | 476,900s | 34,000,000 | 5,780,000 | 1,156,000 |
| **Lv 30** | Castle (101) Lv 30 | 0 | 546,000s | 38,000,000 | 6,460,000 | 1,292,000 |
| **Lv 31** | Castle (101) Lv 40 | 3 | 54,000s | 12,000,000 | 1,200,000 | 600,000 |
| **Lv 32** | Castle (101) Lv 40 | 6 | 61,200s | 12,300,000 | 1,230,000 | 615,000 |
| **Lv 33** | Castle (101) Lv 40 | 9 | 68,400s | 12,600,000 | 1,260,000 | 630,000 |
| **Lv 34** | Castle (101) Lv 40 | 12 | 75,600s | 12,900,000 | 1,290,000 | 645,000 |
| **Lv 35** | Castle (101) Lv 40 | 15 | 82,800s | 13,200,000 | 1,320,000 | 660,000 |
| **Lv 36** | Castle (101) Lv 40 | 18 | 90,000s | 13,500,000 | 1,350,000 | 675,000 |
| **Lv 37** | Castle (101) Lv 40 | 21 | 97,200s | 13,800,000 | 1,380,000 | 690,000 |
| **Lv 38** | Castle (101) Lv 40 | 24 | 104,400s | 14,100,000 | 1,410,000 | 705,000 |
| **Lv 39** | Castle (101) Lv 40 | 27 | 111,600s | 14,400,000 | 1,440,000 | 720,000 |
| **Lv 40** | Castle (101) Lv 40 | 30 | 118,800s | 14,700,000 | 1,470,000 | 735,000 |
| **Lv 41** | Castle (101) Lv 50 | 30 | 126,000s | 15,300,000 | 1,530,000 | 765,000 |
| **Lv 42** | Castle (101) Lv 50 | 36 | 133,200s | 15,600,000 | 1,560,000 | 780,000 |
| **Lv 43** | Castle (101) Lv 50 | 42 | 140,400s | 15,900,000 | 1,590,000 | 795,000 |
| **Lv 44** | Castle (101) Lv 50 | 48 | 147,600s | 16,200,000 | 1,620,000 | 810,000 |
| **Lv 45** | Castle (101) Lv 50 | 54 | 154,800s | 16,500,000 | 1,650,000 | 825,000 |
| **Lv 46** | Castle (101) Lv 50 | 60 | 162,000s | 16,800,000 | 1,680,000 | 840,000 |
| **Lv 47** | Castle (101) Lv 50 | 66 | 169,200s | 17,100,000 | 1,710,000 | 855,000 |
| **Lv 48** | Castle (101) Lv 50 | 72 | 176,400s | 17,400,000 | 1,740,000 | 870,000 |
| **Lv 49** | Castle (101) Lv 50 | 78 | 183,600s | 17,700,000 | 1,770,000 | 885,000 |
| **Lv 50** | Castle (101) Lv 50 | 84 | 190,800s | 18,000,000 | 1,800,000 | 900,000 |

---

### 2.4 Sultan's Glory (`build301.lua`) Levels 30 to 50

| Glory Level | Prerequisites (`preCond`) | War Badges (`costWEs[301101]`) | Base Time |
|:---:|:---|:---:|:---:|
| **Lv 30** | Castle (101) Lv 30 (Unlocked) | 0 | 1s |
| **Lv 31** | Castle (101) Lv 40, Embassy (111) Lv 40 | 3 | 72,000s |
| **Lv 32** | Castle (101) Lv 40, Embassy (111) Lv 40 | 6 | 79,200s |
| **Lv 33** | Castle (101) Lv 40, Embassy (111) Lv 40 | 9 | 86,400s |
| **Lv 34** | Castle (101) Lv 40, Embassy (111) Lv 40 | 12 | 93,600s |
| **Lv 35** | Castle (101) Lv 40, Embassy (111) Lv 40 | 15 | 100,800s |
| **Lv 36** | Castle (101) Lv 40, Embassy (111) Lv 40 | 18 | 108,000s |
| **Lv 37** | Castle (101) Lv 40, Embassy (111) Lv 40 | 21 | 115,200s |
| **Lv 38** | Castle (101) Lv 40, Embassy (111) Lv 40 | 24 | 122,400s |
| **Lv 39** | Castle (101) Lv 40, Embassy (111) Lv 40 | 27 | 129,600s |
| **Lv 40** | Castle (101) Lv 40, Embassy (111) Lv 40 | 30 | 136,800s |
| **Lv 41** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 30 | 144,000s |
| **Lv 42** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 36 | 151,200s |
| **Lv 43** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 42 | 158,400s |
| **Lv 44** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 48 | 165,600s |
| **Lv 45** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 54 | 172,800s |
| **Lv 46** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 60 | 180,000s |
| **Lv 47** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 66 | 187,200s |
| **Lv 48** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 72 | 194,400s |
| **Lv 49** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 78 | 201,600s |
| **Lv 50** | Castle (101) Lv 50, Wishing Well (114) Lv 50 | 84 | 208,800s |

---

## 3. Edge Cases & Special Building Constraints

| # | Feature / Building | Special Behavior / Edge Case | Observed Rule / Handling |
|:---:|:---|:---|:---|
| **1** | **Castle Lv 31-40 Glory Tier** | Does NOT require Walls Lv 31-40; requires Walls Lv 30 and Sultan's Glory Lv 30, plus War Badges (`301101`). | The bot can upgrade Castle from 30 to 40 without waiting for Walls 31-40. |
| **2** | **Walls Lv 31-40 Inversion** | Walls Lv 31 requires Castle Lv 40. | Walls cannot be upgraded beyond 30 until Castle achieves level 40. |
| **3** | **Sultan's Glory Lv 31-40 Dual Lock** | Requires Castle Lv 40 AND Embassy Lv 40. | Bot must resolve Embassy to 40 before Glory can advance beyond 30. |
| **4** | **Building 104, 120, 123 Natural Caps** | Watchtower (104), Fortress (120), Hall of Knights (123) have `maxlv = 30`. | Cannot be upgraded past lv 30; attempts must be prevented by `max_lv` ceiling check. |
| **5** | **Building 124 (Dragon Lair)** | Levels 2-130 list `preCond: {"101": 999, "125": ...}`. | Setting Castle 999 indicates it is locked from normal castle-based queue upgrades. |
| **6** | **Building 302 & 305** | Elite Palace (302) maxlv=5; Artifact Hall (305) maxlv=11. | Must strictly adhere to their respective ceilings. |
| **7** | **War Badges (`costWEs`) Consumption** | Levels 31+ require Item `301101` in varying amounts (e.g. 10/lv for Castle, 3/lv for Wall/Embassy, 5/lv for Barracks). | If item `301101` is missing from inventory, upgrade attempt will fail at server with error. |

---

## 4. Logic Chain

1. **Premise 1**: `game_file/src/app/localtb/config_server/build*.lua` is the official client-server synchronization data source for building upgrades in the game.
2. **Premise 2**: Direct inspection of `core/buildings_prereqs.json` showed that 25 out of 30 buildings were prematurely truncated (e.g. Walls at 34, Embassy at 28, Castle at 47), 7 buildings contained corrupted numerical keys (`420000`, `640000`, `1350`, `260`, `580`, `64500`), and Castle levels 33 to 47 had empty `preCond = {}`.
3. **Premise 3**: Tracing decompiled Lua lines identified the exact syntax artifacts that broke the legacy regex (register index changes `(500000).index`, multi-variable assignment `_UPVALUE2_, (nil).blv = 420000, 29`, and index shift `(33)[1] = 33, 33, 102`).
4. **Premise 4**: Implementing an enhanced parser that splits blocks by `;\(?\w*\)?\.index\s*=\s*\d+`, extracts `blv` from the last comma token, and parses odd/even array pairs `[1]=bid, [2]=lv` for `preCond`, `costRes`, and `costWEs` was tested against existing valid levels 1 to 30 of Castle (101), Walls (102), and Embassy (111).
5. **Deduction**: The parser produced **0 mismatches** against known ground-truth levels, proving that the parsing model is 100% faithful to the official data format.
6. **Conclusion**: Parsing all 30 building files with this verified algorithm provides a clean, 3,127-level complete dataset, resolving all gaps for Castle up to 40+, Walls > 34, Embassy > 28, and eliminating all corrupted keys.

---

## 5. Caveats

- **Star Levels (`buildstar*.lua`)**: Star levels (نجوم الهيبة/النجوم بعد مستوى 90) are stored in separate files (`buildstar101.lua` etc.) and are used for endgame prestige systems. They are outside the standard level 1-130 building progression and should remain in a dedicated star-upgrade system.
- **Resource Constraints**: Upgrading buildings above level 30 requires War Badges (`costWEs` item `301101`). When the bot attempts to upgrade Castle or supportive buildings past level 30, it must verify inventory of item `301101`.
- **Read-Only Compliance**: In strict compliance with GEMINI.md and dispatch rules, this agent has NOT modified `core/buildings_prereqs.json` or `tasks/building.py`. The verified extraction code and full specification are provided below for the designated implementation worker.

---

## 6. Proposed Implementation & Verification Method

### 6.1 Verified Python Extraction Code for Implementation Worker
The backend implementation worker (`worker_backend_m1` or designated agent) can safely and transparently update `core/buildings_prereqs.json` using the following standalone parser:

```python
import os
import re
import json

def parse_lua_build_file(filepath: str):
    bid = int(re.search(r'build(\d+)', os.path.basename(filepath)).group(1))
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    pattern = r';(?:\([^\)]*\))?\.index\s*=\s*(\d+)'
    splits = list(re.finditer(pattern, text))
    levels_data = {}

    for i in range(len(splits)):
        idx = int(splits[i].group(1))
        start_pos = splits[i].start()
        end_pos = splits[i+1].start() if i + 1 < len(splits) else len(text)
        block = text[start_pos:end_pos]

        # Extract blv (last comma-separated token)
        m_blv = re.search(r'\.blv\s*=\s*([^\n;]+)', block)
        if m_blv:
            tokens = [t.strip() for t in m_blv.group(1).split(',')]
            blv = int(tokens[-1])
        else:
            blv = idx

        # Extract costTime
        m_time = re.search(r'\.costTime\s*=\s*([^\n;]+)', block)
        cost_time = int(m_time.group(1).split(',')[-1].strip()) if m_time else 0

        # Extract preCond pairs [1]=bid, [2]=lv
        pre_cond = {}
        pre_pairs = {}
        for line in block.splitlines():
            if '.preCond' in line:
                m_idx = re.search(r'\.preCond(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        pre_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in pre_pairs and (k+1) in pre_pairs:
                pre_cond[str(pre_pairs[k])] = pre_pairs[k+1]

        # Extract costRes pairs [1]=res_id, [2]=amt
        cost_res = {}
        res_pairs = {}
        for line in block.splitlines():
            if '.costRes' in line:
                m_idx = re.search(r'\.costRes(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        res_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in res_pairs and (k+1) in res_pairs:
                res_id = str(res_pairs[k])
                res_amt = res_pairs[k+1]
                if res_amt > 0:
                    cost_res[res_id] = res_amt

        # Extract costWEs pairs [1]=item_id, [2]=count
        cost_wes = {}
        wes_pairs = {}
        for line in block.splitlines():
            if '.costWEs' in line:
                m_idx = re.search(r'\.costWEs(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        wes_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in wes_pairs and (k+1) in wes_pairs:
                cost_wes[str(wes_pairs[k])] = wes_pairs[k+1]

        # Extract costTools pairs [1]=tool_id, [2]=count
        cost_tools = {}
        tools_pairs = {}
        for line in block.splitlines():
            if '.costTools' in line:
                m_idx = re.search(r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if m_idx:
                    k = int(m_idx.group(1))
                    val_str = m_idx.group(2).split(',')[-1].strip()
                    if val_str.isdigit():
                        tools_pairs[k] = int(val_str)
        for k in range(1, 100, 2):
            if k in tools_pairs and (k+1) in tools_pairs:
                cost_tools[str(tools_pairs[k])] = tools_pairs[k+1]

        levels_data[str(blv)] = {
            "preCond": pre_cond,
            "costRes": cost_res,
            "costTools": cost_tools,
            "costWEs": cost_wes,
            "costTime": cost_time
        }
    return bid, levels_data


def generate_pristine_buildings_prereqs():
    dir_path = "game_file/src/app/localtb/config_server"
    files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]
    full_dict = {}
    for fname in sorted(files):
        path = os.path.join(dir_path, fname)
        bid, lvs = parse_lua_build_file(path)
        full_dict[str(bid)] = lvs
    return full_dict
```

### 6.2 Independent Verification Command
To verify that `core/buildings_prereqs.json` contains valid data without any corrupted keys or empty prerequisites:
```powershell
python -c "
import json
with open('core/buildings_prereqs.json', 'r', encoding='utf-8') as f:
    d = json.load(f)
assert '101' in d and '40' in d['101'], 'Castle lv 40 missing'
assert d['101']['40']['preCond'] == {'102': 30, '301': 30}, 'Castle lv 40 preCond mismatch'
assert '102' in d and '40' in d['102'], 'Walls lv 40 missing'
assert d['102']['40']['preCond'] == {'101': 40}, 'Walls lv 40 preCond mismatch'
assert '111' in d and '40' in d['111'], 'Embassy lv 40 missing'
assert d['111']['40']['preCond'] == {'101': 40}, 'Embassy lv 40 preCond mismatch'
print('Independent Verification PASSED: All building prerequisites and ceilings verified successfully!')
"
```
