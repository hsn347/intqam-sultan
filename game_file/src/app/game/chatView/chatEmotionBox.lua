local chatFunctions = include("chatFunctions")
local lordLocalData = include("lordLocalData")
local mailFunctions = include("mailFunctions")
local chatConst = include("chatConst")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local maxWidth = 600
local minHeight = 105
local deltaTopAvatar = 5
local deltaSideAvatar = 10
local deltaSideChatBg = 110
local deltaTopChatBg = 35
local deltaSideNameBox = 135
local deltaTopNameBox = 10
local deltaChatTipBg = 10
local sizeChatTip = cc.size(61, 16)
local deltaCheckSendTime = 5
local deltaKingCapHeight = 50
local chatEmotionBox = class("chatEmotionBox", function(target)
	if target == nil then
		return display.newNode()
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatEmotionBox:ctor()
	self.singleIsMoved = false
	self.ChatPanel = ccui.Layout:create()
	self.ChatPanel:setAnchorPoint(cc.p(0, 0))
	self.ChatPanel:setPosition(cc.p(0, 0))
	self.ChatPanel:addTo(self)
	self.ChatPanel:setTouchEnabled(true)
	self.ChatPanel:setSwallowTouches(false)
	self.ChatPanel:setContentSize(cc.size(600, 105))
	self.ChatPanel:addTouchEventListener(handler(self, self.onChatPanel))
	self.playerAvatarBoxNode = SoraDCreatePanel("playerAvatarBox")
	self.playerAvatarBoxNode:setPosition(cc.p(10, 0))
	self.playerAvatarBoxNode:addTo(self.ChatPanel)
	self.playerAvatarBoxNode:setBtnTouchEnabled(false)
	self.playerNameBoxNode = SoraDCreatePanel("playerNameBox")
	self.playerNameBoxNode:setPosition(cc.p(140, 71))
	self.playerNameBoxNode:addTo(self.ChatPanel)
	self.playerChatEmotionNode = SoraDCreatePanel("playerChatEmotion")
	self.playerChatEmotionNode:setPosition(cc.p(110, 0))
	self.playerChatEmotionNode:addTo(self.ChatPanel)
	local itemSize = self.ChatPanel:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
end
function chatEmotionBox:initWithData(data)
	self.itemData = data
	if self.playerAvatarBoxNode then
		local imgHead = lordLocalData.getHead(data.imageId)
		lordLocalData = data.imageId
		data.imageId.playerId = data.playerId
		data.imageId.imageId = data.imageId
		data.imageId.avatar = data.avatarUrl
		data.imageId.imgPlayer = imgHead
		data.imageId.chatType = data.chatType
		data.imageId.alv = data.alv
		data.imageId.isKing = data.isKing
		data.imageId.isLegendKing = data.isLegendKing
		data.imageId.isLegendForSepKing = data.isLegendForSepKing
		local data.imageId.isHegemon, avatarBoxData = data.isHegemon, data.imageId
		self.playerAvatarBoxNode:initWithData(avatarBoxData)
	end
	if self.playerNameBoxNode then
		local playerName = mailFunctions:getWrappedName(data.alliance, data.nickName)
		lordLocalData = mailFunctions
		mailFunctions.align = data.align
		mailFunctions.isVip = data.isVip
		mailFunctions.vipLv = data.vipLv
		mailFunctions.name = playerName
		mailFunctions.isGM = data.isGM
		local mailFunctions.kid, nameboxData = data.kid, mailFunctions
		self.playerNameBoxNode:initWithData(nameboxData)
		if data.chatType == 2 then
		end
	end
	if self.playerChatEmotionNode then
		lordLocalData = self.playerChatEmotionNode
		self.playerChatEmotionNode.align = data.align
		self.playerChatEmotionNode.playerId = data.playerId
		self.playerChatEmotionNode.chatId = data.chatId
		self.playerChatEmotionNode.content = data.content
		self.playerChatEmotionNode.info = data.time
		self.playerChatEmotionNode.isKing = data.isKing
		self.playerChatEmotionNode.isLegendKing = data.isLegendKing
		self.playerChatEmotionNode.isLegendForSepKing = data.isLegendForSepKing
		self.playerChatEmotionNode.isHegemon = data.isHegemon
		local self.playerChatEmotionNode.isSendToAll, chatEmotionData = data.isSendToAll, self.playerChatEmotionNode
		self.playerChatEmotionNode:initWithData(chatEmotionData)
	end
	local emotionContentHeight = self.playerChatEmotionNode:getItemHeight()
	local emotionContentWidth = self.playerChatEmotionNode:getItemWidth()
	local totalHeight = emotionContentHeight + deltaTopChatBg + ((data.isKing or data.isLegendKing or data.isLegendForSepKing or data.isHegemon) and deltaKingCapHeight or 0)
	local deltaKing = (data.isKing or data.isLegendForSepKing or data.isLegendKing or data.isHegemon) and deltaKingCapHeight or 0
	if totalHeight < minHeight then
		totalHeight = minHeight
	end
	self.itemWidth = maxWidth
	self.itemHeight = totalHeight
	if data.align == 0 then
		self.playerAvatarBoxNode:setPosition(cc.p(deltaSideAvatar, self.itemHeight - deltaTopAvatar - self.playerAvatarBoxNode:getItemHeight() - deltaKing))
		self.playerChatEmotionNode:setPosition(cc.p(deltaSideChatBg, self.itemHeight - deltaTopChatBg - self.playerChatEmotionNode:getItemHeight() - deltaKing))
		self.playerNameBoxNode:setPosition(cc.p(deltaSideNameBox, self.itemHeight - deltaTopNameBox - self.playerNameBoxNode:getItemHeight() - deltaKing))
	elseif data.align == 1 then
		self.playerAvatarBoxNode:setPosition(cc.p(self.itemWidth - deltaSideAvatar - self.playerAvatarBoxNode:getItemWidth(), self.itemHeight - deltaTopAvatar - self.playerAvatarBoxNode:getItemHeight() - deltaKing))
		self.playerChatEmotionNode:setPosition(cc.p(self.itemWidth - deltaSideChatBg - self.playerChatEmotionNode:getItemWidth(), self.itemHeight - deltaTopChatBg - self.playerChatEmotionNode:getItemHeight() - deltaKing))
		self.playerNameBoxNode:setPosition(cc.p(self.itemWidth - deltaSideNameBox - self.playerNameBoxNode:getItemWidth(), self.itemHeight - deltaTopNameBox - self.playerNameBoxNode:getItemHeight() - deltaKing))
	end
	self:updateNetStatus()
	self:updateWarnStatus()
	self.ChatPanel:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function chatEmotionBox:onChatPanel(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local touchEndPos = target:getTouchEndPosition()
		if true == self.playerAvatarBoxNode:getIsTouchPointInPlayer(touchEndPos) then
			print("点击在了头像上~")
			if self.itemData.dataType == gChatDataType.dataType_emotion and chatFunctions.getIsPlayerSelf(self.itemData.playerId) then
			else
				_ENV = self.itemData.playerId
				self.itemData.playerId.msg = "MESSAGE_CHAT_SHOW_CHAT_MENU"
				self.itemData.playerId.itemData = self.itemData
				self.itemData.playerId.sender = target
				SoraDSendMessage(self.itemData.playerId)
			end
			SoraDPlaySound()
			return
		elseif true == self.playerChatEmotionNode:getIsTouchPointInPlayer(touchEndPos) then
			SoraDPlaySound()
			if self.itemData.dataType == gChatDataType.dataType_emotion and chatFunctions.getIsPlayerSelf(self.itemData.playerId) then
			else
				_ENV = self.itemData.playerId
				self.itemData.playerId.msg = "MESSAGE_CHAT_SHOW_CHAT_MENU"
				self.itemData.playerId.itemData = self.itemData
				self.itemData.playerId.sender = target
				SoraDSendMessage(self.itemData.playerId)
			end
			print("点到聊天表情")
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatEmotionBox:getItemWidth()
	return self.itemWidth
end
function chatEmotionBox:getItemHeight()
	return self.itemHeight
end
function chatEmotionBox:showSending()
	self:hideWarning()
	if self.imgSending then
		self.imgSending:setVisible(true)
	else
		self.imgSending = ccui.ImageView:create()
		self.imgSending:loadTexture("icon_circle_small.png", ccui.TextureResType.plistType)
		self.ChatPanel:addChild(self.imgSending, 1)
	end
	self.imgSending:stopAllActions()
	local actionRotateBy = cc.RotateBy:create(1.0, 360)
	local repeatForever = cca.repeatForever(actionRotateBy)
	self.imgSending:runAction(repeatForever)
	self.imgSending:setPosition(self:getIconTipPos())
end
function chatEmotionBox:showWaring()
	self:hideSending()
	if self.btnWarning then
		self.btnWarning:setVisible(true)
	else
		self.btnWarning = ccui.Button:create()
		self.btnWarning:setSwallowTouches(true)
		self.btnWarning:setTouchEnabled(true)
		self.btnWarning:loadTextures("icon_warning_small.png", "icon_warning_small.png", "", ccui.TextureResType.plistType)
		self.btnWarning:setPressedActionEnabled(true)
		self.btnWarning:addTouchEventListener(handler(self, self.btnReSend))
		self.ChatPanel:addChild(self.btnWarning, 1)
	end
	self.btnWarning:setPosition(self:getIconTipPos())
end
function chatEmotionBox:hideSending()
	if self.imgSending then
		self.imgSending:setVisible(false)
		self.imgSending:stopAllActions()
	end
end
function chatEmotionBox:hideWarning()
	if self.btnWarning then
		self.btnWarning:setVisible(false)
	end
end
function chatEmotionBox:getIconTipPos()
	local chatContentHeight = self.playerChatEmotionNode:getItemHeight()
	local chatContentWidth = self.playerChatEmotionNode:getItemWidth()
	local pos
	if self.itemData.align == 0 then
		local posx = deltaSideChatBg + chatContentWidth + deltaChatTipBg + sizeChatTip.width / 2
		local posy = self.itemHeight - (deltaTopChatBg + chatContentHeight / 2)
		pos = cc.p(posx, posy)
	else
		local posx = self.itemWidth - (deltaSideChatBg + chatContentWidth + deltaChatTipBg + sizeChatTip.width / 2)
		local posy = self.itemHeight - (deltaTopChatBg + chatContentHeight / 2)
		pos = cc.p(posx, posy)
	end
	return pos
end
function chatEmotionBox:btnReSend(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDShowMsgBox(i18n("common_text_896"), i18n("common_text_054"), nil, handler(self, self.confirmSend))
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatEmotionBox:confirmSend(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		print("重新发送....")
		self:showSending()
		self.itemData.netStatus = chatConst.netStatus.sending
		local message = self.itemData.content
		local messageType = gChatTypeDef.chat_content_text
		if self.itemData.dataType == 0 then
			messageType = gChatTypeDef.chat_content_text
		elseif self.itemData.dataType == 1 then
			messageType = gChatTypeDef.chat_content_expression
		end
		local chatIndex = self.itemData.chatIndex
		_ENV = nil
		;(nil).message = message
		;(nil).messageType = messageType
		;(nil).chatIndex = chatIndex
		chatSendMgr:reSendMessage(nil)
	end
end
function chatEmotionBox:updateNetStatus()
	if self.itemData.netStatus == chatConst.netStatus.default or self.itemData.netStatus == nil then
		self:hideNetStatus()
	elseif self.itemData.netStatus == chatConst.netStatus.sending then
		self:showSending()
	else
		print("TODO:chatEmotionBox:updateNetStatus()", self.itemData.netStatus)
	end
end
function chatEmotionBox:updateWarnStatus()
	if self.itemData.warnStatus == chatConst.warnStatus.default or self.itemData.warnStatus == nil then
		self:hideWarnStatus()
	elseif self.itemData.warnStatus == chatConst.warnStatus.warn_sending then
		self:showWaring()
	else
		print("TODO:chatEmotionBox:updateWarnStatus()", self.itemData.warnStatus)
	end
end
function chatEmotionBox:hideNetStatus()
	self:hideSending()
end
function chatEmotionBox:hideWarnStatus()
	self:hideWarning()
end
return chatEmotionBox
