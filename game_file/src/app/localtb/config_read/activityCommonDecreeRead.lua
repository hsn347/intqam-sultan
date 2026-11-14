local activityCommonDecreeRead = include("aAReadClass").new()
function activityCommonDecreeRead.getClassType(activityID)
	return SoraDGetActivityClassType(activityID)
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
_UPVALUE2_, _ENV, (nil).keyList, (nil)[1] = "classType", nil, nil, "classType"
_UPVALUE2_, (nil).normalReward, ("classType")[1] = "classType", "classType", "id"
_UPVALUE2_, (nil).normalReward, ("classType")[2] = "classType", "classType", "count"
_UPVALUE2_, (nil).advanceReward, ("classType")[1] = "classType", "classType", "id"
_UPVALUE2_, (nil).advanceReward, ("classType")[2] = "classType", "classType", "count"
;(nil).tableFormat, (nil).seniorReward, ("classType")[1] = nil, "classType", "id"
;(nil).tableFormat, (nil).seniorReward, ("classType")[2] = nil, "classType", "count"
;(nil)[1] = "decoration_battle_reward"
;(nil)[2] = true
activityCommonDecreeRead:defineValue("rewardConfig_9001732", nil)
function activityCommonDecreeRead.getRewardConfig(activityID)
	local classType = activityCommonDecreeRead.getClassType(activityID)
	local config = activityCommonDecreeRead.rewardConfig_9001732
	return config[classType] or config[1]
end
function activityCommonDecreeRead.getLvExpMax(activityID, lv)
	if lv > activityCommonDecreeRead.getMaxLv(activityID) then
		return activityCommonDecreeRead.getMaxExp(activityID)
	end
	local config = activityCommonDecreeRead.getRewardConfig(activityID)
	return config[lv].exp
end
function activityCommonDecreeRead.getNormalRewardConfig(activityID)
	local config = activityCommonDecreeRead.getRewardConfig(activityID)
	local ret = clone(config)
	table.remove(ret, #ret)
	return ret
end
function activityCommonDecreeRead.getSpecialRewardCfg(activityID)
	local config = activityCommonDecreeRead.getRewardConfig(activityID)
	return config[#config]
end
function activityCommonDecreeRead.getMaxLv(activityID)
	local cfg = activityCommonDecreeRead.getSpecialRewardCfg(activityID)
	return cfg.lv
end
function activityCommonDecreeRead.getMaxExp(activityID)
	local cfg = activityCommonDecreeRead.getSpecialRewardCfg(activityID)
	return cfg.exp
end
function activityCommonDecreeRead.getLvByExp(activityID, exp)
	local lv = 0
	local maxLv = activityCommonDecreeRead.getMaxLv(activityID)
	local cfg = activityCommonDecreeRead.getRewardConfig(activityID)
	local totalExp = 0
	local _exp = exp
	for i = 1, maxLv do
		totalExp = totalExp + cfg[i].exp
		if exp < totalExp then
			break
		end
		lv = cfg[i].lv
		_exp = _exp - cfg[i].exp
	end
	if lv == maxLv then
		local overflowExp = exp - totalExp
		local overflowLv = math.floor(overflowExp / cfg[maxLv].exp)
		lv = lv + overflowLv
		_exp = _exp - overflowLv * cfg[maxLv].exp
	end
	return lv, _exp
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "rewardType"
;(nil)[1] = "decoration_battle_recharge"
;(nil)[2] = true
activityCommonDecreeRead:defineValue("rechargeConfig_9001732", nil)
function activityCommonDecreeRead.getRechargeCfg(activityID, rewardType)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001732 then
		return activityCommonDecreeRead.rechargeConfig_9001732[rewardType - 1]
	end
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "rechargeID"
;(nil)[1] = "decoration_battle_recharge"
;(nil)[2] = true
activityCommonDecreeRead:defineValue("rechargeIDConfig_9001732", nil)
function activityCommonDecreeRead.getRechargeName(activityID, rechargeID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001732 then
		local cfg = activityCommonDecreeRead.rechargeIDConfig_9001732[rechargeID]
		return cfg and i18n(cfg.rechargeName)
	end
end
return activityCommonDecreeRead
