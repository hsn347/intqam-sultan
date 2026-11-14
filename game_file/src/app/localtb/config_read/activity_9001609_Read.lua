local activity_9001609_Read = include("aAReadClass").new()
activity_9001609_Read:defineValue("taskCfg", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)
function activity_9001609_Read.getTaskConfig()
	return activity_9001609_Read.taskCfg
end
function _UPVALUE1_()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)[1] = "recallfriends_task_view"
activity_9001609_Read:defineValue("recallfriends_task_view", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)
function activity_9001609_Read.getTaskViewCfg(taskType)
	return activity_9001609_Read.recallfriends_task_view[taskType]
end
function _UPVALUE2_()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)[1] = "recallfriends_binding_reward"
;(function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)[2] = true
activity_9001609_Read:defineValue("recallfriends_binding_reward", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.recallfriends_task")
	for _, v in ipairs(cfg) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v)
	end
	return ret
end)
function activity_9001609_Read.getBindingReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(activity_9001609_Read.recallfriends_binding_reward[1].bindingReward, nil)
end
return activity_9001609_Read
