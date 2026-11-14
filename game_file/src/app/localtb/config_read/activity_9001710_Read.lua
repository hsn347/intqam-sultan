local activity_9001710_Read = include("aAReadClass").new()
activity_9001710_Read:defineValue("crescentdecree_reward", function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001710_Read.getRewardCfg()
	return activity_9001710_Read.crescentdecree_reward
end
function activity_9001710_Read.getRewardMaxLv()
	return #activity_9001710_Read.crescentdecree_reward
end
function activity_9001710_Read.getRewardExpByLv(lv)
	local lv = math.min(math.max(lv, 1), #activity_9001710_Read.crescentdecree_reward)
	return activity_9001710_Read.crescentdecree_reward[lv].exp
end
function activity_9001710_Read:getLvByExp(exp)
	local lv = 0
	local showExp = 0
	local curExp = 0
	for k, v in ipairs(activity_9001710_Read.crescentdecree_reward) do
		curExp = curExp + v.exp
		if exp >= curExp then
			lv = v.lv
			showExp = exp - curExp
		else
			break
		end
	end
	return lv, showExp
end
function _UPVALUE2_()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "crescentdecree_quest"
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001710_Read:defineValue("crescentdecree_quest", function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001710_Read.getQuestCfg()
	return activity_9001710_Read.crescentdecree_quest
end
function _UPVALUE2_()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "crescentdecree_recharge"
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001710_Read:defineValue("crescentdecree_recharge", function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001710_Read.getRechargeCfg()
	return activity_9001710_Read.crescentdecree_recharge[1]
end
function _UPVALUE2_()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "crescentdecree_buff"
;(function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001710_Read:defineValue("crescentdecree_buff", function()
	local config = require_data("crescentdecree_reward", true, true).data
	local _ENV, ret = "crescentdecree_reward", "crescentdecree_reward"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret, v)
	end
	return ret
end)
activity_9001710_Read:defineValue("crescentdecree_buffMap", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001710_Read.crescentdecree_buff) do
		if not ret[v.buildType] then
			ret[v.buildType], _ENV = nil, nil
		end
		v.buffID = v.buff[1]
		v.buffVal = v.buff[2]
		table.insert(ret[v.buildType], v)
	end
	return ret
end)
function activity_9001710_Read.getBuffCfg(buildType)
	return buildType and activity_9001710_Read.crescentdecree_buffMap[buildType] or activity_9001710_Read.crescentdecree_buff
end
return activity_9001710_Read
