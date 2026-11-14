local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mailLogic = include("mailLogic")
local chatFunctions = include("chatFunctions")
local chatConst = include("chatConst")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
_ENV = gChatMgrs
gChatMgrs.addScrollH = 80
gChatMgrs.numPageSize = 7
local gChatMgrs.dayColor, _defaultParam = cc.c3b(172, 151, 129), gChatMgrs
local mailChatView = class("mailChatView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailChatView")
	end
	return target
end)
function mailChatView:ctor()
	self.isHideCurrentSceneView = true
	self.isHidePrePanel = true
	self.chatChannel = gChatChannel.MAIL
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
	self.bottomViewNode = SoraDGetExtendChildFromCCSByName(self, "CCS_chatBottomView_node")
	if self.bottomViewNode then
		self.bottomViewNode:setMaxCharCount(gChatMaxLength.normalChatLength)
		self.bottomViewNode:setViewType("mailChatView")
		self.bottomViewNode:setChatInputType(chatConst.ChatInputType.Input_Text_Emo_Audio)
		self.bottomViewNode:setChatDelegate(self)
	end
	self.chatScrollViewSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	local realScroll = self.chatScrollViewSingle.scrollView
	local scrollSize = realScroll:getContentSize()
	realScroll:setContentSize(cc.size(scrollSize.width, scrollSize.height + _defaultParam.addScrollH))
	self.oriScrollViewSize = realScroll:getContentSize()
	realScroll:setInnerContainerSize(realScroll:getContentSize())
	self.chatEmotionPageView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatEmotionPageView_node")
	self.chatEmotionPageView:setVisible(false)
	self.chatEmotionPageView:init(self)
	self.oriChatScrollViewPos = cc.p(self.chatScrollViewSingle:getPositionX(), self.chatScrollViewSingle:getPositionY())
	self.oriChatEmotionPageViewPos = cc.p(self.chatEmotionPageView:getPositionX(), self.chatEmotionPageView:getPositionY())
	self.oriChatBgPos = cc.p(self.ccsNightBg.chatBg:getPositionX(), self.ccsNightBg.chatBg:getPositionY())
	self.ccsNightBg:updateTheme()
end
function mailChatView:initWithData(data)
	local targetType = data.targetType
	local target = data.target
	local nickName = data.nickName
	local allianceAbbr = data.allianceAbbr
	self.mailSetType = mailLogic.getMailSetType(targetType)
	self.targetType = targetType
	self.target = target
	local key, mailTitle
	if data.targetType == gMailType.CHAT then
		mailTitle = mailFunctions:getWrappedName(allianceAbbr, nickName)
		key = chatDataMgr:getMailChatKey(self.chatChannel, self.chatSet, gMailType.CHAT, target)
	elseif data.targetType == gMailType.ALLIANCE_GROUP_MAIL then
		mailTitle = i18n("mail_text_06")
		key = chatDataMgr:getMailChatKey(self.chatChannel, self.chatSet, gMailType.ALLIANCE_GROUP_MAIL, target)
		self.bottomViewNode:setChatInputType(chatConst.ChatInputType.Input_Text_Emo)
	end
	self.key = key
	chatDataMgr:pushChatChannelInfo()
	mailLogic = chatDataMgr.pushChatChannelInfo
	chatDataMgr.pushChatChannelInfo.chatChannel = self.chatChannel
	chatDataMgr.pushChatChannelInfo.chatSet = self.chatSet
	chatDataMgr.pushChatChannelInfo.key = self.key
	chatDataMgr.pushChatChannelInfo.targetType = self.targetType
	chatDataMgr.pushChatChannelInfo.target = self.target
	local chatDataMgr.pushChatChannelInfo.mailSetType, channelInfo = self.mailSetType, chatDataMgr.pushChatChannelInfo
	chatDataMgr:setChatChannelInfo(channelInfo)
	self.initSuccess = true
	chatDataMgr:cleanMailChatData(self.key)
	if string.len(mailTitle) == 0 then
		mailTitle = tostring(target)
	end
	self.title:setTitle(mailTitle)
	self.bottomViewNode:setTargetType(targetType)
	mailLogic, self.nickName = data.nickName, data.nickName
	data.nickName.chatChannel = self.chatChannel
	data.nickName.chatSet = self.chatSet
	data.nickName.key = self.key
	data.nickName.ignoreCloseLoading = true
	data.nickName.num = _defaultParam.numPageSize
	local data.nickName.mailSetType, channelData = self.mailSetType, data.nickName
	self.chatScrollViewSingle:initWithChatChannel(channelData)
	self:doRequestHistoryMsg()
end
function mailChatView:doRequestHistoryMsg()
	_defaultParam = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = self.chatSet
	;(nil).key = self.key
	;(nil).num = _defaultParam.numPageSize
	local (nil).mailSetType, param = self.mailSetType, nil
	self.chatScrollViewSingle.isWaitFirstHistory = true
	chatSendMgr:requestHistory(param)
end
function mailChatView:getTargetType()
	return self.targetType
end
function mailChatView:getKey()
	return self.key
end
function mailChatView:chatSendOneMessage(target, data)
	if self.targetType == gMailType.CHAT or self.targetType == gMailType.ALLIANCE_GROUP_MAIL then
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canSendChatMail()
		if not canChat then
			_ENV = nil
			;(nil).lv = lv
			SoraDShowMsgTip(i18n("common_text_3668", nil))
			return
		end
	end
	local message = data.message
	local packetId = data.packetId
	local messageType = data.messageType
	local grupid = data.grupid
	local id = data.id
	if messageType == gChatTypeDef.chat_content_text then
		messageType = gChatMailContentType.content_text
	elseif messageType == gChatTypeDef.chat_content_expression then
		messageType = gChatMailContentType.content_emo
	end
	if self.targetType == gMailType.CHAT then
		if messageType == gChatMailContentType.content_emo then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.mailPrivateMsg)
			if canSend == false then
				return
			end
			_ENV = i18n("common_text_3668", nil)
			i18n("common_text_3668", nil).grupid = grupid
			i18n("common_text_3668", nil).id = id
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, i18n("common_text_3668", nil))
		end
	elseif self.targetType == gMailType.ALLIANCE_GROUP_MAIL and messageType == gChatMailContentType.content_emo then
		local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.mailAllianceMsg)
		if canSend == false then
			return
		end
		_ENV = i18n("common_text_3668", nil)
		i18n("common_text_3668", nil).grupid = grupid
		i18n("common_text_3668", nil).id = id
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, i18n("common_text_3668", nil))
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
	local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
	local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
	local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
	print("bubbleId = ", bubbleId, "headWearId = ", headWearId, ", avatarFrameId = ", avatarFrameId)
	_ENV = print
	print.contentType = messageType
	print.content = message
	print.packetId = packetId
	print.isKing = isKing
	print.isHegemon = isHegemon
	print.isLegendKing = isLegendKing
	print.isLegendForSepKing = isKingStar
	print.bubbleId = bubbleId
	print.headWearId = headWearId
	local print.avatarFrameId, content = avatarFrameId, print
	if self.targetType == gMailType.CHAT then
		mailCtrl:sendChatMail(self.target, content)
	elseif self.targetType == gMailType.ALLIANCE_GROUP_MAIL then
		content.isSendToAll = 1
		allianceMgr:reqSendAllianceAllMail(content)
		return
	end
end
function mailChatView:chatScrollViewPosOffset(target, data)
	local offsetY = data.offsetY
	local duration = data.duration
	local deltaHeight = data.deltaHeight
	local isShowKeyboardMask = data.isShowKeyboardMask
	local isMoveTo = data.isMoveTo
	if isMoveTo then
		self:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
		return
	else
		self:doAnimationChatScrollViewScrollOffset(duration, offsetY, deltaHeight, isShowKeyboardMask)
	end
end
function mailChatView:chatScrollViewPosReset(target, data)
	local duration = data.duration
	local offsetY = data.offsetY
	local isShowKeyboardMask = data.isShowKeyboardMask
	local actMoveTo = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMoveTo)
	local actMoveToChatBgReset = cca.moveTo(duration, 0, self.oriChatBgPos.y)
	self.ccsNightBg.node_night:stopAllActions()
	self.ccsNightBg.node_night:runAction(actMoveToChatBgReset)
	if isShowKeyboardMask then
		self.maskArea:setVisible(false)
		self.maskArea:stopAllActions()
		local actMoveTo5 = cca.moveTo(duration, self.oriMaskAreaPos.x, self.oriMaskAreaPos.y)
		self.maskArea:runAction(actMoveTo5)
	end
end
function mailChatView:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
	local actMove1 = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMove1)
	local actMove6 = cca.moveTo(duration, 0, self.oriChatBgPos.y + offsetY)
	self.ccsNightBg.node_night:stopAllActions()
	self.ccsNightBg.node_night:runAction(actMove6)
	if isShowKeyboardMask then
		self.maskArea:setSwallowTouches(true)
		self.maskArea:setVisible(true)
		local bottomViewHeight = self.bottomViewNode:getBottomViewHeight()
		local targetHeight = self.oriMaskAreaPos.y + offsetY + bottomViewHeight
		local actMove7 = cca.moveTo(duration, self.oriMaskAreaPos.x, targetHeight)
		self.maskArea:stopAllActions()
		self.maskArea:runAction(actMove7)
	end
end
function mailChatView:doAnimationChatScrollViewScrollOffset(duration, _adjustHeight, deltaHeight, isShowKeyboardMask)
	local deltaHeight = deltaHeight or 0
	local actMoveBy = cca.moveBy(duration, 0, _adjustHeight)
	local actMoveBy2 = actMoveBy:clone()
	self.chatScrollViewSingle:runAction(actMoveBy)
	if isShowKeyboardMask then
		self.maskArea:runAction(actMoveBy:clone())
	end
	self.chatScrollViewSingle:resizeContentSize(cc.size(self.oriScrollViewSize.width, self.oriScrollViewSize.height - deltaHeight))
end
function mailChatView:onEnterPanel()
	print("mailChatView: onEnterPanel")
end
function mailChatView:onExitPanel()
	local mailType = self.targetType
	local target = self.target
	mailCtrl:viewMailList(self.mailSetType, self.key)
	chatDataMgr:cleanMailChatData(self.key)
	chatDataMgr:setChatChannelInfo(chatDataMgr:popChatChannelInfo())
	chatAudioMgr:stopCurPlayAudio()
	chatAudioMgr:resumeMusic()
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
	end)
end
function mailChatView:openEmotionUI(target, data)
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
function mailChatView:hideEmotionUI(target, data)
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
function mailChatView:OnMaskArea(target, eventType)
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
			self.maskArea.viewType = "mailChatView"
			SoraDSendMessage(self.maskArea)
			self.isOpenKeyBoard = false
		end
	end
end
function mailChatView:doLock(isLock)
	self.btn_lock:setSelected(isLock)
end
function mailChatView:lockEvent(sender, event)
	if event == ccui.CheckBoxEventType.selected then
		mailCtrl:reqLockType(self.targetType, self.target)
		SoraDShowMsgTip(i18n("common_text_136"), "#quest_icon_1.png", sender)
	elseif event == ccui.CheckBoxEventType.unselected then
		mailCtrl:reqUnlockType(self.targetType, self.target)
		SoraDShowMsgTip(i18n("common_text_137"), "#quest_icon_1.png", sender)
	end
end
function mailChatView:showKeyboardMask(target, data)
	self.isOpenKeyBoard = true
	self.maskArea:setVisible(true)
	if self.isOpenEmotion then
		self:hideEmotionUI(nil, nil)
		self.isOpenEmotion = false
	end
end
function mailChatView:hideKeyboardMask(target, data)
	local delayTime = data.delayTime
	if delayTime ~= nil then
		local delay = cca.delay(delayTime)
		local callFunc1 = cca.callFunc(function()
			self.isOpenKeyBoard = false
			self.maskArea:setVisible(false)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = delay
		;(nil)[2] = callFunc1
		self.maskArea:runAction(cca.seq(nil))
	else
		self.maskArea:setVisible(false)
		self.isOpenKeyBoard = false
	end
end
function mailChatView:getTarget()
	return self.target
end
function mailChatView:getChatKey(forceUpdate)
	return self.key
end
return mailChatView
