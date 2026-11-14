local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordRenamePanel = class("lordRenamePanel", baseFguiPanel)
function lordRenamePanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordRenamePanel:ctor", self.viewName)
end
function lordRenamePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordRenamePanel:onInit()
	print("=======lordRenamePanel:onInit")
	self.isHaveTextField = true
	self.maxLen = MAX_NICKNAME_LEN
	self.goldCount = 200
	self.itemID = 500101
	self.haveItem = false
	self.fields.Panel_bg:setString(i18n("common_text_361"))
	self.fields.Text_tip:setString(i18n("common_text_711"))
	_ENV = i18n("common_text_711")
	i18n("common_text_711").count = self.maxLen
	self.fields.Text_warn:setString(i18n("common_text_364", i18n("common_text_711")))
	self.fields.Button_rename:setString(i18n("common_text_363"))
	self.fields.Button_rename:addClickListener(handler(self, self.btnRenameClickCallBack))
	self.fields.TextField_rename:setMaxLength(self.maxLen)
	self.fields.TextField_rename:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.TextField_rename:setAlign(SoraDFLabelR())
	self.fields.TextField_rename:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_362")))
	self.fields.status:setVisible(false)
	self.fields.status:fixPos()
end
function lordRenamePanel:onShow()
	print("=======lordRenamePanel:onShow")
	self.haveItem = backpackCtrl:getItemCount(self.itemID) > 0
	if self.haveItem then
		self.fields.Button_rename:setCostIcon(publicRead.getIcon(self.itemID))
		self.fields.Button_rename:setCostTitle(1)
	else
		self.fields.Button_rename:setCostIcon(publicRead.getIcon(gIDDef.GOLD))
		self.fields.Button_rename:setCostTitle(self.goldCount)
	end
	self.fields.Button_rename:setEnabled(false)
end
function lordRenamePanel:nickNameErr(target, data)
	if data.content.err == gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER and data.content.data.nickName == self.fields.TextField_rename:getText() then
		self.fields.Text_warn:setString(i18n("common_text_366"))
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.status:setIcon("icon_no.png")
		self.fields.Button_rename:setEnabled(false)
	end
end
function lordRenamePanel:onChanged()
	local returnName = self.fields.TextField_rename:getText()
	local nameLen = string.utf8len(returnName)
	self.fields.status:setVisible(true)
	local err, __err = lordInfoCtrl:nickNameLegality(returnName)
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if err == gErrDef.Err_None then
		self.fields.status:setIcon("icon_yes.png")
		_ENV = nil
		;(nil).count = self.maxLen - nameLen
		self.fields.Text_warn:setString(i18n("common_text_364", nil))
		self.fields.Text_warn:setColor(cc.c3b(215, 195, 155))
		self.fields.Button_rename:setEnabled(true)
	else
		if err == gErrDef.Err_NICKNAME_BRACKET then
			self.fields.Text_warn:setString(__err or i18n("common_text_367"))
		elseif err == gErrDef.Err_NICKNAME_MIN_SIZE then
			self.fields.Text_warn:setString(__err or i18n("common_text_365"))
		else
			self.fields.Text_warn:setString(__err or i18n("common_text_366"))
		end
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.status:setIcon("icon_no.png")
		self.fields.Button_rename:setEnabled(false)
	end
end
function lordRenamePanel:btnRenameClickCallBack()
	SoraDPlaySound()
	if self.haveItem or SoraDEnoughGold(self.goldCount) and not self.haveItem then
		lordInfoCtrl:updateLordNickName(self.fields.TextField_rename:getText())
		self:close()
	end
end
return lordRenamePanel
