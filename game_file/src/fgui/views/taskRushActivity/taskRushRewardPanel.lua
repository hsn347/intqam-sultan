local taskRushActivityRead = include("taskRushActivityRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local taskRushRewardPanel = class("taskRushRewardPanel", baseFguiPanel)
function taskRushRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("taskRushRewardPanel:ctor", self.viewName)
end
function taskRushRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
	end
	return self._packageList
end
function taskRushRewardPanel:onInit()
	print("=======taskRushRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function taskRushRewardPanel:onItemRenderer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
function taskRushRewardPanel:onShow()
	print("=======taskRushRewardPanel:onShow")
	local activityID = self.param and self.param.activityID
	self.reward = taskRushActivityRead.getExtraBonus(activityID)
	self.fields.List:setNumItems(#self.reward)
end
function taskRushRewardPanel:onHide()
	print("=======taskRushRewardPanel:onHide")
end
function taskRushRewardPanel:onDispose()
	print("=======taskRushRewardPanel:onDispose")
end
return taskRushRewardPanel
