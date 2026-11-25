# التقرير الجنائي الشامل للذاكرة الحية ومعالجة الإشعارات (`Live Memory & NOTIFY Audit`)

> **مُعدّ خصيصاً لنموذج كاربون (Carbon) كمرجع تنفيذي مباشر للتشخيص النهائي والإصلاح.**
> **نطاق الفحص:** للقراءة والتحليل فقط (لم يُعدَّل أي ملف كود). شمل الفحص: `core/live_memory.py`، `core/game_client.py`، `bot_manager.py`، `tasks/base_task.py`، `tasks/march_manager.py`، `tasks/march_capacity.py`، `tasks/exclude_manager.py`، وجميع المهام الفعّالة المسجلة في `REGISTERED_TASKS` (27 فئة) بالإضافة إلى المهام الست الفرعية المستدعاة عبر `MarchManagerTask` (إجمالي **36 ملف مهام** + **3 ملفات نواة**).
> **المرجع الحقيقي الوحيد:** كود اللعبة الرسمي المُفكَّك في `game_file/src/`، اللقطات الخمس الفعلية للذاكرة الحية في `docs/*_live_memory.json` (`beetoo1`, `beetoo2`, `beetoo3`, `lucifer`, `sample`)، وسجل التشغيل الحي `docs/live_cycle_log.txt` (1,511 سطراً).
> **قاعدة صفر مشاكل وهمية:** لا يحتوي هذا التقرير على أي ملاحظات تجميلية أو نظرية؛ كل خلل في الأقسام 2–5 **مؤكد بنسبة 100% بدليل قاطع** (مسار + سطر + مقابل Lua/JSON/Log)، وكل عنصر يتعذر إثباته قطعياً من كود العميل وحده مفصول تماماً في **القسم 6 (`تحتاج تحققاً ميدانياً`)**.

---

## الخلاصة المعمارية للأنماط الجذرية (5 أسباب رئيسية تفسّر >80% من الأعطال)

قبل استعراض التفاصيل، يكشف الفحص أن معظم أخطاء الذاكرة الحية في المشروع تعود إلى **5 أنماط معمارية متكررة**:

1. **التعديل المزدوج بعد الإشعارات (`Double-Mutation Drift`):**
   في `core/game_client.py:1888-1908`، تمر **كل حزمة واردة** على `memory_engine.ingest_packet_with_report(parsed)` **قبل** تحرير `Future` الخاص بـ `await self.conn.query(...)`. ويثبت السجل الحي `docs/live_cycle_log.txt` أن السيرفر يدفع `NOTIFY_BACKPACK (1)` و`NOTIFY_CITY (9)` و`NOTIFY_LORD (8)` و`NOTIFY_ARMY (15)` و`NOTIFY_EVERYDAY_TASK (55)` و`NOTIFY_BUFF (7)` **قبل** وصول رد الـ RPC. ولأن `_handle_notify_backpack` يعتمد على **جمع/طرح نسبي (Delta)**، فإن أي خصم/إضافة يدوية داخل المهام (`ensure_resources`, `watermill`, `shield`, `building`, `research`, `train`, `cure_wounded`, `material_synthesis`, `forge_equipment`, `stamina`, `gather_speed_buff`, `arena`, `command_hall`) تُضاعف التغيير (أو تُثلّثه في `watermill`!) وتُحدث انحرافاً دائماً طوال الجلسة.
2. **استخدام `_handle_notify_generic_controller` (`smart_deep_merge`) لمتحكمات تعتمد الاستبدال الكامل أو توجيه الأحداث:**
   قوائم غير مفهرسة تتضاعف (`stuffWorkshopCtrl.list` تنمو `7 -> 14 -> 21`، `escortCartCtrl.rewardMap`)، كائنات محذوفة لا تُحذف (`commandHallCtrl`, `badgeExchangeCtrl`, `pyramidCtrl`, `allianceTreasureCtrl`, `kingdomMapCtrl`)، حزم أحداث تُلقى في الجذر بدلاً من تحديث القوائم (`questCtrl`, `equipmentCtrl`, `wallsCtrl`, `allianceCtrl`)، ومزج غير صحيح بين متحكمين مستقلين (`NOTIFY_SHOP` يمسح `storesCtrl` بالكامل بـ `shopCtrl` الفارغ!).
3. **قائمة السماح (`ALLOWED_CONTROLLERS`) وبوابة الجاهزية (`is_memory_ready`) وبداية المهام (`controllers_ready`):**
   إسقاط متحكمات حقيقية تأتي في `CMD 1000/1` (`divineBeastCtrl`, `divineBeastMarkCtrl`, `godArmsRuneCtrl`, `miraculousWeaponCtrl`, `htData`)، فحص `heroCtrl` غير الموجود بدل `heroSysCtrl` في `is_memory_ready()` و`conn.heroes`، وإطلاق `controllers_ready` قبل اكتمال مزامنة المسيرات `1007/1000`.
4. **مشاركة نفس مرجع القائمة بين `init_data["local_queues"]` و`queueCtrl["queues"]`:**
   `core/live_memory.py:713-716, 2135-2139` تربط المفتاحين بنفس كائن القائمة (`own_q`). فتقوم `cure_wounded.py:186-205` بتعديل `queueCtrl["queues"]` **موضعياً (`[:] =` و`.append`)** مما يحقن طابور المستشفى `1202` مباشرة داخل `local_queues` ويسرق خانة مسيرة!
5. **غياب معالجات إشعارات منتصف الليل (`UTC Midnight`) وتراكم حالات الجلسة الطويلة:**
   غياب معالجة `NOTIFY_WORLD_UPDATE (2)` (عدم تجديد الدرع بعد انتهائه!)، و`NOTIFY_DAILYLOGIN_REWARD (18)`، و`NOTIFY_HERO_TRIAL (37)`، و`NOTIFY_TECHNOLOGY (494)`، و`NOTIFY_DUEL_IN_COOL_DOWN (500)`، و`NOTIFY_ARENA (1007)`، وسوء توجيه `NOTIFY_PET (65)` إلى `godBeastCtrl`، وكتابة `NOTIFY_TIME_REWARD/RESET (16/20)` و`NOTIFY_PYRAMID (27)` في الجذر بدل `["data"]` — جميعها تُعطّل المهام بدءاً من اليوم الثاني في الاتصالات المستمرة.

---

## 1. ملخص تنفيذي وحالة كل مكون ومهمة

> **دلالة الحالة:**
> - **سليمة:** لا يوجد خلل ذاكرة حية لا في الملف ولا في مسار `NOTIFY` الخاص به.
> - **بها خلل مؤكد (مباشر):** خلل مؤكد داخل كود الملف نفسه (وقد يتأثر أيضاً بأعطال موروثة من النواة).
> - **بها خلل مؤكد (موروث من المحرك):** كود المهمة نفسه سليم في قراءاته وتحديثاته المحلية، لكنه يتعطل بسبب خلل مؤكد في `core/live_memory.py` أو `tasks/base_task.py` أو `tasks/train.py`.

### 1.1 الطبقة الأساسية ومحركات البنية التحتية (7 ملفات)

| الملف | الحالة | أرقام الأعطال المؤكدة | ملخص سريع |
|---|---|---|---|
| `core/live_memory.py` | **بها خلل مؤكد (مباشر)** | `C-01`–`C-06`, `N-01`–`N-17`, `M-02`, `M-03`, `M-05` | قائمة بيضاء ناقصة، `is_memory_ready` تفحص `heroCtrl`، `_handle_cmd_1005`/`2021` بلا فحص `err==0` وخلط `1005/4` بالتدريب، تلويث `queueCtrl["queues"]`، وأعطال جوهرية في معالجات `NOTIFY` (متخصصة وعامة ومفقودة). |
| `core/game_client.py` | **بها خلل مؤكد (مباشر)** | `C-02`, `C-07`, `M-01`, `M-02` | `controllers_ready` يُفعَّل على أي حزمة `sess_id==0` وقبل اكتمال `1007/1000`؛ `conn.heroes` تقرأ `heroCtrl` غير الموجود. |
| `bot_manager.py` | **بها خلل مؤكد (مباشر)** | `C-08`, `M-01` | `sync_live_data_to_db` تقرأ `allianceCtrl.allianceName` غير الموجود (`""` دائماً) وتقرأ `fcInfo.totalFc` المتجمد؛ `connect()` لا ينتظر مزامنة `1007/1000` قبل `execute_tasks()`. |
| `tasks/base_task.py` | **بها خلل مؤكد (مباشر)** | `BT-01`–`BT-12`, `M-06`, `M-08`, `M-09`, `M-15` | 17 خللاً مؤكداً (تعديل مزدوج في `ensure_resources` وقاعة القيادة، `ottime` كطابع زمني، حقول `queueCtrl["1238"]`، `setID` كـ `int`، تدمير مدد `NOTIFY_BUFF`، إغفال `from.heroInfo` و`defendList` و`rarity`، مصائد السور، وحساب VIP للمسيرات). |
| `tasks/march_manager.py` | **بها خلل مؤكد (مباشر)** | `M-04`, `M-09`, `M-12`–`M-17` (+ موروثة) | سباق ما بعد الإرسال، إزاحة إحداثيات `+1`، تنسيق `target_id`، `buffCtrl` كـ `dict`، حقول ETA خاطئة، تصنيف مسيرات العودة. |
| `tasks/march_capacity.py` | **بها خلل مؤكد (مباشر)** | `M-14` (+ `V-09`, `V-14`) | `now=None` افتراضياً وكل المستدعين لا يمررون `now` (البافات المنتهية تبقى محسوبة وتُضخّم السعة) + تجاهل `stopTime`/`endTime`. |
| `tasks/exclude_manager.py` | **بها خلل مؤكد (مباشر)** | `M-13` | يفترض فاصل `"-"` فقط بينما `march_manager` يولّد `"wood_X_Y"` -> تخزين `x=NULL, y=NULL` وتجاوز فلتر المسافة وتسرب حجز الموارد. |

### 1.2 المهام المسجلة في `REGISTERED_TASKS` (26 مهمة + `MarchManagerTask` و6 وحدات مسيرات فرعية)

| # | ملف المهمة | اسم المهمة | الحالة | الأعطال المؤكدة | تحقق ميداني | ملخص سريع |
|---|---|---|---|---|---|---|
| 1 | `tasks/port.py` | `port` | **بها خلل مؤكد (مباشر + موروث)** | `T-01`, `N-04` | `V-01` | يقرأ `time` الثابت ويتجاهل `isReceive`/`receiveTime`، و`NOTIFY 16/20` يكتبان في الجذر بدل `["data"]`. |
| 2 | `tasks/merchant_ship.py` | `merchant_ship` | **بها خلل مؤكد (موروث من المحرك)** | `N-17` | — | كود المهمة سليم 100%؛ لكن غياب `NOTIFY_DAILYLOGIN_REWARD (18)` في `live_memory.py` يجمّد `canReceive=False` من اليوم الثاني. |
| 3 | `tasks/imperial_mausoleum.py` | `imperial_mausoleum` | **بها خلل مؤكد (مباشر + موروث)** | `T-02`, `N-15` | — | `_mark_completed_in_memory` تمسح `award` عند فشل الاستلام وتصفّر `free=1` بعد استلام جائزة قديمة؛ و`NOTIFY_PYRAMID (27)` يكتب بالجذر. |
| 4 | `tasks/city_harvest.py` | `city_harvest` | **بها خلل مؤكد (مباشر)** | `T-03` | `V-02` | يصفّر `curres="0"` ولا يحاكي التراكم الزمني (`buildCell.lua`) -> يتوقف نهائياً بعد الدورة الأولى حتى إعادة الاتصال. |
| 5 | `tasks/watermill.py` | `watermill` | **بها خلل مؤكد (مباشر)** | `T-04`, `T-05` | `V-03` | **خصم ثلاثي (-3)** من الحقيبة لكل تعزيز (`NOTIFY_BACKPACK` + حلقة `backpackCtrl`/`bagCtrl`) + إفساد `buffCtrl={}` الفارغ. |
| 6 | `tasks/shield.py` | `shield` | **بها خلل مؤكد (مباشر + موروث)** | `T-06`–`T-08`, `N-17` | `V-04` | **حرج (خطر تصفير القلعة):** لا يجدد الدرع بعد الانتهاء (`NOTIFY_WORLD "2"` غير معالج و`is_shielded` يتجاهل `buffCtrl`) + يفعّل `isSafe=True` عند Timeout + خصم مزدوج للحقيبة والذهب. |
| 7 | `tasks/building.py` | `building` | **بها خلل مؤكد (مباشر)** | `T-09`–`T-13`, `BT-01` | — | خصم موارد مزدوج، خصم تسريعات مزدوج/وهمي (`err=1010`)، انتهاء الطابور طبيعياً يجمّد `state="2"`، تجاهل `iid` الحقيقي، والتسريع الجزئي لا يحدّث `queueCtrl`. |
| 8 | `tasks/research.py` | `research` | **بها خلل مؤكد (مباشر + موروث)** | `T-14`–`T-17`, `N-17` | — | يطمس موارد `NOTIFY_CITY`، يكتب `technologyCtrl[id]` عند البدء قبل الاكتمال، يكتب مدة غير مخفضة مع غياب `NOTIFY_TECHNOLOGY (494)`، ويقرأ حقولاً غير موجودة في `guideQuest`. |
| 9 | `tasks/train.py` | `train` | **بها خلل مؤكد (مباشر + موروث)** | `T-18`–`T-20`, `C-04` | — | **حرج:** يستخرج `resp["data"]` بدل `resp["data"]["retdata"]` في `1005/2` -> يفرض مدة `1800s` ويطمس `_handle_cmd_1005` ويخصم الموارد مرتين؛ يلوّث `queueCtrl["queues"]`؛ يقرأ `buffCtrl` كـ `dict`. |
| 10 | `tasks/daily_train.py` | `daily_train` | **بها خلل مؤكد (موروث من `train.py`)** | `T-18`, `T-19` | — | قراءاته المباشرة لـ `everydayTaskCtrl` سليمة، لكنه يستدعي `TrainTask._train_adaptive` فيرث تجميد الثكنة `1800s` (بدل ~5 دقائق لـ 250 جندي T1) والخصم المزدوج (وقراءة ميتة لـ `questCtrl.point_finish_list`). |
| 11 | `tasks/cure_wounded.py` | `cure_wounded` | **بها خلل مؤكد (مباشر + موروث)** | `T-21`–`T-23`, `C-04`, `M-18` | `V-05` | **حرج:** يعدّل `queueCtrl["queues"]` موضعياً فيحقن `1202` في `local_queues` (يسرق خانة مسيرة!)، يكتب `"startTime"` فيجمّد ترقية المستشفى `206`، خصم مزدوج لـ `woundedArmy`، و`_handle_cmd_1005` يخلط `1005/4` بإلغاء التدريب. |
| 12 | `tasks/arena.py` | `arena` | **بها خلل مؤكد (مباشر + موروث)** | `T-24`, `N-17` | — | `NOTIFY_ARENA (1007)` غير معالج (مثبت حياً باللوق -> يكسر جوائز 6 ساعات وتصفير اليوم) + زيادة مزدوجة لـ `eventInfo["30"]`. |
| 13 | `tasks/hero_trial.py` | `hero_trial` | **بها خلل مؤكد (مباشر + موروث)** | `T-25`–`T-27`, `C-01`, `N-17` | — | **حرج:** يكتب `eventInfo["25"]=1` ويرجع `ok` حتى عند الأخطاء والاستثناءات! `htData` مسقطة، `NOTIFY_HERO_TRIAL (37)` غير معالج، يقرأ `armyCtrl["armys"]` غير الموجود و`exaltedPrivilegeCtrl["privileges"]` الوهمي. |
| 14 | `tasks/flower.py` | `flower` | **بها خلل مؤكد (مباشر)** | `T-28`, `T-29` | — | يكتب لقطة ما قبل الإرسال فوق المفاتيح الثلاثة للزهور في `backpackCtrl` بعد `NOTIFY_BACKPACK` + سباق زيادة مزدوجة على `eventInfo["8"]`. |
| 15 | `tasks/wonder_merchant.py` | `wonder_merchant` | **بها خلل مؤكد (مباشر + موروث)** | `T-30`, `T-31`, `N-08` | — | **حرج (موروث):** `NOTIFY_SHOP (23)` في `live_memory.py` يمسح `storesCtrl` بالكامل بـ `shopCtrl`! ومباشراً: الشراء العاشر يتخطى إحلال `newShopItem` + مرجع `event_info` منفصل. |
| 16 | `tasks/material_synthesis.py` | `material_synthesis` | **بها خلل مؤكد (مباشر)** | `T-32` | — | خصم مزدوج `-4` وإضافة مزدوجة `+1` في `backpackCtrl` (مثبت بالأرقام الحية في `live_cycle_log.txt:249-268`: `#200101` ينحرف من `452` إلى `448`). |
| 17 | `tasks/material_workshop.py` | `material_workshop` | **بها خلل مؤكد (موروث من المحرك)** | `N-07`, `BT-04`, `C-05` | — | كود المهمة نفسه نظيف، لكن `NOTIFY_STUFFWORKSHOP_REFINERY (1002)` يضاعف `list` (`7->14->21`) و`base_task.get_material_workshop_status` يقرأ حقولاً خاطئة من `queueCtrl["1238"]`. |
| 18 | `tasks/forge_equipment.py` | `forge_equipment` | **بها خلل مؤكد (مباشر + موروث)** | `T-33`–`T-36`, `N-12` | — | خصم مزدوج للمواد والصلب، تعديل `backpackCtrl`/`cityCtrl` بلا فحص `err==0` في `_ensure_steel_balance`، كتابة `questCtrl["point_finish_list"]` غير القابل للتصفير (يعطّل اليوم الثاني+)، `fe.isCle=1` مقلوب، و`NOTIFY_EQUIPMENT (29)` معطّل. |
| 19 | `tasks/alliance.py` | `alliance` | **بها خلل مؤكد (مباشر + موروث)** | `T-37`–`T-40`, `N-11`, `N-16` | — | **حرج (خطر صرف 50 ذهب صامتاً):** `2015/3` لا تحدّث `nextFreeDigTime`، و`2015/6` لا تحذف العنصر المستلم من `helpInfo` (تعطّل مساعدة الأعضاء)، و`2015/5` بلا مزامنة، و`NOTIFY 3/95` فاسدان. |
| 20 | `tasks/war_medal.py` | `war_medal` | **بها خلل مؤكد (مباشر + موروث)** | `T-41`, `N-14` | — | يتجاهل `curExchangeNumMap["1"]` في فحص الرصيد المسبق (يفحص 350 ألف بينما السيرفر يخصم 1,050,000 كما ثبت في `live_cycle_log.txt:329-339`)، و`NOTIFY_BADGE_EXCHANGE (41)` لا يصفّر عند اليوم الجديد. |
| 21 | `tasks/pet.py` | `pet` | **بها خلل مؤكد (مباشر + موروث)** | `T-42`, `N-09` | `V-06` | `NOTIFY_PET (65)` موجّه لمتحكم وهمي `godBeastCtrl` بدل `petCtrl` (يعطّل تصفير الإطعام المجاني يومياً)، والسطر `318` يفرض `curFreeFeed=2` عند أي خطأ غير صفري. |
| 22 | `tasks/treasure.py` | `treasure` | **سليمة** | لا يوجد | — | متحكم `treviFountainCtrl` وحقوله سليمة، التحديث المحلي مشروط بـ `err=="0"` ومطابق لـ Lua، لا يوجد تعديل يدوي للموارد أو الذهب، و`NOTIFY_TREVIFOUNTAIN (13)` سليم. |
| 23 | `tasks/stamina.py` | `stamina` | **بها خلل مؤكد (مباشر)** | `T-43`, `T-44` | — | **حرج:** يعدّل الذاكرة عند Timeout (`or not r` / `or not r_buy`) + إضافة مزدوجة للطاقة وخصم مزدوج للحقيبة (يمسح حزماً متبقية!) والذهب (مثبت حياً في `live_cycle_log.txt:917-946`). |
| 24 | `tasks/command_hall.py` | `command_hall` | **بها خلل مؤكد (موروث من المحرك)** | `N-10`, `BT-02`, `BT-11`, `BT-12` | `V-07` | كود المهمة يستدعي دوال `base_task.py` فيرث: الخصم المزدوج للطاقة (`base.health`)، عدّاد `_command_hall_daily_subtasks` غير القابل للتصفير في منتصف الليل، و`NOTIFY_COMMAND_HALL (608)` يدمج بدل أن يستبدل. |
| 25 | `tasks/skills.py` | `skills` | **بها خلل مؤكد (موروث من المحرك)** | `BT-03`, `BT-05`, `BT-06`, `BT-07`, `N-17` | `V-08` | يستدعي `base_task.py` فيرث: إرسال `setID` كـ `int` بدل `str` (`err=6` باللوق الحي)، تدمير مدد `NOTIFY_BUFF` بـ `3600s` وحقن طوابير وهمية، سقوط `exaltedPrivilegeCtrl` و`NOTIFY 500/492`، وإغفال `13032`. |
| 26 | `tasks/daily_quest.py` | `daily_quest` | **بها خلل مؤكد (مباشر + موروث)** | `T-45`, `N-13` | — | كود `everydayTaskCtrl` والـ 33 قاعدة سليم 100%؛ لكن `NOTIFY_QUEST (12)` يلقي التحديثات في جذر `questCtrl` والترقيع اليدوي `_apply_pending_quest_notify_patch` يفقد التحديثات المتعددة ويسقط 6 من 7 أنواع `notifyType`. |
| 27 | `tasks/march_manager.py` (+ 6 وحدات فرعية) | `march_manager` | **بها خلل مؤكد (أولوية قصوى)** | `M-01`–`M-18` | `V-09`–`V-14` | تفصيل كامل لدورة حياة المسيرة وجميع الوحدات الست (`hunt_monsters`, `gather_resources`, `explore_ruins`, `escort_treasure`, `gather_speed_buff`, `resource_help`) في **القسم 2**. |

---

## 2. القسم المخصص والأولوية القصوى: التشخيص الجنائي الكامل لذاكرة المسيرات (`March Memory Lifecycle`)

تم تتبّع دورة حياة المسيرة خطوة بخطوة:
**الدخول (`1000/1` -> `1007/1000`) ⟵ حساب الخانات القصوى (`VIP + Tech`) ⟵ حساب السعة والجنود والأبطال ⟵ البحث بالخريطة والاستثناءات ⟵ الإرسال (`1007/2`) ⟵ سباق ما بعد الإرسال ⟵ تحديث/عودة المسيرة (`NOTIFY 202`) ⟵ تصنيف الطوابير وحساب ETA ⟵ تداخل المهام غير القتالية.**

*(ملاحظة نفي إنذار كاذب: `tasks/march_manager.py:833-876` تقرأ `armyCtrl.totalArmy` دون طرح الجنود المسيرين، وهذا **سليم** لأن `armyCtrl.lua:308-450` يؤكد أن `totalArmy` هي أصلاً الجنود الحرة المتاحة داخل القلعة. كما أن `tasks/march_capacity.py:46-47` تُصحَّح في السطرين `613-614` عند الاستيراد إلى `DEAD=2, CAPTURED=3` مطابقةً لـ `heroDef.lua:57-58`.)*

---

### `M-01` — سباق بدء التشغيل: إطلاق المهام قبل اكتمال مزامنة المسيرات `1007/1000`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`kingdomMapCtrl.lua` + جميع لقطات JSON الخمس)
- **الموقع:** `core/game_client.py:1800-1821, 1894-1898` و`bot_manager.py:759, 1023` و`tasks/march_manager.py` (`can_run`/`run`)
- **الدليل المقارن:**
  - **Python (`core/game_client.py:1800-1821, 1894-1895`):**
    ```python
    # _recv_loop:
    if sess_id == 0 or cmd_s in ('1000', 'onemt_1000'):
        self.controllers_ready.set()  # يُفعَّل فوراً قبل 1007/1000!
    # _init_flow:
    await asyncio.wait_for(self.controllers_ready.wait(), timeout=22.0)
    await asyncio.sleep(random.uniform(0.3, 0.8))
    self.send_nowait("1037", "2", {"switch": True, "sn": 1})
    await asyncio.sleep(random.uniform(0.2, 0.5))
    await self.query("1007", "1000", {}, timeout=8.0)  # متأخر بـ 0.6..2.0ث!
    ```
  - **Lua & JSON:** `game_file/src/app/module/world/kingdomMapCtrl.lua:64, 1675-1712` لا تحمّل أي طوابير مسير من `1000/1` بل تعتمد حصراً على `reqLocalQueueSync()` (`1007/1000`). وفي جميع اللقطات الخمس `docs/*_live_memory.json` مفتاح `local_queues` غائب تماماً بعد `1000/1`.
- **السبب وسيناريو الفشل ونطاق التأثير (`Blast Radius`):** `bot_manager.py:759` يفك الحجز فور `controllers_ready` ويبدأ `execute_tasks()` أثناء نافذة `0.6–2.0s` قبل وصول `ADD_ALL` من `1007/1000` (علاوة على أن `sess_id == 0` قد يطلق `controllers_ready` مبكراً على أي إشعار). ترى المهام `local_queues == []` (`active_marches=0`, `busy_heroes={}`) فترسل مسيرات مكررة (حراسة كنز/أطلال/جمع) أو تتجاوز الخانات القصوى فيرفضها السيرفر. كما أن `core/live_memory.py` لا تضبط `local_queues_synced = True` إذا عادت `1007/1000` بـ `err == 0` ولم يكن للقلعة أي مسيرة نشطة (لا يُرسل السيرفر `NOTIFY 202`).
  - **Blast Radius:** جميع مهام المسيرات (`march_manager`, `hunt_monsters`, `gather_resources`, `explore_ruins`, `escort_treasure`, `resource_help`, `command_hall`).
- **التوصية المبدئية:** إضافة `local_queues_ready: asyncio.Event` يُفعَّل عند انتهاء `1007/1000` (`err == 0`) أو وصول `ADD_ALL`، مع تعيين `local_queues_synced = True` عند نجاح `1007/1000` حتى لو كانت القائمة فارغة، وانتظاره في `bot_manager.py` وحراسة `MarchManagerTask.can_run()`.

---

### `M-02` — فشل `is_memory_ready()` دائماً و`conn.heroes == []` بسبب فحص `heroCtrl` بدل `heroSysCtrl`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`PlayerTopModule.lua` + `loginDataInitCtrl.lua` + جميع اللقطات الخمس)
- **الموقع:** `core/live_memory.py:145-152, 2377-2380` و`core/game_client.py:1589-1600`
- **الدليل المقارن:**
  - **Python (`core/live_memory.py:2377-2380` & `game_client.py:1590`):** تفحص `self.init_data.get("heroCtrl")`.
  - **Lua (`PlayerTopModule.lua:699-700`, `loginDataInitCtrl.lua:27-28`):** `name = "heroCtrl", key = "heroSysCtrl"` -> السيرفر يُرسل `retdata["heroSysCtrl"]` حصراً. وجميع اللقطات الخمس (بما فيها `sample_live_memory.json` غير المفلترة بـ 277 مفتاحاً) تحوي `heroSysCtrl` ولا تحوي `heroCtrl` إطلاقاً.
- **السبب ونطاق التأثير:** `is_memory_ready()` تعيد دائماً `(False, ['heroCtrl'])` -> كل مشغلات CLI للمسيرات تنتظر مهلة 20ث كاملة (`gather_resources.py:576`, `hunt_monsters.py:909`, `explore_ruins.py:811`, `escort_treasure.py:701`, `resource_help.py:1017`, `gather_speed_buff.py:491`)، وبوابة الاحتياط في `game_client.py:1897` لا تعمل أبداً، و`conn.heroes` تُرجع `[]` دائماً.
- **التوصية المبدئية:** استبدال `"heroCtrl"` بـ `"heroSysCtrl"` (مع Fallback لـ `"heroCtrl"`) في `CRITICAL_STARTUP_CONTROLLERS` و`is_memory_ready()` و`conn.heroes`.

---

### `M-03` — `NOTIFY_LOCAL_QUEUE_SYNC (202)` لا يحذف `orgId` عند `ADD`، ويدمج `from.army`/`heroInfo` بدل استبدالها عند `UPDATE`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`kingdomMapCtrl.lua`, `localQueueMgr.lua` + السجل الحي `docs/live_cycle_log.txt`)
- **الموقع:** `core/live_memory.py:567-580, 2074-2104`
- **الدليل المقارن:**
  - **Python (`core/live_memory.py:2074-2099`):**
    ```python
    if msg_type == 1 and isinstance(data, dict):  # ADD
        qid = self._extract_queue_id(data)
        if qid:
            self.local_queues_map[qid] = copy.deepcopy(data)  # لا يحذف data["orgId"]!
    elif msg_type == 3 and isinstance(data, dict):  # UPDATE
        smart_deep_merge(self.local_queues_map[qid], data, in_place=True)  # يدمج from.army/heroInfo!
    ```
  - **Lua (`kingdomMapCtrl.lua:931-937`):**
    ```lua
    if msg.msgType == gQueueSyncMsgType.ADD then
        self.kingdomMapCell:onAddLocalQueue(msg.data, msg.teamId, msg.mapId)
        if msg.data and msg.data.orgId then
            self.kingdomMapCell:onRemoveLocalQueue({id = msg.data.orgId}, msg.teamId, msg.mapId)
        end
    ```
  - **Lua (`game_file/src/app/module/world/localQueue/localQueueMgr.lua:11-18`):** عند `UPDATE` بعد الدمج، يستبدل صراحةً:
    `self.queueMap[id].from.army = queue.from.army` و`from.heroInfo` و`from.armsInfo` و`from.divineBeastInfo` بالكامل!
  - **السجل الحي (`docs/live_cycle_log.txt:1139-1147`, `1219-1227`, `1298-1306`):**
    `L1141: ADD(11307263-3816) | مسيراتي=2` ثم بعدها بأسطر `L1146: REMOVE(11307263-3815 hit) | مسيراتي=1`.
- **السبب ونطاق التأثير:**
  1. **(أ) ازدواج خانة العودة:** عند تحوّل المسيرة من ذهاب إلى عودة، يرسل السيرفر `ADD` للمسيرة الجديدة (`orgId = old_id`) قبل `REMOVE` القديمة؛ عدم حذف `orgId` يضخّم `local_queues` مؤقتاً إلى `2` لمسيرة واحدة (ودائماً إن فُقد `REMOVE`).
  2. **(ب) بقاء جنود/أبطال ميتين بعد القتال:** لأن `from.army` قائمة كائنات `[{id, num}]` (`kingdomQueueObjCell.lua:327`)، فإن `smart_deep_merge` لا يحذف أصناف الجنود أو الأبطال التي اختفت في `UPDATE`.
  3. **(ج) `is_own_march_queue` (`live_memory.py:567-580`):** يُرجع `True` افتراضياً عند تعذر تحديد `owner_uid`، مما قد يصنّف مسيرات الغير ضمن مسيرات القلعة.
  - **Blast Radius:** كل مستهلكي `local_queues` و`get_available_marches_count` و`get_busy_hero_ids_from_queues`.
- **التوصية المبدئية:** عند `msg_type == 1 (ADD)` حذف `str(data.get("orgId") or data.get("orgQueueId"))` من `local_queues_map`؛ وعند `msg_type == 3 (UPDATE)` استبدال `from.army`, `from.heroInfo`, `from.armsInfo`, `from.divineBeastInfo` بالكامل عند وجودها؛ وعدم افتراض `True` عند غياب `owner_uid` إذا احتوت المسيرة `uid` صريحاً.

---

### `M-04` — سباق التزامن بعد إرسال المسيرة (`1007/2`): انطلاق المهمة التالية قبل وصول `NOTIFY 202`/`NOTIFY 15` ومع صفر `NOTIFY_HERO_SYS`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (السجل الحي `docs/live_cycle_log.txt`)
- **الموقع:** `tasks/escort_treasure.py:607-633`, `tasks/explore_ruins.py:704-729`, `tasks/hunt_monsters.py:404-424, 811`, `tasks/march_manager.py:2975-3075`, `tasks/resource_help.py:903-910`
- **الدليل المقارن:**
  - **السجل الحي (`docs/live_cycle_log.txt:1196-1202`):**
    ```
    L1196: 🔄 [beetoo3] مزامنة المسيرات (1007/2) ✅
    L1199: 🔔 [إشعار وارد: NOTIFY_LOCAL_QUEUE_SYNC]
    L1201:    🔄 القيمة المستحدثة: ADD(11307263-3817) | مسيراتي=1
    ```
    يثبت أن رد `1007/2` يصل **قبل** وصول `NOTIFY_LOCAL_QUEUE_SYNC (202)`! وعبر كامل اللوق (1,511 سطراً، 3 مسيرات قتالية بـ 5 أبطال)، وصل **0 إشعار `NOTIFY_HERO_SYS`**.
  - **Python (`tasks/resource_help.py:908`):** `if res_updated or q_updated: break` — يخرج فور وصول `NOTIFY_CITY` قبل وصول `NOTIFY 202`! أما `escort_treasure` و`explore_ruins` فتعودان بـ `0ms` انتظار و`march_manager.run()` يبدأ الأولوية التالية فوراً.
- **السبب ونطاق التأثير:** عند تشغيل أولويات متتابعة (`escort` ثم `hunt` ثم `ruins` ثم `gather`) أو حلقات متكررة داخل `hunt`/`resource_help`، تقرأ الدورة التالية `local_queues` القديمة (0 أبطال مشغولين، خانة شاغرة وهمية) و`armyCtrl.totalArmy` القديمة، فترسل نفس الأبطال/الجنود/الخانة -> رفض السيرفر لـ `1007/2`.
- **التوصية المبدئية:** بعد كل `1007/2` بـ `err == "0"`، انتظار وصول التحديث الفعلي في `local_queues` (وبالنسبة لـ `resource_help` اشتراط `res_updated and q_updated` معاً) بمهلة محددة (مثلاً `2.5s`) قبل الرجوع أو تكرار الحلقة.

---

### `M-05` — `NOTIFY_MAP_SYNC (201)` يدمج أحداث الحذف في `kingdomMapCtrl` فتبقى الأطلال والقلاع والطوابير الشبحية للأبد
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`mapDef.lua`, `kingdomMapCtrl.lua`)
- **الموقع:** `core/live_memory.py:838-846, 2242-2250`
- **الدليل المقارن:**
  - **Lua (`mapDef.lua:500-507`, `kingdomMapCtrl.lua:390-399, 847-903`):** `msgType` يفرّق بين `ADD_MAPOBJ=2`, `REMOVE_MAPOBJ=3`, `UPDATE_MAPOBJ=4`, `ADD_PIECE_QUEUE=11`, `ADD_QUEUE=12`, `REMOVE_QUEUE=13`, `UPDATE_QUEUE=14` ويستدعي `onRemoveMapObj`/`onRemoveMapQueue`.
  - **Python (`core/live_memory.py:838-846`):** يوجّه `200`/`201`/`450` إلى `_handle_notify_generic_controller("kingdomMapCtrl")` الذي يدمج حزم الحذف في جذر `kingdomMapCtrl` ولا يحذف شيئاً!
- **السبب ونطاق التأثير:** `march_manager.py:1650-1750` (`search_ruins`) و`resource_help.py:398-418` تقرآن أطلالاً وقلاعاً وطوابير خريطة منتهية -> إهدار استعلامات `1006/15` على أطلال مختفية وتعليم إحداثيات فارغة كمشغولة.
- **التوصية المبدئية:** إنشاء معالج مخصص `_handle_notify_map_sync` يدير الإضافة/التحديث/الحذف حسب `msgType` وتنظيف القطع القديمة عند مسح `1006/1000` جديد.

---

### `M-06` — `get_max_marches_capacity()` تمنح قلاع `VIP 4–7` خانة مسيرة شبحية (+1) وتُقيّد `VIP 26–27` عند 6 (خطر حظر!)
- **الخطورة واليقين:** `CRITICAL` (خطر إرسال مسيرات زائدة عن الحد المسموح!) | **مؤكد 100%** (`buildLogic.lua`, `vipbuff.lua`)
- **الموقع:** `tasks/base_task.py:3410-3418`
- **الدليل المقارن:**
  - **Python (`tasks/base_task.py:3410-3418`):**
    ```python
    if self.is_vip_active:
        vip_lv = self.vip_level
        if vip_lv >= 10: capacity += 2
        elif vip_lv >= 4: capacity += 1
    capacity = min(6, max(1, capacity))
    ```
  - **Lua (`game_file/src/app/localtb/config_server/vipbuff.lua:20-574, 1745-1816` & `buildLogic.lua:1953-1973`):** قيمة `troop = {7206, 2, value}` الرسمية هي:
    - **VIP 1–7 (`L20–436`):** **`0`** (لا توجد زيادة!)
    - **VIP 8–9 (`L503–574`):** **`+1`**
    - **VIP 10–25 (`L641–1678`):** **`+2`**
    - **VIP 26 (`L1745–1747`):** **`+3`** | **VIP 27 (`L1814–1816`):** **`+4`**
- **السبب ونطاق التأثير:** أي قلعة ذات VIP نشط بمستوى `4..7` تحسب `max_marches + 1`؛ وعند امتلاء خاناتها الحقيقية تظل `available_marches == 1` فتكرر مهام المسيرات مسح الخريطة (`2083/1`, `2083/2`, `1006/1000`) وضرب `1007/2` المرفوضة من السيرفر كل دورة (سلوك مشبوه يعرض للحظر).
  - **Blast Radius:** جميع الوحدات الـ 9 للمسيرات وقاعة القيادة.
- **التوصية المبدئية:** تعديل العتبات لتطابق `vipbuff.lua` (`>=27:+4, >=26:+3, >=10:+2, >=8:+1, else 0`) أو قراءة بافات `MARCH_TROOP_TOTAL_BOOST` مباشرة من `buffCtrl`، وإزالة السقف الثابت `min(6, ...)`.

---

### `M-07` — `HuntMonstersTask.get_lord_energy()` تقسم `base.health` على `100` (تعطيل كامل للصيد دون 1,000 طاقة!) + `TypeError` مبتلع في `get_max_can_kill_monster_level`
- **الخطورة واليقين:** `CRITICAL` + `HIGH` | **مؤكد 100%** (جميع لقطات JSON الخمس + `live_cycle_log.txt` + `lordInfoCtrl.lua`)
- **الموقع:** `tasks/hunt_monsters.py:130-139` و`tasks/hunt_monsters.py:567-574` (مع `tasks/march_manager.py:1351`)
- **الدليل المقارن:**
  - **Python (`hunt_monsters.py:139`):** `return self._safe_int(base.get("health"), 0) // 100` (مقارنةً بـ `MIN_LORD_ENERGY = 10`).
  - **JSON & Log & Lua:** `docs/sample_live_memory.json` يحوي `base.health = 100` (طاقة طبيعية كاملة 100/100)، و`docs/live_cycle_log.txt:922-1114` يثبت أن `health` بوحدات طاقة 1:1 (وليس ×100)، ومطابق لـ `lordInfoCtrl.lua:363, 380-386`.
  - **Python (`hunt_monsters.py:568`):** يستدعي `self.get_max_can_kill_monster_level(monster_type)` بينما `march_manager.py:1351` يأخذ **0 معاملات** -> `TypeError` مبتلع يُرجع `0` فيجبر الصيد التلقائي على البدء من Lv.40 دوماً (`TARGET_LEVEL_LOCKED`).
- **السبب ونطاق التأثير:** أي حساب طبيعي يملك `10..999` طاقة يحسب `100 // 100 = 1 < 10` فيرفض `hunt_monsters` و`daily_hunt` العمل نهائياً! ولم ينكشف ذلك في حسابات الاختبار إلا لأنها تخزّن >10,000 طاقة.
- **التوصية المبدئية:** إزالة `// 100` في `hunt_monsters.py:139` (أو استخدام `self.stamina`)، وتصحيح استدعاء `get_max_can_kill_monster_level()` في السطر `568`.

---

### `M-08` — `get_available_heroes()` تقرأ `q_item["heroInfo"]` بالجذر بدل `q_item["from"]["heroInfo"]` + `get_heroes_march_capacity()` تتجاهل `defendList` + خلط `quality` بـ `rarity`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`kingdomQueueObjCell.lua`, `heroCtrl.lua`, `heroltCtrl.lua` + 4 لقطات JSON)
- **الموقع:** `tasks/base_task.py:8551-8565` (المسير)، `tasks/base_task.py:7932-7995` (`defendList`)، `tasks/base_task.py:6996-7008, 8666-8668` (`rarity` vs `quality`)
- **الدليل المقارن:**
  - **Lua (`kingdomQueueObjCell.lua:294-299`):** الأبطال المسيرون داخل `q_item["from"]["heroInfo"]` وليس بالجذر -> `active_queue_heroes` في `base_task.py:8552` تبقى فارغة دائماً! وبما أن السيرفر لا يرسل `NOTIFY_HERO_SYS` عند إرسال المسيرة (`M-04`)، تعيد `get_available_heroes()` أبطالاً يقاتلون فعلياً خارج القلعة!
  - **JSON & Lua (`heroCtrl.lua:899-906`):** في 4 لقطات حقيقية (`beetoo1`, `beetoo3`, `lucifer`, `sample`) حماة السور في `defendList` يحملون `state == 1 (NORMAL)` وليس `5 (DEFEND)`. `get_heroes_march_capacity` لا تفحص `defendList`، فتحتسب حماة السور ضمن سعة الهجوم حتى عند `include_defend=False`.
  - **Lua (`heroltCtrl.lua:709-710`) & `beetoo3_live_memory.json`:** جدول `rare_levels` يُفهرس بالندرة المتأصلة `rarity` وليس `quality`. خلطهما في `get_best_march_heroes` و`get_available_heroes` يُنتج أخطاء فعلية (البطل `1718` بـ `rarity=2, quality=5` يُقيَّم `+7500` بدل `+6000`، والبطل `1713` بـ `rarity=4, quality=2` يُقيَّم `+6000` بدل `+7000` فيعكس ترتيب الاختيار).
- **التوصية المبدئية:** قراءة `from.heroInfo` مع استبعاد `status == 3` في `get_available_heroes`؛ فحص `defendList` في `get_heroes_march_capacity`؛ والفهرسة بـ `rarity` حصراً في الدالتين.

---

### `M-09` — سوء تصنيف مسيرات العودة (`queueType=10, moveLineType=8`) وتضارب أنواع السيرفر/العميل واعتبار `status == 3 (Finished)` نشطاً
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`mapDef.lua`, `kingdomQueueObjCell.lua`)
- **الموقع:** `tasks/march_manager.py:503-522`, `tasks/hunt_monsters.py:148-161`, `tasks/resource_help.py:238-246`, `tasks/base_task.py:3321, 3489, 3544, 3566, 3615, 3649`
- **الدليل المقارن:**
  - **Lua (`mapDef.lua:322-397, 427-430, 576-577` & `kingdomQueueObjCell.lua:47-49`):**
    - مسيرة العودة تحمل **`queueType = 10` و`moveLineType = 8`** مع الأصل في `from`.
    - `status == 3` هي `moveLineStatusTypeFinished` (منتهية)، وليست "عودة"!
    - `queueType == 11` في السيرفر هي `AttackCamp` وليست Escort (`22`)؛ و`queueType == 4` هي `CollResource` وليست Ruins (`5`)؛ و`moveLineType == 1` مشتركة لكل الهجمات (`PvP/Boss/Camp/Monster`).
- **السبب ونطاق التأثير:**
  - مسيرات الوحوش العائدة لا تُكتشف في `has_active_monster_march()` ولا `_count_active_monster_marches()` -> `evaluate_march_block_signal` تُنهي بدلاً من الانتظار، و`daily_hunt` تتجاوز الحد.
  - قوافل دعم الموارد العائدة لا تُكتشف في `_get_active_resource_help_queues()` -> إجهاض مبكر.
  - مسيرات الأطلال العائدة لا تُكتشف في `has_relics_explore_march()` -> محاولات أطلال مكررة.
  - مسيرة `AttackCamp (11)` تُصنَّف كـ Escort في `base_task.py:3649` فتمنع حراسة الكنز؛ وأي مسيرة `status=3` تمنع الجمع/الأطلال/الحراسة.
- **التوصية المبدئية:** الفصل الصارم بين `queueType` (سيرفر) و`moveLineType` (عميل)؛ فحص `from.mapType`/`from.id`/`orgQueueType`/`matrixType` عند `queueType == 10`؛ وحذف `3` من `active_statuses` في جميع دوال `base_task.py`.

---

### `M-10` — `GatherSpeedBuffTask` يخصم العنصر مرتين من `backpackCtrl` بعد `1004/2`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`core/live_memory.py:1760-1773` + `docs/live_cycle_log.txt:930-934`)
- **الموقع:** `tasks/gather_speed_buff.py:402-413`
- **الدليل المقارن:** `NOTIFY_BACKPACK` يخصم `-1` قبل رجوع `1004/2` (`live_cycle_log.txt:930-934`)، ثم `self._decrement_item_in_live_memory(item_id)` يخصم `-1` ثانياً (ويحذف المفتاح إذا بقي 1).
- **السبب ونطاق التأثير:** نفاد وهمي مبكر لعناصر سرعة الجمع وتخطي التفعيل في الدورات اللاحقة.
- **التوصية المبدئية:** إزالة `_decrement_item_in_live_memory` عند نجاح `1004/2` والاعتماد على `NOTIFY_BACKPACK` (أو التحقق من تغيّر الرصيد قبل/بعد الطلب).

---

### `M-11` — `EscortTreasureTask._is_escort_activity_open()` يقرأ مفاتيح غير موجودة في `activityShowCtrl` فيرجع `True` دائماً
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`activityDef.lua:10-13`, `activityShowCtrl.lua:103-105, 1920-1953` + جميع اللقطات الخمس)
- **الموقع:** `tasks/escort_treasure.py:217-226`
- **الدليل المقارن:**
  - **Python:** يقرأ `endTime`/`end_time`/`startTime`/`start_time`/`isOpen`/`open`.
  - **JSON (`docs/*_live_memory.json`):** `"activityShowCtrl": {"9001017": {"state": 3, "endtime": 4102433940, "begintime": 1559977800, "opencount": 4}}` (`OPEN = 3`, والحقول بأحرف صغيرة `begintime`/`endtime`).
- **السبب ونطاق التأثير:** حتى لو كانت الفعالية مغلقة (`state in {1, 2, 4}`) أو انتهى وقتها، ترجع الدالة `True` وترسل استعلامات `1078/2` و`1075/1` بلا داعٍ كل دورة.
- **التوصية المبدئية:** فحص `found_entry.get("state") == 3` أولاً وقراءة `endtime`/`begintime` بأحرف صغيرة.

---

### `M-12` — `_is_coord_targeted_by_any_march()` يتجاهل إزاحة السيرفر `+1` (`gPointClientPointPlus`)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`mapDef.lua:568`, `kingdomQueueObjCell.lua:474-477`)
- **الموقع:** `tasks/march_manager.py:1075-1079` (وكذلك `443-444`)
- **الدليل المقارن:** `local_queues`/`other_local_queues` تخزّن إحداثيات السيرفر الخام `(tx+1, ty+1)` (`core/live_memory.py:2077`)، بينما `search_best_monster` (`L1544`) و`search_ruins` (`L1763`) تمرران إحداثيات العميل `(tx, ty)`. المقارنة `qx == tx and qy == ty` لا تتطابق أبداً!
- **السبب ونطاق التأثير:** إرسال مسيرات مكررة إلى نفس الوحش أو نفس الأطلال المستهدفة بالفعل.
- **التوصية المبدئية:** تطبيع إحداثيات الطوابير بطرح `1` أو مطابقة `{(tx, ty), (tx+1, ty+1)}` كما في `march_manager.py:2509`.

---

### `M-13` — تضارب صيغة `target_id` يُعطّل فلتر المسافة في `ExcludeManager` ويُسرّب حجوزات الموارد لمدة 120ث
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (تضارب صريح بين 3 ملفات)
- **الموقع:** `tasks/march_manager.py:1216, 1537`، `tasks/exclude_manager.py:157-176, 190-204`، `tasks/gather_resources.py:199`
- **الدليل المقارن:** `march_manager` يولّد `"wood_393_425"` و`"monster_393_425"` (فاصل `_`)، بينما `exclude_manager._parse_coords()` و`_infer_target_type()` يقسّمان حصراً على `"-"` -> يُرجعان `(None, None)` و`"unknown"`. كما أن `gather_resources.py:199` يستدعي `release_target(target["target_id"], kingdom_id=...)` دون تمرير `target_type=res_key`؛ و`crystal` (`subType=6`) مفقود من جداول الأنواع.
- **السبب ونطاق التأثير:** كل `confirm()` يخزّن `x=NULL, y=NULL` في SQLite فيتجاوز فلتر `max_distance` ويستهلك حصة `MAX_QUERY_EXCLUDES=60` بأهداف بعيدة؛ وفشل التشكيل في `gather_resources.py:199` يبحث عن الحجز في حوض `"{kid}:unknown"` بدل `"{kid}:wood"` فيتسرّب الحجز 120ث ويمنع القلاع الشقيقة من جمع النقطة.
- **التوصية المبدئية:** دعم كلا الصيغتين `X-Y-mapType-subType-serial` و`{type}_{x}_{y}` في `exclude_manager.py`، إضافة `crystal (6)`، وتمرير `target_type=res_key` في `gather_resources.py:199`.

---

### `M-14` — `march_capacity.py` يترك `now=None` وكل مستدعيه لا يمررون `now` (تضخيم السعة ببافات منتهية -> رفض `1007/2`)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`buff.lua`, `buffSourceList.lua:52-60`, `dressUnit.lua:43`)
- **الموقع:** `tasks/march_capacity.py:402, 424, 551-595, 806, 914` + المستدعون (`march_manager.py:1982, 2284, 2292`, `gather_resources.py:105`, `explore_ruins.py:147, 156`, `escort_treasure.py:315, 323`)
- **الدليل المقارن:** `march_capacity.py:424` لا يستبعد البافات المنتهية (`5010` +25%, `5044` +35%, `5055/5056` +50%) إلا عند تمرير `now`، وجميع مستدعي الإنتاج لا يمررونه؛ كما يتجاهل `_calc_castle_dress_attr` و`_calc_equipment_flat` صلاحية `stopTime`/`endTime`.
- **السبب ونطاق التأثير:** بعد انتهاء باف توسعة المسيرة دون إشعار `buffFinish`، يبقى +25%..+50% محسوباً في السعة -> يبني البوت تشكيلاً أكبر من المسموح -> رفض السيرفر لـ `1007/2`.
- **التوصية المبدئية:** تمرير `now=int(time.time())` افتراضياً في جميع دوال التشغيل الحية وتصفية `stopTime`/`endTime` المنتهية.

---

### `M-15` — `_get_active_soldier_load_multiplier()` و`_get_active_gather_speed_multiplier()` تقرآن `buffCtrl` كـ `dict` بمفاتيح غير موجودة (ترجعان `1.0` دائماً)
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (جميع اللقطات الحية + `core/live_memory.py:1911` + `buff.lua`)
- **الموقع:** `tasks/march_manager.py:1870-1889, 2438-2457`
- **الدليل المقارن:** يفحصان `if isinstance(buff_ctrl, dict)` ومفاتيح `effect`/`buffType`/`endTime`/`value` غير الموجودة، بينما `buffCtrl` الحقيقي `list` من `{"id", "beginTime", "time", "itemId"}`.
- **السبب ونطاق التأثير:** تتجاهل تشكيلات الجمع بافات الحمولة (`5419`)، ويتجاهل تقدير زمن الجمع بافات سرعة الجمع (`5008/5009/5048/4507`).
- **التوصية المبدئية:** قراءة `buffCtrl` كـ `list` باستخدام خرائط `buffID` من `buff.lua` (على غرار `gather_speed_buff.py` و`march_capacity.py`).

---

### `M-16` — قارئات زمن المسيرة وETA تقرأ `finishTime`/`endTime`/`moveTime` بدل `statusStartTime`/`statusEndTime`/`moveTimeSpan`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`kingdomQueueObjCell.lua:71-90, 154-162`, `mapDef.lua:583-596`)
- **الموقع:** `tasks/march_manager.py:429-431, 2487-2492` و`tasks/resource_help.py:256-259`
- **الدليل المقارن:** حقول السيرفر الحقيقية في طوابير الخريطة هي `statusStartTime`, `statusEndTime`, `moveTimeSpan` (`[{time=...}]`).
- **السبب ونطاق التأثير:** `get_active_marches_eta()` يُرجع `0.0` دائماً، و`_get_earliest_resource_help_return_sec()` يسقط دوماً لـ `15.0s`، و`estimate_march_duration()` يتجاهل مدة السيرفر الفعلية.
- **التوصية المبدئية:** قراءة `statusEndTime` و`statusStartTime` ومجموع `moveTimeSpan` أولاً.

---

### `M-17` — `ExploreRuinsTask` يرسل `armsInfo`/`divineBeastInfo` من التشكيلة المحفوظة دون فحص توفرها داخل القلعة (و`divineBeastCtrl` مسقط بالفلتر)
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`WorldDispatchArmyViewPanel.lua:183-195, 1385-1391` + `sample_live_memory.json` + `core/live_memory.py:55-142`)
- **الموقع:** `tasks/explore_ruins.py:688-689, 733` و`core/live_memory.py:55-142`
- **الدليل المقارن:** السورس الرسمي يصفّي الأسلحة الإلهية بـ `marchCount < 1` والوحوش الإلهية بـ `divineBeastCtrl:getIsInCity(v)`.
- **السبب ونطاق التأثير:** إذا كان السلاح الإلهي أو الوحش في مسيرة أخرى، يرفض السيرفر `1007/2` فتقوم `explore_ruins.py:733` بحظر إحداثي أطلال سليم وتعيد المحاولة 3 مرات بنفس الأداة المشغولة.
- **التوصية المبدئية:** إضافة `divineBeastCtrl` إلى `ALLOWED_CONTROLLERS` وتصفية `armsInfo`/`divineBeastInfo` المشغولة في `local_queues` قبل الإرسال.

---

### `M-18` — تداخل حرج من خارج مهام المسيرات: `cure_wounded.py` يحقن طابور المستشفى `1202` موضعياً داخل `init_data["local_queues"]` (سرقة خانة مسيرة!)
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`core/live_memory.py:713-716, 2135-2139` + `tasks/cure_wounded.py:186-205`)
- **الموقع:** `tasks/cure_wounded.py:186-205` + `core/live_memory.py:715-716, 2138-2139` (+ `tasks/train.py:294-299`)
- **الدليل المقارن:** `live_memory.py` يضع مرجع `own_q` نفسه في `init_data["local_queues"]` و`queueCtrl["queues"]`. وعند بدء علاج المصابين، ينفّذ `cure_wounded.py:188-205` تعديلاً موضعياً (`queues[:] = ...; queues.append({"qtype": 1202, ...})`)، مما يحقن كائن المستشفى مباشرة داخل `init_data["local_queues"]`!
- **السبب ونطاق التأثير:** كل مهمة مسيرات تقرأ `local_queues` تخسر خانة مسيرة كاملة حتى وصول إشعار `NOTIFY 202` جديد؛ كما أن `queueCtrl["queues"]` نفسها تلوّث هيكل `queueCtrl` الحقيقي (`{qtype_str: dict}`).
- **التوصية المبدئية:** إزالة `queueCtrl["queues"] = own_q` من `live_memory.py` وإزالة لمس `queueCtrl["queues"]` نهائياً من `cure_wounded.py` و`train.py` (التخزين في `queueCtrl["1202"]` و`queueCtrl["1203".."1207"]` فقط).

---

## 3. الأعطال المؤكدة في الطبقة الأساسية ومعالجات الإشعارات (`core/` و `bot_manager.py`)

### 3.1 أخطاء الإدخال والقائمة البيضاء وأوامر النطاق (`C-01` – `C-08`)

#### `C-01` — `ALLOWED_CONTROLLERS` تُسقط 5 متحكمات رسمية حقيقية من `CMD 1000/1` (+ متحكمين يُقرآن في المهام)
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`PlayerTopModule.lua` + `sample_live_memory.json` vs `beetoo1..3`/`lucifer` + `docs/live_cycle_log.txt:898`)
- **الموقع:** `core/live_memory.py:55-142`
- **الدليل المقارن:**
  - موجودة فعلياً في `CMD 1000/1` (`sample_live_memory.json` + `PlayerTopModule.lua`) ومسقطة في `ALLOWED_CONTROLLERS`:
    1. `divineBeastCtrl` (`PlayerTopModule.lua:1004`, يقرؤه `base_task.py:8137`, `explore_ruins.py`)
    2. `divineBeastMarkCtrl` (`PlayerTopModule.lua:1005`, يقرؤه `base_task.py:8194`)
    3. `godArmsRuneCtrl` (`PlayerTopModule.lua:744`, يقرؤه `base_task.py:8063`)
    4. `miraculousWeaponCtrl` (`PlayerTopModule.lua:743`, يقرؤه `base_task.py:7692`)
    5. `htData` (`PlayerTopModule.lua:512-513`: `name="heroTrialCtrl", key="htData"`, يقرؤه `hero_trial.py:93` — مثبت حياً في `docs/live_cycle_log.txt:898`: `htData missing from live memory. Requesting init sync (CMD 1059 / REQ 10)...` مما يفرض طلباً شبكياً كل جلسة!)
  - ومتحكمان يُحمّلان بـ RPC/NOTIFY ويجب السماح لهما: `exaltedPrivilegeCtrl` (`base_task.py:1992`, `hero_trial.py:145`)، `heroComboSkillCtrl` (`base_task.py:2971, 3063`).
  - *(بالمقابل، `godBeastCtrl`, `heroCtrl`, `vipCtrl` موجودة في `ALLOWED_CONTROLLERS` لكنها غير موجودة في السيرفر إطلاقاً.)*
- **نطاق التأثير:** جميع بونصات سعة المسيرة من الأسلحة المعجزية/رونز الأسلحة/الوحوش الإلهية تُرجع `0` دائماً؛ استعلام شبكي قسري في `hero_trial`؛ فشل قراءة الامتيازات ومهارات الحشد.
- **التوصية المبدئية:** إضافة المتحكمات السبعة المفقودة إلى `ALLOWED_CONTROLLERS`.

#### `C-02` — `is_memory_ready()` و`conn.heroes` تفحصان `heroCtrl` غير الموجود *(مفصّل في `M-02`)*
- **الموقع:** `core/live_memory.py:145-152, 2377-2380` و`core/game_client.py:1589-1600`.

#### `C-03` — `FALLBACK_QUERIES["lordInfoCtrl"]` يستخدم `1002/7` (عرض ملف لاعب آخر) بدل `1002/1` (`REQ_INIT_LORDDATA`)
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`cmdDef.lua:25-32`)
- **الموقع:** `core/live_memory.py:157` (`"lordInfoCtrl": (1002, 7, {"uid": 0})`)
- **الدليل المقارن:** `cmdDef.lua:26` -> `REQ_INIT_LORDDATA = "1"`، بينما `cmdDef.lua:32` -> `REQ_LORD_INFO_UID = "7"` (مخصص لاستعراض ملف لورد آخر!).
- **التوصية المبدئية:** تصحيحها إلى `(1002, 1, {})`.

#### `C-04` — `_handle_cmd_1005` لا يفحص `err == 0`، ويفسد `armyCtrl["trainArmy"]`، ويخلط `1005/4` (العلاج) بإلغاء التدريب!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`cmdDef.lua:84-88`, `armyCtrl.lua:703-713, 894-918, 954-982` + `beetoo1/beetoo2_live_memory.json`)
- **الموقع:** `core/live_memory.py:924-928, 1147-1200`
- **الدليل المقارن:**
  - **Lua (`cmdDef.lua:87`, `armyCtrl.lua:703-713, 894-918`):** `1005/4` هي `REQ_CURE_WOUNDED_ARMY` وليست إلغاء تدريب! و`armyCtrl["trainArmy"]` يحفظ **فقط الجنود المكتملين الجاهزين للاستلام** `{bid: {armyid: count}}`، بينما التدريب الجاري مكانه `queueCtrl["1203".."1206"]`.
  - **Python (`live_memory.py:1147-1190`):** (1) لا يتحقق من `err == 0`؛ (2) عند `1005/2` لا يضيف الطابور إلى `queueCtrl` بل يحقن كائناً مصطنعاً داخل `armyCtrl["trainArmy"][bid]` ويعيد فرضه فوق رد السيرفر `trainArmy = {}` (`L1158-1162`)؛ (3) عند `1005/4` (علاج!) يدخل فرع `"4" in ("4", "5")` فيمسح `trainArmy` ثم يدخل `"lefttime" in ret_q` (لغياب شرط `sub_s == "2"`) ويحقن `armyCtrl["trainArmy"]["unknown"]`!
- **نطاق التأثير:** `train.py`, `daily_train.py`, `cure_wounded.py`, `building.py`.
- **التوصية المبدئية:** التحقق من `err in ("0", "Err_None")` أولاً؛ فصل `sub_s == "2"` (الكتابة في `queueCtrl[queuetype]` لا في `trainArmy`) عن `sub_s == "4"` (الكتابة في `queueCtrl["1202"]`) وعن `sub_s == "5"` (استلام المدربين وتصفية `trainArmy[bid]`).

#### `C-05` — `_handle_cmd_2021` و`extract_controllers` لا يتحققان من `err == 0`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`core/live_memory.py:930-971, 1201-1212`, `stuffWorkshopCtrl.lua:120-124`)
- **الموقع:** `core/live_memory.py:930-947, 1201-1212`
- **السبب ونطاق التأثير:** أي استجابة خطأ (`err != 0`) تحمل `result` (لـ `2021`) أو مفاتيح مطابقة لـ `ALLOWED_CONTROLLERS` تُدمج في `init_data` بلا تحقق.
- **التوصية المبدئية:** اشتراط عدم وجود خطأ غير صفري (`err in (None, 0, "0", "Err_None")`) قبل تنفيذ `_handle_cmd_2021` و`extract_controllers` لحزم RPC.

#### `C-06` — حقن `queueCtrl["queues"] = own_q` يلوّث `queueCtrl` ويشارك مرجع `local_queues` *(مفصّل في `M-18`)*
- **الموقع:** `core/live_memory.py:713-716, 2135-2139`.

#### `C-07` — `controllers_ready.set()` يُطلق على أي `sess_id == 0` قبل `1000/1` وقبل `1007/1000` *(مفصّل في `M-01`)*
- **الموقع:** `core/game_client.py:1800-1822, 1894-1898`.

#### `C-08` — `bot_manager.sync_live_data_to_db()` تقرأ `allianceCtrl["allianceName"]` غير الموجود (تحفظ `""` دائماً) وتتأثر بجمود `fcInfo.totalFc`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (جميع لقطات JSON الخمس)
- **الموقع:** `bot_manager.py:843, 852-853`
- **الدليل المقارن:**
  - **Python:** `alliance_name = alliance.get("allianceName") or base.get("alliancename") or ""`
  - **جميع اللقطات الخمس (`beetoo1..3`, `lucifer`, `sample`):** كلٌّ من `allianceCtrl.get("allianceName")` و`lordInfoCtrl.base.get("alliancename")` قيمتهما `None`! المسار الفعلي لاسم التحالف هو `allianceCtrl["allianceInfo"]["property"]["name"]` (مثل `'جوMARارح'`, `'شوش'`, `'الـتـدخـل الـسـريــع'`). كما أن السطر `843` يقرأ `fc.get("totalFc")` الذي يتجمّد بعد أول `NOTIFY_LORD` بسبب عطل `N-03` (`fcInfo.fcInfo`).
- **التوصية المبدئية:** قراءة `alliance.get("allianceInfo", {}).get("property", {}).get("name")` في `bot_manager.py:853` وإصلاح `N-03` في `live_memory.py`.

---

### 3.2 مصفوفة التدقيق الشامل لجميع معالجات `NOTIFY` في `core/live_memory.py`

#### جدول الحالة الكاملة لمعالجات `NOTIFY` المسجلة في `_NOTIFY_ROUTE_TABLE` (`core/live_memory.py:733-853`)

| ID (`cmdDef.lua`) | الإشعار | المعالج الحالي | الحالة | رقم العطل / ملاحظة |
|---|---|---|---|---|
| `1` | `NOTIFY_BACKPACK_UPDATE` | `_handle_notify_backpack` | **سليم عموماً** | يطابق `add`/`use` في `backpackCtrl.lua:393-483` (ملاحظة: يأخذ `notify_data[0]` إذا كانت قائمة متعددة، ويخزّن `count` كنص `str`). |
| `3` | `NOTIFY_ALLIANCE_UPDATE` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-11` — يلقي `eventName`/`digInfo` في جذر `allianceCtrl` بدل توجيه 35+ حدثاً (`allianceNotifyHandle.lua`). |
| `7` | `NOTIFY_BUFF_UPDATE` | `_handle_notify_buff` | **خلل جزئي مؤكد** | `N-06` — البنية الأساسية وهوية `(id, bid, iid)` سليمة، لكن ينقصه `closeBuff("5130") -> CDData["13032"]` وتصفير `kingdomMapCtrl["isSafe"]` عند إغلاق `"5003"`. |
| `8` | `NOTIFY_LORD_UPDATE` | `_handle_notify_lord` | **خلل حرج مؤكد** | `N-03` — ينشئ `fcInfo.fcInfo` المزدوج (49 مرة باللوق!) ويكتب `closeVIP`/`activate`/`physical`/`signature`/`updateOfficial` في مفاتيح جذر وهمية. |
| `9` | `NOTIFY_CITY_UPDATE` | `_handle_notify_city` | **خلل متوسط مؤكد** | `N-05` — منطق `v.res` سليم؛ ينقصه `updateBuildInfo`, `demolishInfo`, `mastery`, `drawingData`, `buildStatue`, وضبط `starttime` لـ `openChargeQueue`. |
| `11` | `NOTIFY_WALLS_UPDATE` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-13B` — الحمولة داخل `notifyData.notifyData` (ليس `data`) فتُلقى بالجذر ولا تحدّث `defence`/`isBurning`/`status`. |
| `12` | `NOTIFY_QUEST_UPDATE` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-13` — يلقي `questID`/`progress` في الجذر، يفقد التحديثات المتعددة، ويسقط 6 من 7 أنواع `notifyType`. |
| `13` | `NOTIFY_TREVIFOUNTAIN_UPDATE` | `_handle_notify_generic_controller` | **سليم** | يطابق `treviFountainCtrl.lua:29-34` (يحدّث `multipleTimes`). |
| `14` (`1051` وهمي) | `NOTIFY_QUEUE_UPDATE` | `_handle_notify_queue` | **خلل حرج مؤكد** | `N-01` — معطّل كلياً على حزم السيرفر الحقيقية (لا يقرأ `dispatchQueueEvent.name`، يعكس شرط الحذف، ولا يدعم `merge`). |
| `15` | `NOTIFY_ARMY_UPDATE` | `_handle_notify_army` | **خلل مؤكد** | `N-02` — يستبدل 4 مفاتيح فقط ويدمج الباقي، فيترك `fightingArmy`/`exceptionArmy` عالقة عند عودتها `{}`. |
| `16` / `20` | `NOTIFY_TIME_REWARD` / `RESET` | `_handle_notify_time_reward` | **خلل حرج مؤكد** | `N-04` — يكتب في الجذر بدل `timeRewardCtrl["data"]`، يعكس أسماء السلاسل النصية، ولا يصفّر `time` ولا يقرأ `reward`. |
| `23` | `NOTIFY_SHOP` | `_handle_notify_generic_controller` | **خلل حرج مؤكد** | `N-08` — يمسح `storesCtrl` (التاجر العجيب) بالكامل بتعيينه مساوياً لـ `shopCtrl` الفارغ! |
| `27` | `NOTIFY_PYRAMID` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-15` — يدمج في جذر `pyramidCtrl` بدل استبدال `pyramidCtrl["data"]` (يعطّل اليوم الثاني+ ويُبقي `award` القديم). |
| `29` | `NOTIFY_EQUIPMENT` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-12` — لا يعالج أحداث `add`/`delete`/`cle`/`rfr` ولا يزيل طابور `1229`؛ و`DEFAULT_KEY_MAPS` يفهرس `equipment_array` بـ `eid` بدل `epid`! |
| `41` | `NOTIFY_BADGE_EXCHANGE` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-14` — `smart_deep_merge` لا يصفّر `curExchangeNumMap` عندما يرسل السيرفر `{}` عند إعادة التعيين اليومي (`badgeExchangeCtrl.lua:43-44`). |
| `49` / `50` | `NOTIFY_ESCORT` / `ESCORT_CART` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-16B` — `escortCartCtrl.rewardMap` قائمة قوائم (`[[...]]`) فتتضاعف عند الدمج بدل الاستبدال (`escortCartCtrl.lua:102`)؛ و`escortCtrl` يلوّث الجذر بـ `type`. |
| `55` | `NOTIFY_EVERYDAY_TASK` | `_handle_notify_everyday_task` | **سليم** | يستبدل `eventInfo`/`normalRecord`/`chestRecord`/`chestReward` ويصفّر عند `isNewDay` مطابقاً لـ `everydayTaskCtrl.lua:91-119`. *(تفصيلة صغيرة: `chestRecord` غائبة من tuple تحويل `[] -> {}` في L2197.)* |
| `59` (ناقص `464`) | `NOTIFY_SALESROOM` / `NEW_SALESROOM` | `_handle_notify_generic_controller` | **خلل متوسط مؤكد** | الرقم `"464"` (`NOTIFY_NEW_SALESROOM`, `cmdDef.lua:511`) مفقود من جدول التوجيه، و`salesRoomData`/`itemsInfo` تتطلب استبدالاً (`salesRoomAgCtrl.lua:65, 103`). |
| `64` / `1009` | `ALLIANCE_RELATION` / `RECOMMEND` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-11` — يدمج `data` في جذر `allianceCtrl` بدل `relationMap[aid]` (ولا يحذف عند `DEL_RELATION`) ويخاطر بطمس بيانات التحالف عند `RECOMMEND`. |
| `65` | `NOTIFY_PET` | `_handle_notify_generic_controller` | **خلل حرج مؤكد** | `N-09` — موجّه إلى متحكم وهمي غير موجود `godBeastCtrl` بدل `petCtrl`! |
| `95` | `NOTIFY_ALLIANCE_TREASURE` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-16` — يدمج بدل الاستبدال (`allianceTreasureCtrl.lua:275-297`) فتبقي صناديق قديمة ومفاتيح `notifyType: AUTO_REFRESH` (مرصودة في `beetoo1`). |
| `104` (وهمي) | `NOTIFY_HERO` | `_handle_notify_hero` | **مسار ميت** | الرقم `"104"` ليس `NOTIFY` في `cmdDef.lua` ويكتب في `heroCtrl` غير الموجود. |
| `200`/`201`/`450` | `MAP_DATA`/`MAP_SYNC`/`SWITCH_MAP` | `_handle_notify_generic_controller` | **خلل مؤكد** | `M-05` — يدمج أحداث الحذف في جذر `kingdomMapCtrl` ولا يحذف كائنات/طوابير الخريطة. |
| `202` | `NOTIFY_LOCAL_QUEUE_SYNC` | `_handle_notify_local_queue` | **خلل حرج مؤكد** | `M-03` — لا يحذف `orgId` عند `ADD`، ولا يستبدل `from.army`/`heroInfo`/`armsInfo`/`divineBeastInfo` عند `UPDATE`. |
| `406` | `NOTIFY_HERO_SYS` | `_handle_notify_hero_sys` | **سليم** | يطابق `heroCtrl.lua:1325-1398` (يحدّث `heroList[str(hid)]` و`defendList`). |
| `608` | `NOTIFY_COMMAND_HALL` | `_handle_notify_generic_controller` | **خلل مؤكد** | `N-10` — يدمج بدل الاستبدال الكامل (`commandHallCtrl.lua:48-49, 586-588`) فتتراكم مهام شبحية. |
| `1002` | `STUFFWORKSHOP_REFINERY` | `_handle_notify_generic_controller` | **خلل حرج مؤكد** | `N-07` — يضاعف `stuffWorkshopCtrl["list"]` (`7 -> 14 -> 21...`) في كل إشعار ولا يحدّث `queueCtrl["1238"]`! |
| `1070` (وهمي) | `MERITORIOUS_TASK` | `_handle_notify_meritorious` | **مسار ميت** | `"1070"` هي `CMD_CONQUESTWAR` وليست `NOTIFY` في `cmdDef.lua`. |
| **مفقودة** | `2`, `18`, `37`, `492`, `494`, `500`, `571`, `642`, `1007` | **غير مسجّلة أصلاً!** | **خلل حرج/عالي** | `N-17` — إشعارات فعّالة تستخدمها المهام الحية وتُسقط كلياً (`unhandled_notify`)! |

---

#### تفاصيل الأعطال المؤكدة في معالجات `NOTIFY` (`N-01` – `N-17`)

##### `N-01` — `_handle_notify_queue` معطّل كلياً على حزم `NOTIFY_QUEUE (14)` الحقيقية
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`queueCtrl.lua:241-303` + السجل الحي `docs/live_cycle_log.txt:913-916`)
- **الموقع:** `core/live_memory.py:1618-1716`
- **الدليل المقارن:**
  - **Lua (`queueCtrl.lua:241-303`):**
    ```lua
    local event = content.dispatchQueueEvent
    local queueType = event.name  -- اسم المفتاح هو "name" وليس queuetype/qtype!
    if event.notifyType == "merge" then ... -- deleteList + addQueue
    else -- أي حدث غير merge هو إكمال/حذف الطابور (يفحص _uniqueid ثم removeQueue)!
    ```
  - **Python (`core/live_memory.py:1638-1652`):** يبحث عن `queuetype`/`qtype` (يتجاهل `event.get("name")`) فتصبح `qtype == ""` ولا يفعل شيئاً! (مثبت حياً في `docs/live_cycle_log.txt:913-916`: طبع `طوابير القلعة (نشط)` بدون أي `qtype`!) كما أنه لا يحذف الطابور إلا إذا كان `notifyType in ("finish","del","remove","cancel")` — وإلا يطمسه كطابور نشط، ولا يدعم `notifyType == "merge"`.
- **نطاق التأثير:** جميع الطوابير الداخلية المعتمدة على `queueCtrl` (تدريب، علاج، أبحاث، تكرير مواد، مهارات، حدادة).
- **التوصية المبدئية:** قراءة `qtype = str(event.get("name") or event.get("queuetype") or event.get("qtype") or "")`؛ تنفيذ `notifyType == "merge"` (`deleteList` + إضافة الطابور المدموج)؛ وفيما عدا `merge` (ومع استثناء `1200`/`1201` كما في `queueCtrl.lua:252`) حذف `queueCtrl[qtype]` بعد التحقق من `_uniqueid`.

##### `N-02` — `_handle_notify_army` لا يستبدل `fightingArmy`/`exceptionArmy` عند عودتها فارغة `{}`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`armyCtrl.lua:1062-1064`)
- **الموقع:** `core/live_memory.py:1775-1806`
- **الدليل المقارن:** `armyCtrl.lua:1062`: `self.armyInfo = armyInfo` (استبدال كامل). بينما `live_memory.py:1787-1805` يستبدل 4 مفاتيح فقط (`totalArmy`, `woundedArmy`, `trainArmy`, `freeArmy`) ويمرر الباقي لـ `smart_deep_merge` الذي لا يفعل شيئاً عندما تصبح `fightingArmy == {}`.
- **نطاق التأثير:** `base_task.get_army_list(deduct_fighting=True)` تظل تخصم جنوداً عادوا بالفعل إلى القلعة.
- **التوصية المبدئية:** استبدال جميع مفاتيح خرائط الجيش الواردة في `army_info` (بما فيها `fightingArmy`, `exceptionArmy`, `exceptionWoundedArmy`) مباشرة بـ `copy.deepcopy`.

##### `N-03` — `_handle_notify_lord` ينشئ التداخل المزدوج `fcInfo.fcInfo` ويكتب 7 مفاتيح حيوية في مسارات خاطئة
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`lordAuxiliary.lua:385-403`, `lordInfoCtrl.lua:146-362` + 49 ظهوراً حياً في `docs/live_cycle_log.txt:355-1386`)
- **الموقع:** `core/live_memory.py:1889-1907`
- **الدليل المقارن:**
  - **Lua (`lordAuxiliary.lua:385-403`):** يفكّ الجداول المتداخلة (`if type(var) == "table" and key ~= "castleReward": for k,v in pairs(var): lordBaseInfo[k] = v`).
  - **السجل الحي (`docs/live_cycle_log.txt:355, 360, 875, 1173, 1263, 1370`):** السيرفر يرسل `{"key": "fcInfo", "fcInfo": {"totalFc": 3330237, ...}}` فيكتبها البوت داخل **`lordInfoCtrl["fcInfo"]["fcInfo"]`** بينما يبقى `lordInfoCtrl["fcInfo"]["totalFc"]` متجمداً!
  - **Lua (`lordInfoCtrl.lua:146-362`):** `closeVIP` يُصفّر `vip.vipEndTime=0` ويحذف `queueCtrl["1219"]`؛ `activate` يحدّث `vip.vipEndTime`؛ `updateLoginDay` يحدّث `vip.loginDay`؛ `physical` يحدّث طابور `physical_recovery` في `queueCtrl` (السطر `927` باللوق أظهر `physical.time=-1` مرمياً في الجذر!)؛ `signature`/`passwdVerify`/`merge_history`/`mergeGuideFlag` تتبع `lordInfoCtrl["base"]`؛ و`updateOfficial` يتبع `lordInfoCtrl["official"]`.
- **نطاق التأثير:** `bot_manager.sync_live_data_to_db` (`power`)، `is_vip_active`/`vip_end_time` (ومنه `building.py`, `skills.py`, `get_max_marches_capacity`)، وبيانات الطاقة واللورد.
- **التوصية المبدئية:** فك التداخل عندما يكون `sub_dict` يحتوي على نفس المفتاح `key` (`if key in sub_dict and isinstance(sub_dict[key], dict): sub_dict = sub_dict[key]`)، وإضافة توجيه صريح لـ `closeVIP`, `activate`, `updateLoginDay`, `physical`, `updateOfficial`, وحقول `base`.

##### `N-04` — `_handle_notify_time_reward` يكتب بالجذر بدل `timeRewardCtrl["data"]` ويعكس أسماء `TIME_REWARD` vs `REWARD`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`cmdDef.lua:357,361`, `notifyIDDef.lua:26,29`, `notifyCtrl.lua:64,73`, `timeRewardCtrl.lua:27-81` + جميع اللقطات الخمس)
- **الموقع:** `core/live_memory.py:770-776, 2150-2166`
- **الدليل المقارن:**
  - `gNotifyID.REWARD ("NOTIFY_REWARD")` -> `subcmd 16` (`notifyRewardData`: إذا وُجد `timeData` يستبدل البيانات ويعود **دون** فرض `isReceive=2`؛ وإلا يضع `isReceive=2` ويصفّر الانتظار).
  - `gNotifyID.TIME_REWARD ("NOTIFY_TIME_REWARD")` -> `subcmd 20` (`notifyResetRewardData`: يصفّر `isReceive=1, sequence=1, isAllReceive=0, reward=...`).
  - جميع اللقطات الخمس تخزّن هذه الحقول داخل **`timeRewardCtrl["data"]`** وليس الجذر.
- **نطاق التأثير:** `tasks/port.py` يتجمد نهائياً من اليوم الثاني أو يظل عالقاً عند `time > 0`.
- **التوصية المبدئية:** توجيه التحديث إلى `timeRewardCtrl["data"]`، فصل `16`/`NOTIFY_REWARD` (مع احترام `return` عند `timeData` وتصفير `timeRewardCtrl["time"] = 0`) عن `20`/`NOTIFY_TIME_REWARD`/`NOTIFY_RESET_TIME_REWARD` (مع نسخ `reward`).

##### `N-05` — `_handle_notify_city` يفتقد `updateBuildInfo` و`demolishInfo` و`starttime` في `openChargeQueue`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`cityCtrl.lua:1430-1529`)
- **الموقع:** `core/live_memory.py:1536-1616`
- **الدليل المقارن:** `cityCtrl.lua:1523-1529` تحدّث حقول المباني في `blist` من `v.updateBuildInfo`، و`L1430` تحذف المباني المهدومة من `v.demolishInfo`، و`L1449` تحقن `starttime = now` في `openChargeQueue` لأن السيرفر يرسل `totaltime`/`lefttime` فقط.
- **نطاق التأثير:** `building.py`, `city_harvest.py`, `watermill.py`.
- **التوصية المبدئية:** دعم `updateBuildInfo` و`demolishInfo` وتعيين `starttime = int(time.time())` في `openChargeQueue` عند غيابه.

##### `N-06` — `_handle_notify_buff` يفتقد إغلاق درع السلام (`5003`) وتبريد مهارة التسلل (`5130 -> 13032`)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`lordSkillModule.lua:25, 97-98, 228-235`, `beetoo3_live_memory.json`)
- **الموقع:** `core/live_memory.py:1965-1979`
- **السبب ونطاق التأثير:** عند `closeBuff`/`buffFinish` لـ `"5003"` لا يتم تصفير `kingdomMapCtrl["isSafe"] = False` (يسهم في خطر عدم تجديد الدرع في `shield.py`)؛ وعند إغلاق `"5130"` لا يبدأ تبريد `lordSkillCtrl["CDData"]["13032"]` (فيكرر `skills.py` استدعاءها بـ `err=3013`).
- **التوصية المبدئية:** إضافة `"5003" -> kingdomMapCtrl["isSafe"] = False` و`"5130" -> CDData["13032"]` داخل `_handle_notify_buff`.

##### `N-07` — `NOTIFY_STUFFWORKSHOP_REFINERY (1002)` يضاعف `stuffWorkshopCtrl["list"]` (`7 -> 14 -> 21...`) ولا يحدّث `queueCtrl["1238"]`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`stuffWorkshopCtrl.lua:28-44` + `beetoo1_live_memory.json` + `live_cycle_log.txt:278-281` + اختبار Python جاف)
- **الموقع:** `core/live_memory.py:850-852, 2244-2246`
- **الدليل المقارن:** `stuffWorkshopCtrl.lua:30-43` يستبدل `self.dataTable = clone(tmpRetData.data)` بالكامل ويحدّث طابور `1238`. لأن عناصر `list` الـ 7 بلا مفتاح هوية (`{"type": 0}`), فإن `_merge_keyed_lists` يلحق +7 خانات مكررة في **كل** إشعار!
- **نطاق التأثير:** `material_workshop.py` و`base_task.get_material_workshop_status` (خانات شبحية وإرسال `2021/2` زائدة مرفوضة).
- **التوصية المبدئية:** استبدال `stuffWorkshopCtrl` بالكامل بـ `copy.deepcopy(tmp["data"])` ومزامنة/حذف `queueCtrl["1238"]` من `hasRefinery`.

##### `N-08` — `NOTIFY_SHOP (23)` يمسح `storesCtrl` (التاجر العجيب) بالكامل عند وصول أي إشعار متجر!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`storesCtrl.lua:27-63`, `shopCtrl.lua:562-594`, جميع اللقطات الخمس + اختبار Python جاف)
- **الموقع:** `core/live_memory.py:830-832, 2260-2261`
- **الدليل المقارن:** `shopCtrl` غير موجود في `1000/1` بينما `storesCtrl` هو التاجر العجيب (7 مفاتيح). `live_memory.py:2238, 2261` يدمج الإشعار في `shopCtrl` الفارغ ثم ينفّذ `self.init_data["storesCtrl"] = self.init_data["shopCtrl"]` — مما **يدمر `isOpen` و`shopItemArray` فوراً** حتى عند إشعارات `shopCtrl` مثل `newDay`/`updateItemShopConfig`! وعند `notifyType == "close"` لا يصفّر `isOpen`.
- **نطاق التأثير:** تعطّل `WonderMerchantTask` طوال بقية الجلسة.
- **التوصية المبدئية:** فصل `storesCtrl` عن `shopCtrl` نهائياً وكتابة `_handle_notify_shop` يفرّق بـ `notifyType` (`open`, `reset`, `close`, `actBegin`, `actEnd`) وفق `storesCtrl.lua:30-61` مع استبدال `shopItemArray`.

##### `N-09` — `NOTIFY_PET (65)` موجّه لمتحكم وهمي `godBeastCtrl` بدل `petCtrl`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`cmdDef.lua:406`, `notifyIDDef.lua:84` + جميع اللقطات الخمس + اختبار Python جاف)
- **الموقع:** `core/live_memory.py:847-849`
- **السبب ونطاق التأثير:** `godBeastCtrl` غير موجود في اللعبة؛ كل إشعارات `petCtrl` (بما فيها تصفير الإطعام المجاني يومياً) تذهب لمفتاح ميت، فتبقى `curFreeFeed == 2` عالقة من اليوم الثاني في `tasks/pet.py`.
- **التوصية المبدئية:** تغيير الهدف إلى `("petCtrl",)` (والتحقق الميداني `V-06` لتأكيد هل يحتاج دمجاً أم استبدالاً).

##### `N-10` — `NOTIFY_COMMAND_HALL (608)` يدمج بدل الاستبدال الكامل فتتراكم مهام شبحية
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`commandHallCtrl.lua:48-49, 586-588` + `live_cycle_log.txt:1134, 1214, 1293`)
- **الموقع:** `core/live_memory.py:803-805, 2244-2259`
- **السبب ونطاق التأثير:** `smart_deep_merge` لا يحذف المهام المكتملة من `commonTaskData` ولا يفرّغ `armyPioneerTaskData`/`armyGroupTaskData` عند عودتها `{}`.
- **التوصية المبدئية:** استبدال `commandHallCtrl` (والمستعار `commandHall`) بالكامل من `initData` عند `NOTIFY 608`.

##### `N-11` — `NOTIFY_ALLIANCE (3)` و`RELATION (64)` و`RECOMMEND (1009)` تلوّث جذر `allianceCtrl`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`allianceNotifyHandle.lua:16-112`, `allianceRelationCtrl.lua:217-258`, `allianceCtrl.lua:88-99`, `live_cycle_log.txt:321-324`)
- **الموقع:** `core/live_memory.py:793-802`
- **السبب ونطاق التأثير:** `NOTIFY 3` يلقي `eventName`/`digInfo` بالجذر بدل تحديث `helplist`/`allianceTreasureCtrl`/`queueCtrl`؛ `NOTIFY 64` يدمج بالجذر بدل `relationMap[aid]` ولا يحذف عند `DEL_RELATION`؛ `NOTIFY 1009` يخاطر بطمس خصائص التحالف الخاص.
- **التوصية المبدئية:** معالج مخصص لـ `NOTIFY 3` (لأحداث المساعدة وكنز التحالف والعلوم على الأقل)، وتوجيه `64` إلى `relationMap[aid]`، وتجاهل `1009` على `allianceCtrl`.

##### `N-12` — `NOTIFY_EQUIPMENT (29)` لا يعالج أحداث العتاد + `DEFAULT_KEY_MAPS` يفهرس `equipment_array` بـ `eid` بدل `epid`!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`equipmentCtrl.lua:1573-1677` + `beetoo1`/`beetoo2_live_memory.json`)
- **الموقع:** `core/live_memory.py:304-306, 827-829`
- **الدليل المقارن:** `epid` هو المعرّف الفريد للقطعة بينما `eid` هو نوع الوصفة (تتكرر عدة قطع بنفس `eid`). و`NOTIFY 29` يرسل أحداث `cle` (إكمال التصنيع وحذف طابور `1229` ووضع `fe.isCle=1`) و`add` و`delete` و`rfr` — والدمج العام يلقيها في الجذر فقط!
- **نطاق التأثير:** `forge_equipment.py` (تأخر رصد انتهاء الحدادة وتراكم/فقدان قطع في `equipment_array`).
- **التوصية المبدئية:** تغيير مفتاح `equipment_array` في `DEFAULT_KEY_MAPS` إلى `("epid",)` وكتابة `_handle_notify_equipment` مطابقاً لـ `equipmentCtrl.lua:1573-1675`.

##### `N-13` — `NOTIFY_QUEST (12)` يطمس التحديثات المتعددة ويسقط 6 من 7 أنواع + `NOTIFY_WALLS (11)` يقرأ المفتاح الخطأ
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`questCtrl.lua:214-248`, `wallsCtrl.lua:104-116`, `live_cycle_log.txt:306-309`)
- **الموقع:** `core/live_memory.py:806-813`
- **السبب ونطاق التأثير:** `NOTIFY 12` يلقي `questID`/`progress` بالجذر (إذا تقدم أكثر من مهمة في الدورة يُفقد كل ما عدا الأخيرة، وتضيع `new`/`guide`/`finish_guide`/`newOQuest`/`closeOQuest`/`openOQuest` بالكامل -> يفشل `daily_quest.py` في استلام المهام). و`NOTIFY 11` حمولته داخل `notifyData.notifyData` (ليس `data`) فتُلقى بالجذر ولا تحدّث `defence`/`isBurning`/`status`.
- **التوصية المبدئية:** معالج `_handle_notify_quest` يعالج الأنواع الـ 7 مباشرة على `questArray`/`oQuestArray`/`guideQuest`/`pGuideQuest`، ومعالج لـ `NOTIFY 11` يفك `item["notifyData"]`.

##### `N-14` / `N-15` / `N-16` — الاستبدال بدل الدمج في `NOTIFY_BADGE_EXCHANGE (41)`, `NOTIFY_PYRAMID (27)`, `NOTIFY_ALLIANCE_TREASURE (95)`, `NOTIFY_ESCORT_CART (50)`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`badgeExchangeCtrl.lua:43-44`, `pyramidCtrl.lua:253`, `allianceTreasureCtrl.lua:275-297`, `escortCartCtrl.lua:102`, `beetoo1`/`sample_live_memory.json`)
- **الموقع:** `core/live_memory.py:787-792, 818-826, 2244-2250`
- **السبب ونطاق التأثير:**
  - **`N-14` (`41`):** عند التصفير اليومي (`curExchangeNumMap = {}`)، `smart_deep_merge` يبقي العدادات القديمة -> `war_medal.py` يحسب تكلفة خاطئة.
  - **`N-15` (`27`):** `NOTIFY_PYRAMID` يفك `data` في جذر `pyramidCtrl` بدل استبدال `pyramidCtrl["data"]` -> `imperial_mausoleum.py` يتجمد عند `free=0` من اليوم الثاني.
  - **`N-16` (`95`):** `NOTIFY_ALLIANCE_TREASURE` يدمج قوائم الصناديق بدل استبدالها ويُسرّب `"notifyType": "AUTO_REFRESH"` -> صناديق منتهية تبقى في `alliance.py`.
  - **`N-16B` (`50`):** `escortCartCtrl["rewardMap"]` قائمة قوائم (`[[...]]`) فتتضاعف عند الدمج بدل الاستبدال.
- **التوصية المبدئية:** استبدال مباشر (`replace`) بدلاً من `smart_deep_merge` للمفاتيح المذكورة (ولـ `pyramidCtrl["data"]`).

##### `N-17` — 9 إشعارات حرجة/عالية مفقودة كلياً من `_NOTIFY_ROUTE_TABLE` (ومثبتة حياً في `live_cycle_log.txt`)
- **الخطورة واليقين:** `CRITICAL / HIGH` | **مؤكد 100%** (`cmdDef.lua`, `notifyCtrl.lua` + اللوق الحي `docs/live_cycle_log.txt:855, 902`)
- **الموقع:** `core/live_memory.py:733-853`
- **قائمة الإشعارات المفقودة المرتبطة بمهام فعّالة حصراً:**
  1. **`"2"` (`NOTIFY_WORLD_UPDATE`, `cmdDef.lua:343`, `kingdomMapCell.lua:663-667`):** يحدّث `kingdomMapCtrl["isSafe"]` عند تفعيل/انتهاء/انكسار الدرع -> **غيابه يمنع `shield.py` من إعادة التفعيل بعد انتهاء الدرع!**
  2. **`"18"` (`NOTIFY_DAILYLOGIN_REWARD`, `cmdDef.lua:359`, `loginRewardCtrl.lua:39-49`):** يفتح `canReceive=true` في منتصف الليل -> **غيابه يعطّل `merchant_ship.py` من اليوم الثاني!**
  3. **`"37"` (`NOTIFY_HERO_TRIAL`, `cmdDef.lua:378`, `heroTrialCtrl.lua:156-241`):** يحدّث `htData` (`addPoint`/`subPoint`/`battle`/`finish`/`refresh`) -> **مرصود حياً كـ غير معالج في `live_cycle_log.txt:902`!**
  4. **`"1007"` (`NOTIFY_ARENA`, `cmdDef.lua:771`, `arenaCtrl.lua:136-216`):** يحدّث `playerArenaCtrl` (`rewardChange`, `refreshData`, `globalState`, `arenaRankChange`) -> **مرصود حياً كـ غير معالج في `live_cycle_log.txt:855`!**
  5. **`"494"` (`NOTIFY_TECHNOLOGY`, `cmdDef.lua:537`, `technologyCtrl.lua:43-89`):** يحدّث `technologyCtrl` وطابور البحث -> يؤثر على `research.py` و`march_capacity.py`.
  6. **`"500"` (`NOTIFY_DUEL_IN_COOL_DOWN`, `cmdDef.lua:543`, `lordSkillCtrl.lua:199-212`):** يحدّث `lordSkillCtrl["CDData"]` -> يؤثر على `skills.py`.
  7. **`"492"` (`NOTIFY_EXALTED_PRIVILEGE`, `cmdDef.lua:535`, `exaltedPrivilegeCtrl.lua:101`):** يحدّث `exaltedPrivilegeCtrl` -> يؤثر على `skills.py` (الأطقم 4–6) و`hero_trial.py`.
  8. **`"571"` (`NOTIFY_HERO_COMBO_SKILL`, `cmdDef.lua:613`, `heroComboSkillCtrl.lua:25`):** يحدّث `heroComboSkillCtrl` -> يؤثر على `base_task.get_hero_rally_skill_status`.
  9. **`"642"` (`NOTIFY_DIVINE_BEAST`, `cmdDef.lua:683`, `divineBeastCtrl.lua:44`):** يحدّث `divineBeastCtrl` -> يؤثر على `explore_ruins.py` و`base_task.get_divine_beast_march_buff`.
  *(إضافة لرقم `"464"` `NOTIFY_NEW_SALESROOM` المفقود في السطر `836` رغم وجود اسمه النصي.)*


---

## 4. الأعطال المؤكدة في `tasks/base_task.py` (`BT-01` – `BT-12`)

> **ما هو سليم في `tasks/base_task.py`:** خصائص القراءة الأساسية (`uid`, `stamina`, `health`, `gold`, `lord_level`, `castle_level`, `resources`)، قراءة `get_army_list`/`get_trap_list`/`get_available_troops`، `get_active_marches_count`، `get_resource_boost_speedups`/`get_available_stamina_packs`، `get_resource_buildings_boost_status`، `get_drill_grounds_base_capacity`/`get_leadership_technology_additions`/`get_active_march_buffs`/`get_vip_march_buff`/`get_hero_dress_passive_march_buff`، `get_market_transport_capacity`، والتحديثات المحلية في `_sync_command_hall_init_data` (عند `err==0`) و`collect_material_workshop_finished` (`doneID=0`).
> *(ملاحظة: أعطال `base_task.py` المرتبطة مباشرة بالمسيرات موثّقة بالتفصيل في القسم 2 تحت `M-06`, `M-08`, `M-09`.)*

---

### `BT-01` — `ensure_resources`: لا يفحص `err == 0`، يضاعف تعديل الحقيبة والموارد، يطمس `resList`/`reslist`، ويضيف `safe_boxes` إلى `reslist` بدل `saferes`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`backpackCtrl.lua:54-260, 395-483`, `cityCtrl.lua:1403-1422`, `core/live_memory.py:1554-1577, 1717-1774`, `lucifer_live_memory.json`)
- **الموقع:** `tasks/base_task.py:4492-4498, 4602-4623`
- **الدليل المقارن:**
  - **Python (`L4603-4623`):**
    ```python
    resp = await self.safe_query("1004", "2", payload)
    if resp is not None:  # لا يفحص err == 0!
        box_entry["count"] = available_count - use_count  # خصم مزدوج بعد NOTIFY_BACKPACK!
        res_list[res_id] = str(int(float(res_list.get(res_id, 0))) + gained)  # إضافة مزدوجة!
        city["reslist"] = res_list  # يطمس reslist بالقاموس القديم ويكسر الترادف مع resList!
    ```
  - **Lua & JSON:** `backpackCtrl.lua` لا يعدّل الحقيبة ولا الموارد محلياً عند `1004/2` بل يعتمد على `NOTIFY_BACKPACK (1)` و`NOTIFY_CITY (9)`. وفي `lucifer_live_memory.json` الموارد الآمنة منفصلة في `cityCtrl["saferes"]`.
- **نطاق التأثير:** `building.py`, `forge_equipment.py` وكل مهمة تقرأ `cityCtrl.reslist`/`resList`/`saferes` أو `backpackCtrl`.
- **التوصية المبدئية:** اشتراط `is_query_success(resp)` وإزالة التعديل اليدوي لـ `box_entry`/`res_list` (أو قراءة `cityCtrl.reslist`/`saferes` المحدثة بعد `NOTIFY_CITY`، وتوجيه `is_safe=True` إلى `saferes` فقط).

### `BT-02` — مهام قاعة القيادة (المعركة والفورية): خصم مزدوج للطاقة `lordInfoCtrl.base.health` بعد `NOTIFY_LORD (8)`
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`commandHallCtrl.lua:304-327, 376-393`, `lordInfoCtrl.lua:362-387` + إثبات مباشر باللوق الحي `docs/live_cycle_log.txt:943-957, 1112-1126`)
- **الموقع:** `tasks/base_task.py:5453-5458` (معركة `1007/2`) و`tasks/base_task.py:5739-5743` (فورية `2274/5`+`2274/8`)
- **الدليل المقارن:** في `docs/live_cycle_log.txt:943-957` (فورية) و`1112-1126` (معركة)، وصل `NOTIFY_LORD` وخصم الطاقة بالفعل (`26,685 -> 26,680` و`26,650`) **قبل** عودة الـ RPC، ثم خصم الكود `-5` مرة ثانية!
- **نطاق التأثير:** `command_hall.py` وجميع المهام المعتمدة على `self.stamina` (`stamina.py`, `hunt_monsters.py`, `explore_ruins.py`).
- **التوصية المبدئية:** حذف الكتلتين `L5453-5458` و`L5739-5743` والاعتماد على `NOTIFY_LORD (8)`.

### `BT-03` — قراءة/كتابة `queueCtrl[*]["ottime"]` كطابع زمني Unix بدل كونه مدة بالثواني!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`queueCtrl.lua:312-328` + `beetoo2_live_memory.json`, `lucifer_live_memory.json`)
- **الموقع:** `tasks/base_task.py:1863-1871` (`vip_end_time`), `2458-2468` (`get_lord_skill_status`), `2674` (`_mark_skill_buff_active_in_memory`)
- **الدليل المقارن:** في `beetoo2`/`lucifer_live_memory.json` و`queueCtrl.lua:314`: `"ottime": 14400` / `50409` هي **المدة الأصلية بالثواني** لا وقت الانتهاء (`~1.79e9`). لأن `ot != 0` يتجاوز الكود شرط `if ot == 0 and tot > 0 and st > 0:` فيقارن `7200 > now_ts` -> `False` دائماً، وتكتب `L2674` طابعاً زمنياً داخل `ottime`!
- **نطاق التأثير:** `is_vip_active` (ومنه `building.py`, `get_max_marches_capacity`, `skills.py`) ورصد طوابير مهارات اللورد.
- **التوصية المبدئية:** حساب وقت الانتهاء دائماً عبر `starttime + totaltime` (لا `ottime`) وتخزين المدة بالثواني في `ottime`.

### `BT-04` — `get_material_workshop_status` يقرأ أسماء حقول خاطئة من `queueCtrl["1238"]` فتبقى `active_refining_queue == None` دائماً
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`queueCtrl.lua:115-118, 314-327` + `beetoo2_live_memory.json`)
- **الموقع:** `tasks/base_task.py:6206-6216`
- **الدليل المقارن:** الكود يقرأ `queueType`/`type` و`begintime`/`startTime` و`finishTime`/`endTime`، بينما الحقول الحقيقية في `beetoo2_live_memory.json` هي `"qtype": "1238"`, `"starttime": 1795319220`, `"data": {"endtime": 1795333620}`.
- **نطاق التأثير:** `tasks/material_workshop.py`.
- **التوصية المبدئية:** قراءة `qtype`, `starttime`, و`data.endtime` (أو `starttime + totaltime`).

### `BT-05` — `switch_lord_skill_set` يرسل ويخزّن `setID` كـ `int` بدل `str` (سبب خطأ `err=6` الفعلي باللوق الحي!)
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`lordSkillltCtrl.lua:78`, `skillNewActiveViewPanel.lua:546`, `skillViewPanel.lua:99, 252`, `beetoo1..3_live_memory.json` + `docs/live_cycle_log.txt:1340-1373`)
- **الموقع:** `tasks/base_task.py:2591-2612`
- **الدليل المقارن:**
  - **Lua:** `lordSkillltCtrl.lua:78`: `v.setID = tostring(v.setID)`؛ `skillNewActiveViewPanel.lua:546`: `switchSkillSet(tostring(self.setID))`. وفي كل اللقطات `"activeSetID": "1"` نصي.
  - **السجل الحي (`docs/live_cycle_log.txt:1343, 1363, 1373`):** فشل `1002/23` ثلاث مرات متتالية بكود **`6` (`Err_CLIENT_EXCEPTION`)** عند محاولة التبديل للطقم 2.
- **نطاق التأثير:** فشل تفعيل كل مهارات اللورد التي تتطلب تبديل طقم المواهب في `tasks/skills.py`.
- **التوصية المبدئية:** إرسال `{"setID": str(target_set)}` وتخزين `lord_skills_live["activeSetID"] = str(target_set)` (مع تأكيد ميداني `V-08`).

### `BT-06` — `_mark_skill_buff_active_in_memory` يطمس مدد `NOTIFY_BUFF` الحقيقية بـ `3600s`، ويحقن طوابير وهمية لمهارات فورية، و`_sync_skill_cd_in_memory` يغفل `13032`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`buff.lua:868-874, 2675-2682`, `queueTypeDef.lua:17-41`, `lordSkillCtrl.lua:132-163`, `lordSkillModule.lua:97, 228-235`, `live_cycle_log.txt:1325-1418`)
- **الموقع:** `tasks/base_task.py:2634-2686, 2696-2698`
- **الدليل المقارن:**
  - `buff.lua`: باف `4504` (`12023`) مدته `10800s` (3 ساعات) وباف `5129` (`12031`) مدته `14400s` (4 ساعات). عند نجاح `1002/22` يصل `NOTIFY_BUFF` بالمدة الصحيحة (`live_cycle_log.txt:1414`) ثم `b.update(buff_obj)` يقصّها إلى `3600s`!
  - المهارات الفورية (`11011`, `12008`, `13020`, `13021`) بلا طوابير بالسيرفر (`live_cycle_log.txt:1325-1410`)، لكن `L2667-2677` تحقن طوابير `3600s` في `queueCtrl` فتُظهرها نشطة لساعة.
  - `13032` (`SNEAK_INTO`, باف `5130`) تبريدها مؤجّل حتى إغلاق الباف تماماً مثل `11028` و`13040` (`lordSkillModule.lua:97, 228-235`), لكنها غائبة عن `L2697`.
- **نطاق التأثير:** `tasks/skills.py`, `tasks/watermill.py`.
- **التوصية المبدئية:** عدم الكتابة فوق باف موجود بالفعل من `NOTIFY_BUFF`، عدم حقن طوابير للمهارات الفورية، استخدام المدد الحقيقية فقط كاحتياطي عند `err == 3012`، وإضافة `13032` لحراسة `L2697`.

### `BT-07` — `can_switch_lord_skill_set` (الأطقم 4–6): يقرأ `exaltedPrivilegeCtrl["privileges"]` الوهمي (ومسقط بالفلتر)
- **الخطورة واليقين:** `MEDIUM-HIGH` | **مؤكد 100%** (`exaltedPrivilegeCtrl.lua:19, 101-105, 168-202` + `core/live_memory.py:55-142`)
- **الموقع:** `tasks/base_task.py:1990-2005`
- **الدليل المقارن:** لا يوجد حقل `privileges` أو `privilegeList` في السيرفر؛ اللعبة تحسب الامتياز من مجموع `userData.{privilegeItemScore, privilegeLoginScore, privilegeRechargeScore}` عبر جدول `exclusiveVipRead`.
- **نطاق التأثير:** `tasks/skills.py` (الأطقم 4–6 لا تعمل أبداً).
- **التوصية المبدئية:** إضافة `exaltedPrivilegeCtrl` للقائمة البيضاء ومعالج `NOTIFY 492` وحساب الامتياز من مجموع النقاط.

### `BT-08` — `BaseTask.kingdom_id`: يقرأ `lordInfoCtrl.base["lastKid"]` غير الموجود بدل `partition`/`kingdomId`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`lordInfoCtrl.lua:1233-1237` + جميع اللقطات الخمس)
- **الموقع:** `tasks/base_task.py:1711-1721`
- **الدليل المقارن:** `base.get("lastKid")` غير موجود في أي لقطة؛ المفاتيح الفعلية هي `kingdomMapCtrl["kingdomId"]` و`lordInfoCtrl.base["partition"]`.
- **نطاق التأثير:** عند غياب `creds.kingdom_id` يرجع `0` فيُفسد نطاق `exclude_manager` ويرسل `"mapId": 0` في `execute_command_hall_battle_task` (`L5412, 5434`).
- **التوصية المبدئية:** Fallback بالترتيب: `kingdomMapCtrl.kingdomId` -> `lordInfoCtrl.base.partition` -> `sourceKid`.

### `BT-09` — أخطاء حساب سعة المسيرة والقوات في `base_task.py`: مصائد السور، مفاتيح ميتة لـ `pet`/`dress`/`equipment`، عكس حالة `divineBeast`، ونوع `is_mass` خاطئ
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`armyCtrl.lua:308-317`, `petCtrl.lua:290-325`, `dressltCtrl.lua:81-83`, `equipmentDef.lua:74`, `divineBeastCtrl.lua:10-14, 95-120`, `buildLogic.lua:1884` + جميع اللقطات الخمس)
- **المواقع والأدلة:**
  1. **`get_castle_available_troops` (`L8226-8231`):** يحتسب مصائد السور (`801–899`) ضمن الجنود المتاحين للإرسال (مثل 1,958 مصيدة في `beetoo1` و1,303 في `sample`) ويتجاهل `fightingArmy`. **الحل:** تفويضها إلى `self.get_army_list(deduct_fighting=True)`.
  2. **`get_extra_permanent_march_buffs` (`L7634-7670, 7705-7720`):** يبحث عن خاصية `78` في `eq["extra"]` (وهي في الخصائص الأساسية لا `extra`)، ويقرأ `petTalentData`/`talentSkills` غير الموجودة في `petCtrl`، ويقارن `dressID` (7 أرقام) بجدول `subType` (3 أرقام) -> جميعها ترجع `0` دائماً.
  3. **`get_divine_beast_march_buff` (`L8141-8206`):** يقرأ `dispatchBuffDatas` (المحسوب محلياً بـ Lua فقط ولا يرسله السيرفر)، ويعكس الفلتر `b_state in (2, 3, 4)` فيُدخل `state=0 (TREAT)` ويستبعد `state=2 (DEFEND)`! **الحل:** استبعاد `(0, 3, 4)` وحساب المهارة من `starLv` مباشرة.
  4. **`get_castle_march_capacity_without_heroes` (`L7799`):** `is_mass = move_line_type in (3, 4)` خاطئ! في `buildLogic.lua:1884` و`mapDef.lua:330, 334` أنواع الحشد هي `(9, 14)` بينما `3=capture` و`4=RelicsExplore` (يضخّم سعة المسيرة الفردية ببافات الحشد!).

### `BT-10` — `get_hero_rally_skill_status` و`_sync_hero_rally_skill_in_memory`: يخلط `queueType=7 (ResourceHelp)` بالحشد ويطمس مدة الباف بـ `3600`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`mapDef.lua:328, 330, 387`, `localUserQueueMgr.lua:157-166`)
- **الموقع:** `tasks/base_task.py:2971, 3006-3010, 3056`
- **الدليل المقارن:** `str(q_type) in ("0", "7")` يطابق قوافل دعم الموارد (`queueType=7`) كحشد ويغفل الحشود الحقيقية (`9, 14, 21...`)؛ والسطر `3056` يقرأ `status["buff_remaining_seconds"]` (دائماً `0` قبل التفعيل) بدل `HERO_RALLY_SKILLS_CATALOG[group_id]["effect_seconds"]`.
- **التوصية المبدئية:** التحقق من `q_status == 0` مع `moveLineType == 7` أو أنواع الحشد السيرفرية، وقراءة المدة من الكتالوج.

### `BT-11` — عدّاد `conn._command_hall_daily_subtasks` لا يُصفَّر عند منتصف الليل UTC (يعطّل `command_hall` في وضع `daily` بدءاً من اليوم الثاني!)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`tasks/base_task.py:4823-4858`, `core/live_memory.py:2184-2187`)
- **الموقع:** `tasks/base_task.py:4823-4834, 4844-4858`
- **السبب ونطاق التأثير:** عند اليوم الثاني يتصفّر `everydayTaskCtrl["eventInfo"]` إلى `{}` فتسقط الدالة إلى `conn._command_hall_daily_subtasks` الذي يظل `>= 3` من اليوم الأول -> تعيد `(True, 3, 3)` للأبد!
- **التوصية المبدئية:** ربط العدّاد باليوم الحالي (UTC date أو `tomorrowZeroUTC`) وتصفيره عند تبدّل اليوم.

### `BT-12` — غياب فحص `err == 0` قبل تعديل الذاكرة في 3 دوال + قصور `_is_resp_ok`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`core/game_client.py:361-385`, `commandHallCtrl.lua:248`, `achievementctrl.lua:243`)
- **الموقع:** `tasks/base_task.py:2552-2564` (`_is_resp_ok`), `4269-4277` (`get_army_formation`), `4329-4334` (`sync_achievements`), `4891-4903` (`get_command_hall_tasks`)
- **السبب ونطاق التأثير:** `_is_resp_ok` لا يفحص `_ok is False` ولا `resp["data"]["err"]`؛ و`get_army_formation` يستخدم `resp.get("data") or resp` فيلوّث `armyCtrl` بمفاتيح الغلاف (`cmd`, `subcmd`, `err`, `_session`) عند أي خطأ أو `data={}`؛ و`sync_achievements`/`get_command_hall_tasks` يكتبان في `achievementctrl`/`commandHall` دون فحص `err == 0`.
- **التوصية المبدئية:** توحيد `_is_resp_ok` مع `core.game_client.is_query_success` وتقييد التحديثات الثلاثة به دون Fallback لغلاف `resp` الخارجي.

---

## 5. الأعطال المؤكدة في المهام الفردية (`tasks/*.py` — `T-01` – `T-45`)

> المهام التي **لا يوجد بها أي عطل مباشر في كودها**:
> - **`tasks/treasure.py`**: **سليمة 100%** (مباشراً وعبر `live_memory.py`).
> - **`tasks/merchant_ship.py`**: كودها سليم 100% — تتأثر فقط بغياب `NOTIFY_DAILYLOGIN_REWARD (18)` (`N-17`).
> - **`tasks/material_workshop.py`**: كودها سليم 100% — تتأثر فقط بـ `N-07` و`BT-04` و`C-05`.
> - **`tasks/command_hall.py`**: تتأثر عبر `base_task.py` و`live_memory.py` (`N-10`, `BT-02`, `BT-11`, `BT-12`).
> - **`tasks/skills.py`**: تتأثر عبر `base_task.py` و`live_memory.py` (`BT-03`, `BT-05`, `BT-06`, `BT-07`, `N-06`, `N-17`).
> - **`tasks/daily_train.py`**: قراءاتها لـ `everydayTaskCtrl` سليمة — ترث `T-18`/`T-19` من `tasks/train.py` (ولديها قراءة ميتة لـ `questCtrl["point_finish_list"]` في `L161`).

---

### 5.1 `tasks/port.py`
#### `T-01` — فحص `time` الثابت يتجاهل `isReceive` والعد التنازلي الزمني
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`timeRewardAuxiliary.lua:6-19`, `timeRewardCtrl.lua:84-95`, جميع اللقطات الخمس)
- **الموقع:** `tasks/port.py:31-38, 52-54` (يتكامل مع `N-04`)
- **السبب ونطاق التأثير:** `time` مجرد لقطة أولية للثواني المتبقية لا تتناقص مع الزمن؛ إذا بقيت `> 0` تتوقف المهمة للأبد (لأن `N-04` لا يصفّر `time`)، وإذا عادت `1033/2` بـ `isReceive == 1` دون `time > 0` فستضرب المهمة `1033/2` بلا توقف كل دورة (خطر حظر).
- **التوصية المبدئية:** اشتراط `int(tr_data.get("isReceive", 0)) == 2` أو تحقق `(receiveTime + duration[sequence]) <= time.time()` مع إصلاح `N-04`.

---

### 5.2 `tasks/imperial_mausoleum.py`
#### `T-02` — `_mark_completed_in_memory()` تمسح `award` عند فشل الاستلام وتصفّر `free=1` بعد استلام جائزة سابقة
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`pyramidCtrl.lua:178-217`, `tasks/imperial_mausoleum.py:111, 145-157, 178-189`)
- **الدليل والسيناريو:**
  1. عند نجاح الرمي (`1045/3`, `did_explore=True`) وفشل الاستلام (`1045/5` بـ `L153`)، يستدعي `L156-157` دالة `_mark_completed_in_memory()` التي تمسح `award={}` وتكتب `ev_info["26"]=1` وترجع `ok` -> تبقى الجائزة معلقة بالسيرفر وتعطّل الرمي المستقبلي!
  2. عند الدخول بجائزة قديمة معلقة + رمية مجانية جديدة (`free==1`)، يستلم `L144` الجائزة القديمة، يكتب `L150` بيانات السيرفر (`free=1`)، ثم `L157` يصفّر `free=0` فيضيّع الرمية المجانية! (بالإضافة إلى `N-15` لليوم الثاني).
- **التوصية المبدئية:** حفظ `award`/`free=0` عند نجاح `1045/3`؛ استدعاء `_update_local_memory` فقط عند نجاح `1045/5`؛ إعادة `fail` عند فشل الاستلام؛ وحذف تصفير `free` القسري من `_mark_completed_in_memory`.

---

### 5.3 `tasks/city_harvest.py`
#### `T-03` — توقف دائم عن حصاد المدينة بعد الدورة الأولى لغياب محاكاة التراكم الزمني
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`buildCell.lua:28-43`, `cityCtrl.lua:24-38, 1058`, `docs/live_cycle_log.txt`)
- **الموقع:** `tasks/city_harvest.py:58-63, 139-140`
- **السبب ونطاق التأثير:** السيرفر لا يدفع `curres` دورياً (0 إشعارات في 1,511 سطراً من اللوق)، بل العميل يراكم `totaloutput * dt / 3600` محلياً عبر `lastCalcuTime`. `city_harvest.py:139` يصفّر `curres="0"` ثم لا يستخدم `lastCalcuTime` أبداً في `can_run()` -> يتوقف الحصاد للأبد حتى إعادة الاتصال.
- **التوصية المبدئية:** حساب الإنتاج التقديري منذ `lastCalcuTime` (أو السماح بالحصاد عند مضي فاصل زمني محدد مثل 15–30 دقيقة منذ `lastCalcuTime`).

---

### 5.4 `tasks/watermill.py`
#### `T-04` — خصم ثلاثي (-3) من `backpackCtrl` لكل استخدام تعزيز واحد!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`cityCtrl.lua:1080-1095`, `core/live_memory.py:1727-1728, 1756-1767`)
- **الموقع:** `tasks/watermill.py:50-65, 245`
- **الدليل والسيناريو:** `NOTIFY_BACKPACK` يخصم `-1` قبل رجوع `1001/9`؛ ثم `_deduct_backpack_item` يلفّ على `("backpackCtrl", "bagCtrl")` (وهما **نفس الكائن بالذاكرة** بلا `id()` dedup!) فيخصم `-1` ثم `-1` = **-3 لكل عنصر مستخدم**. قلعة تملك 9 عناصر تعزيز و8 مناشر ستفقد 9 عناصر من الذاكرة بعد 3 مناشر فقط وتترك 5 مناشر بلا تعزيز!
- **التوصية المبدئية:** إزالة `_deduct_backpack_item` عند نجاح `1001/9` والاعتماد على `NOTIFY_BACKPACK`.

#### `T-05` — `_register_buff_in_memory` يفسد `buffCtrl == {}` (يُمسح عند أول `NOTIFY_BUFF`)
- **الخطورة واليقين:** `MEDIUM-HIGH` | **مؤكد 100%** (`sample_live_memory.json`, `core/live_memory.py:1914-1920`)
- **الموقع:** `tasks/watermill.py:112-125`
- **السبب ونطاق التأثير:** عندما يدخل الحساب بدون بافات يكون `buffCtrl == {}` (`sample_live_memory.json`). كتابة مفاتيح `buff_5022_...` داخل القاموس تُمسح بالكامل إلى `[]` في أول `NOTIFY_BUFF` (`live_memory.py:1919-1920`) فيعيد `watermill` إرسال `1001/9` لنفس المباني (`err=1017`).
- **التوصية المبدئية:** تحويل `init_data["buffCtrl"]` الفارغ `{}` إلى `list` قياسية عند الإدراج.

---

### 5.5 `tasks/shield.py`
#### `T-06` — القلعة لا تجدّد الدرع أبداً بعد انتهائه (خطر تصفير القلعة!)
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`cmdDef.lua:343`, `kingdomMapCell.lua:663-667`, `beetoo2_live_memory.json`, `beetoo3_live_memory.json`)
- **الموقع:** `tasks/shield.py:121-128, 147, 163`, `tasks/base_task.py:1778-1781`, `core/live_memory.py:733-853, 1937-1979`
- **الدليل المقارن:** `NOTIFY_WORLD_UPDATE ("2")` غير معالج (`N-17`)، و`_handle_notify_buff` لا يصفّر `isSafe` عند إغلاق `5003` (`N-06`)، و`base_task.is_shielded` يقرأ `kingdomMapCtrl["isSafe"]` فقط متجاهلاً `buffCtrl` (`id=5003`) و`conn.shield_expire_ts`. **دليل حي في `beetoo2_live_memory.json`:** يحتوي بالفعل على `kingdomMapCtrl.isSafe: True` بينما `buffCtrl` خالٍ من الدرع `5003`!
- **التوصية المبدئية:** معالجة `NOTIFY 2` و`closeBuff(5003)` في `live_memory.py` + فحص انتهاء باف `5003` و`shield_expire_ts` داخل `base_task.is_shielded`.

#### `T-07` — تعديل الذاكرة وتعيين `isSafe = True` عند انتهاء المهلة / `None` (`or not r_use` / `or not r_buy`)!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`tasks/shield.py:211-225, 256-267`, `tasks/base_task.py:4398`)
- **الدليل:** `err_code = str(r_use.get("err", "0")) if isinstance(r_use, dict) else "0"` متبوعاً بـ `if err_code in ("0", "Err_None", "None") or not r_use:` — أي Timeout (`None`) يفعّل `isSafe=True` ويرجع `ok` فتبقى القلعة مكشوفة تماماً!
- **التوصية المبدئية:** اشتراط `isinstance(r, dict) and str(r.get("err", "-1")) == "0"` بصرامة.

#### `T-08` — خصم مزدوج للدرع من الحقيبة (`1004/2`) وللذهب (`1034/2`)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`backpackCtrl.lua:449-453`, `shopCtrl.lua:387-494`, `live_cycle_log.txt:920-934`)
- **الموقع:** `tasks/shield.py:218-224, 263-266`
- **السبب ونطاق التأثير:** `NOTIFY_BACKPACK` يخصم `-1` ثم `L224` يمسح آخر درع متبقٍ بالذاكرة فيضطر البوت للشراء بالذهب رغم توفر درع مجاني؛ وفي `1034/2` يُخصم الذهب مرتين.
- **التوصية المبدئية:** إزالة الخصم اليدوي للحقيبة والذهب والاعتماد على `NOTIFY_BACKPACK` و`NOTIFY_LORD`.

---

### 5.6 `tasks/building.py`
*(التحديث المحلي لطابور `1200`/`1201` و`state="2"` عند `1001/2` و`1001/3` سليم وضروري لأن `queueCtrl.lua:252` تستثني طوابير البناء من `NOTIFY_QUEUE`.)*

#### `T-09` — خصم مزدوج للموارد في `sync_in_memory_upgrade` بعد `NOTIFY_CITY`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`cityCtrl.lua:846-912`, `docs/live_cycle_log.txt:11-23`)
- **الموقع:** `tasks/building.py:670-680`
- **السبب ونطاق التأثير:** يصل إشعارا `NOTIFY_CITY` قبل رجوع `1001/3`، ثم يخصم الكود الموارد مرة ثانية -> عجز وهمي وفتح صناديق بلا داعٍ عبر `ensure_resources`.
- **التوصية المبدئية:** إزالة الكتلة `L670-680`.

#### `T-10` — خصم مزدوج لأدوات التسريع عند `err == "0"` وخصم وهمي عند `err == "1010"` (`Err_QUEUE_NOT_FOUND`)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`queueCtrl.lua:49-75`, `errDef.lua:34`)
- **الموقع:** `tasks/building.py:747-760, 1390-1393`
- **السبب ونطاق التأثير:** `NOTIFY_BACKPACK` يخصم التسريعات عند `err=="0"`، والسيرفر لا يخصم شيئاً عند `1010`؛ استدعاء `sync_in_memory_consumed_items` في الحالتين يفرّغ مخزون التسريعات بالذاكرة بسرعة.
- **التوصية المبدئية:** إزالة استدعاء `sync_in_memory_consumed_items` عند `L1392`.

#### `T-11` — انتهاء طابور البناء طبيعياً يحذف الطابور ويترك المبنى عالقاً على `state == "2"` للأبد دون زيادة `lv`!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`queueCtrl.lua:252`, `cityCtrl.lua:39-57`)
- **الموقع:** `tasks/building.py:499-501` (و`535`)
- **السبب ونطاق التأثير:** `q_ctrl.pop(str(qtype), None)` بدون استدعاء `sync_in_memory_completed_queue` يجمّد `state="2"` والمستوى القديم -> يعطّل سلسلة ترقية القلعة ومتطلباتها نهائياً حتى إعادة الاتصال.
- **التوصية المبدئية:** استدعاء `sync_in_memory_completed_queue(qtype, bid, lv or None, index=idx, iid=iid)` قبل حذف الطابور المنتهي.

#### `T-12` — إغفال مفتاح `iid` الحقيقي في `queueCtrl["1200"]["data"]` وتثبيت `"iid": "0"`
- **الخطورة واليقين:** `MEDIUM-HIGH` | **مؤكد 100%** (`docs/beetoo2_live_memory.json`, `cityCtrl.lua:43-48, 563`)
- **الموقع:** `tasks/building.py:486-498, 640, 655, 726-738, 1475-1478`
- **السبب ونطاق التأثير:** طابور السيرفر في `beetoo2` يحتوي `{"iid": "3", "bid": "203", ...}` بلا مفتاح `"index"`. مما يحجب الطابور الثاني عن باقي نسخ المبنى (`L1476`) وقد يحدّث النسخة الخطأ عند الاكتمال (`L731`) ويعطي المباني الجديدة `"iid": "0"`.
- **التوصية المبدئية:** استخراج وتمرير `iid` إلى جانب `index` وحساب `max(iid)+1` للمباني الخارجية الجديدة (`bid >= 200`).

#### `T-13` — التسريع الجزئي (`1003/2 mode "2"`) لا يحدّث `init_data["queueCtrl"][qtype]`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`queueCtrl.lua:62-67`, `tasks/building.py:1410-1414, 1592`)
- **السبب ونطاق التأثير:** يُحدَّث `self.active_queues` المؤقت فقط؛ أول نداء تالٍ لـ `refresh_active_queues()` (حتى في `L1592` بنفس الدورة) ينسى كامل وقت التسريع.
- **التوصية المبدئية:** إنقاص `totaltime` (أو إزاحة `starttime`) في `init_data["queueCtrl"][qtype]` بمقدار `total_reduction`.

---

### 5.7 `tasks/research.py`
#### `T-14` — طمس موارد `NOTIFY_CITY` بلقطة قديمة مطروحاً منها التكلفة الأساسية غير المخفضة
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`technologyCtrl.lua:242-270`, `docs/live_cycle_log.txt:31-37`)
- **الموقع:** `tasks/research.py:373, 430-437`
- **التوصية المبدئية:** حذف `L430-437` والاعتماد على `NOTIFY_CITY`.

#### `T-15` — كتابة `technologyCtrl[tech_id] = [tech_id, target_lv]` عند بدء البحث قبل اكتماله!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`technologyCtrl.lua:99-106, 255`, `docs/beetoo2_live_memory.json`)
- **الموقع:** `tasks/research.py:426-428`
- **السبب ونطاق التأثير:** يُسجّل البحث كمكتمل فور بدئه -> يضخّم `march_capacity.py` ويُفسد شجرة المتطلبات لو أُلغي البحث.
- **التوصية المبدئية:** نقل تحديث `technologyCtrl` إلى لحظة اكتمال طابور `1212` أو معالج `NOTIFY_TECHNOLOGY (494)`.

#### `T-16` — كتابة مدة JSON الأساسية غير المخفضة في `queueCtrl["1212"]["totaltime"]` (مع غياب `NOTIFY_TECHNOLOGY 494`)
- **الخطورة واليقين:** `MEDIUM-HIGH` | **مؤكد 100%** (`core/technology_rules.json` vs `beetoo2_live_memory.json` `46800` vs `45658`, `technologyCtrl.lua:250-260`)
- **الموقع:** `tasks/research.py:418-424` (مع `N-17`)
- **التوصية المبدئية:** قراءة `totaltime`/`lefttime` الفعلي من رد `1017/2` وإضافة معالج `NOTIFY 494`.

#### `T-17` — `_get_guide_quest_tech()` يقرأ حقولاً غير موجودة في `questCtrl["guideQuest"]`
- **الخطورة واليقين:** `LOW-MEDIUM` | **مؤكد 100%** (جميع اللقطات الخمس: `guideQuest` يحوي `{aim, status, questID, progress}` فقط)
- **الموقع:** `tasks/research.py:228-236`
- **التوصية المبدئية:** ترجمة `questID` عبر جدول مهام اللعبة الثابت أو إزالة القراءة الميتة.

---

### 5.8 `tasks/train.py` (وتأثيره المباشر على `tasks/daily_train.py`)
#### `T-18` — استخراج `resp["data"]` بدل `resp["data"]["retdata"]` بعد `1005/2` -> إفساد ثلاثي (مدة `1800s` + طمس `_handle_cmd_1005` + خصم موارد مزدوج!)
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`armyCtrl.lua:661-666`, `core/live_memory.py:1149, 1175-1199`, `docs/live_cycle_log.txt:792-840`)
- **الموقع:** `tasks/train.py:272, 306-315, 339-354, 813-818` (موروث في `tasks/daily_train.py:247, 319`)
- **الدليل والسيناريو:** `resp.get("retdata")` دائماً `None` لأن المسار الحقيقي `resp["data"]["retdata"]` -> يسقط `L816` إلى `resp["data"]` فتفشل `ret.get("totaltime")` وتثبّت **`1800s`** (تسبّب إرسال `1005/5` مبكراً كل دورة للتدريبات الطويلة 10–14 ساعة [خطر حظر]، وتجمّد الثكنات 30 دقيقة لتدريب `daily_train` أبو 5 دقائق!)، وتطمس القيم الحقيقية من `_handle_cmd_1005`، وتدخل دائماً فرع `else:` (`L348-353`) فتخصم الموارد مرتين بعد `NOTIFY_CITY`!
- **التوصية المبدئية:** استخراج `(resp.get("data") or {}).get("retdata") or resp.get("retdata") or {}` وإزالة الخصم التقديري `L348-353` والكتابة الاصطناعية في `trainArmy` (`L301-315`).

#### `T-19` — تلويث `queueCtrl["queues"]` وكسر الترادف مع `local_queues`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`core/live_memory.py:713-716, 2135-2139`, `tasks/train.py:294-299, 379-383`)
- **التوصية المبدئية:** حذف لمس `queueCtrl["queues"]` نهائياً والاقتصار على `queueCtrl[qtype]` (`"1203".."1207"`).

#### `T-20` — قراءة `buffCtrl` كـ `dict` بمفاتيح `"322"/"318"` وقراءة `boeAttributeCtrl` الغائب
- **الخطورة واليقين:** `LOW-MEDIUM` | **مؤكد 100%** (جميع اللقطات الخمس)
- **الموقع:** `tasks/train.py:626-654`
- **التوصية المبدئية:** قراءة `buffCtrl` كـ `list` بمطابقة `buffID`/`effectType`.

---

### 5.9 `tasks/cure_wounded.py`
#### `T-21` — تعديل موضعي لـ `queueCtrl["queues"]` يحقن `1202` داخل `init_data["local_queues"]` *(مفصّل في `M-18`)*
- **الموقع:** `tasks/cure_wounded.py:186-205`. **التوصية:** حذف `L185-205` نهائياً.

#### `T-22` — كتابة `"startTime"` بدل `"starttime"` في `queueCtrl["1202"]` تجمّد ترقية المستشفى (`206`) للأبد في `BuildingTask`!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`queueCtrl.lua:116`, `beetoo2_live_memory.json`, `tasks/building.py:392-398`)
- **الموقع:** `tasks/cure_wounded.py:207-212`
- **الدليل والسيناريو:** `building.py:394` يقرأ `q_info.get("starttime", 0)` فيحصل على `0.0` ويسقط إلى `totaltime > 0` الذي لا يتناقص أبداً -> `is_building_busy_with_activity("206")` يرجع `True` للأبد!
- **التوصية المبدئية:** استخدام المفاتيح القياسية `"starttime"`, `"totaltime"`, `"ottime"`, `"qtype": "1202"`.

#### `T-23` — خصم مزدوج لـ `armyCtrl["woundedArmy"]` بعد `NOTIFY_ARMY (15)`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`armyCtrl.lua:889-948, 1061-1064`, `core/live_memory.py:1780-1806`)
- **الموقع:** `tasks/cure_wounded.py:416-424` (مع `C-04` لـ `_handle_cmd_1005`)
- **السبب ونطاق التأثير:** عند العلاج الجزئي (وضع `daily` أو نقص موارد)، يحدّث `NOTIFY_ARMY` المصابين ثم تخصم `L420` نفس الدفعة ثانيةً (أو تحذفهم بـ `pop`) فتبقى جنود مصابة غير معالجة بالمستشفى (خطر امتلاء المستشفى وموت الجنود).
- **التوصية المبدئية:** حذف `L416-424` والاعتماد على `NOTIFY_ARMY` (مع التحقق `V-05`).

---

### 5.10 `tasks/arena.py`
*(تحديث `rewards = []` و`remainTimes`/`myRank` عند `err=="0"` سليم ومطابق لـ `arenaCtrl.lua:297, 335-341`؛ العطل الموروث الأهم هو غياب `NOTIFY_ARENA 1007` في `N-17`.)*

#### `T-24` — زيادة مزدوجة لـ `everydayTaskCtrl.eventInfo["30"]` بعد `NOTIFY_EVERYDAY_TASK`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (إثبات مباشر في `docs/live_cycle_log.txt:868-883`)
- **الموقع:** `tasks/arena.py:389` (`self.record_daily_quest_event(30, 1)`)
- **الدليل والسيناريو:** `NOTIFY_EVERYDAY_TASK` يصل عند `L878-881` قبل عودة `2056/6 ✅` عند `L883` -> النزال الأول يسجّل `2/3` والنزال الثاني يسجّل `3/3` فيتخطى البوت النزال الثالث ويُضخّم نقاط النشاط اليومي (`err=470002` في `daily_quest`).
- **التوصية المبدئية:** إزالة `self.record_daily_quest_event(30, 1)` من `arena.py:389`.

---

### 5.11 `tasks/hero_trial.py`
#### `T-25` — يكتب `eventInfo["25"] = 1` ويعيد `TaskResult.ok()` حتى عند أخطاء السيرفر والاستثناءات!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`tasks/hero_trial.py:225-237, 267-285`, `docs/live_cycle_log.txt:904-910`)
- **السبب ونطاق التأثير:** عند `ERR_HT_SOLDIER_NOT_ENOUGH (35010)` أو Timeout أو أي خطأ أو استثناء، يسجّل إتمام المهمة اليومية (`+20` نقطة وهمية -> يسبب `470002` في `daily_quest`) ويمنع إعادة المحاولة طوال اليوم!
- **التوصية المبدئية:** إزالة `_sync_task_completion_in_memory` من جميع فروع الخطأ والاستثناءات (`L227, L231, L236`) وإعادة `TaskResult.fail(...)` والاعتماد على `NOTIFY_EVERYDAY_TASK` عند النجاح.

#### `T-26` — قراءة مفتاح غير موجود `armyCtrl["armys"]` بدل `armyCtrl["totalArmy"]`
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (جميع اللقطات الخمس + `armyCtrl.lua:64-77`)
- **الموقع:** `tasks/hero_trial.py:256-265`
- **السبب ونطاق التأثير:** عند غياب `battle_data["soldiers"]` يسقط دائماً إلى جندي مشاة T1 (`401`) -> يفشل بـ `35010` على كل قلعة لا تملك T1 مشاة (ثم يُشغّل `T-25`!).
- **التوصية المبدئية:** قراءة `army_ctrl.get("totalArmy")` (مع استبعاد المصائد `801..899`).

#### `T-27` — قراءة `htData` و`exaltedPrivilegeCtrl` المسقطين + مخطط `privileges["56"]` الوهمي
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`core/live_memory.py:55-142`, `exaltedPrivilegeCtrl.lua:25-26, 168-200`, `docs/live_cycle_log.txt:898`)
- **الموقع:** `tasks/hero_trial.py:93, 145-149` (مع `C-01` و`N-17` لـ `NOTIFY_HERO_TRIAL 37`)
- **التوصية المبدئية:** إضافة `htData` إلى `ALLOWED_CONTROLLERS` ومعالجة `NOTIFY 37`، وتصحيح فحص الامتياز أو إزالة الكود الميت `privileges["56"]`.

---

### 5.12 `tasks/flower.py`
#### `T-28` — طمس المفاتيح الثلاثة للزهور في `backpackCtrl` بلقطة قديمة ما قبل الحلقة
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`flowerSysCtrl.lua:67-79`, `docs/live_cycle_log.txt:46-50, 1448`, `core/live_memory.py:1731-1773`)
- **الموقع:** `tasks/flower.py:470-477`
- **السبب ونطاق التأثير:** أي إضافة/استهلاك متزامن للزهور عبر `NOTIFY_BACKPACK` أثناء الحلقة يُمسح ويُستبدل باللقطة القديمة فتتشوّه أرصدة الحقيبة الدلتا طوال الجلسة.
- **التوصية المبدئية:** حذف `L470-477` والاعتماد على `NOTIFY_BACKPACK`.

#### `T-29` — سباق الزيادة المزدوجة على `everydayTaskCtrl.eventInfo["8"]` في الإرسال متعدد الدفعات
- **الخطورة واليقين:** `LOW-MEDIUM` | **مؤكد 100%** (`core/game_client.py:1888-1908`, `tasks/flower.py:427-434`)
- **السبب ونطاق التأثير:** جمع نسبي `+ total_flowers_in_batch` بعد وصول `NOTIFY_EVERYDAY_TASK` قد يقفز بالعدّاد إلى `10/10` مبكراً بعد الدفعة الأولى.
- **التوصية المبدئية:** استخدام `max(current, updated_daily)` أو الاعتماد على `NOTIFY_EVERYDAY_TASK`.

---

### 5.13 `tasks/wonder_merchant.py`
*(العطل الحرج الأكبر موروث من `N-08`: `NOTIFY_SHOP 23` يمسح `storesCtrl` بالكامل!)*

#### `T-30` — الشراء العاشر يتخطى إحلال `newShopItem` + حقن كائن ناقص `{"pricetype": 1001}`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`storesCtrl.lua:68-76`, `tasks/wonder_merchant.py:151-165`)
- **السبب ونطاق التأثير:** `if purchases_today >= 10: break` قبل `slots[idx] = new_shop_item` يبقي الصنف المشترى بالذاكرة، و`L164` يحقن كائناً مصطنعاً ناقص الحقول.
- **التوصية المبدئية:** إحلال `new_shop_item` قبل شرط `break` وعدم كتابة `{"pricetype": 1001}` عند غياب البديل.

#### `T-31` — مرجع `event_info` منفصل بعد أول `NOTIFY_EVERYDAY_TASK` داخل الحلقة
- **الخطورة واليقين:** `LOW` | **مؤكد 100%** (`core/live_memory.py:2196`, `tasks/wonder_merchant.py:96-97, 145`)
- **التوصية المبدئية:** إعادة قراءة `daily_ctrl.setdefault("eventInfo", {})` داخل الحلقة أو الاعتماد على `NOTIFY 55`.

---

### 5.14 `tasks/material_synthesis.py`
#### `T-32` — خصم مزدوج `-4` وإضافة مزدوجة `+1` في `backpackCtrl` (مثبت حياً باللوق!)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`equipmentCtrl.lua:1434-1442`, `core/live_memory.py:1731-1773` + **إثبات مباشر في `docs/live_cycle_log.txt:249-268`**)
- **الموقع:** `tasks/material_synthesis.py:220-232`
- **الدليل الحي:** `#200101` بدأ عند `455` (`L249`) -> `NOTIFY_BACKPACK` خفّضه إلى `451` قبل عودة `1047/10` (`L251-260`) -> ثم خصمت `L226` أربعة ثانيةً ليصبح `447` -> والمهمة التالية (`2021/4`, `L266-268`) أضافت `+1` فأصبح **`448`** بدل رصيد السيرفر الحقيقي **`452`**!
- **التوصية المبدئية:** حذف `L220-232` نهائياً.

---

### 5.15 `tasks/forge_equipment.py`
*(التحديث المحلي لطابور `1229` وحذف `base_epid` وإضافة القطعة المستلمة في `L545-556, 728-761` سليم من حيث المبدأ بعد تصحيح `isCle`.)*

#### `T-33` — خصم مزدوج للمواد والصلب غير المخفض بعد `1047/1` (مثبت حياً باللوق!)
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`equipmentCtrl.lua:999-1039` + **إثبات مباشر في `docs/live_cycle_log.txt:294-311`**)
- **الموقع:** `tasks/forge_equipment.py:702-722`
- **الدليل الحي:** قبل عودة `1047/1` (`L310`) وصل `NOTIFY_BACKPACK` (`#200301=235, #200601=222`) و`NOTIFY_CITY` (خصم `920` صلب بعد باف الحدادة لا `1,000`)، ثم خصمت `L705-722` `-1` من المادتين و`-1,000` صلب مرة ثانية!
- **التوصية المبدئية:** حذف `L702-722` والاعتماد على `NOTIFY_BACKPACK` و`NOTIFY_CITY`.

#### `T-34` — `_ensure_steel_balance` تعدّل `backpackCtrl` و`cityCtrl` بلا فحص `err == 0` وتضاعف خصم الصناديق عند النجاح
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`backpackCtrl.lua:54-75`, `tasks/forge_equipment.py:286-302`)
- **التوصية المبدئية:** فحص `err == "0"` وإزالة التعديل اليدوي `L295-302` وإعادة قراءة `_get_current_steel()`.

#### `T-35` — كتابة مفتاح وهمي `questCtrl["point_finish_list"]` لا يُصفَّر بمنتصف الليل -> تعطيل دائم لـ `forge_equipment` بدءاً من اليوم الثاني!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (0 ظهورات لـ `point_finish_list` في `game_file/src/` وكل اللقطات الخمس)
- **الموقع:** `tasks/forge_equipment.py:156-161, 564-568`
- **التوصية المبدئية:** حذف `L156-161` و`L564-568` نهائياً والاعتماد على `everydayTaskCtrl.eventInfo["9"]`.

#### `T-36` — كتابة `fe.isCle = 1` (المقلوب) عند بدء الحدادة وفحص `fe.endTime` الخاطئ
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`equipmentCell.lua:352-357`, `beetoo2_live_memory.json` + مع عطل `N-12`)
- **الموقع:** `tasks/forge_equipment.py:441-445, 495-499, 740-747`
- **السبب:** `isCle == 1` يعني **اكتمل التصنيع** (`0` = قيد التصنيع)، و`endTime` لصلاحية العتاد المؤقت لا لزمن الحدادة.
- **التوصية المبدئية:** كتابة `"isCle": 0` عند بدء `1047/1`، وفحص `fe.get("isCle") == 0` مع `queueCtrl["1229"]` وإصلاح `N-12`.

---

### 5.16 `tasks/alliance.py`
*(تحديث `helplist` في `L182-184`، `allianceTreasureCtrl` في `L265`، و`minfo` في `L442-445` سليم ومطابق لـ Lua.)*

#### `T-37` — إهمال مزامنة `nextFreeDigTime`/`treasureInfo`/`digListInfo` بعد `2015/3` -> **خطر صرف 50 ذهب صامتاً!**
- **الخطورة واليقين:** `CRITICAL` (خرق قاعدة حماية الذهب!) | **مؤكد 100%** (`allianceTreasureCtrl.lua:75-79, 158-170, 546-559`, `beetoo1_live_memory.json`, `docs/live_cycle_log.txt:319-326`)
- **الموقع:** `tasks/alliance.py:307-328`
- **الدليل والسيناريو:** الحفر المجاني والحفر بـ **50 ذهب** يستخدمان **نفس الأمر `2015/3 {"index": box_idx}`**، ولا يرسل السيرفر `NOTIFY_ALLIANCE_TREASURE` بعد `2015/3` (`live_cycle_log.txt:319-326`). `L325` يزيد `digCount` فقط ويترك `nextFreeDigTime == 0` -> في الدورة التالية يرى `is_free == True` فيرسل `2015/3` أثناء تبريد المجاني فيخصم السيرفر **50 ذهباً** صامتاً!
- **التوصية المبدئية:** تطبيق `rspdata["otherInfo"]` و`removeIndex` و`newDigInfo` فور نجاح `2015/3` مطابقاً لـ `allianceTreasureCtrl.lua:163-169`.

#### `T-38` — `2015/6` لا يحذف العنصر المستلم من `helpInfo` و`digListInfo` -> يُعطّل مساعدة الأعضاء (الخطوة 6) للأبد!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`allianceTreasureCtrl.lua:222-230, 534-545`)
- **الموقع:** `tasks/alliance.py:272-302, 340-343`
- **السبب:** تعيين `item["canReceive"] = False` يبقي العنصر في `helpInfo` بـ `isHelped=True, canReceive=False` فتُرجع `L340-343` `is_already_helping == True` دائماً وتمنع مساعدة الأعضاء! كما يُبقي الكنز المستلم في `digListInfo` فتُرسل الخطوة 3 طلب `2015/4` لکنز محذوف.
- **التوصية المبدئية:** حذف العنصر المستلم من `digListInfo` (نوع 1) ومن `helpInfo` و`canHelpList` (نوع 2) مطابقاً لـ Lua.

#### `T-39` — `2015/5` (مساعدة عضو) لا يزامن `canHelpList`/`helpInfo`/`otherInfo`
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`allianceTreasureCtrl.lua:187-194`)
- **الموقع:** `tasks/alliance.py:365-369`
- **السبب:** يعيد البوت محاولة مساعدة نفس العضو/الصندوق في الدورة التالية فتُرفض (`ALREADY_HELPED` / `PLEASE_RECEIVE_FIRST`).
- **التوصية المبدئية:** تحديث `canHelpList` وإضافة `newHelpInfo` إلى `helpInfo` واستبدال `otherInfo` من `r_help["rspdata"]`.

#### `T-40` — سباق الزيادة المزدوجة على `eventInfo["18"]` بعد `1010/47` + سقف `20` بدل `40`
- **الخطورة واليقين:** `LOW-MEDIUM` | **مؤكد 100%** (`daily_reward_point_config.lua:138-145`: `limitTime = 40`)
- **الموقع:** `tasks/alliance.py:31, 225-229`
- **التوصية المبدئية:** الاعتماد على `NOTIFY_EVERYDAY_TASK` بدل الجمع النسبي `+ pending_helps` ومواءمة السقف مع `40`.

---

### 5.17 `tasks/war_medal.py`
#### `T-41` — الفحص المسبق يتجاهل تصاعد التكلفة في `badgeExchangeCtrl["curExchangeNumMap"]["1"]` (مثبت حياً باللوق!)
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`badge_exchange.lua:1-40`, `beetoo1`/`beetoo3`/`lucifer_live_memory.json` + **إثبات مباشر في `docs/live_cycle_log.txt:329-339`**)
- **الموقع:** `tasks/war_medal.py:21-26, 49-60`
- **الدليل الحي:** التكلفة تتضاعف حسب `num = curExchangeNumMap["1"] + 1` (350k -> 700k -> 1,050k). في `live_cycle_log.txt:329-339` فحصت المهمة `350,000` قمح بينما خصم السيرفر فعلياً **`1,050,000` قمح** (`3x`)! لو كان الرصيد بين `350k` و`1,050k` لفشل الطلب بـ `err=2`.
- **التوصية المبدئية:** قراءة `curExchangeNumMap["1"]` وتطبيق جدول شرائح التكلفة قبل الفحص، وتحديث `curExchangeNumMap` من رد `1067/2` عند النجاح (مع إصلاح `N-14`).

---

### 5.18 `tasks/pet.py`
*(تحديث `QUEUE_KEY_PET_SPECIAL_SKILL` في `L255-264` وزيادة `curFreeFeed` عند `err=="0"` في `L321-323` سليمان لأن السيرفر لا يرسل `NOTIFY_PET` عليهما كما ثبت في `live_cycle_log.txt:440-455`؛ والعطل الحرج الموروث هو `N-09`.)*

#### `T-42` — إجبار `feedInfo["curFreeFeed"] = 2` عند أي خطأ غير صفري من السيرفر
- **الخطورة واليقين:** `MEDIUM` | **مؤكد 100%** (`tasks/pet.py:162-164, 315-319`)
- **السبب:** أي خطأ مؤقت (`err=1` أو `13` أو وصول حيوان لأقصى مستوى) يعطّل الإطعام المجاني لبقية الجلسة.
- **التوصية المبدئية:** حصر تعيين `curFreeFeed = MAX_FREE_FEED` بكود "استنفاد الإطعام المجاني" فقط، والاكتفاء بـ `break` في بقية الأخطاء.

---

### 5.19 `tasks/stamina.py`
#### `T-43` — تعديل الذاكرة (`backpackCtrl`, `health`, `gold`) عند Timeout / `None` (`or not r` / `or not r_buy`)!
- **الخطورة واليقين:** `CRITICAL` | **مؤكد 100%** (`tasks/stamina.py:163-168, 207-212`, `tasks/base_task.py:4398`)
- **السبب:** عند `None` يحذف حزم الطاقة غير المستخدمة ويضيف طاقة وهمية ويخصم ذهباً وهمياً ويعيد `ok`!
- **التوصية المبدئية:** اشتراط `isinstance(r, dict) and str(r.get("err", "-1")) in ("0", "Err_None")` وحذف `or not r`/`or not r_buy`.

#### `T-44` — إضافة مزدوجة لـ `base.health`، وخصم مزدوج وحذف مبكّر لـ `backpackCtrl` (`1004/2`)، وخصم مزدوج للذهب (`1034/2`) — مثبت حياً باللوق!
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`backpackCtrl.lua:54-75`, `shopCtrl.lua:387-494` + **إثبات مباشر في `docs/live_cycle_log.txt:917-946`**)
- **الموقع:** `tasks/stamina.py:39-73, 166-168, 211-212`
- **الدليل الحي:** عند `L920-932` وصل `NOTIFY_LORD` (`health=26,685`) و`NOTIFY_BACKPACK` (`#300401=0`) **قبل** عودة `1004/2` (`L934`)، ثم أضاف `stamina.py` `+10` ثانيةً فأصبحت الطاقة `26,695` (`L938`) بينما السيرفر كان `26,685` (`L945`). ومع دفعات متعددة (مثلاً 15 حزمة بدفعة 10) يخفض `NOTIFY_BACKPACK` الرصيد `15 -> 5` ثم يرى `_deduct_backpack_item` `5 <= 10` فينفّذ **`backpack.pop(...)` ويمسح الـ 5 حزم المتبقية!**
- **التوصية المبدئية:** إزالة `_deduct_backpack_item`, `_add_stamina`, `_deduct_gold` والاعتماد على `NOTIFY_BACKPACK` و`NOTIFY_LORD`.

---

### 5.20 `tasks/daily_quest.py`
*(قراءات وتحديثات `everydayTaskCtrl` و`normalRecord` والـ 33 قاعدة واستلام المهام `_sync_quest_memory_after_commit` سليمة 100% ومطابقة لـ `questCtrl.lua` و`daily_reward_point_config.lua`.)*

#### `T-45` — ترقيع `_apply_pending_quest_notify_patch` يفقد التحديثات المتعددة ولا يغطي `oQuestArray` ويترك بقايا في الجذر
- **الخطورة واليقين:** `HIGH` | **مؤكد 100%** (`questCtrl.lua:214-248`, `tasks/daily_quest.py:434-464`, `live_cycle_log.txt:306-309` + اختبار Python جاف)
- **التوصية المبدئية:** إصلاح `N-13` في `core/live_memory.py` (معالج `_handle_notify_quest` للأنواع الـ 7) ثم حذف الترقيع الجزئي في `daily_quest.py`.

---

## 6. قسم مستقل: عناصر تحتاج تحققاً ميدانياً (`NEEDS_VERIFICATION`)

> **ملاحظة صارمة:** العناصر التالية لا يمكن إثبات سلوك السيرفر الكامل فيها بنسبة 100% من كود العميل المُفكّك (`game_file/src/`) واللقطات المتاحة وحدها. كل عنصر مرفق بخطوات تحقق ميداني محددة عبر التقاط حزم حية (باستخدام أدوات `tools/`).

| المعرّف | الملف / الموقع | السؤال المفتوح وسبب الحاجة للتحقق | خطوات التحقق الميداني |
|---|---|---|---|
| `V-01` | `tasks/port.py:36, 52-54` | هل رد `1033/2` عند `isReceive == 1` يحتوي على مفتاح `"time" > 0` في الجذر أم يحذفه/يرسله `0` (معتمداً على `timereward[sequence].time`)؟ يحدد ما إذا كان `T-01` يسبّب تكراراً فورياً لـ `1033/2` أم تجمّداً دائماً. | التقاط الرد الخام لحزمة `CMD 1033 / SUBCMD 2` وحزمة `NOTIFY_TIME_REWARD (16)` التي تليها على حساب بسفينة جاهزة. |
| `V-02` | `tasks/city_harvest.py:146-150` | `cityCtrl.lua:1055-1072` تقرأ `content.data.drop` فقط عند `1001/8`؛ هل يُرجع السيرفر `"resList"` داخل `r["data"]` أصلاً؟ (إذا أرجعها، فالسطر `150` يكسر الترادف مع `cityCtrl["resList"]`). | فحص حزمة الرد الخام لـ `CMD 1001 / SUBCMD 8` لحصاد مبنى واحد. |
| `V-03` | `tasks/watermill.py:246` | هل يدفع السيرفر دائماً `NOTIFY_BUFF (openBuff)` قبل رجوع `1001/9 (mode=1)`؟ إذا نعم فاستدعاء `_register_buff_in_memory` عند `err=="0"` يطمس `beginTime` السيرفر الحقيقي ويجب حصره بحالة `err=="1017"` فقط. | التقاط تسلسل الحزم حول `1001/9` لمزرعة غير معززة (`NOTIFY_BACKPACK`, `NOTIFY_BUFF`, رد `1001/9`). |
| `V-04` | `tasks/shield.py` + `base_task.py:1778` | البنية الدقيقة لحزمة `NOTIFY_WORLD_UPDATE ("2")` عند تفعيل/انتهاء/انكسار الدرع (`wordMsgType == protectStatus`)، وترتيب `NOTIFY_LORD` و`NOTIFY_BUFF` عند `1034/2 (use=True)`. | تسجيل الحزم الخام الواردة عند تفعيل درع 8 ساعات عبر `1004/2` وعند انتهائه أو كسره. |
| `V-05` | `tasks/cure_wounded.py:416-431` | ترتيب وصول `NOTIFY_ARMY (15)` و`NOTIFY_CITY (9)` بالنسبة لرد `1005/4` (`REQ_CURE_WOUNDED_ARMY`) وهل يحتوي رد `1005/4` نفسه على `data.armyInfo` أو `retdata.costres`. | تنفيذ `CureWoundedTask` على علاج جزئي مع تسجيل الحزم الخام قبل وفي رد `1005/4`. |
| `V-06` | `tasks/pet.py:258-264, 327-330` + `N-09` | ملف `game_file/src/app/module/pet/petCtrl.lua` مقطوع عند السطر 452؛ يلزم تأكيد المسار الدقيق لـ `starttime`/`totaltime` في رد `2036/4` و`petInfo` في `2036/2` وبنية حمولة `NOTIFY_PET (65)` (دمج أم استبدال أم `notifyType`). | تسجيل الردود الخام لـ `2036/4` و`2036/2` وحزمة `cmd=1009, notifyID=65` عبر منتصف الليل UTC. |
| `V-07` | `tasks/base_task.py:1688-1698` | سباق `record_daily_quest_event` مع `NOTIFY_EVERYDAY_TASK (55)` في أي مستدعين مستقبليين (ثبت بالفعل في `arena.py` `T-24`؛ يُتحقق من عدم وجود استدعاءات أخرى تسبق أو تلحق `NOTIFY 55`). | مراجعة ترتيب `NOTIFY 55` مع أي RPC يستدعي `record_daily_quest_event`. |
| `V-08` | `tasks/base_task.py:2591-2597` (`BT-05`) | بعد تغيير `{"setID": str(target_set)}`، التأكد ميدانياً على حساب VIP نشط >= 9 أن `1002/23` يعود بـ `err=="0"` (ونفي وجود أي قيد ثانوي مثل مسيرة نشطة تمنع التبديل)، والتأكد من عدم تأثر أي قارئ لـ `activeSetID` بكونه نصاً `"2"`. | تجربة `1002/23` بـ `"setID": "2"` على حساب VIP >= 9 نشط. |
| `V-09` | `tasks/march_capacity.py` + `march_manager.py:2287` | هل يمنح السيرفر سعة مسيرة إضافية لأبطال الدفاع عن السور (`state=5`)؟ `WorldDispatchArmyViewPanel.lua:1823` يستدعي `getHerosMarchCapacity(heroInfo, true)` (يشترط `state=1`) بينما `L1380` يسمح بإرسال `state=5`، والمشروع يمرر `only_normal_state=False`. | إرسال `1007/2` ببطل سور بملء `base_cap + defend_hero_add` ومراقبة قبول أو رفض السيرفر. |
| `V-10` | `tasks/escort_treasure.py` + `core/live_memory.py:787-792` | الصيغة الخام لـ `NOTIFY_ESCORT (49)` و`NOTIFY_ESCORT_CART (50)`، وهل يرسل السيرفر `RESET_ESCORT_COUNT (type=2)` فوراً بعد إرسال قافلة `1007/2` (حيث لا تحدّث `escort_treasure.py` عدّاد `escortCount` ولا `closestBuild` محلياً؛ كما تمنح `escortDataMgr.lua:48-55` +1 لـ VIP 19+). | التقاط حزم `1009` الخام أثناء دورة `1078/2 -> 1075/1 -> 1007/2` كاملة. |
| `V-11` | `tasks/march_manager.py:1488-1493` | `findMonsterCtrl.lua:22-35` يرسل `posx`/`posy` مع `CMD 2083/9` (وحوش السديم `mapType=56`) بينما `march_manager.py` يحذفهما. هل يقبل السيرفر بدونهما أم يبحث حول `(0,0)`؟ | إرسال `2083/9` أثناء فعالية السديم مع وبدون `posx`/`posy` ومقارنة إحداثيات النتائج. |
| `V-12` | `tasks/march_manager.py` + `base_task.py:8551` | ثبت في `live_cycle_log.txt:1105-1361` أن مسيرات قاعة القيادة بـ 5 أبطال لم تُصدر أي `NOTIFY_HERO_SYS (406)`. هل يُصدر السيرفر `NOTIFY_HERO_SYS (406)` عند إرسال مسيرات العالم العادية (`hunt`, `gather`, `ruins`, `escort`) أم لا؟ | تسجيل حزم `1009` أثناء إرسال مسيرة صيد وجمع بأبطال والتحقق من وصول `notifyID=406`. |
| `V-13` | `tasks/march_manager.py:1789-1821, 2484-2501` | البنية الحقيقية لرد `1006/15` على أطلال مشغولة ورد `1007/2` لكل أنواع المسيرات (الكود يخمّن مفاتيح `relic`/`relics`/`moveTime`/`finishTime`). | تفريغ JSON الخام لـ `1006/15` (أطلال مشغولة) و`1007/2` لجميع الأنواع الخمسة. |
| `V-14` | `tasks/march_capacity.py` + `base_task.py:1818-1884, 7569-7609, 8311` | (أ) تفاوت تقليل السعة (آمن لا يسبب رفضاً) على القلاع القصوى بسبب `warGem` enchantments ومصادر `buffCtrl` الإضافية؛ (ب) التحقق من حزم `NOTIFY_LORD` (`key="activate"`/`closeVIP`) مع `queueCtrl["1219"]` عند تفعيل VIP؛ (ج) مسار `virtualBuff` الميت بـ `base_task.py:8311`. | مقارنة ناتج `calculate_march_capacity()` مع رقم الواجهة الرسمي على قلعة عالية، والتقاط حزم تفعيل VIP. |

---

## 7. خريطة أولويات الإصلاح المقترحة لنموذج كاربون (حسب الخطورة والاعتمادية)

يُوصى بالتنفيذ على **4 موجات متتابعة** لتجنب التضارب وحل أكبر عدد من الأعطال بأقل قدر من التعديلات المتكررة:

1. **الموجة الأولى — أخطار الحظر وتصفير القلاع وصرف الذهب (P0 Immediate):**
   - `T-06`, `T-07`, `N-17(2)`, `N-06(5003)` (`shield.py` + `base_task.is_shielded` + `live_memory.py` — خطر تصفير القلعة!).
   - `T-37`, `T-38` (`alliance.py` — خطر صرف 50 ذهباً صامتاً في حفر التحالف).
   - `M-06` (`base_task.py:3410-3418` — خانة المسيرة الشبحية لقلاع `VIP 4–7`).
   - `M-18` / `T-21` + `C-06` (`cure_wounded.py` + `live_memory.py` — سرقة خانة مسيرة عبر `queueCtrl["queues"]`).
   - `T-43` (`stamina.py` — تعديل الذاكرة عند Timeout) + `T-25` (`hero_trial.py` — نجاح وهمي عند الخطأ).
   - `BT-05` (`base_task.py:2594` — إرسال `setID` كنص `"str"` لحل `err=6`).
   - `M-07` (`hunt_monsters.py:139` — إزالة `// 100` و`L568` `TypeError`).

2. **الموجة الثانية — إصلاح النواة ومحرك الإشعارات (`core/live_memory.py`, `core/game_client.py`, `bot_manager.py`):**
   - `C-01`, `C-02`/`M-02`, `C-03`, `C-04`, `C-05`, `C-08`, `M-01`.
   - معالجات `NOTIFY` المتخصصة: `N-01` (`14`), `N-02` (`15`), `N-03` (`8`), `N-04` (`16/20`), `N-05` (`9`), `N-06` (`7`), `M-03` (`202`).
   - استبدال التوجيه العام الخاطئ: `N-07` (`1002`), `N-08` (`23`), `N-09` (`65`), `N-10` (`608`), `N-11` (`3/64/1009`), `N-12` (`29` + `epid`), `N-13` (`12/11`), `N-14` (`41`), `N-15` (`27`), `N-16` (`95/50`), `M-05` (`200/201/450`).
   - إضافة المعالجات المفقودة: `N-17` (`2`, `18`, `37`, `464`, `492`, `494`, `500`, `571`, `642`, `1007`).

3. **الموجة الثالثة — إصلاح محرك المسيرات و`tasks/base_task.py`:**
   - `M-04`, `M-08`, `M-09`, `M-10`, `M-11`, `M-12`, `M-13`, `M-14`, `M-15`, `M-16`, `M-17`.
   - `BT-01`, `BT-02`, `BT-03`, `BT-04`, `BT-06`, `BT-07`, `BT-08`, `BT-09`, `BT-10`, `BT-11`, `BT-12`.

4. **الموجة الرابعة — تنظيف التعديلات اليدوية المزدوجة وإصلاح المهام الفردية:**
   - إزالة الخصم/الإضافة اليدوية المزدوجة في: `watermill.py` (`T-04`, `T-05`), `shield.py` (`T-08`), `building.py` (`T-09`–`T-13`), `research.py` (`T-14`–`T-17`), `train.py` (`T-18`–`T-20`), `cure_wounded.py` (`T-22`, `T-23`), `arena.py` (`T-24`), `flower.py` (`T-28`, `T-29`), `wonder_merchant.py` (`T-30`, `T-31`), `material_synthesis.py` (`T-32`), `forge_equipment.py` (`T-33`–`T-36`), `alliance.py` (`T-39`, `T-40`), `war_medal.py` (`T-41`), `pet.py` (`T-42`), `stamina.py` (`T-44`), `daily_quest.py` (`T-45`), `port.py` (`T-01`), `imperial_mausoleum.py` (`T-02`), `city_harvest.py` (`T-03`), `hero_trial.py` (`T-26`, `T-27`).
