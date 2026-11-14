local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001496_RewardPanel = class("Activity_9001496_RewardPanel", baseFguiPanel)
function Activity_9001496_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001496_RewardPanel:ctor", self.viewName)
end
function Activity_9001496_RewardPanel:onInit()
	print("=======Activity_9001496_RewardPanel:onInit")
	self.fields.Text_des:setString(i18n("Martial_arts_text_09"))
	self.fields.List:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickClose))
end
function Activity_9001496_RewardPanel:onShow()
	print("=======Activity_9001496_RewardPanel:onShow")
	self.rewardList = self.proxy.param and self.proxy.param.reward
	self.fields.List:setNumItems(#self.rewardList)
end
function Activity_9001496_RewardPanel:onNormalItemRederer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001496_RewardPanel:close(...)
	SoraDMailGainItems(self.rewardList, true)
	self:closePanel()
end
return Activity_9001496_RewardPanel
