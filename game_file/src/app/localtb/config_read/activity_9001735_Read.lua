local activity_9001735_Read = include("aAReadClass").new()
activity_9001735_Read:defineValue("freekick_master_rank", function()
	local config = require_data("freekick_master_rank", true, true).data
	local _ENV, ret = "freekick_master_rank", "freekick_master_rank"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001735_Read.getRankCfg()
	local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
	local classType = activity_9001735_Ctrl:getClassType()
	return activity_9001735_Read.freekick_master_rank[classType]
end
function activity_9001735_Read.getMaxRankNum()
	local config = activity_9001735_Read.getRankCfg()
	return config[#config].rank[2]
end
activity_9001735_Read:defineValue("freekick_master_reward", function()
	local config = require_data("freekick_master_reward", true, true).data
	local _ENV, ret = "freekick_master_reward", "freekick_master_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		ret[v.classType][v.rewardType] = serviceFunctions.tableFormat(v.reward, nil)
	end
	return ret
end)
function activity_9001735_Read.getRewardCfg(rewardType)
	local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
	local classType = activity_9001735_Ctrl:getClassType()
	return activity_9001735_Read.freekick_master_reward[classType][rewardType]
end
activity_9001735_Read:defineValue("freekick_master_recharge", function()
	local config = require_data("freekick_master_recharge", true, true).data
	local _ENV, ret = "freekick_master_recharge", "freekick_master_recharge"
	for k, v in ipairs(config) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end)
function activity_9001735_Read.getRechargeCfg(rechargeType)
	if rechargeType == 1 then
		return activity_9001735_Read.freekick_master_recharge[rechargeType][1]
	else
		return activity_9001735_Read.freekick_master_recharge[rechargeType]
	end
end
function activity_9001735_Read.getRechargeName(rechargeID)
	for rechargeType, cfg in ipairs(activity_9001735_Read.freekick_master_recharge) do
		for _, v in ipairs(cfg) do
			if v.rechargeID == rechargeID then
				return i18n(v.rechargeName)
			end
		end
	end
end
activity_9001735_Read:defineValue("freekick_master_battlepass", function()
	local config = require_data("freekick_master_battlepass", true, true).data
	local _ENV, ret = "freekick_master_battlepass", "freekick_master_battlepass"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001735_Read.getBattlePassCfg()
	local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
	local classType = activity_9001735_Ctrl:getClassType()
	return activity_9001735_Read.freekick_master_battlepass[classType]
end
activity_9001735_Read:defineValue("freekick_master_stage_reward", function()
	local config = require_data("freekick_master_stage_reward", true, true).data
	local _ENV, ret = "freekick_master_stage_reward", "freekick_master_stage_reward"
	local stage = 1
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
			stage = 1
		end
		v.stage = stage
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType], v)
		stage = stage + 1
	end
	return ret
end)
function activity_9001735_Read.getStageRewardCfg()
	local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
	local classType = activity_9001735_Ctrl:getClassType()
	return activity_9001735_Read.freekick_master_stage_reward[classType]
end
return activity_9001735_Read
