local ramadanSurpriseltCtrl = include("ramadanSurpriseltCtrl")
local eventQuestRead = include("eventQuestRead")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ramadanSurpriseCtrl = class("ramadanSurpriseCtrl", GameModule)
function ramadanSurpriseCtrl:ctor(properties)
	ramadanSurpriseCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RAMADAN_SURPRISE_ACTIVITY
end
function ramadanSurpriseCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_DATA, handler(self, self.sendReqDataRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_CHOICE_REWARD, handler(self, self.sendReqChoiceRewardRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_CHANGE_REWARD, handler(self, self.sendReqChangeRewardRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_TASK_REWARD, handler(self, self.sendReqTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_DEL_TASK, handler(self, self.sendReqDelTaskRsp))
	self:resetData()
	ramadanSurpriseCtrl:sendDataMsg()
	self:registerNotify()
end
function ramadanSurpriseCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_SURPRISE, handler(self, self.notifyHandler))
end
function ramadanSurpriseCtrl:notifyHandler(event)
	dump(event.data, "ramadanSurpriseCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.notifyType == "refreshTask" then
			dump(v, "任务刷新 fsfdsfdfdkflkl")
			self.taskList, _ENV = dump, dump
			for i, v in ipairs(v.taskList) do
				self.taskList[i] = v
			end
			_ENV = ipairs(v.taskList)
			ipairs(v.taskList).msg = "MESSAGE_RAMADAN_SURPRISE"
			ipairs(v.taskList).subMsg = "task"
			SoraDSendMessage(ipairs(v.taskList))
		end
	end
end
function ramadanSurpriseCtrl:initClientData(data)
	dump(data, "ramadanSurpriseCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function ramadanSurpriseCtrl:Logout()
	self:resetData()
	ramadanSurpriseCtrl.super.Logout(self)
end
function ramadanSurpriseCtrl:resetData()
	self.gradeReward, _UPVALUE0_ = nil, nil
	self.userSelect, _UPVALUE0_, self.taskList, _UPVALUE0_, self.quest, _UPVALUE0_, self.score = nil, nil, nil, nil, nil, nil, 0
end
function ramadanSurpriseCtrl:setData(data)
	for i, v in ipairs(data.gradeReward) do
		self.gradeReward[i] = v
	end
	self.score = data.score
	self.quest = data.quest
	for i, v in ipairs(data.taskList) do
		self.taskList[i] = v
	end
end
function ramadanSurpriseCtrl:sendDataMsg()
	serverproxy:Request(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_DATA)
end
function ramadanSurpriseCtrl:sendRewardSetMsg(gradeData)
	serverproxy = nil
	;(nil).gradeData = gradeData
	serverproxy:Request(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_CHOICE_REWARD, nil)
end
function ramadanSurpriseCtrl:sendRewardChangeMsg(index, rewardIndex)
	serverproxy = nil
	;(nil).index = index
	;(nil).rewardIndex = rewardIndex
	serverproxy:Request(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_CHANGE_REWARD, nil)
end
function ramadanSurpriseCtrl:sendRewardMsg(questID)
	serverproxy = nil
	;(nil).questID = tonumber(questID)
	serverproxy:Request(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_TASK_REWARD, nil)
end
function ramadanSurpriseCtrl:sendDelTaskMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_RAMADAN_SURPRISE_MODULE, gCmd.REQ_RAMADAN_SURPRISE_DEL_TASK, nil)
end
function ramadanSurpriseCtrl:sendReqDataRsp(content)
	dump(content, "ramadanSurpriseCtrl:sendReqDataRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_SURPRISE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function ramadanSurpriseCtrl:sendReqChoiceRewardRsp(content)
	dump(content, "ramadanSurpriseCtrl:sendReqChoiceRewardRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gradeReward) do
			self.gradeReward[i] = v
		end
		for i, v in ipairs(data.taskList) do
			self.taskList[i] = v
		end
		_ENV = ipairs(data.taskList)
		ipairs(data.taskList).msg = "MESSAGE_RAMADAN_SURPRISE"
		ipairs(data.taskList).subMsg = "task"
		SoraDSendMessage(ipairs(data.taskList))
		return
	end
end
function ramadanSurpriseCtrl:sendReqChangeRewardRsp(content)
	dump(content, "ramadanSurpriseCtrl:sendReqChangeRewardRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gradeReward) do
			self.gradeReward[i] = v
		end
		return
	end
end
function ramadanSurpriseCtrl:sendReqTaskRewardRsp(content)
	dump(content, "ramadanSurpriseCtrl:sendReqTaskRewardRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_SURPRISE"
		self.subMsg = "reward"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
		return
	end
end
function ramadanSurpriseCtrl:sendReqDelTaskRsp(content)
	dump(content, "ramadanSurpriseCtrl:sendReqDelTaskRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in ipairs(data.taskList) do
			self.taskList[i] = v
		end
		_ENV = ipairs(data.taskList)
		ipairs(data.taskList).msg = "MESSAGE_RAMADAN_SURPRISE"
		ipairs(data.taskList).subMsg = "task"
		SoraDSendMessage(ipairs(data.taskList))
		return
	end
end
function ramadanSurpriseCtrl:createQuestComponent(questData)
	local activityTaskComponent = include("activityTaskComponent")
	self.questComponent = activityTaskComponent.new()
	self.questComponent:setActivityID(self.activityID)
	self.questComponent:setQuestData(questData)
end
function ramadanSurpriseCtrl:getTaskList(quests)
	dump(quests, "fskfjdkfjkdfjkdfjkd")
	local _ENV, ret = dump, dump
	for i, taskID in ipairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		if not self.questComponent or not self.questComponent:getQuestData() then
			local _ENV, serverData = self.questComponent:getQuestData(), self.questComponent:getQuestData()
		end
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if serverData then
			if serverData.questProgress then
				progress = serverData.questProgress[tostring(taskID)] or 0
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(taskID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.claimedQuest and serverData.finishedQuest[tostring(taskID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = taskID
		taskID.taskIndex = i
		taskID.taskID = taskID
		taskID.taskStatus = taskStatus
		taskID.taskDes = questInfo.taskDes
		taskID.progress = progress
		taskID.aim = questInfo.aim
		taskID.guideId = questInfo.guideId
		taskID.isAct = questInfo.isAct
		taskID.award = eventQuestRead.getReward(taskID)
		table.insert(ret, taskID)
	end
	dump(ret, "fsjkfljsdfjkdfjkdfjk")
	return ret
end
function ramadanSurpriseCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function ramadanSurpriseCtrl:isSelectedAlready()
	if self.gradeReward and next(self.gradeReward) then
		return true
	end
	return false
end
function ramadanSurpriseCtrl:getCurScore()
	return self.score
end
function ramadanSurpriseCtrl:getTaskRefrshTimeByIndex(index)
	if not self.taskList or not next(self.taskList) then
		return false
	end
	dump(self.taskList, "fskfjdfjslfjsljfl")
	dump(self.taskList[index][2], "fskfjdfjslfjsljflwrwrer")
	if self.taskList[index][2] > 0 then
		return self.taskList[index][2]
	end
	return false
end
function ramadanSurpriseCtrl:getQuestId()
	local _ENV, questId
	for i, v in ipairs(self.taskList) do
		questId[i] = self.taskList[i][1]
	end
	return questId
end
function ramadanSurpriseCtrl:setUserSelect(level, curSelect)
	self.userSelect[level] = curSelect
end
function ramadanSurpriseCtrl:getUserSelectByLevel(level)
	return self.userSelect[level] or false
end
function ramadanSurpriseCtrl:getUserSelect()
	if self:isUseSelectAll() then
		return self.userSelect
	end
	_UPVALUE0_ = self.userSelect
	return self.userSelect
end
function ramadanSurpriseCtrl:isUseSelectAll()
	dump(self.userSelect, "fsfsjfkdjfkdfjkdffd")
	local count = ramadanSurpriseltCtrl.getSelectRewardGradeCount()
	if not self.userSelect then
		return false
	end
	for i = 1, count do
		if not self.userSelect[i] then
			return false
		end
	end
	return true
end
function ramadanSurpriseCtrl:getSelectedIndexByLevel(level)
	if self.gradeReward and self.gradeReward[level] then
		dump(self.gradeReward[level], "fksfkjdjfkdjfkdjkf")
		return self.gradeReward[level][1]
	end
	return nil
end
function ramadanSurpriseCtrl:getSelectedStateByLevel(level)
	if self.gradeReward and self.gradeReward[level] then
		dump(self.gradeReward[level], "fksfkjdjfkdjfkdjkf")
		return self.gradeReward[level][2]
	end
end
return ramadanSurpriseCtrl
