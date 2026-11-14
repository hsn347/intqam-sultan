local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroJourneyRead = include("heroJourneyRead")
local heroJourneyCtrl = SoraDGetCtrl("heroJourneyCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJourneyPanel = class("HeroJourneyPanel", baseFguiPanel)
function HeroJourneyPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HeroJourneyPanel:ctor", self.viewName)
end
function HeroJourneyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicHerb"
	end
	return self._packageList
end
function HeroJourneyPanel:onInit()
	print("=======HeroJourneyPanel:onInit")
	self:fixChildrenPos()
	self.activityID = gActivityTimeActivityID.HERO_DIARY_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001439"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.maxScore = heroJourneyRead.getRewardMaxScore()
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererReward))
	self.rewardCfg = heroJourneyRead.getRewardConfig()
	self:initData()
end
function HeroJourneyPanel:initData()
	self.fields.Label_score:setString(heroJourneyCtrl:getScore())
	self.fields.Com_progress:setValue(heroJourneyCtrl:getScore(), self.maxScore)
	self.curDay = self:calCurDay()
	self.taskList = heroJourneyCtrl:getTaskList(heroJourneyRead.getTaskConfigByDay(self.curDay))
	dump(self.taskList, "HeroJourneyPanel:initData")
	for i, v in ipairs(self.taskList) do
		v.desBgColor = "#D7C39B"
		v.scheduBgColor = "#D7C39B"
		v.scheduColor = "#BE2828"
	end
	self.fields.List_task:setNumItems(table.nums(self.taskList))
	self.fields.List_reward:setNumItems(table.nums(self.rewardCfg))
end
function HeroJourneyPanel:calCurDay()
	local config = activityShowCtrl:getActivityData(self.activityID)
	local beginDay = SoraDConverSecondToDayAndHours(config.begintime)
	local curDay = SoraDConverSecondToDayAndHours(serviceFunctions.systemTime())
	return curDay - beginDay + 1
end
function HeroJourneyPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
end
function HeroJourneyPanel:onItemRendererReward(index, obj)
	obj:initData(index + 1, self.rewardCfg[index + 1])
end
function HeroJourneyPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("herodiary_025")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function HeroJourneyPanel:onShow()
	print("=======HeroJourneyPanel:onShow")
end
return HeroJourneyPanel
