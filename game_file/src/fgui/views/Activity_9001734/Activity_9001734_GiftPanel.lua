local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_GiftPanel = class("Activity_9001734_GiftPanel", baseFguiPanel)
function Activity_9001734_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_GiftPanel.super.ctor(self, ...)
	print("Activity_9001734_GiftPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
end
function Activity_9001734_GiftPanel:onInit()
	print("=======Activity_9001734_GiftPanel:onInit")
	self:fixChildrenPos()
	self.fields.listPackage:setDefaultItem("ui://Activity_9001734/Com_9001734_Gift")
	self.fields.listPackage:setItemRenderer(handler(self, self.itemRenderer_listPackage))
	self.fields.Panel_bg:setString(i18n("kindofwar_btn_01"))
end
function Activity_9001734_GiftPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_betting_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001734_GiftPanel:endShow()
	print("=======Activity_9001734_GiftPanel:endShow")
	self.packages = activity_9001734_Read.getDailyRechargeCfgList()
	self:refreshPackageList()
end
function Activity_9001734_GiftPanel:refreshPackageList()
	self.fields.listPackage:setNumItems(#self.packages)
	for i = 1, #self.packages do
		self.fields.listPackage:getChildAt(i - 1):initData(self.packages[i])
	end
end
function Activity_9001734_GiftPanel:itemRenderer_listPackage(index, obj)
	local data = self.packages[index + 1]
	obj:initData(data)
end
return Activity_9001734_GiftPanel
