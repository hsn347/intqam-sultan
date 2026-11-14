local cumulativeRecharge2021Read = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "cumulative_recharge"
	;(nil)[2] = true
	cumulativeRecharge2021Read:defineValue("recharge", nil)
	cumulativeRecharge2021Read:defineValue("rechargeList", function()
		cumulativeRecharge2021Read.rechargeList, cumulativeRecharge2021Read = nil, nil
		for index, value in ipairs(cumulativeRecharge2021Read.recharge) do
			if not cumulativeRecharge2021Read.rechargeList[value.activityGrade] then
				cumulativeRecharge2021Read.rechargeList[value.activityGrade], cumulativeRecharge2021Read = nil, nil
			end
			table.insert(cumulativeRecharge2021Read.rechargeList[value.activityGrade], value)
		end
		return cumulativeRecharge2021Read.rechargeList
	end)
	local createData = function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_server.2023_cumulation_recharge")
		cumulativeRecharge2021Read.iceRechargeCumu, _ENV, cumulativeRecharge2021Read.iceRechargeList, _ENV = "app." .. LocalTblPath .. ".config_server.2023_cumulation_recharge", "app." .. LocalTblPath .. ".config_server.2023_cumulation_recharge", "app." .. LocalTblPath .. ".config_server.2023_cumulation_recharge", "app." .. LocalTblPath .. ".config_server.2023_cumulation_recharge"
		for index, value in ipairs(config) do
			if not cumulativeRecharge2021Read.iceRechargeList[value.classtype] then
				cumulativeRecharge2021Read.iceRechargeList[value.classtype], _ENV = nil, nil
			end
			if value.type == 1 then
				table.insert(cumulativeRecharge2021Read.iceRechargeList[value.classtype], value)
			elseif value.type == 2 then
				cumulativeRecharge2021Read.iceRechargeCumu[value.classtype] = value
			end
		end
		return cumulativeRecharge2021Read[name]
	end
	cumulativeRecharge2021Read:defineValue("iceRechargeList", createData)
	cumulativeRecharge2021Read:defineValue("iceRechargeCumu", createData)
end
init()
function cumulativeRecharge2021Read.getRechargeList()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.CUMULATIVE_RECHARGE_2021)
	return cumulativeRecharge2021Read.rechargeList[param.classtype]
end
function cumulativeRecharge2021Read.getIceRechargeList()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classtype = 1
	print("[param.classtype", classtype)
	return cumulativeRecharge2021Read.iceRechargeList[classtype]
end
function cumulativeRecharge2021Read.getIceRechargeCumu()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classtype = 1
	print("[param.classtype", classtype)
	return cumulativeRecharge2021Read.iceRechargeCumu[classtype]
end
return cumulativeRecharge2021Read
