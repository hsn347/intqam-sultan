local activity_9001729_Read = include("aAReadClass").new()
activity_9001729_Read:defineValue("ramadan_treasure_hunt_map", function()
	local _ENV, ret
	local config = require_data("ramadan_treasure_hunt_map", true, true).data
	for k, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
activity_9001729_Read:defineValue("ramadan_treasure_levelup", function()
	local _ENV, ret
	local config = require_data("ramadan_treasure_levelup", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		if ret[v.classType][v.id] == nil then
			_ENV = nil
			ret[v.classType][v.id], (nil).totalExp = nil, 0
		end
		ret[v.classType][v.id].totalExp = ret[v.classType][v.id].totalExp + (v.exp or 0)
		v.realExp = ret[v.classType][v.id].totalExp
		table.insert(ret[v.classType][v.id], v)
	end
	for k, v in pairs(ret) do
		for _, vv in pairs(v) do
			vv.totalExp = nil
			table.sort(vv, function(a, b)
				return a.lv < b.lv
			end)
		end
	end
	return ret
end)
activity_9001729_Read:defineValue("ramadan_treasure_hunt_battlepas", function()
	local _ENV, ret
	local config = require_data("ramadan_treasure_hunt_battlepas", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
activity_9001729_Read:defineValue("ramadan_hunt_stage_reward", function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)[1] = "ramadan_treasure_hunt_recharge"
;(function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)[2] = true
activity_9001729_Read:defineValue("ramadan_treasure_hunt_recharge", function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)[1] = "ramadan_treasure_hunt_event"
;(function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)[2] = true
activity_9001729_Read:defineValue("ramadan_treasure_hunt_event", function()
	local _ENV, ret
	local config = require_data("ramadan_hunt_stage_reward", true, true).data
	for _, v in pairs(config) do
		if not ret[v.classType] then
			_ENV = ret[v.classType]
		end
		ret[v.classType] = ret[v.classType]
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001729_Read.getMap(classType)
	if not activity_9001729_Read.ramadan_treasure_hunt_map[classType] then
		activity_9001729_Read = activity_9001729_Read.ramadan_treasure_hunt_map[classType]
	end
	return activity_9001729_Read.ramadan_treasure_hunt_map[classType]
end
function activity_9001729_Read.getMaxBattlePassLv(activityId)
	local classType = activity_9001729_Read.getClassType(activityId)
	if not activity_9001729_Read.ramadan_treasure_hunt_battlepas[classType] then
		local activity_9001729_Read, battlePassConfig = activity_9001729_Read.ramadan_treasure_hunt_battlepas[classType], activity_9001729_Read.ramadan_treasure_hunt_battlepas[classType]
	end
	return #battlePassConfig
end
function activity_9001729_Read:getRechargeName(rechargeID)
	for _, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_recharge) do
		if rechargeID == v.rechargeID then
			return i18n(v.rechargeName)
		end
	end
end
function activity_9001729_Read.getClassType(activityID)
	return SoraDGetActivityClassType(activityID)
end
function activity_9001729_Read.getRechargeCfg()
	return activity_9001729_Read.ramadan_treasure_hunt_recharge[1]
end
function activity_9001729_Read.getRewardList()
	local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
	local classType = activity_9001729_Ctrl:getClassType()
	return activity_9001729_Read.ramadan_treasure_hunt_battlepas[classType]
end
function activity_9001729_Read.getDailyPackages()
	local _ENV, ret
	for _, rechargeCfg in ipairs(activity_9001729_Read.ramadan_treasure_hunt_recharge) do
		if rechargeCfg.rechargeType == 2 then
			table.insert(ret, rechargeCfg)
		end
	end
	return ret
end
function activity_9001729_Read.getDailyReward()
	_ENV = nil
	if not CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM then
		_ENV = CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM
	end
	;(nil).id = CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM[1]
	if not CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM then
		_ENV = CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM
	end
	;(nil).count = CONST_ARRAY.RAMADAN_TREASURE_HUNT_FREE_ITEM[2]
	return nil
end
_ENV, activity_9001729_Read.getEventConfig = function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).NONE = 0
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).GOLD_DICE = 1
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).DOUBLE_DIECE = 2
_ENV, g9001729EventType, (function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).FREE_DICE = function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, 3
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).NONE = 0
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).START = 1
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).NORMAL = 2
_ENV, gCrescentTreasureBlockType, (function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).EVENT = function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, 3
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).OPTION = 1
;(function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).DOUBLE = 2
gCrescentTreasureEventType, (function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end).FREE = function(type)
	for i, v in ipairs(activity_9001729_Read.ramadan_treasure_hunt_event) do
		if type == v.type then
			return v
		end
	end
end, 3
function activity_9001729_Read.getMapData(activityID)
	return activity_9001729_Read.ramadan_treasure_hunt_map[activity_9001729_Read.getClassType(activityID)]
end
function activity_9001729_Read.getLv(gridId, exp, activityID)
	local classType = activity_9001729_Read.getClassType(activityID)
	if not activity_9001729_Read.ramadan_treasure_levelup[classType] then
		activity_9001729_Read = activity_9001729_Read.ramadan_treasure_levelup[classType]
	end
	if not activity_9001729_Read.ramadan_treasure_levelup[classType][gridId] then
		local activity_9001729_Read, levelConfig = activity_9001729_Read.ramadan_treasure_levelup[classType][gridId], activity_9001729_Read.ramadan_treasure_levelup[classType][gridId]
	end
	local lv = 0
	for i, v in ipairs(levelConfig) do
		if not v.exp or exp >= v.realExp then
			lv = v.lv
		else
			break
		end
	end
	return lv
end
function activity_9001729_Read.getLvData(gridId, lv, activityID)
	local classType = activity_9001729_Read.getClassType(activityID)
	if not activity_9001729_Read.ramadan_treasure_levelup[classType] then
		activity_9001729_Read = activity_9001729_Read.ramadan_treasure_levelup[classType]
	end
	if not activity_9001729_Read.ramadan_treasure_levelup[classType][gridId] then
		local activity_9001729_Read, levelConfig = activity_9001729_Read.ramadan_treasure_levelup[classType][gridId], activity_9001729_Read.ramadan_treasure_levelup[classType][gridId]
	end
	for i, v in ipairs(levelConfig) do
		if lv == v.lv then
			return v
		end
	end
	return nil
end
function activity_9001729_Read.getStageData(rewardID, activityID)
	local config = activity_9001729_Read.ramadan_hunt_stage_reward[activity_9001729_Read.getClassType(activityID)]
	for i, v in ipairs(config) do
		if rewardID == v.rewardID then
			return v
		end
	end
	return nil
end
return activity_9001729_Read
