local kingStarBattleRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingStarBattleRead = nil
	;(nil)[1] = "kingstarbattle_buff_des"
	kingStarBattleRead:defineValue("buffDesTable", nil)
	kingStarBattleRead = nil
	;(nil)[1] = "kingstarrank_buff_des"
	kingStarBattleRead:defineValue("buffDesRankTable", nil)
	kingStarBattleRead = nil
	;(nil)[1] = "kingstarbattle_view"
	kingStarBattleRead:defineValue("officialTable", nil)
	kingStarBattleRead:defineValue("officialRankTable", function()
		local baseConfig = require_data("kingstarrank_view", false, true).data
		return kingStarBattleRead.getClassTypeConfig(baseConfig, "servertype")
	end)
	function _ENV()
		local baseConfig = require_data("kingstarrank_view", false, true).data
		return kingStarBattleRead.getClassTypeConfig(baseConfig, "servertype")
	end
	;(function()
		local baseConfig = require_data("kingstarrank_view", false, true).data
		return kingStarBattleRead.getClassTypeConfig(baseConfig, "servertype")
	end)[1] = "world_war_shop"
	;(function()
		local baseConfig = require_data("kingstarrank_view", false, true).data
		return kingStarBattleRead.getClassTypeConfig(baseConfig, "servertype")
	end)[2] = true
	kingStarBattleRead:defineValue("worldWarShop", function()
		local baseConfig = require_data("kingstarrank_view", false, true).data
		return kingStarBattleRead.getClassTypeConfig(baseConfig, "servertype")
	end)
	local createData = function(name)
		kingStarBattleRead.personalOfficial, kingStarBattleRead, kingStarBattleRead.worldOfficial, kingStarBattleRead = nil, nil, nil, nil
		for i, v in ipairs(kingStarBattleRead.officialTable) do
			if v.class == 1 then
				table.insert(kingStarBattleRead.worldOfficial, v)
			elseif v.class == 2 and v.type ~= 1 then
				table.insert(kingStarBattleRead.personalOfficial, v)
			end
		end
		if name == "worldOfficial" then
			return kingStarBattleRead.worldOfficial
		elseif name == "personalOfficial" then
			return kingStarBattleRead.personalOfficial
		end
	end
	kingStarBattleRead:defineValue("worldOfficial", createData)
	kingStarBattleRead:defineValue("personalOfficial", createData)
	local createData = function(name)
		local baseConfig = require_data("kingstarrank_view", false, true).data
		local _ENV, worldRankOfficial = "kingstarrank_view", "kingstarrank_view"
		local _ENV, personalRankOfficial = false, false
		for i, v in ipairs(baseConfig) do
			local servertype = v.servertype
			if not worldRankOfficial[servertype] then
				_ENV = worldRankOfficial[servertype]
			end
			worldRankOfficial[servertype] = worldRankOfficial[servertype]
			if not personalRankOfficial[servertype] then
				_ENV = personalRankOfficial[servertype]
			end
			personalRankOfficial[servertype] = personalRankOfficial[servertype]
			if v.class == 1 then
				table.insert(worldRankOfficial[servertype], v)
			elseif v.class == 2 and v.type ~= 1 then
				table.insert(personalRankOfficial[servertype], v)
			end
		end
		if name == "worldRankOfficial" then
			return worldRankOfficial
		elseif name == "personalRankOfficial" then
			return personalRankOfficial
		end
	end
	kingStarBattleRead:defineValue("worldRankOfficial", createData)
	kingStarBattleRead:defineValue("personalRankOfficial", createData)
	kingStarBattleRead:defineValue("giftPackage", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_kingpackage")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.items = serviceFunctions.tableFormat(v.items, nil)
		end
		return cfg
	end)
	kingStarBattleRead:defineValue("giftRankPackage", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_kingpackage")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_kingpackage", "app." .. LocalTblPath .. ".config_server.kingstarrank_kingpackage"
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.items = serviceFunctions.tableFormat(v.items, nil)
			if not ret[v.servertype] then
				ret[v.servertype], _ENV = v.items, v.items
			end
			table.insert(ret[v.servertype], v)
		end
		return ret
	end)
end
init()
function kingStarBattleRead.getOfficialConfig(mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	return kingStarBattleRead.officialRankTable[activityID] or kingStarBattleRead.officialTable
end
function kingStarBattleRead.getBuffsById(buffType, id, mapid)
	for i, v in ipairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		if v.class == buffType and v.type == id then
			return v.buff
		end
	end
end
function kingStarBattleRead.getAllBuffList(mapid)
	local _ENV, officialList
	for _, v in pairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		officialList[v.type] = v.buff
	end
	return officialList
end
function kingStarBattleRead.getOfficialInfo(buffType, id, mapid)
	for i, v in ipairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		if v.class == buffType and v.type == id then
			return v
		end
	end
end
function kingStarBattleRead.judgeIsGood(buffType, id, mapid)
	local isGood = false
	local officialInfo = kingStarBattleRead.getOfficialInfo(buffType, id, mapid)
	if officialInfo and officialInfo.btype == 1 then
		isGood = true
	end
	return isGood
end
function kingStarBattleRead.getAllWorldOfficial(mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	return kingStarBattleRead.worldRankOfficial[activityID] or kingStarBattleRead.worldOfficial
end
function kingStarBattleRead.getAllPersonalOfficial(mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	return kingStarBattleRead.personalRankOfficial[activityID] or kingStarBattleRead.personalOfficial
end
function kingStarBattleRead.getOfficialName(buffType, id, mapid)
	for i, v in ipairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		if v.class == buffType and v.type == id then
			return i18n(v.name)
		end
	end
end
function kingStarBattleRead.getOfficialType(buffType, id, mapid)
	for i, v in ipairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		if v.class == buffType and v.type == id then
			return v.btype
		end
	end
end
function kingStarBattleRead.getOfficialIcon(buffType, id, mapid)
	for i, v in ipairs(kingStarBattleRead.getOfficialConfig(mapid)) do
		if v.class == buffType and v.type == id then
			return v.img
		end
	end
end
function kingStarBattleRead.getBufferName(bufferId, mapid)
	local buffItem = kingStarBattleRead.getBufferInfo(bufferId, mapid)
	if buffItem then
		return i18n(buffItem.buffDes), buffItem.type
	end
end
function kingStarBattleRead.getBufferInfo(bufferId, mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	local config = kingStarBattleRead.buffDesRankTable[activityID] or kingStarBattleRead.buffDesTable
	local buffItem = config[bufferId]
	return buffItem
end
function kingStarBattleRead.getBuffDesTbById(buffType, id, mapid)
	local buffs = kingStarBattleRead.getBuffsById(buffType, id, mapid)
	local kingStarBattleRead, desTb = buffType, buffType
	for i, v in ipairs(buffs) do
		local bufDes = kingStarBattleRead.getBufferName(v, mapid)
		table.insert(desTb, bufDes)
	end
	return desTb
end
function kingStarBattleRead.getPackageList(mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	return kingStarBattleRead.giftRankPackage[activityID] or kingStarBattleRead.giftPackage
end
function kingStarBattleRead.getPackageName(id, mapid)
	for i, v in ipairs(kingStarBattleRead.getPackageList(mapid)) do
		if v.rewardsType == id then
			return i18n(v.name)
		end
	end
end
function kingStarBattleRead.getPackage(id, mapid)
	for i, v in ipairs(kingStarBattleRead.getPackageList(mapid)) do
		if v.rewardsType == id then
			return v
		end
	end
end
function kingStarBattleRead.getPackageReward(id, mapid)
	for i, v in ipairs(kingStarBattleRead.getPackageList(mapid)) do
		if v.rewardsType == id then
			return v.items
		end
	end
end
function kingStarBattleRead.getPackageRewardRank(id, mapid)
	for i, v in ipairs(kingStarBattleRead.getPackageList(mapid)) do
		if v.rewardsType == id then
			return v.rank
		end
	end
end
function kingStarBattleRead.getShopItemList(shopTpye, mapid)
	local _ENV, shopList
	for k, v in ipairs(kingStarBattleRead.worldWarShop) do
		if v.type == shopTpye then
			table.insert(shopList, v)
		end
	end
	return shopList
end
function kingStarBattleRead.getItemIDByShopItemID(shopItemID, mapid)
	local itemID
	for k, v in ipairs(kingStarBattleRead.worldWarShop) do
		if v.shopItemID == shopItemID then
			itemID = v.itemId
			break
		end
	end
	return itemID
end
function kingStarBattleRead.getItemNumByShopItemID(shopItemID, mapid)
	local itemNum
	for k, v in ipairs(kingStarBattleRead.worldWarShop) do
		if v.shopItemID == shopItemID then
			itemNum = v.itemNum
			break
		end
	end
	return itemNum
end
_UPVALUE1_ = nil
;(nil)[1] = "kingstarbattle_building_config"
kingStarBattleRead:defineValue("kingstarbattle_building_config", nil)
kingStarBattleRead:defineValue("kingstarrank_building_config", function()
	local baseConfig = require_data("kingstarrank_building_config", false, true).data
	local _ENV, ret = "kingstarrank_building_config", "kingstarrank_building_config"
	for __, v in ipairs(baseConfig) do
		if not ret[v.servertype] then
			_ENV = ret[v.servertype]
		end
		ret[v.servertype] = ret[v.servertype]
		ret[v.servertype][v.BuildID] = v
	end
	return ret
end)
function kingStarBattleRead.getImage(buildTypeID, mapid)
	local activityID = worldMapDefine.getKingStarActivityID(mapid)
	local config = kingStarBattleRead.kingstarrank_building_config[activityID] or kingStarBattleRead.kingstarbattle_building_config
	return config[buildTypeID].image
end
return kingStarBattleRead
