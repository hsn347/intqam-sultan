local smeltRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "smelt_equip_config"
	;(nil)[2] = true
	smeltRead:defineValue("equips", nil)
	_ENV = nil
	;(nil)[1] = "smelt_stage_config"
	;(nil)[2] = true
	smeltRead:defineValue("rewards", nil)
	_ENV = nil
	;(nil)[1] = "smelt_item_config"
	;(nil)[2] = true
	smeltRead:defineValue("items", nil)
	_ENV = nil
	;(nil)[1] = "smelt_treasure_refresh"
	;(nil)[2] = true
	smeltRead:defineValue("prices", nil)
	smeltRead = nil
	;(nil)[1] = "smelt_reward_show"
	smeltRead:defineValue("otherReawrds", nil)
	_ENV = nil
	;(nil)[1] = "smelt_task_config"
	;(nil)[2] = true
	smeltRead:defineValue("tasks", nil)
	local createData = function(name)
		smeltRead.maxRounds, smeltRead = nil, nil
		local smeltRead, showRewards
		local rewards = smeltRead.rewards
		for i, v in ipairs(rewards) do
			local round = v.round
			local group = v.group
			if not showRewards[group] then
				showRewards[group], smeltRead = showRewards[group], showRewards[group]
			end
			if not showRewards[group][round] then
				showRewards[group][round], smeltRead = nil, nil
			end
			if not smeltRead.maxRounds[group] or round > smeltRead.maxRounds[group] then
				smeltRead.maxRounds[group] = round
			end
			table.insert(showRewards[group][round], v)
		end
		smeltRead.showRewards = showRewards
		if name == "maxRounds" then
			return smeltRead.maxRounds
		elseif name == "showRewards" then
			return smeltRead.showRewards
		end
	end
	smeltRead:defineValue("maxRounds", createData)
	smeltRead:defineValue("showRewards", createData)
	smeltRead:defineValue("showOtherRewards", function()
		local _ENV, showOtherRewards
		for i, v in ipairs(smeltRead.otherReawrds) do
			if not showOtherRewards[v.group] then
				showOtherRewards[v.group], _ENV = nil, nil
			end
			showOtherRewards[v.group][v.round] = v
		end
		smeltRead.showOtherRewards = showOtherRewards
		return smeltRead.showOtherRewards
	end)
	smeltRead:defineValue("equipGroups", function()
		smeltRead.equipGroups, smeltRead = nil, nil
		for k, v in pairs(smeltRead.equips) do
			if not smeltRead.equipGroups[v.group] then
				smeltRead.equipGroups[v.group], smeltRead = nil, nil
			end
			table.insert(smeltRead.equipGroups[v.group], v)
		end
		return smeltRead.equipGroups
	end)
	smeltRead:defineValue("taskGroups", function()
		smeltRead.taskGroups, smeltRead = nil, nil
		for k, v in pairs(smeltRead.tasks) do
			smeltRead.taskGroups[v.group] = v
		end
		return smeltRead.taskGroups
	end)
end
init()
function smeltRead.getShowRewards(group)
	return smeltRead.showRewards[group]
end
function smeltRead.getEquips(group)
	return smeltRead.equipGroups[group]
end
function smeltRead.getItems()
	return smeltRead.items
end
function smeltRead.getCurPrice(count)
	local curPrice = 0
	for i, v in ipairs(smeltRead.prices) do
		if count >= v.num then
			curPrice = v.gold
		end
	end
	return curPrice
end
function smeltRead.getMaxRound(group)
	return smeltRead.maxRounds[group]
end
function smeltRead.getOtherRewards(group)
	return smeltRead.showOtherRewards[group]
end
function smeltRead.getTasks(group)
	return smeltRead.taskGroups[group].taskID
end
return smeltRead
