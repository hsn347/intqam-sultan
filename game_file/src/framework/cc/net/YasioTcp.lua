local SOCKET_TICK_TIME = 0.1
local SOCKET_RECONNECT_TIME = 5
local SOCKET_CONNECT_FAIL_TIMEOUT = 3
local scheduler = require("framework.scheduler")
local YasioTcp = class("YasioTcp")
local yasio = require("yasio")
local SOCKET_TICK_COUNT = 64
local EVENT_DATA = "SOCKET_TCP_DATA"
local EVENT_CLOSE = "SOCKET_TCP_CLOSE"
local EVENT_CLOSED = "SOCKET_TCP_CLOSED"
local EVENT_CONNECTED = "SOCKET_TCP_CONNECTED"
local EVENT_CONNECT_FAILURE = "SOCKET_TCP_CONNECT_FAILURE"
YasioTcp.EVENT_DATA = EVENT_DATA
YasioTcp.EVENT_CLOSE = EVENT_CLOSE
YasioTcp.EVENT_CLOSED = EVENT_CLOSED
YasioTcp.EVENT_CONNECTED = EVENT_CONNECTED
YasioTcp.EVENT_CONNECT_FAILURE = EVENT_CONNECT_FAILURE
function YasioTcp:ctor(__host, __port, __retryConnectWhenFailure)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.host = __host
	self.port = __port
	self.reconnectScheduler = nil
	self.connectTimeTickScheduler = nil
	self.name = "YasioTcp"
	self.isRetryConnect = __retryConnectWhenFailure
	self.isConnected = false
	self.enableFBFD = false
end
function YasioTcp:setName(__name)
	self.name = __name
	return self
end
function YasioTcp:setTickTime(__time)
	__time = {}
	return self
end
function YasioTcp:setReconnTime(__time)
	__time = {}
	return self
end
function YasioTcp:setConnFailTime(__time)
	__time = {}
	return self
end
function YasioTcp:setEnableFBFD(enable)
	self.enableFBFD = enable
end
local safeCall = _G.SoraDSafeCall
function YasioTcp:connect(__host, __port, __retryConnectWhenFailure)
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
	_ENV, yasio = self.host or self.port, assert
	;(self.host or self.port).host = __host
	;(self.host or self.port).port = __port
	local assert[1], channels = self.host or self.port, assert
	local service = yasio.io_service.new(channels)
	local service_dispatch = function(ev)
		local t = ev:kind()
		if t == yasio.YEK_PACKET then
			local __body = ev:packet()
			yasio = nil
			;(nil).name = EVENT_DATA
			;(nil).data = __body
			;(nil).body = __body
			self:dispatchEvent(nil)
		elseif t == yasio.YEK_CONNECT_RESPONSE then
			if ev:status() == 0 then
				self:_onConnected(ev)
			else
				print("connect server failed!")
				self:close()
				self:_connectFailure()
			end
		elseif t == yasio.YEK_CONNECTION_LOST then
			print("The server connection is lost!")
			self:close()
			if self.isConnected then
				self:_onDisconnect()
			else
				self:_connectFailure()
			end
		end
	end
	service:start(function(ev)
		safeCall(function()
			service_dispatch(ev)
		end)
	end)
	service:set_option(yasio.YOPT_S_CONNECT_TIMEOUT, SOCKET_CONNECT_FAIL_TIMEOUT)
	if self.enableFBFD then
		service:set_option(yasio.YOPT_C_LFBFD_PARAMS, 0, 65535, 0, 2, 2)
	end
	self.service = service
	self.service:open(0, yasio.YCK_TCP_CLIENT)
	local __connectTimeTick = function()
		self.service:dispatch(SOCKET_TICK_COUNT)
	end
	self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
	self.connectTimeTickScheduler = true
end
function YasioTcp:send(__data)
	if self.isConnected then
		self.service:write(self.transport, __data)
	end
end
function YasioTcp:close(...)
	self.service:close(0)
	self.service:set_option(yasio.YOPT_S_EVENT_CB, function()
	end)
	if self.connectTimeTickScheduler then
		scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
	end
	yasio = yasio.YOPT_S_EVENT_CB
	yasio.YOPT_S_EVENT_CB.name = EVENT_CLOSE
	self:dispatchEvent(yasio.YOPT_S_EVENT_CB)
end
function YasioTcp:disconnect()
	self:_disconnect()
	self.isRetryConnect = false
end
function YasioTcp:_disconnect()
	if self.isConnected then
		self.isConnected = false
		self.service:close(self.transport or 0)
	else
		self.service:close(0)
	end
	EVENT_CLOSED = 0
	;(0).name = EVENT_CLOSED
	self:dispatchEvent(0)
end
function YasioTcp:_onDisconnect()
	self.isConnected = false
	EVENT_CLOSED = nil
	;(nil).name = EVENT_CLOSED
	self:dispatchEvent(nil)
	self:_reconnect()
end
function YasioTcp:_onConnected(ev)
	local transport = ev:transport()
	self.transport = transport
	self.isConnected = true
	EVENT_CONNECTED = nil
	;(nil).name = EVENT_CONNECTED
	self:dispatchEvent(nil)
end
function YasioTcp:_connectFailure(status)
	EVENT_CONNECT_FAILURE = nil
	;(nil).name = EVENT_CONNECT_FAILURE
	self:dispatchEvent(nil)
	self:_reconnect()
end
function YasioTcp:_reconnect(__immediately)
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
function YasioTcp:getIsConnected()
	return self.isConnected
end
return YasioTcp
