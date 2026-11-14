local activity_9001651_Read = include("activity_9001651_Read")
local activity_9001651_Ctrl = SoraDGetCtrl("activity_9001651_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001651_RewardPanel = class("Activity_9001651_RewardPanel", baseFguiPanel)
function Activity_9001651_RewardPanel:ctor(...)
	Activity_9001651_RewardPanel.super.ctor(self, ...)
	print("Activity_9001651_RewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self.classType = SoraDGetActivityClassType(self.activityID)
end
function Activity_9001651_RewardPanel:onInit()
	print("=======Activity_9001651_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("weapon_creating_05"))
	self.fields.title_sp:setString(i18n("weapon_creating_12"))
	self.fields.title_reward:setString(i18n("weapon_creating_13"))
	self.fields.List_sp:setItemRenderer(handler(self, self.onItemSpRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001651_RewardPanel:onItemSpRenderer(index, obj)
	obj:initData(self.spList[index + 1].id, self.spList[index + 1].count)
end
function Activity_9001651_RewardPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function Activity_9001651_RewardPanel:onShow()
	print("=======Activity_9001651_RewardPanel:onShow")
	self.rewardList, _ENV, self.spList, _ENV = print, print, print, print
	local times = activity_9001651_Ctrl:getLotteryTimes()
	local spReward = activity_9001651_Read.getSpecialReward(self.classType, times)
	table.insert(self.spList, spReward)
	self.fields.List_sp:setNumItems(#self.spList)
	self.fields.List_sp:setScrollEnable(#self.spList > 5)
	local randomReward = activity_9001651_Read.getRandomReward(self.classType, times)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "weight"
	self.rewardList = serviceFunctions.tableFormat(randomReward, nil)
	self.fields.List_reward:setNumItems(#self.rewardList)
	self.fields.List_reward:setScrollEnable(#self.rewardList > 5)
end
return Activity_9001651_RewardPanel
