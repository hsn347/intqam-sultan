local conquestWarltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local path = "app." .. LocalTblPath .. ".config_server."
	conquestWarltCtrl = nil
	;(nil)[1] = "conquestwar_kingdom_reward"
	;(nil)[2] = true
	conquestWarltCtrl:defineValue("conquestWarKingdomReward", nil)
	conquestWarltCtrl:defineValue("conquestWarPersonalReward", function()
		conquestWarltCtrl.conquestWarPersonalReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_personal_reward")
		conquestWarltCtrl.conquestWarPersonalReward = data
		return conquestWarltCtrl.conquestWarPersonalReward
	end)
	conquestWarltCtrl:defineValue("conquestWarScoreConf", function()
		conquestWarltCtrl.conquestWarScoreConf, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_scoreconf")
		conquestWarltCtrl.conquestWarScoreConf = data
		return conquestWarltCtrl.conquestWarScoreConf
	end)
	conquestWarltCtrl:defineValue("conquestWarWinBuffConf", function()
		conquestWarltCtrl.conquestWarWinBuffConf, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_buff_conf")
		for k, v in pairs(data) do
			local effectType = v.effectType
			conquestWarltCtrl.conquestWarWinBuffConf[effectType] = v
		end
		return conquestWarltCtrl.conquestWarWinBuffConf
	end)
	conquestWarltCtrl:defineValue("conquestWarStageReward", function()
		conquestWarltCtrl.conquestWarStageReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_stage_reward")
		for key, value in ipairs(data) do
			local stageType = value.stageType
			local serverType = value.serverType
			if not conquestWarltCtrl.conquestWarStageReward[serverType] then
				conquestWarltCtrl.conquestWarStageReward[serverType], conquestWarltCtrl = nil, nil
			end
			if not conquestWarltCtrl.conquestWarStageReward[serverType][stageType] then
				conquestWarltCtrl.conquestWarStageReward[serverType][stageType], conquestWarltCtrl = nil, nil
			end
			table.insert(conquestWarltCtrl.conquestWarStageReward[serverType][stageType], value)
		end
		return conquestWarltCtrl.conquestWarStageReward
	end)
	function conquestWarltCtrl()
		conquestWarltCtrl.conquestWarStageReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_stage_reward")
		for key, value in ipairs(data) do
			local stageType = value.stageType
			local serverType = value.serverType
			if not conquestWarltCtrl.conquestWarStageReward[serverType] then
				conquestWarltCtrl.conquestWarStageReward[serverType], conquestWarltCtrl = nil, nil
			end
			if not conquestWarltCtrl.conquestWarStageReward[serverType][stageType] then
				conquestWarltCtrl.conquestWarStageReward[serverType][stageType], conquestWarltCtrl = nil, nil
			end
			table.insert(conquestWarltCtrl.conquestWarStageReward[serverType][stageType], value)
		end
		return conquestWarltCtrl.conquestWarStageReward
	end
	;(function()
		conquestWarltCtrl.conquestWarStageReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_stage_reward")
		for key, value in ipairs(data) do
			local stageType = value.stageType
			local serverType = value.serverType
			if not conquestWarltCtrl.conquestWarStageReward[serverType] then
				conquestWarltCtrl.conquestWarStageReward[serverType], conquestWarltCtrl = nil, nil
			end
			if not conquestWarltCtrl.conquestWarStageReward[serverType][stageType] then
				conquestWarltCtrl.conquestWarStageReward[serverType][stageType], conquestWarltCtrl = nil, nil
			end
			table.insert(conquestWarltCtrl.conquestWarStageReward[serverType][stageType], value)
		end
		return conquestWarltCtrl.conquestWarStageReward
	end)[1] = "conquestwar_assist_reward"
	;(function()
		conquestWarltCtrl.conquestWarStageReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_stage_reward")
		for key, value in ipairs(data) do
			local stageType = value.stageType
			local serverType = value.serverType
			if not conquestWarltCtrl.conquestWarStageReward[serverType] then
				conquestWarltCtrl.conquestWarStageReward[serverType], conquestWarltCtrl = nil, nil
			end
			if not conquestWarltCtrl.conquestWarStageReward[serverType][stageType] then
				conquestWarltCtrl.conquestWarStageReward[serverType][stageType], conquestWarltCtrl = nil, nil
			end
			table.insert(conquestWarltCtrl.conquestWarStageReward[serverType][stageType], value)
		end
		return conquestWarltCtrl.conquestWarStageReward
	end)[2] = true
	conquestWarltCtrl:defineValue("conquestwar_assist_reward", function()
		conquestWarltCtrl.conquestWarStageReward, conquestWarltCtrl = nil, nil
		local data = require_once(path .. "conquestwar_stage_reward")
		for key, value in ipairs(data) do
			local stageType = value.stageType
			local serverType = value.serverType
			if not conquestWarltCtrl.conquestWarStageReward[serverType] then
				conquestWarltCtrl.conquestWarStageReward[serverType], conquestWarltCtrl = nil, nil
			end
			if not conquestWarltCtrl.conquestWarStageReward[serverType][stageType] then
				conquestWarltCtrl.conquestWarStageReward[serverType][stageType], conquestWarltCtrl = nil, nil
			end
			table.insert(conquestWarltCtrl.conquestWarStageReward[serverType][stageType], value)
		end
		return conquestWarltCtrl.conquestWarStageReward
	end)
end
init()
function conquestWarltCtrl.getConquestWarKingdomReward(serverLevType, serverType)
	local _ENV, ret
	for k, v in ipairs(conquestWarltCtrl.conquestWarKingdomReward) do
		if v.serverType == serverType and v.serverLevType == serverLevType then
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
	end
	return ret
end
function conquestWarltCtrl.getConquestWarPersonalReward(kingdomLv, serverType)
	kingdomLv = kingdomLv or 1
	local _ENV, ret
	print("serverType", serverType)
	for k, v in ipairs(conquestWarltCtrl.conquestWarPersonalReward) do
		if (not v.serverLevType or v.serverLevType == kingdomLv) and serverType == v.serverType then
			_ENV = v.serverType
			v.serverType.startrank = v.rank[1]
			v.serverType.endrank = v.rank[2]
			v.serverType.addReward = serviceFunctions.tableFormatToMap(v.addReward)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local v.serverType.reward, data = serviceFunctions.tableFormat(v.reward, nil), v.serverType
			table.insert(ret, data)
		end
	end
	return ret
end
function conquestWarltCtrl.getgetConquestWarChallengeReward(kingdomLv, serverType)
	kingdomLv = kingdomLv or 1
	local _ENV, ret
	print("serverType", serverType)
	for k, v in ipairs(conquestWarltCtrl.conquestwar_assist_reward) do
		if (not v.serverLevType or v.serverLevType == kingdomLv) and serverType == v.serverType then
			_ENV = v.serverType
			v.serverType.type = v.type
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local v.serverType.reward, data = serviceFunctions.tableFormat(v.reward, nil), v.serverType
			table.insert(ret, data)
		end
	end
	return ret
end
function conquestWarltCtrl.getConquestWarScoreConf(eventtype)
	local _ENV, ret
	for k, v in ipairs(conquestWarltCtrl.conquestWarScoreConf) do
		if v.eventtype == eventtype then
			_ENV = v.eventtype
			v.eventtype.condition = v.condition[1]
			v.eventtype.score = v.score
			local v.eventtype.kingScore, data = v.kingdomScore, v.eventtype
			table.insert(ret, data)
		end
	end
	return ret
end
function conquestWarltCtrl.getConquestWarWinBuffInfo(effectType)
	local buffinfo = conquestWarltCtrl.conquestWarWinBuffConf[effectType]
	return buffinfo
end
function conquestWarltCtrl.getConquestWarWinBuffValue(effectType)
	local ret = 0
	local buffinfo = conquestWarltCtrl.conquestWarWinBuffConf[effectType]
	if buffinfo then
		local effect = buffinfo.effect
		if effect[1] and effect[2] then
			if effect[1] == 1 then
				ret = effect[2] / 1000
			elseif effect[1] == 2 then
				ret = effect[2]
			elseif effect[1] == 3 then
				ret = effect[2]
			end
		end
	end
	return ret
end
function conquestWarltCtrl.getStageRewardByType(rewardType, serverType)
	if not conquestWarltCtrl.conquestWarStageReward[serverType][rewardType] then
		conquestWarltCtrl = conquestWarltCtrl.conquestWarStageReward[serverType][rewardType]
	end
	return conquestWarltCtrl.conquestWarStageReward[serverType][rewardType]
end
return conquestWarltCtrl
