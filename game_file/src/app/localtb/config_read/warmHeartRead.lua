local warmHeartRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "warm_heart_stage_reward"
	;(nil)[2] = true
	warmHeartRead:defineValue("whsr", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "warm_heart_coin"
	;(nil)[2] = true
	warmHeartRead:defineValue("whc", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "warm_heart_ranking_reward"
	;(nil)[2] = true
	warmHeartRead:defineValue("whrr", nil)
end
function warmHeartRead.getStageRewardInfo()
	local _ENV, rewardInfo
	for i, v in ipairs(warmHeartRead.whsr) do
		table.insert(rewardInfo, v)
	end
	return rewardInfo
end
function warmHeartRead.getCostCoinPrice(alreadyBuyCount, buyCount)
	local costCoinPrice = 0
	local totalCount = alreadyBuyCount + buyCount
	for i = alreadyBuyCount + 1, totalCount do
		costCoinPrice = costCoinPrice + warmHeartRead.getCount(i)
		print("slkdjflksdjfklsd", i, warmHeartRead.getCount(i), costCoinPrice)
	end
	return costCoinPrice
end
function warmHeartRead.getCount(index)
	local price = 0
	for i, v in ipairs(warmHeartRead.whc) do
		if index >= v.count[1] and index <= v.count[2] then
			price = v.price
		end
	end
	return price
end
function warmHeartRead.getRankRewardInfo(rankType)
	local _ENV, rewardRankInfo
	for i, v in ipairs(warmHeartRead.whrr) do
		if rankType == v.type then
			table.insert(rewardRankInfo, v)
		end
	end
	return rewardRankInfo
end
init()
return warmHeartRead
