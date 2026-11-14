local GameModule = include("GameModule")
local taskRushActivityCtrl = class("taskRushActivityCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function taskRushActivityCtrl:ctor(properties)
	taskRushActivityCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
end
function taskRushActivityCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_CLAIM_REWARD, handler(self, self.reqClaimRewardRsp))
	msgCtrl.register(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_CLAIM_CHEST, handler(self, self.reqClaimChestRsp))
	self:resetData()
	self:registerNotify()
	self:reqInit()
end
function taskRushActivityCtrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
end
function taskRushActivityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.TASK_RUSH_ACTIVITY, handler(self, self.notifyHandler))
end
function taskRushActivityCtrl:notifyHandler(content)
	dump(content, "taskRushActivityCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	local activityId
	for _, notifyMsg in ipairs(notifydata) do
		activityId = notifyMsg.data.activityId
		if notifyMsg.type == "refreshData" then
			self.data[tostring(activityId)] = notifyMsg.data.data
		end
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_TASKRUSH_UPDATE"
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = activityId
	SoraDSendMessage(ipairs(notifydata))
end
function taskRushActivityCtrl:getReceiveStatusAndNum(activityID)
	local count = self:getAllRewardNum(activityID)
	return 0 < count, count
end
function taskRushActivityCtrl:getQuestProgress(questID, activityID)
	local activityID = activityID or self.activityID
	if not self.data[tostring(activityID)].questData.questProgress then
		local _ENV, questProgress = self.data[tostring(activityID)].questData.questProgress, self.data[tostring(activityID)].questData.questProgress
	end
	return questProgress[tostring(questID)] or 0
end
function taskRushActivityCtrl:getQuestStatus(questID, activityID)
	local activityID = activityID or self.activityID
	local status = gBtnTargetStatusDef.GO
	if not self.data[tostring(activityID)].questData.questProgress then
		local _ENV, questProgress = self.data[tostring(activityID)].questData.questProgress, self.data[tostring(activityID)].questData.questProgress
	end
	if not self.data[tostring(activityID)].questData.claimedQuest then
		local _ENV, claimedQuest = self.data[tostring(activityID)].questData.claimedQuest, self.data[tostring(activityID)].questData.claimedQuest
	end
	if not self.data[tostring(activityID)].questData.finishedQuest then
		local _ENV, finishedQuest = self.data[tostring(activityID)].questData.finishedQuest, self.data[tostring(activityID)].questData.finishedQuest
	end
	if finishedQuest[tostring(questID)] and not claimedQuest[tostring(questID)] then
		status = gBtnTargetStatusDef.GET
	end
	if claimedQuest[tostring(questID)] then
		status = gBtnTargetStatusDef.GOT
	end
	return status
end
function taskRushActivityCtrl:getAllRewardNum(activityID)
	local taskRushActivityRead = include("taskRushActivityRead")
	local cfgDay = taskRushActivityRead.getActivityQuestMaxDay(activityID)
	local num = 0
	for i = 1, cfgDay do
		num = num + self:getDayRewardNum(i, activityID)
	end
	return num
end
function taskRushActivityCtrl:getDayRewardNum(day, activityID)
	local activityID = activityID or self.activityID
	if self:isBoxGot(activityID) or self:isBoxCanGet(activityID) then
		return 0
	end
	local taskRushActivityRead = include("taskRushActivityRead")
	local cfgQuestList = taskRushActivityRead.getQuestByDay(day, activityID)
	local num = 0
	if self.data[tostring(activityID)] then
		if not self.data[tostring(activityID)].questData.claimedQuest then
			local _ENV, claimedQuest = self.data[tostring(activityID)].questData.claimedQuest, self.data[tostring(activityID)].questData.claimedQuest
		end
		if not self.data[tostring(activityID)].questData.finishedQuest then
			local _ENV, finishedQuest = self.data[tostring(activityID)].questData.finishedQuest, self.data[tostring(activityID)].questData.finishedQuest
		end
		for k, v in ipairs(cfgQuestList) do
			if finishedQuest[tostring(v)] and not claimedQuest[tostring(v)] then
				num = num + 1
			end
		end
	end
	return num
end
function taskRushActivityCtrl:getDayGroupRewardNum(day, groupID, activityID)
	local activityID = activityID or self.activityID
	if self:isBoxGot(activityID) or self:isBoxCanGet(activityID) then
		return 0
	end
	local taskRushActivityRead = include("taskRushActivityRead")
	local cfgQuestList = taskRushActivityRead.getQuest(day, groupID, activityID)
	local num = 0
	if not self.data[tostring(activityID)].questData.claimedQuest then
		local _ENV, claimedQuest = self.data[tostring(activityID)].questData.claimedQuest, self.data[tostring(activityID)].questData.claimedQuest
	end
	if not self.data[tostring(activityID)].questData.finishedQuest then
		local _ENV, finishedQuest = self.data[tostring(activityID)].questData.finishedQuest, self.data[tostring(activityID)].questData.finishedQuest
	end
	for k, v in ipairs(cfgQuestList) do
		if finishedQuest[tostring(v)] and not claimedQuest[tostring(v)] then
			num = num + 1
		end
	end
	return num
end
function taskRushActivityCtrl:getCurOpenDay(activityID)
	local day = 1
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityID = activityID or self.activityID
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	if timer then
		local startTime = timer.starttime
		local beginUTC0Time = serviceFunctions.getTodayZeroHourUTC(startTime)
		local todayUTC0Time = serviceFunctions.getTodayZeroHourUTC()
		local openTime = todayUTC0Time - beginUTC0Time
		day = math.ceil(openTime / 86400) + 1
	end
	return math.max(1, day)
end
function taskRushActivityCtrl:getFinishQuestNum(activityID)
	local activityID = activityID or self.activityID
	if self.data[tostring(activityID)] then
		return self.data[tostring(activityID)].finishQuestNum
	else
		return 0
	end
end
function taskRushActivityCtrl:isBoxGot(activityID)
	local activityID = activityID or self.activityID
	if self.data[tostring(activityID)] then
		return self.data[tostring(activityID)].finishQuestNum == self.data[tostring(activityID)].rewardQuestNum
	else
		return false
	end
end
function taskRushActivityCtrl:isBoxCanGet(activityID)
	local curTime = serviceFunctions.systemTime()
	local questEffectTime = self:getActivityQuestEffectTime(activityID)
	return curTime > questEffectTime
end
function taskRushActivityCtrl:getActivityQuestEffectTime(activityID)
	local activityID = activityID or self.activityID
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local taskRushActivityRead = include("taskRushActivityRead")
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	local startTime = timer and timer.starttime or serviceFunctions.systemTime()
	local beginUTC0Time = serviceFunctions.getTodayZeroHourUTC(startTime)
	local questEffectTime = taskRushActivityRead.getActivityQuestEffectTime(activityID)
	local effectTime = beginUTC0Time + questEffectTime
	return effectTime
end
function taskRushActivityCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_INIT, nil)
end
function taskRushActivityCtrl:reqClaimReward(questId, activityID)
	local activityID = activityID or self.activityID
	serverproxy = nil
	;(nil).activityId = activityID
	;(nil).questId = questId
	serverproxy:Request(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_CLAIM_REWARD, nil)
end
function taskRushActivityCtrl:reqClaimChest(activityID)
	local activityID = activityID or self.activityID
	serverproxy = nil
	;(nil).activityId = activityID
	serverproxy:Request(gCmd.CMD_TASK_RUSH_ACTIVITY_MODULE, gCmd.REQ_TASK_RUSH_ACTIVITY_CLAIM_CHEST, nil)
end
function taskRushActivityCtrl:reqInitRsp(content)
	dump(content, "==taskRushActivityCtrl:reqInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.data = content.rspdata
	end
end
function taskRushActivityCtrl:reqClaimRewardRsp(content)
	dump(content, "==taskRushActivityCtrl:reqClaimRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.data[tostring(content.data.activityId)] = content.rspdata.data
	end
	_ENV = tostring(content.data.activityId)
	tostring(content.data.activityId).msg = "MESSAGE_ACTIVITY_TASKRUSH_UPDATE"
	SoraDSendMessage((tostring(content.data.activityId)))
end
function taskRushActivityCtrl:reqClaimChestRsp(content)
	dump(content, "==taskRushActivityCtrl:reqClaimChestRsp==", 20)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.data[tostring(content.data.activityId)] = content.rspdata.data
	end
	_ENV = tostring(content.data.activityId)
	tostring(content.data.activityId).msg = "MESSAGE_ACTIVITY_TASKRUSH_UPDATE"
	SoraDSendMessage((tostring(content.data.activityId)))
end
return taskRushActivityCtrl
