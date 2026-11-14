local loginCtrl = class("loginCtrl")
loginCtrl.GAME_ENTER = "LOGINCTRL_GAME_ENTER"
loginCtrl.GAME_REJECTED = "LOGINCTRL_GAME_REJECTED"
loginCtrl.GAME_DISCONNECTED = "LOGINCTRL_GAME_DISCONNECTED"
loginCtrl.SERVER_MAINTAINCE = "LOGINCTRL_SERVER_MAINTAINCE"
loginCtrl.BE_SEALED = "LOGINCTRL_BE_SEALED"
loginCtrl.BE_VERSION_ERROR = "BE_VERSION_ERROR"
_ENV, loginCtrl.ctor = function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end, function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end
;(function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end).user = "3rdid"
;(function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end).pass = "password"
loginCtrl.token, (function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end).subtoken = function(self)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	local login = include("login")
	self.login_ = login.new()
	self.login_:addEventListener(login.LOGIN_SUCCESS, handler(self, self.loginSuccess))
	self.login_:addEventListener(login.LOGIN_FAILED, handler(self, self.loginFailed))
	self.login_:addEventListener(login.LOGIN_DISCONNECTED, handler(self, self.loginDisconnected))
	self.login_:addEventListener(login.SERVER_MAINTAINCE, handler(self, self.serverMaintaince))
	self.login_:addEventListener(login.BE_SEALED, handler(self, self.beSealed))
	self.login_:addEventListener(login.BE_VERSION_ERROR, handler(self, self.versionError))
end, "testsubtoken"
loginCtrl.index = 1
function loginCtrl:connectLogin(host, port)
	if userSDKManager.authId then
		loginCtrl.token.subtoken = userSDKManager.authId
	end
	self.login_:initSocket()
	self.login_:connectLogin(host, port, loginCtrl.token)
end
function loginCtrl:Logout()
	self.login_:disconnectLogin()
	self.gate_:Logout()
end
function loginCtrl:loginSuccess()
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.connect_login_success, nil)
	print("=====loginCtrl:loginSuccess=====")
	local serverproxy = gModuleMgr.getObject("serverproxy")
	local gate = serverproxy.gate_
	self.gate_ = gate
	self.gate_:addEventListener(gate.GATE_CONNECT_PORT_SUCCESS, handler(self, self.gatePortSuccess))
	self.gate_:addEventListener(gate.GATE_HANDSHAKE_SUCCESS, handler(self, self.gateHandshakeSuccess))
	self.gate_:addEventListener(gate.GATE_FAILED, handler(self, self.gateFailed))
	self.gate_:addEventListener(gate.GATE_DISCONNECTED, handler(self, self.gateConnected))
	_ENV = gate.GATE_DISCONNECTED
	userSDKManager.logEvent(gSDKDef.TDonEvent.connect_server, gate.GATE_DISCONNECTED)
	self.gate_:initSocket()
	self.gate_:connectGate(self.login_.gateip, self.login_.gateport)
end
function loginCtrl:loginFailed(event)
	print("=====loginCtrl:loginfailed=====")
	_ENV = nil
	;(nil).name = loginCtrl.GAME_REJECTED
	;(nil).failedType = event.failedType
	self:dispatchEvent(nil)
end
function loginCtrl:serverMaintaince(event)
	print("=====loginCtrl:serverMaintaince=====")
	local kid = event.kid
	local serverTime = event.serverTime
	_ENV = nil
	;(nil).name = loginCtrl.SERVER_MAINTAINCE
	;(nil).kid = kid
	;(nil).serverTime = serverTime
	self:dispatchEvent(nil)
end
function loginCtrl:loginDisconnected()
	print("=====loginCtrl:loginDisconnected=====")
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.connect_login_fail, nil)
	_ENV = nil
	;(nil).name = loginCtrl.GAME_DISCONNECTED
	self:dispatchEvent(nil)
end
function loginCtrl:beSealed(event)
	print("=====loginCtrl:beSealed=====")
	local sealType = event.sealType
	_ENV = nil
	;(nil).name = loginCtrl.BE_SEALED
	;(nil).sealType = sealType
	self:dispatchEvent(nil)
end
function loginCtrl:versionError()
	print("=====loginCtrl:versionError=====")
	_ENV = nil
	;(nil).name = loginCtrl.BE_VERSION_ERROR
	self:dispatchEvent(nil)
end
function loginCtrl:gatePortSuccess()
	print("=====loginCtrl:gatePortSuccess=====")
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.connect_server_success, nil)
	local servername = self.login_.servername
	local uid = self.login_.uid
	local subid = self.login_.subid
	local secret = self.login_.secret
	local index = self.index
	self.gate_:handshake(servername, uid, subid, secret, index)
end
function loginCtrl:gateHandshakeSuccess()
	print("=====loginCtrl:gateHandshakeSuccess=====")
	_ENV = nil
	;(nil).name = loginCtrl.GAME_ENTER
	self:dispatchEvent(nil)
end
function loginCtrl:gateFailed()
	print("=====loginCtrl:gateFailed=====")
	_ENV = nil
	;(nil).name = loginCtrl.GAME_REJECTED
	self:dispatchEvent(nil)
end
function loginCtrl:gateConnected()
	print("=====loginCtrl:gateDisConnected=====")
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.connect_server_fail, nil)
	_ENV = nil
	;(nil).name = loginCtrl.GAME_DISCONNECTED
	self:dispatchEvent(nil)
end
function loginCtrl:onGameLoginTimeout()
	print("=====loginCtrl:onGameLoginTimeout=====")
	self.login_:onGameLoginTimeout()
	if self.gate_ then
		self.gate_:onGameLoginTimeout()
	end
end
return loginCtrl
