local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ramadanMarketCtrl = class("ramadanMarketCtrl", GameModule)
function ramadanMarketCtrl:ctor(properties)
	ramadanMarketCtrl.super.ctor(self, properties)
end
function ramadanMarketCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_BUY, handler(self, self.sendReqBuyRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_NEW_DAY, handler(self, self.sendReqNewDayRsp))
	self:resetData()
	self:registerNotify()
end
function ramadanMarketCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_MARKET, handler(self, self.notifyHandler))
end
function ramadanMarketCtrl:notifyHandler(event)
	dump(event.data, "ramadanMarketCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		dump(content, "ramadanMarketCtrl:notifyHandler", 10)
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_MARKET"
		self.subMsg = "refresh"
		SoraDSendMessage(self)
	end
end
function ramadanMarketCtrl:initClientData(data)
	dump(data, "ramadanMarketCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function ramadanMarketCtrl:Logout()
	self:resetData()
	ramadanMarketCtrl.super.Logout(self)
end
function ramadanMarketCtrl:resetData()
	self.onSaleInfo, _UPVALUE0_ = nil, nil
end
function ramadanMarketCtrl:setData(data)
	if not data and not next(data) then
		return
	end
	self.onSaleInfo = data.onSaleInfo
	table.sort(self.onSaleInfo, function(a, b)
		if a.position < b.position then
			return a.position < b.position
		end
	end)
	dump(self.onSaleInfo, "fskwrwereroeiroeiroerio")
end
function ramadanMarketCtrl:sendDataMsg()
	serverproxy:Request(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_INIT)
end
function ramadanMarketCtrl:sendRewardMsg(shopItemID, buyCount)
	serverproxy = nil
	;(nil).shopItemID = shopItemID
	;(nil).buyCount = buyCount
	serverproxy:Request(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_BUY, nil)
end
function ramadanMarketCtrl:sendNewDayMsg()
	serverproxy:Request(gCmd.CMD_RAMADAN_MARKET_MODULE, gCmd.REQ_RAMADAN_MARKET_NEW_DAY)
end
function ramadanMarketCtrl:sendReqInitRsp(content)
	dump(content, "ramadanMarketCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_MARKET"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function ramadanMarketCtrl:sendReqBuyRsp(content)
	dump(content, "==ramadanMarketCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.onSaleInfo[tostring(content.data.shopItemID)].alreadyBuyCount = data.curInfo.alreadyBuyCount
		dump(self.onSaleInfo, "the buy num change on sale good")
		_ENV = self.onSaleInfo
		self.onSaleInfo.msg = "MESSAGE_RAMADAN_MARKET"
		self.onSaleInfo.subMsg = "buy"
		self.onSaleInfo.itemID = data.curInfo.itemID
		self.onSaleInfo.buyCount = content.data.buyCount
		SoraDSendMessage(self.onSaleInfo)
		return
	end
	if content.err == gErrDef.Err_RAMADAN_MARKET_NOT_ENOUGH_ACTIVE_NUM then
		SoraDShowMsgTip(i18n("ramddantent_text_03"))
		return
	end
	if content.err == gErrDef.Err_RAMADAN_MARKET_NOT_ENOUGH_GOLD then
		SoraDShowMsgTip(i18n("artifact_text_20"))
		return
	end
	if content.err == gErrDef.Err_RAMADAN_MARKET_SHOPITEMID_ERR then
		print("itemID异常")
		SoraDShowMsgTip(i18n("notice_0026"))
		return
	end
	if content.err == gErrDef.Err_RAMADAN_MARKET_BUYCOUNT_ERRN then
		print("buyCount 异常")
		SoraDShowMsgTip(i18n("notice_0026"))
		return
	end
end
function ramadanMarketCtrl:sendReqNewDayRsp(content)
	dump(content, "==ramadanMarketCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		print("模拟跨天成功")
		SoraDShowMsgTip("模拟跨天成功")
	end
end
function ramadanMarketCtrl:getReceiveStatusAndNum()
	return false
end
function ramadanMarketCtrl:getOnSaleInfo()
	return self.onSaleInfo
end
return ramadanMarketCtrl
