local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local newKingRisesCtrl = class("newKingRisesCtrl", gamemodulec)
local newKingRisesltCtrl = gModuleMgr.sharedMgr("newKingRisesltCtrl")
local timerList = gModuleMgr.getObject("timerList")
function newKingRisesCtrl:ctor(properties)
	newKingRisesCtrl.super.ctor(self, properties)
	self.queue, newKingRisesCtrl = newKingRisesCtrl.super.ctor, newKingRisesCtrl.super.ctor
	self:resetData()
end
function newKingRisesCtrl:Logout()
	newKingRisesCtrl.super.Logout(self)
	self:resetData()
end
function newKingRisesCtrl:resetData()
	self.userData, _UPVALUE0_, self.activityData, _UPVALUE0_ = nil, nil, nil, nil
end
local timercallback = function()
end
function newKingRisesCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_REWARD, handler(self, self.getRewardRsp))
end
function newKingRisesCtrl:initRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self.userData = content.userData
	else
	end
end
function newKingRisesCtrl:getTaskSetAwardNumByDay(nDay)
	local num = 0
	local _ENV, subTaskSet
	if self.userData then
		if not self.userData.missionSet then
			_ENV = self.userData.missionSet
		end
		for k, v in pairs(self.userData.missionSet) do
			if v.day == nDay then
				if v.taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
					num = num + 1
				end
				table.insert(subTaskSet, v)
			end
		end
	end
	return num, subTaskSet
end
function newKingRisesCtrl:getCurrentAwardNum()
	local num = 0
	if self.userData then
		if not self.userData.missionSet then
			_ENV = self.userData.missionSet
		end
		for k, v in pairs(self.userData.missionSet) do
			if v.taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
				num = num + 1
			end
		end
	end
	return num
end
function newKingRisesCtrl:getTaskSetAwardNum(taskSetId)
	local num = 0
	local _ENV, subTaskSet
	if self.userData then
		if not self.userData.missionSet then
			_ENV = self.userData.missionSet
		end
		for k, v in pairs(self.userData.missionSet) do
			if v.taskSet == taskSetId then
				if v.taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
					num = num + 1
				end
				table.insert(subTaskSet, v)
			end
		end
	end
	return num, subTaskSet
end
function newKingRisesCtrl:reqEnterData()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_INIT, data)
end
function newKingRisesCtrl:reqAward()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_REWARD, data)
end
function newKingRisesCtrl:reqMissionCommit(taskID)
	local serverproxy, data
	data.taskID = taskID
	serverproxy:Request(gCmd.CMD_NEW_KING_RISES_MODULE, gCmd.REQ_KING_RISES_COMMIT, data)
end
function newKingRisesCtrl:getUserData()
	if self.userData then
		if not self.userData then
			_UPVALUE0_ = self.userData
		end
		return self.userData
	else
		_UPVALUE0_ = self.userData
		return self.userData
	end
end
function newKingRisesCtrl:getRewardNum()
	if self.userData then
		return self.userData.rewardNum or 0
	else
		return 0
	end
end
function newKingRisesCtrl:getUserMissionSet()
	if self.userData then
		if not self.userData.missionSet then
			_UPVALUE0_ = self.userData.missionSet
		end
		return self.userData.missionSet
	else
		_UPVALUE0_ = self.userData.missionSet
		return self.userData.missionSet
	end
end
function newKingRisesCtrl:getUserMissionByDay(nDay)
	local _ENV, ret
	local _ENV, ret1
	local bLock = true
	if self.userData then
		if not self.userData.missionSet then
			_ENV = self.userData.missionSet
		end
		self.userData.missionSet = self.userData.missionSet
		for k, v in pairs(self.userData.missionSet) do
			if v.day == nDay then
				if not ret[v.taskSet] then
					_ENV = ret[v.taskSet]
				end
				ret[v.taskSet] = ret[v.taskSet]
				table.insert(ret[v.taskSet], v)
				if v.lock == false then
					bLock = false
				end
			end
		end
		local index = 1
		for k, v in pairs(ret) do
			local tmpData = clone(v)
			if next(v) then
				table.sort(tmpData, function(p1, p2)
					local status1 = gKingRisesTaskStatus.TASK_STATUS_COMPLETE_DONE
					local status2 = gKingRisesTaskStatus.TASK_STATUS_COMPLETE_DONE
					if p1 then
						status1 = p1.taskstatus
					end
					if p2 then
						status2 = p2.taskstatus
					end
					local _ENV, sortWeight
					sortWeight[tonumber(gKingRisesTaskStatus.TASK_STATUS_COMPLETE)] = 3
					sortWeight[tonumber(gKingRisesTaskStatus.TASK_STATUS_DOING)] = 2
					sortWeight[tonumber(gKingRisesTaskStatus.TASK_STATUS_COMPLETE_DONE)] = 1
					sortWeight[tonumber(gKingRisesTaskStatus.TASK_STATUS_TIME_OUT)] = 2
					if sortWeight[tonumber(status1)] < sortWeight[tonumber(status2)] then
						return false
					elseif sortWeight[tonumber(status1)] == sortWeight[tonumber(status2)] then
						if p1.taskID < p2.taskID then
							return true
						else
							return false
						end
					else
						return true
					end
				end)
			end
			ret1[index] = tmpData
			index = index + 1
		end
	end
	return ret1, bLock
end
function newKingRisesCtrl:getRewardQueue()
	if self.queue then
		local queuetype = self:getQueueKey(gKingRisesActivityStatus.CALCULATE)
		return self.queue[queuetype]
	end
end
function newKingRisesCtrl:getCloseQueue()
	if self.queue then
		local queuetype = self:getQueueKey(gKingRisesActivityStatus.CLOSE)
		return self.queue[queuetype]
	end
end
function newKingRisesCtrl:dealActivityInfo()
	local curtime = serviceFunctions.systemTime()
	if self.activityData then
		if self.activityData.begintime then
			local lefttime = self.activityData.begintime - curtime
			if lefttime < 0 then
				lefttime = 0
			end
			local status = gKingRisesActivityStatus.OPEN
			local queueType = self:getQueueKey(status)
			self:addQueue(queueType, curtime, lefttime, lefttime)
		end
		if self.activityData.rewardtime then
			local lefttime = self.activityData.rewardtime - curtime
			if lefttime < 0 then
				lefttime = 0
			end
			local status = gKingRisesActivityStatus.CALCULATE
			local queueType = self:getQueueKey(status)
			self:addQueue(queueType, curtime, lefttime, lefttime)
		end
		if self.activityData.endtime then
			local lefttime = self.activityData.endtime - curtime
			if lefttime < 0 then
				lefttime = 0
			end
			local status = gKingRisesActivityStatus.CLOSE
			local queueType = self:getQueueKey(status)
			self:addQueue(queueType, curtime, lefttime, lefttime)
		end
	end
end
function newKingRisesCtrl:getActivityStatus()
	if self.activityData then
		return self.activityData.state
	else
		return gKingRisesActivityStatus.CLOSE
	end
end
function newKingRisesCtrl:showUserData()
end
function newKingRisesCtrl:missionCommitRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.mission then
			self:updateMissionData(content.mission)
		end
		if content.rewardNum and self.userData then
			self.userData.rewardNum = content.rewardNum
		end
		if content.rewardInfo then
			SoraDMailGainItems(content.rewardInfo, true)
		end
		if content.completeNum and self.userData then
			self.userData.totalCompleteNum = content.completeNum
		end
		_ENV = content.completeNum
		content.completeNum.msg = "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_EVENTS"
		SoraDSendMessage(content.completeNum)
		_ENV = content.completeNum
		content.completeNum.msg = "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_REWARDS"
		SoraDSendMessage(content.completeNum)
		_ENV = content.completeNum
		content.completeNum.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(content.completeNum)
	else
	end
end
function newKingRisesCtrl:getReceiveStatusAndNum()
	local bAward = false
	local num = 0
	if self.userData then
		for k, v in pairs(self.userData.missionSet) do
			if v.taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
				num = num + 1
				bAward = true
			end
		end
	end
	local curtime = serviceFunctions.systemTime()
	if self.activityData and curtime >= self.activityData.rewardtime and curtime <= self.activityData.endtime and self.userData and 0 < self.userData.rewardNum then
		num = num + self.userData.rewardNum
		bAward = true
	end
	return bAward, num
end
function newKingRisesCtrl:getTotalCompleteNum()
	if self.userData then
		return self.userData.totalCompleteNum or 0
	else
		return 0
	end
end
function newKingRisesCtrl:getExchangeNum(index)
	if self.userData and self.userData.exchangeData then
		return self.userData.exchangeData[tostring(index)] or 0
	else
		return 0
	end
end
function newKingRisesCtrl:getRewardRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.rewardNum and self.userData then
			self.userData.rewardNum = 0
		end
		if content.rewardInfo then
			SoraDMailGainItems(content.rewardInfo, true)
		end
		_ENV = content.rewardInfo
		content.rewardInfo.msg = "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_REWARDS"
		SoraDSendMessage(content.rewardInfo)
		_ENV = content.rewardInfo
		content.rewardInfo.msg = "MESSAGE_SERVER_NEW_KING_RISE_GET_REWARD_SUCCESS"
		content.rewardInfo.err = err
		SoraDSendMessage(content.rewardInfo)
		_ENV = content.rewardInfo
		content.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rewardInfo.eventID = gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY
		SoraDSendMessage(content.rewardInfo)
		_ENV = content.rewardInfo
		content.rewardInfo.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(content.rewardInfo)
	else
		_ENV = content.rewardInfo
		content.rewardInfo.msg = "MESSAGE_SERVER_NEW_KING_RISE_GET_REWARD_SUCCESS"
		content.rewardInfo.err = err
		SoraDSendMessage(content.rewardInfo)
	end
end
function newKingRisesCtrl:initClientData(retdata)
	dump(retdata, "newKingRisesCtrl:initClientData()", 10)
	if not retdata then
		retdata, _ENV = dump, dump
	end
	self.activityData = retdata.activityData
	self:dealActivityInfo()
	self.userData = retdata.userData
	self:registerNotify()
end
function newKingRisesCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_KING_RISES, handler(self, self.notifyUpdate))
end
function newKingRisesCtrl:updateMissionData(missioncell)
	local bRefreshCenter = false
	if self.userData then
		if not self.userData.missionSet then
			local _ENV, missionSet = self.userData.missionSet, self.userData.missionSet
		end
		for k, v in pairs(missionSet) do
			if v.taskID == missioncell.taskID then
				if v.taskstatus ~= missioncell.taskstatus and missioncell.taskstatus == gKingRisesTaskStatus.TASK_STATUS_COMPLETE then
					bRefreshCenter = true
				end
				v.taskstatus = missioncell.taskstatus
				v.lock = missioncell.lock
				v.curnum = missioncell.curnum
				v.conditiontype = missioncell.conditiontype
				break
			end
		end
	end
	return bRefreshCenter
end
function newKingRisesCtrl:getQueueKey(status)
	return tostring("QUEUE_KEY_NEW_KING_RISES" .. status)
end
function newKingRisesCtrl:getAwardItemBox()
	return NEW_KING_RISES_AWARD_BOX
end
function newKingRisesCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function newKingRisesCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function newKingRisesCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function newKingRisesCtrl:notifyUpdate(event)
	local notifydata = event.data
	local bUpdateTask = false
	local bUpdateStatus = false
	local bRefreshCenter = false
	dump(notifydata, "notifyUpdate(event)@@@", 10)
	for k, data in pairs(notifydata) do
		if data.updateMission then
			bUpdateTask = true
			for k1, v1 in pairs(data.updateMission) do
				if self:updateMissionData(v1) then
					bRefreshCenter = true
				end
			end
		end
		if data.activityData then
			self.activityData = data.activityData
			self:dealActivityInfo()
			bUpdateStatus = true
		end
		if data.exchangeData then
			self.userData.exchangeData = data.exchangeData
		end
	end
	if bRefreshCenter then
		_ENV = pairs(notifydata)
		pairs(notifydata).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(pairs(notifydata))
	end
	if bUpdateTask then
		_ENV = pairs(notifydata)
		pairs(notifydata).msg = "MESSAGE_SERVER_NEW_KING_RISE_UPDATE_EVENTS"
		SoraDSendMessage(pairs(notifydata))
	end
	if bUpdateStatus then
		_ENV = pairs(notifydata)
		pairs(notifydata).msg = "MESSAGE_SERVER_NEW_KING_RISE_ACTIVITY_CHANGE"
		SoraDSendMessage(pairs(notifydata))
	end
end
return newKingRisesCtrl
