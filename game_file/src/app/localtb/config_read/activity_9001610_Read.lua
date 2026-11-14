local activity_9001610_Read = include("aAReadClass").new()
function activity_9001610_Read.getRewardConfig(group)
	local activityCommonSignRead = include("activityCommonSignRead")
	return activityCommonSignRead.getRewardConfig(gActivityTimeActivityID.HONOR_BACK_SIGN, group)
end
function activity_9001610_Read.getCumuDayArray(group)
	local _ENV, ret
	for k, v in ipairs(activity_9001610_Read.getRewardConfig(group)) do
		if v.cumulateReward and next(v.cumulateReward) then
			table.insert(ret, v.day)
		end
	end
	return ret
end
function activity_9001610_Read.getExtraAwardByDay(day, group)
	for k, v in ipairs(activity_9001610_Read.getRewardConfig(group)) do
		if v.day == day then
			return v.cumulateReward
		end
	end
	_ENV = (for generator)
	return ipairs(activity_9001610_Read.getRewardConfig(group))
end
function activity_9001610_Read.getAwardByDay(day, group)
	for k, v in ipairs(activity_9001610_Read.getRewardConfig(group)) do
		if v.day == day then
			return v.reward
		end
	end
	_ENV = (for generator)
	return ipairs(activity_9001610_Read.getRewardConfig(group))
end
function activity_9001610_Read.getCostGold(day, group)
	for k, v in ipairs(activity_9001610_Read.getRewardConfig(group)) do
		if v.day == day then
			return v.gold
		end
	end
	return 0
end
return activity_9001610_Read
