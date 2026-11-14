local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local gamemodulec = include("GameModule")
local timeCtrl = class("timeCtrl", gamemodulec)
timeCtrl.REQ_SERVERTIME_BACK = "REQ_SERVERTIME_BACK"
function timeCtrl:ctor(properties)
	timeCtrl.super.ctor(self, properties)
	self:resetData()
end
function timeCtrl:resetData()
	self.serverTime = 0
	self.dttime = 0
	self.lasttime = os.time()
	self.handle_notify = nil
end
function timeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TIME_MODULE, gCmd.REQ_SERVER_TIME, handler(self, self.getServerTimeRsp))
end
function timeCtrl:Logout()
	timeCtrl.super.Logout(self)
	self:resetData()
end
function timeCtrl:update(dttime)
	self.dttime = os.time() - self.lasttime
end
function timeCtrl:getServerTime()
	local ret = self.serverTime + self.dttime
	return ret
end
function timeCtrl:updateServerTime(time)
	self.dttime = 0
	self.lasttime = os.time()
	self.serverTime = time
end
function timeCtrl:getServerTimeReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TIME_MODULE, gCmd.REQ_SERVER_TIME, nil, ...)
end
function timeCtrl:getServerTimeRsp(content)
	local err = content.err
	local data = content.data
	if err == gErrDef.Err_None then
		self.dttime = 0
		self.lasttime = os.time()
		self.serverTime = data.time
		_ENV = nil
		;(nil).msg = "MESSAGE_MAIN_SERVERTIME_CALLBAK"
		;(nil).otherData = content.clientData
		SoraDSendMessage(nil)
	end
end
function timeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TIME, handler(self, self.updateData))
end
function timeCtrl:updateData(event)
	local data = event.data
	for k, v in pairs(data) do
		self:updateServerTime(v.time)
	end
end
function timeCtrl:initClientData(data)
	self.dttime = 0
	self.lasttime = os.time()
	self.serverTime = data
	self:registerNotify()
end
return timeCtrl
