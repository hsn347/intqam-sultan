local activity_9001712_Read = include("activity_9001712_Read")
local activity_9001712_Ctrl = SoraDGetCtrl("activity_9001712_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001712_DayRewardPanel = class("Activity_9001712_DayRewardPanel", baseFguiPanel)
function Activity_9001712_DayRewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001712_DayRewardPanel.super.ctor(self, ...)
	print("Activity_9001712_DayRewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
end
function Activity_9001712_DayRewardPanel:onInit()
	print("=======Activity_9001712_DayRewardPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("anniversary_ten_daily_09"))
	self.fields.Text_title:setString(i18n("anniversary_ten_daily_10"))
end
function Activity_9001712_DayRewardPanel:endShow()
	print("=======Activity_9001712_DayRewardPanel:endShow")
	self:initData()
end
function Activity_9001712_DayRewardPanel:itemRenderer_List(index, obj)
	obj:initData(index + 1, self.rewardData[index + 1])
end
function Activity_9001712_DayRewardPanel:initData()
	self.rewardData = activity_9001712_Read.getDailyRewards(activity_9001712_Ctrl:getClassType())
	self.fields.List:setNumItems(#self.rewardData)
end
return Activity_9001712_DayRewardPanel
