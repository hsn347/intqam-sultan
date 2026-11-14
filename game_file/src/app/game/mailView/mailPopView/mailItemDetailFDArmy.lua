local mailItemDetailFDArmy = class("mailItemDetailFDArmy", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemDetailFDArmy"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemDetailFDArmy:ctor()
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.top_bar = SoraDGetChildByName(self, "top_bar")
	self.top_bar:setTouchEnabled(true)
	self.top_bar:setSwallowTouches(false)
	self.top_bar:addTouchEventListener(handler(self, self.onBtnTop))
	self.top_bar.isLayout = true
	self.bar_bg = SoraDGetChildByName(self, "bar_bg")
	self.imgMine = SoraDGetChildByName(self, "Image_Mine")
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.topHeight = self.top_bar:getContentSize().height
	self.bottomHeight = 0
	self.iconArrow = display.newSprite("#frame_main_integration_arrow.png")
	self.iconArrow:setFlippedY(true)
	self.iconArrow:setPosition(SoraDFPoint(580, 25, 600))
	self.iconArrow:addTo(self.top_bar)
	self.collapseOffsetY = 0
end
function mailItemDetailFDArmy:initWithData(data)
	self.isContentShow = true
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	local strTitle = data.strTitle
	local isAttack = data.isAttack
	local customNode = data.customNode
	local isShowMineIcon = data.isShowMineIcon
	local isEnableCollapse = data.isEnableCollapse
	self.isEnableCollapse = isEnableCollapse
	self.onSizeChanged = data.onSizeChanged
	self.imgMine:setVisible(isShowMineIcon)
	if customNode == nil then
		customNode = ccui.Layout:create()
		customNode:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		customNode:setBackGroundColor(cc.c3b(182, 27, 27))
		customNode:setContentSize(cc.size(0, 0))
	end
	self.iconArrow:setVisible(isEnableCollapse)
	self.text_title:setString(strTitle)
	self.imgMine:setPositionX(SoraDFPosX(gMailDetaiViewWidth / 2 + self.text_title:getContentSize().width / 2 + 20, gMailDetaiViewWidth))
	local nodeWidth, nodeHeight
	if customNode.getItemWidth then
		nodeWidth = customNode:getItemWidth()
	else
		nodeWidth = customNode:getContentSize().width
	end
	if customNode.getItemHeight then
		nodeHeight = customNode:getItemHeight()
	else
		nodeHeight = customNode:getContentSize().height
	end
	self.layout_content:addChild(customNode)
	local totalHeight = self.topHeight + self.bottomHeight
	self.layout_content:setLayoutType(ccui.LayoutType.VERTICAL)
	totalHeight = totalHeight + nodeHeight
	self.customNode = customNode
	self.customNodeSize = cc.size(nodeWidth, nodeHeight)
	self.itemHeight = totalHeight
	print("mailItemDetailFDArmy", self.itemHeight, self.topHeight, self.bottomHeight, nodeHeight)
	self.layout_content:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	ccui.Helper:doLayout(self.layout_content)
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemDetailFDArmy:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFDArmy:getItemHeight()
	return self.itemHeight
end
function mailItemDetailFDArmy:onBtnTop(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.isEnableCollapse then
			if self.isContentShow then
				self.iconArrow:setFlippedY(false)
				self:hideContent()
			else
				self.iconArrow:setFlippedY(true)
				self:showContent()
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	else
		self.singleIsMoved = false
	end
end
function mailItemDetailFDArmy:showContent()
	self.isContentShow = true
	if self.collapseOffsetY == 0 then
		if self.isShowFrame == true then
			self.content_frame:setVisible(true)
		end
		self.customNode:setVisible(true)
	else
		self.customNode:setContentSize(cc.size(self.customNodeSize.width, self.customNodeSize.height))
	end
	self.itemHeight = self.layout_content:getContentSize().height
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.layout_content:setPositionY(1)
	print("mailItemDetailFDArmy2", self.itemHeight, self.topHeight, self.bottomHeight, self.customNodeSize.height)
	if self.onSizeChanged then
		self.onSizeChanged(self, self.itemHeight)
	end
end
function mailItemDetailFDArmy:hideContent(noSendMessage)
	self.isContentShow = false
	if self.collapseOffsetY == 0 then
		self.customNode:setVisible(false)
		self.itemHeight = 0
	else
		self.customNode:setClippingEnabled(true)
		self.customNode:setContentSize(cc.size(self.customNodeSize.width, self.collapseOffsetY))
		self.itemHeight = 80
	end
	local oldHeight = self:getContentSize().height
	self.itemHeight = self.itemHeight + self.topHeight + self.collapseOffsetY
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
	self.layout_content:setPositionY(-self.customNodeSize.height + 1)
	local deltaY = self.itemHeight - oldHeight
	if not noSendMessage and self.onSizeChanged then
		self.onSizeChanged(self, self.itemHeight)
	end
end
return mailItemDetailFDArmy
