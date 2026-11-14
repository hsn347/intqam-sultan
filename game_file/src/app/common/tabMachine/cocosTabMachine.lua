local tabMachine = require("app.common.tabMachine.tabMachine")
local cocosTabMachine = class("cocosTabMachine", tabMachine)
local cocosContext = require("app.common.tabMachine.cocosContext")
function cocosTabMachine:ctor()
	tabMachine.ctor(self)
	self._updateTimer = nil
	self._tickTimer = nil
	self._scheduler = self:createSystemScheduler()
end
function cocosTabMachine:createSystemScheduler()
	local cocosScheduler = cc.Director:getInstance():getScheduler()
	local actionManager = cc.Director:getInstance():getActionManager()
	return self:createScheduler(cocosScheduler, actionManager, nil)
end
function cocosTabMachine:createScheduler(cocosScheduler, actionManager, ctrl)
	local _ENV, scheduler
	function scheduler:createTimer(callback, interval)
		if interval == 0 or interval == nil then
			return cocosScheduler:scheduleScriptFunc(callback, 0, false)
		else
			return cocosScheduler:scheduleScriptFunc(callback, interval, false)
		end
	end
	function scheduler:destroyTimer(handler)
		cocosScheduler:unscheduleScriptEntry(handler)
	end
	function scheduler:getCocosScheduler()
		return cocosScheduler
	end
	function scheduler:getActionManager()
		return actionManager
	end
	function scheduler:isUsingDirectorScheduler()
		return cocosScheduler == cc.Director:getInstance():getScheduler()
	end
	function scheduler:pause()
		if ctrl then
			ctrl:pause()
		end
	end
	function scheduler:resume()
		if ctrl then
			ctrl:resume()
		end
	end
	function scheduler:setTimeScale(timeScale)
		if ctrl then
			ctrl:setTimeScale(timeScale)
		else
			cocosScheduler:setTimeScale(timeScale)
		end
	end
	function scheduler:getTimeScale()
		if ctrl then
			return ctrl:getTimeScale()
		else
			return cocosScheduler:getTimeScale()
		end
	end
	function scheduler:isPaused()
		if ctrl then
			return ctrl:isPaused()
		else
			return false
		end
	end
	return scheduler
end
function cocosTabMachine:getScheduler()
	return self._scheduler
end
function cocosTabMachine:getObject(path)
	if self._rootContext == nil then
		return nil
	end
	return self._rootContext:getObject(path)
end
function cocosTabMachine:_onStopped()
	print("machine stopped")
	tabMachine._onStopped(self)
end
function cocosTabMachine:_createContext(tab, ...)
	if tab ~= nil and tab.isTabClass then
		return tab.new(...)
	else
		local cocosContext, c = tab.new, tab.new
		local class = tab and tab.class or cocosContext
		cocosContext = ...
		....__index = function(t, k)
			return tab and tab[k] or class[k]
		end
		setmetatable(c, ...)
		c.class = class
		c:ctor(...)
		return c
	end
end
function cocosTabMachine:_createException(errorMsg, isTabMachineError)
	local e = tabMachine._createException(self, errorMsg, isTabMachineError)
	e.luaErrorMsg = errorMsg
	e.luaStackTrace = tostring(debug.traceback("", 2))
	return e
end
function cocosTabMachine:_addContextException(e, context)
	if e.tabStacks == nil then
		e.tabStacks, _ENV = e.tabStacks, e.tabStacks
	end
	local _ENV, tabStack = e.tabStacks, e.tabStacks
	table.insert(e.tabStacks, tabStack)
	local c = context
	if c ~= nil then
		e.pcName = c._pcName
		e.pcAction = c._pcAction
	end
	while c ~= nil do
		local _ENV, pc = c._pcAction, c._pcAction
		pc.pcName = c._pcName
		pc.pcAction = c._pcAction
		pc.name = c._name
		pc.nickName = c._nickName
		if c.__cname ~= "cocosContext" and c.__cname ~= nil then
			pc.className = c.__cname
		end
		table.insert(tabStack, pc)
		c = c._pp
	end
end
function cocosTabMachine:_onUnCaughtException(e)
	dump(e, "uncaught exception", 100)
	local eMsg = ""
	local errorMsg = e.errorMsg or "no errorMsg"
	local reportVals = self:getObject("report") and self:getObject("report"):getTreeMsg() or "no reportVals"
	if e.tabStacks then
		if not e.tabStacks then
			_ENV = e.tabStacks
		end
		if self:prettyStr(e.tabStacks) then
			goto lbl_36
		end
	end
	local tabStacks = "no tabStacks"
	::lbl_36::
	local luaStackTrace = e.luaStackTrace or "no luaStackTrace"
	local tabTreeInfo = self._rootContext and self._rootContext:getTreeMsg() or ""
	local strTop = "==== errorMsg ====\n"
	eMsg = eMsg .. strTop .. errorMsg
	strTop = [[


==== reportVals ====
]]
	eMsg = eMsg .. strTop .. reportVals
	strTop = [[


==== tabStacks ====
]]
	eMsg = eMsg .. strTop .. tabStacks
	strTop = [[


==== luaStackTrace ====
]]
	eMsg = eMsg .. strTop .. luaStackTrace
	strTop = [[


==== tabTreeInfo ====
]]
	eMsg = eMsg .. strTop .. tabTreeInfo
	if fabric then
		fabric:getInstance():allSet(tostring(errorMsg), eMsg)
	end
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isReportError() then
		_UPVALUE2_ = eMsg
		eMsg[1] = "下次不再显示"
		eMsg[2] = "复制"
		device.showAlert("出错了,测试使用,请截图", tostring(eMsg), eMsg, function(event)
			SoraDCopyText(tostring(eMsg))
		end)
	end
end
function cocosTabMachine:_disposeContext(context)
	if context.dispose then
		context:dispose()
	end
end
function cocosTabMachine:prettyStr(arr)
