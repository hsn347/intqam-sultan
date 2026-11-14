local lostRuinsRead = include("lostRuinsRead")
local constantRead = include("constantRead")
local eventQuestRead = include("eventQuestRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
local lostRuinsMainView = class("lostRuinsMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lostRuinsMainView")
end)
local MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("LOST_RUINS_SUMMON_ITEM_NUM", 5)
function lostRuinsMainView:ctor(properties)
	self.questInfo, _ENV, self.awardItemList, _ENV, self.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY, gActivityTimeActivityID.LOST_RUINS_ACTIVITY, gActivityTimeActivityID.LOST_RUINS_ACTIVITY, gActivityTimeActivityID.LOST_RUINS_ACTIVITY, gActivityTimeActivityID.LOST_RUINS_ACTIVITY
	self.itemId = 833701
	self.btnGo = SoraDGetChildByName(self, "Button_GetAward")
	self.btnGo:setTitleText(i18n("lost_ruins_text_24"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self.textBtnGo = SoraDGetChildByName(self.btnGo, "Text_btnName")
	self.textBtnGo:setString(i18n("common_text_477"))
	self.nodeTaskTime = SoraDGetChildByName(self.btnGo, "Node_Tasktime")
	self.textTaskLeftTime = SoraDGetChildByName(self.nodeTaskTime, "Text_time")
	self.textTaskLeftTime = SoraDCreateTimerLabel(self, self.textTaskLeftTime)
	self.textLeftTask = SoraDGetChildByName(self, "Text_LeftTask")
	self.nodeSurvey = SoraDGetChildByName(self, "Node_Survey")
	self.textProgress = SoraDGetChildByName(self, "Text_Progress")
	SoraDChangeTextToHtml(self.textProgress)
	self.textDescribe = SoraDGetChildByName(self, "Text_Describe")
	self.textDescribe:setString(i18n("lost_ruins_text_03"))
	self.btnRecords = SoraDGetChildByName(self, "Button_Records")
	self.textSurvey = SoraDGetChildByName(self.btnRecords, "Text_Survey")
	self.textSurvey:setString(i18n("lost_ruins_text_23"))
	self.redPoint = SoraDGetChildByName(self, "Sprite_redPoint")
	self.textRedNum = SoraDGetChildByName(self.redPoint, "Text_redNum")
	self.btnRecords:addTouchEventListener(handler(self, self.btnRecordsClick))
	self.nodeGetAward = SoraDGetChildByName(self, "Node_GetAward")
	self.textTaskDes = SoraDGetChildByName(self.nodeGetAward, "Text_TaskDes")
	self.nodeAward = SoraDGetChildByName(self.nodeGetAward, "Node_Award")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.textTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.nodeItemInfo = SoraDGetChildByName(self, "Node_ItemInfo")
	self.textItemName = SoraDGetChildByName(self.nodeItemInfo, "Text_ItemName")
	self.textItemName:setString(i18n("lost_ruins_text_02"))
	self.textItemCount = SoraDGetChildByName(self.nodeItemInfo, "Text_ItemCount")
	SoraDChangeTextToHtml(self.textItemCount)
	self.btnCall = SoraDGetChildByName(self.nodeItemInfo, "Button_Call")
	self.btnCall:setTitleText(i18n("common_text_2341"))
	self.btnCall:addTouchEventListener(handler(self, self.btnCallClick))
	self.btnBossAward = SoraDGetChildByName(self.nodeItemInfo, "Button_BossAward")
	self.btnBossAward:addTouchEventListener(handler(self, self.btnBossAwardClick))
	self.btnDetail = SoraDGetChildByName(self, "Button_Detail")
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("activity_name_9001301"))
	self:initActivityTime()
	self:initItemInfo()
	self:initData()
	self:updateRedPoint()
	local loop = true
	local cssFileName = "lostRuinsMainView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function lostRuinsMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_LOST_RUINS_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initItemInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function lostRuinsMainView:initData()
	_ENV = nil
	;(nil).num = lostRuinsCtrl:getFinishNum()
	;(nil).limitNum = MAX_TASK
	self.textLeftTask:setString(i18n("lost_ruins_text_38", nil))
	self.questInfo = lostRuinsCtrl:getRunningQuestInfo()
	if next(self.questInfo) then
		self.nodeSurvey:setVisible(false)
		self.nodeGetAward:setVisible(true)
		self.textTaskDes:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)))
		local progress = lostRuinsCtrl:getQuestProgress(self.questInfo.questId)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		_ENV = i18n(eventQuestRead.getDes(self.questInfo.questId))
		i18n(eventQuestRead.getDes(self.questInfo.questId)).member = progress
		_ENV, _ENV, i18n(eventQuestRead.getDes(self.questInfo.questId)).total = i18n(eventQuestRead.getDes(self.questInfo.questId))
		i18n(eventQuestRead.getDes(self.questInfo.questId)).member, i18n(eventQuestRead.getDes(self.questInfo.questId)).color = i18n(eventQuestRead.getDes(self.questInfo.questId))
		self.textProgress:setString(i18n_html("common_text_155", i18n(eventQuestRead.getDes(self.questInfo.questId))))
		self:initAwards(self.questInfo.questId)
		if self.questInfo.isFinish then
			self.textBtnGo:setVisible(false)
			self.nodeTaskTime:setVisible(false)
			self.btnGo:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
			self.btnGo:setTitleText(i18n("common_text_854"))
		else
			self:initTaskTime()
			self.textBtnGo:setVisible(true)
			self.nodeTaskTime:setVisible(true)
			self.btnGo:setTitleText("")
			self.btnGo:loadTextureNormal("btn_yellow_normal_01.png", ccui.TextureResType.plistType)
		end
	else
		self.textBtnGo:setVisible(false)
		self.nodeTaskTime:setVisible(false)
		self.btnGo:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.btnGo:setTitleText(i18n("lost_ruins_text_24"))
		self.nodeGetAward:setVisible(false)
		self.nodeSurvey:setVisible(true)
	end
end
function lostRuinsMainView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTime, 10)
end
function lostRuinsMainView:initTaskTime()
	local totalTime = lostRuinsRead.getTaskTimeByQuestId(self.questInfo.questId)
	self.textTaskLeftTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - lostRuinsCtrl:getRunningQuestInfo().startTime))
	self.textTaskLeftTime:beginTime(leftTime)
	SoraDToCenter(self.nodeTaskTime, 10)
end
function lostRuinsMainView:initAwards(questId)
	local awardConfig = eventQuestRead.getReward(questId)
	for i, v in ipairs(awardConfig) do
		local single
		if not self.awardItemList[i] then
			single = include("commonItemAward").new()
			single:setScale(0.8)
			single:setBaseScale(1.0)
			single:setOwnView(self)
			single:setPosition(0, 0)
			single:addTo(self.nodeAward)
			self.awardItemList[i] = single
		else
			single = self.awardItemList[i]
		end
		single:setVisible(true)
		single:initData(v.id, v.count)
	end
	for i = #awardConfig + 1, #self.awardItemList do
		self.awardItemList[i]:setVisible(false)
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
end
function lostRuinsMainView:initItemInfo()
	local itemHave = backpackCtrl:getItemCount(self.itemId)
	local color = itemHave >= NEED_NUM and "#40E824" or "#FE0101"
	backpackCtrl = nil
	;(nil).member = itemHave
	backpackCtrl, backpackCtrl, (nil).total = nil, NEED_NUM, NEED_NUM
	NEED_NUM.member, (nil).color = nil, color
	self.textItemCount:setString(i18n_html("common_text_155", nil, NEED_NUM))
	SoraDToCenter(self.nodeItemInfo, 10, not SoraDFIsRA())
end
function lostRuinsMainView:updateRedPoint()
	local num = lostRuinsCtrl:getNewSurveyNum()
	self.redPoint:setVisible(0 < num)
	self.textRedNum:setString(num)
end
function lostRuinsMainView:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if next(self.questInfo) then
			if self.questInfo.isFinish then
				lostRuinsCtrl:reqLostRuinsRecieveReward()
			else
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
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
		else
			_ENV = mildGuideManager:splitGuideParam(guideId)
			mildGuideManager:splitGuideParam(guideId).byUID = true
			local hasFirstJump = SoraDConfigGet("Game:lostRuinsMainView:first~bool", (mildGuideManager:splitGuideParam(guideId)))
			if not hasFirstJump then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_LOSTRUINS)
				SoraDRemoveAllPanelFromManager()
				_ENV = SoraDRemoveAllPanelFromManager
				SoraDRemoveAllPanelFromManager.byUID = true
				SoraDConfigSet("Game:lostRuinsMainView:first~bool", true, SoraDRemoveAllPanelFromManager)
			else
				_ENV = "Game:lostRuinsMainView:first~bool"
				lostRuinsCtrl:reqLostRuinsSearch("Game:lostRuinsMainView:first~bool")
			end
		end
	end
end
function lostRuinsMainView:btnRecordsClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("lostRuinsRecordView")
		panel:show()
	end
end
function lostRuinsMainView:btnCallClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if backpackCtrl:getItemCount(self.itemId) < NEED_NUM then
			SoraDShowMsgTip(i18n("lost_ruins_text_04"))
		else
			lostRuinsCtrl:reqLostRuinsSummonBoss()
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function lostRuinsMainView:btnDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("lost_ruins_text_01"))
	end
end
function lostRuinsMainView:btnBossAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("lostRuinsAwardPop")
		panel:initData(gBossType.lostRuinsBoss)
		panel:show()
	end
end
function lostRuinsMainView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return lostRuinsMainView
