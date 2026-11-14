local footballChampionCtrl = SoraDGetCtrl("footballChampionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local footballChampionPanel = class("footballChampionPanel", baseFguiPanel)
function footballChampionPanel:ctor(...)
	self.super.ctor(self, ...)
	print("footballChampionPanel:ctor", self.viewName)
end
function footballChampionPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function footballChampionPanel:onInit()
	print("=======footballChampionPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001474"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(gActivityTimeActivityID.FOOTBALL_CHAMPION_ACTIVITY)
	self.fields.Button_result:setString(i18n("champion_prediction_03"))
	self.fields.Button_award:setString(i18n("champion_prediction_08"))
	self.fields.List_question:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_result:addClickListener(handler(self, self.onClickResult))
	self.fields.Button_award:addClickListener(handler(self, self.onClickAward))
	_ENV = handler(self, self.onClickAward)
	_ENV, _ENV, handler(self, self.onClickAward).defaultClick = handler(self, self.onClickAward)
	handler(self, self.onClickAward).title = i18n("champion_prediction_01")
	_ENV, handler(self, self.onClickAward)[1], handler(self, self.onClickAward).tag = handler(self, self.onClickAward)
	handler(self, self.onClickAward).title = i18n("champion_prediction_02")
	handler(self, self.onClickAward).tabsetArray, handler(self, self.onClickAward)[2], handler(self, self.onClickAward).tag = handler(self, self.onClickAward)
	handler(self, self.onClickAward).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(handler(self, self.onClickAward))
end
function footballChampionPanel:onShow()
	print("=======footballChampionPanel:onShow")
	footballChampionCtrl:reqFootballChampionInit()
end
function footballChampionPanel:updateQuestionList()
	self.questionList = footballChampionCtrl:getDayQuestions()
	if next(self.questionList) then
		self.fields.List_question:setNumItems(table.nums(self.questionList))
		self.fields.Text_NoQuestion:setVisible(false)
	else
		self.fields.List_question:setNumItems(0)
		self.fields.Text_NoQuestion:setVisible(true)
		self.fields.Text_NoQuestion:setString(i18n("champion_prediction_11"))
	end
end
function footballChampionPanel:onItemRederer(index, target)
	target:initData(self.questionList[index + 1])
end
function footballChampionPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("champion_prediction_07")
	uiManager:show("RuleView", nil)
end
function footballChampionPanel:updateView()
	if self.tag == 1 then
		self:updateQuestionList()
	else
		self.questionList = footballChampionCtrl:getGameQuestions()
		self.fields.List_question:setNumItems(table.nums(self.questionList))
		self.fields.Text_NoQuestion:setVisible(false)
		if self.questionList[1] then
			footballChampionCtrl = table.nums(self.questionList)
			table.nums(self.questionList).time = SoraDConverTimeStr(self.questionList[1].end_time)
			self.fields.Text_EndTime:setString(i18n("champion_prediction_04", table.nums(self.questionList)))
		end
	end
end
function footballChampionPanel:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.tag = tonumber(tag)
	self:updateView()
end
function footballChampionPanel:onClickResult()
	SoraDPlaySound()
	uiManager:show("footballGuessResult")
end
function footballChampionPanel:onClickAward()
	SoraDPlaySound()
	uiManager:show("footballReward")
end
return footballChampionPanel
