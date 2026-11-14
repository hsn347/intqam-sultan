local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local rechargePresentCtrl = class("rechargePresentCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function rechargePresentCtrl:getRechargePresentGiftNum(rid, activityID)
	local giftData = self.rechargePresentGift
	if giftData[tostring(rid)] then
		return giftData[tostring(rid)] and giftData[tostring(rid)][1] and giftData[tostring(rid)][1].count or 0
	end
	return 0
end
function rechargePresentCtrl:getRechargePresentGold(activityID)
	return self.data.presentGold
end
function rechargePresentCtrl:getRechargePresentBuyNum(rid, activityID)
	local buyList = self.data.buyList
	if buyList then
		local id = tostring(rid)
		if buyList[id] then
			return buyList[id]
		end
	end
	return 0
end
function rechargePresentCtrl:getRechargePresentGiftReq(activityID)
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, data)
end
function rechargePresentCtrl:sendPresentGiftExchange(exchangeID, activityID)
	if exchangeID then
		serverproxy = nil
		local (nil).exchangeID, data = exchangeID, nil
		serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, data)
	end
end
function rechargePresentCtrl:ctor(properties)
	rechargePresentCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
end
;(function(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getRechargePresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, handler(self, self.reqPresentGiftExchangeRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_NEWYEAR_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getNewyearPresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEW_YEAR_PRESENT_GIFT_EXCHANGE, handler(self, self.reqNewyearPresentGiftExchangeRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).buyList, _ENV, _ENV, rechargePresentCtrl.EnterGame = nil, nil, function(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getRechargePresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, handler(self, self.reqPresentGiftExchangeRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_NEWYEAR_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getNewyearPresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEW_YEAR_PRESENT_GIFT_EXCHANGE, handler(self, self.reqNewyearPresentGiftExchangeRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end, function(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getRechargePresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, handler(self, self.reqPresentGiftExchangeRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_NEWYEAR_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getNewyearPresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEW_YEAR_PRESENT_GIFT_EXCHANGE, handler(self, self.reqNewyearPresentGiftExchangeRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
local (function(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getRechargePresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, handler(self, self.reqPresentGiftExchangeRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_NEWYEAR_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getNewyearPresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEW_YEAR_PRESENT_GIFT_EXCHANGE, handler(self, self.reqNewyearPresentGiftExchangeRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).presentGold, data_default = 0, function(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getRechargePresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_SULTAN_EX_PRESENT_GIFT_EXCHANGE, handler(self, self.reqPresentGiftExchangeRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_NEWYEAR_PRESENT_EX_GIFT_IN_REDIS, handler(self, self.getNewyearPresentGiftRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_NEW_YEAR_PRESENT_GIFT_EXCHANGE, handler(self, self.reqNewyearPresentGiftExchangeRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
data_default.__index = data_default
function rechargePresentCtrl:resetData()
	_UPVALUE0_ = nil
	self:setData(nil)
	_UPVALUE0_ = nil
	self:setNewyearData(nil)
	self.newyearPresentGift, _UPVALUE0_, self.rechargePresentGift, _UPVALUE0_ = self.setNewyearData, self.setNewyearData, self.setNewyearData, self.setNewyearData
end
function rechargePresentCtrl:setData(data, notify)
	if not data then
		data, _ENV = nil, nil
	end
	self.data = data
	setmetatable(self.data, data_default)
	if notify then
		_ENV = self.data
		self.data.msg = "MESSAGE_RECHARGE_PRESENT_REFRESH"
		SoraDSendMessage(self.data)
	end
end
function rechargePresentCtrl:setNewyearData(data, notify)
	if not data then
		data, _ENV = nil, nil
	end
	self.newyearData = data
	setmetatable(self.newyearData, data_default)
	if notify then
		_ENV = self.newyearData
		self.newyearData.msg = "MESSAGE_RECHARGE_PRESENT_REFRESH"
		SoraDSendMessage(self.newyearData)
	end
end
function rechargePresentCtrl:Logout()
	rechargePresentCtrl.super.Logout(self)
	self:resetData()
end
function rechargePresentCtrl:initClientData(data)
	local rechargePresentUtil = include("rechargePresentUtil")
	if rechargePresentUtil.checkActivityOpen(self.activityID) then
		self:getRechargePresentGiftReq(self.activityID)
	end
	if not data then
		return
	end
	local activityData = data[tostring(self.activityID)]
	self:setData(activityData)
	self:setNewyearData(activityData)
end
function rechargePresentCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = tonumber(notifyMsg.activityID)
		if activityID == self.activityID then
			self:updateData(notifyMsg.notifyData, activityID)
		end
	end
end
function rechargePresentCtrl:updateData(data, activityID)
	if data.presentGold then
		self:updateePresentGold(data.presentGold, activityID)
	end
end
function rechargePresentCtrl:updateePresentGold(value, activityID)
	if activityID == self.activityID then
		self.data.presentGold = value
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_RECHARGE_PRESENT_REFRESH"
	SoraDSendMessage(nil)
end
function rechargePresentCtrl:getRechargePresentGiftRsp(content)
	if content.err == gErrDef.Err_None then
		if not content.rspData.rewardInfo then
			_ENV = content.rspData.rewardInfo
		end
		self.rechargePresentGift = content.rspData.rewardInfo
	end
end
function rechargePresentCtrl:reqPresentGiftExchangeRsp(event)
	if event.err == gErrDef.Err_None then
		if event.rspdata.initData then
			self:setData(event.rspdata.initData, true)
		end
		self:popRechargeSuccessView(event)
	end
end
function rechargePresentCtrl:getNewyearPresentGiftRsp(content)
	if content.err == gErrDef.Err_None then
		if not content.rspData.rewardInfo then
			_ENV = content.rspData.rewardInfo
		end
		self.newyearPresentGift = content.rspData.rewardInfo
	end
end
function rechargePresentCtrl:reqNewyearPresentGiftExchangeRsp(event)
	if event.err == gErrDef.Err_None then
		if event.rspdata.initData then
			self:setNewyearData(event.rspdata.initData, true)
		end
		self:popRechargeSuccessView(event)
	end
end
function rechargePresentCtrl:popRechargeSuccessView(event)
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	local _rid = event.data.exchangeID
	local goods = event.rspdata.reward
	local mailID = event.rspdata.mailid
	rechargePopMsg(goods, mailID, _rid)
	_ENV = goods
	_ENV, goods.msg = mailID, "MESSAGE_SERVER_RECHARGECENTER_EXTRA_UI_REFRESH"
	goods.data, mailID.rid = mailID, _rid
	SoraDSendMessage(goods)
end
return rechargePresentCtrl
