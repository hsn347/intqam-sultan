local nebulaKingRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebulaking_reward"
;(nil)[2] = true
nebulaKingRead:defineValue("nebulaking_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebulaking_activity"
;(nil)[2] = true
nebulaKingRead:defineValue("nebulaking_activity", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebulaking_activitygroup"
;(nil)[2] = true
nebulaKingRead:defineValue("nebulaking_activitygroup", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebulaking_language"
;(nil)[2] = false
nebulaKingRead:defineValue("nebulaking_language", nil)
local createData = function(name)
	local _ENV, task_list
	for i, v in ipairs(nebulaKingRead.nebulaking_activity) do
		if not task_list[v.activity] then
			task_list[v.activity], _ENV = nil, nil
		end
		table.insert(task_list[v.activity], v)
	end
	nebulaKingRead.task_list = task_list
	local _ENV, score_reward = ipairs(nebulaKingRead.nebulaking_activity)
	local _ENV, rank_reward = ipairs(nebulaKingRead.nebulaking_activity)
	for i, v in ipairs(nebulaKingRead.nebulaking_reward) do
		if v.rewardType == 1 then
			if not score_reward[v.rewardGroup] then
				score_reward[v.rewardGroup], _ENV = nil, nil
			end
			table.insert(score_reward[v.rewardGroup], v)
		else
			if not rank_reward[v.rewardGroup] then
				rank_reward[v.rewardGroup], _ENV = score_reward[v.rewardGroup], score_reward[v.rewardGroup]
			end
			table.insert(rank_reward[v.rewardGroup], v)
		end
	end
	nebulaKingRead.score_reward = score_reward
	nebulaKingRead.rank_reward = rank_reward
	local _ENV, task_language = ipairs(nebulaKingRead.nebulaking_reward)
	for i, v in ipairs(nebulaKingRead.nebulaking_language) do
		if not task_language[v.activity] then
			task_language[v.activity], _ENV = v, v
		end
		task_language[v.activity][v.activityType] = v
	end
	nebulaKingRead.task_language = task_language
	return nebulaKingRead[name]
end
nebulaKingRead:defineValue("score_reward", createData)
nebulaKingRead:defineValue("rank_reward", createData)
nebulaKingRead:defineValue("task_list", createData)
nebulaKingRead:defineValue("task_language", createData)
function nebulaKingRead.getGroupCfg(groupId)
	return nebulaKingRead.nebulaking_activitygroup[groupId]
end
function nebulaKingRead.getStageName(groupId, stage)
	local groupCfg = nebulaKingRead.getGroupCfg(groupId)
	return groupCfg.languageID and groupCfg.languageID[stage]
end
function nebulaKingRead.getScoreRewardList(rewardGroup)
	return nebulaKingRead.score_reward[rewardGroup]
end
function nebulaKingRead.getRankRewardList(rewardGroup)
	return nebulaKingRead.rank_reward[rewardGroup]
end
function nebulaKingRead.getTaskList(taskType)
	return nebulaKingRead.task_list[taskType]
end
function nebulaKingRead.getTaskLanguage(activityType, activitySubType)
	local cfg = nebulaKingRead.task_language[activityType]
	if cfg[-1] then
		return cfg[-1]
	end
	return cfg[activitySubType]
end
function nebulaKingRead.getTaskLanguageByID(lanID)
	return nebulaKingRead.nebulaking_language[lanID]
end
return nebulaKingRead
