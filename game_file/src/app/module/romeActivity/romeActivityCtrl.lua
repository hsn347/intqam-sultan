local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local timerList = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local gamemodulec = include("GameModule")
local romeActivityCtrl = class("romeActivityCtrl", gamemodulec)
function romeActivityCtrl:ctor(properties)
	romeActivityCtrl.super.ctor(self, properties)
	self:resetData()
end
function romeActivityCtrl:resetData()
	self.queue, _ENV, self.activityState = gRomeActivityState.CLOSE, gRomeActivityState.CLOSE, gRomeActivityState.CLOSE
	self.curStage = 0
	self.historyAllianceRank, _ENV, self.historyMemberRank, _ENV, self.index = gRomeActivityState.CLOSE, gRomeActivityState.CLOSE, gRomeActivityState.CLOSE, gRomeActivityState.CLOSE, 0
	self.state = gAllianceRomeActivityState.NOT_OPEN
	self.score = 0
	self.level = 1
	self.times = 1
	self.reward, _ENV, self.allianceRank = gAllianceRomeActivityState.NOT_OPEN, gAllianceRomeActivityState.NOT_OPEN, 0
	self.memberscore = 0
	self.atkPos, _ENV, self.memberRank = gAllianceRomeActivityState.NOT_OPEN, gAllianceRomeActivityState.NOT_OPEN, 0
	self.serverLv = -1
	self.memFlag = gRomeActivityFlag.NO_JOIN
end
function romeActivityCtrl:EnterGame()
	self:addEventListener(tostring(gRomeActivityState.CLOSE), handler(self, self.activityCloseCallback))
	self:addEventListener(tostring(gRomeActivityState.OPEN), handler(self, self.activityRunningCallback))
	self:addEventListener(ROME_ACTIVITY_ATTACK_KEY, handler(self, self.timesCallBack))
	msgCtrl.register(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_OPEN_ACTIVITY, handler(self, self.openActivityRsp))
	msgCtrl.register(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_MEMBER_RANK_INFO, handler(self, self.initMemberRankInfoRsp))
	msgCtrl.register(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_ALLIANCE_RANK_INFO, handler(self, self.initAllianceRankInfoRsp))
	msgCtrl.register(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_SCORE_AND_RANK, handler(self, self.initMemScoreAndAllScoreRsp))
end
function romeActivityCtrl:Logout()
	romeActivityCtrl.super.Logout(self)
	self:resetData()
end
function romeActivityCtrl:activityCloseCallback(event)
	print("=====romeActivityCtrl:activityCloseCallback=====")
end
function romeActivityCtrl:activityRunningCallback(event)
	print("=====romeActivityCtrl:activityRunningCallback=====")
end
function romeActivityCtrl:timesCallBack(event)
end
function romeActivityCtrl:isShowLevelRewardGeted(difficulte, giftlevel)
	local ret = false
	if (self.state == gAllianceRomeActivityState.RUNNING or self.state == gAllianceRomeActivityState.FINISH) and self.level == difficulte and self.reward[tostring(giftlevel)] then
		ret = true
	end
	return ret
end
function romeActivityCtrl:getAllianceActivityLeftTime()
	local total = (ROME_ACTIVITY_TOTAL_TIMES - self.times - 1) * ROME_ACTIVITY_TIMES_ATKTIME
	return total
end
function romeActivityCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function romeActivityCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function romeActivityCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function romeActivityCtrl:isOpenRomeActivity()
	if self.activityState == gRomeActivityState.OPEN then
		return true
	else
		return false
	end
end
function romeActivityCtrl:isOpenAllianceRomeActivity()
	if self.state == gAllianceRomeActivityState.RUNNING then
		return true
	else
		return false
	end
end
function romeActivityCtrl:isShowAllianceRomeActivity()
	if self:isOpenAllianceRomeActivity() then
		return true
	else
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		if kingdomMapCtrl:hasRomeQueue4SelfAlliance() then
			return true
		end
	end
	return false
end
function romeActivityCtrl:resetAllianceRomeActivityData()
	self.state = gAllianceRomeActivityState.NOT_OPEN
	self.score = 0
	self.level = 1
	self.times = 1
	self.reward, _ENV, self.allianceRank = gAllianceRomeActivityState.NOT_OPEN, gAllianceRomeActivityState.NOT_OPEN, 0
	self.memberscore = 0
	self.atkPos, _ENV, self.memberRank = gAllianceRomeActivityState.NOT_OPEN, gAllianceRomeActivityState.NOT_OPEN, 0
	self:removeQueue(ROME_ACTIVITY_ATTACK_KEY)
	self.memFlag = gRomeActivityFlag.NO_JOIN
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_ALLIANCEATTACK"
	SoraDSendMessage(self)
end
function romeActivityCtrl:setRomeActivityAtkPos(atkPosInfo)
	local uid = gametop.playertop_:getPlayerID()
	local selfInfo = atkPosInfo and atkPosInfo[tostring(uid)]
	if selfInfo then
		self.atkPos = selfInfo
	end
end
function romeActivityCtrl:getRomeActivityAtkPos(waves)
	local ret = self.atkPos[tostring(waves)]
	if ret and type(ret.x) == "number" and type(ret.y) == "number" then
		_ENV = type(ret.y)
		type(ret.y).x = ret.x - 1
		type(ret.y).y = ret.y - 1
		return (type(ret.y))
	else
		_ENV = type(ret.y)
		type(ret.y).x = 0
		type(ret.y).y = 0
		return (type(ret.y))
	end
end
function romeActivityCtrl:setFlag(flag)
	self.memFlag = flag
end
function romeActivityCtrl:getFlag()
	return self.memFlag
end
function romeActivityCtrl:reqOpenActivity(level, ...)
	serverproxy = nil
	;(nil).level = level
	serverproxy:Request(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_OPEN_ACTIVITY, nil, ...)
end
function romeActivityCtrl:reqMemberRankInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_MEMBER_RANK_INFO, nil, ...)
end
function romeActivityCtrl:reqAllianceRankInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_ALLIANCE_RANK_INFO, nil, ...)
end
function romeActivityCtrl:reqMemScoreAndAllScore(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROME_ACTIVITY, gCmd.REQ_INIT_SCORE_AND_RANK, nil, ...)
end
function romeActivityCtrl:openActivityRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		local openlevel = data.level
		local allianceActivityData = data.retdata
		self:initAllianceActivityData(allianceActivityData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_SELECTDIFF"
		SoraDSendMessage(self)
	else
		print("===romeActivityCtrl:openActivityRsp===err", err)
	end
end
function romeActivityCtrl:initMemberRankInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		self.historyMemberRank = content.data.retdata
		dump(self.historyMemberRank, "fdkfjdksjkfjkjk", 10)
		_ENV = self.historyMemberRank
		self.historyMemberRank.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_MEMBERRANK"
		self.historyMemberRank.redata = self.historyMemberRank
		SoraDSendMessage(self.historyMemberRank)
	else
	end
end
function romeActivityCtrl:initAllianceRankInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		self.historyAllianceRank = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_ALLIANCERANK"
		;(nil).redata = self.historyAllianceRank
		SoraDSendMessage(nil)
	else
		print("romeActivityCtrl:initAllianceRankInfoRsp err", err)
	end
end
function romeActivityCtrl:getHistoryMemberRank()
	if self.historyMemberRank then
		return self.historyMemberRank
	end
end
function romeActivityCtrl:getHistoryAllianceRank()
	if self.historyAllianceRank then
		return self.historyAllianceRank
	end
end
function romeActivityCtrl:initMemScoreAndAllScoreRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data.retdata
		if data then
			self.score = data.allianceScore
			self.allianceRank = data.allianceRank
			self.memberscore = data.memberScore
			self.memberRank = data.memberRank
			self.reward = data.reward
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_INFOREQUEST"
		SoraDSendMessage(nil)
	else
		print("romeActivityCtrl:initMemScoreAndAllScoreRsp err", err)
	end
end
function romeActivityCtrl:initAllianceActivityData(allianceActivityData)
	if allianceActivityData then
		self.state = allianceActivityData.state
		self.score = allianceActivityData.score
		self.level = allianceActivityData.level
		self.times = allianceActivityData.times
		self.reward = allianceActivityData.reward
		print("fdfdsjfkdfjdkfj")
		dump(self.reward, "romeActivityCtrl", 10)
		local queue = allianceActivityData.queue.ROME_ACTIVITY_ATTACK_KEY
		if queue then
			local starttime = queue.starttime
			local totaltime = queue.totaltime
			local nowtime = serviceFunctions.systemTime()
			local lasttime = nowtime - starttime
			local lefttime = totaltime - lasttime
			if lefttime <= 0 then
				lefttime = 0
			end
			self:addQueue(ROME_ACTIVITY_ATTACK_KEY, starttime, totaltime, lefttime)
		end
	end
end
function romeActivityCtrl:initTotalRomeActivity(totalRomeActivityData)
	if totalRomeActivityData then
		self.activityState = totalRomeActivityData.activityState
		self.curStage = totalRomeActivityData.curStage
		self.index = totalRomeActivityData.index
		self.serverLv = totalRomeActivityData.serverLevel
		local queue = totalRomeActivityData.queue[tostring(self.activityState)]
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
	end
end
function romeActivityCtrl:initMemFlag(memflaglist)
	if memflaglist then
		local pid = gametop.playertop_:getPlayerID()
		local flag = memflaglist[tostring(pid)]
		if flag then
			self:setFlag(flag)
		end
	end
end
function romeActivityCtrl:initClientData(data)
	dump(data, "fdsfksjkjaskdfdf", 10)
	if nil == data then
		return
	end
	dump(data, "fdjfkdfjdkfd", 10)
	local activitydata = data.activitydata
	self:initTotalRomeActivity(activitydata)
	local alliancedata = data.alliancedata
	self:initAllianceActivityData(alliancedata)
	local atkPosInfo = data.atkPosInfo
	self:setRomeActivityAtkPos(atkPosInfo)
	local memRomeActivityFlag = data.memRomeActivityFlag
	self:initMemFlag(memRomeActivityFlag)
	self:registerNotify()
end
function romeActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ROME_ACTIVITY, handler(self, self.updateRomeActivityData))
end
function romeActivityCtrl:updateRomeActivityData(event)
	local data = event.data
	dump(data, "romeActivityCtrl:updateRomeActivityData", 10)
	for k, v in pairs(data) do
		self:initTotalRomeActivity(v)
	end
	if self.activityState == gRomeActivityState.CLOSE then
		self:resetAllianceRomeActivityData()
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_EVENTREFRESH"
	SoraDSendMessage(self)
end
function romeActivityCtrl:getActNthPhase()
	return self.index
end
return romeActivityCtrl
