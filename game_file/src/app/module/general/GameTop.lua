local GameTop = class("GameTop", cc.mvc.ModelBase)
local socket = require("socket")
GameTop.EVENT_GAMESTART = "GAMETOP_GAMESTART_EVENT"
GameTop.STATE_LOGIN = "GAMETOP_LOGIN_STATE"
GameTop.schema = clone(cc.mvc.ModelBase.schema)
function GameTop:ctor(properties)
	GameTop.super.ctor(self, properties)
	cc(self):addComponent("components.behavior.StateMachine")
	GameTop, _UPVALUE10_, self.fsm__ = self, self:getComponent("components.behavior.StateMachine"), self:getComponent("components.behavior.StateMachine")
	self.name = "start"
	self.from = "none"
	GameTop, self.to = "components.behavior.StateMachine", "idle"
	_UPVALUE4_, ("components.behavior.StateMachine").name = nil, "idretrieve"
	;("components.behavior.StateMachine").from, (nil)[1] = nil, "idle"
	;("components.behavior.StateMachine").from, (nil)[2] = nil, "berejected"
	;("components.behavior.StateMachine").from, (nil)[3] = nil, "bedisconnected"
	;("components.behavior.StateMachine").from, (nil)[4] = nil, "bekickedoff"
	GameTop, ("components.behavior.StateMachine").to = nil, "idwaiting"
	_UPVALUE5_, (nil).name = "idle", "idready"
	;(nil).from, ("idle")[1] = "idle", "idle"
	;(nil).from, ("idle")[2] = "idle", "idwaiting"
	;(nil).from, ("idle")[3] = "idle", "berejected"
	;(nil).from, ("idle")[4] = "idle", "bedisconnected"
	;(nil).from, ("idle")[5] = "idle", "bekickedoff"
	GameTop, (nil).to = "idle", "gamelogin"
	_ENV, ("idle").name = "idle", "entergame"
	;("idle").from, ("idle")[1] = "idle", "gamelogin"
	GameTop, ("idle").to = "idle", "gaming"
	_ENV, ("idle").name = "gamelogin", "rejected"
	;("idle").from, ("gamelogin")[1] = "gamelogin", "gamelogin"
	GameTop, ("idle").to = "gamelogin", "berejected"
	socket, ("gamelogin").name = "gamelogin", "disconnected"
	;("gamelogin").from, ("gamelogin")[1] = "gamelogin", "gamelogin"
	;("gamelogin").from, ("gamelogin")[2] = "gamelogin", "gaming"
	GameTop, ("gamelogin").to = "gamelogin", "bedisconnected"
	socket, ("gamelogin").name = "gamelogin", "kickedoff"
	;("gamelogin").from, ("gamelogin")[1] = "gamelogin", "gamelogin"
	;("gamelogin").from, ("gamelogin")[2] = "gamelogin", "gaming"
	GameTop, ("gamelogin").to = "gamelogin", "bekickedoff"
	_UPVALUE3_, ("gamelogin").name = "gamelogin", "logout"
	;("gamelogin").from, ("gamelogin")[1] = "gamelogin", "gaming"
	;("gamelogin").from, ("gamelogin")[2] = "gamelogin", "bekickedoff"
	;("gamelogin").from, ("gamelogin")[3] = "gamelogin", "gamelogin"
	GameTop, ("gamelogin").to = "gamelogin", "idle"
	_ENV, ("gamelogin").name = "gaming", "maintenance"
	;("gamelogin").from, ("gaming")[1] = "gaming", "gamelogin"
	GameTop, ("gamelogin").to = "gaming", "idle"
	_ENV, ("gaming").name = "gamelogin", "versionerror"
	;("gaming").from, ("gamelogin")[1] = "gamelogin", "gamelogin"
	;("gaming").to = "idle"
	GameTop, self:getComponent("components.behavior.StateMachine")[1] = self, self
	GameTop, self:getComponent("components.behavior.StateMachine")[2] = self, "components.behavior.StateMachine"
	GameTop, self:getComponent("components.behavior.StateMachine")[3] = self
	GameTop, self:getComponent("components.behavior.StateMachine")[4] = self, "idle"
	GameTop, self:getComponent("components.behavior.StateMachine")[5] = self, "idle"
	GameTop, self:getComponent("components.behavior.StateMachine")[6] = self, "gamelogin"
	GameTop, self:getComponent("components.behavior.StateMachine")[7] = self, "gamelogin"
	GameTop, self:getComponent("components.behavior.StateMachine")[8] = self, "gamelogin"
	GameTop, self:getComponent("components.behavior.StateMachine")[9] = self, "gamelogin"
	local GameTop, self:getComponent("components.behavior.StateMachine")[10], defaultEvents = self, "gaming", self:getComponent("components.behavior.StateMachine")
	self.onstart = handler(self, self.onStart_)
	self.ongamelogin = handler(self, self.onGameLogin_)
	self.ongaming = handler(self, self.onGaming_)
	self.onberejected = handler(self, self.onBeRejected_)
	self.onbedisconnected = handler(self, self.onBeDisconnected_)
	local self.onbekickedoff, defaultCallbacks = handler(self, self.onBeKickedoff_), self
	GameTop = self.onBeKickedoff_
	self.onBeKickedoff_.events = defaultEvents
	self.onBeKickedoff_.callbacks = defaultCallbacks
	self.fsm__:setupState(self.onBeKickedoff_)
	local serverproxyc = include("ServerProxy")
	local serverproxy = gModuleMgr.getObject("serverproxy")
	self.serverproxy_ = serverproxy
	self.serverproxy_:addEventListener(serverproxyc.EVENT_GAME_REJECTED, handler(self, GameTop.Rejected))
	self.serverproxy_:addEventListener(serverproxyc.EVENT_GAME_ENTERED, handler(self, GameTop.EnterGame))
	self.serverproxy_:addEventListener(serverproxyc.EVENT_SERVER_DISCONNECTED, handler(self, GameTop.Disconnected))
	self.serverproxy_:addEventListener(serverproxyc.EVENT_SERVER_MAINTAINCE, handler(self, GameTop.serverMaintaince))
	self.serverproxy_:addEventListener(serverproxyc.EVENT_BE_SEALED, handler(self, GameTop.beSealed))
	self.serverproxy_:addEventListener(serverproxyc.EVENT_VERSION_ERROR, handler(self, GameTop.versionError))
	self.startLoginTime = socket.gettime()
	self.fsm__:doEvent("start")
end
function GameTop:StartGame()
	self.startLoginTime = socket.gettime()
	serviceFunctions.print("GT:StartGame()")
	release_print("gametop start game ")
	if self.serverproxy_:IsNeedRefreshUserAccount() then
		self.fsm__:doEvent("idretrieve")
	else
		self.fsm__:doEvent("idready")
	end
end
function GameTop:Logout()
	serviceFunctions.print("GT:Logout()")
	if self.playertop_ then
		self.playertop_:Logout()
		self.fsm__:doEventForce("logout")
	else
	end
end
function GameTop:GetState()
	local state = self.fsm__:getState()
	if state == "idle" then
	elseif state == "idwaiting" then
	end
end
function GameTop:onStart_(event)
	serviceFunctions.print("GT:onStart_ fsmstate=", self.fsm__:getState())
end
function GameTop:onGameLogin_(event)
	serviceFunctions.print("GT:onGameLogin_ fsmstate=", self.fsm__:getState())
	self.serverproxy_:ConnectServer()
	self:removeGameLoginTimer()
	self.timerCheckTimeout = SoradCreateTimer(self, handler(self, self.checkGameLoginTimeout))
end
function GameTop:onGaming_(event)
	serviceFunctions.print("GT:onGaming_ fsmstate=", self.fsm__:getState())
	local uid = event.args[1].uid
	local kid = event.args[1].kid
	local PlayerTopC = include("PlayerTop")
	if not self.playertop_ then
		self.playertop_ = PlayerTopC.new()
	end
	self.playertop_:addEventListener(PlayerTopC.EVENT_HEARTBEAT_TIMEOUT, handler(self, self.onHeartbeatTimeOut))
	self.playertop_:setPlayerID(uid)
	self.playertop_:setKingdomID(kid)
	self.playertop_:EnterGame()
	self:registerServeStatus()
end
function GameTop:registerServeStatus()
	local notifyCtrl = self.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.SERVER_STATUS, handler(self, self.onServerStatus))
end
function GameTop:onBeKickedoff_(event)
	serviceFunctions.print("GT:onBeKickedoff_ fsmstate=", self.fsm__:getState())
end
function GameTop:onBeDisconnected_(event)
	serviceFunctions.print("GT:onBeDisconnected_ fsmstate=", self.fsm__:getState())
end
function GameTop:onBeRejected_(event)
	serviceFunctions.print("GT:onBeRejected_ fsmstate=", self.fsm__:getState())
end
function GameTop:EnterGame(event)
	serviceFunctions.print("GT:EnterGame fsmstate=", self.fsm__:getState())
	local uid = event.uid
	local kid = event.kid
	_ENV = self.fsm__:getState()
	self.fsm__:getState().uid = uid
	self.fsm__:getState().kid = kid
	self.fsm__:doEvent("entergame", self.fsm__:getState())
end
function GameTop:Rejected(event)
	serviceFunctions.print("GT:Rejected fsmstate=", self.fsm__:getState())
	self.fsm__:doEvent("rejected")
	self:Logout()
	_ENV = self
	self.msg = "MESSAGE_MAINSCEN_LOGINFAIL"
	self.type = event.failedType
	SoraDSendMessage(self, nil)
end
function GameTop:KickedOff()
	serviceFunctions.print("GT:KickedOff fsmstate=", self.fsm__:getState())
	self.fsm__:doEvent("kickedoff")
end
function GameTop:Disconnected()
	serviceFunctions.print("GT:Disconnected fsmstate=", self.fsm__:getState())
	local oldState = self.fsm__:getState()
	self.fsm__:doEvent("disconnected")
	if oldState == "gaming" then
		local isInGame = self.playertop_ and self.playertop_:IsInitDataReady() or false
		self:Logout()
		serviceFunctions.print("GT:Disconnected isInGame=", isInGame)
		self:sendGamingErrorMsg(isInGame, 1)
	elseif oldState ~= "idle" then
		if oldState == "gamelogin" then
			local isNetworkOk = network.isHostNameReachable(gConstValue.network_test_host)
			if not isNetworkOk then
				serviceFunctions.print("client network is not ok")
				self:Logout()
				_ENV = self
				self.msg = "MESSAGE_MAINSCEN_LOGINFAIL"
				self.type = gLoginFailTypeDef.loginFailType_client
				SoraDSendMessage(self, nil)
			else
				serviceFunctions.print("loginserver is not ok")
				self:Logout()
				local isServerNetworkOk = network.isHostNameReachable(gSvrConfig.ip)
				if not isServerNetworkOk then
					_ENV = nil
					;(nil).msg = "MESSAGE_MAINSCEN_LOGINFAIL"
					;(nil).type = gLoginFailTypeDef.loginFailType_server
					SoraDSendMessage(nil, nil)
				else
					_ENV = nil
					;(nil).msg = "MESSAGE_MAINSCEN_LOGINFAIL"
					;(nil).type = gLoginFailTypeDef.loginFailType_startLogin
					SoraDSendMessage(nil, nil)
				end
			end
		else
			local isInGame = self.playertop_ and self.playertop_:IsInitDataReady() or false
			self:Logout()
			self:sendGamingErrorMsg(isInGame, 2)
		end
	end
end
function GameTop:serverMaintaince(event)
	serviceFunctions.print("GT:serverMaintaince()")
	self.fsm__:doEvent("maintenance")
	self:Logout()
	local kid = tonumber(event.kid)
	local serverTime = event.serverTime
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_LOGINFAIL"
	;(nil).type = gLoginFailTypeDef.loginFailType_server
	;(nil).kid = kid
	;(nil).serverTime = serverTime
	SoraDSendMessage(nil, nil)
end
function GameTop:beSealed(event)
	serviceFunctions.print("GT:beSealed")
	local sealType = event.sealType
	self:KickedOff()
	self:Logout()
	_ENV = self
	self.msg = "MESSAGE_MAINSCEN_SOCKET_KICKOUT"
	self.type = gUserKickOutTypeDef.userKickOutType_accountBeClosed
	self.sealType = sealType
	SoraDSendMessage(self)
end
function GameTop:versionError()
	serviceFunctions.print("GT:versionError")
end
function GameTop:onServerStatus(event)
	local msg = event.data
	for i = 1, #msg do
		local data = msg[i]
		local status = data.status
		serviceFunctions.print("GT:onServerStatus", self.fsm__:getState())
		if status == "kick" then
			self.serverproxy_:Stop()
			self:KickedOff()
			self:Logout()
			_ENV = self
			self.msg = "MESSAGE_MAINSCEN_SOCKET_KICKOUT"
			self.type = gUserKickOutTypeDef.userKickOutType_otherDeviceLogin
			SoraDSendMessage(self)
		elseif status == "seal" then
			local sealType = data.sealType
			self.serverproxy_:Stop()
			self:KickedOff()
			self:Logout()
			_ENV = self
			self.msg = "MESSAGE_MAINSCEN_SOCKET_KICKOUT"
			self.type = gUserKickOutTypeDef.userKickOutType_accountBeClosed
			self.sealType = sealType
			self.isOnline = true
			SoraDSendMessage(self)
		elseif status == "server_maintenance" then
			self.serverproxy_:Stop()
			self:KickedOff()
			self:Logout()
			_ENV = self
			self.msg = "MESSAGE_MAINSCEN_SOCKET_KICKOUT"
			self.type = gUserKickOutTypeDef.userKickOutType_serverRepair
			SoraDSendMessage(self)
		end
	end
end
function GameTop:onHeartbeatTimeOut()
	self.fsm__:doEvent("disconnected", self.fsm__:getState())
	local isInGame = self.playertop_ and self.playertop_:IsInitDataReady() or false
	serviceFunctions.print("GT:onHeartbeatTimeOut() isInGame=", isInGame)
	self:Logout()
	self:sendGamingErrorMsg(isInGame, 3)
end
function GameTop:checkGameLoginTimeout()
	serviceFunctions.print("GT:checkGameLoginTimeout()")
	if self.fsm__:getState() ~= "gamelogin" then
		self:removeGameLoginTimer()
	else
		self.gameLoginUsedTime = self.gameLoginUsedTime + 1
		if self.gameLoginUsedTime > gConstValue.GAME_LOGIN_TIME_OUT then
			serviceFunctions.print("gamelogin timeout", self.gameLoginUsedTime)
			self:removeGameLoginTimer()
			self.serverproxy_:onGameLoginTimeout()
			self.fsm__:doEvent("disconnected", self.fsm__:getState())
			self:Logout()
			_ENV = self
			self.msg = "MESSAGE_MAINSCEN_LOGINFAIL"
			self.type = gLoginFailTypeDef.loginFailType_startLogin
			SoraDSendMessage(self, nil)
		end
	end
end
function GameTop:removeGameLoginTimer()
	if self.timerCheckTimeout then
		SoraDManagerRemoveTimer(self, self.timerCheckTimeout)
		self.timerCheckTimeout = nil
	end
	self.gameLoginUsedTime = 0
end
function GameTop:sendGamingErrorMsg(isInGame, loginagainTag)
	if self.playertop_ then
		if isInGame then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_LOGINAGAIN"
			;(nil).loginagainTag = loginagainTag
			SoraDSendMessage(nil, nil)
		else
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_LOGINFAIL"
			;(nil).type = gLoginFailTypeDef.loginFailType_getUserInfo
			SoraDSendMessage(nil, nil)
		end
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_LOGINAGAIN"
		;(nil).loginagainTag = loginagainTag
		SoraDSendMessage(nil, nil)
	end
end
return GameTop
