local wheelScrollView = class("wheelScrollView", function(viewSize)
	local baseView = include("baseView")
	local view = baseView.new(viewSize, false)
	view:setAnchorPoint(cc.p(0.0, 0.0))
	view:setSwallowTouches(false)
	return view
end)
function wheelScrollView:ctor()
	local viewSize = self:getContentSize()
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(viewSize)
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(1)
	self.scrollView:setPosition(cc.p(0, 0))
	self.scrollView:setListenAllScrollingEnabled(true)
	self:addChild(self.scrollView, 1)
	self.itemArray, _ENV = self.addChild, self.addChild
	self.cellHeight = 0
	self.circleRadius = 0
	self.itemSelectedListener = nil
	self.offsetPosX = 0
	self.curI = nil
	self.singleIsMoved = false
	self.ignoreOpacity = false
	self.isScrollToIndex = false
	self.isScrollEnd = false
	self.isBounceEnd = false
	self.isSound = true
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollView:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
	SoraDFTarget(self.scrollView)
end
function wheelScrollView:setInertiaValue(inertia)
	self.scrollView:setInertiaValue(inertia)
end
function wheelScrollView:removeChildren()
	self.scrollView:removeAllChildren()
end
function wheelScrollView:initData(array, posX, cellHeight, circleRadius, isSound, isIgnoreOpacity)
	self.itemArray = array
	self.cellHeight = cellHeight
	self.offsetPosX = posX
	self.ignoreOpacity = isIgnoreOpacity or false
	self.circleRadius = math.max(circleRadius, self.scrollView:getContentSize().width)
	self.transparentOffset = math.floor(255 / (self:getContentSize().height / cellHeight)) + 1
	self.isSound = isSound
	local scrollH = #self.itemArray * cellHeight + self.scrollView:getContentSize().height - cellHeight
	for i, v in ipairs(self.itemArray) do
		local transparentPanel = SoraDGetChildByName(v, "Panel_transparent")
		if transparentPanel then
			transparentPanel:setSwallowTouches(false)
		end
		v:setPosition(cc.p(self.offsetPosX, cellHeight * (i - 1) + 0.5 * self.scrollView:getContentSize().height))
		self.scrollView:addChild(v, 1)
		SoraDFTarget(v)
		v:setTag(i)
	end
	self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getInnerContainerSize().width, scrollH))
	self:updateItems()
end
function wheelScrollView:selectedCellIndex(cellIndex, time, attenuated, attenuatedY)
	attenuatedY = attenuatedY or 0
	local scrollInner = self.scrollView:getInnerContainer()
	cellIndex = math.min(math.max(1, cellIndex), #self.itemArray)
	local offsetY = self.itemArray[cellIndex]:getPositionY() - 0.5 * self.scrollView:getContentSize().height + attenuatedY
	local scrollPercent = offsetY == 0 and 100 or 100 * (1 - offsetY / (scrollInner:getContentSize().height - self.scrollView:getContentSize().height))
	if time then
		attenuated = attenuated or false
		self.scrollView:scrollToPercentVertical(scrollPercent, time, attenuated)
	else
		self.scrollView:jumpToPercentVertical(scrollPercent)
		self:updateItems()
		self:pointCurSelectSingle(false)
	end
end
function wheelScrollView:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local scrollInner = self.scrollView:getInnerContainer()
		local offsetY = -scrollInner:getPositionY()
		local centerY = offsetY + 0.5 * self.scrollView:getContentSize().height
		local curI = self:pointCurSelectSingle(true)
		if 1 < curI and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).y <= centerY - 0.5 * self.cellHeight then
			self.isScrollToIndex = -1
			self.scrollView:setTouchEnabled(false)
			self:setTouchDetection(0.3)
		elseif curI < #self.itemArray and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).y >= centerY + 0.5 * self.cellHeight then
			self.isScrollToIndex = 1
			self.scrollView:setTouchEnabled(false)
			self:setTouchDetection(0.3)
		end
		if self.isScrollToIndex then
			self:selectedCellIndex(curI + self.isScrollToIndex, 0.1, true, self.isScrollToIndex * 20)
			self.isScrollToIndex = false
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function wheelScrollView:setTouchDetection(delay)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(delay)
	;(nil)[2] = cca.callFunc(function(...)
		if not self.scrollView:isTouchEnabled() then
			self.scrollView:setTouchEnabled(true)
		end
	end)
	;(nil)[3] = cca.callFunc(function(...)
		if not self.scrollView:isTouchEnabled() then
			self.scrollView:setTouchEnabled(true)
		end
	end)
	self:runAction(cca.seq(nil))
end
function wheelScrollView:scrollEventCallBack(target, event)
	self:updateItems()
	if event == ccui.ScrollviewEventType.scrollingEnd then
		if self.isScrollEnd then
			self:pointCurSelectSingle(false)
			self.isScrollEnd = false
			if not self.scrollView:isTouchEnabled() then
				self.scrollView:setTouchEnabled(true)
			end
		else
			self:bounceSingle()
			if not self.scrollView:isTouchEnabled() then
				self.scrollView:setTouchEnabled(true)
			end
		end
	end
end
function wheelScrollView:pointCurSelectSingle(updateCurI)
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local centerY = offsetY + 0.5 * self.scrollView:getContentSize().height
	local minOffsetY = 0
	local minPoint
	local minI = 1
	for i, v in ipairs(self.itemArray) do
		local y = v:getPositionY() - centerY
		if math.abs(minOffsetY) > math.abs(y) or i == 1 then
			minOffsetY = y
			minPoint = v
			minI = i
		end
	end
	if self.itemSelectedListener and self.curI ~= minI then
		if self.curI ~= nil and not updateCurI and self.isSound then
			SoraDPlaySound()
		end
		if not updateCurI then
			self.curI = minI
			self.itemSelectedListener(self.curI, minPoint)
		end
	end
	return minI
end
function wheelScrollView:bounceSingle()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local centerY = offsetY + 0.5 * self.scrollView:getContentSize().height
	local minOffsetY = 0
	for i, v in ipairs(self.itemArray) do
		local y = v:getPositionY() - centerY
		if math.abs(minOffsetY) > math.abs(y) or i == 1 then
			minOffsetY = y
		end
	end
	offsetY = offsetY + minOffsetY
	local scrollPercent = offsetY == 0 and 100 or 100 * (1 - offsetY / (scrollInner:getContentSize().height - self.scrollView:getContentSize().height))
	if self.isBounceEnd then
		scrollPercent = scrollPercent <= 50 and 0 or 50 < scrollPercent and 100
		self.isBounceEnd = false
	end
	if scrollPercent <= 0 then
		self.scrollView:scrollToTop(0.2, false)
	elseif 100 <= scrollPercent then
		self.scrollView:scrollToBottom(0.2, false)
	else
		self.scrollView:scrollToPercentVertical(scrollPercent, 0.2, true)
	end
	self.isScrollEnd = true
end
function wheelScrollView:updateItems()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local centerY = offsetY + 0.5 * self.scrollView:getContentSize().height
	for i, v in ipairs(self.itemArray) do
		local y = math.abs(v:getPositionY() - centerY)
		local itemOpacity = 255 * (1 - y / (0.5 * self.scrollView:getContentSize().height))
		if itemOpacity <= 0 then
			itemOpacity = 0
		else
			local x = math.sqrt(math.max(self.circleRadius ^ 2 - y ^ 2, 0))
			x = self.offsetPosX + (self.circleRadius - x)
			v:setPositionX(SoraDFPosX(x, v))
		end
		if not self.ignoreOpacity then
			v:setOpacity(itemOpacity)
		end
		local transparentPanel = SoraDGetChildByName(v, "Panel_transparent")
		if transparentPanel then
			if not self.ignoreOpacity then
				transparentPanel:setOpacity(itemOpacity)
			end
			local itemScale = 0.3 * itemOpacity / 255 + 0.7
			transparentPanel:setScale(itemScale)
		end
	end
end
function wheelScrollView:unfoldAction(delay)
	if self.curI == nil then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(false)
	end)
	;(nil)[2] = cca.delay(delay)
	;(nil)[3] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[4] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[5] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[6] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[7] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[8] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[9] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[10] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[11] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[12] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[13] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	;(nil)[14] = cca.callFunc(function(...)
		self.scrollView:setTouchEnabled(true)
	end)
	self:runAction(cca.seq(nil))
	local showCount = 1
	local _ENV, tableOldPos = self, self
	for i, v in ipairs(self.itemArray) do
		if i < self.curI and v:getOpacity() > 0 then
			showCount = self.curI - i
		elseif i > self.curI and v:getOpacity() > 0 then
			showCount = math.max(i - self.curI, showCount)
		end
		v:setLocalZOrder(i > self.curI and self.curI - i or i)
		table.insert(tableOldPos, cc.p(v:getPositionX(), v:getPositionY()))
		v:setVisible(i == self.curI or v:getOpacity() == 0)
	end
	delay = delay / (showCount + 1)
	for i, v in ipairs(self.itemArray) do
		if v:getOpacity() > 0 and i ~= self.curI then
			_UPVALUE2_ = v
			v[1] = cca.delay(delay * math.abs(i - self.curI))
			v[2] = cca.callFunc(function(...)
				v:setVisible(true)
			end)
			v[3] = cca.moveTo(delay, v:getPositionX(), v:getPositionY())
			v[4] = cca.moveTo(delay, v:getPositionX(), v:getPositionY())
			v[5] = cca.moveTo(delay, v:getPositionX(), v:getPositionY())
			v[6] = cca.moveTo(delay, v:getPositionX(), v:getPositionY())
			v[7] = cca.moveTo(delay, v:getPositionX(), v:getPositionY())
			v:runAction(cca.seq(v))
			if i > self.curI then
				v:setPosition(tableOldPos[i - 1])
			else
				v:setPosition(tableOldPos[i + 1])
			end
		elseif i == self.curI then
			v:setScaleY(0.1)
			v:runAction(cca.scaleTo(delay, 1))
		end
	end
end
function wheelScrollView:setItemSelectedListener(listener)
	self.itemSelectedListener = listener
end
return wheelScrollView
