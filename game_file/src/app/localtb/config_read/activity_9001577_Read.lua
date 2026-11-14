local activity_9001577_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ice_competition_reward"
;(nil)[2] = true
activity_9001577_Read:defineValue("ice_competition_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "ice_competition_score"
;(nil)[2] = true
activity_9001577_Read:defineValue("ice_competition_score", nil)
_UPVALUE2_ = nil
;(nil)[1] = "ice_competition"
;(nil)[2] = true
activity_9001577_Read:defineValue("ice_competition", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_competition_language"
;(nil)[2] = false
activity_9001577_Read:defineValue("nebula_competition_language", nil)
local createData = function(name)
	local _ENV, task_list
	for i, v in ipairs(activity_9001577_Read.ice_competition_score) do
		if not task_list[v.activity] then
			task_list[v.activity], _ENV = nil, nil
		end
		table.insert(task_list[v.activity], v)
	end
	activity_9001577_Read.task_list = task_list
	local _ENV, score_reward = ipairs(activity_9001577_Read.ice_competition_score)
	local _ENV, rank_reward = ipairs(activity_9001577_Read.ice_competition_score)
	local _ENV, camp_score_reward = ipairs(activity_9001577_Read.ice_competition_score)
	for i, v in ipairs(activity_9001577_Read.ice_competition_reward) do
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
	activity_9001577_Read.score_reward = score_reward
	activity_9001577_Read.rank_reward = rank_reward
	activity_9001577_Read.camp_score_reward = camp_score_reward
	local _ENV, task_language = ipairs(activity_9001577_Read.ice_competition_reward)
	for i, v in ipairs(activity_9001577_Read.nebula_competition_language) do
		if not task_language[v.activity] then
			task_language[v.activity], _ENV = v, v
		end
		task_language[v.activity][v.activityType] = v
	end
	activity_9001577_Read.task_language = task_language
	return activity_9001577_Read[name]
end
activity_9001577_Read:defineValue("score_reward", createData)
activity_9001577_Read:defineValue("rank_reward", createData)
activity_9001577_Read:defineValue("task_list", createData)
activity_9001577_Read:defineValue("task_language", createData)
activity_9001577_Read:defineValue("camp_score_reward", createData)
function activity_9001577_Read.getGroupCfg(groupId)
	return activity_9001577_Read.ice_competition[groupId]
end
function activity_9001577_Read.getStageName(groupId, stage)
	local groupCfg = activity_9001577_Read.getGroupCfg(groupId)
	return groupCfg.languageID and groupCfg.languageID[stage]
end
function activity_9001577_Read.getScoreRewardList(rewardGroup)
	return activity_9001577_Read.score_reward[rewardGroup]
end
function activity_9001577_Read.getRankRewardList(rewardGroup)
	return activity_9001577_Read.rank_reward[rewardGroup]
end
function activity_9001577_Read.getTaskList(taskType)
	if not activity_9001577_Read.task_list[taskType] then
		activity_9001577_Read = activity_9001577_Read.task_list[taskType]
	end
	return activity_9001577_Read.task_list[taskType]
end
function activity_9001577_Read.getTaskLanguage(activityType, activitySubType)
	local cfg = activity_9001577_Read.task_language[activityType]
	if cfg[-1] then
		return cfg[-1]
	end
	return cfg[activitySubType]
end
function activity_9001577_Read.getTaskLanguageByID(lanID)
	return activity_9001577_Read.nebula_competition_language[lanID]
end
function activity_9001577_Read.getCampScore()
	return activity_9001577_Read.camp_score_reward
end
return activity_9001577_Read
