local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local voiceChatOptionView = class("voiceChatOptionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatOptionView")
	end
	return target
end)
function voiceChatOptionView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_voice")
	self.nodeTitle:setTitle(i18n("common_text_713"))
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.nodePaste = SoraDGetChildByName(self, "Node_paste")
	self.nodePaste:setVisible(false)
	self.btnDismissRoom = SoraDGetChildByName(self, "Button_dismissRoom")
	self.btnDismissRoom:addTouchEventListener(handler(self, self.btnDismissRoomClick))
	self.btnOpenSpeakerPhone = SoraDGetChildByName(self, "Button_openSpeakerphone")
	self.btnOpenSpeakerPhone:addTouchEventListener(handler(self, self.btnOpenSpeakerPhoneClick))
	self.btnCloseSpeakerPhone = SoraDGetChildByName(self, "Button_closeSpeakerphone")
	self.btnCloseSpeakerPhone:addTouchEventListener(handler(self, self.btnCloseSpeakerPhoneClick))
	self.btnOpenAudio = SoraDGetChildByName(self, "Button_openAudio")
	self.btnOpenAudio:addTouchEventListener(handler(self, self.btnOpenAudioClick))
	self.btnCloseAudio = SoraDGetChildByName(self, "Button_closeAudio")
	self.btnCloseAudio:addTouchEventListener(handler(self, self.btnCloseAudioClick))
	self.btnChangeRoonName = SoraDGetChildByName(self, "Button_changeRoonName")
	self.btnChangeRoonName:addTouchEventListener(handler(self, self.btnChangeRoonNameClick))
	self.btnSetRoomPwd = SoraDGetChildByName(self, "Button_setRoomPwd")
	self.btnSetRoomPwd:addTouchEventListener(handler(self, self.btnSetRoomPwdClick))
	self.txtFieldRoomName = SoraDGetChildByName(self, "TextField_roonName")
	self.txtFieldRoomPwd = SoraDGetChildByName(self, "TextField_roomPwd")
	SoraDGetChildByName(self, "Text_roomNameTip"):setString(i18n("chat_text_24"))
	SoraDGetChildByName(self, "Text_roomPwdTip"):setString(i18n("chat_text_25"))
	self.btnDismissRoom:setTitleText(i18n("chat_btn_10"))
	self.btnChangeRoonName:setTitleText(i18n("common_text_243"))
	self.btnSetRoomPwd:setTitleText(i18n("common_text_243"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.nodeContent:setPositionY(self.scroll:getContentSize().height - 50)
	self:changeToEditBox()
	self:initData()
end
function voiceChatOptionView:changeToEditBox(...)
	local realchange = function(ocx)
		local size = ocx:getContentSize()
		local pos = cc.p(ocx:getPositionX(), ocx:getPositionY())
		local ap = ocx:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		if ocx:getMaxLength() > 0 then
			editBox:setMaxLength(ocx:getMaxLength())
		end
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:setTextHorizontalAlignment(SoraDFLabelR())
		editBox:addTo(ocx:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		ocx:removeFromParent()
		return editBox
	end
	self.txtFieldRoomName = realchange(self.txtFieldRoomName)
	self.txtFieldRoomName:setInputMode(0)
	self.txtFieldRoomPwd = realchange(self.txtFieldRoomPwd)
	self.txtFieldRoomPwd:setInputMode(2)
	self.txtFieldRoomPwd:setInputFlag(0)
end
function voiceChatOptionView:OnEditBoxTouch(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		target:touchDownAction(target, eventType)
	end
end
function voiceChatOptionView:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
	end
end
function voiceChatOptionView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMINFOUPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONLEAVECHANNEL", handler(self, self.onExitRoom))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK", function(...)
		SoraDCloseLoading(self)
	end)
end
function voiceChatOptionView:initData(target, redata)
	self.roomInfo = voiceRoomCtrl.roomInfo
	self.amIMaster = voiceRoomCtrl:judgeIsMaster()
	self:initView()
end
function voiceChatOptionView:initView(...)
	self.txtFieldRoomName:setTouchEnabled(self.amIMaster)
	self.txtFieldRoomPwd:setTouchEnabled(self.amIMaster)
end
function voiceChatOptionView:btnOpenSpeakerPhoneClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		VoiceChatSDKManager:getInstance():openSpeakerphone()
	end
end
function voiceChatOptionView:btnCloseSpeakerPhoneClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		VoiceChatSDKManager:getInstance():closeSpeakerphone()
	end
end
function voiceChatOptionView:btnOpenAudioClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		VoiceChatSDKManager:getInstance():enableAudio()
	end
end
function voiceChatOptionView:btnCloseAudioClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		VoiceChatSDKManager:getInstance():disableAudio()
	end
end
function voiceChatOptionView:btnChangeRoonNameClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.amIMaster then
			local chatRoomName = self.txtFieldRoomName:getText()
			if chatRoomName ~= "" then
				if voiceRoomCtrl.checkInputRoomName(chatRoomName) ~= gErrDef.Err_None then
					SoraDShowMsgTip(i18n("lordequip_text_10"))
				else
					local roomId = VoiceChatSDKManager:getInstance().chatRoomId or 0
					voiceRoomCtrl:changeRoomName(roomId, self.txtFieldRoomName:getText())
				end
			else
				SoraDShowMsgTip(i18n("common_text_2149"))
			end
		else
			SoraDShowMsgTip(i18n("chat_text_26"))
		end
	end
end
function voiceChatOptionView:btnSetRoomPwdClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.amIMaster then
			local pwd = self.txtFieldRoomPwd:getText()
			if pwd ~= "" then
				if not voiceRoomCtrl.checkInputPwd(pwd) then
					_ENV = nil
					;(nil).num = 4
					SoraDShowMsgTip(i18n("chat_text_13", nil))
					self.txtFieldRoomPwd:setText("")
				else
					local roomId = VoiceChatSDKManager:getInstance().chatRoomId or 0
					voiceRoomCtrl:changePassword(roomId, pwd)
				end
			elseif pwd == "" then
				local roomId = VoiceChatSDKManager:getInstance().chatRoomId or 0
				voiceRoomCtrl:changePassword(roomId, nil)
			end
		else
			SoraDShowMsgTip(i18n("chat_text_27"))
		end
	end
end
function voiceChatOptionView:btnDismissRoomClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.amIMaster then
			_ENV = nil
			;(nil).sec = 30
			SoraDShowMsgBox(i18n("chat_text_28", nil), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					SoraDShowLoading(self)
					local roomId = VoiceChatSDKManager:getInstance().chatRoomId
					voiceRoomCtrl:dismissRoom(roomId)
				end
			end)
		else
			SoraDShowMsgTip(i18n("chat_text_51"))
		end
	end
end
function voiceChatOptionView:onExitRoom(...)
	self:removeFromParent()
end
return voiceChatOptionView
