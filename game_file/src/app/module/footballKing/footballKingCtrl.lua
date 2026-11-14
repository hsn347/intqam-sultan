local footballKingRead = include("footballKingRead")
local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local footballKingCtrl = class("footballKingCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function footballKingCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY
	footballKingCtrl.super.ctor(self, properties)
	self:resetData()
end
function footballKingCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_INIT, handler(self, self.reqFootballKingDataRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_TASK_REWARD, handler(self, self.reqFootballKingRewardRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_STAGE_REWARD, handler(self, self.reqFootballKingStageRewardRsp))
	self:registerNotify()
end
function footballKingCtrl:initClientData()
	self:sendReqInitDataMsg()
end
function footballKingCtrl:Logout()
	footballKingCtrl.super.Logout(self)
	self:resetData()
end
function footballKingCtrl:resetData()
	self.msgData = nil
	self.taskDatas = nil
	self.curDay = 1
end
function footballKingCtrl:setData(data)
	if self.taskDatas == nil or self.lastGroupId ~= self:getGroup() then
		self.taskDatas, footballKingRead, self.taskNum = self.lastGroupId, self.lastGroupId, 0
		local taskConfig = footballKingRead.getTaskConfig()
		for i, v in pairs(taskConfig) do
			for i2, v2 in ipairs(v) do
				for i3, v3 in ipairs(v2.taskID) do
					local questInfo = eventQuestRead.getTaskConfig(v3)
					footballKingRead = nil
					;(nil).order = i3
					;(nil).taskID = v3
					;(nil).taskStatus = gBtnTargetStatusDef.GO
					;(nil).taskDes = questInfo.taskDes
					;(nil).progress = 0
					;(nil).aim = questInfo.aim
					;(nil).guideId = questInfo.guideId
					;(nil).isAct = questInfo.isAct
					self.taskDatas[v3], (nil).award = nil, eventQuestRead.getReward(v3)
					self.taskNum = self.taskNum + 1
				end
			end
		end
	end
	self.lastGroupId = self:getGroup()
	self.msgData = data.initData
	self.dayRewardCount = 0
	for k, v in pairs(self.taskDatas) do
		local progress = self.msgData.taskFinishProcess[tostring(k)] or 0
		local taskStatus = gBtnTargetStatusDef.GO
		if progress >= v.aim then
			taskStatus = self.msgData.taskRewardRecord[tostring(k)] ~= nil and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GET
			self.dayRewardCount = self.dayRewardCount + 1
		end
		v.taskStatus = taskStatus
		v.progress = progress
	end
end
function footballKingCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FOOTBALL_KING, handler(self, self.notifyHandler))
end
function footballKingCtrl:notifyHandler(event)
	for _, content in ipairs(event.data) do
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
		SoraDSendMessage(self)
	end
end
function footballKingCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_INIT, nil)
	end
end
function footballKingCtrl:reqFootballKingReward(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_TASK_REWARD, nil)
end
function footballKingCtrl:reqFootballKingStageReward(taskNum)
	serverproxy = nil
	;(nil).taskNum = taskNum
	serverproxy:Request(gCmd.CMD_FOOTBALL_KING_MODULE, gCmd.REQ_FOOTBALL_KING_STAGE_REWARD, nil)
end
function footballKingCtrl:reqFootballKingDataRsp(content)
	dump(content, "footballKingCtrl:reqFootballKingDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
		SoraDSendMessage(self)
	end
end
function footballKingCtrl:reqFootballKingRewardRsp(content)
	dump(content, "footballKingCtrl:reqFootballKingRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
		SoraDSendMessage(self)
		local reward = content.rspdata.reward
		if reward then
			SoraDMailGainItems(reward, true)
		end
	end
end
function footballKingCtrl:reqFootballKingStageRewardRsp(content)
	dump(content, "footballKingCtrl:reqFootballKingRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
		SoraDSendMessage(self)
		local reward = content.rspdata.reward
		if reward then
			SoraDMailGainItems(reward, true)
		end
	end
end
function footballKingCtrl:getTaskList(day, label)
	if not self.taskDatas then
		footballKingRead = self.taskDatas
		return self.taskDatas
	end
	local footballKingRead, ret = self.taskDatas, self.taskDatas
	local quests = footballKingRead.getTaskByDayLabel(day, label)
	for i, v in ipairs(quests) do
		table.insert(ret, self.taskDatas[v])
	end
	table.sort(ret, function(l, r)
		if l.taskStatus == r.taskStatus then
			return l.order < r.order
		else
			return l.taskStatus < r.taskStatus
		end
	end)
	return ret
end
function footballKingCtrl:getIsAllTaskFinish(day, label)
	if not self.taskDatas then
		return false
	end
	local quests = footballKingRead.getTaskByDayLabel(day, label)
	for i, v in ipairs(quests) do
		if self.taskDatas[v].taskStatus ~= gBtnTargetStatusDef.GOT then
			return false
		end
	end
	return true
end
function footballKingCtrl:getBoxRewardDataStatus(num)
	if self.msgData == nil then
		return gBtnTargetStatusDef.GO
	end
	if self.msgData.stageRewardRecord[tostring(num)] then
		return gBtnTargetStatusDef.GOT
	end
	if num <= self.dayRewardCount then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function footballKingCtrl:getReceiveStatusAndNum()
	if self.msgData then
		local retNum = 0
		for k, v in pairs(self.taskDatas) do
			if v.taskStatus == gBtnTargetStatusDef.GET then
				return true, -1
			end
		end
		local taskRewardCfgs = footballKingRead.getTaskReward()
		for i, v in ipairs(taskRewardCfgs) do
			if self.msgData.stageRewardRecord[tostring(v.num)] == nil and v.num <= self.dayRewardCount then
				return true, -1
			end
		end
	else
		return false, 0
	end
end
function footballKingCtrl:getReddotNumByDay(day)
	print("getReddotNumByDay", day)
	local num = 0
	local dayCfgs = footballKingRead.getTaskByDayLabel(day)
	for _, info in ipairs(dayCfgs) do
		for _, v in ipairs(info.taskID) do
			if self:isTaskCanGet(v) then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function footballKingCtrl:getReddotNumByLabel(day, label)
	local num = 0
	local taskids = footballKingRead.getTaskByDayLabel(day, label)
	for _, v in ipairs(taskids) do
		if self:isTaskCanGet(v) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function footballKingCtrl:isTaskCanGet(taskID)
	if self.msgData == nil then
		return false
	end
	local progress = self.msgData.taskFinishProcess[tostring(taskID)] or 0
	return self.msgData.taskRewardRecord[tostring(taskID)] == nil and progress >= self.taskDatas[taskID].aim
end
function footballKingCtrl:getCurDay()
	local activityData = SoraDGetCtrl("activityShowCtrl"):getActivityData(self.activityID)
	return activityData and activityData.doStage ~= nil and activityData.doStage + 1 or 0
end
function footballKingCtrl:getGroup()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(self.activityID)
	return param.classtype or 1
end
function footballKingCtrl:getBoxRewardNum()
	return self.dayRewardCount
end
function footballKingCtrl:getTaskNum()
	return self.taskNum
end
return footballKingCtrl
