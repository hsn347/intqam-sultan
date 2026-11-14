local activity_9001711_Read = include("aAReadClass").new()
activity_9001711_Read:defineValue("adventure_recharge", function()
	local config = require_data("adventure_recharge", true, true).data
	local _ENV, ret = "adventure_recharge", "adventure_recharge"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		ret[v.rechargeID] = v
	end
	return ret
end)
activity_9001711_Read:defineValue("adventure_recharge_view", function()
	local config = require_data("adventure_recharge_view", false, true).data
	local _ENV, ret = "adventure_recharge_view", "adventure_recharge_view"
	for k, v in ipairs(config) do
		ret[v.showType] = v
	end
	return ret
end)
function activity_9001711_Read.getRechargeCfg(rechargeID)
	return activity_9001711_Read.adventure_recharge[tonumber(rechargeID)]
end
function activity_9001711_Read.getRechargeViewCfg(showType)
	return activity_9001711_Read.adventure_recharge_view[tonumber(showType)]
end
return activity_9001711_Read
