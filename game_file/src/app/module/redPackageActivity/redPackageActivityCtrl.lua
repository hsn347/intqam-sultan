local GameModule = include("GameModule")
local redPackageActivityCtrl = class("redPackageActivityCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function redPackageActivityCtrl:ctor(properties)
	redPackageActivityCtrl.super.ctor(self, properties)
end
function redPackageActivityCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_RED_PACKAGE_ACTIVITY_MODULE, gCmd.REQ_RED_PACKAGE_ACTIVITY_INIT, handler(self, self.reqInitResp))
	msgCtrl.register(gCmd.CMD_RED_PACKAGE_ACTIVITY_MODULE, gCmd.REQ_RED_PACKAGE_ACTIVITY_RECEIVE, handler(self, self.reqReceiveResp))
	self:resetData()
end
function redPackageActivityCtrl:resetData()
	self.handle_notify = nil
	self.taskInfo = nil
	self.allTaskID = nil
end
function redPackageActivityCtrl:Logout()
	self:resetData()
	redPackageActivityCtrl.super.Logout(self)
end
function redPackageActivityCtrl:initClientData(data)
	if not data then
		return
	end
	if data.taskInfo then
		self.taskInfo = data.taskInfo
	end
	self:registerNotify()
end
function redPackageActivityCtrl:dump()
end
function redPackageActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RED_PACKAGE_ACTIVITY, handler(self, self.notifyHandler))
end
function redPackageActivityCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			if content.data and content.data.taskInfo then
				self.taskInfo = content.data.taskInfo
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_REDPACKAGE_REFRESH"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			;(nil).eventID = gActivityTimeActivityID.RED_PACKAGE_ACTIVITY
			SoraDSendMessage(nil)
		end
	end
end
function redPackageActivityCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_RED_PACKAGE_ACTIVITY_MODULE, gCmd.REQ_RED_PACKAGE_ACTIVITY_INIT)
end
function redPackageActivityCtrl:sendReceiveMsg(taskID)
	local serverproxy, data
	data.taskID = taskID
	serverproxy:Request(gCmd.CMD_RED_PACKAGE_ACTIVITY_MODULE, gCmd.REQ_RED_PACKAGE_ACTIVITY_RECEIVE, data)
end
function redPackageActivityCtrl:reqInitResp(ret)
	if ret and ret.data then
		local data = ret.data
	end
end
function redPackageActivityCtrl:reqReceiveResp(ret)
	if ret and ret.data then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			if data.retData and data.retData.taskInfo then
				self.taskInfo = data.retData.taskInfo
			end
			local reward = data.reward
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_REDPACKAGE_REFRESH"
			;(nil).reward = reward
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			;(nil).eventID = gActivityTimeActivityID.RED_PACKAGE_ACTIVITY
			SoraDSendMessage(nil)
		elseif ret.err == gErrDef.Err_RED_PACKAGEA_CTIVITY_NOT_FOUND_TASKID then
		elseif ret.err == gErrDef.Err_RED_PACKAGEA_CTIVITY_NOT_FINISH then
		elseif ret.err == gErrDef.Err_RED_PACKAGEA_CTIVITY_ALREADY_RECEIVE then
		end
	end
end
function redPackageActivityCtrl:getReceiveStatusAndNum()
	local num = 0
	local allTaskID = self:getAllTaskID()
	for _, taskID in ipairs(allTaskID) do
		if self:isCanReceive(taskID) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function redPackageActivityCtrl:isCanReceive(taskID)
	local ret = false
	local data = self:getInfoByTaskID(taskID)
	if data and data.received == false and data.taskFinish >= data.taskMax then
		ret = true
	end
	return ret
end
function redPackageActivityCtrl:getInfoByTaskID(taskID)
	if not self.taskInfo then
		_ENV = self.taskInfo
	end
	self.taskInfo = self.taskInfo
	return self.taskInfo[tostring(taskID)]
end
function redPackageActivityCtrl:getAllTaskID()
	if not self.allTaskID then
		local _ENV, ret = self.allTaskID, self.allTaskID
		if self.taskInfo then
			for id, value in pairs(self.taskInfo) do
				table.insert(ret, tonumber(id))
			end
			table.sort(ret, function(a, b)
				return a < b
			end)
		end
		self.allTaskID = ret
	end
	return self.allTaskID
end
return redPackageActivityCtrl
