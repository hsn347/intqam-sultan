local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local eventRushTaskCtrl = class("eventRushTaskCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function eventRushTaskCtrl:ctor(properties)
	eventRushTaskCtrl.super.ctor(self, properties)
	self:resetData()
end
function eventRushTaskCtrl:Logout()
	eventRushTaskCtrl.super.Logout(self)
	self:resetData()
end
function eventRushTaskCtrl:resetData()
	self.sunsetWelfare, _UPVALUE0_, self.taskActivity, _UPVALUE0_ = nil, nil, nil, nil
end
function eventRushTaskCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FULL_DAY_SPRINT_MOUDLE, gCmd.REQ_FULL_DAY_SPRINT_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_FULL_DAY_SPRINT_MOUDLE, gCmd.REQ_FULL_DAY_SPRINT_RECEIVE, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_FULL_DAY_SPRINT_MOUDLE, gCmd.REQ_SUNSET_WELFARE_RECEIVE, handler(self, self.missionCommitSunsetRsp))
end
function eventRushTaskCtrl:initRsp(retdata)
	if retdata then
		self.taskActivity = retdata.fullDaysprint
		self.sunsetWelfare = retdata.sunsetWelfare
	end
end
function eventRushTaskCtrl:initClientData(retdata)
	if retdata then
		self.taskActivity = retdata.fullDaysprint
		self.sunsetWelfare = retdata.sunsetWelfare
		self:registerNotify()
	end
end
function eventRushTaskCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FULL_DAY_SPRINT, handler(self, self.notifyUpdate))
end
function eventRushTaskCtrl:notifyUpdate(event)
	dump(event.data, "eventRushTaskCtrl:notifyUpdate", 10)
	for k, v in ipairs(event.data) do
		if v.fullDaysprint then
			for _k, _v in pairs(v.fullDaysprint) do
				local _, beforeNum = self:getReceiveStatusAndNum(_k)
				self.taskActivity[_k] = _v
				local _, curNum = self:getReceiveStatusAndNum(_k)
				if beforeNum ~= curNum then
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = _k
					SoraDSendMessage(nil)
				end
			end
			_ENV = pairs(v.fullDaysprint)
			pairs(v.fullDaysprint).msg = "MESSAGE_SERVER_FULL_RUSH_UPDATE_TASK"
			SoraDSendMessage(pairs(v.fullDaysprint))
		end
	end
end
function eventRushTaskCtrl:getReceiveStatusAndNum(activityID)
	local num = 0
	if activityID and self.taskActivity[tostring(activityID)] then
		for k, v in ipairs(self.taskActivity[tostring(activityID)]) do
			if not v.receive and v.finishCount >= v.amount then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function eventRushTaskCtrl:getTaskData(amount, activityID)
	print("现在的activityID", activityID)
	for k, v in ipairs(self.taskActivity[activityID]) do
		if v.amount == amount then
			return v
		end
	end
end
function eventRushTaskCtrl:getSunsetTaskStatusByID(taskID)
	for k, v in ipairs(self.sunsetWelfare) do
		if v.taskID == taskID then
			return v
		end
	end
end
function eventRushTaskCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_FULL_DAY_SPRINT_MOUDLE, gCmd.REQ_FULL_DAY_SPRINT_RECEIVE, data)
end
function eventRushTaskCtrl:reqCommitSunSetTask(_data)
	local data = _data
	dump(data, "eventRushTaskCtrl:reqCommitSunSetTask", 10)
	serverproxy:Request(gCmd.CMD_FULL_DAY_SPRINT_MOUDLE, gCmd.REQ_SUNSET_WELFARE_RECEIVE, data)
end
function eventRushTaskCtrl:missionCommitRsp(content)
	dump(content, "eventRushTaskCtrl:missionCommitRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		self.taskActivity = content.rspdata.fullDaysprint
		self.sunsetWelfare = content.rspdata.sunsetWelfare
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = content.data.activityID
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_FULL_RUSH_UPDATE_TASK"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function eventRushTaskCtrl:missionCommitSunsetRsp(content)
	dump(content, "eventRushTaskCtrl:missionCommitRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		self.taskActivity = content.rspdata.fullDaysprint
		self.sunsetWelfare = content.rspdata.sunsetWelfare
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_SUN_SET_UPDATE_TASK"
		SoraDSendMessage(content.rspdata.reward)
	end
end
return eventRushTaskCtrl
