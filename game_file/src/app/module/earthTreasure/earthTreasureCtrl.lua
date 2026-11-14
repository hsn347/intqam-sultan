local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local earthTreasureCtrl = class("earthTreasureCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function earthTreasureCtrl:ctor(properties)
	earthTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function earthTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_INIT, handler(self, self.reqEarthTreasureInitRsp))
	msgCtrl.register(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_DRAW, handler(self, self.reqEarthTreasureDrawRsp))
	msgCtrl.register(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_BUY, handler(self, self.reqEarthTreasureBuyRsp))
	self:registerNotify()
end
function earthTreasureCtrl:Logout()
	earthTreasureCtrl.super.Logout(self)
	self:resetData()
end
function earthTreasureCtrl:resetData()
	self.activityInfo, _UPVALUE0_ = nil, nil
	self.group = 1
end
function earthTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EARTH_TREASURE, handler(self, self.notifyHandler))
end
function earthTreasureCtrl:notifyHandler(event)
	dump(event.data, "earthTreasureCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "refreshData" then
			self.activityInfo = v.data
			self.group = v.group
			_ENV = nil
			;(nil).msg = "MESSAGE_REFRESH_EARTH_TREASURE_ACTIVITY"
			;(nil).subMsg = "init"
			SoraDSendMessage(nil)
		elseif "buyGift" == v.type then
			local info = v
			if info.success == true then
				paymentManager.loopForFinishTransaction()
				local reward = info.reward
				local mailid = info.mailID
				local rid = info.rid
				SoraDMailGainItems(reward, true)
				_ENV = reward
				_ENV, reward.msg = true, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(true).result = true
				;(true).rid = rid
				;(true).itemList = reward
				reward.data, (true).mailID = true, mailid
				SoraDSendMessage(reward)
			end
		end
	end
end
function earthTreasureCtrl:reqEarthTreasureInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_INIT, nil)
end
function earthTreasureCtrl:reqEarthTreasureDraw()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_DRAW, nil)
end
function earthTreasureCtrl:reqEarthTreasureBuy()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EARTH_TREASURE_MODULE, gCmd.REQ_EARTH_TREASURE_BUY, nil)
end
function earthTreasureCtrl:reqEarthTreasureInitRsp(content)
	dump(content, "earthTreasureCtrl:reqEarthTreasureInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.activityInfo = content.rspdata
		self.group = content.group
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_REFRESH_EARTH_TREASURE_ACTIVITY"
	gErrDef.Err_None.subMsg = "init"
	SoraDSendMessage(gErrDef.Err_None)
end
function earthTreasureCtrl:reqEarthTreasureDrawRsp(content)
	dump(content, "earthTreasureCtrl:reqEarthTreasureDrawRsp(content)", 10)
	local _ENV, reward = dump, dump
	if content.err == gErrDef.Err_None then
		self.activityInfo = content.rspdata.data
		reward = content.rspdata.reward
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_REFRESH_EARTH_TREASURE_ACTIVITY"
	gErrDef.Err_None.subMsg = "draw"
	gErrDef.Err_None.reward = reward
	SoraDSendMessage(gErrDef.Err_None)
end
function earthTreasureCtrl:reqEarthTreasureBuyRsp(content)
	dump(content, "earthTreasureCtrl:reqEarthTreasureBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.rspdata.rechargeID, orderID)
	end
	_ENV = paymentManager.purchase
	paymentManager.purchase.msg = "MESSAGE_REFRESH_EARTH_TREASURE_ACTIVITY"
	paymentManager.purchase.subMsg = "buy"
	SoraDSendMessage(paymentManager.purchase)
end
function earthTreasureCtrl:getStarLight()
	return self.activityInfo.starLight or 0
end
function earthTreasureCtrl:getCurGiftIndex()
	return self.activityInfo.curGift or 0
end
function earthTreasureCtrl:getGiftTimeOut()
	return self.activityInfo.giftTimeOut or 0
end
function earthTreasureCtrl:getNowRound()
	if not self.activityInfo.gotTreasure then
		_ENV = self.activityInfo.gotTreasure
	end
	return table.nums(self.activityInfo.gotTreasure) + 1
end
function earthTreasureCtrl:getRewardGroup()
	return self.group or 1
end
function earthTreasureCtrl:getGotPosition()
	if not self.activityInfo.gotTreasure then
		_UPVALUE0_ = self.activityInfo.gotTreasure
	end
	return self.activityInfo.gotTreasure
end
return earthTreasureCtrl
