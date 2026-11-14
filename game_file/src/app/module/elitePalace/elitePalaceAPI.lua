local _ENV, elitePalaceAPI
function elitePalaceAPI:getElitePoint()
	return self:getElitePalaceCtrl():getElitePoint()
end
function elitePalaceAPI:test()
end
function elitePalaceAPI:getEliteSoldierLimit()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local blv = cityCtrl:getBuildMaxLv(BUILDID.ELITE_PALACE)
	local cityltCtrl = include("cityltCtrl")
	local limit = cityltCtrl.getSoldierLimit(blv) or 0
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local vip_add = buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_MAX_COUNT, gBuffSource.VIP) or 0
	local wargem_add = buffCtrl:getBuffEffect(gBuffEffect.ELITE_SOLDIER_MAX_COUNT, gBuffSource.WAR_GEM) or 0
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.ELITE_SOLDIER_LIMIT_VALUE_BOOST) or 0
	print("getEliteSoldierLimit vipadd", vip_add, wargem_add, tech_add, limit)
	limit = limit + vip_add + wargem_add + tech_add
	return limit, vip_add + wargem_add + tech_add
end
function elitePalaceAPI:getEliteSoldierCount()
	local gametop = gModuleMgr.getObject("gametop")
	local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	return armyCtrl:getCountByArmyType(gSoldierType.SOLDIER_TYPE_ELITE) + resurrectionCtrl:getDeadArmyCount(gSoldierType.SOLDIER_TYPE_ELITE)
end
function elitePalaceAPI:getDailyElitePointLimitInfo()
	local limit, add, base = self:getElitePalaceCtrl():getCurrentElitePointLimit()
	_UPVALUE0_ = nil
	;(nil).base = base
	;(nil).add = add
	;(nil).total = limit
	return nil
end
function elitePalaceAPI:getElitePalaceCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("elitePalaceCtrl")
end
return elitePalaceAPI
