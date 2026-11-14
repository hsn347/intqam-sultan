local princeGiftRead = include("aAReadClass").new()
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "wisdom_of_oriental_prince_one"
	;(nil)[2] = true
	princeGiftRead:defineValue("woopo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "wisdom_of_oriental_prince_two"
	;(nil)[2] = true
	princeGiftRead:defineValue("woopt", nil)
end
init()
function princeGiftRead.getBuffEffect(effectType)
	local buffValue = 0
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ORIENT_PRINCE_GIFT, false) and 0 < princeGiftCtrl:getBuffEndTime() - serviceFunctions.systemTime() then
		local basicInfo = princeGiftRead.getFirstPackageInfo()
		buffValue = buffValue + (basicInfo.buffValue or 0)
		local strengthTime = princeGiftRead.getStrengthBuffTotalTime()
		buffValue = buffValue + strengthTime
	end
	return buffValue
end
function princeGiftRead.getFirstPackageInfo()
	return princeGiftRead.woopo[1]
end
function princeGiftRead.getSecondPackageInfo()
	return princeGiftRead.woopo[2]
end
function princeGiftRead.getStrengthBuffTotalTime()
	local totalTime = 0
	local isBuy = princeGiftCtrl:getIsBuy()
	local payReiceives = princeGiftCtrl:getPayReceives()
	if isBuy then
		for k, v in pairs(payReiceives) do
			local levelInfo = princeGiftRead.getTaskInfoByLevel(tonumber(k))
			totalTime = totalTime + levelInfo.buffTimePromote
		end
	end
	return totalTime
end
function princeGiftRead.getAllTaskInfo()
	return princeGiftRead.woopt
end
function princeGiftRead.getTaskInfoByLevel(level)
	local _ENV, curTable
	for i, v in ipairs(princeGiftRead.woopt) do
		if level == 0 then
			level = 1
		end
		if level == v.lv then
			table.insert(curTable, v)
		end
	end
	return curTable[1]
end
function princeGiftRead.getTotalUnreceiveRewardNum(score)
	local totalNum = 0
	local isBuy = princeGiftCtrl:getIsBuy()
	for i, v in ipairs(princeGiftRead.woopt) do
		if score >= v.integral then
			local isNormalReceived = princeGiftCtrl:isReceiveReward(1, i)
			if not isNormalReceived then
				totalNum = totalNum + 1
			end
			local isHighReceived = princeGiftCtrl:isReceiveReward(2, i)
			if not isHighReceived and isBuy then
				totalNum = totalNum + 1
			end
		end
	end
	return totalNum
end
function princeGiftRead.getLevelInfoByScore(score)
	local level = 0
	local targetScore = 0
	for i, v in ipairs(princeGiftRead.woopt) do
		if score >= v.integral then
			level = level + 1
		else
			targetScore = v.integral
			break
		end
	end
	return level, targetScore
end
function princeGiftRead.getMaxScore()
	return princeGiftRead.woopt[10].integral
end
return princeGiftRead
