local activity_9001625_Read = include("aAReadClass").new()
activity_9001625_Read:defineValue("feastConfig", function()
	local config = require_data("gathering_activity_feast_reward", true).data
	return activity_9001625_Read.getClassTypeConfig(config, "classtype")
end)
function activity_9001625_Read.getFeastConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.GATHERING_FEAST_2024)
	return activity_9001625_Read.feastConfig[classType] or activity_9001625_Read.feastConfig[1]
end
function activity_9001625_Read.getFeastPoint(cfg)
	return cfg and cfg.point or 0
end
function activity_9001625_Read.getFeastReward(cfg)
	if not cfg or not cfg.reward then
		local _ENV, reward = cfg.reward, cfg.reward
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(reward, nil)
end
function activity_9001625_Read.getFeastRewardById(feastId)
	local feastConfig = activity_9001625_Read.getFeastConfig()
	local cfg = feastConfig[feastId]
	return activity_9001625_Read.getFeastReward(cfg)
end
function activity_9001625_Read.getFeastScoreList(...)
	local activity_9001625_Read, ret
	local feastConfig = activity_9001625_Read.getFeastConfig()
	for i, cfg in ipairs(feastConfig) do
		local point = activity_9001625_Read.getFeastPoint(cfg)
		table.insert(ret, point)
	end
	return ret
end
function _UPVALUE2_()
	local config = require_data("gathering_activity_feast_reward", true).data
	return activity_9001625_Read.getClassTypeConfig(config, "classtype")
end
;(function()
	local config = require_data("gathering_activity_feast_reward", true).data
	return activity_9001625_Read.getClassTypeConfig(config, "classtype")
end)[1] = "gathering_activity_feast_model"
;(function()
	local config = require_data("gathering_activity_feast_reward", true).data
	return activity_9001625_Read.getClassTypeConfig(config, "classtype")
end)[2] = true
activity_9001625_Read:defineValue("gathering_activity_feast_model", function()
	local config = require_data("gathering_activity_feast_reward", true).data
	return activity_9001625_Read.getClassTypeConfig(config, "classtype")
end)
function activity_9001625_Read.getFeastModelType(finishCount)
	local config = activity_9001625_Read.gathering_activity_feast_model
	for __, v in ipairs(config) do
		if finishCount >= v.num[1] and finishCount <= v.num[2] then
			return v.modelType
		end
	end
	return config[#config].modelType
end
activity_9001625_Read:defineValue("taskConfig", function()
	local config = require_data("preparing_feast_quest", true).data
	_UPVALUE2_ = nil
	;(nil)[1] = "classtype"
	;(nil)[2] = "day"
	return activity_9001625_Read.getKeyListConfig(config, nil, "taskID")
end)
function activity_9001625_Read.getTaskConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.PREPARING_FEAST_2024)
	return activity_9001625_Read.taskConfig[classType] or activity_9001625_Read.taskConfig[1]
end
function activity_9001625_Read.getActivityQuestMaxDay(...)
	local cfg = activity_9001625_Read.getTaskConfig()
	return #cfg
end
return activity_9001625_Read
