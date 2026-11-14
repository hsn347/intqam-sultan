local eventQuestRead = include("eventQuestRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local backToTopCtrl = class("backToTopCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local backToTopRead = include("backToTopRead")
function backToTopCtrl:ctor(properties)
	self.activityID = gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY
	backToTopCtrl.super.ctor(self, properties)
	self:resetData()
end
function backToTopCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_INIT, handler(self, self.backToTopInitRsp))
	msgCtrl.register(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_CLAIM_TASK, handler(self, self.backToTopClaimTaskRsp))
	msgCtrl.register(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_CLAIM_REWARD, handler(self, self.backToTopClaimRewardRsp))
	self:registerNotify()
	self:sendInit()
end
function backToTopCtrl:Logout()
	backToTopCtrl.super.Logout(self)
	self:resetData()
end
function backToTopCtrl:resetData()
	self.bUnlockFurther = false
	self.exp = 0
	self.rewardLevel = 0
	self.quest, (nil).claimedQuest, _UPVALUE0_, (nil).questProgress, _UPVALUE0_, _UPVALUE0_, self.furtherRewardLevel = nil, nil, nil, nil, nil, nil, 0
end
function backToTopCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BACK_TO_TOP, handler(self, self.notifyHandler))
end
function backToTopCtrl:notifyHandler(event)
	dump(event.data, "backToTopCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "progressUpdate" then
			if self.quest.questProgress then
				self.quest.questProgress[tostring(v.notifyData.questID)] = v.notifyData.progress
			end
			if v.notifyData.isFinish and self.quest.finishedQuest then
				self.quest.finishedQuest[tostring(v.notifyData.questID)] = 1
			end
		elseif v.notifyType == "updateFurther" then
			self.bUnlockFurther = v.bUnlockFurther
			_ENV = tostring(v.notifyData.questID)
			tostring(v.notifyData.questID).msg = "MESSAGE_SERVER_BACK_TO_TOP_UNLOCK"
			SoraDSendMessage((tostring(v.notifyData.questID)))
		elseif v.notifyType == "updateExp" then
			self.exp = v.exp
			_ENV = tostring(v.notifyData.questID)
			tostring(v.notifyData.questID).msg = "MESSAGE_SERVER_BACK_TO_TOP_EXP_GIFT"
			SoraDSendMessage((tostring(v.notifyData.questID)))
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_BACK_TO_TOP_REFRESH"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_BACK_TO_TOP_TASK_REFRESH"
	SoraDSendMessage(ipairs(event.data))
end
function backToTopCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_INIT, nil)
end
function backToTopCtrl:sendClaimTask(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_CLAIM_TASK, nil)
end
function backToTopCtrl:sendClaimReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BACK_TO_TOP_MODULE, gCmd.REQ_BACK_TO_TOP_CLAIM_REWARD, nil)
end
function backToTopCtrl:backToTopInitRsp(content)
	dump(content, "backToTopCtrl:backToTopInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		newStartMainCtrl:setActInitFlag(self.activityID)
		self.quest = content.rspdata.quest
		self.bUnlockFurther = content.rspdata.bUnlockFurther
		self.exp = content.rspdata.exp
		self.rewardLevel = content.rspdata.rewardLevel
		self.furtherRewardLevel = content.rspdata.furtherRewardLevel
	end
end
function backToTopCtrl:backToTopClaimTaskRsp(content)
	dump(content, "backToTopCtrl:backToTopClaimTaskRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(content.rspdata.claimedQuest) do
			self.quest.claimedQuest[k] = v
		end
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_BACK_TO_TOP_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_BACK_TO_TOP_TASK_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function backToTopCtrl:backToTopClaimRewardRsp(content)
	dump(content, "backToTopCtrl:backToTopClaimRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.furtherRewardLevel = content.rspdata.furtherRewardLevel
		self.rewardLevel = content.rspdata.rewardLevel
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_BACK_TO_TOP_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function backToTopCtrl:getTaskList()
	local groupNum = backToTopRead.getTaskGroupNum()
	local backToTopRead, quests
	for i = 1, groupNum do
		local taskList = backToTopRead.getTaskList(i)
		for k, v in ipairs(taskList) do
			if self.quest.finishedQuest[tostring(v)] and not self.quest.claimedQuest[tostring(v)] then
				quests[i] = v
				break
			end
			if self.quest.questProgress[tostring(v)] and not self.quest.finishedQuest[tostring(v)] then
				quests[i] = v
				break
			end
			if not self.quest.questProgress[tostring(v)] then
				quests[i] = v
				break
			end
			if self.quest.claimedQuest[tostring(v)] and k == #taskList then
				quests[i] = v
			end
		end
	end
	local backToTopRead, ret = (for index), 1
	for group, taskID in pairs(quests) do
		local questInfo = eventQuestRead.getTaskConfig(taskID)
		local taskStatus = gBtnTargetStatusDef.GO
		local progress = 0
		if self.quest.questProgress[tostring(taskID)] then
			progress = self.quest.questProgress[tostring(taskID)]
		end
		if self.quest.claimedQuest[tostring(taskID)] then
			taskStatus = gBtnTargetStatusDef.GOT
		elseif self.quest.finishedQuest[tostring(taskID)] then
			taskStatus = gBtnTargetStatusDef.GET
		end
		backToTopRead = taskID
		taskID.group = group
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
			return l.group < r.group
		else
			return l.taskStatus < r.taskStatus
		end
	end)
	return ret
end
function backToTopCtrl:getCurExp()
	return self.exp
end
function backToTopCtrl:isUnLockTop()
	return self.bUnlockFurther
end
function backToTopCtrl:getRewardLv()
	return self.rewardLevel
end
function backToTopCtrl:getFurtherRewardLv()
	return self.furtherRewardLevel
end
function backToTopCtrl:getTaskRewardNum()
	local num = 0
	for k, v in pairs(self.quest.finishedQuest) do
		if not self.quest.claimedQuest[k] then
			num = num + 1
		end
	end
	return num
end
function backToTopCtrl:getReceiveStatusAndNum()
	local num = 0
	num = self:getTaskRewardNum()
	local lv, curExp, nextExp = backToTopRead.getExpCfg(self.exp)
	if lv >= backToTopRead.getPeakLvCfgNum() then
		local _lv, _curExp, _nextExp = backToTopRead.getMaxLvAndExp(self.exp)
		lv = _lv
	end
	if 0 < lv and lv > self:getRewardLv() and self:getRewardLv() < backToTopRead.getPeakLvCfgNum() or self:isUnLockTop() and lv > self:getFurtherRewardLv() then
		num = num + 1
	end
	return 0 < num, num
end
return backToTopCtrl
