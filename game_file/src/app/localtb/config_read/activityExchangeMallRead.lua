local activityExchangeMallRead = include("aAReadClass").new()
function activityExchangeMallRead:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "exchange_store_activity"
	;(nil)[2] = true
	activityExchangeMallRead:defineValue("exchangeOriCfg", nil)
	activityExchangeMallRead = activityExchangeMallRead.defineValue
	activityExchangeMallRead.defineValue.classType = 0
	activityExchangeMallRead.defineValue.ignoreCheckOpen = 0
	activityExchangeMallRead.defineValue.limitnum = 0
	local activityExchangeMallRead.defineValue.upperLimit, default = 0, activityExchangeMallRead.defineValue
	local checkAndSetValue = function(data, k, v)
		if default[k] and default[k] ~= v then
			data[k] = v
		end
	end
	local createData = function(name)
		activityExchangeMallRead.exchangeActivity, activityExchangeMallRead, activityExchangeMallRead.exchangeItemCfg, activityExchangeMallRead, activityExchangeMallRead.exchangeCfg, activityExchangeMallRead = nil, nil, nil, nil, nil, nil
		for _, v in ipairs(activityExchangeMallRead.exchangeOriCfg) do
			local activityExchangeMallRead, data
			activityExchangeMallRead = nil
			;(nil).__index = default
			setmetatable(data, nil)
			local shopitem = v.shopitem
			local exchangeitem = v.exchangeitem
			data.activityID = v.activityID
			data.shopitem = shopitem[1]
			data.shopitemnum = shopitem[2] or 1
			data.exchangeitem = exchangeitem[1]
			data.exchangenum = exchangeitem[2] or 1
			data.exchangeitem2 = exchangeitem[3]
			data.exchangenum2 = exchangeitem[4]
			data.shopItemID = v.shopItemID
			data.limitType = v.limitType
			data.exLimit = v.exLimits
			data.gloriousLv = v.gloriousLv
			checkAndSetValue(data, "limitnum", v.limitnum)
			checkAndSetValue(data, "classType", v.classType)
			checkAndSetValue(data, "ignoreCheckOpen", v.ignoreCheckOpen)
			checkAndSetValue(data, "upperLimit", v.upperLimit)
			activityExchangeMallRead.exchangeCfg[data.shopItemID] = data
			activityExchangeMallRead.exchangeItemCfg[data.shopitem] = data
			if not activityExchangeMallRead.exchangeActivity[data.activityID] then
				activityExchangeMallRead.exchangeActivity[data.activityID], activityExchangeMallRead = "upperLimit", "upperLimit"
			end
			table.insert(activityExchangeMallRead.exchangeActivity[data.activityID], data)
		end
		return activityExchangeMallRead[name]
	end
	activityExchangeMallRead:defineValue("exchangeCfg", createData)
	activityExchangeMallRead:defineValue("exchangeItemCfg", createData)
	activityExchangeMallRead:defineValue("exchangeActivity", createData)
end
activityExchangeMallRead:init()
local checkShopItemCondition = function(data, otherData)
	if not otherData then
		otherData, _ENV = nil, nil
	end
	local shopType = otherData.shopType
	if data.classType ~= 0 and shopType and shopType ~= data.classType then
		return false
	end
	if data.gloriousLv and data.gloriousLv ~= 0 and not SoraDCheckLimit(gLimitType.STAR_LIMIT, data.gloriousLv) then
		return false
	end
	return true
end
local checkShopItemConditionEx = function(data, otherData)
	if not otherData then
		otherData, _ENV = nil, nil
	end
	local classType = otherData.classType
	if data.classType ~= classType then
		return false
	end
	if data.gloriousLv and data.gloriousLv ~= 0 and not SoraDCheckLimit(gLimitType.STAR_LIMIT, data.gloriousLv) then
		return false
	end
	return true
end
function activityExchangeMallRead:getShopItemList(activityID, shopType)
	if not activityID then
		activityExchangeMallRead = nil
		return nil
	end
	local activityInfo = activityExchangeMallRead.exchangeActivity[activityID]
	if not activityInfo then
		dump(activityID, "activityID not found in exchange_store_activity")
		activityExchangeMallRead = dump
		return dump
	end
	local activityExchangeMallRead, shopList = dump, dump
	for k, v in ipairs(activityInfo) do
		activityExchangeMallRead = nil
		;(nil).shopType = shopType
		if checkShopItemCondition(v, nil) then
			table.insert(shopList, clone(v))
		end
	end
	if activityID == gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY then
		local gametop = gModuleMgr.getObject("gametop")
		local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
		if radianceActivityCtrl:isWarFinish() then
			for i, v in ipairs(shopList) do
				if v.shopitem == 510601 then
					table.remove(shopList, i)
					break
				end
			end
		end
	end
	return shopList
end
function activityExchangeMallRead:getShopItemListByRegionId(activityID)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local nebulaWarRead = include("nebulaWarRead")
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType()
	if not activityID then
		_ENV = nil
		return nil
	end
	local activityInfo = activityExchangeMallRead.exchangeActivity[activityID]
	if not activityInfo then
		dump(activityID, "activityID not found in exchange_store_activity")
		_ENV = dump
		return dump
	end
	local _ENV, shopList = dump, dump
	for k, v in ipairs(activityInfo) do
		_ENV = nil
		;(nil).classType = nebulaWarRead.getAreaGroupNew(regionId)
		if checkShopItemConditionEx(v, nil) then
			table.insert(shopList, clone(v))
		end
	end
	if activityID == gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY then
		local gametop = gModuleMgr.getObject("gametop")
		local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
		if radianceActivityCtrl:isWarFinish() then
			for i, v in ipairs(shopList) do
				if v.shopitem == 510601 then
					table.remove(shopList, i)
					break
				end
			end
		end
	end
	return shopList
end
function activityExchangeMallRead.getShopItemListFromOri(activityID, shopType)
	if activityID then
		local _ENV, shopList
		for _, v in ipairs(activityExchangeMallRead.exchangeOriCfg) do
			if v.activityID == activityID then
				_ENV = nil
				;(nil).shopType = shopType
				if checkShopItemCondition(v, nil) then
					table.insert(shopList, v)
				end
			end
		end
		if activityID == gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY then
			local gametop = gModuleMgr.getObject("gametop")
			local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
			if radianceActivityCtrl:isWarFinish() then
				for i, v in ipairs(shopList) do
					if v.shopitem == 510601 then
						table.remove(shopList, i)
						break
					end
				end
			end
		end
		return shopList
	end
	return activityExchangeMallRead.exchangeOriCfg
end
function activityExchangeMallRead:getShopItemByShopItem(shopItemID)
	return activityExchangeMallRead.exchangeCfg[shopItemID]
end
function activityExchangeMallRead:getShopItemByItemID(itemID)
	return activityExchangeMallRead.exchangeItemCfg[itemID]
end
function activityExchangeMallRead:getExchangeitemByID(activityID)
	local activiyInfo = activityExchangeMallRead.exchangeActivity[activityID]
	if activiyInfo then
		return activiyInfo[1].exchangeitem
	end
end
function activityExchangeMallRead:getCostIDByActivityID(activityID)
	local activityExchangeMallRead, costList
	local activiyInfo = activityExchangeMallRead.exchangeActivity[activityID]
	for k, v in ipairs(activiyInfo) do
		local costID = v.exchangeitem
		if not SoraDisInList(costID, costList) then
			table.insert(costList, costID)
		end
	end
	return costList
end
function activityExchangeMallRead:getExchangeItemList(activityID)
	local activityExchangeMallRead, list
	local activiyInfo = activityExchangeMallRead.exchangeActivity[activityID]
	if activiyInfo then
		for k, v in ipairs(activiyInfo) do
			list[tostring(v.exchangeitem)] = true
		end
	end
	local activityExchangeMallRead, exchangeList = (for generator), ipairs(activiyInfo)
	for k, v in pairs(list) do
		table.insert(exchangeList, tonumber(k))
	end
	return exchangeList
end
function activityExchangeMallRead.getExchangeConfig(activityID)
	return activityExchangeMallRead.exchangeActivity[activityID]
end
function activityExchangeMallRead.checkIsSpecial(shopItemID)
	_UPVALUE0_ = nil
	;(nil)[733] = true
	local (nil)[812], specialConfig = true, nil
	return specialConfig[shopItemID] or false
end
return activityExchangeMallRead
