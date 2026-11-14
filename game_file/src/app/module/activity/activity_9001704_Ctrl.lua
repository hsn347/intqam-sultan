local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001704_Ctrl = class("activity_9001704_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001704_Read = include("activity_9001704_Read")
function activity_9001704_Ctrl:ctor(properties)
	activity_9001704_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	local constantRead = include("constantRead")
	_UPVALUE2_ = nil
	;(nil)[1] = 874501
	;(nil)[2] = 1
	self.costItem = constantRead.getConstValueArray("SKY_ISLAND_MOVE_CONSUME", nil)
	self.itemID = self.costItem[1]
	self.itemNum = self.costItem[2]
end
function activity_9001704_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_DAYS_REWARD, handler(self, self.reqDaysRewardRsp))
	msgCtrl.register(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_CRUISE, handler(self, self.reqCruiseRsp))
	msgCtrl.register(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_PAY_REWARD, handler(self, self.reqPayRewardRsp))
	self:registerNotify()
end
function activity_9001704_Ctrl:Logout()
	activity_9001704_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001704_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	;(nil).daysReward, _UPVALUE0_, (nil).isAdvanceRewardUnlock = nil, nil, false
	self.initData, (nil).payReward, _UPVALUE0_, (nil).steps = nil, nil, nil, 0
end
function activity_9001704_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CRUISE_SKY_ISLAND, handler(self, self.notifyHandler))
end
function activity_9001704_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001704_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "refreshData" then
			self.initData = notifyData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
			;(nil).subMsg = "initData"
			SoraDSendMessage(nil)
		elseif notifyType == "buyGift" and notifyData.success then
			self.initData = notifyData.initData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
			;(nil).subMsg = "buyGift"
			SoraDSendMessage(nil)
		end
	end
end
function activity_9001704_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_INIT, nil)
end
function activity_9001704_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001704_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
		gErrDef.Err_None.subMsg = "initData"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001704_Ctrl:reqReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_REWARD, nil)
end
function activity_9001704_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001704_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
		content.rspdata.rewards.subMsg = "reward"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001704_Ctrl:reqDaysReward(days)
	serverproxy = nil
	;(nil).days = days
	serverproxy:Request(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_DAYS_REWARD, nil)
end
function activity_9001704_Ctrl:reqDaysRewardRsp(content)
	dump(content, "activity_9001704_Ctrl:reqDaysRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
		content.rspdata.rewards.subMsg = "daysReward"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001704_Ctrl:reqCruise()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_CRUISE, nil)
end
function activity_9001704_Ctrl:reqCruiseRsp(content)
	dump(content, "activity_9001704_Ctrl:reqCruiseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
		gErrDef.Err_None.subMsg = "cruise"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001704_Ctrl:reqPayReward(pos)
	serverproxy = nil
	;(nil).pos = pos
	serverproxy:Request(gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE, gCmd.REQ_CRUISE_EMPTY_ISLAND_PAY_REWARD, nil)
end
function activity_9001704_Ctrl:reqPayRewardRsp(content)
	dump(content, "activity_9001704_Ctrl:reqPayRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		SoraDMailGainItems(content.rspdata.rewards, true)
		_ENV = content.rspdata.rewards
		content.rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001704_UPDATE"
		content.rspdata.rewards.subMsg = "payReward"
		SoraDSendMessage(content.rspdata.rewards)
	end
end
function activity_9001704_Ctrl:getCostItemID()
	return self.itemID, self.itemNum
end
function activity_9001704_Ctrl:getRewardLv(rtype)
	local initData = self.initData
	if rtype == 1 then
		return initData.signRewardLv or 0
	else
		return initData.signRewardLvPay or 0
	end
end
function activity_9001704_Ctrl:getIsAdvanceRewardUnlock()
	local initData = self.initData
	return initData.isAdvanceRewardUnlock or false
end
function activity_9001704_Ctrl:getDaysReward()
	local initData = self.initData
	if not initData.daysReward then
		_UPVALUE0_ = initData.daysReward
	end
	return initData.daysReward
end
function activity_9001704_Ctrl:getSteps()
	local initData = self.initData
	return initData.steps or 0
end
function activity_9001704_Ctrl:checkDaysRewardMark(days)
	local daysReward = self:getDaysReward()
	return daysReward[tostring(days)] == 1
end
function activity_9001704_Ctrl:getPayReward()
	local initData = self.initData
	if not initData.payReward then
		_UPVALUE0_ = initData.payReward
	end
	return initData.payReward
end
function activity_9001704_Ctrl:checkPayReward(pos)
	local payReward = self:getPayReward()
	return payReward[tostring(pos)] == 1
end
function activity_9001704_Ctrl:getCurLv()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local curLv = activityShowCtrl:getCurOpenDay(self.activityID)
	local maxDay = activity_9001704_Read.getBattlePassMaxDay(self.activityID)
	return math.min(curLv, maxDay)
end
function activity_9001704_Ctrl:getBattlePassRewardState(rtype, lv)
	local rewardLv = self:getRewardLv(rtype)
	if lv <= rewardLv then
		return gBtnTargetStatusDef.GOT
	end
	if rtype == 2 and not self:getIsAdvanceRewardUnlock() then
		return gBtnTargetStatusDef.NONE
	end
	local curLv = self:getCurLv()
	if lv <= curLv then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activity_9001704_Ctrl:getBattlePassRedNum()
	local curLv = self:getCurLv()
	local rewardLv1 = self:getRewardLv(1)
	if curLv > rewardLv1 then
		return true
	end
	if self:getIsAdvanceRewardUnlock() then
		local rewardLv2 = self:getRewardLv(2)
		if curLv > rewardLv2 then
			return true
		end
	end
	return false
end
function activity_9001704_Ctrl:getBoxState(stage)
	local targetDays = activity_9001704_Read.getStageDays(stage)
	if self:checkDaysRewardMark(targetDays) then
		return gBtnTargetStatusDef.GOT
	end
	if targetDays <= self:getCurLv() then
		return gBtnTargetStatusDef.GET
	else
		return gBtnTargetStatusDef.GO
	end
end
function activity_9001704_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local _isRed, _num = self:getReceiveStatusAndNum_map()
	if _isRed then
		num = num + _num
	end
	local _isRed, _num = self:getReceiveStatusAndNum_sign()
	if _isRed then
		num = num + _num
	end
	return 0 < num, num
end
function activity_9001704_Ctrl:getReceiveStatusAndNum_map()
	local num = 0
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	if itemCount >= self.itemNum then
		num = num + itemCount
	end
	local payRewardIdxList = activity_9001704_Read.getPayRewardIdxList()
	for index, __ in ipairs(payRewardIdxList) do
		if self:getExtraRewardState(index) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activity_9001704_Ctrl:getReceiveStatusAndNum_sign()
	local num = 0
	if self:getBattlePassRedNum() then
		num = num + 1
	end
	local stageConfig = activity_9001704_Read.getConfig_signin_reward()
	for stage, __ in ipairs(stageConfig) do
		if self:getBoxState(stage) == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return 0 < num, num
end
function activity_9001704_Ctrl:getExtraRewardState(index)
	local isUnlock = self:getIsAdvanceRewardUnlock()
	if not isUnlock then
		return gBtnTargetStatusDef.GO
	end
	local steps = self:getSteps()
	local payRewardIdx = activity_9001704_Read.getPayRewardIdx(index)
	if steps < payRewardIdx then
		return gBtnTargetStatusDef.GO
	end
	if self:checkPayReward(payRewardIdx) then
		return gBtnTargetStatusDef.GOT
	else
		return gBtnTargetStatusDef.GET
	end
end
return activity_9001704_Ctrl
