local serverproxy = gModuleMgr.getObject("serverproxy")
local Component = cc.Component
local activityTaskComponent = class("activityTaskComponent", Component)
function activityTaskComponent:ctor()
	activityTaskComponent.super.ctor(self, "activityTaskComponent")
	self:resetData()
end
function activityTaskComponent:exportMethods()
	_UPVALUE2_ = nil
	;(nil)[1] = "dumpTaskInfo"
	;(nil)[2] = "getQuestData"
	self:exportMethods_(nil)
	return self.target_
end
function activityTaskComponent:resetData()
	self.questData, (nil).questProgress, _UPVALUE0_, (nil).finishedQuest, _UPVALUE0_, (nil).claimedQuest, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function activityTaskComponent:setActivityID(activityID)
	self.activityID = tonumber(activityID)
end
function activityTaskComponent:setQuestData(questData)
	dump(questData, "questData")
	if questData and next(questData) then
		self.questData = questData
	else
		self:resetData()
	end
end
function activityTaskComponent:setDailyQuestData(dailyQuestData)
	dump(dailyQuestData, "dailyQuestData")
	if dailyQuestData and next(dailyQuestData) then
		for k, v in pairs(dailyQuestData) do
			if not self.questData[k] then
				self.questData[k] = v
			else
				local temp = self.questData[k]
				table.merge(temp, v)
			end
		end
	end
	dump(self.questData, "==self.questData==")
end
function activityTaskComponent:updateQuest(questID, isFinish, progress)
	if isFinish then
		local finishQuest = self.questData and self.questData.finishedQuest
		if finishQuest then
			finishQuest[tostring(questID)] = true
		end
	end
	local questProgress = self.questData and self.questData.questProgress
	dump(questProgress, "magicLampCtrl:questProgress")
	if questProgress then
		questProgress[tostring(questID)] = progress
	end
end
function activityTaskComponent:getQuestData()
	return self.questData
end
function activityTaskComponent:getReceiveStatusAndNum()
	if not self.questData or not self.questData.finishedQuest then
		return false
	end
	local num = 0
	for k, v in pairs(self.questData.finishedQuest) do
		if not self.questData.claimedQuest[k] then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activityTaskComponent:getReceiveStatusAndNumEx(data)
	if not self.questData or not self.questData.finishedQuest then
		return false
	end
	local isAdvanceUnlock = data.isAdvanceUnlock
	local num = 0
	for taskID, __ in pairs(self.questData.finishedQuest) do
		local taskState = self:getTaskState(taskID)
		if taskState == gBtnTargetStatusDef.GET or taskState == gBtnTargetStatusDef.GOT and isAdvanceUnlock and not self:isGotTaskPayReward(taskID) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activityTaskComponent:getReceiveStatusAndNumByQuestList(questList)
	if not (self.questData and self.questData.finishedQuest) or not questList then
		return false
	end
	local num = 0
	for i, v in ipairs(questList) do
		local id
		if tolua.type(v) == "number" then
			id = tostring(v)
		else
			id = tostring(v.taskID)
		end
		if id and self.questData.finishedQuest[id] and not self.questData.claimedQuest[id] then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activityTaskComponent:getFinishNumByQuestList(questList)
	if not (self.questData and self.questData.finishedQuest) or not questList then
		return false
	end
	local num = 0
	for i, taskID in ipairs(questList) do
		local id = tostring(taskID)
		if self.questData.finishedQuest[id] then
			num = num + 1
		end
	end
	return num
end
function activityTaskComponent:EnterGame()
end
function activityTaskComponent:dumpTaskInfo()
end
function activityTaskComponent:onNotify_progressUpdate(notifyData)
	if not notifyData or not notifyData.activityID then
		return
	end
	local activityID = notifyData.activityID
	if tonumber(activityID) ~= self.activityID then
		return
	end
	local questID = notifyData.questID
	if questID then
		self.questData.questProgress[tostring(questID)] = notifyData.progress
		if notifyData.isFinish then
			self.questData.finishedQuest[tostring(questID)] = 1
			_ENV = tostring(questID)
			tostring(questID).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			tostring(questID).eventID = activityID
			SoraDSendMessage((tostring(questID)))
		end
		_ENV = tostring(questID)
		tostring(questID).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK"
		tostring(questID).activityID = activityID
		SoraDSendMessage((tostring(questID)))
	end
end
function activityTaskComponent:onNotify_reset(notifyData)
	if not notifyData or not notifyData.activityID then
		return
	end
	local activityID = notifyData.activityID
	if tonumber(activityID) ~= self.activityID then
		return
	end
	self:resetData()
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_MODULE_RESET_TASK"
	self.activityID = self.activityID
	SoraDSendMessage(self)
end
function activityTaskComponent:reqRuestClaimRewardRsp(ret)
	dump(ret, "activityTaskComponent:reqRuestClaimRewardRsp(ret)", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		local activityID = ret.rspdata.activityID
		local questID = ret.rspdata.questID
		local reward = ret.rspdata.reward
		if reward then
			SoraDMailGainItems(reward, true)
		end
		self.questData.claimedQuest[tostring(questID)] = 1
		_ENV = tostring(questID)
		tostring(questID).msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		tostring(questID).activityID = activityID
		tostring(questID).questID = questID
		tostring(questID).isSuccess = true
		SoraDSendMessage((tostring(questID)))
		_ENV = tostring(questID)
		tostring(questID).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		tostring(questID).eventID = activityID
		SoraDSendMessage((tostring(questID)))
	else
		local activityID = ret.rspdata.activityID
		local questID = ret.rspdata.questID
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		SoraDSendMessage.activityID = activityID
		SoraDSendMessage.questID = questID
		SoraDSendMessage.isSuccess = false
		SoraDSendMessage(SoraDSendMessage)
	end
end
function activityTaskComponent:isTaskClaimed(taskID)
	return self.questData and self.questData.claimedQuest[tostring(taskID)]
end
function activityTaskComponent:isTaskFinished(taskID)
	return self.questData and self.questData.finishedQuest[tostring(taskID)]
end
function activityTaskComponent:getTaskProgress(taskID)
	return self.questData and self.questData.questProgress[tostring(taskID)] or 0
end
function activityTaskComponent:isGotTaskPayReward(taskID)
	return self.questData and self.questData.payReward[tostring(taskID)] ~= nil
end
function activityTaskComponent:getFinishedQuestNum()
	return table.nums(self.questData.finishedQuest)
end
function activityTaskComponent:getTaskState(taskID)
	if self:isTaskClaimed(taskID) then
		return gBtnTargetStatusDef.GOT
	elseif self:isTaskFinished(taskID) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
return activityTaskComponent
