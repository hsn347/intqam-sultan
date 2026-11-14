local gamemodulec = include("GameModule")
local rechargeCtrl = class("rechargeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function rechargeCtrl:ctor(properties)
	rechargeCtrl.super.ctor(self, properties)
	self:resetData()
end
function rechargeCtrl:resetData()
	self.rechargeList, _UPVALUE0_ = nil, nil
	self.handle_notify = nil
	self.handle_notify_rechargeList = nil
end
function rechargeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_CHECK, handler(self, self.rechargeCheckRsp))
	msgCtrl.register(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_VERIFY, handler(self, self.rechargeVerifyRsp))
end
function rechargeCtrl:Logout()
	rechargeCtrl.super.Logout(self)
	self:resetData()
end
function rechargeCtrl:addTransData(orderID, data)
	if not self.transData then
		self.transData, _UPVALUE0_ = self.transData, self.transData
	end
	if orderID then
		self.transData[orderID] = data
	else
		self.nowTransaction = data
	end
end
function rechargeCtrl:getTransData(orderID)
	if self.transData and orderID then
		return self.transData[orderID]
	end
	return self.nowTransaction
end
function rechargeCtrl:rechargeCheckReq(rid, ...)
	local platform = gRechargePlatform.IOS
	if device.platform == "android" then
		platform = gRechargePlatform.ANDROID
	end
	_ENV = nil
	;(nil).rid = rid
	;(nil).platform = platform
	serverproxy:Request(gCmd.CMD_RECHARGE_MODULE, gCmd.REQ_RECHARGE_CHECK, nil, ...)
end
function rechargeCtrl:rechargeCheckRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local rid = content.data.rid
		local orderID = content.data.orderID
		paymentManager.purchase(rid, orderID)
	else
		print("rechargeCheckRsp err", err)
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function rechargeCtrl:rechargeIOSVerify(rid, receipt, currency, transaction, orderID, pushID, ...)
	self:addTransData(orderID, transaction)
	local rChannel = gRechargeChannel.APPLE
	if userSDKManager.getChannel() == "ko_ios" then
		rChannel = gRechargeChannel.KO_IOS
	end
	local realPrice, isGetPrice, log = paymentManager.getRealPriceLog(rid, 0, receipt)
	local crypt = require("crypt")
	_ENV, receipt = crypt.base64encode(receipt), crypt.base64encode(receipt)
	crypt.base64encode(receipt).rid = rid
	crypt.base64encode(receipt).rChannel = rChannel
	crypt.base64encode(receipt).receipt = receipt
	crypt.base64encode(receipt).orderID = orderID
	crypt.base64encode(receipt).currency = currency
	crypt.base64encode(receipt).clientVersion = GAME_VERSION
	crypt.base64encode(receipt).pushID = pushID
	crypt.base64encode(receipt).realPrice = realPrice
	local crypt.base64encode(receipt).log, data = log, crypt.base64encode(receipt)
	serverproxy:Request(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_VERIFY, data, ...)
end
function rechargeCtrl:rechargeGooglePlayVerify(rid, originalJson, signature, currency, androidRedata, orderID, pushID, ...)
	self.androidRedata = androidRedata
	local rChannel = paymentManager.getStoreChannel()
	print("rechargeCtrl:rechargeGooglePlayVerify", tostring(rid), rChannel)
	local realPrice, isGetPrice, log = paymentManager.getRealPriceLog(rid, 0, originalJson)
	_ENV = originalJson
	originalJson.rid = rid
	originalJson.rChannel = rChannel
	originalJson.originalJson = originalJson
	originalJson.orderID = orderID
	originalJson.signature = signature
	originalJson.currency = currency
	originalJson.clientVersion = GAME_VERSION
	originalJson.pushID = pushID
	originalJson.realPrice = realPrice
	local originalJson.log, data = log, originalJson
	serverproxy:Request(gCmd.CMD_RECAHRGE_SERVER_MODULE, gCmd.REQ_RECHARGE_VERIFY, data, ...)
end
function rechargeCtrl:rechargeVerifyRsp(content)
	local orderID = content.data.orderID
	local rid = content.data.rid
	if content.data.rChannel == gRechargeChannel.GOOGLE_PLAY then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
		end
	elseif content.data.rChannel == gRechargeChannel.APPLE or content.data.rChannel == gRechargeChannel.KO_IOS then
		local nowTransaction = self:getTransData(orderID)
		if nowTransaction then
			paymentManager.finishTransaction(nowTransaction, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, nowTransaction)
		end
	elseif content.data.rChannel == gRechargeChannel.BAZAAR then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
		end
	elseif content.data.rChannel == gRechargeChannel.AMAZON then
		if self.androidRedata then
			paymentManager.finishTransaction(self.androidRedata, rid, orderID)
			paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
		end
	elseif content.data.rChannel == gRechargeChannel.HUAWEI and self.androidRedata then
		paymentManager.finishTransaction(self.androidRedata, rid, orderID)
		paymentManager.OnemtPost2ServerSuccess(rid, self.androidRedata)
	end
	paymentManager.loopForFinishTransaction()
end
function rechargeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RECHARGE, handler(self, self.notifyRecharge))
	self.handle_notify_rechargeList = notifyCtrl:register(gNotifyID.RECHARGE_LIST, handler(self, self.notifyList))
	self.handle_notify_payprice = notifyCtrl:register(gNotifyID.RECHARGE_PRICE_REPORT, handler(self, self.notifyPayPrice))
end
function rechargeCtrl:notifyPayPrice(event)
	dump(event, "notifyPayPrice")
	for k, v in pairs(event.data) do
		userSDKManager.reportPay(v.price)
	end
end
function rechargeCtrl:notifyList(event)
	for k, v in pairs(event.data) do
		dump(event.data, "rechargeCtrl:notifyList", 10)
		self.rechargeList = v.rechargelist
		_ENV = event.data
		event.data.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWGOLDREFRESH"
		SoraDSendMessage(event.data)
	end
end
function rechargeCtrl:notifyRecharge(event)
	for k, v in pairs(event.data) do
		local rid = v.rid
		local result = v.result
		local price = v.price
		local add_gold = v.add_gold or 0
		local isfirst = v.isfirst or false
		self.rechargeList = v.rechargelist
		self:dealExtraRechargeData()
		if result then
			paymentManager.OnemtRechargeSuccess(price)
		end
		_ENV = price
		_ENV, price.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		;(nil).result = result
		;(nil).rid = rid
		price.data, (nil).goldCount = nil, add_gold
		SoraDSendMessage(price)
		if isfirst then
			SoraDShowMsgTip(i18n("common_text_2770"))
		end
	end
end
function rechargeCtrl:dealExtraRechargeData()
	if type(self.rechargeList) == "table" then
		for k, v in pairs(self.rechargeList) do
			if v.ID and v.ID >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and v.ID <= gExtraGiftIDDef.NORMAL_GIFT_END then
				gModuleMgr.sharedMgr("rechargeExtraltCtrl"):addExtraData(clone(v))
			end
		end
	end
end
function rechargeCtrl:initClientData(data)
	self.rechargeList = data.retdata
	self:dealExtraRechargeData()
	self:registerNotify()
	include("rechargeRead").initAndRepalceBaseData()
end
return rechargeCtrl
