local heroJourneyRead = include("heroJourneyRead")
local eventQuestRead = include("eventQuestRead")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local heroJourneyCtrl = class("snowNightCarnivalCtrl", GameModule)
function heroJourneyCtrl:ctor(properties)
	heroJourneyCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HERO_DIARY_ACTIVITY
end
function heroJourneyCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.setInitData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateData))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_DIARY_SCORE_REWARD, handler(self, self.accuRewardRsp))
	self:resetData()
	self:registerNotify()
end
function heroJourneyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_DIARY_ACTIVITY, handler(self, self.notifyHandler))
end
function heroJourneyCtrl:notifyHandler(event)
	dump(event.data, "heroJourneyCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.score then
			self.score = v.score
			_ENV = nil
			;(nil).msg = "MESSAGE_HERO_JOURNEY_REFRESH"
			SoraDSendMessage(nil)
		end
	end
end
function heroJourneyCtrl:Logout()
	heroJourneyCtrl.super.Logout(self)
	self:resetData()
end
function heroJourneyCtrl:setData(data)
	dump(data, "heroJourneyCtrl:setData")
	self.score = data.score or self.score
	for i, v in pairs(data.stageReward) do
		self.stageReward[i] = v
	end
end
function heroJourneyCtrl:resetData()
	self.stageReward, _UPVALUE0_, self.score = nil, nil, 0
end
function heroJourneyCtrl:sendTaskRewardMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_DIARY_SCORE_REWARD, nil)
end
function heroJourneyCtrl:setInitData(target, data)
	if data.activityID == self.activityID then
		dump(data, "heroJourneyCtrl:setInitData")
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_HERO_JOURNEY_REFRESH"
		SoraDSendMessage(self)
	end
end
function heroJourneyCtrl:updateData(target, data)
	if data.activityID == self.activityID then
		_ENV = self.activityID
		self.activityID.msg = "MESSAGE_HERO_JOURNEY_REFRESH"
		SoraDSendMessage(self.activityID)
	end
end
function heroJourneyCtrl:accuRewardRsp(content)
	dump(content, "heroJourneyCtrl:accuRewardRsp")
	if content.err == gErrDef.Err_None then
		local data = content.clientData
		for i, v in pairs(data.stageReward) do
			self.stageReward[i] = v
		end
		self.score = data.score
		if content.rewards then
			SoraDMailGainItems(content.rewards, true)
		end
		_ENV = content.rewards
		content.rewards.msg = "MESSAGE_HERO_JOURNEY_REFRESH"
		SoraDSendMessage(content.rewards)
	end
end
function heroJourneyCtrl:getTaskList(quests)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local _ENV, ret = "activityTaskComponentCtrl", "activityTaskComponentCtrl"
	for _, taskID in pairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
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
function heroJourneyCtrl:getReceiveStatusAndNum()
	local show, num = false, 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	self.rewardCfg = heroJourneyRead.getRewardConfig()
	for i, v in ipairs(self.rewardCfg) do
		if self.score >= v.integral and not self:isInStageReward(i) then
			num = num + 1
		end
	end
	if 0 < num then
		show = true
	end
	return show, -1
end
function heroJourneyCtrl:isInStageReward(index)
	if self.stageReward and self.stageReward[tostring(index)] then
		return true
	end
	return false
end
function heroJourneyCtrl:getScore()
	return self.score
end
return heroJourneyCtrl
