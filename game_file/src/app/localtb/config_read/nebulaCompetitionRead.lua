local nebulaCompetitionRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_competition_reward"
;(nil)[2] = true
nebulaCompetitionRead:defineValue("nebula_competition_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_competition_activity"
;(nil)[2] = true
nebulaCompetitionRead:defineValue("nebula_competition_activity", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_competition_group"
;(nil)[2] = true
nebulaCompetitionRead:defineValue("nebula_competition_group", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_competition_language"
;(nil)[2] = false
nebulaCompetitionRead:defineValue("nebula_competition_language", nil)
local createData = function(name)
	local _ENV, task_list
	for i, v in ipairs(nebulaCompetitionRead.nebula_competition_activity) do
		if not task_list[v.activity] then
			task_list[v.activity], _ENV = nil, nil
		end
		table.insert(task_list[v.activity], v)
	end
	nebulaCompetitionRead.task_list = task_list
	local _ENV, score_reward = ipairs(nebulaCompetitionRead.nebula_competition_activity)
	local _ENV, rank_reward = ipairs(nebulaCompetitionRead.nebula_competition_activity)
	local _ENV, camp_score_reward = ipairs(nebulaCompetitionRead.nebula_competition_activity)
	for i, v in ipairs(nebulaCompetitionRead.nebula_competition_reward) do
		if v.rewardType == 1 then
			if not score_reward[v.rewardGroup] then
				score_reward[v.rewardGroup], _ENV = nil, nil
			end
			table.insert(score_reward[v.rewardGroup], v)
		elseif v.rewardType == 4 then
			if not camp_score_reward[v.rewardGroup] then
				camp_score_reward[v.rewardGroup], _ENV = score_reward[v.rewardGroup], score_reward[v.rewardGroup]
			end
			camp_score_reward[v.rewardGroup][v.task[1]] = v
		else
			if not rank_reward[v.rewardGroup] then
				rank_reward[v.rewardGroup], _ENV = v.task[1], v.task[1]
			end
			table.insert(rank_reward[v.rewardGroup], v)
		end
	end
	nebulaCompetitionRead.score_reward = score_reward
	nebulaCompetitionRead.rank_reward = rank_reward
	nebulaCompetitionRead.camp_score_reward = camp_score_reward
	local _ENV, task_language = ipairs(nebulaCompetitionRead.nebula_competition_reward)
	for i, v in ipairs(nebulaCompetitionRead.nebula_competition_language) do
		if not task_language[v.activity] then
			task_language[v.activity], _ENV = v, v
		end
		task_language[v.activity][v.activityType] = v
	end
	nebulaCompetitionRead.task_language = task_language
	return nebulaCompetitionRead[name]
end
nebulaCompetitionRead:defineValue("score_reward", createData)
nebulaCompetitionRead:defineValue("rank_reward", createData)
nebulaCompetitionRead:defineValue("task_list", createData)
nebulaCompetitionRead:defineValue("task_language", createData)
nebulaCompetitionRead:defineValue("camp_score_reward", createData)
function nebulaCompetitionRead.getGroupCfg(groupId)
	return nebulaCompetitionRead.nebula_competition_group[groupId]
end
function nebulaCompetitionRead.getStageName(groupId, stage)
	local groupCfg = nebulaCompetitionRead.getGroupCfg(groupId)
	return groupCfg.languageID and groupCfg.languageID[stage]
end
function nebulaCompetitionRead.getScoreRewardList(rewardGroup)
	return nebulaCompetitionRead.score_reward[rewardGroup]
end
function nebulaCompetitionRead.getRankRewardList(rewardGroup)
	return nebulaCompetitionRead.rank_reward[rewardGroup]
end
function nebulaCompetitionRead.getTaskList(taskType)
	return nebulaCompetitionRead.task_list[taskType]
end
function nebulaCompetitionRead.getTaskLanguage(activityType, activitySubType)
	local cfg = nebulaCompetitionRead.task_language[activityType]
	if cfg[-1] then
		return cfg[-1]
	end
	return cfg[activitySubType]
end
function nebulaCompetitionRead.getTaskLanguageByID(lanID)
	return nebulaCompetitionRead.nebula_competition_language[lanID]
end
function nebulaCompetitionRead.getCampScore()
	return nebulaCompetitionRead.camp_score_reward
end
return nebulaCompetitionRead
