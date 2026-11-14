local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
local eventQuestRead = include("eventQuestRead")
local snowWolfLostRead = include("snowWolfLostRead")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local MAX_SURVEYNUM = constantRead.getConstValue("LEGEND_OF_PEGASUS_MAX_SURVEYED_NUM", 20)
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendOfPegasusMainPanel = class("LegendOfPegasusMainPanel", baseFguiPanel)
function LegendOfPegasusMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("LegendOfPegasusMainPanel:ctor", self.viewName)
end
function LegendOfPegasusMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendOfPegasusMainPanel:onInit()
	print("=======LegendOfPegasusMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
	self.callNeedNum = constantRead.getConstValue("LEGEND_OF_PEGASUS_SUMMON_ITEM_NUM")
	self.callItemID = constantRead.getConstValue("LEGEND_OF_PEGASUS_SUMMON_ITEM", 1672)
	self.taskDailyLimit = constantRead.getConstValue("LEGEND_OF_PEGASUS_MAX_QUEST_NUM")
	self.fields.Com_title:initData(i18n("activity_name_9001559"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("Legends_of_Pegasus_text_02"))
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
	self.fields.Btn_survey:setString(i18n("lost_ruins_text_24"))
	self.fields.Btn_survey:addClickListener(handler(self, self.onSurveyClick))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.onSurveyClick))
	self.fields.Btn_record:addClickListener(handler(self, self.onRecordClick))
	_UPVALUE2_ = handler(self, self.onRecordClick)
	handler(self, self.onRecordClick)[1] = "ar"
	handler(self, self.onRecordClick)[2] = "en"
	self.fields.icon_title:setURL(SoraDGetImageNameByLang("frame_yfct_%s.png", handler(self, self.onRecordClick)))
	self.fields.Btn_call:fixPos()
	self.fields.Btn_survey:fixPos()
	self.fields.Btn_go:fixPos()
	self.fields.Btn_receive:fixPos()
	self.fields.Text_questPro:fixPos()
	self.fields.Lab_call:fixPos()
	self.fields.Btn_record:fixPos()
	self.fields.Usm_2:setMaxChunkSize(182784)
end
function LegendOfPegasusMainPanel:onShow()
	print("=======LegendOfPegasusMainPanel:onShow")
	self:updateView()
end
function LegendOfPegasusMainPanel:onItemRenderer(index, obj)
	obj:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function LegendOfPegasusMainPanel:updateView(target, data)
	local runningQuest = legendOfPegasusCtrl:getRunningQuestInfo()
	self.questInfo = nil
	if runningQuest and next(runningQuest) then
		self.questInfo = legendOfPegasusCtrl:getQuestInfo(cc.p(tonumber(runningQuest.x), tonumber(runningQuest.y)))
	end
	if self.questInfo then
		local showIndex = legendOfPegasusCtrl:getQuestShowIndex(self.questInfo.state)
		self.controllers.c1:setSelectedIndex(showIndex)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		local progress = legendOfPegasusCtrl:getQuestProgress(self.questInfo.questId)
		legendOfPegasusCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		;("(%{num}/%{num2})").num2 = aim
		self.fields.Text_curQuestPro:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. "(%{num}/%{num2})", "(%{num}/%{num2})")
		legendOfPegasusCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		legendOfPegasusCtrl, legendOfPegasusCtrl, ("(%{num}/%{num2})").num2 = eventQuestRead.getDes(self.questInfo.questId)
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
	local itemHave = legendOfPegasusCtrl:getItemCount(self.callItemID)
	legendOfPegasusCtrl = i18n("lost_ruins_text_24")
	i18n("lost_ruins_text_24").num1 = itemHave
	legendOfPegasusCtrl, legendOfPegasusCtrl, i18n("lost_ruins_text_24").num2 = i18n("lost_ruins_text_24")
	self.callNeedNum.num1, i18n("lost_ruins_text_24").color = i18n("lost_ruins_text_24")
	self.fields.Lab_call:setString(i18n_html("Legends_of_Pegasus_text_04", i18n("lost_ruins_text_24")))
	self.fields.Lab_call:setIcon(publicRead.getIcon(self.callItemID))
	legendOfPegasusCtrl = publicRead.getIcon(self.callItemID)
	publicRead.getIcon(self.callItemID).num = legendOfPegasusCtrl:getFinishNum()
	legendOfPegasusCtrl, legendOfPegasusCtrl, publicRead.getIcon(self.callItemID).limitNum = legendOfPegasusCtrl, self.taskDailyLimit, self.taskDailyLimit
	self.taskDailyLimit.num, legendOfPegasusCtrl.color = legendOfPegasusCtrl, legendOfPegasusCtrl:getFinishNum() ~= 0 and "#F0E6D2" or "#BE2828"
	self.fields.Text_questPro:setString(i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)))
	local curNum = legendOfPegasusCtrl:getSurveyNum()
	local maxNum = MAX_SURVEYNUM
	legendOfPegasusCtrl = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var1 = curNum
	legendOfPegasusCtrl, legendOfPegasusCtrl, i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var2 = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).var1, i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID)).color = i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))
	self.fields.Btn_record:setString(i18n_html("Legends_of_Pegasus_text_03", i18n_html("lost_ruins_text_38", publicRead.getIcon(self.callItemID))))
end
function LegendOfPegasusMainPanel:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getLegendOfPegasusTaskTimeByQuestId(self.questInfo.questId)
	if isRunTime then
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - legendOfPegasusCtrl:getRunningQuestInfo().startTime))
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
function LegendOfPegasusMainPanel:onPreViewClick()
	SoraDPlaySound()
	uiManager:show("LegendOfPegasusReward")
end
function LegendOfPegasusMainPanel:onCallClick()
	SoraDPlaySound()
	local itemHave = legendOfPegasusCtrl:getItemCount(self.callItemID)
	if itemHave < self.callNeedNum then
		SoraDShowMsgTip(i18n("lost_ruins_text_04"))
	else
		legendOfPegasusCtrl:reqLegendOfPegasusSummonBoss()
		self:close()
	end
end
function LegendOfPegasusMainPanel:onSurveyClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if self.questInfo and next(self.questInfo) then
		if self.questInfo.isFinish then
			legendOfPegasusCtrl:reqLegendOfPegasusRecieveReward()
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
			legendOfPegasusCtrl:reqLegendOfPegasusSearch(true)
		end
	end
end
function LegendOfPegasusMainPanel:onRecordClick()
	SoraDPlaySound()
	uiManager:show("LegendOfPegasusRecord")
end
function LegendOfPegasusMainPanel:onReceiveClick()
	SoraDPlaySound()
	legendOfPegasusCtrl:reqLegendOfPegasusRecieveReward()
end
function LegendOfPegasusMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Legends_of_Pegasus_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return LegendOfPegasusMainPanel
