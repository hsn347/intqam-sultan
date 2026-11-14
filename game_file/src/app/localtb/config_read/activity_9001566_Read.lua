local activity_9001566_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").CURE_ARMY_SPEED = 1
local ("aAReadClass").MARCH_SPEED_UP, itemRebateEventType = 2, "aAReadClass"
activity_9001566_Read.itemRebateEventType = itemRebateEventType
activity_9001566_Read:defineValue("taskConfig", function()
	local config = require_data("battleground_item_rebate", true, true).data
	local _ENV, ret = "battleground_item_rebate", "battleground_item_rebate"
	for __, v in ipairs(config) do
		if not ret[v.idActivity] then
			_ENV = ret[v.idActivity]
		end
		ret[v.idActivity] = ret[v.idActivity]
		if not ret[v.idActivity][v.TaskType] then
			_ENV = ret[v.idActivity][v.TaskType]
		end
		ret[v.idActivity][v.TaskType] = ret[v.idActivity][v.TaskType]
		_UPVALUE2_ = ret[v.idActivity][v.TaskType]
		ret[v.idActivity][v.TaskType][1] = "id"
		ret[v.idActivity][v.TaskType][2] = "count"
		v.TaskReward = serviceFunctions.tableFormat(v.TaskReward, ret[v.idActivity][v.TaskType])
		table.insert(ret[v.idActivity][v.TaskType], v)
	end
	return ret
end)
function activity_9001566_Read.getTaskConfig(param)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(param.activityId)
	local ret = activity_9001566_Read.taskConfig[classType]
	if param.eventType then
		if param.idx then
			return ret[param.eventType][param.idx]
		else
			return ret[param.eventType]
		end
	end
	return ret
end
function activity_9001566_Read.getTaskTarget(param)
	local cfg = activity_9001566_Read.getTaskConfig(param)
	return cfg.TaskTarget
end
function activity_9001566_Read.getTaskTarget2(param)
	local taskTarget = activity_9001566_Read.getTaskTarget(param)
	return activity_9001566_Read.changeTaskValue(taskTarget, param.eventType)
end
function activity_9001566_Read.changeTaskValue(value, eventType)
	if eventType == itemRebateEventType.CURE_ARMY_SPEED then
		return math.floor(value / 60)
	else
		return value
	end
end
function activity_9001566_Read.getTaskReward(param)
	local cfg = activity_9001566_Read.getTaskConfig(param)
	return cfg.TaskReward
end
function activity_9001566_Read.getTaskStageList(activityId, eventType)
	activity_9001566_Read = nil
	;(nil).activityId = activityId
	;(nil).eventType = eventType
	local cfg = activity_9001566_Read.getTaskConfig(nil)
	local activity_9001566_Read, ret
	for __, v in ipairs(cfg) do
		table.insert(ret, v.TaskTarget)
	end
	return ret
end
activity_9001566_Read:defineValue("eventTypeConfig", function()
	itemRebateEventType = nil
	itemRebateEventType = nil
	;(nil).name = "battleground_rebate_16"
	;(nil).name2 = "battleground_rebate_7"
	;(nil).des = "battleground_rebate_2"
	;(nil).icon = "img_depot_underlay_01.png"
	;(nil).boxClose = "img_depot_greenbox_01.png"
	;(nil)[itemRebateEventType.CURE_ARMY_SPEED], (nil).boxOpen = nil, "img_depot_greenbox_02.png"
	itemRebateEventType = nil
	;(nil).name = "battleground_rebate_17"
	;(nil).name2 = "battleground_rebate_8"
	;(nil).des = "battleground_rebate_3"
	;(nil).icon = "img_depot_underlay_02.png"
	;(nil).boxClose = "img_depot_redbox_01.png"
	;(nil)[itemRebateEventType.MARCH_SPEED_UP], (nil).boxOpen = nil, "img_depot_redbox_02.png"
	local config
	return config
end)
function activity_9001566_Read.getEventTypeConfig(eventType)
	return activity_9001566_Read.eventTypeConfig[eventType]
end
function activity_9001566_Read.getEventTypeBoxImage(eventType, isOpen)
	local cfg = activity_9001566_Read.getEventTypeConfig(eventType)
	if isOpen then
		return cfg.boxOpen
	else
		return cfg.boxClose
	end
end
function activity_9001566_Read.getEventTypeNameWithIdx(eventType, idx)
	local cfg = activity_9001566_Read.getEventTypeConfig(eventType)
	activity_9001566_Read = nil
	;(nil).num = idx
	return i18n(cfg.name2, nil)
end
function activity_9001566_Read.getEventTypeDesBase(eventType)
	local cfg = activity_9001566_Read.getEventTypeConfig(eventType)
	return cfg.des
end
function activity_9001566_Read.getEventTypeList(...)
	_UPVALUE2_ = nil
	;(nil)[1] = itemRebateEventType.MARCH_SPEED_UP
	local (nil)[2], ret = itemRebateEventType.CURE_ARMY_SPEED, nil
	return ret
end
return activity_9001566_Read
