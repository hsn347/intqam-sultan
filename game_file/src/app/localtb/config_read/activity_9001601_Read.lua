local activity_9001601_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ramadan_bless_reward"
;(nil)[2] = true
activity_9001601_Read:defineValue("ramadan_bless_reward", nil)
activity_9001601_Read:defineValue("blessRewardConfig", function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)
function activity_9001601_Read.getBlessRewardConfig(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.NORMAL_ACTIVITY_9001601)
	local blessRewardConfig = activity_9001601_Read.blessRewardConfig
	return blessRewardConfig[classType] or blessRewardConfig[1]
end
function activity_9001601_Read.getLevelConfig(lv)
	local blessRewardConfig = activity_9001601_Read.getBlessRewardConfig()
	local configMax = activity_9001601_Read.getLevelConfigMax()
	lv = math.min(configMax, lv)
	return blessRewardConfig[lv]
end
function activity_9001601_Read.getLevelConfigMax(...)
	local blessRewardConfig = activity_9001601_Read.getBlessRewardConfig()
	return #blessRewardConfig
end
function activity_9001601_Read.getLevelStr(lv)
	local configMax = activity_9001601_Read.getLevelConfigMax()
	if lv >= configMax then
		return tostring(configMax - 1) .. "+"
	else
		return tostring(lv)
	end
end
function activity_9001601_Read.getLevelByExp(exp)
	local curExp = exp
	local blessRewardConfig = activity_9001601_Read.getBlessRewardConfig()
	for __, cfg in ipairs(blessRewardConfig) do
		if curExp < cfg.exp then
			return cfg.lv - 1, curExp
		else
			curExp = curExp - cfg.exp
		end
	end
	local configMax = activity_9001601_Read.getLevelConfigMax()
	local maxLvExp = activity_9001601_Read.getLevelConfigExp(configMax)
	local n = math.floor(curExp / maxLvExp)
	return configMax + n, curExp - n * maxLvExp
end
function activity_9001601_Read.getLevelConfigExp(lv)
	local cfg = activity_9001601_Read.getLevelConfig(lv)
	return cfg.exp
end
function activity_9001601_Read.getAllAward(giftType)
	activity_9001601_Read = nil
	;(nil)[1] = "advanceReward"
	local (nil)[2], config = "seniorReward", nil
	local rewardKey = config[giftType]
	if not rewardKey then
		return
	end
	local activity_9001601_Read, tempMap
	local blessRewardConfig = activity_9001601_Read.getBlessRewardConfig()
	local configMax = #blessRewardConfig
	for i, cfg in ipairs(blessRewardConfig) do
		if i ~= configMax then
			local award = cfg[rewardKey]
			for i = 1, #award, 2 do
				local itemID, itemCount = award[i], award[i + 1]
				tempMap[itemID] = (tempMap[itemID] or 0) + itemCount
			end
		end
	end
	local activity_9001601_Read, ret = (for generator), ipairs(blessRewardConfig)
	for id, count in pairs(tempMap) do
		activity_9001601_Read = 2
		;(2).id = id
		;(2).count = count
		table.insert(ret, 2)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end
function _UPVALUE2_()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end
;(function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)[1] = "ramadan_bless_recharge"
;(function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)[2] = true
activity_9001601_Read:defineValue("ramadan_bless_recharge", function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)
function activity_9001601_Read.getGiftInfo(giftType)
	return activity_9001601_Read.ramadan_bless_recharge[giftType]
end
function activity_9001601_Read.getGiftTypeByRechargeID(rechargeID)
	for giftType, v in ipairs(activity_9001601_Read.ramadan_bless_recharge) do
		if v.rechargeID == rechargeID then
			return giftType
		end
	end
	return 0
end
function activity_9001601_Read.getGiftNameByRechargeID(rechargeID)
	for __, v in ipairs(activity_9001601_Read.ramadan_bless_recharge) do
		if v.rechargeID == rechargeID then
			return i18n(v.rechargeName)
		end
	end
end
function activity_9001601_Read.getMailDesByRechargeID(rechargeID)
	local giftType = activity_9001601_Read.getGiftTypeByRechargeID(rechargeID)
	activity_9001601_Read = rechargeID
	rechargeID[1] = i18n("ramadan_bless_text_09")
	local rechargeID[2], config = i18n("ramadan_bless_text_11"), rechargeID
	return config[giftType] or rechargeID
end
function _UPVALUE2_()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end
;(function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)[1] = "ramadan_bless_show"
;(function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)[2] = false
activity_9001601_Read:defineValue("ramadan_bless_show", function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_reward, "group")
end)
activity_9001601_Read:defineValue("blessShowConfig", function()
	return activity_9001601_Read.getClassTypeConfig(activity_9001601_Read.ramadan_bless_show, "rechargeID")
end)
function activity_9001601_Read.getGiftBuffShowList(rechargeID)
	return activity_9001601_Read.blessShowConfig[rechargeID]
end
local createData = function(name)
	local _ENV, ret
	local config = require_data(name, true, true).data
	for __, cfg in ipairs(config) do
		local buffType = cfg.buildType
		if not ret[buffType] then
			_ENV = ret[buffType]
		end
		ret[buffType] = ret[buffType]
		_ENV = nil
		;(nil).CastleLv = cfg.buildLv
		;(nil).PrivilegeEffect = cfg.privilegeEffect
		ret[buffType][cfg.rewardType], (nil).EffectIcon = nil, cfg.effectIcon
	end
	return ret
end
activity_9001601_Read:defineValue("ramadan_bless_effect", createData)
function activity_9001601_Read.getBuffInfo(buffType, rewardType)
	local config = activity_9001601_Read.ramadan_bless_effect
	if config[buffType] then
		return config[buffType][rewardType]
	end
end
return activity_9001601_Read
