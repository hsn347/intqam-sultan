local activity_9001721_Read = include("aAReadClass").new()
activity_9001721_Read:defineValue("world_boss_monkey_task", function()
	local config = require_data("world_boss_monkey_task", true, true).data
	local _ENV, ret = "world_boss_monkey_task", "world_boss_monkey_task"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		table.insert(ret[v.classType], v.taskID)
	end
	return ret
end)
function activity_9001721_Read.getTaskCfg(taskType)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY)
	local taskIDList = activity_9001721_Read.world_boss_monkey_task[classType]
	local _ENV, ret
	local eventQuestRead = include("eventQuestRead")
	for k, v in ipairs(taskIDList) do
		local cfg = eventQuestRead.getTaskConfig(v)
		if cfg.type == taskType then
			table.insert(ret, v)
		end
	end
	return ret
end
activity_9001721_Read:defineValue("world_boss_monkey", function()
	local config = require_data("world_boss_monkey", true, true).data
	local ret = config[1]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	ret.victory_rewards = serviceFunctions.tableFormat(ret.victory_rewards, nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	ret.defeat_rewards = serviceFunctions.tableFormat(ret.defeat_rewards, nil)
	ret.itemID = ret.summonCost[1]
	ret.itemCount = ret.summonCost[2]
	return ret
end)
function activity_9001721_Read.getItemID()
	return activity_9001721_Read.world_boss_monkey.itemID
end
function activity_9001721_Read.getItemCount()
	return activity_9001721_Read.world_boss_monkey.itemCount
end
function activity_9001721_Read.getVictoryRewards()
	return activity_9001721_Read.world_boss_monkey.victory_rewards
end
return activity_9001721_Read
