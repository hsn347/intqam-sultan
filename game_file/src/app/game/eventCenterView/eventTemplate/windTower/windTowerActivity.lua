local gametop = gModuleMgr.getObject("gametop")
local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
local windTowerDef = include("windTowerDef")
local eventQuestRead = include("eventQuestRead")
local windTowerActivity = class("windTowerActivity", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("windTowerActivity")
	end
	return target
end)
function windTowerActivity:ctor()
	self.activityID = gActivityTimeActivityID.WIND_TOWER_ACTIVITY
	self.imgBg = SoraDGetChildByName(self, "Image_Bg")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.txtActivityName = SoraDGetChildByName(self, "Text_activityName")
	self.txtActivityTimeTitle = SoraDGetChildByName(self, "Text_activity_time_title")
	self.textActivityTime = SoraDGetChildByName(self, "Text_activity_time_value")
	self.txtActivityTask = SoraDGetChildByName(self, "Text_activity_task_title")
	self.btnHistory = SoraDGetChildByName(self, "Button_history")
	self.txtHistory = SoraDGetChildByName(self, "Text_history")
	self.txtPutTitle = SoraDGetChildByName(self, "Text_put_title")
	self.textItemCount = SoraDGetChildByName(self, "Text_put_has")
	self.spItem = SoraDGetChildByName(self, "Sprite_item")
	self.btnPut = SoraDGetChildByName(self, "Button_put")
	self.txtNormalInfo = SoraDGetChildByName(self, "Text_normal_info")
	self.btnGo = SoraDGetChildByName(self, "Button_spy")
	self.txtSpyInfo = SoraDGetChildByName(self, "Text_spy_info")
	self.txtTaskName = SoraDGetChildByName(self, "Text_task_name")
	self.textProgress = SoraDGetChildByName(self, "Text_task_progress")
	_G.SoraDChangeTextToHtml(self.textProgress)
	self.nodeNormal = SoraDGetChildByName(self, "Node_normal")
	self.nodeItemInfo = SoraDGetChildByName(self, "Node_item_info")
	self.nodeTask = SoraDGetChildByName(self, "Node_tasking")
	self.nodeAward = SoraDGetChildByName(self, "Node_item")
	self.nodeTime = SoraDGetChildByName(self, "Node_activity_time")
	self.nodeSpine = SoraDGetChildByName(self, "Node_spine")
	self.redIcon = SoraDGetChildByName(self, "red_Icon")
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
	self.btnHistory:addTouchEventListener(handler(self, self.onClickHistory))
	self.btnPut:addTouchEventListener(handler(self, self.onClickPut))
	self.btnGo:addTouchEventListener(handler(self, self.onClickSpy))
	self.nodeTaskTime = SoraDGetChildByName(self, "Node_Tasktime")
	self.nodeTimer = SoraDGetChildByName(self, "Node_timer")
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_ttt0201_002")
	self.textTaskLeftTime = SoraDGetChildByName(self, "Text_time")
	self.textBtnGo = SoraDGetChildByName(self, "Text_btnName")
	self.textBtnGo:setString(i18n("common_text_477"))
	self.textTaskLeftTime = SoraDCreateTimerLabel(self, self.textTaskLeftTime)
	self.txtActivityName:setString(i18n("activity_name_9001333"))
	self.txtActivityTimeTitle:setString(i18n("common_text_2669"))
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	_G.SoraDChangeTextToHtml(self.textItemCount)
	self.textSurvey = SoraDGetChildByName(self, "Text_put")
	self.textSurvey:setString(i18n("common_text_2341"))
	self.txtHistory:setString(i18n("lost_ruins_text_23"))
	self.txtPutTitle:setString(i18n("windActive_text_03"))
	self.txtNormalInfo:setString(i18n("windActive_text_02"))
	self.nodeItemInfo:setPositionX(self.txtPutTitle:getPositionX() - self.txtPutTitle:getContentSize().width * 0.5)
	self:initSpineEffect()
	self.awardItemList, _ENV = self.initSpineEffect, self.initSpineEffect
	self:initData()
	local loop = true
	local cssFileName = "windTowerActivity"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function windTowerActivity:initSpineEffect()
	local spine_npc = _G.sp.SkeletonAnimation:create("spine/bufengtaxingdong.skel", "spine/bufengtaxingdong.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setPosition(cc.p(-170, -300))
	spine_npc:addTo(self.nodeSpine)
end
function windTowerActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WIND_TOWER_REFRESH", handler(self, self.updateData))
end
function windTowerActivity:initData()
	self:initView()
	self:updateData()
end
function windTowerActivity:initView()
	self:initActivityTime()
end
function windTowerActivity:initActivityTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.textActivityTime:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	_ENV = eventTime.timerNode.timer:getRemainTime()
	eventTime.timerNode.timer:getRemainTime()[1] = 10
	SoraDAlignNodeArray(self.nodeTime:getChildren(), true, eventTime.timerNode.timer:getRemainTime())
end
function windTowerActivity:updateData()
	self:resetData()
	self:updateDataTaskNum()
	self:updateDataPutInfo()
	self:updateDataItemInfo()
	self:updateStatus()
end
function windTowerActivity:resetData()
	self.textTaskLeftTime:endTime()
end
function windTowerActivity:updateStatus()
	self:updateDataTaskInfo()
end
function windTowerActivity:updateDataTaskNum()
	local num = windTowerCtrl:getFinishNum()
	local limitNum = windTowerDef.MAX_TASK
	windTowerCtrl = nil
	;(nil).num = num
	;(nil).limitNum = limitNum
	self.txtActivityTask:setString(i18n("lost_ruins_text_38", nil))
end
function windTowerActivity:updateDataPutInfo()
	local num = windTowerCtrl:getSurveyNum()
	local limitNum = windTowerDef.MAX_SURVEYNUM
	windTowerCtrl = nil
	;(nil).var1 = num
	;(nil).var2 = limitNum
	self.txtSpyInfo:setString(i18n("windActive_text_04", nil))
end
function windTowerActivity:updateDataItemInfo()
	local itemHave = windTowerCtrl:getBossPoint()
	local enough = itemHave >= windTowerDef.NEED_NUM
	local color = enough and "#40E824" or "#FE0101"
	windTowerCtrl = nil
	;(nil).member = itemHave
	windTowerCtrl, windTowerCtrl, (nil).total = nil, windTowerDef.NEED_NUM, windTowerDef.NEED_NUM
	windTowerDef.NEED_NUM.member, (nil).color = nil, color
	self.textItemCount:setString(_G.i18n_html("common_text_155", nil, windTowerDef.NEED_NUM))
	SoraDToCenter(self.nodeItemInfo, -5, not SoraDFIsRA())
	self.nodeEffect:setVisible(enough)
	self.redIcon:setVisible(windTowerCtrl:hasNewSurvey())
end
function windTowerActivity:updateDataTaskInfo()
	self.questInfo = windTowerCtrl:getRunningQuestInfo()
	if self.questInfo and next(self.questInfo) then
		self.nodeNormal:setVisible(false)
		self.nodeTask:setVisible(true)
		self.txtTaskName:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)))
		local progress = windTowerCtrl:getQuestProgress(self.questInfo.questId)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		windTowerCtrl = i18n(eventQuestRead.getDes(self.questInfo.questId))
		i18n(eventQuestRead.getDes(self.questInfo.questId)).member = progress
		windTowerCtrl, windTowerCtrl, i18n(eventQuestRead.getDes(self.questInfo.questId)).total = i18n(eventQuestRead.getDes(self.questInfo.questId))
		i18n(eventQuestRead.getDes(self.questInfo.questId)).member, i18n(eventQuestRead.getDes(self.questInfo.questId)).color = i18n(eventQuestRead.getDes(self.questInfo.questId))
		self.textProgress:setString(_G.i18n_html("common_text_155", i18n(eventQuestRead.getDes(self.questInfo.questId))))
		self:initAwards(self.questInfo.questId)
		if self.questInfo.finish then
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
		self.nodeTaskTime:setVisible(false)
		self.btnGo:setTitleText(i18n("lost_ruins_text_24"))
		self.btnGo:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.nodeNormal:setVisible(true)
		self.nodeTask:setVisible(false)
	end
end
function windTowerActivity:initTaskTime()
	self.textTaskLeftTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	local leftTime = math.max(0, self.questInfo.endtime - serviceFunctions.systemTime())
	self.textTaskLeftTime:beginTime(leftTime)
	SoraDToCenter(self.nodeTimer, 10)
end
function windTowerActivity:initAwards(questId)
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
function windTowerActivity:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "windActive_text_01"
		;("windActive_text_01").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("windActive_text_01"), "windActive_text_01")
	end
end
function windTowerActivity:onClickHistory(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("windTowerHistoryView")
		panel:show()
	end
end
function windTowerActivity:onClickPut(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if windTowerCtrl:getBossPoint() < windTowerDef.NEED_NUM then
			SoraDShowMsgTip(i18n("lost_ruins_text_04"))
		else
			windTowerCtrl:reqWindTowerSummonBoss()
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function windTowerActivity:onClickSpy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if next(self.questInfo) then
			if self.questInfo.finish then
				windTowerCtrl:reqWindTowerReward()
			else
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
				local tbParam = mildGuideManager:splitGuideParam(guideId)
				if tbParam.id == gNewPLayerTaskType.POP_TIP then
					local des = eventQuestRead.getDes(self.questInfo.questId)
					SoraDShowMsgTip(i18n(des))
				end
				if guideId then
					local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
					if not notNeedClose then
						SoraDRemoveAllPanelFromManager()
					end
				end
			end
		else
			_ENV = mildGuideManager:splitGuideParam(guideId)
			mildGuideManager:splitGuideParam(guideId).byUID = true
			local hasFirstJump = SoraDConfigGet("Game:windTowerActivity:first~bool", (mildGuideManager:splitGuideParam(guideId)))
			if not hasFirstJump then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD_GUIDE_WINDTOWER)
				SoraDRemoveAllPanelFromManager()
				_ENV = SoraDRemoveAllPanelFromManager
				SoraDRemoveAllPanelFromManager.byUID = true
				SoraDConfigSet("Game:windTowerActivity:first~bool", true, SoraDRemoveAllPanelFromManager)
			else
				_ENV = "Game:windTowerActivity:first~bool"
				windTowerCtrl:reqWindTowerSearch("Game:windTowerActivity:first~bool")
			end
		end
	end
end
function windTowerActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return windTowerActivity
