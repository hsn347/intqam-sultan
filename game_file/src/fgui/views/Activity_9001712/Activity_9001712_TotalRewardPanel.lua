local activity_9001712_Read = include("activity_9001712_Read")
local activity_9001712_Ctrl = SoraDGetCtrl("activity_9001712_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001712_TotalRewardPanel = class("Activity_9001712_TotalRewardPanel", baseFguiPanel)
function Activity_9001712_TotalRewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001712_TotalRewardPanel.super.ctor(self, ...)
	print("Activity_9001712_TotalRewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
end
function Activity_9001712_TotalRewardPanel:onInit()
	print("=======Activity_9001712_TotalRewardPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("anniversary_ten_daily_07"))
end
function Activity_9001712_TotalRewardPanel:endShow()
	print("=======Activity_9001712_TotalRewardPanel:endShow")
	self:initData()
end
function Activity_9001712_TotalRewardPanel:itemRenderer_List(index, obj)
	obj:initData(index + 1, self.rewardData[index + 1], true)
end
function Activity_9001712_TotalRewardPanel:initData()
	self.rewardData = activity_9001712_Read.getStageRewards(activity_9001712_Ctrl:getClassType())
	self.fields.List:setNumItems(#self.rewardData)
end
return Activity_9001712_TotalRewardPanel
