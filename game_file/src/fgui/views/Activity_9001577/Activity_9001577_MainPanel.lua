local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
local activity_9001577_Read = include("activity_9001577_Read")
local constantRead = include("constantRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001577_MainPanel = class("Activity_9001577_MainPanel", baseFguiPanel)
function Activity_9001577_MainPanel:ctor(...)
	self.isHideCurrentSceneView = true
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001577_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577
end
function Activity_9001577_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001577_MainPanel:onInit()
	print("=======Activity_9001577_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001577"), handler(self, self.onClickClose), function()
		_ENV = nil
		;(nil).content = i18n("Icefestival2024_text05")
		uiManager:show("RuleView", nil)
	end)
	if SoraDFIsRA() then
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self.fields.Button_rank:setString(i18n("common_text_851"))
	_UPVALUE6_ = self.fields.Button_rank.setString
	self.stages, self.fields.Button_rank.setString[1] = self.fields.Button_rank.setString, self.fields.Com_stage1
	self.stages, self.fields.Button_rank.setString[2] = self.fields.Button_rank.setString, self.fields.Com_stage2
	self.stages, self.fields.Button_rank.setString[3] = self.fields.Button_rank.setString, self.fields.Com_stage3
	self.stages, self.fields.Button_rank.setString[4] = self.fields.Button_rank.setString, self.fields.Com_stage4
	self.stages, self.fields.Button_rank.setString[5] = self.fields.Button_rank.setString, self.fields.Com_stage5
	self.stages, self.fields.Button_rank.setString[6] = self.fields.Button_rank.setString, self.fields.Com_stage6
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickRank))
	self.fields.Button_question:addClickListener(handler(self, self.onClickQuestion))
	for index, value in ipairs(self.stages) do
		value:fix()
		value:fixPos()
	end
	self.fields.Text_myRank:fixPos()
	self.fields.Text_myScore:fixPos()
	self.fields.Button_question:fixPos()
end
function Activity_9001577_MainPanel:onClickRank()
	SoraDPlaySound()
	uiManager:show("Activity_9001577_Rank")
end
function Activity_9001577_MainPanel:onClickQuestion()
	SoraDPlaySound()
	if not activity_9001577_Ctrl:isActivityOpen() then
		SoraDShowMsgTip(i18n("Nebula_Competition_text_08"))
		return
	end
	uiManager:show("Activity_9001577_Score")
end
function Activity_9001577_MainPanel:onItemRenderer(index, obj)
	local idx = self.scoreIndexList[index + 1]
	local data = self.scoreRewardList[idx]
	obj:initData(data, not self.isOpen)
end
function Activity_9001577_MainPanel:onShow()
	print("=======Activity_9001577_MainPanel:onShow")
	activity_9001577_Ctrl:sendReqInit()
	local groupId = activity_9001577_Ctrl:getGroupId()
	local groupCfg = activity_9001577_Read.getGroupCfg(groupId)
	self:updateUI()
end
function Activity_9001577_MainPanel:updateUI()
	local groupId = activity_9001577_Ctrl:getGroupId()
	local groupCfg = activity_9001577_Read.getGroupCfg(groupId)
	local activityData = activity_9001577_Ctrl:getActivityData()
	self.beginTime = activityData.begintime
	self.endTime = activityData.endtime
	local curStage = activity_9001577_Ctrl:getCurrentStage()
	self.stageBeginTime, self.stageEndTime = activity_9001577_Ctrl:getStageTime()
	for index, value in ipairs(self.stages) do
		value:initData(index)
	end
	local myScore = activity_9001577_Ctrl:getMyScore()
	local myRank = 0
	if activity_9001577_Ctrl:isActivityOpen() then
		self.controllers.c1:setSelectedIndex(0)
		activity_9001577_Ctrl = value
		value.num = string.formatnumberthousands(myScore)
		self.fields.Text_myScore:setString(i18n("common_text_2557", value))
		myRank = activity_9001577_Ctrl:getMyRank()
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_myScore:setString(i18n("Nebulaking_text_22"))
		myRank = activity_9001577_Ctrl:getMyTotalRank()
	end
	local maxRank = constantRead.getConstValue("NEBULAKING_UNRANK", 5)
	if myRank == 0 then
		activity_9001577_Ctrl = i18n("Nebulaking_text_22")
		i18n("Nebulaking_text_22").rank = i18n("common_text_827")
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("Nebulaking_text_22")))
	elseif myRank > maxRank then
		activity_9001577_Ctrl = i18n("common_text_825", i18n("Nebulaking_text_22"))
		i18n("common_text_825", i18n("Nebulaking_text_22")).rank = maxRank .. "+"
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))))
	else
		activity_9001577_Ctrl = i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))
		i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))).rank = myRank
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))))
	end
	self.scoreIndexList, activity_9001577_Ctrl, self.scoreRewardList = activity_9001577_Ctrl:getStageScoreReward(), activity_9001577_Ctrl:getStageScoreReward(), activity_9001577_Ctrl:getStageScoreReward()
	for i, v in ipairs(self.scoreRewardList) do
		if myScore < v.task[1] then
			table.insert(self.scoreIndexList, i)
		end
	end
	for i, v in ipairs(self.scoreRewardList) do
		if myScore >= v.task[1] then
			table.insert(self.scoreIndexList, i)
		end
	end
	self.isOpen = activity_9001577_Ctrl:isActivityOpen()
	self.fields.Button_question:setGrayed(not self.isOpen)
	self.fields.List:setNumItems(#self.scoreIndexList)
	local reachIndex = 1
	for index, value in ipairs(self.scoreRewardList) do
		if myScore <= value.task[1] then
			reachIndex = index
		end
	end
	self.fields.List:scrollToView(0, false, false)
	local currentTime = serviceFunctions.systemTime()
	local activityLeftTime = self.endTime - currentTime
	if activityLeftTime < 0 then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	local Label_time = self.fields.Com_title:getLabelTime()
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	if activityData.doStage < #activityData.stagetimes then
		Label_time:setTimeLast(function(strTime)
			return i18n("Nebula_Competition_text_17") .. strTime
		end)
		local stageLeftTime = self.stageEndTime - currentTime
		Label_time:beginTime(stageLeftTime)
	else
		Label_time:setTimeLast(function(strTime)
			return i18n("common_text_2669") .. strTime
		end)
		local activityLeftTime = self.endTime - currentTime
		Label_time:beginTime(activityLeftTime)
	end
end
return Activity_9001577_MainPanel
