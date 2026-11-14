local gamemodulec = include("GameModule")
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local linkCtrl = class("linkCtrl", gamemodulec)
linkCtrl.EVENT_HEARTBEAT_TIMEOUT = "HEARTBEAT_TIMEOUT_EVENT"
linkCtrl.EVENT_SWITCH = "SWITCH_EVENT"
function linkCtrl:ctor(properties)
	linkCtrl.super.ctor(self, properties)
	local serverproxy = gModuleMgr.getObject("serverproxy")
	self.needCheckHeartbeat = true
	self.frontTime = 0
	self.switchSN = 1
end
function linkCtrl:onInvChange(outInType)
	print("linkCtrl:onInvChange(outInType)", outInType)
	if not self.timer then
		return
	end
	self.lastMsgReciveTime = os.time()
	self.lastMsgSendTime = os.time()
	if outInType == GOTO_FOREG_GROUD then
		self.needCheckHeartbeat = true
		self.frontTime = os.time()
		self.switchSN = self.switchSN + 1
		self:sendHeartbeatSwitch(self.needCheckHeartbeat, self.switchSN)
		self.lastMsgReciveTime = os.time()
		self.lastMsgSendTime = os.time()
		local diffTime = gConstValue.HEARTBEAT_INV - gConstValue.SWITCH_CHECK_TIME
		if diffTime < 0 then
			diffTime = 0
		end
		self.lastMsgReciveTime = self.lastMsgReciveTime - gConstValue.HEARTBEAT_INV * (gConstValue.HEARTBEAT_TIMEOUT_TIMES - 1) - diffTime
		self.lastMsgSendTime = self.lastMsgSendTime - gConstValue.HEARTBEAT_INV * (gConstValue.HEARTBEAT_TIMEOUT_TIMES - 1) - diffTime
		self:removeTimer()
		self.timer = SoradCreateTimer(self, handler(self, self.checkLinkTimeout))
		serviceFunctions.print("Enter Foreg")
	elseif outInType == GOTO_BACK_GROUD then
		self.needCheckHeartbeat = false
		self.frontTime = 0
		self:sendHeartbeatSwitch(self.needCheckHeartbeat)
	end
	_ENV = self.needCheckHeartbeat
	_ENV, self.needCheckHeartbeat.name = linkCtrl.EVENT_SWITCH, linkCtrl.EVENT_SWITCH
	self.needCheckHeartbeat.data, linkCtrl.EVENT_SWITCH.isForeground = linkCtrl.EVENT_SWITCH, self.needCheckHeartbeat
	self:dispatchEvent(self.needCheckHeartbeat)
end
function linkCtrl:onMsgRecive()
	self.lastMsgReciveTime = os.time()
end
function linkCtrl:onMsgSend()
	self.lastMsgSendTime = os.time()
end
function linkCtrl:checkLinkTimeout()
	if not self.needCheckHeartbeat then
		return
	end
	local curTime = os.time()
	if self.frontTime > 0 and curTime - self.frontTime >= gConstValue.SWITCH_CHECK_TIME then
		serviceFunctions.print("front self:dispatchEvent({name = linkCtrl.EVENT_HEARTBEAT_TIMEOUT})")
		_ENV = nil
		;(nil).name = linkCtrl.EVENT_HEARTBEAT_TIMEOUT
		self:dispatchEvent(nil)
		return
	end
	if curTime - self.lastMsgSendTime >= gConstValue.HEARTBEAT_INV then
		self:sendHeartbeat()
	end
	if curTime - self.lastMsgReciveTime >= gConstValue.HEARTBEAT_INV * gConstValue.HEARTBEAT_TIMEOUT_TIMES then
		serviceFunctions.print("self:dispatchEvent({name = linkCtrl.EVENT_HEARTBEAT_TIMEOUT})")
		_ENV = gConstValue.HEARTBEAT_TIMEOUT_TIMES
		gConstValue.HEARTBEAT_TIMEOUT_TIMES.name = linkCtrl.EVENT_HEARTBEAT_TIMEOUT
		self:dispatchEvent(gConstValue.HEARTBEAT_TIMEOUT_TIMES)
	end
end
function linkCtrl:sendHeartbeat()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HEARTBEAT_MODULE, gCmd.REQ_HEARTBEAT, nil)
end
function linkCtrl:sendHeartbeatSwitch(switch, sn)
	serverproxy = nil
	;(nil).switch = switch
	;(nil).sn = sn
	serverproxy:Request(gCmd.CMD_HEARTBEAT_MODULE, gCmd.REQ_HEARTBEAT_SWITCH, nil)
end
function linkCtrl:reqHeartbeatRsp()
end
function linkCtrl:reqHeartbeatSwitchRsp(content)
	dump(content, "content=")
	local data = content.data
	if data.switch == true and data.sn == self.switchSN then
		self.frontTime = 0
		print("data.sn == self.switchSN", self.switchSN)
	end
end
function linkCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HEARTBEAT_MODULE, gCmd.REQ_HEARTBEAT, handler(self, self.reqHeartbeatRsp))
	msgCtrl.register(gCmd.CMD_HEARTBEAT_MODULE, gCmd.REQ_HEARTBEAT_SWITCH, handler(self, self.reqHeartbeatSwitchRsp))
	serverproxy:addEventListener(serverproxy.EVENT_GATE_MSG_SEND, handler(self, self.onMsgSend))
	self.lastMsgReciveTime = os.time()
	self.lastMsgSendTime = os.time()
	self.needCheckHeartbeat = true
	self.needCheckHea = 0
	self:removeTimer()
	self.timer = SoradCreateTimer(self, handler(self, self.checkLinkTimeout))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.FORCE_LOGOUT, handler(self, self.onNotifySyncLogout))
end
function linkCtrl:resetData()
	self.needCheckHeartbeat = true
	self.frontTime = 0
end
function linkCtrl:onNotifySyncLogout(event)
	local data = event.data
	if data then
		userSDKManager_sdkOpenCallBack()
	end
end
function linkCtrl:Logout()
	linkCtrl.super.Logout(self)
	print("linkCtrl:Logout()")
	self:removeTimer()
	self:resetData()
end
function linkCtrl:removeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
return linkCtrl
