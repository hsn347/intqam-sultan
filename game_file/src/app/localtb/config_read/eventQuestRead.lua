local eventQuestRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "user_activity_config"
	;(nil)[2] = true
	eventQuestRead:defineValue("userActivityConfig", nil)
	eventQuestRead = nil
	;(nil)[1] = "quest_guideid_view"
	eventQuestRead:defineValue("questGuideCfg", nil)
	local createData = function(name)
		eventQuestRead.questconfig = require_once("app." .. LocalTblPath .. ".config_server.new_quest_config")
		local questdDscribe = require_once("app." .. LocalTblPath .. ".config_client.new_quest_describe")
		eventQuestRead.questconfig_Reward, eventQuestRead = "app." .. LocalTblPath .. ".config_client.new_quest_describe", "app." .. LocalTblPath .. ".config_client.new_quest_describe"
		for questID, v in pairs(eventQuestRead.questconfig) do
			if not questdDscribe[questID] or not questdDscribe[questID].des then
				eventQuestRead = questdDscribe[questID].des
			end
			eventQuestRead.questconfig[questID].taskDes = questdDscribe[questID].des
			eventQuestRead.questconfig[questID].isAct = questdDscribe[questID] and questdDscribe[questID].isAct or 0
			eventQuestRead.questconfig[questID].guideId = questdDscribe[questID] and questdDscribe[questID].guideId
			if not questdDscribe[questID] or not questdDscribe[questID].icon then
				eventQuestRead = questdDscribe[questID].icon
			end
			eventQuestRead.questconfig[questID].icon = questdDscribe[questID].icon
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			eventQuestRead.questconfig_Reward[questID] = serviceFunctions.tableFormat(v.reward, nil)
			v.reward = eventQuestRead.questconfig_Reward[questID]
		end
		if name == "questconfig" then
			return eventQuestRead.questconfig
		elseif name == "questconfig_Reward" then
			return eventQuestRead.questconfig_Reward
		end
	end
	eventQuestRead:defineValue("questconfig", createData)
	eventQuestRead:defineValue("questconfig_Reward", createData)
	eventQuestRead:defineValue("dailyTargetConfig", function()
		local dailyTargetConfig = require_once("app." .. LocalTblPath .. ".config_client.daily_target_config")
		eventQuestRead.dailyTargetConfig, _ENV = "app." .. LocalTblPath .. ".config_client.daily_target_config", "app." .. LocalTblPath .. ".config_client.daily_target_config"
		for _, v in ipairs(dailyTargetConfig) do
			if not eventQuestRead.dailyTargetConfig[v.type] then
				eventQuestRead.dailyTargetConfig[v.type], _ENV = nil, nil
			end
			table.insert(eventQuestRead.dailyTargetConfig[v.type], v.qeustID)
			if not eventQuestRead.dailyTargetConfig[v.type].name then
				eventQuestRead.dailyTargetConfig[v.type].name = v.des
			end
		end
		return eventQuestRead.dailyTargetConfig
	end)
end
init()
function eventQuestRead.getTaskConfig(questID)
	if not eventQuestRead.questconfig[questID] then
		eventQuestRead = eventQuestRead.questconfig[questID]
	end
	return eventQuestRead.questconfig[questID]
end
function eventQuestRead.getAim(questID)
	return eventQuestRead.questconfig[questID] and eventQuestRead.questconfig[questID].aim or 0
end
function eventQuestRead.getReward(questID)
	local eventQuestRead, reward
	if eventQuestRead.questconfig_Reward[questID] then
		reward = eventQuestRead.questconfig_Reward[questID]
	end
	return reward
end
function eventQuestRead.getGuideId(questID)
	if not eventQuestRead.questconfig[questID] or not eventQuestRead.questconfig[questID].guideId then
		eventQuestRead = eventQuestRead.questconfig[questID].guideId
	end
	return eventQuestRead.questconfig[questID].guideId
end
function eventQuestRead.getDes(questID)
	if not eventQuestRead.questconfig[questID] or not eventQuestRead.questconfig[questID].taskDes then
		eventQuestRead = eventQuestRead.questconfig[questID].taskDes
	end
	return eventQuestRead.questconfig[questID].taskDes
end
function eventQuestRead.getIsAct(questID)
	local cfg = eventQuestRead.getTaskConfig(questID)
	return cfg.isAct or 0
end
function eventQuestRead.checkIsAct(questID)
	return eventQuestRead.getIsAct(questID) == 1
end
function eventQuestRead.getDesEx(questID, styles)
	local taskDes = eventQuestRead.getDes(questID)
	if next(taskDes) == nil then
		return ""
	end
	local targetNum = taskDes.num or ""
	if string.formatnumberthousands(targetNum) ~= "0" then
		targetNum = string.formatnumberthousands(targetNum)
	end
	local targetLv = taskDes.lv or ""
	if string.formatnumberthousands(targetLv) ~= "0" then
		targetLv = string.formatnumberthousands(targetLv)
	end
	if styles and next(styles) then
		eventQuestRead = nil
		;(nil).num = targetNum
		;(nil).lv = targetLv
		return _G.i18n_html(taskDes[1] or "", nil, styles)
	else
		eventQuestRead = nil
		;(nil).num = targetNum
		;(nil).lv = targetLv
		return _G.i18n(taskDes[1] or "", nil)
	end
end
function eventQuestRead.getDesNew(questID, styles)
	local taskDes = eventQuestRead.getDes(questID)
	local des = clone(taskDes)
	local langId = taskDes[1] or questID .. ""
	for k, v in pairs(des) do
		local str = string.formatnumberthousands(v)
		if str ~= "0" then
			des[k] = str
		end
	end
	if styles and next(styles) then
		return _G.i18n_html(langId, des, styles)
	else
		return _G.i18n(langId, des)
	end
end
function eventQuestRead.getIcon(questID)
	if not eventQuestRead.questconfig[questID] or not eventQuestRead.questconfig[questID].icon[1] then
		eventQuestRead = eventQuestRead.questconfig[questID].icon[1]
	end
	return eventQuestRead.questconfig[questID].icon[1]
end
function eventQuestRead.getQuestList(activityID)
	return eventQuestRead.userActivityConfig[activityID] and eventQuestRead.userActivityConfig[activityID].questList
end
function eventQuestRead.getActivityParams(activityID)
end
function eventQuestRead.getActivityCostItemID(activityID)
	local param = eventQuestRead.getActivityParams(activityID)
	if param then
		return param.costItemID
	end
end
function eventQuestRead.getDailyQuestList(subType)
	return eventQuestRead.dailyTargetConfig[subType]
end
function eventQuestRead.getDailyQuestName(subType)
	return eventQuestRead.dailyTargetConfig[subType].name
end
function eventQuestRead.isNeedShowGo(taskID)
	local cfgItem = eventQuestRead.questconfig[tonumber(taskID)]
	if cfgItem and cfgItem.isAct == 1 then
		return true
	else
		return false
	end
end
function eventQuestRead.getSortList(activityID, serverData)
	local eventQuestRead, ret
	local queueList = eventQuestRead.getQuestList(activityID)
	dump(serverData, "eventQuestRead.serverData")
	dump(queueList, "eventQuestRead.queueList")
	for i, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData then
			count = serverData.questProgress[tostring(questID)] or 0
			if serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		eventQuestRead = questID
		questID.activityID = activityID
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		questID.type = cfgItem.type
		questID.ruleID = cfgItem.statsRuleID
		questID.isAct = cfgItem.isAct
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function eventQuestRead.getRamadanGiftBagList(activityID, serverData)
	local _ENV, ret
	local _ENV, queueList
	for k, v in pairs(serverData.questProgress) do
		table.insert(queueList, k)
	end
	dump(serverData, "getRamadanGiftBag.serverData")
	dump(queueList, "getRamadanGiftBag.queueList")
	for i, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData then
			count = serverData.questProgress[tostring(questID)] or 0
			if serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = questID
		questID.activityID = activityID
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function eventQuestRead.getDailySortList(subType, serverData)
	local eventQuestRead, ret
	local queueList = eventQuestRead.getDailyQuestList(subType)
	dump(serverData, "eventQuestReadserverData")
	dump(queueList, "eventQuestReadqueueList")
	for _, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData then
			count = serverData.questProgress[tostring(questID)] or 0
			if serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		eventQuestRead = questID
		questID.isAct = cfgItem.isAct
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function eventQuestRead.getRamadanPartySortList(activityID, serverData, isLogin)
	local taskList = eventQuestRead.getSortList(activityID, serverData)
	local eventQuestRead, ret = activityID, activityID
	for i, v in ipairs(taskList) do
		local cfgItem = eventQuestRead.questconfig[tonumber(v.taskID)]
		if isLogin and cfgItem.statsRuleID == 6 or not isLogin and cfgItem.statsRuleID ~= 6 then
			table.insert(ret, v)
		end
	end
	return ret
end
function eventQuestRead.getReceiveStatusAndNum(subType)
	local gametop = gModuleMgr.getObject("gametop")
	if not gametop then
		return false
	end
	local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
	if not activityTaskComponentCtrl then
		return false
	end
	local activityID = gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(activityID)
	local queueList = eventQuestRead.getDailyQuestList(subType)
	if not taskComponent.questData or not taskComponent.questData.finishedQuest then
		return false
	end
	local num = 0
	for _, v in ipairs(queueList) do
		if taskComponent.questData.finishedQuest[tostring(v)] and not taskComponent.questData.claimedQuest[tostring(v)] then
			num = num + 1
		end
	end
	return 0 < num, num
end
function eventQuestRead.getItemOutPutCfg(itemId)
	local itemDesRead = include("itemDesRead")
	local jumpDesRead = include("jumpDesRead")
	local outputCfg = itemDesRead.outputCfg[itemId]
	local _ENV, ret
	if outputCfg then
		for _, v in ipairs(outputCfg.type) do
			if jumpDesRead.getCfg(v) then
				table.insert(ret, jumpDesRead.getCfg(v))
			end
		end
	end
	return ret
end
return eventQuestRead
