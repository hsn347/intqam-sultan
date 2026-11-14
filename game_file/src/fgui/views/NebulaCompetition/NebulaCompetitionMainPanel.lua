local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
local nebulaCompetitionRead = include("nebulaCompetitionRead")
local constantRead = include("constantRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionMainPanel = class("NebulaCompetitionMainPanel", baseFguiPanel)
function NebulaCompetitionMainPanel:ctor(...)
	self.isHideCurrentSceneView = true
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCompetitionMainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY
end
function NebulaCompetitionMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaCompetitionMainPanel:onInit()
	print("=======NebulaCompetitionMainPanel:onInit")
	self.fields.Com_title:initData(i18n("Nebula_Competition_title_01"), handler(self, self.onClickClose), function()
		_ENV = nil
		;(nil).content = i18n("Nebula_Competition_text_03")
		uiManager:show("RuleView", nil)
	end)
	if SoraDFIsRA() then
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self.fields.btn_campScore:setString(i18n("Nebula_Competition_text_09"))
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Text_kingdoms:setString(i18n("Nebula_Competition_text_04"))
	_UPVALUE6_ = self.fields.Text_kingdoms.setString
	self.stages, self.fields.Text_kingdoms.setString[1] = self.fields.Text_kingdoms.setString, self.fields.Com_stage1
	self.stages, self.fields.Text_kingdoms.setString[2] = self.fields.Text_kingdoms.setString, self.fields.Com_stage2
	self.stages, self.fields.Text_kingdoms.setString[3] = self.fields.Text_kingdoms.setString, self.fields.Com_stage3
	self.stages, self.fields.Text_kingdoms.setString[4] = self.fields.Text_kingdoms.setString, self.fields.Com_stage4
	self.stages, self.fields.Text_kingdoms.setString[5] = self.fields.Text_kingdoms.setString, self.fields.Com_stage5
	self.stages, self.fields.Text_kingdoms.setString[6] = self.fields.Text_kingdoms.setString, self.fields.Com_stage6
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickRank))
	self.fields.Button_question:addClickListener(handler(self, self.onClickQuestion))
	self.fields.Button_kingdoms:addClickListener(handler(self, self.onClickKingdoms))
	self.fields.btn_campScore:addClickListener(handler(self, self.onClickCampScore))
	for index, value in ipairs(self.stages) do
		value:fix()
		value:fixPos()
	end
	self.fields.Text_myRank:fixPos()
	self.fields.Text_myScore:fixPos()
	self.fields.Button_question:fixPos()
	self.fields.Text_kingdoms:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
end
function NebulaCompetitionMainPanel:onClickRank()
	SoraDPlaySound()
	uiManager:show("NebulaCompetitionRank")
end
function NebulaCompetitionMainPanel:onClickQuestion()
	SoraDPlaySound()
	if not nebulaCompetitionCtrl:isActivityOpen() then
		SoraDShowMsgTip(i18n("Nebula_Competition_text_08"))
		return
	end
	uiManager:show("NebulaCompetitionScore")
end
function NebulaCompetitionMainPanel:onClickKingdoms()
	SoraDPlaySound()
	uiManager:show("NebulaCompetitionKingdoms")
end
function NebulaCompetitionMainPanel:onClickCampScore()
	SoraDPlaySound()
	uiManager:show("NebulaCompetitionBattle")
end
function NebulaCompetitionMainPanel:onItemRenderer(index, obj)
	local idx = self.scoreIndexList[index + 1]
	local data = self.scoreRewardList[idx]
	obj:initData(data, not self.isOpen)
end
function NebulaCompetitionMainPanel:onShow()
	print("=======NebulaCompetitionMainPanel:onShow")
	nebulaCompetitionCtrl:sendReqInit()
	local groupId = nebulaCompetitionCtrl:getGroupId()
	local groupCfg = nebulaCompetitionRead.getGroupCfg(groupId)
	self:updateUI()
end
function NebulaCompetitionMainPanel:updateUI()
	local groupId = nebulaCompetitionCtrl:getGroupId()
	local groupCfg = nebulaCompetitionRead.getGroupCfg(groupId)
	local activityData = nebulaCompetitionCtrl:getActivityData()
	self.beginTime = activityData.begintime
	self.endTime = activityData.endtime
	local curStage = nebulaCompetitionCtrl:getCurrentStage()
	_ENV, self.stageBeginTime, self.stageEndTime = nebulaCompetitionCtrl:getStageTime()
	nebulaCompetitionCtrl:getStageTime()[1] = groupCfg.previewReward[1]
	local nebulaCompetitionCtrl:getStageTime()[2], showRewrads = groupCfg.previewReward[2], nebulaCompetitionCtrl:getStageTime()
	if nebulaCompetitionCtrl:isActivityOpen() then
		_ENV = nebulaCompetitionCtrl:isActivityOpen()
		showRewrads, nebulaCompetitionCtrl:isActivityOpen()[1] = nebulaCompetitionCtrl:isActivityOpen(), groupCfg.previewReward1[curStage * 2 - 1]
		showRewrads, nebulaCompetitionCtrl:isActivityOpen()[2] = nebulaCompetitionCtrl:isActivityOpen(), groupCfg.previewReward1[curStage * 2]
	else
		_ENV = nebulaCompetitionCtrl:isActivityOpen()
		showRewrads, nebulaCompetitionCtrl:isActivityOpen()[1] = nebulaCompetitionCtrl:isActivityOpen(), groupCfg.previewReward1[13]
		showRewrads, nebulaCompetitionCtrl:isActivityOpen()[2] = nebulaCompetitionCtrl:isActivityOpen(), groupCfg.previewReward1[14]
	end
	self.fields.Com_item1:initData(showRewrads[1])
	self.fields.Com_item2:setVisible(1 < #showRewrads)
	self.fields.Com_item2:initData(showRewrads[2])
	for index, value in ipairs(self.stages) do
		value:initData(index)
	end
	local myScore = nebulaCompetitionCtrl:getMyScore()
	local myRank = 0
	if nebulaCompetitionCtrl:isActivityOpen() then
		self.controllers.c1:setSelectedIndex(0)
		nebulaCompetitionCtrl = value
		value.num = string.formatnumberthousands(myScore)
		self.fields.Text_myScore:setString(i18n("common_text_2557", value))
		myRank = nebulaCompetitionCtrl:getMyRank()
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_myScore:setString(i18n("Nebulaking_text_22"))
		myRank = nebulaCompetitionCtrl:getMyTotalRank()
	end
	local maxRank = constantRead.getConstValue("NEBULAKING_UNRANK", 5)
	if myRank == 0 then
		nebulaCompetitionCtrl = i18n("Nebulaking_text_22")
		i18n("Nebulaking_text_22").rank = i18n("common_text_827")
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("Nebulaking_text_22")))
	elseif myRank > maxRank then
		nebulaCompetitionCtrl = i18n("common_text_825", i18n("Nebulaking_text_22"))
		i18n("common_text_825", i18n("Nebulaking_text_22")).rank = maxRank .. "+"
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))))
	else
		nebulaCompetitionCtrl = i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))
		i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))).rank = myRank
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))))
	end
	self.scoreIndexList, nebulaCompetitionCtrl, self.scoreRewardList = nebulaCompetitionCtrl:getStageScoreReward(), nebulaCompetitionCtrl:getStageScoreReward(), nebulaCompetitionCtrl:getStageScoreReward()
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
	self.isOpen = nebulaCompetitionCtrl:isActivityOpen()
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
return NebulaCompetitionMainPanel
