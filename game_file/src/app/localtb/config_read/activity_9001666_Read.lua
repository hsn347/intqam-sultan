local activity_9001666_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_battlepass"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_battlepass", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_achivement"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_achivement", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_recharge"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_recharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_stage_reward"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_stage_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_match_reward"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_match_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_rank_reward"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_rank_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_attribute"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_attribute", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_rule"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_rule", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snow_competition_group"
;(nil)[2] = true
activity_9001666_Read:defineValue("snow_competition_group", nil)
activity_9001666_Read:defineValue("battlepass", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_battlepass) do
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
		ret[v.classType][v.rewardID] = v
	end
	return ret
end)
activity_9001666_Read:defineValue("rank_reward", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_rank_reward) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[v.classType][v.rewardType] then
			ret[v.classType][v.rewardType], _ENV = nil, nil
		end
		table.insert(ret[v.classType][v.rewardType], v)
	end
	return ret
end)
activity_9001666_Read:defineValue("stage_reward", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_stage_reward) do
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
activity_9001666_Read:defineValue("match_reward", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_match_reward) do
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
activity_9001666_Read:defineValue("rule", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_rule) do
		if not ret[v.distanceGroup] then
			ret[v.distanceGroup], _ENV = nil, nil
		end
		table.insert(ret[v.distanceGroup], v)
	end
	return ret
end)
activity_9001666_Read:defineValue("attr", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001666_Read.snow_competition_attribute) do
		ret[v.level] = v
	end
	return ret
end)
function activity_9001666_Read.getNextMatchReward(distance)
	local classType = SoraDGetCtrl("activity_9001666_Ctrl"):getClassType()
	local rewardList = activity_9001666_Read.match_reward[classType]
	for _, v in ipairs(rewardList) do
		if distance < v.distance then
			return v
		end
	end
	return rewardList[#rewardList]
end
function activity_9001666_Read.getRechargeCfg(rechargeID)
	for i, v in ipairs(activity_9001666_Read.snow_competition_recharge) do
		if v.rechargeID == rechargeID then
			return v
		end
	end
end
function activity_9001666_Read.getRewardList()
	local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
	local classType = activity_9001666_Ctrl:getClassType()
	return activity_9001666_Read.battlepass[classType]
end
function activity_9001666_Read.getLevelReward(day)
	local rewardList = activity_9001666_Read.getRewardList()
	return rewardList[day]
end
function activity_9001666_Read.getMaxLevel()
	local rewardList = activity_9001666_Read.getRewardList()
	return #rewardList
end
function activity_9001666_Read.getRewardDataSize()
	local rewardList = activity_9001666_Read.getRewardList()
	return #rewardList
end
function activity_9001666_Read.getAdvanceRewardItem()
	local activity_9001666_Read, reward
	local rewardList = activity_9001666_Read.getRewardList()
	for i, v in ipairs(rewardList) do
		if v.advanceReward[1] and not reward[tostring(v.advanceReward[1].id)] then
			reward[tostring(v.advanceReward[1].id)] = 0
		end
		if v.advanceReward[2] and not reward[tostring(v.advanceReward[2].id)] then
			reward[tostring(v.advanceReward[2].id)] = 0
		end
	end
	for i, v in ipairs(rewardList) do
		if v.advanceReward[1] then
			reward[tostring(v.advanceReward[1].id)] = reward[tostring(v.advanceReward[1].id)] + v.advanceReward[1].count
		end
		if v.advanceReward[2] then
			reward[tostring(v.advanceReward[2].id)] = reward[tostring(v.advanceReward[2].id)] + v.advanceReward[2].count
		end
	end
	local index = 1
	local activity_9001666_Read, result = ipairs(rewardList)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function activity_9001666_Read.CheckLastLevel()
	local rewardList = activity_9001666_Read.getRewardList()
	local size = table.nums(rewardList)
	if 1 <= size then
		return true, size
	end
	return false
end
function activity_9001666_Read.getLevelRewardSize()
	return activity_9001666_Read.getNormalRewardSize() + activity_9001666_Read.getExtraRewardSize()
end
function activity_9001666_Read.getNormalRewardSize(index)
	local rewardList = activity_9001666_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].normalReward)
	else
		return 0
	end
end
function activity_9001666_Read.getExtraRewardSize(index)
	local rewardList = activity_9001666_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].advanceReward)
	else
		return 0
	end
end
function activity_9001666_Read.getShowRewad(index)
	local rewardList = activity_9001666_Read.getRewardList()
	local cfg, cfg1
	for i = #rewardList, 1, -1 do
		cfg = rewardList[i]
		cfg1 = cfg1 or cfg
		if index > cfg.lv then
			break
		end
		cfg1 = cfg
	end
	print("==1====", index, cfg1.lv)
	return cfg1
end
function activity_9001666_Read.getLevelCfg(level)
	local cfg = activity_9001666_Read.attr[level]
	return cfg
end
function activity_9001666_Read.getBoxCfgs()
	local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
	local classType = activity_9001666_Ctrl:getClassType()
	if not activity_9001666_Read.stage_reward[classType] then
		_ENV = activity_9001666_Read.stage_reward[classType]
	end
	return activity_9001666_Read.stage_reward[classType]
end
function activity_9001666_Read.getAchievementCfgs()
	return activity_9001666_Read.snow_competition_achivement
end
function activity_9001666_Read.getRankCfgs()
	local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
	local classType = activity_9001666_Ctrl:getClassType()
	if not activity_9001666_Read.rank_reward[classType] then
		_ENV = activity_9001666_Read.rank_reward[classType]
	end
	return activity_9001666_Read.rank_reward[classType]
end
function activity_9001666_Read.getRuleCfgs()
	return activity_9001666_Read.rule
end
function activity_9001666_Read.getDistanceGroupCfg()
	return activity_9001666_Read.snow_competition_group
end
return activity_9001666_Read
