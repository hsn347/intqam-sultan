local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local footballKingCtrl = SoraDGetCtrl("footballKingCtrl")
local footballKingRead = include("footballKingRead")
local basePanel = require("fgui.base.baseFguiPanel")
local FootballKingRoadPanel = class("FootballKingRoadPanel", basePanel)
function FootballKingRoadPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function FootballKingRoadPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballKingRoadPanel:onInit()
	self.curChooseDay = 1
	self.curChooseTab = 1
	self.taskCount = footballKingCtrl:getTaskNum()
	self.curTaskConfig = footballKingCtrl:getTaskList(self.curChooseDay, self.curChooseTab)
	self.fields.com_Title:initData(i18n("activity_name_9001472"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:initActivityTime()
	footballKingCtrl = i18n("activity_name_9001472")
	footballKingCtrl, footballKingCtrl, i18n("activity_name_9001472").defaultClick = handler(self, self.onClickHelp)
	footballKingCtrl = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).count = "1"
	handler(self, self.onClickHelp).title = i18n("common_text_523", handler(self, self.onClickHelp))
	footballKingCtrl, handler(self, self.onClickClose)[1], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	footballKingCtrl = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).count = "2"
	handler(self, self.onClickHelp).title = i18n("common_text_523", handler(self, self.onClickHelp))
	footballKingCtrl, handler(self, self.onClickClose)[2], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	footballKingCtrl = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).count = "3"
	handler(self, self.onClickHelp).title = i18n("common_text_523", handler(self, self.onClickHelp))
	footballKingCtrl, handler(self, self.onClickClose)[3], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	footballKingCtrl = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).count = "4"
	handler(self, self.onClickHelp).title = i18n("common_text_523", handler(self, self.onClickHelp))
	footballKingCtrl, handler(self, self.onClickClose)[4], handler(self, self.onClickHelp).tag = handler(self, self.onClickHelp)
	footballKingCtrl = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).count = "5"
	handler(self, self.onClickHelp).title = i18n("common_text_523", handler(self, self.onClickHelp))
	i18n("activity_name_9001472").tabsetArray, handler(self, self.onClickClose)[5], handler(self, self.onClickHelp).tag = handler(self, self.onClickClose), handler(self, self.onClickHelp)
	i18n("activity_name_9001472").callback = handler(self, self.onClickDayItem)
	self.fields.day_List_Tab:initView((i18n("activity_name_9001472")))
	self:updateCurDay()
	footballKingCtrl = i18n("activity_name_9001472")
	footballKingCtrl, footballKingCtrl, i18n("activity_name_9001472").defaultClick = self, handler(self, self.onClickDayItem), nil
	self.title = ""
	footballKingCtrl, handler(self, self.onClickDayItem)[1], self.tag = self, self, 1
	self.title = ""
	i18n("activity_name_9001472").tabsetArray, handler(self, self.onClickDayItem)[2], self.tag = handler(self, self.onClickDayItem), self, 2
	i18n("activity_name_9001472").callback = handler(self, self.onClickTabItem)
	self.fields.task_List_Tab:initView((i18n("activity_name_9001472")))
	self.fields.scroll_Task:setItemRenderer(handler(self, self.onTaskItemRender))
	self.fields.scroll_Task:setNumItems(#self.curTaskConfig)
	self:updateTaskTab()
	self.boxInfo = footballKingRead:getTaskReward()
	self:initProgress()
end
function FootballKingRoadPanel:updateTaskTab()
	local index = 1
	for i = 1, 2 do
		self.fields.task_List_Tab:setBtnTitle(index, i18n(footballKingRead.getTabNameByDayLabel(self.curChooseDay, index)))
		self.fields.task_List_Tab:setBtnShowYes(index, footballKingCtrl:getIsAllTaskFinish(self.curChooseDay, index))
		self.fields.task_List_Tab:setBtnRedDot(index, footballKingCtrl:getReddotNumByLabel(self.curChooseDay, index))
		index = index + 1
	end
end
function FootballKingRoadPanel:onShow()
	footballKingCtrl:sendReqInitDataMsg()
end
function FootballKingRoadPanel:onHide()
end
function FootballKingRoadPanel:initActivityTime()
	self.fields.label_Time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_4415", nil)
	end)
	local curDay = footballKingCtrl:getCurDay()
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY)
	if timer then
		local leftTime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY) - serviceFunctions.systemTime()
		if 0 < leftTime then
			self.fields.label_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function FootballKingRoadPanel:initProgress()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).stageMax = #self.boxInfo
	;(nil).gap = 30
	;(nil).handler = handler(self, self.buttonGetRewardCallBack)
	self.fields.Com_score:initData(nil)
	local personScore = footballKingCtrl:getBoxRewardNum()
	for k, v in pairs(self.boxInfo) do
		v.point = v.num
		v.state = footballKingCtrl:getBoxRewardDataStatus(v.num)
	end
	_ENV = pairs(self.boxInfo)
	pairs(self.boxInfo).stageData = self.boxInfo
	pairs(self.boxInfo).score = personScore
	self.fields.Com_score:updateData(pairs(self.boxInfo))
	_ENV = self.buttonGetRewardCallBack
	self.buttonGetRewardCallBack.var = personScore
	self.buttonGetRewardCallBack.var1 = self.taskCount
	self.fields.Text_curScore:setString(i18n("alliance_stronghold_text_070", self.buttonGetRewardCallBack))
end
function FootballKingRoadPanel:updateCurDay()
	local curDay = footballKingCtrl:getCurDay()
	for i = 1, 5 do
		self.fields.day_List_Tab:setBtnRedDot(i, footballKingCtrl:getReddotNumByDay(i))
		local isUnlock = i <= footballKingCtrl:getCurDay()
		self.fields.day_List_Tab:setBtnLock(i, not isUnlock)
	end
end
function FootballKingRoadPanel:updatTaskScroll()
	self.curTaskConfig = footballKingCtrl:getTaskList(self.curChooseDay, self.curChooseTab)
	dump(self.curTaskConfig, "self.curTaskConfig")
	local num = footballKingRead.getTaskNumByDayLabel(self.curChooseDay, self.curChooseTab)
	self.fields.scroll_Task:setNumItems(#self.curTaskConfig)
end
function FootballKingRoadPanel:updateRed()
	for i = 1, 5 do
		self.fields.day_List_Tab:setBtnRedDot(i, footballKingCtrl:getReddotNumByDay(i))
	end
	for i = 1, 2 do
		self.fields.task_List_Tab:setBtnRedDot(i, footballKingCtrl:getReddotNumByLabel(self.curChooseDay, i))
	end
end
function FootballKingRoadPanel:onTaskItemRender(index, object)
	local config = self.curTaskConfig[index + 1]
	object:initData(config)
	object:setHandler(handler(self, self.onClickGetAward), handler(self, self.onClickGo))
end
function FootballKingRoadPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Frosty_Market_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function FootballKingRoadPanel:onClickDayItem(index)
	print("onClickDayItem", index)
	local newChooseDay = index
	dump(footballKingCtrl:getCurDay(), "footballKingCtrl:getCurDay()")
	local isUnlock = newChooseDay <= footballKingCtrl:getCurDay()
	if not isUnlock then
		_ENV = nil
		;(nil).day = newChooseDay
		SoraDShowMsgTip(i18n("digging_task_04", nil))
		self.fields.day_List_Tab:setToTag(self.curChooseDay)
		return true
	end
	if newChooseDay == self.curChooseDay then
		return true
	end
	self.curChooseDay = newChooseDay
	self:updateTaskTab()
	self.fields.task_List_Tab:setDefaultClick(1, 1)
	self.curChooseTab = 1
	self:updatTaskScroll()
end
function FootballKingRoadPanel:onClickTabItem(index)
	local newChooseTab = index
	if index == self.curChooseTab then
		return
	end
	self.curChooseTab = newChooseTab
	self:updatTaskScroll()
end
function FootballKingRoadPanel:onClickGetAward(taskID)
	SoraDShowLoading()
	footballKingCtrl:reqFootballKingReward(taskID)
end
function FootballKingRoadPanel:onClickGo(guideId, taskDes)
	dump(guideId, "guideId")
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function FootballKingRoadPanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	obj:initData(boxInfo, index + 1)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
function FootballKingRoadPanel:buttonGetRewardCallBack(stageData)
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = stageData.Id
	;(nil).data = stageData
	uiManager:show("FootballKingReward", nil)
end
return FootballKingRoadPanel
