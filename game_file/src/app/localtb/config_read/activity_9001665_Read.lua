local activity_9001665_Read = include("aAReadClass").new()
activity_9001665_Read:defineValue("fishingmaster_stage_reward", function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_stage_reward", true, true).data
	for i, v in ipairs(oriData) do
		local classType = v.classType
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		table.insert(ret[classType], v)
	end
	return ret
end)
activity_9001665_Read:defineValue("fishingmaster_rank_reward", function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_rank_reward", true, true).data
	for i, v in ipairs(oriData) do
		local classType = v.classType
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		table.insert(ret[classType], v)
	end
	return ret
end)
activity_9001665_Read:defineValue("fishingmaster_point", function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_point", true, true).data
	for i, v in ipairs(oriData) do
		ret[v.difficultType] = v
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	local oriData = require_data("fishingmaster_point", true, true).data
	for i, v in ipairs(oriData) do
		ret[v.difficultType] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_point", true, true).data
	for i, v in ipairs(oriData) do
		ret[v.difficultType] = v
	end
	return ret
end)[1] = "fishingmaster_point_rule"
;(function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_point", true, true).data
	for i, v in ipairs(oriData) do
		ret[v.difficultType] = v
	end
	return ret
end)[2] = true
activity_9001665_Read:defineValue("fishingmaster_point_rule", function()
	local _ENV, ret
	local oriData = require_data("fishingmaster_point", true, true).data
	for i, v in ipairs(oriData) do
		ret[v.difficultType] = v
	end
	return ret
end)
function activity_9001665_Read.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local group = activityShowCtrl:getParamClassType(gActivityTimeActivityID.NORMAL_ACTIVITY_9001665)
	return group
end
function activity_9001665_Read.getBoxCfgs()
	local group = activity_9001665_Read.getGroup()
	return activity_9001665_Read.fishingmaster_stage_reward[group]
end
function activity_9001665_Read.getRankRewards()
