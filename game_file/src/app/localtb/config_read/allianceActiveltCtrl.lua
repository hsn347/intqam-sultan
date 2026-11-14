local allianceActiveltCtrl = include("aAReadClass").new()
allianceActiveltCtrl.isInit = false
function allianceActiveltCtrl.init()
	if allianceActiveltCtrl.isInit then
		return
	end
	allianceActiveltCtrl.isInit = true
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_active_lv"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_active_lv", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_active_dailybox"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_active_dailybox", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_active_rank"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_active_rank", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_active_refresh"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_active_refresh", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_active_task"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_active_task", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_personalactive_reward"
	;(nil)[2] = true
	allianceActiveltCtrl:defineValue("alliance_personalactive_reward", nil)
end
allianceActiveltCtrl.init()
function allianceActiveltCtrl.getRankRewardInfo(mType)
	local _ENV, ret
	for k, v in pairs(allianceActiveltCtrl.alliance_active_rank) do
		if v.type == mType then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		return a.index < b.index
	end)
	return ret
end
function allianceActiveltCtrl.getActiveLvInfo()
	local _ENV, ret
	for k, v in ipairs(allianceActiveltCtrl.alliance_active_lv) do
		if #v.reward > 0 then
			table.insert(ret, v)
		end
	end
	return ret
end
function allianceActiveltCtrl.getActiveLvPoint(lv)
	local lv = math.min(lv, #allianceActiveltCtrl.alliance_active_lv)
	return allianceActiveltCtrl.alliance_active_lv[lv].activeNum[1]
end
function allianceActiveltCtrl.getActiveBoxesInfo(aLevel)
	local _ENV, boxesArray
	local _ENV, boxedPoint
	for k, v in ipairs(allianceActiveltCtrl.alliance_active_dailybox) do
		if v.lv == aLevel then
			table.insert(boxesArray, v)
			table.insert(boxedPoint, v.activeNum)
		end
	end
	return boxesArray, boxedPoint
end
function allianceActiveltCtrl.getActiveGold(refreshCount)
	local gold = 0
	for k, v in ipairs(allianceActiveltCtrl.alliance_active_refresh) do
		if refreshCount >= v.refreshNum[1] and refreshCount <= v.refreshNum[2] then
			gold = v.coin
			break
		end
	end
	return gold
end
function allianceActiveltCtrl.getActiveTaskInfo(index)
	local _ENV, taskInfo
	local eventQuestRead = include("eventQuestRead")
	for k, v in ipairs(allianceActiveltCtrl.alliance_active_task) do
		if v.index == index then
			taskInfo.task = v
			taskInfo.index = v.index
			taskInfo.des = eventQuestRead.getDes(v.questID)
			taskInfo.aim = eventQuestRead.getAim(v.questID)
			taskInfo.guideId = eventQuestRead.getGuideId(v.questID)
			break
		end
	end
	return taskInfo
end
function allianceActiveltCtrl.getActiveMemberRankAward(type)
	local _ENV, ret
	for i, v in ipairs(allianceActiveltCtrl.alliance_personalactive_reward) do
		if type == v.type then
			table.insert(ret, v)
		end
	end
	return ret
end
return allianceActiveltCtrl
