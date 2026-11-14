local heroTrialltCtrl = include("aAReadClass").new()
local getHTLikeRankingRewardConfig = function()
	local config = require_once("app." .. LocalTblPath .. ".config_server.hero_trial_like_ranking")
	for index, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
	end
	return config
end
local getHTStageRankingRewardConfig = function()
	local config = require_once("app." .. LocalTblPath .. ".config_server.hero_trial_personal_ranking")
	for index, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
	end
	return config
end
local getHTStageConfig = function()
	local config = require_once("app." .. LocalTblPath .. ".config_server.hero_trial_stage_config")
	local _ENV, ret = "app." .. LocalTblPath .. ".config_server.hero_trial_stage_config", "app." .. LocalTblPath .. ".config_server.hero_trial_stage_config"
	ret.firstStage = config[1].stage
	ret.lastStage = config[#config].stage
	local _ENV, stageConfig = config[#config].stage, config[#config].stage
	local _ENV, mapConfig = ".config_server.hero_trial_stage_config", ".config_server.hero_trial_stage_config"
	local _ENV, areaConfig
	local _ENV, areaTemp
	for index, v in pairs(config) do
		local stage = v.stage
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.enemy = serviceFunctions.tableFormat(v.enemy, nil)
		stageConfig[stage] = v
		local map = v.map
		if not mapConfig[map] then
			_ENV = mapConfig[map]
		end
		mapConfig[map] = mapConfig[map]
		table.insert(mapConfig[map], stage)
		if not areaTemp[map] then
			local area = v.area
			if not areaConfig[area] then
				_ENV = areaConfig[area]
			end
			areaConfig[area] = areaConfig[area]
			table.insert(areaConfig[area], map)
			areaTemp[map] = 1
		end
	end
	ret.stageConfig = stageConfig
	ret.mapConfig = mapConfig
	for k, v in pairs(mapConfig) do
		table.sort(v)
	end
	ret.areaConfig = areaConfig
	for k, v in pairs(areaConfig) do
		table.sort(v)
	end
	return ret
end
local getHTOtherConfig = function()
	local _UPVALUE0_, ret
	ret.initPoint = 5
	ret.limitPoint = 50
	ret.recoveryLimitPoint = 6
	ret.costPoint = 1
	ret.recoveryCDTime = 86400
	ret.limitLogNum = 20
	ret.autoPreTime = 90
	ret.likeAttBuff = 5
	return ret
end
local isInited = false
local init = function()
	if isInited then
		return
	end
	heroTrialltCtrl:defineValue("likeRankingRewardConfig", getHTLikeRankingRewardConfig)
	heroTrialltCtrl:defineValue("stageRankingRewardConfig", getHTStageRankingRewardConfig)
	local createData = function(name)
		local HTStageConfig = getHTStageConfig()
		heroTrialltCtrl.stageConfig = HTStageConfig.stageConfig
		heroTrialltCtrl.mapConfig = HTStageConfig.mapConfig
		heroTrialltCtrl.areaConfig = HTStageConfig.areaConfig
		heroTrialltCtrl.firstStage = HTStageConfig.firstStage
		heroTrialltCtrl.lastStage = HTStageConfig.lastStage
		if name == "stageConfig" then
			return heroTrialltCtrl.stageConfig
		elseif name == "mapConfig" then
			return heroTrialltCtrl.mapConfig
		elseif name == "areaConfig" then
			return heroTrialltCtrl.areaConfig
		elseif name == "firstStage" then
			return heroTrialltCtrl.firstStage
		elseif name == "lastStage" then
			return heroTrialltCtrl.lastStage
		end
	end
	heroTrialltCtrl:defineValue("stageConfig", createData)
	heroTrialltCtrl:defineValue("mapConfig", createData)
	heroTrialltCtrl:defineValue("areaConfig", createData)
	heroTrialltCtrl:defineValue("firstStage", createData)
	heroTrialltCtrl:defineValue("lastStage", createData)
	heroTrialltCtrl:defineValue("HTOtherConfig", getHTOtherConfig)
end
init()
function heroTrialltCtrl.getMapAreaNum()
	return #heroTrialltCtrl.areaConfig
end
function heroTrialltCtrl.getMapListOfArea(area)
	return heroTrialltCtrl.areaConfig[area]
end
function heroTrialltCtrl.getSeniorAreaFirst()
	return heroTrialltCtrl.areaConfig[gTrialArea.SIX][1]
end
function heroTrialltCtrl.getInitFirst()
	return heroTrialltCtrl.areaConfig[gTrialArea.ONE][1]
end
function heroTrialltCtrl.getLastAreaMapID()
	local areaCfg = heroTrialltCtrl.areaConfig[#heroTrialltCtrl.areaConfig]
	return areaCfg[#areaCfg]
end
function heroTrialltCtrl.getMaxArea()
	return heroTrialltCtrl.getMapAreaNum()
end
function heroTrialltCtrl.getFirstStage()
	return heroTrialltCtrl.firstStage
end
function heroTrialltCtrl.getLastStage()
	return heroTrialltCtrl.lastStage
end
function heroTrialltCtrl.getMapIDOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID] and heroTrialltCtrl.stageConfig[stageID].map or 401
end
function heroTrialltCtrl.getLastStageID()
	local lastMapCfg = heroTrialltCtrl.areaConfig[#heroTrialltCtrl.areaConfig]
	local lastMapID = lastMapCfg[#lastMapCfg]
	local stageCfg = heroTrialltCtrl.mapConfig[lastMapID]
	return stageCfg[#stageCfg]
end
function heroTrialltCtrl.getLastStageIDOfArea(areaId)
	local lastMapCfg = heroTrialltCtrl.areaConfig[tonumber(areaId)]
	local lastMapID = lastMapCfg[#lastMapCfg]
	local stageCfg = heroTrialltCtrl.mapConfig[lastMapID]
	return stageCfg[#stageCfg]
end
function heroTrialltCtrl.getAreaIDOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].area
end
function heroTrialltCtrl.getStageTypeOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].stageType
end
function heroTrialltCtrl.getStageBuildTypeOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].stageBuildType
end
function heroTrialltCtrl.getStageListOfMap(mapID)
	return heroTrialltCtrl.mapConfig[mapID]
end
function heroTrialltCtrl.getFirstStageOfMap(mapID)
	local stageArray = heroTrialltCtrl.mapConfig[mapID]
	return stageArray[1]
end
function heroTrialltCtrl.getAreaByMap(mapID)
	for area, v in ipairs(heroTrialltCtrl.areaConfig) do
		if SoraDisInList(mapID, v) then
			return area
		end
	end
end
function heroTrialltCtrl.getNextStage(stageID)
	local nextStage = heroTrialltCtrl.stageConfig[stageID].nextStage
	if nextStage == 0 then
		return nil
	end
	return nextStage
end
function heroTrialltCtrl.isMapID(ID)
	if ID and heroTrialltCtrl.mapConfig[ID] then
		return true
	else
		return false
	end
end
function heroTrialltCtrl.isStageID(ID)
	if ID and heroTrialltCtrl.stageConfig[ID] then
		return true
	else
		return false
	end
end
function heroTrialltCtrl.whetherStageInMap(stageID, mapID)
	local mapIDOfStage = heroTrialltCtrl.getMapIDOfStage(stageID)
	return mapIDOfStage == mapID
end
function heroTrialltCtrl.getLastStageOfMap(mapID)
	local stageArray = heroTrialltCtrl.mapConfig[mapID]
	return stageArray[#stageArray]
end
function heroTrialltCtrl.isLastStageOfMap(stageID)
	local mapID = heroTrialltCtrl.getMapIDOfStage(stageID)
	local lastStageID = heroTrialltCtrl.getLastStageOfMap(mapID)
	return lastStageID == stageID
end
function heroTrialltCtrl.getRewardOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].reward
end
function heroTrialltCtrl.getDefendingSoldiersNumOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].enemyNum
end
function heroTrialltCtrl.getDefendingSoldiersOfStage(stageID)
	return heroTrialltCtrl.stageConfig[stageID].enemy
end
function heroTrialltCtrl.getMapList()
	return heroTrialltCtrl.mapConfig
end
function heroTrialltCtrl.getInitPoint()
	return heroTrialltCtrl.HTOtherConfig.initPoint
end
function heroTrialltCtrl.getLimitPoint()
	return heroTrialltCtrl.HTOtherConfig.limitPoint or 0
end
function heroTrialltCtrl.getRecoveryLimitPoint()
	return heroTrialltCtrl.HTOtherConfig.recoveryLimitPoint
end
function heroTrialltCtrl.getCostPointOfTrial()
	return heroTrialltCtrl.HTOtherConfig.costPoint
end
function heroTrialltCtrl.getRecoveryCDTime()
	return heroTrialltCtrl.HTOtherConfig.recoveryCDTime
end
function heroTrialltCtrl.getLimitLogNum()
	return heroTrialltCtrl.HTOtherConfig.limitLogNum
end
function heroTrialltCtrl.getPreTimeOfAutoBattle()
	return heroTrialltCtrl.HTOtherConfig.autoPreTime
end
function heroTrialltCtrl.getHTLikeRankingRewardList()
	return heroTrialltCtrl.likeRankingRewardConfig
end
function heroTrialltCtrl.gePersonaltRankingRewardList()
	return heroTrialltCtrl.stageRankingRewardConfig
end
function heroTrialltCtrl.getLikeAttackBuff()
	return heroTrialltCtrl.HTOtherConfig.likeAttBuff
end
function heroTrialltCtrl.transformStage(stageID)
	if not heroTrialltCtrl.isStageID(stageID) then
		return
	end
	local map, stage = string.match(stageID, "(%d%d%d)(%d%d)")
	map = tonumber(map)
	stage = tonumber(stage)
	return (map - 401) * 10 + stage
end
return heroTrialltCtrl
