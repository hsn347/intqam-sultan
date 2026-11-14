local legendRewardRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "legendaryking_scoreconf"
	;(nil)[2] = true
	legendRewardRead:defineValue("kingScoreConf", nil)
	_ENV = nil
	;(nil)[1] = "kingstarbattle_scoreconf"
	;(nil)[2] = true
	legendRewardRead:defineValue("kingStarScoreConf", nil)
	_ENV = nil
	;(nil)[1] = "kingstarrank_scoreconf"
	;(nil)[2] = true
	legendRewardRead:defineValue("kingStarRankScoreConf", nil)
	_ENV = nil
	;(nil)[1] = "hegemon_scoreconf"
	;(nil)[2] = true
	legendRewardRead:defineValue("hegemonScoreConf", nil)
	legendRewardRead:defineValue("hegemonStageReward", function()
		local hegemonStageReward = require_once("app." .. LocalTblPath .. ".config_server.hegemon_stage_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.hegemon_stage_reward", "app." .. LocalTblPath .. ".config_server.hegemon_stage_reward"
		for _, v in ipairs(hegemonStageReward) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.stageType] then
				_ENV = ret[v.stageType]
			end
			ret[v.stageType] = ret[v.stageType]
			table.insert(ret[v.stageType], v)
		end
		return ret
	end)
	legendRewardRead:defineValue("kingStageReward", function()
		local kingStageReward = require_once("app." .. LocalTblPath .. ".config_server.legendaryking_stage_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.legendaryking_stage_reward", "app." .. LocalTblPath .. ".config_server.legendaryking_stage_reward"
		for _, v in ipairs(kingStageReward) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.stageType] then
				_ENV = ret[v.stageType]
			end
			ret[v.stageType] = ret[v.stageType]
			table.insert(ret[v.stageType], v)
		end
		return ret
	end)
	legendRewardRead:defineValue("kingStarStageReward", function()
		local kingStarStageReward = require_once("app." .. LocalTblPath .. ".config_server.kingstarbattle_stage_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarbattle_stage_reward", "app." .. LocalTblPath .. ".config_server.kingstarbattle_stage_reward"
		for _, v in ipairs(kingStarStageReward) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.stageType] then
				_ENV = ret[v.stageType]
			end
			ret[v.stageType] = ret[v.stageType]
			table.insert(ret[v.stageType], v)
		end
		return ret
	end)
	legendRewardRead:defineValue("kingStarStageRankReward", function()
		local kingStarStageRankReward = require_once("app." .. LocalTblPath .. ".config_server.kingstarrank_stage_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.kingstarrank_stage_reward", "app." .. LocalTblPath .. ".config_server.kingstarrank_stage_reward"
		for _, v in ipairs(kingStarStageRankReward) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not ret[v.servertype] then
				_ENV = ret[v.servertype]
			end
			ret[v.servertype] = ret[v.servertype]
			if not ret[v.servertype][v.stageType] then
				_ENV = ret[v.servertype][v.stageType]
			end
			ret[v.servertype][v.stageType] = ret[v.servertype][v.stageType]
			table.insert(ret[v.servertype][v.stageType], v)
		end
		return ret
	end)
end
init()
function legendRewardRead.getStageRewardByType(stageType, rewardType, mapid)
	if stageType == gLegendStageType.KING then
		return legendRewardRead.kingStageReward[rewardType]
	elseif stageType == gLegendStageType.HEGEMON then
		return legendRewardRead.hegemonStageReward[rewardType]
	elseif stageType == gLegendStageType.KING_STAR then
		local activityID = worldMapDefine.getKingStarActivityID(mapid)
		local cfg = legendRewardRead.kingStarStageRankReward[activityID] or legendRewardRead.kingStarStageReward
		return cfg[rewardType]
	end
end
function legendRewardRead.getScoreConf(stageType, mapid)
	if stageType == gLegendStageType.KING then
		return legendRewardRead.kingScoreConf
	elseif stageType == gLegendStageType.HEGEMON then
		return legendRewardRead.hegemonScoreConf
	elseif stageType == gLegendStageType.KING_STAR then
		if mapid == worldMapDefine.KINGSTAR_KINGDOM_ID then
			return legendRewardRead.kingStarScoreConf
		else
			return legendRewardRead.kingStarRankScoreConf
		end
	end
end
return legendRewardRead
