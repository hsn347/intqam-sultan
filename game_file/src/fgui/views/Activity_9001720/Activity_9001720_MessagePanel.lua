local resDesRead = include("resDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001720_MessagePanel = class("Activity_9001720_MessagePanel", baseFguiPanel)
function Activity_9001720_MessagePanel:ctor(...)
	Activity_9001720_MessagePanel.super.ctor(self, ...)
	print("Activity_9001720_MessagePanel:ctor", self.viewName)
end
function Activity_9001720_MessagePanel:onInit()
	print("=======Activity_9001720_MessagePanel:onInit")
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickConfirm))
	if not SoraDFIsRA() then
		self.fields.Text_remind:fixPos()
		self.fields.Check_tick:fixPos()
	end
end
function Activity_9001720_MessagePanel:onShow()
	print("=======Activity_9001720_MessagePanel:onShow")
	self.fields.Text_content:setString(self.param.content)
	self.isClickBgClose = true
	local confirmString = self.param.confirmString or i18n("common_text_204")
	self.fields.Button_confirm:setString(confirmString)
	if self.param.remindFunc then
		self.controllers.Ctrl_remind:setSelectedIndex(1)
		local remindString = self.param.remindString or i18n("coffeeCraftsman_text_27")
		self.fields.Text_remind:setString(remindString)
	else
		self.controllers.Ctrl_remind:setSelectedIndex(0)
	end
	local costID = self.param.costID or gIDDef.GOLD
	local resName = resDesRead.getName(costID)
	local resCount = 0
	if costID == gIDDef.GOLD then
		resCount = SoraDGetGold()
	end
	_ENV = nil
	;(nil).resource = resName
	;(nil).count = string.formatnumberthousands(resCount)
	self.fields.Text_gold:setString(i18n("common_text_4289", nil))
end
function Activity_9001720_MessagePanel:onClickConfirm()
	SoraDPlaySound()
	local param = self.param
	local bCheck = self.fields.Check_tick:isSelected()
	self:close()
	if param.confirmFunc then
		if param.remindFunc then
			param.remindFunc(bCheck)
		end
		param.confirmFunc()
	end
end
return Activity_9001720_MessagePanel
