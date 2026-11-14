local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local chatFunctions = include("chatFunctions")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatConst = include("chatConst")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatRoomView = class("chatRoomView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomView")
	end
	return target
end)
_ENV = "chatRoomView"
;("chatRoomView").addScrollH = 80
;("chatRoomView").numPageSize = 7
local ("chatRoomView").dayColor, _defaultParam = cc.c3b(172, 151, 129), "chatRoomView"
function chatRoomView:ctor()
	self.isHideCurrentSceneView = true
	self.isHidePrePanel = true
	self.chatChannel = gChatChannel.CHATROOM
	self.chatSet = gChatSet.TOTAL
	self.targetType = gMailType.CHAT
	self.target = 0
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg_node", true)
	self.maskArea = SoraDGetChildByName(self, "Size_Btn_Check_Not_EmotionArea")
	local black_bg = SoraDGetChildByName(self, "Top_Size_Black_Bg")
	if black_bg then
		black_bg:setLocalZOrder(-10)
	end
	if self.maskArea then
		dump(self.maskArea:getContentSize(), "掩盖层的大小")
		self.maskArea:setTouchEnabled(true)
		self.maskArea:setSwallowTouches(true)
		if device.platform == "mac" then
			self.maskArea:setSwallowTouches(false)
		end
		self.maskArea:setVisible(false)
		self.maskArea:addTouchEventListener(handler(self, self.OnMaskArea))
		self.maskArea:setPosition(cc.p(0, 0))
	end
	self.maskArea:setPositionY(self.maskArea:getPositionY() + 90)
	self.oriMaskAreaPos = cc.p(self.maskArea:getPosition())
	self.btnRoom = SoraDGetChildByName(self, "Button_Room")
	if self.btnRoom then
		self.btnRoom:addTouchEventListener(handler(self, self.onBtnRoom))
	end
	self.bottomViewNode = SoraDGetExtendChildFromCCSByName(self, "CCS_chatBottomView_node")
	self.bottomViewNode:setMaxCharCount(gChatMaxLength.normalChatLength)
	if self.bottomViewNode then
		self.bottomViewNode:setViewType("chatRoomView")
		self.bottomViewNode:setChatInputType(chatConst.ChatInputType.Input_Text_Emo_Audio)
		self.bottomViewNode:setChatDelegate(self)
	end
	self.chatScrollViewSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	local realScroll = self.chatScrollViewSingle.scrollView
	local scrollSize = realScroll:getContentSize()
	realScroll:setContentSize(cc.size(scrollSize.width, scrollSize.height + _defaultParam.addScrollH))
	self.oriScrollViewSize = realScroll:getContentSize()
	realScroll:setInnerContainerSize(realScroll:getContentSize())
	dump(self.chatScrollViewSingle.scrollView:getContentSize(), "chatRoomScrollView Size:")
	self.chatEmotionPageView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatEmotionPageView_node")
	self.chatEmotionPageView:setVisible(false)
	self.chatEmotionPageView:init(self)
	self.oriChatScrollViewPos = cc.p(self.chatScrollViewSingle:getPositionX(), self.chatScrollViewSingle:getPositionY())
	self.oriChatEmotionPageViewPos = cc.p(self.chatEmotionPageView:getPositionX(), self.chatEmotionPageView:getPositionY())
	self.oriChatBgPos = cc.p(self.ccsNightBg.chatBg:getPositionX(), self.ccsNightBg.chatBg:getPositionY())
	self.ccsNightBg:updateTheme()
end
function chatRoomView:initWithData(data)
	self.itemData = data
	local targetType = gMailType.CHAT
	local target = data.crid
	self.crid = data.crid
	local strTitle = data.crname
	self:setRoomTitle(strTitle)
	self.targetType = targetType
	self.target = target
	self.key = self.target
	chatDataMgr:pushChatChannelInfo()
	_ENV = chatDataMgr.pushChatChannelInfo
	chatDataMgr.pushChatChannelInfo.chatChannel = self.chatChannel
	chatDataMgr.pushChatChannelInfo.chatSet = self.chatSet
	chatDataMgr.pushChatChannelInfo.key = self.key
	chatDataMgr.pushChatChannelInfo.targetType = self.targetType
	chatDataMgr.pushChatChannelInfo.target = self.target
	local chatDataMgr.pushChatChannelInfo.crid, channelInfo = self.crid, chatDataMgr.pushChatChannelInfo
	chatDataMgr:setChatChannelInfo(channelInfo)
	self.initSuccess = true
	chatDataMgr:cleanChatRoomData(self.key)
	self.bottomViewNode:setTargetType(targetType)
	self.bottomViewNode:setChatRoomId(data.crid)
	local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(data.crid)
	print("chatRoom.state ", chatRoom.state)
	if chatRoom.state == gChatRoomState.KICKED then
		self.btnRoom:setVisible(false)
	else
		self.btnRoom:setVisible(true)
	end
	_ENV = self.btnRoom.setVisible
	self.btnRoom.setVisible.chatChannel = self.chatChannel
	self.btnRoom.setVisible.chatSet = self.chatSet
	self.btnRoom.setVisible.key = self.key
	self.btnRoom.setVisible.ignoreCloseLoading = true
	self.btnRoom.setVisible.num = _defaultParam.numPageSize
	local self.btnRoom.setVisible.crid, channelData = self.crid, self.btnRoom.setVisible
	self.chatScrollViewSingle:initWithChatChannel(channelData)
	self:doRequestHistoryMsg()
end
function chatRoomView:setRoomTitle(roomTitle)
	local limitW = 400
	self.title:setTitle(roomTitle)
	if limitW < self.title.title:getContentSize().width then
		local retString, _ = SoraDConvertOmissionText(limitW, roomTitle, self.title.title:getFontSize())
		self.title:setTitle(retString)
	end
end
function chatRoomView:doRequestHistoryMsg()
	_defaultParam = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = self.chatSet
	;(nil).key = self.key
	;(nil).num = _defaultParam.numPageSize
	local (nil).crid, param = self.crid, nil
	chatSendMgr:requestHistory(param)
end
function chatRoomView:getTargetType()
	return self.targetType
end
function chatRoomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_QUIT_SUCCESS", handler(self, self.sMsgQuitSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_MODIFY_NAME_SUCCESS", handler(self, self.sMsgModifyNameSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_INFOVIEW_UPDATE_KICKED", handler(self, self.sMsgUpdateKicked))
end
function chatRoomView:chatSendOneMessage(target, data)
	print("function chatRoomView:chatSendOneMessage(target, data) ---------------------------------")
	local message = data.message
	local messageType = data.messageType
	local packetId = data.packetId
	local grupid = data.grupid
	local id = data.id
	local kingdomSettingAPI = include("kingdomSettingAPI")
	local canChat, lv = kingdomSettingAPI:canSendChatMail()
	if not canChat then
		_ENV = nil
		;(nil).lv = lv
		SoraDShowMsgTip(i18n("common_text_3668", nil))
		return
	end
	local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(self.itemData.crid)
	if chatRoom and chatRoom.state == gChatRoomState.KICKED then
		SoraDShowMsgTip(i18n("common_text_2213"))
		return
	end
	if messageType == gChatTypeDef.chat_content_text then
		messageType = gChatRoomChatType.TEXT
	elseif messageType == gChatTypeDef.chat_content_expression then
		messageType = gChatRoomChatType.EMOJI
	end
	if messageType == gChatRoomChatType.EMOJI then
		local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.chatRoomMsg)
		if canSend == false then
			return
		end
		_ENV = i18n("common_text_2213")
		i18n("common_text_2213").grupid = grupid
		i18n("common_text_2213").id = id
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, i18n("common_text_2213"))
	end
	if type(message) == "string" then
		message = string.ltrim(message)
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
			message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
		end
		if message == nil or message == "" then
			return
		end
	end
	local isKing = chatFunctions:getIsSelfKing()
	local isLegendKing = chatFunctions:getIsSelfLegendKing()
	local isKingStar = chatFunctions:getIsSelfKingStar()
	local isHegemon = chatFunctions:getIsSelfHegemon()
	local dressCtrl = gametop.playertop_:getModule("dressCtrl")
	local dressBubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
	local dressAvatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
	local dressHeadWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
	local bubbleId = dressBubbleId
	local avatarFrameId = dressAvatarFrameId
	local headWearId = dressHeadWearId
	if isKing == true then
		if bubbleId == gBubbleId.BUBBLE_ID_NORMAL then
			bubbleId = gBubbleId.BUBBLE_ID_KING
		end
		if headWearId == gHeadWearId.HEAD_ID_NORMAL then
			headWearId = gHeadWearId.HEAD_ID_KING
		end
	end
	local crid = self.itemData.crid
	_ENV = i18n("common_text_2213")
	i18n("common_text_2213").chatType = messageType
	i18n("common_text_2213").content = message
	i18n("common_text_2213").packetId = packetId
	i18n("common_text_2213").isKing = isKing
	i18n("common_text_2213").isLegendKing = isLegendKing
	i18n("common_text_2213").isLegendForSepKing = isKingStar
	i18n("common_text_2213").isHegemon = isHegemon
	i18n("common_text_2213").bubbleId = bubbleId
	i18n("common_text_2213").avatarFrameId = avatarFrameId
	local i18n("common_text_2213").headWearId, msgData = headWearId, i18n("common_text_2213")
	dump(msgData, "发送的聊天室数据--------")
	chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
end
function chatRoomView:chatScrollViewPosOffset(target, data)
	local offsetY = data.offsetY
	local duration = data.duration
	local deltaHeight = data.deltaHeight
	local isShowKeyboardMask = data.isShowKeyboardMask
	print("scroll offsetY: " .. offsetY)
	local isMoveTo = data.isMoveTo
	if isMoveTo then
		self:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
		return
	else
		self:doAnimationChatScrollViewScrollOffset(duration, offsetY, deltaHeight, isShowKeyboardMask)
	end
end
function chatRoomView:chatScrollViewPosReset(target, data)
	local duration = data.duration
	local offsetY = data.offsetY
	local isShowKeyboardMask = data.isShowKeyboardMask
	local actMoveTo = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMoveTo)
	local actMoveToChatBgReset = cca.moveTo(duration, self.oriChatBgPos.x, self.oriChatBgPos.y)
	self.ccsNightBg.chatBg:stopAllActions()
	self.ccsNightBg.chatBg:runAction(actMoveToChatBgReset)
	if isShowKeyboardMask then
		print("取消吞没消息")
		self.maskArea:setVisible(false)
		self.maskArea:stopAllActions()
		local actMoveTo5 = cca.moveTo(duration, self.oriMaskAreaPos.x, self.oriMaskAreaPos.y)
		self.maskArea:runAction(actMoveTo5)
	end
end
function chatRoomView:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
	print("聊天滚动内容:执行MoveTo, offsetY = " .. offsetY)
	local actMove1 = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMove1)
	local actMove6 = cca.moveTo(duration, self.oriChatBgPos.x, self.oriChatBgPos.y + offsetY)
	self.ccsNightBg.chatBg:stopAllActions()
	self.ccsNightBg.chatBg:runAction(actMove6)
	if isShowKeyboardMask then
		self.maskArea:setSwallowTouches(true)
		print("吞没了消息")
		self.maskArea:setVisible(true)
		local bottomViewHeight = self.bottomViewNode:getBottomViewHeight()
		local targetHeight = self.oriMaskAreaPos.y + offsetY + bottomViewHeight
		print("掩盖层移动到高度: " .. targetHeight)
		local actMove7 = cca.moveTo(duration, self.oriMaskAreaPos.x, targetHeight)
		self.maskArea:stopAllActions()
		self.maskArea:runAction(actMove7)
	end
end
function chatRoomView:doAnimationChatScrollViewScrollOffset(duration, _adjustHeight, deltaHeight, isShowKeyboardMask)
	local deltaHeight = deltaHeight or 0
	local actMoveBy = cca.moveBy(duration, 0, _adjustHeight)
	local actMoveBy2 = actMoveBy:clone()
	self.chatScrollViewSingle:runAction(actMoveBy)
	if isShowKeyboardMask then
		self.maskArea:runAction(actMoveBy:clone())
	end
	print("内容框改变的区域大小引起滚动区域改变:" .. deltaHeight)
	self.chatScrollViewSingle:resizeContentSize(cc.size(self.oriScrollViewSize.width, self.oriScrollViewSize.height - deltaHeight))
end
function chatRoomView:onEnterPanel()
	print("chatRoomView: onEnterPanel")
end
function chatRoomView:onExitPanel()
	print("TODO:聊天室退出，需要发起阅读聊天室的请求")
	chatDataMgr:cleanChatRoomData(self.key)
	chatDataMgr:setChatChannelInfo(chatDataMgr:popChatChannelInfo())
	chatAudioMgr:stopCurPlayAudio()
	chatAudioMgr:resumeMusic()
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
	end)
end
function chatRoomView:openEmotionUI(target, data)
	print("打开表情页面")
	self.isOpenEmotion = true
	local offsetY = math.abs(self.oriChatEmotionPageViewPos.y)
	local deltaTextHeight = 0
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = offsetY + deltaTextHeight
	;(nil).isMoveTo = true
	self:chatScrollViewPosOffset(self, nil)
	local actMoveTo1 = cca.moveTo(0.25, 320, offsetY)
	self.bottomViewNode:stopAllActions()
	self.bottomViewNode:runAction(actMoveTo1)
	print("掩盖层的目标高度: " .. offsetY)
	local actMoveTo = cca.moveTo(0.25, 0, offsetY + self.oriMaskAreaPos.y)
	self.maskArea:stopAllActions()
	self.maskArea:setVisible(true)
	self.maskArea:setSwallowTouches(true)
	self.maskArea:runAction(actMoveTo)
	local actMoveTo2 = cca.moveTo(0.25, 0, 0)
	self.chatEmotionPageView:setVisible(true)
	self.chatEmotionPageView:stopAllActions()
	self.chatEmotionPageView:runAction(actMoveTo2)
end
function chatRoomView:hideEmotionUI(target, data)
	print("隐藏表情页面")
	local deltaHeight = 0
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = deltaHeight
	self:chatScrollViewPosReset(self, nil)
	local actMoveTo1 = cca.moveTo(0.25, self.oriChatEmotionPageViewPos.x, self.oriChatEmotionPageViewPos.y)
	self.chatEmotionPageView:setVisible(false)
	self.chatEmotionPageView:stopAllActions()
	self.chatEmotionPageView:runAction(actMoveTo1)
	local actMovTo2 = cca.moveTo(0.25, 0, self.oriMaskAreaPos.y)
	self.maskArea:stopAllActions()
	self.maskArea:runAction(actMovTo2)
	local actMoveTo = cca.moveTo(0.25, 320, 0)
	self.bottomViewNode:stopAllActions()
	self.bottomViewNode:runAction(actMoveTo)
	self.bottomViewNode:switchBtn(false)
end
function chatRoomView:OnMaskArea(target, eventType)
	if eventType == ccui.TouchEventType.began then
		if self.isOpenEmotion then
			self:hideEmotionUI(nil, nil)
			self.maskArea:setVisible(false)
			self.isOpenEmotion = false
		end
		if self.isOpenKeyBoard then
			self.maskArea:setVisible(false)
			_ENV = self.maskArea
			self.maskArea.msg = "MESSAGE_CHAT_CLOSE_IME"
			self.maskArea.viewType = "chatRoomView"
			SoraDSendMessage(self.maskArea)
			self.isOpenKeyBoard = false
			if self.onKebordHideDelegate then
				self.onKebordHideDelegate()
			end
		end
	end
end
function chatRoomView:showKeyboardMask(target, data)
	self.isOpenKeyBoard = true
	self.maskArea:setVisible(true)
	if self.isOpenEmotion then
		self:hideEmotionUI(nil, nil)
		self.isOpenEmotion = false
	end
end
function chatRoomView:hideKeyboardMask(target, data)
	local delayTime = data.delayTime
	if delayTime ~= nil then
		local delay = cca.delay(delayTime)
		local callFunc1 = cca.callFunc(function()
			print("设置掩盖层不可见，延迟时间: ", delayTime)
			self.isOpenKeyBoard = false
			if self.onKebordHideDelegate then
				self.onKebordHideDelegate()
			end
			self.maskArea:setVisible(false)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = delay
		;(nil)[2] = callFunc1
		self.maskArea:runAction(cca.seq(nil))
	else
		self.maskArea:setVisible(false)
		self.isOpenKeyBoard = false
		if self.onKebordHideDelegate then
			self.onKebordHideDelegate()
		end
	end
end
function chatRoomView:getChatRoomId()
	return self.itemData.crid
end
function chatRoomView:onBtnRoom(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("打开聊天室信息界面-----------------")
		local crid = self.itemData.crid
		local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(crid)
		_ENV = nil
		;(nil).chatRoom = chatRoom
		uiManager:show("ChatRoomInfoView", nil)
	end
end
function chatRoomView:getTarget()
	return self.target
end
function chatRoomView:sMsgQuitSuccess(target, data)
	local delCrid = data.crid
	if self.itemData.crid == delCrid then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_ROOM_CLOSE_INFOVIEW"
		SoraDSendMessage(nil)
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function chatRoomView:sMsgModifyNameSuccess(target, data)
	local crid = data.crid
	if self.itemData.crid == crid then
		local newName = data.newName
		self.itemData.crname = newName
		self:setRoomTitle(newName)
	end
end
function chatRoomView:sMsgUpdateKicked(target, data)
	local crid = data.crid
	if self.itemData.crid == crid then
		local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(data.crid)
		if chatRoom.state == gChatRoomState.KICKED then
			self.btnRoom:setVisible(false)
		else
			self.btnRoom:setVisible(true)
		end
	end
end
return chatRoomView
