local activity_9001731_Read = include("activity_9001731_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001731_RewardPrePanel = class("Activity_9001731_RewardPrePanel", baseFguiPanel)
function Activity_9001731_RewardPrePanel:ctor(...)
	self.isLRU = true
	Activity_9001731_RewardPrePanel.super.ctor(self, ...)
	print("Activity_9001731_RewardPrePanel:ctor", self.viewName)
end
function Activity_9001731_RewardPrePanel:onInit()
	print("=======Activity_9001731_RewardPrePanel:onInit")
	self.fields.List_win:setItemRenderer(handler(self, self.itemRenderer_List_win))
	self.fields.List_lose:setItemRenderer(handler(self, self.itemRenderer_List_lose))
	self.fields.Panel_bg:setString(i18n("Ludo_test_004"))
	self.fields.Lab_win:setString(i18n("Ludo_test_008"))
	self.fields.Lab_lose:setString(i18n("Ludo_test_009"))
end
function Activity_9001731_RewardPrePanel:endShow()
	print("=======Activity_9001731_RewardPrePanel:endShow")
	self.List_winData = activity_9001731_Read.getWinReward()
	self.List_loseData = activity_9001731_Read.getLoseReward()
	self.fields.List_win:setNumItems(#self.List_winData)
	self.fields.List_win:setScrollEnable(#self.List_winData > 5)
	self.fields.List_lose:setNumItems(#self.List_loseData)
	self.fields.List_lose:setScrollEnable(#self.List_loseData > 5)
end
function Activity_9001731_RewardPrePanel:itemRenderer_List_win(index, obj)
	local data = self.List_winData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001731_RewardPrePanel:itemRenderer_List_lose(index, obj)
	local data = self.List_loseData[index + 1]
	obj:initData(data.id, data.count)
end
return Activity_9001731_RewardPrePanel
