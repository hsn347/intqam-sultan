local activity_9001716_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").OLD_SERVER = 1
local ("aAReadClass").NEW_SERVER, classType = 2, "aAReadClass"
activity_9001716_Read:defineValue("bubble_puzzle_task", function()
	local _ENV, tasks
	local bubblePuzzleTask = require_data("bubble_puzzle_task", true, true).data
	for i, v in ipairs(bubblePuzzleTask) do
		if not tasks[v.classType] then
			tasks[v.classType], _ENV = nil, nil
		end
		table.insert(tasks[v.classType], v)
	end
	for k, v in pairs(tasks) do
		table.sort(v, function(a, b)
			return a.sort < b.sort
		end)
	end
	activity_9001716_Read.tasks = tasks
	return activity_9001716_Read.tasks
end)
activity_9001716_Read:defineValue("bubble_puzzle_reward", function()
	local _ENV, rewards
	local bubblePuzzleReward = require_data("bubble_puzzle_reward", true, true).data
	for i, v in ipairs(bubblePuzzleReward) do
		if not rewards[v.classType] then
			rewards[v.classType], _ENV = nil, nil
		end
		table.insert(rewards[v.classType], v)
	end
	for k, v in pairs(rewards) do
		table.sort(v, function(a, b)
			return a.boxIndex < b.boxIndex
		end)
	end
	activity_9001716_Read.rewards = rewards
	return activity_9001716_Read.rewards
end)
activity_9001716_Read:defineValue("bubble_puzzle_cross_reward", function()
	local _ENV, matchcs
	local bubblePuzzleCross = require_data("bubble_puzzle_cross_reward", true, true).data
	for i, v in ipairs(bubblePuzzleCross) do
		matchcs[v.boxIndex] = v
	end
	activity_9001716_Read.matchs = matchcs
	return activity_9001716_Read.matchs
end)
function activity_9001716_Read.getTasks(classType)
	if activity_9001716_Read.tasks then
		if not activity_9001716_Read.tasks[classType] then
			activity_9001716_Read = activity_9001716_Read.tasks[classType]
		end
		return activity_9001716_Read.tasks[classType]
	end
	if not activity_9001716_Read.bubble_puzzle_task[classType] then
		activity_9001716_Read = activity_9001716_Read.bubble_puzzle_task[classType]
	end
	return activity_9001716_Read.bubble_puzzle_task[classType]
end
function activity_9001716_Read.getBubbleReward(classType, boxIndex)
	if activity_9001716_Read.rewards then
		if not activity_9001716_Read.rewards[classType] then
			activity_9001716_Read = activity_9001716_Read.rewards[classType]
		end
		return activity_9001716_Read.rewards[classType][boxIndex]
	end
	if not activity_9001716_Read.bubble_puzzle_reward[classType] then
		activity_9001716_Read = activity_9001716_Read.bubble_puzzle_reward[classType]
	end
	return activity_9001716_Read.bubble_puzzle_reward[classType][boxIndex]
end
function activity_9001716_Read.getBubbleRewards(classType)
	if activity_9001716_Read.rewards then
		if not activity_9001716_Read.rewards[classType] then
			activity_9001716_Read = activity_9001716_Read.rewards[classType]
		end
		return activity_9001716_Read.rewards[classType]
	end
	if not activity_9001716_Read.bubble_puzzle_reward[classType] then
		activity_9001716_Read = activity_9001716_Read.bubble_puzzle_reward[classType]
	end
	return activity_9001716_Read.bubble_puzzle_reward[classType]
end
function activity_9001716_Read.getFinalReward(classType)
	if not activity_9001716_Read.rewards[classType] and not activity_9001716_Read.bubble_puzzle_reward[classType] then
		local activity_9001716_Read, rewards = activity_9001716_Read.bubble_puzzle_reward[classType], activity_9001716_Read.bubble_puzzle_reward[classType]
	end
	for i, v in ipairs(rewards) do
		if v.rewardType == 2 then
			return v
		end
	end
	return nil
end
function activity_9001716_Read.getBubbleTasks(boxIndex)
	if activity_9001716_Read.matchs then
		if not activity_9001716_Read.matchs[boxIndex] then
			activity_9001716_Read = activity_9001716_Read.matchs[boxIndex]
		end
		if not activity_9001716_Read.matchs[boxIndex].taskType then
			activity_9001716_Read = activity_9001716_Read.matchs[boxIndex].taskType
		end
		return activity_9001716_Read.matchs[boxIndex].taskType
	end
	if not activity_9001716_Read.bubble_puzzle_cross_reward[boxIndex] then
		activity_9001716_Read = activity_9001716_Read.bubble_puzzle_cross_reward[boxIndex]
	end
	if not activity_9001716_Read.bubble_puzzle_cross_reward[boxIndex].taskType then
		activity_9001716_Read = activity_9001716_Read.bubble_puzzle_cross_reward[boxIndex].taskType
	end
	return activity_9001716_Read.bubble_puzzle_cross_reward[boxIndex].taskType
end
return activity_9001716_Read
