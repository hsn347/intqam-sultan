local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001577_Read = include("activity_9001577_Read")
local activity_9001577_Ctrl = class("activity_9001577_Ctrl", gamemodulec)
function activity_9001577_Ctrl:ctor(properties)
	activity_9001577_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577
	self:resetData()
end
function activity_9001577_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_STAGE_RANK, handler(self, self.reqStageRankRsp))
	msgCtrl.register(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_TOTAL_RANK, handler(self, self.reqTotalRankRsp))
	msgCtrl.register(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_HISTORY_RANK, handler(self, self.reqHistoryRankRsp))
	self:registerNotify()
end
function activity_9001577_Ctrl:reqInitIfOpen()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(self.activityID) ~= gActivityState.CLOSE then
		self:sendReqInit()
	else
		print("activity_9001577_Ctrl:reqInitIfOpen is close, do not reqInit")
	end
end
function activity_9001577_Ctrl:initClientData(data)
	dump(data, "activity_9001577_Ctrl:initClientData", 10)
	self:resetData()
	self:reqInitIfOpen()
	if not data then
		return
	end
end
function activity_9001577_Ctrl:Logout()
	activity_9001577_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001577_Ctrl:resetData()
	self.nebulaKingData, _UPVALUE0_ = nil, nil
	self.nebulaKingData.openCount = 0
	self.nebulaKingData.rank = 0
	self.nebulaKingData.score = 0
	self.nebulaKingData.record, _UPVALUE0_ = nil, nil
	self.myTotalRankInfo, _UPVALUE0_, self.totalRank, _UPVALUE0_, self.myStageRankInfo, _UPVALUE0_, self.stageRank, _UPVALUE0_, self.nebulaKingData.record, _UPVALUE0_ = self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData
end
function activity_9001577_Ctrl:onActivityOpen()
	self:sendReqInit()
end
function activity_9001577_Ctrl:onActivityClose()
	self:resetData()
end
function activity_9001577_Ctrl:onActivityPrepare()
	self:sendReqInit()
end
function activity_9001577_Ctrl:getReceiveStatusAndNum()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(self.activityID) == gActivityState.CLOSE then
		return false, -1
	end
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	local openCount = self.nebulaKingData.openCount
	local state = activityData.state
	local doStage = activityData.doStage
	_ENV = nil
	;(nil).byUID = true
	local saveData = SoraDConfigGet("Game:activity_9001577_Ctrl:reddot~table", nil)
	if not saveData then
		_ENV = "Game:activity_9001577_Ctrl:reddot~table"
		;("Game:activity_9001577_Ctrl:reddot~table").openCount = 0
		;("Game:activity_9001577_Ctrl:reddot~table").state = 0
		saveData, ("Game:activity_9001577_Ctrl:reddot~table").doStage = "Game:activity_9001577_Ctrl:reddot~table", 0
	end
	print("activity_9001577_Ctrl:getReceiveStatusAndNum", saveData.openCount, saveData.state, saveData.doStage)
	local show = openCount > saveData.openCount or state > saveData.state or doStage > saveData.doStage
	return show, -1
end
function activity_9001577_Ctrl:markOpened()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(self.activityID) == gActivityState.CLOSE then
		return
	end
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	local openCount = self.nebulaKingData.openCount
	local state = activityData.state
	local doStage = activityData.doStage
	_ENV = nil
	;(nil).openCount = openCount
	;(nil).state = state
	;(nil).doStage = doStage
	SoraDConfigSet("Game:activity_9001577_Ctrl:reddot~table", nil)
end
function activity_9001577_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FESTIVAL_ACTIVITY_9001577, handler(self, self.notifyHandler))
end
function activity_9001577_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001577_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.nebulaKingData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_KING_INIT"
		SoraDSendMessage(nil)
	end
end
function activity_9001577_Ctrl:sendReqInit()
	print("activity_9001577_Ctrl:sendReqInit")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_INIT, nil)
end
function activity_9001577_Ctrl:sendReqStageRank(stage)
	stage = stage or self:getCurrentStage()
	print("activity_9001577_Ctrl:sendReqStageRank", stage)
	_ENV = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_STAGE_RANK, nil)
end
function activity_9001577_Ctrl:sendReqTotalRank()
	print("activity_9001577_Ctrl:sendReqTotalRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_TOTAL_RANK, nil)
end
function activity_9001577_Ctrl:sendReqHistoryRank()
	print("activity_9001577_Ctrl:sendReqHistoryRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_ICE_COMPETITION_HISTORY_RANK, nil)
end
function activity_9001577_Ctrl:sendReqCampScoreData()
	print("activity_9001577_Ctrl:sendReqCampScoreData")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_ICE_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_CAMP_SCORE_DATA, nil)
end
function activity_9001577_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001577_Ctrl:reqInitRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("activity_9001577_Ctrl:reqInitRsp", content.err)
		return
	end
	self.nebulaKingData = content.rspdata.initData
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_INIT"
	SoraDSendMessage(self)
end
function activity_9001577_Ctrl:reqStageRankRsp(content)
	dump(content, "activity_9001577_Ctrl:reqStageRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("activity_9001577_Ctrl:reqStageRankRsp", content.err)
		return
	end
	local stage = content.data.stage
	self.stageRank[stage] = content.rspdata.rankInfo
	for i = 1, 6 do
		self.myStageRankInfo[i] = content.rspdata["selfInfo" .. i]
	end
	local curStage = self:getCurrentStage()
	print("===", curStage, stage, content.rspdata["selfInfo" .. stage].rank)
	if stage == curStage and content.rspdata["selfInfo" .. stage] then
		self.nebulaKingData.rank = content.rspdata["selfInfo" .. stage].rank
	end
	_ENV = content.rspdata["selfInfo" .. stage].rank
	content.rspdata["selfInfo" .. stage].rank.msg = "MESSAGE_NEBULA_KING_STAGE_RANK"
	content.rspdata["selfInfo" .. stage].rank.stage = stage
	SoraDSendMessage(content.rspdata["selfInfo" .. stage].rank)
end
function activity_9001577_Ctrl:reqTotalRankRsp(content)
	dump(content, "activity_9001577_Ctrl:reqTotalRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("activity_9001577_Ctrl:reqTotalRankRsp", content.err)
		return
	end
	self.totalRank = content.rspdata.rankInfo
	self.myTotalRankInfo = content.rspdata.selfInfo
	local curStage = self:getCurrentStage()
	if curStage == self:getMaxStage() and content.rspdata.selfInfo then
		self.nebulaKingData.totalRank = content.rspdata.selfInfo.rank
	end
	_ENV = content.rspdata.selfInfo.rank
	content.rspdata.selfInfo.rank.msg = "MESSAGE_NEBULA_KING_TOTAL_RANK"
	SoraDSendMessage(content.rspdata.selfInfo.rank)
end
function activity_9001577_Ctrl:reqHistoryRankRsp(content)
	dump(content, "activity_9001577_Ctrl:reqHistoryRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("activity_9001577_Ctrl:reqHistoryRankRsp", content.err)
		return
	end
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_HISTORY_RANK"
	self.historyRankInfo = content.rspdata.historyRankInfo
	SoraDSendMessage(self)
end
function activity_9001577_Ctrl:reqCampScoreDataRsp(content)
	dump(content, "activity_9001577_Ctrl:reqCampScoreDataRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("activity_9001577_Ctrl:reqCampScoreDataRsp", content.err)
		return
	end
	self.campData = content.rspdata
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_CAMPSCORE_DATA"
	self.campData = content.rspdata
	SoraDSendMessage(self)
end
function activity_9001577_Ctrl:showError(strMsg, err)
	_ENV = nil
	;(nil).content = strMsg .. err
	uiManager:show("MessageBox", nil)
end
function activity_9001577_Ctrl:getActivityData()
	return SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
end
function activity_9001577_Ctrl:getGroupId()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function activity_9001577_Ctrl:getCurrentStage()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	if activityData and activityData.doStage and activityData.stagetimes then
		local stage = activityData.doStage + 1
		local maxStage = #activityData.stagetimes
		if stage > maxStage then
			stage = maxStage
		end
		return stage
	end
	print("activity_9001577_Ctrl:getCurrentStage", "activityData", activityData, "doStage", activityData.doStage, "stagetimes", activityData.stagetimes)
	return 0
end
function activity_9001577_Ctrl:getMaxStage()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	print("activityID", self.activityID)
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	return activityData and activityData.stagetimes and #activityData.stagetimes or 5
end
function activity_9001577_Ctrl:getStageTime()
	local activityData = self:getActivityData()
	local begintime = activityData.stagetimes[activityData.doStage] or 0
	local endtime = activityData.stagetimes[activityData.doStage + 1] or 0
	return begintime, endtime
end
function activity_9001577_Ctrl:isActivityPrepare()
	return SoraDGetCtrl("activityShowCtrl"):getStateByID(self.activityID) == gActivityState.PREPARE
end
function activity_9001577_Ctrl:isActivityOpen()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage < #activityData.stagetimes
	end
	return false
end
function activity_9001577_Ctrl:isActivityCalc()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage >= #activityData.stagetimes
	end
	return false
end
function activity_9001577_Ctrl:getCurrentStageName()
	local stage = self:getCurrentStage()
	return self:getStageName(stage)
end
function activity_9001577_Ctrl:getStageName(stage)
	local groupId = self:getGroupId()
	return activity_9001577_Read.getStageName(groupId, stage)
end
function activity_9001577_Ctrl:getStageRankReward(stage)
