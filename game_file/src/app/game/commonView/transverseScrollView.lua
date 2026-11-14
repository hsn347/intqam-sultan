local transverseScrollView = class("transverseScrollView", function(viewSize)
	local baseView = include("baseView")
	local view = baseView.new(viewSize, false)
	view:setAnchorPoint(cc.p(0.0, 0.0))
	view:setSwallowTouches(false)
	return view
end)
function transverseScrollView:ctor()
	self.minOpacity = 0
	local viewSize = self:getContentSize()
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(viewSize)
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(2)
	self.scrollView:setPosition(cc.p(0, 0))
	self.scrollView:setListenAllScrollingEnabled(true)
	self:addChild(self.scrollView, 1)
	self.tableSingle, _ENV = self.addChild, self.addChild
	self.itemSelectedListener = nil
	self.curI = nil
	self.singleIsMoved = false
	self.singleW = 0
	self.isScrollToIndex = false
	self.isBounceEnd = false
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollView:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
	SoraDFTarget(self.scrollView)
end
function transverseScrollView:setInertiaValue(inertia)
	self.scrollView:setInertiaValue(inertia)
end
function transverseScrollView:initData(array, singleW, posY, cur)
	self.tableSingle = array
	self.singleW = singleW
	self.curI = cur
	for i, v in ipairs(self.tableSingle) do
		v:addTo(self.scrollView, 0)
		v:setPosition((i - 1) * self.singleW, posY)
	end
	local scrollW = (#self.tableSingle - 1) * self.singleW + self.scrollView:getContentSize().width
	self.scrollView:setInnerContainerSize(cc.size(scrollW, self.scrollView:getContentSize().height))
	self:bounceSingle()
	self:selectedCellIndex(self.curI)
	if self.itemSelectedListener then
		self.itemSelectedListener(self.curI)
	end
end
function transverseScrollView:setMinOpacity(opacity)
	self.minOpacity = opacity
end
function transverseScrollView:updateSingles()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local scrollW = self.scrollView:getContentSize().width
	local centerX = offsetX + 0.5 * scrollW
	local scale = 0.3 / (0.5 * scrollW)
	local opacity = (255 - self.minOpacity) / (0.5 * scrollW)
	for i, v in ipairs(self.tableSingle) do
		local normalX = (i - 1) * self.singleW + 0.5 * scrollW
		local x = math.abs(normalX - centerX)
		local adjustX = 0.5 * scale * (normalX - centerX) * x
		local _opacity = 255 - x * opacity
		if _opacity < 0 then
			_opacity = 0
		else
		end
		v:setLocalZOrder(x < 0.5 * self.singleW and 1 or 0)
		v:setScale(math.max(1 - scale * x, 0))
		v:setOpacity(_opacity)
		v:setPositionX(normalX - adjustX)
	end
end
function transverseScrollView:selectedCellIndex(cellIndex, time, attenuated, attenuatedX)
	attenuatedX = attenuatedX or 0
	local scrollInner = self.scrollView:getInnerContainer()
	cellIndex = math.min(math.max(1, cellIndex), #self.tableSingle)
	local offsetX = self.tableSingle[cellIndex]:getPositionX() - 0.5 * self.scrollView:getContentSize().width + attenuatedX
	local scrollPercent = offsetX == 0 and 0 or 100 * offsetX / (scrollInner:getContentSize().width - self.scrollView:getContentSize().width)
	if time then
		attenuated = attenuated or false
		self.scrollView:scrollToPercentHorizontal(scrollPercent, time, attenuated)
	else
		self.scrollView:jumpToPercentHorizontal(scrollPercent)
		self:updateSingles()
		self:pointCurSelectSingle(false)
	end
end
function transverseScrollView:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local scrollInner = self.scrollView:getInnerContainer()
		local offsetX = -scrollInner:getPositionX()
		local centerX = offsetX + 0.5 * self.scrollView:getContentSize().width
		self:pointCurSelectSingle(true, 76.5)
		if self.curI > 1 and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x <= centerX - 0.5 * self.singleW then
			self.isScrollToIndex = -1
			self:setTouchEnabled(false)
			self:setTouchDetection(0.3)
		elseif self.curI < #self.tableSingle and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x >= centerX + 0.5 * self.singleW then
			self.isScrollToIndex = 1
			self:setTouchEnabled(false)
			self:setTouchDetection(0.3)
		else
			self:pointCurSelectSingle(false, 76.5)
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
function transverseScrollView:setTouchDetection(delay)
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
function transverseScrollView:scrollEventCallBack(target, event)
	self:updateSingles()
	if event == ccui.ScrollviewEventType.scrollEnd then
		if self.isScrollToIndex then
			self:selectedCellIndex(self.curI + self.isScrollToIndex, 0.1, true, self.isScrollToIndex * self.singleW * 0.2)
			self.isScrollToIndex = false
		else
			if not self:bounceSingle() then
				self:pointCurSelectSingle(false, 76.5)
			end
			if not self:isTouchEnabled() then
				self:setTouchEnabled(true)
			end
		end
	elseif event == ccui.ScrollviewEventType.bounceLeft or event == ccui.ScrollviewEventType.bounceRight then
		self.isBounceEnd = true
	end
end
function transverseScrollView:pointCurSelectSingle(updateCurI, testOpacity)
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self.scrollView:getContentSize().width
	local minOffsetX = 0
	local minPoint
	local minI = 1
	for i, v in ipairs(self.tableSingle) do
		local x = v:getPositionX() - centerX
		if (math.abs(minOffsetX) > math.abs(x) or i == 1) and (testOpacity and testOpacity < v:getOpacity() and i ~= 1 or testOpacity == nil or i == 1) then
			minOffsetX = x
			minPoint = v
			minI = i
		end
	end
	self.curI = minI
	if self.itemSelectedListener and not updateCurI then
		self.itemSelectedListener(self.curI)
	end
end
function transverseScrollView:bounceSingle()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self.scrollView:getContentSize().width
	local minOffsetX = 0
	for i, v in ipairs(self.tableSingle) do
		local x = v:getPositionX() - centerX
		if math.abs(minOffsetX) > math.abs(x) or i == 1 then
			minOffsetX = x
		end
	end
	offsetX = offsetX + minOffsetX
	local scrollPercent = offsetX == 0 and 0 or 100 * offsetX / (scrollInner:getContentSize().width - self.scrollView:getContentSize().width)
	if math.abs(minOffsetX) <= 5 and not self.isBounceEnd then
		return false
	end
	if self.isBounceEnd then
		scrollPercent = scrollPercent <= 50 and 0 or 50 < scrollPercent and 100
		self.isBounceEnd = false
	end
	if scrollPercent <= 0 then
		self.scrollView:scrollToLeft(0.2, true)
	elseif 100 <= scrollPercent then
		self.scrollView:scrollToRight(0.2, true)
	else
		self.scrollView:scrollToPercentHorizontal(scrollPercent, 0.2, true)
	end
	return true
end
function transverseScrollView:unfoldAction(delay)
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
	for i, v in ipairs(self.tableSingle) do
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
	for i, v in ipairs(self.tableSingle) do
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
			v:setOpacity(0)
			v:setCascadeOpacityEnabled(true)
			v:runAction(cca.fadeIn(delay))
		end
	end
end
function transverseScrollView:setItemSelectedListener(listener)
	self.itemSelectedListener = listener
end
return transverseScrollView
