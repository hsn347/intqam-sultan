local gametop = gModuleMgr.getObject("gametop")
local redPacketDetailScrollView = class("redPacketDetailScrollView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("redPacketDetailScrollView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function redPacketDetailScrollView:ctor()
	self.celllWidth = 600
	self.cellHeight = 110
	self.heightTopAutoScroll = 100
	self.heightNotice = 52
	self.itemsData, _ENV, self.recycledList, _ENV, self.heightEnableNotice = nil, nil, nil, nil, 55
	self.reload = false
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.deltaGoldInfoHeight = 80
end
function redPacketDetailScrollView:initWithData(data)
	self.itemsData = self:filterData(data)
	self:delayUpdateScrollView()
end
function redPacketDetailScrollView:filterData(data)
	local ret = data.log
	if data.left == 0 then
		local luckIndex = 0
		local maxGold = 0
		for i, v in ipairs(ret) do
			v.redPacketType = data.type
			if maxGold < v.gold then
				maxGold = v.gold
				luckIndex = i
			end
		end
		if luckIndex ~= 0 then
			print("luck = ", luckIndex)
			ret[luckIndex].isLuck = true
		end
	else
		for i, v in ipairs(ret) do
			v.redPacketType = data.type
		end
	end
	return ret
end
function redPacketDetailScrollView:delayUpdateScrollView()
	local actDelay = cca.delay(0.1)
	local callFunc = cca.callFunc(handler(self, self.updateScrollView))
	_UPVALUE2_ = handler(self, self.updateScrollView)
	handler(self, self.updateScrollView)[1] = actDelay
	handler(self, self.updateScrollView)[2] = callFunc
	local seq = cca.seq(handler(self, self.updateScrollView))
	self:runAction(seq)
end
function redPacketDetailScrollView:onMessageListener()
end
function redPacketDetailScrollView:updateScrollView()
	for i, v in ipairs(self.itemsData) do
		if v.itemWidth == nil and v.itemHeight == nil or v.itemWidth == 0 and v.itemHeight == 0 then
			v.itemWidth = self.cellWidth
			v.itemHeight = self.cellHeight
		else
		end
	end
	if self.reload == true then
		self:doRecycleHistory()
		self.reload = false
	end
	self:updateScrollSize()
	self:updateScrollCell()
end
function redPacketDetailScrollView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local minOffsetY = -(scrollInner:getContentSize().height - self.scrollView:getContentSize().height)
	local offsetY = scrollInner:getPositionY()
	local totalHeight = 0
	for i, v in ipairs(self.itemsData) do
		totalHeight = totalHeight + v.itemHeight
	end
	local scrollInnerHeight = math.max(self.heightNotice + totalHeight, self.scrollView:getContentSize().height)
	local accumulateHeight = 0
	for i, v in ipairs(self.itemsData) do
		v.itemPosX = 0
		accumulateHeight = accumulateHeight + v.itemHeight
		v.itemPosY = scrollInnerHeight - accumulateHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	local totalCellHeight = scrollInnerHeight
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
	end
	local scrollInnerNewH = totalCellHeight
	scrollInnerNewH = scrollInnerNewH + 10
	local bNeedAutoScrollTop = false
	if minOffsetY <= offsetY and offsetY <= minOffsetY + self.heightTopAutoScroll then
		bNeedAutoScrollTop = true
	end
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scrollView:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if bNeedAutoScrollTop then
		self.scrollView:scrollToTop(0.3, true)
	end
end
function redPacketDetailScrollView:updateScrollCell()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollView
	local renderCount = 0
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.itemPosY < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				self:addToRecycledList(v.itemNode)
				v.itemNode = nil
			else
			end
		elseif v.itemPosY and tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			local itemNode, isFromRecycle = self:getItem(v)
			v.itemNode = itemNode
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			if isFromRecycle == false then
				v.itemNode:addTo(self.scrollView)
			end
		end
	end
end
function redPacketDetailScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
	elseif event == ccui.ScrollviewEventType.bounceTop then
	end
end
function redPacketDetailScrollView:isCellInRecycledList(cell)
	local result = false
	for i, v in ipairs(self.recycledList) do
		if v == cell then
			result = true
			break
		end
	end
	return result
end
function redPacketDetailScrollView:addToRecycledList(cell)
	cell:setVisible(false)
	table.insert(self.recycledList, cell)
end
function redPacketDetailScrollView:hasAnyRecycledCell()
	local result = false
	if #self.recycledList > 0 then
		result = true
		return result
	end
	return result
end
function redPacketDetailScrollView:pickCellFromRecycledList()
	local cell
	if #self.recycledList > 0 then
		cell = table.remove(self.recycledList)
		cell:setVisible(true)
	end
	return cell
end
function redPacketDetailScrollView:recycleAll()
	for i = 1, #self.itemsData do
		local dataItem = self.itemsData[i]
		if dataItem.itemNode then
			if dataItem.isSeperator then
				self:addToRecycledGroupList(dataItem.itemNode)
				dataItem.itemNode = nil
			else
				self:addToRecycledList(dataItem.itemNode)
				dataItem.itemNode = nil
			end
		end
	end
end
function redPacketDetailScrollView:cleanAll()
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			self:addToRecycledList(v.itemNode)
			v.itemNode = nil
		end
	end
	self.itemsData, _ENV = ipairs(self.itemsData)
end
function redPacketDetailScrollView:saveHistory()
	self.historyData = self.itemsData
end
function redPacketDetailScrollView:doRecycleHistory()
	print("redPacketDetailScrollView:回收历史")
	for i, v in ipairs(self.historyData) do
		local dataItem = v
		if dataItem.itemNode then
			self:addToRecycledList(dataItem.itemNode)
			dataItem.itemNode = nil
		end
	end
	self.historyData, _ENV = ipairs(self.historyData)
end
function redPacketDetailScrollView:getItem(data)
	local cell
	local isFromRecycle = false
	if self:hasAnyRecycledCell() == true then
		cell = self:pickCellFromRecycledList()
		cell:setScrollView(self)
		cell:initWithData(data)
		isFromRecycle = true
	else
		cell = self:createItem(data)
	end
	return cell, isFromRecycle
end
function redPacketDetailScrollView:createItem(data)
	local redPacketItemNode
	local redPacketItem = include("redPacketItem")
	redPacketItemNode = redPacketItem.new()
	redPacketItemNode:setScrollView(self)
	redPacketItemNode:initWithData(data)
	return redPacketItemNode
end
function redPacketDetailScrollView:adjustHeight(deltaHeight)
	local scrollSize = self.scrollView:getContentSize()
	self.scrollView:setContentSize(cc.size(scrollSize.width, scrollSize.height + self.deltaGoldInfoHeight))
	local scrollInner = self.scrollView:getInnerContainer()
	local innerSize = cc.size(self.scrollView:getContentSize().width, self.scrollView:getContentSize().height)
	self.scrollView:setInnerContainerSize(innerSize)
end
return redPacketDetailScrollView
