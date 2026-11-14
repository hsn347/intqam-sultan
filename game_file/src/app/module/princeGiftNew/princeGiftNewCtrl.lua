local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local princeGiftNewCtrl = class("princeGiftNewCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local newPrinceGiftRead = include("newPrinceGiftRead")
function princeGiftNewCtrl:ctor(properties)
	princeGiftNewCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEW_PRINCE_GIFT_ACTIVITY
	self.giftID = 14308
	self.giftData = clone(newPrinceGiftRead.getGiftData(self.giftID))
end
function princeGiftNewCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_PRINCE_GIFT_MODULE, gCmd.REQ_NEW_PRINCE_GIFT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NEW_PRINCE_GIFT_MODULE, gCmd.REQ_NEW_PRINCE_GIFT_BUY, handler(self, self.reqBuyPackageRsp))
	self:resetData()
	self:registerNotify()
	self:reqInitInfo()
end
function princeGiftNewCtrl:initClientData(data)
	if not data then
		return
	end
end
function princeGiftNewCtrl:resetData()
	self.clientData = nil
end
function princeGiftNewCtrl:Logout()
	self:resetData()
	princeGiftNewCtrl.super.Logout(self)
end
function princeGiftNewCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_PRINCE_GIFT, handler(self, self.notifyHandler))
end
function princeGiftNewCtrl:notifyHandler(event)
	dump(event.data, "princeGiftNewCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content.type == "buyGift" then
			for k, v in pairs(content.data) do
				_ENV = nil
				;(nil).ID = k
				self.clientData, (nil).data = nil, v
			end
			_ENV = pairs(content.data)
			pairs(content.data).msg = "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE"
			SoraDSendMessage(pairs(content.data))
			_ENV = pairs(content.data)
			pairs(content.data).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			pairs(content.data).activityID = self.activityID
			SoraDSendMessage(pairs(content.data))
		elseif content.type == "refresh" then
			for k, v in pairs(content.data) do
				_ENV = nil
				;(nil).ID = k
				self.clientData, (nil).data = nil, v
			end
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
	SoraDSendMessage(pairs(event.data))
end
function princeGiftNewCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_NEW_PRINCE_GIFT_MODULE, gCmd.REQ_NEW_PRINCE_GIFT_INIT, data)
end
function princeGiftNewCtrl:reqBuyPackage(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_NEW_PRINCE_GIFT_MODULE, gCmd.REQ_NEW_PRINCE_GIFT_BUY, data)
end
function princeGiftNewCtrl:reqInitRsp(content)
	dump(content, "princeGiftNewCtrl:reqInitRsp===", 10)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	dump(activityShowCtrl:getShowDataByID(self.activityID), "activityData", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(content.rspdata) do
			_ENV = nil
			;(nil).ID = k
			self.clientData, (nil).data = nil, v
		end
	end
end
function princeGiftNewCtrl:reqBuyPackageRsp(content)
	dump(content, "princeGiftNewCtrl:reqBuyPackageRsp===", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.data.rechargeID, orderID)
	else
		SoraDShowMsgTip(i18n("common_text_4815"))
		SoraDCloseLoading()
	end
end
function princeGiftNewCtrl:getNewPrinceData()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if self.clientData == nil or SoraDGetCastleLv() >= 30 or self:getIsBuy() or activityShowCtrl:getStateByID(self.activityID) ~= gActivityState.OPEN then
		return nil
	end
	return self.clientData, self.giftData
end
function princeGiftNewCtrl:getIsBuy()
	local isBuy = false
	if self.clientData and self.clientData.data and self.clientData.data.buyNum > 0 then
		isBuy = true
	end
	return isBuy
end
function princeGiftNewCtrl:getLeftTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		return leftTime
	end
	return 0
end
function princeGiftNewCtrl:getBuffEndTime()
	local buffEndTime = 0
	if self.clientData and self.clientData.data and self.clientData.data.buffEndTime then
		buffEndTime = self.clientData.data.buffEndTime
	end
	return buffEndTime
end
function princeGiftNewCtrl:getGiftID()
	return self.giftID
end
function princeGiftNewCtrl:getActiviyID()
	return self.activityID
end
function princeGiftNewCtrl:getBuffDesc()
	_ENV = nil
	;(nil).num1 = self.giftData.buffValue / 60
	_ENV, _ENV, (nil).num2 = nil, self.giftData.buffTime / 86400, self.giftData.buffTime / 86400
	_ENV, (self.giftData.buffTime / 86400).num1, (nil).color = nil, nil, "#00FF00"
	_ENV, (self.giftData.buffTime / 86400).num2, (nil).color = nil, nil, "#00FF00"
	;(self.giftData.buffTime / 86400).__default, (nil).color = nil, "#FAD26E"
	local desc = i18n_html(self.giftData.buffDescribe, nil, self.giftData.buffTime / 86400)
	return desc
end
function princeGiftNewCtrl:getBuffEffect()
	local remainTime = self:getBuffEndTime() - serviceFunctions.systemTime()
	local buffValue = 0
	if 0 < remainTime then
		buffValue = self.giftData.buffValue
	end
	return buffValue
end
return princeGiftNewCtrl
