local tabMachine = class("tabMachine")
g_t, _ENV, tabMachine.context = class("context"), class("context"), class("context")
_UPVALUE10_ = "context"
g_t.anyOutputVars, ("context")[1] = "context", "a1"
g_t.anyOutputVars, ("context")[2] = "context", "a2"
g_t.anyOutputVars, ("context")[3] = "context", "a3"
g_t.anyOutputVars, ("context")[4] = "context", "a4"
g_t.anyOutputVars, ("context")[5] = "context", "a5"
g_t.anyOutputVars, ("context")[6] = "context", "a6"
g_t.anyOutputVars, ("context")[7] = "context", "a7"
g_t.anyOutputVars, ("context")[8] = "context", "a8"
g_t.anyOutputVars, ("context")[9] = "context", "a9"
g_t.anyOutputVars, ("context")[10] = "context", "a10"
local context = tabMachine.context
tabMachine.event_context_stop = "context_stop"
tabMachine.event_context_enter = "context_enter"
tabMachine.event_proxy_attached = "proxy_attached"
local outputValues = function(env, outputVars, outputValues)
	for i, var in ipairs(outputVars) do
		if var ~= nil then
			if outputValues == nil then
				env[var] = nil
			else
				env[var] = outputValues[i]
			end
		end
	end
end
function tabMachine:ctor()
	self._isRunning = false
	self._rootContext = nil
	self._outputs = nil
	self._tab = nil
	self._curContext = nil
	self._tickIndex = 0
	self._contextStack, _UPVALUE0_, self._debugger = nil, nil, nil
	self._curStackNum = 0
end
function tabMachine:installTab(tab)
	local subContext = self:_createContext(tab)
	subContext.tm = self
	subContext.p = nil
	subContext._name = "root"
	subContext._isRoot = true
	self._rootContext = subContext
	self._tab = tab
	self._rootContext:_installTab(tab)
end
function tabMachine:setDebugger(debugger)
	self._debugger = debugger
end
function tabMachine:getDebugger()
	return self._debugger
end
function tabMachine:getScheduler()
	return self._scheduler
end
function tabMachine:setScheduler(scheduler)
	self._scheduler = scheduler
	if self._rootContext then
		self._rootContext:setScheduler(scheduler)
	end
end
function tabMachine:start(...)
	if self._debugger then
		self._debugger:onMachineStart(self)
	end
	if self._tab == nil then
		return
	end
	self._isRunning = true
	self._rootContext:_enter(...)
end
function tabMachine:notify(msg, level)
	self._rootContext:notify(msg, level)
end
function tabMachine:stop()
	self._rootContext:stop()
end
function tabMachine:isRunning()
	return self._isRunning
end
function tabMachine:getOutputs()
	if self._outputs then
		return unpack(self._outputs)
	end
	return nil
end
function tabMachine:_setOutputs(outputValues)
	self._outValues = outputValues
end
function tabMachine:_onStopped()
	self._isRunning = false
	self._rootContext = nil
end
function tabMachine:_createContext(...)
	return context.new(...)
end
function tabMachine:_pcall(target, f, selfParam, ...)
	local on_error = function(errorMsg)
		if gVSDebugXpCall then
			gVSDebugXpCall()
		end
		local e = self:_createException(errorMsg)
		local i = self._curStackNum
		local catched = true
		while 0 < i do
			local context = self._contextStack[i].context
			if not target:_throwException(e) then
				self:_addContextException(e, context)
				catched = false
			end
			i = i - 1
			local lastContext = context
			while 0 < i do
				local context = self._contextStack[i].context
				if context == lastContext._pp or context == lastContext then
					lastContext = context
					i = i - 1
				else
					break
				end
			end
		end
		if not catched then
			self:_onUnCaughtException(e)
		end
	end
	local curContextInfo
	self._curStackNum = self._curStackNum + 1
	if #self._contextStack < self._curStackNum then
		curContextInfo, _ENV = #self._contextStack, #self._contextStack
		curContextInfo.context = target
		table.insert(self._contextStack, curContextInfo)
	else
		curContextInfo = self._contextStack[self._curStackNum]
		curContextInfo.context = target
	end
	local a1, a2, a3, a4, a5, a6, a7, a8, a9, a10 = ...
	local stat, result = xpcall(function()
		return f(selfParam, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	end, on_error)
	curContextInfo.context = nil
	self._curStackNum = self._curStackNum - 1
	if stat then
		return result
	end
	return nil
end
function tabMachine:_createException(errorMsg)
	local _UPVALUE0_, exception
	exception.errorMsg = errorMsg
	exception.isCustom = false
	return exception
end
function tabMachine:_addContextException(e, context)
end
function tabMachine:_onUnCaughtException(e)
end
function tabMachine:_disposeContext(context)
end
function context:ctor()
	self.v, _UPVALUE0_, self._enterCount = nil, nil, 0
end
function context:_getPath()
	local c = self
	local name
	while c do
		if name == nil then
			name = c._name
		else
			name = c._name .. "." .. name
		end
		c = c._pp
	end
	return name
end
function context:getSub(scName)
	local curContext = self._tailSubContext
	while curContext ~= nil do
		if curContext.p == self and curContext._name == scName then
			return curContext
		end
		curContext = curContext._preContext
	end
	return nil
end
function context:hasAnySub()
	return self._headSubContext ~= nil
end
function context:_setPc(pc, pcName, action)
	self._pc = pc
	self._pcName = pcName
	self._pcAction = action
end
function context:start(scName, ...)
	if self._isStopped then
		return
	end
	if self._tab == nil then
		return
	end
	self:_setPc(self, "self", scName)
	self:_addEnterCount()
	local sub = self._tab[scName]
	if sub == nil then
		self:_decEnterCount()
		return
	end
	local debugger = self._debugger
	if debugger then
		debugger:onContextStart(self, scName)
	end
	local subUpdateFunEx = self._tab[scName .. "_update"]
	local subUpdateIntevalEx = self._tab[scName .. "_updateInterval"]
	local subEventFunEx = self._tab[scName .. "_event"]
	local subTickFunEx = self._tab[scName .. "_tick"]
	local subFinalFunEx = self._tab[scName .. "_final"]
	local subCatchFunEx = self._tab[scName .. "_catch"]
	if subUpdateFunEx == nil and subTickFunEx == nil and subEventFunEx == nil then
		if subCatchFunEx == nil then
			self._curSubCatchFun = subCatchFunEx
			self.tm:_pcall(self, sub, self, ...)
			self._curSubCatchFun = nil
			self:_checkNext(scName)
			if subFinalFunEx ~= nil then
				self.tm:_pcall(self, subFinalFunEx, self, ...)
			end
		else
			local subContext = self.tm:_createContext()
			subContext.tm = self.tm
			subContext.p = self
			subContext._pp = self
			subContext._name = scName
			subContext._finalFunEx = subFinalFunEx
			subContext._catchFunEx = subCatchFunEx
			self:_addSubContext(subContext)
			subContext:_prepareEnter()
			if sub ~= nil then
				subContext:_setPc(subContext, "self", "start")
				self._curSubCatchFun = subCatchFunEx
				self.tm:_pcall(self, sub, self, ...)
				self._curSubCatchFun = nil
			end
			subContext:stop()
		end
	else
		local subContext = self.tm:_createContext()
		subContext.tm = self.tm
		subContext.p = self
		subContext._pp = self
		subContext._name = scName
		subContext._updateFunEx = subUpdateFunEx
		subContext._updateIntervalEx = subUpdateIntevalEx
		subContext._eventFunEx = subEventFunEx
		subContext._tickFunEx = subTickFunEx
		subContext._finalFunEx = subFinalFunEx
		subContext._catchFunEx = subCatchFunEx
		self:_addSubContext(subContext)
		subContext:_addEnterCount()
		subContext:_prepareEnter()
		if sub ~= nil then
			subContext:_setPc(subContext, "self", "start")
			self._curSubCatchFun = subCatchFunEx
			self.tm:_pcall(self, sub, self, ...)
			self._curSubCatchFun = nil
		end
	end
	self:_decEnterCount()
end
function context:call(tab, scName, outputVars, ...)
	local debugger = self._debugger
	if debugger then
		debugger:onTabCall(self, scName, tab)
	end
	if self._isStopped then
		return
	end
	self:_setPc(self, scName, "call")
	self:_addEnterCount()
	if tab == nil then
		self:_decEnterCount()
		return
	end
	local subContext = self.tm:_createContext(tab, ...)
	subContext.tm = self.tm
	subContext.p = self
	subContext._pp = self
	subContext._name = scName
	subContext:_installTab(tab)
	local subUpdateFunEx, subEventFunEx, subTickFunEx, subFinalFunEx, subCatchFunEx
	if self._tab then
		subUpdateFunEx = self._tab[scName .. "_update"]
		subEventFunEx = self._tab[scName .. "_event"]
		subTickFunEx = self._tab[scName .. "_tick"]
		subFinalFunEx = self._tab[scName .. "_final"]
		subCatchFunEx = self._tab[scName .. "_catch"]
	end
	subContext._updateFunEx = subUpdateFunEx
	subContext._eventFunEx = subEventFunEx
	subContext._tickFunEx = subTickFunEx
	subContext._finalFunEx = subFinalFunEx
	subContext._catchFunEx = subCatchFunEx
	subContext._outputVars = outputVars
	self:_addSubContext(subContext)
	subContext:_enter(...)
	self:_decEnterCount()
end
function context:_callWithContext(context, tab, scName, outputVars, ...)
	local debugger = self._debugger
	if debugger then
		debugger:onTabCall(self, scName, tab)
	end
	if self._isStopped then
		return
	end
	self:_setPc(self, scName, "call")
	self:_addEnterCount()
	if tab == nil then
		self:_decEnterCount()
		return
	end
	local subContext = self.tm:_createContext(...)
	subContext.tm = self.tm
	subContext.p = self
	subContext._pp = self
	subContext._name = scName
	subContext:_installTab(tab)
	subContext._outputVars = outputVars
	self:_addSubContext(subContext)
	subContext:_enter(...)
	self:_decEnterCount()
end
function context:throw(e)
	local _UPVALUE0_, exception
	exception.isCustom = true
	exception.e = e
	local c = self
	if c._pc ~= nil and c._pc ~= self and c._pc._pp == self then
		c = c._pc
	end
	c:_throwException(exception)
end
local joint_event = function(c, msg)
	if not c.p or c.p._isStopped then
		return false
	end
	if type(msg) == "table" and msg.eventType == tabMachine.event_context_stop and msg.p == c.p then
		c.v._unTriggeredContexts[msg.name] = nil
	end
	if not next(c.v._unTriggeredContexts) then
		if c.v._callback then
			c.v._callback()
		end
		c:stop()
	end
	return false
end
function context:join(scNames, scName, callback)
	if self._isStopped then
		return
	end
	if #scNames == 0 then
		return
	end
	self:_setPc(self, scName, "join")
	self.tm:_pcall(self, self._pJoin, self, scNames, scName, callback)
end
function context:_pJoin(scNames, scName, callback)
	local subContext = self.tm:_createContext()
	subContext.tm = self.tm
	subContext.p = self
	subContext._pp = self
	subContext._name = scName
	subContext._eventFun = joint_event
	subContext.v._unTriggeredContexts, joint_event = nil, nil
	subContext.v._callback = callback
	for _, name in ipairs(scNames) do
		self:registerLifeTimeListener(name, subContext)
		subContext.v._unTriggeredContexts[name] = true
	end
	self:_addSubContext(subContext)
	subContext:_prepareEnter()
end
function context:registerLifeTimeListener(name, listenningContext)
	if self._isStopped or listenningContext._isStopped then
		return
	end
	local oldHeadListenInfo = listenningContext._headListenInfo
	oldListenInfo = oldHeadListenInfo
	while oldListenInfo ~= nil do
		if oldListenInfo.target == self and oldListenInfo.name == name then
			return
		end
		oldListenInfo = oldListenInfo.nextInfo
	end
	_ENV = oldListenInfo.nextInfo
	oldListenInfo.nextInfo.target = self
	local oldListenInfo.nextInfo.name, listenInfo = name, oldListenInfo.nextInfo
	if oldHeadListenInfo ~= nil then
		oldHeadListenInfo.preInfo = listenInfo
		listenInfo.nextInfo = oldHeadListenInfo
	end
	listenningContext._headListenInfo = listenInfo
	if self._mapHeadListener == nil then
		self._mapHeadListener, _ENV = self._mapHeadListener, self._mapHeadListener
	end
	_ENV = self._mapHeadListener
	local self._mapHeadListener.context, listenter = listenningContext, self._mapHeadListener
	local oldHeadListener = self._mapHeadListener[name]
	if oldHeadListener then
		oldHeadListener.preListener = listenter
		listenter.nextListener = oldHeadListener
	end
	self._mapHeadListener[name] = listenter
end
function context:unregisterLifeTimeListener(name, listenningContext)
	if self._mapHeadListener == nil then
		return
	end
	local listenInfo = listenningContext._headListenInfo
	while listenInfo ~= nil do
		if listenInfo.name == name and listenInfo.target == self then
			if listenInfo.preInfo ~= nil then
				listenInfo.preInfo.nextInfo = listenInfo.nextInfo
			end
			if listenInfo.nextInfo ~= nil then
				listenInfo.nextInfo.preInfo = listenInfo.preInfo
			end
			if listenningContext._headListenInfo == listenInfo then
				listenningContext._headListenInfo = listenInfo.nextInfo
			end
			break
		end
		listenInfo = listenInfo.nextInfo
	end
	local headListener = self._mapHeadListener[name]
	local listenter = headListener
	while listenter ~= nil do
		if listenter.context == listenningContext then
			listenter.detached = true
			if listenter.preListener ~= nil then
				listenter.preListener.nextListener = listenter.nextListener
			end
			if listenter.nextListener ~= nil then
				listenter.nextListener = listenter.preListener
			end
			if headListener == listenter then
				headListener = listenter.nextListener
				self._mapHeadListener[name] = headListener
			end
			break
		end
		listenter = listenter.nextListener
	end
end
function context:tabWait(scNames, scName)
	_ENV = nil
	;(nil).s1 = function(c)
		self:join(scNames, scName, function()
			c:output(true)
			c:stop()
		end)
	end
	local (nil).s1_event, t = g_t.empty_event, nil
	return t
end
function context:tabProxy(scName, stopHostWhenStop)
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "proxy"
		end
		if self._isStopped then
			c:stop()
			return
		end
		c.v.stopHostWhenStop = stopHostWhenStop
		if scName == nil then
			c.v.host = self
		else
			local subContext = self:getSub(scName)
			if subContext ~= nil then
				c.v.host = subContext
			else
				c:start("t1")
			end
		end
		if c.v.host ~= nil then
			c.v.host:_addProxy(c)
			c:_notifyAttachEvent()
		end
	end
	;(nil).t1 = function(c)
		self:registerLifeTimeListener(scName, c:getSub("t1"))
	end
	;(nil).t1_event = function(c, msg)
		if type(msg) == "table" and msg.eventType == tabMachine.event_context_enter then
			c.v.host = msg.target
			c.v.host:_addProxy(c)
			c:_notifyAttachEvent()
			c:stop("t1")
			return true
		end
	end
	;(nil).event = g_t.empty_event
	;(nil).final = function(c)
		if c.v.host ~= nil then
			c.v.host:_removeProxy(c)
			if c.v.stopHostWhenStop and not c.v.host._isStopped then
				c.v.host:stop()
			end
		end
	end
	;(nil).getHost = function(c)
		return c.v.host
	end
	;(nil)._notifyAttachEvent = function(c)
		tabMachine = nil
		;(nil).eventType = tabMachine.event_proxy_attached
		;(nil).host = c.v.host
		local (nil).proxy, msg = c, nil
		c:upwardNotify(msg)
	end
	return nil
end
function context:tabProxyByPath(path, stopHostWhenStop)
	local beginIndex = 1
	local endIndex = path:find(".", beginIndex, true)
	if endIndex == nil then
		return self:tabProxy(path, stopHostWhenStop)
	else
		_ENV = self.tabProxy
		function self.tabProxy.s1(c)
			c.v.curNodeName = path:sub(beginIndex, endIndex - 1)
			c.v.remainPath = path:sub(endIndex + 1, #path)
		end
		function self.tabProxy.s2(c)
			c.v.sub = self:getSub(c.v.curNodeName)
			if c.v.sub ~= nil then
				c:call(c.v.sub:tabProxyByPath(c.v.remainPath, stopHostWhenStop), "s3")
			else
				c:start("t1")
			end
		end
		function self.tabProxy.s3_event(c, msg)
			if type(msg) == "table" and msg.eventType == tabMachine.event_proxy_attached then
				c.v.host = msg.host
				c:upwardNotify(msg)
				return true
			end
		end
		function self.tabProxy.t1(c)
			self:registerLifeTimeListener(c.v.curNodeName, c:getSub("t1"))
		end
		function self.tabProxy.t1_event(c, msg)
			if type(msg) == "table" and msg.eventType == tabMachine.event_context_enter then
				c:stop("t1")
				c:start("s2")
				return true
			end
		end
		function self.tabProxy.getHost(c)
			return c.v.host
		end
		return self.tabProxy
	end
end
function context:tabWaitStart(scName, ignoreCurSub)
	_ENV = nil
	;(nil).s1 = function(c)
		if g_t.debug then
			c._nickName = "waitStart"
		end
		if self._isStopped then
			return
		end
		local subContext = self:getSub(scName)
		if not ignoreCurSub and subContext ~= nil then
			return
		else
			c:start("t1")
		end
	end
	;(nil).t1 = function(c)
		self:registerLifeTimeListener(scName, c:getSub("t1"))
	end
	;(nil).t1_event = function(c, msg)
		if type(msg) == "table" and msg.eventType == tabMachine.event_context_enter then
			c:stop("t1")
			return true
		end
	end
	return nil
end
function context:hasSub(scName)
	local subContext = self._headSubContext
	while subContext do
		if subContext and subContext._name == scName then
			return true
		end
		subContext = subContext._nextContext
	end
	return false
end
function context:output(...)
	_UPVALUE0_ = nil
	self._outputValues, (nil)[1] = nil, ...
	self._outputValues, (nil)[2] = nil, ...
	self._outputValues, (nil)[3] = nil, ...
	local proxyInfo = self._headProxyInfo
	while proxyInfo ~= nil do
		proxyInfo.proxy:output(...)
		proxyInfo = proxyInfo.nextInfo
	end
end
function context:getOutputs()
	return self._outputValues
end
function context:abort(scName)
	local sc
	if scName ~= nil then
		sc = self:getSub(scName)
	else
		sc = self
	end
	if sc ~= nil then
		sc._name = "__abort" .. sc._name
		sc:stop()
	end
end
function context:stop(scName)
	if self._isStopped then
		return
	end
	if scName == nil then
		self:_stopSelf(scName)
	else
		self:_stopSub(scName)
		self:_checkStop()
	end
end
function context:stopAllSubs(scName)
	if self._isStopped then
		return
	end
	local curContext = self._tailSubContext
	while curContext ~= nil do
		if scName == nil or curContext._name == scName then
			curContext:stop()
		end
		curContext = curContext._preContext
	end
end
function context:isStopped()
	return self._isStopped
end
function context:_addSubContext(subContext)
	if self._isStopped then
		return
	end
	if self._tailSubContext == nil then
		self._headSubContext = subContext
		self._tailSubContext = subContext
	else
		subContext._preContext = self._tailSubContext
		self._tailSubContext._nextContext = subContext
		self._tailSubContext = subContext
	end
end
function context:_removeSubContext(subContext)
	if subContext.p == nil then
		return
	end
	if subContext == self._headSubContext then
		self._headSubContext = subContext._nextContext
		if self._headSubContext ~= nil and self._headSubContext.p == nil then
			self._headSubContext = nil
		end
	end
	if subContext == self._tailSubContext then
		subContext.p._tailSubContext = subContext._preContext
		if self._tailSubContext ~= nil and self._tailSubContext.p == nil then
			self._tailSubContext = nil
		end
	end
	if subContext._preContext ~= nil then
		subContext._preContext._nextContext = subContext._nextContext
	end
	if subContext._nextContext ~= nil then
		subContext._nextContext._preContext = subContext._preContext
	end
	subContext.p = nil
end
function context:_checkNext(scName)
	if self._isStopped then
		return
	end
	self:_startNext(scName)
end
function context:_checkStop()
	if self._isStopped then
		return
	end
	if self._headSubContext == nil and self._updateFun == nil and self._tickFun == nil and self._eventFun == nil and self._enterCount <= 0 then
		self:_stopSelf()
	end
end
function context:_startNext(scName)
	local l = scName:len()
	local splitPos = l
	local zero = "0"
	local nine = "9"
	for i = l, 1, -1 do
		local code = scName:byte(i)
		if code < zero:byte() or code > nine:byte() then
			splitPos = i
			break
		end
	end
	local num = 0
	local base = scName:sub(1, splitPos)
	num = scName:sub(splitPos + 1, l)
	num = tonumber(num)
	if num == nil then
		num = 0
	end
	local nextSub = base .. num + 1
	return self:start(nextSub)
end
function context:_update(dt)
	if self._isStopped then
		return
	end
	self:_setPc(self, "self", "update")
	self:_addEnterCount()
	if self._updateFun then
		self.tm:_pcall(self, self._updateFun, self, dt)
	end
	if self._updateFunEx and self.p then
		self.tm:_pcall(self, self._updateFunEx, self.p, dt)
	end
	self:_decEnterCount()
end
function context:_tick(index)
	if self._isStopped then
		return false
	end
	self:_setPc(self, "self", "tick")
	self:_addEnterCount()
	if self._tickFun then
		self.tm:_pcall(self, self._tickFun, self, index)
	end
	if self._tickFunEx then
		self.tm:_pcall(self, self._tickFunEx, self.p, index)
	end
	self:_decEnterCount()
end
function context:notify(msg, level)
	if self._isStopped then
		return false
	end
	if level == nil then
		level = -1
	end
	if level == 0 then
		return false
	end
	self:_setPc(self, "self", "notify")
	self:_addEnterCount()
	local captured = false
	if self._eventFunEx and self.p and self._eventFunEx ~= g_t.empty_event then
		captured = self.tm:_pcall(self, self._eventFunEx, self.p, msg)
	end
	if captured then
		self:_decEnterCount()
		return true
	end
	if self._isStopped then
		self:_decEnterCount()
		return false
	end
	if self._eventFun and self._eventFun ~= g_t.empty_event then
		captured = self.tm:_pcall(self, self._eventFun, self, msg)
	end
	if captured then
		self:_decEnterCount()
		return true
	end
	if self._isStopped then
		self:_decEnterCount()
		return false
	end
	if level == 1 then
		self:_decEnterCount()
		return false
	end
	local subContext = self._headSubContext
	while subContext ~= nil do
		if subContext.p and not subContext.p._isStopped then
			self:_setPc(subContext, subContext._name, "notify_sub")
			captured = subContext:notify(msg, level - 1)
			if captured then
				self:_decEnterCount()
				return true
			end
		end
		subContext = subContext._nextContext
	end
	self:_decEnterCount()
	return false
end
function context:upwardNotify(msg, lvl)
	if lvl == 0 then
		return false
	end
	local realLvl = lvl
	if realLvl == nil then
		realLvl = -1
	end
	local captured = false
	captured = self:notify(msg, 1)
	local p = self.p
	if not captured and p ~= nil and not p._isStopped then
		captured = p:upwardNotify(msg, realLvl - 1)
	end
	local proxyInfo = self._headProxyInfo
	while proxyInfo ~= nil do
		if not proxyInfo.detached then
			proxyInfo.proxy:upwardNotify(msg, lvl)
		end
		proxyInfo = proxyInfo.nextInfo
	end
	return captured
end
function context:_installTab(tab)
	self._tab = tab
	if tab == nil then
		return
	end
	self._finalFun = self._tab.final
	self._eventFun = self._tab.event
	self._catchFun = self._tab.catch
	self._tickFun = self._tab.tick
	self._updateFun = self._tab.update
	self._updateInterval = self._tab.updateInterval
end
function context:_enter(...)
	self:_prepareEnter()
	self:start("s1", ...)
end
function context:_prepareEnter()
	self:_setPc(self, "self", "prepare")
	if self.p then
		self._debugger = self.p._debugger
		self._scheduler = self.p._scheduler
	else
		self._debugger = self.tm._debugger
		self._scheduler = self.tm._scheduler
	end
	self:_createTickAndUpdateTimers()
	if self.p and self.p._mapHeadListener then
		self.p:_notifyLifeTimeEvent(tabMachine.event_context_enter, self._name, self)
	end
end
function context:_stopSub(scName)
	self:_setPc(self, scName, "stop_sub")
	self.tm:_pcall(self, self._pStopSub, self, scName)
end
function context:_pStopSub(scName)
	local subContext = self._headSubContext
	while subContext ~= nil do
		if subContext.p == self and subContext._name == scName then
			self:_setPc(self, subContext._name, "stop_sub")
			subContext:stop()
		end
		subContext = subContext._nextContext
	end
end
function context:_stopSelf()
	local debugger = self._debugger
	if debugger then
		debugger:onContextStop(self)
	end
	self:_setPc(self, "self", "stop_self")
	self._isStopped = true
	self:_stopUpdateTickNotify()
	self:_stopSubs()
	self:_stopLifeTimeRelation()
	self:_finalize()
	self:_detach()
	self:_dispose()
	self:_notifyStop()
	self:_stopProxy()
end
function context:_stopLifeTimeRelation()
	if self._isLifeTimeRelationStopped then
		return
	end
	self._isLifeTimeRelationStopped = true
	while self._headListenInfo do
		local listenInfo = self._headListenInfo
		listenInfo.target:unregisterLifeTimeListener(listenInfo.name, self)
	end
	if self._mapHeadListener then
		for name, headListener in pairs(self._mapHeadListener) do
			local listenter = headListener
			while listenter ~= nil do
				self:unregisterLifeTimeListener(listenter.name, listenter.context)
				listenter = listenter.nextListener
			end
		end
	end
end
function context:_stopUpdateTickNotify()
	if self._isUpdateTickNotifyStopped then
		return
	end
	self:_setPc(self, "self", "stop_update_and_tick")
	self._isUpdateTickNotifyStopped = true
	self:_destroyTickAndUpdateTimers()
end
function context:_createTickAndUpdateTimers()
	if self._isUpdateTickNotifyStopped then
		return
	end
	if self:_selfNeedUpdate() then
		self._updateTimer = self._scheduler:createTimer(function(dt)
			self:_update(dt)
		end, self._updateIntervalEx or self._updateInterval)
	end
	if self:_selfNeedTick() then
		self._tickTimer = self._scheduler:createTimer(function(dt)
			self:_tick()
		end, 1.0)
	end
end
function context:_destroyTickAndUpdateTimers()
	if self._updateTimer then
		self._scheduler:destroyTimer(self._updateTimer)
		self._updateTimer = nil
	end
	if self._tickTimer then
		self._scheduler:destroyTimer(self._tickTimer)
		self._tickTimer = nil
	end
end
function context:_stopSubs()
	if self._isSubStopped then
		return
	end
	self:_setPc(self, "self", "stop subs")
	self._isSubStopped = true
	local subContext = self._tailSubContext
	while subContext ~= nil do
		subContext:stop()
		subContext = subContext._preContext
	end
end
function context:_finalize()
	if self._isFinalized then
		return
	end
	self._isFinalized = true
	self._headSubContext = nil
	self._tailSubContext = nil
	self:_setPc(self, "self", "finalize")
	if self._finalFun ~= nil then
		self.tm:_pcall(self, self._finalFun, self)
	end
	if self._finalFunEx ~= nil and self.p then
		self.tm:_pcall(self, self._finalFunEx, self.p)
	end
end
function context:forEachSub(callback)
	local subContext = self._tailSubContext
	while subContext ~= nil do
		local isIterationFinished = callback(subContext)
		if isIterationFinished then
			break
		end
		subContext = subContext._preContext
	end
end
function context:_detach()
	if self._isDetached then
		return
	end
	self._isDetached = true
	self:_setPc(self, "self", "finalize")
	local p = self.p
	local tm = self.tm
	if p and not p._isStopped then
		if self._outputVars then
			outputValues(p.v, self._outputVars, self._outputValues)
		end
		p:_removeSubContext(self)
	elseif self._isRoot then
		tm:_setOutputs(self._outputVavlues)
	end
end
function context:_dispose()
	if self._isDisposed then
		return
	end
	self:_setPc(self, "self", "finalize")
	self._isDisposed = true
	self.tm:_disposeContext(self)
end
function context:_notifyStop()
	if self._isNotifyStopped then
		return
	end
	self._isNotifyStopped = true
	local p = self._pp
	local tm = self.tm
	self:_setPc(self, "self", "notify_stop")
	local hasNotify = false
	if p and p._mapHeadListener then
		p:_addEnterCount()
		hasNotify = true
		p:_notifyLifeTimeEvent(tabMachine.event_context_stop, self._name, self)
	end
	if p and not p._isStopped then
		p:_checkNext(self._name)
		p:_checkStop()
	elseif self._isRoot then
		tm:_onStopped()
	end
	if hasNotify then
		p:_decEnterCount()
	end
end
function context:_notifyLifeTimeEvent(eventType, scName, target)
	local listenter = self._mapHeadListener[scName]
	while listenter ~= nil do
		if not listenter.detached then
			_UPVALUE0_ = listenter.detached
			listenter.detached.eventType = eventType
			listenter.detached.p = self
			listenter.detached.name = scName
			local listenter.detached.target, msg = target, listenter.detached
			listenter.context:notify(msg, 1)
		end
		listenter = listenter.nextListener
	end
end
function context:_stopProxy()
	if self._isProxyStopped then
		return
	end
	self._isProxyStopped = true
	local proxyInfo = self._headProxyInfo
	while proxyInfo ~= nil do
		if not proxyInfo.detached then
			proxyInfo.proxy:stop()
		end
		proxyInfo = proxyInfo.nextInfo
	end
end
function context:_addEnterCount()
	if self._isStopped then
		return
	end
	self._enterCount = self._enterCount + 1
end
function context:_decEnterCount()
	if self._isStopped then
		return
	end
	self._enterCount = self._enterCount - 1
	if self._enterCount <= 0 then
		self:_checkStop()
	end
end
function context:_selfNeedUpdate()
	return self._updateFun ~= nil or self._updateFunEx ~= nil
end
function context:_selfNeedTick()
	return self._tickFun ~= nil or self._tickFunEx ~= nil
end
function context:_selfNeedNotify()
	return self._eventFun ~= nil or self._eventFunEx ~= nil
end
function context:_throwException(exception)
	if self._isNotifyStopped then
		return true
	end
	if self._isStopped then
		self:_stopUpdateTickNotify()
		self:_stopSubs()
		self:_finalize()
		self:_detach()
		self:_dispose()
	end
	local debugger = self._debugger
	if debugger then
		debugger:onContextException(self, exception)
	end
	local isCatched = false
	if self._curSubCatchFun ~= nil then
		isCatched = self._curSubCatchFun(self, exception)
	end
	if not isCatched and self._catchFun ~= nil then
		isCatched = self._catchFun(self, exception)
	end
	if not isCatched and self._catchFunEx ~= nil and self.p and not self.p._isStopped then
		isCatched = self._catchFunEx(self.p, exception)
	end
	if isCatched then
		return true
	end
	if self._pp then
		exception.pcName = self._pp._pcName
		exception.pcAction = self._pp._pcAction
		exception.scName = self._name
		return self._pp:_throwException(exception)
	end
	return false
end
function context:getScheduler()
	return self._scheduler
end
function context:setScheduler(scheduler)
	if scheduler == self._scheduler then
		return
	end
	self:_destroyTickAndUpdateTimers()
	self._scheduler = scheduler
	self:_createTickAndUpdateTimers()
	local subContext = self._headSubContext
	while subContext ~= nil do
		subContext:setScheduler(scheduler)
		subContext = subContext._nextContext
	end
end
function context:_getDebugger()
	return self._debugger
end
function context:setDebugger(debugger)
	self._debugger = debugger
	local subContext = self._headSubContext
	while subContext ~= nil do
		subContext:setDebugger(debugger)
		subContext = subContext._nextContext
	end
end
function context:_addProxy(proxy)
	if self._isStopped then
		return
	end
	if self._outputValues == nil then
		proxy._outputValues = nil
	else
		proxy._outputValues, _ENV = self._outputValues, self._outputValues
		for _, output in ipairs(self._outputValues) do
			table.insert(proxy._outputValues, output)
		end
	end
	_ENV = (for generator)
	local ipairs(self._outputValues).proxy, proxyInfo = proxy, ipairs(self._outputValues)
	local oldHeadProxyInfo = self._headProxyInfo
	if oldHeadProxyInfo ~= nil then
		oldHeadProxyInfo.prevInfo = proxyInfo
		proxyInfo.nextInfo = oldHeadProxyInfo
	end
	self._headProxyInfo = proxyInfo
end
function context:_removeProxy(proxy)
	if self._isStopped then
		return
	end
	local proxyInfo = self._headProxyInfo
	while proxyInfo ~= nil do
		if proxyInfo.proxy == proxy then
			proxyInfo.detached = true
			if proxyInfo.prevInfo ~= nil then
				proxyInfo.prevInfo.nextInfo = proxyInfo.nextInfo
			end
			if proxyInfo.nextInfo ~= nil then
				proxyInfo.nextInfo.prevInfo = proxy.prevInfo
			end
			if self._headProxyInfo == proxyInfo then
				self._headProxyInfo = proxyInfo.nextInfo
			end
			break
		else
			proxyInfo = proxyInfo.nextInfo
		end
	end
end
return tabMachine
