local eventRushTaskRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "fullday_sprint_cofig"
	;(nil)[2] = true
	eventRushTaskRead:defineValue("tableAllTask", nil)
	_ENV = nil
	;(nil)[1] = "sunset_welfare"
	;(nil)[2] = true
	eventRushTaskRead:defineValue("tableSunSetTask", nil)
	eventRushTaskRead:defineValue("allTaskConfig", function()
		eventRushTaskRead.allTaskConfig, eventRushTaskRead = nil, nil
		for k, v in ipairs(eventRushTaskRead.tableAllTask) do
			local tempSingle = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempSingle.award = serviceFunctions.tableFormat(v.award, nil)
			table.insert(eventRushTaskRead.allTaskConfig, tempSingle)
		end
		return eventRushTaskRead.allTaskConfig
	end)
	eventRushTaskRead:defineValue("sunSetTaskConfig", function()
		eventRushTaskRead.sunSetTaskConfig, eventRushTaskRead = nil, nil
		for k, v in ipairs(eventRushTaskRead.tableSunSetTask) do
			eventRushTaskRead = nil
			;(nil).guideId = v.type
			;(nil).taskID = v.taskID
			;(nil).aim = v.amount
			local (nil).taskDes, tempSingle = v.taskDes, nil
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempSingle.award = serviceFunctions.tableFormat(v.award, nil)
			table.insert(eventRushTaskRead.sunSetTaskConfig, tempSingle)
		end
		return eventRushTaskRead.sunSetTaskConfig
	end)
end
init()
function eventRushTaskRead.getActivityTaskByID(activityID)
	local _ENV, tempTask
	for k, v in ipairs(eventRushTaskRead.allTaskConfig) do
		if tostring(v.activityID) == activityID then
			table.insert(tempTask, v)
		end
	end
	return tempTask
end
function eventRushTaskRead.getTaskMsg(amount, activityTable)
	for k, v in ipairs(activityTable) do
		if v.amount == amount then
			return v
		end
	end
end
function eventRushTaskRead.getTaskCondition(typeID)
	_ENV = nil
	;(nil)[gSunsetConditionType.LOGIN_DAY] = nil
	;(nil)[gSunsetConditionType.ATTACK_MONSTER_TIMES] = gNewPLayerTaskType.KILL_MONSTER
	;(nil)[gSunsetConditionType.TRAIN_SOLDIER] = gNewPLayerTaskType.TRAIN_SOLDIERS
	;(nil)[gSunsetConditionType.ATTACK_MOMSTER_PALACT] = gNewPLayerTaskType.COMMON_ACTIVITY_CENTER
	local gSunsetConditionType.USE_GOLD.condition, _ENV, _ENV, (nil)[gSunsetConditionType.USE_GOLD], conditionFunc = gNewPLayerTaskType.COMMON_ACTIVITY_CENTER, gNewPLayerTaskType.COMMON_ACTIVITY_CENTER, gSunsetConditionType.USE_GOLD, nil, nil
	local gSunsetConditionType.USE_GOLD.questType, ret = conditionFunc[typeID], gSunsetConditionType.USE_GOLD
	if typeID == gCallbackConditionType.TRAIN_SOLDIER then
		gCallbackConditionType.TRAIN_SOLDIER.condition, _ENV, _ENV = nil, nil, gCallbackConditionType.TRAIN_SOLDIER
		gCallbackConditionType.TRAIN_SOLDIER.questType = conditionFunc[typeID]
		ret, gCallbackConditionType.TRAIN_SOLDIER.bid = gCallbackConditionType.TRAIN_SOLDIER, BUILDID.CHARIOT_PLANT
	end
	return ret
end
return eventRushTaskRead
