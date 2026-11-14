paymentManager, _ENV = nil, nil
paymentManager.bullets, _ENV = nil, nil
paymentManager.enableToPay = true
paymentManager.recentFinishFlag = false
paymentManager.isInRecharging = false
paymentManager.isInit = false
paymentManager.canPost2Server = false
paymentManager.loadNoFinishDone = false
paymentManager.android, _ENV = nil, nil
paymentManager.android.noFinishedList, _ENV = nil, nil
paymentManager.ios, _ENV = nil, nil
paymentManager.ios.noFinishedList, _ENV = nil, nil
function paymentManager.getStoreChannel()
	local rChannel = gRechargeChannel.GOOGLE_PLAY
	if userSDKManager.getChannel() == "fa" then
		rChannel = gRechargeChannel.BAZAAR
	elseif userSDKManager.getChannel() == "ko_android" then
		rChannel = gRechargeChannel.KO_ANDROID
	elseif userSDKManager.getChannel() == "ko_onestore" then
		rChannel = gRechargeChannel.KO_ONESTORE
	elseif userSDKManager.getPlatformChannel() == "amazon" then
		rChannel = gRechargeChannel.AMAZON
	elseif userSDKManager.getPlatformChannel() == "huawei" then
		rChannel = gRechargeChannel.HUAWEI
	elseif userSDKManager.getChannel() == "cp_android" then
		rChannel = gRechargeChannel.CP
	end
	return rChannel
end
function paymentManager.createOrderID()
	local serverproxy = gModuleMgr.getObject("serverproxy")
	local user = serverproxy.loginCtrl_.token.user
	local time = os.time()
	return crypto.md5(user .. time, false)
end
function paymentManager.rid2BuyType(rid)
	if paymentManager.getPaymentBullets(rid) then
		return paymentManager.getPaymentBullets(rid).isActive
	else
		return 0
	end
end
function paymentManager.valToKey(tbl, val)
	for k, v in pairs(tbl) do
		if v.productIdentifier == val then
			return k
		end
	end
	return nil
end
function paymentManager.getPaymentBullets(rid)
	local info = paymentManager.bullets[rid]
	info = info or gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getRechargeClientCfgDataByID(rid)
	return info
end
function paymentManager.rid2Pid(rid)
	rid = tonumber(rid)
	local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
	if pid then
		return paymentManager.products[pid].productIdentifier
	else
		return nil
	end
end
function paymentManager.rid2TokenPirce(rid)
	rid = tonumber(rid)
	local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
	if pid then
		return paymentManager.products[pid].token[2]
	else
		return nil
	end
end
function paymentManager.pid2Rid(productIdentifier)
	local pid, rid
	for k, v in pairs(paymentManager.products) do
		if v.productIdentifier == productIdentifier then
			pid = k
			break
		end
	end
	for k, v in pairs(paymentManager.bullets) do
		if v.pid == pid then
			rid = k
			break
		end
	end
	rid = rid or gModuleMgr.sharedMgr("rechargeExtraltCtrl"):getRidByPid(pid)
	return rid
end
function paymentManager.productIdentifier2Pid(productIdentifier)
	local pid
	for k, v in pairs(paymentManager.products) do
		if v.productIdentifier == productIdentifier then
			pid = k
			break
		end
	end
	return pid
end
function paymentManager.getCurrencyByRID(rid, receipt)
	local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
	if not pid and receipt then
		pid = paymentManager.getPidByReceipt(receipt)
	end
	if pid and paymentManager.products[pid].currency ~= "" then
		return paymentManager.products[pid].currency
	end
	return "US $"
end
function paymentManager.popPayFromLocalByOrderID(orderID)
	local rePay
	local idx = 0
	for k, v in pairs(paymentManager.popAllPayFromLocal()) do
		if v.orderID == orderID then
			rePay = v
			idx = k
			break
		end
	end
	return rePay, idx
end
function paymentManager.popPayFromLocalByRid(rid)
	local rePay
	local idx = 0
	local payPool = paymentManager.popAllPayFromLocal()
	if payPool and next(payPool) then
		for i = #payPool, 1, -1 do
			if payPool[i].rid == rid then
				rePay = payPool[i]
				idx = i
				break
			end
		end
	end
	return rePay, idx
end
function paymentManager.popPayFromLocalByPid(pid)
	local rePay
	local idx = 0
	local payPool = paymentManager.popAllPayFromLocal()
	if payPool and next(payPool) then
		for i = #payPool, 1, -1 do
			if payPool[i].pid == pid then
				rePay = payPool[i]
				idx = i
				break
			end
		end
	end
	return rePay, idx
end
function paymentManager.delPay2LocalByOrderID(orderID)
	local payInfo, idx = paymentManager.popPayFromLocalByOrderID(orderID)
	if payInfo then
		local payPool = paymentManager.popAllPayFromLocal()
		if payPool[idx] then
			table.remove(payPool, idx)
		end
		paymentManager.writePay2Local(payPool)
		return true
	end
	return false
end
function paymentManager.delPay2LocalByRid(rid)
	local payInfo, idx = paymentManager.popPayFromLocalByRid(rid)
	if payInfo then
		local payPool = paymentManager.popAllPayFromLocal()
		if payPool[idx] then
			table.remove(payPool, idx)
		end
		paymentManager.writePay2Local(payPool)
		return true
	end
	return false
end
function paymentManager.delPay2LocalByPid(pid)
	local payInfo, idx = paymentManager.popPayFromLocalByPid(pid)
	if payInfo then
		local payPool = paymentManager.popAllPayFromLocal()
		if payPool[idx] then
			table.remove(payPool, idx)
		end
		paymentManager.writePay2Local(payPool)
		return true
	end
	return false
end
function paymentManager.addPay2Local(value)
	local tmpPayTbl = paymentManager.popAllPayFromLocal()
	table.insert(tmpPayTbl, value)
	paymentManager.writePay2Local(tmpPayTbl)
end
function paymentManager.writePay2Local(value)
	local str = json.encode(value)
	cc.UserDefault:getInstance():setStringForKey("System:paymentManager~table", str)
end
function paymentManager.popAllPayFromLocal()
	local str = cc.UserDefault:getInstance():getStringForKey("System:paymentManager~table", "[]")
	if not json.decode(str) then
		local _ENV, obj = json.decode(str), json.decode(str)
	end
	return obj
end
function paymentManager.delAllPay2Local()
	cc.UserDefault:getInstance():setStringForKey("System:paymentManager~table", "[]")
end
function paymentManager.switchBullets(...)
	gModuleMgr.sharedMgr("rechargeExtraltCtrl"):resetData()
	local lang = userSDKManager.getChannel()
	if lang == "ar" then
		paymentManager.bullets = require("app." .. LocalTblPath .. ".config_client.recharge_client_config")
		paymentManager.products = require("app." .. LocalTblPath .. ".config_client.recharge_products")
	elseif lang == "en" or userSDKManager.isKO() then
		paymentManager.bullets = require("app." .. LocalTblPath .. ".config_client.recharge_client_config")
		paymentManager.products = require("app." .. LocalTblPath .. ".config_client.recharge_products")
	else
		paymentManager.bullets = require("app." .. LocalTblPath .. ".config_client.recharge_client_config")
		paymentManager.products = require("app." .. LocalTblPath .. ".config_client.recharge_products")
	end
end
function paymentManager.init()
	paymentManager.isInRecharging = false
	paymentManager.canPost2Server = false
	if device.platform == "ios" then
		paymentManager.loadNoFinishDone = true
		paymentManager.ios.init()
	elseif device.platform == "android" then
		paymentManager.android.init()
	end
end
function paymentManager.loadProducts(...)
	if device.platform == "ios" then
		paymentManager.ios.loadProducts(paymentManager.products)
	elseif device.platform == "android" then
	end
end
function paymentManager.purchase(...)
	if device.platform == "ios" then
		paymentManager.ios.purchase(...)
	elseif device.platform == "android" then
		paymentManager.android.purchase(...)
	end
end
function paymentManager.finishTransaction(...)
	if device.platform == "ios" then
		paymentManager.ios.finishTransaction(...)
	elseif device.platform == "android" then
		paymentManager.android.consumeFinished(...)
	end
end
function paymentManager.loopForFinishTransaction()
	if device.platform == "ios" then
		paymentManager.ios.loopForFinishTransaction()
	elseif device.platform == "android" then
		paymentManager.android.loopForFinishTransaction()
	end
end
function paymentManager.finishTheLostTransaction()
	if device.platform == "ios" then
		paymentManager.ios.finishTheLostTransaction()
	elseif device.platform == "android" then
		paymentManager.android.finishTheLostTransaction()
	end
end
function paymentManager.start2PostGameServer4FinishTransaction(...)
	paymentManager.canPost2Server = true
	if paymentManager.isInit and paymentManager.loadNoFinishDone then
		paymentManager.loopForFinishTransaction()
	else
		print("start2PostGameServer4FinishTransaction")
	end
end
function paymentManager.start2Loop4FinishTransaction(...)
	paymentManager.isInit = true
	if paymentManager.canPost2Server and paymentManager.loadNoFinishDone then
		paymentManager.loopForFinishTransaction()
	else
		print("start2Loop4FinishTransaction")
	end
end
function paymentManager.start2NoFinishDone4FinishTransaction(...)
	paymentManager.loadNoFinishDone = true
	if paymentManager.canPost2Server and paymentManager.isInit then
		paymentManager.loopForFinishTransaction()
	else
		print("start2NoFinishDone4FinishTransaction")
	end
end
function paymentManager.onEnterForeground()
	local channel = userSDKManager.getChannel()
	if device.platform == "ios" then
	elseif device.platform ~= "android" or "fa" == channel then
	else
		paymentManager.finishTheLostTransaction()
	end
end
function paymentManager.OnemtOpenGiftUI(_pid, fromCenter, isPageTurn, pushID, activityID)
	local log = gSDKDef.TDonEvent.open_rechargegift
	if isPageTurn then
		log = gSDKDef.TDonEvent.open_rechargegift_bypage
	end
	local eventName = log .. fromCenter
	print("paymentManager.OnemtOpenGiftUI = ", eventName)
	_ENV = eventName
	eventName.productid = _pid
	eventName.entrance = fromCenter
	eventName.pushid = pushID
	eventName.activityid = activityID
	userSDKManager.logEvent(eventName, eventName)
	userSDKManager.report2firebase("enterRechargePop")
end
function paymentManager.openRechargeView(fromCenter)
	local eventName = gSDKDef.TDonEvent.open_rechargeview
	print("paymentManager.openRechargeView = ", eventName)
	_ENV = eventName
	eventName.entrance = fromCenter
	userSDKManager.logEvent(eventName, eventName)
	userSDKManager.report2firebase("enterRechargeView")
end
function paymentManager.OnemtReadyBuy(_pid, fromCenter, isPageTurn, otherList, pushID, activityID, is_third)
	local log = gSDKDef.TDonEvent.ready_buy
	if isPageTurn then
		log = gSDKDef.TDonEvent.ready_buy_bypage
	end
	local eventName = log .. fromCenter
	if otherList and next(otherList) then
		if otherList.buyGold then
			eventName = gSDKDef.TDonEvent.ready_buy_onrechargeviewgold
		elseif otherList.buyGift then
			eventName = gSDKDef.TDonEvent.ready_buy_onrechargeview
		end
	end
	print("paymentManager.OnemtReadyBuy eventName = ", eventName)
	_ENV = eventName
	eventName.productid = _pid
	eventName.entrance = fromCenter
	eventName.pushid = pushID
	eventName.activityid = activityID
	eventName.is_third = is_third and 1 or 0
	userSDKManager.logEvent(eventName, eventName)
	userSDKManager.report2firebase("startPay")
end
function paymentManager.OnemtReadyBuyNew(_pid)
	local eventName = gSDKDef.TDonEvent.ready_buy_new
	print("paymentManager.OnemtReadyBuyNew eventName = ", eventName)
	_ENV = eventName
	eventName.productid = _pid
	userSDKManager.logEvent(eventName, eventName)
end
function paymentManager.OnemtCancelBuy(_rid)
	_ENV = nil
	;(nil).productid = _rid
	userSDKManager.logEvent(gSDKDef.TDonEvent.cancel_buy, nil)
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_cancel_pay)
	userSDKManager.report2firebase("cancelPay")
end
function paymentManager.OnemtPost2ServerSuccess(_pid, transaction)
	if transaction then
		if device.platform == "ios" then
			if not transaction or not transaction.receipt then
				local _ENV, postReceipt = transaction.receipt, transaction.receipt
			end
			_ENV = nil
			;(nil).productid = _pid
			;(nil).receipt = postReceipt
			;(nil).base64 = crypto.encodeBase64(postReceipt)
			userSDKManager.logEvent(gSDKDef.TDonEvent.delivered_payment, nil)
		elseif device.platform == "android" then
			_ENV = gSDKDef.TDonEvent.delivered_payment
			gSDKDef.TDonEvent.delivered_payment.productid = _pid
			gSDKDef.TDonEvent.delivered_payment.signature = transaction.signature
			gSDKDef.TDonEvent.delivered_payment.originalJson = transaction.originalJson
			userSDKManager.logEvent(gSDKDef.TDonEvent.delivered_payment, gSDKDef.TDonEvent.delivered_payment)
		end
	else
		_ENV = gSDKDef.TDonEvent.delivered_payment
		gSDKDef.TDonEvent.delivered_payment.productid = _pid
		userSDKManager.logEvent(gSDKDef.TDonEvent.delivered_payment, gSDKDef.TDonEvent.delivered_payment)
	end
end
function paymentManager.OnemtBuySuccessReturn(_pid, transaction, is_third)
	if transaction then
		if device.platform == "ios" then
			if not transaction or not transaction.receipt then
				local _ENV, postReceipt = transaction.receipt, transaction.receipt
			end
			_ENV = nil
			;(nil).productid = _pid
			;(nil).receipt = postReceipt
			;(nil).base64 = crypto.encodeBase64(postReceipt)
			;(nil).is_third = is_third and 1 or 0
			userSDKManager.logEvent(gSDKDef.TDonEvent.received_payment, nil)
		elseif device.platform == "android" then
			_ENV = gSDKDef.TDonEvent.received_payment
			gSDKDef.TDonEvent.received_payment.productid = _pid
			gSDKDef.TDonEvent.received_payment.signature = transaction.signature
			gSDKDef.TDonEvent.received_payment.originalJson = transaction.originalJson
			gSDKDef.TDonEvent.received_payment.is_third = is_third and 1 or 0
			userSDKManager.logEvent(gSDKDef.TDonEvent.received_payment, gSDKDef.TDonEvent.received_payment)
		end
	else
		_ENV = gSDKDef.TDonEvent.received_payment
		gSDKDef.TDonEvent.received_payment.productid = _pid
		gSDKDef.TDonEvent.received_payment.is_third = is_third and 1 or 0
		userSDKManager.logEvent(gSDKDef.TDonEvent.received_payment, gSDKDef.TDonEvent.received_payment)
	end
end
function paymentManager.OnemtRechargeSuccess(money)
end
function paymentManager.android.init()
	if type(paymentManager.products) ~= "table" or not next(paymentManager.products) then
		paymentManager.switchBullets()
	end
	if paymentManager.isInit then
		paymentManager_android_callBackStartToPost()
	else
		local javaClassName = "com/unity3d/player/AndroidPayment"
		local javaMethodName = "initIabHelp"
		local javaMethodSig = "()V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	end
end
function paymentManager.android.purchase(rid, orderID, pushID)
	rid = tonumber(rid)
	print("出现活动ID:" .. rid)
	local pid = paymentManager.rid2Pid(rid)
	if pid then
		_ENV = nil
		;(nil).rid = rid
		userSDKManager.logEvent(gSDKDef.TDonEvent.purchase, nil)
		print("找到产品ID:" .. pid)
		_ENV = print
		print.rid = rid
		print.pid = pid
		print.orderID = orderID
		print.pushID = pushID
		local print.reqTime, storeTbl = serviceFunctions.systemTime(), print
		paymentManager.addPay2Local(storeTbl)
		paymentManager.android.huawei_purchase(pid, orderID)
	else
		_ENV = paymentManager.android.huawei_purchase
		_ENV, paymentManager.android.huawei_purchase.msg = pid, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		pid.result = false
		paymentManager.android.huawei_purchase.data, pid.rid = pid, rid
		SoraDSendMessage(paymentManager.android.huawei_purchase)
	end
end
function paymentManager.android.loadProducts(tbl)
	if type(tbl) ~= "table" or not next(tbl) then
		return
	end
	local bullets = ""
	local index = 1
	for _, v in pairs(tbl) do
		if userSDKManager.isHuawei() and v.productIdentifier == "subwar3001" then
		else
			if index == 1 then
				bullets = bullets .. v.productIdentifier
			else
				bullets = bullets .. "," .. v.productIdentifier
			end
			index = index + 1
		end
	end
	local javaClassName = "com/unity3d/player/AndroidPayment"
	local javaMethodName = "requestForProducts"
	_UPVALUE1_ = pairs(tbl)
	local pairs(tbl)[1], javaParams = "" .. bullets, pairs(tbl)
	local javaMethodSig = "(Ljava/lang/String;)V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
function paymentManager.android.consumeFinished(arg, rid, orderID)
	paymentManager.curConsumePay = nil
	local javaClassName = "com/unity3d/player/AndroidPayment"
	local javaMethodName = "postBackToConsume"
	_UPVALUE1_ = nil
	local (nil)[1], javaParams = "" .. arg, nil
	local javaMethodSig = "(Ljava/lang/String;)V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	if orderID then
		if not paymentManager.delPay2LocalByOrderID(orderID) then
			paymentManager.delPay2LocalByRid(rid)
		end
	else
		paymentManager.delPay2LocalByRid(rid)
	end
end
function paymentManager_android_callBackStartToPost()
	if type(paymentManager.products) ~= "table" or not next(paymentManager.products) then
		paymentManager.switchBullets()
	end
	paymentManager.android.loadProducts(paymentManager.products)
end
function paymentManager_android_start2Loop4FinishTransaction(...)
	paymentManager.start2Loop4FinishTransaction()
end
function paymentManager_android_reqListCallBack(arg)
	local reqListRedata = json.decode(arg)
	if not paymentManager.products then
		return
	end
	for k, v in pairs(paymentManager.products) do
		if reqListRedata[v.productIdentifier] then
			local deContent = json.decode(reqListRedata[v.productIdentifier])
			v.price = deContent.price
			v.currency = deContent.price_currency_code
			if deContent.price_amount_micros then
				v.price_amount = deContent.price_amount_micros / 1000000
			end
		end
	end
end
function paymentManager_android_googlePayFailed(arg)
	_ENV = nil
	_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
	;(nil).data, (nil).result = nil, false
	SoraDSendMessage(nil)
	paymentManager.isInRecharging = false
end
function paymentManager_android_purchaseFailed(arg)
	print("paymentManager_android_purchaseFailed = ", arg)
	if paymentManager.canPost2Server then
		local payInfo = paymentManager.popPayFromLocalByPid(arg)
		if payInfo then
			local rid = payInfo.rid
			local pid = payInfo.pid
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = false
			;(nil).data, (nil).rid = nil, rid
			SoraDSendMessage(nil)
			paymentManager.delPay2LocalByPid(pid)
			paymentManager.OnemtCancelBuy(rid)
		end
	end
end
function paymentManager.android.post2GameServer(_localRid, _gBuyType, _originalJson, _signature, _encodeInfo, _orderID, _pushID)
	local gametop = gModuleMgr.getObject("gametop")
	local _localCurrency = paymentManager.getCurrencyByRID(_localRid, _originalJson)
	if gBuyType.RECHARGE == _gBuyType then
		local rechargeCtrl = gametop.playertop_:getModule("rechargeCtrl")
		rechargeCtrl:rechargeGooglePlayVerify(_localRid, _originalJson, _signature, _localCurrency, _encodeInfo, _orderID, _pushID)
	else
		local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
		rechargeActivityCtrl:rechargeGooglePlayVerify(_localRid, _originalJson, _signature, _localCurrency, _encodeInfo, _orderID, _pushID)
	end
end
function paymentManager_android_payCallBack(arg)
	local androidRedata = json.decode(arg)
	local purchasedData = json.decode(androidRedata.originalJson)
	local payInfo = paymentManager.popPayFromLocalByPid(purchasedData.productId)
	if userSDKManager.isHuawei() and not payInfo then
		payInfo = paymentManager.popPayFromLocalByOrderID(purchasedData.orderId)
	end
	dump(payInfo, "payInfo")
	if payInfo then
		local rid = payInfo.rid
		paymentManager.android.post2GameServer(rid, paymentManager.getPaymentBullets(rid).isActive, androidRedata.originalJson, androidRedata.signature, arg, payInfo.orderID, payInfo.pushID)
		paymentManager.OnemtBuySuccessReturn(rid, androidRedata)
	else
		paymentManager.android.post2GameServer(nil, nil, androidRedata.originalJson, androidRedata.signature, arg, nil, nil)
		_ENV = nil
		_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		;(nil).result = false
		;(nil).data, (nil).pName = nil, purchasedData.productId
		SoraDSendMessage(nil)
	end
	_ENV = nil
	;(nil).arg = arg
	paymentManager.curConsumePay, (nil).info = nil, payInfo
end
function paymentManager.reconsumePayWhenRelogin()
	if device.platform == "ios" then
	elseif device.platform == "android" then
		paymentManager.android.reconsumePayWhenRelogin()
	end
end
function paymentManager.android.reconsumePayWhenRelogin()
	if paymentManager.curConsumePay then
		dump(paymentManager.curConsumePay, "reconsume when relogin", 5)
		local repay = paymentManager.curConsumePay.arg
		paymentManager_android_payCallBack(repay)
	end
	if userSDKManager.isHuawei() then
		paymentManager_android_getPurchases_huawei()
	end
end
function paymentManager.android.finishTheLostTransaction()
	if next(paymentManager.android.noFinishedList) then
		for k, v in pairs(paymentManager.android.noFinishedList) do
			local payInfo = paymentManager.popPayFromLocalByPid(v.productId)
			if payInfo then
				do
					local rid = payInfo.rid
					local receipt = v.receipt
					if not paymentManager.getPaymentBullets(rid) then
						local _ENV, rInfo = paymentManager.getPaymentBullets(rid), paymentManager.getPaymentBullets(rid)
					end
					print("找到未结rid=", rid, "以及pid=", payInfo.pid, "以及orderID=", payInfo.orderID)
					paymentManager.android.post2GameServer(rid, rInfo.isActive, v.originalJson, v.signature, json.encode(v), payInfo.orderID, payInfo.pushID)
					paymentManager.android.noFinishedList[k] = nil
				end
				break
			end
			print("结掉找不到的订单:", v.productId)
			do
				local receipt = v.receipt
				paymentManager.android.post2GameServer(nil, nil, v.originalJson, v.signature, json.encode(v), nil, nil)
				paymentManager.android.noFinishedList[k] = nil
			end
			break
		end
	end
end
function paymentManager.android.loopForFinishTransaction()
	if next(paymentManager.android.noFinishedList) then
		paymentManager.android.finishTheLostTransaction()
	else
		paymentManager.recentFinishFlag = true
		paymentManager.delAllPay2Local()
	end
end
function paymentManager_android_saveToNoFinishPurchased(arg)
	local noFinishList = json.decode(arg)
	if next(noFinishList) then
		for k, v in pairs(noFinishList) do
			table.insert(paymentManager.android.noFinishedList, v)
		end
	end
	paymentManager.start2NoFinishDone4FinishTransaction()
end
function paymentManager.ios.init()
	print("注册回调函数&初始化in-app")
	_ENV = nil
	;(nil).funcIAP = PaymentManager_IOS_TransBack2Disposer
	;(nil).callBackFunc = PaymentManager_Ios_LoadProducts
	;(nil).promotingBuy = PaymentManager_Ios_PromotingBuy
	luaoc.callStaticMethod("IAPHelper", "initPaymentModules", nil)
end
function paymentManager.ios.getGiftIdFromAppStore()
	local giftId
	local ok, productIdentifier = luaoc.callStaticMethod("IAPHelper", "getProductFromAppStore", nil)
	print("获取内购产品id,ok", ok, productIdentifier)
	if ok and tolua.type(productIdentifier) == "string" then
		giftId = paymentManager.pid2Rid(productIdentifier)
	end
	return giftId
end
function PaymentManager_Ios_PromotingBuy(pid)
	print("appstore商城上的内购推广购买回调", pid)
	SoraDJumpToBuyGift()
end
function paymentManager.getRidByPromotPid(pid)
	local pIndex
	for index, v in pairs(paymentManager.products) do
		if v.pid == pid then
			pIndex = index
			break
		end
	end
	if pIndex then
		for rid, v in pairs(paymentManager.bullets) do
			if pIndex == v.pIndex then
				return rid
			end
		end
	end
	return nil
end
function PaymentManager_IOS_TransBack2Disposer(transactionJson)
	local transaction = json.decode(transactionJson)
	if transaction then
		if transaction.state == "purchased" then
			print("other state 1: purchased")
			if paymentManager.canPost2Server then
				print("realOrderID", tostring(transaction.developPayload))
				local payInfo = paymentManager.popPayFromLocalByPid(transaction.productIdentifier)
				if payInfo then
					local rid = payInfo.rid
					local receipt = transaction.receipt
					local realOrderID = transaction.developPayload
					paymentManager.ios.post2GameServer(rid, paymentManager.getPaymentBullets(rid).isActive, receipt, transaction, payInfo.orderID, payInfo.pushID)
					paymentManager.OnemtBuySuccessReturn(rid, transaction)
				else
					local receipt = transaction.receipt
					local realOrderID = transaction.developPayload
					paymentManager.ios.post2GameServer(nil, nil, receipt, transaction, realOrderID, nil)
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = false
					;(nil).data, (nil).pName = nil, transaction.productIdentifier
					SoraDSendMessage(nil)
				end
			else
				print("other state 1: comsumeableRestore")
				table.insert(paymentManager.ios.noFinishedList, transaction)
				paymentManager.ios.haveNoFinishCome()
			end
		elseif transaction.state == "restored" then
			print("other state : " .. transaction.state)
		elseif transaction.state == "comsumeableRestore" then
			print("other state 2: " .. transaction.state)
			table.insert(paymentManager.ios.noFinishedList, transaction)
			paymentManager.ios.haveNoFinishCome()
		else
			print("other state : " .. transaction.state)
			if paymentManager.canPost2Server then
				local payInfo = paymentManager.popPayFromLocalByPid(transaction.productIdentifier)
				if payInfo then
					local rid = payInfo.rid
					local pid = payInfo.pid
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = false
					;(nil).data, (nil).rid = nil, rid
					SoraDSendMessage(nil)
					paymentManager.delPay2LocalByPid(pid)
					paymentManager.OnemtCancelBuy(rid)
				end
			end
		end
	end
end
function paymentManager.ios.post2GameServer(_localRid, _gBuyType, _receipt, _transaction, _orderID, _pushID)
	print("paymentManager.ios.post2GameServer!!!")
	local gametop = gModuleMgr.getObject("gametop")
	local _localCurrency = paymentManager.getCurrencyByRID(_localRid, _receipt)
	if gBuyType.RECHARGE == _gBuyType then
		local rechargeCtrl = gametop.playertop_:getModule("rechargeCtrl")
		rechargeCtrl:rechargeIOSVerify(_localRid, _receipt, _localCurrency, _transaction, _orderID, _pushID)
	else
		local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
		rechargeActivityCtrl:rechargeIOSVerify(_localRid, _receipt, _localCurrency, _transaction, _orderID, _pushID)
	end
end
function paymentManager.ios.finishTheLostTransaction()
	if next(paymentManager.ios.noFinishedList) then
		for k, v in pairs(paymentManager.ios.noFinishedList) do
			local payInfo = paymentManager.popPayFromLocalByPid(v.productIdentifier)
			if payInfo then
				do
					local rid = payInfo.rid
					local receipt = v.receipt
					if not paymentManager.getPaymentBullets(rid) then
						local _ENV, rInfo = paymentManager.getPaymentBullets(rid), paymentManager.getPaymentBullets(rid)
					end
					print("找到未结rid=", rid, "以及pid=", payInfo.pid, "以及orderID=", payInfo.orderID)
					paymentManager.ios.post2GameServer(rid, rInfo.isActive, receipt, v, payInfo.orderID, payInfo.pushID)
					paymentManager.ios.noFinishedList[k] = nil
				end
				break
			end
			print("结掉找不到的订单:", v.productIdentifier)
			do
				local receipt = v.receipt
				paymentManager.ios.post2GameServer(nil, nil, receipt, v, nil, nil)
				paymentManager.ios.noFinishedList[k] = nil
			end
			break
		end
	end
end
function paymentManager.ios.haveNoFinishCome(...)
	if not paymentManager.ios.isHaveNoFinishCome then
		paymentManager.ios.isHaveNoFinishCome = true
		paymentManager.start2NoFinishDone4FinishTransaction()
	end
end
function paymentManager.ios.loopForFinishTransaction()
	if next(paymentManager.ios.noFinishedList) then
		paymentManager.ios.finishTheLostTransaction()
	else
		paymentManager.recentFinishFlag = true
		paymentManager.delAllPay2Local()
	end
end
function paymentManager.ios.loadProducts(tbl)
	dump(tbl, "paymentManager.ios.loadProducts", 10)
	local bullets = ""
	local index = 1
	for _, v in pairs(tbl) do
		if index == 1 then
			bullets = bullets .. v.productIdentifier
		else
			bullets = bullets .. "," .. v.productIdentifier
		end
		index = index + 1
	end
	_ENV = (for generator)
	local pairs(tbl).pList, args = bullets, pairs(tbl)
	local ok, ret = luaoc.callStaticMethod("IAPHelper", "lua2Req", args)
end
function PaymentManager_Ios_LoadProducts(plistJson)
	local plist = json.decode(plistJson)
	dump(plist, "回来的商品信息", 100)
	if plist and next(plist) ~= nil then
		local _ENV, tmpTable = next(plist), next(plist)
		for k, v in pairs(plist) do
			_ENV = nil
			;(nil).currency = v.priceLocale
			tmpTable[v.productIdentifier], (nil).price = nil, v.price
		end
		for k, v in pairs(paymentManager.products) do
			if tmpTable[v.productIdentifier] then
				v.currency = tmpTable[v.productIdentifier].currency
				v.price = v.currency .. string.format("%.2f", tostring(tmpTable[v.productIdentifier].price))
			end
		end
		dump(paymentManager.products, "转换后的表", 10)
		paymentManager.ios.start2Loop4FinishTransaction()
	end
end
function paymentManager.ios.start2Loop4FinishTransaction(...)
	paymentManager.start2Loop4FinishTransaction()
end
function paymentManager.ios.restore(...)
	local ok, ret = luaoc.callStaticMethod("IAPHelper", "startRestore", nil)
end
function paymentManager.ios.canMakePurchases(...)
	local ok, ret = luaoc.callStaticMethod("IAPHelper", "canMakePayments", nil)
	return ret
end
function paymentManager.ios.purchase(rid, orderID, pushID)
	rid = tonumber(rid)
	print("出现活动ID:" .. rid)
	local pid = paymentManager.rid2Pid(rid)
	if pid then
		print("找到产品ID:" .. pid)
		_ENV = print
		print.rid = rid
		print.pid = pid
		print.orderID = orderID
		print.pushID = pushID
		local print.reqTime, storeTbl = serviceFunctions.systemTime(), print
		paymentManager.addPay2Local(storeTbl)
		_ENV = paymentManager.addPay2Local
		paymentManager.addPay2Local.product2Buy = pid
		local paymentManager.addPay2Local.customOrderId, args = orderID, paymentManager.addPay2Local
		local ok, ret = luaoc.callStaticMethod("IAPHelper", "lua2Buy", args)
	else
		_ENV = paymentManager.addPay2Local
		_ENV, paymentManager.addPay2Local.msg = luaoc.callStaticMethod("IAPHelper", "lua2Buy", args)
		luaoc.callStaticMethod("IAPHelper", "lua2Buy", args).result = false
		paymentManager.addPay2Local.data, luaoc.callStaticMethod("IAPHelper", "lua2Buy", args).rid = luaoc.callStaticMethod("IAPHelper", "lua2Buy", args)
		SoraDSendMessage(paymentManager.addPay2Local)
	end
end
function paymentManager.ios.finishTransaction(transaction, rid, orderID)
	print("准备结单：", transaction.productIdentifier)
	local _transJson = json.encode(transaction)
	_ENV = transaction
	transaction.transJson = _transJson
	local transaction.productIdentifier, args = transaction.productIdentifier, transaction
	local ok, ret = luaoc.callStaticMethod("IAPHelper", "lua2FinishTransaction", args)
	if orderID then
		if not paymentManager.delPay2LocalByOrderID(orderID) then
			paymentManager.delPay2LocalByRid(rid)
		end
	else
		paymentManager.delPay2LocalByRid(rid)
	end
end
function paymentManager.normalGiftBuyClassify(_id, additionData)
	local rechargeRead = include("rechargeRead")
	local info = rechargeRead.getPageViewData(_id)
	paymentManager.ready2Pay(_id, additionData)
end
function paymentManager.ready2Pay(rid, additionData)
	local luckyCommonFun = function(rid)
		local gametop = gModuleMgr.getObject("gametop")
		local luckyGiftCtrl = gametop.playertop_:getModule("luckyGiftCtrl")
		local _ENV, luckyGiftList = gametop.playertop_, gametop.playertop_
		if additionData and additionData.luckyType and additionData.luckyType == gLuckyPackageType.LUCKY_PACKAGE_CHOICE then
			luckyGiftList = luckyGiftCtrl:getChoiceLuckyGiftData(true)
		else
			luckyGiftList = luckyGiftCtrl:getLuckyGiftData(true)
		end
		for _, v in pairs(luckyGiftList) do
			if tonumber(v.luckyGiftID) == tonumber(rid) then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				luckyGiftCtrl:sendReceiveReward(rid)
			end
		end
	end
	local rechargeRead = include("rechargeRead")
	dump(paymentManager.getPaymentBullets(rid), "paymentManager.getPaymentBullets(rid)===" .. rid)
	if not paymentManager.getPaymentBullets(rid) and rechargeRead.getPageViewData(rid) then
		luckyCommonFun(rid)
		return
	end
	if not paymentManager.enableToPay then
		SoraDShowMsgTip(i18n("common_text_699"))
		return
	end
	if not paymentManager.recentFinishFlag then
		SoraDShowMsgTip(i18n("common_text_1048"))
		return
	end
	if not paymentManager.isInit then
		SoraDShowMsgTip(i18n("system_notice_05"))
		return
	end
	if paymentManager.isInRecharging then
		SoraDShowMsgTip(i18n("common_text_1048"))
		return
	end
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if paymentManager.getPaymentBullets(rid) then
		paymentManager.OnemtReadyBuyNew(rid)
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_trigger_pay)
		if paymentManager.getPaymentBullets(rid).isActive == gBuyType.RECHARGE then
			local gametop = gModuleMgr.getObject("gametop")
			local rechargeCtrl = gametop.playertop_:getModule("rechargeCtrl")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			rechargeCtrl:rechargeCheckReq(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.RECHARGE_ACTIVITY then
			local gametop = gModuleMgr.getObject("gametop")
			local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			rechargeActivityCtrl:rechargeCheckReq(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.LUCKY_BAG then
			luckyCommonFun(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.KINGDOM_GROUPBUY then
			local gametop = gModuleMgr.getObject("gametop")
			local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			kingGroupBuyAgCtrl:sendChargeMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.RED_ENVELOPES then
			local gametop = gModuleMgr.getObject("gametop")
			local propCtrl = gametop.playertop_:getModule("propCtrl")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			propCtrl:checkRechargeGoldGift(additionData.tmpType, additionData.tmpNum, additionData.tmpText, rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.ICE_BREAK_GIFT then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local iceBreakCtrl = gametop.playertop_:getModule("iceBreakCtrl")
			iceBreakCtrl:sendBuyMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.SEVEN_DAY_GIFT then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			include("rechargeGiftDataModuleAPI"):buyRechargeGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.PRIVILEGE_GIFT then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
			privilegeGiftCtrl:sendBuyMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.RUIRUILADDER_GIFT then
			print("gBuyType.RUIRUILADDER_GIFT")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
			ladderGiftCtrl:buyGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.DAILY_DISCOUNT_GIFT then
			print("gBuyType.DAILY_DISCOUNT_GIFT")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local dailyDiscountGiftCtrl = gametop.playertop_:getModule("dailyDiscountGiftCtrl")
			dailyDiscountGiftCtrl:buyGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.HONOR_BACK_GIFT then
			print("gBuyType.HONOR_BACK_GIFT")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local honorBackCtrl = gametop.playertop_:getModule("honorBackCtrl")
			_ENV = nil
			;(nil).rechargeID = rid
			honorBackCtrl:reqBuyGiftsItem(nil)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.WEEKLY_GIFT then
			print("gBuyType.WEEKLY_GIFT")
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local weeklySpecialCtrl = gametop.playertop_:getModule("weeklySpecialCtrl")
			weeklySpecialCtrl:sendBuyPackageMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.AMAZING_FORTUNE then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
			amazingFortuneCtrl:sendReqBuyGiftMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.UMLOCK_CAT then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local friendPetCtrl = SoraDGetCtrl("friendPetCtrl")
			friendPetCtrl:sendReqBuyGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.OPTIONAL_PACKAGE then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local manualGiftCtrl = SoraDGetCtrl("manualGiftCtrl")
			manualGiftCtrl:reqBuyPackageMsg(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.LUXURY_GIFT then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
			_ENV = nil
			;(nil).rechargeID = rid
			luxuryRebateCtrl:reqLuxuryRebateBuyGift(nil)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.SERICA then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			local gametop = gModuleMgr.getObject("gametop")
			local merchantOfSericaCtrl = gametop.playertop_:getModule("merchantOfSericaCtrl")
			merchantOfSericaCtrl:reqSericaOrder()
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.ATLANTIS_SKILL then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			SoraDGetCtrl("atlantisActivityCtrl"):reqBuySkillGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.STARLIGHT_PAVILION then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			SoraDGetCtrl("starlightPavilionCtrl"):sendBuyGift(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.SERICA_SHOP then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			SoraDGetCtrl("sericaShopCtrl"):reqSericaShopBuy(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.WAR_ORDER_9001562 then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			SoraDGetCtrl("warOrderCtrl"):reqWarOrderBuy(rid)
		elseif paymentManager.getPaymentBullets(rid).isActive == gBuyType.WAR_ORDER_9001581 then
			SoraDShowLoading(nil, nil, nil, nil, 30)
			paymentManager.isInRecharging = true
			SoraDGetCtrl("warHornCtrl"):reqWarOrderBuy(rid)
		else
			local bullet = paymentManager.getPaymentBullets(rid)
			if bullet.isActive == gBuyType.DICTATORSHIPS then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001486_Ctrl"):reqBuy(rid)
			elseif bullet.isActive == gBuyType.ACTIVITY_9001496 then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001496_Ctrl"):reqGift(rid)
			elseif bullet.isActive == gBuyType.NEBULA_EMPEROR then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("nebulaEmperorCtrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.MAGIC_LAMP_ORDER then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001565_Ctrl"):reqWarOrderBuy(rid)
			elseif bullet.isActive == gBuyType.NEBULA_ALL_STAR then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("nebulaAllStarCtrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.ACTIVITY_9001601 then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001601_Ctrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.END_OF_RAMADAN_MARKET then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001624_Ctrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.CORBAN_MARKET then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001639_Ctrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.PREPARE_FOR_WAR then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001656_Ctrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.CELEBRATE_CORBAN then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001637_Ctrl"):reqBuyGift(rid)
			elseif bullet.isActive == gBuyType.NEBULA_TREASURE then
				SoraDShowLoading(nil, nil, nil, nil, 30)
				paymentManager.isInRecharging = true
				SoraDGetCtrl("activity_9001628_Ctrl"):reqBuyPackageMsg(rid)
			else
				local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
				local buyType = bullet.isActive
				if commonBuyGiftCtrl:checkHasConfig(buyType) then
					SoraDShowLoading(nil, nil, nil, nil, 30)
					paymentManager.isInRecharging = true
					commonBuyGiftCtrl:reqBuyGift(buyType, rid)
				end
			end
		end
	else
		SoraDShowMsgTip(i18n("notice_0118"))
	end
end
function paymentManager.judgeGiftExclusive(rid)
	local isEnable = false
	rid = tonumber(rid)
	if paymentManager.getPaymentBullets(rid) then
		local deviceID = paymentManager.getPaymentBullets(rid).device
		if deviceID and deviceID ~= 0 then
			if deviceID == 1 and device.platform == "ios" then
				isEnable = true
			elseif deviceID == 2 and device.platform == "android" then
				isEnable = true
			elseif device.platform == "mac" then
				isEnable = true
			end
		else
			isEnable = true
		end
	end
	return isEnable
end
function paymentManager.mainUiTopIconJudge(rid)
	_UPVALUE2_ = nil
	_UPVALUE2_, (nil)[1] = gRechargeActiveModelType.NORMAL, gRechargeActiveModelType.NORMAL
	local _UPVALUE2_, (nil)[2], canType = gRechargeActiveModelType.NORMAL, gRechargeActiveModelType.LUCKYGIFT, nil
	gRechargeActiveModelType.NORMAL[1] = gRechargeActiveModelType.SUBSCRIPTION
	local gRechargeActiveModelType.NORMAL[2], disType = gRechargeActiveModelType.MONTHLYGIFT, gRechargeActiveModelType.NORMAL
	local isEnable = false
	rid = tonumber(rid)
	local rechargeRead = include("rechargeRead")
	local info = rechargeRead.getPageViewData(rid)
	if info then
		local aType = info.activeModelType
		for k, v in pairs(canType) do
			if v == aType then
				isEnable = true
			end
		end
		for k, v in pairs(disType) do
			if v == aType then
				isEnable = false
			end
		end
	end
	return isEnable
end
function paymentManager.judgePrice(rid, price)
	local channel = userSDKManager.getChannel()
	if "fa" == channel then
		return paymentManager.bazzer_judgePrice(price), true
	elseif "en" == channel and paymentManager.returnROSSpecialID()[rid] then
		return paymentManager.bazzer_judgePrice(price), true
	elseif userSDKManager.isKO() and device.platform ~= "ios" then
		return paymentManager.ko_judgePrice(price), true
	else
		rid = tonumber(rid)
		local priceStr = "US $" .. price
		local isGetPrice = false
		local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
		if pid and paymentManager.products[pid].price ~= "" then
			priceStr = paymentManager.products[pid].price
			isGetPrice = true
		end
		return priceStr, isGetPrice
	end
end
function paymentManager.getRealPrice(pid, price)
	local priceStr = "US $" .. price
	local isGetPrice = false
	if pid and paymentManager.products[pid] and paymentManager.products[pid].price ~= "" then
		priceStr = paymentManager.products[pid].price
		isGetPrice = true
	end
	return priceStr, isGetPrice
end
local getRealPriceLogNormal = function(pid, price)
	local reResult = ""
	local isGetPrice = false
	local bulletPrice = "???"
	local priceStr = "US $" .. price
	local logPriceAmount
	if pid then
		logPriceAmount = "unknow"
		bulletPrice = paymentManager.products[pid].price
		if paymentManager.products[pid].price_amount then
			logPriceAmount = paymentManager.products[pid].price_amount
			reResult = paymentManager.products[pid].price_amount
			if bulletPrice ~= "" then
				priceStr = bulletPrice
			end
			isGetPrice = true
		else
			if bulletPrice ~= "" then
				priceStr = bulletPrice
				isGetPrice = true
			end
			local readyStr = string.match(priceStr, "([%d.,]+)")
			if readyStr then
				if string.sub(readyStr, -3, -3) == "," then
					local _rePrice = string.gsub(readyStr, "%.", "")
					local rePrice = string.gsub(_rePrice, "%,", ".")
					reResult = tonumber(rePrice)
				else
					local rePrice = string.gsub(readyStr, "%,", "")
					reResult = tonumber(rePrice)
				end
			else
				reResult = 0
			end
		end
	end
	local log = string.format("%s-%s-%s-%s-%s-%s", tostring(reResult), tostring(isGetPrice), tostring(pid), tostring(priceStr), tostring(bulletPrice), tostring(logPriceAmount))
	return reResult, isGetPrice, log
end
local getProductIdentifierByReceipt_IOS = function(receiptstr)
	local _ENV, receipttb
	for k, v in string.gmatch(receiptstr, "(\".-\") = (\".-\")") do
		local key = string.sub(k, 2, string.len(k) - 1)
		local value = string.sub(v, 2, string.len(v) - 1)
		receipttb[tostring(key)] = value
	end
	dump(receipttb, "paymentManager-receipttb", 10)
	local _ENV, purchaseinfotb = dump, dump
	local purchaseinfobase64Encode = receipttb["purchase-info"]
	if purchaseinfobase64Encode then
		local crypt = require("crypt")
		local purchaseinfostr = crypt.base64decode(purchaseinfobase64Encode)
		for k, v in string.gmatch(purchaseinfostr, "(\".-\") = (\".-\")") do
			local key = string.sub(k, 2, string.len(k) - 1)
			local value = string.sub(v, 2, string.len(v) - 1)
			purchaseinfotb[tostring(key)] = value
		end
	end
	dump(purchaseinfotb, "paymentManager-purchaseinfotb", 10)
	return purchaseinfotb["product-id"]
end
local getProductIdentifierByReceipt_Android = function(receiptstr)
	local cjson = require("cjson")
	local purchaseinfotb = cjson.decode(receiptstr)
	dump(purchaseinfotb, "paymentManager-purchaseinfotb", 10)
	return purchaseinfotb.productId
end
function paymentManager.getPidByReceipt(receipt)
	local pid
	if receipt then
		pcall(function()
			local productIdentifier
			if device.platform == "ios" then
				productIdentifier = getProductIdentifierByReceipt_IOS(receipt)
			elseif device.platform == "android" then
				productIdentifier = getProductIdentifierByReceipt_Android(receipt)
			end
			print(productIdentifier, "paymentManager-getPidByReceipt-productIdentifier")
			if productIdentifier then
				print(pid, "paymentManager-getPidByReceipt-pid")
			end
		end)
	end
	return pid
end
function paymentManager.getRealPriceLog(rid, price, receipt)
	rid = tonumber(rid)
	local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
	local realPrice, isGetPrice, log = getRealPriceLogNormal(pid, price)
	print(log, "paymentManager-log1")
	if not isGetPrice and receipt then
		pcall(function()
			local productIdentifier
			if device.platform == "ios" then
				productIdentifier = getProductIdentifierByReceipt_IOS(receipt)
			elseif device.platform == "android" then
				productIdentifier = getProductIdentifierByReceipt_Android(receipt)
			end
			print(productIdentifier, "paymentManager-productIdentifier")
			if productIdentifier then
				print(pid, "paymentManager-pid")
				if pid then
					print(log, "paymentManager-log2")
					if not isGetPrice then
					end
				else
				end
			else
			end
		end)
	end
	return realPrice, isGetPrice, log
end
function paymentManager.calculateDiscount(rid, priceStr, discount, oriPrice)
	rid = tonumber(rid)
	local reResult = ""
	xpcall(function(...)
		local channel = userSDKManager.getChannel()
		if "fa" == channel then
		elseif "en" == channel and paymentManager.returnROSSpecialID()[rid] then
		elseif userSDKManager.isKO() then
		else
			local transPrice = function(arg)
				return tonumber(arg) or 100
			end
			local unit = "US $"
			local pid = paymentManager.getPaymentBullets(rid) and paymentManager.getPaymentBullets(rid).pid
			if pid and paymentManager.products[pid].currency ~= "" then
				unit = paymentManager.products[pid].currency
			end
			local readyStr = string.match(priceStr, "([%d.,]+)")
			if readyStr then
				if string.sub(readyStr, -3, -3) == "," then
					local _rePrice = string.gsub(readyStr, "%.", "")
					local rePrice = string.gsub(_rePrice, "%,", ".")
				else
					local rePrice = string.gsub(readyStr, "%,", "")
				end
			else
				unit = {}
			end
		end
	end, function(...)
		print("calculateDiscount error")
	end)
	return reResult
end
function paymentManager.exchangeByChannel(price)
	local channel = userSDKManager.getChannel()
	if "fa" == channel then
		return paymentManager.bazzer_exchange2IRR(price)
	else
		return price
	end
end
function paymentManager.returnCurrencyByChannel()
	local channel = userSDKManager.getChannel()
	if "fa" == channel then
		return paymentManager.bazzer_returnRial()
	else
		return "$"
	end
end
function paymentManager.returnROSSpecialID()
	local _UPVALUE0_, tbl
	return tbl
end
function paymentManager.bazzer_returnRial()
	return " ریال "
end
function paymentManager.bazzer_exchange2IRR(price)
	price = tostring(price)
	if price == "" then
		return
	end
	local trasnPrice = function(rePrice)
		_ENV = nil
		;(nil)["1"] = "۱"
		;(nil)["2"] = "۲"
		;(nil)["3"] = "۳"
		;(nil)["4"] = "۴"
		;(nil)["5"] = "۵"
		;(nil)["6"] = "۶"
		;(nil)["7"] = "۷"
		;(nil)["8"] = "۸"
		;(nil)["9"] = "۹"
		;(nil)["0"] = "۰"
		;(nil)["."] = "."
		local (nil)[","], numList = "،", nil
		local tNum = ""
		for i = 1, #rePrice do
			local char = string.sub(rePrice, i, i)
			if numList[char] then
				tNum = tNum .. numList[char]
			else
				tNum = tNum .. " "
			end
		end
		return tNum
	end
	_ENV = price
	price["0.99"] = "35,000"
	price["1.4"] = "49,990"
	price["4.99"] = "175,000"
	price["9.99"] = "350,000"
	price["19.99"] = "700,000"
	price["24.99"] = "875,000"
	price["49.99"] = "1,750,000"
	local price["99.99"], exchangeTbl = "3,500,000", price
	if exchangeTbl[price] then
		return trasnPrice(exchangeTbl[price])
	else
		local rPrice = tonumber(price)
		local tax = 35000
		local rePrice = string.formatnumberthousands(string.format("%.2f", rPrice * tax))
		return trasnPrice(rePrice)
	end
end
function paymentManager.bazzer_judgePrice(price)
	local _unit = paymentManager.bazzer_returnRial()
	local _price = paymentManager.bazzer_exchange2IRR(price)
	local priceStr = _price .. _unit
	return priceStr, true
end
function paymentManager.ko_judgePrice(price)
	local _unit = "KRW"
	_ENV = nil
	;(nil)["0.99"] = "1,200"
	;(nil)["1.99"] = "2,500"
	;(nil)["2.99"] = "3,700"
	;(nil)["3.99"] = "5,000"
	;(nil)["4.99"] = "6,000"
	;(nil)["9.99"] = "12,000"
	;(nil)["19.99"] = "25,000"
	;(nil)["24.99"] = "31,000"
	;(nil)["49.99"] = "60,000"
	local (nil)["99.99"], exchangeTbl = "120,000", nil
	local priceStr = tostring(price)
	if exchangeTbl[priceStr] then
		return exchangeTbl[priceStr] .. _unit, true
	else
		local rPrice = tonumber(price)
		local tax = 1200
		local rePrice = 0
		rePrice = string.formatnumberthousands(string.format("%d", math.floor(rPrice * tax)))
		return rePrice .. _unit, true
	end
end
function paymentManager.android.huawei_purchase(pid, orderID)
	local javaClassName = "com/unity3d/player/AndroidPayment"
	local javaMethodName = "toBuy"
	_UPVALUE2_ = nil
	;(nil)[1] = "" .. pid
	local (nil)[2], javaParams = "" .. orderID, nil
	local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
function paymentManager_android_payCallBack_huawei(arg)
	local arg1 = json.decode(arg)
	dump(arg1, "paymentManager_android_payCallBack_huawei")
	if paymentManager.canPost2Server then
		paymentManager_android_payCallBack(arg)
	else
		dump(arg, "未完成的订单")
		table.insert(paymentManager.android.noFinishedList, arg)
	end
end
function paymentManager_android_purchaseDelay_huawei(...)
	print("paymentManager_android_purchaseDelay")
	if paymentManager.canPost2Server then
		local callBackHandle = function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				SoraDPlaySound()
				userSDKManager.openFeedback("Purchase", true)
			end
		end
		_ENV = nil
		;(nil).title = i18n("common_text_4622")
		SoraDShowMsgBox(i18n("common_text_4621"), i18n("common_text_2102"), nil, callBackHandle, nil)
	end
end
function paymentManager_android_getPurchases_huawei()
	if paymentManager.isInit and device.platform == "android" and userSDKManager.isHuawei() then
		local javaClassName = "com/unity3d/player/AndroidPayment"
		local javaMethodName = "getPurchases"
		local javaMethodSig = "()V"
		luaj.callStaticMethod(javaClassName, javaMethodName, nil, javaMethodSig)
	end
end
function paymentManager_android_onBillingServiceDisconnected(...)
	if paymentManager.isInit then
		paymentManager.isInit = false
	end
	SoraDIntervalCallOnce("reInitPayment", function()
		paymentManager.android.init()
	end)
end
