local _ENV, cityWallConfig
cityWallConfig.COST_GOLD_OF_EXTINGUISHING = 50
cityWallConfig.RECOVERTY_CD = 1800
cityWallConfig.ADD_BURNING_TIME_AFTER_DEFEND_FAILED = 1800
cityWallConfig.LIMIT_BURNING_TIME = 86400
cityWallConfig.INTERVAL_OF_SUB_DEFENCE = 18
cityWallConfig.REPAIR_DEFENCE = 80
function cityWallConfig.costGoldOfExtinguishing()
	return cityWallConfig.COST_GOLD_OF_EXTINGUISHING
end
function cityWallConfig.getRecovertyCD()
	return cityWallConfig.RECOVERTY_CD
end
function cityWallConfig.getBurningTimeAfterDefendFailed()
	return cityWallConfig.ADD_BURNING_TIME_AFTER_DEFEND_FAILED
end
function cityWallConfig.getLimitBurningTime()
	return cityWallConfig.LIMIT_BURNING_TIME
end
function cityWallConfig.getIntervalOfDefence()
	if worldMapDefine.isInPyramid() or worldMapDefine.isInRadiance() then
		return cityWallConfig.INTERVAL_OF_SUB_DEFENCE / 50
	elseif worldMapDefine.isInNewTrial() then
		return 0.01
	end
	return cityWallConfig.INTERVAL_OF_SUB_DEFENCE
end
function cityWallConfig.getDefenceOfRepairOneTime()
	return cityWallConfig.REPAIR_DEFENCE
end
return cityWallConfig
