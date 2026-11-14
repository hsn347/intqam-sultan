local GameModule = include("GameModule")
local anniversaryCtrl = class("anniversaryCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function anniversaryCtrl:ctor(properties)
	anniversaryCtrl.super.ctor(self, properties)
end
function anniversaryCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_INIT, handler(self, self.reqAnniversaryInitRsp))
	msgCtrl.register(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_COMMIT, handler(self, self.reqCommitTaskRsp))
	msgCtrl.register(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_ONEKEY, handler(self, self.reqOneKeyRsp))
	self:resetData()
end
function anniversaryCtrl:initClientData(data)
	if not data then
		return
	end
	self.anniversaryData = data
	self:registerNotify()
end
function anniversaryCtrl:resetData()
	self.handle_notify = nil
	self.anniversaryData = nil
end
function anniversaryCtrl:Logout()
	self:resetData()
	anniversaryCtrl.super.Logout(self)
end
function anniversaryCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ANNIVERSARY, handler(self, self.notifyHandler))
end
function anniversaryCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content and table.nums(self.anniversaryData.userData.missionSet) > 0 then
			for i, v in ipairs(self.anniversaryData.userData.missionSet) do
				if content.updateMission then
					for j, m in ipairs(content.updateMission) do
						if v.taskID == m.taskID then
							v.curNum = m.curNum
							v.taskStatus = m.taskStatus
						end
					end
				end
			end
			_ENV = ipairs(self.anniversaryData.userData.missionSet)
			ipairs(self.anniversaryData.userData.missionSet).msg = "MESSAGE_ANNIVERSARY_REFRESH_BACK"
			SoraDSendMessage(ipairs(self.anniversaryData.userData.missionSet))
		end
	end
end
function anniversaryCtrl:sendAnniversaryInitMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_INIT, data)
end
function anniversaryCtrl:sendCommitTaskMsg(taskID)
	serverproxy = nil
	local (nil).taskID, data = taskID, nil
	serverproxy:Request(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_COMMIT, data)
end
function anniversaryCtrl:sendGetRewardsMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_ANNIVERSARY_MODULE, gCmd.REQ_ANNIVERSARY_ONEKEY, data)
end
function anniversaryCtrl:reqAnniversaryInitRsp(ret)
	if ret and ret.err == gErrDef.Err_None then
		self.anniversaryData.userData = ret.userData
		_ENV = ret.userData
		ret.userData.msg = "MESSAGE_ANNIVERSARY_INIT_BACK"
		SoraDSendMessage(ret.userData)
	end
end
function anniversaryCtrl:reqCommitTaskRsp(ret)
	if ret and ret.err == gErrDef.Err_None then
		for i, v in ipairs(self.anniversaryData.userData.missionSet) do
			if v.taskID == ret.mission.taskID then
				v.taskStatus = ret.mission.taskStatus
				break
			end
		end
		self.anniversaryData.userData.activeValue = ret.completeNum
		local _ENV, tTbl = self.anniversaryData.userData, self.anniversaryData.userData
		for i, v in ipairs(ret.rewardInfo) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_ANNIVERSARY_REFRESH_BACK"
		SoraDSendMessage(tTbl)
		_ENV = tTbl
		tTbl.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		tTbl.eventID = gActivityTimeActivityID.ANNIVERSARY_CELEBRATION
		SoraDSendMessage(tTbl)
	end
end
function anniversaryCtrl:reqOneKeyRsp(ret)
	if ret and ret.err == gErrDef.Err_None then
		for i, v in ipairs(self.anniversaryData.userData.missionSet) do
			for j, m in ipairs(ret.completeSet) do
				if v.taskID == m.mission.taskID then
					v.taskStatus = m.mission.taskStatus
				end
			end
		end
		self.anniversaryData.userData.activeValue = ret.completeNum
		SoraDMailGainItems(ret.rewardInfo)
		_ENV = ret.rewardInfo
		ret.rewardInfo.msg = "MESSAGE_ANNIVERSARY_REFRESH_BACK"
		SoraDSendMessage(ret.rewardInfo)
		_ENV = ret.rewardInfo
		ret.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ret.rewardInfo.eventID = gActivityTimeActivityID.ANNIVERSARY_CELEBRATION
		SoraDSendMessage(ret.rewardInfo)
	end
end
function anniversaryCtrl:getMissionSetData(day)
	local _ENV, missionSet
	local _ENV, doneList
	for i, v in ipairs(self.anniversaryData.userData.missionSet) do
		if day == v.day then
			if not missionSet[v.taskSet] then
				_ENV = missionSet[v.taskSet]
			end
			missionSet[v.taskSet] = missionSet[v.taskSet]
			if not doneList[v.taskSet] then
				_ENV = doneList[v.taskSet]
			end
			doneList[v.taskSet] = doneList[v.taskSet]
			if v.taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE_DONE then
				table.insert(doneList[v.taskSet], v)
			else
				table.insert(missionSet[v.taskSet], v)
			end
		end
	end
	for k, v in pairs(doneList) do
		if next(doneList[k]) then
			for j, m in ipairs(doneList[k]) do
				table.insert(missionSet[k], m)
			end
		end
	end
	return missionSet
end
function anniversaryCtrl:getMissionCompleteNumsByMissionSet(taskSet)
	local num = 0
	for i, v in ipairs(self.anniversaryData.userData.missionSet) do
		if taskSet == v.taskSet and v.taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE and v.lock == false then
			num = num + 1
		end
	end
	return num
end
function anniversaryCtrl:getMissionCompleteNumsByDay(day)
	local num = 0
	for i, v in ipairs(self.anniversaryData.userData.missionSet) do
		if day == v.day and v.taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE and v.lock == false then
			num = num + 1
		end
	end
	return num
end
function anniversaryCtrl:getCurrentDayByLoginTime()
	local day = math.floor(math.abs(serviceFunctions.getTodayZeroHourUTC() - serviceFunctions.getTodayZeroHourUTC(self.anniversaryData.userData.beginTime)) / 86400) + 1
	return day
end
function anniversaryCtrl:getRemainTimesToDoTask()
	local remainTime = serviceFunctions.getTodayZeroHourUTC(self.anniversaryData.userData.beginTime) + 604800 - serviceFunctions.systemTime()
	return remainTime
end
function anniversaryCtrl:getPlayerActiveness()
	return self.anniversaryData.userData.activeValue
end
function anniversaryCtrl:getReceiveStatusAndNum(activityID)
	if activityID == gActivityTimeActivityID.ANNIVERSARY_CELEBRATION then
		local ret = false
		local num = 0
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIVERSARY_CELEBRATION) and self.anniversaryData.userData and 0 < table.nums(self.anniversaryData.userData) then
			for i, v in ipairs(self.anniversaryData.userData.missionSet) do
				if v.taskStatus == gAnnivasaryTaskStatus.TASK_STATUS_COMPLETE and v.lock == false then
					num = num + 1
				end
			end
		end
		if 0 < num then
			ret = true
		end
		return ret, num
	end
	return false, 0
end
return anniversaryCtrl
