local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SupremacyRoadRewardPanel = class("SupremacyRoadRewardPanel", baseFguiPanel)
function SupremacyRoadRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SupremacyRoadRewardPanel:ctor", self.viewName)
end
function SupremacyRoadRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SupremacyRoadRewardPanel:onInit()
	print("=======SupremacyRoadRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_2078"))
	self.fields.Text_des:setString(i18n("supremacy_road_text_006"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
end
function SupremacyRoadRewardPanel:onShow()
	print("=======SupremacyRoadRewardPanel:onShow")
	if not self.proxy.param or not self.proxy.param.config then
		local _ENV, config = self.proxy.param.config, self.proxy.param.config
	end
	local curScore = config.curScore
	local maxScore = config.maxScore
	if not config.rewards then
		_ENV = config.rewards
	end
	self.rewards = config.rewards
	_ENV = nil
	;(nil).var = string.formatnumberthousands(curScore)
	;(nil).var1 = string.formatnumberthousands(maxScore)
	self.fields.Text_progress:setString(i18n("alliance_stronghold_text_070", nil))
	self.fields.List_reward:setNumItems(#self.rewards)
end
function SupremacyRoadRewardPanel:onRewardItemRenderer(index, object)
	local data = self.rewards[index + 1]
	object:initData(data.id, data.count)
end
return SupremacyRoadRewardPanel
