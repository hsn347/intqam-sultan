local contactCtrl = SoraDGetCtrl("contactCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local friendRenameViewPanel = class("friendRenameViewPanel", baseFguiPanel)
function friendRenameViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("friendRenameViewPanel:ctor", self.viewName)
end
function friendRenameViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function friendRenameViewPanel:onInit()
	print("=======friendRenameViewPanel:onInit")
	self.isHaveTextField = true
	self.maxLen = MAX_NICKNAME_LEN
	self.fields.Panel_bg:setString(i18n("privilege_btn_02"))
	_ENV = i18n("privilege_btn_02")
	i18n("privilege_btn_02").count = self.maxLen
	self.fields.Text_warn:setString(i18n("common_text_364", i18n("privilege_btn_02")))
	self.fields.Button_rename:setString(i18n("common_text_243"))
	self.fields.Button_rename:addClickListener(handler(self, self.btnRenameClickCallBack))
	self.fields.TextField_rename:setMaxLength(self.maxLen)
	self.fields.TextField_rename:addEventListener(fgui.UIEventType.Changed, handler(self, self.updateView))
	self.fields.TextField_rename:setAlign(SoraDFLabelR())
	self.fields.TextField_rename:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_362")))
	self.fields.status:setVisible(false)
	self.fields.Text_warn:fixPos()
	self.fields.status:fixPos()
end
function friendRenameViewPanel:onShow()
	print("=======friendRenameViewPanel:onShow")
	self.info = self.param.info
	self:initData()
end
function friendRenameViewPanel:initData()
	self.uid = self.info.uid
	self.remarkName = self.info.remarkName
	self.fields.TextField_rename:setText(self.remarkName)
	self:updateView()
end
function friendRenameViewPanel:updateView()
	local returnName = self.fields.TextField_rename:getText()
	local nameLen = string.utf8len(returnName)
	self.fields.status:setVisible(true)
	if serviceFunctions.isExistSpecialSymbol(returnName) then
		self.fields.status:setIcon("icon_no.png")
		self.fields.Text_warn:setString(i18n("notice_0071"))
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.Button_rename:setEnabled(false)
	else
		self.fields.status:setIcon("icon_yes.png")
		_ENV = i18n("notice_0071")
		i18n("notice_0071").count = self.maxLen - nameLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("notice_0071")))
		self.fields.Text_warn:setColor(cc.c3b(215, 195, 155))
		self.fields.Button_rename:setEnabled(true)
	end
end
function friendRenameViewPanel:btnRenameClickCallBack()
	SoraDPlaySound()
	local text = self.fields.TextField_rename:getText()
	if text == "" then
		text = nil
	end
	contactCtrl:reqRemarksContact(self.uid, text)
	self:close()
end
return friendRenameViewPanel
