local activity_9001735_Read = include("activity_9001735_Read")
local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001735_GiftPanel = class("Activity_9001735_GiftPanel", baseFguiPanel)
function Activity_9001735_GiftPanel:ctor(...)
	self.isLRU = true
	Activity_9001735_GiftPanel.super.ctor(self, ...)
	print("Activity_9001735_GiftPanel:ctor", self.viewName)
end
function Activity_9001735_GiftPanel:onInit()
	print("=======Activity_9001735_GiftPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("kindofwar_btn_01"))
end
function Activity_9001735_GiftPanel:endShow()
	print("=======Activity_9001735_GiftPanel:endShow")
	self.rechargeList = activity_9001735_Read.getRechargeCfg(2)
	self.fields.List:setNumItems(#self.rechargeList)
end
function Activity_9001735_GiftPanel:buyGiftMsgBack(target, data)
	print("=======Activity_9001735_GiftPanel:buyGiftMsgBack", data)
	self.fields.List:setNumItems(#self.rechargeList)
end
function Activity_9001735_GiftPanel:onNewDay()
	self:close()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		activity_9001735_Ctrl:sendReqInitDataMsg()
	end
end
function Activity_9001735_GiftPanel:itemRenderer_List(index, obj)
	local data = self.rechargeList[index + 1]
	obj:initData(data)
end
return Activity_9001735_GiftPanel
