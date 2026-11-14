local activity_9001479_Read = include("aAReadClass").new()
activity_9001479_Read:defineValue("rewardConfig", function()
	local _ENV, config
	local campintegralreward = require_data("campintegralreward", true).data
	for i, v in ipairs(campintegralreward) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		table.insert(config[round], v)
	end
	activity_9001479_Read.rewardConfig = config
	return activity_9001479_Read.rewardConfig
end)
function activity_9001479_Read.getAwardConfigByRound(round)
	return activity_9001479_Read.rewardConfig[round]
end
function _UPVALUE2_()
	local _ENV, config
	local campintegralreward = require_data("campintegralreward", true).data
	for i, v in ipairs(campintegralreward) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		table.insert(config[round], v)
	end
	activity_9001479_Read.rewardConfig = config
	return activity_9001479_Read.rewardConfig
end
;(function()
	local _ENV, config
	local campintegralreward = require_data("campintegralreward", true).data
	for i, v in ipairs(campintegralreward) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		table.insert(config[round], v)
	end
	activity_9001479_Read.rewardConfig = config
	return activity_9001479_Read.rewardConfig
end)[1] = "campintegraltask"
;(function()
	local _ENV, config
	local campintegralreward = require_data("campintegralreward", true).data
	for i, v in ipairs(campintegralreward) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		table.insert(config[round], v)
	end
	activity_9001479_Read.rewardConfig = config
	return activity_9001479_Read.rewardConfig
end)[2] = true
activity_9001479_Read:defineValue("campintegraltask", function()
	local _ENV, config
	local campintegralreward = require_data("campintegralreward", true).data
	for i, v in ipairs(campintegralreward) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		table.insert(config[round], v)
	end
	activity_9001479_Read.rewardConfig = config
	return activity_9001479_Read.rewardConfig
end)
activity_9001479_Read:defineValue("taskConfig", function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)
function activity_9001479_Read.getTaskConfigByRound(round, batch)
	if not (activity_9001479_Read.taskConfig and activity_9001479_Read.taskConfig[round]) or not activity_9001479_Read.taskConfig[round][batch] then
		local activity_9001479_Read, ret = activity_9001479_Read.taskConfig[round][batch], activity_9001479_Read.taskConfig[round][batch]
	end
	return ret
end
function _UPVALUE2_()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end
;(function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)[1] = "campintegraldata"
;(function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)[2] = false
activity_9001479_Read:defineValue("campintegraldata", function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)
function activity_9001479_Read.getTaskClientConfig(taskType)
	if not activity_9001479_Read.campintegraldata[taskType] then
		activity_9001479_Read = activity_9001479_Read.campintegraldata[taskType]
		activity_9001479_Read.campintegraldata[taskType].describe = "undefined"
	end
	return activity_9001479_Read.campintegraldata[taskType]
end
function activity_9001479_Read.getTaskDescribe(taskType)
	local config = activity_9001479_Read.getTaskClientConfig(taskType)
	return config.describe
end
function activity_9001479_Read.getTaskJump(taskType)
	local config = activity_9001479_Read.getTaskClientConfig(taskType)
	return config.jump
end
function _UPVALUE2_()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end
;(function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)[1] = "campintegraltime"
;(function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)[2] = true
activity_9001479_Read:defineValue("campintegraltime", function()
	local _ENV, config
	for i, v in ipairs(activity_9001479_Read.campintegraltask) do
		local round = v.num
		if not config[round] then
			_ENV = config[round]
		end
		config[round] = config[round]
		local batch = v.batch
		if not config[round][batch] then
			_ENV = config[round][batch]
		end
		config[round][batch] = config[round][batch]
		local taskType = v.type
		if not config[round][batch][taskType] then
			_ENV = config[round][batch][taskType]
		end
		config[round][batch][taskType] = config[round][batch][taskType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(config[round][batch][taskType], v)
	end
	activity_9001479_Read.taskConfig = config
	return activity_9001479_Read.taskConfig
end)
function activity_9001479_Read.getRoundAndBatch(stage)
	local cfg = activity_9001479_Read.campintegraltime[stage]
	return cfg.num, cfg.batch
end
function activity_9001479_Read.getStageTime(stage)
	local cfg = activity_9001479_Read.campintegraltime[stage] or activity_9001479_Read.campintegraltime[#activity_9001479_Read.campintegraltime]
	return cfg.time
end
function activity_9001479_Read.getTabsetArray(...)
	_ENV, _ENV = nil, nil
	_ENV = nil
	;(nil).num = 1
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("circus_text_06", nil)
	_ENV = nil
	;(nil).num = 2
	_ENV, (nil)[2], (nil).title = nil, nil, i18n("circus_text_06", nil)
	_ENV = nil
	;(nil).num = 3
	_ENV, (nil)[3], (nil).title = nil, nil, i18n("circus_text_06", nil)
	_ENV = nil
	;(nil).num = 4
	;(nil)[4], (nil).title = nil, i18n("circus_text_06", nil)
	local tabsetArray
	return tabsetArray
end
return activity_9001479_Read
