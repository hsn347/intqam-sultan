local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001706_Ctrl = class("activity_9001706_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001706_Ctrl:ctor(properties)
	activity_9001706_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SULTAN_COIN_PRESENT_ACTIVITY
	self:resetData()
end
function activity_9001706_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_MONTH_REWARD, handler(self, self.reqMonthRewardRsp))
	msgCtrl.register(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_SERVER_REWARD, handler(self, self.reqServerRewardRsp))
	self:registerNotify()
end
function activity_9001706_Ctrl:Logout()
	activity_9001706_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001706_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).isPayServerRewardUnlock, _UPVALUE0_, (nil).payServerReward, _UPVALUE0_, (nil).freeServerReward, _UPVALUE0_, (nil).monthReward, _UPVALUE0_, (nil).stageReward, _UPVALUE0_, (nil).costSultanCoin = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.defaultData, (nil).peopleNumber = nil, 0
end
function activity_9001706_Ctrl:initClientData(data)
	dump(data, "activity_9001706_Ctrl:initClientData===")
	if data then
		self.defaultData = data
	end
end
function activity_9001706_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SULTAN_COIN_PRESENT, handler(self, self.notifyHandler))
end
function activity_9001706_Ctrl:notifyHandler(event)
	dump(event, "activity_9001706_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "refreshData" then
			self.defaultData = v.notifyData
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001706_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001706_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_INIT, nil)
end
function activity_9001706_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001678_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001706_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001706_Ctrl:sendStageReward(stageId)
	serverproxy = nil
	;(nil).stageId = stageId
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_STAGE_REWARD, nil)
end
function activity_9001706_Ctrl:reqStageRewardRsp(content)
	dump(content, "activity_9001678_Ctrl:reqStageRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001706_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001706_Ctrl:sendMonthReward(month)
	serverproxy = nil
	;(nil).month = month
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_MONTH_REWARD, nil)
end
function activity_9001706_Ctrl:reqMonthRewardRsp(content)
	dump(content, "activity_9001678_Ctrl:reqMonthRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001706_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001706_Ctrl:sendServerReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SULTAN_COIN_PRESENT_MODULE, gCmd.REQ_SULTAN_COIN_PRESENT_SERVER_REWARD, nil)
end
function activity_9001706_Ctrl:reqServerRewardRsp(content)
	dump(content, "activity_9001678_Ctrl:reqServerRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001706_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001706_Ctrl:getReceiveStatusAndNum()
	local num = self:getPersonRewardNum() + self:getServerRewardNum()
	return 0 < num, num
end
function activity_9001706_Ctrl:getPersonRewardNum()
	local doStage = self:getDoStage()
	local num = 0
	local activity_9001706_Read = include("activity_9001706_Read")
	local stageCfg = activity_9001706_Read.getStageCfg()
	for k, v in ipairs(stageCfg) do
		if self:getCostSultanCoin() >= v.point and not self.defaultData.stageReward[tostring(v.index)] then
			num = num + 1
		end
	end
	if doStage == 1 and 0 < self:getCostSultanCoin() then
		local personalCfg = activity_9001706_Read.getPersonalCfg()
		for k, v in ipairs(personalCfg) do
			local leftTime = serviceFunctions.getNextMonthDayTime(self:getActivityBeginTime(), v.rewardID - 1)
			if not self.defaultData.monthReward[tostring(v.rewardID)] and leftTime <= 0 then
				num = num + 1
			end
		end
	end
	return num
end
function activity_9001706_Ctrl:getServerRewardNum()
	local doStage = self:getDoStage()
	local num = 0
	if doStage == 1 then
		local activity_9001706_Read = include("activity_9001706_Read")
		local reachIndex = activity_9001706_Read.getServerIndex(self:getPeopleNumber(), true)
		if 0 < reachIndex then
			local month = self:getCurMonth()
			local leftTime = serviceFunctions.getNextMonthDayTime(self:getActivityStageTime(), 1)
			if leftTime <= 0 and not self:isClaimedSerFreeReward(month) then
				num = num + 1
			end
			if self:isPaySerUnlock(month) and not self:isClaimedSerPayReward(month) then
				num = num + 1
			end
		end
	end
	return num
end
function activity_9001706_Ctrl:getStageBoxStatues(stage, point)
	local stageData = self.defaultData.stageReward[tostring(stage)]
	local state = stageData and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getCostSultanCoin() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001706_Ctrl:getCostSultanCoin()
	return self.defaultData.costSultanCoin
end
function activity_9001706_Ctrl:getPeopleNumber()
	return self.defaultData.peopleNumber
end
function activity_9001706_Ctrl:isGainedMonth(month)
	return self.defaultData.monthReward[tostring(month)] and true or false
end
function activity_9001706_Ctrl:isClaimedSerFreeReward(index)
	return self.defaultData.freeServerReward[tostring(index)] and true or false
end
function activity_9001706_Ctrl:isClaimedSerPayReward(index)
	return self.defaultData.payServerReward[tostring(index)] and true or false
end
function activity_9001706_Ctrl:isPaySerUnlock(index)
	return self.defaultData.isPayServerRewardUnlock[tostring(index)] and true or false
end
function activity_9001706_Ctrl:getActivityBeginTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local data = activityShowCtrl:getActivityData(self.activityID)
	return data.begintime
end
function activity_9001706_Ctrl:getActivityStageTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local data = activityShowCtrl:getActivityData(self.activityID)
	return data.stagetimes[1] - 1
end
function activity_9001706_Ctrl:getCurMonth()
	local curTime = serviceFunctions.systemTime()
	local month1 = tonumber(os.date("!%m", self:getActivityStageTime()))
	local month2 = tonumber(os.date("!%m", curTime))
	local monthTemp = month2 - month1
	if monthTemp < 0 then
		monthTemp = monthTemp + 12
	end
	monthTemp = monthTemp + 1
	return monthTemp
end
function activity_9001706_Ctrl:isBeginMonth()
	local curTime = serviceFunctions.systemTime()
	local month1 = tonumber(os.date("!%m", self:getActivityStageTime()))
	local month2 = tonumber(os.date("!%m", curTime))
	return month1 == month2
end
function activity_9001706_Ctrl:getCurDay()
	local constantRead = include("constantRead")
	_UPVALUE2_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 7
	local cfgDays = constantRead.getConstValueArray("SULTAN_PRESENT_REWARD_TIME", nil)
	local day = serviceFunctions.getUtcDayIndex(serviceFunctions.systemTime())
	return day, day >= cfgDays[1] and day <= cfgDays[2]
end
function activity_9001706_Ctrl:getDoStage()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local doStage = activityShowCtrl:getDoStageByID(self.activityID)
	return doStage
end
return activity_9001706_Ctrl
