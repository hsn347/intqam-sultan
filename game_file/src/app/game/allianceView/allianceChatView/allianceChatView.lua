local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMsg = gametop.playertop_:getModule("allianceMsg")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatConst = include("chatConst")
local allianceChatView = class("allianceChatView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceChatView")
	end
	return target
end)
_ENV = "allianceChatView"
;("allianceChatView").addScrollH = 80
;("allianceChatView").dayColor = cc.c3b(172, 151, 129)
local ("allianceChatView").nightColor, _defaultParam = cc.c3b(84, 75, 64), "allianceChatView"
function allianceChatView:ctor()
	self.isHideCurrentSceneView = true
	self.chatChannel = gChatChannel.ALLIANCEMSG
	self.chatSet = gChatSet.TOTAL
	self.allianceId = 0
	self.maxCharCount = gChatMaxLength.allianceChatLength
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.title:setTitle(i18n("common_text_181"))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg_node", true)
	self.maskArea = SoraDGetChildByName(self, "Size_Btn_Check_Not_EmotionArea")
	self.maskArea:setLocalZOrder(100)
	if self.maskArea then
		print("---------掩盖层------------")
		dump(self.maskArea:getContentSize(), "掩盖层的大小")
		self.maskArea:setTouchEnabled(true)
		self.maskArea:setSwallowTouches(true)
		if device.platform == "mac" then
			self.maskArea:setSwallowTouches(false)
		end
		self.maskArea:setVisible(false)
		print("设置为不可见")
		self.maskArea:addTouchEventListener(handler(self, self.OnMaskArea))
		self.maskArea:setPosition(cc.p(0, 0))
	else
		print("不存在掩盖层")
	end
	self.maskArea:setPositionY(self.maskArea:getPositionY() + 90)
	self.oriMaskAreaPos = cc.p(self.maskArea:getPosition())
	self.bottomViewNode = SoraDGetExtendChildFromCCSByName(self, "CCS_chatBottomView_node")
	if self.bottomViewNode then
		self.bottomViewNode:setViewType("allianceChatView")
		self.bottomViewNode:setMaxCharCount(self.maxCharCount)
		self.bottomViewNode:setChatInputType(chatConst.ChatInputType.Input_Text)
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
	self.ccsNightBg:updateTheme()
end
function allianceChatView:initWithData(data)
	self.allianceId = data.allianceId
	local key = self:getChatKey(true)
	chatDataMgr:pushChatChannelInfo()
	chatDataMgr = chatDataMgr.pushChatChannelInfo
	chatDataMgr.pushChatChannelInfo.chatChannel = self.chatChannel
	chatDataMgr.pushChatChannelInfo.chatSet = self.chatSet
	chatDataMgr.pushChatChannelInfo.key = self.key
	local chatDataMgr.pushChatChannelInfo.allianceId, channelInfo = self.allianceId, chatDataMgr.pushChatChannelInfo
	chatDataMgr:setChatChannelInfo(channelInfo)
	chatDataMgr:cleanAllianceMsgData(self.key)
	self.initSuccess = true
	chatDataMgr = nil
	;(nil).nextIndex = 1
	;(nil).allianceId = self.allianceId
	chatDataMgr:setSetParam(self.chatChannel, self.chatSet, key, nil)
	chatDataMgr = chatDataMgr.setSetParam
	chatDataMgr.setSetParam.chatChannel = self.chatChannel
	chatDataMgr.setSetParam.chatSet = self.chatSet
	chatDataMgr.setSetParam.key = self.key
	local chatDataMgr.setSetParam.ignoreCloseLoading, channelData = true, chatDataMgr.setSetParam
	self.chatScrollViewSingle:initWithChatChannel(channelData)
	self:doRequestHistoryMsg()
end
function allianceChatView:doRequestHistoryMsg()
	chatSendMgr = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = self.chatSet
	local (nil).key, param = self.key, nil
	self.chatScrollViewSingle.isWaitFirstHistory = true
	chatSendMgr:requestHistory(param)
end
function allianceChatView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceChatView:chatSendOneMessage(target, data)
	local textContent = data.message
	local messageType = data.messageType
	if messageType == gChatTypeDef.chat_content_text then
		messageType = gAllianceChatMsgType.text
	elseif messageType == gChatTypeDef.chat_content_expression then
		messageType = gAllianceChatMsgType.emoticon
	end
	local kingdomSettingAPI = include("kingdomSettingAPI")
	local canChat, lv = kingdomSettingAPI:canLeaveMsgInAlliance()
	if not canChat then
		_ENV = nil
		;(nil).lv = lv
		SoraDShowMsgTip(i18n("common_text_3671", nil))
		return
	end
	textContent = string.ltrim(textContent)
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(textContent) then
		textContent = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(textContent)
	end
	if textContent == nil or textContent == "" then
		return
	end
	local aid = self.allianceId
	_ENV = gModuleMgr.sharedMgr("shieldedWordsltCtrl")
	gModuleMgr.sharedMgr("shieldedWordsltCtrl").contentType = messageType
	local gModuleMgr.sharedMgr("shieldedWordsltCtrl").content, content = textContent, gModuleMgr.sharedMgr("shieldedWordsltCtrl")
	print("发送联盟留言: aid: " .. aid)
	allianceMsg:reqSendAllianceMsg(aid, content.content)
end
function allianceChatView:chatScrollViewPosOffset(target, data)
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
function allianceChatView:chatScrollViewPosReset(target, data)
	local duration = data.duration
	local offsetY = data.offsetY
	local isShowKeyboardMask = data.isShowKeyboardMask
	local actMoveTo = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMoveTo)
	local actMoveToChatBgReset = cca.moveTo(duration, 0, 85)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMoveToChatBgReset)
	if isShowKeyboardMask then
		print("取消吞没消息")
		self.maskArea:setVisible(false)
		self.maskArea:stopAllActions()
		local actMoveTo5 = cca.moveTo(duration, self.oriMaskAreaPos.x, self.oriMaskAreaPos.y)
		self.maskArea:runAction(actMoveTo5)
	end
end
function allianceChatView:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
	print("聊天滚动内容:执行MoveTo, offsetY = " .. offsetY)
	local actMove1 = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMove1)
	local actMove6 = cca.moveTo(duration, 0, 85 + offsetY)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove6)
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
function allianceChatView:doAnimationChatScrollViewScrollOffset(duration, _adjustHeight, deltaHeight, isShowKeyboardMask)
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
function allianceChatView:onEnterPanel()
	print("allianceChatView: onEnterPanel")
end
function allianceChatView:onExitPanel()
	print("allianceChatView: on Exit Panel")
	if self.initSuccess and self.key then
		chatDataMgr:cleanSetParam(self.chatChannel, self.chatSet, self.key)
		chatDataMgr:setChatChannelInfo(chatDataMgr:popChatChannelInfo())
		chatDataMgr:cleanAllianceMsgData(self.key)
	end
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
	end)
end
function allianceChatView:openEmotionUI(target, data)
	print("打开表情页面")
	self.isOpenEmotion = true
	local offsetY = math.abs(self.oriChatEmotionPageViewPos.y)
	local deltaTextHeight = 0
	print("offsetY = ", offsetY, ", deltaTextHeight = ", deltaTextHeight)
	_ENV = offsetY
	offsetY.duration = 0.25
	offsetY.offsetY = offsetY + deltaTextHeight
	offsetY.isMoveTo = true
	self:chatScrollViewPosOffset(offsetY)
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
	self.chatEmotionPageView:stopAllActions()
	self.chatEmotionPageView:runAction(actMoveTo2)
end
function allianceChatView:hideEmotionUI(target, data)
	print("隐藏表情页面")
	local deltaHeight = 0
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = deltaHeight
	self:chatScrollViewPosReset(self, nil)
	_ENV = self
	self.msg = "MESSAGE_CHAT_SCROLL_VIEW_POS_RESET"
	self.duration = 0.25
	self.offsetY = deltaHeight
	SoraDSendMessage(self)
	local actMoveTo1 = cca.moveTo(0.25, self.oriChatEmotionPageViewPos.x, self.oriChatEmotionPageViewPos.y)
	self.chatEmotionPageView:stopAllActions()
	self.chatEmotionPageView:runAction(actMoveTo1)
	local actMovTo2 = cca.moveTo(0.25, 0, self.oriMaskAreaPos.y)
	self.maskArea:stopAllActions()
	self.maskArea:runAction(actMovTo2)
	local offsetY = -math.abs(self.oriChatEmotionPageViewPos.y)
	local actMoveTo = cca.moveTo(0.25, 320, 0)
	self.bottomViewNode:stopAllActions()
	self.bottomViewNode:runAction(actMoveTo)
	self.bottomViewNode:switchBtn(false)
end
function allianceChatView:OnMaskArea(target, eventType)
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
			self.maskArea.viewType = "allianceChatView"
			SoraDSendMessage(self.maskArea)
			self.isOpenKeyBoard = false
		end
	end
end
function allianceChatView:sMsgNewAllianceMsg(target, data)
	print("收到了联盟留言新消息:")
	local newMsg = data.allianceMsg
	dump(newMsg)
	local playerId = newMsg.uid
	local isNeedScroll = false
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil and lordInfoCtrl:getLordInfo().base.uid == playerId then
		isNeedScroll = true
	end
	local chatChannel = gChatChannel.ALLIANCEMSG
	local chatDataSet = gChatSet.TOTAL
	_ENV = nil
	lordInfoCtrl, (nil).msg = nil, "MESSAGE_CHAT_SERVER_NEW_MESSAGE"
	;(nil).data, (nil)[1] = nil, newMsg
	;(nil).chatChannel = chatChannel
	;(nil).chatDataSet = chatDataSet
	;(nil).target = self.allianceId
	;(nil).isNeedScroll = isNeedScroll
	SoraDSendMessage(nil)
end
function allianceChatView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceChat" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceChatView:msgReqOperateShieldList(target, data)
	self.opType = data.opType
	self.opList = data.opList
	self.targetNickName = data.nickName
	self.targetAbbr = data.abbr
	local strMsg = ""
	if self.opType == gAShieldListOperate.add then
		if self.opList.aid ~= nil then
			_ENV = nil
			;(nil).name = self.targetAbbr
			strMsg = i18n("common_text_538", nil)
			SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmOperateShiledListCallBack))
		elseif self.opList.uid ~= nil then
			_ENV = i18n("common_text_054")
			i18n("common_text_054").name = self.targetNickName
			strMsg = i18n("common_text_1881", (i18n("common_text_054")))
			SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmOperateShiledListCallBack))
		end
	else
		self:confirmOperateShiledListCallBack(MSGBOX_CALLBACK_YES)
	end
end
function allianceChatView:confirmOperateShiledListCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		allianceMsg:reqOperateShieldList(self.opType, self.opList)
	end
end
function allianceChatView:showKeyboardMask(target, data)
	print("function allianceChatView:showKeyboardMask(target, data)")
	self.isOpenKeyBoard = true
	self.maskArea:setVisible(true)
end
function allianceChatView:hideKeyboardMask(target, data)
	local delayTime = data.delayTime
	if delayTime ~= nil then
		local delay = cca.delay(delayTime)
		local callFunc1 = cca.callFunc(function()
			print("设置掩盖层不可见，延迟时间: ", delayTime)
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
function allianceChatView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	end
end
function allianceChatView:getChatKey(forceUpdate)
	if not self.key or forceUpdate then
		self.key = string.format("%d_%d_%s", self.chatChannel, self.chatSet, tostring(self.allianceId))
	end
	return self.key
end
return allianceChatView
