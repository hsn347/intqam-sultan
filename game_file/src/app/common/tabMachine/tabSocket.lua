local socket = require("socket")
local cocosContext = require("app.common.tabMachine.cocosContext")
local tabSocket = class("tabSocket", cocosContext)
local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"
_ENV = nil
;(nil).DISCONNECTED = 1
;(nil).CONNECTING = 2
tabSocket.STATE, (nil).CONNECTED = nil, 3
function tabSocket:s1(isUsingIpV6)
	self._isUsingIpV6 = isUsingIpV6
	self._tcp = nil
	self._buffer = nil
	self:call(self:tabMain(), "main")
	self._main = self:getSub("main")
end
function tabSocket:tabMain()
	tabSocket = nil
	;(nil).s1 = function(c)
		self._state = tabSocket.STATE.DISCONNECTED
		_UPVALUE3_ = nil
		;(nil)[1] = "ip"
		;(nil)[2] = "port"
		;(nil)[3] = "timeout"
		c:call(self:tabWaitConnectEvent(), "s2", nil)
	end
	;(nil).s3 = function(c)
		self._state = tabSocket.STATE.CONNECTING
		_UPVALUE2_ = c.v.ip
		c.v.ip[1] = "isSuccess"
		c.v.ip[2] = "err"
		c:call(self:tabConnectting(c.v.ip, c.v.port), "s4", c.v.ip)
	end
	;(nil).s5 = function(c)
		if c.v.isSuccess then
			self._state = tabSocket.STATE.CONNECTED
			c:call(self:tabConnectted(), "s6")
		else
			c:start("s1")
		end
	end
	;(nil).s7 = function(c)
		c:start("s1")
	end
	;(nil).tabState = function(c, scName)
		if scName == tabSocket.STATE.CONNECTING then
			return c:tabProxy("s4")
		elseif scName == tabSocket.STATE.CONNECTED then
			return c:tabProxy("s6")
		elseif scName == tabSocket.STATE.DISCONNECTED then
			return c:tabProxy("s2")
		end
	end
	return nil
end
function tabSocket:tabWaitConnectEvent()
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "tabWaitConnectEvent"
		end
	end
	;(nil).s1_event = function(c, event)
		if type(event) == "table" and event.name == "tabSocket.connect" then
			c:output(event.ip, event.port, event.timeout)
			c:stop()
			return true
		end
	end
	return nil
end
function tabSocket:tabConnectting(ip, port, timeout)
	if timeout == nil then
		timeout = 3
	end
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "tabConnectting"
		end
		self._buffer, _ENV = g_t.debug, g_t.debug
		local ipV6 = self:getIpV6Address(ip)
		if self._isUsingIpV6 and ipV6 ~= nil then
			c.v.ip = ipV6
			self._tcp = socket.tcp6()
		else
			c.v.ip = ip
			self._tcp = socket.tcp()
		end
		self._tcp:settimeout(0)
		c.v.time = 0
		c.v.isConnected = c:_tryToConnect()
		if c.v.isConnected then
			c:output(true)
			c:stop()
		end
	end
	;(nil).s1_update = function(c, dt)
		c.v.isConnected = c:_tryToConnect()
		if c.v.isConnected then
			c:output(true)
			c:stop()
			return
		end
		c.v.time = c.v.time + dt
		if c.v.time >= timeout then
			c:output(false, "tabSocket.connectting.timeout")
			c:stop()
		end
	end
	;(nil).event = function(c, event)
		if type(event) == "table" and event.name == "tabSocket.disconnect" then
			c:output(false, event.name)
			c:stop()
		end
	end
	;(nil).final = function(c)
		if not c.v.isConnected then
			self._tcp:close()
			self._tcp = nil
		end
	end
	;(nil)._tryToConnect = function(c)
		local isSuccess, status = self._tcp:connect(c.v.ip, port)
		if not isSuccess and status == STATUS_ALREADY_CONNECTED then
			isSuccess = true
		end
		return isSuccess
	end
	return nil
end
function tabSocket:tabConnectted()
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "tabConnectted"
		end
	end
	;(nil).s1_update = function(c)
		local body, status, partical = self._tcp:receive("*a")
		if partical and partical:len() > 0 then
			table.insert(self._buffer, partical)
		elseif body and body:len() > 0 then
			table.insert(self._buffer, body)
		end
		if status == STATUS_CLOSED or status == STATUS_NOT_CONNECTED then
			c:output(false, "closed")
			c:stop()
		end
	end
	;(nil).event = function(c, event)
		if type(event) == "table" and event.name == "tabSocket.disconnect" then
			c:output(false, event.name)
			c:stop()
		end
	end
	;(nil).final = function(c)
		self._tcp:shutdown()
		self._tcp:close()
		self._tcp = nil
	end
	return nil
end
function tabSocket:final()
	if self._tcp then
		self._tcp:close()
	end
end
function tabSocket:connect(ip, port)
	_ENV = nil
	;(nil).name = "tabSocket.connect"
	;(nil).ip = ip
	;(nil).port = port
	;(nil).timeout = timeout
	self._main:notify(nil)
	return self._main:tabState(tabSocket.STATE.CONNECTING)
end
function tabSocket:disconnect()
	_UPVALUE0_ = nil
	;(nil).name = "tabSocket.disconnect"
	self._main:notify(nil)
end
function tabSocket:getState()
	return self._state
end
function tabSocket:tabInState(state)
	_UPVALUE0_ = nil
	;(nil).s1 = function(c)
		c._nickName = "tabSocket#tabInState->" .. state
		if self._state ~= state then
			c:stop()
		else
			c:call(self._main:tabState(state), "s2")
		end
	end
	return nil
end
function tabSocket:tabReadOneSegment(funDecode, updateInterval)
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "tabSocket#tabReadOneSegment"
		end
		c.v.lastBuffLen = 0
		local segment = c:_decode()
		if segment ~= nil then
			c:output(segment)
			c:stop()
		end
	end
	;(nil).s1_update = function(c, dt)
		local newBuffLen = #self._buffer
		if newBuffLen ~= c.v.lastBuffLen and 0 < newBuffLen then
			local segment = c:_decode()
			if segment ~= nil then
				c:output(segment)
				c:stop()
			end
			c.v.lastBuffLen = #self._buffer
		end
	end
	;(nil).s1_updateInterval = updateInterval
	;(nil)._decode = function(c)
		local newBuffLen = #self._buffer
		if 0 < newBuffLen then
			local stream
			if 1 < newBuffLen then
				stream = table.concat(self._buffer)
			else
				stream = self._buffer[1]
			end
			local segment, remain = funDecode(stream)
			while #self._buffer > 0 do
				table.remove(self._buffer)
			end
			if remain and 0 < remain:len() then
				table.insert(self._buffer, remain)
			end
			return segment
		else
			return nil
		end
	end
	return nil
end
function tabSocket:tabPullSegments(funDecode, segmentHandler, updateInterval)
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "tabSocket#tabPullSegments"
		end
		c.v.lastBuffLen = 0
		c:_pullSegment()
	end
	;(nil).s1_update = function(c, dt)
		c:_pullSegment()
	end
	;(nil).s1_updateInterval = updateInterval
	;(nil)._pullSegment = function(c)
		local newBuffLen = #self._buffer
		if newBuffLen ~= c.v.lastBuffLen and 0 < newBuffLen then
			while true do
				local segment = c:_decode()
				if segment ~= nil then
					segmentHandler(segment)
				else
					break
				end
			end
			c.v.lastBuffLen = #self._buffer
		end
	end
	;(nil)._decode = function(c)
		local newBuffLen = #self._buffer
		if 0 < newBuffLen then
			local stream
			if 1 < newBuffLen then
				stream = table.concat(self._buffer)
			else
				stream = self._buffer[1]
			end
			local segment, remain = funDecode(stream)
			while #self._buffer > 0 do
				table.remove(self._buffer)
			end
			if remain and 0 < remain:len() then
				table.insert(self._buffer, remain)
			end
			return segment
		else
			return nil
		end
	end
	return nil
end
function tabSocket:send(data)
	assert(self._state == tabSocket.STATE.CONNECTED, "socket is not connected")
	if self._tcp then
		self._tcp:send(data)
	end
end
function tabSocket:getIpV6Address(ip)
	local result = socket.dns.getaddrinfo(ip)
	local addr
	if result then
		for k, v in pairs(result) do
			if v.family == "inet6" then
				addr = v.addr
				break
			end
		end
	end
	return addr
end
return tabSocket
