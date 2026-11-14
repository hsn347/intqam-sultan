local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001703_Ctrl = class("activity_9001703_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001703_Ctrl:ctor(properties)
	activity_9001703_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.BALLOON_HUNTER_ACTIVITY
	self:resetData()
end
function activity_9001703_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_NEW_GAME, handler(self, self.reqNewGameRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_UPGRADE_SKILL, handler(self, self.reqUpgradeSkillRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_KILL_MONSTER, handler(self, self.reqKillMonsterRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_MONSTER_ATTACK, handler(self, self.reqMonsterAttackRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_SCORE_RANK, handler(self, self.reqScoreRankRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_END_GAME, handler(self, self.reqEndGameRsp))
	msgCtrl.register(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_SELECT_SKILL, handler(self, self.reqSelectSkillRsp))
	self:registerNotify()
end
function activity_9001703_Ctrl:Logout()
	activity_9001703_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001703_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).classType = 0
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).isAdvanceRewardUnlock = false
	;(nil).inGame = false
	;(nil).maxScore = 0
	;(nil).coinNum = 0
	;(nil).score = 0
	;(nil).lv = 0
	_UPVALUE0_, (nil).exp = nil, 0
	;(nil)["1"] = 1
	;(nil)["2"] = 1
	;(nil).skill, _UPVALUE0_, (nil).baseSkill, (nil)["3"] = nil, nil, nil, 1
	;(nil).blood = 0
	;(nil).killMonsterNum = 0
	;(nil).gameTimes = 0
	;(nil).maxKillMonsterNum = 0
	;(nil).stageReward, _UPVALUE0_, (nil).taskReward, _UPVALUE0_, (nil).totalKillMonsterNum = nil, nil, nil, nil, 0
	;(nil).totalScore = 0
	self.defaultData, (nil).isGuideComplete = nil, false
end
function activity_9001703_Ctrl:initClientData(data)
	dump(data, "activity_9001703_Ctrl:initClientData===")
end
function activity_9001703_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BALLOON_HUNTER, handler(self, self.notifyHandler))
end
function activity_9001703_Ctrl:notifyHandler(event)
	dump(event, "activity_9001703_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshData" then
			self.defaultData = notifyData
		elseif notifyType == "buyGift" then
			self.defaultData = notifyData.initData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001703_BUYGIFT"
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001703_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_INIT, nil)
end
function activity_9001703_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001703_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_REWARD, nil)
end
function activity_9001703_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001703_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001703_Ctrl:reqNewGame()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_NEW_GAME, nil)
end
function activity_9001703_Ctrl:reqNewGameRsp(content)
	dump(content, "activity_9001703_Ctrl:reqNewGameRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_NEWGAME"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqUpgradeSkill(skillId)
	serverproxy = nil
	;(nil).skillId = skillId
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_UPGRADE_SKILL, nil)
end
function activity_9001703_Ctrl:reqUpgradeSkillRsp(content)
	dump(content, "activity_9001703_Ctrl:reqUpgradeSkillRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqSelectSkill(skillId)
	serverproxy = nil
	;(nil).skillId = skillId
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_SELECT_SKILL, nil)
end
function activity_9001703_Ctrl:reqSelectSkillRsp(content)
	dump(content, "activity_9001703_Ctrl:reqSelectSkillRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqKillMonster(monsterList)
	serverproxy = nil
	;(nil).monsterList = monsterList
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_KILL_MONSTER, nil)
end
function activity_9001703_Ctrl:reqKillMonsterRsp(content)
	dump(content, "activity_9001703_Ctrl:reqKillMonsterRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local randomSkill = content.rspdata.randomSkill
		if randomSkill and next(randomSkill) then
			_ENV = randomSkill
			randomSkill.msg = "MESSAGE_ACTIVITY_9001703_RANDOMSKILL"
			randomSkill.randomSkill = randomSkill
			SoraDSendMessage(randomSkill)
		end
		_ENV = randomSkill
		randomSkill.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(randomSkill)
	end
end
function activity_9001703_Ctrl:reqMonsterAttack(monsterList)
	serverproxy = nil
	;(nil).monsterList = monsterList
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_MONSTER_ATTACK, nil)
end
function activity_9001703_Ctrl:reqMonsterAttackRsp(content)
	dump(content, "activity_9001703_Ctrl:reqMonsterAttackRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqTaskReward(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_TASK_REWARD, nil)
end
function activity_9001703_Ctrl:reqTaskRewardRsp(content)
	dump(content, "activity_9001703_Ctrl:reqTaskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001703_Ctrl:reqStageReward(stageId)
	serverproxy = nil
	;(nil).stageId = stageId
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_STAGE_REWARD, nil)
end
function activity_9001703_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001703_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001703_Ctrl:reqScoreRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_SCORE_RANK, nil)
end
function activity_9001703_Ctrl:reqScoreRankRsp(content)
	dump(content, "activity_9001703_Ctrl:reqScoreRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:reqEndGame()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BALLOON_HUNTER_MODULE, gCmd.REQ_BALLOON_HUNTER_END_GAME, nil)
end
function activity_9001703_Ctrl:reqEndGameRsp(content)
	dump(content, "activity_9001703_Ctrl:reqEndGameRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001703_ENDGAME"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001703_Ctrl:getReceiveStatusAndNum()
	local num = self:isHaveSignReward() and 1 or 0
	num = num + self:getTaskRewardNum() + self:getStageRewardNum()
	return 0 < num, num
end
function activity_9001703_Ctrl:getCoinNum()
	return self.defaultData.coinNum
end
function activity_9001703_Ctrl:getBaseSkillLv(basicId)
	return self.defaultData.baseSkill[tostring(basicId)] or 1
end
function activity_9001703_Ctrl:getSkillLv(skillId)
	return self.defaultData.skill[tostring(skillId)] or 0
end
function activity_9001703_Ctrl:getSkillLvEffect(skillId, lv)
	local activity_9001703_Read = include("activity_9001703_Read")
	local lv = lv or self:getSkillLv(skillId)
	local cfg = activity_9001703_Read.getSkillData(skillId, lv)
	local val = cfg and cfg.effect or 0
	local valShow = val
	if skillId <= 3 then
		valShow = val .. "%"
	end
	return val, valShow
end
function activity_9001703_Ctrl:getBaseSkillVal(basicId)
	local activity_9001703_Read = include("activity_9001703_Read")
	local lv = self:getBaseSkillLv(basicId)
	local cfg = activity_9001703_Read.getBasicSkillData(basicId, lv)
	local effectStr = cfg.basicEffect
	if basicId == 1 then
		effectStr = "+" .. cfg.basicEffect
	elseif basicId == 2 then
		_ENV = nil
		;(nil).num = cfg.basicEffect
		effectStr = i18n("balloon_hunter_042", nil)
	elseif basicId == 3 then
		effectStr = "+" .. cfg.basicEffect .. "%"
	end
	return cfg.basicEffect, effectStr
end
function activity_9001703_Ctrl:getPowerVal(skillId)
	local activity_9001703_Read = include("activity_9001703_Read")
	if skillId == 1 then
		local baseLv = self:getBaseSkillLv(skillId)
		local cfg = activity_9001703_Read.getBasicSkillData(skillId, baseLv)
		local skillLv = self:getSkillLv(skillId)
		local skillCfg = activity_9001703_Read.getSkillData(skillId, skillLv)
		local val = cfg.basicEffect
		if skillCfg then
			val = cfg.basicEffect * (1 + skillCfg.effect / 100)
		end
		return val
	elseif skillId == 2 then
		local baseLv = self:getBaseSkillLv(skillId)
		local cfg = activity_9001703_Read.getBasicSkillData(skillId, baseLv)
		local skillLv = self:getSkillLv(skillId)
		local skillCfg = activity_9001703_Read.getSkillData(skillId, skillLv)
		local val = cfg.basicEffect
		if skillCfg then
			val = cfg.basicEffect * (1 - skillCfg.effect / 100)
		end
		return val
	else
		return self:getSkillLvEffect(skillId)
	end
end
function activity_9001703_Ctrl:getClassType()
	return self.defaultData.classType or 1
end
function activity_9001703_Ctrl:getTaskStatus(taskId, taskType, parameter)
	local status = gBtnTargetStatusDef.GO
	if self.defaultData.taskReward[tostring(taskId)] then
		status = gBtnTargetStatusDef.GOT
	elseif taskType == 1 and parameter <= self:getGameTimes() then
		status = gBtnTargetStatusDef.GET
	elseif taskType == 2 and parameter <= self:getMaxKillMonsterNum() then
		status = gBtnTargetStatusDef.GET
	elseif taskType == 3 and parameter <= self:getTotalKillMonsterNum() then
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function activity_9001703_Ctrl:getGameTimes()
	return self.defaultData.gameTimes or 0
end
function activity_9001703_Ctrl:getKillMonsterNum()
	return self.defaultData.killMonsterNum or 0
end
function activity_9001703_Ctrl:getMaxKillMonsterNum()
	return self.defaultData.maxKillMonsterNum or 0
end
function activity_9001703_Ctrl:getTotalKillMonsterNum()
	return self.defaultData.totalKillMonsterNum or 0
end
function activity_9001703_Ctrl:isHaveSignReward()
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	local activity_9001703_Read = include("activity_9001703_Read")
	local lvList = activity_9001703_Read.getBattlepassCfg()
	local ret = false
	for k, v in ipairs(lvList) do
		if openDay >= v.lv and self.defaultData.signRewardLv < v.lv then
			ret = true
		end
		if self:getUnlockAdv() and openDay >= v.lv and self.defaultData.signRewardLvPay < v.lv then
			ret = true
		end
	end
	return ret
end
function activity_9001703_Ctrl:getSignLvStatus(lv, isAdv)
	local status = 0
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	if isAdv then
		status = 0
		if self:getUnlockAdv() then
			if lv <= self.defaultData.signRewardLvPay then
				status = 3
			elseif lv <= openDay then
				status = 1
			end
		end
	else
		status = 2
		if lv <= self.defaultData.signRewardLv then
			status = 3
		elseif lv <= openDay then
			status = 1
		end
	end
	return status
end
function activity_9001703_Ctrl:getUnlockAdv()
	return self.defaultData.isAdvanceRewardUnlock or false
end
function activity_9001703_Ctrl:getScore()
	return self.defaultData.score or 0
end
function activity_9001703_Ctrl:isInGame()
	return self.defaultData.inGame or false
end
function activity_9001703_Ctrl:getExp()
	return self.defaultData.exp or 0
end
function activity_9001703_Ctrl:getLv()
	return self.defaultData.lv or 0
end
function activity_9001703_Ctrl:getBlood()
	return self.defaultData.blood or 0
end
function activity_9001703_Ctrl:getTotalScore()
	return self.defaultData.totalScore or 0
end
function activity_9001703_Ctrl:getStageBoxStatues(stage, point)
	local stageData = self.defaultData.stageReward[tostring(stage)]
	local state = stageData and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getTotalScore() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001703_Ctrl:getStageRewardNum()
	local activity_9001703_Read = include("activity_9001703_Read")
	local stageCfg = activity_9001703_Read.getStageCfg()
	local num = 0
	for k, v in ipairs(stageCfg) do
		if self:getStageBoxStatues(v.stageId, v.stage) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001703_Ctrl:getTaskRewardNum()
	local activity_9001703_Read = include("activity_9001703_Read")
	if not activity_9001703_Read.getTaskCfg(self:getClassType()) then
		local _ENV, taskCfg = activity_9001703_Read.getTaskCfg(self:getClassType()), activity_9001703_Read.getTaskCfg(self:getClassType())
	end
	local num = 0
	for k, v in ipairs(taskCfg) do
		if self:getTaskStatus(v.taskId, v.taskType, v.parameter) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001703_Ctrl:isNeedGuide()
	return not self.defaultData.isGuideComplete
end
return activity_9001703_Ctrl
