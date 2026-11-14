# تقرير التنقيب المرجعي الدقيق لقاعة القيادة (Command Hall Specification Mining)

**تاريخ التحقيق المرجعي**: 2026-11-01  
**المصدر المرجعي الإلزامي**: ملفات العميل الرسمية للعبة (Lua Client Codebase) في `game_file/src/app/` و `game_file/src/fgui/` و `game_file/src/app/localtb/`.  
**فاحص المواصفات (Specification Miner)**: `teamwork_spec_miner`

---

## 1. نظرة عامة على قاعة القيادة والبروتوكول الرسمي

### 1.1 أكواد الأوامر وثوابت الشبكة (Network Command Constants)
- **وحدة قاعة القيادة (`gCmd.CMD_COMMAND_HALL_MODULE`)**: `"2274"` (`game_file/src/app/constdef/cmdDef.lua:3242`).
- **الأوامر الفرعية (Sub-Commands)**:
  1. `REQ_COMMAND_HALL_INIT = "1"`: استعلام ومزامنة بيانات قاعة القيادة (`initData`).
  2. `REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"`: ترقية مستوى قاعة القيادة واستلام مكافأة الترقية.
  3. `REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"`: ترقية مستوى القوة.
  4. `REQ_COMMAND_HALL_FINISH_GUIDE = "4"`: إنهاء الدليل التعليمي.
  5. `REQ_COMMAND_HALL_FINISH_TASK = "5"`: إنجاز المهمة (للمهام الفورية 3، 4، 6).
  6. `REQ_COMMAND_HALL_SET_DEFEND = "6"`: ضبط تشكيلة دفاع القلعة ضد الغزاة.
  7. `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"`: شن هجوم استباقي على فيلق الغزاة المهاجم (Type 1).
  8. `REQ_COMMAND_HALL_COMMIT_TASK = "8"`: استلام جوائز المهام المكتملة (`statue == 3`).
  9. `REQ_COMMAND_HALL_REFRESH_POS = "9"`: تحديث موقع هدف المهمة على الخريطة.
  10. `REQ_COMMAND_HALL_REFRESH_POS2 = "10"`: تحديث الموقع والانتقال للمشهد.
  11. `REQ_COMMAND_HALL_GET_BATTLE_INFO = "11"`: استعلام معلومات المعركة الموصى بها.
  12. `REQ_COMMAND_HALL_GET_RANK_INFO = "12"`: استعلام معلومات الترتيب.

- **وحدة طوابير الخريطة ومسير الجيوش (`CMD_KINGDOM_QUEUE_MODULE`)**: `"1007"` (`cmdDef.lua:237`).
- **أمر إرسال الفيلق (`ADD_KINGDOM_QUEUE`)**: `"2"` (`cmdDef.lua:238`).
- **نوع المسير لقاعة القيادة (`moveLineTypeCommandHallNpc`)**: `15` (`mapDef.lua:395`).
- **نوع مصفوفة الجيش (`moveLineMatrixTypeTroop`)**: `1` (`mapDef.lua:411`).

### 1.2 حالات المهام الفرعية (`gCommandHallTaskStatue`)
من `wholeDefine.lua:1372-1375`:
- `PREPARE = 1`: قيد التحضير/المسير.
- `BEGIN = 2`: جاهزة للتنفيذ.
- `FINISH = 3`: مكتملة وبانتظار استلام الجوائز (`REQ_COMMAND_HALL_COMMIT_TASK`).

---

## 2. التحقيق الميداني لأنواع المهام الفرعية الست (`gCommandHallTaskType`)

من `wholeDefine.lua:1365-1370`:
```lua
gCommandHallTaskType = {
    REBEL_ARMY_GROUP_TASK = 1,   -- فيلق الغزاة المهاجم (جيش المتمردين الجماعي)
    REBEL_ARMY_PIONEER_TASK = 2, -- طليعة الغزاة (تتطلب مسير فيلق)
    DIALOGUE_TASK = 3,           -- المعلومات العسكرية / الحوار (فورية مجانية)
    RESCUE_TASK = 4,             -- إنقاذ القرويين (فورية مجانية)
    BATTLE_TASK = 5,             -- فريق الغزاة / المعركة (تتطلب مسير فيلق)
    SNIPE_HUNTER_TASK = 6,       -- القناص الصامت (لعبة مصغرة - فورية مجانية عبر البروتوكول)
}
```

تصنيف متطلبات الجيش من `commandHallUtil.lua:114-126`:
```lua
function commandHallUtil.checkTaskTypeNeedArmy(taskType)
    local config = {
        [gCommandHallTaskType.RESCUE_TASK] = true,
        [gCommandHallTaskType.SNIPE_HUNTER_TASK] = true,
        [gCommandHallTaskType.DIALOGUE_TASK] = true,
    }
    return not config[taskType]
end

function commandHallUtil.checkTaskTypeShowNpc(taskType)
    local config = {
        [gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK] = true,
        [gCommandHallTaskType.BATTLE_TASK] = true,
    }
    return config[taskType]
end
```
- **مهام لا تحتاج جيش (No Army Required)**: `DIALOGUE_TASK (3)`, `RESCUE_TASK (4)`, `SNIPE_HUNTER_TASK (6)`.
- **مهام تحتاج جيش (Army Required)**: `REBEL_ARMY_GROUP_TASK (1)`, `REBEL_ARMY_PIONEER_TASK (2)`, `BATTLE_TASK (5)`.
- **مهام تظهر كوحوش/NPC على الخريطة (Map NPC)**: `REBEL_ARMY_PIONEER_TASK (2)`, `BATTLE_TASK (5)`.

---

### النوع 1: فيلق الغزاة المهاجم (`REBEL_ARMY_GROUP_TASK`)

#### أ. آلية الهجوم وحزمة البيانات الرسمية
- **التحكم والواجهة**:
  يظهر هذا الفيلق كغزو قادم نحو القلعة عبر `Com_MainReward.lua`. يتم تتبع حالته عبر `task.rabelHp` (نقاط الحياة الإجمالية) و `task.hurtHp` (الضرر المتراكم).
  الضرر يحسب تلقائياً بمرور الوقت أو عند إرسال أمر الهجوم المباشر (`commandHallCtrl:reqAttackArmyGroup`).
  الكود المصدري في `commandHallCtrl.lua:343-350`:
  ```lua
  function commandHallCtrl:reqAttackArmyGroup(armyInfo, heroInfo, armsInfo, divineBeastInfo)
      local data = {
          armyInfo = armyInfo,
          heroInfo = heroInfo,
          armsInfo = armsInfo,
          divineBeastInfo = divineBeastInfo,
      }
      serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_ATTACK_ARMY_GROUP, data)
  end
  ```
- **الحمولة (Payload)**:
  - عند استدعاء الزر في الواجهة (`Com_MainReward.lua:235`):
    `commandHallCtrl:reqAttackArmyGroup()` يستدعى بدون وسائط! فيرسل الكائن حقيبة فارغة `{}` أو قيم افتراضية، مما يجعل السيرفر يحتسب المعركة باستخدام قوات الدفاع الأساسية للقلعة.
  - إذا تم إرسال معلمات مخصصة:
    - `armyInfo`: مصفوفة تشكيلة القوات `[{"id": soldierID, "num": count}, ...]`.
    - `heroInfo`: مصفوفة الأبطال `[{"heroID": heroID}, ...]`.
    - `armsInfo`: مصفوفة أسلحة الحاكم الخارقة (`godArmsList`).
    - `divineBeastInfo`: مصفوفة الوحوش الإلهية (`divineBeasts`).

#### ب. هزيمة الفيلق وتجديد قائمة المهام واستلام المكافآت
- عند استنزاف صحة الفيلق (`task.hurtHp >= task.rabelHp`):
  ينتقل الفيلق إلى حالة الاكتمال `task.statue == gCommandHallTaskStatue.FINISH` (3).
- يظهر زر `Button_get` ("استلام"). وعند النقر، يتم استدعاء:
  `commandHallCtrl:reqCommitTask(1, task.index)`
  - **الباكيت الصادر**: CMD `"2274"`، SubCMD `"8"` (`REQ_COMMAND_HALL_COMMIT_TASK`)، الحمولة:
    ```json
    {
      "commitType": 1,
      "index": 1
    }
    ```
- **استجابة السيرفر وتجديد المهام**:
  في `commandHallCtrl.lua:376-393`:
  السيرفر يعيد `rspdata.initData` و `rspdata.reward`.
  يتم تحديث `armyGroupID` إلى المستوى/الموجة التالية، ويتم إفراغ المهام السابقة وتوليد حزمة مهام فرعية جديدة تماماً (`commonTaskData`)، وتُمنح مكافأة الفوز المباشرة عبر البريد/الحقيبة (`SoraDMailGainItems`).

---

### النوع 2: طليعة الغزاة (`REBEL_ARMY_PIONEER_TASK`)

#### أ. بروتوكول المسير الرسمي (`CMD 1007 SubCMD 2`)
- **الأمر**: CMD `"1007"` (وحدة طوابير المملكة)، SubCMD `"2"` (`ADD_KINGDOM_QUEUE`).
- **نوع خط السير**: `moveLineType = 15` (`gMapMoveLineType.moveLineTypeCommandHallNpc`).
- **نوع المصفوفة**: `matrixType = 1` (`gMapMoveLineMatrixType.moveLineMatrixTypeTroop`).

#### ب. هيكلية حزمة البيانات الرسمية الكاملة (Complete Packet Structure)
مستخرجة من `worldMapFunction.lua:186-238` و `WorldDispatchArmyViewPanel.lua:1359-1494`:
```json
{
  "moveLineType": 15,
  "matrixType": 1,
  "commandHallTaskType": 2,
  "commandHallTaskID": 2001,
  "data": {
    "to": {
      "x": 612,
      "y": 584,
      "id": "1-2001-..."
    },
    "data": {
      "commandHallTaskType": 2,
      "commandHallTaskID": 2001
    },
    "army": [
      {"id": 401, "num": 50000},
      {"id": 501, "num": 50000}
    ],
    "heroInfo": [
      {"heroID": 1700},
      {"heroID": 1701}
    ],
    "armsInfo": [],
    "divineBeastInfo": [],
    "mapId": 1,
    "isDuel": false,
    "isKillLeaderNpc": false,
    "killNormalNpcLv": 0,
    "isForbidSpeed": false,
    "isSecondaryLock": false
  }
}
```
*ملاحظة حرجة*: البوت في السابق كان يرسل حزمة مبسطة تخلو من كائن `army` الميداني وكائن `heroInfo`؛ البروتوكول الرسمي يضع `to` و `army` و `heroInfo` مدمجة داخل الحقل المتشعب `data`.

#### ج. استلام الجائزة بعد وصول الفيلق وانتصاره
عند وصول الفيلق إلى الهدف وهزيمته، يرسل السيرفر إشعاراً `gNotifyID.COMMAND_HALL` بنوع `PIONEER_TASK` (`commandHallCtrl.lua:56-86`).
تتغير حالة المهمة إلى `FINISH` (3).
يتم استلام الجائزة عبر إرسال CMD `"2274"` SubCMD `"8"`:
```json
{
  "commitType": 2,
  "index": 2
}
```

---

### النوع 3: المعلومات العسكرية / الحوار (`DIALOGUE_TASK`)

#### أ. ملفات التحكم والخيارات
- الملف المصدري لواجهة الحوار: `game_file/src/fgui/views/CommandHall/CommandHallTalkPanel.lua`.
- ملف نصوص وتفرعات الحوار: `game_file/src/app/localtb/config_client/newcommandhalldialogue.lua`.

#### ب. طبيعة خيارات الحوار (Client-Side Only)
- في `CommandHallTalkPanel.lua:54-63`:
  يعرض العميل أزرار الإجابات (`btn_answer1` و `btn_answer2`) بناءً على المفاتيح `key1` و `key2`.
  عند نقر أي زر، يتم استدعاء `onClickBtnAnswer(tag)` للتنقل إلى العقدة التالية `later1` أو `later2` محلياً داخل شجرة الحوار.
- **الاكتشاف القاطع**: **لا يتم إرسال أي من خيارات اللاعب أو إجاباته إلى السيرفر على الإطلاق!**
  الحوار بأكمله عبارة عن واجهة مرئية محلية (Visual Novel UI).

#### ج. حزمة الإنهاء الشبكية
عند الوصول إلى نهاية الحوار، يتم استدعاء الدالة المباشرة (`CommandHallTalkPanel.lua:65-68`):
```lua
function CommandHallTalkPanel:endDialogue(...)
    commandHallCtrl:reqFinishTask(self.taskData.index)
    self:closePanel()
end
```
- **حزمة الإنهاء المباشرة**:
  CMD `"2274"`، SubCMD `"5"` (`REQ_COMMAND_HALL_FINISH_TASK`)
  الحمولة:
  ```json
  {
    "index": 3
  }
  ```
- **استلام الجائزة**:
  تتحول المهمة إلى `statue = 3` (`FINISH`)، ويتم استلام المكافأة عبر:
  CMD `"2274"`، SubCMD `"8"` (`REQ_COMMAND_HALL_COMMIT_TASK`)
  الحمولة:
  ```json
  {
    "commitType": 3,
    "index": 3
  }
  ```

---

### النوع 4: إنقاذ القرويين (`RESCUE_TASK`)

#### أ. سلوك المهمة
- لا تتطلب أي فيلق أو جنود على الإطلاق (`checkTaskTypeNeedArmy == false`).
- في واجهة قاعة القيادة (`CommandHallMainPanel.lua:588-589`):
  ```lua
  elseif taskType == gCommandHallTaskType.RESCUE_TASK then
      commandHallCtrl:reqFinishTask(taskIndex)
  ```
  تُنفذ فوراً دون محاكاة أو مسير حقيقي!

#### ب. حزمة الإنهاء الشبكية الفورية
- CMD `"2274"`، SubCMD `"5"` (`REQ_COMMAND_HALL_FINISH_TASK`)
  الحمولة:
  ```json
  {
    "index": 4
  }
  ```
- **استلام المكافأة**:
  CMD `"2274"`، SubCMD `"8"` (`REQ_COMMAND_HALL_COMMIT_TASK`)
  الحمولة:
  ```json
  {
    "commitType": 4,
    "index": 4
  }
  ```

---

### النوع 5: فريق الغزاة / المعركة (`BATTLE_TASK`)

#### أ. طبيعة المهمة
- تظهر على الخريطة كـ NPC (`checkTaskTypeShowNpc == true`).
- تتطلب إرسال فيلق حقيقي (`checkTaskTypeNeedArmy == true`).

#### ب. بروتوكول المسير الرسمي (`CMD 1007 SubCMD 2`)
- **الأمر**: CMD `"1007"` SubCMD `"2"` (`ADD_KINGDOM_QUEUE`).
- **نوع المسير**: `moveLineType = 15`.
- **نوع المصفوفة**: `matrixType = 1`.
- **الحمولة الرسمية**:
  ```json
  {
    "moveLineType": 15,
    "matrixType": 1,
    "commandHallTaskType": 5,
    "commandHallTaskID": 5001,
    "data": {
      "to": {
        "x": 620,
        "y": 590,
        "id": "1-5001-..."
      },
      "data": {
        "commandHallTaskType": 5,
        "commandHallTaskID": 5001
      },
      "army": [
        {"id": 401, "num": 50000}
      ],
      "heroInfo": [
        {"heroID": 1700}
      ],
      "armsInfo": [],
      "divineBeastInfo": [],
      "mapId": 1,
      "isDuel": false,
      "isKillLeaderNpc": false,
      "killNormalNpcLv": 0,
      "isForbidSpeed": false,
      "isSecondaryLock": false
    }
  }
  ```

#### ج. معالجة النتيجة واستلام المكافأة
عند وصول الفيلق، يرسل السيرفر إشعار `COMMON_TASK` (`commandHallCtrl.lua:127-181`).
إذا كانت النتيجة فوزاً (`win == true`)، تصبح المهمة `statue == 3`.
يتم استلام الجائزة عبر CMD `"2274"` SubCMD `"8"`:
```json
{
  "commitType": 5,
  "index": 5
}
```

---

### النوع 6: القناص الصامت (`SNIPE_HUNTER_TASK`)

#### أ. فحص واجهة اللعبة المصغرة والتحكم
- ملف الواجهة: `game_file/src/fgui/views/SneakSnipeGame/SneakSnipeGamePanel.lua`.
- ملف وسيط النتائج: `game_file/src/fgui/views/SneakSnipeGame/SneakSnipeResultProxy.lua`.
- وحدة التحكم: `game_file/src/app/module/commandHall/commandHallCtrl.lua:733-741`:
  ```lua
  function commandHallCtrl:setSoldierRushResultIndex(index)
      self.resultIndex = index
      local task = self:getTaskByIndex(self.resultIndex)
      local archeryId = task.shellType
      uiManager:show("SneakSnipeGame", { sceneType = archeryId, isTaskGame = true })
  end
  ```
- معالجة نتيجة اللعبة في `commandHallCtrl.lua:185-206`:
  ```lua
  function commandHallCtrl:onMsgGameResult(target, event)
      if self.resultIndex then
          local task = self:getTaskByIndex(self.resultIndex)
          if not task then return end
          if event.isWin then
              commandHallCtrl:reqFinishTask(self.resultIndex)
          end
          self.resultIndex = nil
      end
  end
  ```

#### ب. الاكتشاف المرجعي الحاسم (Zero-MiniGame Protocol)
- اللعبة المصغرة (`SneakSnipeGame`) تجري **بالكامل على جهاز المستخدم (Client-Side Rendering)** عبر محرك الرسوميات ولا ترسل أي إحداثيات أو إصابات أسهم للسيرفر.
- عند إتمام اللعبة بالفوز، ترسل الواجهة رسالة داخلية `MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE` مع `isWin = true`، فتقوم دالة `onMsgGameResult` باستدعاء `commandHallCtrl:reqFinishTask(self.resultIndex)` مباشرة!
- **حزمة الشبكة المباشرة لإنهاء القناص الصامت فوراً دون فتح اللعبة المصغرة**:
  CMD `"2274"`، SubCMD `"5"` (`REQ_COMMAND_HALL_FINISH_TASK`)
  الحمولة:
  ```json
  {
    "index": 6
  }
  ```
- **استلام المكافأة**:
  CMD `"2274"`، SubCMD `"8"` (`REQ_COMMAND_HALL_COMMIT_TASK`)
  الحمولة:
  ```json
  {
    "commitType": 6,
    "index": 6
  }
  ```

---

## 3. تصنيف الأبطال (Hero Classification: Combat vs Gathering)

### 3.1 تصنيف أنواع الأبطال في المحرك
من `game_file/src/app/localtb/config_client/hero_type_info.lua`:
```lua
id = 1, heroType = 1, typename = "hero_typename_01", icon = "icon_herotype_fuzhu.png"    -- نوع الدعم (مساعد/تنمية/جمع)
id = 2, heroType = 2, typename = "hero_typename_02", icon = "icon_herotype_chebing.png"  -- نوع العربة الحربية (Chariot)
id = 3, heroType = 3, typename = "hero_typename_03", icon = "icon_herotype_qibing.png"   -- نوع الفرسان (Cavalry)
id = 4, heroType = 4, typename = "hero_typename_04", icon = "icon_herotype_gongbing.png" -- نوع الرماة (Archer)
id = 5, heroType = 5, typename = "hero_typename_05", icon = "icon_herotype_bubing.png"   -- نوع المشاة (Infantry)
```

### 3.2 أبطال الدعم والجمع (Support / Gathering Heroes - Type 1)
من `hero_view_info.lua` و `hero_skill_conf.lua` و `local_arab.json`:
يوجد في اللعبة 4 أبطال فقط يتبعون `heroType == 1`:
1. **المعرف 1711**: `الأنيق` (مهاراته سعة المصابين `buffType = 95`).
2. **المعرف 1717**: `المزيونة` (بطلة الجمع المتخصصة، مهاراتها سرعة وقدرة جمع الموارد `JUNIOR_COLLECT_KO` `buffType = 302`).
3. **المعرف 1724**: `الضرغام` (مهاراته إنتاج البلور `buffType = 99`).
4. **المعرف 1733**: `صخر` (مهاراته سرعة علاج الجنود بالمشفى `buffType = 102`).

### 3.3 أبطال القتال والحروب (Combat Heroes - Types 2-5)
جميع الأبطال الآخرين (53 بطلاً) يمتلكون `heroType` من 2 إلى 5:
- **أبطال المشاة (`heroType = 5`)**: الفاتح (1703)، الأسطورة (1709)، أمير الحرب (1710)، الغضنفر (1712)، السفاح (1713)، المستبدة (1719)، الكاسر (1720)، المُهاب (1727)، الحازم البتار (1731)، العاصوف (1736)، إلخ.
- **أبطال الفرسان (`heroType = 3`)**: أمير الصحراء (1700)، أمير الظلام (1704)، الزعيم (1714)، المفترس (1718)، صائد الفرسان (1721)، اليمامة (1725)، الصارم المقدام (1728)، جساس (1730)، الإمبراطور (1732)، العنقاء (1735)، إلخ.
- **أبطال الرماة (`heroType = 4`)**: قاهرة الأعداء (1701)، البارق (1705)، صقر المملكة (1706)، المرعب (1707)، أميرة الرماة (1716)، الهمام (1722)، الأمير القناص (1723)، جسار (1726)، الباسلة (1729)، العنيد (1734)، إلخ.
- **أبطال العربات (`heroType = 2`)**: أمير الشرق (1702)، أميرة الحرب (1708).

### 3.4 منطق انتقاء الأبطال لمسير قاعة القيادة
1. استبعاد فوري لأي بطل يحمل `heroType == 1` (الأنيق، المزيونة، الضرغام، صخر).
2. التحقق من حالة البطل في الذاكرة الحية (`hInfo.state`):
   - يجب أن يكون `NORMAL (1)` أو `DEFEND (2)` (جاهز للمسير).
   - استبعاد أي بطل بحالة `BATTLE (3)` أو `CAPTURED (4)` أو `DEAD (5)`.
3. عدد الأبطال المسموح به في الفيلق الواحد:
   - يحسب عبر دالة `heroCtrl:getMaxBattleHeroNum()` في `module/hero/heroCtrl.lua:1221`:
     قراءة ثوابت `HIRED_HEROES_1_LV` إلى `HIRED_HEROES_5_LV` ومقارنتها بمستوى القلعة الحالي (حتى 5 أبطال).

---

## 4. معادلة حساب سعة مسير الجيش الرسمية (Army March Capacity Calculation)

المصدر المرجعي الصارم: `game_file/src/app/module/city/buildLogic.lua:1861-1904`:
```lua
function buildLogic.getExpArmyCount(moveLineType)
```

### عناصر المعادلة الدقيقة:
1. **السعة الأساسية (`base`)**:
   - سعة مبنى ساحة العرض (`BUILDID.DRILL_GROUDS` = 4220):
     `base = buildLogic.getBuildBaseValue(BUILDID.DRILL_GROUDS, "capacity", bcell)`
2. **القيمة الافتراضية الثابتة (`default`)**:
   - `gConstValue.DEFAULT_EXP_ARMY_COUNT = 1000` (`constValue.lua:14`).
3. **أبحاث المعهد لتعزيز الفيلق (`tech_add`)**:
   - أبحاث قيادة الجيش الأساسية:
     `tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.SINGLE_TROOP_STRENGTH)`
4. **أبحاث المجموعات الإضافية (`techGroupAdd`)**:
   - `CONQUEST_WAR_SINGLE_TROOP_STRENGTH`
   - `PYRAMID_SINGLE_TROOP_STRENGTH`
   - `LEGEND_SINGLE_TROOP_STRENGTH`
5. **إضافات التعزيز الرقمية الثابتة (`total_add`)**:
   - بفات السعة الرقمية: `buff_value_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)`.
   - سمات الحاكم والمعدات: `attrAdd = attributeSystem.query(gAttributeEnum.DISPATCH_TROOP_COUNT_NUM)`.
   - بونص الأبطال الرقمي: `hero_add = heroCtrl:getTheActiveBuff(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)`.
   - `total_add = default + tech_add + buff_value_add + attrAdd + hero_add`
6. **بفات النسبة المئوية (`buff_percent_add`)**:
   - نسبة تعزيز المسير (من VIP، والمواهب، والمشروبات، إلخ):
     `buff_percent_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST) / 1000`
7. **النسبة الإضافية للمسير (`buff_add`)**:
   `buff_add = math.floor((base + total_add) * (buff_percent_add + techGroupAdd))`
8. **السعة الإجمالية النهائية للمسير (`total`)**:
   $$\text{Total Capacity} = \text{base} + \text{total\_add} + \text{buff\_add}$$
   أي:
   $$\text{Total Capacity} = \lfloor (\text{base} + 1000 + \text{tech} + \text{flat\_buffs}) \times (1 + \text{buff\_percent} + \text{techGroupAdd}) \rfloor$$

---

## 5. جدول ملخص الميزات المكتشفة (Features Discovered Table)

| # | Category | Feature | Description | Inputs | Outputs | Error Behavior | Discovered Via |
|---|----------|---------|-------------|--------|---------|----------------|----------------|
| 1 | Subtask 1 | `REBEL_ARMY_GROUP_TASK` | الهجوم على فيلق الغزاة الجماعي | CMD 2274 SubCMD 7 (`armyInfo`, `heroInfo`, ...) | `rspdata.initData` | خطأ 0 يعيد تحديث HP | `commandHallCtrl.lua:343` |
| 2 | Subtask 1 | `COMMIT_ARMY_GROUP` | استلام مكافأة هزيمة فيلق الغزاة وتجديد المهام | CMD 2274 SubCMD 8 (`commitType=1`, `index`) | تجديد قائمة المهام وترقية `armyGroupID` | لا يتجدد إذا لم يستلم | `commandHallCtrl.lua:370` |
| 3 | Subtask 2 | `REBEL_ARMY_PIONEER_TASK` | إرسال فيلق لطليعة الغزاة على الخريطة | CMD 1007 SubCMD 2 (`moveLineType=15`, `matrixType=1`, `army`, `heroInfo`) | انطلاق طابور السير على الخريطة | رفض إذا كان الطابور ممتلئاً | `worldMapFunction.lua:186` |
| 4 | Subtask 2 | `COMMIT_PIONEER` | استلام جائزة طليعة الغزاة بعد الانتصار | CMD 2274 SubCMD 8 (`commitType=2`, `index`) | منح الجوائز وحذف المهمة | خطأ إذا لم تكن في حالة FINISH | `commandHallCtrl.lua:370` |
| 5 | Subtask 3 | `DIALOGUE_TASK` | إنهاء مهمة المعلومات العسكرية (حوار) | CMD 2274 SubCMD 5 (`index`) | اكتمال المهمة (`statue=3`) | الحوار شكلي محلي | `CommandHallTalkPanel.lua:66` |
| 6 | Subtask 3 | `COMMIT_DIALOGUE` | استلام جائزة مهمة الحوار | CMD 2274 SubCMD 8 (`commitType=3`, `index`) | عناصر الجائزة بالحقيبة | يتطلب إنهاء مسبق | `commandHallCtrl.lua:370` |
| 7 | Subtask 4 | `RESCUE_TASK` | إنهاء مهمة إنقاذ القرويين الفورية | CMD 2274 SubCMD 5 (`index`) | اكتمال المهمة فوراً (`statue=3`) | استهلاك 0 طاقة | `CommandHallMainPanel.lua:589` |
| 8 | Subtask 4 | `COMMIT_RESCUE` | استلام مكافأة إنقاذ القرويين | CMD 2274 SubCMD 8 (`commitType=4`, `index`) | مكافآت القرويين | يتطلب إنهاء مسبق | `commandHallCtrl.lua:370` |
| 9 | Subtask 5 | `BATTLE_TASK` | مسير فيلق لمواجهة فريق الغزاة بالخريطة | CMD 1007 SubCMD 2 (`moveLineType=15`, `matrixType=1`) | طابور مسير وهجوم على NPC | استهلاك طاقة وجنود | `worldMapCommandHallNpcViewPanel.lua:103` |
| 10 | Subtask 5 | `COMMIT_BATTLE` | استلام مكافأة فريق الغزاة | CMD 2274 SubCMD 8 (`commitType=5`, `index`) | جوائز المعركة | يتطلب انتصار الفيلق | `commandHallCtrl.lua:370` |
| 11 | Subtask 6 | `SNIPE_HUNTER_TASK` | إنهاء مهمة القناص الصامت مباشرة (0-MiniGame) | CMD 2274 SubCMD 5 (`index`) | اكتمال المهمة فوراً (`statue=3`) | تجاوز الرسوميات بأمان تام | `SneakSnipeGamePanel.lua:592` & `commandHallCtrl.lua:195` |
| 12 | Subtask 6 | `COMMIT_SNIPE` | استلام مكافأة القناص الصامت | CMD 2274 SubCMD 8 (`commitType=6`, `index`) | مكافآت القنص | يتطلب إنهاء مسبق | `commandHallCtrl.lua:370` |
| 13 | Hero | `Hero Classification` | تصنيف أبطال القتال مقابل الجمع | فحص حقل `heroType` في `hero_view_info.lua` | تصفية أبطال `heroType == 1` | استبعاد دياوشان/المزيونة (1717) والأنيق (1711) | `hero_type_info.lua:3-26` |
| 14 | Capacity | `March Capacity Calc` | حساب السعة القصوى لمسير الجيش | قراءة ساحة العرض + الأبحاث + البفات + VIP | السعة الدقيقة للفيلق | منع تجاوز سعة السير | `buildLogic.lua:1861` |

---

## 6. الحالات الحدية (Edge Cases)

| # | Feature | Input | Observed Behavior |
|---|---------|-------|-------------------|
| 1 | `REBEL_ARMY_GROUP_TASK` | استدعاء `reqAttackArmyGroup()` بدون معاملات `{}` | السيرفر ينفذ الهجوم الاستباقي بقوات الدفاع الافتراضية للقلعة ويخصم نقاط صحة الغزاة. |
| 2 | `REBEL_ARMY_GROUP_TASK` | استلام الجائزة قبل انتهاء صحة الفيلق | السيرفر يرفض الطلب ويعيد رمز خطأ، حيث يشترط `task.hurtHp >= task.rabelHp`. |
| 3 | `SNIPE_HUNTER_TASK` | إرسال `REQ_COMMAND_HALL_FINISH_TASK` مباشرة بدون فتح اللعبة المصغرة | السيرفر يقبل الباكيت فوراً وينقل المهمة إلى `statue=3` لأن منطق اللعبة المصغرة محلي بالكامل. |
| 4 | `DIALOGUE_TASK` | اختيار أي فرع حواري | لا تأثير على الشبكة، والباكيت النهائي واحد دائماً `{"index": task.index}`. |
| 5 | `REBEL_ARMY_PIONEER_TASK` | نقص الجنود أو انشغال كافة طوابير المسير | يجب فحص الذاكرة مسبقاً (0-Network)؛ إرسال الطلب مع طوابير ممتلئة يسبب رفض السيرفر وخطأ. |
| 6 | `Hero Selection` | إدراج البطلة المزيونة (1717) أو الأنيق (1711) في مسير الغزاة | البطل لا يقدم أي بونص حربي، وتصنيفه نوع دعم `heroType = 1` مما يضعف قوة الفيلق في المعركة. |
| 7 | `March Capacity` | غياب بفات VIP أو عدم بناء ساحة العرض | تعتمد السعة على القيمة الافتراضية `DEFAULT_EXP_ARMY_COUNT = 1000` زائداً أبحاث قيادة الجيش. |
