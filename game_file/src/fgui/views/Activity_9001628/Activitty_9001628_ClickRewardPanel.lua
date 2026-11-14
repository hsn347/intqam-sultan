local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activitty_9001628_ClickRewardPanel = class("Activitty_9001628_ClickRewardPanel", baseFguiPanel)
local MAX_AWARD_NUM = 12
function Activitty_9001628_ClickRewardPanel:ctor(...)
	Activitty_9001628_ClickRewardPanel.super.ctor(self, ...)
	print("Activitty_9001628_ClickRewardPanel:ctor", self.viewName)
end
function Activitty_9001628_ClickRewardPanel:onInit()
	print("=======Activitty_9001628_ClickRewardPanel:onInit")
	self.awardArray, _ENV = print, print
	self.text_ins = SoraDGetChildByName(self, "text_ins")
	self.list_reward = SoraDGetChildByName(self, "list_reward")
	self.icon_znxb_hjbox_01_2 = SoraDGetChildByName(self, "icon_znxb_hjbox_01_2")
	self.text_ins:setString(i18n("luckyFalcon_text16"))
	self.list_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activitty_9001628_ClickRewardPanel:onShow()
	print("=======Activitty_9001628_ClickRewardPanel:onShow")
end
function Activitty_9001628_ClickRewardPanel:initData(rewardList, packageID)
	if not rewardList then
		return
	end
	self.rewardList = rewardList
	self:initScroll()
end
function Activitty_9001628_ClickRewardPanel:initScroll()
	self.list_reward:setNumItems(#self.rewardList)
end
function Activitty_9001628_ClickRewardPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data)
end
return Activitty_9001628_ClickRewardPanel
