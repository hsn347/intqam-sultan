local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dailyAwardPassViewPanel = class("dailyAwardPassViewPanel", baseFguiPanel)
function dailyAwardPassViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("dailyAwardPassViewPanel:ctor", self.viewName)
end
function dailyAwardPassViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function dailyAwardPassViewPanel:onInit()
	print("=======dailyAwardPassViewPanel:onInit")
	self.fields.Btn_use:addClickListener(handler(self, self.btnClickCallBack))
end
function dailyAwardPassViewPanel:onShow()
	print("=======dailyAwardPassViewPanel:onShow")
	self.msg = self.param.msg
	self.isEnough = self.param.isEnough
	self.onConfirm = self.param.onConfirm
	self.param = self.param.param
	self:initData()
end
function dailyAwardPassViewPanel:initData()
	self.fields.Text_msg:setString(self.msg)
	if self.param.icon then
		self.fields.Btn_use:setCostIcon(self.param.icon)
	end
	self.fields.Btn_use:setString(self.param.title or i18n("common_text_204"))
	self.fields.Btn_use:setCostTitle(self.param.gold or 0)
	if self.param.costItemID then
		self.fields.Btn_use:setCost(self.param.costItemID, self.param.gold)
	end
	local isEnough = not self.param.checkGold or SoraDEnoughGold(self.param.gold or 0, true)
	self.fields.Btn_use.controllers.Ctrl_status:setSelectedIndex(isEnough and 0 or 1)
	self.taskType = self.param.taskType
	self.needGold = self.param.gold
end
function dailyAwardPassViewPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.onConfirm then
		self.onConfirm()
		self:close()
		return
	end
	if self.isEnough then
		if everydayTaskCtrl:isTaskCompleted(self.taskType) then
			SoraDShowMsgTip(i18n("Actpass_text_07"))
		else
			everydayTaskCtrl:sendUseFastPassMsg(self.taskType)
		end
	elseif SoraDEnoughGold(self.needGold) then
		if everydayTaskCtrl:isTaskCompleted(self.taskType) then
			SoraDShowMsgTip(i18n("Actpass_text_07"))
		else
			local shopItemID = 1000214
			everydayTaskCtrl:sendUseFastPassMsg(self.taskType, shopItemID)
		end
	end
	self:close()
end
return dailyAwardPassViewPanel
