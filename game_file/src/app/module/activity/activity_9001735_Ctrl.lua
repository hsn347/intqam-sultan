local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001735_Ctrl = class("activity_9001735_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001735_Ctrl:ctor(properties)
	activity_9001735_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY
	self:resetData()
end
function activity_9001735_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_RANKING, handler(self, self.reqRankingRsp))
	msgCtrl.register(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_SHOOT, handler(self, self.reqShootRsp))
	msgCtrl.register(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_STAGE, handler(self, self.reqStageRsp))
	self:registerNotify()
end
function activity_9001735_Ctrl:Logout()
	activity_9001735_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001735_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).classType = 1
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).isAdvanceRewardUnlock = false
	;(nil).dailyGift, _UPVALUE0_, (nil).dailyGiftResetTime = nil, nil, 0
	;(nil).inGame = false
	;(nil).score = 0
	self.initData, (nil).stageReward, _UPVALUE0_, (nil).goalScore = nil, nil, nil, 0
end
function activity_9001735_Ctrl:initClientData(data)
	dump(data, "activity_9001735_Ctrl:initClientData===")
end
function activity_9001735_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FREE_KICK_MASTER, handler(self, self.notifyHandler))
end
function activity_9001735_Ctrl:notifyHandler(event)
	dump(event, "activity_9001735_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshData" then
			self.initData = notifyData
		elseif notifyType == "buyGift" then
			self.initData = notifyData.initData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001735_BUYGIFT"
			SoraDSendMessage(nil)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001735_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001735_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_INIT, nil)
end
function activity_9001735_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001735_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001735_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001735_Ctrl:reqSign()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_SIGN, nil)
end
function activity_9001735_Ctrl:reqSignRsp(content)
	dump(content, "activity_9001735_Ctrl:reqSignRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001735_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001735_Ctrl:reqRanking(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_RANKING, nil)
end
function activity_9001735_Ctrl:reqRankingRsp(content)
	dump(content, "activity_9001735_Ctrl:reqRankingRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001735_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001735_Ctrl:reqShoot(isHit)
	serverproxy = nil
	;(nil).isHit = isHit
	serverproxy:Request(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_SHOOT, nil)
end
function activity_9001735_Ctrl:reqShootRsp(content)
	dump(content, "activity_9001735_Ctrl:reqShootRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		local isHit = content.data.isHit or false
		if isHit then
			uiManager:show("Activity_9001735_win")
		else
			uiManager:show("Activity_9001735_lose")
		end
	end
end
function activity_9001735_Ctrl:reqStage(point)
	serverproxy = nil
	;(nil).point = point
	serverproxy:Request(gCmd.CMD_FREE_KICK_MASTER_MODULE, gCmd.REQ_FREE_KICK_MASTER_STAGE, nil)
end
function activity_9001735_Ctrl:reqStageRsp(content)
	dump(content, "activity_9001735_Ctrl:reqStageRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001735_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001735_Ctrl:getReceiveStatusAndNum()
	local num = self:getStageRewardNum() + self:getPassRedNum() + self:getItemRedNum()
	return 0 < num, num
end
function activity_9001735_Ctrl:getStageRewardNum()
	local activity_9001735_Read = include("activity_9001735_Read")
	local stageCfg = activity_9001735_Read.getStageRewardCfg()
	local num = 0
	for k, v in ipairs(stageCfg) do
		if self:getStageBoxStatues(v.point) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001735_Ctrl:getPassRedNum()
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	local activity_9001735_Read = include("activity_9001735_Read")
	local lvList = activity_9001735_Read.getBattlePassCfg()
	local ret = false
	for k, v in ipairs(lvList) do
		if openDay >= v.rewardID and self.initData.signRewardLv < v.rewardID then
			ret = true
		end
		if self:getUnlockAdv() and openDay >= v.rewardID and self.initData.signRewardLvPay < v.rewardID then
			ret = true
		end
	end
	return ret and 1 or 0
end
function activity_9001735_Ctrl:getItemRedNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local constantRead = include("constantRead")
	local itemID = constantRead.getConstValue("FREEKICK_MASTER_GAME_COST", 882601)
	return backpackCtrl:getItemCount(itemID) > 0 and 1 or 0
end
function activity_9001735_Ctrl:getStageBoxStatues(point)
	local state = self.initData.stageReward[tostring(point)] and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	if state ~= gBtnTargetStatusDef.GOT and point <= self:getScore() then
		state = gBtnTargetStatusDef.GET
	end
	return state
end
function activity_9001735_Ctrl:getScore()
	return self.initData.score or 0
end
function activity_9001735_Ctrl:getClassType()
	return self.initData.classType or 1
end
function activity_9001735_Ctrl:getUnlockAdv()
	return self.initData.isAdvanceRewardUnlock or false
end
function activity_9001735_Ctrl:getSignLvStatus(lv, isAdv)
	local status = 0
	local openDay = SoraDGetCtrl("activityShowCtrl"):getCurOpenDay(self.activityID)
	if isAdv then
		status = 0
		if self:getUnlockAdv() then
			status = 2
			if lv <= self.initData.signRewardLvPay then
				status = 3
			elseif lv <= openDay then
				status = 1
			end
		end
	else
		status = 2
		if lv <= self.initData.signRewardLv then
			status = 3
		elseif lv <= openDay then
			status = 1
		end
	end
	return status
end
function activity_9001735_Ctrl:getDailyGiftBuyCount(rechargeID)
	return self.initData.dailyGift[tostring(rechargeID)] or 0
end
return activity_9001735_Ctrl
