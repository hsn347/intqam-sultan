local heroPaeanRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "hero_paean_quest"
;(nil)[2] = true
heroPaeanRead:defineValue("hero_paean_quest", nil)
_UPVALUE2_ = nil
;(nil)[1] = "hero_paean_stage"
;(nil)[2] = true
heroPaeanRead:defineValue("hero_paean_stage", nil)
function heroPaeanRead.getTaskConfigByDay(day)
	for i, v in ipairs(heroPaeanRead.hero_paean_quest) do
		if v.day == day then
			return v.quest
		end
	end
	_ENV = (for generator)
	return ipairs(heroPaeanRead.hero_paean_quest)
end
function heroPaeanRead.getTotalDay()
	return table.nums(heroPaeanRead.hero_paean_quest)
end
function heroPaeanRead.getStageRewardConfig()
	return heroPaeanRead.hero_paean_stage
end
function heroPaeanRead.getRewardMaxScore()
	return heroPaeanRead.hero_paean_stage[table.nums(heroPaeanRead.hero_paean_stage)].score
end
function heroPaeanRead:getCurScoreLevel(curScore)
	local curlevel = 0
	for i, v in ipairs(heroPaeanRead.hero_paean_stage) do
		if curScore >= v.score then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function heroPaeanRead.getLeftNum(curValue, curLevel)
	if 0 < curLevel then
		return curValue - heroPaeanRead.hero_paean_stage[curLevel].score
	else
		return curValue
	end
end
function heroPaeanRead.getLevelNum(level)
	if 0 < level then
		return heroPaeanRead.hero_paean_stage[level].score
	else
		return 0
	end
end
return heroPaeanRead
