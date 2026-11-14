local allianceGroupMailView = class("allianceGroupMailView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("allianceGroupMailView")
end)
function allianceGroupMailView:ctor(properties)
	self.titleStr = ""
	self.textStr = ""
	self.nodeTitle = SoraDGetChildByName(self, "Node_Title")
	self.textMail = SoraDGetChildByName(self.nodeTitle, "text_mail_title")
	self.textMail:setString(i18n("common_text_190"))
	self.nodeInputTitle = SoraDGetChildByName(self, "Node_InputTitle")
	SoraDGetChildByName(self.nodeInputTitle, "Text_Title"):setString(i18n("Union_text_1"))
	self.titleField = SoraDGetChildByName(self.nodeInputTitle, "TextField")
	_ENV = "TextField"
	;("TextField").func = handler(self, self.editBoxTextEvent)
	self.titleField = SoraDChangeToEditBox(self.titleField, "TextField")
	self.titleField:addTouchEventListener(handler(self, self.tFieldTouchClick))
	self.titleField:setPlaceHolder(i18n("pyramid_text_22"))
	self.titleLeftNum = SoraDGetChildByName(self.nodeInputTitle, "Text_leftNum")
	_ENV = i18n("pyramid_text_22")
	i18n("pyramid_text_22").member = 0
	i18n("pyramid_text_22").total = 30
	self.titleLeftNum:setString(i18n("common_text_155", i18n("pyramid_text_22")))
	self.titleField:setFontSize(22)
	self.titleField:setPlaceholderFontSize(22)
	self.titleField:setTextHorizontalAlignment(SoraDFLabelR())
	self.nodeInputContent = SoraDGetChildByName(self, "Node_InputContent")
	SoraDGetChildByName(self.nodeInputContent, "Text_Title"):setString(i18n("common_text_088"))
	self.textField = SoraDGetChildByName(self.nodeInputContent, "TextField")
	_ENV = "TextField"
	;("TextField").func = handler(self, self.editBoxTextEvent)
	self.textField = SoraDChangeToEditBox(self.textField, "TextField")
	self.textField:addTouchEventListener(handler(self, self.tFieldTouchClick))
	self.textField:setPlaceHolder(i18n("Union_text_2"))
	self.textLeftNum = SoraDGetChildByName(self.nodeInputContent, "Text_leftNum")
	_ENV = i18n("Union_text_2")
	i18n("Union_text_2").member = 0
	i18n("Union_text_2").total = 500
	self.textLeftNum:setString(i18n("common_text_155", i18n("Union_text_2")))
	self.textField:setFontSize(22)
	self.textField:setPlaceholderFontSize(22)
	self.textField:setTextHorizontalAlignment(SoraDFLabelR())
	self.btnSend = SoraDGetChildByName(self, "btn_Send")
	self.btnSend:setTitleText(i18n("common_text_073"))
	self.btnSend:addTouchEventListener(handler(self, self.btnSendClick))
	self:updateBtnStatus()
end
function allianceGroupMailView:close(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.textStr == "" and self.titleStr == "" then
			self:removeFromParent()
		else
			SoraDShowMsgBox(i18n("Union_text_4"), i18n("common_text_054"), i18n("common_text_185"), function(type)
				if type == MSGBOX_CALLBACK_YES then
					self:removeFromParent()
				end
			end)
		end
	end
end
function allianceGroupMailView:editBoxTextEvent(strEventName, edit)
	if strEventName == "began" then
	elseif strEventName == "ended" then
		print("editBox   DidEnd !")
	elseif strEventName == "return" then
		print("editBox   was returned !")
	elseif strEventName == "changed" then
		if edit == self.titleField then
			self.titleStr = RemoveStringSpecial(edit:getText())
			_ENV = edit:getText()
			edit:getText().member = string.utf16len(self.titleStr)
			edit:getText().total = 30
			self.titleLeftNum:setString(i18n("common_text_155", edit:getText()))
		else
			self.textStr = RemoveStringSpecial(edit:getText())
			_ENV = edit:getText()
			edit:getText().member = string.utf16len(self.textStr)
			edit:getText().total = 500
			self.textLeftNum:setString(i18n("common_text_155", edit:getText()))
		end
		self:updateBtnStatus()
	end
end
function allianceGroupMailView:updateBtnStatus()
	if self.textStr ~= "" and self.titleStr ~= "" then
		self.btnSend:setTouchEnabled(true)
		self.btnSend:setBright(true)
	else
		self.btnSend:setTouchEnabled(false)
		self.btnSend:setBright(false)
	end
end
function allianceGroupMailView:tFieldTouchClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		target:touchDownAction(target, eventType)
	end
end
function allianceGroupMailView:btnSendClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).contentType = gChatMailContentType.content_text
		;(nil).content = self:checkShieldWord(self.textStr)
		;(nil).title = self:checkShieldWord(self.titleStr)
		SoraDGetCtrl("allianceMgr"):reqSendAllianceAllMail(nil)
		self:removeFromParent()
	end
end
function allianceGroupMailView:checkShieldWord(message)
	if type(message) == "string" then
		message = string.ltrim(message)
		if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(message) then
			message = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(message)
		end
		if message == nil or message == "" then
			return ""
		end
	end
	return message
end
return allianceGroupMailView
