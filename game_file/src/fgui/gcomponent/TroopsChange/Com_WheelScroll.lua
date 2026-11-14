local baseComponent = require("fgui.base.baseComponent")
local Com_WheelScroll = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/Com_WheelScroll", Com_WheelScroll)
function Com_WheelScroll:onInit()
	self.itemArray, _ENV = nil, nil
	self.centerY = display.cy
	self.circleRadius = 500
	self.cellHeight = 100
	self.offsetPosX = 320
	self.ignoreOpacity = false
	self.totalNum = 10
	self.curI = 1
	self.fields.scroll:addClickListener(handler(self, self.onClickScroll))
	self.fields.scroll:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrolling))
	self.fields.scroll:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
end
function Com_WheelScroll:onShow()
	self.scrollInner = fgui.GComponent:create()
	self.fields.scroll:addChild(self.scrollInner)
	local scrollH = #self.itemArray * self.cellHeight + self.fields.scroll:getContentSize().height - self.cellHeight
	for i, v in ipairs(self.itemArray) do
		v:setPosition(cc.p(self.offsetPosX, self.cellHeight * (i - 1) + 0.5 * self.fields.scroll:getContentSize().height))
		self.scrollInner:addChild(v, 1)
		v:setTag(i)
	end
	self.scrollInner:setContentSize(cc.size(self.fields.scroll:getContentSize().width, scrollH))
	self:onScrolling()
end
function Com_WheelScroll:onClickScroll(eventContext)
	local offsetY = -self.scrollInner:getPositionY()
	local centerY = offsetY + 0.5 * self.fields.scroll:getContentSize().height
	local curI = self:pointCurSelectSingle(true)
	local touchPosY = eventContext:getInput():getPosition().y
	print(touchPosY, "touchPosY", curI)
	if 1 <= curI and touchPosY >= self.centerY + 0.5 * self.cellHeight then
		self.isScrollToIndex = 1
	elseif curI <= self.totalNum and touchPosY <= self.centerY - 0.5 * self.cellHeight then
		self.isScrollToIndex = -1
	end
	if self.isScrollToIndex then
		print("curI + self.isScrollToIndex", curI + self.isScrollToIndex)
		self:selectedCellIndex(curI + self.isScrollToIndex)
		self.isScrollToIndex = false
	end
end
function Com_WheelScroll:onItemRenderer(index, object)
	local contentHeight = self.fields.scroll:getContentSize().height
	local objectPosY = object:convertToWorldSpace(cc.p(object:getPositionX(), 0)).y
	local y = math.abs(objectPosY - self.centerY)
	local itemOpacity = 255 * (1 - y / (0.5 * contentHeight))
	if itemOpacity <= 0 then
		itemOpacity = 0
	else
		local x = math.sqrt(self.circleRadius ^ 2 - y ^ 2)
		x = self.offsetPosX + (self.circleRadius - x)
		object:setPositionX(SoraDFPosX(x, object))
	end
	if not self.ignoreOpacity then
		object:setAlpha(itemOpacity / 255)
	end
	local itemScale = 0.3 * itemOpacity / 255 + 0.7
	object:setScale(itemScale)
	object:setString(index)
end
function Com_WheelScroll:onScrolling()
	for i, v in ipairs(self.itemArray) do
		self:onItemRenderer(i - 1, v)
	end
end
function Com_WheelScroll:onScrollEnd()
	self:bounceSingle()
end
function Com_WheelScroll:bounceSingle()
	local curI = self:pointCurSelectSingle(true)
	local offsetY = self.itemArray[curI]:getPositionY() - 0.5 * self.fields.scroll:getContentSize().height
	local scrollPercent = offsetY == 0 and 0 or offsetY / (self.scrollInner:getContentSize().height - self.fields.scroll:getContentSize().height)
	print(scrollPercent, "scrollPercent", curI)
	self.fields.scroll:getScrollPane():setPercY(scrollPercent, false)
end
function Com_WheelScroll:selectedCellIndex(cellIndex)
	cellIndex = math.min(math.max(1, cellIndex), self.totalNum)
	local offsetY = self.itemArray[cellIndex]:getPositionY() - 0.5 * self.fields.scroll:getContentSize().height
	local scrollPercent = offsetY == 0 and 0 or offsetY / (self.scrollInner:getContentSize().height - self.fields.scroll:getContentSize().height)
	self.fields.scroll:getScrollPane():setPercY(scrollPercent, true)
	print("scrollPercent", cellIndex, scrollPercent, offsetY, self.itemArray[cellIndex]:getPositionY(), self.scrollInner:getContentSize().height - self.fields.scroll:getContentSize().height)
	self:pointCurSelectSingle(false)
end
function Com_WheelScroll:pointCurSelectSingle(updateCurI)
	local minOffsetY = 0
	local minPoint
	local minI = 1
	for i, v in ipairs(self.itemArray) do
		local objectPosY = v:convertToWorldSpace(cc.p(v:getPositionX(), 0)).y
		local y = objectPosY - self.centerY
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
function Com_WheelScroll:setItemSelectedListener(handler)
	self.itemSelectedListener = listener
end
function Com_WheelScroll:setParam(data)
	self.itemArray = data.array
	self.cellHeight = data.cellHeight
	self.offsetPosX = data.posX
	self.ignoreOpacity = data.isIgnoreOpacity or false
	self.circleRadius = math.max(data.circleRadius, self.fields.scroll:getContentSize().width)
end
return Com_WheelScroll
