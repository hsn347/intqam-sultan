local nebulaWonderlandRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_wonderland"
;(nil)[2] = true
nebulaWonderlandRead:defineValue("nebula_wonderland", nil)
nebulaWonderlandRead:defineValue("nebulaWonderlandConfig", function()
	return nebulaWonderlandRead.getClassTypeConfig(nebulaWonderlandRead.nebula_wonderland)
end)
function nebulaWonderlandRead.getRewardConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY)
	return nebulaWonderlandRead.nebulaWonderlandConfig[classType]
end
function nebulaWonderlandRead.getMaxMile()
	local config = nebulaWonderlandRead.getRewardConfig()
	local n = table.nums(config)
	return config[n].integral
end
return nebulaWonderlandRead
