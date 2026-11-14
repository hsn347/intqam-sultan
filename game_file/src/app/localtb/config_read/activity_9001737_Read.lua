local activity_9001737_Read = include("aAReadClass").new()
local getClassType = function()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY)
end
activity_9001737_Read:defineValue("troublemaker_camp", function()
	local config = require_data("troublemaker_camp", true, true).data
	local _ENV, list = "troublemaker_camp", "troublemaker_camp"
	local _ENV, byCampType = true, true
	for _, v in ipairs(config) do
		table.insert(list, v)
		byCampType[v.campType] = v
	end
	_ENV = (for generator)
	ipairs(config).list = list
	ipairs(config).byCampType = byCampType
	return ipairs(config)
end)
function activity_9001737_Read.getCampCfgList()
	return activity_9001737_Read.troublemaker_camp.list
end
function activity_9001737_Read.getCampCfgByCampType(campType)
	return activity_9001737_Read.troublemaker_camp.byCampType[campType]
end
activity_9001737_Read:defineValue("troublemaker_rank_reward", function()
	local config = require_data("troublemaker_rank_reward", true, true).data
	local _ENV, ret = "troublemaker_rank_reward", "troublemaker_rank_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001737_Read.getRankCfg()
	local classType = getClassType()
	if not activity_9001737_Read.troublemaker_rank_reward[classType] then
		getClassType = activity_9001737_Read.troublemaker_rank_reward[classType]
	end
	return activity_9001737_Read.troublemaker_rank_reward[classType]
end
activity_9001737_Read:defineValue("troublemaker_stage_reward", function()
	local config = require_data("troublemaker_stage_reward", true, true).data
	local _ENV, ret = "troublemaker_stage_reward", "troublemaker_stage_reward"
	local stage = 1
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
			stage = 1
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		v.stage = stage
		table.insert(ret[v.classType], v)
		stage = stage + 1
	end
	return ret
end)
function activity_9001737_Read.getStageRewardCfg()
	local classType = getClassType()
	if not activity_9001737_Read.troublemaker_stage_reward[classType] then
		getClassType = activity_9001737_Read.troublemaker_stage_reward[classType]
	end
	return activity_9001737_Read.troublemaker_stage_reward[classType]
end
return activity_9001737_Read
