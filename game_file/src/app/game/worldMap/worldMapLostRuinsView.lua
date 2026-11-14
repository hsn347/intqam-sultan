local constantRead = include("constantRead")
local lostRuinsRead = include("lostRuinsRead")
local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
local publicRead = include("publicRead")
local eventQuestRead = include("eventQuestRead")
local worldMapLostRuinsView = class("worldMapLostRuinsView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("worldMapLostRuinsView")
end)
_UPVALUE6_ = "worldMapLostRuinsView"
;("worldMapLostRuinsView")[1] = "lost_ruins_text_06"
;("worldMapLostRuinsView")[2] = "lost_ruins_text_08"
;("worldMapLostRuinsView")[3] = "lost_ruins_text_07"
;("worldMapLostRuinsView")[4] = "lost_ruins_text_10"
;("worldMapLostRuinsView")[5] = "common_text_1892"
local ("worldMapLostRuinsView")[6], taskStateStr = "lost_ruins_text_09", "worldMapLostRuinsView"
local MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
function worldMapLostRuinsView:ctor(properties)
	self.awardList, _ENV = nil, nil
	self.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("lost_ruins_text_11"))
	self.btnGetAward = SoraDGetChildByName(self, "Button_GetAward")
	self.btnGetAward:addTouchEventListener(handler(self, self.btnGetAwardClick))
	self.textTaskDes = SoraDGetChildByName(self, "Text_TaskDes")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeItem = SoraDGetChildByName(self, "Node_Item")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.textLeftTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textLeftTime = SoraDCreateTimerLabel(self, self.textLeftTime)
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.btnCancle = SoraDGetChildByName(self, "Button_Cancle")
	self.btnCancle:addTouchEventListener(handler(self, self.btnCancleClick))
	self.textStatus = SoraDGetChildByName(self, "Text_Status")
	self.textLeftTask = SoraDGetChildByName(self, "Text_LeftTask")
	local loop = true
	local cssFileName = "worldMapLostRuinsView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function worldMapLostRuinsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LOST_RUINS_REFRESH", handler(self, self.msgCallBack))
end
function worldMapLostRuinsView:initData()
	_ENV = nil
	;(nil).num = lostRuinsCtrl:getFinishNum()
	;(nil).limitNum = MAX_TASK
	self.textLeftTask:setString(i18n("lost_ruins_text_38", nil))
	_ENV = self.textLeftTask.setString
	self.textLeftTask.setString.x = self.tilePoint.x + 1
	self.point, self.textLeftTask.setString.y = self.textLeftTask.setString, self.tilePoint.y + 1
	self.questInfo = lostRuinsCtrl:getQuestInfo(self.point)
	local status = self.questInfo.state
	local isTwoBtnShow = gLosRuinsStatus.COMPLETE ~= status
	self.textTaskDes:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)))
	self:initAwardNode(self.questInfo.questId)
	self.btnGetAward:setVisible(not isTwoBtnShow)
	self.textStatus:setVisible(not isTwoBtnShow)
	self.btnSure:setVisible(isTwoBtnShow)
	self.btnCancle:setVisible(isTwoBtnShow)
	self.textStatus:setString(i18n(taskStateStr[status]))
	self.nodeTime:setVisible(isTwoBtnShow)
	if gLosRuinsStatus.NOT_RECIEVE == status then
		self.btnCancle:setTitleText(i18n("common_text_091"))
		self.btnSure:setTitleText(i18n("common_text_3093"))
		self:initActivityTime(false)
	elseif gLosRuinsStatus.RECIEVED == status then
		self.btnCancle:setTitleText(i18n("common_text_3626"))
		self.btnSure:setTitleText(i18n("common_text_477"))
		self:initActivityTime(true)
	elseif gLosRuinsStatus.COMPLETE == status then
		self.btnGetAward:setTitleText(i18n("common_text_1146"))
	end
end
function worldMapLostRuinsView:initActivityTime(isRunTime)
	local totalTime = lostRuinsRead.getTaskTimeByQuestId(self.questInfo.questId)
	if isRunTime then
		self.textLeftTime:setTimeEndListener(handler(self, function()
			self:close(self, ccui.TouchEventType.ended)
		end))
		self.textLeftTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - lostRuinsCtrl:getRunningQuestInfo().startTime))
		self.textLeftTime:beginTime(leftTime)
	else
		self.textLeftTime:endTime()
		lostRuinsRead = lostRuinsCtrl
		lostRuinsCtrl.time = SoraDConvertSecondToString(totalTime)
		self.textLeftTime:setString(i18n("lost_ruins_text_15", lostRuinsCtrl))
	end
	SoraDToCenter(self.nodeTime, 10)
end
function worldMapLostRuinsView:initAwardNode(questId)
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
function worldMapLostRuinsView:btnGetAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		lostRuinsCtrl:reqLostRuinsRecieveReward()
		self:close(self, eventType)
	end
end
function worldMapLostRuinsView:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
			if lostRuinsCtrl:getFinishNum() >= MAX_TASK then
				SoraDShowMsgTip(i18n("lost_ruins_text_18"))
			elseif next(lostRuinsCtrl:getRunningQuestInfo()) then
				SoraDShowMsgTip(i18n("lost_ruins_text_17"))
			else
				lostRuinsCtrl:reqLostRuinsRecieveQuest(self.point)
			end
		elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
			local tbParam = mildGuideManager:splitGuideParam(guideId)
			if tbParam.id == gNewPLayerTaskType.POP_TIP then
				SoraDShowMsgTip(i18n(taskDes))
			end
			if guideId then
				local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
				if not notNeedClose then
					self:close(self, eventType)
				end
			end
		end
	end
end
function worldMapLostRuinsView:btnCancleClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
			SoraDShowMsgBox(i18n("lost_ruins_text_36"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if MSGBOX_CALLBACK_YES == type then
					lostRuinsCtrl:reqLostRuinsGiveUp(self.point)
					self:close(self, eventType)
				end
			end)
		elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
			SoraDShowMsgBox(i18n("lost_ruins_text_19"), i18n("common_text_204"), i18n("common_text_185"), function(type)
				if MSGBOX_CALLBACK_YES == type then
					lostRuinsCtrl:reqLostRuinsGiveUp(self.point)
					self:close(self, eventType)
				end
			end)
		end
	end
end
function worldMapLostRuinsView:msgCallBack(target, data)
	self:initData(self.point)
end
function worldMapLostRuinsView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapLostRuinsView:getTilePoint()
	return self.tilePoint
end
function worldMapLostRuinsView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return worldMapLostRuinsView
