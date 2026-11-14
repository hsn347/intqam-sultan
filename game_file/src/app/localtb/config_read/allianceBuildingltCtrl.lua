local allianceBuildingltCtrl = include("aAReadClass").new()
function allianceBuildingltCtrl.init()
	if allianceBuildingltCtrl.isInit then
		return
	end
	allianceBuildingltCtrl.isInit = true
	local createData = function(name)
		local alliance_building_summary_config = require_once("app." .. LocalTblPath .. ".config_server.alliance_building_summary")
		local _ENV, summaryConfig = "app." .. LocalTblPath .. ".config_server.alliance_building_summary", "app." .. LocalTblPath .. ".config_server.alliance_building_summary"
		local _ENV, mainBuildingList = LocalTblPath, LocalTblPath
		for bid, v in pairs(alliance_building_summary_config) do
			local config = v
			config.buildingCondition = serviceFunctions.tableFormatToMap(config.buildingCondition)
			local _ENV, temp = serviceFunctions.tableFormatToMap(config.buildingCondition), serviceFunctions.tableFormatToMap(config.buildingCondition)
			for k, v in pairs(config.demolishRankCondition) do
				temp[v] = true
			end
			config.demolishRankCondition = temp
			summaryConfig[bid] = config
			if gStatus.YES == v.mainBuilding then
				mainBuildingList[bid] = bid
			end
		end
		allianceBuildingltCtrl.buildingSummaryConfig = summaryConfig
		allianceBuildingltCtrl.mainBuildingList = mainBuildingList
		return name == "buildingSummaryConfig" and summaryConfig or mainBuildingList
	end
	allianceBuildingltCtrl:defineValue("buildingSummaryConfig", createData)
	allianceBuildingltCtrl:defineValue("mainBuildingList", createData)
	local createData2 = function()
		local alliance_building_cost_config = require_once("app." .. LocalTblPath .. ".config_server.alliance_building_cost")
		local _ENV, costConfig = "app." .. LocalTblPath .. ".config_server.alliance_building_cost", "app." .. LocalTblPath .. ".config_server.alliance_building_cost"
		for _, v in pairs(alliance_building_cost_config) do
			local config = v
			local bid = v.bid
			local buildingNum = v.buildingNum
			local _ENV, temp
			for k, v in pairs(config.rankCondition) do
				temp[v] = true
			end
			config.rankCondition = temp
			if not costConfig[bid] then
				_ENV = costConfig[bid]
			end
			costConfig[bid] = costConfig[bid]
			assert(not costConfig[bid][buildingNum], string.format("localDataConfigLogic.getAllianceBuildingConfig: repeat num config! bid(%s), buildingNum(%s)!", tostring(bid), tostring(buildingNum)))
			costConfig[bid][buildingNum] = config
		end
		return costConfig
	end
	allianceBuildingltCtrl:defineValue("buildingCostConfig", createData2)
	_UPVALUE2_ = createData2
	createData2[1] = "alliance_stronghold_mine"
	createData2[2] = true
	allianceBuildingltCtrl:defineValue("mineCfg", createData2)
end
allianceBuildingltCtrl.init()
function allianceBuildingltCtrl:getMineCfg(id)
	return self.mineCfg[id]
end
function allianceBuildingltCtrl:isAllianceBuilding(bid)
	if self:getBuildingSummaryConfig()[bid] then
		return true
	end
	return false
end
function allianceBuildingltCtrl:canBuildUseGold(bid, num)
	local costConditionType = self:getBuildingCostConfig()[bid][num].costConditionType
	if gAllianceBuildingCreateCostType.GOLD == costConditionType or gAllianceBuildingCreateCostType.GOLD_OR_BONUS == costConditionType then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getCreateBuildingGoldCount(bid, num)
	return self:getBuildingCostConfig()[bid][num].costGold
end
function allianceBuildingltCtrl:getNeedCastleLevel(bid, num)
	return self:getBuildingCostConfig()[bid][num].castleLevelCondition
end
function allianceBuildingltCtrl:canBuildUseBonus(bid, num)
	local costConditionType = self:getBuildingCostConfig()[bid][num].costConditionType
	if gAllianceBuildingCreateCostType.BONUS == costConditionType or gAllianceBuildingCreateCostType.GOLD_OR_BONUS == costConditionType then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getCreateBuildingBonusCount(bid, num)
	return self:getBuildingCostConfig()[bid][num].costBonus
end
function allianceBuildingltCtrl:canRankMemberCreate(bid, rank, num)
	local ranklist = self:getBuildingCostConfig()[bid][num].rankCondition
	if "table" == type(ranklist) and ranklist[rank] then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getRankMemberCreate(bid, num)
	local ranklist = self:getBuildingCostConfig()[bid][num].rankCondition
	local curRank = gAllianceRank.R5
	if "table" == type(ranklist) then
		for k, v in pairs(ranklist) do
			if v and k < curRank then
				curRank = k
			end
		end
	end
	return curRank
end
function allianceBuildingltCtrl:hasPreviousBuildingConditon(bid)
	local buildingCondition = self:getPreviousBuildingConditon(bid)
	if "table" == type(buildingCondition) and next(buildingCondition) then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getPreviousBuildingConditon(bid)
	return self:getBuildingSummaryConfig()[bid].buildingCondition
end
function allianceBuildingltCtrl:getBuildingDefaultCount(bid)
	return self:getBuildingSummaryConfig()[bid].default
end
function allianceBuildingltCtrl:getBuildingLimit(bid)
	return self:getBuildingSummaryConfig()[bid].limit
end
function allianceBuildingltCtrl:canRankMemberDestory(bid, rank)
	local ranklist = self:getBuildingSummaryConfig()[bid].demolishRankCondition
	if "table" == type(ranklist) and ranklist[rank] then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getHPMax(bid)
	return self:getBuildingSummaryConfig()[bid].HPMax
end
function allianceBuildingltCtrl:getHPMin(bid)
	local HPMin = 0
	return HPMin
end
function allianceBuildingltCtrl:getWarningHPPercent(bid)
	return self:getBuildingSummaryConfig()[bid].warningHPPercent
end
function allianceBuildingltCtrl:getTimeBurnOneHP(bid)
	return self:getBuildingSummaryConfig()[bid].burnOneHPTime
end
function allianceBuildingltCtrl:getTimeRecoverOneHP(bid)
	return self:getBuildingSummaryConfig()[bid].recoverOneHPTime
end
function allianceBuildingltCtrl:beProtected(bid)
	local value = self:getBuildingSummaryConfig()[bid].protected
	if gStatus.YES == value then
		return true
	end
	return false
end
function allianceBuildingltCtrl:hasCD(bid)
	local CDTime = self:getBuildingCD(bid)
	if "number" == type(CDTime) and 0 < CDTime then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getBuildingCD(bid)
	return self:getBuildingSummaryConfig()[bid].buildCDTime
end
function allianceBuildingltCtrl:isMainBuilding(bid)
	local value = self:getBuildingSummaryConfig()[bid].mainBuilding
	if gStatus.YES == value then
		return true
	end
	return false
end
function allianceBuildingltCtrl:getMainBuildingList()
	return self.mainBuildingList
end
function allianceBuildingltCtrl:getRestoreGoldCount(bid)
	return self:getBuildingSummaryConfig()[bid].restoreGold
end
function allianceBuildingltCtrl:getRestoreBonusCount(bid)
	return self:getBuildingSummaryConfig()[bid].restoreBonus
end
function allianceBuildingltCtrl:getBuildingSummaryConfig()
	return self.buildingSummaryConfig
end
function allianceBuildingltCtrl:getBuildingCostConfig()
	return self.buildingCostConfig
end
return allianceBuildingltCtrl
