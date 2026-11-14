local activity_9001731_Read = include("aAReadClass").new()
activity_9001731_Read:defineValue("ludo_reward", function()
	local config = require_data("ludo_reward", true, true).data
	local _ENV, ret = "ludo_reward", "ludo_reward"
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
function activity_9001731_Read.getRewardCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.FLYING_CHESS_ACTIVITY)
	return activity_9001731_Read.ludo_reward[classType]
end
function activity_9001731_Read.getTaskCfg()
	local cfg = activity_9001731_Read.getRewardCfg()
	local activity_9001731_Read, ret
	for k, v in ipairs(cfg) do
		if v.rewardType < 4 then
			table.insert(ret, v)
		end
	end
	return ret
end
function activity_9001731_Read.getStageCfg()
	local cfg = activity_9001731_Read.getRewardCfg()
	local activity_9001731_Read, ret
	for k, v in ipairs(cfg) do
		if v.rewardType == 4 then
			table.insert(ret, v)
		end
	end
	return ret
end
function activity_9001731_Read.isStageTaskId(taskId)
	local cfg = activity_9001731_Read.getRewardCfg()
	local ret = false
	for k, v in ipairs(cfg) do
		if v.rewardType == 4 and v.taskId == taskId then
			ret = true
		end
	end
	return ret
end
function activity_9001731_Read.getWinReward()
	local cfg = activity_9001731_Read.getRewardCfg()
	local activity_9001731_Read, ret
	for k, v in ipairs(cfg) do
		if v.rewardType == 5 then
			ret = v.taskReward
		end
	end
	return ret
end
function activity_9001731_Read.getLoseReward()
	local cfg = activity_9001731_Read.getRewardCfg()
	local activity_9001731_Read, ret
	for k, v in ipairs(cfg) do
		if v.rewardType == 6 then
			ret = v.taskReward
		end
	end
	return ret
end
activity_9001731_Read:defineValue("ludo_battlepass", function()
	local config = require_data("ludo_battlepass", true, true).data
	local _ENV, ret = "ludo_battlepass", "ludo_battlepass"
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
function activity_9001731_Read.getBattlePassCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.FLYING_CHESS_ACTIVITY)
	return activity_9001731_Read.ludo_battlepass[classType]
end
function _UPVALUE1_()
	local config = require_data("ludo_battlepass", true, true).data
	local _ENV, ret = "ludo_battlepass", "ludo_battlepass"
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
	local config = require_data("ludo_battlepass", true, true).data
	local _ENV, ret = "ludo_battlepass", "ludo_battlepass"
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
end)[1] = "ludo_recharge"
activity_9001731_Read:defineValue("ludo_recharge", function()
	local config = require_data("ludo_battlepass", true, true).data
	local _ENV, ret = "ludo_battlepass", "ludo_battlepass"
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
function activity_9001731_Read.getRechargeCfg(rechargeType)
	return activity_9001731_Read.ludo_recharge[rechargeType]
end
activity_9001731_Read:defineValue("ludo_map", function()
	local config = require_data("ludo_map", true, true).data
	local _ENV, ret = "ludo_map", "ludo_map"
	for k, v in ipairs(config) do
		ret[v.mapNumer] = v
	end
	return ret
end)
function activity_9001731_Read.getMapList()
	return activity_9001731_Read.ludo_map
end
function activity_9001731_Read.getMapCfg(mapNumer)
	return activity_9001731_Read.ludo_map[tonumber(mapNumer)]
end
function activity_9001731_Read.isSafeMapNumber(mapNumer)
	local cfg = activity_9001731_Read.getMapCfg(mapNumer)
	return cfg and cfg.mapType == gFlyingChessBroadGridType.SAFE
end
activity_9001731_Read:defineValue("ludo_path", function()
	local config = require_data("ludo_path", true, true).data
	local _ENV, ret = "ludo_path", "ludo_path"
	for k, v in ipairs(config) do
		ret[v.belongPlayer] = v.path
	end
	return ret
end)
function activity_9001731_Read.getMovePathList(player, from, to)
	local cfg = activity_9001731_Read.ludo_path[player]
	local activity_9001731_Read, pathList
	if from == 0 then
		table.insert(pathList, cfg[to])
	else
		for i = from + 1, to do
			table.insert(pathList, cfg[i])
		end
	end
	return pathList
end
function activity_9001731_Read.getGridByPathIndex(player, pathIndex)
	return activity_9001731_Read.ludo_path[player][pathIndex]
end
function activity_9001731_Read.getPathCfg(player)
	return activity_9001731_Read.ludo_path[player]
end
return activity_9001731_Read
