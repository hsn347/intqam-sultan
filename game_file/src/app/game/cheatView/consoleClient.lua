local scheduler = require("framework.scheduler")
local consoleClient = class("consoleClient")
function consoleClient:ctor()
end
function consoleClient:testPythonSocket()
	local net = require("framework.cc.net.init")
	local SocketTCP = net.SocketTCP
	local socket = SocketTCP.new()
	socket:setName("python tcp")
	socket:setTickTime(0.01)
	socket:setReconnTime(6)
	socket:setConnFailTime(15)
	socket:addEventListener(SocketTCP.EVENT_DATA, handler(self, self.onReceiveData))
	socket:addEventListener(SocketTCP.EVENT_CLOSE, handler(self, self.onClose))
	socket:addEventListener(SocketTCP.EVENT_CLOSED, handler(self, self.onClosed))
	socket:addEventListener(SocketTCP.EVENT_CONNECTED, handler(self, self.onConnected))
	socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.onConnectFailed))
	self.socket = socket
	self.socket:connect("127.0.0.1", 9999)
end
function consoleClient:onReceiveData(event)
	local data = event.data
	print("consoleClient received: ", data)
	local paramTb = SoraDStringSplit(data, "/")
	if 1 < #paramTb then
		local param1 = paramTb[1]
		if param1 == "open" then
			SoraDCreatePanel(paramTb[2]):show()
		end
	end
end
function consoleClient:onClose()
	print("consoleClient:onClose()")
end
function consoleClient:onClosed()
	print("consoleClient:onClosed()")
	self.socket:removeAllEventListeners()
end
function consoleClient:onConnected()
	print("consoleClient:onConnected() -- success")
	self.socket:send("I'm consoleClient-------")
	self.closeScheduler = scheduler.performWithDelayGlobal(handler(self, self.doClose), 3)
end
function consoleClient:doClose()
	print("consoleClient:doClose()-----------")
	self.socket:send("exit")
end
function consoleClient:onConnectFailed()
	print("consoleClient:onConnectFailed()")
end
return consoleClient
