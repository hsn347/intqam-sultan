local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailFunctions = include("mailFunctions")
local chatFunctions = include("chatFunctions")
local chatConst = include("chatConst")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local mailWriteMailView = class("mailWriteMailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("mailWriteMailView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailWriteMailView:ctor()
	self.isHaveTextField = true
	self.textField_playerName = SoraDGetChildByName(self, "textField_playerName")
	self.textField_playerName = SoraDChangeToEditBox(self.textField_playerName)
	self.textField_playerName:setTextHorizontalAlignment(SoraDFLabelR())
	self.textField_Content = SoraDGetChildByName(self, "textField_Content")
	self.textField_Content = SoraDChangeToEditBox(self.textField_Content)
	self.textField_Content:setTextHorizontalAlignment(SoraDFLabelR())
	self.textField_playerName:setMaxLength(gChatMaxLength.writemailName)
	self.textField_Content:setMaxLength(gChatMaxLength.writeMailContent)
	self.textField_Content:setFontSize(20)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_mail")
	self.mailViewFrame = SoraDGetExtendChildFromCCSByName(self, "CCS_mailViewFrame_node", true)
	self.title:setTitle(i18n("mail_text_25"))
	self.text_name_tip = SoraDGetChildByName(self, "Top_text_name_tip")
	if self.text_name_tip then
		self.text_name_tip:setString(i18n("common_text_087"))
	end
	self.text_content_tip = SoraDGetChildByName(self, "Top_text_content_tip")
	if self.text_content_tip then
		self.text_content_tip:setString(i18n("common_text_088"))
	end
	self.btn_send = SoraDGetChildByName(self, "btn_send")
	if self.btn_send ~= nil then
		self.btn_send:addTouchEventListener(handler(self, self.onBtnSend))
		self.btn_send:setPressedActionEnabled(true)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	self.btn_send:setEnabled(false)
	self.btn_send:setBright(false)
	self.btnChatRoom = SoraDGetChildByName(self, "Button_ChatRoom")
	if self.btnChatRoom then
		self.btnChatRoom:setTitleText(i18n("common_text_3526"))
		self.btnChatRoom:setPressedActionEnabled(true)
		self.btnChatRoom:addTouchEventListener(handler(self, self.onBtnChatRoom))
		SoraDAutoSizeButtonText(self.btnChatRoom, cc.size(156, 40))
	end
end
function mailWriteMailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_SEND_SUCCESS", handler(self, self.sMsgSendSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_SEND_ERROR", handler(self, self.sMsgSendError))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SEL_PLAYERS_CONFIRM", handler(self, self.msgSelPlayersConfirm))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_CLOSE_WRITE_MAIL_VIEW", handler(self, self.msgClose))
end
function mailWriteMailView:updateTime()
	local strName = self.textField_playerName:getString()
	local strContent = self.textField_Content:getString()
	if strName == self.oldStrName and self.oldStrContent == strContent then
		return
	end
	self.oldStrName = strName
	self.oldStrContent = strContent
	if string.len(strName) > 0 and string.len(strContent) > 0 then
		self.btn_send:setEnabled(true)
		self.btn_send:setBright(true)
	else
		self.btn_send:setEnabled(false)
		self.btn_send:setBright(false)
	end
end
function mailWriteMailView:initContent(str)
	self.textField_Content:setString(str)
end
function mailWriteMailView:onExitPanel()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function mailWriteMailView:initSendMode(modeType)
	self.sendMode = modeType
end
function mailWriteMailView:onBtnSend(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local kingdomSettingAPI = include("kingdomSettingAPI")
		local canChat, lv = kingdomSettingAPI:canSendChatMail()
		if not canChat then
			_ENV = nil
			;(nil).lv = lv
			SoraDShowMsgTip(i18n("common_text_3668", nil))
			return
		end
		if self.isInChatRoomMode then
			local loading = SoraDShowLoading(self.btn_send, self.btn_send:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(self.btn_send:getContentSize().width / 2, self.btn_send:getContentSize().height / 2))
			local crName = i18n("common_text_2033")
			if i18n.getLocale() == "zh_cn" then
				crName = "ChatRoom"
			end
			local aid = allianceMgr:getOwnAid()
			local _ENV, members = allianceMgr, allianceMgr
			local chatType = gChatRoomChatType.TEXT
			local text = self.textField_Content:getString()
			for i, v in ipairs(self.selItems) do
				_ENV = cc.p(self.btn_send:getContentSize().width / 2, self.btn_send:getContentSize().height / 2)
				local cc.p(self.btn_send:getContentSize().width / 2, self.btn_send:getContentSize().height / 2).uid, item = v.playerId, cc.p(self.btn_send:getContentSize().width / 2, self.btn_send:getContentSize().height / 2)
				table.insert(members, #members + 1, item)
			end
			local isKing = chatFunctions:getIsSelfKing()
			local isLegendKing = chatFunctions:getIsSelfLegendKing()
			local isKingStar = chatFunctions:getIsSelfKingStar()
			local isHegemon = chatFunctions:getIsSelfHegemon()
			local chatSkinRead = include("chatSkinRead")
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
			_ENV = gHeadWearId
			gHeadWearId.chatType = chatType
			gHeadWearId.content = text
			gHeadWearId.isKing = isKing
			gHeadWearId.isLegendKing = isLegendKing
			gHeadWearId.isLegendForSepKing = isKingStar
			gHeadWearId.isHegemon = isHegemon
			gHeadWearId.bubbleId = bubbleId
			gHeadWearId.avatarFrameId = avatarFrameId
			local gHeadWearId.headWearId, msgData = headWearId, gHeadWearId
			chatroomCtrl:reqChatRoomCreate(crName, aid, members, msgData)
		else
			local loading = SoraDShowLoading(self.btn_send, self.btn_send:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(self.btn_send:getContentSize().width / 2, self.btn_send:getContentSize().height / 2))
			local strName = self.textField_playerName:getString()
			local strContent = self.textField_Content:getString()
			local isKing = chatFunctions:getIsSelfKing()
			local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
			local isLegendKing = legendLordCtrl:getIsSelfLegendKing()
			local isKingStar = chatFunctions:getIsSelfKingStar()
			local isHegemon = chatFunctions:getIsSelfHegemon()
			local chatSkinRead = include("chatSkinRead")
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
			_ENV = gHeadWearId
			gHeadWearId.contentType = 0
			gHeadWearId.content = strContent
			gHeadWearId.isKing = isKing
			gHeadWearId.isLegendKing = isLegendKing
			gHeadWearId.isLegendForSepKing = isKingStar
			gHeadWearId.isHegemon = isHegemon
			gHeadWearId.bubbleId = bubbleId
			gHeadWearId.avatarFrameId = avatarFrameId
			local gHeadWearId.headWearId, content = headWearId, gHeadWearId
			mailCtrl:sendChatMailByName(strName, content)
		end
	end
end
function mailWriteMailView:sMsgSendSuccess(target, data)
	SoraDShowMsgTip(i18n("common_text_2293"))
	self:close(nil, ccui.TouchEventType.ended)
end
function mailWriteMailView:sMsgSendError(target, data)
	SoraDCloseLoading(self.btn_send)
end
function mailWriteMailView:onBtnChatRoom(target, event)
	if event == ccui.TouchEventType.ended then
		print("先关闭键盘----------------------------")
		SoraDPlaySound()
		local glView = cc.Director:getInstance():getOpenGLView()
		if glView.setIMEKeyboardState then
			glView:setIMEKeyboardState(false)
		end
		if allianceMgr:hasJoinAlliance() then
			local chatRoomSelPlayers = SoraDCreatePanel("chatRoomSelPlayers")
			chatRoomSelPlayers:show()
			local selfId = chatFunctions:getSelfId()
			_ENV = chatFunctions
			allianceMgr, chatFunctions.selPlayerOpType = chatConst.selPlayerOpType.selPlayerCreateChatRoom, chatConst.selPlayerOpType.selPlayerCreateChatRoom
			chatFunctions.members, chatConst.selPlayerOpType.selPlayerCreateChatRoom[1] = chatConst.selPlayerOpType.selPlayerCreateChatRoom, selfId
			local chatFunctions.owner, data = selfId, chatFunctions
			chatRoomSelPlayers:initWithData(data)
		else
			_ENV = chatFunctions:getSelfId()
			chatFunctions:getSelfId().msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
			chatFunctions:getSelfId().info = "From MAIL"
			SoraDSendMessage((chatFunctions:getSelfId()))
		end
	end
end
function mailWriteMailView:msgSelPlayersConfirm(target, data)
	local selItems = data.selItems
	self.selItems = selItems
	self.isInChatRoomMode = false
	if not self.selItems or #self.selItems <= 0 then
		return
	end
	if #self.selItems == 1 then
		local name = self.selItems[1].nickName
		self.textField_playerName:setString(name)
	else
		self.isInChatRoomMode = true
		local strNames = ""
		for i, v in ipairs(self.selItems) do
			strNames = strNames .. v.nickName
			if i < #self.selItems then
				strNames = strNames .. ","
			end
		end
		local selfName = chatFunctions:getSelfNickName()
		strNames = selfName .. "," .. strNames
		local retStr = SoraDConvertOmissionText(360, strNames, 28)
		self.textField_playerName:setString(retStr)
	end
end
function mailWriteMailView:msgClose(target, data)
	self:close(nil, ccui.TouchEventType.ended)
end
return mailWriteMailView
