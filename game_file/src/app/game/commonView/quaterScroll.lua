local QuaterScroll = class("quaterScroll", function(target)
	return target
end)
function QuaterScroll:ctor()
	self.scroll = self
	self.scroll:setListenAllScrollingEnabled(true)
	self.itemList, _ENV, self.infoTbl, _ENV = self.scroll.setListenAllScrollingEnabled, self.scroll.setListenAllScrollingEnabled, self.scroll.setListenAllScrollingEnabled, self.scroll.setListenAllScrollingEnabled
	self.scrollEnd = true
	if not self._addEventListener then
		self._addEventListener = self.addEventListener
		self:_addEventListener(handler(self, self.scrollEventCallBack))
		function self.addEventListener(target, cb)
			target.scrollEventCb = cb
		end
	end
end
function QuaterScroll:init(initInfo)
	self.infoTbl = initInfo
	self.createSingle = initInfo.createHandler
	self.jumpHandler = initInfo.jumpHandler
	self:initView()
end
function QuaterScroll:initView(...)
	if self.infoTbl.inertia then
		self.scroll:setInertiaValue(self.infoTbl.inertia)
	end
	self.scrollWidth = self.infoTbl.showCount * self.infoTbl.itemSize.width
	self.totalItemWidth = self.infoTbl.itemSize.width * table.nums(self.infoTbl.itemList)
	self.innerScrollWidth = self.totalItemWidth + self.scrollWidth - self.infoTbl.itemSize.width
	self.scroll:setContentSize(cc.size(self.scrollWidth, self.infoTbl.itemSize.height))
	self.scroll:setInnerContainerSize(cc.size(self.innerScrollWidth, self.infoTbl.itemSize.height))
	self:refreshTable()
	if self.infoTbl.curIndex then
		self:jumpToIndex(self.infoTbl.curIndex)
	end
	self:updateScroll()
	self:initDiviImage()
end
function QuaterScroll:refreshData(itemList)
	self.infoTbl.itemList = itemList
	self:refreshTable()
	self:updateScroll()
	self:initDiviImage()
end
function QuaterScroll:initDiviImage(...)
	if table.nums(self.infoTbl.itemList) > 1 and self.infoTbl.diviImg then
		local sSize = self.scroll:getContentSize()
		for i = 1, table.nums(self.infoTbl.itemList) - 1 do
			local dSp = display.newSprite("#" .. self.infoTbl.diviImg)
			if SoraDFIsRA() then
				dSp:setFlippedX(false)
			else
				dSp:setFlippedX(true)
			end
			dSp:addTo(self.scroll)
			dSp:setPosition(sSize.width / 2 + self.infoTbl.itemSize.width / 2 + (i - 1) * self.infoTbl.itemSize.width, sSize.height / 2)
		end
	end
end
function QuaterScroll:refreshTable(...)
	self.scroll:removeAllChildren()
	self.itemList, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	local keys = table.keys(self.infoTbl.itemList)
	local realSW = (self.scrollWidth - self.infoTbl.itemSize.width) / 2
	for i, v in ipairs(keys) do
		self.itemList[v], _ENV = nil, nil
		if SoraDFIsRA() then
			self.itemList[v].posX = self.innerScrollWidth - (i + 1) * self.infoTbl.itemSize.width
		else
			self.itemList[v].posX = realSW + (i - 1) * self.infoTbl.itemSize.width
		end
		self.itemList[v].data = self.infoTbl.itemList[v]
		self.itemList[v].index = i
	end
end
function QuaterScroll:updateScroll(...)
	local scrollInner = self.scroll:getInnerContainer()
	local sSize = self.scroll:getContentSize()
	local itemWidth = self.infoTbl.itemSize.width
	local offsetX = -scrollInner:getPositionX()
	local scrollW = sSize.width
	_ENV = nil
	;(nil).beginX = math.max(0, offsetX - 0.5 * scrollW)
	local _ENV, (nil).endX, tableShowW = offsetX + 2 * scrollW, offsetX + 2 * scrollW, nil
	;(offsetX + 2 * scrollW).beginX = math.max(0, offsetX + itemWidth / 2) - itemWidth / 2
	local (offsetX + 2 * scrollW).endX, fadeShowW = offsetX + scrollW - itemWidth / 2 - itemWidth / 2, offsetX + 2 * scrollW
	local midPos = offsetX + scrollW / 2
	for k, v in pairs(self.itemList) do
		if v.posX < tableShowW.beginX or v.posX > tableShowW.endX then
			if v.point then
				v.point:setVisible(false)
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(v.posX + itemWidth / 2, sSize.height / 2)
		else
			local single = self.createSingle(v.data, k)
			single:setPosition(v.posX + itemWidth / 2, sSize.height / 2)
			single:addTo(self.scroll)
			v.point = single
		end
		if self.infoTbl.fadeAction then
			if v.posX < fadeShowW.beginX then
				if v.point then
					local deta = fadeShowW.beginX - v.posX
					v.point:setOpacity((1 - math.min(deta / itemWidth, 1)) * 255)
				end
			elseif v.posX > fadeShowW.endX then
				if v.point then
					local deta = v.posX - fadeShowW.endX
					v.point:setOpacity((1 - math.min(deta / itemWidth, 1)) * 255)
				end
			elseif v.point then
				v.point:setOpacity(255)
			end
		elseif self.infoTbl.scaleAction and v.point then
			local realPosX = v.posX + itemWidth / 2
			if midPos > realPosX then
				local deta = midPos - realPosX
				local scaleF = self.clampf(1 - math.min(deta / itemWidth, 1), 0.75, 1)
				v.point:setScale(scaleF)
			elseif midPos < realPosX then
				local deta = realPosX - midPos
				local scaleF = self.clampf(1 - math.min(deta / itemWidth, 1), 0.75, 1)
				v.point:setScale(scaleF)
			else
				v.point:setScale(1)
			end
		end
	end
end
function QuaterScroll.round(v)
	return math.floor(v + 0.5)
end
function QuaterScroll.clampf(value, min, max)
	return math.max(math.min(value, max), min)
end
function QuaterScroll:jumpToIndex(index)
	local scrollInner = self.scroll:getInnerContainer()
	local totalWidth = scrollInner:getContentSize().width - self.scroll:getContentSize().width
	local curPosX = (index - 1) * self.infoTbl.itemSize.width
	self.scroll:scrollToPercentHorizontal(curPosX / totalWidth * 100, 0.1, true)
	if not self.scrollEnd and self.jumpHandler then
		self.jumpHandler(self:transIndex(index))
	end
end
function QuaterScroll:popAllItems(...)
	local _ENV, popList
	for k, v in pairs(self.itemList) do
		if v.point then
			_ENV = nil
			;(nil).ocx = v.point
			;(nil).idx = k
			table.insert(popList, nil)
		end
	end
	return popList
end
function QuaterScroll:transIndex(index)
	if SoraDFIsRA() then
		return table.nums(self.infoTbl.itemList) - index + 1
	else
		return index
	end
end
function QuaterScroll:scrollToIndex(index)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local totalWidth = scrollInner:getContentSize().width - self.scroll:getContentSize().width
	local curPosX = self.round(offsetX / self.infoTbl.itemSize.width) * self.infoTbl.itemSize.width
	if index then
		curPosX = (index - 1) * self.infoTbl.itemSize.width
	end
	self.scroll:scrollToPercentHorizontal(curPosX / totalWidth * 100, 0.1, true)
	if self.jumpHandler then
		local jIndex = index or math.abs(self.clampf(curPosX / self.infoTbl.itemSize.width + 1, 1, table.nums(self.infoTbl.itemList)))
		self.jumpHandler(self:transIndex(jIndex))
	end
	_ENV = self:transIndex(jIndex)
	self:transIndex(jIndex).delay = 0.3
	self:transIndex(jIndex).onComplete = function()
		self.scrollEnd = true
	end
	transition.execute(self, nil, self:transIndex(jIndex))
end
function QuaterScroll:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScroll()
	elseif event == ccui.ScrollviewEventType.scrollingEnd then
		print("scrollEnd")
		if self.scrollEnd then
			self.scrollEnd = false
			self:scrollToIndex()
			self:updateScroll()
		end
	elseif event == ccui.ScrollviewEventType.bounceLeft or event == ccui.ScrollviewEventType.bounceRight then
	end
	if self.scrollEventCb then
		self.scrollEventCb(target, event)
	end
end
return QuaterScroll
