local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local summerPrayCtrl = class("summerPrayCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function summerPrayCtrl:ctor(properties)
	summerPrayCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self:resetData()
end
function summerPrayCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_INIT, handler(self, self.reqSummerPrayInitRsp))
	msgCtrl.register(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_BLESS, handler(self, self.reqSummerPrayBlessRsp))
	msgCtrl.register(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_RESET, handler(self, self.reqSummerPrayResetRsp))
	msgCtrl.register(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_BLESS_TEN, handler(self, self.reqSummerPrayBlessTenRsp))
	self:registerNotify()
	self:reqSummerPrayInit()
end
function summerPrayCtrl:Logout()
	summerPrayCtrl.super.Logout(self)
	self:resetData()
end
function summerPrayCtrl:resetData()
	self.prayValue = 0
	self.resetPrayCount = 0
	self.giftOrder = 0
end
function summerPrayCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SUMMER_PRAY_ACTIVITY, handler(self, self.notifyHandler))
end
function summerPrayCtrl:notifyHandler(event)
	dump(event.data, "summerPrayCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local summerPrayData = v.summerPrayData
		self.prayValue = summerPrayData.failProcess
		self.resetPrayCount = summerPrayData.resetPrayCount
		self.roundFree = summerPrayData.roundFree
		self.giftOrder = summerPrayData.successProcess
		_ENV = nil
		;(nil).msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
	end
end
function summerPrayCtrl:reqSummerPrayInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_INIT, nil)
end
function summerPrayCtrl:reqSummerPrayBless()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_BLESS, nil)
end
function summerPrayCtrl:reqSummerPrayReset()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_RESET, nil)
end
function summerPrayCtrl:reqSummerPrayBlessTen()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SUMMER_PRAY_MODULE, gCmd.REQ_SUMMER_PRAY_BLESS_TEN, nil)
end
function summerPrayCtrl:reqSummerPrayInitRsp(content)
	dump(content, "summerPrayCtrl:reqSummerPrayInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local summerPrayData = content.rspdata.summerPrayData
		self.prayValue = summerPrayData.failProcess
		self.resetPrayCount = summerPrayData.resetPrayCount
		self.roundFree = summerPrayData.roundFree
		self.giftOrder = summerPrayData.successProcess
		_ENV = "summerPrayCtrl:reqSummerPrayInitRsp(content)"
		;("summerPrayCtrl:reqSummerPrayInitRsp(content)").msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;("summerPrayCtrl:reqSummerPrayInitRsp(content)").subMsg = "init"
		SoraDSendMessage("summerPrayCtrl:reqSummerPrayInitRsp(content)")
	end
end
function summerPrayCtrl:reqSummerPrayBlessRsp(content)
	dump(content, "summerPrayCtrl:reqSummerPrayBlessRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local success = content.rspdata.success
		local prayReward = content.rspdata.prayReward
		if not content.rspdata.successReward then
			local _ENV, successReward = content.rspdata.successReward, content.rspdata.successReward
		end
		local summerPrayData = content.rspdata.summerPrayData
		if not content.rspdata.failReward then
			local _ENV, failReward = content.rspdata.failReward, content.rspdata.failReward
		end
		self.prayValue = summerPrayData.failProcess
		self.resetPrayCount = summerPrayData.resetPrayCount
		self.giftOrder = summerPrayData.successProcess
		self.roundFree = summerPrayData.roundFree
		local reward = failReward
		local successItem = success and successReward[1].id or nil
		table.insert(reward, prayReward)
		_ENV = reward
		reward.msg = "MESSAGE_SUMMER_PRAY_VIEW"
		reward.subMsg = "bless"
		reward.success = success
		reward.reward = reward
		reward.successItem = successItem
		SoraDSendMessage(reward)
		_ENV = reward
		reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		reward.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
		SoraDSendMessage(reward)
	elseif content.err == gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER then
		_ENV = gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER
		gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER.msg = "MESSAGE_SUMMER_PRAY_VIEW"
		gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER.subMsg = "bless"
		SoraDSendMessage(gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER)
	end
end
function summerPrayCtrl:reqSummerPrayBlessTenRsp(content)
	dump(content, "summerPrayCtrl:reqSummerPrayBlessTenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local prayReward = content.rspdata.prayTenReward
		if not content.rspdata.successTenReward then
			local _ENV, successReward = content.rspdata.successTenReward, content.rspdata.successTenReward
		end
		if not content.rspdata.failTenReward then
			local _ENV, failReward = content.rspdata.failTenReward, content.rspdata.failTenReward
		end
		local summerPrayData = content.rspdata.summerPrayData
		self.prayValue = summerPrayData.failProcess
		self.resetPrayCount = summerPrayData.resetPrayCount
		self.giftOrder = summerPrayData.successProcess
		self.roundFree = summerPrayData.roundFree
		local reward = failReward
		for _, item in ipairs(prayReward) do
			table.insert(reward, item)
		end
		for _, item in ipairs(successReward) do
			table.insert(reward, item)
		end
		local success = next(successReward)
		_ENV = ipairs(successReward)
		ipairs(successReward).msg = "MESSAGE_SUMMER_PRAY_VIEW"
		ipairs(successReward).subMsg = "bless"
		ipairs(successReward).isTen = true
		ipairs(successReward).success = success
		ipairs(successReward).reward = reward
		SoraDSendMessage(ipairs(successReward))
		_ENV = ipairs(successReward)
		ipairs(successReward).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ipairs(successReward).activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
		SoraDSendMessage(ipairs(successReward))
	elseif content.err == gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER then
		_ENV = gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER
		gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER.msg = "MESSAGE_SUMMER_PRAY_VIEW"
		gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER.subMsg = "bless"
		SoraDSendMessage(gErrDef.Err_SUMMER_PRAY_LIMIT_NUMBER)
	end
end
function summerPrayCtrl:reqSummerPrayResetRsp(content)
	dump(content, "summerPrayCtrl:reqSummerPrayResetRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local summerPrayData = content.rspdata.summerPrayData
		self.prayValue = summerPrayData.failProcess
		self.resetPrayCount = summerPrayData.resetPrayCount
		self.roundFree = summerPrayData.roundFree
		self.giftOrder = summerPrayData.successProcess
		_ENV = "summerPrayCtrl:reqSummerPrayResetRsp(content)"
		;("summerPrayCtrl:reqSummerPrayResetRsp(content)").msg = "MESSAGE_SUMMER_PRAY_VIEW"
		;("summerPrayCtrl:reqSummerPrayResetRsp(content)").subMsg = "init"
		SoraDSendMessage("summerPrayCtrl:reqSummerPrayResetRsp(content)")
	end
end
function summerPrayCtrl:getPrayValue()
	return self.prayValue or 0
end
function summerPrayCtrl:getResetPrayCount()
	return self.resetPrayCount or 0
end
function summerPrayCtrl:getGiftOrder()
	return self.giftOrder or 0
end
function summerPrayCtrl:getIsFirst()
	return self.roundFree
end
function summerPrayCtrl:getPrayRed()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	if activityData.doStage == 0 then
		local itemID = self:getItemID()
		return self.roundFree or 0 < backpackCtrl:getItemCount(itemID)
	else
		return false
	end
end
function summerPrayCtrl:getExchangeRed(...)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(self.activityID)
	local retExchange, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID, classType)
	return retExchange
end
function summerPrayCtrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false
	end
	if self:getPrayRed() then
		return true, -1
	end
	if self:getExchangeRed() then
		return true, -1
	end
	return false, 0
end
function summerPrayCtrl:getItemID(...)
	local summerPrayRead = include("summerPrayRead")
	return summerPrayRead.getItemID()
end
return summerPrayCtrl
