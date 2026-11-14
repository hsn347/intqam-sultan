local activity_9001558_Read = include("aAReadClass").new()
activity_9001558_Read:defineValue("Task_Config", function()
	local _ENV, ret
	local oriData = require_data("stellar_odyssey_task", true, true).data
	for i, v in ipairs(oriData) do
		local _group, _day, _type = v.group, v.day[1], v.day[2]
		if not ret[_group] then
			_ENV = ret[_group]
		end
		ret[_group] = ret[_group]
		if not ret[_group][_day] then
			_ENV = ret[_group][_day]
		end
		ret[_group][_day] = ret[_group][_day]
		ret[_group][_day][_type] = v
	end
	return ret
end)
function activity_9001558_Read.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local group = activityShowCtrl:getParamClassType(gActivityTimeActivityID.STELLAR_ODYSSEY_ACTIVITY)
	return group
end
function activity_9001558_Read.getTaskConfig(_day, _type)
	local group = activity_9001558_Read.getGroup()
	local cfg = activity_9001558_Read.Task_Config[group]
	if not _day then
		return cfg
	elseif not _type then
		return cfg[_day]
	else
		return cfg[_day][_type]
	end
end
function activity_9001558_Read.getActivityQuestMaxDay()
	local cfg = activity_9001558_Read.getTaskConfig()
	local dayMax = 0
	for day, __ in pairs(cfg) do
		if day > dayMax then
			dayMax = day
		end
	end
	return dayMax
end
function activity_9001558_Read.getTaskIDList(_day, _type)
	local cfg = activity_9001558_Read.getTaskConfig(_day, _type)
	return cfg.taskID
end
function activity_9001558_Read.getTabName(_day, _type)
	local cfg = activity_9001558_Read.getTaskConfig(_day, _type)
	return i18n(cfg.language)
end
function activity_9001558_Read.getTotalQuestNum()
	local num = 0
	local cfg = activity_9001558_Read.getTaskConfig()
	for _day, v in pairs(cfg) do
		for _type, w in pairs(v) do
			num = num + #w.taskID
		end
	end
	return num
end
activity_9001558_Read:defineValue("Exchange_Config", function()
	local _ENV, ret
	local oriData = require_data("stellar_odyssey_exchange", true, true).data
	for i, v in ipairs(oriData) do
		local _group = v.group
		if not ret[_group] then
			_ENV = ret[_group]
		end
		ret[_group] = ret[_group]
		table.insert(ret[_group], v)
	end
	return ret
end)
function activity_9001558_Read.getExchangeList()
	local group = activity_9001558_Read.getGroup()
	local cfg = activity_9001558_Read.Exchange_Config[group]
	return cfg
end
return activity_9001558_Read
