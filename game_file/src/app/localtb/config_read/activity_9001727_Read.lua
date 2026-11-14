local activity_9001727_Read = include("aAReadClass").new()
local activityID = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
activity_9001727_Read:defineValue("albarqdecree_reward", function()
	local config = require_data("albarqdecree_reward", true, true).data
	local _ENV, ret = "albarqdecree_reward", "albarqdecree_reward"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		if not ret[v.groupID][v.classType] then
			ret[v.groupID][v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.goldAward1 = serviceFunctions.tableFormat(v.goldAward1, nil)
		table.insert(ret[v.groupID][v.classType], v)
	end
	return ret
end)
function activity_9001727_Read.getReward()
	local classType = SoraDGetCtrl("activity_9001727_Ctrl"):getGroupType()
	local groupType = SoraDGetActivityClassType(activityID)
	return activity_9001727_Read.albarqdecree_reward[groupType][classType]
end
function activity_9001727_Read.getAllReward()
	local activity_9001727_Read, ret
	local reward = activity_9001727_Read.getReward()
	for _, v in ipairs(reward) do
		for _, m in ipairs(v.bronzeAward) do
			table.insert(ret, m)
		end
		for _, n in ipairs(v.goldAward1) do
			table.insert(ret, n)
		end
	end
	return SoraDMergeRewards(ret)
end
function activity_9001727_Read.getLvByExp(exp)
	local lv = 0
	local showExp = 0
	local curExp = 0
	local needExp = 0
	local cfg = activity_9001727_Read.getReward()
	if cfg then
		needExp = cfg[1].exp
		for k, v in ipairs(cfg) do
			curExp = curExp + v.exp
			if exp >= curExp then
				lv = v.lv
				showExp = exp - curExp
			else
				needExp = v.exp
				break
			end
		end
	end
	return lv, showExp, needExp
end
activity_9001727_Read:defineValue("albarqdecree_quest", function()
	local config = require_data("albarqdecree_quest", true, true).data
	local _ENV, ret = "albarqdecree_quest", "albarqdecree_quest"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		if not ret[v.groupID][v.classType] then
			ret[v.groupID][v.classType], _ENV = nil, nil
		end
		table.insert(ret[v.groupID][v.classType], v)
	end
	return ret
end)
function activity_9001727_Read.getQuest()
	local groupType = SoraDGetActivityClassType(activityID)
	local classType = SoraDGetCtrl("activity_9001727_Ctrl"):getGroupType()
	return activity_9001727_Read.albarqdecree_quest[groupType][classType]
end
activity_9001727_Read:defineValue("albarqdecree_recharge", function()
	local config = require_data("albarqdecree_recharge", true, true).data
	local _ENV, ret = "albarqdecree_recharge", "albarqdecree_recharge"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.Rewards = serviceFunctions.tableFormat(v.Rewards, nil)
		ret[v.groupID][v.classType] = v
	end
	return ret
end)
function activity_9001727_Read.getRecharge()
	local groupType = SoraDGetActivityClassType(activityID)
	local classType = SoraDGetCtrl("activity_9001727_Ctrl"):getGroupType()
	return activity_9001727_Read.albarqdecree_recharge[groupType][classType]
end
activity_9001727_Read:defineValue("albarqdecree_effect_show", function()
	local config = require_data("albarqdecree_effect_show", false, true).data
	local _ENV, ret = "albarqdecree_effect_show", "albarqdecree_effect_show"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		if not ret[v.groupID][v.classType] then
			ret[v.groupID][v.classType], _ENV = nil, nil
		end
		if not ret[v.groupID][v.classType][v.RechargeID] then
			ret[v.groupID][v.classType][v.RechargeID], _ENV = nil, nil
		end
		table.insert(ret[v.groupID][v.classType][v.RechargeID], v)
	end
	return ret
end)
function activity_9001727_Read.getEffectShow(rid)
	local groupType = SoraDGetActivityClassType(activityID)
	local classType = SoraDGetCtrl("activity_9001727_Ctrl"):getGroupType()
	return activity_9001727_Read.albarqdecree_effect_show[groupType][classType][rid]
end
activity_9001727_Read:defineValue("albarqdecree", function()
	local config = require_data("albarqdecree", true, true).data
	local _ENV, ret = "albarqdecree", "albarqdecree"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		ret[v.groupID][v.classType] = v.albarqStage
	end
	return ret
end)
activity_9001727_Read:defineValue("albarqdecree_effect", function()
	local config = require_data("albarqdecree_effect", true, true).data
	local _ENV, ret = "albarqdecree_effect", "albarqdecree_effect"
	for k, v in ipairs(config) do
		if not ret[v.groupID] then
			ret[v.groupID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "buffValue"
		v.PrivilegeEffect = serviceFunctions.tableFormat(v.PrivilegeEffect, nil)
		v.albarqStage = activity_9001727_Read.albarqdecree[v.groupID][v.classType]
		ret[v.groupID][v.classType] = v
	end
	return ret
end)
function activity_9001727_Read.getBuffCfg()
	local groupType = SoraDGetActivityClassType(activityID)
	return activity_9001727_Read.albarqdecree_effect[groupType]
end
return activity_9001727_Read
