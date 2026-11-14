local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaCompetitionRead = include("nebulaCompetitionRead")
local nebulaCompetitionCtrl = class("nebulaCompetitionCtrl", gamemodulec)
function nebulaCompetitionCtrl:ctor(properties)
	nebulaCompetitionCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY
	self:resetData()
end
function nebulaCompetitionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_STAGE_RANK, handler(self, self.reqStageRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_TOTAL_RANK, handler(self, self.reqTotalRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_HISTORY_RANK, handler(self, self.reqHistoryRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_CAMP_SCORE_DATA, handler(self, self.reqCampScoreDataRsp))
	self:registerNotify()
end
function nebulaCompetitionCtrl:reqInitIfOpen()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(self.activityID) ~= gActivityState.CLOSE then
		self:sendReqInit()
	else
		print("nebulaCompetitionCtrl:reqInitIfOpen is close, do not reqInit")
	end
end
function nebulaCompetitionCtrl:initClientData(data)
	dump(data, "nebulaCompetitionCtrl:initClientData", 10)
	self:resetData()
	self:reqInitIfOpen()
	if not data then
		return
	end
end
function nebulaCompetitionCtrl:Logout()
	nebulaCompetitionCtrl.super.Logout(self)
	self:resetData()
end
function nebulaCompetitionCtrl:resetData()
	self.nebulaKingData, _UPVALUE0_ = nil, nil
	self.nebulaKingData.openCount = 0
	self.nebulaKingData.rank = 0
	self.nebulaKingData.score = 0
	self.nebulaKingData.record, _UPVALUE0_ = nil, nil
	self.myTotalRankInfo, _UPVALUE0_, self.totalRank, _UPVALUE0_, self.myStageRankInfo, _UPVALUE0_, self.stageRank, _UPVALUE0_, self.nebulaKingData.record, _UPVALUE0_ = self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData
end
function nebulaCompetitionCtrl:onActivityOpen()
	self:sendReqInit()
end
function nebulaCompetitionCtrl:onActivityClose()
	self:resetData()
end
function nebulaCompetitionCtrl:onActivityPrepare()
	self:sendReqInit()
end
function nebulaCompetitionCtrl:getReceiveStatusAndNum()
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
	local saveData = SoraDConfigGet("Game:nebulaCompetitionCtrl:reddot~table", nil)
	if not saveData then
		_ENV = "Game:nebulaCompetitionCtrl:reddot~table"
		;("Game:nebulaCompetitionCtrl:reddot~table").openCount = 0
		;("Game:nebulaCompetitionCtrl:reddot~table").state = 0
		saveData, ("Game:nebulaCompetitionCtrl:reddot~table").doStage = "Game:nebulaCompetitionCtrl:reddot~table", 0
	end
	print("nebulaCompetitionCtrl:getReceiveStatusAndNum", saveData.openCount, saveData.state, saveData.doStage)
	local show = openCount > saveData.openCount or state > saveData.state or doStage > saveData.doStage
	return show, -1
end
function nebulaCompetitionCtrl:markOpened()
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
	SoraDConfigSet("Game:nebulaCompetitionCtrl:reddot~table", nil)
end
function nebulaCompetitionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_COMPETITION_ACTIVITY, handler(self, self.notifyHandler))
end
function nebulaCompetitionCtrl:notifyHandler(event)
	dump(event.data, "nebulaCompetitionCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.nebulaKingData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_KING_INIT"
		SoraDSendMessage(nil)
	end
end
function nebulaCompetitionCtrl:sendReqInit()
	print("nebulaCompetitionCtrl:sendReqInit")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_INIT, nil)
end
function nebulaCompetitionCtrl:sendReqStageRank(stage)
	stage = stage or self:getCurrentStage()
	print("nebulaCompetitionCtrl:sendReqStageRank", stage)
	_ENV = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_STAGE_RANK, nil)
end
function nebulaCompetitionCtrl:sendReqTotalRank()
	print("nebulaCompetitionCtrl:sendReqTotalRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_TOTAL_RANK, nil)
end
function nebulaCompetitionCtrl:sendReqHistoryRank()
	print("nebulaCompetitionCtrl:sendReqHistoryRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_HISTORY_RANK, nil)
end
function nebulaCompetitionCtrl:sendReqCampScoreData()
	print("nebulaCompetitionCtrl:sendReqCampScoreData")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_COMPETITION_MODULE, gCmd.REQ_NEBULA_COMPETITION_CAMP_SCORE_DATA, nil)
end
function nebulaCompetitionCtrl:reqInitRsp(content)
	dump(content, "nebulaCompetitionCtrl:reqInitRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCompetitionCtrl:reqInitRsp", content.err)
		return
	end
	self.nebulaKingData = content.rspdata.initData
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_INIT"
	SoraDSendMessage(self)
end
function nebulaCompetitionCtrl:reqStageRankRsp(content)
	dump(content, "nebulaCompetitionCtrl:reqStageRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCompetitionCtrl:reqStageRankRsp", content.err)
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
function nebulaCompetitionCtrl:reqTotalRankRsp(content)
	dump(content, "nebulaCompetitionCtrl:reqTotalRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCompetitionCtrl:reqTotalRankRsp", content.err)
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
function nebulaCompetitionCtrl:reqHistoryRankRsp(content)
	dump(content, "nebulaCompetitionCtrl:reqHistoryRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCompetitionCtrl:reqHistoryRankRsp", content.err)
		return
	end
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_HISTORY_RANK"
	self.historyRankInfo = content.rspdata.historyRankInfo
	SoraDSendMessage(self)
end
function nebulaCompetitionCtrl:reqCampScoreDataRsp(content)
	dump(content, "nebulaCompetitionCtrl:reqCampScoreDataRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaCompetitionCtrl:reqCampScoreDataRsp", content.err)
		return
	end
	self.campData = content.rspdata
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_CAMPSCORE_DATA"
	self.campData = content.rspdata
	SoraDSendMessage(self)
end
function nebulaCompetitionCtrl:showError(strMsg, err)
	_ENV = nil
	;(nil).content = strMsg .. err
	uiManager:show("MessageBox", nil)
end
function nebulaCompetitionCtrl:getActivityData()
	return SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
end
function nebulaCompetitionCtrl:getGroupId()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function nebulaCompetitionCtrl:getCurrentStage()
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
	print("nebulaCompetitionCtrl:getCurrentStage", "activityData", activityData, "doStage", activityData.doStage, "stagetimes", activityData.stagetimes)
	return 0
end
function nebulaCompetitionCtrl:getMaxStage()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	print("activityID", self.activityID)
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	return activityData and activityData.stagetimes and #activityData.stagetimes or 5
end
function nebulaCompetitionCtrl:getStageTime()
	local activityData = self:getActivityData()
	local begintime = activityData.stagetimes[activityData.doStage] or 0
	local endtime = activityData.stagetimes[activityData.doStage + 1] or 0
	return begintime, endtime
end
function nebulaCompetitionCtrl:isActivityPrepare()
	return SoraDGetCtrl("activityShowCtrl"):getStateByID(self.activityID) == gActivityState.PREPARE
end
function nebulaCompetitionCtrl:isActivityOpen()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage < #activityData.stagetimes
	end
	return false
end
function nebulaCompetitionCtrl:isActivityCalc()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage >= #activityData.stagetimes
	end
	return false
end
function nebulaCompetitionCtrl:getCurrentStageName()
	local stage = self:getCurrentStage()
	return self:getStageName(stage)
end
function nebulaCompetitionCtrl:getStageName(stage)
	local groupId = self:getGroupId()
	return nebulaCompetitionRead.getStageName(groupId, stage)
end
function nebulaCompetitionCtrl:getStageRankReward(stage)
