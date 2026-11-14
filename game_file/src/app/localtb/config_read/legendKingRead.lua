local legendKingRead = include("aAReadClass").new()
local kingStarBattleRead = include("kingStarBattleRead")
local isInited = false
local init = function()
	if isInited then
		return
	end
	legendKingRead = nil
	;(nil)[1] = "legendaryking_buff_des"
	legendKingRead:defineValue("buffDesTable", nil)
	legendKingRead = nil
	;(nil)[1] = "legendaryking_view"
	legendKingRead:defineValue("officialTable", nil)
	_ENV = nil
	;(nil)[1] = "world_war_shop"
	;(nil)[2] = true
	legendKingRead:defineValue("worldWarShop", nil)
	local createData = function(name)
		legendKingRead.personalOfficial, legendKingRead, legendKingRead.worldOfficial, legendKingRead = nil, nil, nil, nil
		for i, v in ipairs(legendKingRead.officialTable) do
			if v.class == 1 then
				table.insert(legendKingRead.worldOfficial, v)
			elseif v.class == 2 and v.type ~= 1 then
				table.insert(legendKingRead.personalOfficial, v)
			end
		end
		if name == "worldOfficial" then
			return legendKingRead.worldOfficial
		elseif name == "personalOfficial" then
			return legendKingRead.personalOfficial
		end
	end
	legendKingRead:defineValue("worldOfficial", createData)
	legendKingRead:defineValue("personalOfficial", createData)
	legendKingRead:defineValue("giftPackage", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_kingpackage")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.items = serviceFunctions.tableFormat(v.items, nil)
		end
		return cfg
	end)
	isInited = legendKingRead.defineValue
	legendKingRead.defineValue.SPEED = 1
	legendKingRead.defineValue.TREAT = 2
	legendKingRead.shopTpye, legendKingRead.defineValue.LEGEND_CRYSTAL = legendKingRead.defineValue, 3
end
init()
function legendKingRead.getBuffsById(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getBuffsById(buffType, id, mapid)
	end
	for i, v in ipairs(legendKingRead.officialTable) do
		if v.class == buffType and v.type == id then
			return v.buff
		end
	end
end
function legendKingRead.getAllBuffList(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getAllBuffList(mapid)
	end
	local _ENV, officialList = kingStarBattleRead.getAllBuffList, kingStarBattleRead.getAllBuffList
	for _, v in pairs(legendKingRead.officialTable) do
		officialList[v.type] = v.buff
	end
	return officialList
end
function legendKingRead.getOfficialInfo(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getOfficialInfo(buffType, id, mapid)
	end
	for i, v in ipairs(legendKingRead.officialTable) do
		if v.class == buffType and v.type == id then
			return v
		end
	end
end
function legendKingRead.judgeIsGood(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.judgeIsGood(buffType, id, mapid)
	end
	local isGood = false
	local officialInfo = legendKingRead.getOfficialInfo(buffType, id)
	if officialInfo and officialInfo.btype == 1 then
		isGood = true
	end
	return isGood
end
function legendKingRead.getAllWorldOfficial(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getAllWorldOfficial(mapid)
	end
	return legendKingRead.worldOfficial
end
function legendKingRead.getAllPersonalOfficial(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getAllPersonalOfficial(mapid)
	end
	return legendKingRead.personalOfficial
end
function legendKingRead.getOfficialName(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getOfficialName(buffType, id, mapid)
	end
	for i, v in ipairs(legendKingRead.officialTable) do
		if v.class == buffType and v.type == id then
			return i18n(v.name)
		end
	end
end
function legendKingRead.getOfficialType(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getOfficialType(buffType, id, mapid)
	end
	for i, v in ipairs(legendKingRead.officialTable) do
		if v.class == buffType and v.type == id then
			return v.btype
		end
	end
end
function legendKingRead.getOfficialIcon(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getOfficialIcon(buffType, id, mapid)
	end
	for i, v in ipairs(legendKingRead.officialTable) do
		if v.class == buffType and v.type == id then
			return v.img
		end
	end
end
function legendKingRead.getBufferName(bufferId, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getBufferName(bufferId, mapid)
	end
	local buffItem = legendKingRead.buffDesTable[bufferId]
	if buffItem then
		return i18n(buffItem.buffDes), buffItem.type
	end
end
function legendKingRead.getBufferInfo(bufferId, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getBufferInfo(bufferId, mapid)
	end
	local buffItem = legendKingRead.buffDesTable[bufferId]
	return buffItem
end
function legendKingRead.getBuffDesTbById(buffType, id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getBuffDesTbById(buffType, id, mapid)
	end
	local buffs = legendKingRead.getBuffsById(buffType, id, mapid)
	local _ENV, desTb = buffType, buffType
	for i, v in ipairs(buffs) do
		local bufDes = legendKingRead.getBufferName(v, mapid)
		table.insert(desTb, bufDes)
	end
	return desTb
end
function legendKingRead.getPackageList(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getPackageList(mapid, mapid)
	end
	return legendKingRead.giftPackage
end
function legendKingRead.getPackageName(id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getPackageName(id, mapid)
	end
	for i, v in ipairs(legendKingRead.giftPackage) do
		if v.rewardsType == id then
			return i18n(v.name)
		end
	end
end
function legendKingRead.getPackage(id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getPackage(id, mapid)
	end
	for i, v in ipairs(legendKingRead.giftPackage) do
		if v.rewardsType == id then
			return v
		end
	end
end
function legendKingRead.getPackageReward(id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getPackageReward(id, mapid)
	end
	for i, v in ipairs(legendKingRead.giftPackage) do
		if v.rewardsType == id then
			return v.items
		end
	end
end
function legendKingRead.getPackageRewardRank(id, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getPackageRewardRank(id, mapid)
	end
	for i, v in ipairs(legendKingRead.giftPackage) do
		if v.rewardsType == id then
			return v.rank
		end
	end
end
function legendKingRead.getShopItemList(shopTpye, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getShopItemList(shopTpye, mapid)
	end
	local _ENV, shopList = kingStarBattleRead.getShopItemList, kingStarBattleRead.getShopItemList
	for k, v in ipairs(legendKingRead.worldWarShop) do
		if v.type == shopTpye then
			table.insert(shopList, v)
		end
	end
	return shopList
end
function legendKingRead.getItemIDByShopItemID(shopItemID, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getItemIDByShopItemID(shopItemID, mapid)
	end
	local itemID
	for k, v in ipairs(legendKingRead.worldWarShop) do
		if v.shopItemID == shopItemID then
			itemID = v.itemId
			break
		end
	end
	return itemID
end
function legendKingRead.getItemNumByShopItemID(shopItemID, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getItemNumByShopItemID(shopItemID, mapid)
	end
	local itemNum
	for k, v in ipairs(legendKingRead.worldWarShop) do
		if v.shopItemID == shopItemID then
			itemNum = v.itemNum
			break
		end
	end
	return itemNum
end
function legendKingRead.checkUnlockConditions(_shopTpye)
	local shopItemList = legendKingRead.getShopItemList(_shopTpye, worldMapDefine.currentMapKindomID)
	local shopTpye = legendKingRead.shopTpye
	if _shopTpye == shopTpye.LEGEND_CRYSTAL then
		local technologyCtrl = SoraDGetCtrl("technologyCtrl")
		for __, v in pairs(shopItemList) do
			for __, technologyId in ipairs(v.conditions) do
				if technologyCtrl:isActiveTech(math.floor(technologyId / 100)) then
					return true
				end
			end
		end
	end
	return false
end
_UPVALUE1_ = nil
;(nil)[1] = "legendaryking_building_config"
legendKingRead:defineValue("legendaryking_building_config", nil)
function legendKingRead.getImage(buildTypeID, mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return kingStarBattleRead.getImage(buildTypeID, mapid)
	end
	return legendKingRead.legendaryking_building_config[buildTypeID].image
end
return legendKingRead
