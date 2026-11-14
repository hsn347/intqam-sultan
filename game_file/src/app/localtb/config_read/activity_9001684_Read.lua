local activity_9001684_Read = include("aAReadClass").new()
activity_9001684_Read:defineValue("collect_accitivity_task", function()
	local config = require_data("collect_accitivity_task", true, true).data
	local _ENV, ret = "collect_accitivity_task", "collect_accitivity_task"
	for k, v in ipairs(config) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.resourceNum, nil)
		table.insert(ret[v.taskType], v)
	end
	return ret
end)
activity_9001684_Read:defineValue("taskTypeCfg", function()
	local config = require_data("collect_accitivity_task", true, true).data
	local _ENV, ret = "collect_accitivity_task", "collect_accitivity_task"
	for k, v in ipairs(config) do
		ret[tostring(v.taskId)] = v.taskType
	end
	return ret
end)
function activity_9001684_Read.getTaskCfg(taskType)
	return activity_9001684_Read.collect_accitivity_task[taskType]
end
function activity_9001684_Read.getTaskType(taskId)
	return activity_9001684_Read.taskTypeCfg[tostring(taskId)]
end
activity_9001684_Read:defineValue("collect_task_infiniity", function()
	local config = require_data("collect_task_infiniity", true, true).data
	local _ENV, ret = "collect_task_infiniity", "collect_task_infiniity"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.resourceNumCLE, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001684_Read.getInfiniityTaskCfg()
	return activity_9001684_Read.collect_task_infiniity
end
function activity_9001684_Read.getInfiniityTaskCfgByIndex(index)
	return activity_9001684_Read.collect_task_infiniity[index]
end
activity_9001684_Read:defineValue("collect_accitivity_rank", function()
	local config = require_data("collect_accitivity_rank", true, true).data
	local _ENV, ret = "collect_accitivity_rank", "collect_accitivity_rank"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.rankType] then
			ret[v.serverType][v.rankType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rankReward, nil)
		table.insert(ret[v.serverType][v.rankType], v)
	end
	return ret
end)
function activity_9001684_Read.getRankRewardCfg(rankType)
	local serverType = SoraDGetCtrl("nebulaActivityCtrl"):getServerType()
	return activity_9001684_Read.collect_accitivity_rank[serverType][rankType]
end
activity_9001684_Read:defineValue("collect_accitivity_stage", function()
	local config = require_data("collect_accitivity_stage", true, true).data
	local _ENV, ret = "collect_accitivity_stage", "collect_accitivity_stage"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.stageType] then
			ret[v.serverType][v.stageType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.serverType][v.stageType], v)
	end
	return ret
end)
function activity_9001684_Read.getStageCfg(stageType)
	local serverType = SoraDGetCtrl("nebulaActivityCtrl"):getServerType()
	return activity_9001684_Read.collect_accitivity_stage[serverType][stageType]
end
function activity_9001684_Read.getStageLevelCfg(stageType, stageLevel)
	local serverType = SoraDGetCtrl("nebulaActivityCtrl"):getServerType()
	return activity_9001684_Read.collect_accitivity_stage[serverType][stageType][stageLevel]
end
function _UPVALUE2_()
	local config = require_data("collect_accitivity_stage", true, true).data
	local _ENV, ret = "collect_accitivity_stage", "collect_accitivity_stage"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.stageType] then
			ret[v.serverType][v.stageType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.serverType][v.stageType], v)
	end
	return ret
end
;(function()
	local config = require_data("collect_accitivity_stage", true, true).data
	local _ENV, ret = "collect_accitivity_stage", "collect_accitivity_stage"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.stageType] then
			ret[v.serverType][v.stageType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.serverType][v.stageType], v)
	end
	return ret
end)[1] = "damage_factor"
;(function()
	local config = require_data("collect_accitivity_stage", true, true).data
	local _ENV, ret = "collect_accitivity_stage", "collect_accitivity_stage"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.stageType] then
			ret[v.serverType][v.stageType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.serverType][v.stageType], v)
	end
	return ret
end)[2] = true
activity_9001684_Read:defineValue("damage_factor", function()
	local config = require_data("collect_accitivity_stage", true, true).data
	local _ENV, ret = "collect_accitivity_stage", "collect_accitivity_stage"
	for k, v in ipairs(config) do
		if not ret[v.serverType] then
			ret[v.serverType], _ENV = nil, nil
		end
		if not ret[v.serverType][v.stageType] then
			ret[v.serverType][v.stageType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.serverType][v.stageType], v)
	end
	return ret
end)
function activity_9001684_Read.getFactorCfg()
	return activity_9001684_Read.damage_factor
end
function activity_9001684_Read.getDamageFactor(collectInterval)
	if collectInterval <= 0 then
		return 0, activity_9001684_Read.damage_factor[1].collectInterval[1]
	end
	local factor = activity_9001684_Read.damage_factor[#activity_9001684_Read.damage_factor].damageFactor
	local toNext = 0
	for k, v in ipairs(activity_9001684_Read.damage_factor) do
		if collectInterval >= v.collectInterval[1] and collectInterval <= v.collectInterval[2] then
			factor = v.damageFactor
			if k < #activity_9001684_Read.damage_factor then
				toNext = activity_9001684_Read.damage_factor[k + 1].collectInterval[1] - collectInterval
			end
			break
		end
	end
	return factor, toNext
end
return activity_9001684_Read
