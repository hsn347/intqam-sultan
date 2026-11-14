local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailScrollView = class("mailScrollView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailScrollView"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailScrollView:ctor()
	self.timeCount = 1
	self.timeDelta = 6
	self.nextIndex = 1
	self.topPadding = 0
	self.paddingXLoadingSprite = 25
	self.heightNotice = 52
	self.heightEnableNotice = 55
	self.cellHeight = 132
	self.heightTopAutoScroll = 100
	self.isRequesting = true
	self.hasMore = false
	self.mailSetType = 0
	self.itemsData, _ENV, self.recycledList, _ENV, self.mailSetKey = nil, nil, nil, nil, "key"
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setPosition(self.labelNotice:getPositionX(), 13)
	self.labelNotice:setVisible(false)
	self.loadingSprite = display.newSprite("SinglePicture/loading1.png")
	self.loadingSprite:setScale(25 / self.loadingSprite:getContentSize().width)
	self.loadingSprite:setAnchorPoint(cc.p(0.5, 0.5))
	self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	self.loadingSprite:setVisible(false)
	self.scrollView:addChild(self.loadingSprite, 1, "loadingSprite")
	self.timeHandler = SoradCreateTimer(self, handler(self, self.turnJumpRedPointBy6Second))
end
function mailScrollView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS", handler(self, self.updateRedIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_GET_EXTRA_SUCCESS", handler(self, self.updateExtraIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_MAIL_TYPE_LIST_BACK", handler(self, self.refreshScrollData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_DEL_SUCCESS", handler(self, self.reloadScrollData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_NEW_MAIL", handler(self, self.refreshViewByNewMail))
end
function mailScrollView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local totalHeight = 0
	local accumulateHeight = 0
	for i, v in ipairs(self.itemsData) do
		totalHeight = totalHeight + v.itemHeight
	end
	local scrollInnerHeight = math.max(self.heightNotice + totalHeight, self.scrollView:getContentSize().height)
	for i, v in ipairs(self.itemsData) do
		v.itemPosX = 0
		accumulateHeight = accumulateHeight + v.itemHeight
		v.itemPosY = scrollInnerHeight - accumulateHeight - 5
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	local offsetY = scrollInner:getPositionY()
	local minOffsetY = -(scrollInner:getContentSize().height - self.scrollView:getContentSize().height)
	local scrollInnerNewH = scrollInnerHeight + self.topPadding
	local offsetYNew = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scrollView:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, scrollInnerNewH))
	scrollInner:setPositionY(offsetYNew)
	if self:isCanLookFirstMail(offsetY, minOffsetY) then
		self.scrollView:scrollToTop(0, false)
	end
end
function mailScrollView:updateScrollCell()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 1.5 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollView
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.itemPosY < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				if v.isSeperator then
					self:addToRecycledGroupList(v.itemNode)
					v.itemNode = nil
				else
					self:addToRecycledList(v.itemNode)
					v.itemNode = nil
				end
			elseif self.isUpdateRedIcon then
				v.itemNode:updateMailRedNum()
			elseif self.isUpdateExtra then
				v.itemNode:updateAttach()
			end
		elseif tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			local itemNode, isFromRecycle = self:getItem(v)
			v.itemNode = itemNode
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			if isFromRecycle == false then
				v.itemNode:addTo(self.scrollView)
			end
		end
	end
end
function mailScrollView:updateScrollView()
	print("mailScrollView:updateScrollView", self.mailSetType)
	for i, v in ipairs(self.itemsData) do
		if not v.itemWidth and not v.itemHeight then
			v.itemWidth = 640
			v.itemHeight = self.cellHeight
		end
	end
	self:updateMailSetStatus()
	self:updateScrollSize()
	self:updateScrollCell()
	self:immediateJumpPoint()
	self.isRequesting = false
end
function mailScrollView:updateRedIcon()
	SoraDCloseLoading()
	self.isUpdateRedIcon = true
	self:updateScrollCell()
	self.isUpdateRedIcon = false
end
function mailScrollView:updateExtraIcon()
	SoraDCloseLoading()
	self.isUpdateExtra = true
	self:updateScrollCell()
	self.isUpdateExtra = false
end
function mailScrollView:refreshViewByNewMail(target, data)
