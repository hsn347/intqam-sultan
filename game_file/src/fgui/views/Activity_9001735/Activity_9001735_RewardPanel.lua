local activity_9001735_Read = include("activity_9001735_Read")
local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001735_RewardPanel = class("Activity_9001735_RewardPanel", baseFguiPanel)
function Activity_9001735_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001735_RewardPanel.super.ctor(self, ...)
	print("Activity_9001735_RewardPanel:ctor", self.viewName)
end
function Activity_9001735_RewardPanel:onInit()
	print("=======Activity_9001735_RewardPanel:onInit")
	self.fields.List_win:setItemRenderer(handler(self, self.itemRenderer_List_win))
	self.fields.List_lose:setItemRenderer(handler(self, self.itemRenderer_List_lose))
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.Lab_win:setString(i18n("freekick_master_text_04"))
	self.fields.Lab_lose:setString(i18n("accompany_peer_text_06"))
end
function Activity_9001735_RewardPanel:endShow()
	print("=======Activity_9001735_RewardPanel:endShow")
	self.reward_win = activity_9001735_Read.getRewardCfg(1)
	self.reward_lose = activity_9001735_Read.getRewardCfg(2)
	self.fields.List_win:setNumItems(#self.reward_win)
	self.fields.List_lose:setNumItems(#self.reward_lose)
end
function Activity_9001735_RewardPanel:itemRenderer_List_win(index, obj)
	local data = self.reward_win[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001735_RewardPanel:itemRenderer_List_lose(index, obj)
	local data = self.reward_lose[index + 1]
	obj:initData(data.id, data.count)
end
return Activity_9001735_RewardPanel
