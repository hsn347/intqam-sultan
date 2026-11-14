local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001684_Ctrl = class("activity_9001684_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001684_Read = include("activity_9001684_Read")
function activity_9001684_Ctrl:ctor(properties)
	activity_9001684_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.DONATE_METERIAL_ACTIVITY
	self:resetData()
end
function activity_9001684_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_NUM_RANK, handler(self, self.reqNumRankRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_BOSS_DMG_RANK, handler(self, self.reqBossDmgRankRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_GET_ALL_REWARD, handler(self, self.reqGetAllRewardRsp))
	msgCtrl.register(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_GET_BOSS_POS, handler(self, self.reqGetBossPosRsp))
	self:registerNotify()
end
function activity_9001684_Ctrl:Logout()
	activity_9001684_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001684_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).bossDmg = 0
	self.defaultData, (nil).infinityTask, _UPVALUE0_, (nil).stageRewards, _UPVALUE0_, (nil).dailyQuestData, _UPVALUE0_, (nil).questData, _UPVALUE0_, (nil).meterialNum = nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.bossPos = nil
end
function activity_9001684_Ctrl:initClientData(data)
	dump(data, "activity_9001684_Ctrl:initClientData===")
end
function activity_9001684_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DONATE_METERIAL, handler(self, self.notifyHandler))
end
function activity_9001684_Ctrl:notifyHandler(event)
	dump(event, "activity_9001678_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshData" then
			self.defaultData = notifyData
		elseif notifyType == "questProgressUpdate" then
			local taskType = activity_9001684_Read.getTaskType(notifyData.questID)
			if taskType == 1 then
				if not self.defaultData.dailyQuestData.questProgress then
					self.defaultData.dailyQuestData.questProgress, _ENV = nil, nil
				end
				self.defaultData.dailyQuestData.questProgress[tostring(notifyData.questID)] = notifyData.progress
				if notifyData.isFinish then
					if not self.defaultData.dailyQuestData.finishedQuest then
						self.defaultData.dailyQuestData.finishedQuest, _ENV = tostring(notifyData.questID), tostring(notifyData.questID)
					end
					self.defaultData.dailyQuestData.finishedQuest[tostring(notifyData.questID)] = 1
				end
			else
				if not self.defaultData.questData.questProgress then
					self.defaultData.questData.questProgress, _ENV = tostring(notifyData.questID), tostring(notifyData.questID)
				end
				self.defaultData.questData.questProgress[tostring(notifyData.questID)] = notifyData.progress
				if notifyData.isFinish then
					if not self.defaultData.questData.finishedQuest then
						self.defaultData.questData.finishedQuest, _ENV = tostring(notifyData.questID), tostring(notifyData.questID)
					end
					self.defaultData.questData.finishedQuest[tostring(notifyData.questID)] = 1
				end
			end
		elseif notifyType == "resetDailyQuest" then
			self.defaultData.dailyQuestData.questProgress, _ENV = self.defaultData.questData.finishedQuest, self.defaultData.questData.finishedQuest
			self.defaultData.dailyQuestData.finishedQuest, _ENV = self.defaultData.questData.finishedQuest, self.defaultData.questData.finishedQuest
			self.defaultData.dailyQuestData.claimedQuest, _ENV = self.defaultData.questData.finishedQuest, self.defaultData.questData.finishedQuest
		elseif notifyType == "infinityTask" then
			for k, data in pairs(notifyData) do
				if not self.defaultData.infinityTask[k] then
					self.defaultData.infinityTask[k], _ENV = nil, nil
				end
				self.defaultData.infinityTask[k].progress = data.progress
				self.defaultData.infinityTask[k].getedNum = data.getedNum or 0
			end
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001684_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_INIT, nil)
end
function activity_9001684_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001684_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001684_Ctrl:reqQuestReward(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_QUEST_REWARD, nil)
end
function activity_9001684_Ctrl:reqQuestRewardRsp(content)
	dump(content, "activity_9001684_Ctrl:reqQuestRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local questID = content.rspdata.questID
		local taskType = activity_9001684_Read.getTaskType(questID)
		if taskType == 1 then
			if not self.defaultData.dailyQuestData.claimedQuest then
				self.defaultData.dailyQuestData.claimedQuest, _ENV = 10, 10
			end
			self.defaultData.dailyQuestData.claimedQuest[tostring(questID)] = 1
		else
			if not self.defaultData.questData.claimedQuest then
				self.defaultData.questData.claimedQuest, _ENV = tostring(questID), tostring(questID)
			end
			self.defaultData.questData.claimedQuest[tostring(questID)] = 1
		end
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001684_Ctrl:reqStageReward(stageType, stageIdx)
	serverproxy = nil
	;(nil).stageType = stageType
	;(nil).stageIdx = stageIdx
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_STAGE_REWARD, nil)
end
function activity_9001684_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001684_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001684_Ctrl:reqNumRank(begin, count)
	serverproxy = nil
	;(nil).begin = begin
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_NUM_RANK, nil)
end
function activity_9001684_Ctrl:reqNumRankRsp(content)
	dump(content, "activity_9001684_Ctrl:reqNumRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
	if not content.rspdata then
		local _ENV, rspdata = content.rspdata, content.rspdata
	end
	_ENV = "activity_9001684_Ctrl:reqNumRankRsp(content)"
	;("activity_9001684_Ctrl:reqNumRankRsp(content)").msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
	;("activity_9001684_Ctrl:reqNumRankRsp(content)").key = "rank"
	if not rspdata.rank then
		_ENV = rspdata.rank
	end
	;("activity_9001684_Ctrl:reqNumRankRsp(content)").rankList = rspdata.rank
	;("activity_9001684_Ctrl:reqNumRankRsp(content)").myInfo = rspdata.myInfo
	SoraDSendMessage("activity_9001684_Ctrl:reqNumRankRsp(content)")
end
function activity_9001684_Ctrl:reqBossDmgRank(begin, count)
	serverproxy = nil
	;(nil).begin = begin
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_BOSS_DMG_RANK, nil)
end
function activity_9001684_Ctrl:reqBossDmgRankRsp(content)
	dump(content, "activity_9001684_Ctrl:reqBossDmgRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
	if not content.rspdata then
		local _ENV, rspdata = content.rspdata, content.rspdata
	end
	_ENV = "activity_9001684_Ctrl:reqBossDmgRankRsp(content)"
	;("activity_9001684_Ctrl:reqBossDmgRankRsp(content)").msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
	;("activity_9001684_Ctrl:reqBossDmgRankRsp(content)").key = "rank"
	if not rspdata.rank then
		_ENV = rspdata.rank
	end
	;("activity_9001684_Ctrl:reqBossDmgRankRsp(content)").rankList = rspdata.rank
	;("activity_9001684_Ctrl:reqBossDmgRankRsp(content)").myInfo = rspdata.myInfo
	SoraDSendMessage("activity_9001684_Ctrl:reqBossDmgRankRsp(content)")
end
function activity_9001684_Ctrl:reqTaskReward(taskType)
	serverproxy = nil
	;(nil).taskType = taskType
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_TASK_REWARD, nil)
end
function activity_9001684_Ctrl:reqTaskRewardRsp(content)
	dump(content, "activity_9001684_Ctrl:reqTaskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001684_Ctrl:reqGetAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_GET_ALL_REWARD, nil)
end
function activity_9001684_Ctrl:reqGetAllRewardRsp(content)
	dump(content, "activity_9001684_Ctrl:reqGetAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001684_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
end
function activity_9001684_Ctrl:reqGetBossPos()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DONATE_METERIAL_MODULE, gCmd.REQ_DONATE_METERIAL_GET_BOSS_POS, nil)
end
function activity_9001684_Ctrl:reqGetBossPosRsp(content)
	dump(content, "activity_9001684_Ctrl:reqGetAllRewardRsp(content)", 10)
	_UPVALUE2_ = "activity_9001684_Ctrl:reqGetAllRewardRsp(content)"
	;("activity_9001684_Ctrl:reqGetAllRewardRsp(content)")[1] = 608
	;("activity_9001684_Ctrl:reqGetAllRewardRsp(content)")[2] = 600
	local cfgPos = include("constantRead").getConstValueArray("COLLECT_ACTIVITY_BOSS_COORDINATE", "activity_9001684_Ctrl:reqGetAllRewardRsp(content)")
	local pos = include("mapSyncUtilClient").serverTOClientPos(cc.p(cfgPos[1], cfgPos[2]))
	if content.err == gErrDef.Err_None then
		pos = include("mapSyncUtilClient").serverTOClientPos(cc.p(content.rspdata.x, content.rspdata.y))
	end
	self.bossPos = pos
	_ENV = cc.p(content.rspdata.x, content.rspdata.y)
	cc.p(content.rspdata.x, content.rspdata.y).msg = "MESSAGE_ACTIVITY_9001684_BOSS"
	cc.p(content.rspdata.x, content.rspdata.y).pos = pos
	SoraDSendMessage(cc.p(content.rspdata.x, content.rspdata.y))
end
function activity_9001684_Ctrl:getReceiveStatusAndNum()
	local num = self:getTaskStatusAndNum(1) + self:getTaskStatusAndNum(2) + self:getTaskStatusAndNum(3)
	return 0 < num, -1
end
function activity_9001684_Ctrl:getTaskStatusAndNum(taskType)
	local taskList = taskType == 3 and activity_9001684_Read.getInfiniityTaskCfg() or activity_9001684_Read.getTaskCfg(taskType)
	local num = 0
	for k, v in ipairs(taskList) do
		local status = self:getTaskStatus(v.taskId or v.taskType, taskType == 3)
		if status == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001684_Ctrl:getStageBoxStatues(stageType, stageLevel)
	if not self.defaultData.stageRewards[tostring(stageType)] then
		local _ENV, stageData = self.defaultData.stageRewards[tostring(stageType)], self.defaultData.stageRewards[tostring(stageType)]
	end
	local state = stageData[tostring(stageLevel)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	local stageLevelCfg = activity_9001684_Read.getStageLevelCfg(stageType, stageLevel)
	local num = stageType == 1 and self:getMeterialNum() or self:getBossDmg()
	if state ~= gBtnTargetStatusDef.GOT and num >= stageLevelCfg.stageNum then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001684_Ctrl:getTaskProgress(taskId, isInfinity)
	local progress = 0
	if isInfinity then
		local cfg = activity_9001684_Read.getInfiniityTaskCfgByIndex(taskId)
		if not self.defaultData.infinityTask[tostring(taskId)] then
			local activity_9001684_Read, info = self.defaultData.infinityTask[tostring(taskId)], self.defaultData.infinityTask[tostring(taskId)]
		end
		return (info.progress or 0) - (info.getedNum or 0) * cfg.taskNum
	else
		local taskType = activity_9001684_Read.getTaskType(taskId)
		local info = taskType == 1 and self.defaultData.dailyQuestData or self.defaultData.questData
		if not info.questProgress then
			local activity_9001684_Read, questProgress = info.questProgress, info.questProgress
		end
		return questProgress[tostring(taskId)] or 0
	end
	return progress
end
function activity_9001684_Ctrl:getTaskStatus(taskId, isInfinity)
	local status = gBtnTargetStatusDef.GO
	if isInfinity then
		local cfg = activity_9001684_Read.getInfiniityTaskCfgByIndex(taskId)
		if not self.defaultData.infinityTask[tostring(taskId)] then
			local _ENV, info = self.defaultData.infinityTask[tostring(taskId)], self.defaultData.infinityTask[tostring(taskId)]
		end
		local total = math.floor((info.progress or 0) / cfg.taskNum)
		local left = total - (info.getedNum or 0)
		if 0 < left then
			status = gBtnTargetStatusDef.GET
		end
	else
		local taskType = activity_9001684_Read.getTaskType(taskId)
		local info = taskType == 1 and self.defaultData.dailyQuestData or self.defaultData.questData
		if not info.claimedQuest then
			local _ENV, claimedQuest = info.claimedQuest, info.claimedQuest
		end
		if claimedQuest[tostring(taskId)] then
			status = gBtnTargetStatusDef.GOT
		else
			if not info.finishedQuest then
				local _ENV, finishedQuest = info.finishedQuest, info.finishedQuest
			end
			if finishedQuest[tostring(taskId)] then
				status = gBtnTargetStatusDef.GET
			end
		end
	end
	return status
end
function activity_9001684_Ctrl:getMeterialNum()
	return self.defaultData.meterialNum or 0
end
function activity_9001684_Ctrl:getBossDmg()
	return self.defaultData.bossDmg or 0
end
function activity_9001684_Ctrl:getBossPos()
	return self.bossPos
end
function activity_9001684_Ctrl:getBossChallengeTime()
	local constantRead = include("constantRead")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local monsterLimitTime = constantRead.getConstValue("COLLECT_CHALLENGE_MONSTER_FIGHTTIME_LIMIT", 300)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	return eventTime.timerNode.timer:getRemainTime() - monsterLimitTime
end
return activity_9001684_Ctrl
