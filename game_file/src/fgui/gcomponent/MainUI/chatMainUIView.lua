local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatDataModuleAPI = include("chatDataModuleAPI")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local voiceRoomCtrl = SoraDGetCtrl("voiceRoomCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mainUIDef = include("mainUIDef")
local worldMapWarDef = include("worldMapWarDef")
_ENV = "worldMapWarDef"
;("worldMapWarDef").none = 0
;("worldMapWarDef").left = 1
local ("worldMapWarDef").right, HDirection = 2, "worldMapWarDef"
local baseComponent = require("fgui.base.baseComponent")
local chatMainUIView = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/chatMainUIView", chatMainUIView)
function chatMainUIView:onInit()
	self.curChannel = gChatChannel.KINGDOM
	self.singleIsMoved = false
	self.csdList, _ENV, self.channelList, _ENV, self.moveDistanceMinX = gChatChannel.KINGDOM, gChatChannel.KINGDOM, gChatChannel.KINGDOM, gChatChannel.KINGDOM, 32
	self.isShow = true
	self:addClickListener(handler(self, self.onBtnClick))
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onInClick))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.chat:fixPos()
	self.fields.voiceroom_tip:fixPos()
	self.fields.voiceroom_tip:addClickEventListener(handler(self, self.onVoiceRoomClick))
	self.voiceromm_Ani = fguiHelper.get_transitions(self.fields.voiceroom_tip).t0
	self.fields.voiceroom_tip:runAction(ffa.repeatForever(ffa.seq(cca.delay(2), ffa.callFunc(handler(self, self.onVoiceRoomTipFlash)))))
end
function chatMainUIView:onShow()
	self:initWithData()
end
function chatMainUIView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_GO_TO_CHANNEL", handler(self, self.msgGotoChannel))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.upateDJInfo))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GET_COVER_BACK", handler(self, self.updatePersonalRedIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS", handler(self, self.updatePersonalRedIcon))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_UPDATE_TIPS", handler(self, self.onUpdateVoiceRoomTip))
end
function chatMainUIView:onVoiceRoomTipFlash()
	if self.fields.voiceroom_tip:isVisible() then
		self.voiceromm_Ani:play()
	end
end
function chatMainUIView:onUpdateVoiceRoomTip()
	local unreadNum = voiceRoomCtrl:isHasUnreadRoomList()
	dump(unreadNum, "isHasUnreadRoomList")
	self.fields.voiceroom_tip:setVisible(unreadNum)
end
function chatMainUIView:onVoiceRoomClick()
	self:openChatView(true)
end
function chatMainUIView:initWithData()
	chatCtrl = nil
	;(nil)[1] = gChatChannel.KINGDOM
	;(nil)[2] = gChatChannel.ALLIANCE
	local (nil)[3], config = gChatChannel.MAIL, nil
	chatCtrl, self.channelList = gChatChannel.KINGDOM, config
	gChatChannel.KINGDOM[1] = self.fields.Csd_kingdom
	gChatChannel.KINGDOM[2] = self.fields.Csd_alliance
	local gChatChannel.KINGDOM[3], config = self.fields.Csd_personal, gChatChannel.KINGDOM
	self.csdList = config
	if worldMapWarDef.isInWarForbidShowAllianceChat() then
		table.remove(self.channelList, 2)
		local csd = table.remove(self.csdList, 2)
		csd:setVisible(false)
	else
		local csd = self.csdList[2]
		if csd then
			csd:setVisible(true)
		end
	end
	if worldMapDefine.isInNebula() then
		self.fields.Csd_camp:setVisible(true)
		table.insert(self.channelList, 2, gChatChannel.CAMP)
		table.insert(self.csdList, 2, self.fields.Csd_camp)
	elseif worldMapDefine.isInRoaringFlame() then
		self.fields.Csd_camp:setVisible(true)
		table.insert(self.channelList, 3, gChatChannel.TEAM)
		table.insert(self.csdList, 3, self.fields.Csd_camp)
	else
		self.fields.Csd_camp:setVisible(false)
	end
	self.fields.com_ret:initChannelList(self.channelList)
	local beginPosX = SoraDFIsRA() and 0 or 55
	local stepWidth = SoraDFIsRA() and -self:getWidth() or self:getWidth()
	local curIndex = table.indexof(self.channelList, self.curChannel) or 1
	for i, v in ipairs(self.csdList) do
		v:setEffectPath("chatMainUIViewBox")
		v:setPositionX(beginPosX + stepWidth * (i - curIndex))
		_ENV = beginPosX + stepWidth * (i - curIndex)
		;(beginPosX + stepWidth * (i - curIndex)).chatChannel = self.channelList[i]
		v:getEffect():initWithData(beginPosX + stepWidth * (i - curIndex))
		v:setVisible(self.isShow)
	end
	self:updatePersonalRedIcon()
	if self.curChannel == gChatChannel.CAMP then
		chatDataMgr:setGChatChannel(gChatChannel.KINGDOM)
		chatDataMgr:saveGChatChannel()
	end
	self:udpateImgState(self.curChannel)
	if 0 < chatCtrl:getUnreadAtSelfMsg(gChatChannel.ALLIANCE) then
		chatDataMgr:setGChatChannel(gChatChannel.ALLIANCE)
	end
	self:MoveToChannel(chatDataMgr:getGChatChannel(), false)
	self:onUpdateVoiceRoomTip()
end
function chatMainUIView:upateDJInfo()
	self.fields.chat:setShowType(SoraDGetCtrl("djCtrl").isListen and 1 or 0)
end
function chatMainUIView:isHideContent(ret)
	self.isShow = not ret
	for i, v in ipairs(self.csdList) do
		v:setVisible(self.isShow)
	end
	self.fields.chat:setVisible(self.isShow)
end
function chatMainUIView:changeToChannel(chatChannel, bAnimated)
	if self.chatChannel == chatChannel then
		return
	end
	self:MoveToChannel(chatChannel, bAnimated)
	print("设置为聊天~", chatChannel)
	if bAnimated then
		if chatChannel == gChatChannel.ALLIANCE then
			chatChannel = self.fields.Csd_alliance:getEffect():getChatChannel()
		elseif chatChannel == gChatChannel.MAIL then
			chatChannel = self.fields.Csd_personal:getEffect():getChatChannel()
		end
		chatDataMgr:setGChatChannel(chatChannel)
		chatDataMgr:saveGChatChannel()
	end
	if self.curChannel ~= gChatChannel.ALLIANCE or allianceMgr:hasJoinAlliance(true) then
	else
		local panel = SoraDSearchPanelFromManagerByName("chatView")
		if panel then
			panel:removeFromParent()
		end
		panel = SoraDCreatePanel("chatView")
		panel:show()
		panel:init()
	end
end
function chatMainUIView:onBtnClick()
	self:openChatView()
end
function chatMainUIView:openChatView(isFromVoiceRoomTip)
	SoraDPlaySound("uicontrol", 17)
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	local panel = SoraDSearchPanelFromManagerByName("chatView")
	if panel then
		panel:removeFromParent()
	end
	panel = SoraDCreatePanel("chatView")
	panel:show()
	panel:init()
	if isFromVoiceRoomTip and self.fields.voiceroom_tip:isVisible() then
		local djCtrl = gametop.playertop_:getModule("djCtrl")
		if djCtrl.isListen then
			SoraDShowMsgTip(i18n("Anchor_text_58"))
		else
			local seq = ffa.seq(ffa.delay(0), ffa.callFunc(function()
				VoiceChatSDKManager.openView()
			end))
			seq:setTag(996)
			self:stopActionByTag(996)
			self:runAction(seq)
		end
		voiceRoomCtrl:onReadRoomList()
	end
end
function chatMainUIView:onInClick(context)
	self.posBegin = context:getInput():getPosition()
end
function chatMainUIView:onOutClick(context)
	self.posEnd = context:getInput():getPosition()
	if self.posBegin and self.posEnd then
		if self.posEnd.x - self.posBegin.x >= self.moveDistanceMinX then
			self.moveDirection = HDirection.right
			self.singleIsMoved = true
		elseif self.posEnd.x - self.posBegin.x <= -self.moveDistanceMinX then
			self.moveDirection = HDirection.left
			self.singleIsMoved = true
		else
			self.singleIsMoved = false
			self.moveDirection = HDirection.none
		end
		if self.singleIsMoved then
			local isNeedLog = false
			local targetChannel
			local curIndex = table.indexof(self.channelList, self.curChannel) or 1
			local nextIndex = curIndex
			if self.moveDirection == HDirection.left then
				isNeedLog = true
				if SoraDFIsRA() then
					nextIndex = math.max(1, curIndex - 1)
				else
					nextIndex = math.min(#self.channelList, curIndex + 1)
				end
			elseif self.moveDirection == HDirection.right then
				isNeedLog = true
				if SoraDFIsRA() then
					nextIndex = math.min(#self.channelList, curIndex + 1)
				else
					nextIndex = math.max(1, curIndex - 1)
				end
			end
			local targetChannel = self.channelList[nextIndex] or gChatChannel.KINGDOM
			print("targetChannel = ", targetChannel, ", self.curChannel =", self.curChannel)
			self:changeToChannel(targetChannel, true)
			if isNeedLog then
				local curChannel = chatDataMgr:getGChatChannel()
				local channelStr = "kingdom"
				if curChannel == gChatChannel.ALLIANCE then
					channelStr = "alliance"
				elseif curChannel == gChatChannel.MAIL then
					channelStr = "mail"
				elseif curChannel == gChatChannel.CHATROOM then
					channelStr = "chatroom"
				end
				HDirection = self.curChannel
				self.curChannel.channel = channelStr
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_chat_channel, self.curChannel)
			end
			self.moveDirection = HDirection.none
			self.singleIsMoved = false
		end
		self.posBegin = nil
		self.posEnd = nil
	end
end
function chatMainUIView:doAnimationOffsetWithView(view, offsetX)
	if view == nil or 0 == offsetX then
		return
	end
	view:runAction(ffa.moveBy(0.3, offsetX, 0))
end
function chatMainUIView:moveWithView(view, bAnimate, multiple)
	if view then
		local offsetX = multiple * self:getWidth()
		if bAnimate ~= nil and bAnimate == false then
			view:setPositionX(view:getPositionX() + offsetX)
		else
			self:doAnimationOffsetWithView(view, offsetX)
		end
	end
end
function chatMainUIView:MoveToChannel(targetChannel, bAnimate)
	if not worldMapDefine.isInRoaringFlame() and gChatChannel.TEAM == targetChannel then
		targetChannel = gChatChannel.ALLIANCE
	end
	if gChatChannel.CHATROOM == targetChannel then
		targetChannel = gChatChannel.MAIL
	end
	if self.curChannel == targetChannel then
		return
	end
	if gChatChannel.DJ == targetChannel then
		return
	end
	print("目标chatChannel = ", self.curChannel, targetChannel)
	local curIndex = table.indexof(self.channelList, self.curChannel) or 1
	local targetIndex = table.indexof(self.channelList, targetChannel) or 1
	local multiple = SoraDFSign(targetIndex - curIndex)
	for i, v in ipairs(self.csdList) do
		self:moveWithView(v, bAnimate, multiple)
	end
	self.curChannel = targetChannel
	self:udpateImgState(targetChannel)
	self:updatePersonalRedIcon()
end
function chatMainUIView:udpateImgState(targetChannel)
	local curIndex = table.indexof(self.channelList, targetChannel) or 1
	self.fields.com_ret:setShowType(curIndex - 1)
end
function chatMainUIView:msgGotoChannel(target, data)
	local channel = data.channel
	self:MoveToChannel(channel, false)
end
function chatMainUIView:updatePersonalRedIcon()
	local newMessage = gChatMgrs:getMgr("chatCoverMgr"):getTotalNewNum()
	self.fields.chat:setRedVisible(0 < newMessage)
end
return chatMainUIView
