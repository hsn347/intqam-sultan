local activity_9001710_Read = include("activity_9001710_Read")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001710_RewardPanel = class("Activity_9001710_RewardPanel", baseFguiPanel)
function Activity_9001710_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001710_RewardPanel.super.ctor(self, ...)
	print("Activity_9001710_RewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001710
end
function Activity_9001710_RewardPanel:onInit()
	print("=======Activity_9001710_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Smelt_text_08"))
	self.fields.Text_tip:setString(i18n("CrescentDecree_text_07"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Activity_9001710_RewardPanel:onItemRender(index, obj)
	local data = self.rewardData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("nbg"):setVisible(index % 2 == 0)
	obj:getChild("Com_item"):initData(data.id)
	obj:getChild("Text_itemName"):setString(publicRead.getName(data.id))
	obj:getChild("Text_itemCount"):setString("x" .. data.count)
end
function Activity_9001710_RewardPanel:endShow()
	print("=======Activity_9001710_RewardPanel:endShow")
	local cfg = activity_9001710_Read.getRewardCfg()
	self.rewardData, _ENV = "=======Activity_9001710_RewardPanel:endShow", "=======Activity_9001710_RewardPanel:endShow"
	for k, v in ipairs(cfg) do
		for _, reward in ipairs(v.bronzeAward) do
			table.insert(self.rewardData, reward)
		end
		for _, reward in ipairs(v.goldAward1) do
			table.insert(self.rewardData, reward)
		end
	end
	self.rewardData = SoraDMergeRewards(self.rewardData)
	self.fields.List:setNumItems(#self.rewardData)
	self.fields.List:jumpToTop()
end
return Activity_9001710_RewardPanel
