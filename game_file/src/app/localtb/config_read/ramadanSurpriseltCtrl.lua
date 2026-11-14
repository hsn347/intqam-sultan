local ramadanSurpriseltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ramadan_surprise_reward"
;(nil)[2] = true
ramadanSurpriseltCtrl:defineValue("ramadan_surprise_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "ramadan_surprise_task"
;(nil)[2] = true
ramadanSurpriseltCtrl:defineValue("ramadan_surprise_task", nil)
function ramadanSurpriseltCtrl.getSelectRewardByIndex(index)
	return ramadanSurpriseltCtrl.ramadan_surprise_reward[index]
end
function ramadanSurpriseltCtrl.getSelectedIconByIndex(index, subIndex)
	return ramadanSurpriseltCtrl.ramadan_surprise_reward[index].gift[subIndex * 2 - 1]
end
function ramadanSurpriseltCtrl.getTaskScoreByQuestId(questId)
	for i, v in pairs(ramadanSurpriseltCtrl.ramadan_surprise_task) do
		dump(v.qeustID, "fjskfjksdfjkdfjkdf")
		for _, q in pairs(v.qeustID) do
			if questId == q then
				return v.integral
			end
		end
	end
	return 0
end
function ramadanSurpriseltCtrl.getMaxTaskScore()
	local count = table.nums(ramadanSurpriseltCtrl.ramadan_surprise_reward)
	return ramadanSurpriseltCtrl.ramadan_surprise_reward[count].integral or 0
end
function ramadanSurpriseltCtrl.getSelectRewardGradeCount()
	if not ramadanSurpriseltCtrl.ramadan_surprise_reward then
		_ENV = ramadanSurpriseltCtrl.ramadan_surprise_reward
	end
	return table.nums(ramadanSurpriseltCtrl.ramadan_surprise_reward)
end
function ramadanSurpriseltCtrl.getRewardTaskByIndex(index)
	return ramadanSurpriseltCtrl.ramadan_surprise_task[index]
end
function ramadanSurpriseltCtrl:getCurScoreLevel(curScore)
	local curlevel = 0
	for i, v in ipairs(ramadanSurpriseltCtrl.ramadan_surprise_reward) do
		if curScore >= v.integral then
			curlevel = curlevel + 1
		else
			break
		end
	end
	return curlevel
end
function ramadanSurpriseltCtrl.getLeftNum(curValue, curLevel)
	if 0 < curLevel then
		return curValue - ramadanSurpriseltCtrl.ramadan_surprise_reward[curLevel].integral
	else
		return curValue
	end
end
function ramadanSurpriseltCtrl.getLevelNum(level)
	if 0 < level then
		return ramadanSurpriseltCtrl.ramadan_surprise_reward[level].integral
	else
		return 0
	end
end
return ramadanSurpriseltCtrl
