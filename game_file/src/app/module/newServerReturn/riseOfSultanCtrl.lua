local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local riseOfSultanCtrl = class("riseOfSultanCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function riseOfSultanCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.SUDAN_RISING_ACTIVITY
	riseOfSultanCtrl.super.ctor(self, properties)
	self:resetData()
end
function riseOfSultanCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SUDAN_RISING_MODULE, gCmd.REQ_SUDAN_RISING_INIT, handler(self, self.riseOfSultanInitRsp))
	msgCtrl.register(gCmd.CMD_SUDAN_RISING_MODULE, gCmd.REQ_SUDAN_RISING_REWARD, handler(self, self.riseOfSultanRewardRsp))
	self:registerNotify()
	riseOfSultanCtrl:riseOfSultanInit()
end
function riseOfSultanCtrl:Logout()
	riseOfSultanCtrl.super.Logout(self)
	self:resetData()
end
function riseOfSultanCtrl:resetData()
	self.curIndex = 1
	self.nextRefreshTime = 0
end
function riseOfSultanCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SUDAN_RISING, handler(self, self.notifyHandler))
end
function riseOfSultanCtrl:notifyHandler(event)
	dump(event.data, "riseOfSultanCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.notifyType == "resetQuest" then
			if v.data.curIndex then
				self.curIndex = v.data.curIndex
				self.nextRefreshTime = v.data.nextRefreshTime
			end
			if self.questComponent then
				self.questComponent:setQuestData(v.data.quest)
			else
				self:createQuestComponent(v.data.quest)
			end
			_ENV = self
			self.msg = "MESSAGE_RISE_OF_SULTAN_REFRESH"
			SoraDSendMessage(self)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage(ipairs(event.data))
end
function riseOfSultanCtrl:riseOfSultanInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUDAN_RISING_MODULE, gCmd.REQ_SUDAN_RISING_INIT, nil)
end
function riseOfSultanCtrl:riseOfSultanReward(taskID)
	serverproxy = nil
	;(nil).questID = taskID
	serverproxy:Request(gCmd.CMD_SUDAN_RISING_MODULE, gCmd.REQ_SUDAN_RISING_REWARD, nil)
end
function riseOfSultanCtrl:riseOfSultanInitRsp(content)
	dump(content, "riseOfSultanCtrl:riseOfSultanInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		newStartMainCtrl:setActInitFlag(self.activityID)
		self:createQuestComponent(content.rspdata.quest)
		self.curIndex = content.rspdata.curIndex
		self.nextRefreshTime = content.rspdata.nextRefreshTime
		_ENV = self
		self.msg = "MESSAGE_RISE_OF_SULTAN_REFRESH"
		SoraDSendMessage(self)
	end
end
function riseOfSultanCtrl:riseOfSultanRewardRsp(content)
	dump(content, "riseOfSultanCtrl:riseOfSultanRewardRsp(content)", 10)
	_ENV = dump
	local _ENV, dump.err, myContent = content.err, content.err, dump
	content.err.questID = content.data.questID
	content.err.reward = content.rspdata and content.rspdata.reward
	myContent.rspdata, content.err.activityID = content.err, self.activityID
	self.questComponent:reqRuestClaimRewardRsp(myContent)
end
function riseOfSultanCtrl:createQuestComponent(questData)
	local activityTaskComponent = include("activityTaskComponent")
	self.questComponent = activityTaskComponent.new()
	self.questComponent:setActivityID(self.activityID)
	self.questComponent:setQuestData(questData)
end
function riseOfSultanCtrl:getTaskList(quests)
	local _ENV, ret
	for _, taskID in pairs(quests) do
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
function riseOfSultanCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function riseOfSultanCtrl:getNextTaskResetTime()
	return self.nextRefreshTime
end
function riseOfSultanCtrl:getClassTypeIndex()
	return self.curIndex
end
return riseOfSultanCtrl
