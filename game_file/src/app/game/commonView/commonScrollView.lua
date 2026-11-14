local commonScrollView = class("commonScrollView", function(target)
	return target
end)
function commonScrollView:ctor()
	self.nodeFreed, _ENV, self.listData, _ENV = nil, nil, nil, nil
	self.scrollViewType = gScrollViewType.default
	self.hasMore = true
	self.heightNotice = 40
	self.widthNotice = 50
	self.heightEnableNotice = 55
	self.widthEnableNotice = 55
	self.fromLoadText = false
	self.paddingBottom = 0
	self.paddingTop = 0
	self.paddingLeft = 0
	self.paddingRight = 0
	self.contentOffsetH = 0
	self.contentOffsetW = 0
	self.showScaleBottom = 0.5
	self.showScaleTop = 1.5
	self.showScaleLeft = 0.5
	self.showScaleRight = 1.5
	self.minScrollOffsetX = 10
	self.minScrollOffsetY = 10
	self.nodeWidth = 0
	self.isScrollingToWheelNode = false
	self:setListenAllScrollingEnabled(true)
	self:addEventListener(handler(self, self.scrollEventCallBack))
	self:setInnerContainerSize(self:getContentSize())
	self.scrollSize = self:getContentSize()
	self._unikey = string.format("commonScrollView_%s", tostring(self))
	self.offsetY = nil
	self.offsetX = nil
end
function commonScrollView:init(data)
	self.nodeSizeType = data.nodeSizeType or gScrollViewNodeSizeType.dynamic
	if self.nodeSizeType == gScrollViewNodeSizeType.fixed then
		assert(data.fixedNodeSize, "data.fixedNodeSize must be defined")
		self.fixedNodeSize = data.fixedNodeSize
	end
	self.dragTipType = data.dragTipType or gScrollViewDragTipType.none
	if self.dragTipType ~= gScrollViewDragTipType.none then
		self:checkAndCreateLabelTip()
	end
	self.traverseHandler = data.traverseHandler
	self.createNodeHandler = data.createNodeHandler
	self.requestHandler = data.requestHandler
	self.nodeClass = data.nodeClass
	self.cellSizeFunc = data.cellSizeFunc
	self.updateCellAtIndexFunc = data.updateCellAtIndexFunc
	self.nodeDirection = data.nodeDirection or gScrollViewNodeDirection.top
	self.paddingBottom = data.paddingBottom or 0
	self.paddingTop = data.paddingTop or 0
	self.paddingLeft = data.paddingLeft or 0
	self.paddingRight = data.paddingRight or 0
	self.selIndex = data.selIndex or 1
	self.offsetSelX = self.scrollSize.width / 2
	self.offsetSelY = self.scrollSize.height / 2
	if data.heightNotice then
		self.heightNotice = data.heightNotice
	end
	if data.widthNotice then
		self.widthNotice = data.widthNotice
	end
	if data.scrollViewType then
		self.scrollViewType = data.scrollViewType
		if self.scrollViewType == gScrollViewType.wheel then
			self:addTouchEventListener(handler(self, self.scrollTouchEventCallBack))
			self.selWheelNodeHandler = data.selWheelNodeHandler
		end
	end
	if data.minScrollOffsetY then
		self.minScrollOffsetY = data.minScrollOffsetY
	end
	if data.minScrollOffsetX then
		self.minScrollOffsetX = data.minScrollOffsetX
	end
	if data.showScaleBottom then
		self.showScaleBottom = data.showScaleBottom
	end
	if data.showScaleTop then
		self.showScaleTop = data.showScaleTop
	end
	if data.hasMore ~= nil then
		self.hasMore = data.hasMore
	end
	if data.handler then
		self.updateWheelNodeHandler = data.handler
	end
	if data.maxOffsetY then
		self.maxOffsetY = data.maxOffsetY
	end
	if data.maxScale then
		self.maxScale = data.maxScale
	end
	if data.chilsOffsetX then
		self.chilsOffsetX = data.chilsOffsetX
	end
	if data.nodeWidth then
		self.nodeWidth = data.nodeWidth
	end
	self:refreshList(data.listData)
end
function commonScrollView:setVisbileShowScale(scaleBottom, scaleTop)
	if scaleBottom then
		self.showScaleBottom = scaleBottom
	end
	if scaleTop then
		self.showScaleTop = scaleTop
	end
end
function commonScrollView:setVisibleShowScaleHorizontal(scaleLeft, scaleRight)
	if scaleLeft then
		self.showScaleLeft = scaleLeft
	end
	if scaleRight then
		self.showScaleRight = scaleRight
	end
end
function commonScrollView:setMinScrollOffsetY(minScrollOffsetY)
	self.minScrollOffsetY = minScrollOffsetY
end
function commonScrollView:setMinScrollOffsetX(minScrollOffsetX)
	self.minScrollOffsetX = minScrollOffsetX
end
function commonScrollView:updateOffsetY()
	local scrollInner = self:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	self.offsetY = offsetY
end
function commonScrollView:updateOffsetX()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	self.offsetX = offsetX
end
function commonScrollView:setContentOffsetH(contentOffsetH, bNeedRefresh)
	if not contentOffsetH then
		return
	end
	self.contentOffsetH = contentOffsetH
	if bNeedRefresh then
		self:refreshList(self.listData)
	end
end
function commonScrollView:setPaddingBottom(paddingBottom)
	self.paddingBottom = paddingBottom
end
function commonScrollView:setPaddingTop(paddingTop)
	self.paddingTop = paddingTop
end
function commonScrollView:setPaddingLeft(paddingLeft)
	self.paddingLeft = paddingLeft
end
function commonScrollView:setPaddingRight(paddingRight)
	self.paddingRight = paddingRight
end
function commonScrollView:refreshList(data)
	self.offsetY = nil
	self.offsetX = nil
	self.lastIndex = nil
	self:recycleAll()
	self.listData = data
	if not self.listData or #self.listData == 0 then
		return
	end
	self:updateScrollView()
	print("refreshList ---self.lastIndex = ", self.lastIndex)
end
function commonScrollView:resizeContentSize(newSize)
	local scrollInner = self:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local offsetX = scrollInner:getPositionX()
	self:setContentSize(newSize)
	scrollInner:setPositionY(offsetY)
	scrollInner:setPositionX(offsetX)
end
function commonScrollView:getInnerContainerPosition()
	local scrollInner = self:getInnerContainer()
	return cc.p(scrollInner:getPosition())
end
function commonScrollView:getInnerContainerSize()
	local scrollInner = self:getInnerContainer()
	return scrollInner:getContentSize()
end
function commonScrollView:getScrolledPercentVertical()
	local minY = self:getContentSize().height - self:getInnerContainerSize().height
	return (1.0 - self:getInnerContainerPosition().y / minY) * 100
end
function commonScrollView:getScrolledPercentHorizontal()
	local minX = self:getContentSize().width - self:getInnerContainerSize().width
	return self:getInnerContainerPosition().x / minX * 100
end
function commonScrollView:setScrollMoveFun(handle)
	self.moveHandle = handle
end
function commonScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		if self.moveHandle then
			self.moveHandle()
		end
		if self.nodeDirection == gScrollViewNodeDirection.top or self.nodeDirection == gScrollViewNodeDirection.bottom or self.nodeDirection == gScrollViewNodeDirection.bottom_only then
			self:updateScrollCell()
			local scrollInner = self:getInnerContainer()
			local offsetY = -scrollInner:getPositionY()
			if self.offsetY and math.abs(self.offsetY - offsetY) < self.minScrollOffsetY then
				return
			end
		else
			self:updateScrollCell()
			local scrollInner = self:getInnerContainer()
			local offsetX = -scrollInner:getPositionX()
			if self.offsetX and math.abs(self.offsetX - offsetX) < self.minScrollOffsetX then
				return
			end
		end
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.dragTipType == gScrollViewDragTipType.bottom then
			if self.fromLoadText then
				if self.hasMore then
					self.labelTip:setString(i18n("common_text_089"))
					self:requestMore()
				end
				self.fromLoadText = false
			end
		elseif self.dragTipType == gScrollViewDragTipType.none and self.nodeDirection == gScrollViewNodeDirection.top and self.hasMore then
			self:requestMore()
		end
		self.isBounceBack = true
		print("ccui.ScrollviewEventType.bounceBottom  = ", true)
	elseif event == ccui.ScrollviewEventType.bounceTop then
		if self.dragTipType == gScrollViewDragTipType.top then
			if self.fromLoadText then
				if self.hasMore then
					self.labelTip:setString(i18n("common_text_074"))
					self:requestMore()
				end
				self.fromLoadText = false
			end
		elseif self.dragTipType == gScrollViewDragTipType.none and self.nodeDirection == gScrollViewNodeDirection.bottom and self.hasMore then
			self:requestMore()
		end
		self.isBounceBack = true
		print("ccui.ScrollviewEventType.bounceTop  = ", true)
	elseif event == ccui.ScrollviewEventType.bounceLeft then
		if self.dragTipType == gScrollViewDragTipType.left then
			if self.fromLoadText then
				if self.hasMore then
					self:requestMore()
				end
				self.fromLoadText = false
			end
		elseif self.dragTipType == gScrollViewDragTipType.none and self.nodeDirection == gScrollViewNodeDirection.right and self.hasMore then
			self:requestMore()
		end
		self.isBounceBack = true
		print("self.bounceLeft isBounceBack = ", self.isBounceBack)
	elseif event == ccui.ScrollviewEventType.bounceRight then
		if self.dragTipType == gScrollViewDragTipType.right then
			if self.fromLoadText then
				if self.hasMore then
					self:requestMore()
				end
				self.fromLoadText = false
			end
		elseif self.dragTipType == gScrollViewDragTipType.none and self.nodeDirection == gScrollViewNodeDirection.left and self.hasMore then
			self:requestMore()
		end
		self.isBounceBack = true
		print("self.bounceRight isBounceBack = ", self.isBounceBack)
	elseif event == ccui.ScrollviewEventType.scrollingEnd then
		if self.scrollViewType == gScrollViewType.wheel and not self.isScrollingToWheelNode then
			if self.isBounceBack then
				local percent
				if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
					percent = self:getScrolledPercentHorizontal()
					if percent <= 50 then
						print("---------------滚动到最左边-----")
						self:scrollToLeft(0.2, true)
					else
						print("---------------滚动到最右边-----")
						self:scrollToRight(0.2, true)
					end
				else
					percent = self:getScrolledPercentVertical()
					if percent <= 50 then
						self:scrollToTop(0.2, true)
					else
						self:scrollToBottom(0.2, true)
					end
				end
				self.isBounceBack = false
			elseif self.scrollViewType == gScrollViewType.wheel then
				self:autoSelWheel()
			end
		end
		if not self:isScrolling() and not self:isAutoScrolling() then
			self:traverseNodesOnce()
			self:updateLabelTip()
			self.isScrollingToWheelNode = false
			if self.scrollViewType == gScrollViewType.wheel then
				self.offsetY = nil
				self.offsetX = nil
				print("这是最终停止的时候-----")
				self:updateScrollCell()
			end
		end
		print(" event == ccui.ScrollviewEventType.scrollingEnd", self:isScrolling(), self:isAutoScrolling())
	end
end
function commonScrollView:updateScrollView()
	self:updateScrollSize()
	self:updateScrollCell()
	self:traverseNodesOnce()
end
function commonScrollView:calculateHeight(preCall, postCall)
	local nodeClass = self.nodeClass
	local nodeTmp, measureSizeFunc
	if nodeClass and nodeClass.measureSize then
		measureSizeFunc = nodeClass.measureSize
	elseif self.cellSizeFunc then
		measureSizeFunc = self.cellSizeFunc
	else
		nodeTmp = self.createNodeHandler()
		nodeTmp:addTo(self)
	end
	local accuNodeHeight = self.paddingBottom
	for _, v in ipairs(self.listData) do
		if not ((v.nodeWidth ~= 0 or v.nodeHeight ~= 0) and v.nodeWidth) or not v.nodeHeight then
			local nodeSize
			if measureSizeFunc then
				nodeSize = measureSizeFunc(v)
			else
				if nodeTmp.initData then
					nodeTmp:initData(v)
				elseif nodeTmp.init then
					nodeTmp:init(v)
				end
				nodeSize = cc.size(nodeTmp:getNodeWidth(), nodeTmp:getNodeHeight())
			end
			v.nodeWidth = nodeSize.width
			v.nodeHeight = nodeSize.height
		end
		if preCall then
			preCall(v, accuNodeHeight)
		end
		accuNodeHeight = accuNodeHeight + v.nodeHeight
		if postCall then
			postCall(v, accuNodeHeight)
		end
	end
	if nodeTmp then
		nodeTmp:setVisible(false)
		table.insert(self.nodeFreed, nodeTmp)
	end
	return accuNodeHeight
end
function commonScrollView:calculateWidth(preCall, postCall)
	local nodeClass = self.nodeClass
	local nodeTmp, measureSizeFunc
	if nodeClass and nodeClass.measureSize then
		measureSizeFunc = nodeClass.measureSize
	elseif self.cellSizeFunc then
		measureSizeFunc = self.cellSizeFunc
	else
		nodeTmp = self.createNodeHandler()
		nodeTmp:addTo(self)
	end
	local accuNodeWidth = 0
	accuNodeWidth = accuNodeWidth + self.paddingLeft
	for _, v in ipairs(self.listData) do
		if not ((v.nodeWidth ~= 0 or v.nodeHeight ~= 0) and v.nodeWidth) or not v.nodeHeight then
			local nodeSize
			if measureSizeFunc then
				nodeSize = measureSizeFunc(v)
			else
				if nodeTmp.initData then
					nodeTmp:initData(v)
				elseif nodeTmp.init then
					nodeTmp:init(v)
				end
				nodeSize = cc.size(nodeTmp:getNodeWidth(), nodeTmp:getNodeHeight())
			end
			v.nodeWidth = nodeSize.width
			v.nodeHeight = nodeSize.height
		end
		if preCall then
			preCall(v, accuNodeWidth)
		end
		accuNodeWidth = accuNodeWidth + v.nodeWidth
		if postCall then
			postCall(v, accuNodeWidth)
		end
	end
	if nodeTmp then
		nodeTmp:setVisible(false)
		table.insert(self.nodeFreed, nodeTmp)
	end
	return accuNodeWidth
end
function commonScrollView:updateScrollSize_Top()
	local scrollContentSize = self:getContentSize()
	local accuNodeHeight = self:calculateHeight()
	local sumH = accuNodeHeight + self.contentOffsetH
	local heightNotice = 0
	if self.dragTipType == gScrollViewDragTipType.bottom then
		heightNotice = self.heightNotice
		self.labelTip:setPosition(self.labelTip:getPositionX(), self.paddingBottom)
	end
	sumH = sumH + heightNotice + self.paddingTop
	sumH = math.max(sumH, scrollContentSize.height)
	local accuH = sumH - self.contentOffsetH - self.paddingTop
	for _, v in ipairs(self.listData) do
		accuH = accuH - v.nodeHeight
		print("accuH - v.nodeHeight", accuH, v.nodeHeight)
		v.nodePosY = accuH
		if v.node then
			v.node:setPositionY(v.nodePosY)
		end
	end
	local scrollInner = self:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	offsetY = offsetY - (sumH - scrollInner:getContentSize().height)
	self:setInnerContainerSize(cc.size(self.scrollSize.width, sumH))
	scrollInner:setPositionY(offsetY)
end
function commonScrollView:updateScrollSize_Bottom()
	if not self.chPreCall then
		function self.chPreCall(data, curAccuH)
			data.nodePosY = curAccuH
			if data.node then
				data.node:setPositionY(data.nodePosY)
			end
		end
	end
	local accuNodeHeight = self:calculateHeight(self.chPreCall)
	local scrollInner = self:getInnerContainer()
	local scrollContentSize = self:getContentSize()
	local offsetY = scrollInner:getPositionY()
	local heightNotice = 0
	if self.dragTipType == gScrollViewDragTipType.top then
		heightNotice = self.heightNotice
		self.labelTip:setPosition(self.labelTip:getPositionX(), accuNodeHeight)
	end
	local sumH = accuNodeHeight + heightNotice + self.paddingTop
	if sumH < scrollContentSize.height then
		if self.nodeDirection == gScrollViewNodeDirection.bottom then
			local deltaY = scrollContentSize.height - sumH
			for _, v in ipairs(self.listData) do
				v.nodePosY = v.nodePosY + deltaY
				if v.node and not tolua.isnull(v.node) then
					v.node:setPositionY(v.nodePosY)
				end
			end
			if self.dragTipType == gScrollViewDragTipType.top then
				self.labelTip:setPositionY(self.labelTip:getPositionY() + deltaY)
			end
		end
		sumH = scrollContentSize.height
	end
	self:setInnerContainerSize(cc.size(self.scrollSize.width, sumH))
	scrollInner:setPositionY(offsetY)
	dump(self.listData, "commonScrollView:updateScrollSize_Bottom()", 10)
end
function commonScrollView:updateScrollSize_left()
	if not self.cwPreCall then
		function self.cwPreCall(data, curAccuW)
			data.nodePosX = curAccuW
			if data.node then
				data.node:setPositionX(data.nodePosX)
			end
		end
	end
	local accuNodeWidth = self:calculateWidth(self.cwPreCall)
	local scrollInner = self:getInnerContainer()
	local scrollContentSize = self:getContentSize()
	local offsetX = scrollInner:getPositionX()
	local widthNotice = 0
	if self.dragTipType == gScrollViewDragTipType.right then
		widthNotice = self.widthNotice
		self.labelTip:setPosition(accuNodeWidth + widthNotice / 2, self.labelTip:getPositionY())
	end
	local sumW = accuNodeWidth + widthNotice + self.paddingRight
	if sumW < scrollContentSize.width then
		if self.nodeDirection == gScrollViewNodeDirection.left then
			local deltaX = scrollContentSize.width - sumW
			for _, v in ipairs(self.listData) do
				v.nodePosX = v.nodePosX + deltaX
				if v.node and not tolua.isnull(v.node) then
					v.node:setPositionX(v.nodePosX)
				end
			end
			if self.dragTipType == gScrollViewDragTipType.left then
				self.labelTip:setPositionX(self.labelTip:getPositionX() + deltaX)
			end
		end
		sumW = scrollContentSize.height
	end
	self:setInnerContainerSize(cc.size(sumW, self.scrollSize.height))
	scrollInner:setPositionX(offsetX)
end
function commonScrollView:updateScrollSize_right()
	local scrollContentSize = self:getContentSize()
	local accuNodeWidth = self:calculateWidth()
	local sumW = accuNodeWidth + self.contentOffsetH
	local widthNotice = 0
	if self.dragTipType == gScrollViewDragTipType.left then
		widthNotice = self.widthNotice
		self.labelTip:setPosition(self.paddingLeft + widthNotice / 2, self.labelTip:getPositionY())
	end
	sumW = sumW + widthNotice + self.paddingRight
	sumW = math.max(sumW, scrollContentSize.height)
	local accuW = sumW - self.contentOffsetW - self.paddingRight
	for _, v in ipairs(self.listData) do
		accuW = accuW - v.nodeWidth
		v.nodePosX = accuW
		if v.node then
			v.node:setPositionX(v.nodePosX)
		end
	end
	local scrollInner = self:getInnerContainer()
	local offsetX = scrollInner:getPositionX()
	offsetX = offsetX - (sumW - scrollInner:getContentSize().width)
	self:setInnerContainerSize(cc.size(sumW, self.scrollSize.height))
	scrollInner:setPositionX(offsetX)
end
function commonScrollView:updateScrollSize()
	self.offsetY = nil
	self.offsetX = nil
	if self.nodeDirection == gScrollViewNodeDirection.top then
		self:updateScrollSize_Top()
	elseif self.nodeDirection == gScrollViewNodeDirection.bottom or self.nodeDirection == gScrollViewNodeDirection.bottom_only then
		self:updateScrollSize_Bottom()
	elseif self.nodeDirection == gScrollViewNodeDirection.left then
		self:updateScrollSize_left()
	elseif self.nodeDirection == gScrollViewNodeDirection.right then
		self:updateScrollSize_right()
	end
end
function commonScrollView:updateScrollCell()
	if self.nodeDirection == gScrollViewNodeDirection.top or self.nodeDirection == gScrollViewNodeDirection.bottom or self.nodeDirection == gScrollViewNodeDirection.bottom_only then
		self:updateScrollCellH()
	elseif self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
		self:updateScrollCellW()
	end
	if self.scrollViewType == gScrollViewType.wheel then
		self:updateWheelNodes()
	end
end
function commonScrollView:updateScrollCellH()
	local scrollInner = self:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self:getContentSize().height
	_ENV = self
	self.beginY = math.max(0, offsetY - self.showScaleBottom * scrollH)
	local self.endY, tableShowH = offsetY + self.showScaleTop * scrollH, self
	for _, v in ipairs(self.listData) do
		if v.node then
			if v.nodePosY + v.nodeHeight < tableShowH.beginY or v.nodePosY > tableShowH.endY then
				v.node:setVisible(false)
				table.insert(self.nodeFreed, v.node)
				v.node = nil
			end
		else
			if v.nodePosY + v.nodeHeight >= tableShowH.beginY and v.nodePosY <= tableShowH.endY then
				local node = table.remove(self.nodeFreed)
				if not node then
					node = self.createNodeHandler(v)
					node:addTo(self)
				end
				node:setVisible(true)
				v.node = node
				if self.updateCellAtIndexFunc then
					self.updateCellAtIndexFunc(node, v)
				elseif v.node.initData then
					v.node:initData(v)
				elseif v.node.init then
					v.node:init(v)
				end
				v.node:setPosition(self.chilsOffsetX or 0, v.nodePosY)
			else
			end
		end
	end
	if self.dragTipType == gScrollViewDragTipType.top then
		if offsetY > scrollInner:getContentSize().height - self:getContentSize().height + self.heightEnableNotice then
			self.fromLoadText = true
			if self.hasMore then
				self.labelTip:setString(i18n("common_text_084"))
			end
		end
	elseif self.dragTipType == gScrollViewDragTipType.bottom and offsetY < -self.heightEnableNotice then
		self.fromLoadText = true
		if self.hasMore then
			self.labelTip:setString(i18n("common_text_084"))
		end
	end
	self:updateOffsetY()
end
function commonScrollView:updateScrollCellW()
	local scrollInner = self:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local scrollW = self:getContentSize().width
	_ENV = self
	self.beginX = math.max(0, offsetX - self.showScaleLeft * scrollW)
	local self.endX, tableShowW = offsetX + self.showScaleRight * scrollW, self
	for _, v in ipairs(self.listData) do
		if v.node then
			if v.nodePosX + v.nodeWidth < tableShowW.beginX or v.nodePosX > tableShowW.endX then
				v.node:setVisible(false)
				table.insert(self.nodeFreed, v.node)
				v.node = nil
			end
		else
			if v.nodePosX + v.nodeWidth >= tableShowW.beginX and v.nodePosX <= tableShowW.endX then
				local node = table.remove(self.nodeFreed)
				if not node then
					node = self.createNodeHandler(v)
					node:addTo(self)
				end
				node:setVisible(true)
				v.node = node
				if v.node.initData then
					v.node:initData(v)
				elseif v.node.init then
					v.node:init(v)
				end
				v.node:setPosition(v.nodePosX, 0)
			else
			end
		end
	end
	if self.dragTipType == gScrollViewDragTipType.right then
		if offsetX > scrollInner:getContentSize().width - self:getContentSize().width + self.widthEnableNotice then
			self.fromLoadText = true
			if self.hasMore then
				self.labelTip:setString(i18n("common_text_084"))
			end
		end
	elseif self.dragTipType == gScrollViewDragTipType.left and offsetX < -self.widthEnableNotice then
		self.fromLoadText = true
		if self.hasMore then
			self.labelTip:setString(i18n("common_text_084"))
		end
	end
	self:updateOffsetX()
end
function commonScrollView:requestMore()
	if self.requestHandler then
		self.requestHandler()
	end
end
function commonScrollView:recycleAll()
	for _, v in ipairs(self.listData) do
		if v.node then
			v.node:setVisible(false)
			table.insert(self.nodeFreed, v.node)
			v.node = nil
		end
	end
	self.tableSingle, _ENV = ipairs(self.listData)
end
function commonScrollView:setTraverseHandler(traverseHandler)
	self.traverseHandler = traverseHandler
end
function commonScrollView:traverseNodesOnce()
	if not self.traverseHandler then
		return
	end
	if not self.traverseNodesHandler then
		self.traverseNodesHandler = handler(self, self.traverseNodes)
	end
	self.traverseHandle = SoraDDelayCallOnce(self._unikey, self.traverseNodesHandler, 0.3)
end
function commonScrollView:traverseNodes()
	if self.traverseHandler then
		self.traverseHandler(self.listData)
	end
end
function commonScrollView:checkAndCreateLabelTip()
	if not self.labelTip then
		local labelTip = ccui.Text:create()
		labelTip:setFontSize(20)
		labelTip:setColor(cc.c3b(242, 205, 70))
		labelTip:addTo(self)
		self.labelTip = labelTip
		labelTip:setAnchorPoint(cc.p(0.5, 0))
		if self.dragTipType == gScrollViewDragTipType.bottom then
			self.labelTip:setString(i18n("common_text_089"))
		elseif self.dragTipType == gScrollViewDragTipType.top then
			self.labelTip:setString(i18n("common_text_074"))
		end
		self.labelTip:setPositionX(self:getContentSize().width / 2)
	end
end
function commonScrollView:getLabelTip()
	return self.labelTip
end
function commonScrollView:navigateToIndex(index, offset, nodeOffset)
	offset = offset or 0
	nodeOffset = nodeOffset or 0
	if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
		self.offsetX = nil
		local itemData = self.listData[index]
		if not itemData then
			return
		end
		local scrollInner = self:getInnerContainer()
		local scrollInnerW = scrollInner:getContentSize().width
		local scrollW = self:getContentSize().width
		local posCellX = itemData.nodePosX + offset + nodeOffset
		posCellX = posCellX - scrollW
		local percent = posCellX / (scrollInnerW - scrollW)
		print("...", posCellX, scrollInnerW - scrollW)
		percent = math.min(100, math.max(0, percent * 100))
		self:stopAutoScroll()
		self:scrollToPercentHorizontal(percent, 0.2, true)
	else
		self.offsetY = nil
		local itemData = self.listData[index]
		if not itemData then
			return
		end
		local scrollInner = self:getInnerContainer()
		local scrollInnerHeight = scrollInner:getContentSize().height
		local scrollH = self:getContentSize().height
		local posCellY = itemData.nodePosY + offset + nodeOffset
		local percent = (scrollInnerHeight - posCellY) / (scrollInnerHeight - scrollH)
		percent = math.min(100, math.max(0, percent * 100))
		self:stopAutoScroll()
		self:scrollToPercentVertical(percent, 0.2, true)
	end
end
function commonScrollView:setHasMore(hasMore)
	self.hasMore = hasMore
	self:updateLabelTip()
end
function commonScrollView:updateLabelTip()
	if self.dragTipType == gScrollViewDragTipType.none then
		return
	end
	if self.hasMore then
		if #self.listData == 0 then
			if self.labelTip then
				self.labelTip:setString("")
			end
			return
		end
		if self.dragTipType == gScrollViewDragTipType.bottom then
			self.labelTip:setString(i18n("common_text_089"))
		elseif self.dragTipType == gScrollViewDragTipType.top then
			self.labelTip:setString(i18n("common_text_074"))
		elseif self.dragTipType == gScrollViewDragTipType.left then
		elseif self.dragTipType == gScrollViewDragTipType.right then
		end
	else
		self.labelTip:setString(i18n("common_text_085"))
	end
end
function commonScrollView:updateWheelNodes()
	for _, v in ipairs(self.listData) do
		if v.node then
			if self.updateWheelNodeHandler then
				self.updateWheelNodeHandler(v.node)
			else
				self:updateWheelNodeDefault(v.node)
			end
		end
	end
end
function commonScrollView:updateWheelNodeDefault(node)
	local scale = 1.0
	local opacity
	local minScale = 0.5
	local maxScale = self.maxScale or 1
	local sepScale = 0.65
	local minOpacity = 51.0
	local maxOpacity = 255
	local sepOpacityScale = 0.8
	local sepOpacity = sepOpacityScale * 255
	local scrollInner = self:getInnerContainer()
	local maxOffsetY = self.maxOffsetY or 0
	local maxOffsetX = 0
	if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
		local posX = node:getPositionX() + node:getNodeWidth() / 2
		local offsetX = scrollInner:getPositionX()
		local halfW = self.scrollSize.width / 2
		local centerX = halfW - offsetX
		local deltaX = math.min(halfW, math.abs(centerX - posX))
		local alpha = math.min(maxScale, math.max(0, 1.0 - deltaX / halfW))
		scale = SoraDLerpNumber(minScale, maxScale, alpha)
		local deltaOffsetY = SoraDLerpNumber(0, -maxOffsetY, 1.0 - alpha)
		if node.setContentOffset then
			node:setContentOffset(nil, deltaOffsetY)
		end
	else
		local posY = node:getPositionY() + node:getNodeHeight() / 2
		local offsetY = scrollInner:getPositionY()
		local halfH = self.scrollSize.height / 2
		local centerY = halfH - offsetY
		local deltaY = math.min(halfH, math.abs(centerY - posY))
		local alpha = math.min(maxScale, math.max(0, 1.0 - deltaY / halfH))
		scale = SoraDLerpNumber(minScale, maxScale, alpha)
		local deltaOffsetX = SoraDLerpNumber(0, maxOffsetX, 1.0 - alpha)
		if node.setContentOffset then
			node:setContentOffset(deltaOffsetX, nil)
		end
	end
	if node.setContentScale then
		node:setContentScale(scale)
	end
	if node.setContentOpacity then
		if sepScale >= scale then
			local alpha = (scale - minScale) / (sepScale - minScale)
			opacity = SoraDLerpNumber(minOpacity, sepOpacity, alpha)
		else
			local alpha = (scale - sepScale) / (maxScale - sepScale)
			opacity = SoraDLerpNumber(sepOpacity, maxOpacity, alpha)
		end
		node:setContentOpacity(opacity)
	end
end
function commonScrollView:scrollToWheelIndex(index, notTriggerEvent, delay)
	local itemData
	self.isScrollingToWheelNode = true
	if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
		local offsetX = self.offsetSelX
		itemData = self.listData[index]
		if not itemData then
			return
		end
		local nodeOffset = itemData.nodeWidth / 2
		if delay then
			_UPVALUE1_ = nil
			;(nil)[1] = cca.delay(0.0)
			;(nil)[2] = cca.callFunc(function()
				self:navigateToIndex(index, offsetX, nodeOffset)
			end)
			;(nil)[3] = cca.callFunc(function()
				self:navigateToIndex(index, offsetX, nodeOffset)
			end)
			self:runAction(cca.seq(nil))
		else
			self:navigateToIndex(index, offsetX, nodeOffset)
		end
	else
		local offsetY = self.offsetSelY
		itemData = self.listData[index]
		if not itemData then
			return
		end
		local nodeOffset = itemData.nodeHeight / 2
		if delay then
			_UPVALUE1_ = offsetX
			offsetX[1] = cca.delay(0.0)
			offsetX[2] = cca.callFunc(function()
				self:navigateToIndex(index, offsetY, nodeOffset)
			end)
			offsetX[3] = cca.callFunc(function()
				self:navigateToIndex(index, offsetY, nodeOffset)
			end)
			self:runAction(cca.seq(offsetX))
		else
			self:navigateToIndex(index, offsetX, nodeOffset)
		end
	end
	if self.lastIndex == index then
		print("选中的是同一个节点，直接返回咯", self.lastIndex, index)
		return
	end
	if not notTriggerEvent and self.selWheelNodeHandler then
		self.selWheelNodeHandler(index, itemData)
	end
	self.lastIndex = index
	self:disableMoveForDuration(0.3)
end
function commonScrollView:getNearestIndex()
	local scrollInner = self:getInnerContainer()
	if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
		local offsetSelX = self.offsetSelX
		local offsetX = scrollInner:getPositionX()
		local nearX = math.abs(offsetX) + offsetSelX
		local index = 1
		local deltaX, minDeltaX
		for i, v in ipairs(self.listData) do
			if v.node then
				local posX = v.nodePosX + v.nodeWidth / 2
				deltaX = math.abs(posX - nearX)
				if not minDeltaX or minDeltaX > deltaX then
					minDeltaX = deltaX
					index = i
				end
			end
		end
		return index
	else
		local offsetSelY = self.offsetSelY
		local offsetY = scrollInner:getPositionY()
		local nearY = math.abs(offsetY) + offsetSelY
		local index = 1
		local deltaY, minDeltaY
		for i, v in ipairs(self.listData) do
			if v.node then
				local posY = v.nodePosY + v.nodeHeight / 2
				deltaY = math.abs(posY - nearY)
				if not minDeltaY or minDeltaY > deltaY then
					minDeltaY = deltaY
					index = i
				end
			end
		end
		return index
	end
end
function commonScrollView:autoSelWheel()
	local nearIndex = self:getNearestIndex()
	self:scrollToWheelIndex(nearIndex)
end
function commonScrollView:scrollTouchEventCallBack(target, type)
	if type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.nodeDirection == gScrollViewNodeDirection.left or self.nodeDirection == gScrollViewNodeDirection.right then
			local scrollInner = self:getInnerContainer()
			local offsetX = -scrollInner:getPositionX()
			local centerX = offsetX + self.scrollSize.width / 2
			local nodeWidth = self.listData and self.listData[1] and self.listData[1].nodeWidth or self.nodeWidth
			self.selIndex = self:getNearestIndex()
			local touchNodePos = scrollInner:convertToNodeSpace(target:getTouchBeganPosition())
			if touchNodePos.x <= centerX - 0.5 * nodeWidth then
				if self.nodeDirection == gScrollViewNodeDirection.left then
					if 1 < self.selIndex then
						self.selIndex = self.selIndex - 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					end
				elseif self.nodeDirection == gScrollViewNodeDirection.right and self.selIndex < #self.listData then
					self.selIndex = self.selIndex + 1
					self:scrollToWheelIndex(self.selIndex, false, true)
				end
			elseif touchNodePos.x >= centerX + 0.5 * nodeWidth then
				if self.nodeDirection == gScrollViewNodeDirection.right then
					if 1 < self.selIndex then
						self.selIndex = self.selIndex - 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					end
				else
					if self.nodeDirection == gScrollViewNodeDirection.left and self.selIndex < #self.listData then
						self.selIndex = self.selIndex + 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					else
					end
				end
			end
		else
			local scrollInner = self:getInnerContainer()
			local offsetY = -scrollInner:getPositionY()
			local centerY = offsetY + self.scrollSize.height / 2
			local nodeHeight = self.listData[1].nodeHeight
			self.selIndex = self:getNearestIndex()
			local touchNodePos = scrollInner:convertToNodeSpace(target:getTouchBeganPosition())
			if touchNodePos.y <= centerY - 0.5 * nodeHeight then
				if self.nodeDirection == gScrollViewNodeDirection.bottom then
					if 1 < self.selIndex then
						self.selIndex = self.selIndex - 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					end
				elseif self.nodeDirection == gScrollViewNodeDirection.top and self.selIndex < #self.listData then
					self.selIndex = self.selIndex + 1
					self:scrollToWheelIndex(self.selIndex, false, true)
				end
			elseif touchNodePos.y >= centerY + 0.5 * nodeHeight then
				if self.nodeDirection == gScrollViewNodeDirection.top then
					if 1 < self.selIndex then
						self.selIndex = self.selIndex - 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					end
				else
					if self.nodeDirection == gScrollViewNodeDirection.bottom and self.selIndex < #self.listData then
						self.selIndex = self.selIndex + 1
						self:scrollToWheelIndex(self.selIndex, false, true)
					else
					end
				end
			end
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
	elseif type == ccui.TouchEventType.began then
	end
end
function commonScrollView:disableMoveForDuration(duration)
	print("禁用触摸 11111")
	self:setTouchEnabled(false)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(duration)
	;(nil)[2] = cca.callFunc(function()
		self:setTouchEnabled(true)
		print("启用触摸 22222")
		if not self:isAutoScrolling() then
			self.isScrollingToWheelNode = false
		end
	end)
	;(nil)[3] = cca.callFunc(function()
		self:setTouchEnabled(true)
		print("启用触摸 22222")
		if not self:isAutoScrolling() then
			self.isScrollingToWheelNode = false
		end
	end)
	self:runAction(cca.seq(nil))
end
return commonScrollView
