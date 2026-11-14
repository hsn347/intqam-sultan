local activity_9001670_Read = include("aAReadClass").new()
activity_9001670_Read:defineValue("rebuildRewardConfig", function()
	local config = require_data("bubble_island_rebuld_reward", true, true).data
	local _ENV, ret = "bubble_island_rebuld_reward", "bubble_island_rebuld_reward"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.seniorReward = serviceFunctions.tableFormat(v.seniorReward, nil)
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)
function activity_9001670_Read.getRebuildRewardConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.REBUILD_BUBBLE_LAND)
	return activity_9001670_Read.rebuildRewardConfig[classType] or activity_9001670_Read.rebuildRewardConfig[1]
end
function activity_9001670_Read.getLvExpMax(lv)
	if lv > activity_9001670_Read.getMaxLv() then
		return activity_9001670_Read.getMaxExp()
	end
	local config = activity_9001670_Read.getRebuildRewardConfig()
	return config[lv].exp
end
function activity_9001670_Read.getNormalRewardConfig()
	local config = activity_9001670_Read.getRebuildRewardConfig()
	local ret = clone(config)
	table.remove(ret, #ret)
	return ret
end
function activity_9001670_Read.getSpecialRewardCfg()
	local config = activity_9001670_Read.getRebuildRewardConfig()
	return config[#config]
end
function activity_9001670_Read.getMaxLv(...)
	local cfg = activity_9001670_Read.getSpecialRewardCfg()
	return cfg.lv
end
function activity_9001670_Read.getMaxExp(...)
	local cfg = activity_9001670_Read.getSpecialRewardCfg()
	return cfg.exp
end
function activity_9001670_Read.getLvByExp(exp)
	local lv = 0
	local maxLv = activity_9001670_Read.getMaxLv()
	local cfg = activity_9001670_Read.getRebuildRewardConfig()
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
function _UPVALUE2_()
	local config = require_data("bubble_island_rebuld_reward", true, true).data
	local _ENV, ret = "bubble_island_rebuld_reward", "bubble_island_rebuld_reward"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.seniorReward = serviceFunctions.tableFormat(v.seniorReward, nil)
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end
;(function()
	local config = require_data("bubble_island_rebuld_reward", true, true).data
	local _ENV, ret = "bubble_island_rebuld_reward", "bubble_island_rebuld_reward"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.seniorReward = serviceFunctions.tableFormat(v.seniorReward, nil)
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)[1] = "bubble_island_rebuld_alliance"
;(function()
	local config = require_data("bubble_island_rebuld_reward", true, true).data
	local _ENV, ret = "bubble_island_rebuld_reward", "bubble_island_rebuld_reward"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.seniorReward = serviceFunctions.tableFormat(v.seniorReward, nil)
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)[2] = true
activity_9001670_Read:defineValue("allianceConfig", function()
	local config = require_data("bubble_island_rebuld_reward", true, true).data
	local _ENV, ret = "bubble_island_rebuld_reward", "bubble_island_rebuld_reward"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.seniorReward = serviceFunctions.tableFormat(v.seniorReward, nil)
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)
function activity_9001670_Read.getAllianceConfig(...)
	return activity_9001670_Read.allianceConfig
end
function activity_9001670_Read.getAllianceLv(score)
	for i, v in ipairs(activity_9001670_Read.allianceConfig) do
		if score < v.point then
			return i - 1
		end
	end
	return #activity_9001670_Read.allianceConfig
end
function activity_9001670_Read.getAllianceLvExpMax(lv)
	local lvMax = #activity_9001670_Read.allianceConfig
	local _lv = math.min(lv, lvMax)
	local cfg = activity_9001670_Read.allianceConfig[_lv]
	return cfg.point
end
function activity_9001670_Read.getAllianceLvReward(lv)
	local cfg = activity_9001670_Read.allianceConfig[lv]
	return serviceFunctions.tableFormatToMap(cfg.reward)
end
function activity_9001670_Read.getAllianceCastleType(lv)
	local cfg = activity_9001670_Read.allianceConfig[lv]
	return cfg and cfg.castleType or 1
end
function activity_9001670_Read.getAllianceCastleUsm(lv)
	activity_9001670_Read = nil
	;(nil)[1] = "frame_9001670_chengbao1.usm"
	;(nil)[2] = "frame_9001670_chengbao2.usm"
	local (nil)[3], config = "frame_9001670_chengbao3.usm", nil
	local castleType = activity_9001670_Read.getAllianceCastleType(lv)
	return config[castleType] or castleType[1]
end
activity_9001670_Read:defineValue("bubble_island_rebuld_gift", function()
	local config = require_data("bubble_island_rebuld_gift", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "group")
end)
function activity_9001670_Read.getGiftConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.REBUILD_BUBBLE_LAND)
	return activity_9001670_Read.bubble_island_rebuld_gift[classType] or activity_9001670_Read.bubble_island_rebuld_gift[1]
end
function activity_9001670_Read.getGiftRewards(giftType)
	local config = activity_9001670_Read.getGiftConfig()
	local reward = config[giftType].reward
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	return serviceFunctions.tableFormat(reward, nil)
end
function _UPVALUE2_()
	local config = require_data("bubble_island_rebuld_gift", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "group")
end
;(function()
	local config = require_data("bubble_island_rebuld_gift", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "group")
end)[1] = "bubble_island_rebuld_giftconfig"
;(function()
	local config = require_data("bubble_island_rebuld_gift", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "group")
end)[2] = true
activity_9001670_Read:defineValue("giftConfig", function()
	local config = require_data("bubble_island_rebuld_gift", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "group")
end)
function activity_9001670_Read.getGiftTypeMax(...)
	return #activity_9001670_Read.giftConfig
end
function activity_9001670_Read.getGiftName(giftType)
	local cfg = activity_9001670_Read.giftConfig[giftType]
	return i18n(cfg.giftName)
end
function activity_9001670_Read.getGiftIcon(giftType)
	local cfg = activity_9001670_Read.giftConfig[giftType]
	return cfg.giftIcon
end
function activity_9001670_Read.getGiftDuration(giftType)
	local cfg = activity_9001670_Read.giftConfig[giftType]
	return cfg.duration
end
function activity_9001670_Read.getGiftGrantTime(giftType)
	local cfg = activity_9001670_Read.giftConfig[giftType]
	return cfg.grantTime
end
function activity_9001670_Read.getGiftGrantNum(giftType)
	local cfg = activity_9001670_Read.giftConfig[giftType]
	return cfg.grantNum
end
activity_9001670_Read:defineValue("rechargeConfig", function()
	local config = require_data("bubble_island_rebuld_recharge", true).data
	return activity_9001670_Read.getClassTypeConfig(config, "rewardType")
end)
function activity_9001670_Read.getRechargeCfg(rewardType)
	local config = activity_9001670_Read.rechargeConfig[rewardType]
	if rewardType == 1 then
		return config
	else
		return config[1]
	end
end
function activity_9001670_Read.getRechargeGiftAward(rewardType)
	local rewardConfig = activity_9001670_Read.getRebuildRewardConfig()
	local activity_9001670_Read, giftAward
	for __, v in ipairs(rewardConfig) do
		local activity_9001670_Read, rewards
		if rewardType == 1 then
			rewards = v.normalReward
		elseif rewardType == 2 then
			rewards = v.advanceReward
		elseif rewardType == 3 then
			rewards = v.seniorReward
		end
		for __, v2 in ipairs(rewards) do
			giftAward[v2.id] = (giftAward[v2.id] or 0) + v2.count
		end
	end
	local activity_9001670_Read, ret = (for generator), ipairs(rewardConfig)
	for k, v in pairs(giftAward) do
		activity_9001670_Read = ipairs(rewards)
		ipairs(rewards).id = k
		ipairs(rewards).count = v
		table.insert(ret, ipairs(rewards))
	end
	return ret
end
activity_9001670_Read:defineValue("rechargeIDConfig", function()
	local _ENV, ret
	local config = require_data("bubble_island_rebuld_recharge", true).data
	for i, v in ipairs(config) do
		ret[v.rechargeID] = v
	end
	return ret
end)
function activity_9001670_Read.getRechargeName(rechargeID)
	local cfg = activity_9001670_Read.rechargeIDConfig[rechargeID]
	return cfg and i18n(cfg.rechargeName) or rechargeID
end
return activity_9001670_Read
