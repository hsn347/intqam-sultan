local footballChampionRead = include("footballChampionRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local footballRewardPanel = class("footballRewardPanel", baseFguiPanel)
function footballRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("footballRewardPanel:ctor", self.viewName)
end
function footballRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function footballRewardPanel:onInit()
	print("=======footballRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("champion_prediction_08"))
	self.fields.Text_Title1:setString(i18n("champion_prediction_02"))
	self.fields.Text_Title2:setString(i18n("champion_prediction_01"))
	self.fields.List1:setItemRenderer(handler(self, self.onItemRender1))
	self.fields.List2:setItemRenderer(handler(self, self.onItemRender2))
	self.fields.List1:setNumItems(2)
	self.fields.List2:setNumItems(2)
end
function footballRewardPanel:onShow()
	print("=======footballRewardPanel:onShow")
end
function footballRewardPanel:onItemRender1(index, target)
	local awardRight, awardMistake = footballChampionRead.getAwardByType(2)
	target:initData(index == 0 and awardRight or awardMistake, index == 0 and i18n("champion_prediction_12") or i18n("champion_prediction_13"))
end
function footballRewardPanel:onItemRender2(index, target)
	local awardRight, awardMistake = footballChampionRead.getAwardByType(1)
	target:initData(index == 0 and awardRight or awardMistake, index == 0 and i18n("champion_prediction_12") or i18n("champion_prediction_13"))
end
return footballRewardPanel
