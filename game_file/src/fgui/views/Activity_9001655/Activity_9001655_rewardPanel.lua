local activity_9001655_Ctrl = SoraDGetCtrl("activity_9001655_Ctrl")
local activity_9001655_Read = include("activity_9001655_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001655_rewardPanel = class("Activity_9001655_rewardPanel", baseFguiPanel)
function Activity_9001655_rewardPanel:ctor(...)
	Activity_9001655_rewardPanel.super.ctor(self, ...)
	print("Activity_9001655_rewardPanel:ctor", self.viewName)
end
function Activity_9001655_rewardPanel:onInit()
	print("=======Activity_9001655_rewardPanel:onInit")
	self.reward, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("constellation_departure_text6"))
	self.fields.Text_tip:setString(i18n("constellation_departure_text2"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001655_rewardPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
	obj:setItemStatus(self.historyMap[self.reward[index + 1].position] and 2 or 0)
end
function Activity_9001655_rewardPanel:onShow()
	print("=======Activity_9001655_rewardPanel:onShow")
	local history = activity_9001655_Ctrl:getHistory()
	self.historyMap, _ENV = activity_9001655_Ctrl, activity_9001655_Ctrl
	for _, position in ipairs(history) do
		self.historyMap[position] = true
	end
	self.reward = activity_9001655_Read.getAwardByValue()
	self.fields.List:setNumItems(#self.reward)
end
return Activity_9001655_rewardPanel
