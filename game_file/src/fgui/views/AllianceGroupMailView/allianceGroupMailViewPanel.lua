MAIL_TITLE_LEN = 30
MAIL_CONTENT_LEN = 500
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceGroupMailViewPanel = class("allianceGroupMailViewPanel", baseFguiPanel)
function allianceGroupMailViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceGroupMailViewPanel:ctor", self.viewName)
end
function allianceGroupMailViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceGroupMailViewPanel:onInit()
	print("=======allianceGroupMailViewPanel:onInit")
	self.titleStr = ""
	self.textStr = ""
	self.fields.text_mail_title:setString(i18n("common_text_190"))
	self.fields.Text_Title:setString(i18n("Union_text_1"))
	self.fields.Text_Content:setString(i18n("common_text_088"))
	self.fields.btn_Send:setString(i18n("common_text_073"))
	self.fields.btn_Send:addClickListener(handler(self, self.btnSendClick))
	self.fields.TextField_name:setMaxLength(MAIL_TITLE_LEN)
	self.fields.TextField_name:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputTitle))
	self.fields.TextField_name:setAlign(SoraDFLabelR())
	self.fields.TextField_name:setPrompt(fguiHelper.getColorString("#746e65", i18n("pyramid_text_22")))
	_ENV = fguiHelper.getColorString("#746e65", i18n("pyramid_text_22"))
	fguiHelper.getColorString("#746e65", i18n("pyramid_text_22")).member = 0
	fguiHelper.getColorString("#746e65", i18n("pyramid_text_22")).total = MAIL_TITLE_LEN
	self.fields.Text_leftNum:setString(i18n("common_text_155", fguiHelper.getColorString("#746e65", i18n("pyramid_text_22"))))
	self.fields.TextField_content:setMaxLength(MAIL_CONTENT_LEN)
	self.fields.TextField_content:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputContent))
	self.fields.TextField_content:setAlign(SoraDFLabelR())
	self.fields.TextField_content:setPrompt(fguiHelper.getColorString("#746e65", i18n("Union_text_2")))
	_ENV = fguiHelper.getColorString("#746e65", i18n("Union_text_2"))
	fguiHelper.getColorString("#746e65", i18n("Union_text_2")).member = 0
	fguiHelper.getColorString("#746e65", i18n("Union_text_2")).total = MAIL_CONTENT_LEN
	self.fields.Text_leftCount:setString(i18n("common_text_155", fguiHelper.getColorString("#746e65", i18n("Union_text_2"))))
	self.fields.Text_Title:fixPos()
	self.fields.TextField_name:fixPos()
	self.fields.Text_leftNum:fixPos()
	self.fields.Text_Content:fixPos()
	self.fields.TextField_content:fixPos()
	self.fields.Text_leftCount:fixPos()
end
function allianceGroupMailViewPanel:onShow()
	print("=======allianceGroupMailViewPanel:onShow")
	self:updateBtnStatus()
end
function allianceGroupMailViewPanel:OnInputTitle()
	self.titleStr = RemoveStringSpecial(self.fields.TextField_name:getText())
	_ENV = self.fields.TextField_name:getText()
	self.fields.TextField_name:getText().member = string.utf16len(self.titleStr)
	self.fields.TextField_name:getText().total = MAIL_TITLE_LEN
	self.fields.Text_leftNum:setString(i18n("common_text_155", self.fields.TextField_name:getText()))
	self:updateBtnStatus()
end
function allianceGroupMailViewPanel:OnInputContent()
	self.textStr = RemoveStringSpecial(self.fields.TextField_content:getText())
	_ENV = self.fields.TextField_content:getText()
	self.fields.TextField_content:getText().member = string.utf16len(self.textStr)
	self.fields.TextField_content:getText().total = MAIL_CONTENT_LEN
	self.fields.Text_leftCount:setString(i18n("common_text_155", self.fields.TextField_content:getText()))
	self:updateBtnStatus()
end
function allianceGroupMailViewPanel:updateBtnStatus()
	if self.textStr ~= "" and self.titleStr ~= "" then
		self.fields.btn_Send:setEnabled(true)
	else
		self.fields.btn_Send:setEnabled(false)
	end
end
function allianceGroupMailViewPanel:btnSendClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).contentType = gChatMailContentType.content_text
	;(nil).content = self:checkShieldWord(self.textStr)
	;(nil).title = self:checkShieldWord(self.titleStr)
	SoraDGetCtrl("allianceMgr"):reqSendAllianceAllMail(nil)
	self:close()
end
function allianceGroupMailViewPanel:checkShieldWord(message)
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
function allianceGroupMailViewPanel:onClickBg()
	if self.textStr == "" and self.titleStr == "" then
		self:close()
	else
		SoraDShowMsgBox(i18n("Union_text_4"), i18n("common_text_054"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				self:close()
			end
		end)
	end
end
return allianceGroupMailViewPanel
