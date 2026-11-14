local activity_9001719_Read = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "magic_carpet_monster"
activity_9001719_Read:defineValue("magic_carpet_monster", nil)
function activity_9001719_Read.getMonsterCfg(index)
	return activity_9001719_Read.magic_carpet_monster[index]
end
activity_9001719_Read:defineValue("magic_carpet_monster_order", function()
	local config = require_data("magic_carpet_monster_order", true, true).data
	local _ENV, ret = "magic_carpet_monster_order", "magic_carpet_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001719_Read.getMonsterOrderCfg(time)
	local index = 1
	local interval = 1
	for _, v in ipairs(activity_9001719_Read.magic_carpet_monster_order) do
		if time >= v.time[1] and time <= v.time[2] then
			index = v.index
			interval = v.interval
		end
	end
	return index, interval
end
function activity_9001719_Read.getRandomMonsterCfg(time)
	local orderIndex, orderInterval = activity_9001719_Read.getMonsterOrderCfg(time)
	local total = 0
	local cfg = activity_9001719_Read.magic_carpet_monster_order[orderIndex]
	for _, v in ipairs(cfg.weightCfg) do
		total = total + v.weight
	end
	local random = math.random(total)
	local index = 1
	local tmpW = 0
	for i, v in ipairs(cfg.weightCfg) do
		if random <= v.weight + tmpW then
			index = v.id
			break
		end
		tmpW = tmpW + v.weight
	end
	return activity_9001719_Read.magic_carpet_monster[index]
end
activity_9001719_Read:defineValue("magic_carpet_task", function()
	local config = require_data("magic_carpet_task", true, true).data
	local _ENV, ret = "magic_carpet_task", "magic_carpet_task"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.taskReward = serviceFunctions.tableFormat(v.taskReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001719_Read.getTaskCfg(classType)
	return activity_9001719_Read.magic_carpet_task[classType]
end
activity_9001719_Read:defineValue("magic_carpet_stage_reward", function()
	local config = require_data("magic_carpet_stage_reward", true, true).data
	local _ENV, ret = "magic_carpet_stage_reward", "magic_carpet_stage_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.stageReward = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001719_Read.getStageCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.MAGIC_CARPET)
	return activity_9001719_Read.magic_carpet_stage_reward[classType]
end
activity_9001719_Read:defineValue("magic_carpet_battlepass", function()
	local config = require_data("magic_carpet_battlepass", true, true).data
	local _ENV, ret = "magic_carpet_battlepass", "magic_carpet_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001719_Read.getBattlepassCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.MAGIC_CARPET)
	return activity_9001719_Read.magic_carpet_battlepass[classType]
end
function activity_9001719_Read.getAdvRewards()
	local _ENV, ret
	for k, v in ipairs(activity_9001719_Read.getBattlepassCfg()) do
		for i, reward in ipairs(v.advanceReward) do
			table.insert(ret, reward)
		end
	end
	return SoraDMergeRewards(ret)
end
function _UPVALUE2_()
	local config = require_data("magic_carpet_battlepass", true, true).data
	local _ENV, ret = "magic_carpet_battlepass", "magic_carpet_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end
;(function()
	local config = require_data("magic_carpet_battlepass", true, true).data
	local _ENV, ret = "magic_carpet_battlepass", "magic_carpet_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)[1] = "magic_carpet_recharge"
;(function()
	local config = require_data("magic_carpet_battlepass", true, true).data
	local _ENV, ret = "magic_carpet_battlepass", "magic_carpet_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)[2] = true
activity_9001719_Read:defineValue("magic_carpet_recharge", function()
	local config = require_data("magic_carpet_battlepass", true, true).data
	local _ENV, ret = "magic_carpet_battlepass", "magic_carpet_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001719_Read.getRechargeCfg()
	return activity_9001719_Read.magic_carpet_recharge[1]
end
activity_9001719_Read:defineValue("magic_carpet_rank", function()
	local config = require_data("magic_carpet_rank", true, true).data
	local _ENV, ret = "magic_carpet_rank", "magic_carpet_rank"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rankReward = serviceFunctions.tableFormat(v.rankReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001719_Read.getRankCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.MAGIC_CARPET)
	return activity_9001719_Read.magic_carpet_rank[classType]
end
return activity_9001719_Read
