local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
local crossDecryptionCtrl = class("crossDecryptionCtrl", gamemodulec)
_ENV = "crossDecryptionCtrl"
;("crossDecryptionCtrl").DOING = 1
;("crossDecryptionCtrl").COMLIETE = 2
local ("crossDecryptionCtrl").COMLIETE_DONE, taskStatus = 3, "crossDecryptionCtrl"
function crossDecryptionCtrl:ctor(properties)
	crossDecryptionCtrl.super.ctor(self, properties)
	self.queue, crossDecryptionCtrl = crossDecryptionCtrl.super.ctor, crossDecryptionCtrl.super.ctor
	self:resetData()
	self.activityID = gActivityTimeActivityID.CROSS_MISSION
end
function crossDecryptionCtrl:initActivityId(id)
	self.activityID = id
end
function crossDecryptionCtrl:Logout()
	crossDecryptionCtrl.super.Logout(self)
	self:resetData()
end
function crossDecryptionCtrl:resetData()
	self.userTaskData, _UPVALUE0_, self.finishCol, _UPVALUE0_, self.finishRow, _UPVALUE0_, self.rewardData, _UPVALUE0_, self.openCount = nil, nil, nil, nil, nil, nil, nil, nil, 0
end
function crossDecryptionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CROSS_MISSION_MODULE, gCmd.REQ_CROSS_MISSION_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_CROSS_MISSION_MODULE, gCmd.REQ_CROSS_MISSION_GETREWARD, handler(self, self.getRewardRsp))
end
function crossDecryptionCtrl:initClientData(retdata)
	if retdata then
		self.openCount = retdata.openCount
		self.rewardData = retdata.rewardData
		self.userTaskData = retdata.userTaskData
		self.activityType = retdata.classType
		self:registerNotify()
	end
end
function crossDecryptionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CROSS_MISSION, handler(self, self.notifyUpdate))
end
function crossDecryptionCtrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "crossDecryptionCtrl:notifyUpdate", 10)
	_ENV = event
	event.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	event.eventID = self.activityID
	SoraDSendMessage(event)
	for k, v in ipairs(notifydata) do
		if v.type == "updateMission" then
			local reflashTask = false
			local _ENV, reflashTaskTable
			for k, _v in ipairs(v.data) do
				if self.userTaskData[tostring(_v.taskID)] and self.userTaskData[tostring(_v.taskID)].taskStatus ~= _v.taskStatus then
					reflashTask = true
					reflashTaskTable[tostring(_v.taskID)] = _v
				end
				self.userTaskData[tostring(_v.taskID)] = _v
			end
			if reflashTask then
				_ENV = ipairs(v.data)
				ipairs(v.data).msg = "MESSAGE_SERVER_CROSS_UPDATE_TASK"
				ipairs(v.data).taskChange = reflashTaskTable
				SoraDSendMessage(ipairs(v.data))
			end
		elseif v.type == "initData" then
			self.openCount = v.data.openCount
			self.rewardData = v.data.rewardData
			self.userTaskData = v.data.userTaskData
			self.activityType = v.data.classType
		end
	end
end
function crossDecryptionCtrl:getActivityType()
	return self.activityType
end
function crossDecryptionCtrl:getTaskData()
	return self.userTaskData
end
function crossDecryptionCtrl:getRewardData()
	return self.rewardData
end
function crossDecryptionCtrl:getTaskDataLength()
	local length = 0
	for k, v in pairs(self.userTaskData) do
		length = length + 1
	end
	return length
end
function crossDecryptionCtrl:getRowNum()
	local length = self:getTaskDataLength()
	return length and math.sqrt(length) or 0
end
function crossDecryptionCtrl:getTaskDataByID(taskID)
	return self.userTaskData[tostring(taskID)]
end
function crossDecryptionCtrl:checkFinishRowAndCol()
	self.finishCol, _ENV, self.finishRow, _ENV = nil, nil, nil, nil
	local row = self:getRowNum()
	for k, v in pairs(self.userTaskData) do
		local curRow = math.floor((v.index - 1) / row) + 1
		local curCol = (v.index - 1) % row + 1
		if not self.finishRow[curRow] then
			self.finishRow[curRow] = 0
		end
		if not self.finishCol[curCol] then
			self.finishCol[curCol] = 0
		end
		if v.taskStatus ~= taskStatus.DOING then
			self.finishRow[curRow] = self.finishRow[curRow] + 1
			self.finishCol[curCol] = self.finishCol[curCol] + 1
		end
	end
	return self.finishRow, self.finishCol
end
function crossDecryptionCtrl:checkReceivedRowAndCol()
	local _ENV, finishRow
	local _ENV, finishCol
	local row = self:getRowNum()
	for k, v in pairs(self.userTaskData) do
		local curRow = math.floor((v.index - 1) / row) + 1
		local curCol = (v.index - 1) % row + 1
		if not finishRow[curRow] then
			finishRow[curRow] = 0
		end
		if not finishCol[curCol] then
			finishCol[curCol] = 0
		end
		if v.taskStatus == taskStatus.COMLIETE_DONE then
			finishRow[curRow] = finishRow[curRow] + 1
			finishCol[curCol] = finishCol[curCol] + 1
		end
	end
	return finishRow, finishCol
end
function crossDecryptionCtrl:getNeedReceiveBox()
	local _ENV, needReceiveBox
	local row = self:getRowNum()
	for k, v in ipairs(self.finishRow) do
		if v >= row and not self.rewardData[tostring(k * 2 - 1)] then
			table.insert(needReceiveBox, k * 2 - 1)
		end
	end
	for k, v in ipairs(self.finishCol) do
		if v >= row and not self.rewardData[tostring(k * 2)] then
			table.insert(needReceiveBox, k * 2)
		end
	end
	return needReceiveBox
end
function crossDecryptionCtrl:checkReceiveBoxNum()
	self:checkFinishRowAndCol()
	local row = self:getRowNum()
	local boxReceiveNum = 0
	for k, v in ipairs(self.finishRow) do
		if v >= row and not self.rewardData[tostring(k * 2 - 1)] then
			boxReceiveNum = boxReceiveNum + 1
		end
	end
	for k, v in ipairs(self.finishCol) do
		if v >= row and not self.rewardData[tostring(k * 2)] then
			boxReceiveNum = boxReceiveNum + 1
		end
	end
	return boxReceiveNum
end
function crossDecryptionCtrl:checkCurBoxStatus(boxTag)
	local canReceived = false
	local row = self:getRowNum()
	if self.finishRow[(boxTag + 1) / 2] and row <= self.finishRow[(boxTag + 1) / 2] and not self.rewardData[tostring(boxTag)] then
		canReceived = true
	end
	if self.finishCol[boxTag / 2] and row <= self.finishCol[boxTag / 2] and not self.rewardData[tostring(boxTag)] then
		canReceived = true
	end
	return canReceived
end
function crossDecryptionCtrl:isHLineReward(line)
	local fnums = 0
	local row = self:getRowNum()
	local begin = row * (line - 1) + 1
	for i = begin, begin + row - 1 do
		for k, v in pairs(self.userTaskData) do
			if v.index == i and v.taskStatus == taskStatus.COMLIETE_DONE then
				fnums = fnums + 1
			end
		end
	end
	return fnums == row
end
function crossDecryptionCtrl:isLLineReward(line)
	local fnums = 0
	local row = self:getRowNum()
	local begin = line
	for i = begin, begin + (row - 1) * row, row do
		for k, v in pairs(self.userTaskData) do
			if v.index == i and v.taskStatus == taskStatus.COMLIETE_DONE then
				fnums = fnums + 1
			end
		end
	end
	return fnums == row
end
function crossDecryptionCtrl:checkCurBoxOpen(boxTag)
	local canReceived = false
	local row = self:getRowNum()
	if self.rewardData and self.rewardData[tostring(boxTag)] then
		return true
	end
	return false
end
function crossDecryptionCtrl:checkAllTaskComplete()
	local tCompleteNum = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus == taskStatus.COMLIETE_DONE then
			tCompleteNum = tCompleteNum + 1
		end
	end
	local curLength = self:getTaskDataLength()
	if tCompleteNum == curLength then
		return true
	end
	return false
end
function crossDecryptionCtrl:checkBigAward()
	local tCompleteNum = 0
	for k, v in pairs(self.userTaskData) do
		if v.taskStatus ~= taskStatus.DOING then
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
function crossDecryptionCtrl:getReceiveStatusAndNum()
	local bAward = false
	local num = 0
	if self.userTaskData then
		for k, v in pairs(self.userTaskData) do
			if v.taskStatus == taskStatus.COMLIETE then
				num = num + 1
			end
		end
	end
	num = num + self:checkReceiveBoxNum()
	if self:checkBigAward() then
		num = num + 1
	end
	if 0 < num then
		bAward = true
	end
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		num = 0
	end
	return bAward, num
end
function crossDecryptionCtrl:reqGetReward(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_CROSS_MISSION_MODULE, gCmd.REQ_CROSS_MISSION_GETREWARD, data)
end
function crossDecryptionCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_CROSS_MISSION_MODULE, gCmd.REQ_CROSS_MISSION_COMMIT, data)
end
function crossDecryptionCtrl:getRewardRsp(content)
	dump(content, "crossDecryptionCtrl:getRewardRsp(content)", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.rspdata
		if data then
			for k, v in pairs(data.rewardData) do
				self.rewardData[k] = v
				index = k
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_CROSS_GET_REWARD"
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
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_CROSS_UPDATE_TASK"
	SoraDSendMessage(SoraDSendMessage)
end
function crossDecryptionCtrl:missionCommitRsp(content)
	dump(content, "crossDecryptionCtrl:missionCommitRsp(content)", 10)
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
		content.rspdata.reward.msg = "MESSAGE_SERVER_CROSS_UPDATE_TASK"
		content.rspdata.reward.data = mission
		content.rspdata.reward.index = mission.index
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
return crossDecryptionCtrl
