local m = fgui.GComponent
_ENV = nil
;(nil).NONE = 0
;(nil).VERTICAL = 1
;(nil).HORIZONTAL = 2
m.Direction, (nil).BOTH = nil, 3
function m:addEventListener(callback, param2)
	if param2 then
		local uiEventType = callback
		local _callback = param2
		_ENV = nil
		;(nil)[fgui.UIEventType.Scroll] = true
		;(nil)[fgui.UIEventType.ScrollEnd] = true
		;(nil)[fgui.UIEventType.PullDownRelease] = true
		local (nil)[fgui.UIEventType.PullUpRelease], config = true, nil
		if config[uiEventType] then
			self:getScrollPane():AddEventListener1(uiEventType, _callback)
		else
			fgui.GObject.addEventListener(self, uiEventType, _callback)
		end
		return
	end
	self:getScrollPane():AddEventListener1(fgui.UIEventType.onScrollViewEvent, function(contex)
		local eventType = contex:getData()
		callback(self, contex:getData())
	end)
end
function m:numChildren()
	return self:getChildrenCount()
end
function m:getDescription()
	return "GComponent"
end
function m:getInnerContainer()
	return self:getScrollPane()
end
function m:getInnerContainerPosition()
	return self:getScrollPane():getPosition()
end
function m:getInnerContainerSize()
	return self:getScrollPane():getContentSize()
end
function m:getScrolledPercentHorizontal()
	return self:getScrollPane():getPercX()
end
function m:getScrolledPercentVertical()
	return self:getScrollPane():getPerY()
end
function m:init(...)
	print_warn("GComponent:init", ...)
end
function m:jumpToBottom()
	self:getScrollPane():ScrollBottom()
end
function m:jumpToLeft()
	self:getScrollPane():ScrollLeft()
end
function m:jumpToRight()
	self:getScrollPane():ScrollRight()
end
function m:jumpToTop()
	self:getScrollPane():ScrollTop()
end
_ENV, m.setBounceEnabled = function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end, function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end
;(function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end).NONE = 0
;(function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end).VERTICAL = 1
;(function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end).HORIZONTAL = 2
local (function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end).BOTH, Direction = 3, function(self, enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end
function m:setDirection(dir)
	local scrollPane = self:getScrollPane()
	if dir == Direction.NONE then
		print_error("暂时不支持设置scrollDirection为None")
	elseif dir == Direction.VERTICAL then
		scrollPane:setScrollType(fgui.ScrollType.Vertical)
	elseif dir == Direction.HORIZONTAL then
		scrollPane:setScrollType(fgui.ScrollType.Horizontal)
	elseif dir == Direction.BOTH then
		scrollPane:setScrollType(fgui.ScrollType.Both)
	end
end
function m:setInnerContainerSize(w, h)
	if h then
		self:getScrollPane():setContentSize(w, h)
	else
		self:getScrollPane():setContentSize(w.width, w.height)
	end
end
function m:setTouchTotalTimeThreshold(touchTotalTimeThreshold)
	error("GComponent:setTouchTotalTimeThreshold(touchTotalTimeThreshold)")
end
function m:stopAutoScroll()
	self:getScrollPane():stopAutoScroll()
end
function m:update(dt)
	print_error("GComponent:update 不知道干嘛")
end
function m:setStencil()
end
function m:setInverted()
end
function m:removeAllChildren()
	if self.isCocos then
		local objs = self:GetChildren()
		for i, v in ipairs(objs) do
			if v and v.isCocos or v.isFguiOnCocos then
				v:removeFromParent()
			end
		end
	else
		self:RemoveChildren(true)
	end
end
function m:create()
	local ret = cc.Node.CreateNode()
	ret:setPosition(0, 0)
	return ret
end
function m:setScrollEnable(value)
	self:getScrollPane():setTouchEffect(value)
end
function m:setBounceable(enabled)
	self:getScrollPane():setBouncebackEffect(enabled)
end
function m:setInertiaValue(inertia)
	self:getScrollPane():setInertiaValue(inertia)
end
function m:setDelegate()
end
function m:setClippingToBounds(bValue)
	self:getScrollPane():setClippingToBounds(bValue)
end
function m:minContainerOffset()
	local scrollPane = self:getScrollPane()
	return cc.p(scrollPane.viewWidth - scrollPane.contentWidth, scrollPane.viewHeight - scrollPane.contentHeight)
end
function m:maxContainerOffset()
	return cc.p(0, 0)
end
function m:getContentOffset()
	local scrollPane = self:getScrollPane()
	return scrollPane:getPosition()
end
function m:getViewSize()
	return self:getContentSize()
end
function m:setOpacity(opacity)
	if self.__background_color__ then
		self.__background_color__:setOpacity(opacity)
	else
		fgui.GObject.setOpacity(self, opacity)
	end
end
function m:checkBackgroudColor()
	if self.__background_color__ then
		return
	end
	self.__background_color__ = self:getChild("__background_color__")
	if self.__background_color__ then
		return
	end
	local bg = fgui.GGraph()
	bg:setName("__background_color__")
	bg:DrawRect(self:getWidth(), self:getHeight(), 0, display.COLOR_WHITE, display.COLOR_WHITE)
	bg:setTouchable(false)
	bg.relations:Add(self, fgui.RelationType.Size)
	self:addChildAt(bg, 0)
	bg:AddRelation(self, fgui.RelationType.Size)
	self.__background_color__ = bg
end
function m:setBackGroundColorOpacity(value)
	self:checkBackgroudColor()
	if self.__background_color__ then
		self.__background_color__:setOpacity(value)
	end
end
function m:setBackGroundColorType(colorType)
	self:checkBackgroudColor()
	if self.__background_color__ then
		if colorType == ccui.LayoutBackGroundColorType.none then
			self.__background_color__:setVisible(false)
		elseif colorType == ccui.LayoutBackGroundColorType.solid then
			self.__background_color__:setVisible(true)
		elseif colorType == ccui.LayoutBackGroundColorType.gradient then
			self.__background_color__:setVisible(true)
			print_warn("暂不处理gradient")
		else
			error("unknow colorType:" .. colorType)
		end
	end
end
function m:setBackGroundColor(color)
	self:checkBackgroudColor()
	if self.__background_color__ then
		self.__background_color__:setColor(color)
	end
end
function m:setBackGroundGradient(startColor, endColor, vec)
	self:checkBackgroudColor()
	if self.__background_color__ then
		self.__background_color__:DrawGradientRect(self:getWidth(), self:getHeight(), 0, startColor, endColor, vec.x, vec.y)
	end
end
function m:setCustomScrollThreshold(iVal)
	print_warn("暂不处理ScrollView:setCustomScrollThreshold")
end
function m:setListenAllScrollingEnabled()
end
function m:setClippingEnabled(value)
	if self:getScrollPane() then
		self:getScrollPane():setClippingToBounds(value)
	elseif value then
		self:setOverflow(fgui.OverflowType.Hidden)
	else
		self:setOverflow(fgui.OverflowType.Visible)
	end
end
function m:reorderChild(child, order)
	child:setLocalZOrder(order)
end
function m:addScrollNode()
end
function m:setAccelerometerEnabled(value)
	print_warn("暂不实现：Layer:setAccelerometerEnabled")
end
function m:setAccelerometerInterval()
	print_warn("暂不实现：Layer:setAccelerometerInterval")
end
function m:scrollToCenter(pos, ani)
	local scrollPane = self:getScrollPane()
	local viewSize = scrollPane:getViewSize()
	local posX = pos.x - viewSize.width / 2
	local posY = pos.y - viewSize.height / 2
	local offsetPoint = cc.p(posX, posY)
	if ani and 0 < ani then
		scrollPane:setContentOffsetInDuration(offsetPoint, ani)
	else
		scrollPane:setContentOffset(offsetPoint)
	end
end
