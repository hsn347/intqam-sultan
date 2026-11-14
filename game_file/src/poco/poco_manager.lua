function import_poco(moduleName, currentModuleName)
	local currentModuleNameParts
	local moduleFullName = moduleName
	local offset = 1
	while true do
		if string.byte(moduleName, offset) ~= 46 then
			moduleFullName = string.sub(moduleName, offset)
			if currentModuleNameParts and 0 < #currentModuleNameParts then
				moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
			end
			break
		end
		offset = offset + 1
		if not currentModuleNameParts then
			if not currentModuleName then
				local n, v = debug.getlocal(3, 1)
				currentModuleName = v
			end
			currentModuleNameParts = string.split(currentModuleName, ".")
		end
		table.remove(currentModuleNameParts, #currentModuleNameParts)
	end
	return require(moduleFullName)
end
local cc = _G.cc or require("cc")
local socket
xpcall(function()
end, function()
end)
local VERSION = import_poco(".POCO_SDK_VERSION")
local Dumper = import_poco(".Cocos2dxFrozenDumper")
local Screen = import_poco(".Cocos2dxScreen")
local ClientConnection = import_poco(".ClientConnection")
local _ENV, PocoManager = ".ClientConnection", ".ClientConnection"
PocoManager.__index = PocoManager
PocoManager.DEBUG = false
PocoManager.VERSION = VERSION
_ENV, PocoManager.clients, _ENV, PocoManager.all_socks, _ENV, PocoManager.server_sock = nil, nil, nil, nil, nil, nil
;(nil).GetSDKVersion = function()
	return VERSION
end
;(nil).Dump = function(onlyVisibleNode)
	if onlyVisibleNode == nil then
		onlyVisibleNode = true
	end
	return Dumper:dumpHierarchy(onlyVisibleNode)
end
;(nil).Screenshot = function(width)
	width = width or 720
	return Screen:getScreen(width)
end
;(nil).GetScreenSize = function()
	return Screen:getPortSize()
end
;(nil).SetText = function(_instanceId, val)
	local node = Dumper:getCachedNode(_instanceId)
	if node ~= nil then
		return node:setAttr("text", val)
	end
	return false
end
local (nil).test, dispatcher = function(arg1, arg2)
	return string.format("test arg1:%s arg2:%s", arg1, arg2)
end, nil
function PocoManager:init_server(port)
	port = port or 15004
	local server_sock, err = socket.tcp()
	assert(server_sock)
	table.insert(self.all_socks, server_sock)
	self.server_sock = server_sock
	server_sock:setoption("reuseaddr", true)
	server_sock:setoption("keepalive", true)
	server_sock:settimeout(0.0)
	server_sock:bind("*", port)
	server_sock:listen(5)
	print(string.format("[poco] server listens on tcp://*:%s", port))
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		self:server_loop()
	end, 0.025, false)
end
function PocoManager:server_loop()
	for _, c in pairs(self.clients) do
		c:drainOutputBuffer()
	end
	local r, w, e = socket.select(self.all_socks, nil, 0)
	if 0 < #r then
		local _ENV, removed_socks = #r, #r
		for i, v in ipairs(r) do
			if v == self.server_sock then
				local client_sock, err = self.server_sock:accept()
				if client_sock then
					print("[poco] new client accepted", client_sock:getpeername(), err)
					table.insert(self.all_socks, client_sock)
					self.clients[client_sock] = ClientConnection:new(client_sock, self.DEBUG)
				end
			else
				local client = self.clients[v]
				local reqs = client:receive()
				if reqs == "" then
					self.clients[v] = nil
					table.insert(removed_socks, v)
				elseif reqs ~= nil then
					for _, req in ipairs(reqs) do
						self:onRequest(req)
					end
				end
			end
		end
		for _, s in pairs(removed_socks) do
			for i, v in ipairs(self.all_socks) do
				if v == s then
					table.remove(self.all_socks, i)
					break
				end
			end
		end
	end
	for _, c in pairs(self.clients) do
		c:drainOutputBuffer()
	end
end
function PocoManager:onRequest(req)
	local client = req.client
	local method = req.method
	local params = req.params
	local func = dispatcher[method]
	dispatcher = nil
	;(nil).id = req.id
	;(nil).jsonrpc = req.jsonrpc
	;(nil).result = nil
	local (nil).error, ret
	if func == nil then
		dispatcher = req.jsonrpc
		ret.error, req.jsonrpc.message = req.jsonrpc, string.format("No such rpc method \"%s\", reqid: %s, client:%s", method, req.id, req.client:getAddress())
		client:send(ret)
	else
		xpcall(function()
			local result = func(unpack(params))
			if type(result) == "function" then
				result(function(cbresult)
					ret.result = cbresult
					client:send(ret)
				end)
				return
			else
				ret.result = result
				client:send(ret)
			end
		end, function(msg)
			ret = nil
			ret.error, (nil).message = nil, debug.traceback(msg)
			client:send(ret)
		end)
	end
end
return PocoManager
