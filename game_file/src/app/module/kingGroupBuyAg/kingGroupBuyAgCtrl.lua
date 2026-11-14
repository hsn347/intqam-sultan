local GameModule = include("GameModule")
local kingGroupBuyAgCtrl = class("kingGroupBuyAgCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function kingGroupBuyAgCtrl:ctor(properties)
	kingGroupBuyAgCtrl.super.ctor(self, properties)
end
function kingGroupBuyAgCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_INIT, handler(self, self.kingGroupBuyAgInitResp))
	msgCtrl.register(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_CHARGE, handler(self, self.kingGroupBuyAgBuyResp))
	msgCtrl.register(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_LOG, handler(self, self.kingGroupBuyAgLogResp))
	msgCtrl.register(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_DEBUG_REFRESH, handler(self, self.kingGroupBuyAgDebugRefreshResp))
	msgCtrl.register(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_MARK, handler(self, self.kingGroupBuyAgMarkResp))
	self:resetData()
end
function kingGroupBuyAgCtrl:resetData()
	self.playerStatus = nil
	self.maxBuyCount = nil
	self.leftBuyCount = nil
	self.alreadyBuyCount = nil
	self.clientInfo = nil
	self.groupbuyLog = nil
	self.isMark = nil
	self.currentRid1 = 0
	self.currentRid2 = 0
	self.currentPrice1 = 0
	self.currentPrice2 = 0
	self.currentNum1 = 0
	self.currentNum2 = 0
	self.markNumber = 0
end
function kingGroupBuyAgCtrl:Logout()
	self:resetData()
	kingGroupBuyAgCtrl.super.Logout(self)
end
function kingGroupBuyAgCtrl:initClientData(data)
	self:registerNotify()
end
function kingGroupBuyAgCtrl:dealData(data)
	if data.playerStatus then
		self.playerStatus = data.playerStatus
	end
	if data.maxBuyCount then
		self.maxBuyCount = data.maxBuyCount
	end
	if data.leftBuyCount then
		self.leftBuyCount = data.leftBuyCount
	end
	if data.alreadyBuyCount then
		self.alreadyBuyCount = data.alreadyBuyCount
	end
	if data.clientInfo then
		self.clientInfo = data.clientInfo
		self.markNumber = data.clientInfo.markNumber
		self.isMark = data.clientInfo.isMark
	end
	self.rewardInfo, _ENV = data.clientInfo.isMark, data.clientInfo.isMark
	if self.clientInfo and type(self.clientInfo.reward) == "table" then
		for rid, value in pairs(self.clientInfo.reward) do
			if table.nums(value) == 1 then
				self.currentRid2 = tonumber(rid)
				if value[1] then
					self.currentPrice2 = value[1].price or 0
					self.currentNum2 = value[1].num or 0
				end
			else
				self.rewardInfo = value
				self.currentRid1 = tonumber(rid)
				if value[1] then
					self.currentPrice1 = value[1].price or 0
					self.currentNum1 = value[1].num or 0
				end
			end
		end
	end
end
function kingGroupBuyAgCtrl:dump()
	print("self:getPlayerStatus()", self:getPlayerStatus())
	print("self:getMaxBuyCount()", self:getMaxBuyCount())
	print("self:getLeftBuyCount()", self:getLeftBuyCount())
	print("self:getAlreadyBuyCount()", self:getAlreadyBuyCount())
	print("self:getJoinCount()", self:getJoinCount())
	print("self:getTotalBuyCount()", self:getTotalBuyCount())
	print("self:getCurDay()", self:getCurDay())
	print("self:getClearingLeftTime()", self:getClearingLeftTime())
	print("self:getSendRewardLeftTime()", self:getSendRewardLeftTime())
	print("self:getCanRecharge()", self:getCanRecharge())
	print("self:getIsMark()", self:getIsMark())
	print("self:getMarkNumber()", self:getMarkNumber())
end
function kingGroupBuyAgCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KING_GROUP_BUY, handler(self, self.notifyHandler))
end
function kingGroupBuyAgCtrl:notifyHandler(event)
	local content = event.data[1]
	if content then
		self:dealData(content.data)
		if content.rechargeInfo then
			local rid = content.rechargeInfo.rid
			local price = content.rechargeInfo.price
			local rechargeSuccess = content.rechargeInfo.rechargeSuccess
			local bAddList = content.rechargeInfo.bAddList
			paymentManager.OnemtRechargeSuccess(price)
			paymentManager.loopForFinishTransaction()
			if rechargeSuccess then
				if bAddList then
					_ENV = price
					_ENV, price.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					price.data, (nil).rid = nil, rid
					SoraDSendMessage(price)
				else
					_ENV = price
					_ENV, price.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = false
					;(nil).rid = rid
					price.data, (nil).contactMe = nil, true
					SoraDSendMessage(price)
				end
			else
				_ENV = price
				_ENV, price.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(nil).result = false
				price.data, (nil).rid = nil, rid
				SoraDSendMessage(price)
			end
		end
		_ENV = content.rechargeInfo.price
		content.rechargeInfo.price.msg = "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_INIT"
		SoraDSendMessage(content.rechargeInfo.price)
	end
end
function kingGroupBuyAgCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_INIT)
end
function kingGroupBuyAgCtrl:sendChargeMsg(rid)
	local serverproxy, data
	data.rid = rid
	serverproxy:Request(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_CHARGE, data)
end
function kingGroupBuyAgCtrl:sendLogMsg(startIndex)
	local serverproxy, data
	data.startIndex = startIndex
	serverproxy:Request(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_BUY_LOG, data)
end
function kingGroupBuyAgCtrl:sendDebugRefrsh(rid, price)
	serverproxy = nil
	;(nil).rid = rid
	local (nil).price, data = price, nil
	serverproxy:Request(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_DEBUG_REFRESH, data)
end
function kingGroupBuyAgCtrl:sendMark()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KING_GROUP_BUY_MODULE, gCmd.REQ_KING_GROUP_MARK, data)
end
function kingGroupBuyAgCtrl:kingGroupBuyAgInitResp(ret)
	if ret and ret.data then
		local data = ret.data
		self:dealData(data)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_INIT"
		SoraDSendMessage(self)
	end
end
function kingGroupBuyAgCtrl:kingGroupBuyAgBuyResp(ret)
	if ret and ret.data then
		local rid = ret.data.rid
		if ret.err == gErrDef.Err_None then
			local orderID = ret.data.orderID
			paymentManager.purchase(rid, orderID)
		else
			SoraDCloseLoading()
			paymentManager.isInRecharging = false
			if ret.err == gErrDef.Err_KING_GROUP_BUY_NOT_FOUND_ID then
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_IN_ENEMY_STATE then
				SoraDShowMsgTip(i18n("common_text_3114"))
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_REACH_MAX then
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_WILL_REACH_MAX then
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_BEFORE_KID_NOT_END then
				SoraDShowMsgTip(i18n("common_text_1028"))
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_CLOSE then
			elseif ret.err == gErrDef.Err_KING_GROUP_BUY_CLEARING then
			end
		end
	end
end
function kingGroupBuyAgCtrl:kingGroupBuyAgLogResp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		local startIndex = ret.data.startIndex
		local newStartIndex = ret.data.newStartIndex
		local bCanContinueGet = ret.data.bCanContinueGet
		if tonumber(startIndex) == 1 then
			self.groupbuyLog, _ENV = tonumber(startIndex), tonumber(startIndex)
		end
		if type(ret.data.selfRechargeLog) == "table" then
			for index, value in pairs(ret.data.selfRechargeLog) do
				self.groupbuyLog[tonumber(index)] = value
			end
		end
		_ENV = pairs(ret.data.selfRechargeLog)
		pairs(ret.data.selfRechargeLog).msg = "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_RECORDBACK"
		pairs(ret.data.selfRechargeLog).noticeLog = self.groupbuyLog
		pairs(ret.data.selfRechargeLog).nextIndex = newStartIndex
		pairs(ret.data.selfRechargeLog).canGet = bCanContinueGet
		SoraDSendMessage(pairs(ret.data.selfRechargeLog))
	end
end
function kingGroupBuyAgCtrl:kingGroupBuyAgDebugRefreshResp(ret)
end
function kingGroupBuyAgCtrl:kingGroupBuyAgMarkResp(ret)
	if ret and ret.data then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			self.isMark = true
			if data.markNumber then
				self.markNumber = data.markNumber
			end
		elseif ret.err == gErrDef.Err_KING_GROUP_BUY_OPEN then
		elseif ret.err == gErrDef.Err_KING_GROUP_BUY_ALREADY_MARK then
		end
	end
end
function kingGroupBuyAgCtrl:getActivityStatus()
	local ret = gKingGroupBuyStatus.RECHARGE_CLOSING
	if self.clientInfo and self.clientInfo.status then
		ret = self.clientInfo.status
	end
	return ret
end
function kingGroupBuyAgCtrl:getMaxBuyCount()
	return self.maxBuyCount or 10
end
function kingGroupBuyAgCtrl:getJoinCount()
	if not self.clientInfo then
		_UPVALUE0_ = self.clientInfo
	end
	self.clientInfo = self.clientInfo
	return self.clientInfo.joinCount or 0
end
function kingGroupBuyAgCtrl:getTotalBuyCount()
	if not self.clientInfo then
		_UPVALUE0_ = self.clientInfo
	end
	self.clientInfo = self.clientInfo
	return self.clientInfo.buyCount or 0
end
function kingGroupBuyAgCtrl:getCurDay()
	if not self.clientInfo then
		_UPVALUE0_ = self.clientInfo
	end
	self.clientInfo = self.clientInfo
	return self.clientInfo.curDay or 0
end
function kingGroupBuyAgCtrl:getRechargeInfo1()
	_UPVALUE0_ = nil
	;(nil).rid = self.currentRid1
	;(nil).price = self.currentPrice1
	;(nil).num = self.currentNum1
	return nil
end
function kingGroupBuyAgCtrl:getRechargeInfo2()
	_UPVALUE0_ = nil
	;(nil).rid = self.currentRid2
	;(nil).price = self.currentPrice2
	;(nil).num = self.currentNum2
	return nil
end
function kingGroupBuyAgCtrl:getClearingLeftTime()
	local ret = 0
	if self.clientInfo and self.clientInfo.clearingtime then
		ret = self.clientInfo.clearingtime - serviceFunctions.systemTime()
		if ret <= 0 then
			ret = 0
		end
	end
	return ret
end
function kingGroupBuyAgCtrl:getSendRewardLeftTime()
	local ret = 0
	if self.clientInfo and self.clientInfo.endtime then
		ret = self.clientInfo.endtime - serviceFunctions.systemTime()
		if ret <= 0 then
			ret = 0
		end
	end
	return ret
end
function kingGroupBuyAgCtrl:getReward()
	return self.rewardInfo
end
function kingGroupBuyAgCtrl:getMarkNumber()
	return self.markNumber or 0
end
function kingGroupBuyAgCtrl:getPlayerStatus()
	return self.playerStatus
end
function kingGroupBuyAgCtrl:getLeftBuyCount()
	return self.leftBuyCount or 0
end
function kingGroupBuyAgCtrl:getAlreadyBuyCount()
	return self.alreadyBuyCount or 0
end
function kingGroupBuyAgCtrl:getCanRecharge()
	local ret = false
	if self.clientInfo.status == gKingGroupBuyStatus.RECHARGE_OPEN then
		ret = true
	end
	return ret
end
function kingGroupBuyAgCtrl:getIsMark()
	return self.isMark
end
return kingGroupBuyAgCtrl
