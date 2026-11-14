local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local voiceChatCreateRoomView = class("voiceChatCreateRoomView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("voiceChatCreateRoomView")
	end
	return target
end)
function voiceChatCreateRoomView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("chat_btn_02"))
	self.spNameState = SoraDGetChildByName(self, "Sprite_state")
	self.spPwdState = SoraDGetChildByName(self, "TextField_name")
	self.errTip = SoraDGetChildByName(self, "Text_errSlogan")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	local total = voiceRoomCtrl:getMaxMemCount()
	_ENV = i18n("chat_btn_02")
	i18n("chat_btn_02").num = total
	self.txtTip:setString(i18n("chat_text_11", i18n("chat_btn_02")))
	self.btnCreate = SoraDGetChildByName(self, "Button_create")
	self.btnCreate:setTitleText(i18n("remains_btn_04"))
	self.btnCreate:addTouchEventListener(handler(self, self.btnCreateClick))
	self.txtFieldName = SoraDGetChildByName(self, "TextField_name")
	self.txtFieldPwd = SoraDGetChildByName(self, "TextField_pwd")
	self:changeToEditBox()
end
function voiceChatCreateRoomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_ONCREATECHANNELSUCCESS", handler(self, self.onServerCreateSuccess))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK", function(...)
		print("失败的通用回调------")
		SoraDCloseLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONJOINCHANNELSUCCESS", function(...)
		self:removeFromParent()
	end)
end
function voiceChatCreateRoomView:changeToEditBox(...)
	local realchange = function(ocx)
		local size = ocx:getContentSize()
		local pos = cc.p(ocx:getPositionX(), ocx:getPositionY())
		local ap = ocx:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setPlaceholderFontColor(cc.c3b(120, 120, 120))
		editBox:setFontSize(20)
		editBox:setFontColor(display.COLOR_BLACK)
		if ocx:getMaxLength() > 0 then
			editBox:setMaxLength(ocx:getMaxLength())
		end
		editBox:setTextHorizontalAlignment(SoraDFLabelR())
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(ocx:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		ocx:removeFromParent()
		return editBox
	end
	self.txtFieldName = realchange(self.txtFieldName)
	self.txtFieldName:setInputMode(0)
	self.txtFieldName:setPlaceHolder(i18n("chat_text_08"))
	self.txtFieldPwd = realchange(self.txtFieldPwd)
	self.txtFieldPwd:setInputMode(2)
	self.txtFieldPwd:setInputFlag(0)
	self.txtFieldPwd:setPlaceHolder(i18n("chat_text_09"))
end
function voiceChatCreateRoomView:OnEditBoxTouch(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		target:touchDownAction(target, eventType)
	end
end
function voiceChatCreateRoomView:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
	end
end
function voiceChatCreateRoomView:onServerCreateSuccess(target, redata)
	local roomId = redata.roomId
	print("服务端创建成功-------, ", redata.roomId, "开始加入SDK的channel:-------------: roomId = ", roomId)
	VoiceChatSDKManager:getInstance():joinChannel(roomId)
end
function voiceChatCreateRoomView:checkInputFormat(...)
	local err = 0
	local chatRoomName = self.txtFieldName:getText()
	if chatRoomName ~= "" then
		if voiceRoomCtrl.checkInputRoomName(chatRoomName) ~= gErrDef.Err_None then
			self.errTip:setString(i18n("lordequip_text_10"))
			err = 1
		else
			self.errTip:setString("")
		end
	else
		self.errTip:setString(i18n("common_text_2149"))
		err = 1
	end
	local chatRoomPwd = self.txtFieldPwd:getText()
	if chatRoomPwd ~= "" then
		if not voiceRoomCtrl.checkInputPwd(chatRoomPwd) then
			voiceRoomCtrl = i18n("common_text_2149")
			i18n("common_text_2149").num = 4
			self.errTip:setString(i18n("chat_text_13", i18n("common_text_2149")))
			err = 2
		else
			self.errTip:setString("")
		end
	end
	return err
end
function voiceChatCreateRoomView:btnCreateClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self:checkInputFormat() > 0 then
			return
		end
		if VoiceChatSDKManager:getInstance().vociePermission then
			SoraDShowLoading(self)
			local chatRoomName = self.txtFieldName:getText()
			local chatRoomPwd = self.txtFieldPwd:getText()
			chatRoomPwd = chatRoomPwd ~= "" and chatRoomPwd or nil
			voiceRoomCtrl:createRoom(chatRoomName, chatRoomPwd)
			voiceRoomCtrl = chatRoomPwd
			chatRoomPwd[1] = cca.delay(30)
			chatRoomPwd[2] = cca.callFunc(function()
				if not tolua.isnull(self) then
					self:removeFromParent()
				end
				VoiceChatSDKManager:getInstance():leaveChannelTimeOut()
				userSDKManager.logEvent(gSDKDef.TDonEvent.voicechat_timeout)
				_ENV = gSDKDef.TDonEvent.voicechat_timeout
				gSDKDef.TDonEvent.voicechat_timeout.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
				SoraDSendMessage(gSDKDef.TDonEvent.voicechat_timeout)
			end)
			chatRoomPwd[3] = cca.callFunc(function()
				if not tolua.isnull(self) then
					self:removeFromParent()
				end
				VoiceChatSDKManager:getInstance():leaveChannelTimeOut()
				userSDKManager.logEvent(gSDKDef.TDonEvent.voicechat_timeout)
				_ENV = gSDKDef.TDonEvent.voicechat_timeout
				gSDKDef.TDonEvent.voicechat_timeout.msg = "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK"
				SoraDSendMessage(gSDKDef.TDonEvent.voicechat_timeout)
			end)
			self:runAction(cca.seq(chatRoomPwd))
		else
			SoraDShowMsgTip(i18n("chat_text_55"))
		end
	end
end
return voiceChatCreateRoomView
