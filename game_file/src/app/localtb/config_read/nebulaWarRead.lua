local nebulaWarRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_wars_award"
;(nil)[2] = true
nebulaWarRead:defineValue("nebula_wars_award", nil)
nebulaWarRead:defineValue("nebulaWarsAwardConfig", function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)
function nebulaWarRead.getAwardConfigByRound(round, teamType)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local _, regionId = nebulaActivityCtrl:getKingdomRegionType()
	if not teamType then
		local teamInfo = nebulaActivityCtrl:getMyTeamInfo()
		if teamInfo and teamInfo:getIsSuperTeam() then
			teamType = 1
		else
			teamType = 2
		end
	end
	local cfg = nebulaWarRead.nebulaWarsAwardConfig[round][teamType]
	for __, v in ipairs(cfg) do
		local awardGroup = v.awardGroup[regionId]
		v.award = nebulaWarRead.getGroupAward(awardGroup)
	end
	return cfg
end
function nebulaWarRead.getRewardShowConfig(round, teamType)
	local nebulaWarRead, ret
	local cfg = nebulaWarRead.getAwardConfigByRound(round, teamType)
	for __, v in ipairs(cfg) do
		if v.type ~= 4 then
			table.insert(ret, v)
		end
	end
	return ret
end
function nebulaWarRead.getScoreRewardList(round)
	local nebulaWarRead, ret
	local cfg = nebulaWarRead.getAwardConfigByRound(round)
	local nebulaWarUtil = include("nebulaWarUtil")
	local battldId = nebulaWarUtil.getMyBattldId(round)
	for __, v in ipairs(cfg) do
		if v.type == 4 then
			if round <= 3 then
				table.insert(ret, v)
			elseif battldId == v.battldId then
				table.insert(ret, v)
			end
		end
	end
	return ret
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)[1] = "nebula_wars_group_award"
;(function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_wars_group_award", function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)
function nebulaWarRead.getGroupAward(groupId)
	local cfg = nebulaWarRead.nebula_wars_group_award[groupId]
	if not cfg or not cfg.groupAward then
		nebulaWarRead = cfg.groupAward
	end
	return cfg.groupAward
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)[1] = "nebula_wars_map"
;(function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_wars_map", function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_wars_award) do
		local round = v.num
		local teamType = v.ifPeak
		if not ret[round] then
			_ENV = ret[round]
		end
		ret[round] = ret[round]
		if not ret[round][teamType] then
			_ENV = ret[round][teamType]
		end
		ret[round][teamType] = ret[round][teamType]
		v.awardGroup = serviceFunctions.tableFormatToMap(v.awardGroup)
		table.insert(ret[round][teamType], v)
	end
	return ret
end)
nebulaWarRead:defineValue("superWarAreaRectList", function()
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local _ENV, ret = "mapSyncUtilClient", "mapSyncUtilClient"
	for __, cfg in ipairs(nebulaWarRead.nebula_wars_map) do
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local areas = serviceFunctions.tableFormat(cfg.area, nil)
		for __, area in ipairs(areas) do
			local point = mapSyncUtilClient.serverTOClientPos(cc.p(area.beginX, area.beginY))
			local width = area.endX - area.beginX + 1
			local height = area.endY - area.beginY + 1
			local forbidRect = cc.rect(point.x, point.y, width - 1, height - 1)
			table.insert(ret, forbidRect)
		end
	end
	return ret
end)
function nebulaWarRead.getSuperWarAreaRectList()
	return nebulaWarRead.superWarAreaRectList
end
nebulaWarRead:defineValue("superWarAreaForbidRectList", function()
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local _ENV, ret = "mapSyncUtilClient", "mapSyncUtilClient"
	for __, cfg in ipairs(nebulaWarRead.nebula_wars_map) do
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local areas = serviceFunctions.tableFormat(cfg.area, nil)
		for __, area in ipairs(areas) do
			local point = mapSyncUtilClient.serverTOClientPos(cc.p(area.beginX, area.beginY))
			local radius = cfg.forbiddenSizd
			local width = area.endX - area.beginX + 1 + radius * 2
			local height = area.endY - area.beginY + 1 + radius * 2
			local forbidRect = cc.rect(point.x - radius, point.y - radius, width - 1, height - 1)
			table.insert(ret, forbidRect)
		end
	end
	return ret
end)
function nebulaWarRead.getSuperWarAreaForbidRectList()
	return nebulaWarRead.superWarAreaForbidRectList
end
nebulaWarRead:defineValue("forbidRectList", function()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local buildId = v.buildID
		local point = nebulaWarRead.getBuildPoint(buildId)
		local size = nebulaWarRead.getBuildSize(buildId)
		local radius = nebulaWarRead.getBuildForbiddenSize(buildId)
		local width = size + radius * 2
		local height = size + radius * 2
		local forbidRect = cc.rect(point.x - radius, point.y - radius, width - 1, height - 1)
		table.insert(ret, forbidRect)
	end
	return ret
end)
function nebulaWarRead.getForbidRectList(...)
	return nebulaWarRead.forbidRectList
end
nebulaWarRead:defineValue("buildPos2HoldSize", function()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local key = v.x .. "," .. v.y
		ret[key] = v.size
	end
	return ret
end)
function nebulaWarRead.getBuildHoldSizeByPos(pos)
	local key = pos.x .. "," .. pos.y
	return nebulaWarRead.buildPos2HoldSize[key]
end
function _UPVALUE2_()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local key = v.x .. "," .. v.y
		ret[key] = v.size
	end
	return ret
end
;(function()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local key = v.x .. "," .. v.y
		ret[key] = v.size
	end
	return ret
end)[1] = "nebula_wars_build"
;(function()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local key = v.x .. "," .. v.y
		ret[key] = v.size
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_wars_build", function()
	local _ENV, ret
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		local key = v.x .. "," .. v.y
		ret[key] = v.size
	end
	return ret
end)
nebulaWarRead:defineValue("nebulaWarsBuildList", function()
	local _ENV, config
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		config[v.buildID] = v
	end
	nebulaWarRead.nebulaWarsBuildList = config
	return nebulaWarRead.nebulaWarsBuildList
end)
function nebulaWarRead.getServerBuildConfig(buildId)
	return nebulaWarRead.nebulaWarsBuildList[buildId]
end
function nebulaWarRead.getBuildPoint(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	local mapSyncUtilClient = include("mapSyncUtilClient")
	return mapSyncUtilClient.serverTOClientPos(cc.p(config.x, config.y))
end
function nebulaWarRead.getBuildIdByType(buildType)
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		if v.buildtype == buildType then
			return v.buildID
		end
	end
end
function nebulaWarRead.getBuildBuff(buildId)
	_UPVALUE0_ = nil
	return nil
end
function nebulaWarRead.getBuildStartTime(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	return config.startTime
end
function nebulaWarRead.getBuildTime(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	return config.time
end
function nebulaWarRead.getBuildIntegral(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	return config.integral
end
function nebulaWarRead.getBuildSize(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	return config.size
end
function nebulaWarRead.getBuildForbiddenSize(buildId)
	local config = nebulaWarRead.getServerBuildConfig(buildId)
	return config.forbiddenSize
end
nebulaWarRead:defineValue("buildId2buildType", function()
	local _ENV, config
	for __, v in pairs(nebulaWarRead.nebula_wars_build) do
		config[v.buildID] = v.buildtype
	end
	nebulaWarRead.buildId2buildType = config
	return nebulaWarRead.buildId2buildType
end)
function nebulaWarRead.getBuildTypeByBuildId(buildId)
	return nebulaWarRead.buildId2buildType[buildId]
end
nebulaWarRead:defineValue("nebulaWarsBuildConfigList", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_build_config", false, true).data
	for i, v in ipairs(configs) do
		ret[v.buildtype] = v
	end
	return ret
end)
function nebulaWarRead.getBuildConfig(subType)
	return nebulaWarRead.nebulaWarsBuildConfigList[subType]
end
function nebulaWarRead.getBuildName(subType)
	local config = nebulaWarRead.getBuildConfig(subType)
	if config then
		return i18n(config.name)
	end
end
function nebulaWarRead.getBuildNameByBuildId(buildId)
	local subType = nebulaWarRead.getBuildTypeByBuildId(buildId)
	return nebulaWarRead.getBuildName(subType)
end
function nebulaWarRead.getBuildImage(subType)
	local config = nebulaWarRead.getBuildConfig(subType)
	if config then
		return config.image
	end
end
function nebulaWarRead.getBuildImageByBuildId(buildId)
	local subType = nebulaWarRead.getBuildTypeByBuildId(buildId)
	return nebulaWarRead.getBuildImage(subType)
end
function nebulaWarRead.getBuildIcon(subType)
	local config = nebulaWarRead.getBuildConfig(subType)
	if config then
		return config.icon
	end
end
function nebulaWarRead.getBuildIconByBuildId(buildId)
	local subType = nebulaWarRead.getBuildTypeByBuildId(buildId)
	return nebulaWarRead.getBuildIcon(subType)
end
function nebulaWarRead.getBuildIconLod(subType)
	local config = nebulaWarRead.getBuildConfig(subType)
	if config then
		return config.iconLod
	end
end
function nebulaWarRead.getBuildIconLodByBuildId(buildId)
	local subType = nebulaWarRead.getBuildTypeByBuildId(buildId)
	return nebulaWarRead.getBuildIconLod(subType)
end
function _UPVALUE2_()
	local _ENV, ret
	local configs = require_data("nebula_wars_build_config", false, true).data
	for i, v in ipairs(configs) do
		ret[v.buildtype] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_build_config", false, true).data
	for i, v in ipairs(configs) do
		ret[v.buildtype] = v
	end
	return ret
end)[1] = "nebula_war_monster"
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_build_config", false, true).data
	for i, v in ipairs(configs) do
		ret[v.buildtype] = v
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_war_monster", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_build_config", false, true).data
	for i, v in ipairs(configs) do
		ret[v.buildtype] = v
	end
	return ret
end)
nebulaWarRead:defineValue("nebulaWarsMonsterList", function()
	local _ENV, ret
	for i, v in ipairs(nebulaWarRead.nebula_war_monster) do
		ret[v.npcId] = v
	end
	return ret
end)
function nebulaWarRead.getMonsterConfig(npcId)
	return nebulaWarRead.nebulaWarsMonsterList[npcId]
end
function nebulaWarRead.getMonsterName(npcId)
	return worldMapDefine.getMonsterName(npcId)
end
function nebulaWarRead.getMonsterIntegral(npcId)
	local cfg = nebulaWarRead.getMonsterConfig(npcId)
	return cfg.integral
end
function nebulaWarRead.getMonsterConsume(npcId)
	local cfg = nebulaWarRead.getMonsterConfig(npcId)
	return cfg.consume
end
function nebulaWarRead.getOneMonsterName()
	local npcId = nebulaWarRead.nebula_war_monster[1].npcId
	return nebulaWarRead.getMonsterName(npcId)
end
function nebulaWarRead.getOneMonsterID()
	local npcId = nebulaWarRead.nebula_war_monster[1].npcId
	return npcId
end
function nebulaWarRead.getMonsterRefresh(npcId)
	local cfg = nebulaWarRead.getMonsterConfig(npcId)
	return cfg.refresh
end
function nebulaWarRead.getFirstMonsterRefreshTime()
	local npcId = nebulaWarRead.nebula_war_monster[1].npcId
	local refresh = nebulaWarRead.getMonsterRefresh(npcId)
	local refreshTime = refresh[1]
	local nebulaWarUtil = include("nebulaWarUtil")
	local warStartTime = nebulaWarUtil.getWarRealStartTime()
	local remainTime = warStartTime + refreshTime - serviceFunctions.systemTime()
	if 0 < remainTime then
		return remainTime, refreshTime
	end
end
nebulaWarRead:defineValue("nebulaWarsMineList", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for i, v in ipairs(configs) do
		ret[v.buildID] = v
	end
	return ret
end)
nebulaWarRead:defineValue("targetId2buildId", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)
function nebulaWarRead.getMineConfig(buildId)
	return nebulaWarRead.nebulaWarsMineList[buildId]
end
function nebulaWarRead.getMineTargetBuildName(buildId)
	local buildList = nebulaWarRead.getMineTargetBuildList(buildId)
	local targetBuild = buildList[1]
	return nebulaWarRead.getBuildNameByBuildId(targetBuild)
end
function nebulaWarRead.getMineTargetBuildList(buildId)
	local cfg = nebulaWarRead.getMineConfig(buildId)
	return cfg.targetId
end
function nebulaWarRead.getMineQueueNum(buildId)
	local cfg = nebulaWarRead.getMineConfig(buildId)
	return cfg.num
end
function nebulaWarRead.getTargetBuildScore(targetId)
	local buildId = nebulaWarRead.targetId2buildId[targetId]
	if buildId then
		return nebulaWarRead.getBuildIntegral(buildId)
	end
	return 0
end
function nebulaWarRead.getWarCampName(campType)
	if campType == NEBULA_WAR_CAMP.SOUTH then
		return i18n("nebula_war_text_0076")
	elseif campType == NEBULA_WAR_CAMP.NORTH then
		return i18n("nebula_war_text_0075")
	else
		return ""
	end
end
function nebulaWarRead.getWarCampAbbr(campType)
	if campType == NEBULA_WAR_CAMP.SOUTH then
		return "S"
	elseif campType == NEBULA_WAR_CAMP.NORTH then
		return "N"
	else
		return ""
	end
end
function nebulaWarRead.getWarCampType(campAbbr)
	if campAbbr == "S" then
		return NEBULA_WAR_CAMP.SOUTH
	else
		return NEBULA_WAR_CAMP.NORTH
	end
end
function nebulaWarRead.getWarCampIcon(campType)
	if campType == NEBULA_WAR_CAMP.SOUTH then
		return "icon_battlefield_south.png"
	elseif campType == NEBULA_WAR_CAMP.NORTH then
		return "icon_battlefield_north.png"
	else
		return "icon_battlefield_south.png"
	end
end
function _UPVALUE1_()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)[1] = "nebula_camp_viewinfo"
nebulaWarRead:defineValue("nebula_camp_viewinfo", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)
function nebulaWarRead.getWarGroupName(groupId)
	local cfg = nebulaWarRead.nebula_camp_viewinfo[groupId]
	return i18n(cfg.campName)
end
function nebulaWarRead.getWarGroupAbbr(groupId)
	local cfg = nebulaWarRead.nebula_camp_viewinfo[groupId]
	return i18n(cfg.campAbbreviation)
end
function nebulaWarRead.getWarGroupIcon(groupId)
	local cfg = nebulaWarRead.nebula_camp_viewinfo[groupId]
	return cfg.campIcon
end
function nebulaWarRead.getWarGroupImg(groupId)
	local cfg = nebulaWarRead.nebula_camp_viewinfo[groupId]
	return cfg.campImg
end
function _UPVALUE1_()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)[1] = "nebula_area_name"
nebulaWarRead:defineValue("nebula_area_name", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)
function nebulaWarRead.getAreaName(areaID)
	local config = nebulaWarRead.nebula_area_name[areaID]
	if config then
		return i18n(config.areaname)
	end
end
function nebulaWarRead.getAreaLand(areaID)
	local config = nebulaWarRead.nebula_area_name[areaID]
	return config and config.land or 1
end
function nebulaWarRead.getAreaBigIcon(areaID)
	local config = nebulaWarRead.nebula_area_name[areaID]
	if config then
		return config.icon
	end
end
function nebulaWarRead.getAreaIcon(areaID)
	local config = nebulaWarRead.nebula_area_name[areaID]
	if config then
		return config.icon2
	end
end
function nebulaWarRead.getAreaAbbr(areaID)
	return string.format("A%02d", areaID)
end
function _UPVALUE2_()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)[1] = "nebula_area_group"
;(function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_area_group", function()
	local _ENV, ret
	local configs = require_data("nebula_wars_minenpc", true, true).data
	for __, v in ipairs(configs) do
		for __, targetId in ipairs(v.targetId) do
			ret[targetId] = v.buildID
		end
	end
	return ret
end)
nebulaWarRead:defineValue("nebulaAreaGroupMap", function()
	local _ENV, ret
	for __, v in ipairs(nebulaWarRead.nebula_area_group) do
		ret[v.id] = v.type
	end
	return ret
end)
function nebulaWarRead.getAreaGroup(areaID)
	return nebulaWarRead.nebulaAreaGroupMap[areaID] or 2
end
function nebulaWarRead.getAreaGroupNew(areaID)
	return nebulaWarRead.nebulaAreaGroupMap[areaID] or 0
end
function nebulaWarRead.getCampType(areaID)
	local cfg = nebulaWarRead.nebula_area_group[areaID]
	return cfg and cfg.campType
end
function nebulaWarRead.checkCampType1(areaID)
	local campType = nebulaWarRead.getCampType(areaID)
	return campType and campType == 1
end
function _UPVALUE2_()
	local _ENV, ret
	for __, v in ipairs(nebulaWarRead.nebula_area_group) do
		ret[v.id] = v.type
	end
	return ret
end
;(function()
	local _ENV, ret
	for __, v in ipairs(nebulaWarRead.nebula_area_group) do
		ret[v.id] = v.type
	end
	return ret
end)[1] = "nebula_exchange_time"
;(function()
	local _ENV, ret
	for __, v in ipairs(nebulaWarRead.nebula_area_group) do
		ret[v.id] = v.type
	end
	return ret
end)[2] = true
nebulaWarRead:defineValue("nebula_exchange_time", function()
	local _ENV, ret
	for __, v in ipairs(nebulaWarRead.nebula_area_group) do
		ret[v.id] = v.type
	end
	return ret
end)
nebulaWarRead:defineValue("nebulaExchangeTimeCfg", function()
	local config = nebulaWarRead.nebula_exchange_time
	local nebulaWarRead, ret
	for i, v in ipairs(config) do
		local cfg = clone(v)
		if config[i + 1] then
			_UPVALUE2_ = config[i + 1]
			cfg.range, config[i + 1][1] = config[i + 1], cfg.time
			cfg.range, config[i + 1][2] = config[i + 1], config[i + 1].time
		else
			_UPVALUE2_ = config[i + 1]
			cfg.range, config[i + 1][1] = config[i + 1], cfg.time
			cfg.range, config[i + 1][2] = config[i + 1], cfg.time
		end
		table.insert(ret, cfg)
	end
	return ret
end)
function nebulaWarRead.getExchangeShopTime(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.NEBULA_REGION_ACTIVITY)
	local curTime = serviceFunctions.systemTime()
	local pastTime = curTime - beginTime
	if pastTime < 0 then
		return 0
	end
	for i, cfg in ipairs(nebulaWarRead.nebulaExchangeTimeCfg) do
		if pastTime >= cfg.range[1] and pastTime < cfg.range[2] then
			print("==nebulaWarRead.getExchangeShopTime==", cfg.num, cfg.range[2] - pastTime)
			if 0 < cfg.num then
				return cfg.range[2] - pastTime, cfg.num
			else
				return 0
			end
		end
	end
	return 0
end
nebulaWarRead:defineValue("kingstarrank_server", function()
	local _ENV, ret
	local configs = require_data("kingstarrank_server", true, true).data
	for i, v in ipairs(configs) do
		ret[v.areaid] = v
	end
	return ret
end)
function nebulaWarRead.getExtraAreaCfg(areaid)
	return nebulaWarRead.kingstarrank_server[areaid]
end
function nebulaWarRead.getAreaID(servertype)
	for k, v in pairs(nebulaWarRead.kingstarrank_server) do
		if v.servertype == servertype then
			return k
		end
	end
end
function nebulaWarRead.getServer(servertype)
	for k, v in pairs(nebulaWarRead.kingstarrank_server) do
		if v.servertype == servertype then
			return v.server
		end
	end
end
function nebulaWarRead.getRoundName(round)
	_ENV = nil
	;(nil)[1] = i18n("nebula_stage_name_004")
	;(nil)[2] = i18n("nebula_stage_name_005")
	;(nil)[3] = i18n("nebula_stage_name_006")
	local (nil)[4], config = i18n("nebula_stage_name_007"), nil
	return config[round] or round
end
return nebulaWarRead
