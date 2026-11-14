local activity_9001649_Read = include("aAReadClass").new()
function activity_9001649_Read.init()
	activity_9001649_Read:defineValue("reward", function()
		activity_9001649_Read.reward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "weight"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.reward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.reward[v.herotype]
			end
			activity_9001649_Read.reward[v.herotype] = activity_9001649_Read.reward[v.herotype]
			table.insert(activity_9001649_Read.reward[v.herotype], v)
		end
		return activity_9001649_Read.reward
	end)
	activity_9001649_Read:defineValue("stageReward", function()
		activity_9001649_Read.stageReward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_stage_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.stageReward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.stageReward[v.herotype]
			end
			activity_9001649_Read.stageReward[v.herotype] = activity_9001649_Read.stageReward[v.herotype]
			table.insert(activity_9001649_Read.stageReward[v.herotype], v)
		end
		return activity_9001649_Read.stageReward
	end)
	function _UPVALUE2_()
		activity_9001649_Read.stageReward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_stage_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.stageReward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.stageReward[v.herotype]
			end
			activity_9001649_Read.stageReward[v.herotype] = activity_9001649_Read.stageReward[v.herotype]
			table.insert(activity_9001649_Read.stageReward[v.herotype], v)
		end
		return activity_9001649_Read.stageReward
	end
	;(function()
		activity_9001649_Read.stageReward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_stage_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.stageReward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.stageReward[v.herotype]
			end
			activity_9001649_Read.stageReward[v.herotype] = activity_9001649_Read.stageReward[v.herotype]
			table.insert(activity_9001649_Read.stageReward[v.herotype], v)
		end
		return activity_9001649_Read.stageReward
	end)[1] = "ore_set"
	;(function()
		activity_9001649_Read.stageReward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_stage_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.stageReward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.stageReward[v.herotype]
			end
			activity_9001649_Read.stageReward[v.herotype] = activity_9001649_Read.stageReward[v.herotype]
			table.insert(activity_9001649_Read.stageReward[v.herotype], v)
		end
		return activity_9001649_Read.stageReward
	end)[2] = true
	activity_9001649_Read:defineValue("config", function()
		activity_9001649_Read.stageReward, activity_9001649_Read = nil, nil
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.ore_stage_reward")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if not activity_9001649_Read.stageReward[v.herotype] then
				activity_9001649_Read = activity_9001649_Read.stageReward[v.herotype]
			end
			activity_9001649_Read.stageReward[v.herotype] = activity_9001649_Read.stageReward[v.herotype]
			table.insert(activity_9001649_Read.stageReward[v.herotype], v)
		end
		return activity_9001649_Read.stageReward
	end)
end
function activity_9001649_Read.getRewardConfig()
	local classType = activity_9001649_Read.getClassType()
	if not activity_9001649_Read.reward[classType] then
		activity_9001649_Read = activity_9001649_Read.reward[classType]
	end
	return activity_9001649_Read.reward[classType]
end
function activity_9001649_Read.getBigReward()
	local reward = activity_9001649_Read.getRewardConfig()
	for i, v in ipairs(reward) do
		if v.Itemorder == 1 then
			return v.reward[1]
		end
	end
end
function activity_9001649_Read.getRewardCard(id)
	local cfgs = activity_9001649_Read.getRewardConfig()
	for i, v in ipairs(cfgs) do
		if v.drawType == id then
			return v.showType
		end
	end
end
function activity_9001649_Read.getRewardCfg(id)
	local cfgs = activity_9001649_Read.getRewardConfig()
	for i, v in ipairs(cfgs) do
		if v.drawType == id then
			return v
		end
	end
end
function activity_9001649_Read.getStageConfig()
	local classType = activity_9001649_Read.getClassType()
	if not activity_9001649_Read.stageReward[classType] then
		activity_9001649_Read = activity_9001649_Read.stageReward[classType]
	end
	return activity_9001649_Read.stageReward[classType]
end
function activity_9001649_Read.getItemCfg()
	return activity_9001649_Read.config[1]
end
function activity_9001649_Read.getBannerName()
	local reward = activity_9001649_Read.getStageConfig()
	for i, v in ipairs(reward) do
		if v.activity_bg ~= "" then
			return v.activity_bg
		end
	end
	return "bg_activity_9001649.png"
end
function activity_9001649_Read.getClassType(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.GEOCENTRIC_EXPLORATION)
	return classType
end
activity_9001649_Read.init()
return activity_9001649_Read
