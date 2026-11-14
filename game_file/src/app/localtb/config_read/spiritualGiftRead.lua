local spiritualGiftRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "nafu_config"
	;(nil)[2] = true
	spiritualGiftRead:defineValue("nc", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "nafu_big_pool"
	;(nil)[2] = true
	spiritualGiftRead:defineValue("nbp", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "nafu_prize_pool"
	;(nil)[2] = true
	spiritualGiftRead:defineValue("npp", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "nafu_lucky_number"
	;(nil)[2] = true
	spiritualGiftRead:defineValue("nln", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "nafu_rank_reward"
	;(nil)[2] = true
	spiritualGiftRead:defineValue("nrr", nil)
	spiritualGiftRead = nil
	;(nil)[1] = "nafu_pool_show"
	spiritualGiftRead:defineValue("nps", nil)
end
function spiritualGiftRead:getRealCfg(config, group)
	local _ENV, cfg
	local _index = 1
	for k, v in ipairs(config) do
		if v.group == group then
			v.index = _index
			cfg[_index] = v
			_index = _index + 1
		end
	end
	return cfg
end
function spiritualGiftRead:getTopPriceLimit(group)
	local topPriceLimit = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		topPriceLimit = cfg[1].topPriceLimit
	end
	return topPriceLimit
end
function spiritualGiftRead:getEarnScore(group)
	local earnScore = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		earnScore = cfg[1].earnScore
	end
	return earnScore
end
function spiritualGiftRead:getInitGold(group)
	local initGold = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		initGold = cfg[1].initGold
	end
	return initGold
end
function spiritualGiftRead:getTaxCost(group)
	local taxCost = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		taxCost = cfg[1].taxCost
	end
	return taxCost
end
function spiritualGiftRead:getRankTop3Limit(group)
	local rankTop3Limit = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		rankTop3Limit = cfg[1].rankTop3Limit
	end
	return rankTop3Limit
end
function spiritualGiftRead:getPrizePoolRewardByIndex(group, index, poolType)
	local reward
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.npp, group)
	if cfg[index] and poolType == cfg[index].type then
		_UPVALUE2_ = group
		group[1] = "id"
		group[2] = "count"
		reward = serviceFunctions.tableFormat(cfg[index].reward, group)
	end
	return reward
end
function spiritualGiftRead:getPrizePoolRewardsForPreview(group)
	local spiritualGiftRead, rewards
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.npp, group)
	for i, v in ipairs(cfg) do
		if not rewards[v.type] then
			rewards[v.type], spiritualGiftRead = nil, nil
		end
		table.insert(rewards[v.type], v.reward)
	end
	return rewards
end
function spiritualGiftRead:getPrizePoolRewardsNumByType(group, poolType)
	local totalNum = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.npp, group)
	for i, v in ipairs(cfg) do
		if v.type == poolType then
			totalNum = totalNum + 1
		end
	end
	return totalNum
end
function spiritualGiftRead:getOneTimeTicketCost(group)
	local oneTimeCost = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		oneTimeCost = cfg[1].buyTicketCost
	end
	return oneTimeCost
end
function spiritualGiftRead:getDailyBuyLimit(group)
	local dailyLimit = 0
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nc, group)
	if cfg[1] then
		dailyLimit = cfg[1].dailyLimit
	end
	return dailyLimit
end
function spiritualGiftRead:getNormalPrizePreview(group)
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nps, group)
	return cfg[1].reward
end
function spiritualGiftRead:getPoolUpperLimit(group, playerScore)
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nbp, group)
	local finalScore = cfg[1].initialScore
	local increaseStep = cfg[1].incrScore
	if playerScore > finalScore then
		finalScore = finalScore + math.ceil((playerScore - finalScore) / increaseStep) * increaseStep
	elseif playerScore == finalScore then
		finalScore = finalScore + increaseStep
	end
	return finalScore
end
function spiritualGiftRead:getOutRankShowRewards(group)
	local spiritualGiftRead, rewards
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nrr, group)
	if cfg[1] then
		rewards = cfg[1].reward
	end
	return rewards
end
function spiritualGiftRead:getRankShowAllRewards(group)
	local spiritualGiftRead, rewards
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nrr, group)
	for i, v in ipairs(cfg) do
		table.insert(rewards, v)
	end
	return rewards
end
function spiritualGiftRead:getLuckyNumberInfo(group)
	local spiritualGiftRead, luckyNumberList
	local cfg = spiritualGiftRead:getRealCfg(spiritualGiftRead.nln, group)
	for i, v in ipairs(cfg) do
		if v.luckyNum ~= 0 then
			table.insert(luckyNumberList, v)
		end
	end
	return luckyNumberList
end
init()
return spiritualGiftRead
