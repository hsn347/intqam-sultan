local allianceResPointltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceResPointltCtrl:defineValue("buildingInfo", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.alliance_build_info")
		local _ENV, allianceBuildInfo = "app." .. LocalTblPath .. ".config_server.alliance_build_info", "app." .. LocalTblPath .. ".config_server.alliance_build_info"
		for i, v in ipairs(config) do
			allianceBuildInfo[v.bid] = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "aim"
			v.buildReq = serviceFunctions.tableFormat(v.buildReq, nil)
			if gConstValue.IS_DEBUG_SERVER then
				for _, cond in ipairs(v.buildReq) do
					if cond.id == gAllianceBuildCondType.MEMBER then
						cond.aim = 1
					end
				end
			end
		end
		return allianceBuildInfo
	end)
end
init()
function allianceResPointltCtrl.isAllianceBuilding(bid)
	if not bid then
		return false
	end
	if allianceResPointltCtrl.buildingInfo[bid] then
		return true
	end
	return false
end
function allianceResPointltCtrl.getBuildingType(bid)
	return allianceResPointltCtrl.getBuildingProperty(bid, "bType")
end
function allianceResPointltCtrl.getCondOfSetBuilding(bid)
	return allianceResPointltCtrl.getBuildingProperty(bid, "buildReq")
end
function allianceResPointltCtrl.getBuildingInitLV(bid)
	return allianceResPointltCtrl.getBuildingProperty(bid, "initLV")
end
function allianceResPointltCtrl.getBuildingMaxLV(bid)
	return allianceResPointltCtrl.getBuildingProperty(bid, "maxLV")
end
function allianceResPointltCtrl.getNeedBonus(bid)
	return allianceResPointltCtrl.getBuildingProperty(bid, "point")
end
function allianceResPointltCtrl.beUpgraded(bid)
	local value = allianceResPointltCtrl.getBuildingProperty(bid, "beUpgraded")
	if 1 == value then
		return true
	else
		if 0 == value then
			return false
		else
		end
	end
end
function allianceResPointltCtrl.isResPoint(bid)
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	if gAllianceBuildType.RESOURCE == buildingType then
		return true
	end
	return false
end
function allianceResPointltCtrl.getBuildingProperty(bid, key)
	print("bid, key = ", bid, key)
	if not bid or not key then
		return
	end
	local info = allianceResPointltCtrl.buildingInfo[bid]
	if not info then
		return
	end
	return info[key]
end
return allianceResPointltCtrl
