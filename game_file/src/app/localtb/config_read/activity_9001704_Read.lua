local activity_9001704_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "skyisland_recharge"
;(nil)[2] = true
activity_9001704_Read:defineValue("skyisland_recharge", nil)
function activity_9001704_Read.getRechargeCfg(activityID)
	return activity_9001704_Read.skyisland_recharge[1]
end
activity_9001704_Read:defineValue("skyisland_battlepass", function()
	local baseConfig = require_data("skyisland_battlepass", true, true).data
	local _ENV, ret = "skyisland_battlepass", "skyisland_battlepass"
	for i, v in ipairs(baseConfig) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001704_Read.getConfig_battlepass()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001704_Read.skyisland_battlepass[classType]
end
function activity_9001704_Read.getBattlePassMaxDay()
	local config = activity_9001704_Read.getConfig_battlepass()
	return #config
end
activity_9001704_Read:defineValue("skyisland_signin_reward", function()
	local baseConfig = require_data("skyisland_signin_reward", true, true).data
	local _ENV, ret = "skyisland_signin_reward", "skyisland_signin_reward"
	for i, v in ipairs(baseConfig) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001704_Read.getConfig_signin_reward()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001704_Read.skyisland_signin_reward[classType]
end
function activity_9001704_Read.getStageDays(stage)
	local config = activity_9001704_Read.getConfig_signin_reward()
	return config[stage].days
end
activity_9001704_Read:defineValue("island_reward", function()
	local baseConfig = require_data("island_reward", true, true).data
	local _ENV, ret = "island_reward", "island_reward"
	for i, v in ipairs(baseConfig) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.free_reward = serviceFunctions.tableFormat(v.free_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.pay_reward = serviceFunctions.tableFormat(v.pay_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.pass_reward = serviceFunctions.tableFormat(v.pass_reward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001704_Read.getConfig_island_reward()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001704_Read.island_reward[classType]
end
function activity_9001704_Read.getGridMax()
	local config = activity_9001704_Read.getConfig_island_reward()
	return #config
end
function activity_9001704_Read.getFreeReward(index)
	local config = activity_9001704_Read.getConfig_island_reward()
	return config[index].free_reward
end
function activity_9001704_Read.getPayReward(index)
	local config = activity_9001704_Read.getConfig_island_reward()
	return config[index].pay_reward
end
function activity_9001704_Read.getPassReward(index)
	local config = activity_9001704_Read.getConfig_island_reward()
	return config[index].pass_reward
end
activity_9001704_Read:defineValue("payRewardIdxList", function()
	local _ENV, ret
	for classType, confg in pairs(activity_9001704_Read.island_reward) do
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		for i, v in ipairs(confg) do
			if #v.pay_reward > 0 then
				table.insert(ret[classType], i)
			end
		end
	end
	return ret
end)
function activity_9001704_Read.getPayRewardIdxList()
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	local classType = SoraDGetActivityClassType(activityID)
	return activity_9001704_Read.payRewardIdxList[classType]
end
function activity_9001704_Read.getPayRewardIdx(index)
	local payRewardIdxList = activity_9001704_Read.getPayRewardIdxList()
	return payRewardIdxList[index]
end
return activity_9001704_Read
