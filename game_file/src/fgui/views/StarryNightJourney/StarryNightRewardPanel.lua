local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local starryNightJourneyCtrl = SoraDGetCtrl("starryNightJourneyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarryNightRewardPanel = class("StarryNightRewardPanel", baseFguiPanel)
function StarryNightRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarryNightRewardPanel:ctor", self.viewName)
end
function StarryNightRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarryNightRewardPanel:onInit()
	print("=======StarryNightRewardPanel:onInit")
	self.classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_JOURNEY).classtype
	self.configs = ramadanAccuRechargeltCtrl.getStarryNightJourneyReward(self.classType)
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function StarryNightRewardPanel:initData(index, score)
	print("=======StarryNightRewardPanel:onInit")
	self.index = index or self.index
	self.score = score or self.score
	if starryNightJourneyCtrl:getCurScore() < self.score then
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	elseif not starryNightJourneyCtrl:hadgotGift(index) and starryNightJourneyCtrl:getCurScore() >= self.score then
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	else
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	end
	self.fields.List_reward:setNumItems(table.nums(self.configs[self.index].reward) / 2)
end
function StarryNightRewardPanel:onClickGet()
	SoraDPlaySound()
	if not starryNightJourneyCtrl:hadgotGift(self.index) and starryNightJourneyCtrl:getCurScore() >= self.score then
		starryNightJourneyCtrl:sendRewardMsg(self.index)
		self:removeFromParent()
	end
end
function StarryNightRewardPanel:onItemRenderer(index, object)
	object:initData(self.configs[self.index].reward[index * 2 + 1], self.configs[self.index].reward[index * 2 + 2])
end
function StarryNightRewardPanel:onShow()
	print("=======StarryNightRewardPanel:onShow")
	self:initData(self.proxy.param.index, self.proxy.param.score)
end
return StarryNightRewardPanel
