local activity_9001716_Read = include("activity_9001716_Read")
local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001716_RewardPanel = class("Activity_9001716_RewardPanel", baseFguiPanel)
function Activity_9001716_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001716_RewardPanel.super.ctor(self, ...)
	print("Activity_9001716_RewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001716
end
function Activity_9001716_RewardPanel:onInit()
	print("=======Activity_9001716_RewardPanel:onInit")
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bg:setTitle(i18n("common_text_059"))
end
function Activity_9001716_RewardPanel:endShow()
	print("=======Activity_9001716_RewardPanel:endShow")
	self:initData(self.param.rewardData)
end
function Activity_9001716_RewardPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Activity_9001716_RewardPanel:initData(puzzleReward)
	self.rewards, _ENV = nil, nil
	for i = 1, #puzzleReward.reward, 2 do
		local _ENV, reward
		reward.id = puzzleReward.reward[i]
		reward.count = puzzleReward.reward[i + 1]
		table.insert(self.rewards, reward)
	end
	self.fields.List_items:setNumItems(#self.rewards)
end
return Activity_9001716_RewardPanel
