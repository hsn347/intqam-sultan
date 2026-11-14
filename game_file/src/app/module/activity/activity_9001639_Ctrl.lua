local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001639_Ctrl = class("activity_9001639_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001639_Ctrl:ctor(properties)
	activity_9001639_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY
	self:resetData()
end
function activity_9001639_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CORBAN_MARKET_MODULE, gCmd.REQ_CORBAN_MARKET_INIT, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_CORBAN_MARKET_MODULE, gCmd.REQ_CORBAN_MARKET_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:registerNotify()
end
function activity_9001639_Ctrl:Logout()
	activity_9001639_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001639_Ctrl:resetData()
	_UPVALUE0_ = nil
	self.record, _UPVALUE0_, self.initData, (nil).purchasedGift, _UPVALUE0_, (nil).giftRewards, _UPVALUE0_, (nil).cumulateGold = nil, nil, nil, nil, nil, nil, nil, 0
end
function activity_9001639_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CORBAN_MARKET, handler(self, self.notifyHandler))
end
function activity_9001639_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001639_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "buyGift" then
			self.initData = v.notifyData.initData
			if v.notifyData.success then
				paymentManager.loopForFinishTransaction()
				local reward = v.notifyData.reward
				local rid = v.notifyData.rid
				_ENV = nil
				_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(nil).result = true
				;(nil).rid = rid
				;(nil).data, (nil).itemList = nil, reward
				SoraDSendMessage(nil)
			end
		elseif v.notifyType == "refreshData" then
			self.initData = v.notifyData.initData
		elseif v.notifyType == "addRecord" then
			table.insert(self.record, 1, v.notifyData)
		elseif v.notifyType == "cumulateReward" then
			_ENV = v.notifyData
			v.notifyData.rewards = v.notifyData.rewards
			uiManager:show("Activity_9001639_StagePop", v.notifyData)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001639_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001639_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CORBAN_MARKET_MODULE, gCmd.REQ_CORBAN_MARKET_INIT, nil)
end
function activity_9001639_Ctrl:reqBuyGift(rechargeID)
	serverproxy = nil
	;(nil).rechargeID = rechargeID
	serverproxy:Request(gCmd.CMD_CORBAN_MARKET_MODULE, gCmd.REQ_CORBAN_MARKET_BUY_GIFT, nil)
end
function activity_9001639_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001639_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		if not content.rspdata.record then
			_ENV = content.rspdata.record
		end
		self.record = content.rspdata.record
	end
end
function activity_9001639_Ctrl:reqBuyGiftRsp(content)
	dump(content, "activity_9001639_Ctrl:reqBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.data.rechargeID, orderID)
	end
end
function activity_9001639_Ctrl:getReceiveStatusAndNum()
	local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local shopList = newExchangeMallCtrl:getConfigByActivityID(gActivityTimeActivityID.CORBAN_MARKEY_EXCHANGE, SoraDGetActivityClassType(self.activityID))
	for k, v in ipairs(shopList) do
		if v.remindStatus == 1 and v.limitnum - v.curExchangeNum > 0 and backpackCtrl:getItemCount(v.exchangeitem[1]) >= v.exchangeitem[2] then
			return true, -1
		end
	end
	return false
end
function activity_9001639_Ctrl:getGiftBoughtCount(rid)
	return self.initData.purchasedGift[tostring(rid)] or 0
end
function activity_9001639_Ctrl:getCumulateGold()
	return self.initData.cumulateGold
end
function activity_9001639_Ctrl:getRecord()
	return self.record
end
return activity_9001639_Ctrl
