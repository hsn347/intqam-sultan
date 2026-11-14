local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001614_Ctrl = class("activity_9001614_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001614_Ctrl:ctor(properties)
	activity_9001614_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_RECHARGE_REBATE
	self:resetData()
end
function activity_9001614_Ctrl:EnterGame()
	print("==activity_9001614_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_RECEIVE, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_BUY_Daily_Gift, handler(self, self.reqBuyDailyGiftRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_BUY_Notify_Gift, handler(self, self.reqBuyNotifyGiftRsp))
	self:registerNotify()
end
function activity_9001614_Ctrl:Logout()
	activity_9001614_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001614_Ctrl:resetData()
	self.notifyGift, _UPVALUE0_, self.dailyGift, _UPVALUE0_ = nil, nil, nil, nil
	self.payAbility = 0
	self.receiveMark, _UPVALUE0_, self.price = nil, nil, 0
end
function activity_9001614_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HONOR_BACK_RECHARGE_REBATE, handler(self, self.notifyHandler))
end
function activity_9001614_Ctrl:notifyHandler(event)
	dump(event, "activity_9001614_Ctrl:notifyHandler===========", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		if not notifyData.dailyGift then
			_ENV = notifyData.dailyGift
		end
		self.dailyGift = notifyData.dailyGift
		if not notifyData.notifyGift then
			_ENV = notifyData.notifyGift
		end
		self.notifyGift = notifyData.notifyGift
		self.payAbility = notifyData.payAbility or 0
		self.price = notifyData.price or 0
		if not notifyData.receiveMark then
			_ENV = notifyData.receiveMark
		end
		self.receiveMark = notifyData.receiveMark
		if v.notifyType == "updateData" then
		elseif v.notifyType == "buyGift" then
			local rechargeInfo = notifyData.rechargeInfo
			if rechargeInfo.success then
				paymentManager.loopForFinishTransaction()
				local reward = rechargeInfo.reward
				local mailid = rechargeInfo.mailid
				local rid = rechargeInfo.rid
				_ENV = nil
				_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(nil).result = rechargeInfo.success
				;(nil).rid = rid
				;(nil).itemList = reward
				;(nil).data, (nil).mailID = nil, mailid
				SoraDSendMessage(nil)
			end
		elseif v.notifyType == "addNotifyGift" then
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001614_UPDATE"
	SoraDSendMessage(ipairs(event.data))
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(event.data).eventID = self.activityID
	ipairs(event.data).activityID = self.activityID
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001614_Ctrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_INIT)
end
function activity_9001614_Ctrl:sendReceiveMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_RECEIVE, nil)
end
function activity_9001614_Ctrl:sendBuyGiftMsg(rid)
	if self.notifyGift[tostring(rid)] then
		self:sendBuyDailyGiftMsg(rid)
	else
		self:sendBuyNotifyGiftMsg(rid)
	end
end
function activity_9001614_Ctrl:sendBuyDailyGiftMsg(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_BUY_Daily_Gift, nil)
end
function activity_9001614_Ctrl:sendBuyNotifyGiftMsg(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_HONOR_BACK_RECHARGE_REBATE_MODULE, gCmd.REQ_HONOR_BACK_RECHARGE_REBATE_BUY_Notify_Gift, nil)
end
function activity_9001614_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001614_Ctrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, data = content.rspdata, content.rspdata
		end
		if not data.dailyGift then
			_ENV = data.dailyGift
		end
		self.dailyGift = data.dailyGift
		if not data.notifyGift then
			_ENV = data.notifyGift
		end
		self.notifyGift = data.notifyGift
		self.payAbility = data.payAbility or 0
		self.price = data.price or 0
		if not data.receiveMark then
			_ENV = data.receiveMark
		end
		self.receiveMark = data.receiveMark
	end
end
function activity_9001614_Ctrl:reqReceiveRsp(content)
	dump(content, "activity_9001614_Ctrl:reqReceiveRsp")
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, data = content.rspdata, content.rspdata
		end
		self.dailyGift = data.dailyGift
		self.notifyGift = data.notifyGift
		self.payAbility = data.payAbility
		self.price = data.price
		self.receiveMark = data.receiveMark
		if data.rewards then
			SoraDMailGainItems(data.rewards, true)
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001614_UPDATE"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
	SoraDMailGainItems.activityID = self.activityID
	SoraDSendMessage(SoraDMailGainItems)
end
function activity_9001614_Ctrl:reqBuyDailyGiftRsp(content)
	dump(content, "activity_9001614_Ctrl:reqBuyDailyGiftRsp")
	if content.err == gErrDef.Err_None then
		paymentManager.purchase(content.data.rid, content.rspdata.orderID)
	end
end
function activity_9001614_Ctrl:reqBuyNotifyGiftRsp(content)
	dump(content, "activity_9001614_Ctrl:reqBuyNotifyGiftRsp")
	if content.err == gErrDef.Err_None then
		paymentManager.purchase(content.data.rid, content.rspdata.orderID)
	end
end
function activity_9001614_Ctrl:getReceiveStatusAndNum()
	local retNum = 0
	local activity_9001614_Read = include("activity_9001614_Read")
	local targetList = activity_9001614_Read.getRewardCfg()
	for k, v in ipairs(targetList) do
		if not self.receiveMark[tostring(v.index)] and self.price >= v.rechargeAmount then
			retNum = retNum + 1
		end
	end
	return 0 < retNum, retNum
end
function activity_9001614_Ctrl:getPrice()
	return self.price
end
function activity_9001614_Ctrl:getBoxStatus(index)
	if self.receiveMark[tostring(index)] then
		return gBtnTargetStatusDef.GOT
	end
	local activity_9001614_Read = include("activity_9001614_Read")
	local cfg = activity_9001614_Read.getRewardCfgByIndex(index)
	if cfg.rechargeAmount <= self.price then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001614_Ctrl:getActiveNotifyGift()
	local _ENV, gift
	for k, v in pairs(self.notifyGift) do
		if v.time + 86400 - serviceFunctions.systemTime() > 0 and v.buyCount < 1 then
			_ENV = nil
			;(nil).rechargeid = tonumber(k)
			;(nil).time = v.time
			;(nil).buyCount = v.buyCount
			table.insert(gift, nil)
		end
	end
	if 0 < #gift then
		table.sort(gift, function(a, b)
			return a.time < b.time
		end)
		return true, gift[1]
	end
	_ENV = gift[1]
	return false, gift[1]
end
function activity_9001614_Ctrl:hasBoughtGift(rid)
	return self.dailyGift[tostring(rid)] and true or false
end
return activity_9001614_Ctrl
