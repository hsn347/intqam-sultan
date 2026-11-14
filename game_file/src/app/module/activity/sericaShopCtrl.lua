local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local sericaShopCtrl = class("sericaShopCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function sericaShopCtrl:ctor(properties)
	sericaShopCtrl.super.ctor(self, properties)
	self:resetData()
end
function sericaShopCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_INIT, handler(self, self.reqSericaShopInitRsp))
	msgCtrl.register(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_SELECT, handler(self, self.reqSericaShopSelectRsp))
	msgCtrl.register(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_BUY, handler(self, self.reqSericaShopBuyRsp))
	self:registerNotify()
end
function sericaShopCtrl:Logout()
	sericaShopCtrl.super.Logout(self)
	self:resetData()
end
function sericaShopCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function sericaShopCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SERICA_SHOP, handler(self, self.notifyHandler))
end
function sericaShopCtrl:notifyHandler(event)
	dump(event.data, "sericaShopCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.initData then
			self.initData = v.initData
			_ENV = nil
			;(nil).msg = "MESSAGE_ACTIVITY_9001528_UPDATE"
			SoraDSendMessage(nil)
		end
		if v.rid then
			paymentManager.loopForFinishTransaction()
			SoraDMailGainItems(v.reward, true)
			_ENV = v.reward
			_ENV, v.reward.msg = true, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(true).result = true
			v.reward.data, (true).itemList = true, reward
			SoraDSendMessage(v.reward)
		end
	end
end
function sericaShopCtrl:reqSericaShopInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_INIT, nil)
end
function sericaShopCtrl:reqSericaShopInitRsp(content)
	dump(content, "sericaShopCtrl:reqSericaShopInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001528_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function sericaShopCtrl:reqSericaShopSelect(rid, selectIndexs)
	serverproxy = nil
	;(nil).rid = rid
	;(nil).selectIndexs = selectIndexs
	serverproxy:Request(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_SELECT, nil)
end
function sericaShopCtrl:reqSericaShopSelectRsp(content)
	dump(content, "sericaShopCtrl:reqSericaShopSelectRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
	end
end
function sericaShopCtrl:reqSericaShopBuy(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_SERICA_SHOP_MODULE, gCmd.REQ_SERICA_SHOP_BUY, nil)
end
function sericaShopCtrl:reqSericaShopBuyRsp(content)
	dump(content, "sericaShopCtrl:reqSericaShopBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(content.data.rid, rspdata.orderID)
	end
end
function sericaShopCtrl:getBuyCountByID(rechargeID)
	if self.initData.buyRecord then
		return self.initData.buyRecord[tostring(rechargeID)] or 0
	end
	return 0
end
function sericaShopCtrl:getSelectRecordByID(rechargeID)
	if self.initData.selectRecord then
		if not self.initData.selectRecord[tostring(rechargeID)] then
			_ENV = self.initData.selectRecord[tostring(rechargeID)]
		end
		return self.initData.selectRecord[tostring(rechargeID)]
	end
	_ENV = self.initData.selectRecord[tostring(rechargeID)]
	return self.initData.selectRecord[tostring(rechargeID)]
end
return sericaShopCtrl
