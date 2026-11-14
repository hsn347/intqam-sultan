_ENV = nil
;(nil).ConfirmAndCancel = 0
local _ENV, (nil).Confirm, CTRL_TYPE = nil, 1, nil
;(nil).NONE = 0
local (nil).REMIND, CTRL_REMIND = 1, nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MessageBoxPanel = class("MessageBoxPanel", baseFguiPanel)
function MessageBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MessageBoxPanel:ctor", self.viewName)
end
function MessageBoxPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function MessageBoxPanel:onInit()
	print("=======MessageBoxPanel:onInit")
	self.param = self.proxy.param
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickConfirm))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickCancel))
	self.fields.Check_tick:addClickListener(function()
		SoraDPlaySound()
	end)
	self.fields.Text_remind:fixPos()
	self.fields.Check_tick:fixPos()
end
function MessageBoxPanel:onClickConfirm()
	local param = self.param
	local bCheck = self.fields.Check_tick:isSelected()
	SoraDPlaySound()
	self:close()
	if param.confirmFunc then
		if param.remindFunc then
			param.remindFunc(bCheck)
		end
		param.confirmFunc()
	end
end
function MessageBoxPanel:onClickCancel()
	if self.param.cancelFunc then
		self.param.cancelFunc()
	end
	if self.param.isCanCloseSelf ~= nil then
		self.isCanCloseSelf = true
	end
	self:onClickClose()
end
function MessageBoxPanel:onShow()
	print("=======MessageBoxPanel:onShow")
	local topPanel = SoraDCurrentTopPanelFromManager()
	if topPanel then
		self.topPanel_isCantCloseByReturn = topPanel.isCantCloseByReturn
		topPanel.isCantCloseByReturn = true
	end
	if self.param.isCanCloseSelf ~= nil then
		self.isCanCloseSelf = self.param.isCanCloseSelf
	end
	self.fields.Text_content:setString(self.param.content)
	self.isClickBgClose = true
	if self.param.cancel or self.param.cancelString or self.param.cancelFunc then
		self.controllers.Ctrl_type:setSelectedIndex(CTRL_TYPE.ConfirmAndCancel)
		local cancelString = self.param.cancelString or i18n("common_text_185")
		self.fields.Button_cancel:setString(cancelString)
	else
		self.controllers.Ctrl_type:setSelectedIndex(CTRL_TYPE.Confirm)
	end
	self.fields.Button_confirm:fixPos()
	self.fields.Button_cancel:fixPos()
	local confirmString = self.param.confirmString or i18n("common_text_204")
	self.fields.Button_confirm:setString(confirmString)
	if self.param.remindFunc then
		self.controllers.Ctrl_remind:setSelectedIndex(CTRL_REMIND.REMIND)
		local remindString = self.param.remindString or i18n("common_text_2273")
		self.fields.Text_remind:setString(remindString)
		local bRemind = false
		self.fields.Check_tick:setSelected(bRemind)
	else
		self.controllers.Ctrl_remind:setSelectedIndex(CTRL_REMIND.NONE)
	end
	if self.param.cancleColorIndex then
		fguiHelper.get_controllers(self.fields.Button_cancel).c1:setSelectedIndex(self.param.cancleColorIndex)
	end
	local countDownTime = self.param.countDownTime
	if countDownTime and 0 < countDownTime then
		self:initCountDownTime(countDownTime)
	end
end
function MessageBoxPanel:onHide()
	print("=======MessageBoxPanel:onHide")
	local topPanel = SoraDCurrentTopPanelFromManager()
	if topPanel then
		topPanel.isCantCloseByReturn = self.topPanel_isCantCloseByReturn
	end
	if self.param.hideFunc then
		self.param.hideFunc()
	end
end
function MessageBoxPanel:onDispose()
	print("=======MessageBoxPanel:onDispose")
end
function MessageBoxPanel:initCountDownTime(countDownTime)
	local timeLabel = SoraDCreateTimerLabel(self, self.fields.Button_confirm)
	timeLabel:setEnabled(false)
	local confirmString = self.param.confirmString or i18n("common_text_204")
	timeLabel:setTimeLast(function(timeStr, time)
		return confirmString .. string.format("(%ds)", time)
	end)
	timeLabel:setTimeEndListener(function(...)
		timeLabel:setString(confirmString)
		timeLabel:setEnabled(true)
	end)
	timeLabel:beginTime(countDownTime)
end
return MessageBoxPanel
