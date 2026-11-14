local net = require("framework.cc.net.init")
local crypt = require("crypt")
local login = class("login")
login.LOGIN_SUCCESS = "LOGIN_SUCCESS"
login.LOGIN_FAILED = "LOGIN_FAILED"
login.LOGIN_DISCONNECTED = "LOGIN_DISCONNECTED"
login.SERVER_MAINTAINCE = "SERVER_MAINTAINCE"
login.BE_SEALED = "BE_SEALED"
login.BE_VERSION_ERROR = "BE_VERSION_ERROR"
login.Err_Login_HandshakeFailed = 400
login.Err_Login_AuthTokenSuccess = 200
login.Err_Login_Unauthorized = 401
login.Err_Login_Forbidden = 403
login.Err_Login_NotAcceptable = 406
login.Err_Login_NotExistServer = 501
login.Err_Login_BeSealed = 502
login.Err_Login_VersionError = 503
login.Err_Login_SDKTokenError = 504
login.Err_Login_SDKUserDelete = 505
local S2C_CHALLENGE = "S2C_CHALLENGE"
local S2C_SERVERKEY = "S2C_SERVERKEY"
local S2C_HANDSHAKE = "S2C_HANDSHAKE"
local S2C_AUTH_TOKEN = "S2C_AUTH_TOKEN"
local S2C_DISCONNECT = "S2C_DISCONNECT"
local NextState = S2C_CHALLENGE
local base64decode = function(str)
	local status, result = xpcall(function()
		return crypt.base64decode(str)
	end, function()
		_G.__G__TRACKBACK__(str)
	end)
	if not status then
		print(str)
	end
	return result
end
function login:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end
function login:initSocket()
	print("=====initSocket=====")
	self:disconnectLogin()
	local socket = net.SocketTCP.new()
	socket:setName("SocketTCP")
	socket:setTickTime(0.01)
	socket:setReconnTime(6)
	socket:setConnFailTime(15)
	socket:addEventListener(socket.EVENT_DATA, handler(self, self.receive))
	socket:addEventListener(socket.EVENT_CLOSE, handler(self, self.tcpClose))
	socket:addEventListener(socket.EVENT_CLOSED, handler(self, self.tcpClosed))
	socket:addEventListener(socket.EVENT_CONNECTED, handler(self, self.tcpConnected))
	socket:addEventListener(socket.EVENT_CONNECT_FAILURE, handler(self, self.failure))
	self.socket = socket
end
function login:connectLogin(host, port, token)
	print("=====login:connectLogin=====", host, port)
	sendReviewLog(string.format("=====login:connectLogin===== %s %s", host, port))
	self.token = token
	self.socket:connect(host, port)
end
function login:sendMsg(text)
	self.socket:send(self:pack(text))
end
function encodetoken(token)
	return string.format("%s@%s:%s", crypt.base64encode(token.user), crypt.base64encode(token.pass), crypt.base64encode(token.subtoken))
end
function login:handleloginmsg(msg)
	if NextState == S2C_CHALLENGE then
		self:S2C_CHALLENGE(msg)
	elseif NextState == S2C_SERVERKEY then
		self:S2C_SERVERKEY(msg)
	elseif NextState == S2C_HANDSHAKE then
		self:S2C_HANDSHAKE(msg)
	elseif NextState == S2C_AUTH_TOKEN then
		self:S2C_AUTH_TOKEN(msg)
	end
end
function login:S2C_CHALLENGE(msg)
	print("=====login:S2C_CHALLENGE=====")
	sendReviewLog("=====login:S2C_SERVERKEY=====")
	self.challenge = base64decode(msg)
	self.clientkey = crypt.randomkey()
	local b64clientkey = crypt.base64encode(crypt.dhexchange(self.clientkey))
	self:sendMsg(b64clientkey)
end
function login:S2C_SERVERKEY(msg)
	print("=====login:S2C_SERVERKEY=====")
	sendReviewLog("=====login:S2C_SERVERKEY=====" .. msg)
	self.secret = crypt.dhsecret(base64decode(msg), self.clientkey)
	local hmac = crypt.hmac64(self.challenge, self.secret)
	local b64encodehmac = crypt.base64encode(hmac)
	self:sendMsg(b64encodehmac)
end
function login:S2C_HANDSHAKE(msg)
	print("=====login:S2C_HANDSHAKE=====")
	sendReviewLog("=====login:S2C_HANDSHAKE=====" .. tostring(msg))
	local code = tonumber(string.sub(msg, 1, 3))
	local submsg = string.sub(msg, 5)
	if code == login.Err_Login_HandshakeFailed then
		self:loginFailed()
	else
		local etoken = crypt.desencode(self.secret, encodetoken(self.token))
		local b64encodetoken = crypt.base64encode(etoken)
		local b64encodeversion = crypt.base64encode(crypt.desencode(self.secret, GAME_VERSION or "NONE"))
		local model, systemPlatform, systemVersion, deviceId, store, packageName = SoraDGetDeviceInfo()
		systemPlatform = tostring(systemPlatform) or "NONE"
		systemVersion = tostring(systemVersion) or "NONE"
		deviceId = tostring(deviceId) or "NONE"
		local callId = userSDKManager.callId or "NONE"
		local plateform = systemPlatform .. " " .. systemVersion .. " " .. deviceId .. " " .. store .. " " .. packageName .. " " .. string.lower(device.language)
		local b64encodeplateform = crypt.base64encode(crypt.desencode(self.secret, plateform or "NONE"))
		local b64encodemodel = crypt.base64encode(crypt.desencode(self.secret, model or "NONE"))
		local carrier = SoraDGetCarrier()
		local b64encodecarrier = crypt.base64encode(crypt.desencode(self.secret, carrier or "NONE"))
		local sendmsg = string.format("%s@%s@%s@%s@%s", b64encodetoken, b64encodeversion, b64encodeplateform, b64encodemodel, b64encodecarrier)
		self:sendMsg(sendmsg)
	end
end
function login:tempConverGateIP()
	if gSvrConfig.ip == "220.249.170.253" then
		self.gateip = "220.249.170.253"
	end
end
function login:S2C_AUTH_TOKEN(msg)
	print("=====login:S2C_AUTH_TOKEN=====", msg)
	sendReviewLog("=====login:S2C_AUTH_TOKEN=====" .. tostring(msg))
	local code = tonumber(string.sub(msg, 1, 3))
	local submsg = string.sub(msg, 5)
	if code == login.Err_Login_AuthTokenSuccess then
		local resultmsg = base64decode(submsg)
		local b64kingdomId, b64servername, b64gateip, b64gateport, b64subid, b64uid = resultmsg:match("([^@]+)@([^@]+)@([^@]+)@([^@]+)@([^@]+)@(.+)")
		self.kingdomId = base64decode(b64kingdomId)
		self.servername = base64decode(b64servername)
		self.gateip = base64decode(b64gateip)
		self.gateport = base64decode(b64gateport)
		self.subid = base64decode(b64subid)
		self.uid = base64decode(b64uid)
		if device.platform == "mac" or userSDKManager.isBeta() then
			self:tempConverGateIP()
		end
		print(string.format("=====login authtoken success=====", self.kingdomId, self.uid, self.gateip, self.gateport))
		sendReviewLog(string.format("=====login authtoken success=====", self.kingdomId, self.uid, self.gateip, self.gateport))
		self:disconnectLogin()
		self:loginSuccess()
	elseif code == login.Err_Login_NotExistServer then
		local _, kid = msg:match("(%d+) (%d+)")
		local serverTime = string.match(msg, "serverTime:(%d+)")
		serverTime = serverTime and tonumber(serverTime)
		self:serverMaintaince(kid, serverTime)
	elseif code == login.Err_Login_BeSealed then
		local _, sealType = msg:match("(%d+) (%d+)")
		sealType = tonumber(sealType)
		self:beSealed(sealType)
	elseif code == login.Err_Login_VersionError then
		self:versionError()
	elseif code == login.Err_Login_SDKUserDelete then
		self:beSealed(gSealAccountType.DEL_ACCOUNT)
	else
		local failedType = gLoginFailTypeDef.loginFailType_startLogin
		if code == login.Err_Login_Unauthorized then
			print("=====验证token失败 登录失败,自定义的auth_handler不认可token=====")
			sendReviewLog("=====验证token失败 登录失败,自定义的auth_handler不认可token=====")
		elseif code == login.Err_Login_Forbidden then
			print("=====验证token失败 登录失败,自定义的login_handler执行失败=====")
			sendReviewLog("=====验证token失败 登录失败,自定义的login_handler执行失败=====")
		elseif code == login.Err_Login_NotAcceptable then
			print("=====验证token失败 登录失败,该用户已经在登陆中(只发生在multilogin关闭时)=====")
			sendReviewLog("=====验证token失败 登录失败,该用户已经在登陆中(只发生在multilogin关闭时)=====")
		elseif code == login.Err_Login_SDKTokenError then
			print("=====验证token失败 登录失败,第三方SDK认证错误====")
			sendReviewLog("=====验证token失败 登录失败,第三方SDK认证错误====")
			failedType = gLoginFailTypeDef.loginFailType_sdkTokenError
		end
		self:loginFailed(failedType)
	end
end
function login:disconnectLogin()
	print("=====login:disconnectLogin=====")
	sendReviewLog("=====login:loginSuccess=====")
	if self.socket then
		self.socket:removeAllEventListeners()
		self.socket:disconnect()
		self.socket = nil
	end
	if self.last then
		self.last = nil
	end
end
function login:unpack_line(text)
	local from = text:find("\n", 1, true)
	if from then
		return text:sub(1, from - 1), text:sub(from + 1)
	end
	return nil, text
end
function login:pack(text)
	local package = text .. "\n"
	return text .. "\n"
end
function login:unpack(text)
	local left = text
	if self.last then
		left = self.last .. text
	end
	while true do
		local result
		result, left = self:unpack_line(left)
		if result then
			self:handleloginmsg(result)
		end
		if not (result and left) then
			break
		end
	end
	self.last = left
end
function login:loginSuccess()
	print("=====login:loginSuccess=====")
	sendReviewLog("=====login:loginSuccess=====")
	_ENV = nil
	;(nil).name = login.LOGIN_SUCCESS
	self:dispatchEvent(nil)
end
function login:loginFailed(failedType)
	print("=====login:loginFailed=====")
	sendReviewLog("=====login:loginFailed=====")
	_ENV = nil
	;(nil).name = login.LOGIN_FAILED
	;(nil).failedType = failedType
	self:dispatchEvent(nil)
	self:disconnectLogin()
end
function login:serverMaintaince(kid, serverTime)
	print("=====login:serverMaintaince=====")
	sendReviewLog("=====login:serverMaintaince=====")
	_ENV = nil
	;(nil).name = login.SERVER_MAINTAINCE
	;(nil).kid = kid
	;(nil).serverTime = serverTime
	self:dispatchEvent(nil)
	self:disconnectLogin()
end
function login:beSealed(sealType)
	print("=====login:beSealed=====", sealType)
	_ENV = sealType
	sealType.name = login.BE_SEALED
	sealType.sealType = sealType
	self:dispatchEvent(sealType)
	self:disconnectLogin()
end
function login:sdkLoginFail()
	print("=====login:sdkLoginFail=====")
	sendReviewLog("=====login:sdkLoginFail=====")
	self:disconnectLogin()
	_ENV = self
	self.msg = "MESSAGE_MAINSCEN_LOGINFAIL"
	self.type = gLoginFailTypeDef.loginFailType_sdkTokenError
	SoraDSendMessage(self)
end
function login:versionError()
	print("=====login:versionError=====")
	sendReviewLog("=====login:versionError=====")
	_ENV = nil
	;(nil).name = login.BE_VERSION_ERROR
	self:dispatchEvent(nil)
	self:disconnectLogin()
end
function login:receive(event)
	self:unpack(event.data)
end
function login:tcpClose()
	print("=====login:tcpClose=====")
	sendReviewLog("=====login:tcpClose=====")
end
function login:tcpClosed()
	print("=====login:tcpClosed=====")
	sendReviewLog("=====login:tcpClosed=====")
	self:onDisconnected()
end
function login:tcpConnected()
	print("=====login:tcpConnected=====")
	sendReviewLog("=====login:tcpConnected=====")
end
function login:failure()
	print("=====login:failure=====")
	sendReviewLog("=====login:failure=====")
	self:onDisconnected()
end
function login:onDisconnected()
	if NextState ~= S2C_DISCONNECT then
		NextState = nil
		;(nil).name = login.LOGIN_DISCONNECTED
		self:dispatchEvent(nil)
	end
end
function login:onGameLoginTimeout()
	print("=====login:onGameLoginTimeout=====")
	sendReviewLog("=====login:onGameLoginTimeout=====")
	self:disconnectLogin()
end
return login
