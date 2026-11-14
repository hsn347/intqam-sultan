local activityCommonKitchenRead = include("activityCommonKitchenRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001669_FoodPanel = class("Activity_9001669_FoodPanel", baseFguiPanel)
function Activity_9001669_FoodPanel:ctor(...)
	Activity_9001669_FoodPanel.super.ctor(self, ...)
	print("Activity_9001669_FoodPanel:ctor", self.viewName)
end
function Activity_9001669_FoodPanel:onInit()
	print("=======Activity_9001669_FoodPanel:onInit")
	self.fields.Panel_bg:setString(i18n("octopus_kitchen_text_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001669_FoodPanel:onShow()
	print("=======Activity_9001669_FoodPanel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	self.foodIDList = activityCommonKitchenRead.getFoodIDList(self.activityID)
	self.fields.List:setNumItems(#self.foodIDList)
end
function Activity_9001669_FoodPanel:onItemRenderer(index, obj)
	local itemID = self.foodIDList[index + 1]
	obj:initItemID(itemID)
end
return Activity_9001669_FoodPanel
