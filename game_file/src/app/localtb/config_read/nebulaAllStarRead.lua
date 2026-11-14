local nebulaAllStarRead = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").NONE = 0
;("aAReadClass").BEGIN = 1
;("aAReadClass").ALL_STAR_TEAM = 2
;("aAReadClass").BACKUP_GROUP_TEAM = 3
;("aAReadClass").ENTER_ROOM = 4
;("aAReadClass").BATTLE = 5
;("aAReadClass").SETTLE = 6
_ENV, nebulaAllStarRead.NEBULA_ALL_STAR_STATE, ("aAReadClass").FINISH = "aAReadClass", "aAReadClass", 7
;("aAReadClass").WIN = 1
_ENV, nebulaAllStarRead.NEBULA_ALLSTAR_WAR_QUIZ_BET_RESULT, ("aAReadClass").LOST = "aAReadClass", "aAReadClass", 2
;("aAReadClass").STAR_KILL_ARMY_SCORE = 1
;("aAReadClass").SUPPORT_KILL_ARMY_SCORE = 2
;("aAReadClass").STAR_VALUE = 3
;("aAReadClass").SUPPORT_VALUE = 4
;("aAReadClass").STAR_ROB_VALUE = 5
;("aAReadClass").SUPPORT_ROB_VALUE = 6
;("aAReadClass").CHARM = 7
;("aAReadClass").CAMP_OCCUPY = 100
;("aAReadClass").VIEWER_COLLECT_SPOIL = 101
nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE, ("aAReadClass").CAMP_COLLECT_SPOIL = "aAReadClass", 102
local RANK_TYPE = nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE
_ENV = nil
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_108"
;(nil).showTitle = "NebulaAllstar_40"
;(nil).showImg = "icon_xyqmx_officer_4.png"
;(nil).showTitle2 = "common_text_2556"
;(nil).key = "killArmyScore"
;(nil)[RANK_TYPE.STAR_KILL_ARMY_SCORE], (nil).scoreDes = nil, "NebulaAllstar_275"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_109"
;(nil).showTitle = "NebulaAllstar_42"
;(nil).showImg = "icon_xyqmx_officer_5.png"
;(nil).showTitle2 = "common_text_2556"
;(nil).key = "killArmyScore"
;(nil)[RANK_TYPE.SUPPORT_KILL_ARMY_SCORE], (nil).scoreDes = nil, "NebulaAllstar_275"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_110"
;(nil).showTitle = "NebulaAllstar_110"
;(nil).showTitle2 = "NebulaAllstar_357"
;(nil).key = "value"
;(nil)[RANK_TYPE.STAR_VALUE], (nil).scoreDes = nil, "NebulaAllstar_121"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_112"
;(nil).showTitle = "NebulaAllstar_112"
;(nil).showTitle2 = "NebulaAllstar_358"
;(nil).key = "value"
;(nil)[RANK_TYPE.SUPPORT_VALUE], (nil).scoreDes = nil, "NebulaAllstar_123"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_111"
;(nil).showTitle = "NebulaAllstar_36"
;(nil).showImg = "icon_xyqmx_officer_2.png"
;(nil).showTitle2 = "NebulaAllstar_37"
;(nil).key = "robValue"
;(nil)[RANK_TYPE.STAR_ROB_VALUE], (nil).scoreDes = nil, "NebulaAllstar_122"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_113"
;(nil).showTitle = "NebulaAllstar_38"
;(nil).showImg = "icon_xyqmx_officer_3.png"
;(nil).showTitle2 = "NebulaAllstar_39"
;(nil).key = "robValue"
;(nil)[RANK_TYPE.SUPPORT_ROB_VALUE], (nil).scoreDes = nil, "NebulaAllstar_124"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_107"
;(nil).showTitle = "NebulaAllstar_34"
;(nil).showImg = "icon_xyqmx_officer_1.png"
;(nil).showTitle2 = "NebulaAllstar_35"
;(nil).key = "charm"
;(nil)[RANK_TYPE.CHARM], (nil).scoreDes = nil, "NebulaAllstar_118"
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_106"
;(nil).showTitle = "NebulaAllstar_51"
;(nil).showImg = "icon_xyqmx_officer_10.png"
;(nil).showTitle2 = "NebulaAllstar_52"
;(nil).key = "occupyPalaceSecs"
;(nil).isRegion = true
;(nil).scoreDes = "NebulaAllstar_305"
;(nil)[RANK_TYPE.CAMP_OCCUPY], (nil).subcmd = nil, gCmd.REQ_NEBULA_ALLSTAR_WAR_CAMP_OCCUPY_RANK
_ENV = nil
;(nil).rankTitle = "NebulaAllstar_114"
;(nil).showTitle = "NebulaAllstar_43"
;(nil).showImg = "icon_xyqmx_officer_6.png"
;(nil).showTitle2 = "NebulaAllstar_44"
;(nil).key = "spoilCount"
;(nil).scoreDes = "NebulaAllstar_125"
;(nil)[RANK_TYPE.VIEWER_COLLECT_SPOIL], (nil).subcmd = nil, gCmd.REQ_NEBULA_ALLSTAR_WAR_VIEWER_COLLECT_SPOIL_RANK
_ENV = nil
;(nil).rankTitle = ""
;(nil).showTitle = "NebulaAllstar_54"
;(nil).showImg = "icon_xyqmx_officer_11.png"
;(nil).showTitle2 = "NebulaAllstar_55"
;(nil).key = "spoilCount"
;(nil).isRegion = true
;(nil)[RANK_TYPE.CAMP_COLLECT_SPOIL], (nil).subcmd = nil, gCmd.REQ_NEBULA_ALLSTAR_WAR_CAMP_COLLECT_SPOIL_RANK
local config
function nebulaAllStarRead.getRankTypeConfig(rankType)
	if not config[rankType] then
		local config, cfg = config[rankType], config[rankType]
	end
	cfg.rankType = rankType
	return cfg
end
function nebulaAllStarRead.getRankTypeSubCmd(rankType)
	local cfg = nebulaAllStarRead.getRankTypeConfig(rankType)
	return cfg and cfg.subcmd or gCmd.REQ_NEBULA_ALLSTAR_WAR_PLAYER_RANK
end
function nebulaAllStarRead.getRankTypeScoreDes(rankType)
	local cfg = nebulaAllStarRead.getRankTypeConfig(rankType)
	if cfg and cfg.scoreDes then
		return i18n(cfg.scoreDes)
	else
		return rankType
	end
end
function nebulaAllStarRead.getRankTypeValueKey(rankType)
	local cfg = nebulaAllStarRead.getRankTypeConfig(rankType)
	return cfg and cfg.key or "value"
end
function nebulaAllStarRead.getRankConfig(...)
	_UPVALUE9_ = nil
	;(nil)[1] = RANK_TYPE.CAMP_OCCUPY
	;(nil)[2] = RANK_TYPE.CHARM
	;(nil)[3] = RANK_TYPE.STAR_KILL_ARMY_SCORE
	;(nil)[4] = RANK_TYPE.SUPPORT_KILL_ARMY_SCORE
	;(nil)[5] = RANK_TYPE.STAR_VALUE
	;(nil)[6] = RANK_TYPE.STAR_ROB_VALUE
	;(nil)[7] = RANK_TYPE.SUPPORT_VALUE
	;(nil)[8] = RANK_TYPE.SUPPORT_ROB_VALUE
	local (nil)[9], config = RANK_TYPE.VIEWER_COLLECT_SPOIL, nil
	local RANK_TYPE, ret = RANK_TYPE.CAMP_OCCUPY, RANK_TYPE.CAMP_OCCUPY
	for __, rankType in ipairs(config) do
		table.insert(ret, nebulaAllStarRead.getRankTypeConfig(rankType))
	end
	return ret
end
function nebulaAllStarRead.getShowRankConfig(...)
	_UPVALUE8_ = nil
	;(nil)[1] = RANK_TYPE.CAMP_OCCUPY
	;(nil)[2] = RANK_TYPE.CAMP_COLLECT_SPOIL
	;(nil)[3] = RANK_TYPE.CHARM
	;(nil)[4] = RANK_TYPE.STAR_ROB_VALUE
	;(nil)[5] = RANK_TYPE.SUPPORT_ROB_VALUE
	;(nil)[6] = RANK_TYPE.STAR_KILL_ARMY_SCORE
	;(nil)[7] = RANK_TYPE.SUPPORT_KILL_ARMY_SCORE
	local (nil)[8], config = RANK_TYPE.VIEWER_COLLECT_SPOIL, nil
	local RANK_TYPE, ret = RANK_TYPE.CAMP_OCCUPY, RANK_TYPE.CAMP_OCCUPY
	for __, rankType in ipairs(config) do
		table.insert(ret, nebulaAllStarRead.getRankTypeConfig(rankType))
	end
	return ret
end
_UPVALUE2_ = nil
;(nil)[1] = "nebulaallstarconstant"
;(nil)[2] = true
nebulaAllStarRead:defineValue("constantTable", nil)
function nebulaAllStarRead.getConstValue(key, defaultValue)
	local info = nebulaAllStarRead.constantTable[key]
	local value = info and info.value
	if value then
		return value
	end
	return defaultValue
end
function nebulaAllStarRead.getTeamNumMax(isSuperTeam)
	if isSuperTeam ~= false then
		return nebulaAllStarRead.getConstValue("AllStarTeamNum", 50)
	else
		return nebulaAllStarRead.getConstValue("SupportTeamNum", 150)
	end
end
function nebulaAllStarRead.getTeamCommandMax()
	return nebulaAllStarRead.getConstValue("AllStarTeamAdjutantNum", 4)
end
function nebulaAllStarRead.getNeedLv(...)
	return nebulaAllStarRead.getConstValue("NeedLv", 54)
end
function nebulaAllStarRead.getViewerNeedLv(...)
	return nebulaAllStarRead.getConstValue("ViewerNeedLv", 31)
end
function nebulaAllStarRead.getPalaceEnergyMax(...)
	return nebulaAllStarRead.getConstValue("NebulaCupEnergy", 10000)
end
function nebulaAllStarRead.getAreaEnergyMax(...)
	return nebulaAllStarRead.getConstValue("EveryCampCanGetEnergy", 1000)
end
function nebulaAllStarRead.getDonateGoldMax(...)
	return nebulaAllStarRead.getConstValue("donateGoldMax", 1000)
end
function nebulaAllStarRead.getSupportEnrollCD(...)
	local nebulaWarUtil = include("nebulaWarUtil")
	if nebulaWarUtil.getIsDebug() then
		return 30
	end
	return nebulaAllStarRead.getConstValue("SupportEnrollCD", 1800)
end
function nebulaAllStarRead.getFreeSoldierNum(...)
	return nebulaAllStarRead.getConstValue("FreeSoldierNum", 12000000)
end
_UPVALUE2_ = nil
;(nil)[1] = "nebulaallstarcamp"
;(nil)[2] = true
nebulaAllStarRead:defineValue("nebulaallstarcamp", nil)
function nebulaAllStarRead.getAllStarTeamAbbr(areaID)
	local cfg = nebulaAllStarRead.nebulaallstarcamp[areaID]
	if cfg then
		return cfg.allstarname
	end
	return string.format("A%02d", areaID)
end
function nebulaAllStarRead.getSupportTeamAbbr(areaID)
	local cfg = nebulaAllStarRead.nebulaallstarcamp[areaID]
	if cfg then
		return cfg.supportname
	end
	return string.format("B%02d", areaID)
end
function nebulaAllStarRead.getCampColorRGB(areaID)
	if areaID then
		local cfg = nebulaAllStarRead.nebulaallstarcamp[areaID]
		if cfg then
			return SoraDHtmlColor2RGB(cfg.campColor)
		end
	end
	return cc.c3b(255, 255, 255)
end
local createData = function(name)
	local _ENV, config
	local _ENV, buildIDList
	local _ENV, buildPosMap
	local nebulaemperorbuild = require_data("nebulaallstarbuilding", true, true).data
	for i, v in ipairs(nebulaemperorbuild) do
		v.buildID = v.BuildingId
		v.buildtype = v.BuildingType
		v.x = v.Xpos
		v.y = v.Ypos
		local cfg = nebulaAllStarRead.getBuildScanConfig(v.buildtype)
		if cfg then
			v.name = cfg.BuildingName
			v.image = cfg.image
			v.icon = cfg.iconBig
			v.iconLod = cfg.iconSmall
		end
		config[v.buildID] = v
		if not buildIDList[v.buildtype] then
			_ENV = buildIDList[v.buildtype]
		end
		buildIDList[v.buildtype] = buildIDList[v.buildtype]
		table.insert(buildIDList[v.buildtype], v.buildID)
		local posKey = v.x .. "," .. v.y
		buildPosMap[posKey] = true
	end
	nebulaAllStarRead.nebulaemperorbuild = config
	for __, v in pairs(buildIDList) do
		table.sort(v, function(a, b)
			local dataA = nebulaAllStarRead.nebulaemperorbuild[a]
			local dataB = nebulaAllStarRead.nebulaemperorbuild[b]
			if dataA.x ~= dataB.x then
				return dataA.x < dataB.x
			end
			if dataA.y ~= dataB.y then
				return dataA.y < dataB.y
			end
			return dataA.buildID < dataB.buildID
		end)
	end
	nebulaAllStarRead.buildIDList = buildIDList
	if name == "nebulaemperorbuild" then
		return nebulaAllStarRead.nebulaemperorbuild
	elseif name == "buildIDList" then
		return nebulaAllStarRead.buildIDList
	elseif name == "buildPosMap" then
		return buildPosMap
	end
end
nebulaAllStarRead:defineValue("nebulaemperorbuild", createData)
nebulaAllStarRead:defineValue("buildIDList", createData)
nebulaAllStarRead:defineValue("buildPosMap", createData)
function nebulaAllStarRead.getBuildConfig(buildID)
	return nebulaAllStarRead.nebulaemperorbuild[buildID]
end
function nebulaAllStarRead.getBuildName(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg and i18n(cfg.name)
end
function nebulaAllStarRead.getBuildImage(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.image
end
function nebulaAllStarRead.getBuildType(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.buildtype
end
function nebulaAllStarRead.getBuildSize(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg and cfg.size or 2
end
function nebulaAllStarRead.getBuildIconLod(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.iconLod
end
function nebulaAllStarRead.getBuildPos(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cc.p(cfg.x, cfg.y)
end
function nebulaAllStarRead.getBuildIcon(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.icon
end
function nebulaAllStarRead.getBuildParameters(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.parameters
end
function nebulaAllStarRead.getBuildBandage(buildID)
	local param = nebulaAllStarRead.getBuildParameters(buildID)
	if param and 0 < #param then
		return param[2] / param[1] * 60
	else
		return 0
	end
end
function nebulaAllStarRead.getBuildBuffId(buildID)
	local cfg = nebulaAllStarRead.getBuildConfig(buildID)
	return cfg.BuffId
end
function nebulaAllStarRead.getBuildIDListByType(buildType)
	if not nebulaAllStarRead.buildIDList[buildType] then
		nebulaAllStarRead = nebulaAllStarRead.buildIDList[buildType]
	end
	return nebulaAllStarRead.buildIDList[buildType]
end
function nebulaAllStarRead.checkIsBuildInPos(pos)
	local posKey = pos.x .. "," .. pos.y
	return nebulaAllStarRead.buildPosMap[posKey] or false
end
nebulaAllStarRead:defineValue("nebulaallstarbuildingscan", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getBuildScanConfig(buildType)
	return nebulaAllStarRead.nebulaallstarbuildingscan[buildType]
end
function nebulaAllStarRead.getBuildNameByType(buildType)
	local cfg = nebulaAllStarRead.getBuildScanConfig(buildType)
	return cfg and i18n(cfg.BuildingName)
end
function nebulaAllStarRead.getBuildImageByType(buildType)
	local cfg = nebulaAllStarRead.getBuildScanConfig(buildType)
	return cfg.image
end
function nebulaAllStarRead.getBuildBandageByType(buildType)
	local buildList = nebulaAllStarRead.getBuildIDListByType(buildType)
	return nebulaAllStarRead.getBuildBandage(buildList[1])
end
function nebulaAllStarRead.getMapBuildPosition(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarPalace] = cc.p(0, 100)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarTower] = cc.p(0, 100)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarBigSpring] = cc.p(0, 100)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarSmallSpring] = cc.p(0, 100)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarObservation] = cc.p(-20, 88)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarEngine] = cc.p(0, 88)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarCrossbow] = cc.p(28, 88)
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarWorkshop] = cc.p(0, 88)
	local (nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarCamp], config = cc.p(-34, 110), nil
	return config[subType] or cc.p(0, 0)
end
function nebulaAllStarRead.getMapBuildScale(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarPalace] = 1.2
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarObservation] = 1.2
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarEngine] = 1.2
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarCrossbow] = 1.2
	;(nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarWorkshop] = 1.2
	local (nil)[gWorldTypeServerDef.subTypeNebulaAllStarWarCamp], config = 1.5, nil
	return config[subType] or 1
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[1] = "allstartowerbuff"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("allstartowerbuff", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getEnergyBuff()
	return nebulaAllStarRead.allstartowerbuff
end
function nebulaAllStarRead.getEnergyBuffIDList()
	return table.ikeys(nebulaAllStarRead.allstartowerbuff)
end
function nebulaAllStarRead.getEnergyBuffConfig(buffID)
	return nebulaAllStarRead.allstartowerbuff[buffID]
end
function nebulaAllStarRead.getEnergyBuffName(buffID)
	local cfg = nebulaAllStarRead.getEnergyBuffConfig(buffID)
	return i18n(cfg.name)
end
function nebulaAllStarRead.getEnergyBuffDes(buffID)
	local cfg = nebulaAllStarRead.getEnergyBuffConfig(buffID)
	return i18n(cfg.text)
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[1] = "nebulaallstardonatedes"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("nebulaallstardonatedes", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getDonateSkillConfig(...)
	return nebulaAllStarRead.nebulaallstardonatedes[1]
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[1] = "nebulaallstardonate"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("nebulaallstardonate", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getDonateGoldConfig(grade)
	grade = math.min(grade, nebulaAllStarRead.getDonateLvMax())
	return nebulaAllStarRead.nebulaallstardonate[grade]
end
function nebulaAllStarRead.getDonateLvMax()
	return #nebulaAllStarRead.nebulaallstardonate
end
function nebulaAllStarRead.getDonateLv(value)
	for i, v in ipairs(nebulaAllStarRead.nebulaallstardonate) do
		if value < v.needGold then
			return i - 1
		end
	end
	return nebulaAllStarRead.getDonateLvMax()
end
function nebulaAllStarRead.isDonateLvMax(grade)
	return grade >= nebulaAllStarRead.getDonateLvMax()
end
function nebulaAllStarRead.getDonateNeedGold(grade)
	local cfg = nebulaAllStarRead.getDonateGoldConfig(grade)
	return cfg and cfg.needGold or 0
end
function nebulaAllStarRead.getDonateSkillDes(grade)
	local cfg = nebulaAllStarRead.getDonateGoldConfig(grade)
	return i18n(cfg and cfg.text)
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[1] = "nebulaallstardonaterewards"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("nebulaallstardonaterewards", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getDonateRewardConfig(grade)
	return nebulaAllStarRead.nebulaallstardonaterewards[grade]
end
function nebulaAllStarRead.getDonateRewardMax()
	return #nebulaAllStarRead.nebulaallstardonaterewards
end
function nebulaAllStarRead.getDonateRewardNeedGold(grade)
	local cfg = nebulaAllStarRead.getDonateRewardConfig(grade)
	return cfg.needGold
end
function nebulaAllStarRead.getDonateRewardNeedGoldMax()
	local gradeMax = nebulaAllStarRead.getDonateRewardMax()
	return nebulaAllStarRead.getDonateRewardNeedGold(gradeMax)
end
function nebulaAllStarRead.getDonateRewards(grade)
	local cfg = nebulaAllStarRead.getDonateRewardConfig(grade)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.rewards, nil)
end
function nebulaAllStarRead.getDonateRewardGoldPercent(totalGold)
	local gradeMax = nebulaAllStarRead.getDonateRewardMax()
	local _needGold = 0
	for i, v in ipairs(nebulaAllStarRead.nebulaallstardonaterewards) do
		if totalGold < v.needGold then
			local percent = v.grade / gradeMax - (v.needGold - totalGold) / (v.needGold - _needGold) / gradeMax
			return percent
		end
		_needGold = v.needGold
	end
	return 1
end
function nebulaAllStarRead.getDonateRewardFrame(grade)
	local cfg = nebulaAllStarRead.getDonateRewardConfig(grade)
	return cfg.frame
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[1] = "nebulaallstarmap"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("nebulaallstarmap", function()
	local _ENV, ret
	local config = require_data("nebulaallstarbuildingscan", false, true).data
	for i, v in ipairs(config) do
		ret[v.BuildingType] = v
	end
	return ret
end)
function nebulaAllStarRead.getMapAreaConfig(areaType, camp)
	local _ENV, ret
	for __, v in ipairs(nebulaAllStarRead.nebulaallstarmap) do
		if v.type == areaType and (not camp or camp == v.camp) then
			table.insert(ret, v.area)
		end
	end
	return ret
end
nebulaAllStarRead:defineValue("nebulaallstarrankrewards", function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)
function nebulaAllStarRead.getRewardConfigByType(rankID)
	return nebulaAllStarRead.nebulaallstarrankrewards[rankID]
end
function nebulaAllStarRead.getRobRewardConfig(isSuperTeam)
	if isSuperTeam then
		return nebulaAllStarRead.getRewardConfigByType(3)
	else
		return nebulaAllStarRead.getRewardConfigByType(5)
	end
end
function nebulaAllStarRead.getRewardConfigRankStr(cfg)
	local rankCorridor = cfg.rankCorridor
	local rank1, rank2 = rankCorridor[1], rankCorridor[2]
	local rankStr = ""
	if rank1 == 9999 or rank2 == 9999 then
		rankStr = string.format("%d+", rank1)
	elseif rank1 ~= rank2 then
		rankStr = string.format("%d-%d", rank1, rank2)
	else
		rankStr = rank1
	end
	return rankStr
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)[1] = "nebulaallstargift"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("nebulaallstargift", function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)
function nebulaAllStarRead.getGiftList()
	local _ENV, ret
	local starLv = SoraDGetBuildStarLv()
	for __, v in ipairs(nebulaAllStarRead.nebulaallstargift) do
		if starLv >= v.castleLv and nebulaAllStarRead.checkGiftType(v.gifttype) then
			table.insert(ret, v)
		end
	end
	return ret
end
function nebulaAllStarRead.checkGiftType(gifttype)
	if gifttype == 1 then
		return true
	end
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if nebulaAllStarUtil.checkBattleState() then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		local isHasTeam = nebulaAllStarCtrl:getMyTeamInfo():isHasTeam()
		if gifttype == 2 and not isHasTeam then
			return true
		elseif gifttype == 3 and isHasTeam then
			return true
		end
	end
	return false
end
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)[1] = "viewerquiz"
;(function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)[2] = true
nebulaAllStarRead:defineValue("viewerquiz", function()
	local _ENV, ret
	local config = require_data("nebulaallstarrankrewards", true, true).data
	for i, v in ipairs(config) do
		if not ret[v.rankID] then
			_ENV = ret[v.rankID]
		end
		ret[v.rankID] = ret[v.rankID]
		table.insert(ret[v.rankID], v)
	end
	return ret
end)
function nebulaAllStarRead.getTurnByTime(time)
	local cfg = nebulaAllStarRead.viewerquiz[1]
	for k, v in ipairs(nebulaAllStarRead.viewerquiz) do
		if time >= v.RefreshTime then
			cfg = v
		end
	end
	return cfg.turn
end
function nebulaAllStarRead.getNextTurnByTime(time)
	local cfg = nebulaAllStarRead.viewerquiz[#nebulaAllStarRead.viewerquiz]
	for k, v in ipairs(nebulaAllStarRead.viewerquiz) do
		if time <= v.RefreshTime then
			cfg = v
			break
		end
	end
	return cfg.turn
end
function nebulaAllStarRead.isLastTurn(turn)
	return turn >= #nebulaAllStarRead.viewerquiz
end
function nebulaAllStarRead.getGuessTime(turn, time)
	local leftTime = nebulaAllStarRead.getConstValue("QuizTime", 300) - (time - nebulaAllStarRead.viewerquiz[turn].RefreshTime)
	return math.max(leftTime, 0)
end
function nebulaAllStarRead.getTurnCfg(turn)
	local cfg = nebulaAllStarRead.viewerquiz[1]
	for k, v in ipairs(nebulaAllStarRead.viewerquiz) do
		if v.turn == turn then
			cfg = v
			break
		end
	end
	return cfg
end
nebulaAllStarRead:defineValue("viewerquiztheme", function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)
function nebulaAllStarRead.getThemeCfg(themeID)
	return nebulaAllStarRead.viewerquiztheme[themeID]
end
function _UPVALUE2_()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[1] = "viewerquizodd"
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[2] = true
nebulaAllStarRead:defineValue("viewerquizodd", function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)
function nebulaAllStarRead.getOddByRank(rank)
	return nebulaAllStarRead.viewerquizodd[rank].ThemeOdd / 100
end
function _UPVALUE2_()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[1] = "viewerquizstore"
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[2] = true
nebulaAllStarRead:defineValue("viewerquizstore", function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)
function nebulaAllStarRead.getStoreCfg()
	return nebulaAllStarRead.viewerquizstore
end
function _UPVALUE2_()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[1] = "allstarscoretask"
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[2] = true
nebulaAllStarRead:defineValue("allstarscoretask", function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)
function _UPVALUE2_()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[1] = "supportscoretask"
;(function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)[2] = true
nebulaAllStarRead:defineValue("supportscoretask", function()
	nebulaAllStarRead.viewerquiztheme, nebulaAllStarRead = nil, nil
	local cfg = require_data("viewerquiztheme", true, true).data
	for k, v in ipairs(cfg) do
		nebulaAllStarRead.viewerquiztheme[v.ThemeId] = v
	end
	return nebulaAllStarRead.viewerquiztheme
end)
function nebulaAllStarRead.getScoreTaskList(isSuperTeam)
	if isSuperTeam then
		return nebulaAllStarRead.allstarscoretask
	else
		return nebulaAllStarRead.supportscoretask
	end
end
function nebulaAllStarRead.getTaskConfig(taskID, isSuperTeam)
	local config = nebulaAllStarRead.getScoreTaskList(isSuperTeam)
	return config[taskID]
end
function nebulaAllStarRead.getTaskConfigTask(taskID, isSuperTeam)
	local cfg = nebulaAllStarRead.getTaskConfig(taskID, isSuperTeam)
	return cfg and cfg.task or 0
end
nebulaAllStarRead:defineValue("viewerGiftName", function()
	_UPVALUE0_ = nil
	;(nil)[1] = "NebulaAllstar_189"
	local (nil)[2], ret = "NebulaAllstar_190", nil
	return ret
end)
function nebulaAllStarRead.getViewerGiftName(giftType)
	local cfg = nebulaAllStarRead.viewerGiftName[giftType]
	return cfg and i18n(cfg) or tostring(giftType)
end
nebulaAllStarRead:defineValue("allstarrulemsg", function()
	local _ENV, ret
	local config = require_data("allstarrulemsg", false, true).data
	for i, v in ipairs(config) do
		if not ret[v.type] then
			_ENV = ret[v.type]
		end
		ret[v.type] = ret[v.type]
		if not ret[v.type][v.page] then
			_ENV = ret[v.type][v.page]
		end
		ret[v.type][v.page] = ret[v.type][v.page]
		table.insert(ret[v.type][v.page], v)
	end
	return ret
end)
function nebulaAllStarRead.getFAQConfig(...)
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if nebulaAllStarUtil.isWarTest() then
		if not nebulaAllStarRead.allstarrulemsg[2] then
			_ENV = nebulaAllStarRead.allstarrulemsg[2]
		end
		return nebulaAllStarRead.allstarrulemsg[2]
	else
		if not nebulaAllStarRead.allstarrulemsg[1] then
			_ENV = nebulaAllStarRead.allstarrulemsg[1]
		end
		return nebulaAllStarRead.allstarrulemsg[1]
	end
end
return nebulaAllStarRead
