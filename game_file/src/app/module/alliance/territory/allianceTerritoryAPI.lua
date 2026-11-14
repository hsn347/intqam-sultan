local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceBuff = require("app." .. LocalTblPath .. ".config_server.alliance_territory_income")
local _ENV, allianceTerritoryAPI = "app." .. LocalTblPath .. ".config_server.alliance_territory_income", "app." .. LocalTblPath .. ".config_server.alliance_territory_income"
function allianceTerritoryAPI:buildAllianceBuilding(bid, pos, costType)
	if not self:checkAllianceTerritory() then
		return
	end
	local posNew = include("mapSyncUtilClient").clientTOServerPos(pos)
	if gAllianceBuilding.PALACE == bid then
		costType = gAllianceCreateBuildingCostType.BONUS
	end
	if gAllianceCreateBuildingCostType.GOLD == costType then
		return self:getTerritoryCtrl():buildAllianceBuildingUseGold(bid, posNew)
	elseif gAllianceCreateBuildingCostType.BONUS == costType then
		return self:getTerritoryCtrl():buildAllianceBuildingUseBonus(bid, posNew)
	elseif gAllianceCreateBuildingCostType.RECYCLE == costType then
		return self:getTerritoryCtrl():buildAllianceBuildingUseBonus(bid, posNew, true)
	end
end
function allianceTerritoryAPI:demolishAllianceBuilding(id, bid)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():demolishAllianceBuilding(id, bid)
end
function allianceTerritoryAPI:getAllianceMainBuildingInfo()
	if not self:checkAllianceTerritory() then
		_UPVALUE0_ = self:checkAllianceTerritory()
		return (self:checkAllianceTerritory())
	end
	return self:getTerritoryCtrl():getAllianceMainBuildingInfo()
end
function allianceTerritoryAPI:getBuildingRemainCDTime(bid)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getBuildingRemainCDTime(bid)
end
function allianceTerritoryAPI:getCurrentBuildingHP(id, bid)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getCurrentBuildingHP(id, bid)
end
function allianceTerritoryAPI:getAllianceFlagInfo()
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getAllianceFlagInfo()
end
function allianceTerritoryAPI:getAllianceFlagCount()
	local ret = 0
	if not self:checkAllianceTerritory() then
		return ret
	end
	return self:getTerritoryCtrl():getAllianceFlagCount()
end
function allianceTerritoryAPI:getFlagLimit()
	return allianceBuildingltCtrl:getBuildingLimit(gAllianceBuilding.FLAG)
end
function allianceTerritoryAPI:getCurrentFlagLimit()
	local ret = 0
	if not self:checkAllianceTerritory() then
		return ret
	end
	local allianceScience = self:getAllianceScience()
	if not allianceScience:getAllianceFlagInfo() then
		local allianceBuildingltCtrl, ret = allianceScience:getAllianceFlagInfo(), allianceScience:getAllianceFlagInfo()
	end
	local curSciAddCount = ret.curSciAddCount or 0
	local total = allianceBuildingltCtrl:getBuildingDefaultCount(gAllianceBuilding.FLAG) + curSciAddCount
	return total
end
function allianceTerritoryAPI:getCreateBuildingGoldCount(bid, buildCount)
	buildCount = buildCount or 1
	if "number" ~= type(buildCount) then
		return
	end
	local limit = allianceBuildingltCtrl:getBuildingLimit(bid)
	if buildCount <= 0 or buildCount > limit then
		return
	end
	return allianceBuildingltCtrl:getCreateBuildingGoldCount(bid, buildCount)
end
function allianceTerritoryAPI:getCreateBuildingBonusCount(bid, buildCount)
	buildCount = buildCount or 1
	if "number" ~= type(buildCount) then
		return
	end
	local limit = allianceBuildingltCtrl:getBuildingLimit(bid)
	if buildCount <= 0 or buildCount > limit then
		return
	end
	return allianceBuildingltCtrl:getCreateBuildingBonusCount(bid, buildCount)
end
function allianceTerritoryAPI:getCreateFlagGoldCount(buildCount)
	return self:getCreateBuildingGoldCount(gAllianceBuilding.FLAG, buildCount)
end
function allianceTerritoryAPI:getCreateFlagBonusCount(buildCount)
	return self:getCreateBuildingBonusCount(gAllianceBuilding.FLAG, buildCount)
end
function allianceTerritoryAPI:getRestoreBonus(bid)
	bid = bid or gAllianceBuilding.PALACE
	return allianceBuildingltCtrl:getRestoreBonusCount(bid)
end
function allianceTerritoryAPI:getRestoreGold(bid)
	bid = bid or gAllianceBuilding.PALACE
	return allianceBuildingltCtrl:getRestoreGoldCount(bid)
end
function allianceTerritoryAPI:restoreAllianceBuilding(id, bid, costType)
	if not self:checkAllianceTerritory() then
		local _UPVALUE0_, defaultValue = self:checkAllianceTerritory(), self:checkAllianceTerritory()
		return defaultValue
	end
	return self:getTerritoryCtrl():restoreAllianceBuilding(id, bid, costType)
end
function allianceTerritoryAPI:getAllianceBuildingInfo(id, bid)
	if not self:checkAllianceTerritory() then
		local _UPVALUE0_, defaultValue = self:checkAllianceTerritory(), self:checkAllianceTerritory()
		return defaultValue
	end
	return self:getTerritoryCtrl():getAllianceBuildingInfo(id, bid)
end
function allianceTerritoryAPI:loadTaxRecordList(recordIDFlag, count)
	if not self:checkAllianceTerritory() then
		local _UPVALUE0_, defaultValue = self:checkAllianceTerritory(), self:checkAllianceTerritory()
		return defaultValue
	end
	return self:getTerritoryCtrl():getTaxRecordList(recordIDFlag, count)
end
function allianceTerritoryAPI:getTaxWarehouseData()
	if not self:checkAllianceTerritory() then
		local _UPVALUE0_, defaultValue = self:checkAllianceTerritory(), self:checkAllianceTerritory()
		return defaultValue
	end
	return self:getTerritoryCtrl():getAllianceTaxWarehouseData()
end
function allianceTerritoryAPI:allocateTaxes(resID)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():allocateTaxes(resID)
end
function allianceTerritoryAPI:getBurningBuildingList()
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getBurningBuildingList()
end
function allianceTerritoryAPI:getWellDestroyBuildingNum()
	local ret = 0
	if not self:checkAllianceTerritory() then
		return ret
	end
	local list = self:getTerritoryCtrl():getBurningBuildingList()
	return list and #list or 0
end
function allianceTerritoryAPI:getTaxPer()
	if not self:checkAllianceTerritory() then
		return 0
	end
	return self:getTerritoryCtrl():getTaxPer()
end
function allianceTerritoryAPI:getScore()
	if not self:checkAllianceTerritory() then
		local defaultValue = 0
		return defaultValue
	end
	return self:getTerritoryCtrl():getAreas()
end
function allianceTerritoryAPI:getKillBuff()
	local myScore = self:getScore()
	for k, v in pairs(allianceBuff) do
		local min = v.scorerange[1]
		local max = v.scorerange[2]
		if myScore >= min and myScore <= max then
			return v.expbuff
		end
	end
	return 0
end
function allianceTerritoryAPI:getIsHaveBuidingInConstruction(...)
	local buildingFlags = self:getTerritoryCtrl():getBuildingFlags()
	if 0 < #buildingFlags then
		return true
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceBuild = gametop.playertop_:getModule("allianceBuild")
	local resBuildings = allianceBuild:getBuildingList()
	for i, v in ipairs(resBuildings) do
		if v:getBuildingStatus() == gAllianceBuildingStatus.BUILD then
			return true
		end
	end
	if not self:checkAllianceTerritory() then
		return false
	end
	return self:getTerritoryCtrl():getIsHaveBuidingInConstruction(...)
end
function allianceTerritoryAPI:getAllBuildingPos()
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getAllBuildingPos()
end
function allianceTerritoryAPI:calcCurrentHP(buildingData)
	local building = include("allianceBuilding").new(buildingData.wall)
	return building:calcCurrentHP()
end
function allianceTerritoryAPI:getTaxResourceLimit(resID)
	return include("allianceTaxltCtrl"):getTaxResourceLimit(resID)
end
function allianceTerritoryAPI:checkHasMainBuilding(bid)
	local buildingInfoList = self:getAllianceMainBuildingInfo()
	for k, v in pairs(buildingInfoList) do
		if v.bid == bid and v.status ~= gAllianceBuildingStatus.NONE and v.status ~= gAllianceBuildingStatus.DESTROY and v.status ~= gAllianceBuildingStatus.BUILDING then
			return true
		end
	end
	return false
end
function allianceTerritoryAPI:getMainBuildingPos(bid)
	local buildingInfoList = self:getAllianceMainBuildingInfo()
	for k, v in pairs(buildingInfoList) do
		if v.bid == bid then
			return v.pos
		end
	end
	_ENV = (for generator)
	return pairs(buildingInfoList)
end
function allianceTerritoryAPI:getRecycleBuildings(...)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():getRecycleBuildings(...)
end
function allianceTerritoryAPI:checkHasRecycleBuilding(...)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():checkHasRecycleBuilding(...)
end
function allianceTerritoryAPI:checkIsRecycleBuilding(...)
	if not self:checkAllianceTerritory() then
		return
	end
	return self:getTerritoryCtrl():checkIsRecycleBuilding(...)
end
function allianceTerritoryAPI:getTerritoryCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("allianceTerritoryCtrl")
end
function allianceTerritoryAPI:getAllianceScience()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("allianceScience")
end
function allianceTerritoryAPI:checkAllianceTerritory()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local aid = allianceMgr:getOwnAid()
	if "number" ~= type(aid) or aid <= 0 then
		return false
	end
	if not self:getTerritoryCtrl():getTerritory() then
		return false
	end
	return true
end
return allianceTerritoryAPI
