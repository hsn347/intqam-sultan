local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local activity_9001716_Read = include("activity_9001716_Read")
local activity_9001716_Ctrl = class("activity_9001716_Ctrl", gamemodulec)
_ENV = "activity_9001716_Ctrl"
;("activity_9001716_Ctrl").DOING = 1
;("activity_9001716_Ctrl").COMPLETE = 2
activity_9001716_Ctrl.taskStatus, ("activity_9001716_Ctrl").COMPLETE_DONE = "activity_9001716_Ctrl", 3
function activity_9001716_Ctrl:ctor(properties)
	activity_9001716_Ctrl.super.ctor(self, properties)
	self.queue, activity_9001716_Ctrl = activity_9001716_Ctrl.super.ctor, activity_9001716_Ctrl.super.ctor
	self:resetData()
	self.activityID = gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716
end
function activity_9001716_Ctrl:initActivityId(id)
	self.activityID = id
end
function activity_9001716_Ctrl:Logout()
	activity_9001716_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001716_Ctrl:resetData()
	self.finishCol, _UPVALUE0_, self.finishRow, _UPVALUE0_ = nil, nil, nil, nil
	self.userTaskData, _UPVALUE0_, self.rewardData, _UPVALUE0_, self.openCount = nil, nil, nil, nil, 0
	self.beginTime = 0
	self.endTime = 0
	self.classType = 0
	self.loginTime = 0
	self.handle_notify = nil
end
function activity_9001716_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BUBBLE_MAZE_MODULE, gCmd.REQ_BUBBLE_MAZE_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_MAZE_MODULE, gCmd.REQ_BUBBLE_MAZE_GETREWARD, handler(self, self.getRewardRsp))
	self:resetData()
	self:registerNotify()
end
function activity_9001716_Ctrl:initClientData(retdata)
	if retdata then
		self.openCount = retdata.openCount
		self.rewardData = retdata.rewardData
		self.userTaskData = retdata.userTaskData
		self.beginTime = retdata.beginTime
		self.endTime = retdata.endTime
		self.classType = retdata.classType
		self.activityType = retdata.activityType
		self.loginTime = retdata.loginTime
	end
end
function activity_9001716_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BUBBLE_MAZE, handler(self, self.notifyUpdate))
end
function activity_9001716_Ctrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "activity_9001716_Ctrl:notifyUpdate", 10)
	_ENV = event
	event.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	event.eventID = self.activityID
	SoraDSendMessage(event)
	for k, v in ipairs(notifydata) do
		if v.type == "updateMission" then
			local refreshTask = false
			local _ENV, refreshTaskTable
			for k, _v in ipairs(v.data) do
				if self.userTaskData[tostring(_v.taskID)] and self.userTaskData[tostring(_v.taskID)].taskStatus ~= _v.taskStatus then
					refreshTask = true
					refreshTaskTable[tostring(_v.taskID)] = _v
				end
				self.userTaskData[tostring(_v.taskID)] = _v
			end
			if refreshTask then
				_ENV = ipairs(v.data)
				ipairs(v.data).msg = "MESSAGE_ACTIVITY_9001716_UPDATE_TASK"
				ipairs(v.data).taskChange = refreshTaskTable
				SoraDSendMessage(ipairs(v.data))
			end
		elseif v.type == "initData" then
			self.openCount = v.data.openCount
			self.rewardData = v.data.rewardData
			self.userTaskData = v.data.userTaskData
			self.activityType = v.data.activityType
			self.classType = v.data.classType
		end
	end
end
function activity_9001716_Ctrl:getClassType()
	return self.classType or 1
end
function activity_9001716_Ctrl:getActivityType()
	return self.activityType
end
function activity_9001716_Ctrl:getTaskData()
	return self.userTaskData
end
function activity_9001716_Ctrl:getRewardData()
	return self.rewardData
end
function activity_9001716_Ctrl:getTaskDataLength()
	local length = 0
	for k, v in pairs(self.userTaskData) do
		length = length + 1
	end
	return length
end
function activity_9001716_Ctrl:getRowNum()
	return 3
end
function activity_9001716_Ctrl:getTaskDataByID(taskID)
	return self.userTaskData[tostring(taskID)]
end
function activity_9001716_Ctrl:checkCurBoxOpen(boxTag)
	if self.rewardData and self.rewardData[tostring(boxTag)] then
		return true
	end
	return false
end
function activity_9001716_Ctrl:checkAllTaskComplete()
	local tCompleteNum = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE_DONE or v.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE then
			tCompleteNum = tCompleteNum + 1
		end
	end
	local curLength = self:getTaskDataLength()
	if tCompleteNum == curLength then
		return true
	end
	return false
end
function activity_9001716_Ctrl:checkBigAward()
	local tCompleteNum = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus ~= activity_9001716_Ctrl.taskStatus.DOING then
			tCompleteNum = tCompleteNum + 1
		end
	end
	local curLength = self:getTaskDataLength()
	local curRow = self:getRowNum()
	if tCompleteNum == curLength and (not (not self.rewardData or self.rewardData[tostring(curRow * 2 + 1)]) or not self.rewardData) then
		return true
	end
	return false
end
function activity_9001716_Ctrl:getTaskTotalProgress()
	local tCompleteNum = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus ~= activity_9001716_Ctrl.taskStatus.DOING then
			tCompleteNum = tCompleteNum + 1
		end
	end
	return tCompleteNum
end
function activity_9001716_Ctrl:getTaskData(taskID)
	return self.userTaskData[taskID]
end
function activity_9001716_Ctrl:getReceiveStatusAndNum()
	local num = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE then
			num = num + 1
		end
	end
	for i, v in pairs(activity_9001716_Read.getBubbleRewards(self:getClassType())) do
		if self:checkBubbleCanReceive(v.boxIndex) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activity_9001716_Ctrl:checkBubbleCanReceive(boxIndex)
	if self:checkCurBoxOpen(boxIndex) then
		return false
	end
	local requireTaskIndex = activity_9001716_Read.getBubbleTasks(boxIndex)
	local taskDatas = activity_9001716_Read.getTasks(self:getClassType())
	for i, taskIndex in ipairs(requireTaskIndex) do
		local taskData = taskDatas[taskIndex]
		if taskData then
			local taskInfo = self.userTaskData[tostring(taskData.taskType)]
			if taskInfo.taskStatus == activity_9001716_Ctrl.taskStatus.DOING then
				return false
			end
		end
	end
	return true
end
function activity_9001716_Ctrl:reqGetReward(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_BUBBLE_MAZE_MODULE, gCmd.REQ_BUBBLE_MAZE_GETREWARD, data)
end
function activity_9001716_Ctrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_BUBBLE_MAZE_MODULE, gCmd.REQ_BUBBLE_MAZE_COMMIT, data)
end
function activity_9001716_Ctrl:getRewardRsp(content)
	dump(content, "activity_9001716_Ctrl:getRewardRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.rspdata
		if data then
			for k, v in pairs(data.rewardData) do
				self.rewardData[k] = v
				_ENV = nil
				;(nil).msg = "MESSAGE_ACTIVITY_9001716_GET_REWARD"
				;(nil).index = k
				SoraDSendMessage(nil)
			end
			if content.rspdata.reward then
				SoraDMailGainItems(content.rspdata.reward, true)
			end
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ACTIVITY_9001716_GET_REWARD"
		SoraDSendMessage(SoraDSendMessage)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_ACTIVITY_9001716_UPDATE_TASK"
	SoraDSendMessage(SoraDSendMessage)
end
function activity_9001716_Ctrl:missionCommitRsp(content)
	dump(content, "activity_9001716_Ctrl:missionCommitRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local mission = content.rspdata.mission
		if mission then
			self.userTaskData[tostring(mission.taskID)] = mission
		end
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001716_COMMIT_TASK"
		content.rspdata.reward.data = mission
		content.rspdata.reward.index = mission.index
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001716_UPDATE_TASK"
		content.rspdata.reward.data = mission
		content.rspdata.reward.index = mission.index
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
return activity_9001716_Ctrl
