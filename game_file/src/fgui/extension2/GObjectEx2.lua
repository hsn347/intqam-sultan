local m = fgui.GObject
local removeFromParent_old = tolua.getcfunction(m, "removeFromParent")
local setColor_old = tolua.getcfunction(m, "setColor")
function m:displayObject()
	return self
end
function m:setAutoCull(value)
end
function m:addComponent(component)
	print_error("暂不实现，GObject:addComponnet")
end
function m:setColor(color)
	if type(color) == "string" then
		color = SoraDHtmlColor2RGB(color)
	end
	local newColor = cc.c3b(math.floor(color.r or 0), math.floor(color.g or 0), math.floor(color.b or 0))
	setColor_old(self, newColor)
end
function m:removeEventListeners()
	self:RemoveEventListeners()
end
function m:convertToWorldSpace(nodePoint)
	return self:convertToWorldSpaceEX(nodePoint.x, nodePoint.y)
end
function m:getAnchorPoint()
	local pivot = self:getPivot()
	pivot.y = 1 - pivot.y
	return pivot
end
function m:localToScreen(pos)
	local p = cc.p(pos.x, self:getHeight() - pos.y)
	if self:isPivotAsAnchor() then
		local pivot = self:getPivot()
		p.x = p.x + pivot.x * self:getWidth()
		p.y = p.y + pivot.y * self:getHeight()
	end
	local ret = self:displayObject():convertToWorldSpace(p)
	ret.y = display.height - ret.y
	return ret
end
function m:getContentSize()
	return cc.size(self:getWidth(), self:getHeight())
end
function m:setContentSize(wv, hv)
	if hv then
		self:setCocosSize(wv, hv)
	elseif wv then
		self:setCocosSize(wv.width, wv.height)
	end
end
function m:getVirtualRendererSize()
	local size = cc.size(self:getWidth(), self:getHeight())
	return size
end
function m:getDescription()
	return "GObject"
end
function m:getEventDispatcher()
	return cc.Director:getInstance():getEventDispatcher()
end
function m:getGLProgram()
	print_error("暂不实现Gobject:getGLProgram")
end
function m:getGLProgramState()
	return self.material
end
function m:getLocalZOrder()
	return self:getSortingOrder()
end
function m:getNodeToWorldTransform()
	print_error("暂不实现Gobject:getNodeToWorldTransform")
end
function m:getWorldToNodeTransform()
	print_error("暂不实现Gobject:getWorldToNodeTransform")
end
function m:getOpacity()
	return self:getAlpha() * 255
end
function m:isCascadeOpacityEnabled()
	return false
end
function m:isIgnoreAnchorPointForPosition()
	return not self:isPivotAsAnchor()
end
function m:isOpacityModifyRGB()
	print_warn("暂不处理GObject:isOpacityModifyRGB")
	return false
end
function m:isRunning()
	return self.onStage
end
function m:pause()
end
function m:removeAllChildrenWithCleanup(cleanup)
	error("GObject:removeAllChildrenWithCleanup(cleanup)")
end
function m:removeAllComponents()
	error("GObject:removeAllComponents()")
end
function m:removeComponent(name)
	error("GObject:removeComponent(name)")
end
function m:removeFromParentAndCleanup(cleanup)
	self:removeFromParent(cleanup)
end
function m:resume()
end
function m:setCameraMask(mask, applyChildren)
	print_warn("暂不处理GObject:setCameraMask")
end
function m:setCascadeOpacityEnabled(cascadeOpacityEnabled)
end
function m:setGLProgramState(glProgramState)
	self.material = glProgramState
end
function m:setGlobalZOrder(globalZOrder)
end
function m:setLocalZOrder(localZOrder)
	self:setSortingOrder(localZOrder)
end
function m:setOpacity(opacity)
	self:setAlpha(opacity / 255)
end
function m:setOpacityModifyRGB(value)
	print_warn("暂不处理GObject:setOpacityModifyRGB")
end
function m:getPosition()
	if self.isCocos then
		return self:getPositionX(), self:getPositionY()
	else
		return cc.p(self:getPositionX(), self:getPositionY())
	end
end
function m:setPosition3D(position)
	print("暂不处理GObject:getPosition3D")
end
function m:setPositionZ(positionZ)
	self.z = positionZ
end
local setScale_old = fgui.GObject.setScale
function m:setScale(scaleX, scaleY)
	if scaleY then
		setScale_old(self, scaleX, scaleY)
	else
		setScale_old(self, scaleX, scaleY)
	end
end
function m:setScaleZ(scaleZ)
	print("暂不处理GObject:setScaleZ")
end
_ENV, m.visit = function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end, function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).NODE = 0
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).MENU_CLICKED = 1
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).CALLFUNC = 2
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).SCHEDULE = 3
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).TOUCHES = 4
;(function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).KEYPAD = 5
local _ENV, (function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end).ACCELEROMETER, HandlerType = nil, 6, function(self, renderer, parentTransform, parentFlags)
	if _gBeginingRenderTexture then
		_gBeginingRenderTexture:addObjectToVisitList(self)
	end
end
;(nil)[1] = "ctor"
;(nil)[2] = "enter"
;(nil)[3] = "exit"
local (nil)[4], eventMap = "cleanup", nil
function m:_nodeEventDelegate(name)
	if self._nodeEventCallback then
		self._nodeEventCallback(eventMap[name])
	end
end
function m:registerScriptHandler(callback, type)
	type = type or HandlerType.NODE
	if type == HandlerType.NODE then
		self._nodeEventCallback = callback
		self:SetNodeCallback(handler(self, self._nodeEventDelegate))
	else
		print_warn("registerScriptHandler暂 不支持的类型", type)
	end
end
function m:unregisterScriptHandler()
	self:RemoveNodeCallback()
end
local ccuiEventType2Name = function(eventType)
	if eventType == ccui.TouchEventType.began then
		return "began"
	elseif eventType == ccui.TouchEventType.moved then
		return "moved"
	elseif eventType == ccui.TouchEventType.ended then
		return "ended"
	elseif eventType == ccui.TouchEventType.canceled then
		return "canceled"
	end
end
function m:addNodeEventListener(eventType, callback)
	if cc.NODE_EVENT == eventType then
		self._nodeEventCallback = callback
		self:SetNodeCallback(handler(self, self._nodeEventDelegate))
	elseif cc.NODE_ENTER_FRAME_EVENT == eventType then
		self:scheduleUpdateWithPriorityLua(callback, 0)
	elseif cc.NODE_TOUCH_EVENT == eventType then
		self:addTouchEventListener(function(target, eventType)
			local p = target:getTouchMovePosition()
			local prevP = target:getTouchLastPosition()
			callback = nil
			;(nil).name = ccuiEventType2Name(eventType)
			;(nil).x = p.x
			;(nil).y = p.y
			;(nil).prevX = prevP.x
			;(nil).prevY = prevP.y
			callback(nil)
		end)
	else
		print_warn("addNodeEventListener暂未处理其他事件注册", self, eventType)
	end
	return callback
end
function m:getSize()
	return cc.size(self:getWidth(), self:getHeight())
end
function m:setKeyboardEnabled(keyboardEnabled)
end
local addTouchEventListener_ = m.addTouchEventListener
function m:addTouchEventListener(callback)
	if self._isIgnorTrainsGuide then
		addTouchEventListener_(self, onTouch_)
		return
	end
	local onTouch_ = function(...)
		if self.mildGuideCallBack then
			self.mildGuideCallBack(...)
		end
		self._touchEventListener_(...)
	end
	if not self._touchEventListener_ then
		addTouchEventListener_(self, onTouch_)
	end
	self._touchEventListener_ = callback
end
m.addTouchEventListener_ = m.addTouchEventListener
function m:addClickEventListener(callback, params)
	self:addClickListener(function(eventContext)
		callback(self, params)
	end)
end
function m:getVirtualRenderer()
	return self
end
function m:setState(value)
	self:setGrayed(value == 1)
end
function m:setAdditionalTransform(mat)
end
function m:ignoreAnchorPointForPosition(bIgnore)
	self.pivotAsAnchor = not bIgnore
end
function m:getBackGroundColorOpacity()
	return self:getAlpha() * 255
end
function m:setBackGroundColorOpacity(value)
	self:setAlpha(value / 255)
end
function m:setDimensions(width, height)
	self:setContentSize(width, height)
end
local setPosition = m.setPosition
function m:setPosition(xv, yv)
	if type(xv) == "userdata" then
		setPosition(self, xv)
	elseif type(xv) == "table" then
		setPosition(self, xv.x, xv.y)
	else
		setPosition(self, xv, yv)
	end
end
function m:setPkmGrayEnable(isGrayed)
	self:setGrayed(isGrayed)
end
function m:getChildByName()
	require("csb_fix"):add(self)
	print_warn("try 'getChildByName' from GObject", self:FullPathInStage())
end
function m:getChild()
	return nil
end
function m:addChild()
	require("csb_fix"):add(self)
	print_error("try 'addChild' from GObject", self:FullPathInStage())
end
function m:removeAllChildren()
	require("csb_fix"):add(self)
	print_error("try 'removeAllChildren' from GObject", self:FullPathInStage())
end
function m:getChildren()
	_UPVALUE0_ = nil
	return nil
end
function m:getChildrenCount()
	return 0
end
function m:setScheduler()
end
function m:addRelation(target, relationType)
	self:AddRelation(target, relationType)
end
