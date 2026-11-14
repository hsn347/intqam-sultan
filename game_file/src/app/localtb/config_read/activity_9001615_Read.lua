local activity_9001615_Read = include("aAReadClass").new()
local isInited = false
local tmpGroup = 2
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "return_smelt_equip_config"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("equips", nil)
	_ENV = nil
	;(nil)[1] = "return_stage_config"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("rewards", nil)
	_ENV = nil
	;(nil)[1] = "return_smelt_item_config"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("items", nil)
	_ENV = nil
	;(nil)[1] = "return_smelt_recharge"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("recharge", nil)
	_ENV = nil
	;(nil)[1] = "return_smelt_treasure_refresh"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("prices", nil)
	activity_9001615_Read = nil
	;(nil)[1] = "return_smelt_reward_show"
	activity_9001615_Read:defineValue("otherReawrds", nil)
	_ENV = nil
	;(nil)[1] = "return_smelt_task_config"
	;(nil)[2] = true
	activity_9001615_Read:defineValue("tasks", nil)
	local createData = function(name)
		activity_9001615_Read.maxRounds, activity_9001615_Read = nil, nil
		local activity_9001615_Read, showRewards
		local rewards = activity_9001615_Read.rewards
		for i, v in ipairs(rewards) do
			local round = v.round
			local group = tmpGroup
			if not showRewards[group] then
				showRewards[group], activity_9001615_Read = showRewards[group], showRewards[group]
			end
			if not showRewards[group][round] then
				showRewards[group][round], activity_9001615_Read = nil, nil
			end
			if not activity_9001615_Read.maxRounds[group] or round > activity_9001615_Read.maxRounds[group] then
				activity_9001615_Read.maxRounds[group] = round
			end
			table.insert(showRewards[group][round], v)
		end
		activity_9001615_Read.showRewards = showRewards
		if name == "maxRounds" then
			return activity_9001615_Read.maxRounds
		elseif name == "showRewards" then
			return activity_9001615_Read.showRewards
		end
	end
	activity_9001615_Read:defineValue("maxRounds", createData)
	activity_9001615_Read:defineValue("showRewards", createData)
	activity_9001615_Read:defineValue("showOtherRewards", function()
		local _ENV, showOtherRewards
		for i, v in ipairs(activity_9001615_Read.otherReawrds) do
			if not showOtherRewards[tmpGroup] then
				showOtherRewards[tmpGroup], _ENV = nil, nil
			end
			showOtherRewards[tmpGroup][v.round] = v
		end
		activity_9001615_Read.showOtherRewards = showOtherRewards
		return activity_9001615_Read.showOtherRewards
	end)
	activity_9001615_Read:defineValue("equipGroups", function()
		activity_9001615_Read.equipGroups, activity_9001615_Read = nil, nil
		for k, v in pairs(activity_9001615_Read.equips) do
			if not activity_9001615_Read.equipGroups[tmpGroup] then
				activity_9001615_Read.equipGroups[tmpGroup], activity_9001615_Read = nil, nil
			end
			table.insert(activity_9001615_Read.equipGroups[tmpGroup], v)
		end
		return activity_9001615_Read.equipGroups
	end)
	activity_9001615_Read:defineValue("taskGroups", function()
		activity_9001615_Read.taskGroups, activity_9001615_Read = nil, nil
		return activity_9001615_Read.taskGroups
	end)
end
init()
function activity_9001615_Read.getShowRewards(group)
	return activity_9001615_Read.showRewards[tmpGroup]
end
function activity_9001615_Read.getEquips(group)
	dump(activity_9001615_Read.equipGroups[tmpGroup], "activity_9001615_Read.equipGroups[tmpGroup]")
	return activity_9001615_Read.equipGroups[tmpGroup]
end
function activity_9001615_Read.getItems()
	return activity_9001615_Read.items
end
function activity_9001615_Read.getCurPrice(count)
	local curPrice = 0
	for i, v in ipairs(activity_9001615_Read.prices) do
		if count >= v.num then
			curPrice = v.gold
		end
	end
	return curPrice
end
function activity_9001615_Read.getMaxRound(group)
	return activity_9001615_Read.maxRounds[tmpGroup]
end
function activity_9001615_Read.getOtherRewards(group)
	return activity_9001615_Read.showOtherRewards[tmpGroup]
end
function activity_9001615_Read.getTasks(group)
	_UPVALUE0_ = nil
	return nil
end
function activity_9001615_Read.getGift(activityID)
	for i, v in ipairs(activity_9001615_Read.recharge) do
		if v.activityID == activityID then
			return v
		end
	end
end
return activity_9001615_Read
