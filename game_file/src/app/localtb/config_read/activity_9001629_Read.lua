local activity_9001629_Read = include("aAReadClass").new()
activity_9001629_Read:defineValue("stars_wishing_special_reward", function()
	local config = require_data("stars_wishing_special_reward", true, true).data
	local _ENV, ret = "stars_wishing_special_reward", "stars_wishing_special_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "_"
		v.Items = serviceFunctions.tableFormat(v.Items, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function _UPVALUE2_()
	local config = require_data("stars_wishing_special_reward", true, true).data
	local _ENV, ret = "stars_wishing_special_reward", "stars_wishing_special_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "_"
		v.Items = serviceFunctions.tableFormat(v.Items, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end
;(function()
	local config = require_data("stars_wishing_special_reward", true, true).data
	local _ENV, ret = "stars_wishing_special_reward", "stars_wishing_special_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "_"
		v.Items = serviceFunctions.tableFormat(v.Items, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)[1] = "stars_wishing_text"
;(function()
	local config = require_data("stars_wishing_special_reward", true, true).data
	local _ENV, ret = "stars_wishing_special_reward", "stars_wishing_special_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "_"
		v.Items = serviceFunctions.tableFormat(v.Items, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)[2] = true
activity_9001629_Read:defineValue("stars_wishing_text", function()
	local config = require_data("stars_wishing_special_reward", true, true).data
	local _ENV, ret = "stars_wishing_special_reward", "stars_wishing_special_reward"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "_"
		v.Items = serviceFunctions.tableFormat(v.Items, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
activity_9001629_Read:defineValue("stars_wishing_task", function()
	local config = require_data("stars_wishing_task", true, true).data
	local _ENV, ret = "stars_wishing_task", "stars_wishing_task"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.Rewards = serviceFunctions.tableFormat(v.Rewards, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
activity_9001629_Read:defineValue("stars_wishing_level", function()
	local config = require_data("stars_wishing_level", true, true).data
	local _ENV, ret = "stars_wishing_level", "stars_wishing_level"
	for _, v in ipairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001629_Read.getItemData()
	local classType = SoraDGetCtrl("activity_9001629_Ctrl"):getClassType()
	return activity_9001629_Read.stars_wishing_special_reward[classType][1].cost
end
function activity_9001629_Read.getReward()
	local classType = SoraDGetCtrl("activity_9001629_Ctrl"):getClassType()
	return activity_9001629_Read.stars_wishing_special_reward[classType][1].Items
end
function activity_9001629_Read.getWishingTextList(idx)
	return idx and activity_9001629_Read.stars_wishing_text[idx] or activity_9001629_Read.stars_wishing_text
end
function activity_9001629_Read.getTaskList()
	local classType = SoraDGetCtrl("activity_9001629_Ctrl"):getClassType()
	return activity_9001629_Read.stars_wishing_task[classType]
end
function activity_9001629_Read.getLevelList()
	local classType = SoraDGetCtrl("activity_9001629_Ctrl"):getClassType()
	return activity_9001629_Read.stars_wishing_level[classType]
end
return activity_9001629_Read
