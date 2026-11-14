local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local guardianRead = include("guardianRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local guardianCtrl = class("guardianCtrl", GameModule)
function guardianCtrl:ctor(properties)
	guardianCtrl.super.ctor(self, properties)
end
function guardianCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_RECEIVE, handler(self, self.sendReqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_SHOW, handler(self, self.sendReqInitRsp))
	self:resetData()
	self:registerNotify()
end
function guardianCtrl:Logout()
	self:resetData()
	guardianCtrl.super.Logout(self)
end
function guardianCtrl:initClientData(content)
	dump(content, "==guardianCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.activityData = content
end
function guardianCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function guardianCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GUARD_ACTIVITY, handler(self, self.notifyCallback))
end
function guardianCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "==guardianCtrl:notifyCallback==", 20)
			self.activityData = content.initData
			_ENV = "==guardianCtrl:notifyCallback=="
			;("==guardianCtrl:notifyCallback==").name = gEventName.event_buff_update
			self:dispatchEvent("==guardianCtrl:notifyCallback==")
			_ENV = self
			self.msg = "MESSAGE_GUARDIAN_REFRESH"
			SoraDSendMessage(self)
		end
	end
end
function guardianCtrl:sendReqInitRsp(content)
	dump(content, "==guardianCtrl:sendReqRefreshRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_GUARDIAN_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function guardianCtrl:sendReqGetRewardRsp(content)
	dump(content, "==guardianCtrl:sendReqRefreshRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_GUARDIAN_REFRESH"
		gErrDef.Err_None.reward = content.rspdata.reward
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function guardianCtrl:sendReqInit()
	serverproxy:Request(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_INIT)
end
function guardianCtrl:sendReqShow(data)
	serverproxy:Request(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_SHOW, data)
end
function guardianCtrl:sendReqGetReward(data)
	data, serverproxy = nil, nil
	serverproxy:Request(gCmd.CMD_GUARD_ACTIVITY_MODULE, gCmd.REQ_GUARD_ACTIVITY_RECEIVE, data)
end
function guardianCtrl:getGuardType()
	return self.activityData.guardType or 0
end
function guardianCtrl:getIsCanReceive()
	return self.activityData.isCanReceive or false
end
function guardianCtrl:getIsShow()
	return self.activityData.show or false
end
function guardianCtrl:getLoginDay()
	return self.activityData.cumuLoginDay or 0
end
function guardianCtrl:getBuffEffect(type)
	local buffValue
	if not guardianRead.getProperty(self.activityData.guardType or 0, "buff") then
		local guardianRead, buffData = guardianRead.getProperty(self.activityData.guardType or 0, "buff"), guardianRead.getProperty(self.activityData.guardType or 0, "buff")
	end
	for i, v in ipairs(buffData) do
		local effectType = buffltCtrl:getEffectType(v)
		if effectType == type then
			local effectValue = buffltCtrl:getEffect(v)
			buffValue = (buffValue or 0) + effectValue
		end
	end
	return buffValue
end
return guardianCtrl
