local activity_9001729_Read = include("activity_9001729_Read")
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001729_RewardPanel = class("Activity_9001729_RewardPanel", baseFguiPanel)
function Activity_9001729_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001729_RewardPanel.super.ctor(self, ...)
	print("Activity_9001729_RewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function Activity_9001729_RewardPanel:onInit()
	print("=======Activity_9001729_RewardPanel:onInit")
	self.fields.curRewards:setItemRenderer(handler(self, self.itemRenderer_curRewards))
	self.fields.nextRewards:setItemRenderer(handler(self, self.itemRenderer_nextRewards))
	self.fields.maxRewards:setItemRenderer(handler(self, self.itemRenderer_maxRewards))
	self.fields.txtCur:setString(i18n("common_text_279"))
	self.fields.txtNext:setString(i18n("common_text_280"))
end
function Activity_9001729_RewardPanel:endShow()
	print("=======Activity_9001729_RewardPanel:endShow")
	self:initData(self.param.gridIndex)
end
function Activity_9001729_RewardPanel:itemRenderer_curRewards(index, obj)
	local data = self.curRewardsData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001729_RewardPanel:itemRenderer_nextRewards(index, obj)
	local data = self.nextRewardsData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001729_RewardPanel:itemRenderer_maxRewards(index, obj)
	local data = self.curRewardsData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001729_RewardPanel:initData(gridIndex)
	self.fields.txtTitle:setString(i18n("Ramadan_treasure_hunt_text_06"))
	local curLv = activity_9001729_Ctrl:getGridLv(gridIndex)
	local curLvData = activity_9001729_Read.getLvData(gridIndex, curLv, self.activityID)
	local nextLvData = activity_9001729_Read.getLvData(gridIndex, curLv + 1, self.activityID)
	activity_9001729_Read = self.activityID
	self.activityID[1] = "id"
	self.activityID[2] = "count"
	self.curRewardsData = serviceFunctions.tableFormat(curLvData.reward, self.activityID)
	if nextLvData then
		self.controllers.ctrlMax:setSelectedIndex(0)
		self.fields.curRewards:setNumItems(#self.curRewardsData)
		_ENV = "count"
		;("count").num1 = activity_9001729_Ctrl:getGridExp(gridIndex) - curLvData.realExp
		;("count").num2 = nextLvData.exp
		self.fields.txtDesc:setString(i18n("Ramadan_treasure_hunt_text_07", "count"))
		activity_9001729_Read = i18n("Ramadan_treasure_hunt_text_07", "count")
		i18n("Ramadan_treasure_hunt_text_07", "count")[1] = "id"
		i18n("Ramadan_treasure_hunt_text_07", "count")[2] = "count"
		self.nextRewardsData = serviceFunctions.tableFormat(nextLvData.reward, i18n("Ramadan_treasure_hunt_text_07", "count"))
		self.fields.nextRewards:setNumItems(#self.nextRewardsData)
	else
		self.controllers.ctrlMax:setSelectedIndex(1)
		self.fields.maxRewards:setNumItems(#self.curRewardsData)
		self.fields.txtDesc:setString(i18n("common_text_283"))
	end
end
return Activity_9001729_RewardPanel
