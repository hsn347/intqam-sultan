local chiselStoneRead = include("chiselStoneRead")
local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local chiselStoneCtrl = class("chiselStoneCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function chiselStoneCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.CHISEL_STONE_ACTIVITY
	chiselStoneCtrl.super.ctor(self, properties)
	self:resetData()
end
function chiselStoneCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CHISEL_STONE_MODULE, gCmd.REQ_CHISEL_STONE_DATA, handler(self, self.reqChiselStoneDataRsp))
	msgCtrl.register(gCmd.CMD_CHISEL_STONE_MODULE, gCmd.REQ_CHISEL_STONE_REWARD, handler(self, self.reqChiselStoneRewardRsp))
	self:registerNotify()
end
function chiselStoneCtrl:initClientData()
	self:reqChiselStoneData()
end
function chiselStoneCtrl:Logout()
	chiselStoneCtrl.super.Logout(self)
	self:resetData()
end
function chiselStoneCtrl:resetData()
	self.dayTask, _UPVALUE0_ = nil, nil
	self.curDay = 1
end
function chiselStoneCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CHISEL_STONE, handler(self, self.notifyHandler))
end
function chiselStoneCtrl:notifyHandler(event)
	dump(event.data, "chiselStoneCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.questComponent then
				self.questComponent:onNotify_progressUpdate(v.notifyData)
			end
		elseif v.type == "refreshData" then
			if v.curDay then
				self.curDay = v.curDay
			end
			if self.questComponent then
				self.questComponent:setQuestData(v.data.quest)
			else
				self:createQuestComponent(v.data.quest)
			end
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID = self.activityID
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
			SoraDSendMessage(self)
		end
	end
end
function chiselStoneCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_CHISEL_STONE_MODULE, gCmd.REQ_CHISEL_STONE_DATA, nil)
	end
end
function chiselStoneCtrl:reqChiselStoneReward(taskID)
	serverproxy = nil
	;(nil).questID = taskID
	serverproxy:Request(gCmd.CMD_CHISEL_STONE_MODULE, gCmd.REQ_CHISEL_STONE_REWARD, nil)
end
function chiselStoneCtrl:reqChiselStoneDataRsp(content)
	dump(content, "chiselStoneCtrl:reqChiselStoneDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:createQuestComponent(content.rspdata.quest)
		self.curDay = content.curDay
		_ENV = self
		self.msg = "MESSAGE_CHISEL_STONE_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function chiselStoneCtrl:reqChiselStoneRewardRsp(content)
	dump(content, "chiselStoneCtrl:reqChiselStoneRewardRsp(content)", 10)
	_ENV = dump
	local _ENV, dump.err, myContent = content.err, content.err, dump
	content.err.questID = content.data.questID
	content.err.reward = content.rspdata and content.rspdata.reward
	myContent.rspdata, content.err.activityID = content.err, self.activityID
	self.questComponent:reqRuestClaimRewardRsp(myContent)
end
function chiselStoneCtrl:createQuestComponent(questData)
	local activityTaskComponent = include("activityTaskComponent")
	self.questComponent = activityTaskComponent.new()
	self.questComponent:setActivityID(self.activityID)
	self.questComponent:setQuestData(questData)
end
function chiselStoneCtrl:getTaskList(day, label)
	print("chiselStoneCtrl", day, label)
	local _ENV, ret = print, print
	local quests = chiselStoneRead.getTaskByDayLabel(day, label)
	for i, v in pairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(v.taskID)
		if not self.questComponent or not self.questComponent:getQuestData() then
			local _ENV, serverData = self.questComponent:getQuestData(), self.questComponent:getQuestData()
		end
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if serverData then
			if serverData.questProgress then
				progress = serverData.questProgress[tostring(v.taskID)] or 0
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(v.taskID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.claimedQuest and serverData.finishedQuest[tostring(v.taskID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = v.taskID
		v.taskID.order = v.order
		v.taskID.taskID = v.taskID
		v.taskID.taskStatus = taskStatus
		v.taskID.taskDes = questInfo.taskDes
		v.taskID.progress = progress
		v.taskID.aim = questInfo.aim
		v.taskID.guideId = questInfo.guideId
		v.taskID.isAct = questInfo.isAct
		v.taskID.award = eventQuestRead.getReward(v.taskID)
		table.insert(ret, v.taskID)
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
function chiselStoneCtrl:getReceiveStatusAndNum()
	if self.questComponent then
		return self.questComponent:getReceiveStatusAndNum()
	else
		return false, 0
	end
end
function chiselStoneCtrl:getReddotNumByDay(day)
	local num = 0
	if self.questComponent then
		for _, info in ipairs(chiselStoneRead.getTaskByDayLabel(day)) do
			for _, v in ipairs(info.quests) do
				if self.questComponent:isTaskFinished(v.taskID) and not self.questComponent:isTaskClaimed(v.taskID) then
					num = num + 1
				end
			end
		end
	end
	return 0 < num, num
end
function chiselStoneCtrl:getReddotNumByLabel(day, label)
	local num = 0
	if self.questComponent then
		for _, v in ipairs(chiselStoneRead.getTaskByDayLabel(day, label)) do
			if self.questComponent:isTaskFinished(v.taskID) and not self.questComponent:isTaskClaimed(v.taskID) then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function chiselStoneCtrl:getCurDay()
	return self.curDay
end
return chiselStoneCtrl
