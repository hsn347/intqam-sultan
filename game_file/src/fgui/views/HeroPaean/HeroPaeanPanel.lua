local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local heroPaeanCtrl = SoraDGetCtrl("heroPaeanCtrl")
local heroPaeanRead = include("heroPaeanRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroPaeanPanel = class("HeroPaeanPanel", baseFguiPanel)
function HeroPaeanPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HeroPaeanPanel:ctor", self.viewName)
end
function HeroPaeanPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TheGoldMarket"
		self._packageList, self._packageList[2] = self._packageList, "AnnivColossusActivity"
		self._packageList, self._packageList[3] = self._packageList, "DecryptionNew"
		self._packageList, self._packageList[4] = self._packageList, "MagicHerb"
	end
	return self._packageList
end
function HeroPaeanPanel:onInit()
	print("=======HeroPaeanPanel:onInit")
	self:fixPos()
	heroPaeanCtrl:sendInitMsg()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.controllers.lang:setSelectedIndex(1)
	end
	self.fields.Spine_hero:setEffectPath("spine/herosV/heroModle_173602.skel")
	self.activityID = gActivityTimeActivityID.HERO_PAEAN_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001450"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_curScore:setString(i18n("common_text_448"))
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRendererTask))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererReward))
	self.tag = self.curDay or 1
	self.maxScore = heroPaeanRead.getRewardMaxScore()
	self.StageCfg = heroPaeanRead.getStageRewardConfig()
end
function HeroPaeanPanel:fixPos()
	_UPVALUE9_ = nil
	;(nil)[1] = "List_reward"
	;(nil)[2] = "n1"
	;(nil)[3] = "n2"
	;(nil)[4] = "n3"
	;(nil)[5] = "n4"
	;(nil)[6] = "n5"
	;(nil)[7] = "Text_curScore"
	;(nil)[8] = "Label_score"
	;(nil)[9] = "Com_progress"
	for i, v in pairs(nil) do
		self.fields[v]:fixPos()
	end
	self.fields.banner:fix(false)
	self.fields.Spine_hero:fixPos()
end
function HeroPaeanPanel:initData()
	self.fields.Label_time:initActivityTimeStyle(self.activityID)
	self.curDay = activityShowCtrl:getActivityData(self.activityID).doStage + 1
	local activityShowCtrl, tabsetArray = activityShowCtrl:getActivityData(self.activityID).doStage + 1, activityShowCtrl:getActivityData(self.activityID).doStage + 1
	for i = 1, heroPaeanRead.getTotalDay() do
		local lock = i > self.curDay and true or false
		activityShowCtrl = nil
		activityShowCtrl = nil
		;(nil).num = i
		;(nil).title = i18n("newYearRecharge_003", nil)
		;(nil).isLock = lock
		;(nil).tag = i
		table.insert(tabsetArray, nil)
	end
	activityShowCtrl = 1
	;(1).defaultClick = self.tag
	;(1).tabsetArray = tabsetArray
	;(1).callback = handler(self, self.onClickTab)
	;(1).isLock = true
	self.fields.com_Tab:initView(1)
	self.fields.Label_score:setString(heroPaeanCtrl:getScore())
	self.fields.Com_progress:setValue(heroPaeanCtrl:getScore(), self.maxScore)
	self:initPage()
end
function HeroPaeanPanel:initPage()
	self.taskList = heroPaeanCtrl:getTaskList(heroPaeanRead.getTaskConfigByDay(self.tag))
	for i, v in ipairs(self.taskList) do
		v.desBgColor = "#FFEBB9"
		v.scheduBgColor = "#FFEBB9"
		v.scheduColor = "#FF1128"
	end
	self.fields.List_task:setNumItems(table.nums(self.taskList))
	self.fields.List_reward:setNumItems(table.nums(self.StageCfg))
	self:refreshTabRed()
end
function HeroPaeanPanel:refreshTabRed()
	local count = heroPaeanRead.getTotalDay()
	for i = 1, count do
		local visible, num = heroPaeanCtrl:getDayRewardCount(i)
		self.fields.com_Tab:setBtnRedDot(i, visible, num)
	end
end
function HeroPaeanPanel:onItemRendererTask(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.getTaskReward))
end
function HeroPaeanPanel:getTaskReward(taskID)
	heroPaeanCtrl:sendDayTaskMsg(taskID)
end
function HeroPaeanPanel:onItemRendererReward(index, obj)
	obj:initData(index + 1, self.StageCfg[index + 1])
end
function HeroPaeanPanel:onClickTab(tag)
	if tag > self.curDay then
		SoraDShowMsgTip(i18n("common_text_2274"))
		self.fields.com_Tab:setTabIndex(self.tag)
		return
	end
	self.tag = tag
	self:initPage(self.tag)
end
function HeroPaeanPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("hero_paean_text_0001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function HeroPaeanPanel:onShow()
	print("=======HeroPaeanPanel:onShow")
	self:resizeBanner()
end
function HeroPaeanPanel:resizeBanner()
	local width = self:getWidth()
	local scale = width / self.fields.banner:getWidth()
	self.fields.banner:setWidth(width)
	self.fields.banner:setHeight(self.fields.banner:getHeight() * scale)
end
return HeroPaeanPanel
