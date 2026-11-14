local activity_9001703_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "balloon_hunter_monster"
;(nil)[2] = true
activity_9001703_Read:defineValue("balloon_hunter_monster", nil)
function activity_9001703_Read.getMonsterCfg(index)
	return activity_9001703_Read.balloon_hunter_monster[index]
end
activity_9001703_Read:defineValue("balloon_hunter_monster_order", function()
	local config = require_data("balloon_hunter_monster_order", false, true).data
	local _ENV, ret = "balloon_hunter_monster_order", "balloon_hunter_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001703_Read.getMonsterOrderCfg(time)
	local index = 1
	local interval = 1
	for _, v in ipairs(activity_9001703_Read.balloon_hunter_monster_order) do
		if time >= v.time[1] and time <= v.time[2] then
			index = v.index
			interval = v.interval
		end
	end
	return index, interval
end
function activity_9001703_Read.getRandomMonsterCfg(time)
	local orderIndex, orderInterval = activity_9001703_Read.getMonsterOrderCfg(time)
	local total = 0
	local cfg = activity_9001703_Read.balloon_hunter_monster_order[orderIndex]
	for _, v in ipairs(cfg.weightCfg) do
		total = total + v.weight
	end
	local random = math.random(total)
	local index = 1
	local tmpW = 0
	for i, v in ipairs(cfg.weightCfg) do
		if random <= v.weight + tmpW then
			index = v.id
			break
		end
		tmpW = tmpW + v.weight
	end
	return activity_9001703_Read.balloon_hunter_monster[index]
end
function _UPVALUE2_()
	local config = require_data("balloon_hunter_monster_order", false, true).data
	local _ENV, ret = "balloon_hunter_monster_order", "balloon_hunter_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("balloon_hunter_monster_order", false, true).data
	local _ENV, ret = "balloon_hunter_monster_order", "balloon_hunter_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "balloon_hunter_upgrade"
;(function()
	local config = require_data("balloon_hunter_monster_order", false, true).data
	local _ENV, ret = "balloon_hunter_monster_order", "balloon_hunter_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001703_Read:defineValue("balloon_hunter_upgrade", function()
	local config = require_data("balloon_hunter_monster_order", false, true).data
	local _ENV, ret = "balloon_hunter_monster_order", "balloon_hunter_monster_order"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "weight"
		v.weightCfg = serviceFunctions.tableFormat(v.weight, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001703_Read.getNeedExp(lv)
	local lv = math.min(math.max(lv, 1), #activity_9001703_Read.balloon_hunter_upgrade)
	return activity_9001703_Read.balloon_hunter_upgrade[lv].expNeed
end
activity_9001703_Read:defineValue("balloon_hunter_task", function()
	local config = require_data("balloon_hunter_task", true, true).data
	local _ENV, ret = "balloon_hunter_task", "balloon_hunter_task"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.taskReward = serviceFunctions.tableFormat(v.taskReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001703_Read.getTaskCfg(classType)
	return activity_9001703_Read.balloon_hunter_task[classType]
end
activity_9001703_Read:defineValue("balloon_hunter_stage_reward", function()
	local config = require_data("balloon_hunter_stage_reward", true, true).data
	local _ENV, ret = "balloon_hunter_stage_reward", "balloon_hunter_stage_reward"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.stageReward = serviceFunctions.tableFormat(v.stageReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001703_Read.getStageCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY)
	return activity_9001703_Read.balloon_hunter_stage_reward[classType]
end
activity_9001703_Read:defineValue("balloon_hunter_battlepass", function()
	local config = require_data("balloon_hunter_battlepass", true, true).data
	local _ENV, ret = "balloon_hunter_battlepass", "balloon_hunter_battlepass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001703_Read.getBattlepassCfg()
	return activity_9001703_Read.balloon_hunter_battlepass
end
function activity_9001703_Read.getAdvRewards()
	local _ENV, ret
	for k, v in ipairs(activity_9001703_Read.balloon_hunter_battlepass) do
		for i, reward in ipairs(v.advanceReward) do
			table.insert(ret, reward)
		end
	end
	return SoraDMergeRewards(ret)
end
function _UPVALUE2_()
	local config = require_data("balloon_hunter_battlepass", true, true).data
	local _ENV, ret = "balloon_hunter_battlepass", "balloon_hunter_battlepass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("balloon_hunter_battlepass", true, true).data
	local _ENV, ret = "balloon_hunter_battlepass", "balloon_hunter_battlepass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "balloon_hunter_recharge"
;(function()
	local config = require_data("balloon_hunter_battlepass", true, true).data
	local _ENV, ret = "balloon_hunter_battlepass", "balloon_hunter_battlepass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
activity_9001703_Read:defineValue("balloon_hunter_recharge", function()
	local config = require_data("balloon_hunter_battlepass", true, true).data
	local _ENV, ret = "balloon_hunter_battlepass", "balloon_hunter_battlepass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		table.insert(ret, v)
	end
	return ret
end)
function activity_9001703_Read.getRechargeCfg()
	return activity_9001703_Read.balloon_hunter_recharge[1]
end
activity_9001703_Read:defineValue("balloon_hunter_rank", function()
	local config = require_data("balloon_hunter_rank", true, true).data
	local _ENV, ret = "balloon_hunter_rank", "balloon_hunter_rank"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rankReward = serviceFunctions.tableFormat(v.rankReward, nil)
		table.insert(ret[v.classType], v)
	end
	return ret
end)
function activity_9001703_Read.getRankCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY)
	return activity_9001703_Read.balloon_hunter_rank[classType]
end
activity_9001703_Read:defineValue("balloon_hunter_basicskill", function()
	local config = require_data("balloon_hunter_basicskill", true, true).data
	local _ENV, ret = "balloon_hunter_basicskill", "balloon_hunter_basicskill"
	for k, v in ipairs(config) do
		if not ret[v.basicId] then
			ret[v.basicId], _ENV = nil, nil
		end
		table.insert(ret[v.basicId], v)
	end
	return ret
end)
function activity_9001703_Read.getBasicSkillCfg()
	return activity_9001703_Read.balloon_hunter_basicskill
end
function activity_9001703_Read.getBasicSkillMaxLv(basicId)
	return #activity_9001703_Read.balloon_hunter_basicskill[basicId]
end
function activity_9001703_Read.getBasicSkillData(basicId, lv)
	local lv = math.min(lv, activity_9001703_Read.getBasicSkillMaxLv(basicId))
	return activity_9001703_Read.balloon_hunter_basicskill[basicId][lv]
end
function activity_9001703_Read.getBasicSkillNamePng(basicId)
	local skillName = i18n("balloon_hunter_008")
	local png = "frame_9001703_gongjili.png"
	if basicId == 1 then
		skillName = i18n("balloon_hunter_008")
		png = "frame_9001703_gongjili.png"
	elseif basicId == 2 then
		skillName = i18n("balloon_hunter_009")
		png = "frame_9001703_gongsu.png"
	elseif basicId == 3 then
		skillName = i18n("balloon_hunter_010")
		png = "frame_9001703_jifen.png"
	end
	return skillName, png
end
activity_9001703_Read:defineValue("balloon_hunter_skill", function()
	local config = require_data("balloon_hunter_skill", true, true).data
	local _ENV, ret = "balloon_hunter_skill", "balloon_hunter_skill"
	for k, v in ipairs(config) do
		if not ret[v.skillId] then
			ret[v.skillId], _ENV = nil, nil
		end
		table.insert(ret[v.skillId], v)
	end
	return ret
end)
function activity_9001703_Read.getShowSkill()
	_UPVALUE3_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	return nil
end
function activity_9001703_Read.getShowSkillCfg()
	return activity_9001703_Read.balloon_hunter_skill
end
function activity_9001703_Read.getSkillData(skillId, skillLv)
	return activity_9001703_Read.balloon_hunter_skill[skillId][skillLv]
end
function _UPVALUE1_()
	local config = require_data("balloon_hunter_skill", true, true).data
	local _ENV, ret = "balloon_hunter_skill", "balloon_hunter_skill"
	for k, v in ipairs(config) do
		if not ret[v.skillId] then
			ret[v.skillId], _ENV = nil, nil
		end
		table.insert(ret[v.skillId], v)
	end
	return ret
end
;(function()
	local config = require_data("balloon_hunter_skill", true, true).data
	local _ENV, ret = "balloon_hunter_skill", "balloon_hunter_skill"
	for k, v in ipairs(config) do
		if not ret[v.skillId] then
			ret[v.skillId], _ENV = nil, nil
		end
		table.insert(ret[v.skillId], v)
	end
	return ret
end)[1] = "balloon_hunter_skill_show"
activity_9001703_Read:defineValue("balloon_hunter_skill_show", function()
	local config = require_data("balloon_hunter_skill", true, true).data
	local _ENV, ret = "balloon_hunter_skill", "balloon_hunter_skill"
	for k, v in ipairs(config) do
		if not ret[v.skillId] then
			ret[v.skillId], _ENV = nil, nil
		end
		table.insert(ret[v.skillId], v)
	end
	return ret
end)
function activity_9001703_Read.getSkillShowCfg()
	return activity_9001703_Read.balloon_hunter_skill_show
end
function activity_9001703_Read.getSkillShow(skillId)
	return activity_9001703_Read.balloon_hunter_skill_show[skillId]
end
return activity_9001703_Read
