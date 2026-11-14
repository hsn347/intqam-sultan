local activity_9001614_Read = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "recharge_return_label"
activity_9001614_Read:defineValue("recharge_return_label", nil)
function activity_9001614_Read.getRechargeTypeCfg()
	return activity_9001614_Read.recharge_return_label
end
activity_9001614_Read:defineValue("recharge_return_daily", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_daily")
	for _, v in ipairs(cfg) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end)
function activity_9001614_Read.getRechargeListCfg(rechargeType)
	return activity_9001614_Read.recharge_return_daily[rechargeType]
end
function _UPVALUE2_()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_daily")
	for _, v in ipairs(cfg) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_daily")
	for _, v in ipairs(cfg) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end)[1] = "recharge_return_reward"
;(function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_daily")
	for _, v in ipairs(cfg) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end)[2] = true
activity_9001614_Read:defineValue("recharge_return_reward", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_daily")
	for _, v in ipairs(cfg) do
		if not ret[v.rechargeType] then
			ret[v.rechargeType], _ENV = nil, nil
		end
		table.insert(ret[v.rechargeType], v)
	end
	return ret
end)
function activity_9001614_Read.getRewardCfg()
	return activity_9001614_Read.recharge_return_reward
end
function activity_9001614_Read.getRewardCfgByIndex(index)
	return activity_9001614_Read.recharge_return_reward[index]
end
activity_9001614_Read:defineValue("recharge_return_encounter", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recharge_return_encounter")
	for _, v in ipairs(cfg) do
		ret[v.rechargeid] = v
	end
	return ret
end)
function activity_9001614_Read.getNotifyGiftCfg(rechargeid)
	return activity_9001614_Read.recharge_return_encounter[rechargeid]
end
return activity_9001614_Read
