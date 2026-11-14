local MAX_NAME_LEN = 10
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneRenamePopPanel = class("RuneRenamePopPanel", baseFguiPanel)
function RuneRenamePopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneRenamePopPanel:ctor", self.viewName)
end
function RuneRenamePopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneRenamePopPanel:onInit()
	print("=======RuneRenamePopPanel:onInit")
	self.isHaveTextField = true
	self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
	self.fields.Text_msg:setString(i18n("lordequip_text_04"))
	_ENV = i18n("lordequip_text_04")
	i18n("lordequip_text_04").count = MAX_NAME_LEN
	self.fields.Text_tip:setString(i18n("common_text_364", i18n("lordequip_text_04")))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.onRenameClick))
	self.fields.input:setPrompt(i18n("lordequip_text_05"))
	self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
end
function RuneRenamePopPanel:onShow()
	print("=======RuneRenamePopPanel:onShow")
	self.fields.input:setMaxLength(MAX_NAME_LEN)
	self:setBtnState(false)
end
function RuneRenamePopPanel:setBtnState(canUse)
	self.fields.Btn_ok:setEnabled(canUse)
end
function RuneRenamePopPanel:updateView()
	local returnName = self.fields.input:getText()
	local nameLen = string.utf8len(returnName)
	local isLegal = nameLen <= MAX_NAME_LEN and 0 < nameLen
	if isLegal then
		_ENV = nil
		;(nil).count = MAX_NAME_LEN - nameLen
		self.fields.Text_tip:setString(i18n("common_text_364", nil))
		self.fields.Text_tip:setColor(cc.c3b(120, 120, 120))
		self:setBtnState(true)
	else
		local strTip = i18n(i18n("notice_0071"))
		if nameLen == 0 then
			_ENV = i18n("notice_0071")
			i18n("notice_0071").num = 1
			strTip = i18n("common_text_1442", i18n("notice_0071"))
		end
		self.fields.Text_tip:setString(strTip)
		self.fields.Text_tip:setColor(display.COLOR_RED)
		self:setBtnState(false)
	end
end
function RuneRenamePopPanel:onChanged(Context)
	print("onChanged=====", self.fields.input:getText())
	self:updateView()
end
function RuneRenamePopPanel:onSubmit(Context)
	print("onSubmit=====", self.fields.input:getText())
	self:updateView()
end
function RuneRenamePopPanel:onRenameClick()
	SoraDPlaySound()
	if artifactRuneRead.isRuneSetLock(self.param.group - 1) then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
	else
		godArmsRuneCtrl:sendGroupName(self.param.data.weaponID, self.param.group, self.fields.input:getText())
		self:close()
	end
end
return RuneRenamePopPanel
