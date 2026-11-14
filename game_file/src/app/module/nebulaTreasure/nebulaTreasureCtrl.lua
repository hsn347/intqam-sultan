local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local nebulaTreasureCtrl = class("nebulaTreasureCtrl", GameModule)
local nebulaMileStoneRead = include("nebulaMileStoneRead")
_ENV = "nebulaMileStoneRead"
;("nebulaMileStoneRead").FINISH = 1
;("nebulaMileStoneRead").UNCOMPLETE = 2
local ("nebulaMileStoneRead").RECEIVE, TaskStatus = 3, "nebulaMileStoneRead"
function nebulaTreasureCtrl:ctor(properties)
	nebulaTreasureCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY
	local constantRead = include("constantRead")
	self.refresMaxCount = constantRead.getConstValue("STAR_TREASURE_REFRESH") or 5
	self.questLimitCount = constantRead.getConstValue("STAR_TREASURE_LIMIT") or 5
end
function nebulaTreasureCtrl:EnterGame()
	print("nebulaTreasureCtrl:EnterGame")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA", handler(self, self.activityTaskUpdate))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_REFRESH, handler(self, self.sendRefreshRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_STAGE_REWARD, handler(self, self.sendreceiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_GAME_WIN, handler(self, self.sendGameWinRsp))
	self:resetData()
	self:registerNotify()
end
function nebulaTreasureCtrl:Logout()
	SoraDRemoveMessageByTarget(self)
	nebulaTreasureCtrl.super.Logout(self)
	self:resetData()
end
function nebulaTreasureCtrl:activityInitRsp(target, data)
	if data.activityID == self.activityID then
		self:initClientData(data.initData)
	end
end
function nebulaTreasureCtrl:activityTaskUpdate(target, data)
	if data.activityID == self.activityID and self.msgData then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
		for k, v in pairs(questData.claimedQuest) do
			self.msgData.questData.claimedQuest[k] = v
		end
		for k, v in pairs(questData.finishedQuest) do
			self.msgData.questData.finishedQuest[k] = v
		end
		for k, v in pairs(questData.questProgress) do
			if self.msgData.questData.questProgress[k] then
				self.msgData.questData.questProgress[k] = v
			end
		end
		_ENV = pairs(questData.questProgress)
		pairs(questData.questProgress).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		pairs(questData.questProgress).eventID = gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY
		SoraDSendMessage(pairs(questData.questProgress))
		_ENV = pairs(questData.questProgress)
		pairs(questData.questProgress).msg = "MESSAGE_UPDATE_NEBULA_TREASURE"
		SoraDSendMessage(pairs(questData.questProgress))
	end
end
function nebulaTreasureCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	end
end
function nebulaTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_TREASURE, handler(self, self.notifyHandler))
end
function nebulaTreasureCtrl:notifyHandler(event)
	dump(event.data, "nebulaTreasureCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:initClientData(content)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_TREASURE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function nebulaTreasureCtrl:initClientData(data)
	dump(data, "nebulaTreasureCtrl:initClientData", 10)
	if data then
		local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
		local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
		if questData then
			if not data.questData.claimedQuest then
				_ENV = data.questData.claimedQuest
			end
			questData.claimedQuest = data.questData.claimedQuest
			if not data.questData.finishedQuest then
				_ENV = data.questData.finishedQuest
			end
			questData.finishedQuest = data.questData.finishedQuest
			if not data.questData.questProgress then
				_ENV = data.questData.questProgress
			end
			questData.questProgress = data.questData.questProgress
		end
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY
		SoraDSendMessage(self)
	end
end
function nebulaTreasureCtrl:resetData()
	self.msgData = nil
end
function nebulaTreasureCtrl:setData(data)
	self.msgData = data
end
function nebulaTreasureCtrl:sendInit()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function nebulaTreasureCtrl:sendRefresh()
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_REFRESH)
end
function nebulaTreasureCtrl:sendreceive(stage)
	serverproxy = nil
	;(nil).stage = stage
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_STAGE_REWARD, nil)
end
function nebulaTreasureCtrl:sendGameWin(gameType)
	serverproxy = nil
	;(nil).gameType = gameType
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEBULA_TREASURE_GAME_WIN, nil)
end
function nebulaTreasureCtrl:sendRefreshRsp(content)
	dump(content, "nebulaTreasureCtrl:sendRefreshRsp==", 20)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_TREASURE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function nebulaTreasureCtrl:sendreceiveRsp(content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_TREASURE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function nebulaTreasureCtrl:sendGameWinRsp(content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UPDATE_NEBULA_TREASURE"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
		return
	end
end
function nebulaTreasureCtrl:getCompleteCount()
	if self.msgData then
		return self.msgData.completeCount
	end
	return 0
end
function nebulaTreasureCtrl:getTaskStatus(taskID)
	local status = TaskStatus.UNCOMPLETE
	if self:getIsTaskClaimed(taskID) then
		status = TaskStatus.RECEIVE
	elseif self:getIsTaskFinished(taskID) then
		status = TaskStatus.FINISH
	end
	return status
end
function nebulaTreasureCtrl:getClaimedTasks()
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.questProgress then
		_UPVALUE0_ = self.msgData.questData.questProgress
		return self.msgData.questData.questProgress
	end
	return self.msgData.questData.questProgress
end
function nebulaTreasureCtrl:getTaskProgress(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.questProgress then
		return 0
	end
	local ret = self.msgData.questData.questProgress[tostring(taskID)]
	return ret ~= nil and ret or 0
end
function nebulaTreasureCtrl:getIsTaskClaimed(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.claimedQuest then
		return false
	end
	local ret = self.msgData.questData.claimedQuest[tostring(taskID)]
	return ret ~= nil
end
function nebulaTreasureCtrl:getIsTaskFinished(taskID)
	if not (self.msgData and self.msgData.questData) or not self.msgData.questData.finishedQuest then
		return false
	end
	local ret = self.msgData.questData.finishedQuest[tostring(taskID)]
	return ret ~= nil
end
function nebulaTreasureCtrl:getIsRateGot(stage)
	if not self.msgData then
		return false
	end
	return not not self.msgData.stageReward[tostring(stage)]
end
function nebulaTreasureCtrl:getLastRefreshCount()
	if not self.msgData then
		return 0
	end
	return self.refresMaxCount - self.msgData.refreshCount
end
function nebulaTreasureCtrl:getLastDailyCompleteCount()
	if not self.msgData then
		return 0
	end
	return self.questLimitCount - self.msgData.dailyCompleteCount
end
function nebulaTreasureCtrl:getCompleteDatas()
	if not self.msgData then
		return 0, self.questLimitCount
	end
	return self.msgData.dailyCompleteCount, self.questLimitCount
end
function nebulaTreasureCtrl:getReceiveStatusAndNum(...)
	if not self.msgData or not self.msgData.questData then
		return 0, false
	end
	local num = 0
	local completeCount, limitCount = self:getCompleteDatas()
	if completeCount < limitCount then
		num = num + 1
	end
	local nebulaTreasureRead = include("nebulaTreasureRead")
	local rateCfgs = nebulaTreasureRead.getRateCfg()
	local curRate = self:getCompleteCount()
	for k, v in pairs(rateCfgs) do
		if curRate >= v.rate and not self:getIsRateGot(v.stage) then
			num = num + 1
		end
	end
	return 0 < num, -1, num
end
return nebulaTreasureCtrl
