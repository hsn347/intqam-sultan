local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonCaveDrawRewardPanel = class("IceDragonCaveDrawRewardPanel", baseFguiPanel)
function IceDragonCaveDrawRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonCaveDrawRewardPanel:ctor", self.viewName)
end
function IceDragonCaveDrawRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonCaveDrawRewardPanel:onInit()
	print("=======IceDragonCaveDrawRewardPanel:onInit")
	self.fields.desc:setString(i18n("Battle_Towers_14"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function IceDragonCaveDrawRewardPanel:onShow()
	print("=======IceDragonCaveDrawRewardPanel:onShow")
	self:updateView()
end
function IceDragonCaveDrawRewardPanel:onHide()
	if self.callFunc then
		self.callFunc()
	end
end
function IceDragonCaveDrawRewardPanel:updateView()
	self.rewards = self.param.reward
	self.callFunc = self.param.callFunc
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
end
function IceDragonCaveDrawRewardPanel:onItemRenderer(index, object)
	fguiHelper.get_fields(object).item:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return IceDragonCaveDrawRewardPanel
