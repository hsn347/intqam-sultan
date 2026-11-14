local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatFunctions = include("chatFunctions")
local chatConst = include("chatConst")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local djCtrl = SoraDGetCtrl("djCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local worldMapWarDef = include("worldMapWarDef")
_ENV = "worldMapWarDef"
_ENV, ("worldMapWarDef").deltaDrag = nil, 150
;(nil)[gChatChannel.KINGDOM] = 0
;(nil)[gChatChannel.CAMP] = 640
;(nil)[gChatChannel.VIEWER] = 640
;(nil)[gChatChannel.ALLIANCE] = 1280
;(nil)[gChatChannel.DJ] = 1920
;(nil)[gChatChannel.TEAM] = 1920
;(nil)[gChatChannel.MAIL] = 2560
;("worldMapWarDef").channelX, (nil)[gChatChannel.CHATROOM] = nil, 2560
local ("worldMapWarDef").maxOffsetX, _defaultParam = 640, "worldMapWarDef"
local chatView = class("chatView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatView")
	end
	return target
end)
function chatView:onExitPanel()
	print("chatView: on Exit Panel")
	if not self.isInstanceView then
		chatDataMgr:cleanKingdomAllianceDataNode()
	end
	SoraDDelayCallOnce("closeLoading", function()
		SoraDCloseLoading(nil, gShowLoadingMark.chat)
	end)
	chatAudioMgr:stopCurPlayAudio()
	chatAudioMgr:resumeMusic()
	worldMapDefine.isInDJChatView = false
	cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
	chatCtrl:getUnreadAtSelfUserList(self.curChannel, self.curChatInfo and self.curChatInfo.target, true)
	_ENV = chatCtrl
	chatCtrl.msg = "MESSAGE_CHAT_UNREAD_AT_UPDATE"
	SoraDSendMessage(chatCtrl)
	_ENV = chatCtrl
	chatCtrl.msg = "MESSAGE_CHAT_CLEAR_REPLY_MSG"
	SoraDSendMessage(chatCtrl)
end
function chatView:ctor()
	self.isHideCurrentSceneView = true
	self.chatJoinAlliance = nil
	self.oriAllianceScrollViewSize = nil
	self.oriKingdomScrollViewSize = nil
	self.oriChatPrizePageViewPosY = -365
	self.isMoveV = false
	self.isMoveH = false
	self.judgeHMove = 3 * TOUCH_MOVED_ERROR_VALUE
	self.judgeVMove = 3 * TOUCH_MOVED_ERROR_VALUE
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.title:setTitle(i18n("common_text_071"))
	self.nodeTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.nodeTab:setChooseColor(cc.c3b(255, 245, 175))
	self.nodeTab:setUnChooseColor(cc.c3b(144, 132, 97))
	self.nodeTab:setChoosePng("btn_alliance_special.png")
	self.nodeTab:setUnChoosePng("btn_alliance_click.png")
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg_node", true)
	self.ccsPerList = SoraDGetExtendChildFromCCSByName(self, "CCS_chatPersonalList", true)
	self.ccsPerList:setChatDelegate(self)
	self.ccsPerList:setVisible(false)
	self.btnVoiceRoom = SoraDGetChildByName(self, "Button_voice_room")
	self.btnSetting = SoraDGetChildByName(self, "Button_setting")
	self.nodeContentViews = SoraDGetChildByName(self, "nodeContentViews")
	self.touchPanel = SoraDGetChildByName(self, "Size_TouchPanel")
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:addTouchEventListener(handler(self, self.onTouchPanel))
	self.oriTouchPanelPos = cc.p(self.touchPanel:getPosition())
	self.maskArea = SoraDGetChildByName(self, "Size_Btn_Check_Not_EmotionArea")
	self.maskArea:setLocalZOrder(1)
	if self.maskArea then
		self.maskArea:setSwallowTouches(true)
		if device.platform == "mac" then
			self.maskArea:setSwallowTouches(false)
		end
		self.maskArea:setVisible(false)
		self.maskArea:addTouchEventListener(handler(self, self.OnMaskArea))
	end
	self.btnVoiceRoom:addTouchEventListener(handler(self, self.onBtnVoiceRoom))
	self.btnSetting:addTouchEventListener(handler(self, self.onBtnSetting))
	self.maskArea:setPositionY(self.maskArea:getPositionY() + 90)
	self.oriMaskAreaPos = cc.p(self.maskArea:getPosition())
	self.isCapturing = false
	self.listener = cc.EventListenerTouchOneByOne:create()
	self.listener:registerScriptHandler(function()
		print("录音屏蔽", self.isCapturing)
		return self.isCapturing
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -99999)
	self.topPanelInfo = SoraDGetChildByName(self, "Top_Panel_info")
	local mailNode = SoraDGetExtendChildFromCCSByName(self, "CCS_chatContentView_Personal", true)
	_ENV = self
	self[gChatChannel.KINGDOM] = SoraDGetExtendChildFromCCSByName(self, "CCS_chatContentView_kingdom", true)
	self[gChatChannel.CAMP] = SoraDGetExtendChildFromCCSByName(self, "CCS_chatContentView_camp", true)
	self[gChatChannel.ALLIANCE] = SoraDGetExtendChildFromCCSByName(self, "CCS_chatContentView_alliance", true)
	self[gChatChannel.DJ] = SoraDGetExtendChildFromCCSByName(self, "CCS_djContentView_dj", true)
	self[gChatChannel.TEAM] = SoraDGetExtendChildFromCCSByName(self, "CCS_chatContentView_team", true)
	self[gChatChannel.MAIL] = mailNode
	self.chatNode, self[gChatChannel.CHATROOM] = self, mailNode
	self.chatNode[gChatChannel.VIEWER] = self.chatNode[gChatChannel.CAMP]
	self.isInstanceView = true
	for __, chatNode in pairs(self.chatNode) do
		chatNode:setPositionX(SoraDFSign(640))
		if chatNode.scrollView then
			chatNode.scrollView.isInInstanceView = self.isInstanceView
		end
	end
	if worldMapDefine.isInSimulatedDrill() then
		self.chatNode[gChatChannel.KINGDOM]:initInputView(chatConst.ChatInputType.Input_Text_Emo)
	else
		self.chatNode[gChatChannel.KINGDOM]:initInputView(chatConst.ChatInputType.Input_Text_Emo_Horn)
	end
	self.chatNode[gChatChannel.CAMP]:initInputView(chatConst.ChatInputType.Input_Text_Emo)
	self.chatNode[gChatChannel.VIEWER]:initInputView(chatConst.ChatInputType.Input_Text_Emo)
	self.chatNode[gChatChannel.ALLIANCE]:initInputView(chatConst.ChatInputType.Input_Text_Emo_Audio)
	self.chatNode[gChatChannel.MAIL]:initInputView(chatConst.ChatInputType.Input_Text_Emo_Audio)
	_ENV = chatConst.ChatInputType.Input_Text_Emo_Audio
	chatConst.ChatInputType.Input_Text_Emo_Audio.chatChannel = gChatChannel.KINGDOM
	self.chatNode[gChatChannel.KINGDOM]:initTop(chatConst.ChatInputType.Input_Text_Emo_Audio)
	_ENV = chatConst.ChatInputType.Input_Text_Emo_Audio
	chatConst.ChatInputType.Input_Text_Emo_Audio.chatChannel = gChatChannel.CAMP
	self.chatNode[gChatChannel.CAMP]:initTop(chatConst.ChatInputType.Input_Text_Emo_Audio)
	_ENV = chatConst.ChatInputType.Input_Text_Emo_Audio
	chatConst.ChatInputType.Input_Text_Emo_Audio.chatChannel = gChatChannel.ALLIANCE
	self.chatNode[gChatChannel.ALLIANCE]:initTop(chatConst.ChatInputType.Input_Text_Emo_Audio)
	if worldMapDefine.isInNewTrial() then
		self.chatNode[gChatChannel.TEAM]:initInputView(chatConst.ChatInputType.Input_Text_Emo_Quick)
	else
		self.chatNode[gChatChannel.TEAM]:initInputView(chatConst.ChatInputType.Input_Text_Emo)
	end
	_ENV = chatConst.ChatInputType.Input_Text_Emo
	chatConst.ChatInputType.Input_Text_Emo.chatChannel = gChatChannel.TEAM
	self.chatNode[gChatChannel.TEAM]:initTop(chatConst.ChatInputType.Input_Text_Emo)
	self:initBtnSettingAndVoiceRoom()
	self.chatEmotionPageView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatEmotionPageView_node")
	self.chatSelectBottomView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatSelectBottomView_node")
	self.chatEmotionPageView:setVisible(false)
	self.chatSelectBottomView:setVisible(false)
	self.oriContentViewPos = cc.p(self.nodeContentViews:getPosition())
	self.oriChatEmotionPageViewPos = cc.p(self.chatEmotionPageView:getPositionX(), self.chatEmotionPageView:getPositionY())
	self.ccsNightBg:updateTheme()
	self:initChatJoinAlliance()
	self.chatSelectBottomView:init(self)
	self.chatEmotionPageView:init(self)
end
function chatView:onCreateFromCache()
	self:initChatJoinAlliance()
	for k, v in pairs(self.chatNode) do
		if v and v.resetInit then
			v:resetInit()
		end
	end
	self:hideEmotionUI(nil, nil, 0)
	self.curChannel = nil
	self:initBtnSettingAndVoiceRoom()
end
function chatView:onClearFromCache()
	for __, chatNode in pairs(self.chatNode) do
		if chatNode.scrollView and chatNode.scrollView.clearCache then
			print("chatView:onClearFromCache()")
			chatNode.scrollView:clearCache()
		end
	end
	chatDataMgr:cleanKingdomAllianceDataNode()
end
function chatView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.refreshAllianceChat))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED_UI", handler(self, self.sMsgAllianceBeKicked))
	SoraDAddMessage(self, "MESSAGE_IME_EVENT", handler(self, self.onImeEvent))
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.updateAncientTreasure))
	SoraDAddMessage(self, "MESSAGE_CHAT_UI_DELETE_PERSONAL", handler(self, self.resetPersonalChat))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GET_COVER_BACK", handler(self, self.updatePersonalRedIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS", handler(self, self.updatePersonalRedIcon))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SEL_PLAYERS_CONFIRM", handler(self, self.openPersonalChatView))
	SoraDAddMessage(self, "MESSAGE_CHAT_ADD_MESSAGE", handler(self, self.chatAddMessage))
end
function chatView:chatAddMessage(target, data)
	dump(data, "chatView:chatAddMessage", 10)
	local chatChannel = data.chatChannel
	if chatChannel == gChatChannel.ALLIANCE then
		self:updateAllianceRedIcon()
	elseif chatChannel == gChatChannel.DJ then
		self:checkDJGift(data)
	end
end
function chatView:init(data)
	if data and data.chatChannel then
		self.curChatInfo = data
		self.curChannel = data.chatChannel
	else
		self.curChatInfo = chatDataMgr:getChatChannelInfo()
	end
	if not self.curChannel then
		self.curChannel = chatDataMgr:getGChatChannel()
	end
	print("当前聊天频道:", self.curChannel)
	self:updateTab()
	self:updatePersonalRedIcon()
	self:updateAllianceRedIcon()
end
function chatView:updateAllianceRedIcon(...)
	if self.curChannel ~= gChatChannel.ALLIANCE then
		local redNum = chatCtrl:getUnreadAtSelfMsg(gChatChannel.ALLIANCE)
		self.nodeTab:setBigRedPointCount(gChatChannel.ALLIANCE, redNum)
	else
		self.nodeTab:setBigRedPointCount(gChatChannel.ALLIANCE, 0)
	end
end
function chatView:updateTab()
	for __, chatNode in pairs(self.chatNode) do
		chatNode:setPositionX(SoraDFSign(640))
	end
	local kingdomClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	_ENV = SoraDGetCtrl("kingdomMapCtrl")
	SoraDGetCtrl("kingdomMapCtrl")[gKingdomClassType.nebulaAllStar] = i18n("NebulaAllstar_187")
	SoraDGetCtrl("kingdomMapCtrl")[gKingdomClassType.roaringFlame] = i18n("NebulaAllstar_187")
	local SoraDGetCtrl("kingdomMapCtrl")[gKingdomClassType.simulatedDrill], config = i18n("simulated_drill_text_52"), SoraDGetCtrl("kingdomMapCtrl")
	local _ENV, _ENV, kingdomTitle = "simulated_drill_text_52", "common_text_070", config[kingdomClassType] or i18n("common_text_070")
	;("simulated_drill_text_52").title = kingdomTitle
	;("simulated_drill_text_52").tag = gChatChannel.KINGDOM
	self.channelList, ("common_text_070")[1], ("simulated_drill_text_52").handle = "common_text_070", "simulated_drill_text_52", handler(self, self.OnBtnChangeClick)
	_ENV, _defaultParam.maxOffsetX = "common_text_070", 0
	_ENV, self.channelX, ("common_text_070")[gChatChannel.KINGDOM] = "common_text_070", "common_text_070", _defaultParam.maxOffsetX
	;("common_text_070")[gKingdomClassType.nebula] = i18n("nebula_war_text_0296")
	local ("common_text_070")[gKingdomClassType.nebulaAllStar], config = i18n("NebulaAllstar_186"), "common_text_070"
	local campTitle = config[kingdomClassType]
	if campTitle then
		_ENV = i18n("NebulaAllstar_186")
		i18n("NebulaAllstar_186").title = campTitle
		i18n("NebulaAllstar_186").tag = gChatChannel.CAMP
		local i18n("NebulaAllstar_186").handle, data = handler(self, self.OnBtnChangeClick), i18n("NebulaAllstar_186")
		self.channelList[#self.channelList + 1] = data
		_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
		self.channelX[gChatChannel.CAMP] = _defaultParam.maxOffsetX
	end
	local showAllianceChat = false
	if worldMapWarDef.isInWarForbidShowAllianceChat() then
		showAllianceChat = false
	else
		showAllianceChat = not worldMapDefine.isInWar() or allianceMgr:hasJoinAlliance()
	end
	if showAllianceChat then
		_ENV = _defaultParam.maxOffsetX
		_defaultParam.maxOffsetX.title = i18n("common_text_946")
		_defaultParam.maxOffsetX.tag = gChatChannel.ALLIANCE
		self.channelList[#self.channelList + 1], _defaultParam.maxOffsetX.handle = _defaultParam.maxOffsetX, handler(self, self.OnBtnChangeClick)
		_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
		self.channelX[gChatChannel.ALLIANCE] = _defaultParam.maxOffsetX
	else
		_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
		self.chatNode[gChatChannel.ALLIANCE]:setVisible(false)
		self.chatNode[gChatChannel.ALLIANCE]:setPositionX(SoraDFSign(640))
	end
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if nebulaAllStarCtrl:getIsViewer() then
		_ENV = SoraDFSign(640)
		SoraDFSign(640).title = i18n("NebulaAllstar_188")
		SoraDFSign(640).tag = gChatChannel.VIEWER
		SoraDFSign(640).handle = handler(self, self.OnBtnChangeClick)
		table.insert(self.channelList, SoraDFSign(640))
		_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
		self.channelX[gChatChannel.VIEWER] = _defaultParam.maxOffsetX
	end
	self.chatNode[gChatChannel.TEAM]:setVisible(false)
	self.chatNode[gChatChannel.DJ]:setVisible(false)
	if worldMapDefine.isInTeamChannel() or worldMapDefine.isInSimulatedDrill() then
		self.chatNode[gChatChannel.TEAM]:setVisible(true)
		_ENV = self.chatNode[gChatChannel.TEAM].setVisible
		self.chatNode[gChatChannel.TEAM].setVisible.title = i18n("remains_text_310")
		self.chatNode[gChatChannel.TEAM].setVisible.tag = gChatChannel.TEAM
		local self.chatNode[gChatChannel.TEAM].setVisible.handle, data = handler(self, self.OnBtnChangeClick), self.chatNode[gChatChannel.TEAM].setVisible
		if worldMapDefine.isInNebulaEmperor() then
			data.title = i18n("nebulaemperor_text_221")
		elseif worldMapDefine.isInNebulaAllStar() then
			local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
			if myTeamInfo:getIsSuperTeam() then
				data.title = i18n("NebulaAllstar_184")
			else
				data.title = i18n("NebulaAllstar_185")
			end
		elseif worldMapDefine.isInRoaringFlame() then
			data.title = i18n("flames_dunes_push3")
		elseif worldMapDefine.isInSimulatedDrill() then
			data.title = i18n("nebula_war_text_0296")
		end
		self.channelList[#self.channelList + 1] = data
		_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
		self.channelX[gChatChannel.TEAM] = _defaultParam.maxOffsetX
		local posX = self.channelX[gChatChannel.TEAM]
		self.chatSelectBottomView:setPositionX(SoraDFPosX(-posX, 0) + 320)
	end
	local channel = self.curChatInfo and self.curChatInfo.tab or gChatChannel.MAIL
	_ENV = self.chatSelectBottomView
	self.chatSelectBottomView.title = i18n("chat_text_69")
	self.chatSelectBottomView.tag = channel
	self.channelList[#self.channelList + 1], self.chatSelectBottomView.handle = self.chatSelectBottomView, handler(self, self.OnBtnChangeClick)
	_defaultParam.maxOffsetX = _defaultParam.maxOffsetX + 640
	self.channelX[channel] = _defaultParam.maxOffsetX
	for channel, posX in pairs(self.channelX) do
		local chatNode = self.chatNode[channel]
		if chatNode then
			chatNode:setPositionX(SoraDFPosX(-posX, 0))
		end
	end
	_ENV = pairs(self.channelX)
	pairs(self.channelX).tabNum = #self.channelList
	pairs(self.channelX).defaultClick = self.curChannel or gChatChannel.KINGDOM
	pairs(self.channelX).tabsetArray = self.channelList
	self.nodeTab:initView(pairs(self.channelX))
	if not SoraDIsGameGuide() then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:updateGuideModule(gGuideModule.CHAT_AT_GUIDE)
	end
end
function chatView:updatePersonalRedIcon()
	local tag = self.curChatInfo and self.curChatInfo.tab or gChatChannel.MAIL
	local redNum = gChatMgrs:getMgr("chatCoverMgr"):getTotalNewNum()
	print("updatePersonalRedIcon", tag, redNum)
	self.nodeTab:setBigRedPointCount(tag, redNum)
	self.chatNode[gChatChannel.MAIL]:updatePersonalRedIcon()
end
function chatView:initChatJoinAlliance()
	if not allianceMgr:hasJoinAlliance() then
		if self.chatNode[gChatChannel.ALLIANCE] then
			self.chatNode[gChatChannel.ALLIANCE]:setVisible(false)
		end
		if self.chatJoinAlliance then
			self.chatJoinAlliance:setVisible(true)
		else
			self.chatJoinAlliance = SoraDCreatePanel("chatJoinAlliance")
			self.chatJoinAlliance:addTo(self.nodeContentViews)
		end
		self.chatJoinAlliance:setPosition(cc.p(self.chatNode[gChatChannel.ALLIANCE]:getPosition()))
	else
		if self.chatNode[gChatChannel.ALLIANCE] then
			self.chatNode[gChatChannel.ALLIANCE]:setVisible(true)
		end
		if self.chatJoinAlliance then
			self.chatJoinAlliance:setVisible(false)
		end
	end
end
function chatView:toogleSelectBottomUI(show)
	if nil == show then
		if self.chatSelectBottomView:isVisible() then
			self.chatSelectBottomView:setVisible(false)
		else
			self.chatSelectBottomView:initData()
			self.chatSelectBottomView:setVisible(true)
		end
	elseif show then
		self.chatSelectBottomView:initData()
		self.chatSelectBottomView:setVisible(true)
	else
		self.chatSelectBottomView:setVisible(false)
	end
end
function chatView:checkDJGift(data)
	local chatData = data.chatData
	if chatData.isHistoryMsg then
		return
	end
	local msgData = chatData.data and chatData.data[#chatData.data] or nil
	if msgData and msgData.messageType == gChatTypeDef.chat_content_dj_gift and msgData.itemID ~= nil then
		self:runSendDJGiftAnimation(msgData.itemID)
	end
end
function chatView:runSendDJGiftAnimation(itemID)
	if itemID then
		local actName = "animationDJ_" .. itemID
		if self.djAnimations == nil then
			self.djAnimations, _ENV = self.djAnimations, self.djAnimations
		end
		local actionNode = self.djAnimations[actName]
		if actionNode == nil then
			actionNode = SoraDCreatAnimationEx(actName)
			actionNode:addTo(self, 10)
			actionNode:setScale(1.3)
			actionNode:setPosition(320, display.height - 350)
			self.djAnimations[actName] = actionNode
			if SoraDGetChildByName(actionNode, "Node_Effect_ltjm01_006") then
				for k, v in ipairs(SoraDGetChildByName(actionNode, "Node_Effect_ltjm01_006"):getChildren()) do
					local nameTB = SoraDStringSplit(v:getName(), "_")
					if nameTB[1] == "G" then
						SoraDMixtureGLONE(v)
					end
				end
			end
		else
			actionNode = SoraDCreatAnimationEx(actName, actionNode)
		end
		if self.curDJActionNode then
			self.curDJActionNode:setVisible(false)
		end
		self:stopActionByTag(itemID)
		actionNode:setVisible(true)
		actionNode.action:gotoFrameAndPlay(0, false)
		_UPVALUE1_ = actionNode.action
		actionNode.action[1] = cca.delay(3.02)
		actionNode.action[2] = cca.callFunc(function(...)
			actionNode:setVisible(false)
		end)
		actionNode.action[3] = cca.callFunc(function(...)
			actionNode:setVisible(false)
		end)
		actionNode.action[4] = cca.callFunc(function(...)
			actionNode:setVisible(false)
		end)
		actionNode.action[5] = cca.callFunc(function(...)
			actionNode:setVisible(false)
		end)
		actionNode.action[6] = cca.callFunc(function(...)
			actionNode:setVisible(false)
		end)
		local actHiddle = cca.seq(actionNode.action)
		actHiddle:setTag(itemID)
		self:runAction(actHiddle)
		self.curDJActionNode = actionNode
	end
end
function chatView:getActiveBottomView()
	local channel = self.curChannel
	if channel == gChatChannel.CHATROOM or channel == gChatChannel.MAIL then
		local personalView = self.chatNode[gChatChannel.MAIL]
		if personalView and personalView.bottomViewNode then
			return personalView.bottomViewNode
		end
	end
	local contentView = channel and self.chatNode[channel]
	if contentView and contentView.bottomViewNode then
		return contentView.bottomViewNode
	end
	return nil
end
function chatView:resolveReplyMsg(data)
	local replyMsg = data.replyMsg
	if not replyMsg then
		local bottomView = self:getActiveBottomView()
		if bottomView and bottomView.getReplyMsg then
			replyMsg = bottomView:getReplyMsg()
		end
	end
	if replyMsg then
		local bottomView = self:getActiveBottomView()
		if bottomView then
			bottomView:clearReplyMsg()
		end
	end
	return replyMsg
end
function chatView:buildWrapSendParam(message, chatIndex, packetId, replyMsg, isAtAll, atUserMap)
	chatSendMgr = nil
	;(nil).message = message
	;(nil).chatIndex = chatIndex
	;(nil).packetId = packetId
	;(nil).replyMsg = replyMsg
	;(nil).isAtAll = isAtAll
	;(nil).atUserMap = atUserMap
	return chatSendMgr:wrapSendMessageContent(nil)
end
function chatView:chatSendOneMessage(target, data)
	local message = data.message
	local messageType = data.messageType
	local chatIndex = data.newChatIndex
	local packetId = data.packetId
	local grupid = data.grupid
	local id = data.id
	local isAtAll = data.isAtAll
	local atUserMap = data.atUserMap
	local replyMsg = self:resolveReplyMsg(data)
	dump(data, "chatView:chatSendOneMessage", 10)
	if self:handleCMD(message) then
		return
	end
	local curChannel = self.curChannel
	if curChannel == gChatChannel.DJ then
		if false == chatCtrl:canChat() and messageType ~= gChatTypeDef.chat_content_dj_gift then
			SoraDShowMsgTip(i18n("common_text_1039"), "#icon_mail_lock.png")
			return
		end
		if messageType == gChatTypeDef.chat_content_dj_gift then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.djGiftMsg)
			if canSend == false then
				return
			end
		end
		local newChatIndex = chatIndex or chatSendMgr:getNewChatIndex()
		if messageType == gChatTypeDef.chat_content_dj_text then
			message = string.ltrim(message)
			if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
				message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
			end
			if message == nil or message == "" then
				return
			end
			message = string.gsub(message, "\n", " ")
		end
		local chatChannel = gChatChannel.DJ
		local chatSet = gChatSet.TOTAL
		_ENV = "\n"
		;("\n").shopItemID = data.shopItemID
		;("\n").itemID = data.itemID
		;("\n").count = data.count
		;("\n").chatChannel = chatChannel
		;("\n").chatSet = chatSet
		;("\n").messageType = messageType
		;("\n").message = message
		;("\n").chatIndex = newChatIndex
		local ("\n").packetId, param = packetId, "\n"
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		chatCtrl = chatSendMgr
		local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
		if messageType == gChatTypeDef.chat_content_dj_gift then
			local shopItemID = sendingMessage.shopItemID
			local count = sendingMessage.count
			local priceGold = 0
			if shopItemID then
				priceGold = djCtrl:getGiftPrize(shopItemID)
			end
			if 0 < priceGold then
				if GLOBAL_SEND_GIFT_NOTICE then
					_ENV = nil
					;(nil).gold = string.formatnumberthousands(priceGold * count)
					local panel = SoraDShowMsgBox(i18n("common_text_4574", nil), i18n("common_text_204"), nil, function(callType)
						if callType == MSGBOX_CALLBACK_YES then
							if self:canSendDjGift(priceGold * count, data) then
								djCtrl:sendMessage(sendingMessage, messageType)
								GLOBAL_SEND_GIFT_NOTICE = false
								_ENV = sendingMessage
								sendingMessage.data = dataArray
								sendingMessage.isHistory = false
								sendingMessage.chatChannel = chatChannel
								sendingMessage.chatDataSet = chatSet
								sendingMessage.isWrapped = true
								sendingMessage.isNeedScroll = true
								chatDataMgr:addChatData(sendingMessage)
							else
								if GLOBAL_GAME_RECHARGE_MODE then
									uiManager:show("rechargeView")
								else
									SoraDCreatePanel("rechargeView"):show()
								end
								paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
							end
						end
					end)
					panel:setTextAndGoldOnYesBtn(priceGold * count, i18n("common_text_204"), true)
				elseif self:canSendDjGift(priceGold * count, data) then
					djCtrl:sendMessage(sendingMessage, messageType)
					_ENV = sendingMessage
					sendingMessage.data = dataArray
					sendingMessage.isHistory = false
					sendingMessage.chatChannel = chatChannel
					sendingMessage.chatDataSet = chatSet
					sendingMessage.isWrapped = true
					sendingMessage.isNeedScroll = true
					chatDataMgr:addChatData(sendingMessage)
				else
					SoraDShowMsgTip(i18n("Anchor_text_27"))
				end
			else
				djCtrl:sendMessage(sendingMessage, messageType)
				_ENV = sendingMessage
				sendingMessage.data = dataArray
				sendingMessage.isHistory = false
				sendingMessage.chatChannel = chatChannel
				sendingMessage.chatDataSet = chatSet
				sendingMessage.isWrapped = true
				sendingMessage.isNeedScroll = true
				chatDataMgr:addChatData(sendingMessage)
			end
		else
			djCtrl:sendMessage(sendingMessage, messageType)
			_ENV = sendingMessage
			sendingMessage.data = dataArray
			sendingMessage.isHistory = false
			sendingMessage.chatChannel = chatChannel
			sendingMessage.chatDataSet = chatSet
			sendingMessage.isWrapped = true
			sendingMessage.isNeedScroll = true
			chatDataMgr:addChatData(sendingMessage)
		end
		chatSendMgr:sendMsgTimeOutManage(newChatIndex, chatChannel, chatSet)
	elseif curChannel == gChatChannel.KINGDOM then
		if false == chatCtrl:canChat() then
			SoraDShowMsgTip(i18n("common_text_1039"), "#icon_mail_lock.png")
			return
		end
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canChatInWorld()
		if not canChat then
			_ENV = chatSendMgr.sendMsgTimeOutManage
			chatSendMgr.sendMsgTimeOutManage.lv = lv
			SoraDShowMsgTip(i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage))
			return
		end
		if messageType == gChatTypeDef.chat_content_expression then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.kingdomEmotion)
			if canSend == false then
				return
			end
			_ENV = i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage)
			i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).grupid = grupid
			i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).id = id
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage))
		end
		local newChatIndex = chatIndex or chatSendMgr:getNewChatIndex()
		print("发送国家聊天信息: message = ", message, "messageType = ", messageType)
		message = string.ltrim(message)
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
			message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
		end
		print("过滤后:", message)
		if message == nil or message == "" then
			return
		end
		local chatChannel = gChatChannel.KINGDOM
		local chatSet = gChatSet.TOTAL
		_ENV = message
		message.chatChannel = chatChannel
		message.chatSet = chatSet
		message.messageType = messageType
		message.message = message
		message.chatIndex = newChatIndex
		message.packetId = packetId
		local message.replyMsg, param = replyMsg, message
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		chatCtrl = chatSendMgr
		local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
		print("添加到新消息中------------")
		_ENV = i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage)
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).data = dataArray
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).isHistory = false
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).chatChannel = chatChannel
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).chatDataSet = chatSet
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).isWrapped = true
		i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage).isNeedScroll = true
		chatDataMgr:addChatData(i18n("common_text_3669", chatSendMgr.sendMsgTimeOutManage))
		local wrapMessage = self:buildWrapSendParam(message, newChatIndex, packetId, replyMsg)
		chatCtrl:sendKingDomMessage(wrapMessage, messageType)
		chatSendMgr:sendMsgTimeOutManage(newChatIndex, chatChannel, chatSet)
	elseif curChannel == gChatChannel.TEAM then
		if false == chatCtrl:canChat() then
			SoraDShowMsgTip(i18n("common_text_1039"), "#icon_mail_lock.png")
			return
		end
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		local playerId = chatFunctions:getSelfId()
		local newChatIndex = chatIndex or chatSendMgr:getNewChatIndex()
		print("发送小队聊天信息: message = ", message, "messageType = ", messageType, "chatIndex = " .. newChatIndex)
		if messageType == gChatTypeDef.chat_content_expression then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.teamEmotion)
			if canSend == false then
				return
			end
			_ENV = "messageType = "
			;("messageType = ").grupid = grupid
			;("messageType = ").id = id
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, "messageType = ")
		end
		if messageType == gChatTypeDef.chat_content_audio then
			local chatChannel = gChatChannel.TEAM
			local chatSet = gChatSet.TOTAL
			_ENV = gSDKDef.TDonEvent.click_emoticon_single
			gSDKDef.TDonEvent.click_emoticon_single.chatChannel = chatChannel
			gSDKDef.TDonEvent.click_emoticon_single.chatSet = chatSet
			gSDKDef.TDonEvent.click_emoticon_single.messageType = messageType
			gSDKDef.TDonEvent.click_emoticon_single.message = message
			local gSDKDef.TDonEvent.click_emoticon_single.chatIndex, param = newChatIndex, gSDKDef.TDonEvent.click_emoticon_single
			local sendingMessage = chatSendMgr:createSendingMessage(param)
			chatCtrl = chatSendMgr
			local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
		elseif messageType == gChatTypeDef.chat_content_devil_valley_battle then
			_ENV = gChatTypeDef.chat_content_devil_valley_battle
			gChatTypeDef.chat_content_devil_valley_battle.message = message
			local gChatTypeDef.chat_content_devil_valley_battle.chatIndex, wrapMessage = newChatIndex, gChatTypeDef.chat_content_devil_valley_battle
			chatCtrl:sendTeamMessage(wrapMessage, messageType)
			_ENV = chatCtrl
			chatCtrl.msg = "MESSAGE_CHAT_SCROLL_JUMPTO_BOTTOM"
			chatCtrl.chatChannel = gChatChannel.TEAM
			SoraDSendMessage(chatCtrl)
		else
			message = string.ltrim(message)
			if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
				message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
			end
			if message == nil or message == "" then
				return
			end
			local chatChannel = gChatChannel.TEAM
			local chatSet = gChatSet.TOTAL
			_ENV = message
			message.chatChannel = chatChannel
			message.chatSet = chatSet
			message.messageType = messageType
			message.message = message
			message.chatIndex = newChatIndex
			message.packetId = packetId
			local message.replyMsg, param = replyMsg, message
			local sendingMessage = chatSendMgr:createSendingMessage(param)
			chatCtrl = chatSendMgr
			local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
			_ENV = chatSendMgr.sendMsgTimeOutManage
			chatSendMgr.sendMsgTimeOutManage.data = dataArray
			chatSendMgr.sendMsgTimeOutManage.isHistory = false
			chatSendMgr.sendMsgTimeOutManage.chatChannel = chatChannel
			chatSendMgr.sendMsgTimeOutManage.chatSet = chatSet
			chatSendMgr.sendMsgTimeOutManage.isWrapped = true
			chatSendMgr.sendMsgTimeOutManage.isNeedScroll = true
			chatDataMgr:addChatData(chatSendMgr.sendMsgTimeOutManage)
			local wrapMessage = self:buildWrapSendParam(message, newChatIndex, packetId, replyMsg, isAtAll, atUserMap)
			chatCtrl:sendTeamMessage(wrapMessage, messageType)
			chatSendMgr:sendMsgTimeOutManage(newChatIndex, chatChannel)
		end
	elseif curChannel == gChatChannel.ALLIANCE then
		if false == chatCtrl:canChat() then
			SoraDShowMsgTip(i18n("common_text_1039"), "#icon_mail_lock.png")
			return
		end
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canChatInAlliance()
		if not canChat then
			_ENV = chatSendMgr:createSendingMessage(param)
			chatSendMgr:createSendingMessage(param).lv = lv
			SoraDShowMsgTip(i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))))
			return
		end
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		local playerId = chatFunctions:getSelfId()
		local isForbid = allianceMsg:isLordInShieldList(playerId)
		if isForbid and true == isForbid then
			SoraDShowMsgTip(i18n("common_text_2766"), "#icon_mail_lock.png")
			return
		end
		local newChatIndex = chatIndex or chatSendMgr:getNewChatIndex()
		print("发送联盟聊天信息: message = ", message, "messageType = ", messageType, "chatIndex = " .. newChatIndex)
		if messageType == gChatTypeDef.chat_content_expression then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.allianceEmotion)
			if canSend == false then
				return
			end
			_ENV = "messageType = "
			;("messageType = ").grupid = grupid
			;("messageType = ").id = id
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, "messageType = ")
		end
		if messageType == gChatTypeDef.chat_content_audio then
			local rank
			if not worldMapDefine.isInTeamStatus() then
				local memberMgr = gametop.playertop_:getModule("memberMgr")
				local member = memberMgr:getOwnMember()
				rank = member:getProperty("rank")
			end
			local chatChannel = gChatChannel.ALLIANCE
			local chatSet = gChatSet.TOTAL
			_ENV = member:getProperty("rank")
			member:getProperty("rank").chatChannel = chatChannel
			member:getProperty("rank").chatSet = chatSet
			member:getProperty("rank").messageType = messageType
			member:getProperty("rank").message = message
			member:getProperty("rank").chatIndex = newChatIndex
			local member:getProperty("rank").alv, param = rank, member:getProperty("rank")
			local sendingMessage = chatSendMgr:createSendingMessage(param)
			chatCtrl = chatSendMgr
			local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
			chatCtrl = i18n("common_text_3667", (chatSendMgr:createSendingMessage(param)))
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isHistory = false
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).chatChannel = chatChannel
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).chatDataSet = chatSet
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isWrapped = true
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isNeedScroll = true
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param)))[1] = dataArray
			chatDataMgr:addChatData(i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))))
		elseif messageType == gChatTypeDef.chat_content_devil_valley_battle then
			_ENV = gChatTypeDef.chat_content_devil_valley_battle
			gChatTypeDef.chat_content_devil_valley_battle.message = message
			local gChatTypeDef.chat_content_devil_valley_battle.chatIndex, wrapMessage = newChatIndex, gChatTypeDef.chat_content_devil_valley_battle
			chatCtrl:sendAllianceMessage(wrapMessage, messageType)
			_ENV = chatCtrl
			chatCtrl.msg = "MESSAGE_CHAT_SCROLL_JUMPTO_BOTTOM"
			chatCtrl.chatChannel = gChatChannel.ALLIANCE
			SoraDSendMessage(chatCtrl)
		else
			message = string.ltrim(message)
			if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
				message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
			end
			if message == nil or message == "" then
				return
			end
			local rank
			if not worldMapDefine.isInTeamStatus() then
				local memberMgr = gametop.playertop_:getModule("memberMgr")
				local member = memberMgr:getOwnMember()
				rank = member:getProperty("rank")
			end
			local chatChannel = gChatChannel.ALLIANCE
			local chatSet = gChatSet.TOTAL
			_ENV = member:getProperty("rank")
			member:getProperty("rank").chatChannel = chatChannel
			member:getProperty("rank").chatSet = chatSet
			member:getProperty("rank").messageType = messageType
			member:getProperty("rank").message = message
			member:getProperty("rank").chatIndex = newChatIndex
			member:getProperty("rank").alv = rank
			member:getProperty("rank").packetId = packetId
			local member:getProperty("rank").replyMsg, param = replyMsg, member:getProperty("rank")
			local sendingMessage = chatSendMgr:createSendingMessage(param)
			sendingMessage.isAtAll = isAtAll
			chatCtrl, sendingMessage.atUserMap = chatSendMgr, atUserMap
			local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
			_ENV = i18n("common_text_3667", (chatSendMgr:createSendingMessage(param)))
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).data = dataArray
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isHistory = false
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).chatChannel = chatChannel
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).chatSet = chatSet
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isWrapped = true
			i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))).isNeedScroll = true
			chatDataMgr:addChatData(i18n("common_text_3667", (chatSendMgr:createSendingMessage(param))))
			local wrapMessage = self:buildWrapSendParam(message, newChatIndex, packetId, replyMsg, isAtAll, atUserMap)
			chatCtrl:sendAllianceMessage(wrapMessage, messageType)
			chatSendMgr:sendMsgTimeOutManage(newChatIndex, chatChannel)
		end
	elseif curChannel == gChatChannel.MAIL then
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canSendChatMail()
		if not canChat then
			_ENV = chatSendMgr:getNewChatIndex()
			chatSendMgr:getNewChatIndex().lv = lv
			SoraDShowMsgTip(i18n("common_text_3668", (chatSendMgr:getNewChatIndex())))
			return
		end
		if messageType == gChatTypeDef.chat_content_text then
			messageType = gChatMailContentType.content_text
		elseif messageType == gChatTypeDef.chat_content_expression then
			messageType = gChatMailContentType.content_emo
		end
		if messageType == gChatMailContentType.content_emo then
			local canSend = chatSendMgr:checkIntervalTime(gChatSendIntervalType.mailPrivateMsg)
			if canSend == false then
				return
			end
			_ENV = i18n("common_text_3668", (chatSendMgr:getNewChatIndex()))
			i18n("common_text_3668", (chatSendMgr:getNewChatIndex())).grupid = grupid
			i18n("common_text_3668", (chatSendMgr:getNewChatIndex())).id = id
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_single, i18n("common_text_3668", (chatSendMgr:getNewChatIndex())))
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
		print.avatarFrameId = avatarFrameId
		local print.replyMsg, content = replyMsg, print
		SoraDGetCtrl("mailCtrl"):sendChatMail(self.curChatInfo.target, content)
	elseif curChannel == gChatChannel.CHATROOM then
		print("function chatRoomView:chatSendOneMessage(target, data) ---------------------------------")
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canSendChatMail()
		if not canChat then
			_ENV = chatFunctions:getIsSelfHegemon()
			chatFunctions:getIsSelfHegemon().lv = lv
			SoraDShowMsgTip(i18n("common_text_3668", (chatFunctions:getIsSelfHegemon())))
			return
		end
		local chatRoom = SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target)
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
		local crid = self.curChatInfo.target
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
		i18n("common_text_2213").headWearId = headWearId
		i18n("common_text_2213").isAtAll = isAtAll
		i18n("common_text_2213").atUserMap = atUserMap
		local i18n("common_text_2213").replyMsg, msgData = replyMsg, i18n("common_text_2213")
		SoraDGetCtrl("chatroomCtrl"):reqChatRoomSendMsg(crid, msgData)
	elseif curChannel == gChatChannel.CAMP or curChannel == gChatChannel.VIEWER then
		message = string.ltrim(message)
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
			message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
		end
		if message == nil or message == "" then
			return
		end
		local newChatIndex = chatIndex or chatSendMgr:getNewChatIndex()
		local chatChannel = curChannel
		local chatSet = gChatSet.TOTAL
		_ENV = SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target)
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).chatChannel = chatChannel
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).chatSet = chatSet
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).messageType = messageType
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).message = message
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).chatIndex = newChatIndex
		SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).packetId = packetId
		local SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target).replyMsg, param = replyMsg, SoraDGetCtrl("chatroomCtrl").chatroomMgr:getChatRoom(self.curChatInfo.target)
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		chatCtrl = chatSendMgr
		local chatSendMgr[1], dataArray = sendingMessage, chatSendMgr
		_ENV = gametop.playertop_:getModule("dressCtrl")
		gametop.playertop_:getModule("dressCtrl").data = dataArray
		gametop.playertop_:getModule("dressCtrl").isHistory = false
		gametop.playertop_:getModule("dressCtrl").chatChannel = chatChannel
		gametop.playertop_:getModule("dressCtrl").chatDataSet = chatSet
		gametop.playertop_:getModule("dressCtrl").isWrapped = true
		gametop.playertop_:getModule("dressCtrl").isNeedScroll = true
		chatDataMgr:addChatData((gametop.playertop_:getModule("dressCtrl")))
		local wrapMessage = self:buildWrapSendParam(message, newChatIndex, packetId, replyMsg, isAtAll, atUserMap)
		if curChannel == gChatChannel.CAMP then
			chatCtrl:sendMessageByType(gChatTypeDef.chat_camp_type, wrapMessage, messageType)
		elseif curChannel == gChatChannel.VIEWER then
			chatCtrl:sendMessageByType(gChatTypeDef.chat_viewer_type, wrapMessage, messageType)
		end
	end
end
function chatView:canSendDjGift(goldCount, data)
	local canSend = true
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local haveCount = backpackCtrl:getItemCount(data.itemID)
	if haveCount <= 0 then
		shopItemID = data.shopItemID
		canSend = SoraDEnoughGold(goldCount, true)
	end
	return canSend
end
function chatView:contentViewOffset(target, data)
	local targetContentView = self.chatNode[self.curChannel]
	targetContentView:onOffsetUI(data)
	self.chatSelectBottomView:onOffsetUI(data)
	local offsetY = data.offsetY
	local duration = data.duration
	local isShowKeyboardMask = data.isShowKeyboardMask
	print("scroll offsetY: " .. offsetY)
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
function chatView:contentViewPosReset(target, data)
	print("doing reset --------")
	local targetContentView = self.chatNode[self.curChannel]
	targetContentView:onOffsetUI(data)
	self.chatSelectBottomView:onOffsetUI(data)
	local duration = data.duration
	local isShowKeyboardMask = data.isShowKeyboardMask
	if isShowKeyboardMask then
		print("取消吞没消息")
		self.maskArea:setVisible(false)
		local actMoveTo5 = cca.moveTo(duration, self.oriMaskAreaPos.x, self.oriMaskAreaPos.y)
		self.maskArea:stopAllActions()
		self.maskArea:runAction(actMoveTo5)
	end
end
function chatView:changeToChannel(chatChannel)
	local preChannel = self.curChannel
	if preChannel ~= chatChannel and chatCtrl:checkUnreadAtSelfChannel(preChannel) then
		chatCtrl:cleanUnreadAtSelfUserList(preChannel, self.curChatInfo and self.curChatInfo.target)
		self.chatNode[preChannel]:updateAtSelfInfo()
	end
	self.curChannel = chatChannel
	if self.curChatInfo then
		self.curChatInfo.chatChannel = chatChannel
	else
		chatCtrl = self.curChatInfo
		self.curChatInfo, self.curChatInfo.chatChannel = self.curChatInfo, chatChannel
	end
	chatDataMgr:setGChatChannel(chatChannel)
	chatDataMgr:saveGChatChannel()
	chatDataMgr:setChatChannelInfo(self.curChatInfo)
	self:checkInitChannel(chatChannel)
	self:showChatChannel(chatChannel)
	self:toogleSelectBottomUI(false)
	chatCtrl = self
	self.msg = "MESSAGE_CHAT_CLEAR_REPLY_MSG"
	SoraDSendMessage(self)
	chatCtrl = self
	self.msg = "MESSAGE_CHAT_GO_TO_CHANNEL"
	self.channel = chatChannel
	SoraDSendMessage(self)
	self:updateAllianceRedIcon()
end
function chatView:OnBtnChangeClick(tag, name)
	self:changeToChannel(tag)
	self:removeAncientTreasure()
	if tag == gChatChannel.ALLIANCE and allianceMgr:hasJoinAlliance() and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
		self:updateAncientTreasure()
	end
	if self.curChannel == gChatChannel.ALLIANCE then
		self:initChatJoinAlliance()
	else
		if self.chatJoinAlliance then
			self.chatJoinAlliance:setVisible(false)
		end
		print("主播聊天")
		if self.curChannel == gChatChannel.DJ then
			worldMapDefine.isInDJChatView = true
			djCtrl:checkAndSendPrivilegeDebut()
		else
			worldMapDefine.isInDJChatView = false
		end
	end
end
function chatView:onBtnVoiceRoom(target, eventType)
	if eventType == ccui.TouchEventType.began then
		print("todo:蔡拓：打开语音聊天室")
		SoraDPlaySound()
		if djCtrl.isListen then
			SoraDShowMsgTip(i18n("Anchor_text_58"))
		else
			VoiceChatSDKManager.openView()
			self:toogleSelectBottomUI(false)
		end
	end
end
function chatView:onBtnSetting(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curChannel == gChatChannel.CHATROOM and self.curChatInfo.target then
			dump(self.curChatInfo, "elf.curChatInfo")
			local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
			if chatroomCtrl:checkChatRoomState(curChannel) then
				local crid = self.curChatInfo.target
				local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(crid)
				_ENV = nil
				;(nil).chatRoom = chatRoom
				uiManager:show("ChatRoomInfoView", nil)
			else
				SoraDShowMsgTip(i18n("common_text_2213"))
			end
		else
			SoraDCreatePanel("chatShieldSettingView"):show()
		end
	end
end
function chatView:OnMaskArea(target, eventType)
	if eventType == ccui.TouchEventType.began then
		print("点击到了掩盖层上", self.isShowList)
		if self.isOpenEmotion then
			self:hideEmotionUI(nil, nil)
			self.maskArea:setVisible(false)
			self.isOpenEmotion = false
		end
		if self.isOpenPrize then
			self:hidePrizeUI(nil, nil)
			self.maskArea:setVisible(false)
			self.isOpenPrize = false
		end
		if self.isOpenKeyBoard then
			self.maskArea:setVisible(false)
			_ENV = self.maskArea
			self.maskArea.msg = "MESSAGE_CHAT_CLOSE_IME"
			self.maskArea.viewType = "chatView"
			SoraDSendMessage(self.maskArea)
			self.isOpenKeyBoard = false
		end
		if self.isShowList then
			self:hidePersonalList()
		end
	end
end
function chatView:onTouchPanel(target, event)
	if event == ccui.TouchEventType.ended then
		if self.isMoveH then
			self.touchPanel:setSwallowTouches(false)
			self:onAfterDrag()
		end
		self.isMoveV = false
		self.isMoveH = false
	elseif event == ccui.TouchEventType.moved then
		if self.isShowList then
			return
		end
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local touchDeltaX = touchmovePoint.x - touchBeganPoint.x
		local touchDeltaY = touchmovePoint.y - touchBeganPoint.y
		if self.isMoveH == false and self.isMoveV == false then
			if math.abs(touchDeltaX) >= self.judgeHMove and self.isMoveV == false and math.abs(touchDeltaY) < self.judgeVMove then
				self.isMoveH = true
			end
			if math.abs(touchDeltaX) < self.judgeHMove and math.abs(touchDeltaY) >= self.judgeVMove and self.isMoveH == false then
				self.isMoveV = true
			end
		end
		if self.isMoveH == true then
			if not self.touchPanel:isSwallowTouches() then
				self.touchPanel:setSwallowTouches(true)
			end
			local targetX = self.beginContentPos.x + touchDeltaX
			print("targetX", targetX, self.beginContentPos.x, touchDeltaX)
			if SoraDFIsRA() then
				targetX = math.max(0, math.min(SoraDFSign(_defaultParam.maxOffsetX), targetX))
			else
				targetX = math.min(0, math.max(SoraDFSign(_defaultParam.maxOffsetX), targetX))
			end
			self.nodeContentViews:setPositionX(targetX)
		elseif self.isMoveV == true then
		end
	elseif event == ccui.TouchEventType.canceled then
		if self.isMoveH then
			self.touchPanel:setSwallowTouches(false)
			self:onAfterDrag()
		end
		self.isMoveV = false
		self.isMoveH = false
	elseif event == ccui.TouchEventType.began then
		self.nodeContentViews:stopAllActions()
		self.beginContentPos = cc.p(self.nodeContentViews:getPosition())
		dump(self.beginContentPos, "self.beginContentPos", 10)
		self.isMoveV = false
		self.isMoveH = false
		print("self.maskArea:isSwallowTouches()", self.maskArea:isSwallowTouches())
	end
end
function chatView:openEmotionUI(target, data)
	self.isOpenEmotion = true
	local delayTime = self.isOpenKeyBoard and 0 or 0.25
	local offsetY = math.abs(self.oriChatEmotionPageViewPos.y)
	local deltaTextHeight = 0
	print("offsetY = ", offsetY, ", deltaTextHeight = ", deltaTextHeight)
	_ENV = ", deltaTextHeight = "
	;(", deltaTextHeight = ").duration = delayTime
	;(", deltaTextHeight = ").offsetY = offsetY + deltaTextHeight
	;(", deltaTextHeight = ").isMoveTo = true
	self:contentViewOffset(self, ", deltaTextHeight = ")
	print("掩盖层的目标高度: " .. offsetY)
	local actMoveTo = cca.moveTo(delayTime, 0, offsetY + 90)
	self.maskArea:stopAllActions()
	self.maskArea:setVisible(true)
	self.maskArea:setSwallowTouches(true)
	self.maskArea:runAction(actMoveTo)
	local actMove8 = cca.moveTo(delayTime, 0, self.oriTouchPanelPos.y + offsetY)
	self.touchPanel:stopAllActions()
	self.touchPanel:runAction(actMove8)
	local actMove9 = cca.moveTo(delayTime, 0, offsetY)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove9)
	self.chatEmotionPageView:setVisible(true)
	local actMoveTo2 = cca.moveTo(delayTime, 0, 0)
	self.chatEmotionPageView:stopAllActions()
	self.chatEmotionPageView:runAction(actMoveTo2)
	self:toogleSelectBottomUI(false)
end
function chatView:hideEmotionUI(target, data, delay)
	delay = delay or 0.25
	local deltaHeight = 0
	_ENV = nil
	;(nil).duration = delay
	;(nil).offsetY = deltaHeight
	self:contentViewPosReset(self, nil)
	self.chatEmotionPageView:setVisible(false)
	self.chatEmotionPageView:stopAllActions()
	self.maskArea:stopAllActions()
	self.ccsNightBg:stopAllActions()
	self.touchPanel:stopAllActions()
	if delay == 0 then
		self.chatEmotionPageView:setPositionY(self.oriChatEmotionPageViewPos.y)
		self.maskArea:setPositionY(90)
		self.ccsNightBg:setPositionY(0)
		self.touchPanel:setPositionY(self.oriTouchPanelPos.y)
	else
		local actMoveTo1 = cca.moveTo(delay, self.oriChatEmotionPageViewPos.x, self.oriChatEmotionPageViewPos.y)
		self.chatEmotionPageView:runAction(actMoveTo1)
		local actMovTo2 = cca.moveTo(delay, 0, 90)
		self.maskArea:runAction(actMovTo2)
		local actMove9 = cca.moveTo(delay, 0, 0)
		self.ccsNightBg:runAction(actMove9)
		local actMove8 = cca.moveTo(delay, 0, self.oriTouchPanelPos.y)
		self.touchPanel:runAction(actMove8)
	end
	local targetContentView = self.chatNode[self.curChannel]
	if targetContentView.bottomViewNode then
		targetContentView.bottomViewNode:switchBtn(false)
	end
end
function chatView:openPrizeUI(target, data)
	self.isOpenPrize = true
	local offsetY = math.abs(self.oriChatPrizePageViewPosY)
	local deltaTextHeight = 0
	print("offsetY = ", offsetY, ", deltaTextHeight = ", deltaTextHeight)
	_ENV = ", deltaTextHeight = "
	;(", deltaTextHeight = ").duration = 0.25
	;(", deltaTextHeight = ").offsetY = offsetY + deltaTextHeight
	;(", deltaTextHeight = ").isMoveTo = true
	self:contentViewOffset(self, ", deltaTextHeight = ")
	print("掩盖层的目标高度: " .. offsetY)
	local actMoveTo = cca.moveTo(0.25, 0, offsetY + 90)
	self.maskArea:stopAllActions()
	self.maskArea:setVisible(true)
	self.maskArea:setSwallowTouches(true)
	self.maskArea:runAction(actMoveTo)
	local actMove8 = cca.moveTo(0.25, 0, self.oriTouchPanelPos.y + offsetY)
	self.touchPanel:stopAllActions()
	self.touchPanel:runAction(actMove8)
	local actMove9 = cca.moveTo(0.25, 0, offsetY)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove9)
end
function chatView:hidePrizeUI(target, data)
	local deltaHeight = 0
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = deltaHeight
	self:contentViewPosReset(self, nil)
	local actMovTo2 = cca.moveTo(0.25, 0, 90)
	self.maskArea:stopAllActions()
	self.maskArea:runAction(actMovTo2)
	local actMove9 = cca.moveTo(0.25, 0, 0)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove9)
	local actMove8 = cca.moveTo(0.25, 0, self.oriTouchPanelPos.y)
	self.touchPanel:stopAllActions()
	self.touchPanel:runAction(actMove8)
	local targetContentView = self.chatNode[self.curChannel]
	if targetContentView.bottomViewNode then
		targetContentView.bottomViewNode:switchBtn(false)
	end
end
function chatView:showKeyboardMask(target, data)
	self.isOpenKeyBoard = true
	self.maskArea:setVisible(true)
	if self.isOpenEmotion then
		self:hideEmotionUI(nil, nil, 0)
		self.isOpenEmotion = false
	end
	self:toogleSelectBottomUI(false)
end
function chatView:hideKeyboardMask(target, data)
	if self.isOpenEmotion then
		return
	end
	print("chatView:hideKeyboardMask")
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
function chatView:showPersonalList(noAction)
	self.isShowList = true
	if not noAction then
		self:doEaseAction(self, 0.25, SoraDFPosX(1280, 0) + SoraDFPosX(-640, 0), 0)
		local actMove9 = cca.moveTo(0.25, 0, 0)
		self.ccsPerList:setPosition(cc.p(SoraDFPosX(640, 0), 0))
		self.ccsPerList:stopAllActions()
		self.ccsPerList:runAction(actMove9)
		self.ccsPerList:setVisible(true)
		local actMoveTo = cca.moveTo(0.25, SoraDFPosX(-640, 0), 90)
		self.maskArea:stopAllActions()
		self.maskArea:setVisible(true)
		self.maskArea:setSwallowTouches(true)
		self.maskArea:runAction(actMoveTo)
		local actMove8 = cca.moveTo(0.25, self.oriTouchPanelPos.x + SoraDFPosX(-640, 0), self.oriTouchPanelPos.y)
		self.touchPanel:stopAllActions()
		self.touchPanel:runAction(actMove8)
		for i, v in ipairs(self.channelList) do
			if v.tag ~= gChatChannel.MAIL and v.tag ~= gChatChannel.CHATROOM then
				self.chatNode[v.tag]:setVisible(false)
			end
		end
	else
		self.ccsPerList:setPosition(cc.p(0, 0))
		self.ccsPerList:setVisible(true)
		self.nodeContentViews:stopAllActions()
		self.nodeContentViews:setPosition(SoraDFPosX(1280, 0) + SoraDFPosX(-640, 0), 0)
		self.maskArea:stopAllActions()
		self.maskArea:setVisible(false)
		self.maskArea:setPosition(SoraDFPosX(-640, 0), 90)
		self.touchPanel:stopAllActions()
		self.touchPanel:setPosition(self.oriTouchPanelPos.x + SoraDFPosX(-640, 0), self.oriTouchPanelPos.y)
		for i, v in ipairs(self.channelList) do
			if v.tag ~= gChatChannel.MAIL and v.tag ~= gChatChannel.CHATROOM then
				self.chatNode[v.tag]:setVisible(false)
			end
		end
	end
end
function chatView:hidePersonalList(noAction)
	print("hidePersonalList", noAction)
	if not noAction then
		self.nodeContentViews:stopAllActions()
		self:doEaseAction(self, 0.25, SoraDFPosX(1280, 0), 0)
		local actMoveTo = cca.moveTo(0.25, 0, 90)
		self.maskArea:stopAllActions()
		self.maskArea:setVisible(false)
		self.maskArea:runAction(actMoveTo)
		local actMove8 = cca.moveTo(0.25, 0, self.oriTouchPanelPos.y)
		self.touchPanel:stopAllActions()
		self.touchPanel:runAction(actMove8)
		_UPVALUE1_ = 0
		;(0)[1] = cca.delay(0.25)
		;(0)[2] = cca.callFunc(function()
			for i, v in ipairs(self.channelList) do
				if v.tag ~= gChatChannel.MAIL and v.tag ~= gChatChannel.CHATROOM then
					self.chatNode[v.tag]:setVisible(true)
				end
			end
			self.ccsPerList:setVisible(false)
			self.isShowList = false
		end)
		;(0)[3] = cca.callFunc(function()
			for i, v in ipairs(self.channelList) do
				if v.tag ~= gChatChannel.MAIL and v.tag ~= gChatChannel.CHATROOM then
					self.chatNode[v.tag]:setVisible(true)
				end
			end
			self.ccsPerList:setVisible(false)
			self.isShowList = false
		end)
		self:runAction(cca.seq(0))
	else
		self.ccsPerList:setVisible(false)
		self.nodeContentViews:stopAllActions()
		self.nodeContentViews:setPosition(SoraDFPosX(1280, 0), 0)
		self.maskArea:stopAllActions()
		self.maskArea:setVisible(false)
		self.maskArea:setPosition(0, 90)
		self.touchPanel:stopAllActions()
		self.touchPanel:setPosition(0, self.oriTouchPanelPos.y)
		for i, v in ipairs(self.channelList) do
			if v.tag ~= gChatChannel.MAIL and v.tag ~= gChatChannel.CHATROOM then
				self.chatNode[v.tag]:setVisible(true)
			end
		end
		self.isShowList = false
	end
end
function chatView:resizeChatTip(text)
	local deltaSide = 24
	local sizeImgIcon = 34
	local deltaImgIcon = 20
	self.chat_tip_text:setString(text or "")
	local widthText = self.chat_tip_text:getContentSize().width
	local totalWidth = widthText + deltaSide + sizeImgIcon
	local totalHeight = 40
	self.chat_tip_bg:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_node:setContentSize(cc.size(totalWidth, totalHeight))
	self.chat_tip_node:setAnchorPoint(SoraDFAP(0, 1))
	self.chat_tip_node:setPosition(SoraDFPoint(0, display.height - 200))
	self.chat_tip_bg:setAnchorPoint(cc.p(0.5, 0))
	self.chat_tip_bg:setPosition(cc.p(totalWidth / 2, 0))
	self.chat_tip_text:setTextHorizontalAlignment(SoraDFLabelL())
	self.chat_tip_text:setAnchorPoint(SoraDFAP(0, 0.5))
	self.chat_tip_text:setPosition(SoraDFPoint(deltaSide, totalHeight / 2, totalWidth))
	self.chat_tip_icon:setAnchorPoint(cc.p(0.5, 0.5))
	self.chat_tip_icon:setPosition(SoraDFPoint(totalWidth - deltaImgIcon, totalHeight / 2, totalWidth))
end
function chatView:showChatChannel(chatChannel, isAction)
	local targetX = SoraDFSign(self.channelX[chatChannel])
	if self.isShowList and chatChannel ~= gChatChannel.MAIL and chatChannel ~= gChatChannel.CHATROOM then
		self.ccsNightBg:setPositionX(0)
		self.isShowList = false
		self:hidePersonalList(true)
	end
	if not self.curChatInfo.key and (chatChannel == gChatChannel.MAIL or chatChannel == gChatChannel.CHATROOM) then
		self:showPersonalList(true)
		return
	end
	if not isAction then
		self.nodeContentViews:setPositionX(targetX)
	else
		local dt = 0.3
		self.nodeContentViews:runAction(cca.moveTo(dt, targetX, 0))
	end
end
function chatView:onAfterDrag()
	local speed = 2000
	local curContentPos = cc.p(self.nodeContentViews:getPosition())
	local deltaX = curContentPos.x - self.beginContentPos.x
	local chatChannel = self.curChannel
	print("滑动距离:", deltaX)
	if math.abs(deltaX) > _defaultParam.deltaDrag then
		print("判断产生了滑动")
		local curIndex = 1
		for i, v in ipairs(self.channelList) do
			if v.tag == chatChannel then
				curIndex = i
				break
			end
		end
		if SoraDFSign(deltaX) > 0 then
			curIndex = curIndex + 1
		else
			curIndex = curIndex - 1
		end
		curIndex = math.max(1, math.min(curIndex, #self.channelList))
		chatChannel = self.channelList[curIndex].tag
	end
	local targetX = SoraDFSign(self.channelX[chatChannel])
	local dt = math.abs(curContentPos.x - targetX) / speed
	local targetY = curContentPos.y
	self:doEaseAction(self.nodeContentViews, dt, targetX, targetY)
	self:dragCheckInitChannel(chatChannel, dt + 0.05)
end
function chatView:checkInitChannel(chatChannel, dt)
	print("检测初始化:", chatChannel)
	local targetView = self.chatNode[chatChannel]
	if dt then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(dt)
		;(nil)[2] = cca.callFunc(function()
			if not targetView:isInit() then
				targetView = nil
				;(nil).chatChannel = chatChannel
				;(nil).chatDelegate = self
				targetView:init(nil)
			end
		end)
		;(nil)[3] = cca.callFunc(function()
			if not targetView:isInit() then
				targetView = nil
				;(nil).chatChannel = chatChannel
				;(nil).chatDelegate = self
				targetView:init(nil)
			end
		end)
		targetView:runAction(cca.seq(nil))
	elseif not targetView:isInit() then
		_ENV = cca.seq(nil)
		cca.seq(nil).chatChannel = chatChannel
		cca.seq(nil).chatDelegate = self
		targetView:init(cca.seq(nil))
	end
end
function chatView:dragCheckInitChannel(chatChannel, dt)
	local targetView = self.chatNode[chatChannel]
	if dt then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(dt)
		;(nil)[2] = cca.callFunc(function()
			if self.curChannel == chatChannel then
				return
			end
			self.nodeTab:clickByTag(chatChannel)
		end)
		;(nil)[3] = cca.callFunc(function()
			if self.curChannel == chatChannel then
				return
			end
			self.nodeTab:clickByTag(chatChannel)
		end)
		targetView:runAction(cca.seq(nil))
	else
		if self.curChannel == chatChannel then
			return
		end
		self.nodeTab:clickByTag(chatChannel)
	end
end
function chatView:doEaseAction(target, dt, targetX, targetY)
	local moveTo = cca.moveTo(dt, targetX, targetY)
	self.nodeContentViews:runAction(cc.EaseOut:create(moveTo, 1))
end
function chatView:refreshAllianceChat()
	print("Update alliance chat channel")
	if self.curChannel == gChatChannel.ALLIANCE then
		self.nodeTab:clickByTag(self.curChannel)
	end
end
function chatView:sMsgAllianceBeKicked(target, data)
	self:refreshAllianceChat()
end
function chatView:onImeEvent(button, eventType)
	self:toogleSelectBottomUI(false)
end
function chatView:updateAncientTreasure(target, data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) and ancientTreasureCtrl:isTreasureStageOpen() then
		if not self.ATNode then
			self.ATNode = display.newNode()
			local spBg = display.newSprite("#frame_main_common_round.png")
			spBg:addTo(self.ATNode, 0)
			local spJz = display.newSprite("#icon_sgjz_chat_01.png")
			spJz:addTo(self.ATNode, 1)
			local spriteBg = display.newSprite("#frame_recharge__sheer_time.png")
			spriteBg:setScaleX(0.5)
			spriteBg:setPosition(cc.p(0, -40))
			spriteBg:addTo(self.ATNode, 2)
			local text = ccui.Text:create(i18n("activity_name_9001201"), "", 20)
			text:setAnchorPoint(cc.p(0.5, 0.5))
			text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			text:setTextAreaSize(cc.size(110, 30))
			text:setColor(cc.c3b(255, 255, 255))
			text:setPosition(cc.p(0, -40))
			text:addTo(self.ATNode, 3)
			local btnAT = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
			btnAT:ignoreContentAdaptWithSize(false)
			btnAT:setAnchorPoint(cc.p(0.5, 0.5))
			btnAT:setPosition(cc.p(0, 0))
			btnAT:setContentSize(cc.size(80, 80))
			btnAT:addTo(self.ATNode, 4)
			btnAT:addTouchEventListener(function(target, event)
				if event == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local panel = SoraDCreatePanel("eventAncientSecretRewardView")
					panel:show()
				end
			end)
			self.ATNode:setPosition(SoraDFPosX(580), display.height - 280)
			self.ATNode:addTo(self, 99)
		end
	else
		self:removeAncientTreasure()
	end
end
function chatView:resetPersonalChat(target, data)
	if data.key == self.curChatInfo.key and (self.curChannel == gChatChannel.MAIL or self.curChannel == gChatChannel.CHATROOM) then
		_ENV = self.curChannel
		self.curChatInfo, self.curChannel.chatChannel = self.curChannel, self.curChannel
		chatDataMgr:setChatChannelInfo(self.curChatInfo)
		_ENV = self.curChatInfo
		self.curChatInfo.chatChannel = self.curChannel
		self.curChatInfo.chatDelegate = self
		self.chatNode[self.curChannel]:init(self.curChatInfo)
		_ENV = self.chatNode[self.curChannel]
		self.chatNode[self.curChannel].msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
		self.chatNode[self.curChannel].chatChannel = self.curChannel
		self.chatNode[self.curChannel].chatSet = gChatSet.TOTAL
		self.chatNode[self.curChannel].content = nil
		SoraDSendMessage(self.chatNode[self.curChannel])
	end
end
function chatView:handleCMD(message)
	if message == "@showfps" then
		cc.Director:getInstance():setDisplayStats(true)
		return true
	elseif message == "@hidefps" then
		cc.Director:getInstance():setDisplayStats(false)
		return true
	elseif message == "@tn" and (userSDKManager.isBeta() or device.platform == "mac") then
		_ENV = cc.Director:getInstance()
		cc.Director:getInstance().msg = "MESSAGE_MAINCITYVIEW_TOGGLE_DARK"
		SoraDSendMessage((cc.Director:getInstance()))
		return true
	end
	return false
end
function chatView:removeAncientTreasure()
	if self.ATNode then
		self.ATNode:removeFromParent()
		self.ATNode = nil
	end
end
function chatView:resetContentInit(chatChannel)
	self.chatNode[chatChannel]:resetInit()
end
function chatView:openPersonalChatView(target, data)
	self:resetContentInit(gChatChannel.MAIL)
	local info = data.selItems[1]
	_ENV = self
	self.chatChannel = gChatChannel.MAIL
	self.key = include("chatFunctions"):getChatMailKey(info.playerId, gChatChannel.MAIL)
	self.tab = gChatChannel.MAIL
	self.target = info.playerId
	self.chatSet = gChatSet.TOTAL
	local self.titleName, params = textParser.formatPlayerName(info.abbr, info.nickName), self
	self:init(params)
	chatSendMgr:requestHistory(params)
end
function chatView:setCapturing(isCapturing)
	self.isCapturing = isCapturing
end
function chatView:initBtnSettingAndVoiceRoom()
	if worldMapDefine.isInSimulatedDrill() then
		self.btnVoiceRoom:setVisible(false)
		self.btnSetting:setVisible(false)
	else
		self.btnSetting:setVisible(true)
		if commonCheck.VOICE_CHATE_ROOM then
			self.btnVoiceRoom:setVisible(true)
			self.btnSetting:setPositionX(SoraDFPosX(520, 400))
		else
			self.btnVoiceRoom:setVisible(false)
			self.btnSetting:setPositionX(SoraDFPosX(590, 540))
		end
	end
end
return chatView
