local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Common_RewardPrePanel = class("Common_RewardPrePanel", baseFguiPanel)
function Common_RewardPrePanel:ctor(...)
	self.isLRU = true
	Common_RewardPrePanel.super.ctor(self, ...)
	print("Common_RewardPrePanel:ctor", self.viewName)
end
function Common_RewardPrePanel:onInit()
	print("=======Common_RewardPrePanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function Common_RewardPrePanel:endShow()
	print("=======Common_RewardPrePanel:endShow")
	self.title = self.param.title or i18n("hero_title_02")
	if not self.param.rewardData then
		_ENV = self.param.rewardData
	end
	self.rewardData = self.param.rewardData
	self.fields.Panel_bg:setString(self.title)
	self.fields.List:setNumItems(#self.rewardData)
	self.fields.List:jumpToTop()
end
function Common_RewardPrePanel:onItemRender(index, obj)
	local data = self.rewardData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("nbg"):setVisible(index % 2 == 1)
	obj:getChild("Com_item"):initData(data.id)
	if data.effect then
		obj:getChild("Com_item"):setEffect(data.effect)
	else
		obj:getChild("Com_item"):hideEffect()
	end
	obj:getChild("Text_itemName"):setString(publicRead.getName(data.id))
	obj:getChild("Text_itemCount"):setString("x" .. data.count)
end
return Common_RewardPrePanel
