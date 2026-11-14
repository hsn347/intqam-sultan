local activity_9001611_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "return_daily_target_reward"
;(nil)[2] = true
activity_9001611_Read:defineValue("return_daily_target_reward", nil)
function activity_9001611_Read.getTargetCfg(classType, backStarLv)
	local _ENV, cfg
	for k, v in ipairs(activity_9001611_Read.return_daily_target_reward) do
		if v.classType == classType and v.rewardtype == 1 and backStarLv >= v.glorylv[1] and backStarLv <= v.glorylv[2] then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function activity_9001611_Read.getCumuCfg(classType, backStarLv)
	local _ENV, cfg
	for k, v in ipairs(activity_9001611_Read.return_daily_target_reward) do
		if v.classType == classType and v.rewardtype == 2 and backStarLv >= v.glorylv[1] and backStarLv <= v.glorylv[2] then
			table.insert(cfg, v)
		end
	end
	return cfg
end
_UPVALUE2_ = nil
;(nil)[1] = "return_daily_target"
;(nil)[2] = true
activity_9001611_Read:defineValue("return_daily_target", nil)
function activity_9001611_Read.getTargetList()
	return activity_9001611_Read.return_daily_target
end
return activity_9001611_Read
