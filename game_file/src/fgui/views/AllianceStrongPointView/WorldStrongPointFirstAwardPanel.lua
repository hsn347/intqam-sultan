local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldStrongPointFirstAwardPanel = class("WorldStrongPointFirstAwardPanel", baseFguiPanel)
function WorldStrongPointFirstAwardPanel:ctor(...)
	WorldStrongPointFirstAwardPanel.super.ctor(self, ...)
	print("WorldStrongPointFirstAwardPanel:ctor", self.viewName)
end
function WorldStrongPointFirstAwardPanel:onInit()
	print("=======WorldStrongPointFirstAwardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("alliance_stronghold_text_046"))
	self.fields.Text_des:setString(i18n("common_text_2211"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function WorldStrongPointFirstAwardPanel:onShow()
	print("=======WorldStrongPointFirstAwardPanel:onShow")
	local rewards = self.param and self.param.rewards
	if rewards then
		self:initData(rewards)
	end
end
function WorldStrongPointFirstAwardPanel:initData(rewards)
	self.rewards = rewards
	self.fields.List:setNumItems(#self.rewards)
end
function WorldStrongPointFirstAwardPanel:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
return WorldStrongPointFirstAwardPanel
