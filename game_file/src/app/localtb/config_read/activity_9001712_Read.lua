local Activity_9001712_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass")[1] = i18n("anniversary_ten_daily_16")
;("aAReadClass")[2] = i18n("anniversary_ten_daily_17")
;("aAReadClass")[3] = i18n("anniversary_ten_daily_18")
;("aAReadClass")[4] = i18n("anniversary_ten_daily_19")
local ("aAReadClass")[5], CardIndex2Name = i18n("anniversary_ten_daily_20"), "aAReadClass"
Activity_9001712_Read:defineValue("anniversary_daily_reward", function()
	local _ENV, rewards
	local _dailyRewards = require_data("anniversary_daily_reward", true, true).data
	for i, v in ipairs(_dailyRewards) do
		if not rewards[v.classType] then
			rewards[v.classType], _ENV = nil, nil
		end
		table.insert(rewards[v.classType], v)
	end
	for k, v in pairs(rewards) do
		table.sort(v, function(a, b)
			return a.day < b.day
		end)
	end
	Activity_9001712_Read.dailyRewards = rewards
	return Activity_9001712_Read.dailyRewards
end)
Activity_9001712_Read:defineValue("anniversary_stage_reward", function()
	local _ENV, rewards
	local _stageRewards = require_data("anniversary_stage_reward", true, true).data
	for i, v in ipairs(_stageRewards) do
		if not rewards[v.classType] then
			rewards[v.classType], _ENV = nil, nil
		end
		table.insert(rewards[v.classType], v)
	end
	for k, v in pairs(rewards) do
		table.sort(v, function(a, b)
			return a.stageIndex < b.stageIndex
		end)
	end
	Activity_9001712_Read.stageRewards = rewards
	return Activity_9001712_Read.stageRewards
end)
function Activity_9001712_Read.getDailyRewards(classType)
	if Activity_9001712_Read.dailyRewards then
		if not Activity_9001712_Read.dailyRewards[classType] then
			Activity_9001712_Read = Activity_9001712_Read.dailyRewards[classType]
		end
		return Activity_9001712_Read.dailyRewards[classType]
	end
	if not Activity_9001712_Read.anniversary_daily_reward[classType] then
		Activity_9001712_Read = Activity_9001712_Read.anniversary_daily_reward[classType]
	end
	return Activity_9001712_Read.anniversary_daily_reward[classType]
end
function Activity_9001712_Read.getStageRewards(classType)
	if Activity_9001712_Read.stageRewards then
		if not Activity_9001712_Read.stageRewards[classType] then
			Activity_9001712_Read = Activity_9001712_Read.stageRewards[classType]
		end
		return Activity_9001712_Read.stageRewards[classType]
	end
	if not Activity_9001712_Read.anniversary_stage_reward[classType] then
		Activity_9001712_Read = Activity_9001712_Read.anniversary_stage_reward[classType]
	end
	return Activity_9001712_Read.anniversary_stage_reward[classType]
end
function Activity_9001712_Read.getCardName(index)
	return CardIndex2Name[index] or ""
end
return Activity_9001712_Read
