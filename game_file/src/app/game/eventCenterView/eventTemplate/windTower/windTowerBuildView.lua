local windTowerRead = include("windTowerRead")
local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
local windTowerDef = include("windTowerDef")
local windTowerUtil = include("windTowerUtil")
local eventQuestRead = include("eventQuestRead")
local windTowerBuildView = class("windTowerBuildView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("windTowerBuildView")
end)
local MAX_TASK = windTowerDef.MAX_TASK
local gWindTowerStatus = _G.gWindTowerStatus
function windTowerBuildView:ctor(properties)
	self.awardList, _ENV = nil, nil
	self.activityID = gActivityTimeActivityID.WIND_TOWER_ACTIVITY
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("windActive_text_08"))
	self.btnGetAward = SoraDGetChildByName(self, "Button_GetAward")
	self.btnGetAward:addTouchEventListener(handler(self, self.btnGetAwardClick))
	self.textTaskDes = SoraDGetChildByName(self, "Text_TaskDes")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeItem = SoraDGetChildByName(self, "Node_Item")
	self.nodeNormal = SoraDGetChildByName(self, "Node_normal")
	self.nodeTasking = SoraDGetChildByName(self, "Node_tasking")
	self.nodeTime = SoraDGetChildByName(self, "Node_task_time")
	self.textLeftTime = SoraDGetChildByName(self, "Text_Status")
	self.textLeftTime = SoraDCreateTimerLabel(self, self.textLeftTime)
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.btnCancle = SoraDGetChildByName(self, "Button_Cancle")
	self.btnCancle:addTouchEventListener(handler(self, self.btnCancleClick))
	self.btnSurvey = SoraDGetChildByName(self, "Button_spy")
	self.btnSurvey:setTitleText(i18n("lost_ruins_text_24"))
	self.btnSurvey:addTouchEventListener(handler(self, self.btnSurveyClick))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
	self.textLeftTask = SoraDGetChildByName(self, "Text_LeftTask")
	self.textDescribe = SoraDGetChildByName(self, "Text_Describe")
	self.textDescribe:setString(i18n("windActive_text_11"))
	self.txtSpyInfo = SoraDGetChildByName(self, "Text_spy_info")
	self.textTaskDes = SoraDGetChildByName(self, "Text_TaskDes")
	_G.SoraDChangeTextToHtml(self.textTaskDes)
	self.nodeSpine = SoraDGetChildByName(self, "Node_spine")
	self:initSpineEffect()
	local loop = true
	local cssFileName = "windTowerBuildView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function windTowerBuildView:initSpineEffect()
	local spine_npc = _G.sp.SkeletonAnimation:create("spine/bufengtaxingdong.skel", "spine/bufengtaxingdong.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setPosition(cc.p(-170, -300))
	spine_npc:addTo(self.nodeSpine)
end
function windTowerBuildView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WIND_TOWER_REFRESH", handler(self, self.msgCallBack))
end
function windTowerBuildView:initData(instanceID, status)
	self.instanceID = instanceID
	_UPVALUE0_, self.status = nil, status
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
	self:updateData()
end
function windTowerBuildView:updateData()
	if windTowerUtil.isBuildCD(self.tilePoint) then
		self:close(self, ccui.TouchEventType.ended)
	elseif self.status == gWindTowerStatus.SURVEY then
		self:initData_normal()
	else
		self:initData_tasking()
	end
end
function windTowerBuildView:initData_normal()
	self.nodeNormal:setVisible(true)
	self.btnHelp:setVisible(false)
	self.nodeTasking:setVisible(false)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if v.to.objType == gMapObjTypeDef.mapTypeLostRuins and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.btnSurvey:setBright(false)
			self.btnSurvey:setTouchEnabled(false)
			self.btnSurvey:setTitleText(i18n("lost_ruins_text_25"))
		end
	end
	local num = windTowerCtrl:getSurveyNum()
	local limitNum = windTowerDef.MAX_SURVEYNUM
	_ENV = self.btnSurvey
	self.btnSurvey.var1 = num
	self.btnSurvey.var2 = limitNum
	self.txtSpyInfo:setString(i18n("windActive_text_04", self.btnSurvey))
	_ENV = i18n("windActive_text_04", self.btnSurvey)
	i18n("windActive_text_04", self.btnSurvey).num = windTowerCtrl:getFinishNum()
	i18n("windActive_text_04", self.btnSurvey).limitNum = MAX_TASK
	self.textLeftTask:setString(i18n("lost_ruins_text_38", i18n("windActive_text_04", self.btnSurvey)))
end
function windTowerBuildView:initData_tasking()
	self.nodeNormal:setVisible(false)
	self.btnHelp:setVisible(true)
	self.nodeTasking:setVisible(true)
	_ENV = nil
	;(nil).num = windTowerCtrl:getFinishNum()
	;(nil).limitNum = MAX_TASK
	self.textLeftTask:setString(i18n("lost_ruins_text_38", nil))
	self.questInfo = windTowerCtrl:getQuestInfo(self.point)
	dump(self.questInfo, "self.questInfo", 10)
	local status = self.questInfo.status
	local isTwoBtnShow = not self.questInfo.finish
	local taskDes = i18n(eventQuestRead.getDes(self.questInfo.questId))
	if gWindTowerStatus.NOT_RECIEVE ~= status then
		local progress = windTowerCtrl:getQuestProgress(self.questInfo.questId)
		local aim = eventQuestRead.getAim(self.questInfo.questId)
		_ENV = eventQuestRead.getDes(self.questInfo.questId)
		eventQuestRead.getDes(self.questInfo.questId).member = progress
		_ENV, _ENV, eventQuestRead.getDes(self.questInfo.questId).total = eventQuestRead.getDes(self.questInfo.questId)
		eventQuestRead.getDes(self.questInfo.questId).member, eventQuestRead.getDes(self.questInfo.questId).color = eventQuestRead.getDes(self.questInfo.questId)
		local task_progress = _G.i18n_html("common_text_155", eventQuestRead.getDes(self.questInfo.questId))
		taskDes = string.format("%s(%s)", taskDes, task_progress)
	end
	self.textTaskDes:setString(taskDes)
	self:initAwardNode(self.questInfo.questId)
	self.btnGetAward:setVisible(not isTwoBtnShow)
	self.btnSure:setVisible(isTwoBtnShow)
	self.btnCancle:setVisible(isTwoBtnShow)
	self.nodeTime:setVisible(isTwoBtnShow)
	if gWindTowerStatus.NOT_RECIEVE == status then
		self.btnCancle:setTitleText(i18n("common_text_091"))
		self.btnSure:setTitleText(i18n("common_text_3093"))
		self:initActivityTime(false)
	elseif gWindTowerStatus.RECIEVED == status then
		if self.questInfo.finish then
			self.btnGetAward:setTitleText(i18n("common_text_1146"))
		else
			self.btnCancle:setTitleText(i18n("common_text_3626"))
			self.btnSure:setTitleText(i18n("common_text_477"))
			self:initActivityTime(true)
		end
	end
end
function windTowerBuildView:initActivityTime(isRunTime)
	if isRunTime then
		self.textLeftTime:setTimeEndListener(handler(self, function()
			self:close(self, ccui.TouchEventType.ended)
		end))
		self.textLeftTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
		local leftTime = math.max(0, self.questInfo.endtime - serviceFunctions.systemTime())
		self.textLeftTime:beginTime(leftTime)
	else
		local totalTime = windTowerRead.getTaskTimeByQuestId(self.questInfo.questId)
		self.textLeftTime:endTime()
		_ENV = handler(self, function()
			self:close(self, ccui.TouchEventType.ended)
		end)
		handler(self, function()
			self:close(self, ccui.TouchEventType.ended)
		end).time = SoraDConvertSecondToString(totalTime)
		self.textLeftTime:setString(i18n("lost_ruins_text_15", handler(self, function()
			self:close(self, ccui.TouchEventType.ended)
		end)))
	end
end
function windTowerBuildView:initAwardNode(questId)
	local awardConfig = eventQuestRead.getReward(questId)
	for i, v in ipairs(awardConfig) do
		local single
		if not self.awardList[i] then
			single = include("commonItemAward").new()
			single:setScale(0.8)
			single:setBaseScale(1.0)
			single:setOwnView(self)
			single:setPosition(0, 0)
			single:addTo(self.nodeAward)
			self.awardList[i] = single
		else
			single = self.awardList[i]
		end
		single:setVisible(true)
		single:initData(v.id, v.count)
	end
	for i = #awardConfig + 1, #self.awardList do
		self.awardList[i]:setVisible(false)
	end
	SoraDToCenter(self.nodeAward, 95, SoraDFIsRA())
end
function windTowerBuildView:btnGetAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		windTowerCtrl:reqWindTowerReward()
		self:close(self, eventType)
	end
end
function windTowerBuildView:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if gWindTowerStatus.NOT_RECIEVE == self.questInfo.status then
			if windTowerCtrl:getFinishNum() >= MAX_TASK then
				SoraDShowMsgTip(i18n("lost_ruins_text_18"))
			elseif next(windTowerCtrl:getRunningQuestInfo()) then
				SoraDShowMsgTip(i18n("lost_ruins_text_17"))
			else
				windTowerCtrl:reqWindTowerSurvey(self.point)
			end
		elseif gWindTowerStatus.RECIEVED == self.questInfo.status then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				SoraDShowMsgTip(i18n(eventQuestRead.getDes(self.questInfo.questId)))
			end
			if guideId then
				local _, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
				if not notNeedClose then
					self:close(self, eventType)
				end
			end
		end
	end
end
function windTowerBuildView:btnCancleClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if gWindTowerStatus.RECIEVED == self.questInfo.status then
			SoraDShowMsgBox(i18n("windActive_text_14"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if MSGBOX_CALLBACK_YES == type and not tolua.isnull(self) and self.questInfo then
					local data = clone(self.point)
					data.status = self.questInfo.status
					windTowerCtrl:reqWindTowerGiveUp(data)
					self:close(self, eventType)
				end
			end)
		elseif gWindTowerStatus.NOT_RECIEVE == self.questInfo.status then
			SoraDShowMsgBox(i18n("windActive_text_13"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if MSGBOX_CALLBACK_YES == type and not tolua.isnull(self) and self.questInfo then
					local data = clone(self.point)
					data.status = self.questInfo.status
					windTowerCtrl:reqWindTowerGiveUp(data)
					self:close(self, eventType)
				end
			end)
		end
	end
end
function windTowerBuildView:btnSurveyClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		local physical = lordInfoCtrl:getBaseInfo().physical
		if windTowerCtrl:getSurveyNum() < windTowerDef.MAX_SURVEYNUM then
			if SoraDEnoughTroops() then
				_ENV = SoraDEnoughTroops()
				SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing
				SoraDEnoughTroops().toPoint = self.tilePoint
				local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
				worldMapFunction.gotoDispatch(armyData, true)
				self:close(self, eventType)
			end
		elseif physical < windTowerDef.HP_MIN_SURVEY_NEED then
			SoraDShowMsgTip(i18n("lost_ruins_text_13"))
		else
			SoraDShowMsgTip(i18n("lost_ruins_text_05"))
		end
	end
end
function windTowerBuildView:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("windActive_text_11"))
	end
end
function windTowerBuildView:msgCallBack(target, data)
	local questInfo = windTowerCtrl:getQuestInfo(self.point)
	if questInfo then
		self.status = questInfo.status or gWindTowerStatus.SURVEY
	else
		self.status = gWindTowerStatus.SURVEY
	end
	self:updateData()
end
function windTowerBuildView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function windTowerBuildView:getTilePoint()
	return self.tilePoint
end
function windTowerBuildView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return windTowerBuildView
