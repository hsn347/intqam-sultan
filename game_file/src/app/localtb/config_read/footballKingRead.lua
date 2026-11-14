local footballKingRead = include("aAReadClass").new()
function footballKingRead.getTaskByDayLabel(day, label)
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	if label then
		return footballKingRead.Task_Config[group][day][label].taskID
	else
		return footballKingRead.Task_Config[group][day]
	end
end
function footballKingRead.getTabNameByDayLabel(day, label)
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	return footballKingRead.Task_Config[group][day][label].language
end
function footballKingRead.getTaskNumByDayLabel(day, label)
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	return #footballKingRead.Task_Config[group][day][label].taskID
end
function footballKingRead.init()
	footballKingRead:defineValue("Task_Config", function()
		footballKingRead.Task_Config, footballKingRead = nil, nil
		local oriData = require_data("footballking_task", true, true).data
		for i, v in pairs(oriData) do
			if not footballKingRead.Task_Config[v.group] then
				footballKingRead.Task_Config[v.group], footballKingRead = nil, nil
			end
			if not footballKingRead.Task_Config[v.group][v.day[1]] then
				footballKingRead.Task_Config[v.group][v.day[1]], footballKingRead = nil, nil
			end
			footballKingRead.Task_Config[v.group][v.day[1]][v.day[2]] = v
		end
		return footballKingRead.Task_Config
	end)
	footballKingRead:defineValue("Task_Reward", function()
		footballKingRead.Task_Reward, footballKingRead = nil, nil
		local oriData = require_data("footballking_reward", true, true).data
		for i, v in ipairs(oriData) do
			if not footballKingRead.Task_Reward[v.group] then
				footballKingRead.Task_Reward[v.group], footballKingRead = nil, nil
			end
			footballKingRead = footballKingRead.Task_Reward
			footballKingRead.Task_Reward.Id = #footballKingRead.Task_Reward[v.group] + 1
			footballKingRead.Task_Reward.num = v.taskNum
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local footballKingRead.Task_Reward.reward, taskRewardCfg = serviceFunctions.tableFormat(v.reward, nil), footballKingRead.Task_Reward
			footballKingRead.Task_Reward[v.group][taskRewardCfg.Id] = taskRewardCfg
		end
		return footballKingRead.Task_Reward
	end)
end
function footballKingRead.getTaskConfig()
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	return footballKingRead.Task_Config[group]
end
function footballKingRead.getTaskReward()
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	return footballKingRead.Task_Reward[group]
end
function footballKingRead.getTaskRewardByIdx(idx)
	local group = SoraDGetCtrl("footballKingCtrl"):getGroup()
	return footballKingRead.Task_Reward[group][idx]
end
footballKingRead.init()
return footballKingRead
