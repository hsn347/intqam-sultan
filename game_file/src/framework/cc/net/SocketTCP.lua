local SOCKET_TICK_TIME = 0.1
local SOCKET_RECONNECT_TIME = 5
local SOCKET_CONNECT_FAIL_TIMEOUT = 3
local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"
local scheduler = require("framework.scheduler")
local socket = require("socket")
local SocketTCP = class("SocketTCP")
SocketTCP.EVENT_DATA = "SOCKET_TCP_DATA"
SocketTCP.EVENT_CLOSE = "SOCKET_TCP_CLOSE"
SocketTCP.EVENT_CLOSED = "SOCKET_TCP_CLOSED"
SocketTCP.EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
SocketTCP.EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"
SocketTCP._VERSION = socket._VERSION
SocketTCP._DEBUG = socket._DEBUG
function SocketTCP.getTime()
	return socket.gettime()
end
function SocketTCP:ctor(__host, __port, __retryConnectWhenFailure)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.host = __host
	self.port = __port
	self.tickScheduler = nil
	self.reconnectScheduler = nil
	self.connectTimeTickScheduler = nil
	self.name = "SocketTCP"
	self.tcp = nil
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false
end
function SocketTCP:setName(__name)
	self.name = __name
	return self
end
function SocketTCP:setTickTime(__time)
	__time = {}
	return self
end
function SocketTCP:setReconnTime(__time)
	__time = {}
	return self
end
function SocketTCP:setConnFailTime(__time)
	__time = {}
	return self
end
function SocketTCP:connect(__host, __port, __retryConnectWhenFailure)
	if __host then
		self.host = __host
	end
	if __port then
		self.port = __port
	end
	if __retryConnectWhenFailure ~= nil then
		self.isRetryConnect = __retryConnectWhenFailure
	end
	assert(self.host or self.port, "Host and port are necessary!")
	local isSupportIpv6 = function(_domain)
		local result = socket.dns.getaddrinfo(_domain)
		local ipv6 = false
		local addr
		local family = ""
		if result then
			for k, v in pairs(result) do
				if v.family == "inet6" then
					addr = v.addr
					family = v.family
					ipv6 = true
					break
				else
					family = family .. v.family
				end
			end
		end
		return ipv6, addr, family
	end
	local __ipv6, __addr, __family = isSupportIpv6(self.host)
	if __ipv6 and __addr and device.platform == "ios" and not gSvrConfig.closeIpv6 then
		sendReviewLog("socket connect host " .. self.host .. "  port:" .. self.port .. " user ipv6")
		self.host = __addr
		self.tcp = socket.tcp6()
	else
		sendReviewLog("socket connect host " .. self.host .. "  port:" .. self.port .. " user ipv4 " .. __family)
		self.tcp = socket.tcp()
	end
	self.tcp:settimeout(0)
	local __checkConnect = function()
		local __succ = self:_connect()
		if __succ then
			self:_onConnected()
		end
		return __succ
	end
	if not __checkConnect() then
		local __connectTimeTick = function()
			if self.isConnected then
				return
			end
			self.waitConnect = self.waitConnect or 0
			self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
			if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
				self.waitConnect = nil
				self:close()
				self:_connectFailure()
			end
			__checkConnect()
		end
		self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
	end
end
function SocketTCP:send(__data)
	if self.isConnected then
		self.tcp:send(__data)
	end
end
function SocketTCP:close(...)
	print("%s.close", self.name)
	self.tcp:close()
	if self.connectTimeTickScheduler then
		scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
	end
	if self.tickScheduler then
		scheduler.unscheduleGlobal(self.tickScheduler)
	end
	_ENV = self.name
	self.name.name = SocketTCP.EVENT_CLOSE
	self:dispatchEvent(self.name)
end
function SocketTCP:disconnect()
	self:_disconnect()
	self.isRetryConnect = false
end
local gStatusLastLogTime = 0
local gStatusLogInv = 1
local gStatusLast
function SocketTCP:_connect()
	local __succ, __status = self.tcp:connect(self.host, self.port)
	if gStatusLast ~= __status or os.time() - gStatusLastLogTime >= gStatusLogInv then
		serviceFunctions.print("SocketTCP._connect:", __succ, __status)
	else
	end
	__status = {}
	return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end
function SocketTCP:_disconnect()
	self.isConnected = false
	self.tcp:shutdown()
	SocketTCP = nil
	;(nil).name = SocketTCP.EVENT_CLOSED
	self:dispatchEvent(nil)
end
function SocketTCP:_onDisconnect()
	self.isConnected = false
	SocketTCP = nil
	;(nil).name = SocketTCP.EVENT_CLOSED
	self:dispatchEvent(nil)
	self:_reconnect()
end
function SocketTCP:_onConnected()
	self.isConnected = true
	SocketTCP = nil
	;(nil).name = SocketTCP.EVENT_CONNECTED
	self:dispatchEvent(nil)
	if self.connectTimeTickScheduler then
		scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
	end
	local __tick = function()
		while true do
			local __body, __status, __partial = self.tcp:receive("*a")
			if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
				self:close()
				if self.isConnected then
					self:_onDisconnect()
				else
					self:_connectFailure()
				end
				return
			end
			if __body and string.len(__body) == 0 or __partial and string.len(__partial) == 0 then
				return
			end
			if __body and __partial then
				__body = __body .. __partial
			end
			self = nil
			;(nil).name = SocketTCP.EVENT_DATA
			;(nil).data = __body or __partial
			;(nil).partial = __partial
			;(nil).body = __body
			self:dispatchEvent(nil)
		end
	end
	self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end
function SocketTCP:_connectFailure(status)
	SocketTCP = nil
	;(nil).name = SocketTCP.EVENT_CONNECT_FAILURE
	self:dispatchEvent(nil)
	self:_reconnect()
end
function SocketTCP:_reconnect(__immediately)
	if not self.isRetryConnect then
		return
	end
	if __immediately then
		self:connect()
		return
	end
	if self.reconnectScheduler then
		scheduler.unscheduleGlobal(self.reconnectScheduler)
	end
	local __doReConnect = function()
		self:connect()
	end
	self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
end
function SocketTCP:getIsConnected()
	return self.isConnected
end
return SocketTCP
