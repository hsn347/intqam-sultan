local merchantOfSericaRead = include("aAReadClass").new()
function merchantOfSericaRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "serica"
	;(nil)[2] = true
	merchantOfSericaRead:defineValue("config", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "serica_gift_bag"
	;(nil)[2] = true
	merchantOfSericaRead:defineValue("gift", nil)
	merchantOfSericaRead:defineValue("groupConfig", function()
		merchantOfSericaRead.groupConfig, merchantOfSericaRead = nil, nil
		for i, v in ipairs(merchantOfSericaRead.config) do
			local group = v.serverGroup
			print(v.commodityID)
			if not merchantOfSericaRead.groupConfig[group] then
				merchantOfSericaRead.groupConfig[group], merchantOfSericaRead = v.commodityID, v.commodityID
			end
			table.insert(merchantOfSericaRead.groupConfig[group], v)
		end
		return merchantOfSericaRead.groupConfig
	end)
	merchantOfSericaRead:defineValue("serica_shop", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.serica_shop")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.serica_shop", "app." .. LocalTblPath .. ".config_server.serica_shop"
		for i, v in ipairs(config) do
			if not ret[v.classtype] then
				ret[v.classtype], _ENV = nil, nil
			end
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
end
function merchantOfSericaRead.getPackageInfo()
	return merchantOfSericaRead.gift[14261]
end
function merchantOfSericaRead.getConfigBygroup(id)
	return merchantOfSericaRead.groupConfig[id]
end
function merchantOfSericaRead.getNumById(id, group)
	local list = merchantOfSericaRead.groupConfig[group]
	for k, v in ipairs(list) do
		local item = v.prop[1]
		if item == id then
			return v.prop[2]
		end
	end
end
function merchantOfSericaRead.getNumByCommodityID(CommodityID, group)
	local list = merchantOfSericaRead.groupConfig[group]
	for k, v in ipairs(list) do
		if v.CommodityID == CommodityID then
			return v.prop[2]
		end
	end
end
function merchantOfSericaRead.getConfigByCommodityID(cmmId, groupId)
	local list = merchantOfSericaRead.groupConfig[groupId]
	for k, v in ipairs(list) do
		if v.commodityID == cmmId then
			return v.prop[1]
		end
	end
end
function merchantOfSericaRead.getSericaShop(classtype)
	return merchantOfSericaRead.serica_shop[classtype]
end
merchantOfSericaRead.init()
return merchantOfSericaRead
