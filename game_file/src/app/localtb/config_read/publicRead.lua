local _ENV, publicRead
function publicRead.getName(qid)
	qid = tonumber(qid)
	qid = include("equipDesRead").getRealEquipIDAndQuality(qid)
	local publicRead
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicRead = include("itemDesRead")
	elseif gIDType.EQUIPMENT == sType then
		publicRead = include("equipDesRead")
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		publicRead = include("wargemResRead")
	elseif include("resDesRead").checkResID(qid) then
		publicRead = include("resDesRead")
	elseif gIDType.WARFRAME == sType then
		publicRead = gModuleMgr.sharedMgr("armorSystemRead")
	elseif gIDType.GOD_ARMS_RUNE == sType then
		local artifactRuneRead = include("artifactRuneRead")
		return artifactRuneRead.getRuneName(qid) or "???"
	elseif gIDType.TROOP == sType then
		publicRead = include("armyDesRead")
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicRead = include("divineBeastMarkRead")
		return publicRead.getName(qid)
	elseif gIDType.HERO_WAEPON == sType then
		publicRead = include("heroWeaponRead")
		return publicRead.getWeaponName(qid)
	elseif gIDType.GARDEN_DRESS == sType then
		local manorCityRead = include("manorCityRead")
		return manorCityRead.getDressItemName(qid)
	elseif gIDType.GARDEN_FARM_SEED == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getSeedItemName(qid)
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getFruitItemName(qid)
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getBagItemName(qid)
	end
	return publicRead and publicRead.getName(qid) or "???"
end
function publicRead.getBg(qid)
	qid = tonumber(qid)
	local quality
	qid, quality = include("equipDesRead").getRealEquipIDAndQuality(qid)
	local publicReadFun
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicReadFun = include("itemDesRead").getBg
	elseif gIDType.EQUIPMENT == sType then
		if quality then
			qid = quality
			publicReadFun = include("equipDesRead").getBg
		else
			publicReadFun = include("equipDesRead").getBgByID
		end
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		publicReadFun = include("wargemResRead").getBg
	elseif gIDType.TROOP == sType then
		publicReadFun = include("armyDesRead").getBg
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicReadFun = include("divineBeastMarkRead").getBg
	elseif gIDType.HERO_WAEPON == sType then
		publicReadFun = include("heroWeaponRead").getBg
	elseif gIDType.GARDEN_DRESS == sType then
		publicReadFun = include("manorCityRead").getDressItemBg
	elseif gIDType.GARDEN_FARM_SEED == sType then
		publicReadFun = include("manorFarmRead").getSeedItemBg
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		publicReadFun = include("manorFarmRead").getFruitItemBg
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		publicReadFun = include("manorFarmRead").getBagItemBg
	else
		publicReadFun = include("resDesRead").getBg
	end
	return publicReadFun(qid)
end
function publicRead.getIcon(qid, fromMemory)
	qid = tonumber(qid)
	qid = include("equipDesRead").getRealEquipIDAndQuality(qid)
	local publicRead
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicRead = include("itemDesRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif gIDType.EQUIPMENT == sType then
		publicRead = include("equipDesRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		publicRead = include("wargemResRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif include("resDesRead").checkResID(qid) then
		publicRead = include("resDesRead")
		return publicRead.getBIcon(qid, fromMemory)
	elseif gIDType.WARFRAME == sType then
		publicRead = gModuleMgr.sharedMgr("armorSystemRead")
		return publicRead.getIcon(qid)
	elseif gIDType.GOD_ARMS_RUNE == sType then
		local artifactRuneRead = include("artifactRuneRead")
		return artifactRuneRead.getRuneIcon(qid) or "icon_item_common.png"
	elseif gIDType.TROOP == sType then
		publicRead = include("armyDesRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicRead = include("divineBeastMarkRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif gIDType.HERO_WAEPON == sType then
		publicRead = include("heroWeaponRead")
		return publicRead.getWeaponIcon(qid, fromMemory)
	elseif gIDType.GARDEN_DRESS == sType then
		local manorCityRead = include("manorCityRead")
		return manorCityRead.getDressItemIcon(qid, fromMemory)
	elseif gIDType.GARDEN_FARM_SEED == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getSeedItemIcon(qid)
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getFruitItemIcon(qid)
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getBagItemIcon(qid)
	else
		return "icon_item_common.png"
	end
end
function publicRead.getSmallIcon(qid)
	qid = tonumber(qid)
	qid = include("equipDesRead").getRealEquipIDAndQuality(qid)
	local publicRead
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicRead = include("itemDesRead")
		return publicRead.getIcon(qid)
	elseif gIDType.EQUIPMENT == sType then
		publicRead = include("equipDesRead")
		return publicRead.getIcon(qid)
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		publicRead = include("wargemResRead")
		return publicRead.getIcon(qid)
	elseif gIDType.WARFRAME == sType then
		publicRead = gModuleMgr.sharedMgr("armorSystemRead")
		return publicRead.getIcon(qid)
	elseif gIDType.TROOP == sType then
		publicRead = include("armyDesRead")
		return publicRead.getIcon(qid)
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicRead = include("divineBeastMarkRead")
		return publicRead.getIcon(qid, fromMemory)
	elseif gIDType.HERO_WAEPON == sType then
		publicRead = include("heroWeaponRead")
		return publicRead.getWeaponIcon(qid, fromMemory)
	elseif gIDType.GARDEN_DRESS == sType then
		local manorCityRead = include("manorCityRead")
		return manorCityRead.getDressItemIcon(qid, fromMemory)
	elseif gIDType.GARDEN_FARM_SEED == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getSeedItemIcon(qid)
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getFruitItemIcon(qid)
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getBagItemIcon(qid)
	else
		publicRead = include("resDesRead")
		return publicRead.getIcon(qid)
	end
end
function publicRead.getDes(qid)
	qid = tonumber(qid)
	qid = include("equipDesRead").getRealEquipIDAndQuality(qid)
	local publicRead
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicRead = include("itemDesRead")
		return publicRead.getDes(qid)
	elseif gIDType.EQUIPMENT == sType then
		publicRead = include("equipDesRead")
		local compoundID = publicRead.getEquipQualityCompoundIDID(qid)
		local quality = publicRead.getEquipQuality(compoundID)
		if quality then
			local baseStr = publicRead.getDes(qid, quality)
			local equipmentltCtrl = include("equipmentltCtrl")
			local limitLv = equipmentltCtrl.getEquipmentLv(qid)
			_ENV = nil
			;(nil).lv = limitLv
			baseStr = baseStr .. "\n" .. i18n("common_text_2003", nil)
			return baseStr
		else
			return publicRead.getName(qid)
		end
	elseif gIDType.WAR_STONE == sType or gIDType.ENCHANTMENT_SCROLL == sType then
		publicRead = include("wargemResRead")
		return publicRead.getDes(qid)
	elseif gIDType.WARFRAME == sType then
		publicRead = gModuleMgr.sharedMgr("armorSystemRead")
		return publicRead.getDes(qid)
	elseif gIDType.GOD_ARMS_RUNE == sType then
		local artifactRuneRead = include("artifactRuneRead")
		if not artifactRuneRead.getRuneDes(qid) then
			_ENV = qid
			qid.des = "??????"
		end
		return (i18n("common_text_1437", qid))
	elseif gIDType.TROOP == sType then
		publicRead = include("armyDesRead")
		return publicRead.getName(qid)
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicRead = include("divineBeastMarkRead")
		return publicRead.getName(qid)
	elseif gIDType.GARDEN_DRESS == sType then
		local manorCityRead = include("manorCityRead")
		return manorCityRead.getDressItemDes(qid)
	elseif gIDType.GARDEN_FARM_SEED == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getSeedItemDes(qid)
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getFruitItemDes(qid)
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getBagItemDes(qid)
	else
		publicRead = include("resDesRead")
		return publicRead.getDes(qid)
	end
end
function publicRead.getQuality(qid)
	qid = tonumber(qid)
	local publicRead
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		publicRead = include("itemDesRead")
		return publicRead.getQuality(qid)
	elseif gIDType.WAR_STONE == sType then
		publicRead = include("wargemResRead")
		return publicRead.getQuality(qid)
	elseif gIDType.DIVINE_BEAST_MARK == sType then
		publicRead = include("divineBeastMarkRead")
		return publicRead.getQuality(qid)
	elseif gIDType.HERO_WAEPON == sType then
		publicRead = include("heroWeaponRead")
		return publicRead.getQuality(qid)
	elseif gIDType.GARDEN_DRESS == sType then
		local manorCityRead = include("manorCityRead")
		return manorCityRead.getDressItemQuality(qid)
	elseif gIDType.GARDEN_FARM_SEED == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getSeedItemQuality(qid)
	elseif gIDType.GARDEN_FARM_FRUIT == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getFruitItemQuality(qid)
	elseif gIDType.GARDEN_FARM_SEED_BAG == sType then
		local manorFarmRead = include("manorFarmRead")
		return manorFarmRead.getBagItemQuality(qid)
	else
		publicRead = include("resDesRead")
		return publicRead.getQuality(qid)
	end
end
function publicRead.getBgByQuality(lv)
	lv = tonumber(lv) + 1
	if lv >= BG_MIN_QUALITY and lv <= BG_MAX_QUALITY then
		return "frame_item_base_0" .. lv .. ".png"
	else
		return "frame_item_base_01.png"
	end
end
function publicRead.checkLevelCondition(qid)
	qid = tonumber(qid)
	local cond
	local sType = serviceFunctions.getIDType(qid)
	if gIDType.ITEM == sType or gIDType.PACKAGE == sType then
		local itemLogic = include("itemLogic")
		if not itemLogic.checkCastleLevelCond(qid) then
			local _, _, lv = itemLogic.checkCastleLevelCond(qid)
			_ENV = nil
			cond, (nil).needCastleLevel = nil, lv
		end
		if not itemLogic.checkLordLevelCond(qid) then
			local _, _, lv = itemLogic.checkLordLevelCond(qid)
			_ENV = nil
			cond, (nil).needLordLevel = nil, lv
		end
		if not itemLogic.checkVIPLevelCond(qid) then
			local _, err, lv = itemLogic.checkVIPLevelCond(qid)
			if err == gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP then
				_ENV = gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP
				cond, gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP.needVIPLevel = gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP, lv
			elseif err == gErrDef.Err_VIP_NO_ACTIVATING then
				_ENV = gErrDef.Err_VIP_NO_ACTIVATING
				cond, gErrDef.Err_VIP_NO_ACTIVATING.needVIPActive = gErrDef.Err_VIP_NO_ACTIVATING, true
			end
		end
		return cond
	else
		local resDesRead = include("resDesRead")
		if not resDesRead.checkCastleLevelCond(qid) then
			local _, _, lv = resDesRead.checkCastleLevelCond(qid)
			_ENV = gErrDef.Err_VIP_NO_ACTIVATING
			cond, gErrDef.Err_VIP_NO_ACTIVATING.needCastleLevel = gErrDef.Err_VIP_NO_ACTIVATING, lv
		end
		return cond
	end
end
return publicRead
