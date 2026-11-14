local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
local nebulaKingRead = include("nebulaKingRead")
local constantRead = include("constantRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaKingMainPanel = class("NebulaKingMainPanel", baseFguiPanel)
function NebulaKingMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaKingMainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_KING_ACTIVITY
end
function NebulaKingMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaKingMainPanel:onInit()
	print("=======NebulaKingMainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001440"), handler(self, self.onClickClose), function()
		_ENV = nil
		;(nil).content = i18n("Nebulaking_text_25")
		uiManager:show("RuleView", nil)
	end)
	if SoraDFIsRA() then
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self.fields.Button_rank:setString(i18n("common_text_851"))
	self.fields.Text_reward:setString(i18n("common_text_1875"))
	_UPVALUE5_ = self.fields.Text_reward.setString
	self.stages, self.fields.Text_reward.setString[1] = self.fields.Text_reward.setString, self.fields.Com_stage1
	self.stages, self.fields.Text_reward.setString[2] = self.fields.Text_reward.setString, self.fields.Com_stage2
	self.stages, self.fields.Text_reward.setString[3] = self.fields.Text_reward.setString, self.fields.Com_stage3
	self.stages, self.fields.Text_reward.setString[4] = self.fields.Text_reward.setString, self.fields.Com_stage4
	self.stages, self.fields.Text_reward.setString[5] = self.fields.Text_reward.setString, self.fields.Com_stage5
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
function NebulaKingMainPanel:onClickRank()
	uiManager:show("NebulaKingRank")
end
function NebulaKingMainPanel:onClickQuestion()
	uiManager:show("NebulaKingScore")
end
function NebulaKingMainPanel:onItemRenderer(index, obj)
	local idx = self.scoreIndexList[index + 1]
	local data = self.scoreRewardList[idx]
	obj:initData(data, not self.isOpen)
end
function NebulaKingMainPanel:onShow()
	print("=======NebulaKingMainPanel:onShow")
	nebulaKingCtrl:sendReqInit()
	local groupId = nebulaKingCtrl:getGroupId()
	local groupCfg = nebulaKingRead.getGroupCfg(groupId)
	self.fields.Spine_hero:setEffectPath(groupCfg.picture)
	self:updateUI()
end
function NebulaKingMainPanel:updateUI()
	local groupId = nebulaKingCtrl:getGroupId()
	local groupCfg = nebulaKingRead.getGroupCfg(groupId)
	local activityData = nebulaKingCtrl:getActivityData()
	self.beginTime = activityData.begintime
	self.endTime = activityData.endtime
	local curStage = nebulaKingCtrl:getCurrentStage()
	self.stageBeginTime, self.stageEndTime = nebulaKingCtrl:getStageTime()
	self.fields.Com_item1:initData(groupCfg.previewReward[1])
	self.fields.Com_item2:setVisible(#groupCfg.previewReward > 1)
	self.fields.Com_item2:initData(groupCfg.previewReward[2])
	for index, value in ipairs(self.stages) do
		value:initData(index)
	end
	local myScore = nebulaKingCtrl:getMyScore()
	local myRank = 0
	if nebulaKingCtrl:isActivityOpen() then
		self.controllers.c1:setSelectedIndex(0)
		nebulaKingCtrl = value
		value.num = string.formatnumberthousands(myScore)
		self.fields.Text_myScore:setString(i18n("common_text_2557", value))
		myRank = nebulaKingCtrl:getMyRank()
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_myScore:setString(i18n("Nebulaking_text_22"))
		myRank = nebulaKingCtrl:getMyTotalRank()
	end
	local maxRank = constantRead.getConstValue("NEBULAKING_UNRANK", 5)
	if myRank == 0 then
		nebulaKingCtrl = i18n("Nebulaking_text_22")
		i18n("Nebulaking_text_22").rank = i18n("common_text_827")
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("Nebulaking_text_22")))
	elseif myRank > maxRank then
		nebulaKingCtrl = i18n("common_text_825", i18n("Nebulaking_text_22"))
		i18n("common_text_825", i18n("Nebulaking_text_22")).rank = maxRank .. "+"
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))))
	else
		nebulaKingCtrl = i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))
		i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22"))).rank = myRank
		self.fields.Text_myRank:setString(i18n("common_text_825", i18n("common_text_825", i18n("common_text_825", i18n("Nebulaking_text_22")))))
	end
	self.scoreIndexList, nebulaKingCtrl, self.scoreRewardList = nebulaKingCtrl:getStageScoreReward(), nebulaKingCtrl:getStageScoreReward(), nebulaKingCtrl:getStageScoreReward()
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
	self.isOpen = nebulaKingCtrl:isActivityOpen()
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
return NebulaKingMainPanel
