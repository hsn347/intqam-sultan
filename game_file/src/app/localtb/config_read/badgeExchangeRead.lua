local badgeExchangeRead = include("aAReadClass").new()
function badgeExchangeRead:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "badge_exchange"
	;(nil)[2] = true
	badgeExchangeRead:defineValue("badgeExchange", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "badge_exchange_limit"
	;(nil)[2] = true
	badgeExchangeRead:defineValue("badge_exchange_limit", nil)
	badgeExchangeRead:defineValue("badgeExchangeCostList", function()
		local _ENV, badgeExchangeCostList
		for k, v in ipairs(badgeExchangeRead.badgeExchange) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local costTb = serviceFunctions.tableFormat(v.cost, nil)
			if not badgeExchangeCostList[v.badgeType] then
				badgeExchangeCostList[v.badgeType], _ENV = nil, nil
			end
			for _, cfg in ipairs(costTb) do
				if not badgeExchangeCostList[v.badgeType][cfg.id] then
					badgeExchangeCostList[v.badgeType][cfg.id], _ENV = nil, nil
				end
				badgeExchangeCostList[v.badgeType][cfg.id][v.num] = cfg.count
			end
		end
		return badgeExchangeCostList
	end)
	badgeExchangeRead:defineValue("exchangeConfig", function()
		local _ENV, exchangeConfig
		for bType, v in pairs(badgeExchangeRead.badgeExchangeCostList) do
			if not exchangeConfig[bType] then
				exchangeConfig[bType], _ENV = exchangeConfig[bType], exchangeConfig[bType]
			end
			for id, data in pairs(v) do
				table.insert(exchangeConfig[bType], id)
			end
			table.sort(exchangeConfig[bType])
		end
		return exchangeConfig
	end)
	badgeExchangeRead:defineValue("stage2Name", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_4939"
		;(nil)[2] = "npc_name_003"
		;(nil)[3] = "recharge_label_003"
		;(nil)[4] = "Divine_beast_text_02"
		;(nil)[5] = "garden_btn_02"
		return nil
	end)
	badgeExchangeRead:defineValue("badge_exchange_title", function()
		local _ENV, ret
		local config = require_data("badge_exchange_title", false, true).data
		for k, v in pairs(config) do
			ret[v.badgeStage] = v
		end
		return ret
	end)
end
badgeExchangeRead:init()
function badgeExchangeRead.getExchangeConfig(...)
	return badgeExchangeRead.exchangeConfig
end
function badgeExchangeRead.getExchangeBadgeType(id, bTypeList)
	for _, bType in ipairs(bTypeList) do
		local list = badgeExchangeRead.exchangeConfig[bType]
		if SoraDisInList(id, list) then
			return bType
		end
	end
	return bTypeList[1]
end
function badgeExchangeRead.getCostCfg(badgeType)
	return badgeExchangeRead.badgeExchangeCostList[badgeType]
end
function badgeExchangeRead.getCostByType(nType, exchangeNum, curExchangeNum, badgeType)
	badgeType = badgeType or gBadgeExchangeType.COMMON_BADGE_TYPE
	if not badgeExchangeRead.badgeExchangeCostList[badgeType][tonumber(nType)] then
		local _ENV, costList = badgeExchangeRead.badgeExchangeCostList[badgeType][tonumber(nType)], badgeExchangeRead.badgeExchangeCostList[badgeType][tonumber(nType)]
	end
	local lastNum = #costList
	local lastCost = costList[lastNum]
	local totalCost = 0
	local alreadyNum = 0
	local beginNum = curExchangeNum + 1
	local endNum = beginNum + exchangeNum - 1
	for i = beginNum, endNum do
		local cost = costList[i]
		if cost then
			alreadyNum = alreadyNum + 1
			totalCost = totalCost + cost
		else
			break
		end
	end
	if 0 < exchangeNum - alreadyNum then
		local cost = lastCost * (exchangeNum - alreadyNum)
		totalCost = totalCost + cost
	end
	return totalCost
end
function badgeExchangeRead.getTimeLimitType(badgeType)
	local cfg = badgeExchangeRead.getExchangeLimitCfgByType(badgeType)
	return cfg.limitType
end
function badgeExchangeRead.getOpenType(badgeType)
	local cfg = badgeExchangeRead.getExchangeLimitCfgByType(badgeType)
	return cfg.open_type
end
function badgeExchangeRead.getTecSet(badgeType)
	local cfg = badgeExchangeRead.getExchangeLimitCfgByType(badgeType)
	return cfg.tec_set
end
function badgeExchangeRead.getLimitNum(badgeType)
	local cfg = badgeExchangeRead.getExchangeLimitCfgByType(badgeType)
	return cfg.limitNum
end
function badgeExchangeRead.getExchangeLimitCfgByType(badgeType)
	for k, v in ipairs(badgeExchangeRead.badge_exchange_limit) do
		if v.badgeType == badgeType then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(badgeExchangeRead.badge_exchange_limit)
end
function badgeExchangeRead.getExchangeLimitCfg()
	return badgeExchangeRead.badge_exchange_limit
end
function badgeExchangeRead.getBadgeStageNameKey(stage)
	return badgeExchangeRead.badge_exchange_title[stage] and badgeExchangeRead.badge_exchange_title[stage].des or nil
end
return badgeExchangeRead
