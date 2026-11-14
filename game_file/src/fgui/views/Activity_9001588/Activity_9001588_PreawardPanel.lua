local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001588_PreawardPanel = class("Activity_9001588_PreawardPanel", baseFguiPanel)
function Activity_9001588_PreawardPanel:ctor(...)
	Activity_9001588_PreawardPanel.super.ctor(self, ...)
	print("Activity_9001588_PreawardPanel:ctor", self.viewName)
end
function Activity_9001588_PreawardPanel:onInit()
	print("=======Activity_9001588_PreawardPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001588_PreawardPanel:onShow()
	print("=======Activity_9001588_PreawardPanel:onShow")
	self.config = newLotteryRead.getPreAwardByActivityID(self.activityID, SoraDGetCtrl("activity_9001588_Ctrl"):getClassType())
	self.fields.List:setNumItems(#self.config)
end
function Activity_9001588_PreawardPanel:onItemRederer(index, target)
	target:initData(self.config[index + 1])
end
return Activity_9001588_PreawardPanel
