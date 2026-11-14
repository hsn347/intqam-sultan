local activity_9001688_Read = include("aAReadClass").new()
local activityID = gActivityTimeActivityID.DAILY_SALUTE
activity_9001688_Read:defineValue("daily_salute_reward", function()
	local config = require_data("daily_salute_reward", true, true).data
	local _ENV, ret = "daily_salute_reward", "daily_salute_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001688_Read.getStageCfg()
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001688_Read.daily_salute_reward[classType]
end
function activity_9001688_Read.getStageReward(value)
	local classType = SoraDGetActivityClassType(activityID)
	local _ENV, reward = activityID, activityID
	for k, v in ipairs(activity_9001688_Read.daily_salute_reward[classType]) do
		if value >= v.score then
			for _, r in ipairs(v.reward) do
				table.insert(reward, r)
			end
		end
	end
	return reward
end
activity_9001688_Read:defineValue("daily_salute_task", function()
	local config = require_data("daily_salute_task", true, true).data
	local _ENV, ret = "daily_salute_task", "daily_salute_task"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001688_Read.getTaskCfg()
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001688_Read.daily_salute_task[classType]
end
activity_9001688_Read:defineValue("daily_salute_bribe_reward", function()
	local config = require_data("daily_salute_bribe_reward", true, true).data
	local _ENV, ret = "daily_salute_bribe_reward", "daily_salute_bribe_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.bribe_type] then
			ret[v.classType][v.bribe_type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.bribe_type], v)
	end
	return ret
end)
function activity_9001688_Read.getBribeRewardCfg(bribe_type, rank)
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001688_Read.daily_salute_bribe_reward[classType][bribe_type][rank]
end
function _UPVALUE2_()
	local config = require_data("daily_salute_bribe_reward", true, true).data
	local _ENV, ret = "daily_salute_bribe_reward", "daily_salute_bribe_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.bribe_type] then
			ret[v.classType][v.bribe_type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.bribe_type], v)
	end
	return ret
end
;(function()
	local config = require_data("daily_salute_bribe_reward", true, true).data
	local _ENV, ret = "daily_salute_bribe_reward", "daily_salute_bribe_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.bribe_type] then
			ret[v.classType][v.bribe_type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.bribe_type], v)
	end
	return ret
end)[1] = "daily_salute_task_score"
;(function()
	local config = require_data("daily_salute_bribe_reward", true, true).data
	local _ENV, ret = "daily_salute_bribe_reward", "daily_salute_bribe_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.bribe_type] then
			ret[v.classType][v.bribe_type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.bribe_type], v)
	end
	return ret
end)[2] = true
activity_9001688_Read:defineValue("daily_salute_task_score", function()
	local config = require_data("daily_salute_bribe_reward", true, true).data
	local _ENV, ret = "daily_salute_bribe_reward", "daily_salute_bribe_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		if not ret[v.classType][v.bribe_type] then
			ret[v.classType][v.bribe_type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType][v.bribe_type], v)
	end
	return ret
end)
activity_9001688_Read:defineValue("daily_salute_rank_reward", function()
	local config = require_data("daily_salute_rank_reward", true, true).data
	local _ENV, ret = "daily_salute_rank_reward", "daily_salute_rank_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001688_Read.getRankCfg()
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001688_Read.daily_salute_rank_reward[classType]
end
return activity_9001688_Read
