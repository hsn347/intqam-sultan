local activity_9001691_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "surprise_box_battlepass"
;(nil)[2] = true
activity_9001691_Read:defineValue("surprise_box_battlepass", nil)
_UPVALUE2_ = nil
;(nil)[1] = "surprise_box_main"
;(nil)[2] = true
activity_9001691_Read:defineValue("surprise_box_main", nil)
_UPVALUE2_ = nil
;(nil)[1] = "surprise_box_recharge"
;(nil)[2] = true
activity_9001691_Read:defineValue("surprise_box_recharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "surprise_box_reward"
;(nil)[2] = true
activity_9001691_Read:defineValue("surprise_box_reward", nil)
activity_9001691_Read:defineValue("battlepass", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001691_Read.surprise_box_battlepass) do
		v.classType = 1
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
		ret[v.classType][v.lv] = v
	end
	return ret
end)
local createData = function(name)
	activity_9001691_Read.gameReward, activity_9001691_Read, activity_9001691_Read.rankReward, activity_9001691_Read = nil, nil, nil, nil
	for k, v in ipairs(activity_9001691_Read.surprise_box_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.stageReward, nil)
		if v.rewardType == 1 then
			activity_9001691_Read.gameReward[v.classType] = v
		else
			if not activity_9001691_Read.rankReward[v.classType] then
				activity_9001691_Read.rankReward[v.classType], activity_9001691_Read = nil, nil
			end
			table.insert(activity_9001691_Read.rankReward[v.classType], v)
		end
	end
	dump(activity_9001691_Read[name], "activity_9001691_Read[name]")
	return activity_9001691_Read[name]
end
activity_9001691_Read:defineValue("rankReward", createData)
activity_9001691_Read:defineValue("gameReward", createData)
function activity_9001691_Read.getRechargeCfg()
	return activity_9001691_Read.surprise_box_recharge[1]
end
function activity_9001691_Read.getRewardList()
	local classType = 1
	return activity_9001691_Read.battlepass[classType]
end
function activity_9001691_Read.getLevelReward(day)
	local rewardList = activity_9001691_Read.getRewardList()
	return rewardList[day]
end
function activity_9001691_Read.getMaxLevel()
	local rewardList = activity_9001691_Read.getRewardList()
	return #rewardList
end
function activity_9001691_Read.getRewardDataSize()
	local rewardList = activity_9001691_Read.getRewardList()
	return #rewardList
end
function activity_9001691_Read.getAdvanceRewardItem()
	local activity_9001691_Read, reward
	local rewardList = activity_9001691_Read.getRewardList()
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
	local activity_9001691_Read, result = ipairs(rewardList)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function activity_9001691_Read.CheckLastLevel()
	local rewardList = activity_9001691_Read.getRewardList()
	local size = table.nums(rewardList)
	if 1 <= size then
		return true, size
	end
	return false
end
function activity_9001691_Read.getLevelRewardSize()
	return activity_9001691_Read.getNormalRewardSize() + activity_9001691_Read.getExtraRewardSize()
end
function activity_9001691_Read.getNormalRewardSize(index)
	local rewardList = activity_9001691_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].normalReward)
	else
		return 0
	end
end
function activity_9001691_Read.getExtraRewardSize(index)
	local rewardList = activity_9001691_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].advanceReward)
	else
		return 0
	end
end
function activity_9001691_Read.getShowRewad(index)
	local rewardList = activity_9001691_Read.getRewardList()
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
function activity_9001691_Read.getMainCfgs()
	return activity_9001691_Read.surprise_box_main
end
function activity_9001691_Read.getMainCfg(level)
	return activity_9001691_Read.surprise_box_main[level]
end
function activity_9001691_Read.getGameReward()
	local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
	local classType = activity_9001691_Ctrl:getClassType()
	local gameRewardCfg = activity_9001691_Read.gameReward[classType]
	if not gameRewardCfg or not gameRewardCfg.reward then
		_ENV = gameRewardCfg.reward
	end
	return gameRewardCfg.reward
end
function activity_9001691_Read.getRankCfgs()
	local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
	local classType = activity_9001691_Ctrl:getClassType()
	if not activity_9001691_Read.rankReward[classType] then
		_ENV = activity_9001691_Read.rankReward[classType]
	end
	return activity_9001691_Read.rankReward[classType]
end
activity_9001691_Read:defineValue("guide_step", function()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	_UPVALUE0_, (nil)[1], (nil).talk = nil, nil, "surprise_box_058"
	_UPVALUE1_, (nil).talk = nil, "surprise_box_059"
	_UPVALUE0_, (nil)[2], (nil).highLightUIs, (nil)[1] = nil, nil, nil, "box"
	;(nil).talk = "surprise_box_060"
	_UPVALUE0_, (nil)[3], (nil).mask = nil, nil, "guide_open"
	_UPVALUE2_, (nil).talk = nil, "surprise_box_061"
	;(nil)[4], (nil).highLightUIs, (nil)[1] = nil, nil, "list_myhp"
	;(nil)[4], (nil).highLightUIs, (nil)[2] = nil, nil, "list_aihp"
	return nil
end)
function activity_9001691_Read.getGuideStep(index)
	return activity_9001691_Read.guide_step[index]
end
return activity_9001691_Read
