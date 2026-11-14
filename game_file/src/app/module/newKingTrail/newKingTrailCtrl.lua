local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local newKingTrailRead = include("newKingTrailRead")
local newKingTrailCtrl = class("newKingTrailCtrl", GameModule)
function newKingTrailCtrl:ctor(properties)
	newKingTrailCtrl.super.ctor(self, properties)
end
function newKingTrailCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_TRIAL_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_STAGE_RANK, handler(self, self.sendReqStageRankRsp))
	msgCtrl.register(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_TOTAL_RANK, handler(self, self.sendReqTotalRankRsp))
	self:resetData()
	self:registerNotify()
end
function newKingTrailCtrl:Logout()
	self:resetData()
	newKingTrailCtrl.super.Logout(self)
end
function newKingTrailCtrl:initClientData(content)
	dump(content, "==newKingTrailCtrl:initClientData==", 20)
end
function newKingTrailCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function newKingTrailCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEWKING_TRAIL, handler(self, self.notifyCallback))
end
function newKingTrailCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			dump(content, "==newKingTrailCtrl:notifyCallback==", 20)
			local refreshAll = false
			if content.type == "taskCompete" then
				if not content.data then
					_ENV = content.data
				end
				self.activityData = content.data
			elseif content.type == "stageChg" then
				refreshAll = true
				self.activityData.stageType = content.data and content.data.stageType or self.activityData.stageType
			end
			_ENV = content.data and content.data.stageType or self.activityData.stageType
			;(content.data and content.data.stageType or self.activityData.stageType).msg = "MESSAGE_NEWKINGTRAIL_REFRESH"
			;(content.data and content.data.stageType or self.activityData.stageType).refreshAll = refreshAll
			SoraDSendMessage(content.data and content.data.stageType or self.activityData.stageType)
		end
	end
end
function newKingTrailCtrl:sendReqInitRsp(content)
	dump(content, "==newKingTrailCtrl:sendReqRefreshRsp==", 20)
	if content.err == gErrDef.Err_None then
		local refreshAll = content.rspdata.stageType ~= self.activityData.stageType
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.activityData = content.rspdata
		self.totalRank = content.totalRank
		self.totalSelfRank = content.totalSelfRank
		_ENV = "==newKingTrailCtrl:sendReqRefreshRsp=="
		;("==newKingTrailCtrl:sendReqRefreshRsp==").msg = "MESSAGE_NEWKINGTRAIL_REFRESH"
		;("==newKingTrailCtrl:sendReqRefreshRsp==").refreshAll = refreshAll
		SoraDSendMessage("==newKingTrailCtrl:sendReqRefreshRsp==")
	end
end
function newKingTrailCtrl:sendReqStageRankRsp(content)
	dump(content, "==newKingTrailCtrl:sendReqStageRankRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.stageRank = content.stageRank
		self.stageSelfRank = content.stageSelfRank
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEWKINGTRAIL_REFRESH"
		gErrDef.Err_None.refreshAll = false
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function newKingTrailCtrl:sendReqTotalRankRsp(content)
	dump(content, "==newKingTrailCtrl:sendReqTotalRankRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.totalRank = content.totalRank
		self.totalSelfRank = content.totalSelfRank
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NEWKINGTRAIL_REFRESH"
		gErrDef.Err_None.refreshAll = false
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function newKingTrailCtrl:sendReqInit()
	serverproxy:Request(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_TRIAL_INIT)
end
function newKingTrailCtrl:sendReqStageRank(data)
	serverproxy:Request(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_STAGE_RANK, data)
end
function newKingTrailCtrl:sendReqTotalStageRank()
	serverproxy:Request(gCmd.CMD_NEW_KING_TRIAL_MODULE, gCmd.REQ_NEW_KING_TOTAL_RANK)
end
function newKingTrailCtrl:getSelfRank(type)
	return type == 1 and self.stageSelfRank or self.totalSelfRank
end
function newKingTrailCtrl:getRank(type)
	return type == 1 and self.stageRank or self.totalRank
end
function newKingTrailCtrl:getStagePoint(index)
	local score = self.activityData.stageSet[tostring(index)] and self.activityData.stageSet[tostring(index)].score
	return score or 0
end
function newKingTrailCtrl:getNowStage()
	print("self.activityData.stageType", self.activityData.stageType)
	dump(self.activityData.stageType, "self.activityData.stageType", 10)
	if self.activityData.stageType then
		return self.activityData.stageType
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEWKING_TRAIL)
	local totalTime = eventTime and eventTime.totaltime or 0
	curTime = curTime or serviceFunctions.systemTime()
	local passTime = curTime - eventTime.starttime
	for i = 1, 5 do
		if passTime < newKingTrailRead.getTotalStageTime(i) then
			return i
		end
	end
end
function newKingTrailCtrl:getRankFirstInfo()
	return self.totalRank and self.totalRank[1]
end
return newKingTrailCtrl
