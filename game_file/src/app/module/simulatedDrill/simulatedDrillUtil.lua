local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local _ENV, simulatedDrillUtil = "simulatedDrillCtrl", "simulatedDrillCtrl"
function simulatedDrillUtil.checkIsCanTransfer(targetRect)
	return false
end
function simulatedDrillUtil.getCampName(camp)
	_ENV = nil
	;(nil)[SIMULATED_DRILL_WAR_CAMP.WEST] = i18n("simulated_drill_title_02")
	local (nil)[SIMULATED_DRILL_WAR_CAMP.EAST], config = i18n("simulated_drill_title_03"), nil
	return config[camp]
end
function simulatedDrillUtil.getCampColor(camp)
	_ENV = nil
	;(nil)[SIMULATED_DRILL_WAR_CAMP.WEST] = cc.c3b(100, 180, 230)
	local (nil)[SIMULATED_DRILL_WAR_CAMP.EAST], config = cc.c3b(255, 65, 45), nil
	return config[camp]
end
function simulatedDrillUtil.getPlayerNameColor(fromCamp, selfCamp)
	selfCamp = selfCamp or simulatedDrillCtrl:getSelfCamp()
	if fromCamp == selfCamp then
		return worldMapDefine.getLeagueManorLineColor(true)
	else
		return worldMapDefine.getLeagueManorLineColor(nil, gMapAllianceRelationType.ENEMY)
	end
end
function simulatedDrillUtil.getPalaceOwner(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local buildId = gWorldTypeServerDef.subTypeSimulatedDrillWarPalace
	return kingdomMapCtrl:getWarBuildingOwner(worldMapDefine.currentMapKindomID, buildId)
end
return simulatedDrillUtil
