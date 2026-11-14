local chatDesRead = include("chatDesRead")
local chatFunctions = include("chatFunctions")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
_ENV = gChatMgrs
_defaultParam, gChatMgrs.numPageSize = gChatMgrs, 7
local worldEscortLogScroll = class("worldEscortLogScroll", function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("worldEscortLogScroll")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel("worldEscortLogScroll")
	end
	return target
end)
function worldEscortLogScroll:ctor()
	self.tableSpare, _ENV, self.itemsData, _ENV = nil, nil, nil, nil
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setLocalZOrder(10)
	self.heightNotice = 40
	self.heightEnableNotice = 55
	self.fromLoadText = false
	self.isHistoryMsg = true
	self.isReqRedPacket = false
	self.heightBottomAutoScroll = 50
	self.hasMore = true
	self.isShowEffect = true
	self.scrollView:setListenAllScrollingEnabled(true)
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
end
function worldEscortLogScroll:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ADD_MESSAGE", handler(self, self.chatAddMessage))
	SoraDAddMessage(self, "MESSAGE_CHAT_HISTORY_END", handler(self, self.chatHistoryEnd))
	SoraDAddMessage(self, "MESSAGE_CHAT_SHOW_CHAT_MENU", handler(self, self.msgShowChatMenu))
	SoraDAddMessage(self, "MESSAGE_CHAT_UPDATE_SCROLLVIEW", handler(self, self.msgUpdateScrollView))
end
function worldEscortLogScroll:initWithChatChannel(data)
	self.channelData = data
	self.chatChannel = data.chatChannel
	self.chatSet = data.chatSet or gChatSet.TOTAL
	self.key = data.key
	self.chatType = gChatChannel2ChatTypeUI[self.chatChannel]
	local ignoreCloseLoading = data.ignoreCloseLoading
	print("chatScrollView:initWithChatChannel: self.chatChannel, chatSet, key = ", self.chatChannel, self.chatSet, self.key)
	local itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet, self.key)
	print("地址:itemsData = ", tostring(itemsData))
	self:initWithData(itemsData, ignoreCloseLoading)
	self.labelNotice:setString(i18n("common_text_089"))
	self.labelNotice:setVisible(false)
end
function worldEscortLogScroll:initWithData(chatData, ignoreCloseLoading)
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			v.itemNode:setVisible(false)
			table.insert(self.tableSpare, v.itemNode)
			v.itemNode = nil
		end
	end
	self.itemsData = chatData
	self:delayUpdateScrollView(ignoreCloseLoading)
end
function worldEscortLogScroll:delayUpdateScrollView(ignoreCloseLoading)
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	local delay = cca.delay(0.2)
	local callFunc = cca.callFunc(function()
		self:updateScrollView()
		if not ignoreCloseLoading then
			SoraDCloseLoading(nil, gShowLoadingMark.chat)
		end
	end)
	_UPVALUE2_ = gShowLoadingMark.chat
	gShowLoadingMark.chat[1] = delay
	gShowLoadingMark.chat[2] = callFunc
	local seq = cca.seq(gShowLoadingMark.chat)
	self:runAction(seq)
end
function worldEscortLogScroll:requestMore()
	if self.hasMore == false then
		print("没有更多消息了，不再请求-------------")
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		print("worldEscortLogScroll Request data!!!")
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
		_ENV = SoraDCloseLoading
		SoraDCloseLoading.chatChannel = self.chatChannel
		SoraDCloseLoading.chatSet = self.chatSet
		SoraDCloseLoading.key = self.key
		local SoraDCloseLoading.num, param = _defaultParam.numPageSize, SoraDCloseLoading
		chatSendMgr:requestHistory(param)
		self.isShowEffect = false
	end
end
function worldEscortLogScroll:autoNewChatMsg()
	print("auto new msg----------------------------------------")
	local delayTime = cca.delay(3)
	local callFunc = cca.callFunc(function()
		self:produceChatMsg(1, false)
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = delayTime
	;(nil)[2] = callFunc
	local seq = cca.seq(nil)
	local repeatSeq = cca.repeatForever(seq)
	self:runAction(repeatSeq)
end
function worldEscortLogScroll:produceChatMsg(number, isHistoryMsg)
	local chatData.data, _ENV, _ENV, chatData
	chatData.isHistoryMsg = isHistoryMsg
	for i = 1, number do
		if isHistoryMsg then
			_ENV = nil
			;(nil).dataType = 0
			;(nil).chatId = 99 + i
			;(nil).playerId = 100
			;(nil).isVip = true
			;(nil).alliance = "Cec"
			;(nil).content = "this is produced history msg"
			;(nil).time = "11:30"
			;(nil).itemNode = nil
			;(nil).itemWidth = 0
			;(nil).itemHeight = 0
			;(nil).itemPosX = SoraDFPosX(600, 600)
			;(nil).itemPosY = 0
			table.insert(chatData.data, i, nil)
		else
			local contenttext = "this is produced new msg"
			local dataType = math.random(0, 1)
			if dataType == 1 then
				contenttext = chatDesRead.getEmotionImgById(1)
			end
			_ENV = 600
			;(600).dataType = dataType
			;(600).chatId = 1000 + i
			;(600).playerId = 100
			;(600).isVip = true
			;(600).alliance = "Cec"
			;(600).content = contenttext
			;(600).time = "11:30"
			;(600).itemNode = nil
			;(600).itemWidth = 0
			;(600).itemHeight = 0
			;(600).itemPosX = SoraDFPosX(600, 600)
			;(600).itemPosY = 0
			table.insert(chatData.data, i, 600)
		end
	end
	self:receiveChatMsg(chatData)
end
function worldEscortLogScroll:receiveChatMsg(chatData)
	local numberOfChatItem = #chatData.data
	local isHistoryMsg = chatData.isHistoryMsg
	if isHistoryMsg == true then
		print("receive history msg")
		self.isHistoryMsg = true
	else
		print("receive new msg")
		self.isHistoryMsg = false
		self.isShowEffect = true
	end
	self:updateScrollView()
	if isHistoryMsg == true then
	end
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
end
function worldEscortLogScroll:createChatItem(data)
	local worldEscortLogItem = include("worldEscortLogItem")
	local logItemNode = worldEscortLogItem.new()
	logItemNode:initWithData(data)
	return logItemNode
end
function worldEscortLogScroll:updateScrollView()
	local worldEscortLogItem = include("worldEscortLogItem")
	local logItemNdoe = worldEscortLogItem.new()
	logItemNdoe:retain()
	local tempChatEffect
	dump(self.itemsData, "self.itemsData--worldEscortLogScroll:updateScrollView()", 10)
	for _, v in ipairs(self.itemsData) do
		if v.itemWidth == 0 and v.itemHeight == 0 then
			logItemNdoe:initWithData(v)
			v.itemWidth = logItemNdoe:getItemWidth()
			v.itemHeight = logItemNdoe:getItemHeight()
			v.labelSize = logItemNdoe:getLabelSize()
		else
		end
	end
	logItemNdoe:release()
	self:updateScrollSize()
	self:updateScrollCell()
end
function worldEscortLogScroll:updateScrollCell()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local _ENV, self.scrollView.endY, tableShowH = offsetY + 1.5 * scrollH, offsetY + 1.5 * scrollH, self.scrollView
	;(offsetY + 1.5 * scrollH).beginY = math.max(0, offsetY - 0.0 * scrollH)
	local (offsetY + 1.5 * scrollH).endY, tableVisibleShowH = offsetY + 1.0 * scrollH, offsetY + 1.5 * scrollH
	for i, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.itemPosY + v.itemHeight < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				v.itemNode:setVisible(false)
				table.insert(self.tableSpare, v.itemNode)
				v.itemNode = nil
			end
		elseif tableShowH.beginY <= v.itemPosY and tableShowH.endY >= v.itemPosY then
			if 0 < #self.tableSpare then
				v.itemNode = table.remove(self.tableSpare)
				v.itemNode:initWithData(v)
				v.itemNode:setVisible(true)
			else
				v.itemNode = self:createChatItem(v)
				v.itemNode:addTo(self.scrollView)
			end
			v.itemNode:setPosition(v.itemPosX, v.itemPosY)
		end
	end
	if offsetY < -self.heightEnableNotice then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
	elseif self.hasMore then
		self.labelNotice:setString(i18n("common_text_089"))
	else
		self.labelNotice:setString(i18n("common_text_085"))
	end
	offsetY = -scrollInner:getPositionY()
end
function worldEscortLogScroll:getTotalCellHeight()
	local totalCellHeight = 0
	for i, v in ipairs(self.itemsData) do
		local itemWidth = self.itemsData.itemWidth
		local itemHeight = self.itemsData.itemHeight
		totalCellHeight = totalCellHeight + itemHeight
	end
	totalCellHeight = totalCellHeight + self.heightNotice
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
		totalCellHeight = scrollContentSize.height
	end
	return totalCellHeight
end
function worldEscortLogScroll:resizeContentSize(newSize)
	print("调整了大小: ")
	dump(newSize, "调整为新的大小")
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	self.scrollView:setContentSize(newSize)
	scrollInner:setPositionY(offsetY)
end
function worldEscortLogScroll:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local accumulateHeight = 0
	accumulateHeight = accumulateHeight + self.heightNotice
	for i = #self.itemsData, 1, -1 do
		local v = self.itemsData[i]
		v.itemPosX = SoraDFPosX(600, 600)
		v.itemPosY = accumulateHeight
		accumulateHeight = accumulateHeight + v.itemHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			v.itemNode:setPositionX(v.itemPosX)
		end
	end
	self.labelNotice:setPosition(self.labelNotice:getPositionX(), 10)
	self.labelNotice:setVisible(true)
	local totalCellHeight = accumulateHeight
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
		local deltaY = scrollContentSize.height - totalCellHeight
		for i, v in ipairs(self.itemsData) do
			v.itemPosY = v.itemPosY + deltaY
			if v.itemNode then
				v.itemNode:setPositionY(v.itemPosY)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	scrollInnerNewH = scrollInnerNewH + 10
	local bNeedAutoScrollTop = false
	if self.isHistoryMsg then
		if scrollInnerNewH > scrollInner:getContentSize().height then
			offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
		end
	elseif offsetY < scrollInner:getContentSize().height - self.heightBottomAutoScroll or self.isNeedScroll == true then
		bNeedAutoScrollTop = true
		if self.isNeedScroll == true then
			self.isNeedScroll = false
		end
	end
	self.scrollView:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if bNeedAutoScrollTop then
		self.scrollView:scrollToTop(0.5, true)
	end
end
function worldEscortLogScroll:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		if self.fromLoadText then
			self.labelNotice:setString(i18n("common_text_089"))
			self.fromLoadText = false
			self:requestMore()
		end
	elseif event == ccui.ScrollviewEventType.bounceTop then
	end
end
function worldEscortLogScroll:chatAddMessage(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		return
	end
	local chatData = data.chatData
	self.isNeedScroll = data.isNeedScroll
	if nil == chatData then
		return
	end
	print("收到了新消息------------------------")
	self:receiveChatMsg(chatData)
end
function worldEscortLogScroll:chatHistoryEnd(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		print("类型没通过验证", self.chatChannel, self.chatSet, self.key, chatChannel, chatSet, key)
		return
	end
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
	self.labelNotice:setString(i18n("common_text_085"))
	self.hasMore = false
end
function worldEscortLogScroll:msgShowChatMenu(target, data)
	local itemData = data.itemData
	local sender = data.sender
	if itemData == nil or sender == nil then
		return
	end
	if self.chatType ~= itemData.chatType then
		return
	end
	if sender then
		if SoraDIsNodeVisibleOnScroll(sender, self.scrollView) == true then
			print("在滚动框内")
			chatFunctions.ShowPlayerMenu(itemData)
		else
			print("在滚动框外")
		end
	end
end
function worldEscortLogScroll:msgUpdateScrollView(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		return
	end
	self:updateScrollView()
end
return worldEscortLogScroll
