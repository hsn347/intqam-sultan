local gametop = gModuleMgr.getObject("gametop")
local chatDataMgr = _G.gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = _G.gChatMgrs:getMgr("chatSendMgr")
local chatConst = include("chatConst")
local teamChatView = class("teamChatView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamChatView")
	end
	return target
end)
_ENV = "teamChatView"
;("teamChatView").addScrollH = 80
;("teamChatView").dayColor = cc.c3b(172, 151, 129)
local ("teamChatView").nightColor, _defaultParam = cc.c3b(84, 75, 64), "teamChatView"
function teamChatView:ctor()
	self.isHideCurrentSceneView = true
	self.chatChannel = gChatChannel.TEAMMSG
	self.chatSet = gChatSet.TOTAL
	self.teamId = 0
	self.teamType = 0
	self.maxCharCount = gChatMaxLength.allianceChatLength
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.title:setTitle(i18n("remains_text_310"))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg_node", true)
	self.ccsNightBg:setContentHeight(display.height - 67)
	self.ccsNightBg:setPositionY(0)
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
		self.bottomViewNode:setViewType("teamChatView")
		self.bottomViewNode:setMaxCharCount(self.maxCharCount)
		self.bottomViewNode:setChatInputType(chatConst.ChatInputType.Input_Text_Emo)
		self.bottomViewNode:setChatDelegate(self)
	end
	self.chatScrollViewSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	local realScroll = self.chatScrollViewSingle.scrollView
	local scrollSize = realScroll:getContentSize()
	realScroll:setContentSize(cc.size(scrollSize.width, scrollSize.height + _defaultParam.addScrollH))
	self.oriScrollViewSize = realScroll:getContentSize()
	realScroll:setInnerContainerSize(realScroll:getContentSize())
	self.chatEmotionPageView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatEmotionPageView_node")
	self.chatEmotionPageView:init(self)
	self.chatEmotionPageView:setPositionY(-435)
	self.chatEmotionPageView:setLocalZOrder(1)
	self.chatEmotionPageView:setVisible(false)
	self.oriChatScrollViewPos = cc.p(self.chatScrollViewSingle:getPositionX(), self.chatScrollViewSingle:getPositionY())
	self.oriChatEmotionPageViewPos = cc.p(self.chatEmotionPageView:getPositionX(), self.chatEmotionPageView:getPositionY())
	self.oriChatBgPos = cc.p(320, 0)
	self.ccsNightBg:updateTheme()
end
function teamChatView:initWithData(data)
	self.teamId = data.teamId
	self.teamType = data.teamType
	self.myTeamInfo = data.myTeamInfo
	self:getChatKey(true)
	chatDataMgr:pushChatChannelInfo()
	chatDataMgr = chatDataMgr.pushChatChannelInfo
	chatDataMgr.pushChatChannelInfo.chatChannel = self.chatChannel
	chatDataMgr.pushChatChannelInfo.chatSet = self.chatSet
	chatDataMgr.pushChatChannelInfo.key = self.key
	local chatDataMgr.pushChatChannelInfo.teamId, channelInfo = self.teamId, chatDataMgr.pushChatChannelInfo
	chatDataMgr:setChatChannelInfo(channelInfo)
	chatDataMgr:cleanTeamMsgData(self.key)
	self.initSuccess = true
	chatDataMgr = nil
	;(nil).nextIndex = 1
	;(nil).teamId = self.teamId
	chatDataMgr:setSetParam(self.chatChannel, self.chatSet, self.key, nil)
	chatDataMgr = chatDataMgr.setSetParam
	chatDataMgr.setSetParam.chatChannel = self.chatChannel
	chatDataMgr.setSetParam.chatSet = self.chatSet
	chatDataMgr.setSetParam.key = self.key
	chatDataMgr.setSetParam.channelID = self.myTeamInfo:getChannelID()
	chatDataMgr.setSetParam.teamId = self.myTeamInfo:getTeamID()
	local chatDataMgr.setSetParam.ignoreCloseLoading, channelData = true, chatDataMgr.setSetParam
	self.channelData = channelData
	self.chatScrollViewSingle:initWithChatChannel(channelData)
	self:doRequestHistoryMsg()
	local teamDef = include("teamDef")
	if self.teamType == teamDef.teamAreaEnum.NEBULA_EMPEROR then
		self.title:setTitle(i18n("nebulaemperor_text_221"))
	end
end
function teamChatView:doRequestHistoryMsg()
	chatSendMgr:requestHistory(self.channelData)
end
function teamChatView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
end
function teamChatView:updateTeamInfo(target, data)
	if not self.myTeamInfo:isHasTeam() then
		self:removeFromParent()
	end
end
function teamChatView:chatSendOneMessage(target, data)
	local textContent = data.message
	local messageType = data.messageType
	local packetId = data.packetId
	if messageType == gChatTypeDef.chat_content_expression then
		local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.teamEmotion)
		if canSend == false then
			return
		end
	end
	if messageType == gChatTypeDef.chat_content_text then
		messageType = _G.gChatMsgContentFormatType.PLAIN_TEXT
	elseif messageType == gChatTypeDef.chat_content_expression then
		messageType = _G.gChatMsgContentFormatType.EMOTICON
	end
	textContent = string.ltrim(textContent)
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(textContent) then
		textContent = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(textContent)
	end
	if textContent == nil or textContent == "" then
		return
	end
	local teamId = self.teamId
	_ENV = gModuleMgr.sharedMgr("shieldedWordsltCtrl")
	gModuleMgr.sharedMgr("shieldedWordsltCtrl").formatType = messageType
	gModuleMgr.sharedMgr("shieldedWordsltCtrl").packetId = packetId
	gModuleMgr.sharedMgr("shieldedWordsltCtrl").content = textContent
	local gModuleMgr.sharedMgr("shieldedWordsltCtrl").teamType, content = self.teamType, gModuleMgr.sharedMgr("shieldedWordsltCtrl")
	print("发送联盟留言: teamid: " .. teamId)
	local chatCtrl = SoraDGetCtrl("chatCtrl")
	chatCtrl:reqSendTeamMsg(content)
end
function teamChatView:chatScrollViewPosOffset(target, data)
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
function teamChatView:chatScrollViewPosReset(target, data)
	local duration = data.duration
	local offsetY = data.offsetY
	local isShowKeyboardMask = data.isShowKeyboardMask
	local actMoveTo = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMoveTo)
	local actMoveToChatBgReset = cca.moveTo(duration, 0, 0)
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
function teamChatView:doAnimationChatScrollViewScrollTo(duration, offsetY, isShowKeyboardMask)
	print("聊天滚动内容:执行MoveTo, offsetY = " .. offsetY)
	local actMove1 = cca.moveTo(duration, self.oriChatScrollViewPos.x, self.oriChatScrollViewPos.y + offsetY)
	self.chatScrollViewSingle:stopAllActions()
	self.chatScrollViewSingle:runAction(actMove1)
	local actMove6 = cca.moveTo(duration, 0, offsetY)
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
function teamChatView:doAnimationChatScrollViewScrollOffset(duration, _adjustHeight, deltaHeight, isShowKeyboardMask)
	deltaHeight = deltaHeight or 0
	local actMoveBy = cca.moveBy(duration, 0, _adjustHeight)
	self.chatScrollViewSingle:runAction(actMoveBy)
	if isShowKeyboardMask then
		self.maskArea:runAction(actMoveBy:clone())
	end
	print("内容框改变的区域大小引起滚动区域改变:" .. deltaHeight)
	self.chatScrollViewSingle:resizeContentSize(cc.size(self.oriScrollViewSize.width, self.oriScrollViewSize.height - deltaHeight))
end
function teamChatView:onEnterPanel()
	print("teamChatView: onEnterPanel")
end
function teamChatView:onExitPanel()
	print("teamChatView: on Exit Panel")
	if self.initSuccess and self.key then
		chatDataMgr:cleanSetParam(self.chatChannel, self.chatSet, self.key)
		chatDataMgr:setChatChannelInfo(chatDataMgr:popChatChannelInfo())
		chatDataMgr:cleanTeamMsgData(self.key)
	end
	self.myTeamInfo:cleanHasNewTeamMsg()
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, _G.gShowLoadingMark.chat)
	end)
end
function teamChatView:openEmotionUI(target, data)
	print("打开表情页面")
	self.isOpenEmotion = true
	local offsetY = math.abs(self.oriChatEmotionPageViewPos.y)
	local deltaTextHeight = 0
	print("offsetY = ", offsetY, ", deltaTextHeight = ", deltaTextHeight)
	_ENV = ", deltaTextHeight = "
	;(", deltaTextHeight = ").duration = 0.25
	;(", deltaTextHeight = ").offsetY = offsetY + deltaTextHeight
	;(", deltaTextHeight = ").isMoveTo = true
	self:chatScrollViewPosOffset(self, ", deltaTextHeight = ")
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
function teamChatView:hideEmotionUI(target, data)
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
function teamChatView:OnMaskArea(target, eventType)
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
			self.maskArea.viewType = "teamChatView"
			SoraDSendMessage(self.maskArea)
			self.isOpenKeyBoard = false
		end
	end
end
function teamChatView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceChat" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function teamChatView:showKeyboardMask(target, data)
	print("function teamChatView:showKeyboardMask(target, data)")
	self.isOpenKeyBoard = true
	self.maskArea:setVisible(true)
	if self.isOpenEmotion then
		self:hideEmotionUI(nil, nil)
		self.isOpenEmotion = false
	end
end
function teamChatView:hideKeyboardMask(target, data)
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
function teamChatView:getChatKey(forceUpdate)
	if not self.key or forceUpdate then
		self.key = string.format("%d_%d_%s", self.chatChannel, self.chatSet, tostring(self.teamId))
	end
	return self.key
end
function teamChatView:initActivityChatRoom(teamType, chatChannelID)
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local myTeamInfo = teamCtrl:getTeamData(teamType)
	_ENV = nil
	;(nil).tid = 1
	;(nil).chatChannelID = chatChannelID
	myTeamInfo:setMyTeamInfo(nil)
	_ENV = myTeamInfo.setMyTeamInfo
	myTeamInfo.setMyTeamInfo.teamId = myTeamInfo:getTeamID()
	myTeamInfo.setMyTeamInfo.teamType = myTeamInfo:getTeamType()
	local myTeamInfo.setMyTeamInfo.myTeamInfo, data = myTeamInfo, myTeamInfo.setMyTeamInfo
	self:initWithData(data)
end
function teamChatView:initKohMigrateChatRoom(...)
	self.title:setTitle(i18n("common_text_4673"))
	local teamDef = include("teamDef")
	local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
	local teamType = teamDef.teamAreaEnum.KOH_MIGRATE
	local chatChannelID = kohMigrateCtrl:getChannelID()
	self:initActivityChatRoom(teamType, chatChannelID)
end
function teamChatView:init9001606ChatRoom()
	self.title:setTitle(i18n("CombineServers_25"))
	local teamCtrl = SoraDGetCtrl("teamCtrl")
	local teamDef = include("teamDef")
	local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
	local teamType = teamDef.teamAreaEnum.MERGE_SERVER_SHOW
	local myTeamInfo = teamCtrl:getTeamData(teamType)
	_ENV = i18n("CombineServers_25")
	i18n("CombineServers_25").tid = 1
	i18n("CombineServers_25").chatChannelID = myTeamInfo.chatChannelID
	myTeamInfo:setMyTeamInfo(i18n("CombineServers_25"))
	_ENV = myTeamInfo.setMyTeamInfo
	myTeamInfo.setMyTeamInfo.teamId = myTeamInfo:getTeamID()
	myTeamInfo.setMyTeamInfo.teamType = myTeamInfo:getTeamType()
	local myTeamInfo.setMyTeamInfo.myTeamInfo, data = myTeamInfo, myTeamInfo.setMyTeamInfo
	self:initWithData(data)
end
function teamChatView:init9001657ChatRoom(...)
	self.title:setTitle(i18n("common_text_4673"))
	local teamDef = include("teamDef")
	local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
	local teamType = teamDef.teamAreaEnum.ACTIVITY_9001657
	local chatChannelID = activity_9001657_Ctrl:getChannelID()
	self:initActivityChatRoom(teamType, chatChannelID)
end
function teamChatView:initWithActivityID(activityID)
	local teamDef = include("teamDef")
	local teamType, chatChannelID
	if activityID == gActivityTimeActivityID.SIMULATED_DRILL_WAR_ACTIVITY then
		self.title:setTitle(i18n("simulated_drill_btn_03"))
		teamType = teamDef.teamAreaEnum.ACTIVITY_9001725
		local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
		chatChannelID = simulatedDrillCtrl:getChannelID()
	end
	if teamType and chatChannelID then
		self:initActivityChatRoom(teamType, chatChannelID)
	end
end
return teamChatView
