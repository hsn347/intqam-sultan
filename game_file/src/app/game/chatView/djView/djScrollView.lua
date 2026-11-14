local chatDesRead = include("chatDesRead")
local chatFunctions = include("chatFunctions")
local gametop = gModuleMgr.getObject("gametop")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local chatNodeFactory = include("chatNodeFactory")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
local DjScrollView = class("djScrollView", function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("djScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if target == nil then
		return SoraDCreateBasePanel("djScrollView")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("djScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if target == nil then
		return SoraDCreateBasePanel("djScrollView")
	end
	return target
end, "djScrollView"
;(function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("djScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if target == nil then
		return SoraDCreateBasePanel("djScrollView")
	end
	return target
end)[gChatDJShowType.CHAT_VIEW] = 415
;("djScrollView").normalOtherH, (function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("djScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if target == nil then
		return SoraDCreateBasePanel("djScrollView")
	end
	return target
end)[gChatDJShowType.DJ_VIEW] = function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("djScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if target == nil then
		return SoraDCreateBasePanel("djScrollView")
	end
	return target
end, 355
local _defaultParam = "djScrollView"
function DjScrollView:ctor()
	self.itemsGiftNodes, _ENV, self.giftTableSpare, _ENV, self.tableSpare, _ENV, self.itemsData, _ENV, self.showType = gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW, gChatDJShowType.CHAT_VIEW
	self.giftMsgNum = 5
	self.updateKey = gChatDjMTypeToKey[gChatTypeDef.chat_content_dj_gift]
	self.chatChannel = 0
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.giftScroll = SoraDGetChildByName(self, "Gift_scrollView")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setVisible(false)
	self.heightNotice = 0
	self.isHistoryMsg = true
	self.isReqRedPacket = false
	self.heightBottomAutoScroll = -100
	self.isShowEffect = true
	self.normalH = 0
	self.btn_new_number = SoraDGetChildByName(self, "btn_new_number")
	self.txt_new_number = SoraDGetChildByName(self.btn_new_number, "txt_new_number")
	self.btn_new_number:addTouchEventListener(handler(self, self.onTouchNewNumber))
	self.btn_new_number:setVisible(false)
	self.newNumber = 0
	self.scrollView:setListenAllScrollingEnabled(true)
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollView.parentView = self
end
function DjScrollView:updateTime()
	if self.isScrollDirty then
		self:updateScrollSize()
		self:updateScrollCell()
		self:traverseNodesOnce()
		self.isScrollDirty = false
		self.isScrollCellDirty = false
	elseif self.isScrollCellDirty then
		self:updateScrollCell()
		self.isScrollCellDirty = false
	end
end
function DjScrollView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ADD_MESSAGE", handler(self, self.chatAddMessage))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_HEAD_UPDATE", function(...)
		self:initScrollSize()
		self:updateScrollView()
	end)
	SoraDAddMessage(self, "MESSAGE_CHAT_UPDATE_SCROLLVIEW", handler(self, self.msgUpdateScrollView))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_SCROLL_RELOAD", function(...)
		if self.chatChannel > 0 then
			self:initWithChatChannel(self.channelData)
		end
	end)
end
function DjScrollView:initWithChatChannel(data)
	self.channelData = data
	self.chatChannel = data.chatChannel
	self.chatSet = data.chatSet or gChatSet.TOTAL
	self.key = data.key or 1
	self.headNode = data.headNode
	self.showType = data.showType
	local ignoreCloseLoading = data.ignoreCloseLoading
	print("DjScrollView:initWithChatChannel: self.chatChannel, chatSet, key = ", self.chatChannel, self.chatSet, self.key)
	local itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet, self.key)
	print("地址:itemsData = ", tostring(itemsData))
	self:initScrollSize()
	self:initWithData(itemsData, ignoreCloseLoading)
end
function DjScrollView:initScrollSize()
	if self.headNode then
		local headH = self.headNode:getSingleHeight()
		self.normalH = display.height - _defaultParam.normalOtherH[self.showType]
		self.scrollView:setContentSize(cc.size(640, self.normalH - headH))
		self.giftScroll:setPositionY(self.normalH - headH + 15)
		SoraDGetChildByName(self, "frame_yyzbgnyh_btl_02_1"):setPositionY(self.normalH - headH - 17 + 15)
		self.scrollView:setInnerContainerSize(self.scrollView:getContentSize())
		self.scrollSize = self.scrollView:getContentSize()
	end
end
function DjScrollView:initWithData(chatData, ignoreCloseLoading)
	self:recycleAll()
	self.itemsData = chatData
	self:delayUpdateScrollView(ignoreCloseLoading)
end
function DjScrollView:delayUpdateScrollView(ignoreCloseLoading)
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	local delay = cca.delay(0.15)
	local callFunc = cca.callFunc(function()
		self:updateScrollView()
		if not ignoreCloseLoading then
			SoraDCloseLoading(nil, gShowLoadingMark.chat)
		end
		self.isScrollUpdatedFirst = true
		local parent = self:getParent()
		if parent and parent.onScrollUpdateFirst then
			parent:onScrollUpdateFirst(self)
		end
	end)
	_UPVALUE2_ = gShowLoadingMark.chat
	gShowLoadingMark.chat[1] = delay
	gShowLoadingMark.chat[2] = callFunc
	local seq = cca.seq(gShowLoadingMark.chat)
	self:runAction(seq)
end
function DjScrollView:autoNewChatMsg()
	local delayTime = cca.delay(5)
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
function DjScrollView:produceChatMsg(number, isHistoryMsg)
	do return end
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
			;(nil).itemPosX = 0
			;(nil).itemPosY = 0
			table.insert(chatData.data, i, nil)
		else
			local contenttext = "this is produced new msg"
			local dataType = math.random(0, 1)
			if dataType == 1 then
				contenttext = chatDesRead.getEmotionImgById(1)
			end
			_ENV = nil
			;(nil).dataType = dataType
			;(nil).chatId = 1000 + i
			;(nil).playerId = 100
			;(nil).isVip = true
			;(nil).alliance = "Cec"
			;(nil).content = contenttext
			;(nil).time = "11:30"
			;(nil).itemNode = nil
			;(nil).itemWidth = 0
			;(nil).itemHeight = 0
			;(nil).itemPosX = 0
			;(nil).itemPosY = 0
			table.insert(chatData.data, i, nil)
		end
	end
	self:receiveChatMsg(chatData)
end
function DjScrollView:receiveChatMsg(chatData)
	local numberOfChatItem = #chatData.data
	local isHistoryMsg = chatData.isHistoryMsg
	if isHistoryMsg == true then
		print("receive history msg")
		self.isHistoryMsg = true
	else
		print("receive new msg")
		self.isHistoryMsg = false
		self.isShowEffect = true
		self.newNumber = self.newNumber + numberOfChatItem
	end
	self:updateScrollView()
	if isHistoryMsg == true and self.isReqRedPacket == true then
		print("这是请求历史记录后的返回，自动跳转红包位置----------------------")
		self.isReqRedPacket = false
		_ENV = "这是请求历史记录后的返回，自动跳转红包位置----------------------"
		;("这是请求历史记录后的返回，自动跳转红包位置----------------------").msg = "MESSAGE_CHAT_NAVIGATE_TO_RED_PACKET"
		SoraDSendMessage("这是请求历史记录后的返回，自动跳转红包位置----------------------")
	end
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
end
function DjScrollView:createChatItem(data)
	local node = chatNodeFactory.getNode(data.nodeType, self.tableSpare)
	node:init(data)
	if node.setScroll then
		node:setScroll(self.scrollView)
	end
	return node
end
function DjScrollView:updateScrollView()
	self:updateScrollSize()
	self:updateScrollCell()
	self:traverseNodesOnce()
	self:updateGiftMsgScrollView()
end
function DjScrollView:updateGiftMsgScrollView()
	print(self.chatChannel, self.chatSet, "self.chatChannel, self.chatSet")
	if self.chatChannel == gChatChannel.DJ and self.chatSet then
		local itemData = chatDataMgr:getData(self.chatChannel, self.chatSet, 2)
		dump(itemData, "itemData")
		self:recycleGiftNode()
		local posY = 0
		for i = 1, math.min(#itemData, self.giftMsgNum) do
			if itemData[i].itemWidth == 0 and itemData[i].itemHeight == 0 then
				local nodeClass = include(chatNodeFactory.getClass(itemData[i].nodeType))
				local nodeSize = nodeClass.measureSize(itemData[i])
				itemData[i].itemWidth = nodeSize.width
				itemData[i].itemHeight = nodeSize.height
			end
			local node, isNew = chatNodeFactory.getNode(itemData[i].nodeType, self.giftTableSpare)
			node:init(itemData[i])
			node:setVisible(true)
			node:setPosition(cc.p(0, posY))
			posY = posY + itemData[i].itemHeight
			if isNew then
				node.nodeType = itemData[i].nodeType
				node:addTo(self.giftScroll)
				if node.setScroll then
					node:setScroll(self.giftScroll)
				end
			end
			self.itemsGiftNodes[i] = node
		end
		self.giftScroll:setInnerContainerSize(cc.size(640, posY))
		local offsetY = math.min(0, 125 - posY)
		self.giftScroll:getInnerContainer():setPositionY(offsetY)
		if gChatDjMTypeToKey[gChatTypeDef.chat_content_dj_gift] == self.updateKey then
			self.giftScroll:scrollToBottom(0.3, true)
		end
	end
end
function DjScrollView:needKeyWorldEffect(itemData)
	if itemData.dataType ~= gChatDataType.dataType_text then
		return false
	end
	if itemData.serverMsg and type(itemData.serverMsg.content) == "table" and itemData.serverMsg.content.textType ~= gChatTextType.text_plain then
		return false
	end
	if itemData.isSysMsg then
		return false
	end
	return true
end
function DjScrollView:needTranslate(itemData)
	if itemData.isSelf then
		return false
	end
	if itemData.serverMsg and type(itemData.serverMsg.content) == "table" and itemData.serverMsg.content.textType ~= gChatTextType.text_plain then
		return false
	end
	if itemData.isSysMsg then
		return false
	end
	if itemData.translation == nil then
		return true
	end
	local isNeedTranslate, tText = translateCtrl:needTranslate(itemData.translation)
	return isNeedTranslate
end
function DjScrollView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local totalCount = #self.itemsData
	local removeCount = 0
	if -10000 < offsetY and 1500 < totalCount then
		removeCount = 1000
	elseif 2000 < totalCount then
		removeCount = 1500
	end
	if 0 < removeCount then
		local removeNode
		for i = 1, removeCount do
			removeNode = table.remove(self.itemsData)
			if removeNode.itemNode then
				removeNode.itemNode:setVisible(false)
				chatNodeFactory.addNode(removeNode.itemNode, removeNode.nodeType, self.tableSpare)
				removeNode.itemNode = nil
			end
		end
	end
	local accumulateHeight = 0
	for _, v in ipairs(self.itemsData) do
		if v.itemWidth == 0 and v.itemHeight == 0 then
			local nodeClass = include(chatNodeFactory.getClass(v.nodeType))
			local nodeSize = nodeClass.measureSize(v)
			v.itemWidth = nodeSize.width
			v.itemHeight = nodeSize.height
		end
		v.itemPosY = accumulateHeight
		accumulateHeight = accumulateHeight + v.itemHeight
		if v.itemNode then
			v.itemNode:setPositionY(v.itemPosY)
			local itemPosX
			itemPosX = 0
			v.itemNode:setPositionX(itemPosX)
			if v.markDirty and v.itemNode.reInit then
				v.itemNode:reInit(true)
				v.markDirty = false
			end
		end
	end
	local totalCellHeight = accumulateHeight + self.heightNotice
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
		local deltaY = scrollContentSize.height - totalCellHeight
		totalCellHeight = scrollContentSize.height
		for _, v in ipairs(self.itemsData) do
			v.itemPosY = v.itemPosY + deltaY
			if v.itemNode and not tolua.isnull(v.itemNode) then
				v.itemNode:setPositionY(v.itemPosY)
			end
		end
		self.labelNotice:setPosition(self.labelNotice:getPositionX(), totalCellHeight - self.heightNotice)
	end
	local scrollInnerNewH = totalCellHeight
	scrollInnerNewH = scrollInnerNewH + 10
	local bNeedAutoScrollBottom = false
	if self.isHistoryMsg and not self.isBackWard then
	else
		if offsetY > self.heightBottomAutoScroll then
			bNeedAutoScrollBottom = true
			if self.isNeedScroll == true then
				self.isNeedScroll = false
			end
			self.newNumber = 0
			_ENV = self.labelNotice:getPositionX()
			self.labelNotice:getPositionX().msg = "MESSAGE_CHAT_CLOSE_MENU"
			self.labelNotice:getPositionX().chatChannel = self.chatChannel
			SoraDSendMessage((self.labelNotice:getPositionX()))
		end
		if 0 < removeCount then
		else
			offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
		end
		self:updateNewNumber()
	end
	self.scrollView:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	offsetY = math.min(0, math.max(offsetY, scrollContentSize.height - scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if bNeedAutoScrollBottom then
		self.scrollView:scrollToBottom(0.3, true)
	end
end
function DjScrollView:traverseNodesOnce()
	if not self.traverseHandler then
		self.traverseHandler = handler(self, self.traverseNodes)
	end
	if not self.unikey then
		self.unikey = "TraverseNodesKey_" .. self.chatChannel
	end
	self.traverseHandle = SoraDDelayCallOnce(self.unikey, self.traverseHandler, 0.3)
end
function DjScrollView:traverseNodes()
	local _ENV, needTranslateData
	local tempChatEffect
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			local isDataInside = not self:isDataOutSideVisible(v)
			if not v.isSysMsg and not v.isCheckedEffect and not tempChatEffect and isDataInside and self:needKeyWorldEffect(v) and self.isShowEffect then
				local isHave, index = gModuleMgr.sharedMgr("keywordsOfFastivalltCtrl"):marchKewwords(v.content)
				if isHave and index and tempChatEffect == nil then
					tempChatEffect = index
					self.isShowEffect = false
				end
			end
			if isDataInside and v.dataType == gChatDataType.dataType_text then
				local data = v
				if chatTranslateMgr:needAutoTranslate(data) and not chatTranslateMgr:isReqTranslating(data) then
					table.insert(needTranslateData, data)
				end
			end
		end
		v.isCheckedEffect = true
	end
	self:addEffectByKeyWord(tempChatEffect)
	if 0 < #needTranslateData then
		print("发起批量翻译请求------")
		local from = gChatChannel2From[self.chatChannel]
		_ENV = nil
		;(nil).from = from
		;(nil).dataItemList = needTranslateData
		;(nil).isAutoTranslate = true
		;(nil).dataKey = self.key
		chatTranslateMgr:reqTranslate(nil)
	end
end
function DjScrollView:lazyUpdateScrollCell()
	self.isScrollCellDirty = true
end
function DjScrollView:lazyUpdateScrollView()
	self.isScrollDirty = true
end
function DjScrollView:updateScrollCell()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.0 * scrollH)
	local _ENV, self.scrollView.endY, tableShowH = offsetY + 1.0 * scrollH, offsetY + 1.0 * scrollH, self.scrollView
	;(offsetY + 1.0 * scrollH).beginY = math.max(0, offsetY - 0.0 * scrollH)
	local (offsetY + 1.0 * scrollH).endY, tableVisibleShowH = offsetY + 1.0 * scrollH, offsetY + 1.0 * scrollH
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			if v.itemPosY + v.itemHeight < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				v.itemNode:setVisible(false)
				chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
				v.itemNode = nil
			elseif v.itemPosY >= tableVisibleShowH.beginY and v.itemPosY <= tableVisibleShowH.endY and not v.isRead then
				if v.dataType == gChatDataType.dataType_red_packet then
					print("标记为已读")
				end
				v.isRead = true
			end
		elseif tableShowH.beginY <= v.itemPosY + v.itemHeight and tableShowH.endY >= v.itemPosY then
			local node, isNew = chatNodeFactory.getNode(v.nodeType, self.tableSpare)
			v.itemNode = node
			v.itemNode:init(v)
			if isNew then
				v.itemNode:addTo(self.scrollView)
				if v.itemNode.setScroll then
					v.itemNode:setScroll(self.scrollView)
				end
			end
			v.itemNode:setPosition(0, v.itemPosY)
			if v.itemPosY >= tableVisibleShowH.beginY and v.itemPosY <= tableVisibleShowH.endY and not v.isRead then
				v.isRead = true
			end
		end
		if v.itemPosY > tableShowH.endY then
			print("提早break了---", _, "#self.itemsData", #self.itemsData)
			break
		end
	end
end
function DjScrollView:resizeContentSize(newSize)
	print("调整了大小: ")
	dump(newSize, "调整为新的大小")
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	self.scrollView:setContentSize(newSize)
	self.giftScroll:setPositionY(newSize.height + 15)
	SoraDGetChildByName(self, "frame_yyzbgnyh_btl_02_1"):setPositionY(newSize.height - 17 + 15)
	scrollInner:setPositionY(offsetY)
end
function DjScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollCell()
		self:checkToBottom()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		self.newNumber = 0
		self:updateNewNumber()
	elseif event == ccui.ScrollviewEventType.bounceTop then
	elseif event == ccui.ScrollviewEventType.scrollingEnd then
		if not self.scrollView:isScrolling() and not self.scrollView:isAutoScrolling() then
			self:traverseNodesOnce()
		end
		self:checkToBottom()
	end
end
function DjScrollView:checkToBottom()
	local isToBottom = false
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	if offsetY > self.heightBottomAutoScroll then
		isToBottom = true
	end
	if isToBottom then
		self.newNumber = 0
		self:updateNewNumber()
	end
end
function DjScrollView:chatAddMessage(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	self.updateKey = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet then
		return
	end
	local chatData = data.chatData
	if nil == chatData then
		print("chatData是空的--------1111")
		return
	end
	self.isNeedScroll = data.isNeedScroll
	self.isBackWard = data.isBackWard
	print("收到了新消息------------------------")
	self:receiveChatMsg(chatData)
end
function DjScrollView:chatHistoryEnd(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		print("类型没通过验证", self.chatChannel, self.chatSet, self.key, chatChannel, chatSet, key)
		return
	end
	print("·DjScrollView:chatHistoryEnd· 没有更多数据了·")
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
	self.labelNotice:setString(i18n("common_text_085"))
	self.hasMore = false
	_ENV = self.labelNotice
	self.labelNotice.msg = "MESSAGE_UPDATE_UNREAD_WHEN_SCROLL"
	self.labelNotice.chatChannel = self.chatChannel
	SoraDSendMessage(self.labelNotice)
end
function DjScrollView:msgShowChatMenu(target, data)
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
function DjScrollView:msgClickOnAvatar(target, data)
	print("------DjScrollView:msgClickOnAvatar(target, data)--------")
	local chatType = data.chatType
	local sender = data.sender
	local playerID = data.playerID
	if chatType == nil or sender == nil then
		return
	end
	if self.chatType ~= chatType then
		return
	end
	if sender then
		if SoraDIsNodeVisibleOnScroll(sender, self.scrollView) == true then
			print("在滚动框内===")
			_ENV = "在滚动框内==="
			;("在滚动框内===").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			;("在滚动框内===").playerID = playerID
			SoraDSendMessage("在滚动框内===")
		else
			print("在滚动框外===")
		end
	end
end
function DjScrollView:msgUpdateScrollView(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		return
	end
	self:updateScrollView()
end
function DjScrollView:isSelfRPSender(data)
	local playerId = chatFunctions:getSelfId()
	if data.customData and data.customData.uinfo and data.customData.uinfo.id == playerId then
		return true
	end
	return false
end
function DjScrollView:hasRedPacketOutSideVisible()
	local ret = false
	local retCell
	for i, v in ipairs(self.itemsData) do
		if v.dataType == gChatDataType.dataType_red_packet and not v.isRead and not self:isSelfRPSender(v) and not chatFunctions:getIsRPExpiredByTime(v.customData.redPacketInfo.sendTime) and self:isDataOutSideVisible(v) then
			ret = true
			retCell = v
			break
		end
	end
	return ret, retCell
end
function DjScrollView:navigateToChatId(chatId)
	local itemData = chatDataMgr:getExistDataByChatId(self.chatChannel, self.chatSet, self.key, chatId)
	if not itemData then
		return
	end
	print("DjScrollView:navigateToChatId(chatId)本地跳转到：", chatId)
	local scrollInner = self.scrollView:getInnerContainer()
	local scrollInnerHeight = scrollInner:getContentSize().height
	local scrollH = self.scrollView:getContentSize().height
	local posCellY = itemData.itemPosY
	posCellY = posCellY - scrollH
	local percent = 1 - posCellY / (scrollInnerHeight - scrollH)
	percent = math.min(100, math.max(0, math.ceil(percent * 100)))
	print("DjScrollView:navigateToChatId(chatId)滚动到percent:", percent, "内容: ", itemData.content)
	self.scrollView:scrollToPercentVertical(percent, 0.2, true)
end
function DjScrollView:isDataOutSideVisible(data)
	local ret = false
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.0 * scrollH)
	local self.scrollView.endY, tableShowH = offsetY + 1.0 * scrollH, self.scrollView
	if data.itemPosY > tableShowH.endY then
		ret = true
	end
	return ret
end
function DjScrollView:msgNavigateToRedPacket(target, data)
	print("DjScrollView:msgNavigateToRedPacket, table ------", tostring(self))
	local channel = chatDataMgr:getCurrentChatChannel()
	local chatType = self.chatType
	if channel == gChatTypeDef.chat_kingDom_type and chatType ~= 0 then
		return
	end
	if channel == gChatTypeDef.chat_alliance_type and chatType ~= 1 then
		return
	end
	local hasCell, retCell = self:hasRedPacketOutSideVisible()
	if hasCell and retCell then
		local scrollInner = self.scrollView:getInnerContainer()
		local scrollInnerHeight = scrollInner:getContentSize().height
		local scrollH = self.scrollView:getContentSize().height
		local posCellY = retCell.itemPosY + retCell.itemHeight / 2
		posCellY = posCellY - scrollH / 2
		local percent = 1 - posCellY / (scrollInnerHeight - scrollH)
		percent = math.min(100, math.max(0, math.ceil(percent * 100)))
		print("滚动到percent:", percent, "红包内容: ", retCell.content)
		self.scrollView:scrollToPercentVertical(percent, 0.2, true)
	else
		print("红包不在本地，请求更多的数据-------")
		self.scrollView:scrollToPercentVertical(0, 0.2, true)
		self.isReqRedPacket = true
		self:requestMore()
	end
end
function DjScrollView:msgJumpToTop(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		return
	end
	self.scrollView:jumpToTop()
	_ENV = self.scrollView
	self.scrollView.msg = "MESSAGE_CHAT_CLOSE_MENU"
	self.scrollView.chatChannel = self.chatChannel
	SoraDSendMessage(self.scrollView)
end
function DjScrollView:msgJumpToBottom(target, data)
	local chatChannel = data.chatChannel
	if self.chatChannel ~= chatChannel then
		return
	end
	self.scrollView:jumpToBottom()
end
function DjScrollView:addEffectByKeyWord(eType)
	local chatConst = include("chatConst")
	local path = chatConst.getChatEffectPathByType(eType)
	if not path then
		print("没有特效，返回了----")
		return
	end
	if not self.snow then
		self.snow = cc.ParticleSnow:createWithTotalParticles(25)
		self.snow:setTexture(cc.Director:getInstance():getTextureCache():addImage(path))
		self.snow:setPosition(cc.p(display.cx, display.height - 300))
		self.snow:setPosVar(cc.p(300, 0))
		self.snow:setDuration(3)
		self.snow:setRadialAccelVar(2)
		self.snow:setTangentialAccelVar(2)
		self.snow:setSpeed(300)
		self.snow:setSpeedVar(20)
		self.snow:setLife(6)
		self.snow:setLifeVar(1)
		self.snow:setStartSize(54)
		self.snow:setStartSizeVar(30)
		self.snow:setEndSize(52)
		self.snow:setEndSizeVar(20)
		self.snow:addTo(self, 5)
		_UPVALUE1_ = self.snow
		self.snow[1] = cca.delay(6)
		self.snow[2] = cca.callFunc(function()
			self.snow:removeFromParent()
			self.snow = nil
		end)
		self.snow[3] = cca.callFunc(function()
			self.snow:removeFromParent()
			self.snow = nil
		end)
		local action = cca.seq(self.snow)
		self.snow:runAction(action)
	else
		self.snow:removeFromParent()
		self.snow = nil
		self:addEffectByKeyWord(eType)
	end
end
function DjScrollView:recycleAll()
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			v.itemNode:setVisible(false)
			chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
			v.itemNode = nil
		end
	end
	self.itemsData, _ENV = ipairs(self.itemsData)
	self:recycleGiftNode()
end
function DjScrollView:recycleGiftNode()
	for _, itemNode in ipairs(self.itemsGiftNodes) do
		if itemNode then
			itemNode:setVisible(false)
			chatNodeFactory.addNode(itemNode, itemNode.nodeType, self.giftTableSpare)
		end
	end
	self.itemsGiftNodes, _ENV = ipairs(self.itemsGiftNodes)
end
function DjScrollView:onExitOther()
	if self.traverseHandle then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.traverseHandle)
	end
	self:recycleAll()
	if not self.isInInstanceView then
		self:clearCache()
	else
		self.scrollView:scrollToBottom(0, false)
	end
	local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
	if (self.chatChannel == gChatChannel.KINGDOM or self.chatChannel == gChatChannel.ALLIANCE) and self.chatSet == gChatSet.TOTAL then
		_ENV = false
		;(false).chatChannel = self.chatChannel
		;(false).chatSet = self.chatSet
		chatUnReadMgr:reqReadChatMsg(false)
	end
end
function DjScrollView:clearCache()
	chatNodeCacheMgr.clearCache(self.tableSpare)
	chatNodeCacheMgr.clearCache(self.giftTableSpare)
end
function DjScrollView:updateNewNumber()
	if self.newNumber > 0 then
		self.btn_new_number:setVisible(true)
		self.txt_new_number:setString(self.newNumber)
	else
		self.btn_new_number:setVisible(false)
	end
end
function DjScrollView:onTouchNewNumber(target, event)
	if event == ccui.TouchEventType.ended then
		self.scrollView:scrollToBottom(0.2, true)
	end
end
return DjScrollView
