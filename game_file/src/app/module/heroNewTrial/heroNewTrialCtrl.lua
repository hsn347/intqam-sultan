local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local heroNewTrialCtrl = class("heroNewTrialCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local heroNewTrialRead = include("heroNewTrialRead")
function heroNewTrialCtrl:ctor(properties)
	heroNewTrialCtrl.super.ctor(self, properties)
	self:resetData()
	local constantRead = include("constantRead")
	self.afkTimeMax = constantRead.getConstValue("HERO_EXPERIENCE_AFK_MAX_TIME", 0)
end
function heroNewTrialCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_CLIAM, handler(self, self.reqCliamRsp))
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_GUIDE, handler(self, self.reqGuideRsp))
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_AFK_INIT, handler(self, self.reqAfkInitRsp))
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_AFK_CLIAM, handler(self, self.reqAfkCliamRsp))
	msgCtrl.register(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_GAME_WIN, handler(self, self.reqGameWinRsp))
	self:registerNotify()
	self:reqInitData()
end
function heroNewTrialCtrl:Logout()
	heroNewTrialCtrl.super.Logout(self)
	self:resetData()
end
function heroNewTrialCtrl:resetData()
	;(nil).guide, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	self.initData, (nil).receiveTime = nil, 0
end
function heroNewTrialCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_NEW_TRIAL, handler(self, self.notifyHandler))
end
function heroNewTrialCtrl:notifyHandler(event)
	dump(event.data, "heroNewTrialCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "updateData" then
			local questData = v.notifyData.questData
			self:getQuestComponent():setQuestData(questData)
		end
	end
end
function heroNewTrialCtrl:getQuestComponent(...)
	if not self.questComponent then
		local activityTaskComponent = include("activityTaskComponent")
		self.questComponent = activityTaskComponent.new()
	end
	return self.questComponent
end
function heroNewTrialCtrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_INIT, nil)
end
function heroNewTrialCtrl:reqInitDataRsp(content)
	dump(content, "heroNewTrialCtrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		local questData = self.initData.questData
		self:getQuestComponent():setQuestData(questData)
		self:setAfkReceiveTime(nil, content.rspdata.heroAfkReceiveTime)
	end
end
function heroNewTrialCtrl:reqCliam(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_CLIAM, nil)
end
function heroNewTrialCtrl:reqCliamRsp(content)
	dump(content, "heroNewTrialCtrl:reqCliamRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		self.initData = content.rspdata
		local questData = self.initData.questData
		self:getQuestComponent():setQuestData(questData)
		self:setAfkReceiveTime(nil, content.rspdata.heroAfkReceiveTime)
		_ENV = self
		self.msg = "MESSAGE_HERO_NEW_TRIAL_UPDATE"
		self.subMsg = "cliam"
		SoraDSendMessage(self)
	end
end
function heroNewTrialCtrl:reqGuide(heroID)
	serverproxy = nil
	;(nil).heroID = heroID
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_GUIDE, nil)
end
function heroNewTrialCtrl:reqGuideRsp(content)
	dump(content, "heroNewTrialCtrl:reqGuideRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function heroNewTrialCtrl:reqAfkInit(heroID)
	serverproxy = nil
	;(nil).heroID = heroID
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_AFK_INIT, nil)
end
function heroNewTrialCtrl:reqAfkInitRsp(content)
	dump(content, "heroNewTrialCtrl:reqAfkInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local heroID = content.data.heroID
		local rspdata = content.rspdata
		self:setAfkReceiveTime(heroID, rspdata.receiveTime)
		_ENV = self
		self.msg = "MESSAGE_HERO_NEW_TRIAL_UPDATE"
		self.subMsg = "afkInit"
		self.rewardMap = rspdata.rewardMap
		SoraDSendMessage(self)
	end
end
function heroNewTrialCtrl:reqAfkCliam(heroID)
	serverproxy = nil
	;(nil).heroID = heroID
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_AFK_CLIAM, nil)
end
function heroNewTrialCtrl:reqAfkCliamRsp(content)
	dump(content, "heroNewTrialCtrl:reqAfkCliamRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		local heroID = content.data.heroID
		local rspdata = content.rspdata
		self:setAfkReceiveTime(heroID, rspdata.receiveTime)
		_ENV = self
		self.msg = "MESSAGE_HERO_NEW_TRIAL_UPDATE"
		self.subMsg = "afkCliam"
		SoraDSendMessage(self)
	end
end
function heroNewTrialCtrl:reqGameWin(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_HERO_NEW_TRIAL_MODULE, gCmd.REQ_HERO_NEW_TRIAL_GAME_WIN, nil)
end
function heroNewTrialCtrl:reqGameWinRsp(content)
	dump(content, "heroNewTrialCtrl:reqGameWinRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function heroNewTrialCtrl:getCurStage(heroID)
	local taskList = heroNewTrialRead.getTaskList(heroID)
	for stage, cfg in ipairs(taskList) do
		if not self:getQuestComponent():isTaskClaimed(cfg.taskId) then
			return stage
		end
	end
	return #taskList + 1
end
function heroNewTrialCtrl:getReceiveStatusAndNum(heroID)
	local redNum = 0
	local ret, num = self:getTaskStatusAndNum(heroID)
	if ret then
		redNum = redNum + num
	end
	local ret, num = self:getAfkStatusAndNum(heroID)
	if ret then
		redNum = redNum + num
	end
	return 0 < redNum, redNum
end
function heroNewTrialCtrl:getTaskStatusAndNum(heroID)
	if not self:unlockTrial(heroID) then
		return false, 0
	end
	local taskList = heroNewTrialRead.getTaskList(heroID)
	for stage, cfg in ipairs(taskList) do
		local taskState = self:getQuestComponent():getTaskState(cfg.taskId)
		if taskState == gBtnTargetStatusDef.GET then
			return true, 1
		end
	end
	return false, 0
end
function heroNewTrialCtrl:getTrialAfkStatusAndNum()
	if not self:isOpenHeroTrial() then
		return false, 0
	end
	local afkTime = self:getAfkTime()
	if afkTime >= self.afkTimeMax / 2 then
		return true, 1
	end
	return false, 0
end
function heroNewTrialCtrl:getAfkStatusAndNum(heroID)
	if not self:unlockTrialAfk(heroID) then
		return false, 0
	end
	local afkTime = self:getAfkTime(heroID)
	if afkTime >= self.afkTimeMax / 2 then
		return true, 1
	end
	return false, 0
end
function heroNewTrialCtrl:getAllAfkStatusAndNum(...)
	local redNum = 0
	local heroIDList = SoraDGetCtrl("heroCtrl"):getHeroSSS()
	for __, heroID in ipairs(heroIDList) do
		local ret, num = self:getAfkStatusAndNum(heroID)
		if ret then
			redNum = redNum + num
		end
	end
	return 0 < redNum, redNum
end
function heroNewTrialCtrl:checkFinishGuide(heroID)
	local guide = self.initData.guide
	if guide and guide[tostring(heroID)] then
		return true
	else
		return false
	end
end
function heroNewTrialCtrl:getAfkReceiveTime(heroID)
	return self.initData.receiveTime or 0
end
function heroNewTrialCtrl:setAfkReceiveTime(heroID, time)
	self.initData.receiveTime = time
end
function heroNewTrialCtrl:getAfkTime(heroID)
	local receiveTime = self:getAfkReceiveTime(heroID)
	local afkTime = serviceFunctions.systemTime() - receiveTime
	afkTime = math.min(self.afkTimeMax, math.max(0, afkTime))
	return afkTime
end
function heroNewTrialCtrl:getAfkTimeMax(...)
	return self.afkTimeMax
end
function heroNewTrialCtrl:getAfkUnlockStage(heroID)
	return heroNewTrialRead.getStageMax(heroID)
end
function heroNewTrialCtrl:getStageTaskState(heroID, stage)
	local taskId = heroNewTrialRead.getTaskId(heroID, stage)
	local taskState = self:getQuestComponent():getTaskState(taskId)
	return taskState
end
function heroNewTrialCtrl:unlockTrialAfk(heroID)
	if not self:unlockTrial(heroID) then
		return false
	end
	local curStage = self:getCurStage(heroID)
	local afkUnlockStage = self:getAfkUnlockStage(heroID)
	if curStage <= afkUnlockStage then
		return false
	else
		return true
	end
end
function heroNewTrialCtrl:unlockTrial(heroID)
	return heroNewTrialRead.unlockTrial(heroID)
end
function heroNewTrialCtrl:isOpenHeroTrial()
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local list = heroCtrl:getHeroSSS()
	if #list == 0 then
		return false
	end
	local num = 0
	for _, v in ipairs(list) do
		if self:unlockTrialAfk(v) then
			num = num + 1
		end
	end
	return 0 < num
end
return heroNewTrialCtrl
