local activity_9001729_Read = include("activity_9001729_Read")
local gametop = gModuleMgr.getObject("gametop")
local gamemodulec = include("GameModule")
local activity_9001729_Ctrl = class("activity_9001729_Ctrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function activity_9001729_Ctrl:ctor(properties)
	activity_9001729_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY
end
function activity_9001729_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_INIT, handler(self, self.reqInitInfoRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_THROW, handler(self, self.reqThrowDiceRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_STAGE, handler(self, self.reqReceiveStageRewardRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_SIGN, handler(self, self.reqSignRewardRsp))
	msgCtrl.register(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_GET_REWARD, handler(self, self.reqGetDailyRewardRsp))
	self:resetData()
	self:registerNotify()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function activity_9001729_Ctrl:initClientData(content)
	dump(content, "==activity_9001729_Ctrl:initClientData==", 20)
	if not content then
		return
	end
	self.activityData = content
end
function activity_9001729_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).blockInfo, _UPVALUE0_, (nil).curIdx = nil, nil, 1
	;(nil).goldDiceNum = 0
	;(nil).isNextDouble = false
	;(nil).isNextFree = false
	;(nil).stageReward, _UPVALUE0_, (nil).totalScore = nil, nil, 0
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).isAdvanceRewardUnlock = false
	;(nil).dailyGift, _UPVALUE0_, (nil).lastGetRewardTime = nil, nil, 0
	self.activityData, (nil).dailyGiftResetTime = nil, 0
end
function activity_9001729_Ctrl:Logout()
	self:resetData()
	activity_9001729_Ctrl.super.Logout(self)
end
function activity_9001729_Ctrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001729_Ctrl:newDay()
	self.activityData.dailyGift, _ENV = nil, nil
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE"
	SoraDSendMessage(nil)
end
function activity_9001729_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CRESCENT_TREASURE, handler(self, self.notifyHandler))
end
function activity_9001729_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001729_Ctrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			if content.notifyType == "buyGift" then
				if content.notifyData.success then
					self.activityData = content.notifyData.initData
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = self.activityID
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_ACTIVITY_9001729_BUYGIFT"
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE"
					SoraDSendMessage(nil)
				else
					_ENV = nil
					;(nil).msg = "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE"
					SoraDSendMessage(nil)
				end
			elseif content.notifyType == "refreshData" then
				self.activityData = content.notifyData
				_ENV = nil
				;(nil).msg = "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE"
				SoraDSendMessage(nil)
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				;(nil).eventID = self.activityID
				SoraDSendMessage(nil)
			end
		end
	end
end
function activity_9001729_Ctrl:sendReqInitDataMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_INIT, data)
end
function activity_9001729_Ctrl:reqThrowDiceMsg(step)
	serverproxy = nil
	;(nil).step = step
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_THROW, nil)
	local proxy = uiManager:getProxy("Activity_9001729_ViewPanel")
	if proxy then
		SoraDShowLoading(proxy.view, nil, gCmd.REQ_CRESCENT_TREASURE_THROW)
	end
end
function activity_9001729_Ctrl:reqStageRewardMsg(stageId)
	serverproxy = nil
	;(nil).stageId = stageId
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_STAGE, nil)
	local proxy = uiManager:getProxy("Activity_9001729_ViewPanel")
	if proxy then
		SoraDShowLoading(proxy.view, nil, gCmd.REQ_CRESCENT_TREASURE_STAGE)
	end
end
function activity_9001729_Ctrl:reqSignMsg()
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_SIGN)
end
function activity_9001729_Ctrl:reqBuyGiftMsg(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_BUY_GIFT, nil)
end
function activity_9001729_Ctrl:reqGetDailyRewardMsg()
	serverproxy:Request(gCmd.CMD_CRESCENT_TREASURE_MODULE, gCmd.REQ_CRESCENT_TREASURE_GET_REWARD)
end
function activity_9001729_Ctrl:reqInitInfoRsp(content)
	dump(content, "activity_9001729_Ctrl:reqInitInfoRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ANNIVERSARY_TREASURE_HUNT_INIT_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001729_Ctrl:reqThrowDiceRsp(content)
	dump(content, "activity_9001729_Ctrl:reqThrowDiceRsp===", 10)
	if content.err == gErrDef.Err_None then
		_ENV = content.err
		content.err.goldDiceNum = self.activityData.goldDiceNum
		content.err.isNextDouble = self.activityData.isNextDouble
		local content.err.isNextFree, oldData = self.activityData.isNextFree, content.err
		self.activityData = content.rspdata.initData
		if not content.rspdata.blockReward then
			local _ENV, blockReward = content.rspdata.blockReward, content.rspdata.blockReward
		end
		if not content.rspdata.roundReward then
			local _ENV, roundReward = content.rspdata.roundReward, content.rspdata.roundReward
		end
		if not content.rspdata.roundIds then
			local _ENV, roundIds = content.rspdata.roundIds, content.rspdata.roundIds
		end
		if not content.rspdata.steps then
			local _ENV, steps = content.rspdata.steps, content.rspdata.steps
		end
		if #steps == 0 then
			steps[1] = content.data.step
		end
		local eventType = content.rspdata.eventType or 0
		_ENV = nil
		_ENV, (nil).msg = nil, "MESSAGE_ACTIVITY_9001729_THROW_DICE"
		if content.data.step then
			_UPVALUE1_ = content.data.step
			content.data.step[1] = true
			if content.data.step then
				goto lbl_71
			end
		end
		_UPVALUE1_ = content.data.step
		content.data.step[1] = false
		::lbl_71::
		;(nil).isGold = content.data.step[1]
		;(nil).oldData = oldData
		;(nil).blockReward = blockReward
		;(nil).steps = steps
		;(nil).eventType = eventType
		;(nil).roundReward = roundReward
		;(nil).data, (nil).roundIds = nil, roundIds
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	else
	end
	local proxy = uiManager:getProxy("Activity_9001729_View")
	if proxy then
		SoraDCloseLoading(proxy.view, gCmd.REQ_CRESCENT_TREASURE_THROW)
	end
end
function activity_9001729_Ctrl:reqReceiveStageRewardRsp(content)
	dump(content, "activity_9001729_Ctrl:reqReceiveStageRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001729_STAGE_REWARD"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	end
	local proxy = uiManager:getProxy("Activity_9001729_View")
	if proxy then
		SoraDCloseLoading(proxy.view, gCmd.REQ_CRESCENT_TREASURE_STAGE)
	end
end
function activity_9001729_Ctrl:reqSignRewardRsp(content)
	dump(content, "activity_9001729_Ctrl:reqSignRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001729_BATTLEPASS_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	else
	end
end
function activity_9001729_Ctrl:reqBuyGiftRsp(content)
	dump(content, "activity_9001729_Ctrl:reqBuyGiftRsp===", 10)
	if content.err == gErrDef.Err_None then
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
		paymentManager.purchase(content.data.rid, content.rspdata.orderID)
		_ENV = content.data.rid
		content.data.rid.msg = "MESSAGE_ACTIVITY_9001729_BUY_GIFT"
		SoraDSendMessage(content.data.rid)
		_ENV = content.data.rid
		content.data.rid.msg = "MESSAGE_ACTIVITY_9001729_BATTLEPASS_UPDATE"
		SoraDSendMessage(content.data.rid)
		_ENV = content.data.rid
		content.data.rid.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.data.rid.eventID = self.activityID
		SoraDSendMessage(content.data.rid)
	end
	local proxy = uiManager:getProxy("Activity_9001729_BuyGift")
	if proxy then
		SoraDCloseLoading(proxy.view, gCmd.REQ_CRESCENT_TREASURE_BUY_GIFT)
	end
end
function activity_9001729_Ctrl:reqGetDailyRewardRsp(content)
	dump(content, "activity_9001729_Ctrl:reqGetDailyRewardrsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initData
		if content.rspdata.rewards then
			SoraDMailGainItems(content.rspdata.rewards, true)
		end
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001729_PACKAGE_UPDATE"
		SoraDSendMessage(content.rspdata.rewards)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewards.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001729_Ctrl:getMapSize()
	local activity_9001729_Read = include("activity_9001729_Read")
	return #activity_9001729_Read.getMapData(self.activityID)
end
function activity_9001729_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local dailyRewardReceived = self:getDailyRewardReceived()
	if not dailyRewardReceived then
		num = num + 1
	end
	local diceNum = self:getNormalDiceNum() + self:getGoldDiceNum()
	num = num + diceNum
	local battlePassNum = self:getBattlePassCanReceiveNum()
	num = num + battlePassNum
	local stageRewardNum = self:getStageRewardCanReceiveNum()
	num = num + stageRewardNum
	print("======activity_9001729_Ctrl:getReceiveStatusAndNum diceNum battlePassNum stageRewardNum dailyRewardNum", diceNum, battlePassNum, stageRewardNum, not dailyRewardReceived and 1 or 0)
	return 0 < num, num
end
function activity_9001729_Ctrl:getStarLv()
	return self.activityData.starLv or 0
end
function activity_9001729_Ctrl:getGroupID()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID) or 1
end
function activity_9001729_Ctrl:getCurDay()
	return self.activityData.signRewardLv or 0
end
function activity_9001729_Ctrl:isActiveGold()
	if self.activityData then
		_UPVALUE1_ = self.activityData
		self.activityData[1] = self.activityData.isAdvanceRewardUnlock
		if self.activityData then
			goto lbl_13
		end
	end
	_UPVALUE1_ = self.activityData
	self.activityData[1] = false
	::lbl_13::
	return self.activityData[1]
end
function activity_9001729_Ctrl:getRewardDay()
	return self.activityData and self.activityData.signRewardLv or 0
end
function activity_9001729_Ctrl:getRewardDayGold()
	return self.activityData and self.activityData.signRewardLvPay or 0
end
function activity_9001729_Ctrl:getDailyRewardReceived()
	local lastRewardTime = self.activityData.lastGetRewardTime or 0
	return serviceFunctions.isSameDay(lastRewardTime, serviceFunctions.getTodayZeroHourUTC())
end
function activity_9001729_Ctrl:getDailyGiftRefreshed()
	return serviceFunctions.isSameDay(self.activityData.dailyGiftResetTime or 0, serviceFunctions.getTodayZeroHourUTC())
end
function activity_9001729_Ctrl:getBattlePassCanReceive()
	local day = self:getCurDay()
	local dayPay = self.activityData.signRewardLvPay or 0
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityDay = activityShowCtrl:getCurOpenDay(self.activityID)
	local max = activity_9001729_Read.getMaxBattlePassLv(self.activityID)
	activityDay = math.min(activityDay, max)
	if self.activityData.isAdvanceRewardUnlock then
		return day < activityDay or dayPay < activityDay
	else
		return day < activityDay
	end
end
function activity_9001729_Ctrl:getBattlePassCanReceiveNum()
	local day = self:getCurDay()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityDay = activityShowCtrl:getCurOpenDay(self.activityID)
	activityDay = math.min(activityDay, activity_9001729_Read.getMaxBattlePassLv(self.activityID))
	return math.max(0, activityDay - day)
end
function activity_9001729_Ctrl:getStageRewardCanReceiveNum()
	local stages = self:getStageData()
	local num = 0
	for _, v in ipairs(stages) do
		if v.state == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return num
end
function activity_9001729_Ctrl:packageSoldOut()
	local dailyRewardReceived = self:getDailyRewardReceived()
	local packages = activity_9001729_Read.getDailyPackages()
	local packageSoldOut = true
	local sameDay = serviceFunctions.isSameDay(self.activityData.dailyGiftResetTime or 0, serviceFunctions.systemTime())
	if not sameDay then
		self.activityData.dailyGift, activity_9001729_Read = serviceFunctions.systemTime()
	end
	for k, v in pairs(packages) do
		local buyNum = self:getGiftDayBuyNum(v.rechargeID)
		if not sameDay or buyNum < v.extraData then
			packageSoldOut = false
			break
		end
	end
	return dailyRewardReceived and packageSoldOut
end
function activity_9001729_Ctrl:getGoldDiceNum()
	return self.activityData.goldDiceNum or 0
end
function activity_9001729_Ctrl:isNextDice2x()
	return self.activityData.isNextDouble or false
end
function activity_9001729_Ctrl:isNextDiceFree()
	return self.activityData.isNextFree or false
end
local diceItemId = 880201
function activity_9001729_Ctrl:getNormalDiceNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	return backpackCtrl:getItemCount(diceItemId) or 0
end
function activity_9001729_Ctrl:getScore()
	return self.activityData.totalScore or 0
end
function activity_9001729_Ctrl:getGiftDayBuyNum(rechargeID)
	if not self.activityData.dailyGift then
		local _ENV, dailyGift = self.activityData.dailyGift, self.activityData.dailyGift
	end
	local buyCount = dailyGift[tostring(rechargeID)] or 0
	if not serviceFunctions.isSameDay(self.activityData.dailyGiftResetTime or 0, serviceFunctions.systemTime()) then
		buyCount = 0
		self.activityData.dailyGift, _ENV = self.activityData.dailyGiftResetTime or 0, self.activityData.dailyGiftResetTime or 0
	end
	return buyCount
end
function activity_9001729_Ctrl:getCurPosIndex()
	return self.activityData.curIdx
end
function activity_9001729_Ctrl:getGridLv(id)
	if not self.activityData.blockInfo[tostring(id)] then
		_ENV = self.activityData.blockInfo[tostring(id)]
		local self.activityData.blockInfo[tostring(id)].exp, blockInfo = 0, self.activityData.blockInfo[tostring(id)]
	end
	return activity_9001729_Read.getLv(id, blockInfo.exp, self.activityID)
end
function activity_9001729_Ctrl:getGridExp(id)
	if not self.activityData.blockInfo[tostring(id)] then
		_ENV = self.activityData.blockInfo[tostring(id)]
		local self.activityData.blockInfo[tostring(id)].exp, blockInfo = 0, self.activityData.blockInfo[tostring(id)]
	end
	return blockInfo.exp
end
function activity_9001729_Ctrl:getStageData()
	local activity_9001729_Read, ret
	local classType = self:getClassType()
	if not activity_9001729_Read.ramadan_hunt_stage_reward[classType] then
		local activity_9001729_Read, stageConfig = activity_9001729_Read.ramadan_hunt_stage_reward[classType], activity_9001729_Read.ramadan_hunt_stage_reward[classType]
	end
	local curScore = self:getScore()
	for i, cfg in ipairs(stageConfig) do
		local state = gBtnTargetStatusDef.NONE
		if curScore >= cfg.num then
			if not self.activityData.stageReward[tostring(cfg.rewardID)] then
				state = gBtnTargetStatusDef.GET
			else
				state = gBtnTargetStatusDef.GOT
			end
		else
			state = gBtnTargetStatusDef.GO
		end
		activity_9001729_Read = cfg.rewardID
		cfg.rewardID.stage = cfg.index
		cfg.rewardID.point = cfg.num
		cfg.rewardID.state = state
		cfg.rewardID.rewardId = cfg.rewardID
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		cfg.rewardID.rewards = serviceFunctions.tableFormat(cfg.reward, nil)
		table.insert(ret, cfg.rewardID)
	end
	return ret
end
function activity_9001729_Ctrl:getStageRewardState(rewardID)
	local curScore = self:getScore()
	local state = gBtnTargetStatusDef.NONE
	local cfg = activity_9001729_Read.getStageData(rewardID, self.activityID)
	if curScore >= cfg.num then
		if not self.activityData.stageReward[tostring(cfg.rewardID)] then
			state = gBtnTargetStatusDef.GET
		else
			state = gBtnTargetStatusDef.GOT
		end
	else
		state = gBtnTargetStatusDef.GO
	end
	return state
end
function activity_9001729_Ctrl:setTest()
	self.activityData.goldDiceNum = 1
	self.activityData.isNextDouble = true
	self.activityData.isNextFree = true
end
return activity_9001729_Ctrl
