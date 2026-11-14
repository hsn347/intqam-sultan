local activity_9001651_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "weapon_random_reward"
;(nil)[2] = true
activity_9001651_Read:defineValue("weapon_random_reward", nil)
function activity_9001651_Read.getSpecialReward(classType, times)
	local _ENV, cfg
	for k, v in ipairs(activity_9001651_Read.weapon_random_reward) do
		if v.sign == classType and times >= v.randomStage[1] then
			cfg.id = v.specialReward[1]
			cfg.count = v.specialReward[2]
		end
	end
	return cfg
end
function activity_9001651_Read.getRandomReward(classType, times)
	local _ENV, cfg
	for k, v in ipairs(activity_9001651_Read.weapon_random_reward) do
		if v.sign == classType and times >= v.randomStage[1] then
			cfg = v.randomReward
		end
	end
	return cfg
end
function activity_9001651_Read.getCostItem(classType, times)
	local costItem = 513801
	for k, v in ipairs(activity_9001651_Read.weapon_random_reward) do
		if v.sign == classType and times >= v.randomStage[1] then
			costItem = v.costItem
		end
	end
	return costItem
end
_UPVALUE2_ = nil
;(nil)[1] = "weapon_accumulate_reward"
;(nil)[2] = true
activity_9001651_Read:defineValue("weapon_accumulate_reward", nil)
function activity_9001651_Read.getStageConfig(classType)
	local _ENV, cfg
	local index = 1
	for k, v in ipairs(activity_9001651_Read.weapon_accumulate_reward) do
		if v.sign == classType then
			v.index = index
			table.insert(cfg, v)
			index = index + 1
		end
	end
	return cfg
end
activity_9001651_Read:defineValue("weapon_activity_task", function()
	local config = require_data("weapon_activity_task", true, true).data
	local _ENV, ret = "weapon_activity_task", "weapon_activity_task"
	for _, v in ipairs(config) do
		ret[v.sign] = v.taskId
	end
	return ret
end)
function activity_9001651_Read.getTaslConfig(classType)
	return activity_9001651_Read.weapon_activity_task[classType]
end
return activity_9001651_Read
