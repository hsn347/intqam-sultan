local ServerProxy = class("ServerProxy", cc.mvc.ModelBase)
ServerProxy.EVENT_GAME_REJECTED = "SERVERPROXY_GAME_REJECTED_EVENT"
ServerProxy.EVENT_GAME_ENTERED = "SERVERPROXY_GAME_ENTERED_EVENT"
ServerProxy.EVENT_SERVER_DISCONNECTED = "SERVERPROXY_SERVER_DISCONNECTED_EVENT"
ServerProxy.EVENT_PLAYER_KICKEDOFF = "SERVERPROXY_PLAYER_KICKEDOFF_EVENT"
ServerProxy.EVENT_GATE_MSG_SEND = "SERVERPROXY_GATE_MSG_SEND_EVENT"
ServerProxy.EVENT_SERVER_MAINTAINCE = "SERVERPROXY_SERVER_MAINTAINCE_EVENT"
ServerProxy.EVENT_BE_SEALED = "SERVERPROXY_BE_SEALED_EVENT"
ServerProxy.EVENT_VERSION_ERROR = "SERVERPROXY_VERSION_ERROR_EVENT"
ServerProxy.schema = clone(cc.mvc.ModelBase.schema)
_UPVALUE1_ = cc.mvc.ModelBase.schema
ServerProxy.schema.server, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "string"
_UPVALUE2_ = cc.mvc.ModelBase.schema
ServerProxy.schema.port, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "number"
ServerProxy.schema.port, cc.mvc.ModelBase.schema[2] = cc.mvc.ModelBase.schema, 0
function ServerProxy:ctor(properties)
	ServerProxy.super.ctor(self, properties)
	self.session = 0
	local loginCtrl = include("loginCtrl")
	self.loginCtrl_ = loginCtrl.new()
	self.loginCtrl_:addEventListener(loginCtrl.GAME_ENTER, handler(self, self.gameEnter))
	self.loginCtrl_:addEventListener(loginCtrl.GAME_REJECTED, handler(self, self.gameRejected))
	self.loginCtrl_:addEventListener(loginCtrl.GAME_DISCONNECTED, handler(self, self.gameDisconnected))
	self.loginCtrl_:addEventListener(loginCtrl.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.loginCtrl_:addEventListener(loginCtrl.BE_SEALED, handler(self, self.beSealed))
	self.loginCtrl_:addEventListener(loginCtrl.BE_VERSION_ERROR, handler(self, self.versionError))
	local gate = include("gate")
	self.gate_ = gate.new()
	self.isGameStoped = false
end
function ServerProxy:IsNeedRefreshUserAccount()
	return false
end
function ServerProxy:ConnectServer()
	userSDKManager.timeInfo.t_login.tbegin = SoraDGetSocketTime()
	local ip = gSvrConfig.ip
	if not gIsReviewGameSever and gWebCallGameSeverIP ~= nil then
		ip = gWebCallGameSeverIP
	end
	self.isGameStoped = false
	self.loginCtrl_:connectLogin(ip, gSvrConfig.loginPort)
end
function ServerProxy:RequestLoginInitData(...)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LOGIN_DATA_INIT
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_LOGIN_DATA_INIT, gCmd.REQ_LOGIN_DATA_INIT, gCmd.REQ_LOGIN_DATA_INIT
	local msg
	local clientData = (...)
	if clientData then
		msg.clientData = clientData
	end
	if self.isGameStoped then
		return
	end
	local session = 0
	self.gate_:sendrequest(msg, session)
	_ENV = msg
	msg.name = ServerProxy.EVENT_GATE_MSG_SEND
	self:dispatchEvent(msg)
end
function ServerProxy:SendMsg(msg)
	qaDump(msg, "Request", 10)
	if self.isGameStoped then
		return
	end
	local session
	if msg.cmd == gCmd.CMD_NOTIFY_MODULE and (msg.subcmd == gCmd.NOTIFY_MAP_DATA or msg.subcmd == gCmd.NOTIFY_WORLD_UPDATE) then
		session = 0
	else
		self.session = self.session + 1
		session = self.session
	end
	self.gate_:sendrequest(msg, session)
	_ENV = msg
	msg.name = ServerProxy.EVENT_GATE_MSG_SEND
	self:dispatchEvent(msg)
end
function ServerProxy:Request(cmd_, subcmd_, data_, ...)
	_UPVALUE0_ = nil
	;(nil).cmd = cmd_
	;(nil).subcmd = subcmd_
	local (nil).data, msg = data_, nil
	local clientData = (...)
	if clientData then
		msg.clientData = clientData
	end
	self:SendMsg(msg)
end
function ServerProxy:Logout()
	self.loginCtrl_:Logout()
end
function ServerProxy:Stop()
	self.isGameStoped = true
end
function ServerProxy:gameEnter()
	serviceFunctions.print("SP:gameEnter")
	local uid = self.loginCtrl_.login_.uid
	local kid = self.loginCtrl_.login_.kingdomId
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_GAME_ENTERED
	;(nil).uid = uid
	;(nil).kid = kid
	self:dispatchEvent(nil)
end
function ServerProxy:gameRejected(event)
	serviceFunctions.print("SP:gameRejected")
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_GAME_REJECTED
	;(nil).failedType = event.failedType
	self:dispatchEvent(nil)
end
function ServerProxy:serverMaintaince(event)
	serviceFunctions.print("SP:serverMaintaince")
	local kid = event.kid
	local serverTime = event.serverTime
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_SERVER_MAINTAINCE
	;(nil).kid = kid
	;(nil).serverTime = serverTime
	self:dispatchEvent(nil)
end
function ServerProxy:beSealed(event)
	serviceFunctions.print("SP:beSealed")
	local sealType = event.sealType
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_BE_SEALED
	;(nil).sealType = sealType
	self:dispatchEvent(nil)
end
function ServerProxy:versionError()
	serviceFunctions.print("SP:versionError")
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_VERSION_ERROR
	self:dispatchEvent(nil)
end
function ServerProxy:gameDisconnected()
	serviceFunctions.print("SP:gameDisconnected")
	_ENV = nil
	;(nil).name = ServerProxy.EVENT_SERVER_DISCONNECTED
	self:dispatchEvent(nil)
end
function ServerProxy:onGameLoginTimeout()
	serviceFunctions.print("SP:onGameLoginTimeout")
	self.loginCtrl_:onGameLoginTimeout()
end
return ServerProxy
