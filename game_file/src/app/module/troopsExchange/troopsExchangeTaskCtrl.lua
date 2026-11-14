local armyChangeRead = include("armyChangeRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local troopsExchangeTaskCtrl = class("troopsExchangeTaskCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function troopsExchangeTaskCtrl:ctor(properties)
	troopsExchangeTaskCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.BATTLEFIELD_TRAINING
end
function troopsExchangeTaskCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BATTLEFIELD_TRAINING_MODULE, gCmd.REQ_BATTLEFIELD_TRAINING_INIT, handler(self, self.reqBattlefieldTrainingInitRsp))
	msgCtrl.register(gCmd.CMD_BATTLEFIELD_TRAINING_MODULE, gCmd.REQ_BATTLEFIELD_TRAINING_CLAIM, handler(self, self.reqBattlefieldTrainingClaimRsp))
	self:registerNotify()
end
function troopsExchangeTaskCtrl:Logout()
	troopsExchangeTaskCtrl.super.Logout(self)
	self:resetData()
end
function troopsExchangeTaskCtrl:resetData()
	self.questComponent = nil
end
function troopsExchangeTaskCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BATTLEFIELD_TRAINING, handler(self, self.notifyHandler))
end
function troopsExchangeTaskCtrl:notifyHandler(event)
	dump(event.data, "troopsExchangeTaskCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.type == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.type == "resetQuest" then
			self:createQuestComponent(v.quest)
			_ENV = self
			self.msg = "MESSAGE_TROOPS_EXCHANGE_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		end
	end
end
function troopsExchangeTaskCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_BATTLEFIELD_TRAINING_MODULE, gCmd.REQ_BATTLEFIELD_TRAINING_INIT, nil)
	end
end
function troopsExchangeTaskCtrl:reqBattlefieldTrainingClaim(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_BATTLEFIELD_TRAINING_MODULE, gCmd.REQ_BATTLEFIELD_TRAINING_CLAIM, nil)
end
function troopsExchangeTaskCtrl:reqBattlefieldTrainingInitRsp(content)
	dump(content, "troopsExchangeTaskCtrl:reqBattlefieldTrainingInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:createQuestComponent(content.rspdata.quest)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function troopsExchangeTaskCtrl:reqBattlefieldTrainingClaimRsp(content)
	dump(content, "troopsExchangeTaskCtrl:reqBattlefieldTrainingClaimRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = content.err
		local _ENV, content.err.err, myContent = content.err, content.err, content.err
		content.err.questID = content.data.questID
		content.err.reward = content.rspdata.reward
		myContent.rspdata, content.err.activityID = content.err, self.activityID
		self.questComponent:reqRuestClaimRewardRsp(myContent)
	else
		local questID = content.data.questID
		_ENV = self.questComponent
		self.questComponent.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		self.questComponent.activityID = self.activityID
		self.questComponent.questID = questID
		self.questComponent.isSuccess = false
		SoraDSendMessage(self.questComponent)
	end
end
function troopsExchangeTaskCtrl:createQuestComponent(questData)
	if self.questComponent then
		self.questComponent:setQuestData(questData)
	else
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
		self.questComponent:setQuestData(questData)
	end
end
function troopsExchangeTaskCtrl:getTaskProgress(taskID)
	if self.questComponent then
		return self.questComponent:getTaskProgress(taskID)
	end
	return 0
end
function troopsExchangeTaskCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function troopsExchangeTaskCtrl:isTaskClaimed(taskID)
	if self.questComponent then
		return self.questComponent:isTaskClaimed(taskID)
	end
	return false
end
function troopsExchangeTaskCtrl:isTaskFinished(taskID)
	if self.questComponent then
		return self.questComponent:isTaskFinished(taskID)
	end
	return false
end
function troopsExchangeTaskCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	end
	return false, 0
end
function troopsExchangeTaskCtrl:getReddotNumByType(type)
	local num = 0
	if self.questComponent then
		local taskList = armyChangeRead.getTaskConfig()
		local questIDList = taskList[tonumber(type)] and taskList[tonumber(type)].qeustID
		return self.questComponent:getReceiveStatusAndNumByQuestList(questIDList)
	end
	return 0 < num, num
end
function troopsExchangeTaskCtrl:getTaskList(taskList)
	table.sort(taskList, function(l, r)
		local lState = self:getTaskState(l)
		local rState = self:getTaskState(r)
		if lState == rState then
			return l < r
		else
			return lState < rState
		end
	end)
	return taskList
end
return troopsExchangeTaskCtrl
