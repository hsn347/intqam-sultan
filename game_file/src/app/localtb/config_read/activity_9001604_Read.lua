local activity_9001604_Read = include("aAReadClass").new()
activity_9001604_Read:defineValue("ramadan_mobilize_task", function()
	local config = require_data("ramadan_mobilize_task", true, true).data
	local _ENV, ret = "ramadan_mobilize_task", "ramadan_mobilize_task"
	for _, v in ipairs(config) do
		ret[v.taskID] = v
	end
	return ret
end)
activity_9001604_Read:defineValue("ramadan_mobilize_stage_award", function()
	local config = require_data("ramadan_mobilize_stage_award", true, true).data
	local _ENV, ret = "ramadan_mobilize_stage_award", "ramadan_mobilize_stage_award"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		ret[v.classType][v.stage] = v
	end
	return ret
end)
activity_9001604_Read:defineValue("ramadan_mobilize_rank_award", function()
	local config = require_data("ramadan_mobilize_rank_award", true, true).data
	local _ENV, ret = "ramadan_mobilize_rank_award", "ramadan_mobilize_rank_award"
	for _, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001604_Read.getLvCfgs()
	local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
	local group = activity_9001604_Ctrl:getGroupID()
	return activity_9001604_Read.ramadan_mobilize_stage_award[group]
end
function activity_9001604_Read.getRankCfgs()
	local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
	local group = activity_9001604_Ctrl:getGroupID()
	return activity_9001604_Read.ramadan_mobilize_rank_award[group]
end
function activity_9001604_Read.getLvCfgByScore(score)
	local lastCfg
	local lastScore = score
	local rewards = activity_9001604_Read.getLvCfgs()
	for i, v in ipairs(rewards) do
		if lastScore - v.score < 0 then
			return v, false, lastScore
		end
		lastScore = lastScore - v.score
		lastCfg = v
	end
	return lastCfg, true, lastCfg.score
end
function activity_9001604_Read.getTaskName(taskID)
	local task = activity_9001604_Read.ramadan_mobilize_task[taskID]
	return task and task.taskName ~= "" and task.taskName or " "
end
function activity_9001604_Read.getTaskLimitTime(taskID)
	local task = activity_9001604_Read.ramadan_mobilize_task[taskID]
	return task and task.limitTime or 0
end
function activity_9001604_Read.getTaskIcon(taskID)
	local task = activity_9001604_Read.ramadan_mobilize_task[taskID]
	return task and task.taskIcon or ""
end
function activity_9001604_Read.getTaskScore(taskID)
	local task = activity_9001604_Read.ramadan_mobilize_task[taskID]
	return task and task.point or 0
end
return activity_9001604_Read
