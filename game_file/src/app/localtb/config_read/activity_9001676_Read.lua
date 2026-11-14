local activity_9001676_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "korean_chess_battlepass"
;(nil)[2] = true
activity_9001676_Read:defineValue("korean_chess_battlepass", nil)
_UPVALUE2_ = nil
;(nil)[1] = "korean_chess_recharge"
;(nil)[2] = true
activity_9001676_Read:defineValue("korean_chess_recharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "korean_chess_element"
;(nil)[2] = true
activity_9001676_Read:defineValue("korean_chess_element", nil)
_UPVALUE1_ = nil
;(nil)[1] = "korean_chess_ai_client"
activity_9001676_Read:defineValue("korean_chess_ai_client", nil)
_UPVALUE2_ = nil
;(nil)[1] = "korean_chess_ai"
;(nil)[2] = true
activity_9001676_Read:defineValue("korean_chess_ai", nil)
_UPVALUE2_ = nil
;(nil)[1] = "korean_chess_reward"
;(nil)[2] = true
activity_9001676_Read:defineValue("korean_chess_reward", nil)
activity_9001676_Read:defineValue("battlepass", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001676_Read.korean_chess_battlepass) do
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
activity_9001676_Read:defineValue("reward", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001676_Read.korean_chess_reward) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		ret[v.classType][v.type] = v
	end
	return ret
end)
local KOREAN_CHESS_SHOT_MAX_TIME = 30
local KOREAN_CHESS_SHOT_TO_END_MAX_TIME = KOREAN_CHESS_SHOT_MAX_TIME + 30
local KOREAN_CHESS_ROOM_MAX_TIME = 600
local KOREAN_CHESS_ROOM_READY_MAX_TIME = 86400
local KOREAN_CHESS_ROOM_MODE_CD = 30
local KOREAN_CHESS_MATCH_MIN_TIME = 3
local KOREAN_CHESS_MATCH_MAX_TIME = 60
function activity_9001676_Read.getRoomModeCD()
	return KOREAN_CHESS_ROOM_MODE_CD
end
function activity_9001676_Read.getMatchModeCD()
	return KOREAN_CHESS_MATCH_MIN_TIME
end
function activity_9001676_Read.getRechargeCfg(gifttype)
	for i, v in ipairs(activity_9001676_Read.korean_chess_recharge) do
		if v.gifttype == gifttype then
			return v
		end
	end
end
function activity_9001676_Read.getRechargeCfgList(gifttype)
	local _ENV, ret
	for i, v in ipairs(activity_9001676_Read.korean_chess_recharge) do
		if v.gifttype == gifttype then
			table.insert(ret, v)
		end
	end
	return ret
end
function activity_9001676_Read.getRewardList()
	return activity_9001676_Read.battlepass[1]
end
function activity_9001676_Read.getLevelReward(day)
	local rewardList = activity_9001676_Read.getRewardList()
	return rewardList[day]
end
function activity_9001676_Read.getMaxLevel()
	local rewardList = activity_9001676_Read.getRewardList()
	return #rewardList
end
function activity_9001676_Read.getRewardDataSize()
	local rewardList = activity_9001676_Read.getRewardList()
	return #rewardList
end
function activity_9001676_Read.getAdvanceRewardItem()
	local activity_9001676_Read, reward
	local rewardList = activity_9001676_Read.getRewardList()
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
	local activity_9001676_Read, result = ipairs(rewardList)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function activity_9001676_Read.CheckLastLevel()
	local rewardList = activity_9001676_Read.getRewardList()
	local size = table.nums(rewardList)
	if 1 <= size then
		return true, size
	end
	return false
end
function activity_9001676_Read.getLevelRewardSize()
	return activity_9001676_Read.getNormalRewardSize() + activity_9001676_Read.getExtraRewardSize()
end
function activity_9001676_Read.getNormalRewardSize(index)
	local rewardList = activity_9001676_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].normalReward)
	else
		return 0
	end
end
function activity_9001676_Read.getExtraRewardSize(index)
	local rewardList = activity_9001676_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].advanceReward)
	else
		return 0
	end
end
function activity_9001676_Read.getShowRewad(index)
	local rewardList = activity_9001676_Read.getRewardList()
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
function activity_9001676_Read.getElement(id)
	local cfg = activity_9001676_Read.korean_chess_element[id]
	return cfg
end
function activity_9001676_Read.getIsRoomTimeOut(stateTime)
	if stateTime + KOREAN_CHESS_ROOM_READY_MAX_TIME > serviceFunctions.systemTime() then
		return false
	else
		return true
	end
end
function activity_9001676_Read.getAIPlayers()
	return activity_9001676_Read.korean_chess_ai_client
end
function activity_9001676_Read.getRandomAICfg()
	local randomParam = activity_9001676_Read.randomParam
	if activity_9001676_Read.randomParam == nil then
		randomParam, activity_9001676_Read = activity_9001676_Read.randomParam, activity_9001676_Read.randomParam
		for i, v in ipairs(activity_9001676_Read.korean_chess_ai) do
			table.insert(randomParam, v.weights)
		end
		activity_9001676_Read.randomParam = randomParam
	end
	local randIndex = SoraDRandomItem(randomParam)
	return activity_9001676_Read.korean_chess_ai[randIndex]
end
function activity_9001676_Read.getReward(type)
	local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
	local classType = activity_9001676_Ctrl:getClassType()
	return activity_9001676_Read.reward[classType][type]
end
return activity_9001676_Read
