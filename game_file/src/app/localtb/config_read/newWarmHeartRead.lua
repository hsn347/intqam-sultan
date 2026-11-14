local newWarmHeartRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "celebrate_eidal_stage_reward"
	;(nil)[2] = true
	newWarmHeartRead:defineValue("whsr", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "celebrate_eidal_coin"
	;(nil)[2] = true
	newWarmHeartRead:defineValue("whc", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "celebrate_eidal_ranking_reward"
	;(nil)[2] = true
	newWarmHeartRead:defineValue("whrr", nil)
end
function newWarmHeartRead.getStageRewardInfo()
	local _ENV, rewardInfo
	for i, v in ipairs(newWarmHeartRead.whsr) do
		table.insert(rewardInfo, v)
	end
	return rewardInfo
end
function newWarmHeartRead.getCostCoinPrice(alreadyBuyCount, buyCount)
	local costCoinPrice = 0
	local totalCount = alreadyBuyCount + buyCount
	for i = alreadyBuyCount + 1, totalCount do
		costCoinPrice = costCoinPrice + newWarmHeartRead.getCount(i)
		print("slkdjflksdjfklsd", i, newWarmHeartRead.getCount(i), costCoinPrice)
	end
	return costCoinPrice
end
function newWarmHeartRead.getCount(index)
	local price = 0
	for i, v in ipairs(newWarmHeartRead.whc) do
		if index >= v.count[1] and index <= v.count[2] then
			price = v.price
		end
	end
	return price
end
function newWarmHeartRead.getRankRewardInfo(rankType)
	local _ENV, rewardRankInfo
	for i, v in ipairs(newWarmHeartRead.whrr) do
		if rankType == v.type then
			table.insert(rewardRankInfo, v)
		end
	end
	return rewardRankInfo
end
init()
return newWarmHeartRead
