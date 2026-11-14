local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local timerList = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local gamemodulec = include("GameModule")
local activityCtrl = class("activityCtrl", gamemodulec)
function activityCtrl:ctor(properties)
	activityCtrl.super.ctor(self, properties)
	self:resetData()
end
function activityCtrl:resetData()
	self.activityList, _ENV, self.isNewServer = nil, nil, false
	self.activityState = gActivityState.CLOSE
	self.curStage = 0
	self.totalStage = 0
	self.historyRank, _ENV, self.stageRank, _ENV, self.queue, _ENV, self.curActivityID = gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, 0
	self.activityScore = 0
	self.curStageRank = 0
	self.totalRank = 0
	self.curStageRankList, _ENV, self.rewardGet, _ENV, self.stageCityLv = gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, gActivityState.CLOSE, 1
	self.serverLv = -1
end
function activityCtrl:EnterGame()
	self:addEventListener(tostring(gActivityState.CLOSE), handler(self, self.activityCloseCallback))
	self:addEventListener(tostring(gActivityState.PREPARE), handler(self, self.activityPrepareCallback))
	self:addEventListener(tostring(gActivityState.OPEN), handler(self, self.activityRunningCallback))
	msgCtrl.register(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_INIT_ACTIVITY_INFO, handler(self, self.initActivityInfoRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_INIT_ACTIVITY_MEMBER_INFO, handler(self, self.initActivityMemberInfoRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_STAGE_RANK_INFO, handler(self, self.initStageRankInfoRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_HISTORY_RANK_INFO, handler(self, self.initHistoryRankInfoRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_CUR_STAGE_RANK_INFO, handler(self, self.initCurStageRankInfoRsp))
end
function activityCtrl:Logout()
	activityCtrl.super.Logout(self)
	self:resetData()
end
function activityCtrl:activityCloseCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_CLOSEFRAME"
	SoraDSendMessage(nil)
	self:reqActivityInfo()
end
function activityCtrl:activityPrepareCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_CLOSEFRAME"
	SoraDSendMessage(nil)
	self:reqActivityInfo()
end
function activityCtrl:activityRunningCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_CLOSEFRAME"
	SoraDSendMessage(nil)
	self:reqActivityInfo()
end
function activityCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self:dispatchEvent(event)
		self.queue[queuetype] = nil
	end
	local _ENV, queue = self, self
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function activityCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function activityCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function activityCtrl:pointRewardIsGet(pointid)
	if not self.rewardGet then
		_ENV = self.rewardGet
	end
	for k, v in pairs(self.rewardGet) do
		if pointid == v then
			return true
		end
	end
end
function activityCtrl:reqActivityInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_INIT_ACTIVITY_INFO, nil, ...)
end
function activityCtrl:reqActivityMemberInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_INIT_ACTIVITY_MEMBER_INFO, nil, ...)
end
function activityCtrl:reqStageRankInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_STAGE_RANK_INFO, nil, ...)
end
function activityCtrl:reqHistoryRankInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_HISTORY_RANK_INFO, nil, ...)
end
function activityCtrl:reqCurStageRankInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ACTIVITY_MODULE, gCmd.REQ_CUR_STAGE_RANK_INFO, nil, ...)
end
function activityCtrl:initActivityInfoRsp(content)
	dump(content, "activityCtrl:initActivityInfoRsp", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self.isNewServer = retdata.isNewServer
		if not retdata.activityList then
			_ENV = retdata.activityList
		end
		self.activityList = retdata.activityList
		self.activityState = retdata.activityState
		self.curActivityID = retdata.curActivityID
		self.curStage = retdata.curStage
		self.totalStage = retdata.totalStage
		self.serverLv = retdata.serverLevel
		local queue = retdata.queue[tostring(self.activityState)]
		if queue then
			local starttime = queue.starttime
			local totaltime = queue.totaltime
			local nowtime = serviceFunctions.systemTime()
			local lasttime = nowtime - starttime
			local lefttime = totaltime - lasttime
			if lefttime <= 0 then
				lefttime = 0
			end
			self:addQueue(tostring(self.activityState), starttime, totaltime, lefttime)
		end
	else
	end
	_ENV = retdata.queue[tostring(self.activityState)]
	retdata.queue[tostring(self.activityState)].msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER"
	SoraDSendMessage(retdata.queue[tostring(self.activityState)])
end
function activityCtrl:initActivityMemberInfoRsp(content)
	dump(content, "activityCtrl:initActivityMemberInfoRsp", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self.activityScore = retdata.activityScore
		self.curStageRank = retdata.curStageRank
		self.totalRank = retdata.totalRank
		self.stageCityLv = retdata.stageCityLv
		self.rewardGet = retdata.rewardGet
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_INITDATA"
		SoraDSendMessage(10)
	else
	end
end
function activityCtrl:initStageRankInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		self.stageRank = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_SECTIONRANK"
		;(nil).redata = self.stageRank
		SoraDSendMessage(nil)
	else
	end
end
function activityCtrl:initHistoryRankInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		self.historyRank = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_TOTALRANK"
		;(nil).redata = self.historyRank
		SoraDSendMessage(nil)
	else
	end
end
function activityCtrl:initCurStageRankInfoRsp(content)
	if content.err == gErrDef.Err_None then
		if not content.data.retdata then
			_ENV = content.data.retdata
		end
		self.curStageRankList = content.data.retdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_STAGERANK"
		gErrDef.Err_None.redata = self.curStageRankList
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LORD_ACTIVITY, handler(self, self.updateActivityData))
end
function activityCtrl:updateActivityData(event)
	if not event.data then
		_ENV = event.data
	end
	for k, v in pairs(event.data) do
		self:resetData()
		self:setActivityData(v)
	end
end
function activityCtrl:setActivityData(data)
	if data then
		self.isNewServer = data.isNewServer
		self.activityState = data.activityState
		self.curActivityID = data.curActivityID
		if not data.activityList then
			_ENV = data.activityList
		end
		self.activityList = data.activityList
		self.curStage = data.curStage
		self.totalStage = data.totalStage
		local queue = data.queue[tostring(self.activityState)]
		if queue then
			local starttime = queue.starttime
			local totaltime = queue.totaltime
			local nowtime = serviceFunctions.systemTime()
			local lasttime = nowtime - starttime
			local lefttime = totaltime - lasttime
			if lefttime <= 0 then
				lefttime = 0
			end
			self:addQueue(tostring(self.activityState), starttime, totaltime, lefttime)
		end
		_ENV = queue.totaltime
		queue.totaltime.msg = "MESSAGE_SERVER_EVENTCENTER_KINGSORDER"
		queue.totaltime.isUpdateAll = true
		SoraDSendMessage(queue.totaltime)
	end
end
function activityCtrl:initClientData(data)
	self:setActivityData(data)
	self:registerNotify()
end
return activityCtrl
