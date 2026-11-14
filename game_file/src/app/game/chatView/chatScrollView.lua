local chatDesRead = include("chatDesRead")
local chatFunctions = include("chatFunctions")
local gametop = gModuleMgr.getObject("gametop")
local translateCtrl = gametop.playertop_:getModule("translateCtrl")
local chatNodeFactory = include("chatNodeFactory")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
local chatScrollView = class("chatScrollView", function(target)
	if target == nil then
		local panel = SoraDCreateBasePanel("chatScrollView")
		SoraDDeviceFitOffset(panel)
		return panel
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel("chatScrollView")
	end
	return target
end)
function chatScrollView:ctor()
	self.tableSpare, _ENV, self.itemsData, _ENV = nil, nil, nil, nil
	self.chatChannel = 0
	self.scrollView = SoraDGetChildByName(self, "Size_scrollView")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setLocalZOrder(10)
	self.heightNotice = 40
	self.heightEnableNotice = 55
	self.fromLoadText = false
	self.isHistoryMsg = true
	self.isReqRedPacket = false
	self.heightBottomAutoScroll = -50
	self.hasMore = true
	self.isShowEffect = true
	self.btn_new_number = SoraDGetChildByName(self, "btn_new_number")
	self.txt_new_number = SoraDGetChildByName(self.btn_new_number, "txt_new_number")
	self.btn_new_number:addTouchEventListener(handler(self, self.onTouchNewNumber))
	self.btn_new_number:setVisible(false)
	self.newNumber = 0
	self.scrollView:setListenAllScrollingEnabled(true)
	self.scrollView:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollView:setInnerContainerSize(self.scrollView:getContentSize())
	self.scrollSize = self.scrollView:getContentSize()
	self.scrollView.parentView = self
	self.timerKey = SoradCreateTimer(self, handler(self, self.updateTime))
end
function chatScrollView:updateTime()
	if self.isScrollCellDirty then
		_ENV = nil
		;(nil).msg = "MESSAGE_UPDATE_UNREAD_WHEN_SCROLL"
		;(nil).chatChannel = self.chatChannel
		SoraDSendMessage(nil)
		self.isScrollCellDirty = false
	end
end
function chatScrollView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ADD_MESSAGE", handler(self, self.chatAddMessage))
	SoraDAddMessage(self, "MESSAGE_CHAT_HISTORY_END", handler(self, self.chatHistoryEnd))
	SoraDAddMessage(self, "MESSAGE_CHAT_SHOW_CHAT_MENU", handler(self, self.msgShowChatMenu))
	SoraDAddMessage(self, "MESSAGE_CHAT_CLICK_ON_AVATAR", handler(self, self.msgClickOnAvatar))
	SoraDAddMessage(self, "MESSAGE_CHAT_UPDATE_SCROLLVIEW", handler(self, self.msgUpdateScrollView))
	SoraDAddMessage(self, "MESSAGE_CHAT_NAVIGATE_TO_RED_PACKET", handler(self, self.msgNavigateToRedPacket))
	SoraDAddMessage(self, "MESSAGE_CHAT_NAVIGATE_REPLY_MSG", handler(self, self.msgNavigateReplyMsg))
	SoraDAddMessage(self, "MESSAGE_CHAT_SCROLL_JUMPTO_TOP", handler(self, self.msgJumpToTop))
	SoraDAddMessage(self, "MESSAGE_CHAT_SCROLL_JUMPTO_BOTTOM", handler(self, self.msgJumpToBottom))
	SoraDAddMessage(self, "MESSAGE_CHAT_SET_SHIELD_MESSAGE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DEL_ALLIANCE_MSG_REFRESH", handler(self, self.msgDelrefreshView))
	SoraDAddMessage(self, "MESSAGE_CHAT_SHIELD_USER", handler(self, self.msgRefreshView))
end
function chatScrollView:initWithChatChannel(data)
	self.channelData = data
	self.chatChannel = data.chatChannel
	self.chatSet = data.chatSet or gChatSet.TOTAL
	self.key = data.key
	local ignoreCloseLoading = data.ignoreCloseLoading
	print("chatScrollView:initWithChatChannel: self.chatChannel, chatSet, key = ", self.chatChannel, self.chatSet, self.key)
	if not chatDataMgr:getData(self.chatChannel, self.chatSet, self.key) then
		local _ENV, itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet, self.key), chatDataMgr:getData(self.chatChannel, self.chatSet, self.key)
	end
	self:initWithData(itemsData, ignoreCloseLoading)
	self.labelNotice:setString(i18n("common_text_074"))
	self.labelNotice:setVisible(false)
end
function chatScrollView:msgRefreshView(target, data)
	for _, v in ipairs(self.itemsData) do
		v.isExist = true
	end
	self:updateScrollView()
	self.scrollView:jumpToBottom()
end
function chatScrollView:msgDelrefreshView(target, data)
	self:initWithChatChannel(data)
	self.scrollView:jumpToBottom()
end
function chatScrollView:refreshView(target, data)
	self:initWithData(self.itemsData)
	self.scrollView:jumpToBottom()
end
function chatScrollView:shieldData(newItemsData)
	print("receive history msg", self.isScrollUpdatedFirst)
	if not self.itemsData then
		_ENV = self.itemsData
	end
	self.itemsData = self.itemsData
	for _, v in ipairs(self.itemsData) do
		local isExist = false
		for _, v2 in ipairs(newItemsData) do
			if v2 == v then
				isExist = true
				break
			end
		end
		if not isExist and v.itemNode then
			v.itemNode:setVisible(false)
			chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
			v.itemNode = nil
		end
	end
	self.itemsData = newItemsData
	if self.chatChannel == gChatChannel.KINGDOM or self.chatChannel == gChatChannel.ALLIANCE or self.chatChannel == gChatChannel.TEAM then
		for k, v in ipairs(self.itemsData) do
			v.showIndex = k
		end
		local _ENV, showData = (for generator), ipairs(self.itemsData)
		_ENV = nil
		;(nil).byUID = true
		local level = SoraDConfigGet("Game:chat:castleLv~integer", nil)
		_ENV = nil
		;(nil).byUID = true
		local starLevel = SoraDConfigGet("Game:chat:castleStarLv~integer", nil)
		local index = 1
		for k, v in ipairs(self.itemsData) do
			dump(v.serverMsg, "v.serverMsg")
			local castleLv = v.serverMsg and v.serverMsg.castleLv
			local starLv = v.serverMsg and v.serverMsg.starLv
			if (castleLv and level > castleLv or starLv and starLevel > starLv) and not v.isSelf then
				print("忽略消息=========", k)
				if v.itemNode then
					v.itemNode:setVisible(false)
					chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
					v.itemNode = nil
				end
			else
				v.showIndex = index
				showData[index] = v
				index = index + 1
			end
		end
		self.itemsData = showData
	end
	local _ENV, showData = showData, ipairs(self.itemsData)
	for k, v in ipairs(self.itemsData) do
		dump(v, "chatScrollView:shieldData")
		local isForbiddenMessage = (not (v.serverMsg and v.serverMsg.content) or not v.serverMsg.content.is_adv) and (not v.data or not v.data.is_adv) and (not v.customData or not v.customData.is_adv) and v.customData and v.customData.data and v.customData.data.is_adv
		if isForbiddenMessage then
			local playerId = v.playerId or v.from or v.sender or v.user and v.user.uid or 0
			local isSelfMessage = chatFunctions.getIsPlayerSelf(playerId)
			if isSelfMessage then
				table.insert(showData, v)
			end
		else
			table.insert(showData, v)
		end
	end
	self.itemsData = showData
	if self.chatChannel == gChatChannel.TEAMMSG then
		for k, v in ipairs(self.itemsData) do
			v.showIndex = k
		end
		local _ENV, showData = (for generator), ipairs(self.itemsData)
		local index = 1
		for k, v in ipairs(self.itemsData) do
			if SoraDGetCtrl("chatCtrl"):isShield(v.playerId) and not v.isExist then
				print("忽略消息=========", k)
				if v.itemNode then
					v.itemNode:setVisible(false)
					chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
					v.itemNode = nil
				end
			else
				v.showIndex = index
				showData[index] = v
				index = index + 1
			end
		end
		self.itemsData = showData
	end
end
function chatScrollView:initWithData(chatData, ignoreCloseLoading)
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			v.itemNode:setVisible(false)
			chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
			v.itemNode = nil
		end
	end
	self:shieldData(chatData)
	self:delayUpdateScrollView(ignoreCloseLoading)
end
function chatScrollView:delayUpdateScrollView(ignoreCloseLoading)
	SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
	local delay = cca.delay(0.2)
	local callFunc = cca.callFunc(function()
		self:updateScrollView()
		if not ignoreCloseLoading then
			SoraDCloseLoading(nil, gShowLoadingMark.chat)
		end
		self.labelNotice:setVisible(true)
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
function chatScrollView:requestMore()
	if self.hasMore == false then
		print("没有更多消息了，不再请求-------------")
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		if not self.channelData then
			return
		end
		print("Request data!!! self.chatChannel, self.chatSet, self.key = ", self.chatChannel, self.chatSet, self.key)
		SoraDShowLoading(nil, nil, gShowLoadingMark.chat)
		chatSendMgr:requestHistory(self.channelData)
		self.isShowEffect = false
	end
end
function chatScrollView:autoNewChatMsg()
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
function chatScrollView:produceChatMsg(number, isHistoryMsg)
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
function chatScrollView:receiveChatMsg(chatData)
	local numberOfChatItem = #chatData.data
	local isHistoryMsg = chatData.isHistoryMsg
	local itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet, self.key)
	self:shieldData(itemsData)
	if isHistoryMsg == true then
		print("receive history msg", self.isScrollUpdatedFirst)
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
		chatDataMgr = "这是请求历史记录后的返回，自动跳转红包位置----------------------"
		;("这是请求历史记录后的返回，自动跳转红包位置----------------------").msg = "MESSAGE_CHAT_NAVIGATE_TO_RED_PACKET"
		SoraDSendMessage("这是请求历史记录后的返回，自动跳转红包位置----------------------")
	end
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
end
function chatScrollView:createChatItem(data)
	local node = chatNodeFactory.getNode(data.nodeType, self.tableSpare)
	node:init(data)
	if node.setScroll then
		node:setScroll(self.scrollView)
	end
	return node
end
function chatScrollView:updateScrollView()
	self:viewMailAndChatroom()
	self:updateScrollSize()
	self:updateScrollCell()
	self:traverseNodesOnce()
end
function chatScrollView:viewMailAndChatroom()
	local chatCoverMgr = gChatMgrs:getMgr("chatCoverMgr")
	if self.chatChannel == gChatChannel.MAIL then
		if chatCoverMgr:viewMailList(self.key) then
			SoraDGetCtrl("mailCtrl"):viewMailList(gMailSetType.CHAT, self.key)
		end
	elseif self.chatChannel == gChatChannel.CHATROOM then
		local newNum = chatCoverMgr:getNumInfoByKey(self.key).newNum
		if chatCoverMgr:viewMailList(self.key) then
			SoraDGetCtrl("chatroomCtrl"):reqChatRoomMsgBeenRead(self.channelData.target, newNum)
		end
	end
end
function chatScrollView:needKeyWorldEffect(itemData)
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
function chatScrollView:needTranslate(itemData)
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
function chatScrollView:updateScrollSize()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	print("updateScrollSize offsetY : " .. offsetY, self.isBackWard, #self.itemsData)
	dump(self.scrollView:getContentSize())
	local accumulateHeight = 0
	for _, v in ipairs(self.itemsData) do
		if v.itemWidth == 0 and v.itemHeight == 0 then
			local nodeClass = include(chatNodeFactory.getClass(v.nodeType))
			local nodeSize = nodeClass.measureSize(v)
			v.itemWidth = nodeSize.width
			v.itemHeight = nodeSize.height
		end
		v.itemPosY = accumulateHeight
		print("v.itemHeight", v.itemHeight)
		accumulateHeight = accumulateHeight + v.itemHeight
		if v.itemNode and not tolua.isnull(v.itemNode) and v.itemNode:isVisible() then
			v.itemNode:setPositionY(v.itemPosY)
			local itemPosX
			if v.direction == gChatDirection.left then
				itemPosX = 0
			else
				itemPosX = self.scrollSize.width - v.itemNode.width
			end
			v.itemNode:setPositionX(itemPosX)
			if v.markDirty and v.itemNode.reInit then
				v.itemNode:reInit(true)
				v.markDirty = false
			end
		end
	end
	self.labelNotice:setPosition(self.labelNotice:getPositionX(), accumulateHeight)
	local totalCellHeight = accumulateHeight + self.heightNotice
	print("totalCellHeight", totalCellHeight, accumulateHeight, self.heightNotice)
	local scrollContentSize = self.scrollView:getContentSize()
	if totalCellHeight < scrollContentSize.height then
		local deltaY = scrollContentSize.height - totalCellHeight
		totalCellHeight = scrollContentSize.height
		for _, v in ipairs(self.itemsData) do
			v.itemPosY = v.itemPosY + deltaY
			if v.itemNode and not tolua.isnull(v.itemNode) and v.itemNode:isVisible() then
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
		if offsetY > self.heightBottomAutoScroll or self.isNeedScroll == true then
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
		offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
		self:updateNewNumber()
	end
	self.scrollView:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if bNeedAutoScrollBottom then
		self.scrollView:scrollToBottom(0.3, true)
	end
end
function chatScrollView:traverseNodesOnce()
	if not self.traverseHandler then
		self.traverseHandler = handler(self, self.traverseNodes)
	end
	if not self.unikey then
		self.unikey = "TraverseNodesKey_" .. self.chatChannel
	end
	self.traverseHandle = SoraDDelayCallOnce(self.unikey, self.traverseHandler, 0.3)
end
function chatScrollView:traverseNodes()
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
function chatScrollView:lazyUpdateScrollCell()
	self.isScrollCellDirty = true
end
function chatScrollView:updateScrollCell()
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollView:getContentSize().height
	_ENV = self.scrollView
	self.scrollView.beginY = math.max(0, offsetY - 0.0 * scrollH)
	local _ENV, self.scrollView.endY, tableShowH = offsetY + 1.0 * scrollH, offsetY + 1.0 * scrollH, self.scrollView
	;(offsetY + 1.0 * scrollH).beginY = math.max(0, offsetY - 0.0 * scrollH)
	local (offsetY + 1.0 * scrollH).endY, tableVisibleShowH = offsetY + 1.0 * scrollH, offsetY + 1.0 * scrollH
	dump(self.itemsData, "self.itemsData")
	for _, v in ipairs(self.itemsData) do
		if v.itemNode and not tolua.isnull(v.itemNode) then
			if v.itemPosY + v.itemHeight < tableShowH.beginY or v.itemPosY > tableShowH.endY then
				v.itemNode:setVisible(false)
				chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
				v.itemNode = nil
			else
				v.itemNode:setVisible(true)
				if v.itemPosY >= tableVisibleShowH.beginY and v.itemPosY <= tableVisibleShowH.endY and not v.isRead then
					if v.dataType == gChatDataType.dataType_red_packet then
						print("标记为已读")
					end
					v.isRead = true
				end
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
			if v.direction == gChatDirection.left then
				v.itemNode:setPosition(0, v.itemPosY)
			else
				v.itemNode:setPosition(self.scrollSize.width - v.itemNode.width, v.itemPosY)
			end
			v.itemNode:setVisible(true)
			if v.itemPosY >= tableVisibleShowH.beginY and v.itemPosY <= tableVisibleShowH.endY and not v.isRead then
				v.isRead = true
			end
		end
		if v.itemPosY > tableShowH.endY then
			break
		end
	end
	if offsetY > scrollInner:getContentSize().height - self.scrollView:getContentSize().height + self.heightEnableNotice then
		self.fromLoadText = true
		if self.hasMore then
			self.labelNotice:setString(i18n("common_text_084"))
		end
	end
end
function chatScrollView:resizeContentSize(newSize)
	print("调整了大小: ")
	dump(newSize, "调整为新的大小")
	local scrollInner = self.scrollView:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	self.scrollView:setContentSize(newSize)
	scrollInner:setPositionY(offsetY)
end
function chatScrollView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:lazyUpdateScrollCell()
		self:updateScrollCell()
		self:checkToBottom()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		self.newNumber = 0
		self:updateNewNumber()
	elseif event == ccui.ScrollviewEventType.bounceTop then
		if self.fromLoadText then
			if self.hasMore then
				self.labelNotice:setString(i18n("common_text_074"))
			end
			self.fromLoadText = false
			self:requestMore()
		end
	elseif event == ccui.ScrollviewEventType.scrollingEnd then
		if not self.scrollView:isScrolling() and not self.scrollView:isAutoScrolling() then
			self:traverseNodesOnce()
		end
		self:checkToBottom()
	end
end
function chatScrollView:checkToBottom()
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
function chatScrollView:chatAddMessage(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	print("chatScrollView:chatAddMessage chatChannel", chatChannel, self.chatChannel)
	print("chatScrollView:chatAddMessage chatSet", chatSet, self.chatSet)
	print("chatScrollView:chatAddMessage key", key, self.key)
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
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
function chatScrollView:chatHistoryEnd(target, data)
	dump(data, "chatScrollView:chatHistoryEnd(target, data)", 10)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		print("类型没通过验证", self.chatChannel, self.chatSet, self.key, chatChannel, chatSet, key)
		return
	end
	print("·chatScrollView:chatHistoryEnd· 没有更多数据了·")
	SoraDCloseLoading(nil, gShowLoadingMark.chat)
	self.labelNotice:setString(i18n("common_text_085"))
	self.hasMore = false
	_ENV = self.labelNotice
	self.labelNotice.msg = "MESSAGE_UPDATE_UNREAD_WHEN_SCROLL"
	self.labelNotice.chatChannel = self.chatChannel
	SoraDSendMessage(self.labelNotice)
end
function chatScrollView:msgShowChatMenu(target, data)
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
function chatScrollView:msgClickOnAvatar(target, data)
	print("------chatScrollView:msgClickOnAvatar(target, data)--------")
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
function chatScrollView:msgUpdateScrollView(target, data)
	local chatChannel = data.chatChannel
	local chatSet = data.chatSet
	local key = data.key
	if self.chatChannel ~= chatChannel or self.chatSet ~= chatSet or self.key ~= key then
		return
	end
	self:updateScrollView()
end
function chatScrollView:isSelfRPSender(data)
	local playerId = chatFunctions:getSelfId()
	if data.customData and data.customData.uinfo and data.customData.uinfo.id == playerId then
		return true
	end
	return false
end
function chatScrollView:hasRedPacketOutSideVisible()
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
function chatScrollView:navigateToChatId(chatId)
	local itemData = chatDataMgr:getExistDataByChatId(self.chatChannel, self.chatSet, self.key, chatId)
	if not itemData then
		return
	end
	print("chatScrollView:navigateToChatId(chatId)本地跳转到：", chatId)
	local scrollInner = self.scrollView:getInnerContainer()
	local scrollInnerHeight = scrollInner:getContentSize().height
	local scrollH = self.scrollView:getContentSize().height
	local scrollableH = scrollInnerHeight - scrollH
	if scrollableH <= 0 then
		return
	end
	local itemH = itemData.itemHeight or 0
	local posCellY = itemData.itemPosY + itemH / 2 - scrollH / 2
	posCellY = math.max(0, math.min(scrollableH, posCellY))
	local percent = 1 - posCellY / scrollableH
	percent = math.min(100, math.max(0, math.ceil(percent * 100)))
	print("chatScrollView:navigateToChatId(chatId)滚动到percent:", percent, "内容: ", itemData.content)
	self.scrollView:scrollToPercentVertical(percent, 0.2, true)
end
function chatScrollView:msgNavigateReplyMsg(target, data)
	if not data or not data.msgID then
		return
	end
	if data.chatChannel and data.chatChannel ~= self.chatChannel then
		return
	end
	if data.chatSet and data.chatSet ~= self.chatSet then
		return
	end
	if data.key and self.key and data.key ~= self.key then
		return
	end
	local itemData = chatDataMgr:getExistDataByChatId(self.chatChannel, self.chatSet, self.key, data.msgID)
	if itemData then
		self:navigateToChatId(data.msgID)
	end
end
function chatScrollView:isDataOutSideVisible(data)
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
function chatScrollView:msgNavigateToRedPacket(target, data)
	print("chatScrollView:msgNavigateToRedPacket, table ------", tostring(self))
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
function chatScrollView:msgJumpToTop(target, data)
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
function chatScrollView:msgJumpToBottom(target, data)
	local chatChannel = data.chatChannel
	if self.chatChannel ~= chatChannel then
		return
	end
	self.scrollView:jumpToBottom()
end
function chatScrollView:addEffectByKeyWord(eType)
	do return end
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
function chatScrollView:onExitOther()
	print("退出-------------------chatScrollView:onExitOther")
	if self.traverseHandle then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.traverseHandle)
	end
	for _, v in ipairs(self.itemsData) do
		if v.itemNode then
			v.itemNode:setVisible(false)
			chatNodeFactory.addNode(v.itemNode, v.nodeType, self.tableSpare)
			v.itemNode = nil
		end
	end
	self.itemsData, _ENV = ipairs(self.itemsData)
	if not self.isInInstanceView then
		self:clearCache()
	else
		self.scrollView:scrollToBottom(0, false)
	end
	local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
	if (self.chatChannel == gChatChannel.KINGDOM or self.chatChannel == gChatChannel.ALLIANCE or self.chatChannel == gChatChannel.TEAM) and self.chatSet == gChatSet.TOTAL then
		_ENV = false
		;(false).chatChannel = self.chatChannel
		;(false).chatSet = self.chatSet
		chatUnReadMgr:reqReadChatMsg(false)
	end
end
function chatScrollView:clearCache()
	chatNodeCacheMgr.clearCache(self.tableSpare)
end
function chatScrollView:updateNewNumber()
	if self.newNumber > 0 then
		self.btn_new_number:setVisible(true)
		self.txt_new_number:setString(self.newNumber)
	else
		self.btn_new_number:setVisible(false)
	end
end
function chatScrollView:onTouchNewNumber(target, event)
	if event == ccui.TouchEventType.ended then
		self.scrollView:scrollToBottom(0.3, true)
	end
end
return chatScrollView
