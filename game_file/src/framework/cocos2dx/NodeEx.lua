local c = cc
local Node = fgui.GObject
local getCascadeBoundingBox = Node.getCascadeBoundingBox
local setTouchEnabled = Node.setTouchEnabled
local scheduleUpdate = Node.scheduleUpdate
local addNodeEventListener = Node.addNodeEventListener
local removeNodeEventListener = Node.removeNodeEventListener
local removeNodeEventListenersByEvent = Node.removeNodeEventListenersByEvent
local removeAllNodeEventListeners = Node.removeAllNodeEventListeners
c.TouchesAllAtOnce = cc.TOUCHES_ALL_AT_ONCE
c.TouchesOneByOne = cc.TOUCHES_ONE_BY_ONE
c.TOUCH_MODE_ALL_AT_ONCE = c.TouchesAllAtOnce
c.TOUCH_MODE_ONE_BY_ONE = c.TouchesOneByOne
local flagNodeTouchInCocos = false
local isPointIn = function(rc, pt)
	local rect = cc.rect(rc.x, rc.y, rc.width, rc.height)
	return cc.rectContainsPoint(rect, pt)
end
function Node:align(anchorPoint, x, y)
	self:setAnchorPoint(display.ANCHOR_POINTS[anchorPoint])
	if x and y then
		self:setPosition(x, y)
	end
	return self
end
function Node:schedule(callback, interval)
	_UPVALUE1_ = nil
	;(nil)[1] = cc.DelayTime:create(interval)
	;(nil)[2] = cc.CallFunc:create(callback)
	;(nil)[3] = cc.CallFunc:create(callback)
	;(nil)[4] = cc.CallFunc:create(callback)
	local seq = transition.sequence(nil)
	local action = cc.RepeatForever:create(seq)
	self:runAction(action)
	return action
end
function Node:performWithDelay(callback, delay)
	_UPVALUE1_ = nil
	;(nil)[1] = cc.DelayTime:create(delay)
	;(nil)[2] = cc.CallFunc:create(callback)
	;(nil)[3] = cc.CallFunc:create(callback)
	;(nil)[4] = cc.CallFunc:create(callback)
	local action = transition.sequence(nil)
	self:runAction(action)
	return action
end
function Node:getCascadeBoundingBox()
	local rc
	local func = getCascadeBoundingBox
	if func then
		rc = func(self)
	end
	getCascadeBoundingBox = func(self)
	func(self).x = rc.x
	getCascadeBoundingBox, rc.origin, func(self).y = func(self), func(self), rc.y
	func(self).width = rc.width
	rc.size, func(self).height = func(self), rc.height
	rc.containsPoint = isPointIn
	return rc
end
function Node:hitTest(point, bCascade)
	local nsp = self:convertToNodeSpace(point)
	local rect
	if bCascade then
		rect = self:getCascadeBoundingBox()
	else
		rect = self:getBoundingBox()
	end
	if cc.rectContainsPoint(rect, nsp) then
		return true
	end
	return false
end
function Node:removeSelf()
	self:removeFromParent(true)
end
function Node:onEnter()
end
function Node:onExit()
end
function Node:onEnterTransitionFinish()
end
function Node:onExitTransitionStart()
end
function Node:onCleanup()
end
function Node:setNodeEventEnabled(enabled, listener)
	if enabled then
		if self.__node_event_handle__ then
			self:removeNodeEventListener(self.__node_event_handle__)
			self.__node_event_handle__ = nil
		end
		listener = listener or function(event)
			local name = event
			if name == "enter" then
				self:onEnter()
			elseif name == "exit" then
				self:onExit()
			elseif name == "enterTransitionFinish" then
				self:onEnterTransitionFinish()
			elseif name == "exitTransitionStart" then
				self:onExitTransitionStart()
			elseif name == "cleanup" then
				self:onCleanup()
			end
		end
		self.__node_event_handle__ = self:addNodeEventListener(c.NODE_EVENT, listener)
	elseif self.__node_event_handle__ then
		self:removeNodeEventListener(self.__node_event_handle__)
		self.__node_event_handle__ = nil
	end
	return self
end
function Node:setTouchEnabled(enable)
	local func = setTouchEnabled
	func(self, enable)
	if not flagNodeTouchInCocos then
		return
	end
	if enable then
		self:setBaseNodeEventListener()
	end
end
function Node:setKeypadEnabled(enable)
	if not flagNodeTouchInCocos then
		self:setKeyboardEnabled(enable)
		return
	end
	_enable = self._keyboardEnabled or false
	if enable == _enable then
		return self
	end
	self._keyboardEnabled = enable
	if self.__key_event_handle__ then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListener(self.__key_event_handle__)
		self.__key_event_handle__ = nil
	end
	if enable then
		local onKeyPressed = function(keycode, event)
			_UPVALUE3_ = nil
			;(nil)[1] = keycode
			;(nil)[2] = event
			;(nil)[3] = "Pressed"
			return self:EventDispatcher(c.KEYPAD_EVENT, nil)
		end
		local onKeyReleased = function(keycode, event)
			_UPVALUE3_ = nil
			;(nil)[1] = keycode
			;(nil)[2] = event
			;(nil)[3] = "Released"
			return self:EventDispatcher(c.KEYPAD_EVENT, nil)
		end
		local listener = cc.EventListenerKeyboard:create()
		listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
		listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
		self.__key_event_handle__ = listener
	end
	return self
end
function Node:isKeypadEnabled()
	if not flagNodeTouchInCocos then
		return self:isKeyboardEnabled()
	end
	enable = self._keyboardEnabled or false
	return enable
end
function Node:scheduleUpdate()
	if not flagNodeTouchInCocos then
		scheduleUpdate(self)
		return
	end
	local listener = function(dt)
		self:EventDispatcher(c.NODE_ENTER_FRAME_EVENT, dt)
	end
	self:scheduleUpdateWithPriorityLua(listener, 0)
end
function Node:setBaseNodeEventListener()
	if self._baseNodeEventListener_ then
		return
	end
	function self._baseNodeEventListener_(evt)
		self:EventDispatcher(c.NODE_EVENT, evt)
	end
	self:registerScriptHandler(self._baseNodeEventListener_)
end
function Node:addNodeEventListener(evt, hdl, tag, priority)
	if not flagNodeTouchInCocos then
		addNodeEventListener(self, evt, hdl, tag, priority)
		return
	end
	priority = priority or 0
	if not self._scriptEventListeners_ then
		self._scriptEventListeners_, flagNodeTouchInCocos = self._scriptEventListeners_, self._scriptEventListeners_
		self:setBaseNodeEventListener()
	end
	local luaListeners_ = self._scriptEventListeners_
	local idx = self._nextScriptEventHandleIndex_ or 0
	idx = idx + 1
	self._nextScriptEventHandleIndex_ = idx
	if not luaListeners_[evt] then
		luaListeners_[evt], flagNodeTouchInCocos = luaListeners_[evt], luaListeners_[evt]
	end
	local eventListeners_ = luaListeners_[evt]
	flagNodeTouchInCocos = hdl
	hdl.index_ = idx
	hdl.listener_ = hdl
	hdl.tag_ = tag
	hdl.priority_ = priority
	hdl.enable_ = true
	local hdl.removed_, lis = false, hdl
	if evt == c.NODE_ENTER_FRAME_EVENT then
		eventListeners_[1] = lis
	else
		table.insert(eventListeners_, lis)
	end
	return self._nextScriptEventHandleIndex_
end
function Node:removeNodeEventListener(listener)
	if not flagNodeTouchInCocos then
		local func = removeNodeEventListener
		if func then
			return func(self, listener)
		end
		return
	end
	if not self._scriptEventListeners_ then
		return
	end
	for evt, liss in pairs(self._scriptEventListeners_) do
		for i, v in ipairs(liss) do
			if v.index_ == listener then
				table.remove(liss, i)
				if #liss == 0 then
					self:removeNodeEventListenersByEvent(evt)
				end
				return
			end
		end
	end
end
function Node:removeNodeEventListenersByEvent(evt)
	if not flagNodeTouchInCocos then
		removeNodeEventListenersByEvent(self, evt)
		return
	end
	if self._scriptEventListeners_ and self._scriptEventListeners_[evt] then
		if evt == c.KEYPAD_EVENT then
			self:setKeypadEnabled(false)
		elseif evt == c.NODE_ENTER_FRAME_EVENT then
			self:unscheduleUpdate()
		elseif evt == c.NODE_TOUCH_EVENT then
			self:removeTouchEvent()
		elseif evt == c.NODE_TOUCH_CAPTURE_EVENT then
			self:removeTouchEvent()
		end
		self._scriptEventListeners_[evt] = nil
	end
end
function Node:removeAllNodeEventListeners()
	if not flagNodeTouchInCocos then
		removeAllNodeEventListeners(self)
		return
	end
	self:removeNodeEventListenersByEvent(c.NODE_EVENT)
	self:removeNodeEventListenersByEvent(c.NODE_ENTER_FRAME_EVENT)
	self:removeNodeEventListenersByEvent(c.NODE_TOUCH_EVENT)
	self:removeNodeEventListenersByEvent(c.NODE_TOUCH_CAPTURE_EVENT)
	self:removeNodeEventListenersByEvent(c.KEYPAD_EVENT)
end
local KeypadEventCodeConvert = function(code)
	local key
	if code == cc.KeyCode.KEY_BACK then
		key = "back"
	elseif code == cc.KeyCode.KEY_LEFT_CTRL then
		key = "menu"
	else
		key = tostring(code)
	end
	return key
end
function Node:EventDispatcher(idx, data)
	local obj = self
	local flagNodeCleanup = false
	local event, touch_event
	if idx == c.NODE_EVENT then
		c = c.NODE_EVENT
		event, c.NODE_EVENT.name = c.NODE_EVENT, data
		if data == "cleanup" then
			flagNodeCleanup = true
		end
	elseif idx == c.NODE_ENTER_FRAME_EVENT then
		event = data
	elseif idx == c.KEYPAD_EVENT then
		local code = data[1]
		local ename = data[3]
		if ename ~= "Released" then
			return true
		end
		c = true
		;(true).code = code
		event, (true).key = true, KeypadEventCodeConvert(code)
	else
		event = data
		touch_event = event
	end
	local rnval = false
	if idx == cc.NODE_TOUCH_CAPTURE_EVENT then
		rnval = true
	end
	local flagNeedClean = false
	local listener
	if obj._scriptEventListeners_ then
		listener = obj._scriptEventListeners_[idx]
	end
	if listener then
		for i, v in ipairs(listener) do
			if v.removed_ then
				flagNeedClean = true
			else
				if touch_event and touch_event.name == "began" then
					v.enable_ = true
				end
				if v.enable_ then
					listenerRet = v.listener_(event)
					if not listenerRet then
						if idx == cc.NODE_TOUCH_CAPTURE_EVENT then
							local evtname = event.name
							if evtname == "began" or evtname == "moved" then
								rnval = false
							end
						elseif idx == cc.NODE_TOUCH_EVENT then
							if event.name == "began" then
								v.enable_ = false
							end
							rnval = rnval or listenerRet
						else
							rnval = rnval or listenerRet
						end
					end
				end
			end
		end
	end
	if flagNodeCleanup then
		print_error("cleanup!!!!!")
		obj:setTouchEnabled(false)
		obj:removeAllNodeEventListeners()
		obj:removeTouchEvent()
		obj:unregisterScriptHandler()
		obj._baseNodeEventListener_ = nil
	end
	return rnval
end
