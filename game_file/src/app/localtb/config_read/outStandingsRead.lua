local outStandingsRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "outstanding_basic"
	;(nil)[2] = true
	outStandingsRead:defineValue("outstandingBasic", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "outstanding_rank_reward"
	;(nil)[2] = true
	outStandingsRead:defineValue("outstandingRankReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "outstanding_rank_floor"
	;(nil)[2] = true
	outStandingsRead:defineValue("outstandingFloorReward", nil)
end
init()
function outStandingsRead.getBasicScoreByType(classType, basicType)
	local _ENV, valueList
	for i, v in ipairs(outStandingsRead.outstandingBasic) do
		if v.classType == classType and v.cfgType == basicType then
			table.insert(valueList, v.value)
		end
	end
	return valueList
end
function outStandingsRead.getMaxClassType()
	local maxClassType = 0
	for i, v in ipairs(outStandingsRead.outstandingBasic) do
		if maxClassType < v.classType then
			maxClassType = v.classType
		end
	end
	return maxClassType
end
function outStandingsRead.getTypeCount(tpye)
	local count = 0
	for k, v in ipairs(outStandingsRead.outstandingBasic) do
		if tpye > v.cfgType then
			count = count + 1
		end
	end
	return count
end
function outStandingsRead.getRealIndex(classType, basicType, index)
	local realIndex = 0
	print("classType, basicType, index ==== ", classType, basicType, index)
	for i, v in ipairs(outStandingsRead.outstandingBasic) do
		if v.classType == classType and v.cfgType == basicType then
			print("v.index <= index ", v.index, index, realIndex)
			if index >= v.index then
				realIndex = realIndex + 1
			end
		end
	end
	return realIndex
end
function outStandingsRead.getBasicRewardsByIndex(index, basicType, classType)
	local rewardList
	if outStandingsRead.outstandingBasic[index] then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		rewardList = serviceFunctions.tableFormat(outStandingsRead.outstandingBasic[index].reward, nil)
	end
	return rewardList
end
function outStandingsRead:getNeedFloorPoint(floorType)
	local point = 0
	for i, v in ipairs(outStandingsRead.outstandingFloorReward) do
		if v.cfgType == floorType then
			point = v.floorValue
			break
		end
	end
	return point
end
function outStandingsRead.getRankingRewardByType(index, rankType)
	local rewardList
	local _ENV, cfgs
	for i, v in ipairs(outStandingsRead.outstandingRankReward) do
		if rankType == v.cfgType then
			table.insert(cfgs, v)
		end
	end
	if cfgs[index] then
		_UPVALUE2_ = ipairs(outStandingsRead.outstandingRankReward)
		ipairs(outStandingsRead.outstandingRankReward)[1] = "id"
		ipairs(outStandingsRead.outstandingRankReward)[2] = "count"
		rewardList = serviceFunctions.tableFormat(cfgs[index].reward, ipairs(outStandingsRead.outstandingRankReward))
	end
	return rewardList
end
function outStandingsRead.getRankingInfo(rankType)
	local _ENV, rankInfo
	for i, v in ipairs(outStandingsRead.outstandingRankReward) do
		if v.cfgType == rankType then
			table.insert(rankInfo, v.rank)
		end
	end
	return rankInfo
end
return outStandingsRead
