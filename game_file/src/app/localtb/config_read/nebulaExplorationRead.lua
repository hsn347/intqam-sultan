local nebulaExplorationRead = include("aAReadClass").new()
function nebulaExplorationRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "nebula_treasure_hunt"
	;(nil)[2] = true
	nebulaExplorationRead:defineValue("nebula_treasure_hunt", nil)
	nebulaExplorationRead:defineValue("treasureHuntConfig", function()
		local _ENV, ret
		for i, v in ipairs(nebulaExplorationRead.nebula_treasure_hunt) do
			v.layerId = v.lv
			if not ret[v.classType] then
				_ENV = ret[v.classType]
			end
			ret[v.classType] = ret[v.classType]
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
	nebulaExplorationRead:defineValue("progressCfg", function()
		local _ENV, ret
		for i, v in ipairs(nebulaExplorationRead.nebula_treasure_hunt) do
			v.layerId = v.lv
			if not ret[v.classType] then
				_ENV = ret[v.classType]
			end
			ret[v.classType] = ret[v.classType]
			if next(v.tierRewards) then
				_ENV = nil
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				;(nil).tierRewards = serviceFunctions.tableFormat(v.tierRewards, nil)
				;(nil).level = v.layerId
				table.insert(ret[v.classType], nil)
			end
		end
		return ret
	end)
end
function nebulaExplorationRead:getProgressCfg()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY)
	return nebulaExplorationRead.progressCfg[classType]
end
function nebulaExplorationRead:getLevelConfig(level)
	local config = self:getPreAwardConfig()
	level = math.min(level, table.nums(config))
	return config[level]
end
function nebulaExplorationRead:getPreAwardConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY)
	return nebulaExplorationRead.treasureHuntConfig[classType]
end
nebulaExplorationRead.init()
return nebulaExplorationRead
