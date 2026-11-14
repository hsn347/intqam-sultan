local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FruitCultivateRewardPanel = class("FruitCultivateRewardPanel", baseFguiPanel)
function FruitCultivateRewardPanel:ctor(...)
	self.isLRU = true
	FruitCultivateRewardPanel.super.ctor(self, ...)
	print("FruitCultivateRewardPanel:ctor", self.viewName)
end
function FruitCultivateRewardPanel:onInit()
	print("=======FruitCultivateRewardPanel:onInit")
	self.fields.listItem:setItemRenderer(handler(self, self.itemRenderer_listItem))
	self.fields.btnConfirm:setTitle(i18n("common_text_204"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
	self.fields.txtDesc:setString(i18n("farmland_text_38"))
	self.fields.Panel_bg1:setString(i18n("hero_title_02"))
end
function FruitCultivateRewardPanel:endShow()
	print("=======FruitCultivateRewardPanel:endShow")
	self:initData(self.param.rewards)
end
function FruitCultivateRewardPanel:itemRenderer_listItem(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function FruitCultivateRewardPanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	self:close()
end
function FruitCultivateRewardPanel:initData(rewards)
	self.rewards = rewards
	self.fields.listItem:setNumItems(#self.rewards)
end
return FruitCultivateRewardPanel
