local beastCanyonRead = include("beastCanyonRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local beastCanyonCtrl = class("beastCanyonCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function beastCanyonCtrl:ctor(properties)
	beastCanyonCtrl.super.ctor(self, properties)
	self:resetData()
end
function beastCanyonCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_INIT, handler(self, self.reqDivineBeastCanyonInitRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_BUY_TIMES, handler(self, self.reqDivineBeastCanyonBuyTimesRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_CHALLENGE, handler(self, self.reqDivineBeastCanyonChallengeRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_SWEEP, handler(self, self.reqDivineBeastCanyonSweepRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_WEEK_REWARD, handler(self, self.reqDivineBeastCanyonWeekRewardRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_RANK_INFO, handler(self, self.reqDivineBeastCanyonRankInfoRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_INIT, handler(self, self.reqDivineBeastCanyonInitRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_BUY_TIMES, handler(self, self.reqDivineBeastCanyonBuyTimesRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_CHALLENGE, handler(self, self.reqDivineBeastCanyonChallengeRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_SWEEP, handler(self, self.reqDivineBeastCanyonSweepRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_WEEK_REWARD, handler(self, self.reqDivineBeastCanyonWeekRewardRsp))
	msgCtrl.register(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_RANK_INFO, handler(self, self.reqDivineBeastCanyonRankInfoRsp))
	self:registerNotify()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function beastCanyonCtrl:Logout()
	beastCanyonCtrl.super.Logout(self)
	self:resetData()
end
function beastCanyonCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function beastCanyonCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DIVINE_BEAST_CANYON, handler(self, self.notifyHandler))
	self.handle_notify2 = notifyCtrl:register(gNotifyID.ELITE_DIVINE_BEAST_CANYON, handler(self, self.notifyHandler2))
end
function beastCanyonCtrl:notifyHandler(event)
	dump(event.data, "beastCanyonCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refreshData" then
			self:setInitData(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY, v.data)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
			self.subMsg = "init"
			SoraDSendMessage(self)
		end
	end
end
function beastCanyonCtrl:notifyHandler2(event)
	dump(event.data, "beastCanyonCtrl:notifyHandler2", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refreshData" then
			self:setInitData(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650, v.data)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
			self.subMsg = "init"
			SoraDSendMessage(self)
		end
	end
end
function beastCanyonCtrl:newDay()
	self:sendReqInitDataMsg()
end
function beastCanyonCtrl:getActivityIDByCmd(cmd)
	if cmd == gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE then
		return gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
	else
		return gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	end
end
function beastCanyonCtrl:sendReqInitDataMsg()
	local activityID = gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	if commonCheck.DIVINEBEASTCANYON_SWITCH then
		self:reqDivineBeastCanyonInit(activityID)
	end
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
	if self:isOpen(activityID) then
		self:reqDivineBeastCanyonInit(activityID)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonInit(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_INIT, nil)
	else
		_ENV = nil
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_INIT, nil)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonInitRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonInitRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		self:setInitData(activityID, content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		self.subMsg = "init"
		self.activityID = activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		self.eventID = activityID
		SoraDSendMessage(self)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonBuyTimes(activityID, times)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_ENV = nil
		;(nil).times = times
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_BUY_TIMES, nil)
	else
		_ENV = nil
		;(nil).times = times
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_BUY_TIMES, nil)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonBuyTimesRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonBuyTimesRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		self:setInitData(activityID, content.rspdata)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_11"))
		_ENV = i18n("Divinebeastcanyon_text_11")
		i18n("Divinebeastcanyon_text_11").msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		i18n("Divinebeastcanyon_text_11").subMsg = "buyTimes"
		i18n("Divinebeastcanyon_text_11").activityID = activityID
		SoraDSendMessage(i18n("Divinebeastcanyon_text_11"))
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonChallenge(activityID, data)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_CHALLENGE, data)
	else
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_CHALLENGE, data)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonChallengeRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonChallengeRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		self:setInitData(activityID, content.rspdata.data)
		self:setLoseLift(activityID, content.rspdata.loseLife)
		self:setRewardList(activityID, content.rspdata.rewardList)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		self.subMsg = "challenge"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_DIVINE_BEAST_CANYON_BOSS_NOT_OPEN then
		local bossConfig = beastCanyonRead.getBossConfigByBossType(content.data.bossType)
		_ENV = nil
		;(nil).name = i18n(bossConfig.name)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_15", nil))
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonSweep(activityID, bossType, sweepNum)
	_ENV = nil
	;(nil).bossType = bossType
	local (nil).times, data = sweepNum, nil
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_SWEEP, data)
	else
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_SWEEP, data)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonSweepRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonSweepRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		self:setInitData(activityID, content.rspdata.data)
		_ENV = content.rspdata.data
		content.rspdata.data.activityID = activityID
		content.rspdata.data.resultType = 2
		content.rspdata.data.bossType = content.data.bossType
		content.rspdata.data.reward = content.rspdata.reward
		content.rspdata.data.damage = self:getTodayMaxLoseLife(activityID, content.data.bossType)
		uiManager:show("BeastCanyonResult", content.rspdata.data)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		uiManager.subMsg = "sweep"
		SoraDSendMessage(uiManager)
	elseif content.err == gErrDef.Err_DIVINE_BEAST_CANYON_BOSS_NOT_OPEN then
		local bossConfig = beastCanyonRead.getBossConfigByBossType(content.data.bossType)
		_ENV = self:getTodayMaxLoseLife(activityID, content.data.bossType)
		self:getTodayMaxLoseLife(activityID, content.data.bossType).name = i18n(bossConfig.name)
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_15", (self:getTodayMaxLoseLife(activityID, content.data.bossType))))
	elseif content.err == gErrDef.Err_DIVINE_BEAST_CANYON_NOT_CHALLENGE then
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_16"))
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonWeekReward(activityID, idx)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_ENV = nil
		;(nil).idx = idx
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_WEEK_REWARD, nil)
	else
		_ENV = nil
		;(nil).idx = idx
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_WEEK_REWARD, nil)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonWeekRewardRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonWeekRewardRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		local initData = self:getInitData(activityID)
		initData.weekReward[tostring(content.data.idx)] = 1
		_ENV = tostring(content.data.idx)
		tostring(content.data.idx).msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		tostring(content.data.idx).subMsg = "reward"
		SoraDSendMessage((tostring(content.data.idx)))
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonRankInfo(activityID, bossType)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_ENV = nil
		;(nil).bossType = bossType
		serverproxy:Request(gCmd.CMD_ELITE_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_ELITE_DIVINE_BEAST_CANYON_RANK_INFO, nil)
	else
		_ENV = nil
		;(nil).bossType = bossType
		serverproxy:Request(gCmd.CMD_DIVINE_BEAST_CANYON_MODULE, gCmd.REQ_DIVINE_BEAST_CANYON_RANK_INFO, nil)
	end
end
function beastCanyonCtrl:reqDivineBeastCanyonRankInfoRsp(content)
	dump(content, "beastCanyonCtrl:reqDivineBeastCanyonRankInfoRsp(content)", 10)
	local activityID = self:getActivityIDByCmd(content.cmd)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001547_UPDATE"
		gErrDef.Err_None.subMsg = "rank"
		gErrDef.Err_None.rankData = content.rspdata.rankData
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function beastCanyonCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		_UPVALUE0_ = self.activityData[activityID]
	end
	return self.activityData[activityID]
end
function beastCanyonCtrl:setActivityData(activityID, activityData)
	self.activityData[activityID] = activityData
end
function beastCanyonCtrl:getInitData(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.initData then
		_UPVALUE0_ = activityData.initData
	end
	return activityData.initData
end
function beastCanyonCtrl:setInitData(activityID, initData)
	local activityData = self:getActivityData(activityID)
	activityData.initData = initData
	self:setActivityData(activityID, activityData)
end
function beastCanyonCtrl:getChallengeTimes(activityID)
	local initData = self:getInitData(activityID)
	return initData.leftTimes or 0
end
function beastCanyonCtrl:isDeastStateChanged(activityID)
	local initData = self:getInitData(activityID)
	return initData.lastAddTime ~= 0
end
function beastCanyonCtrl:getNextAddTime(activityID)
	local initData = self:getInitData(activityID)
	return initData.lastAddTime + 7200
end
function beastCanyonCtrl:getBuyTimes(activityID)
	local initData = self:getInitData(activityID)
	return initData.todayBuyTimes or 0
end
function beastCanyonCtrl:getWeekTimes(activityID)
	local initData = self:getInitData(activityID)
	return initData.weekTimes or 0
end
function beastCanyonCtrl:getTaskList(activityID)
	local taskList = beastCanyonRead.getTaskList(activityID)
	table.sort(taskList, function(l, r)
		local lState = self:getTaskState(activityID, l.Index, l.num)
		local rState = self:getTaskState(activityID, r.Index, r.num)
		if lState == rState then
			return l.Index < r.Index
		else
			return lState < rState
		end
	end)
	return taskList
end
function beastCanyonCtrl:getTaskState(activityID, taskID, num)
	if self:isTaskClaimed(activityID, taskID) then
		return gBtnTargetStatusDef.GOT
	elseif self:isTaskFinished(activityID, num) then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function beastCanyonCtrl:isTaskClaimed(activityID, Index)
	local initData = self:getInitData(activityID)
	if initData and initData.weekReward and initData.weekReward[tostring(Index)] == 1 then
		return true
	end
	return false
end
function beastCanyonCtrl:isTaskFinished(activityID, num)
	return num <= self:getWeekTimes(activityID)
end
function beastCanyonCtrl:getTodayMaxLoseLife(activityID, bossType)
	local initData = self:getInitData(activityID)
	return initData.todayMaxLoseLife and initData.todayMaxLoseLife[tostring(bossType)]
end
function beastCanyonCtrl:getLoseLife(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.loseLife or 0
end
function beastCanyonCtrl:setLoseLift(activityID, loseLife)
	local activityData = self:getActivityData(activityID)
	activityData.loseLife = loseLife
	self:setActivityData(activityID, activityData)
end
function beastCanyonCtrl:getRewardList(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.rewardList then
		_UPVALUE0_ = activityData.rewardList
	end
	return activityData.rewardList
end
function beastCanyonCtrl:setRewardList(activityID, rewardList)
	local activityData = self:getActivityData(activityID)
	activityData.rewardList = rewardList
	self:setActivityData(activityID, activityData)
end
function beastCanyonCtrl:getReceiveStatusAndNum(activityID)
	if not self:checkActivityShow(activityID) then
		return false, 0
	end
	if self:isDeastStateChanged(activityID) then
		if 0 < self:getChallengeTimes(activityID) then
			return true, -1
		end
		if self:getTaskStatusAndNum(activityID) then
			return true, -1
		end
	end
	return false, -1
end
function beastCanyonCtrl:getTaskStatusAndNum(activityID)
	local taskList = beastCanyonRead.getTaskList(activityID)
	for i, v in ipairs(taskList) do
		if self:getTaskState(activityID, v.Index, v.num) == gBtnTargetStatusDef.GET then
			return true
		end
	end
	return false
end
function beastCanyonCtrl:checkActivityShow(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		if not self:isOpen(activityID) then
			return false
		end
		local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
		return divineBeastMarkCtrl:getIsFuncOpen()
	else
		if not commonCheck.DIVINEBEASTCANYON_SWITCH then
			return false
		end
		local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
		if not divineBeastCtrl:getIsCanyonUnlock() then
			return false
		end
		if not self:isDeastStateChanged(activityID) then
			return false
		end
		return true
	end
end
function beastCanyonCtrl:isOpen(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		local constantRead = include("constantRead")
		local openTime = constantRead.getConstValue("ELITEBEASTCANYON_SWITCH", 0)
		local curTime = serviceFunctions.systemTime()
		_UPVALUE2_ = nil
		;(nil)[1] = curTime
		;(nil)[2] = openTime
		dump(nil, "beastCanyonCtrl:isOpen")
		if openTime <= curTime then
			return true
		end
		return false
	else
		return commonCheck.DIVINEBEASTCANYON_SWITCH
	end
end
return beastCanyonCtrl
