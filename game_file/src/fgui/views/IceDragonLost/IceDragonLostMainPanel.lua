local iceDragonLostCtrl = SoraDGetCtrl("iceDragonLostCtrl")
local eventQuestRead = include("eventQuestRead")
local snowWolfLostRead = include("snowWolfLostRead")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonLostMainPanel = class("IceDragonLostMainPanel", baseFguiPanel)
function IceDragonLostMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonLostMainPanel:ctor", self.viewName)
end
function IceDragonLostMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonLostMainPanel:onInit()
	print("=======IceDragonLostMainPanel:onInit")
	self.activityID = gActivityTimeActivityID.ICE_DRAGON_LOST
	self.callNeedNum = constantRead.getConstValue("ICEDRAGON_LOST_SUMMON_ITEM_NUM")
	self.callItemID = constantRead.getConstValue("ICEDRAGON_LOST_SUMMON_ITEM")
	self.taskDailyLimit = constantRead.getConstValue("ICEDRAGON_LOST_MAX_QUEST_NUM")
	self.fields.Com_title:initData(i18n("activity_name_9001482"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("icedragon_lost_02"))
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
	self.fields.Btn_record:setString(i18n("lost_ruins_text_23"))
	self.fields.Btn_record:addClickListener(handler(self, self.onRecordClick))
	self.fields.Btn_call:fixPos()
	self.fields.Btn_survey:fixPos()
	self.fields.Text_questPro:fixPos()
	self.fields.Lab_call:fixPos()
end
function IceDragonLostMainPanel:onShow()
	print("=======IceDragonLostMainPanel:onShow")
	self:updateView()
end
function IceDragonLostMainPanel:onItemRenderer(index, obj)
	obj:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function IceDragonLostMainPanel:updateView(target, data)
	local runningQuest = iceDragonLostCtrl:getRunningQuestInfo()
	self.questInfo = nil
	if runningQuest and next(runningQuest) then
		self.questInfo = iceDragonLostCtrl:getQuestInfo(cc.p(tonumber(runningQuest.x), tonumber(runningQuest.y)))
	end
	if self.questInfo then
		local showIndex = iceDragonLostCtrl:getQuestShowIndex(self.questInfo.state)
		self.controllers.c1:setSelectedIndex(showIndex)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		local progress = iceDragonLostCtrl:getQuestProgress(self.questInfo.questId)
		iceDragonLostCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		;("(%{num}/%{num2})").num2 = aim
		self.fields.Text_curQuestPro:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. "(%{num}/%{num2})", "(%{num}/%{num2})")
		iceDragonLostCtrl = "(%{num}/%{num2})"
		;("(%{num}/%{num2})").num = progress
		iceDragonLostCtrl, iceDragonLostCtrl, ("(%{num}/%{num2})").num2 = eventQuestRead.getDes(self.questInfo.questId)
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
	local itemHave = backpackCtrl:getItemCount(self.callItemID)
	iceDragonLostCtrl = i18n("lost_ruins_text_24")
	i18n("lost_ruins_text_24").num1 = itemHave
	iceDragonLostCtrl, iceDragonLostCtrl, i18n("lost_ruins_text_24").num2 = i18n("lost_ruins_text_24")
	self.callNeedNum.num1, i18n("lost_ruins_text_24").color = i18n("lost_ruins_text_24")
	self.fields.Lab_call:setString(i18n_html("icedragon_lost_11", i18n("lost_ruins_text_24")))
	self.fields.Lab_call:setIcon(publicRead.getIcon(self.callItemID))
	iceDragonLostCtrl = publicRead.getIcon(self.callItemID)
	publicRead.getIcon(self.callItemID).num = iceDragonLostCtrl:getFinishNum()
	publicRead.getIcon(self.callItemID).limitNum = self.taskDailyLimit
	self.fields.Text_questPro:setString(i18n("lost_ruins_text_38", publicRead.getIcon(self.callItemID)))
end
function IceDragonLostMainPanel:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getIceDragonTaskTimeByQuestId(self.questInfo.questId)
	if isRunTime then
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - iceDragonLostCtrl:getRunningQuestInfo().startTime))
		if 0 < leftTime then
			self.Text_questTime:beginTime(leftTime)
		else
			self.Text_questTime:setString(i18n("lost_ruins_text_22"))
		end
	else
		self.Text_questTime:setString(i18n("lost_ruins_text_22"))
	end
end
function IceDragonLostMainPanel:onPreViewClick()
	SoraDPlaySound()
	uiManager:show("IceDragonLostReward")
end
function IceDragonLostMainPanel:onCallClick()
	SoraDPlaySound()
	local itemHave = backpackCtrl:getItemCount(self.callItemID)
	if itemHave < self.callNeedNum then
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	else
		iceDragonLostCtrl:reqIceDragonLostSummonBoss()
		self:close()
	end
end
function IceDragonLostMainPanel:onSurveyClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	if self.questInfo and next(self.questInfo) then
		if self.questInfo.isFinish then
			iceDragonLostCtrl:reqIceDragonLostRecieveReward()
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
		local hasFirstJump = SoraDConfigGet("Game:IceDragonLost:first~bool", mildGuideManager:starMildByNewPlayerStringParam(guideId))
		if not hasFirstJump then
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_ICEDRAGONLOST)
			SoraDRemoveAllPanelFromManager()
			_ENV = SoraDRemoveAllPanelFromManager
			SoraDRemoveAllPanelFromManager.byUID = true
			SoraDConfigSet("Game:IceDragonLost:first~bool", true, SoraDRemoveAllPanelFromManager)
		else
			_ENV = true
			iceDragonLostCtrl:reqIceDragonLostSearch(true)
		end
	end
end
function IceDragonLostMainPanel:onRecordClick()
	SoraDPlaySound()
	uiManager:show("IceDragonRecord")
end
function IceDragonLostMainPanel:onReceiveClick()
	SoraDPlaySound()
	iceDragonLostCtrl:reqIceDragonLostRecieveReward()
end
function IceDragonLostMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("icedragon_lost_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return IceDragonLostMainPanel
