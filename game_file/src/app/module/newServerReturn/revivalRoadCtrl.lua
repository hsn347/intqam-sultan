local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local revivalRoadCtrl = class("revivalRoadCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function revivalRoadCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY
	revivalRoadCtrl.super.ctor(self, properties)
	self:resetData()
end
function revivalRoadCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ROAD_TO_REVIVE_MODULE, gCmd.REQ_ROAD_TO_REVIVE_INIT, handler(self, self.reqRoadToReviveInitRsp))
	msgCtrl.register(gCmd.CMD_ROAD_TO_REVIVE_MODULE, gCmd.REQ_ROAD_TO_REVIVE_REWARD, handler(self, self.reqRoadToReviveRewardRsp))
	self:registerNotify()
	revivalRoadCtrl:reqRoadToReviveInit()
end
function revivalRoadCtrl:Logout()
	revivalRoadCtrl.super.Logout(self)
	self:resetData()
end
function revivalRoadCtrl:resetData()
	self.curWeek = 1
end
function revivalRoadCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ROAD_TO_REVIVE, handler(self, self.notifyHandler))
end
function revivalRoadCtrl:notifyHandler(event)
	dump(event.data, "revivalRoadCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.notifyType == "resetQuest" then
			if v.data.curWeek then
				self.curWeek = v.data.curWeek
			end
			dump(v.data.quest, "v.data.quest")
			self:createQuestComponent(v.data.quest)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_REVIVAL_ROAD_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage(ipairs(event.data))
end
function revivalRoadCtrl:reqRoadToReviveInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROAD_TO_REVIVE_MODULE, gCmd.REQ_ROAD_TO_REVIVE_INIT, nil)
end
function revivalRoadCtrl:reqRoadToReviveReward(taskID)
	serverproxy = nil
	;(nil).questID = taskID
	serverproxy:Request(gCmd.CMD_ROAD_TO_REVIVE_MODULE, gCmd.REQ_ROAD_TO_REVIVE_REWARD, nil)
end
function revivalRoadCtrl:reqRoadToReviveInitRsp(content)
	dump(content, "revivalRoadCtrl:reqRoadToReviveInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		newStartMainCtrl:setActInitFlag(self.activityID)
		self:createQuestComponent(content.rspdata.quest)
		self.curWeek = content.rspdata.curWeek
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_REVIVAL_ROAD_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function revivalRoadCtrl:reqRoadToReviveRewardRsp(content)
	dump(content, "revivalRoadCtrl:reqRoadToReviveRewardRsp(content)", 10)
	_ENV = dump
	local _ENV, dump.err, myContent = content.err, content.err, dump
	content.err.questID = content.data.questID
	content.err.reward = content.rspdata and content.rspdata.reward
	myContent.rspdata, content.err.activityID = content.err, self.activityID
	self.questComponent:reqRuestClaimRewardRsp(myContent)
end
function revivalRoadCtrl:createQuestComponent(questData)
	if not self.questComponent then
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
		self.questComponent:setActivityID(self.activityID)
	end
	self.questComponent:setQuestData(questData)
end
function revivalRoadCtrl:getTaskList(quests)
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
function revivalRoadCtrl:getCurWeek()
	return self.curWeek or 1
end
function revivalRoadCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function revivalRoadCtrl:getReceiveStatusAndNumByQuests(questList)
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNumByQuestList(questList)
	else
		return false, 0
	end
end
return revivalRoadCtrl
