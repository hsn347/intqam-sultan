local simulatedDrillRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "simulated_drill_build"
;(nil)[2] = true
simulatedDrillRead:defineValue("simulated_drill_build", nil)
function simulatedDrillRead.getBuildConfig(objId)
	return simulatedDrillRead.simulated_drill_build[objId]
end
function simulatedDrillRead.getBuildName(objId)
	local cfg = simulatedDrillRead.getBuildConfig(objId)
	return cfg and i18n(cfg.buildName) or ""
end
function simulatedDrillRead.getBuildImage(objId)
	local cfg = simulatedDrillRead.getBuildConfig(objId)
	return cfg.buildImage
end
function simulatedDrillRead.getBuildActionlnv(objId)
	local cfg = simulatedDrillRead.getBuildConfig(objId)
	return cfg.actionlnv
end
function simulatedDrillRead.getBuildPoint(objId)
	local cfg = simulatedDrillRead.getBuildConfig(objId)
	return cfg.point
end
function simulatedDrillRead.getBuildSubType(objId)
	local cfg = simulatedDrillRead.getBuildConfig(objId)
	return cfg.type
end
return simulatedDrillRead
