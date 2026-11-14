local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MiningMeteoritesRewardPanel = class("MiningMeteoritesRewardPanel", baseFguiPanel)
function MiningMeteoritesRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MiningMeteoritesRewardPanel:ctor", self.viewName)
end
function MiningMeteoritesRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MiningMeteoritesRewardPanel:onInit()
	print("=======MiningMeteoritesRewardPanel:onInit")
	self.getRewards = self.param.getRewards
	self.rewards = self.param.rewards
	self.cfg = self.param.cfg
	self.closeCallback = self.param.closeCallback
	_ENV = nil
	;(nil).var = i18n(self.cfg.name)
	self.fields.txt_title:setString(i18n("mining_meteorites_15", nil))
	_ENV = i18n("mining_meteorites_15", nil)
	i18n("mining_meteorites_15", nil).var = i18n(self.cfg.name)
	self.fields.bg:setTitle(i18n("mining_meteorites_14", i18n("mining_meteorites_15", nil)))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	self.fields.Btn_reward:addClickEventListener(handler(self, self.onClicked))
	self.fields.Btn_reward:setTitle(i18n("common_text_854"))
end
function MiningMeteoritesRewardPanel:onShow()
	print("=======MiningMeteoritesRewardPanel:onShow")
	self.fields.scroll:setNumItems(#self.getRewards)
end
function MiningMeteoritesRewardPanel:onHide()
	SoraDMailGainItems(self.getRewards, true)
	if self.closeCallback then
		self.closeCallback()
	end
end
function MiningMeteoritesRewardPanel:onNormalItemRenderer(index, obj)
	local reward = self.getRewards[index + 1]
	obj:initData(reward.id, reward.count)
end
function MiningMeteoritesRewardPanel:onClicked()
	self:close()
end
return MiningMeteoritesRewardPanel
