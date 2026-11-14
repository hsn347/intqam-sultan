local petHeadSingleW = 250
local KingGroupBuyBoxScroll = class("kingGroupBuyBoxScroll", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingGroupBuyBoxScroll")
	end
	return target
end)
function KingGroupBuyBoxScroll:ctor()
	self.handle = nil
	self.createFun = nil
	self.curI = 1
	self.singleIsMoved = false
	self.isScrollToIndex = false
	self.isBounceEnd = false
	self.petListData, _ENV, self.tableSpare, _ENV, self.hasInit = nil, nil, nil, nil, false
	self:setListenAllScrollingEnabled(true)
	self:setInertiaValue(0.1)
	self:addEventListener(handler(self, self.scrollEventCallBack))
	self:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
end
function KingGroupBuyBoxScroll:initData(data, index, createFun, editFun)
	self.createFun = createFun
	self.editFun = editFun
	self.hasInit = false
	local tableBaseData = data
	for i, v in ipairs(self.petListData) do
		if v.point then
			table.insert(self.tableSpare, v.point)
			v.point:setVisible(false)
		end
	end
	self.petListData, _ENV = ipairs(self.petListData)
	self.curI = index and index or 1
	if SoraDFIsRA() then
		for i = #tableBaseData, 1, -1 do
			_ENV = v.point
			v.point.data = tableBaseData[i]
			v.point.point = nil
			v.point.posX = 0
			v.point.idx = i
			table.insert(self.petListData, v.point)
		end
	else
		for i = 1, #tableBaseData do
			_ENV = v.point
			v.point.data = tableBaseData[i]
			v.point.point = nil
			v.point.posX = 0
			v.point.idx = i
			table.insert(self.petListData, v.point)
		end
	end
	self:updateSize()
	self:updateSingles()
end
function KingGroupBuyBoxScroll:transIndex(index)
	if SoraDFIsRA() then
		return table.nums(self.petListData) - index + 1
	else
		return index
	end
end
function KingGroupBuyBoxScroll:updateSize(notBigChange)
	local scrollW = (#self.petListData - 1) * petHeadSingleW + self:getContentSize().width
	for i, v in ipairs(self.petListData) do
		v.posX = 0.5 * self:getContentSize().width + (i - 1) * petHeadSingleW
	end
	if not notBigChange then
		local offsetX = self.petListData[self.curI].posX - 0.5 * self:getContentSize().width
		local scrollPercent = offsetX == 0 and 0 or 100 * offsetX / (scrollW - self:getContentSize().width)
		self:setInnerContainerSize(cc.size(scrollW, self:getContentSize().height))
		self:jumpToPercentHorizontal(scrollPercent)
	end
	self:updateSingles()
	self:selectedCellIndex(self.curI, 0.5, true)
end
function KingGroupBuyBoxScroll:updateSingles()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local scale = 0.004285714285714286
	local rgb = 0.001176470588235294
	local scrollW = self:getContentSize().width
	local scrollH = self:getContentSize().height
	_ENV = self
	self.beginX = math.max(0, offsetX - 0.5 * scrollW)
	local self.endX, tableShowW = offsetX + 1.5 * scrollW, self
	local midPos = offsetX + scrollW / 2
	for i, v in ipairs(self.petListData) do
		if v.point then
			if v.posX < tableShowW.beginX or v.posX > tableShowW.endX then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowW.beginX <= v.posX and tableShowW.endX >= v.posX then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				self.editFun(single, v.data, v.idx)
				single:setVisible(true)
			else
				single = self.createFun(v.data, v.idx)
				single:addTo(self)
			end
			single:setPosition(cc.p(v.posX, 0.5 * scrollH))
			v.point = single
		end
		if v.point then
			if midPos > v.posX then
				local deta = midPos - v.posX
				local scaleF = self.clampf(1 - math.min(deta / petHeadSingleW, 1), 0.75, 1)
				v.point:setScale(scaleF)
			elseif midPos < v.posX then
				local deta = v.posX - midPos
				local scaleF = self.clampf(1 - math.min(deta / petHeadSingleW, 1), 0.75, 1)
				v.point:setScale(scaleF)
			else
				v.point:setScale(1)
			end
		end
	end
end
function KingGroupBuyBoxScroll.clampf(value, min, max)
	return math.max(math.min(value, max), min)
end
function KingGroupBuyBoxScroll:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local scrollInner = self:getInnerContainer()
		local offsetX = -scrollInner:getPositionX()
		local centerX = offsetX + 0.5 * self:getContentSize().width
		local singleWidth = petHeadSingleW
		self:pointCurSelectSingle(true)
		if self.curI > 1 and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x <= centerX - 0.5 * singleWidth then
			self.isScrollToIndex = -1
			self:setTouchEnabled(false)
			self:setTouchDetection(0.3)
		elseif self.curI < #self.petListData and scrollInner:convertToNodeSpace(target:getTouchBeganPosition()).x >= centerX + 0.5 * singleWidth then
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
function KingGroupBuyBoxScroll:setTouchDetection(delay)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(delay)
	;(nil)[2] = cca.callFunc(function(...)
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
			self:setSwallowTouches(false)
		end
	end)
	;(nil)[3] = cca.callFunc(function(...)
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
			self:setSwallowTouches(false)
		end
	end)
	self:runAction(cca.seq(nil))
end
function KingGroupBuyBoxScroll:scrollEventCallBack(target, event)
	self:updateSingles()
	if event == ccui.ScrollviewEventType.scrollingEnd then
		if not self:bounceSingle() then
			self:pointCurSelectSingle(false)
		end
		if not self:isTouchEnabled() then
			self:setTouchEnabled(true)
			self:setSwallowTouches(false)
		end
	elseif event == ccui.ScrollviewEventType.bounceLeft or event == ccui.ScrollviewEventType.bounceRight then
		self.isBounceEnd = true
	end
end
function KingGroupBuyBoxScroll:selectedCellIndex(cellIndex, time, attenuated, attenuatedX)
	attenuatedX = attenuatedX or 0
	local scrollInner = self:getInnerContainer()
	cellIndex = math.min(math.max(1, cellIndex), #self.petListData)
	local offsetX = self.petListData[cellIndex].posX - 0.5 * self:getContentSize().width + attenuatedX
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
function KingGroupBuyBoxScroll:bounceSingle()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local minOffsetX = 0
	for i, v in ipairs(self.petListData) do
		local x = v.posX - centerX
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
function KingGroupBuyBoxScroll:pointCurSelectSingle(updateCurI)
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local centerX = offsetX + 0.5 * self:getContentSize().width
	local minOffsetX = 0
	local minPoint
	local minI = 1
	for i, v in ipairs(self.petListData) do
		local x = v.posX - centerX
		if math.abs(minOffsetX) > math.abs(x) or i == 1 then
			minOffsetX = x
			minPoint = v
			minI = i
		end
	end
	local oldI = self.curI
	self.curI = minI
	if oldI ~= minI and self.handle and not updateCurI and self.hasInit then
		SoraDPlaySound()
		self.handle(self:transIndex(self.curI))
		self:setGray(self:transIndex(self.curI))
	end
	self.hasInit = true
end
function KingGroupBuyBoxScroll:setGray(index)
	for i, v in ipairs(self.petListData) do
		if v.point then
			if index == v.idx then
				v.point:getVirtualRenderer():setState(0)
				v.point:getChildByName("Image_item"):getVirtualRenderer():setState(0)
			else
				v.point:getVirtualRenderer():setState(1)
				v.point:getChildByName("Image_item"):getVirtualRenderer():setState(1)
			end
		end
	end
end
function KingGroupBuyBoxScroll:setHandle(handle)
	self.handle = handle
end
return KingGroupBuyBoxScroll
