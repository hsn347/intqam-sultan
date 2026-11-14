local activity_9001630_Read = include("aAReadClass").new()
function activity_9001630_Read.init()
	activity_9001630_Read:defineValue("reward", function()
		activity_9001630_Read.reward, activity_9001630_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.nebula_paradise_draw_config")
		for i, v in ipairs(cfg) do
			if not activity_9001630_Read.reward[v.classType] then
				activity_9001630_Read = activity_9001630_Read.reward[v.classType]
			end
			activity_9001630_Read.reward[v.classType] = activity_9001630_Read.reward[v.classType]
			_UPVALUE2_ = activity_9001630_Read.reward[v.classType]
			activity_9001630_Read.reward[v.classType][1] = "id"
			activity_9001630_Read.reward[v.classType][2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, activity_9001630_Read.reward[v.classType])
			table.insert(activity_9001630_Read.reward[v.classType], v)
		end
		return activity_9001630_Read.reward
	end)
	activity_9001630_Read:defineValue("stageReward", function()
		activity_9001630_Read.stageReward, activity_9001630_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.nebula_paradise_stage_reward")
		for i, v in ipairs(cfg) do
			if not activity_9001630_Read.stageReward[v.classType] then
				activity_9001630_Read = activity_9001630_Read.stageReward[v.classType]
			end
			activity_9001630_Read.stageReward[v.classType] = activity_9001630_Read.stageReward[v.classType]
			_UPVALUE2_ = activity_9001630_Read.stageReward[v.classType]
			activity_9001630_Read.stageReward[v.classType][1] = "id"
			activity_9001630_Read.stageReward[v.classType][2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, activity_9001630_Read.stageReward[v.classType])
			table.insert(activity_9001630_Read.stageReward[v.classType], v)
		end
		return activity_9001630_Read.stageReward
	end)
	function _ENV()
		activity_9001630_Read.stageReward, activity_9001630_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.nebula_paradise_stage_reward")
		for i, v in ipairs(cfg) do
			if not activity_9001630_Read.stageReward[v.classType] then
				activity_9001630_Read = activity_9001630_Read.stageReward[v.classType]
			end
			activity_9001630_Read.stageReward[v.classType] = activity_9001630_Read.stageReward[v.classType]
			_UPVALUE2_ = activity_9001630_Read.stageReward[v.classType]
			activity_9001630_Read.stageReward[v.classType][1] = "id"
			activity_9001630_Read.stageReward[v.classType][2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, activity_9001630_Read.stageReward[v.classType])
			table.insert(activity_9001630_Read.stageReward[v.classType], v)
		end
		return activity_9001630_Read.stageReward
	end
	;(function()
		activity_9001630_Read.stageReward, activity_9001630_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.nebula_paradise_stage_reward")
		for i, v in ipairs(cfg) do
			if not activity_9001630_Read.stageReward[v.classType] then
				activity_9001630_Read = activity_9001630_Read.stageReward[v.classType]
			end
			activity_9001630_Read.stageReward[v.classType] = activity_9001630_Read.stageReward[v.classType]
			_UPVALUE2_ = activity_9001630_Read.stageReward[v.classType]
			activity_9001630_Read.stageReward[v.classType][1] = "id"
			activity_9001630_Read.stageReward[v.classType][2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, activity_9001630_Read.stageReward[v.classType])
			table.insert(activity_9001630_Read.stageReward[v.classType], v)
		end
		return activity_9001630_Read.stageReward
	end)[1] = "nebula_paradise_view_config"
	activity_9001630_Read:defineValue("config", function()
		activity_9001630_Read.stageReward, activity_9001630_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.nebula_paradise_stage_reward")
		for i, v in ipairs(cfg) do
			if not activity_9001630_Read.stageReward[v.classType] then
				activity_9001630_Read = activity_9001630_Read.stageReward[v.classType]
			end
			activity_9001630_Read.stageReward[v.classType] = activity_9001630_Read.stageReward[v.classType]
			_UPVALUE2_ = activity_9001630_Read.stageReward[v.classType]
			activity_9001630_Read.stageReward[v.classType][1] = "id"
			activity_9001630_Read.stageReward[v.classType][2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, activity_9001630_Read.stageReward[v.classType])
			table.insert(activity_9001630_Read.stageReward[v.classType], v)
		end
		return activity_9001630_Read.stageReward
	end)
end
function activity_9001630_Read.getRewardConfig()
	local group = SoraDGetCtrl("activity_9001630_Ctrl"):getGroupID()
	return activity_9001630_Read.reward[group]
end
function activity_9001630_Read.getRewardCard(id)
	local cfgs = activity_9001630_Read.getRewardConfig()
	for i, v in ipairs(cfgs) do
		if v.drawType == id then
			return v.showType
		end
	end
end
function activity_9001630_Read.getRewardCfg(id)
	local cfgs = activity_9001630_Read.getRewardConfig()
	for i, v in ipairs(cfgs) do
		if v.drawType == id then
			return v
		end
	end
end
function activity_9001630_Read.getStageConfig()
	local group = SoraDGetCtrl("activity_9001630_Ctrl"):getGroupID()
	return activity_9001630_Read.stageReward[group]
end
function activity_9001630_Read.getCardCfg(index)
	return activity_9001630_Read.config[index]
end
activity_9001630_Read.init()
return activity_9001630_Read
