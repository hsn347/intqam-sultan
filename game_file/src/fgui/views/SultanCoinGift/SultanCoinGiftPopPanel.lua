local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SultanCoinGiftPopPanel = class("SultanCoinGiftPopPanel", baseFguiPanel)
function SultanCoinGiftPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SultanCoinGiftPopPanel:ctor", self.viewName)
end
function SultanCoinGiftPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Effect_baoxiang"
	end
	return self._packageList
end
function SultanCoinGiftPopPanel:onInit()
	print("=======SultanCoinGiftPopPanel:onInit")
	self.reward = self.proxy.param.reward
	self.fields.title:setString(i18n("Lucky_treasure_text_05"))
	self.fields.Button_buy:setString(i18n("common_text_204"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List_reward:setNumItems(#self.reward)
	self.fields.Button_buy:addClickListener(handler(self, self.onClickClose))
end
function SultanCoinGiftPopPanel:onShow()
	print("=======SultanCoinGiftPopPanel:onShow")
end
function SultanCoinGiftPopPanel:onItemRederer(index, target)
	target:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
return SultanCoinGiftPopPanel
