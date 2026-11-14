local newExchangeMallRead = include("aAReadClass").new()
function newExchangeMallRead.init()
	local createData = function(name)
		newExchangeMallRead.costIDArray, newExchangeMallRead, newExchangeMallRead.exchangeCfg, newExchangeMallRead = nil, nil, nil, nil
		local exchangeCfg = require_data("new_exchange_store", true, true).data
		for _, v in ipairs(exchangeCfg) do
			print("newExchangeMallRead.init", _)
			if not newExchangeMallRead.exchangeCfg[v.activityID] then
				newExchangeMallRead.exchangeCfg[v.activityID], newExchangeMallRead = _, _
			end
			if not newExchangeMallRead.costIDArray[v.activityID] then
				newExchangeMallRead.costIDArray[v.activityID], newExchangeMallRead = _, _
			end
			for i = 1, #v.exchangeitem, 2 do
				newExchangeMallRead.costIDArray[v.activityID][v.exchangeitem[i]] = 1
			end
			newExchangeMallRead = v.activityID
			v.activityID.index = v.index
			v.activityID.storeID = v.storeID
			v.activityID.shopitem = v.shopitem
			v.activityID.exchangeitem = v.exchangeitem
			v.activityID.limitType = v.limitType
			v.activityID.limitnum = v.limitnum
			v.activityID.exchangeLv = v.exchangeLv
			v.activityID.tabType = v.type
			v.activityID.gloriousLv = v.gloriousLv
			v.activityID.classType = v.classType
			v.activityID.itemSheet = v.itemSheet
			v.activityID.exLimits = v.exLimits
			table.insert(newExchangeMallRead.exchangeCfg[v.activityID], v.activityID)
		end
		if name == "exchangeCfg" then
			return newExchangeMallRead.exchangeCfg
		elseif name == "costIDArray" then
			return newExchangeMallRead.costIDArray
		end
	end
	newExchangeMallRead:defineValue("exchangeCfg", createData)
	newExchangeMallRead:defineValue("costIDArray", createData)
	newExchangeMallRead:defineValue("ex_config", function()
		newExchangeMallRead.ex_config, newExchangeMallRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.exchangestore_config")
		for k, v in ipairs(cfg) do
			if not newExchangeMallRead.ex_config[v.ID] then
				newExchangeMallRead.ex_config[v.ID], newExchangeMallRead = nil, nil
			end
			newExchangeMallRead.ex_config[v.ID][v.classType] = v
		end
		return newExchangeMallRead.ex_config
	end)
	newExchangeMallRead:defineValue("tab_config", function()
		newExchangeMallRead.tab_config, newExchangeMallRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_client.exchange_store_show_type")
		for k, v in ipairs(cfg) do
			newExchangeMallRead.tab_config[v.ID] = v.sheetName
		end
		return newExchangeMallRead.tab_config
	end)
end
local checkShopItemCondition = function(data, otherData)
	if not otherData then
		otherData, _ENV = nil, nil
	end
	local shopType = otherData.shopType
	if data.classType ~= 0 and shopType and shopType ~= data.classType then
		return false
	end
	if data.exchangeLv and data.exchangeLv ~= 0 and not SoraDCheckLimit(gLimitType.CASTLE_LIMIT, data.exchangeLv) then
		return false
	end
	if data.gloriousLv and data.gloriousLv ~= 0 and not SoraDCheckLimit(gLimitType.STAR_LIMIT, data.gloriousLv) then
		return false
	end
	return true
end
function newExchangeMallRead.getConfigByActivityID(activityID, classtype)
	if not newExchangeMallRead.exchangeCfg[tonumber(activityID)] then
		local newExchangeMallRead, activityInfo = newExchangeMallRead.exchangeCfg[tonumber(activityID)], newExchangeMallRead.exchangeCfg[tonumber(activityID)]
	end
	local newExchangeMallRead, shopList = tonumber(activityID), tonumber(activityID)
	local classtype = classtype or 1
	for k, v in ipairs(activityInfo) do
		if v.classType then
			if checkShopItemCondition(v) and v.classType == classtype then
				table.insert(shopList, v)
			end
		elseif checkShopItemCondition(v) then
			table.insert(shopList, v)
		end
	end
	return shopList
end
function newExchangeMallRead.isReachOpenLvByID(activityID)
	if newExchangeMallRead.exchangeCfg[activityID] == nil then
		return true
	end
	if not newExchangeMallRead.exchangeCfg[activityID] then
		local newExchangeMallRead, config = newExchangeMallRead.exchangeCfg[activityID], newExchangeMallRead.exchangeCfg[activityID]
	end
	if 0 < #config then
		for k, v in ipairs(config) do
			if checkShopItemCondition(v) then
				return true
			end
		end
		return false
	else
		return false
	end
	return false
end
function newExchangeMallRead.getCostIDByActivityID(activityID)
	return newExchangeMallRead.costIDArray[tonumber(activityID)]
end
function newExchangeMallRead.getNewCfg(id)
	local activityID = tonumber(id)
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	local _classtype = 1
	if param and param.classtype then
		_classtype = tonumber(param.classtype)
	end
	if newExchangeMallRead.ex_config[activityID] then
		return newExchangeMallRead.ex_config[activityID][_classtype]
	end
end
function newExchangeMallRead.getTabConfig(activityID)
	if not newExchangeMallRead.tab_config[tonumber(activityID)] then
		newExchangeMallRead = newExchangeMallRead.tab_config[tonumber(activityID)]
	end
	return newExchangeMallRead.tab_config[tonumber(activityID)]
end
function newExchangeMallRead.getExchangeConfig(activityID)
	return newExchangeMallRead.exchangeCfg[activityID]
end
newExchangeMallRead.init()
return newExchangeMallRead
