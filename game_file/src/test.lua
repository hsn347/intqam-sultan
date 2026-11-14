local net = require("framework.cc.net.init")
local _ENV, test = "framework.cc.net.init", "framework.cc.net.init"
local _ENV, navigator
if g_scale == nil then
	g_scale = 1
end
function navigator.getCurNode()
	return _G.g_curNode
end
function navigator.setCurNode(node)
	_G.g_curNode = node
	navigator.updateCurNodeMark()
end
function navigator.showCurNodeMark(show)
	if show and _G.g_curNodeMark == nil then
		_G.g_curNodeMark = cc.DrawNode:create()
		local curScene = display.getRunningScene()
		curScene:addChild(_G.g_curNodeMark, 1000)
		local label = ccui.Text:create()
		_G.g_curNodeMark:addChild(label)
		local x = display.width * 0.5
		local y = display.height * 0.5
		label:setPosition(x, y)
		label:setString("123")
		label:setFontSize(20)
		label:setColor(cc.c3b(0, 255, 255))
		label:setTextAreaSize(cc.size(600, 0))
		_G.g_curNodeMark.label = label
		navigator.updateCurNodeMark()
	elseif not show and _G.g_curNodeMark ~= nil then
		_G.g_curNodeMark:removeFromParent()
		_G.g_curNodeMark = nil
	end
end
function navigator.updateCurNodeMark()
	if _G.g_curNodeMark == nil then
		return
	end
	_G.g_curNodeMark:clear()
	if _G.g_curNode ~= nil then
		local boundBox = SoraDGetBoundBox(_G.g_curNode, _G.g_curNode:getParent() and _G.g_curNodeMark:getParent())
		local pos = cc.p(_G.g_curNode:getPosition())
		if _G.g_curNode:getParent() then
			pos = _G.g_curNode:getParent():convertToWorldSpace(pos)
			pos = _G.g_curNodeMark:getParent():convertToNodeSpace(pos)
		end
		_G.g_curNodeMark:drawCircle(pos, 10, 0, 10, false, 1, 1, cc.c4f(1, 0, 0, 1))
		_G.g_curNodeMark:drawRect(cc.p(boundBox.left, boundBox.bottom), cc.p(boundBox.right, boundBox.top), cc.c4f(1, 0, 0, 1))
		local label = _G.g_curNodeMark.label
		label:setString(navigator.getNodeDesc(_G.g_curNode))
	end
end
function navigator.getNodesUnderPoint(pos, root, nodes)
	if not root:isVisible() then
		return
	end
	local box = SoraDGetBoundBox(root, nil)
	local children = root:getChildren()
	for i = #children, 1, -1 do
		navigator.getNodesUnderPoint(pos, children[i], nodes)
	end
	local localPos = pos
	if root:getParent() ~= nil then
		localPos = root:getParent():convertToNodeSpace(pos)
	end
	if localPos.x >= box.left and localPos.x <= box.right and localPos.y >= box.bottom and localPos.y <= box.top then
		table.insert(nodes, root)
	end
end
function navigator.enableTouchSelection(enable)
	if _G.g_touchListener == nil and enable then
		local listener = cc.EventListenerTouchOneByOne:create()
		local onTouchBegan = function(touch, event)
			_G.g_lastTestTouchPos = touch:getStartLocation()
			return _G.g_enableTestTouch
		end
		local onTouchEnded = function(touch, event)
			local _ENV, nodes
			_G.g_touchedNodes = nodes
			_G.g_touchedIndex = 1
			navigator.getNodesUnderPoint(touch:getStartLocation(), display.getRunningScene(), nodes)
			print("nodes under touch")
			if 0 < #nodes then
				navigator.setCurNode(nodes[1])
				navigator.printCurNode()
				for i, node in ipairs(nodes) do
					print(i, navigator.getNodeDesc(node))
				end
			end
			_G.g_enableTestTouch = false
		end
		listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
		listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_CANCELLED)
		listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
		local eventDispatcher = display:getRunningScene():getEventDispatcher()
		listener:setSwallowTouches(true)
		eventDispatcher:addEventListenerWithFixedPriority(listener, -11000)
		print("listener added")
		_G.g_touchListener = listener
	end
	_G.g_enableTestTouch = enable
end
function navigator.switchTouchIndex(offset)
	if _G.g_touchedNodes and #_G.g_touchedNodes then
		_G.g_touchedIndex = (_G.g_touchedIndex + offset) % #_G.g_touchedNodes
		navigator.setCurNode(_G.g_touchedNodes[_G.g_touchedIndex])
		navigator.printCurNode()
	end
end
function navigator.cmdA()
	navigator.showCurNodeMark(not _G.g_curNodeMark)
end
function navigator.cmdDebug()
	print("ZeroBrane Studio 启用调试------")
	require("mobdebug").start()
end
function navigator.cmdZ()
	navigator.enableTouchSelection(true)
	if _G.g_enableTestTouch then
		navigator.showCurNodeMark(true)
	end
end
function navigator.cmdX()
	navigator.switchTouchIndex(1)
end
function navigator.cmdC()
	navigator.switchTouchIndex(-1)
end
function navigator.cmdB()
	navigator.setCurNode(display.getRunningScene())
	navigator.printCurNode()
end
function navigator.cmdG()
	navigator.cmdTopPanel()
end
function navigator.cmdTopPanel()
	local panel = SoraDPanelManager[#SoraDPanelManager]
	navigator.setCurNode(panel)
	navigator.printCurNode()
end
function navigator.cmdJ()
	navigator.parent()
	navigator.printCurNode()
end
function navigator.cmdK()
	navigator.firstChild()
	navigator.printCurNode()
end
function navigator.cmdL()
	navigator.nextSibling()
	navigator.printCurNode()
end
function navigator.cmdH()
	navigator.prevSibling()
	navigator.printCurNode()
end
function navigator.cmdN()
	navigator.printCurNode()
end
function navigator.cmdM()
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	navigator.printAncestor(navigator.getCurNode())
end
function navigator.cmdO()
	navigator.printNodePosInfo(navigator.getCurNode())
end
function navigator.cmdS()
	navigator.printChildren(navigator.getCurNode())
end
function navigator.cmdV()
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	navigator.toggleNode(navigator.getCurNode())
	local str = navigator.getCurNode():isVisible() and "set cur node visible" or "set cur node invisible"
	print(str)
end
function navigator.cmdQ()
	if g_scale == nil then
		g_scale = 1
	end
	if g_scale == 1 then
		g_scale = 10
	elseif g_scale == 10 then
		g_scale = 100
	elseif g_scale == 100 then
		g_scale = 1
	end
end
function navigator.cmdW()
	package.loaded["app.game.cheatView.testCanvas"] = nil
	local testCanvas = display.getRunningScene():getChildByName("testCanvas")
	if testCanvas then
		testCanvas:close()
	else
		testCanvas = require("app.game.cheatView.testCanvas").new()
		testCanvas:show()
	end
end
function navigator.cmdE()
	dump(debug.getfenv(navigator.getCurNode()), "kk", 1000)
end
function navigator.cmdR()
	if navigator.getCurNode() then
		navigator.getCurNode():removeFromParent()
	end
	navigator.setCurNode(nil)
end
function navigator.cmdD()
	__debugTest = not __debugTest
end
function navigator.cmdF()
	if g_ctrlMode == nil or g_ctrlMode == "move" then
		g_ctrlMode = "opacity_scale"
	elseif g_ctrlMode == "opacity_scale" then
		g_ctrlMode = "scaleXY"
	elseif g_ctrlMode == "scaleXY" then
		g_ctrlMode = "move"
	end
	printInfo("ctrlMove switch to %s", g_ctrlMode)
end
function navigator.cmdLeft()
	print("cmdLeft")
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	if g_ctrlMode == "move" or g_ctrlMode == nil then
		local x, y = navigator.getCurNode():getPosition()
		navigator.getCurNode():setPosition(cc.p(x - g_scale, y))
	elseif g_ctrlMode == "opacity_scale" then
		local scale = navigator:getCurNode():getScale()
		navigator.getCurNode():setScale(scale - g_scale * 0.01)
	elseif g_ctrlMode == "scaleXY" then
		local scaleX = navigator:getCurNode():getScaleX()
		navigator.getCurNode():setScaleX(scaleX - g_scale * 0.01)
	end
end
function navigator.cmdRight()
	print("cmdRight")
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	if g_ctrlMode == "move" or g_ctrlMode == nil then
		local x, y = navigator.getCurNode():getPosition()
		navigator.getCurNode():setPosition(cc.p(x + g_scale, y))
	elseif g_ctrlMode == "opacity_scale" then
		local scale = navigator:getCurNode():getScale()
		navigator.getCurNode():setScale(scale + g_scale * 0.01)
	elseif g_ctrlMode == "scaleXY" then
		local scaleX = navigator:getCurNode():getScaleX()
		navigator.getCurNode():setScaleX(scaleX + g_scale * 0.01)
	end
end
function navigator.cmdUp()
	print("cmdUp")
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	if g_ctrlMode == "move" or g_ctrlMode == nil then
		local x, y = navigator.getCurNode():getPosition()
		navigator.getCurNode():setPosition(cc.p(x, y + g_scale))
	elseif g_ctrlMode == "opacity_scale" then
		local opacity = navigator:getCurNode():getOpacity()
		opacity = opacity + g_scale
		if 255 < opacity then
			opacity = 255
		elseif opacity < 0 then
			opacity = 0
		end
		navigator.getCurNode():setOpacity(opacity)
	elseif g_ctrlMode == "scaleXY" then
		local scaleY = navigator:getCurNode():getScaleY()
		navigator.getCurNode():setScaleY(scaleY + g_scale * 0.01)
	end
end
function navigator.cmdDown()
	print("cmdDown")
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
	end
	if g_ctrlMode == "move" or g_ctrlMode == nil then
		local x, y = navigator.getCurNode():getPosition()
		navigator.getCurNode():setPosition(cc.p(x, y - g_scale))
	elseif g_ctrlMode == "opacity_scale" then
		local opacity = navigator:getCurNode():getOpacity()
		opacity = opacity - g_scale
		if 255 < opacity then
			opacity = 255
		elseif opacity < 0 then
			opacity = 0
		end
		navigator.getCurNode():setOpacity(opacity)
	elseif g_ctrlMode == "scaleXY" then
		local scaleY = navigator:getCurNode():getScaleY()
		navigator.getCurNode():setScaleY(scaleY - g_scale * 0.01)
	end
end
function navigator.parent()
	if navigator.getCurNode() == nil then
		print("Current Node is nil!")
		return
	end
	navigator.setCurNode(navigator.getCurNode():getParent())
end
function navigator.firstChild()
	if navigator.getCurNode() == nil then
		return
	end
	local children = navigator.getCurNode():getChildren()
	local child = children[1]
	if child == nil then
		print("First child is nil!")
	else
		navigator.setCurNode(child)
	end
end
function navigator.lastChild()
	if navigator.getCurNode() == nil then
		return
	end
	local children = navigator.getCurNode():getChildren()
	local child = children[#children]
	if child == nil then
		print("Last child is nil!")
	else
		navigator.setCurNode(child)
	end
end
function navigator.nextSibling()
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
		return
	end
	local parent = navigator.getCurNode():getParent()
	if parent == nil then
		print("Parent node is nil!")
		return
	end
	local index = navigator.getChildIndex(navigator.getCurNode())
	local node = navigator.getChildByIndex(parent, index + 1)
	if node == nil then
		node = navigator.getChildByIndex(parent, 1)
	end
	navigator.setCurNode(node)
end
function navigator.getChildIndex(node)
	if node == nil then
		return 0
	end
	local parent = node:getParent()
	if parent == nil then
		return 0
	end
	for index, child in ipairs(parent:getChildren()) do
		if child == node then
			return index
		end
	end
	return 0
end
function navigator.getChildByIndex(parent, index)
	if parent == nil then
		return nil
	end
	return parent:getChildren()[index]
end
function navigator.saveCurNode()
	g_savedNode = navigator.getCurNode()
end
function navigator.restoreNode()
	navigator.setCurNode(g_savedNode)
end
function navigator.prevSibling()
	if navigator.getCurNode() == nil then
		print("Current node is nil!")
		return
	end
	local parent = navigator.getCurNode():getParent()
	if parent == nil then
		print("Parent node is nil!")
		return
	end
	local index = navigator.getChildIndex(navigator.getCurNode())
	local node = navigator.getChildByIndex(parent, index - 1)
	if node == nil then
		node = navigator.getChildByIndex(parent, #parent:getChildren())
	end
	navigator.setCurNode(node)
end
function navigator.printCurNode()
	navigator.printNode(navigator.getCurNode())
end
function navigator.printNodePosInfo(node)
	local desc = navigator.getNodePosInfo(node)
	print(desc)
end
function navigator.printChildren(node)
	if node == nil then
		print("nil")
	else
		for index, child in ipairs(node:getChildren()) do
			local nodeDesc = navigator.getNodeDesc(child)
			local desc = string.format("[%d(%d)] %s %s", index, child:getLocalZOrder(), nodeDesc, child:isVisible() and "visible" or "invisible")
			print(desc)
		end
	end
end
function navigator.printNode(node)
	local desc = navigator.getNodeDesc(node)
	print(desc)
end
function navigator.printAncestor(node)
	if node == nil then
		return
	end
	local _ENV, nodes
	while node ~= nil do
		table.insert(nodes, node)
		node = node:getParent()
	end
	for index = #nodes, 1, -1 do
		local desc = navigator.getNodeDesc(nodes[index])
		local str = string.format("[%d] %s", #nodes - index, desc)
		print(str)
	end
end
function navigator.getNodeDesc(node)
	if node == nil then
		return "nil"
	else
		local infoStr = string.format("%s name(%s), type(%s), class(%s) tag(%d)", tostring(node), node:getName() or nil, tolua.type(node) or nil, node.__cname or "nil", node:getTag() or "nil")
		local sprite
		if tolua.type(node) == "cc.Sprite" then
			sprite = node
		elseif tolua.type(node) == "ccui.ImageView" then
			sprite = node:getVirtualRenderer():getSprite()
		elseif tolua.type(node) == "ccui.Button" then
			sprite = node:getNormalRenderer():getSprite()
		end
		if sprite then
		end
		return infoStr
	end
end
function navigator.getNodePosInfo(node)
	if node == nil then
		return "nil"
	else
		local infoStr = string.format("groupId %d index %d zorder %d %s pos %f,%f size %f,%f, scale %f,%f opacity %f anchorPoint %f,%f ", node:getGroupID(), navigator.getChildIndex(node), node:getLocalZOrder(), node:isVisible() and "visible" or "invisible", node:getPositionX(), node:getPositionY(), node:getContentSize().width, node:getContentSize().height, node:getScaleX(), node:getScaleY(), node:getOpacity(), node:getAnchorPoint().x, node:getAnchorPoint().y)
		return infoStr
	end
end
function navigator.toggleNode(node)
	if node == nil then
		return
	end
	node:setVisible(not node:isVisible())
end
function navigator.hideSibling(target, root)
	print("hideSibling")
	while target ~= root and target ~= nil do
		local parent = target:getParent()
		local children = parent:getChildren()
		for _, child in pairs(children) do
			if child == target then
				child:setVisible(true)
			else
				child:setVisible(false)
			end
		end
		target = parent
	end
end
function navigator.showAllChildren(parent, show)
	print("showAllChildren")
	local children = parent:getChildren()
	for _, child in pairs(children) do
		child:setVisible(show)
	end
end
function navigator.showAllOffSpring(root, show)
	print("showAllOffSpring")
	root:setVisible(show)
	local children = root:getChildren()
	for _, child in pairs(children) do
		navigator.showAllOffSpring(child, show)
	end
end
function navigator.printAllOffSpring(root, index, prefix)
	local nodeDesc = navigator.getNodeDesc(root)
	local desc = string.format("[%d(%d)] %s %s", index or 0, root:getLocalZOrder(), nodeDesc, root:isVisible() and "visible" or "invisible")
	if prefix ~= nil then
		desc = prefix .. desc
	end
	print(desc)
	if prefix ~= nil then
		prefix = " " .. prefix
	else
		prefix = " "
	end
	local children = root:getChildren()
	for childIndex, child in ipairs(children) do
		navigator.printAllOffSpring(child, childIndex, prefix)
	end
end
local _ENV, hooker = function(root, index, prefix)
	local nodeDesc = navigator.getNodeDesc(root)
	local desc = string.format("[%d(%d)] %s %s", index or 0, root:getLocalZOrder(), nodeDesc, root:isVisible() and "visible" or "invisible")
	if prefix ~= nil then
		desc = prefix .. desc
	end
	print(desc)
	if prefix ~= nil then
		prefix = " " .. prefix
	else
		prefix = " "
	end
	local children = root:getChildren()
	for childIndex, child in ipairs(children) do
		navigator.printAllOffSpring(child, childIndex, prefix)
	end
end, function(root, index, prefix)
	local nodeDesc = navigator.getNodeDesc(root)
	local desc = string.format("[%d(%d)] %s %s", index or 0, root:getLocalZOrder(), nodeDesc, root:isVisible() and "visible" or "invisible")
	if prefix ~= nil then
		desc = prefix .. desc
	end
	print(desc)
	if prefix ~= nil then
		prefix = " " .. prefix
	else
		prefix = " "
	end
	local children = root:getChildren()
	for childIndex, child in ipairs(children) do
		navigator.printAllOffSpring(child, childIndex, prefix)
	end
end
function hooker.pack(...)
	_ENV = nil
	;(nil).n = select("#", ...)
	;(nil)[1] = ...
	;(nil)[2] = ...
	;(nil)[3] = ...
	return nil
end
function hooker.logHook(obj, functionName, tag, dumParams)
	if tag == nil then
		tag = obj.__cname
	end
	local logFun = function(name, ...)
		print("calling ", tag, name)
		if dumParams then
			local args = hooker.pack(...)
			print("args number ", args.n)
			for i = 1, args.n do
				local arg = args[i]
				dump(arg, "msg", 8)
			end
		end
	end
	hooker.setHook(obj, functionName, logFun, true)
end
function hooker.isTargetKey(key, functionName)
	if type(functionName) == "string" then
		return key == functionName
	elseif type(functionName) == "function" then
		return functionName(key)
	end
	return true
end
function hooker.setHook(obj, functionName, newFun, passingFunctionName, replace)
	local targetObj = obj
	local _ENV, keys
	if type(obj) == "userdata" then
		targetObj = debug.getfenv(obj)
	end
	while targetObj ~= nil do
		for key, _ in pairs(targetObj) do
			if key ~= "__index" and key ~= "__newindex" and hooker.isTargetKey(key, functionName) then
				keys[key] = true
			end
		end
		targetObj = getmetatable(targetObj)
	end
	local packedParams = function(funName, ...)
		if passingFunctionName then
			return funName, ...
		else
			return ...
		end
	end
	local info = obj._hookerInfo_
	if info == nil then
		info, _ENV = pairs(targetObj)
		obj._hookerInfo_ = info
	end
	for key, _ in pairs(keys) do
		local objType = type(obj[key])
		if objType == "function" then
			local lastFun = obj[key]
			local oriFun = lastFun
			local funcInfo = info[key]
			if funcInfo ~= nil then
				oriFun = funcInfo.oriFun
			end
			_ENV, obj[key] = function(...)
				if not replace then
					newFun(packedParams(key, ...))
					return oriFun(...)
				else
					return newFun(packedParams(key, ...))
				end
			end, function(...)
				if not replace then
					newFun(packedParams(key, ...))
					return oriFun(...)
				else
					return newFun(packedParams(key, ...))
				end
			end
			;(function(...)
				if not replace then
					newFun(packedParams(key, ...))
					return oriFun(...)
				else
					return newFun(packedParams(key, ...))
				end
			end).oriFun = oriFun
			info[key], (function(...)
				if not replace then
					newFun(packedParams(key, ...))
					return oriFun(...)
				else
					return newFun(packedParams(key, ...))
				end
			end).hookFun = function(...)
				if not replace then
					newFun(packedParams(key, ...))
					return oriFun(...)
				else
					return newFun(packedParams(key, ...))
				end
			end, obj[key]
			print("function ", key, " hooked")
		end
	end
end
function hooker.hasHook(target)
	local info = target._hookerInfo_
	return info ~= nil
end
function hooker.switchHook(target)
	local info = target._hookerInfo_
	if info ~= nil then
		for key, vals in pairs(info) do
			local hookFun = vals.hookFun
			local curFun = target[key]
			local oriFun = vals.oriFun
			if curFun == hookFun then
				target[key] = oriFun
				print("fun ", key, " restored")
			elseif curFun == oriFun then
				target[key] = hookFun
				print("fun ", key, " hooked")
			end
		end
	end
end
function hooker.resetHook(target)
	local info = target._hookerInfo_
	if info ~= nil then
		for key, vals in pairs(info) do
			local oriFun = vals.oriFun
			target[key] = oriFun
			print("fun ", key, " restored")
		end
	end
end
function hooker.hookMsg(hookRev, hookSend)
	if hookRev then
		local msgCtrl = include("msgCtrl")
		if hooker.hasHook(msgCtrl) then
			hooker.switchHook(msgCtrl)
		else
			hooker.logHook(msgCtrl, "handle", "recMsg", true)
		end
	end
	if hookSend then
		local serverproxy = gModuleMgr.getObject("serverproxy")
		local gate = serverproxy.gate_
		if hooker.hasHook(gate) then
			hooker.switchHook(gate)
		else
			hooker.logHook(gate, "sendrequest", "sendMsg", true)
		end
	end
end
local _ENV, remoteCommander = function(hookRev, hookSend)
	if hookRev then
		local msgCtrl = include("msgCtrl")
		if hooker.hasHook(msgCtrl) then
			hooker.switchHook(msgCtrl)
		else
			hooker.logHook(msgCtrl, "handle", "recMsg", true)
		end
	end
	if hookSend then
		local serverproxy = gModuleMgr.getObject("serverproxy")
		local gate = serverproxy.gate_
		if hooker.hasHook(gate) then
			hooker.switchHook(gate)
		else
			hooker.logHook(gate, "sendrequest", "sendMsg", true)
		end
	end
end, function(hookRev, hookSend)
	if hookRev then
		local msgCtrl = include("msgCtrl")
		if hooker.hasHook(msgCtrl) then
			hooker.switchHook(msgCtrl)
		else
			hooker.logHook(msgCtrl, "handle", "recMsg", true)
		end
	end
	if hookSend then
		local serverproxy = gModuleMgr.getObject("serverproxy")
		local gate = serverproxy.gate_
		if hooker.hasHook(gate) then
			hooker.switchHook(gate)
		else
			hooker.logHook(gate, "sendrequest", "sendMsg", true)
		end
	end
end
function remoteCommander.connect(ip, port)
	if __socket ~= nil then
		__socket:close()
		__socket = nil
	end
	local socket = net.SocketTCP.new()
	socket:setName("testSocket")
	socket:setTickTime(0.1)
	socket:setReconnTime(6)
	socket:setConnFailTime(15)
	local processCmd = function(event)
		if event.data == nil then
			return
		end
		local f = loadstring(event.data)
		f()
	end
	socket:addEventListener(socket.EVENT_DATA, processCmd)
	socket:addEventListener(socket.EVENT_CLOSE, function()
		print("socket close")
	end)
	socket:addEventListener(socket.EVENT_CLOSED, function()
		print("socket closed")
	end)
	socket:addEventListener(socket.EVENT_CONNECTED, function()
		print("socket connected")
	end)
	socket:addEventListener(socket.EVENT_CONNECT_FAILURE, function()
		print("socket failed")
	end)
	__socket = socket
	__socket:connect(ip, port)
	print("connectting")
end
function remoteCommander.redirectLog(ip, port)
	if __logSocket ~= nil then
		__logSocket:close()
		__logSocket = nil
	end
	local socket = net.SocketTCP.new()
	socket:setName("testSocket")
	socket:setTickTime(0.1)
	socket:setReconnTime(6)
	socket:setConnFailTime(15)
	local processCmd = function(event)
		if event.data == nil then
			return
		end
		print("receive data", event.data)
	end
	socket:addEventListener(socket.EVENT_DATA, processCmd)
	socket:addEventListener(socket.EVENT_CLOSE, function()
		socket.__connected = false
		print("socket close")
	end)
	socket:addEventListener(socket.EVENT_CLOSED, function()
		socket.__connected = false
		print("socket closed")
	end)
	socket:addEventListener(socket.EVENT_CONNECTED, function()
		socket.__connected = true
		print("socket connected")
	end)
	socket:addEventListener(socket.EVENT_CONNECT_FAILURE, function()
		socket.__connected = false
		print("socket failed")
	end)
	local oldPrint = __oriPrint
	if __oriPrint == nil then
		oldPrint = print
	end
	function print(...)
		if __logSocket ~= nil and __logSocket.__connected then
			_ENV = __logSocket.__connected
			__logSocket.__connected[1] = ...
			__logSocket.__connected[2] = ...
			__logSocket.__connected[3] = ...
			__logSocket.__connected[4] = ...
			__logSocket.__connected[5] = ...
			__logSocket.__connected[6] = ...
			__logSocket.__connected[7] = ...
			__logSocket.__connected[8] = ...
			local __logSocket.__connected[9], args = ...
			local str = ""
			for _, arg in ipairs(args) do
				str = str .. tostring(arg)
			end
			__logSocket:send(str .. "\n")
		end
		if __oriPrint then
			__oriPrint(...)
		end
	end
	__oriPrint = oldPrint
	__logSocket = socket
	__logSocket:connect(ip, port)
	print("connectting")
end
function remoteCommander.redirectResServer(ip, port)
	print("remoteCommander.redirectResServer")
	local crypt = require("crypt")
	if __logSocket ~= nil then
		__logSocket:close()
		__logSocket = nil
	end
	local _ENV, findFiles = __logSocket.close, __logSocket.close
	local receiveFile = ""
	local socket = net.SocketTCP.new()
	socket:setName("testSocket")
	socket:setTickTime(0.1)
	socket:setReconnTime(6)
	socket:setConnFailTime(15)
	__logSocket = socket
	local sendSize = 307200
	local processCmd = function(event)
		print("remoteCommander.redirectResServer processCmd")
		if event.data == nil then
			return
		end
		local fileTag = string.find(receiveFile, "sendEnd;")
		if not fileTag then
			return
		end
		local receiveFile = string.sub(receiveFile, 1, #receiveFile - 8)
		local testScoket = require("socket")
		print("receive data length", #receiveFile)
		print("receive data", receiveFile)
		local files = string.split(receiveFile, "@")
		if type(files) == "table" then
			for m, n in pairs(files) do
				local fileName = crypt.base64decode(n)
				table.insert(findFiles, fileName)
			end
		end
		dump(findFiles, "000000000")
		for key, fileName in pairs(findFiles) do
			if cc.FileUtils:getInstance():isFileExist(fileName) then
				print("send File.....", fileName)
				local fileBase64String = cc.FileUtils:getInstance():getBase64StringFromFile(fileName)
				print("send File size.....", string.len(fileBase64String))
				local sendData = string.format("%s@%s", fileName, fileBase64String)
				if string.len(sendData) > sendSize then
					while true do
						if string.len(sendData) <= sendSize then
							print(#(sendData .. "allSize;"))
							socket:send(sendData .. "allSize;" .. "\n")
							testScoket.select(nil, nil, 0.1)
							break
						else
							local tempSendData = string.sub(sendData, 1, sendSize)
							sendData = string.sub(sendData, sendSize + 1, string.len(sendData))
							print(sendSize)
							socket:send(tempSendData .. "\n")
							testScoket.select(nil, nil, 0.1)
						end
					end
				else
					testScoket.select(nil, nil, 0.01)
					print(#sendData)
					socket:send(sendData .. "allSize;" .. "\n")
				end
			end
		end
		socket:send("finishEnd;" .. "\n")
	end
	socket:addEventListener(socket.EVENT_DATA, processCmd)
	socket:addEventListener(socket.EVENT_CLOSE, function()
		socket.__connected = false
		print("socket close")
	end)
	socket:addEventListener(socket.EVENT_CLOSED, function()
		socket.__connected = false
		print("socket closed")
	end)
	socket:addEventListener(socket.EVENT_CONNECTED, function()
		socket.__connected = true
		print("socket connected")
	end)
	socket:addEventListener(socket.EVENT_CONNECT_FAILURE, function()
		socket.__connected = false
		print("socket failed")
	end)
	__logSocket:connect(ip, port)
	print("connectting")
end
function test.connectToCommandServer(ip, port)
	if ip == nil then
		ip = "127.0.0.1"
	end
	if port == nil then
		port = 53145
	end
	if type(port) ~= "number" then
		port = tonumber(port)
	end
	remoteCommander.connect(ip, port)
end
function test.connectToLogServer(ip, port)
	if ip == nil then
		ip = "127.0.0.1"
	end
	if port == nil then
		port = 52137
	end
	if type(port) ~= "number" then
		port = tonumber(port)
	end
	remoteCommander.redirectLog(ip, port)
end
function test.downloadFile(ip, filePath, onSuccess, onFail)
	local fileDir = ""
	local fileName = filePath
	local index = filePath:find("/[^/]*$")
	if index ~= nil then
		fileDir = filePath:sub(1, index - 1)
		fileName = filePath:sub(index + 1)
	end
	local url = "http://" .. ip .. ":9099/" .. filePath
	local xhr = cc.XMLHttpRequest:new()
	xhr._urlFileName = fileName
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", url)
	local onDownloadFile = function()
		if xhr.readyState == 4 and xhr.status == 200 then
			local fileData = xhr.response
			local fullFileName = cc.FileUtils:getInstance():getWritablePath() .. "updatePersion"
			if fileDir ~= "" then
				fullFileName = fullFileName .. "/" .. fileDir
			end
			cc.FileUtils:getInstance():createDirectory(fullFileName)
			fullFileName = fullFileName .. "/" .. xhr._urlFileName
			local file = io.open(fullFileName, "wb")
			file:write(fileData)
			file:close()
			if onSuccess then
				onSuccess(filePath)
			end
		elseif onFail then
			onFail(filePath)
		end
	end
	xhr:registerScriptHandler(onDownloadFile)
	xhr:send()
end
function test.connectIp(ipStr)
	if device.platform == "mac" or ipStr == "" then
		return
	end
	local surl = "http://" .. ipStr .. ":9099/" .. "test.lua"
	local xhr = cc.XMLHttpRequest:new()
	xhr._urlFileName = "test.lua"
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", surl)
	local onDownloadTest = function()
		print("xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
		if xhr.readyState == 4 and xhr.status >= 200 and xhr.status < 207 then
			local fileData = xhr.response
			local fullFileName = cc.FileUtils:getInstance():getWritablePath() .. "updatePersion"
			io.mkdir(fullFileName)
			fullFileName = fullFileName .. "/" .. xhr._urlFileName
			print("fullFileName:", fullFileName)
			local file = io.open(fullFileName, "wb")
			file:write(fileData)
			file:close()
			SoraDShowMsgTip("test.lua 更新成功!")
		else
			SoraDShowMsgTip("test.lua 更新失败!")
		end
	end
	xhr:registerScriptHandler(onDownloadTest)
	xhr:send()
end
function test.cmdRemoteDebug(ip)
	if ip == nil then
		ip = "127.0.0.1"
	end
	local mobdebug
	if cc.FileUtils:getInstance():isFileExist("mobdebug.lua") then
		mobdebug = require("mobdebug")
	end
	if mobdebug then
		mobdebug.start(ip)
	else
		test.downloadFile(ip, "mobdebug.lua", function()
			package.loaded.mobdebug = nil
			mobdebug.start(ip)
		end)
	end
end
function test.connectToResServer(ip, port)
	remoteCommander.redirectResServer(ip, port)
end
function test.cmdMsgLog(rec, sent)
	DEBUG_REC_MSG = rec
	DEBUG_SEND_MSG = sent
end
function test.main()
	remoteCommander.connect("192.168.10.149", 53145)
end
function test.getBuildCell(slotId)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildlist = cityCtrl:getBuildList()
	for _, buildcellitem in pairs(buildlist) do
		if buildcellitem.info and buildcellitem.info.index and tonumber(buildcellitem.info.index) == slotId then
			return buildcellitem
		end
	end
	return nil
end
function test.setRes(slotId, res)
	local buildCell = test.getBuildCell(slotId)
	if buildCell and buildCell.info and buildCell.info.curres then
		buildCell.info.curres = tostring(res)
	end
end
function test.getTarget()
	local mainScene = display.getRunningScene()
	local view = mainScene.testView or mainScene.currentShowView
	return view
end
function test.cmdT()
	print("ZeroBrane Studio 启用调试------")
	require("mobdebug").start()
end
function test.cmdHookCurNode()
	local target = navigator.getCurNode()
	hooker.logHook(target, nil, "curNode", true)
end
function test.cmdConnetLogServer(ip)
	if ip == nil then
		ip = "127.0.0.1"
	end
	remoteCommander.redirectLog(ip, 52137)
end
function test.cmdB()
	local mainScene = display.getRunningScene()
	navigator.setCurNode(mainScene)
	navigator.printCurNode()
	navigator.showCurNodeMark(true)
end
function test.cmdDumpTexture()
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	printInfo(sharedTextureCache:getCachedTextureInfo())
end
function test.cmdP()
	if cc.Director:getInstance():isPaused() then
		print("resume")
		cc.Director:getInstance():resume()
	else
		cc.Director:getInstance():pause()
		print("pause")
	end
end
_ENV = nil
;(nil).__index = navigator
setmetatable(test, nil)
function test.cc()
	print("cc")
	test.connectToCommandServer("192.168.18.118", 53145)
	if device.platform ~= "mac" then
		test.connectToLogServer("192.168.18.118", 52137)
	end
end
function test.setNormalServer()
	_UPVALUE2_ = nil
	gSvrConfig.updateAddr, (nil)[1] = nil, "http://boeveliaversion.menaapp.net/index.php?p=%s&v=%s"
	gSvrConfig.updateAddr, (nil)[2] = nil, "http://boeawsversion.menaapp.net/index.php?p=%s&v=%s"
	gSvrConfig.ip = "47.254.175.61"
	gSvrConfig.loginPort = 10000
	gSvrConfig.WebMaintainURL = "http://boeevent.onemt.co/game/eventnotice/notice?appid=%s&kid=%s&lang=%s"
	gSvrConfig.lordLevelUpURL = "http://boeaction.onemt.co/upgrade?level=%s&source=%s&inviteCode=%s&name=%s"
	gSvrConfig.shareFaceBookURL = "http://boeaction.onemt.co/invite?inviteCode=%s&source=%s&name=%s"
end
function test.cmdSave()
	local _ENV, obj
	obj.cmd = "cc"
	obj.params, _ENV, obj.delay = nil, nil, 1
	local crypt = require("crypt")
	local strAct = util.serialize(obj)
	local strBase64 = crypt.base64encode(strAct)
	SoraDConfigSet("System:preStartAction~string", strBase64)
end
function test.cmdUnSave()
	SoraDConfigSet("System:preStartAction~string", nil)
end
function test.cmdSdkLogin()
	test.setNormalServer()
	userSDKManager.login("")
end
function test.cmdIdLogin(id)
	if id == nil then
		id = "a6c6a4b454224faa9c872eec4d545679"
	end
	test.setNormalServer()
	userSDKManager.userid = id
	SoraDStartLoginServer()
end
function test.cmdNoDump()
	function dump()
	end
end
function test.switchI18n()
	if __oldI18n == nil then
		__oldI18n = i18n
		function i18n(text)
			return text
		end
	else
		i18n = __oldI18n
		__oldI18n = nil
	end
end
function test.cmdReleaseRes()
	AppDidReceiveMemoryWarning()
end
function test.cmd0()
	local GameModule = include("GameModule")
	local gametop = gModuleMgr.getObject("gametop")
	local artifactCtrl = gametop.playertop_:getModule("artifactCtrl")
	artifactCtrl:getRuneDataInBag(1)
end
function test.cmd1()
	hooker.hookMsg(true, true)
	local GameModule = include("GameModule")
	local gametop = gModuleMgr.getObject("gametop")
	local serverproxy = gModuleMgr.getObject("serverproxy")
	hooker = nil
	;(nil).idPage = 2
	serverproxy:Request("2065", "8", nil)
end
function test.cmd9()
	SoraDDebugSendGmCmd("/fsxylb 1 22 7170001")
end
function test.cmd2()
	SoraDDebugSendGmCmd("/czlb add 70008 70166")
	SoraDDebugSendGmCmd("/czlb add 80009 80014")
	SoraDDebugSendGmCmd("/fsxylb 2")
end
_ENV, _ENV, test.setScale = test, function(scale)
	g_scale = scale
end, function(scale)
	g_scale = scale
end
test.keyName = "..B(根节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdB, test.color = test, test, cc.c3b(0, 255, 255)
test.keyName = "..H(上一节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdH, test.color = test, test, cc.c3b(0, 255, 255)
test.keyName = "..L(下一节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdL, test.color = test, test, cc.c3b(0, 255, 255)
test.keyName = "..J(父节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdJ, test.color = test, test, cc.c3b(0, 255, 255)
test.keyName = "..K子节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdK, test.color = test, test, cc.c3b(0, 255, 255)
test.keyName = "...C(点击处上一节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdC, test.color = test, test, cc.c3b(0, 255, 0)
test.keyName = "...X(点击处下一节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdX, test.color = test, test, cc.c3b(0, 255, 0)
test.keyName = "...Z(点选节点)"
_ENV, (function(scale)
	g_scale = scale
end).cmdZ, test.color = test, test, cc.c3b(0, 255, 0)
test.keyName = " ip连接"
test.keyInfo, (function(scale)
	g_scale = scale
end).connectIp, test.color = function(scale)
	g_scale = scale
end, test, cc.c3b(0, 255, 0)
function test.cmd3()
	SoraDDebugSendGmCmd("/fsxylb 2")
end
local file = "sprite3d/eluosiwangfei/eluosiwangfei_001_body_n.png"
function test.cmd4()
	local updateModule = require("app.game.updateModule.updateModule")
	local state = updateModule:getInstance():getHdResFileState(file)
	print("state ", state)
	print("filePri ", updateModule:getInstance():getHdResFilePriority(file))
	print("pausePri ", updateModule:getInstance():getHdResPausePriority())
end
function test.cmd5()
	local updateModule = require("app.game.updateModule.updateModule")
	updateModule:getInstance():setHdResFilePriority(file, 44)
	capi_hd_res_set_pause_download_priority(-1)
	updateModule:getInstance():resumeDownloadHdRes()
end
function test.cmd6()
	_ENV, _UPVALUE1_ = nil, nil
	;(nil).id = gIDType.DEVIL_VALLEY_POINT
	;(nil).count = 33333
	;(nil)[1] = nil
	SoraDMailGainItems(nil, true)
end
function test.cmd7()
	g_curNode:setPosition(0, 0)
end
function test.cmd8()
	g_curNode:setGroupID(52000)
end
if gIsHideMainUI == nil then
	gIsHideMainUI = true
end
function test.cmd_59()
	print("作弊指令------空格-------")
	gIsHideMainUI = not gIsHideMainUI
	print("gIsHideMainUI = ", gIsHideMainUI)
	_ENV = print
	print.isHideCurrentSceneView = false
	local print.isHideMainUI, hideData = gIsHideMainUI, print
	SoraDHideCurrentSceneViewAndMainUI(hideData)
end
local addZoomScale = function(isAdd)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local worldMapViewDef = include("worldMapViewDef")
	local viewScrollView = worldMapView.viewScrollView
	local zoomScale = viewScrollView:getZoomScale()
	local step = 0.1
	if not isAdd then
		step = -step
	end
	zoomScale = zoomScale + step
	zoomScale = math.min(math.max(zoomScale, worldMapViewDef.MIN_SCALE), worldMapViewDef.MAX_SCALE)
	viewScrollView:setZoomScale(zoomScale)
end
test["cmd_" .. cc.KeyCode.KEY_KP_PLUS] = function()
	addZoomScale(true)
end
test["cmd_" .. cc.KeyCode.KEY_KP_MINUS] = function()
	addZoomScale()
end
return test
