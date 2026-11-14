local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local heroTrialltCtrl = include("heroTrialltCtrl")
local _ENV, _ENV, htPointMgr = nil, "heroTrialltCtrl", "heroTrialltCtrl"
;(nil).point = 0
;(nil).isInRecoveryCD = false
htPointMgr.property, (nil).recoveryBeginTime = nil, nil
local isInit = false
function htPointMgr.init(data)
	if isInit then
		printError("heroTrial log: repeat ot init the htPointMgr!")
		return
	end
	htPointMgr.property.point = data.htPoint
	htPointMgr.property.isInRecoveryCD = data.inRCD
	if htPointMgr.property.isInRecoveryCD then
		htPointMgr.property.recoveryBeginTime = data.bTime
	end
end
function htPointMgr.setPoint(num)
	htPointMgr.property.point = num
	local limitPoint = heroTrialltCtrl.getLimitPoint()
	if limitPoint < htPointMgr.property.point then
		htPointMgr.property.point = limitPoint
	end
end
function htPointMgr.getPoint()
	return htPointMgr.property.point or 0
end
function htPointMgr.addPoint(num)
	htPointMgr.property.point = htPointMgr.property.point + num
	local limitPoint = heroTrialltCtrl.getLimitPoint()
	if limitPoint < htPointMgr.property.point then
		htPointMgr.property.point = limitPoint
	end
	htPointMgr.updateReceiverQueue()
end
function htPointMgr.subPoint(num)
	htPointMgr.property.point = htPointMgr.property.point - num
	if htPointMgr.property.point < 0 then
		printError("heroTrial log: subPoint fail! .point = ", htPointMgr.property.point)
		htPointMgr.property.point = 0
	end
	htPointMgr.updateReceiverQueue()
end
function htPointMgr.isPointFull()
	local limitPoint = heroTrialltCtrl.getLimitPoint()
	if limitPoint <= htPointMgr.property.point then
		return true
	end
	return false
end
function htPointMgr.isRecoveryPointFull()
	local limitPoint = heroTrialltCtrl.getRecoveryLimitPoint()
	if limitPoint <= htPointMgr.property.point then
		return true
	end
	return false
end
function htPointMgr.isPointEnough(num)
	local point = htPointMgr.property.point or 0
	return num <= point
end
function htPointMgr.setBeginTimeOfRecovry(time)
	htPointMgr.property.recoveryBeginTime = time
end
function htPointMgr.getRemainTimeOfRecovery()
	if not htPointMgr.property.isInRecoveryCD then
		return 0
	end
	local passTime = serviceFunctions.systemTime() - htPointMgr.property.recoveryBeginTime
	local recoveryTime = heroTrialltCtrl.getRecoveryCDTime()
	local remainTime = recoveryTime - passTime
	remainTime = 0 <= remainTime and remainTime or 0
	return remainTime
end
function htPointMgr.isInRecoveryCD()
	return htPointMgr.property.isInRecoveryCD
end
function htPointMgr.logout()
	htPointMgr.property, htPointMgr = nil, nil
end
function htPointMgr.dump()
end
function htPointMgr.updateReceiverQueue()
end
return htPointMgr
