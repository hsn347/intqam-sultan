local baseComponent = require("fgui.base.baseComponent")
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("SNOWWOLF_LOST_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("SNOWWOLF_LOST_SUMMON_ITEM_NUM", 5)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local eventQuestRead = include("eventQuestRead")
local snowWolfLostRead = include("snowWolfLostRead")
local Com_SnowWolfLost_Main = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_SnowWolfLost_Main", Com_SnowWolfLost_Main)
function Com_SnowWolfLost_Main:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.itemId = 843701
	self.fields.txt_reward:addClickListener(function(eventContext)
		SoraDPlaySound()
		uiManager:show("SnowWolfLostReward")
	end)
	self.fields.txt_investigation:addClickListener(function(eventContext)
		SoraDPlaySound()
		uiManager:show("SnowWolfRecord")
	end)
	self.fields.btn_help:addClickEventListener(handler(self, self.onClickHelp))
	self.fields.btn_call:setTitle(i18n("common_text_2341"))
	self.fields.btn_go:setTitle(i18n("lost_ruins_text_24"))
	self.fields.btn_call:addClickEventListener(handler(self, self.onClickCall))
	self.fields.btn_go:addClickEventListener(handler(self, self.onClickGo))
	self.fields.btn_get:addClickEventListener(handler(self, self.onClickGet))
end
function Com_SnowWolfLost_Main:onShow()
end
function Com_SnowWolfLost_Main:initView()
	self.fields.btn_get:setTitle(i18n("common_text_1146"))
	self.txt_task_time = SoraDCreateTimerLabel(self, self.fields.txt_task_time)
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return i18n_html("common_text_2669") .. " " .. strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	self.fields.txt_desc:setString(i18n("snowWolfLost_002"))
	self.fields.txt_reward:setString(i18n("decrypt_text_03"))
	self.fields.txt_investigation:setString(i18n("lost_ruins_text_23"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self:updateView()
end
function Com_SnowWolfLost_Main:updateView()
	self.questInfo = snowWolfLostCtrl:getRunningQuestInfo()
	local isInQuest = next(self.questInfo) ~= nil
	self.controllers.c2:setSelectedIndex(isInQuest and 1 or 0)
	if isInQuest then
		self:updateTask()
		self.fields.btn_go:setTitle(i18n("common_text_477"))
	else
		self.fields.btn_go:setTitle(i18n("lost_ruins_text_24"))
		self.txt_task_time:endTime()
		self.fields.btn_go:setVisible(true)
	end
	snowWolfLostCtrl = i18n("lost_ruins_text_24")
	i18n("lost_ruins_text_24").num = snowWolfLostCtrl:getFinishNum()
	i18n("lost_ruins_text_24").limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", i18n("lost_ruins_text_24")))
	local itemHave = backpackCtrl:getItemCount(self.itemId)
	local color = itemHave >= NEED_NUM and "#000000" or "#FE0101"
	snowWolfLostCtrl = i18n("lost_ruins_text_38", i18n("lost_ruins_text_24"))
	i18n("lost_ruins_text_38", i18n("lost_ruins_text_24")).num1 = itemHave
	snowWolfLostCtrl, snowWolfLostCtrl, i18n("lost_ruins_text_38", i18n("lost_ruins_text_24")).num2 = i18n("lost_ruins_text_38", i18n("lost_ruins_text_24"))
	NEED_NUM.num1, i18n("lost_ruins_text_38", i18n("lost_ruins_text_24")).color = i18n("lost_ruins_text_38", i18n("lost_ruins_text_24"))
	self.fields.txt_item_num:setString(i18n_html("snowWolfLost_014", i18n("lost_ruins_text_38", i18n("lost_ruins_text_24"))))
end
function Com_SnowWolfLost_Main:updateTask()
	local status = self.questInfo.state
	self:initActivityTime(not self.questInfo.isFinish)
	local aim = eventQuestRead.getAim(self.questInfo.questId)
	local progress = snowWolfLostCtrl:getQuestProgress(self.questInfo.questId)
	eventQuestRead = "(%{num}/%{num2})"
	;("(%{num}/%{num2})").num = progress
	eventQuestRead, eventQuestRead, ("(%{num}/%{num2})").num2 = eventQuestRead.getDes(self.questInfo.questId)
	eventQuestRead.getDes(self.questInfo.questId).num, eventQuestRead.getDes(self.questInfo.questId).color = eventQuestRead.getDes(self.questInfo.questId)
	local realTxt = i18n_html(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. "(%{num}/%{num2})", "(%{num}/%{num2})", eventQuestRead.getDes(self.questInfo.questId))
	self.fields.txt_task_desc:setString(realTxt)
	local awardConfig = eventQuestRead.getReward(self.questInfo.questId)
	self.awardConfig = awardConfig
	self.fields.scroll:setNumItems(#awardConfig)
	self.fields.btn_go:setVisible(not self.questInfo.isFinish)
	self.fields.btn_get:setVisible(self.questInfo.isFinish)
end
function Com_SnowWolfLost_Main:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getTaskTimeByQuestId(self.questInfo.questId)
	if isRunTime then
		self.txt_task_time:setTimeEndListener(handler(self, function()
			self:updateView()
		end))
		self.txt_task_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("lost_ruins_text_15", nil)
		end)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - snowWolfLostCtrl:getRunningQuestInfo().startTime))
		self.txt_task_time:beginTime(leftTime)
	else
		self.txt_task_time:endTime()
		self.txt_task_time:setString(i18n("lost_ruins_text_22"))
	end
end
function Com_SnowWolfLost_Main:onClickCall()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemId) < NEED_NUM then
		SoraDShowMsgTip(i18n("lost_ruins_text_04"))
	else
		snowWolfLostCtrl:reqSnowWolfLostSummonBoss()
		uiManager:close("SnowWolfLost")
	end
end
function Com_SnowWolfLost_Main:onClickGo()
	SoraDPlaySound()
	if next(self.questInfo) then
		if self.questInfo.isFinish then
			snowWolfLostCtrl:reqSnowWolfLostRecieveReward()
		else
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
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
		_ENV = mildGuideManager:splitGuideParam(guideId)
		mildGuideManager:splitGuideParam(guideId).byUID = true
		local hasFirstJump = SoraDConfigGet("Game:Com_SnowWolfLost:first~bool", (mildGuideManager:splitGuideParam(guideId)))
		if not hasFirstJump then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_SNOWWOLFLOST)
			SoraDRemoveAllPanelFromManager()
			_ENV = SoraDRemoveAllPanelFromManager
			SoraDRemoveAllPanelFromManager.byUID = true
			SoraDConfigSet("Game:Com_SnowWolfLost:first~bool", true, SoraDRemoveAllPanelFromManager)
		else
			_ENV = "Game:Com_SnowWolfLost:first~bool"
			snowWolfLostCtrl:reqSnowWolfLostSearch("Game:Com_SnowWolfLost:first~bool")
		end
	end
end
function Com_SnowWolfLost_Main:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("snowWolfLost_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Com_SnowWolfLost_Main:onClickGet()
	SoraDPlaySound()
	snowWolfLostCtrl:reqSnowWolfLostRecieveReward()
end
function Com_SnowWolfLost_Main:onItemRenderer(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
return Com_SnowWolfLost_Main
