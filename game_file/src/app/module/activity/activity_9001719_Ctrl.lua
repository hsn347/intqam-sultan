local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001719_Ctrl = class("activity_9001719_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001719_Read = include("activity_9001719_Read")
function activity_9001719_Ctrl:ctor(properties)
	activity_9001719_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_CARPET
	self:resetData()
end
function activity_9001719_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_GAME_BEGIN, handler(self, self.reqGameBeginRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_GAME_END, handler(self, self.reqGameEndRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_BATTLE_PASS_ALL_REWARD, handler(self, self.reqPassAllRewardRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_PLAYER_RANK, handler(self, self.reqPlayerRankRsp))
	self:registerNotify()
end
function activity_9001719_Ctrl:Logout()
	activity_9001719_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001719_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).opencount = 0
	;(nil).score = 0
	;(nil).gameBeginTime = nil
	;(nil).isAdvanceBattlePass = false
	;(nil).gotNormalBattlePassLv = 0
	_UPVALUE3_, (nil).recharge, _UPVALUE0_, (nil).gotAdvanceBattlePassLv = nil, nil, nil, 0
	;(nil).gotStageReward, _UPVALUE0_, (nil).gotTaskReward, _UPVALUE0_, (nil).task, (nil)[1] = nil, nil, nil, nil, nil, 0
	;(nil).gotStageReward, _UPVALUE0_, (nil).gotTaskReward, _UPVALUE0_, (nil).task, (nil)[2] = nil, nil, nil, nil, nil, 0
	;(nil).gotStageReward, _UPVALUE0_, (nil).gotTaskReward, _UPVALUE0_, (nil).task, (nil)[3] = nil, nil, nil, nil, nil, 0
	self.defaultData, (nil).isGuideComplete = nil, nil
end
function activity_9001719_Ctrl:initClientData(data)
	dump(data, "activity_9001719_Ctrl:initClientData===")
	if data then
		self.defaultData = data
	end
end
function activity_9001719_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MAGIC_CARPET, handler(self, self.notifyHandler))
end
function activity_9001719_Ctrl:notifyHandler(event)
	dump(event, "activity_9001719_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "data" then
			self.defaultData = notifyData
		elseif notifyType == "buyGift" then
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001719_BUYGIFT"
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001719_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001719_Ctrl:reqGameBegin()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_GAME_BEGIN, nil)
end
function activity_9001719_Ctrl:reqGameBeginRsp(content)
	dump(content, "activity_9001719_Ctrl:reqNewGameRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001719_NEWGAME"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001719_Ctrl:reqGameEnd(secs, score)
	serverproxy = nil
	;(nil).secs = secs
	;(nil).score = score
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_GAME_END, nil)
end
function activity_9001719_Ctrl:reqGameEndRsp(content)
	dump(content, "activity_9001719_Ctrl:reqEndGameRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001719_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001719_Ctrl:reqPassAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_BATTLE_PASS_ALL_REWARD, nil)
end
function activity_9001719_Ctrl:reqPassAllRewardRsp(content)
	dump(content, "activity_9001719_Ctrl:reqPassAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001719_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001719_Ctrl:reqTaskReward(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_TASK_REWARD, nil)
end
function activity_9001719_Ctrl:reqTaskRewardRsp(content)
	dump(content, "activity_9001719_Ctrl:reqTaskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001719_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001719_Ctrl:reqStageReward(stageId)
	serverproxy = nil
	;(nil).stageId = stageId
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_STAGE_REWARD, nil)
end
function activity_9001719_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001719_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001719_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001719_Ctrl:reqPlayerRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin or 1
	;(nil).nCount = nCount or 200
	serverproxy:Request(gCmd.CMD_MAGIC_CARPET_MODULE, gCmd.REQ_MAGIC_CARPET_PLAYER_RANK, nil)
end
function activity_9001719_Ctrl:reqPlayerRankRsp(content)
	dump(content, "activity_9001719_Ctrl:reqPlayerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001719_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001719_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local rewardNum = self:getTaskRewardNum() + self:getStageRewardNum()
	local signNum = self:isHaveSignReward() and 1 or 0
	num = num + signNum
	local costID = include("constantRead").getConstValue("MAGIC_CARPET_STAR_COST", 878001)
	if 0 < SoraDGetCtrl("backpackCtrl"):getItemCount(costID) then
		num = num + 1
	end
	return 0 < num or 0 < rewardNum, 0 < rewardNum and rewardNum or -1
end
function activity_9001719_Ctrl:getClassType()
	return SoraDGetActivityClassType(self.activityID)
end
function activity_9001719_Ctrl:getScore()
	return self.defaultData.score or 0
end
function activity_9001719_Ctrl:getBestScore()
	return self.defaultData.task[3] or 0
end
function activity_9001719_Ctrl:getUnlockAdv()
	return self.defaultData.isAdvanceBattlePass or false
end
function activity_9001719_Ctrl:getTaskPregress(taskType)
	return self.defaultData.task[taskType] or 0
end
function activity_9001719_Ctrl:getTaskStatus(taskId, taskType, parameter)
	local status = gBtnTargetStatusDef.GO
	if self.defaultData.gotTaskReward[taskId] == true then
		status = gBtnTargetStatusDef.GOT
	elseif parameter <= self:getTaskPregress(taskType) then
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function activity_9001719_Ctrl:getStageBoxStatues(stage, point)
	local stageData = self.defaultData.gotStageReward[stage]
	local state = stageData == true and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getScore() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001719_Ctrl:isHaveSignReward()
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	local lvList = activity_9001719_Read.getBattlepassCfg()
	local ret = false
	for k, v in ipairs(lvList) do
		if openDay >= v.lv and self.defaultData.gotNormalBattlePassLv < v.lv then
			ret = true
		end
		if self:getUnlockAdv() and openDay >= v.lv and self.defaultData.gotAdvanceBattlePassLv < v.lv then
			ret = true
		end
	end
	return ret
end
function activity_9001719_Ctrl:getSignLvStatus(lv, isAdv)
	local status = 0
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	if isAdv then
		status = 0
		if self:getUnlockAdv() then
			if lv <= self.defaultData.gotAdvanceBattlePassLv then
				status = 3
			elseif lv <= openDay then
				status = 1
			end
		end
	else
		status = 2
		if lv <= self.defaultData.gotNormalBattlePassLv then
			status = 3
		elseif lv <= openDay then
			status = 1
		end
	end
	return status
end
function activity_9001719_Ctrl:getStageRewardNum()
	local stageCfg = activity_9001719_Read.getStageCfg()
	local num = 0
	for k, v in ipairs(stageCfg) do
		if self:getStageBoxStatues(v.stageId, v.stage) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001719_Ctrl:getTaskRewardNum()
	if not activity_9001719_Read.getTaskCfg(self:getClassType()) then
		local activity_9001719_Read, taskCfg = activity_9001719_Read.getTaskCfg(self:getClassType()), activity_9001719_Read.getTaskCfg(self:getClassType())
	end
	local num = 0
	for k, v in ipairs(taskCfg) do
		if self:getTaskStatus(v.taskId, v.taskType, v.parameter) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001719_Ctrl:isNeedGuide()
	return not self.defaultData.isGuideComplete
end
return activity_9001719_Ctrl
