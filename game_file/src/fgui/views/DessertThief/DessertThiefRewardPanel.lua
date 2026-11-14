local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dessertThiefRead = include("dessertThiefRead")
local DessertThiefRewardPanel = class("DessertThiefRewardPanel", baseFguiPanel)
function DessertThiefRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DessertThiefRewardPanel:ctor", self.viewName)
end
function DessertThiefRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertThiefRewardPanel:onInit()
	print("=======DessertThiefRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewards = dessertThiefRead.getCfgs()
	self.fields.List:setNumItems(#self.rewards)
end
function DessertThiefRewardPanel:onShow()
	print("=======DessertThiefRewardPanel:onShow")
end
function DessertThiefRewardPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
return DessertThiefRewardPanel
