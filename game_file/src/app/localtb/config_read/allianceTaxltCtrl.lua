local allianceTaxltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceTaxltCtrl:initialize()
end
function allianceTaxltCtrl:initialize()
	local createData = function(name)
		local resltConfig = require_once("app." .. LocalTblPath .. ".config_server.alliance_tax_res_config")
		local _ENV, resConfig = "app." .. LocalTblPath .. ".config_server.alliance_tax_res_config", "app." .. LocalTblPath .. ".config_server.alliance_tax_res_config"
		local _ENV, showResArray = LocalTblPath, LocalTblPath
		for _, v in ipairs(resltConfig) do
			local resID = v.resID
			resConfig[resID] = v
			table.insert(showResArray, resID)
		end
		allianceTaxltCtrl.resConfig = resConfig
		allianceTaxltCtrl.showResArray = showResArray
		return name == "resConfig" and resConfig or showResArray
	end
	allianceTaxltCtrl:defineValue("resConfig", createData)
	allianceTaxltCtrl:defineValue("showResArray", createData)
	_UPVALUE2_ = createData
	createData[1] = "alliance_tax_rank"
	createData[2] = true
	allianceTaxltCtrl:defineValue("rankConfig", createData)
end
init()
function allianceTaxltCtrl:getWarehouseShowResArray()
	return self.showResArray
end
function allianceTaxltCtrl:isAllocateResID(resID)
	if resID and self.resConfig[resID] then
		return true
	end
	return false
end
function allianceTaxltCtrl:getAllocateTaxResourceMin(resID)
	return self.resConfig[resID]
end
function allianceTaxltCtrl:getTaxResourceLimit(resID)
	local defaultLimit = 0
	if self.resConfig[resID] then
		local limit = self.resConfig[resID].limit
		limit = limit or defaultLimit
		return limit
	end
	return defaultLimit
end
return allianceTaxltCtrl
