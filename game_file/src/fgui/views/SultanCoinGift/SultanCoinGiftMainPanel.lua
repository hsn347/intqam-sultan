local sultanCoinRebateCtrl = SoraDGetCtrl("sultanCoinRebateCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SultanCoinGiftMainPanel = class("SultanCoinGiftMainPanel", baseFguiPanel)
function SultanCoinGiftMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SultanCoinGiftMainPanel:ctor", self.viewName)
end
function SultanCoinGiftMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SultanCoinGiftMainPanel:onInit()
	print("=======SultanCoinGiftMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.SULTAN_COIN_REBATE_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001533"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.List_Task:setItemRenderer(handler(self, self.onItemRederer))
end
function SultanCoinGiftMainPanel:onShow()
	print("=======SultanCoinGiftMainPanel:onShow")
	SoraDShowLoading(self)
	sultanCoinRebateCtrl:sendReqInitDataMsg()
end
function SultanCoinGiftMainPanel:onItemRederer(index, target)
	target:initData(self.taskList[index + 1])
end
function SultanCoinGiftMainPanel:updateTaskList()
	self.taskList = sultanCoinRebateCtrl:getTaskList()
	self.fields.List_Task:setNumItems(#self.taskList)
end
function SultanCoinGiftMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("othen_rebate_1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return SultanCoinGiftMainPanel
