local MaxY = 50
local eventLimitGiftScrollView = class("equipMenuRowScrollView", function(target)
	return target
end)
function eventLimitGiftScrollView:ctor()
	self.tableSingle, _ENV = nil, nil
	self.singleSelectedListener = nil
	self.curI = nil
	self.hasInit = false
	self.singleIsMoved = false
	self.isScrollToIndex = false
	self.isBounceEnd = false
	self:setListenAllScrollingEnabled(true)
	self:setInertiaValue(0.1)
	self:addEventListener(handler(self, self.scrollEventCallBack))
	self:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
end
function eventLimitGiftScrollView:initData(curI, tableSingle, singleSize, itemPosY)
	self.curI = curI
	self.tableSingle = tableSingle
	for i, v in ipairs(self.tableSingle) do
		function v.getSingleW()
			return singleSize.width
		end
		function v.getSingleH()
			return singleSize.height
		end
		v:addTo(self, 0)
		v.posy = itemPosY or v:getSingleH() * 0.5
		v:setPositionY(v.posy)
	end
	self:updateSize()
end
function eventLimitGiftScrollView:updateSize()
	local scrollW = (#self.tableSingle - 1) * self.tableSingle[1]:getSingleW() + self:getContentSize().width
	self:setInnerContainerSize(cc.size(scrollW, self:getContentSize().height))
	self:jumpToPercentHorizontal(100 * (self.curI - 0.5) / #self.tableSingle)
	self:updateSingles()
	self:selectedCellIndex(self.curI)
end
function eventLimitGiftScrollView:jumpToIndex(index)
	self.curI = index
	self:updateSize()
end
function eventLimitGiftScrollView:updateSingles()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local scrollW = self:getContentSize().width
	local scale = 0.3 / (0.5 * scrollW)
	local rgb = 127.5 / (0.5 * scrollW)
	for i, v in ipairs(self.tableSingle) do
		local normalX = (i - 1) * v:getSingleW() + 0.5 * scrollW
		local x = math.abs(normalX - centerX)
		local adjustX = 0.5 * scale * (normalX - centerX) * x
		local _rgb = 255 - x * rgb
		local _scale = 1.0 - scale * x
		if 0 < _rgb then
			if v.setContentScale then
				v.setContentScale(_scale)
			else
				v:setScale(_scale)
			end
			if v.setContentOpacity then
				v.setContentOpacity(_rgb)
			else
				v:setColor(cc.c3b(_rgb, _rgb, _rgb))
			end
			if v.needAdjustX == nil or v.needAdjustX then
				v:setPositionX(normalX - adjustX)
			else
				v:setPositionX(normalX)
			end
			if v.needAdjustY == nil or v.needAdjustY then
				v:setPositionY(v.posy + math.abs(adjustX))
			end
		end
		v:setVisible(0 < _rgb)
	end
end
function eventLimitGiftScrollView:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local action = cca.callFunc(function()
			local scrollInner = self:getInnerContainer()
			local offsetX = -scrollInner:getPositionX()
			local centerX = offsetX + 0.5 * self:getContentSize().width
			local singleWidth = self.tableSingle[1]:getSingleW()
			self:pointCurSelectSingle(true)
			if 1 < self.curI and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x <= centerX - 0.5 * singleWidth then
				self.isScrollToIndex = -1
				self:setTouchEnabled(false)
				self:setTouchDetection(0.3)
			elseif self.curI < #self.tableSingle and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x >= centerX + 0.5 * singleWidth then
				self.isScrollToIndex = 1
				self:setTouchEnabled(false)
				self:setTouchDetection(0.3)
			else
				self:pointCurSelectSingle(false)
			end
			if self.isScrollToIndex then
				self:selectedCellIndex(self.curI + self.isScrollToIndex, 0.1, true, self.isScrollToIndex * 20)
				self.isScrollToIndex = false
			end
		end)
		self:runAction(action)
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
function eventLimitGiftScrollView:setTouchDetection(delay)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(delay)
	;(nil)[2] = cca.callFunc(function(...)
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
		end
	end)
	;(nil)[3] = cca.callFunc(function(...)
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
		end
	end)
	self:runAction(cca.seq(nil))
end
function eventLimitGiftScrollView:scrollEventCallBack(target, event)
	self:updateSingles()
	if event == ccui.ScrollviewEventType.scrollingEnd then
		if not self:bounceSingle() then
			self:pointCurSelectSingle(false)
		end
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
		end
	elseif event == ccui.ScrollviewEventType.bounceLeft or event == ccui.ScrollviewEventType.bounceRight then
		self.isBounceEnd = true
	end
end
function eventLimitGiftScrollView:selectedCellIndex(cellIndex, time, attenuated, attenuatedX)
	attenuatedX = attenuatedX or 0
	local scrollInner = self:getInnerContainer()
	cellIndex = math.min(math.max(1, cellIndex), #self.tableSingle)
	local offsetX = self.tableSingle[cellIndex]:getPositionX() - 0.5 * self:getContentSize().width + attenuatedX
	local scrollPercent = offsetX == 0 and 0 or 100 * offsetX / (scrollInner:getContentSize().width - self:getContentSize().width)
	if time then
		attenuated = attenuated or false
		self:scrollToPercentHorizontal(scrollPercent, time, attenuated)
	else
		self:jumpToPercentHorizontal(scrollPercent)
		self:updateSingles()
		self:pointCurSelectSingle(false)
	end
end
function eventLimitGiftScrollView:bounceSingle()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local minOffsetX = 0
	for i, v in ipairs(self.tableSingle) do
		local x = v:getPositionX() - centerX
		if math.abs(minOffsetX) > math.abs(x) or i == 1 then
			minOffsetX = x
		end
	end
	offsetX = offsetX + minOffsetX
	local scrollPercent = offsetX == 0 and 0 or 100 * offsetX / (scrollInner:getContentSize().width - self:getContentSize().width)
	if math.abs(minOffsetX) <= 5 and not self.isBounceEnd then
		return false
	end
	if self.isBounceEnd then
		scrollPercent = scrollPercent <= 50 and 0 or 50 < scrollPercent and 100
		self.isBounceEnd = false
	end
	if scrollPercent <= 0 then
		self:scrollToLeft(0.2, true)
	elseif 100 <= scrollPercent then
		self:scrollToRight(0.2, true)
	else
		self:scrollToPercentHorizontal(scrollPercent, 0.2, true)
	end
	return true
end
function eventLimitGiftScrollView:pointCurSelectSingle(updateCurI)
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local minOffsetX = 0
	local minPoint
	local minI = 1
	for i, v in ipairs(self.tableSingle) do
		local x = v:getPositionX() - centerX
		if math.abs(minOffsetX) > math.abs(x) or i == 1 then
			minOffsetX = x
			minPoint = v
			minI = i
		end
	end
	self.curI = minI
	if self.singleSelectedListener and not updateCurI then
		if self.hasInit then
		else
			self.hasInit = true
		end
		self.singleSelectedListener(self.curI)
	end
end
function eventLimitGiftScrollView:setSingleSelectedListener(listener)
	self.singleSelectedListener = listener
end
function eventLimitGiftScrollView:unfoldAction(delay)
end
function eventLimitGiftScrollView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
	end
end
return eventLimitGiftScrollView
