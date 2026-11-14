local planThoroughRead = include("aAReadClass").new()
local eventQuestRead = include("eventQuestRead")
local isInited = false
local init = function()
	if isInited then
		return
	end
	planThoroughRead = nil
	;(nil)[1] = "overall_planning_config"
	planThoroughRead:defineValue("config", nil)
	planThoroughRead:defineValue("dailyTargetConfig", function()
		planThoroughRead.dailyTargetConfig, planThoroughRead = nil, nil
		for k, v in ipairs(planThoroughRead.config) do
			if not planThoroughRead.dailyTargetConfig[v.type] then
				planThoroughRead.dailyTargetConfig[v.type], planThoroughRead = nil, nil
			end
			table.insert(planThoroughRead.dailyTargetConfig[v.type], v.qeustID)
			if not planThoroughRead.dailyTargetConfig[v.type].name then
				planThoroughRead.dailyTargetConfig[v.type].name = v.des
			end
		end
		return planThoroughRead.dailyTargetConfig
	end)
end
init()
function planThoroughRead.getDailyQuestList(subType)
	return planThoroughRead.dailyTargetConfig[subType]
end
function planThoroughRead.getDailyQuestName(subType)
	return planThoroughRead.dailyTargetConfig[subType].name
end
function planThoroughRead.getDailySortList(subType, serverData)
	local planThoroughRead, ret
	local queueList = planThoroughRead.getDailyQuestList(subType)
	for _, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData and next(serverData) ~= nil then
			count = serverData.questProgress[tostring(questID)] or 0
			if serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		if cfgItem then
			planThoroughRead = questID
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
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
return planThoroughRead
