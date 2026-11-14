local backToTopRead = include("aAReadClass").new()
local isInited = false
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "return_peak_lv_exp"
	;(nil)[2] = true
	backToTopRead:defineValue("peakExp", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "return_peak_lv_reward"
	;(nil)[2] = true
	backToTopRead:defineValue("peakLvReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "return_peak_quest"
	;(nil)[2] = true
	backToTopRead:defineValue("peakQuest", nil)
	backToTopRead = nil
	;(nil)[1] = "return_peak_reward_show"
	backToTopRead:defineValue("peakReward", nil)
end
init()
function backToTopRead.getExpCfg(exp)
	local lv = 0
	local curExp = exp
	local nextExp
	for k, v in ipairs(backToTopRead.peakExp) do
		if curExp >= v.exp then
			lv = v.lv
			curExp = curExp - v.exp
		else
			nextExp = v.exp
			if curExp < v.exp then
				break
			end
		end
	end
	return lv, curExp, nextExp
end
function backToTopRead.getPeakLvCfg()
	return backToTopRead.peakExp
end
function backToTopRead.getPeakLvCfgNum()
	return #backToTopRead.peakExp
end
function backToTopRead.getAllPeakReward()
	local _ENV, ret
	for k, v in ipairs(backToTopRead.peakExp) do
		if v.PeakReward and next(v.PeakReward) then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.PeakReward, nil)
			for ki, vi in ipairs(reward) do
				table.insert(ret, vi)
			end
		end
	end
	return ret
end
function backToTopRead.getTaskGroupNum()
	return #backToTopRead.peakQuest
end
function backToTopRead.getNextTaskID(group, taskID)
	local taskID = tonumber(taskID)
	local questCfg = backToTopRead.peakQuest[group].questID
	if taskID then
		for k, v in ipairs(questCfg) do
			if taskID == v then
				local index = math.min(k + 1, #questCfg)
				return questCfg[index]
			end
		end
	else
		return questCfg[1]
	end
end
function backToTopRead.getTaskGroup(taskID)
	local taskID = tonumber(taskID)
	for k, v in ipairs(backToTopRead.peakQuest) do
		if SoraDisInList(taskID, v.questID) then
			return v.questGroup, v.questID[#v.questID] == taskID
		end
	end
end
function backToTopRead.getTaskList(group)
	return backToTopRead.peakQuest[group].questID
end
function backToTopRead.getExtraCfg()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return backToTopRead.peakLvReward[1].lv, backToTopRead.peakLvReward[1].exp, serviceFunctions.tableFormat(backToTopRead.peakLvReward[1].PeakReward, nil)
end
function backToTopRead.getMaxLvAndExp(exp)
	local lv = 0
	local curExp = exp
	local nextExp = backToTopRead.peakLvReward[1].exp
	for k, v in ipairs(backToTopRead.peakExp) do
		curExp = curExp - v.exp
		lv = v.lv
	end
	local extraLv = math.floor(curExp / nextExp)
	curExp = curExp - extraLv * nextExp
	return lv + extraLv, curExp, nextExp
end
function backToTopRead.getGiftInfo(rid)
	for k, v in ipairs(backToTopRead.peakReward) do
		if v.rechargeID == rid then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return v.price, v.gold, serviceFunctions.tableFormat(v.award, nil), v.limited
		end
	end
end
return backToTopRead
