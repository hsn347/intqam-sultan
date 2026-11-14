local rechargeADRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	rechargeADRead = nil
	;(nil)[1] = "rechargeAD"
	rechargeADRead:defineValue("rechargeAD", nil)
end
init()
function rechargeADRead.isADOpen(ccsFile)
	_ENV = nil
	;(nil).ADType = false
	local (nil).menuID, ret = 0, nil
	for i, v in pairs(rechargeADRead.rechargeAD) do
		if v.className == ccsFile then
			ret.ADType = 1
			ret.menuID = v.menuID
			break
		end
	end
	if ret.ADType then
		ret.ADType = rechargeADRead.verifyData(ret.menuID)
	end
	return ret
end
function rechargeADRead.verifyData(menuID)
	local ADType = 1
	if menuID ~= 0 then
		local gametop = gModuleMgr.getObject("gametop")
		local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
		local activeDataList = rechargeActivityCtrl:getRecommendActivityList(menuID)
		if not next(activeDataList) then
			ADType = false
		end
	end
	return ADType
end
function rechargeADRead.getMenuID(ccsFile)
	local menuID = 0
	for i, v in pairs(rechargeADRead.rechargeAD) do
		if v.className == ccsFile then
			menuID = v.menuID
			break
		end
	end
	return menuID
end
function rechargeADRead.getMenuIDBySpeedUpType(type)
	local menuID = 0
	_ENV = nil
	;(nil)[gQueueTypeDef.free_build_queue] = gRechargeRecommendType.BUILD
	;(nil)[gQueueTypeDef.charge_build_queue] = gRechargeRecommendType.BUILD
	;(nil)[gQueueTypeDef.technology_upgrade_queue] = gRechargeRecommendType.TECH
	;(nil)[gQueueTypeDef.nebula_palace_technology] = gRechargeRecommendType.TECH
	;(nil)[gQueueTypeDef.war_tech_research] = gRechargeRecommendType.TECH
	;(nil)[gQueueTypeDef.frotress_queue] = gRechargeRecommendType.TRAP_BUILD
	;(nil)[gQueueTypeDef.elite_queue] = gRechargeRecommendType.ARMY_TRAIN
	;(nil)[gQueueTypeDef.chariot_plant_queue] = gRechargeRecommendType.ARMY_TRAIN
	;(nil)[gQueueTypeDef.stables_queue] = gRechargeRecommendType.ARMY_TRAIN
	;(nil)[gQueueTypeDef.range_queue] = gRechargeRecommendType.ARMY_TRAIN
	;(nil)[gQueueTypeDef.barracks_queue] = gRechargeRecommendType.ARMY_TRAIN
	local (nil)[gQueueTypeDef.forge_equipment], tableType = gRechargeRecommendType.EQUIP, nil
	local worldMapWarDef = include("worldMapWarDef")
	local hospitalQueues = worldMapWarDef.getHospitalQueues()
	for queueType, __ in pairs(hospitalQueues) do
		tableType[queueType] = gRechargeRecommendType.WOUND_ARMY_CURE
	end
	return tableType[type]
end
function rechargeADRead.getMenuIDByResType(type)
	local menuID = 0
	_ENV = nil
	;(nil)[gIDDef.WOOD] = gRechargeRecommendType.WOOD_BUY
	;(nil)[gIDDef.FOOD] = gRechargeRecommendType.FOOD_BUY
	;(nil)[gIDDef.IRON] = gRechargeRecommendType.IRON_BUY
	local (nil)[gIDDef.MITHRIL], tableType = gRechargeRecommendType.MITHRIL_BUY, nil
	return tableType[type]
end
return rechargeADRead
