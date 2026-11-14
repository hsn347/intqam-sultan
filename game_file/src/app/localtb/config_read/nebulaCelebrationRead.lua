local nebulaCelebrationRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_celebration_task"
;(nil)[2] = true
nebulaCelebrationRead:defineValue("nebula_celebration_task", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_celebration_reward"
;(nil)[2] = true
nebulaCelebrationRead:defineValue("nebula_celebration_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_celebration_recharge"
;(nil)[2] = true
nebulaCelebrationRead:defineValue("nebula_celebration_recharge", nil)
local createData = function(name)
	local _ENV, task_list
	local _ENV, daily_task_list
	for i, v in ipairs(nebulaCelebrationRead.nebula_celebration_task) do
		if v.type == 1 then
			if not daily_task_list[v.group] then
				daily_task_list[v.group], _ENV = nil, nil
			end
			table.insert(daily_task_list[v.group], v.taskID)
		else
			if not task_list[v.group] then
				task_list[v.group], _ENV = daily_task_list[v.group], daily_task_list[v.group]
			end
			table.insert(task_list[v.group], v.taskID)
		end
	end
	nebulaCelebrationRead.task_list = task_list
	nebulaCelebrationRead.daily_task_list = daily_task_list
	local _ENV, reward = ipairs(nebulaCelebrationRead.nebula_celebration_task)
	for i, v in ipairs(nebulaCelebrationRead.nebula_celebration_reward) do
		if not reward[v.group] then
			reward[v.group], _ENV = v.taskID, v.taskID
		end
		table.insert(reward[v.group], v)
	end
	nebulaCelebrationRead.reward = reward
	return nebulaCelebrationRead[name]
end
nebulaCelebrationRead:defineValue("task_list", createData)
nebulaCelebrationRead:defineValue("daily_task_list", createData)
nebulaCelebrationRead:defineValue("reward", createData)
function nebulaCelebrationRead.getTaskList(groupId)
	return nebulaCelebrationRead.task_list[groupId]
end
function nebulaCelebrationRead.getDailyTaskList(groupId)
	return nebulaCelebrationRead.daily_task_list[groupId][1]
end
function nebulaCelebrationRead.getRewardList(groupId)
	return nebulaCelebrationRead.reward[groupId]
end
function nebulaCelebrationRead.getLevelReward(lv, groupId)
	local maxLv = #nebulaCelebrationRead.reward[groupId]
	if lv >= maxLv then
		lv = maxLv
	end
	return nebulaCelebrationRead.reward[groupId][lv]
end
function nebulaCelebrationRead.getRecharge()
	return nebulaCelebrationRead.nebula_celebration_recharge[1]
end
function nebulaCelebrationRead.getLvByExp(group, exp)
	local list = nebulaCelebrationRead.reward[group]
	local lv = 0
	local lvExp = 0
	local expNext = 0
	for index, value in ipairs(list) do
		expNext = expNext + value.exp
		if exp < expNext then
			break
		end
		lv = value.level
		lvExp = expNext
	end
	exp = exp - lvExp
	if lv >= #list then
		local lastExp = list[#list].exp
		local lvAdd = math.floor(exp / lastExp)
		local leftExp = exp % lastExp
		return lv + lvAdd, leftExp, lastExp
	else
		return lv, exp, expNext - lvExp
	end
end
function nebulaCelebrationRead.getShowRewad(group, index)
	local list = nebulaCelebrationRead.reward[group]
	local cfg, cfg1
	for i = #list, 1, -1 do
		cfg = list[i]
		cfg1 = cfg1 or cfg
		if index > cfg.level then
			break
		end
		if cfg.show and cfg.show > 0 then
			cfg1 = cfg
		end
	end
	print("==1====", index, cfg1.level)
	return cfg1
end
return nebulaCelebrationRead
