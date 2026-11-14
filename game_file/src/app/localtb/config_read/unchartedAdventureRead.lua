local unchartedAdventureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "secret_explore_map"
	;(nil)[2] = true
	unchartedAdventureRead:defineValue("unchartedReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "secret_explore_shop"
	;(nil)[2] = true
	unchartedAdventureRead:defineValue("unchartedShop", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "secret_explore_surprise"
	;(nil)[2] = true
	unchartedAdventureRead:defineValue("unchartedSurprise", nil)
	unchartedAdventureRead = nil
	;(nil)[1] = "secret_explore_exchange"
	unchartedAdventureRead:defineValue("unchartedExchange", nil)
end
function unchartedAdventureRead.getClearanceReward()
	local _ENV, rewardList
	for i, v in ipairs(unchartedAdventureRead.unchartedReward) do
		table.insert(rewardList, v.ItemReward)
	end
	return rewardList
end
function unchartedAdventureRead.getClearanceRewardByIndex(index)
	local _ENV, rewardList
	for i, v in ipairs(unchartedAdventureRead.unchartedReward) do
		if i == index then
			table.insert(rewardList, v.ItemReward)
		end
	end
	return rewardList
end
function unchartedAdventureRead.getPointsRewardByIndex(index)
	local points = 0
	for i, v in ipairs(unchartedAdventureRead.unchartedReward) do
		if i == index then
			points = v.PointReward
			break
		end
	end
	return points
end
function unchartedAdventureRead.getSaleItemsList()
	local _ENV, itemList
	for i, v in ipairs(unchartedAdventureRead.unchartedShop) do
		if v.Sale == 1 then
			table.insert(itemList, v)
		end
	end
	return itemList
end
function unchartedAdventureRead.getAllStoreItemList()
	local _ENV, itemList
	for i, v in ipairs(unchartedAdventureRead.unchartedShop) do
		local keys = v.NeedRound
		if not itemList[keys + 1] then
			itemList[keys + 1], _ENV = nil, nil
		end
		table.insert(itemList[keys + 1], v)
	end
	return itemList
end
function unchartedAdventureRead.getSurpriseReward(type, effect)
	local _ENV, itemList
	for i, v in ipairs(unchartedAdventureRead.unchartedSurprise) do
		if type == v.Type and effect == v.Effect then
			table.insert(itemList, v)
		end
	end
	return itemList[1]
end
function unchartedAdventureRead.getExchangeCoinList()
	local _ENV, exchangeList
	for i, v in ipairs(unchartedAdventureRead.unchartedExchange) do
		table.insert(exchangeList, v)
	end
	return exchangeList
end
init()
return unchartedAdventureRead
