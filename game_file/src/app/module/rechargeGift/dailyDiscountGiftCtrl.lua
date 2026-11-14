local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local dailyDiscountGiftCtrl = class("dailyDiscountGiftCtrl", gamemodulec)
function dailyDiscountGiftCtrl:buyGift(giftID)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_DAILY_DISCOUNT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT, gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT
	;(nil).data, gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT.rechargeID = gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT, giftID
	local msg
	serverproxy:SendMsg(msg)
end
function dailyDiscountGiftCtrl:buyGiftRsp(content)
	dump(content, "dailyDiscountGiftCtrl:buyGiftRsp", 10)
	if content.err == gErrDef.Err_None then
		local giftid = content.data.rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(giftid, orderID)
	else
		print("adderGiftCtrl:buyGiftRsp err", content.err)
		_ENV = "adderGiftCtrl:buyGiftRsp err"
		;("adderGiftCtrl:buyGiftRsp err").msg = "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH"
		SoraDSendMessage("adderGiftCtrl:buyGiftRsp err")
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function dailyDiscountGiftCtrl:receiveGift(subCmd)
	if subCmd then
		serverproxy = nil
		;(nil).cmd = gCmd.CMD_DAILY_DISCOUNT_MODULE
		;(nil).subcmd = subCmd
		serverproxy:SendMsg(nil)
	end
end
function dailyDiscountGiftCtrl:receiveFreeGiftRsp(content)
	dump(content, "dailyDiscountGiftCtrl:receiveFreeGiftRsp", 10)
	if content.err == gErrDef.Err_None then
		self.dailyDiscountGiftData.freeGiftTime = content.rspdata.freeGiftTime
		SoraDMailGainItems(self.freeGiftData, true)
		_ENV = self.freeGiftData
		self.freeGiftData.msg = "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH"
		SoraDSendMessage(self.freeGiftData)
	end
end
function dailyDiscountGiftCtrl:receiveSpecialGiftRsp(content)
	dump(content, "dailyDiscountGiftCtrl:receiveSpecialGiftRsp", 10)
	if content.err == gErrDef.Err_None then
		self.dailyDiscountGiftData.rewardGiftTime = content.rspdata.rewardGiftTime
		SoraDMailGainItems(self.specialGiftData, true)
		_ENV = self.specialGiftData
		self.specialGiftData.msg = "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH"
		SoraDSendMessage(self.specialGiftData)
	end
end
function dailyDiscountGiftCtrl:noitfyDataRsp(event)
	dump(event, "noitfyDataRsp", 5)
	if event.data then
		for _, content in pairs(event.data) do
			local info = content.data
			local giftType = content.type
			if "buyGift" == giftType then
				self.dailyDiscountGiftData.buyGiftList = info.buyGiftList
				if info.success == true then
					paymentManager.OnemtRechargeSuccess(info.price)
					paymentManager.loopForFinishTransaction()
					local reward = info.reward
					local mailid = info.mailid
					local rid = info.rid
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					;(nil).rid = rid
					;(nil).itemList = reward
					;(nil).data, (nil).mailID = nil, mailid
					SoraDSendMessage(nil)
				end
				_ENV = info.mailid
				info.mailid.msg = "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH"
				SoraDSendMessage(info.mailid)
			elseif "refreshData" == giftType then
				self.dailyDiscountGiftData = content.data
				self:getGiftData()
				_ENV = self
				self.msg = "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH"
				SoraDSendMessage(self)
			end
		end
	end
end
function dailyDiscountGiftCtrl:getDailyDiscountGiftData(...)
	return self.dailyDiscountGiftData
end
function dailyDiscountGiftCtrl:getFreeGiftData()
	return self.freeGiftData
end
function dailyDiscountGiftCtrl:getspecialGiftData()
	return self.specialGiftData
end
function dailyDiscountGiftCtrl:getFirstGiftID()
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		return v.rechargeID
	end
end
function dailyDiscountGiftCtrl:ctor(properties)
	dailyDiscountGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function dailyDiscountGiftCtrl:resetData()
	self.dailyDiscountGiftData, _UPVALUE0_ = nil, nil
end
function dailyDiscountGiftCtrl:getGiftData()
	if self.dailyDiscountGiftData.rewardGroup then
		local giftData = require("app." .. LocalTblPath .. ".config_server.special_offer_daily_reward")
		for k, v in ipairs(giftData) do
			if v.cover == self.dailyDiscountGiftData.rewardGroup and v.number == 0 then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				self.freeGiftData = serviceFunctions.tableFormat(v.reward, nil)
			elseif v.cover == self.dailyDiscountGiftData.rewardGroup and v.number ~= 0 then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				self.specialGiftData = serviceFunctions.tableFormat(v.reward, nil)
			end
		end
	end
end
function dailyDiscountGiftCtrl:initClientData(data)
	if nil == data then
		return
	end
	self.dailyDiscountGiftData = data
	self:getGiftData()
	self:registerNotify()
end
function dailyDiscountGiftCtrl:EnterGame()
	dailyDiscountGiftCtrl.super.EnterGame(self)
	print("dailyDiscountGiftCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_BUY_DAILY_DISCOUNT_GIFT, handler(self, self.buyGiftRsp))
	msgCtrl.register(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_FREE_GIFT, handler(self, self.receiveFreeGiftRsp))
	msgCtrl.register(gCmd.CMD_DAILY_DISCOUNT_MODULE, gCmd.REQ_RECEIVE_SPECIAL_GIFT, handler(self, self.receiveSpecialGiftRsp))
end
function dailyDiscountGiftCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DAILY_DISCOUNT_GIFT, handler(self, self.noitfyDataRsp))
end
function dailyDiscountGiftCtrl:Logout()
	dailyDiscountGiftCtrl.super.Logout(self)
	self:resetData()
end
return dailyDiscountGiftCtrl
