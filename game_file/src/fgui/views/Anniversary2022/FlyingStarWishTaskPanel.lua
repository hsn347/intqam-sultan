local flyingStarWishRead = include("flyingStarWishRead")
local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FlyingStarWishTaskPanel = class("FlyingStarWishTaskPanel", baseFguiPanel)
function FlyingStarWishTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FlyingStarWishTaskPanel:ctor", self.viewName)
end
function FlyingStarWishTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FlyingStarWishTaskPanel:onInit()
	print("=======FlyingStarWishTaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("giftgiving_text_17"))
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRendererTask))
	self.taskConfig = flyingStarWishRead.getTaskConfig()
	self:initData()
end
function FlyingStarWishTaskPanel:initData()
	self.taskList = flyingStarWishCtrl:getTaskList(self.taskConfig)
	dump(self.taskList, "FlyingStarWishTaskPanel:taskList")
	for i, v in ipairs(self.taskList) do
		v.desBgColor = "#A9997F"
		v.scheduBgColor = "#A9997F"
		v.scheduColor = "#FF1128"
		v.str = "alliance_stronghold_text_070"
	end
	self.fields.List_task:setNumItems(table.nums(self.taskList))
end
function FlyingStarWishTaskPanel:onItemRendererTask(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.getTaskReward))
end
function FlyingStarWishTaskPanel:getTaskReward(taskID)
	flyingStarWishCtrl:sendTaskRewardMsg(taskID)
end
function FlyingStarWishTaskPanel:onShow()
	print("=======FlyingStarWishTaskPanel:onShow")
end
return FlyingStarWishTaskPanel
