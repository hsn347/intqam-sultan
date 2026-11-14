local starEnergyCubeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "star_cube_box"
	;(nil)[2] = true
	starEnergyCubeRead:defineValue("stb", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "star_cube_fight"
	;(nil)[2] = true
	starEnergyCubeRead:defineValue("stf", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "star_cube_monster"
	;(nil)[2] = true
	starEnergyCubeRead:defineValue("stm", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "star_cube_reward"
	;(nil)[2] = true
	starEnergyCubeRead:defineValue("str", nil)
	starEnergyCubeRead:defineValue("strConfig", function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)
	function _UPVALUE2_()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end
	;(function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)[1] = "random_item_config"
	;(function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)[2] = true
	starEnergyCubeRead:defineValue("random_item_config", function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)
	function _UPVALUE2_()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end
	;(function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)[1] = "star_cube_total_reward"
	;(function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)[2] = true
	starEnergyCubeRead:defineValue("sctr", function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.str)
	end)
	starEnergyCubeRead:defineValue("sctrConfig", function()
		return starEnergyCubeRead.getClassTypeConfig(starEnergyCubeRead.sctr)
	end)
end
init()
function starEnergyCubeRead:getAccuRewardInfo()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.STAR_CUBE_ACTIVITY)
	return starEnergyCubeRead.sctrConfig[classType]
end
function starEnergyCubeRead:getNextAccuRewardInfo(curOpenTimes)
	local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
	local config = starEnergyCubeRead:getAccuRewardInfo()
	for i, v in ipairs(config) do
		if curOpenTimes < v.totalOpenNum then
			return curOpenTimes, v.totalOpenNum, i, 1
		elseif curOpenTimes == v.totalOpenNum and not starCubeCtrl:isInStageReward(i) then
			return curOpenTimes, v.totalOpenNum, i, 2
		elseif not starCubeCtrl:isInStageReward(i) then
			return curOpenTimes, v.totalOpenNum, i, 2
		end
	end
	local maxSatgeOpenTimes = config[#config].totalOpenNum
	return curOpenTimes, maxSatgeOpenTimes, #config, 3
end
function starEnergyCubeRead:getAccuRewardMaxNum()
	local config = starEnergyCubeRead:getAccuRewardInfo()
	return config[#config].totalOpenNum
end
function starEnergyCubeRead:getCurScoreLevel(curOpenTimes)
	local curlevel = 0
	local config = starEnergyCubeRead:getAccuRewardInfo()
	for i, v in ipairs(config) do
		if curOpenTimes >= v.totalOpenNum then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function starEnergyCubeRead.getLeftNum(curValue, curLevel)
	if 0 < curLevel then
		local config = starEnergyCubeRead:getAccuRewardInfo()
		return curValue - config[curLevel].totalOpenNum
	else
		return curValue
	end
end
function starEnergyCubeRead.getLevelNum(level)
	if 0 < level then
		local config = starEnergyCubeRead:getAccuRewardInfo()
		return config[level].totalOpenNum
	else
		return 0
	end
end
function starEnergyCubeRead:getTreasureChestInfo(boxType)
	local starEnergyCubeRead, chestInfo
	if starEnergyCubeRead.stb[boxType] then
		chestInfo = starEnergyCubeRead.stb[boxType]
	end
	return chestInfo
end
function starEnergyCubeRead:getTreasureKeyTable(boxType)
	local starEnergyCubeRead, keyTable
	if starEnergyCubeRead.stb[boxType] then
		keyTable = starEnergyCubeRead.stb[boxType].key
	end
	return keyTable
end
function starEnergyCubeRead:getTotalTreasureOpenCount()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local totalCount = 0
	for i, v in ipairs(starEnergyCubeRead.stb) do
		local keyTable = self:getTreasureKeyTable(i)
		local smallCount = 0
		if keyTable and next(keyTable) then
			for i, v in ipairs(keyTable) do
				local keyCount = backpackCtrl:getItemCount(keyTable[i])
				if i == 1 then
					smallCount = keyCount
				end
				if keyCount < smallCount then
					smallCount = keyCount
				end
			end
		end
		totalCount = totalCount + smallCount
	end
	return totalCount
end
function starEnergyCubeRead:getCurChestState(keyTable)
	if not next(keyTable) then
		return
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local chestState = gRaidersLostArkChestStatus.UNSNATCH
	local totalCount = 0
	for i, v in ipairs(keyTable) do
		local keyCount = backpackCtrl:getItemCount(v)
		if 0 < keyCount then
			totalCount = totalCount + 1
		end
	end
	if 0 < totalCount then
		chestState = gRaidersLostArkChestStatus.SNATCH
	end
	if totalCount == 3 then
		chestState = gRaidersLostArkChestStatus.CANOPEN
	end
	return chestState
end
function starEnergyCubeRead:getBoxCount()
	return table.nums(starEnergyCubeRead.stb)
end
function starEnergyCubeRead:getRewardHightlightByType(type)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.STAR_CUBE_ACTIVITY)
	for i, v in ipairs(starEnergyCubeRead.strConfig[classType]) do
		if v.type == type then
			return v.highlight
		end
	end
	_ENV = (for generator)
	return ipairs(starEnergyCubeRead.strConfig[classType])
end
function starEnergyCubeRead:getRadomRewardByType(type)
	local _ENV, rewards
	local count = 0
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.STAR_CUBE_ACTIVITY)
	for i, v in ipairs(starEnergyCubeRead.strConfig[classType]) do
		if v.type == type then
			local index = 1
			while index <= table.nums(v.reward) do
				rewards, count = self:getTopFourRewards(starEnergyCubeRead.random_item_config[v.reward[index]].items, rewards, count, 3)
				index = index + 3
			end
			return rewards
		end
	end
	return rewards
end
function starEnergyCubeRead:getTopFourRewards(array, rewards, count, step)
	if 4 <= count or not next(array) then
		return rewards, count
	end
	local t = 1
	while t < table.nums(array) and count < 4 do
		local hasSame = false
		for i, v in ipairs(rewards) do
			if v == array[t] then
				hasSame = true
				break
			end
		end
		if not hasSame then
			table.insert(rewards, array[t])
			count = count + 1
		end
		t = t + step
	end
	return rewards, count
end
return starEnergyCubeRead
