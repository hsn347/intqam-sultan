local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_RewardPanel = class("Activity_9001676_RewardPanel", baseFguiPanel)
local activity_9001676_Read = include("activity_9001676_Read")
function Activity_9001676_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_RewardPanel.super.ctor(self, ...)
	print("Activity_9001676_RewardPanel:ctor", self.viewName)
end
function Activity_9001676_RewardPanel:onInit()
	print("=======Activity_9001676_RewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.list1:setItemRenderer(handler(self, self.itemRenderer))
	self.fields.list2:setItemRenderer(handler(self, self.itemRenderer2))
	self.fields.title1:setString(i18n("Korean_chess_optimization_01"))
	self.fields.title2:setString(i18n("Korean_chess_optimization_02"))
end
function Activity_9001676_RewardPanel:endShow()
	print("=======Activity_9001676_RewardPanel:endShow")
end
function Activity_9001676_RewardPanel:onShow()
	self:updateView()
end
function Activity_9001676_RewardPanel:updateView()
	self.reward1 = activity_9001676_Read.getReward(1).reward
	self.reward2 = activity_9001676_Read.getReward(2).reward
	dump(self.reward1, "self.reward1")
	self.fields.list1:setNumItems(#self.reward1)
	self.fields.list2:setNumItems(#self.reward2)
end
function Activity_9001676_RewardPanel:itemRenderer(index, obj)
	local item = self.reward1[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001676_RewardPanel:itemRenderer2(index, obj)
	local item = self.reward2[index + 1]
	obj:initData(item.id, item.count)
end
return Activity_9001676_RewardPanel
