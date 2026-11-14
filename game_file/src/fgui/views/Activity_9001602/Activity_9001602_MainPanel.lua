local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
local eventQuestRead = include("eventQuestRead")
local snowWolfLostRead = include("snowWolfLostRead")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local MAX_SURVEYNUM = constantRead.getConstValue("FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM", 20)
_ENV = "FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM"
;("FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = constantRead.getConstValue("FIREDRAGON_OF_ANGER_SUMMON_ITEM", 1681)
local _ENV, ("FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], itemIDs = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696, 1709, "FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM"
gActivityTimeActivityID.NORMAL_ACTIVITY_9001696[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = activity_9001602_Ctrl
local _ENV, gActivityTimeActivityID.NORMAL_ACTIVITY_9001696[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], activityCtrl = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696, activity_9001696_Ctrl, gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
gActivityTimeActivityID.NORMAL_ACTIVITY_9001696[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001603
local gActivityTimeActivityID.NORMAL_ACTIVITY_9001696[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], exchangeActivityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010007, gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001602_MainPanel = class("Activity_9001602_MainPanel", baseFguiPanel)
function Activity_9001602_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("Activity_9001602_MainPanel:ctor", self.viewName)
end
function Activity_9001602_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001602_MainPanel:onInit()
	print("=======Activity_9001602_MainPanel:onInit")
	self.callNeedNum = constantRead.getConstValue("FIREDRAGON_OF_ANGER_SUMMON_ITEM_NUM")
	self.taskDailyLimit = constantRead.getConstValue("FIREDRAGON_OF_ANGER_MAX_QUEST_NUM")
	self.fields.Com_title:initData(i18n("activity_name_9001602"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("firedragon_of_anger_text2"))
	self.fields.Text_done:setString(i18n("lost_ruins_text_22"))
	self.fields.Btn_receive:setString(i18n("common_text_1146"))
	self.fields.Btn_receive:addClickListener(handler(self, self.onReceiveClick))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setAlignCenter(true)
	self.Text_questTime = SoraDCreateTimerLabel(self, self.fields.Text_questTime)
	self.Text_questTime:setTimeEndListener(handler(self, function()
		self:updateView()
	end))
	self.Text_questTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("lost_ruins_text_15", nil)
	end)
	self.fields.Btn_preView:setString(i18n("soldier_rush_text_11"))
	self.fields.Btn_preView:addClickListener(handler(self, self.onPreViewClick))
	self.fields.Btn_call:setString(i18n("common_text_2341"))
	self.fields.Btn_call:addClickListener(handler(self, self.onCallClick))
	self.fields.btn_shop:setString(i18n("common_text_1809"))
	self.fields.btn_shop:addClickListener(handler(self, self.onShopClick))
	self.fields.Btn_survey:setString(i18n("lost_ruins_text_24"))
	self.fields.Btn_survey:addClickListener(handler(self, self.onSurveyClick))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.onSurveyClick))
	self.fields.Btn_record:addClickListener(handler(self, self.onRecordClick))
	_UPVALUE2_ = handler(self, self.onRecordClick)
	handler(self, self.onRecordClick)[1] = "ar"
	handler(self, self.onRecordClick)[2] = "en"
	self.fields.icon_title:setURL(SoraDGetImageNameByLang("frame_hlzn_%s.png", handler(self, self.onRecordClick)))
	self.fields.Btn_call:fixPos()
	self.fields.Btn_survey:fixPos()
	self.fields.Btn_go:fixPos()
	self.fields.Btn_receive:fixPos()
	self.fields.Text_questPro:fixPos()
	self.fields.Lab_call:fixPos()
	self.fields.Btn_record:fixPos()
	self.fields.Usm_2:setMaxChunkSize(182784)
end
function Activity_9001602_MainPanel:onShow()
	print("=======Activity_9001602_MainPanel:onShow")
	self.activityID = self.param.activityID
	self.callItemID = itemIDs[self.activityID]
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self:updateView()
end
function Activity_9001602_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function Activity_9001602_MainPanel:updateView(target, data)
	local runningQuest = activityCtrl[self.activityID]:getRunningQuestInfo()
	self.questInfo = nil
	if runningQuest and next(runningQuest) then
		self.questInfo = activityCtrl[self.activityID]:getQuestInfo(cc.p(tonumber(runningQuest.x), tonumber(runningQuest.y)))
	end
	if self.questInfo then
		local showIndex = activityCtrl[self.activityID]:getQuestShowIndex(self.questInfo.state)
		self.controllers.c1:setSelectedIndex(showIndex)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		local progress = activityCtrl[self.activityID]:getQuestProgress(self.questInfo.questId)
		activityCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		;("(%{num}/%{num2})").num2 = aim
		self.fields.Text_curQuestPro:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. "(%{num}/%{num2})", "(%{num}/%{num2})")
		activityCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		activityCtrl, activityCtrl, ("(%{num}/%{num2})").num2 = eventQuestRead.getDes(self.questInfo.questId)
		eventQuestRead.getDes(self.questInfo.questId).num, eventQuestRead.getDes(self.questInfo.questId).color = eventQuestRead.getDes(self.questInfo.questId)
		self.fields.Text_progress:setString(i18n_html(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. "(%{num}/%{num2})", "(%{num}/%{num2})", eventQuestRead.getDes(self.questInfo.questId)))
		self.awardConfig = eventQuestRead.getReward(self.questInfo.questId)
		self.fields.List_reward:setNumItems(#self.awardConfig)
		self:initActivityTime(not self.questInfo.isFinish)
		self.fields.Btn_survey:setTitle(i18n("common_text_477"))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Btn_survey:setTitle(i18n("lost_ruins_text_24"))
	end
	local itemHave = activityCtrl[self.activityID]:getItemCount(self.callItemID)
	eventQuestRead = self.callItemID
	self.callItemID[1] = self.callItemID
	self.callItemID[2] = itemHave
	dump(self.callItemID, "self.callItemID")
	activityCtrl = i18n("lost_ruins_text_24")
	i18n("lost_ruins_text_24").num1 = itemHave
	activityCtrl, activityCtrl, i18n("lost_ruins_text_24").num2 = i18n("lost_ruins_text_24")
	self.callNeedNum.num1, i18n("lost_ruins_text_24").color = i18n("lost_ruins_text_24")
	self.fields.Lab_call:setString(i18n_html("firedragon_of_anger_text3", i18n("lost_ruins_text_24")))
	self.fields.Lab_call:setIcon(publicRead.getIcon(self.callItemID))
	activityCtrl = publicRead.getIcon(self.callItemID)
	publicRead.getIcon(self.callItemID).num = activityCtrl[self.activityID]:getFinishNum()
	activityCtrl, activityCtrl, publicRead.getIcon(self.callItemID).limitNum = activityCtrl[self.activityID], self.taskDailyLimit, self.taskDailyLimit
	self.taskDailyLimit.num, activityCtrl[self.activityID].color = activityCtrl[self.activityID], activityCtrl[self.activityID]:getFinishNum() ~= 0 and "#F0E6D2" or "#BE2828"
	self.fields.Text_questPro:setString(i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)))
	local curNum = activityCtrl[self.activityID]:getSurveyNum()
	local maxNum = MAX_SURVEYNUM
	activityCtrl = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var1 = curNum
	activityCtrl, activityCtrl, i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var2 = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var1, i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).color = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	self.fields.Btn_record:setString(i18n_html("windActive_text_04", i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))))
end
function Activity_9001602_MainPanel:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getActivityTaskTimeByQuestId(self.questInfo.questId, self.activityID)
	if isRunTime then
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - activityCtrl[self.activityID]:getRunningQuestInfo().startTime))
		if 0 < leftTime then
			self.Text_questTime:beginTime(leftTime)
			self.fields.Btn_go:setBeginTime(leftTime)
		else
			self.Text_questTime:setString(i18n("lost_ruins_text_22"))
		end
	else
		self.Text_questTime:setString(i18n("lost_ruins_text_22"))
	end
end
function Activity_9001602_MainPanel:onPreViewClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001602_Reward", nil)
end
function Activity_9001602_MainPanel:onCallClick()
	SoraDPlaySound()
	local itemHave = activityCtrl[self.activityID]:getItemCount(self.callItemID)
	if itemHave < self.callNeedNum then
		SoraDShowMsgTip(i18n("lost_ruins_text_04"))
	else
		activityCtrl[self.activityID]:reqLegendOfPegasusSummonBoss()
		self:close()
	end
end
function Activity_9001602_MainPanel:onShopClick()
	SoraDPlaySound()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(exchangeActivityID[self.activityID])
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		SoraDShowMsgTip(i18n("firedragon_of_anger_text4"))
	else
		_ENV = i18n("firedragon_of_anger_text4")
		i18n("firedragon_of_anger_text4").id = exchangeActivityID[self.activityID]
		uiManager:show("ExchangeEventPage", i18n("firedragon_of_anger_text4")):setOwnerKey(self)
	end
end
function Activity_9001602_MainPanel:onSurveyClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if self.questInfo and next(self.questInfo) then
		if self.questInfo.isFinish then
			activityCtrl[self.activityID]:reqLegendOfPegasusRecieveReward()
		else
			local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				SoraDShowMsgTip(i18n(eventQuestRead.getDes(self.questInfo.questId)))
				return
			end
			if guideId then
				local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
				if not notNeedClose then
					SoraDRemoveAllPanelFromManager()
				end
			end
		end
	else
		_ENV = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		mildGuideManager:starMildByNewPlayerStringParam(guideId).byUID = true
		local hasFirstJump = SoraDConfigGet("Game:LegendOfPegasus:first~bool", mildGuideManager:starMildByNewPlayerStringParam(guideId))
		if not hasFirstJump then
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_LEGENDOFPEGASUS)
			SoraDRemoveAllPanelFromManager()
			_ENV = SoraDRemoveAllPanelFromManager
			SoraDRemoveAllPanelFromManager.byUID = true
			SoraDConfigSet("Game:LegendOfPegasus:first~bool", true, SoraDRemoveAllPanelFromManager)
		else
			_ENV = true
			activityCtrl[self.activityID]:reqLegendOfPegasusSearch(true)
		end
	end
end
function Activity_9001602_MainPanel:onRecordClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001602_Record", nil)
end
function Activity_9001602_MainPanel:onReceiveClick()
	SoraDPlaySound()
	activityCtrl[self.activityID]:reqLegendOfPegasusRecieveReward()
end
function Activity_9001602_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("firedragon_of_anger_text1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return Activity_9001602_MainPanel
