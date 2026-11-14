_ENV = nil
;(nil).left = 1
local (nil).right, actDirDef = 2, nil
local commonAutoScrollList = class("commonAutoScrollList", function(target)
	return target
end)
function commonAutoScrollList:ctor()
	self.isInit = false
	self.isRight = false
	self.isShowSlider = false
	self.childSize = cc.size(0, 0)
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.itemList, _ENV, self.childOffset = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	self:addEventListener(handler(self, self.scrollEventCallBack))
	self.tbShowScaleBottom = 0.5
	self.tbShowScaleTop = 1.5
	self.barOpacity = 255
end
function commonAutoScrollList:openSlider(targetBar, color, offsetx, barOpacity)
	if not targetBar then
		return
	end
	self.isShowSlider = true
	if barOpacity then
		self.barOpacity = barOpacity
	end
	self.img_bar = targetBar
	self.img_bar:setColor(color or cc.c3b(100, 150, 250))
	self.img_bar:setOpacity(0)
	self.img_bar_offsetx = offsetx or 0
	self.bar_size = self.img_bar:getContentSize()
	self._upY = self:getContentSize().height - self.bar_size.width / 2
	self._downY = self.bar_size.width / 2
end
function commonAutoScrollList:setVisbileShowScale(scaleBottom, scaleTop)
	if scaleBottom then
		self.tbShowScaleBottom = scaleBottom
	end
	if scaleTop then
		self.tbShowScaleTop = scaleTop
	end
end
function commonAutoScrollList:resetScroll()
	self.tableSpare, _UPVALUE0_, self.tableSingle, _UPVALUE0_ = nil, nil, nil, nil
	self:removeAllChildren()
end
function commonAutoScrollList:getAllChildren()
	local _ENV, children
	for i, v in ipairs(self.tableSingle) do
		table.insert(children, v)
	end
	for i, v in ipairs(self.tableSpare) do
		table.insert(children, v)
	end
	return children
end
function commonAutoScrollList:updateItemSelect(itemID)
	local children = self:getAllChildren()
	for k, v in ipairs(children) do
		if v.point then
			v.point:isShowSelect(v.point:getItemID() == itemID)
		end
	end
end
function commonAutoScrollList:recyclingAll()
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
			v.point = nil
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
end
function commonAutoScrollList:getChildByIndex(index)
	return self.tableSingle[index].point
end
function commonAutoScrollList:setSingleRefresh(handle)
	self.refreshHandle = handle
end
function commonAutoScrollList:setSingleCreate(handle)
	self.createHandle = handle
end
function commonAutoScrollList:setSingleCCS(ccsFileName, isNeedFix)
	self.singleCCS = ccsFileName
	self._isNeedFix = isNeedFix
end
function commonAutoScrollList:setScrollBottomFun(handle)
	self.bottomHandle = handle
end
function commonAutoScrollList:setScrollMoveFun(handle)
	self.moveHandle = handle
end
function commonAutoScrollList:setIsRight(ret)
	self.isRight = ret
end
function commonAutoScrollList:updateSlider(target, event)
	local move = function()
		self.img_bar:setOpacity(self.barOpacity)
		self.img_bar:setContentSize(cc.size(self.bar_size.width, self.bar_size.height))
		local inner = self:getInnerContainer()
		local scrollHeight = inner:getContentSize().height
		local posY = inner:getPositionY()
		self.img_bar:setAnchorPoint(cc.p(0.5, 0))
		local _barLen = math.abs(self._upY - self._downY)
		local _topY = scrollHeight - self:getContentSize().height
		local _offsetY = -_barLen / _topY * posY + self._downY
		if _offsetY > self._upY then
			_offsetY = self._upY + self.bar_size.width / 2
			self.img_bar:setAnchorPoint(cc.p(0, 0))
			local percent = math.max(1 - math.abs(_topY + posY) / _barLen, 0.05)
			self.img_bar:setContentSize(cc.size(self.bar_size.width * percent, self.bar_size.height))
		elseif _offsetY < self._downY then
			_offsetY = self._downY - self.bar_size.width / 2
			self.img_bar:setAnchorPoint(cc.p(1, 0))
			local percent = math.max(1 - math.abs(posY) / _barLen, 0.05)
			self.img_bar:setContentSize(cc.size(self.bar_size.width * percent, self.bar_size.height))
		end
		_offsetY = _offsetY + self:getPositionY() + self:getAnchorPoint().y * self:getContentSize().height
		self.img_bar:setPositionX(self:getPositionX() + self:getAnchorPoint().x * self:getContentSize().width + self:getContentSize().width - 10 + self.img_bar_offsetx)
		self.img_bar:setPositionY(_offsetY)
		self.img_bar:runAction(cca.fadeOut(0.5))
	end
	if event == ccui.ScrollviewEventType.containerMoved then
		move()
	elseif event == ccui.ScrollviewEventType.scrollingEnd and self.img_bar:getOpacity() == 0 then
		self.img_bar:setOpacity(self.barOpacity)
		self.img_bar:setContentSize(cc.size(self.bar_size.width, self.bar_size.height))
		self.img_bar:runAction(cca.fadeOut(0.5))
	end
end
function commonAutoScrollList:scrollEventCallBack(target, event)
	if self.isShowSlider then
		self:updateSlider(target, event)
	end
	if event == ccui.ScrollviewEventType.containerMoved then
		self:refreshScroll()
		if self.moveHandle then
			self.moveHandle()
		end
	elseif event == ccui.ScrollviewEventType.bounceBottom and self.bottomHandle then
		self.bottomHandle()
	end
end
function commonAutoScrollList:jumpIndexToTop(index)
	local inner = self:getInnerContainer()
	local scrollHeight = inner:getContentSize().height
	local index = index or 1
	local posY = self:getContentSize().height - self:getInnerContainerSize().height + self.childSize.height * (index - 1)
	inner:setPositionY(math.min(0, posY))
	self:updateScrollView(self.childSize, self.itemList, self.widthNum, self.otherData, true)
end
function commonAutoScrollList:jumpIndexToBottom(index)
	local inner = self:getInnerContainer()
	local scrollHeight = inner:getContentSize().height
	local index = index or 1
	local posY = self.childSize.height * (index - #self.itemList)
	inner:setPositionY(math.max(self:getContentSize().height - self:getInnerContainerSize().height, posY))
	self:updateScrollView(self.childSize, self.itemList, self.widthNum, self.otherData, true)
end
function commonAutoScrollList:jumpIndexToCenter(index)
	local inner = self:getInnerContainer()
	local innerH = inner:getContentSize().height
	local scrollH = self:getContentSize().height
	local index = index or 1
	local posY = scrollH / 2 - innerH + self.childSize.height * (index - 0.5)
	inner:setPositionY(math.max(scrollH - innerH, (math.min(0, posY))))
	print("alliancePBLHonorView_Jump", index, posY, innerH, scrollH, math.max(scrollH - innerH, (math.min(0, posY))), self.childSize.height)
	self:updateScrollView(self.childSize, self.itemList, self.widthNum, self.otherData, true)
end
function commonAutoScrollList:jumpIndexToCenter_X(index)
	local inner = self:getInnerContainer()
	local innerW = inner:getContentSize().width
	local scrollW = self:getContentSize().width
	local index = index or 1
	local posX = scrollW / 2 - innerW + self.childSize.width * (index - 0.5)
	print("alliancePBLHonorView_Jump", index, posX, innerW, scrollW, math.max(scrollW - innerW, (math.min(0, posX))), inner:getPositionX())
	inner:setPositionX(math.max(scrollW - innerW, (math.min(0, posX))))
end
function commonAutoScrollList:setChildOffset(offset)
	self.childOffset = offset
end
function commonAutoScrollList:setEnabledFollowHeight()
	self:setTouchEnabled(self:getInnerContainerSize().height > self:getContentSize().height)
end
function commonAutoScrollList:updateScrollView(singleSize, itemList, widthNum, otherData, isAct)
