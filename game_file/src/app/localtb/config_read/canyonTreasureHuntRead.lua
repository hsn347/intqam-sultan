local canyonTreasureHuntRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "canyon_treasure_discount"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("ctd", nil)
	_ENV = nil
	;(nil)[1] = "canyon_treasure_reward"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("ctr", nil)
	_ENV = nil
	;(nil)[1] = "canyon_discount_time"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("cdt", nil)
	_ENV = nil
	;(nil)[1] = "canyon_treasure_config"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("ctc", nil)
	_ENV = nil
	;(nil)[1] = "canyon_treasure_gold"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("ctg", nil)
	_ENV = nil
	;(nil)[1] = "canyon_treasure_discount_effect"
	;(nil)[2] = true
	canyonTreasureHuntRead:defineValue("ctde", nil)
	canyonTreasureHuntRead:defineValue("ctrConfig", function()
		local _ENV, ctrConfig
		for i, v in ipairs(canyonTreasureHuntRead.ctr) do
			if not ctrConfig[v.canyonType] then
				_ENV = ctrConfig[v.canyonType]
			end
			ctrConfig[v.canyonType] = ctrConfig[v.canyonType]
			if not ctrConfig[v.canyonType][v.rewardType] then
				_ENV = ctrConfig[v.canyonType][v.rewardType]
			end
			ctrConfig[v.canyonType][v.rewardType] = ctrConfig[v.canyonType][v.rewardType]
			table.insert(ctrConfig[v.canyonType][v.rewardType], v)
		end
		return ctrConfig
	end)
end
init()
function canyonTreasureHuntRead.getTreasureOptionalReward(canyonType, rewardType)
	local canyonTreasureHuntRead, rewardList
	local config = canyonTreasureHuntRead.getCtrConfigByType(canyonType, rewardType)
	for i, v in ipairs(config) do
		table.insert(rewardList, v.item)
		table.insert(rewardList, v.num)
	end
	_UPVALUE2_ = ipairs(config)
	ipairs(config)[1] = "id"
	ipairs(config)[2] = "count"
	rewardList = serviceFunctions.tableFormat(rewardList, ipairs(config))
	return rewardList
end
function canyonTreasureHuntRead.getCtrConfigByType(canyonType, rewardType)
	return canyonTreasureHuntRead.ctrConfig[canyonType][rewardType]
end
function canyonTreasureHuntRead.getCtrConfigByID(id)
	return canyonTreasureHuntRead.ctr[id]
end
function canyonTreasureHuntRead.getGoldCostByTimes(times)
	if 6 <= times then
		return canyonTreasureHuntRead.ctg[#canyonTreasureHuntRead.ctg].gold
	end
	return canyonTreasureHuntRead.ctg[times + 1].gold
end
function canyonTreasureHuntRead.getTreasureCost(canyonType, times)
	local numType = 1
	if times ~= 1 then
		numType = 2
	end
	for i, v in ipairs(canyonTreasureHuntRead.ctc) do
		if v.canyonType == canyonType and v.type == numType then
			return v.spend[2]
		end
	end
end
function canyonTreasureHuntRead.getDisCountByType(canyonType)
	local _ENV, discountTable
	for i, v in ipairs(canyonTreasureHuntRead.ctd) do
		if v.type == canyonType then
			table.insert(discountTable, v)
		end
	end
	return discountTable
end
return canyonTreasureHuntRead
