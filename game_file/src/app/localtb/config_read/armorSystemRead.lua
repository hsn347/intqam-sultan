local ltBase = include("ltBase")
local armorSystemRead = class("armorSystemRead", ltBase, include("aAReadClass").new())
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "soldiers_armor"
	;(nil)[2] = true
	armorSystemRead:defineValue("soldiersArmor", nil)
	_ENV = nil
	;(nil)[1] = "soldiers_armor_exechange_config"
	;(nil)[2] = true
	armorSystemRead:defineValue("armorExchange", nil)
	armorSystemRead:defineValue("armorConfig", function()
		local _ENV, _ENV, _ENV, armorConfig
		;(nil).icon = "icon_herotype_chebing.png"
		;(nil).technologyID = WARFRAME_TECHNOLOGY_ID.CHARISTS_ARMOR
		;(nil).gildedTechID = GILDED_TECHNOLOGY_ID.CHARISTS_ARMOR
		;(nil).resTechnology = gTechnologyType.CHARISTS_ARMOR_FORIGIN_RES_REDUCE
		;(nil).consumeTechnology = gTechnologyType.CHARISTS_ARMOR_FORIGIN_CONSUME_REDUCE
		;(nil).timeTechnology = gTechnologyType.CHARISTS_ARMOR_FORIGIN_TIME_REDUCE
		;(nil).crystalTimeTechnology = gTechnologyType.CHARISTS_GILDED_ARMOR_FORIGIN_TIME_REDUCE
		_ENV, (nil)[7], (nil).crystalTechnology = nil, nil, gTechnologyType.CHARISTS_ARMOR_FORIGIN_CRYSTAL_REDUCE
		;(nil).icon = "icon_herotype_qibing.png"
		;(nil).technologyID = WARFRAME_TECHNOLOGY_ID.CAVALRY_ARMOR
		;(nil).gildedTechID = GILDED_TECHNOLOGY_ID.CAVALRY_ARMOR
		;(nil).resTechnology = gTechnologyType.CAVALRY_ARMOR_FORIGIN_RES_REDUCE
		;(nil).consumeTechnology = gTechnologyType.CAVALRY_ARMOR_FORIGIN_CONSUME_REDUCE
		;(nil).timeTechnology = gTechnologyType.CAVALRY_ARMOR_FORIGIN_TIME_REDUCE
		;(nil).crystalTimeTechnology = gTechnologyType.CAVALRY_GILDED_ARMOR_FORIGIN_TIME_REDUCE
		_ENV, (nil)[5], (nil).crystalTechnology = nil, nil, gTechnologyType.CAVALRY_ARMOR_FORIGIN_CRYSTAL_REDUCE
		;(nil).icon = "icon_herotype_gongbing.png"
		;(nil).technologyID = WARFRAME_TECHNOLOGY_ID.ARCHER_ARMOR
		;(nil).gildedTechID = GILDED_TECHNOLOGY_ID.ARCHER_ARMOR
		;(nil).resTechnology = gTechnologyType.ARCHER_ARMOR_FORIGIN_RES_REDUCE
		;(nil).consumeTechnology = gTechnologyType.ARCHER_ARMOR_FORIGIN_CONSUME_REDUCE
		;(nil).timeTechnology = gTechnologyType.ARCHER_ARMOR_FORIGIN_TIME_REDUCE
		;(nil).crystalTimeTechnology = gTechnologyType.ARCHER_GILDED_ARMOR_FORIGIN_TIME_REDUCE
		_ENV, (nil)[6], (nil).crystalTechnology = nil, nil, gTechnologyType.ARCHER_ARMOR_FORIGIN_CRYSTAL_REDUCE
		;(nil).icon = "icon_herotype_bubing.png"
		;(nil).technologyID = WARFRAME_TECHNOLOGY_ID.INFANTRY_ARMOR
		;(nil).gildedTechID = GILDED_TECHNOLOGY_ID.INFANTRY_ARMOR
		;(nil).resTechnology = gTechnologyType.INFANTRY_ARMOR_FORIGIN_RES_REDUCE
		;(nil).consumeTechnology = gTechnologyType.INFANTRY_ARMOR_FORIGIN_CONSUME_REDUCE
		;(nil).timeTechnology = gTechnologyType.INFANTRY_ARMOR_FORIGIN_TIME_REDUCE
		;(nil).crystalTimeTechnology = gTechnologyType.INFANTRY_GILDED_ARMOR_FORIGIN_TIME_REDUCE
		;(nil)[4], (nil).crystalTechnology = nil, gTechnologyType.INFANTRY_ARMOR_FORIGIN_CRYSTAL_REDUCE
		local extendConfig
		local tmpConfig = require_once("app." .. LocalTblPath .. ".config_client.soldiers_armor_config")
		for i, v in ipairs(tmpConfig) do
			local soldierConfig = armorSystemRead:getArmorRefSoldierInfo(v.armorId)
			_ENV = v.armorId
			v.armorId.name = v.name
			v.armorId.des = v.des
			v.armorId.herIcon = v.icon
			v.armorId.herBg = v.herBg
			v.armorId.armorType = soldierConfig.armorType
			v.armorId.armyType = soldierConfig.armyType
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.armorId.costRes = serviceFunctions.tableFormat(soldierConfig.costRes, nil)
			v.armorId.forgingTime = soldierConfig.forgingTime
			v.armorId.index = soldierConfig.id
			v.armorId.barrackID = soldierConfig.barrackID
			v.armorId.newLv = soldierConfig.newLv
			v.armorId.oldLv = soldierConfig.oldLv
			v.armorId.armyIcon = extendConfig[soldierConfig.armyType].icon
			v.armorId.technologyID = extendConfig[soldierConfig.armyType].technologyID
			v.armorId.gildedTechID = extendConfig[soldierConfig.armyType].gildedTechID
			v.armorId.resTechnology = extendConfig[soldierConfig.armyType].resTechnology
			v.armorId.crystalTechnology = extendConfig[soldierConfig.armyType].crystalTechnology
			v.armorId.consumeTechnology = extendConfig[soldierConfig.armyType].consumeTechnology
			v.armorId.timeTechnology = extendConfig[soldierConfig.armyType].timeTechnology
			armorConfig[v.armorId], v.armorId.crystalTimeTechnology = v.armorId, extendConfig[soldierConfig.armyType].crystalTimeTechnology
		end
		return armorConfig
	end)
end
function armorSystemRead:getArmorRefSoldierInfo(armorId)
	for i, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.armorId == armorId then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(armorSystemRead.soldiersArmor)
end
function armorSystemRead:getArmorCfg(lv)
	local lv = lv or 13
	local _ENV, cfg
	for i, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.newLv == lv then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function armorSystemRead:getGildedArmorCfg(armorId)
	local armorType = 4
	local gGrmorId = 10011
	for _, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.armorId == armorId then
			armorType = v.armorType
			break
		end
	end
	for _, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.newLv == 14 and v.armorType == armorType then
			gGrmorId = v.armorId
			break
		end
	end
	return gGrmorId
end
function armorSystemRead:getT13ArmorID(armorId)
	local armorType = 0
	local T13ArmorID
	for _, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.armorId == armorId then
			armorType = v.armorType
			break
		end
	end
	for _, v in ipairs(armorSystemRead.soldiersArmor) do
		if v.armorType == armorType and v.newLv == 13 then
			T13ArmorID = v.armorId
			break
		end
	end
	return T13ArmorID
end
function armorSystemRead:ctor(...)
end
function armorSystemRead:getArmorIdByArmyId(armyID, isOld, isAll)
	local armyltCtrl = include("armyltCtrl")
	local armyType, lv = armyltCtrl.getArmyTypeAndLv(armyID)
	local _ENV, armorIdList
	for armorId, v in pairs(armorSystemRead.armorConfig) do
		if v.armyType == armyType then
			if isOld then
				if type(v.oldLv) == "table" then
					for _, oldLv in ipairs(v.oldLv) do
						if lv == oldLv then
							table.insert(armorIdList, armorId)
						end
					end
				elseif type(v.oldLv) == "number" and lv == v.oldLv then
					table.insert(armorIdList, armorId)
				end
			elseif lv == v.newLv then
				table.insert(armorIdList, armorId)
			end
		end
	end
	table.sort(armorIdList)
	if isAll then
		return armorIdList[1], armorIdList
	else
		return armorIdList[1]
	end
end
function armorSystemRead:getProperty(armorId, property)
	if not armorSystemRead.super.getProperty(self, self.armorConfig, armorId, property) then
		armorSystemRead = armorSystemRead.super.getProperty(self, self.armorConfig, armorId, property)
	end
	return (armorSystemRead.super.getProperty(self, self.armorConfig, armorId, property))
end
function armorSystemRead.getName(armorId)
	return i18n(armorSystemRead:getProperty(armorId, "name"))
end
function armorSystemRead.getIcon(armorId)
	return armorSystemRead:getProperty(armorId, "herIcon")
end
function armorSystemRead.getBigIcon(armorId)
	return armorSystemRead:getProperty(armorId, "herBg")
end
function armorSystemRead.getDes(armorId)
	return i18n(armorSystemRead:getProperty(armorId, "des"))
end
function armorSystemRead:getUnlockArmorIDList(newLv)
	local _ENV, ret
	for i, v in ipairs(armorSystemRead.soldiersArmor) do
		if newLv == 13 and newLv == v.newLv then
			_ENV = nil
			;(nil).isArmorID = true
			;(nil).armorID = v.armorId
			if SoraDIsBrave8Level(nil) then
				table.insert(ret, v.armorId)
			end
		end
		if newLv == 14 and newLv == v.newLv then
			_ENV = ret
			ret.isArmorID = true
			ret.armorID = v.armorId
			if SoraDIsGildedArmorOpen(ret) then
				table.insert(ret, v.armorId)
			end
		end
	end
	return ret
end
function armorSystemRead:getArmoExchange()
	return armorSystemRead.armorExchange
end
init()
return armorSystemRead
