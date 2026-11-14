local heroPaeanRead = include("heroPaeanRead")
local eventQuestRead = include("eventQuestRead")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local heroPaeanCtrl = class("heroPaeanCtrl", GameModule)
function heroPaeanCtrl:ctor(properties)
	heroPaeanCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HERO_PAEAN_ACTIVITY
end
function heroPaeanCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_INIT, handler(self, self.sendInitRsp))
	msgCtrl.register(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_TASK_REWARD, handler(self, self.sendDayTaskRsp))
	msgCtrl.register(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_STAGE_REWARD, handler(self, self.sendStageRewardRsp))
	self:resetData()
	self:registerNotify()
	heroPaeanCtrl:sendInitMsg()
end
function heroPaeanCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_PAEAN, handler(self, self.notifyHandler))
end
function heroPaeanCtrl:notifyHandler(event)
	dump(event.data, "heroPaeanCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.initData then
			self:setData(v.initData)
			_ENV = self
			self.msg = "MESSAGE_HERO_PEAEAN_REFRESH"
			self.subMsg = "refresh"
			SoraDSendMessage(self)
		end
	end
end
function heroPaeanCtrl:Logout()
	heroPaeanCtrl.super.Logout(self)
	self:resetData()
end
function heroPaeanCtrl:setData(data)
	dump(data, "heroPaeanCtrl:setData")
	if next(data.stageRewardRecord) then
		for i, v in pairs(data.stageRewardRecord) do
			self.stageRewardRecord[i] = v
		end
	end
	if next(data.taskFinishProcess) then
		for i, v in pairs(data.taskFinishProcess) do
			self.taskFinishProcess[i] = v
		end
	end
	if next(data.taskRewardRecord) then
		for i, v in pairs(data.taskRewardRecord) do
			self.taskRewardRecord[i] = v
		end
	end
end
function heroPaeanCtrl:resetData()
	self.taskRewardRecord, _UPVALUE0_, self.taskFinishProcess, _UPVALUE0_, self.stageRewardRecord, _UPVALUE0_ = nil, nil, nil, nil, nil, nil
	self.score = 0
end
function heroPaeanCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_INIT)
end
function heroPaeanCtrl:sendDayTaskMsg(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_TASK_REWARD, nil)
end
function heroPaeanCtrl:sendStageRewardMsg(stageID)
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_HERO_PAEAN_MODULE, gCmd.REQ_HERO_PAEAN_STAGE_REWARD, nil)
end
function heroPaeanCtrl:sendInitRsp(content)
	dump(content, "heroPaeanCtrl:sendInitRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_HERO_PEAEAN_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function heroPaeanCtrl:sendDayTaskRsp(content)
	dump(content, "heroPaeanCtrl:sendDayTaskRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		_ENV = self
		self.msg = "MESSAGE_HERO_PEAEAN_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
	end
end
function heroPaeanCtrl:sendStageRewardRsp(content)
	dump(content, "heroPaeanCtrl:sendStageRewardRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.initData)
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_HERO_PEAEAN_REFRESH"
		content.rspdata.reward.subMsg = "init"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function heroPaeanCtrl:getTaskList(quests)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local _ENV, ret = "activityTaskComponentCtrl", "activityTaskComponentCtrl"
	for _, taskID in pairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if self.taskFinishProcess then
			progress = self.taskFinishProcess[tostring(taskID)] or 0
			if progress >= questInfo.aim and self.taskRewardRecord[tostring(taskID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif progress >= questInfo.aim then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = taskID
		taskID.activityID = self.activityID
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
	table.sort(ret, function(l, r)
		if l.taskStatus == r.taskStatus then
			return l.taskID < r.taskID
		else
			return l.taskStatus < r.taskStatus
		end
	end)
	return ret
end
function heroPaeanCtrl:getReceiveStatusAndNum()
	local show, total = false, 0
	local count = heroPaeanRead.getTotalDay()
	for i = 1, count do
		local visible, num = self:getDayRewardCount(i)
		total = total + num
	end
	local visible, num = self:getStageRewardCount()
	total = total + num
	return 0 < total, total
end
function heroPaeanCtrl:isInStageReward(index)
	dump(self.stageRewardRecord, "Fksdfkdjfk")
	if self.stageRewardRecord and self.stageRewardRecord[tostring(index)] then
		return true
	end
	return false
end
function heroPaeanCtrl:getScore()
	local score = 0
	for i, v in pairs(self.taskFinishProcess) do
		if v >= eventQuestRead.getAim(tonumber(i)) then
			score = score + 1
		end
	end
	return score
end
function heroPaeanCtrl:getDayRewardCount(index)
	local taskList = heroPaeanRead.getTaskConfigByDay(index)
	local count = 0
	for i, v in ipairs(taskList) do
		if self.taskFinishProcess[tostring(v)] and self.taskFinishProcess[tostring(v)] >= eventQuestRead.getAim(tonumber(v)) and not self.taskRewardRecord[tostring(v)] then
			count = count + 1
		end
	end
	return 0 < count, count
end
function heroPaeanCtrl:getStageRewardCount()
	local count = 0
	local curScore = self:getScore()
	local StageCfg = heroPaeanRead.getStageRewardConfig()
	for i, v in ipairs(StageCfg) do
		if curScore >= v.score and not self.stageRewardRecord[tostring(i)] then
			count = count + 1
		end
	end
	return 0 < count, count
end
return heroPaeanCtrl
