local roadToGloryRead = include("aAReadClass").new()
local eventQuestRead = include("eventQuestRead")
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "glory_quest_config"
	;(nil)[2] = true
	roadToGloryRead:defineValue("config", nil)
	roadToGloryRead.TasConfig, isInited = roadToGloryRead.defineValue, roadToGloryRead.defineValue
end
init()
function roadToGloryRead.getTaskConfig()
	return roadToGloryRead.TasConfig
end
function roadToGloryRead.getTaskbyLv(lv1, lv2)
	for k, v in ipairs(roadToGloryRead.config) do
		local lvMin = 0
		local lvMax = 0
		local starMin = 0
		local starMax = 0
		if #v.lv == 2 then
			lvMin = v.lv[1]
			lvMax = v.lv[2]
		end
		if #v.lv1 == 2 then
			starMin = v.lv1[1]
			starMax = v.lv1[2]
		end
		if lv1 >= lvMin and lv1 <= lvMax and lv2 >= starMin and lv2 <= starMax then
			return v.taskID
		end
	end
end
function roadToGloryRead.getActType(lv1, lv2)
	local queueList = roadToGloryRead.getTaskbyLv(lv1, lv2)
	if queueList then
		local questID = queueList[1]
		return eventQuestRead.questconfig[tonumber(questID)].type
	end
end
function roadToGloryRead.getSortList(lv1, lv2, serverData)
	local roadToGloryRead, ret
	local queueList = roadToGloryRead.getTaskbyLv(lv1, lv2)
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
		roadToGloryRead = questID
		questID.activityID = gActivityTimeActivityID.GLORY_ROAD_ACTIVITY
		questID.taskID = questID
		questID.progress = count
		questID.award = cfgItem.reward
		questID.aim = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		questID.type = cfgItem.type
		questID.ruleID = cfgItem.statsRuleID
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
return roadToGloryRead
