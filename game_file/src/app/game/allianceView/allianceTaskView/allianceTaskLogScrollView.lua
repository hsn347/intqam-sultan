local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceTaskLogScrollView = class("allianceTaskLogScrollView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskLogScrollView")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskLogScrollView:ctor()
	self.ScrollView_Log = SoraDGetChildByName(self, "Size_ScrollView_Log")
	self.Text_notice = SoraDGetChildByName(self, "Text_notice")
	self.Button_closeLog = SoraDGetChildByName(self, "Button_closeLog")
	self.frame_square_28_1 = SoraDGetChildByName(self, "frame_square_28_1")
	self.frame_square_28_2 = SoraDGetChildByName(self, "frame_square_28_2")
	self.btn_arrow_06_3 = SoraDGetChildByName(self, "btn_arrow_06_3")
	self.Button_closeLog:addTouchEventListener(handler(self, self.onClick_Button_closeLog))
	self.Button_closeLog:setTouchEnabled(true)
	self.tableSpare, _ENV, self.itemsData, _ENV = self.Button_closeLog.setTouchEnabled, self.Button_closeLog.setTouchEnabled, self.Button_closeLog.setTouchEnabled, self.Button_closeLog.setTouchEnabled
	self.scrollView = self.ScrollView_Log
	self.labelNotice = self.Text_notice
	self.labelNotice:setString(i18n("common_text_089"))
	self.loadingSprite = display.newSprite("SinglePicture/loading1.png")
	self.labelNotice:getParent():addChild(self.loadingSprite, 1, "loadingSprite")
	self.paddingXLoadingSprite = 25
	self.loadingSprite:setScale(25 / self.loadingSprite:getContentSize().width)
	self.loadingSprite:setAnchorPoint(cc.p(0.5, 0.5))
	self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
	self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	self.labelNotice:setVisible(false)
	self.loadingSprite:setVisible(false)
	self.heightNotice = 52
	self.fromLoadText = false
	self.recycledList, _ENV, self.heightTopAutoScroll = self.loadingSprite.setVisible, self.loadingSprite.setVisible, 100
	self.heightEnableNotice = 55
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
end
function allianceTaskLogScrollView:getLoadingSpriteXPos()
	if SoraDFIsRA() then
		return self.labelNotice:getPositionX() + (self.labelNotice:getContentSize().width / 2 + self.paddingXLoadingSprite)
	else
		return self.labelNotice:getPositionX() - (self.labelNotice:getContentSize().width / 2 + self.paddingXLoadingSprite)
	end
end
function allianceTaskLogScrollView:init(data)
	self:recycleAllNodes()
	self.itemsData = self:getLogDatas()
	self:updateScrollView()
	self.labelNotice:setVisible(true)
	self.labelNotice:setString(i18n("common_text_089"))
end
function allianceTaskLogScrollView:getLogDatas()
	local playerMobilizationCtrl, ret
	local logs = playerMobilizationCtrl:getOperateLog()
	if logs then
		for i, v in ipairs(logs) do
			playerMobilizationCtrl = nil
			;(nil).logData = v
			table.insert(ret, nil)
		end
	end
	return ret
end
function allianceTaskLogScrollView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UPDATE_TASK_LOG", handler(self, self.msgUpdateTaskLog))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_NOMORE_TASK_LOG", handler(self, self.msgNoMoreTaskLog))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_NEW_TASK_LOG", handler(self, self.msgNewTaskLog))
end
function allianceTaskLogScrollView:onClick_Button_closeLog(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("发送消息------")
		_ENV = "发送消息------"
		;("发送消息------").msg = "MESSAGE_ALLIANCE_HIDE_LOGS"
		SoraDSendMessage("发送消息------")
	end
end
function allianceTaskLogScrollView:createItem(data)
	local allianceTaskLogItem = include("allianceTaskLogItem")
	local logItemNode = allianceTaskLogItem.new()
	logItemNode:init(data)
	logItemNode:setScroll(self.scrollView)
	return logItemNode
end
function allianceTaskLogScrollView:addToRecycledList(cell)
	cell:setVisible(false)
	table.insert(self.recycledList, cell)
end
function allianceTaskLogScrollView:hasAnyRecycledCell()
	local result = false
	if #self.recycledList > 0 then
		result = true
		return result
	end
	return result
end
function allianceTaskLogScrollView:pickCellFromRecycledList()
	local cell
	if #self.recycledList > 0 then
		cell = table.remove(self.recycledList)
		cell:setVisible(true)
	end
	return cell
end
function allianceTaskLogScrollView:getItem(data)
	local cell
	local isFromRecycle = false
	if self:hasAnyRecycledCell() == true then
		cell = self:pickCellFromRecycledList()
		cell:init(data)
		isFromRecycle = true
	else
		cell = self:createItem(data)
	end
	return cell, isFromRecycle
end
function allianceTaskLogScrollView:updateHasMore()
end
function allianceTaskLogScrollView:showLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:setVisible(true)
		self.loadingSprite:stopAllActions()
		local actionRotateBy = cc.RotateBy:create(1.0, 360)
		local repeatForever = cca.repeatForever(actionRotateBy)
		self.loadingSprite:runAction(repeatForever)
	end
end
function allianceTaskLogScrollView:hideLoadingSprite()
	self.loadingSprite:stopAllActions()
	self.loadingSprite:setVisible(false)
end
function allianceTaskLogScrollView:updateScrollView()
	local allianceTaskLogItem = include("allianceTaskLogItem")
	local logItemNdoe = allianceTaskLogItem.new()
	logItemNdoe:retain()
	for i, v in ipairs(self.itemsData) do
		if (v.itemWidth == 0 or v.itemWidth == nil) and (v.itemHeight == 0 or v.itemHeight == nil) then
			logItemNdoe:init(v)
			v.itemWidth = logItemNdoe:getItemWidth()
			v.itemHeight = logItemNdoe:getItemHeight()
		else
		end
	end
	logItemNdoe:release()
	self:updateScrollSize()
	self:updateScrollCell()
end
function allianceTaskLogScrollView:updateScrollCell()
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
		elseif tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			local itemNode, isFromRecycle = self:getItem(v)
			v.itemNode = itemNode
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
			if isFromRecycle == false then
				v.itemNode:addTo(self.scrollView)
			end
		end
	end
	if offsetY < -self.heightEnableNotice then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	end
end
function allianceTaskLogScrollView:updateScrollSize()
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
		v.itemPosX = 20
		accumulateHeight = accumulateHeight + v.itemHeight
		v.itemPosY = scrollInnerHeight - accumulateHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	self.labelNotice:setPosition(self.labelNotice:getPositionX(), 13)
	self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
	self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
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
function allianceTaskLogScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.fromLoadText then
			self.fromLoadText = false
			self:requestMore()
			if self.hasMore then
				self.labelNotice:setString(i18n("common_text_089"))
				self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
				self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
			else
				self.labelNotice:setString(i18n("common_text_085"))
				self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
				self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
			end
		end
	elseif event == ccui.ScrollviewEventType.bounceTop then
	end
end
function allianceTaskLogScrollView:requestMore()
	if self.hasMore == false then
		print("没有更多消息了，不再请求-------------")
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = #self.itemsData
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		playerMobilizationCtrl:reqOperateLog(index)
	end
end
function allianceTaskLogScrollView:msgUpdateTaskLog(target, data)
	self:recycleAllNodes()
	self.itemsData = self:getLogDatas()
	self:updateScrollView()
	self:hideLoadingSprite()
end
function allianceTaskLogScrollView:recycleAllNodes()
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			self:addToRecycledList(v.itemNode)
			v.itemNode = nil
		end
	end
end
function allianceTaskLogScrollView:msgNoMoreTaskLog(target, data)
	self.hasMore = false
	self.labelNotice:setString(i18n("common_text_085"))
	self:hideLoadingSprite()
end
function allianceTaskLogScrollView:msgNewTaskLog(target, data)
	print("allianceTaskLogScrollView:msgNewTaskLog 接收到日志--------")
	self:recycleAllNodes()
	self.itemsData = self:getLogDatas()
	self:updateScrollView()
end
return allianceTaskLogScrollView
