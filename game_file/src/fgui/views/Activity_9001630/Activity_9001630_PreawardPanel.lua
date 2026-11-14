local activity_9001630_Read = include("activity_9001630_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001630_PreawardPanel = class("Activity_9001630_PreawardPanel", baseFguiPanel)
function Activity_9001630_PreawardPanel:ctor(...)
	Activity_9001630_PreawardPanel.super.ctor(self, ...)
	print("Activity_9001630_PreawardPanel:ctor", self.viewName)
end
function Activity_9001630_PreawardPanel:onInit()
	print("=======Activity_9001630_PreawardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("nebula_paradise_text_05"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function Activity_9001630_PreawardPanel:onShow()
	print("=======Activity_9001630_PreawardPanel:onShow")
	local rewardConfig = activity_9001630_Read.getRewardConfig()
	self.rewardConfig, _ENV = "=======Activity_9001630_PreawardPanel:onShow", "=======Activity_9001630_PreawardPanel:onShow"
	for i, v in ipairs(rewardConfig) do
		if self.rewardConfig[v.rewardType] == nil then
			self.rewardConfig[v.rewardType] = v
		end
	end
	dump(self.rewardConfig, "self.rewardConfig")
	self.fields.List:setNumItems(#self.rewardConfig)
end
function Activity_9001630_PreawardPanel:onItemRederer(index, target)
	target:initData(self.rewardConfig[index + 1], self.rewardConfig[index])
end
return Activity_9001630_PreawardPanel
