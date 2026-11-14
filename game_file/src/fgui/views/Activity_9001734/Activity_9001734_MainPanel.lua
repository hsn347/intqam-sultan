local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local listsEqual = function(list1, list2)
	if list1 == list2 then
		return true
	end
	local len = #list1
	if #list2 ~= len then
		return false
	end
	for i = 1, len do
		if list1[i] ~= list2[i] then
			return false
		end
	end
	return true
end
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_MainPanel = class("Activity_9001734_MainPanel", baseFguiPanel)
function Activity_9001734_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_MainPanel.super.ctor(self, ...)
	print("Activity_9001734_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
end
function Activity_9001734_MainPanel:onInit()
	print("=======Activity_9001734_MainPanel:onInit")
	self.fields.List_Predict:setItemRenderer(handler(self, self.itemRenderer_List_Predict))
	self.fields.List_EventPredict:setItemRenderer(handler(self, self.itemRenderer_List_EventPredict))
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_achievement:setTitle(i18n("common_text_1752"))
	self.fields.Button_achievement:addClickListener(handler(self, self.onClick_Button_Achievement))
	self.fields.Button_record:setTitle(i18n("common_text_836"))
	self.fields.Button_record:addClickListener(handler(self, self.onClick_Button_Record))
	self.fields.Button_gift:setTitle(i18n("snow_competition_text_11"))
	self.fields.Button_gift:addClickListener(handler(self, self.onClick_Button_Gift))
	self.fields.Text_noData:setString(i18n("football_betting_text_14"))
	_ENV = i18n("football_betting_text_14")
	i18n("football_betting_text_14").time = _pq(fguiHelper.getColorString("#F0E6D2", SoraDConverTimeStr(CONST_ARRAY.FOOTBALL_BETTING_PREBET_TIME[2])))
	self.fields.lab_EventQuestion:setString(i18n("champion_prediction_04", i18n("football_betting_text_14")))
end
function Activity_9001734_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_betting_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001734_MainPanel:endShow()
	print("=======Activity_9001734_MainPanel:endShow")
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.tag = 1
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("football_betting_text_02")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("football_betting_text_03")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("champion_prediction_01")
	self.activityID.tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(self.activityID)
end
function Activity_9001734_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001734_MainPanel:initView(target, data)
	print("=======Activity_9001734_MainPanel:initView")
	self:refreshRedDots()
	if self.tag == 1 then
		self.fields.Com_pass:initData()
	elseif self.tag == 2 then
		self:initEventPredictList()
	elseif self.tag == 3 then
		self:initPredictList()
	end
	self:updateItemNum()
end
function Activity_9001734_MainPanel:updatePass()
	self.fields.Com_pass:initData()
	self:refreshRedDots()
end
function Activity_9001734_MainPanel:initPredictList()
	self.MatchIdList = activity_9001734_Ctrl:getMatchIdList(true)
	self.fields.List_Predict:setNumItems(#self.MatchIdList)
	self.fields.Text_noData:setVisible(#self.MatchIdList == 0)
end
function Activity_9001734_MainPanel:initEventPredictList()
	self.EventQuestionList = activity_9001734_Ctrl:getEventQuestionList()
	self.fields.List_EventPredict:setNumItems(#self.EventQuestionList)
	self.fields.Text_noData:setVisible(#self.EventQuestionList == 0)
end
function Activity_9001734_MainPanel:updatePredictList(data)
	local matchid = data.id
	local title = data.title
	if self.tag == 3 then
		local newMatchIdList = activity_9001734_Ctrl:getMatchIdList(true)
		if listsEqual(self.MatchIdList, newMatchIdList) then
			for i = 1, self.fields.List_Predict:getNumItems() do
				local obj = self.fields.List_Predict:getChildAt(i - 1)
				if self.MatchIdList[i] == matchid then
					obj:updateQuestionSingle(title)
				end
			end
		else
			self:initPredictList()
		end
	elseif self.tag == 2 then
		for i = 1, self.fields.List_EventPredict:getNumItems() do
			local obj = self.fields.List_EventPredict:getChildAt(i - 1)
			if self.EventQuestionList[i].title == title then
				obj:initData(self.EventQuestionList[i])
			end
		end
	end
end
function Activity_9001734_MainPanel:updateItemNum()
	local constantRead = include("constantRead")
	local itemId = constantRead.getConstValue("FOOTBALL_BETTING_BETITEM", 882701)
	self.fields.Lab_haveItem:setitemInfo(itemId)
end
function Activity_9001734_MainPanel:setTabRedNum()
	local passRedNum = activity_9001734_Ctrl:getPassRedNum()
	self.fields.Com_title:setBtnRedDot(1, 0 < passRedNum)
end
function Activity_9001734_MainPanel:setAchievementRedDot()
	local redNum = activity_9001734_Ctrl:getAchievementRedNum()
	self.fields.Button_achievement:setReddot(0 < redNum)
end
function Activity_9001734_MainPanel:setRecordRedDot()
	local redNum = activity_9001734_Ctrl:getRecordRedNum()
	self.fields.Button_record:setReddot(0 < redNum)
end
function Activity_9001734_MainPanel:refreshRedDots()
	self:setTabRedNum()
	self:setAchievementRedDot()
	self:setRecordRedDot()
end
function Activity_9001734_MainPanel:itemRenderer_List_EventPredict(index, obj)
	obj:initData(self.EventQuestionList[index + 1])
end
function Activity_9001734_MainPanel:itemRenderer_List_Predict(index, obj)
	obj:initData(self.MatchIdList[index + 1])
end
function Activity_9001734_MainPanel:onClick_Button_Achievement(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001734_Achi")
end
function Activity_9001734_MainPanel:onClick_Button_Record(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001734_Record")
end
function Activity_9001734_MainPanel:onClick_Button_Gift(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001734_Gift")
end
return Activity_9001734_MainPanel
