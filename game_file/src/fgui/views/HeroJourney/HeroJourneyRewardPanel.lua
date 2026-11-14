local heroJourneyCtrl = SoraDGetCtrl("heroJourneyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJourneyRewardPanel = class("HeroJourneyRewardPanel", baseFguiPanel)
function HeroJourneyRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroJourneyRewardPanel:ctor", self.viewName)
end
function HeroJourneyRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroJourneyRewardPanel:onInit()
	print("=======HeroJourneyRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("herodiary_002"))
	self.fields.Button_get:setTitleText(i18n("common_text_1146"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_get:addClickListener(handler(self, self.onBtnClick))
end
function HeroJourneyRewardPanel:initData(data)
	self.index = data.index
	self.reward = data.reward
	_ENV = nil
	;(nil).num = data.score
	self.fields.Text_tip:setString(i18n("herodiary_003", nil))
	if heroJourneyCtrl:getScore() < data.score then
		self.fields.Text_score:setString(heroJourneyCtrl:getScore() .. "/" .. data.score)
		self.controllers.c1:setSelectedIndex(0)
	elseif not heroJourneyCtrl:isInStageReward(self.index) and heroJourneyCtrl:getScore() >= data.score then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.fields.Text_hadGot:setString(i18n("common_text_1892"))
		self.controllers.c1:setSelectedIndex(2)
	end
	self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
end
function HeroJourneyRewardPanel:onItemRenderer(index, object)
	object:initData(self.reward[index * 2 + 1], self.reward[index * 2 + 2])
end
function HeroJourneyRewardPanel:onBtnClick()
	heroJourneyCtrl:sendTaskRewardMsg(self.index)
	self:close()
end
function HeroJourneyRewardPanel:onShow()
	print("=======HeroJourneyRewardPanel:onShow")
	self:initData(self.proxy.param)
end
return HeroJourneyRewardPanel
