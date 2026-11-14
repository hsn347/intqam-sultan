local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatDataModuleAPI = include("chatDataModuleAPI")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mainUIDef = include("mainUIDef")
_ENV = "mainUIDef"
;("mainUIDef").none = 0
;("mainUIDef").left = 1
local ("mainUIDef").right, HDirection = 2, "mainUIDef"
local chatMainUIView = class("chatMainUIView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatMainUIView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatMainUIView:ctor()
	self:initGroup()
	self.btnChat = SoraDGetChildByName(self, "Button_chat")
	if self.btnChat then
		self.btnChat:setPressedActionEnabled(false)
		self.btnChat:setGroupID(mainUIDef.newGroupID.main)
		self.btnChat:addTouchEventListener(handler(self, self.OnChatClick))
	end
	self.img_chatBg = SoraDGetChildByName(self, "img_chat_bg")
	self.img_chatBg:setGroupID(mainUIDef.newGroupID.main)
	self.img_current = SoraDGetChildByName(self, "img_chat_current")
	self.img_current:setGroupID(mainUIDef.newGroupID.main)
	self.img_chatL = SoraDGetChildByName(self, "img_chatL")
	self.img_chatL:setGroupID(mainUIDef.newGroupID.main)
	self.img_chatR = SoraDGetChildByName(self, "img_chatR")
	self.img_chatR:setGroupID(mainUIDef.newGroupID.main)
	self.img_chatC = SoraDGetChildByName(self, "img_chatC")
	self.img_chatC:setGroupID(mainUIDef.newGroupID.main)
	self.img_chat = SoraDGetChildByName(self, "img_chat")
	self.img_chat:setGroupID(mainUIDef.newGroupID.mainTop)
	self.redIcon = SoraDGetChildByName(self.img_chat, "Sprite_redPoint")
	self.redIcon:setGroupID(mainUIDef.newGroupID.mainTop)
	self.redIcon:setVisible(false)
	self.chatKingdomBox = SoraDGetExtendChildFromCCSByName(self, "CCS_chatMainUIViewBox_Kingdom")
	self.chatAllianceBox = SoraDGetExtendChildFromCCSByName(self, "CCS_chatMainUIViewBox_Alliance")
	self.chatPersonalBox = SoraDGetExtendChildFromCCSByName(self, "CCS_chatMainUIViewBox_Personal")
	self.curChannel = gChatChannel.KINGDOM
	self:udpateImgState(self.curChannel)
	self:MoveToChannel(chatDataMgr:getGChatChannel(), false)
	self.singleIsMoved = false
	self.moveDistanceMinX = 4 * TOUCH_MOVED_ERROR_VALUE
end
function chatMainUIView:initStyle()
	if GLOBAL_MAINUI_STYLE == gMainUIStype.HALLOWEEN then
		self.img_chatL:setSpriteFrame("btn_ZJM_dhk_wxz_wsj.png")
		self.img_chatR:setSpriteFrame("btn_ZJM_dhk_wxz_wsj.png")
		self.img_chatC:setSpriteFrame("btn_ZJM_dhk_wxz_wsj.png")
		self.img_chatL:setFlippedX(true)
		self.img_chatR:setFlippedX(false)
		self.img_current:setFlippedX(self.curChannel ~= gChatChannel.KINGDOM)
		self.img_current:setSpriteFrame("btn_ZJM_dhk_xz_wsj.png")
	end
end
function chatMainUIView:upateDJInfo()
	self.img_chat:setSpriteFrame(SoraDGetCtrl("djCtrl").isListen and "icon_chat_bugle1.png" or "icon_main_message.png")
end
function chatMainUIView:initGroup()
	local createGroupNode = function(groupID, zOrder)
		local node = display.newNode()
		node:setGroupID(groupID, true)
		node:addTo(self)
		node:setLocalZOrder(zOrder)
	end
	createGroupNode(mainUIDef.newGroupID.main, 2)
	createGroupNode(mainUIDef.newGroupID.mainTop, 7)
end
function chatMainUIView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_GO_TO_CHANNEL", handler(self, self.msgGotoChannel))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.upateDJInfo))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GET_COVER_BACK", handler(self, self.updatePersonalRedIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_VIEW_MAIL_SUCCESS", handler(self, self.updatePersonalRedIcon))
end
function chatMainUIView:initWithData()
	_ENV = nil
	;(nil).chatChannel = gChatChannel.KINGDOM
	self.chatKingdomBox:initWithData(nil)
	_ENV = nil
	;(nil).chatChannel = gChatChannel.ALLIANCE
	self.chatAllianceBox:initWithData(nil)
	_ENV = nil
	;(nil).chatChannel = gChatChannel.MAIL
	self.chatPersonalBox:initWithData(nil)
end
function chatMainUIView:changeToChannel(chatChannel, bAnimated)
	if self.chatChannel == chatChannel then
		return
	end
	self:MoveToChannel(chatChannel, bAnimated)
	print("设置为聊天~", chatChannel)
	if bAnimated then
		if chatChannel == gChatChannel.ALLIANCE then
			chatChannel = self.chatAllianceBox:getChatChannel()
		elseif chatChannel == gChatChannel.MAIL then
			chatChannel = self.chatPersonalBox:getChatChannel()
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
function chatMainUIView:OnChatClick(ref, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 17)
		_ENV = "uicontrol"
		;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage("uicontrol")
		print("self.moveDirection =", self.moveDirection)
		if self.singleIsMoved then
			local isNeedLog = false
			local targetChannel
			if self.moveDirection == HDirection.left then
				isNeedLog = true
				if SoraDFIsRA() then
					targetChannel = math.max(1, self.curChannel - 1)
				else
					targetChannel = math.min(3, self.curChannel + 1)
				end
			elseif self.moveDirection == HDirection.right then
				isNeedLog = true
				if SoraDFIsRA() then
					targetChannel = math.min(3, self.curChannel + 1)
				else
					targetChannel = math.max(1, self.curChannel - 1)
				end
			end
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
				_ENV = self.curChannel
				self.curChannel.channel = channelStr
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_chat_channel, self.curChannel)
			end
			self.moveDirection = HDirection.none
			self.singleIsMoved = false
			return
		end
		local panel = SoraDSearchPanelFromManagerByName("chatView")
		if panel then
			panel:removeFromParent()
		end
		panel = SoraDCreatePanel("chatView")
		panel:show()
		panel:init()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchmovePoint = ref:getTouchMovePosition()
		local distanceX = touchmovePoint.x - touchBeganPoint.x
		if distanceX > self.moveDistanceMinX then
			self.moveDirection = HDirection.right
			self.singleIsMoved = true
		elseif distanceX < -self.moveDistanceMinX then
			self.moveDirection = HDirection.left
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.moveDirection = HDirection.none
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function chatMainUIView:doAnimationOffsetWithView(view, offsetX)
	if view == nil or 0 == offsetX then
		return
	end
	local actionMoveBy = cca.moveBy(0.3, offsetX, 0)
	view:runAction(actionMoveBy)
end
function chatMainUIView:moveWithView(view, bAnimate, multiple)
	if view then
		local offsetX = multiple * 640
		if bAnimate ~= nil and bAnimate == false then
			view:setPositionX(view:getPositionX() + offsetX)
		else
			self:doAnimationOffsetWithView(view, offsetX)
		end
	end
end
function chatMainUIView:MoveToChannel(targetChannel, bAnimate)
	if gChatChannel.TEAM == targetChannel then
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
	if targetChannel > self.curChannel then
		if SoraDFIsRA() then
			print("111111")
			self:moveWithView(self.chatAllianceBox, bAnimate, targetChannel - self.curChannel)
			self:moveWithView(self.chatKingdomBox, bAnimate, targetChannel - self.curChannel)
			self:moveWithView(self.chatPersonalBox, bAnimate, targetChannel - self.curChannel)
		else
			print("22222")
			self:moveWithView(self.chatAllianceBox, bAnimate, self.curChannel - targetChannel)
			self:moveWithView(self.chatKingdomBox, bAnimate, self.curChannel - targetChannel)
			self:moveWithView(self.chatPersonalBox, bAnimate, self.curChannel - targetChannel)
		end
	elseif SoraDFIsRA() then
		print("33333")
		self:moveWithView(self.chatAllianceBox, bAnimate, targetChannel - self.curChannel)
		self:moveWithView(self.chatKingdomBox, bAnimate, targetChannel - self.curChannel)
		self:moveWithView(self.chatPersonalBox, bAnimate, targetChannel - self.curChannel)
	else
		print("44444")
		self:moveWithView(self.chatAllianceBox, bAnimate, self.curChannel - targetChannel)
		self:moveWithView(self.chatKingdomBox, bAnimate, self.curChannel - targetChannel)
		self:moveWithView(self.chatPersonalBox, bAnimate, self.curChannel - targetChannel)
	end
	self.curChannel = targetChannel
	self:udpateImgState(targetChannel)
	self:updatePersonalRedIcon()
end
function chatMainUIView:udpateImgState(targetChannel)
	local targetX = SoraDFPosX(275)
	if targetChannel == gChatChannel.KINGDOM then
		targetX = SoraDFPosX(365)
	elseif targetChannel == gChatChannel.ALLIANCE then
		targetX = 320
	end
	self.img_current:setPositionX(targetX)
	self:initStyle()
end
function chatMainUIView:msgGotoChannel(target, data)
	local channel = data.channel
	self:MoveToChannel(channel, false)
end
function chatMainUIView:updatePersonalRedIcon()
	local newMessage = gChatMgrs:getMgr("chatCoverMgr"):getTotalNewNum()
	print("chatMainUIView:updatePersonalRedIcon", self.curChannel, newMessage, gChatChannel.CHATROOM, gChatChannel.MAIL)
	self.redIcon:setVisible(0 < newMessage)
end
return chatMainUIView
