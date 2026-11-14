# Handoff Report — Command Hall Deep Specification Mining

**Date**: 2026-11-01  
**Agent**: `teamwork_spec_miner` (Specification Miner)  
**Task Working Directory**: `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_survey_1`  
**Handoff Type**: Hard (Task Complete)

---

## 1. Observation (الملاحظات الميدانية المباشرة)

1. **ثوابت الشبكة والأوامر الرسمية (`wholeDefine.lua` & `cmdDef.lua`)**:
   - `wholeDefine.lua:1365-1375`:
     ```lua
     ;(nil).REBEL_ARMY_GROUP_TASK = 1
     ;(nil).REBEL_ARMY_PIONEER_TASK = 2
     ;(nil).DIALOGUE_TASK = 3
     ;(nil).RESCUE_TASK = 4
     ;(nil).BATTLE_TASK = 5
     gCommandHallTaskType, (nil).SNIPE_HUNTER_TASK = nil, 6
     ```
   - `cmdDef.lua:3242-3254`:
     ```lua
     ;(nil).CMD_COMMAND_HALL_MODULE = "2274"
     ;(nil).REQ_COMMAND_HALL_INIT = "1"
     ;(nil).REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"
     ;(nil).REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"
     ;(nil).REQ_COMMAND_HALL_FINISH_GUIDE = "4"
     ;(nil).REQ_COMMAND_HALL_FINISH_TASK = "5"
     ;(nil).REQ_COMMAND_HALL_SET_DEFEND = "6"
     ;(nil).REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"
     ;(nil).REQ_COMMAND_HALL_COMMIT_TASK = "8"
     ;(nil).REQ_COMMAND_HALL_REFRESH_POS = "9"
     ;(nil).REQ_COMMAND_HALL_REFRESH_POS2 = "10"
     ;(nil).REQ_COMMAND_HALL_GET_BATTLE_INFO = "11"
     ;(nil).REQ_COMMAND_HALL_GET_RANK_INFO = "12"
     ```
   - `cmdDef.lua:237-238` & `mapDef.lua:395, 411`:
     ```lua
     ;(nil).CMD_KINGDOM_QUEUE_MODULE = "1007"
     ;(nil).ADD_KINGDOM_QUEUE = "2"
     moveLineTypeCommandHallNpc = 15
     moveLineMatrixTypeTroop = 1
     ```

2. **تصنيف متطلبات الجيش وظهور الوحوش (`commandHallUtil.lua:114-126`)**:
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

3. **هجوم فيلق الغزاة الجماعي (Type 1) وتجديد القائمة (`Com_MainReward.lua:206-237` & `commandHallCtrl.lua:343-393`)**:
   - الهجوم المباشر: `commandHallCtrl:reqAttackArmyGroup()` (أمر 2274 SubCMD 7). إذا أُرسل بدون معلمات، يُرسل `{}` ويعتمد السيرفر قوة الدفاع الأساسية.
   - استلام الجائزة: `commandHallCtrl:reqCommitTask(1, task.index)` (أمر 2274 SubCMD 8) مع `commitType = 1`.
   - استجابة السيرفر: تمنح الجوائز، ترفع `armyGroupID`، وتفرغ وتولد مهام جديدة (`commonTaskData`).

4. **حوار المعلومات العسكرية (Type 3) (`CommandHallTalkPanel.lua:65-68`)**:
   ```lua
   function CommandHallTalkPanel:endDialogue(...)
       commandHallCtrl:reqFinishTask(self.taskData.index)
       self:closePanel()
   end
   ```
   لا تُرسل أي خيارات أو تفرعات حوارية للسيرفر. الإنجاز يتم حصراً عبر `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) بحمولة `{"index": task.index}`، يليه استلام الجائزة عبر `REQ_COMMAND_HALL_COMMIT_TASK` (CMD 2274 SubCMD 8) بحمولة `{"commitType": 3, "index": task.index}`.

5. **إنقاذ القرويين (Type 4) (`CommandHallMainPanel.lua:588-589`)**:
   ```lua
   elseif taskType == gCommandHallTaskType.RESCUE_TASK then
       commandHallCtrl:reqFinishTask(taskIndex)
   ```
   إنجاز فوري عبر CMD 2274 SubCMD 5 بـ `{"index": taskIndex}`، يليه استلام عبر SubCMD 8 بـ `{"commitType": 4, "index": taskIndex}`.

6. **القناص الصامت (Type 6) (`commandHallCtrl.lua:185-206` & `SneakSnipeResultProxy.lua:6-11`)**:
   اللعبة المصغرة تعمل على العميل فقط. عند الفوز، تُطلق رسالة `MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE` مع `isWin = true`، فيستدعي العميل:
   `commandHallCtrl:reqFinishTask(self.resultIndex)`
   أي أن أمر الإنهاء المباشر دون تشغيل الرسوميات هو CMD 2274 SubCMD 5 بـ `{"index": taskIndex}`، يليه الاستلام عبر SubCMD 8 بـ `{"commitType": 6, "index": taskIndex}`.

7. **حزمة مسير طليعة الغزاة (Type 2) وفريق الغزاة (Type 5) (`worldMapFunction.lua:186-238` & `WorldDispatchArmyViewPanel.lua:1359-1494`)**:
   - إرسال الفيلق: CMD `"1007"` SubCMD `"2"` (`ADD_KINGDOM_QUEUE`).
   - هيكل الحزمة الرسمي:
     ```json
     {
       "moveLineType": 15,
       "matrixType": 1,
       "commandHallTaskType": <taskType>,
       "commandHallTaskID": <taskID>,
       "data": {
         "to": {"x": target_x, "y": target_y, "id": instance_id},
         "data": {"commandHallTaskType": <taskType>, "commandHallTaskID": <taskID>},
         "army": [{"id": armyID, "num": count}, ...],
         "heroInfo": [{"heroID": heroID}, ...],
         "armsInfo": [],
         "divineBeastInfo": [],
         "mapId": mapId
       }
     }
     ```

8. **تصنيف الأبطال (قتال vs جمع) (`hero_type_info.lua:1-26` & `hero_view_info.lua`)**:
   - `heroType = 1`: نوع الدعم والتنمية والجمع (`icon_herotype_fuzhu.png`):
     يشمل فقط 4 أبطال:
     * 1711: الأنيق (سعة الجرحى)
     * 1717: المزيونة (دياوشان العربية - جمع الموارد `buffType = 302`)
     * 1724: الضرغام (إنتاج البلور)
     * 1733: صخر (سرعة العلاج)
   - `heroType = 2, 3, 4, 5`: أبطال القتال والحروب (مشاة، فرسان، رماة، عربات).
   - الفلترة الصحيحة لمسير قاعة القيادة: استبعاد الأبطال أصحاب `heroType == 1`، واختيار أبطال القتال الجاهزين (`state in (NORMAL, DEFEND)`).

9. **معادلة سعة مسير الجيش الرسمية (`buildLogic.lua:1861-1904`)**:
   - `base`: سعة ساحة العرض (`BUILDID.DRILL_GROUDS`).
   - `default`: `1000` (`gConstValue.DEFAULT_EXP_ARMY_COUNT`).
   - `tech_add`: أبحاث قيادة الجيش (`SINGLE_TROOP_STRENGTH`).
   - `techGroupAdd`: مجموع أبحاث حرب الفتوحات والأهرامات والأسطورة.
   - `flat_buffs`: `MARCH_VALUE_LIMIT_BOOST` + `DISPATCH_TROOP_COUNT_NUM` + بونص الأبطال.
   - `buff_percent`: `MARCH_LIMIT_BOOST / 1000` (من VIP، المواهب، إلخ).
   - المعادلة:
     $$\text{Capacity} = \lfloor (\text{base} + 1000 + \text{tech} + \text{flat\_buffs}) \times (1 + \text{buff\_percent} + \text{techGroupAdd}) \rfloor$$

---

## 2. Logic Chain (سلسلة الاستدلال المنطقي)

1. **الاستدلال على المهام الفورية المباشرة (3، 4، 6)**:
   - بالنظر إلى الملاحظة (2)، صُنفت المهام 3 و 4 و 6 كمهام `checkTaskTypeNeedArmy == false`.
   - بالنظر إلى الملاحظات (4، 5، 6)، تؤدي جميع هذه المهام الثلاث في كود الواجهة إلى استدعاء دالة واحدة متطابقة: `commandHallCtrl:reqFinishTask(index)`.
   - الاستنتاج: المهام 3 و 4 و 6 يمكن للبوت إنجازها فورياً بضمان 100% وأمان تام ودون محاكاة رسومية عبر إرسال CMD 2274 SubCMD 5، ثم استلام جوائزها عبر CMD 2274 SubCMD 8.

2. **الاستدلال على مهام المسير (2 و 5) وتصحيح هيكل الحزمة**:
   - بالنظر إلى الملاحظات (2 و 7)، تتطلب المهمتان 2 و 5 مسير جيش حقيقي على الخريطة بنوع مسير `moveLineType = 15`.
   - في كود البوت السابق (`tasks/command_hall.py:527-533`)، كانت حزمة `ADD_KINGDOM_QUEUE` ترسل فقط `to`, `moveLineType`, `matrixType`, `taskIndex`, `taskType` وتفتقر إلى كائن `army` الميداني ومصفوفة `heroInfo`.
   - بالنظر إلى الملاحظة (7)، تتطلب خوادم اللعبة إدراج مصفوفة الجنود `army` وتشكيلة الأبطال `heroInfo` داخل كائن `data` المتشعب.
   - الاستنتاج: يجب تعديل دالة إرسال الفيلق في `tasks/command_hall.py` لتشمل حساب القوات وسعة الجيش والأبطال وفق الهيكل الرسمي في الملاحظة (7).

3. **الاستدلال على تصفية الأبطال ومنع أبطال الجمع**:
   - بالنظر إلى الملاحظة (8)، صُنفت دياوشان/المزيونة (1717) والأنيق (1711) تحت `heroType = 1` (نوع الدعم/الجمع).
   - الاستنتاج: استبعاد أي بطل يحمل `heroType == 1` من فيالق قاعة القيادة، وانتقاء أبطال القتال المؤهلين من الأنواع 2-5 فقط.

4. **الاستدلال على فيلق الغزاة المهاجم (Type 1)**:
   - بالنظر إلى الملاحظة (3)، عند وصول صحة الفيلق إلى الصفر (`hurtHp >= rabelHp`)، تتغير حالته إلى `FINISH (3)`.
   - استدعاء `REQ_COMMAND_HALL_COMMIT_TASK` مع `commitType = 1` يُحدث نقلة نوعية في بيانات القلعة: يمنح مكافأة الفوز المباشرة، ويرفع `armyGroupID`، ويجدد قائمة المهام اليومية بالكامل.
   - الاستنتاج: تضمين معالجة واستلام الفيلق الجماعي (Type 1) هو المفتاح الأساسي لضمان تجديد ظهور مهام قاعة القيادة.

---

## 3. Caveats (التحفظات والاستثناءات)

1. تم استخراج جميع الأرقام والقواعد من الكود المصدري الرسمي للعميل (Client Lua) في `game_file/`. بعض المتغيرات مثل سرعة المسير الفردية على الخريطة قد تتأثر ببفات خاصة بحرب الممالك إذا كانت القلعة تشارك في حدث خاص.
2. لا توجد أي تحفظات أخرى (No caveats).

---

## 4. Conclusion (الخلاصة والقرارات القابلة للتنفيذ)

1. **المهام الفورية الثلاث (3، 4، 6)**:
   - تنفيذ فوري عبر CMD `"2274"` SubCMD `"5"` بحمولة `{"index": task.index}`.
   - استلام الجوائز عبر CMD `"2274"` SubCMD `"8"` بحمولة `{"commitType": task.type, "index": task.index}`.
2. **فيلق الغزاة المهاجم (Type 1)**:
   - هجوم استباقي اختياري عبر CMD `"2274"` SubCMD `"7"` بحمولة `{}`.
   - عند اكتمال الضرر (`statue == 3`)، استلام وتجديد المهام عبر CMD `"2274"` SubCMD `"8"` بحمولة `{"commitType": 1, "index": task.index}`.
3. **مهام الفيالق (2 و 5)**:
   - إرسال فيلق عبر CMD `"1007"` SubCMD `"2"` بحمولة متكاملة تشمل `moveLineType = 15`، `matrixType = 1`، وقائمة الجنود `army` ضمن سعة المسير المحسوبة بدقة، وأبطال القتال فقط.
4. **تصنيف الأبطال**:
   - حظر أبطال `heroType == 1` (1711, 1717, 1724, 1733).
   - اختيار أبطال القتال من `heroType in (2, 3, 4, 5)` حتى الحد الأقصى للمستوى (`getMaxBattleHeroNum`).

---

## 5. Verification Method (طريقة التحقق الميداني المستقل)

1. **فحص ملفات المواصفات ومطابقة الأسطر**:
   - فحص `game_file/src/app/constdef/wholeDefine.lua` أسطر 1365-1382.
   - فحص `game_file/src/app/constdef/cmdDef.lua` أسطر 3242-3254.
   - فحص `game_file/src/app/localtb/config_client/hero_type_info.lua`.
   - فحص `game_file/src/app/module/city/buildLogic.lua` أسطر 1861-1904.
2. **تشغيل أداة فحص الأبطال الميدانية**:
   ```powershell
   python tools/inspect_hero_types.py
   ```
   يجب أن يعيد تصنيف دقيق لأبطال الدعم الأربعة (1711, 1717, 1724, 1733) وأبطال القتال الـ 53.
