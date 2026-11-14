local net = require("framework.cc.net.init")
local crypt = require("crypt")
local bit32 = require("bit32")
local cjson = require("cjson")
local socket = require("socket")
local gate = class("gate")
gate.GATE_CONNECT_PORT_SUCCESS = "GATE_CONNECT_PORT_SUCCESS"
gate.GATE_HANDSHAKE_SUCCESS = "GATE_HANDSHAKE_SUCCESS"
gate.GATE_FAILED = "GATE_FAILED"
gate.GAME_MSG_RESPONSE = "GAME_MSG_RESPONSE"
gate.GATE_DISCONNECTED = "GAME_DISCONNECTED"
gate.Err_Gate_HandshakeSuccess = 200
gate.Err_Gate_HandshakeMessageTpErr = 405
gate.Err_Gate_UserNotFound = 404
gate.Err_Gate_IndexExpired = 403
gate.Err_Gate_Unauthorized = 401
gate.Err_Gate_BadRequest = 400
gate.Err_Gate_tcpConnected = 100
local limitSize = 65536
local S2C_HANDSHAKE = "S2C_HANDSHAKE"
local S2C_RESPONSE = "S2C_RESPONSE"
local S2C_DISCONNECT = "S2C_DISCONNECT"
local NextState = S2C_HANDSHAKE
local string_unpack = string.unpack
local string_pack = string.pack
local string_format = string.format
function gate:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end
function gate:initSocket()
	print("=====gate:initSocket=====")
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
function gate:connectGate(host, port)
	local curTime = SoraDGetSocketTime()
	userSDKManager.timeInfo.t_login.tend = curTime
	userSDKManager.timeInfo.t_gamelogin.tbegin = curTime
	local ip = host
	if not gIsReviewGameSever and gWebCallGameSeverIP ~= nil then
		ip = gWebCallGameSeverIP
	end
	self.socket:connect(ip, port)
	print("=====gate:connectGate=====", ip, port)
end
function gate:Logout()
	print("=====gate:Logout=====")
	self:disconnectGate()
end
function gate:disconnectGate()
	print("=====gate:disconnectGate=====")
	if self.socket then
		self.socket:removeAllEventListeners()
		self.socket:disconnect()
		self.socket = nil
		self:removeAllEventListeners()
		if self.last then
			self.last = nil
		end
	end
end
function gate:handshake(servername, uid, subid, secret, index)
	print("=====gate:handshake=====")
	self.secret = secret
	local username = string_format("%s@%s#%s", crypt.base64encode(uid), crypt.base64encode(servername), crypt.base64encode(subid))
	local handshake = string_format("%s:%d", username, index)
	local hmac = crypt.hmac64(crypt.hashkey(handshake), secret)
	_ENV = crypt.hashkey(handshake)
	crypt.hashkey(handshake).username = username
	crypt.hashkey(handshake).index = index
	local crypt.hashkey(handshake).hmac, handshake_content = crypt.base64encode(hmac), crypt.hashkey(handshake)
	self.socket:send(self:pack_handshake(cjson.encode(handshake_content)))
end
function gate:sendrequest(msg, session)
	if self.socket then
		local jsonMsg = cjson.encode(msg)
		local desMsg = crypt.desencode(self.secret, jsonMsg or "")
		local msg64code = crypt.base64encode(desMsg)
		self.socket:send(self:pack_request(msg64code, session))
	else
		print("------Error ------: socket is not connected!")
	end
end
function gate:handlegatemsg(msg)
	if NextState == S2C_HANDSHAKE then
		self:S2C_HANDSHAKE(msg)
	elseif NextState == S2C_RESPONSE then
		self:S2C_RESPONSE(msg)
	end
end
function gate:S2C_HANDSHAKE(msg)
	local code = tonumber(string.sub(msg, 1, 3))
	local submsg = string.sub(msg, 5)
	if code == gate.Err_Gate_HandshakeSuccess then
		print("=====handshake success=====")
		sendReviewLog("=====handshake success=====")
		_ENV = string.sub(msg, 1, 3)
		string.sub(msg, 1, 3).name = gate.GATE_HANDSHAKE_SUCCESS
		self:dispatchEvent(string.sub(msg, 1, 3))
	else
		if code == gate.Err_Gate_UserNotFound then
			print("=====网关握手失败,用户没找到=====")
			sendReviewLog("=====网关握手失败,用户没找到=====")
		elseif code == gate.Err_Gate_IndexExpired then
			print("=====网关握手失败,index版本错误=====")
			sendReviewLog("=====网关握手失败,index版本错误=====")
		elseif code == gate.Err_Gate_Unauthorized then
			print("=====网关握手失败,网关认证没通过=====")
			sendReviewLog("=====网关握手失败,网关认证没通过=====")
		elseif code == gate.Err_Gate_BadRequest then
			print("=====网关握手失败,错误的请求=====")
			sendReviewLog("=====网关握手失败,错误的请求=====")
		elseif code == gate.Err_Gate_HandshakeMessageTpErr then
			print("=====网关握手失败,握手包类型错误=====")
			sendReviewLog("=====网关握手失败,握手包类型错误=====")
		end
		_ENV = string.sub(msg, 1, 3)
		string.sub(msg, 1, 3).name = gate.GATE_FAILED
		self:dispatchEvent(string.sub(msg, 1, 3))
		self:Logout()
	end
end
function gate:S2C_RESPONSE(msg)
	local ok, _content, _session = self:recv_response(msg)
	if ok then
		local cjsonSize = string.len(_content)
		local _oldContent = _content
		if _session == 0 then
			local zlib = require("zlib")
			local uncompress = zlib.inflate()
			local inflated, eof, bytes_in, bytes_out = uncompress(_content)
			_content = inflated
		end
		_content = cjson.decode(_content)
		if not _content then
			print("_content error", self.last, cjsonSize)
			gate = "_content error"
			;("_content error")[1] = _oldContent
			;("_content error")[2] = cjsonSize
			dump("_content error", "oldContent")
		end
		_ENV = "oldContent"
		_ENV, ("oldContent").name = gate.GAME_MSG_RESPONSE, gate.GAME_MSG_RESPONSE
		gate.GAME_MSG_RESPONSE.content = _content
		;("oldContent").data, gate.GAME_MSG_RESPONSE.session = gate.GAME_MSG_RESPONSE, _session
		self:dispatchEvent("oldContent")
	else
		print("receive response not ok")
	end
end
function gate:recv_response(v)
	local content = v:sub(1, -6)
	local ok = v:byte(-5)
	local session = string_unpack(">I4", v, -4)
	return ok ~= 0, content, session
end
function gate:unpack_package(text)
	local size = #text
	local headSize = 2
	if size < headSize then
		return nil, text
	end
	local b1, b2 = text:byte(1, 2)
	local s = b1 * 256 + b2
	if s == 65535 then
		headSize = 5
		if size < headSize then
			return nil, text
		end
		s = string_unpack(">I3", text, 3)
	end
	if size < s + headSize then
		return nil, text
	end
	return text:sub(headSize + 1, headSize + s), text:sub(headSize + s + 1)
end
function gate:safeCall(func, trackback)
	trackback = trackback or __G__TRACKBACK__
	local status, msg = xpcall(func, trackback)
	if not status then
		print(msg)
		return false
	end
	return true
end
function gate:unpack(text, handle)
	local left = text
	if self.last then
		left = self.last .. text
	end
	while true do
		local result
		result, left = self:unpack_package(left)
		if result then
			self:safeCall(function()
				self:handlegatemsg(result)
			end)
		end
		if not (result and left) then
			break
		end
	end
	self.last = left
end
function gate:pack_handshake(text)
	local size = #text
	local format = string_format(">I2c%d", size)
	local package = string_pack(format, size, text)
	return package
end
function gate:pack_request(text, session)
	local ssize = #text
	local size = ssize + 4
	if size > limitSize then
		print("=====gate:pack_request package over limitSize =====")
		return
	end
	local format = string_format(">I2c%dI4", ssize)
	local package = string_pack(format, size, text, session)
	return package
end
function gate:receive(event)
	self:unpack(event.data)
end
function gate:tcpClose()
	print("=====gate:tcpClose=====")
	sendReviewLog("=====gate:tcpClose=====")
end
function gate:tcpClosed()
	print("=====gate:tcpClosed=====")
	sendReviewLog("=====gate:tcpClosed=====")
	self:onDisconnected()
end
function gate:tcpConnected()
	print("=====gate:tcpConnected=====")
	sendReviewLog("=====gate:tcpConnected=====")
	_ENV = nil
	;(nil).name = gate.GATE_CONNECT_PORT_SUCCESS
	self:dispatchEvent(nil)
end
function gate:failure()
	print("=====gate:failure=====")
	sendReviewLog("=====gate:failure=====")
	self:onDisconnected()
end
function gate:onDisconnected()
	print("=====gate:onDisconnected=====")
	sendReviewLog("=====gate:onDisconnected=====")
	_ENV = nil
	;(nil).name = gate.GATE_DISCONNECTED
	self:dispatchEvent(nil)
	self:disconnectGate()
end
function gate:onGameLoginTimeout()
	print("=====gate:onGameLoginTimeout=====")
	sendReviewLog("=====gate:onGameLoginTimeout=====")
	self:disconnectGate()
end
return gate
