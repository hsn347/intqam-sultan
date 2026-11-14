local activity_9001624_Read = include("aAReadClass").new()
activity_9001624_Read:defineValue("eidalfitr_market_reward", function()
	local config = require_data("eidalfitr_market_reward", true, true).data
	local _ENV, ret = "eidalfitr_market_reward", "eidalfitr_market_reward"
	for _, v in ipairs(config) do
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
function _UPVALUE2_()
	local config = require_data("eidalfitr_market_reward", true, true).data
	local _ENV, ret = "eidalfitr_market_reward", "eidalfitr_market_reward"
	for _, v in ipairs(config) do
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
end
;(function()
	local config = require_data("eidalfitr_market_reward", true, true).data
	local _ENV, ret = "eidalfitr_market_reward", "eidalfitr_market_reward"
	for _, v in ipairs(config) do
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
end)[1] = "eidalfitr_market_recharge"
;(function()
	local config = require_data("eidalfitr_market_reward", true, true).data
	local _ENV, ret = "eidalfitr_market_reward", "eidalfitr_market_reward"
	for _, v in ipairs(config) do
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
end)[2] = true
activity_9001624_Read:defineValue("eidalfitr_market_recharge", function()
	local config = require_data("eidalfitr_market_reward", true, true).data
	local _ENV, ret = "eidalfitr_market_reward", "eidalfitr_market_reward"
	for _, v in ipairs(config) do
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
function activity_9001624_Read.getRewards(activityID)
	if activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local group = activityShowCtrl:getParamClassType(activityID)
		return activity_9001624_Read.edial_celebration_reward[group]
	end
	local activity_9001624_Ctrl = SoraDGetCtrl("activity_9001624_Ctrl")
	local group = activity_9001624_Ctrl:getGroupID()
	return activity_9001624_Read.eidalfitr_market_reward[group]
end
function activity_9001624_Read.getRechargeCfg(activityID)
	if activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		return activity_9001624_Read.edial_celebration_recharge[1]
	end
	return activity_9001624_Read.eidalfitr_market_recharge[1]
end
function activity_9001624_Read.getRechargeName(activityID, rechargeID)
	local cfg = activity_9001624_Read.getRechargeCfg(activityID)
	if cfg then
		if rechargeID then
			return cfg.rechargeID == rechargeID and i18n(cfg.rechargeName)
		else
			return i18n(cfg.rechargeName)
		end
	end
end
activity_9001624_Read:defineValue("edial_celebration_reward", function()
	local config = require_data("edial_celebration_reward", true, true).data
	local _ENV, ret = "edial_celebration_reward", "edial_celebration_reward"
	for _, v in ipairs(config) do
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
function _UPVALUE2_()
	local config = require_data("edial_celebration_reward", true, true).data
	local _ENV, ret = "edial_celebration_reward", "edial_celebration_reward"
	for _, v in ipairs(config) do
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
end
;(function()
	local config = require_data("edial_celebration_reward", true, true).data
	local _ENV, ret = "edial_celebration_reward", "edial_celebration_reward"
	for _, v in ipairs(config) do
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
end)[1] = "edial_celebration_recharge"
;(function()
	local config = require_data("edial_celebration_reward", true, true).data
	local _ENV, ret = "edial_celebration_reward", "edial_celebration_reward"
	for _, v in ipairs(config) do
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
end)[2] = true
activity_9001624_Read:defineValue("edial_celebration_recharge", function()
	local config = require_data("edial_celebration_reward", true, true).data
	local _ENV, ret = "edial_celebration_reward", "edial_celebration_reward"
	for _, v in ipairs(config) do
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
function activity_9001624_Read.getActivityCtrl(activityID)
	if activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		return SoraDGetCtrl("activity_9001637_Ctrl")
	else
		return SoraDGetCtrl("activity_9001624_Ctrl")
	end
end
return activity_9001624_Read
