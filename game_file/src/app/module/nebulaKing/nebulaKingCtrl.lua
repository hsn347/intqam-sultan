local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local nebulaKingRead = include("nebulaKingRead")
local nebulaKingCtrl = class("nebulaKingCtrl", gamemodulec)
function nebulaKingCtrl:ctor(properties)
	nebulaKingCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_KING_ACTIVITY
	self:resetData()
end
function nebulaKingCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_STAGE_RANK, handler(self, self.reqStageRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_TOTAL_RANK, handler(self, self.reqTotalRankRsp))
	msgCtrl.register(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_HISTORY_RANK, handler(self, self.reqHistoryRankRsp))
	self:registerNotify()
end
function nebulaKingCtrl:reqInitIfOpen()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:getStateByID(self.activityID) ~= gActivityState.CLOSE then
		self:sendReqInit()
	else
		print("nebulaKingCtrl:reqInitIfOpen is close, do not reqInit")
	end
end
function nebulaKingCtrl:initClientData(data)
	dump(data, "nebulaKingCtrl:initClientData", 10)
	self:resetData()
	self:reqInitIfOpen()
	if not data then
		return
	end
end
function nebulaKingCtrl:Logout()
	nebulaKingCtrl.super.Logout(self)
	self:resetData()
end
function nebulaKingCtrl:resetData()
	self.nebulaKingData, _UPVALUE0_ = nil, nil
	self.nebulaKingData.openCount = 0
	self.nebulaKingData.rank = 0
	self.nebulaKingData.score = 0
	self.nebulaKingData.record, _UPVALUE0_ = nil, nil
	self.myTotalRankInfo, _UPVALUE0_, self.totalRank, _UPVALUE0_, self.myStageRankInfo, _UPVALUE0_, self.stageRank, _UPVALUE0_, self.nebulaKingData.record, _UPVALUE0_ = self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData, self.nebulaKingData
end
function nebulaKingCtrl:onActivityOpen()
	self:sendReqInit()
end
function nebulaKingCtrl:onActivityClose()
	self:resetData()
end
function nebulaKingCtrl:onActivityPrepare()
	self:sendReqInit()
end
function nebulaKingCtrl:getReceiveStatusAndNum()
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
	local saveData = SoraDConfigGet("Game:nebulaKingCtrl:reddot~table", nil)
	if not saveData then
		_ENV = "Game:nebulaKingCtrl:reddot~table"
		;("Game:nebulaKingCtrl:reddot~table").openCount = 0
		;("Game:nebulaKingCtrl:reddot~table").state = 0
		saveData, ("Game:nebulaKingCtrl:reddot~table").doStage = "Game:nebulaKingCtrl:reddot~table", 0
	end
	print("nebulaKingCtrl:getReceiveStatusAndNum", saveData.openCount, saveData.state, saveData.doStage)
	local show = openCount > saveData.openCount or state > saveData.state or doStage > saveData.doStage
	return show, -1
end
function nebulaKingCtrl:markOpened()
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
	SoraDConfigSet("Game:nebulaKingCtrl:reddot~table", nil)
end
function nebulaKingCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_KING_ACTIVITY, handler(self, self.notifyHandler))
end
function nebulaKingCtrl:notifyHandler(event)
	dump(event.data, "nebulaKingCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.nebulaKingData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_NEBULA_KING_INIT"
		SoraDSendMessage(nil)
	end
end
function nebulaKingCtrl:sendReqInit()
	print("nebulaKingCtrl:sendReqInit")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_INIT, nil)
end
function nebulaKingCtrl:sendReqStageRank(stage)
	stage = stage or self:getCurrentStage()
	print("nebulaKingCtrl:sendReqStageRank", stage)
	_ENV = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_STAGE_RANK, nil)
end
function nebulaKingCtrl:sendReqTotalRank()
	print("nebulaKingCtrl:sendReqTotalRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_TOTAL_RANK, nil)
end
function nebulaKingCtrl:sendReqHistoryRank()
	print("nebulaKingCtrl:sendReqHistoryRank")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_NEBULA_KING_MODULE, gCmd.REQ_NEBULA_KING_HISTORY_RANK, nil)
end
function nebulaKingCtrl:reqInitRsp(content)
	dump(content, "nebulaKingCtrl:reqInitRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaKingCtrl:reqInitRsp", content.err)
		return
	end
	self.nebulaKingData = content.rspdata.initData
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_INIT"
	SoraDSendMessage(self)
end
function nebulaKingCtrl:reqStageRankRsp(content)
	dump(content, "nebulaKingCtrl:reqStageRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaKingCtrl:reqStageRankRsp", content.err)
		return
	end
	local stage = content.data.stage
	self.stageRank[stage] = content.rspdata.rankInfo
	self.myStageRankInfo[stage] = content.rspdata.selfInfo
	local curStage = self:getCurrentStage()
	print("===", curStage, stage, content.rspdata.selfInfo.rank)
	if stage == curStage and content.rspdata.selfInfo then
		self.nebulaKingData.rank = content.rspdata.selfInfo.rank
	end
	_ENV = content.rspdata.selfInfo.rank
	content.rspdata.selfInfo.rank.msg = "MESSAGE_NEBULA_KING_STAGE_RANK"
	content.rspdata.selfInfo.rank.stage = stage
	SoraDSendMessage(content.rspdata.selfInfo.rank)
end
function nebulaKingCtrl:reqTotalRankRsp(content)
	dump(content, "nebulaKingCtrl:reqTotalRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaKingCtrl:reqTotalRankRsp", content.err)
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
function nebulaKingCtrl:reqHistoryRankRsp(content)
	dump(content, "nebulaKingCtrl:reqHistoryRankRsp", 10)
	if content.err ~= gErrDef.Err_None then
		self:showError("nebulaKingCtrl:reqHistoryRankRsp", content.err)
		return
	end
	_ENV = self
	self.msg = "MESSAGE_NEBULA_KING_HISTORY_RANK"
	self.historyRankInfo = content.rspdata.historyRankInfo
	SoraDSendMessage(self)
end
function nebulaKingCtrl:showError(strMsg, err)
	_ENV = nil
	;(nil).content = strMsg .. err
	uiManager:show("MessageBox", nil)
end
function nebulaKingCtrl:getActivityData()
	return SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
end
function nebulaKingCtrl:getGroupId()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function nebulaKingCtrl:getCurrentStage()
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
	print("nebulaKingCtrl:getCurrentStage", "activityData", activityData, "doStage", activityData.doStage, "stagetimes", activityData.stagetimes)
	return 0
end
function nebulaKingCtrl:getMaxStage()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	print("activityID", self.activityID)
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	return activityData and activityData.stagetimes and #activityData.stagetimes or 5
end
function nebulaKingCtrl:getStageTime()
	local activityData = self:getActivityData()
	local begintime = activityData.stagetimes[activityData.doStage] or 0
	local endtime = activityData.stagetimes[activityData.doStage + 1] or 0
	return begintime, endtime
end
function nebulaKingCtrl:isActivityPrepare()
	return SoraDGetCtrl("activityShowCtrl"):getStateByID(self.activityID) == gActivityState.PREPARE
end
function nebulaKingCtrl:isActivityOpen()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage < #activityData.stagetimes
	end
	return false
end
function nebulaKingCtrl:isActivityCalc()
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(self.activityID) then
		local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
		return activityData.doStage >= #activityData.stagetimes
	end
	return false
end
function nebulaKingCtrl:getCurrentStageName()
	local stage = self:getCurrentStage()
	return self:getStageName(stage)
end
function nebulaKingCtrl:getStageName(stage)
	local groupId = self:getGroupId()
	return nebulaKingRead.getStageName(groupId, stage)
end
function nebulaKingCtrl:getStageRankReward(stage)
