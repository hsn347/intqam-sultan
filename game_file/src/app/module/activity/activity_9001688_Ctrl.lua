local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001688_Ctrl = class("activity_9001688_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local daySec = 86400
local hourSec = 3600
function activity_9001688_Ctrl:ctor(properties)
	activity_9001688_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE
	self:resetData()
end
function activity_9001688_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DAILY_SALUTE_MODULE, gCmd.REQ_DAILY_SALUTE_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_DAILY_SALUTE_MODULE, gCmd.REQ_DAILY_SALUTE_PLAYER_RANK, handler(self, self.reqRankRsp))
	self:registerNotify()
end
function activity_9001688_Ctrl:Logout()
	activity_9001688_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001688_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).opencount = 0
	;(nil).totalScore = 0
	self.defaultData, (nil).task, _UPVALUE0_, (nil).taskTime = nil, nil, nil, 0
	self.globalScore = 0
end
function activity_9001688_Ctrl:initClientData(data)
	dump(data, "activity_9001688_Ctrl:initClientData===")
end
function activity_9001688_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DAILY_SALUTE, handler(self, self.notifyHandler))
end
function activity_9001688_Ctrl:notifyHandler(event)
	dump(event, "activity_9001688_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.globalScore then
			self.globalScore = v.globalScore
		end
		if v.data then
			self.defaultData = v.data
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001688_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001688_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DAILY_SALUTE_MODULE, gCmd.REQ_DAILY_SALUTE_DATA, nil)
end
function activity_9001688_Ctrl:reqRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_DAILY_SALUTE_MODULE, gCmd.REQ_DAILY_SALUTE_PLAYER_RANK, nil)
end
function activity_9001688_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001688_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		self.globalScore = content.rspdata.globalScore
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001688_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001688_Ctrl:reqRankRsp(content)
	dump(content, "activity_9001688_Ctrl:reqRankRsp(content)", 10)
	local myInfo
	local _ENV, rank = content, content
	if content.err == gErrDef.Err_None then
		myInfo = content.rspdata.myInfo
		rank = content.rspdata.rank
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001688_UPDATE"
	gErrDef.Err_None.key = "rank"
	gErrDef.Err_None.myInfo = myInfo
	gErrDef.Err_None.rank = rank
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001688_Ctrl:getReceiveStatusAndNum()
	local num = 0
	if not self:isTodayCanSigned() then
		num = num + 1
	end
	num = num + self:getStageSignNum()
	num = num + self:getSignGoldNum()
	return 0 < num, num
end
function activity_9001688_Ctrl:isTodayCanSigned()
	local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
	local curDay = activityCommonSignCtrl:getCurDay(self.activityID)
	local signState = activityCommonSignCtrl:getSignInfoByDay(self.activityID, curDay)
	return signState ~= gSignRewardType.NO_SIGN
end
function activity_9001688_Ctrl:getStageSignNum()
	local num = 0
	local activityCommonSignRead = include("activityCommonSignRead")
	local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
	local signCuumCfg = activityCommonSignRead.getCumuDayArray(self.activityID)
	for k, v in ipairs(signCuumCfg) do
		local status = activityCommonSignCtrl:getExtraRewardInfoByDay(self.activityID, v)
		if status == gSignRewardStatus.CAN_RECEIVE then
			num = num + 1
		end
	end
	return num
end
function activity_9001688_Ctrl:getSignGoldNum()
	local num = 0
	local activityCommonSignRead = include("activityCommonSignRead")
	local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
	local signCfg = clone(activityCommonSignRead.getRewardConfig(self.activityID))
	local needGold = activityCommonSignCtrl:getCostGold(self.activityID)
	for k, v in ipairs(signCfg) do
		local curDay = activityCommonSignCtrl:getCurDay(self.activityID)
		local signState = activityCommonSignCtrl:getSignInfoByDay(self.activityID, v.day)
		local status = 0
		if signState == gSignRewardType.NO_SIGN then
			status = curDay > v.day and 2 or 0
			if curDay == v.day then
				status = 1
			end
		else
			status = 3
		end
		if status == 1 or status == 2 and SoraDEnoughGold(needGold, true) then
			num = num + 1
		end
	end
	return num
end
function activity_9001688_Ctrl:getStageBoxProgress(taskType)
	return self.defaultData.task[tostring(taskType)] or 0
end
function activity_9001688_Ctrl:getCycleState()
	local time = serviceFunctions.systemTime()
	local beginTime = SoraDGetCtrl("activityShowCtrl"):getBeginTimeSecond(self.activityID)
	local cycleHour = (time - beginTime) % daySec / hourSec
	local state = 0
	local nextStateTime = 0
	local curDay = math.floor((time - beginTime) / daySec)
	if 20 < cycleHour then
		state = 1
		nextStateTime = beginTime + curDay * daySec + 24 * hourSec - time
	else
		state = 0
		nextStateTime = beginTime + curDay * daySec + 20 * hourSec - time
	end
	return state, nextStateTime
end
function activity_9001688_Ctrl:getNextFireTime()
	local fiveSec = 300
	local time = serviceFunctions.systemTime()
	local beginTime = SoraDGetCtrl("activityShowCtrl"):getBeginTimeSecond(self.activityID)
	local times = math.floor((time - (beginTime + 20 * hourSec)) / fiveSec)
	local nextTime = (times + 1) * fiveSec + beginTime + 20 * hourSec
	return nextTime - time
end
function activity_9001688_Ctrl:getGlobalScore()
	return self.globalScore
end
return activity_9001688_Ctrl
