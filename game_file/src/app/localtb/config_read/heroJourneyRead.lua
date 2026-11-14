local heroJourneyRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "hero_diary"
;(nil)[2] = true
heroJourneyRead:defineValue("hero_diary", nil)
_UPVALUE2_ = nil
;(nil)[1] = "hero_diary_reward"
;(nil)[2] = true
heroJourneyRead:defineValue("hero_diary_reward", nil)
heroJourneyRead:defineValue("heroDiaryRewardConfig", function()
	return heroJourneyRead.getClassTypeConfig(heroJourneyRead.hero_diary_reward)
end)
function heroJourneyRead.getTaskConfigByDay(day)
	local _ENV, taskList
	for i, v in ipairs(heroJourneyRead.hero_diary) do
		if v.day == day then
			for _, taskID in ipairs(v.singleQeustID) do
				table.insert(taskList, taskID)
			end
			for _, taskID in ipairs(v.teamQeustID) do
				table.insert(taskList, taskID)
			end
			return taskList
		end
	end
	_ENV = (for generator)
	return ipairs(heroJourneyRead.hero_diary)
end
function heroJourneyRead.getRewardConfig()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.HERO_DIARY_ACTIVITY)
	return heroJourneyRead.heroDiaryRewardConfig[classType]
end
function heroJourneyRead.getRewardMaxScore()
	local config = heroJourneyRead.getRewardConfig()
	return config[table.nums(config)].integral
end
function heroJourneyRead:getCurScoreLevel(curScore)
	local curlevel = 0
	local config = heroJourneyRead.getRewardConfig()
	for i, v in ipairs(config) do
		if curScore >= v.integral then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function heroJourneyRead.getLeftNum(curValue, curLevel)
	if 0 < curLevel then
		local config = heroJourneyRead.getRewardConfig()
		return curValue - config[curLevel].integral
	else
		return curValue
	end
end
function heroJourneyRead.getLevelNum(level)
	if 0 < level then
		local config = heroJourneyRead.getRewardConfig()
		return config[level].integral
	else
		return 0
	end
end
return heroJourneyRead
