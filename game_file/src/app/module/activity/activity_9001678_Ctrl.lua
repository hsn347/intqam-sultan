local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001678_Ctrl = class("activity_9001678_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001678_Ctrl:ctor(properties)
	activity_9001678_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.FROSTY_MARKET
	self.exchangeActID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010005
	self:resetData()
end
function activity_9001678_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_SHARE, handler(self, self.reqShareRsp))
	msgCtrl.register(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_HELP, handler(self, self.reqHelpRsp))
	msgCtrl.register(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_HELPERS, handler(self, self.reqHelpersRsp))
	msgCtrl.register(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_BUY, handler(self, self.reqBuyRsp))
	self:registerNotify()
end
function activity_9001678_Ctrl:Logout()
	activity_9001678_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001678_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).opencount = 0
	;(nil).goods, _UPVALUE0_, (nil).goodsTime = nil, nil, 0
	self.defaultData, (nil).recharge, _UPVALUE0_, (nil).shareTime = nil, nil, nil, 0
end
function activity_9001678_Ctrl:initClientData(data)
	dump(data, "activity_9001678_Ctrl:initClientData===")
	self.defaultData = data
end
function activity_9001678_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FROSTY_MARKET, handler(self, self.notifyHandler))
end
function activity_9001678_Ctrl:notifyHandler(event)
	dump(event, "activity_9001678_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.notifyType == "data" then
			self.defaultData = v.notifyData
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001678_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_DATA, nil)
end
function activity_9001678_Ctrl:sendShareMsg(goodId, toUid, toAlliance, toKingdom)
	serverproxy = nil
	;(nil).goodId = goodId
	;(nil).toUid = toUid
	;(nil).toAlliance = toAlliance or false
	;(nil).toKingdom = toKingdom or false
	serverproxy:Request(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_SHARE, nil)
end
function activity_9001678_Ctrl:sendHelpMsg(uid, goodId, t, classType)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).goodId = goodId
	;(nil).t = t
	;(nil).classType = classType
	serverproxy:Request(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_HELP, nil)
end
function activity_9001678_Ctrl:sendHelpersMsg(goodId, uid, t)
	serverproxy = nil
	;(nil).goodId = goodId
	;(nil).uid = uid
	;(nil).t = t
	serverproxy:Request(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_HELPERS, nil)
end
function activity_9001678_Ctrl:sendBuyMsg(goodId)
	serverproxy = nil
	;(nil).goodId = goodId
	serverproxy:Request(gCmd.CMD_FROSTY_MARKET_MODULE, gCmd.REQ_FROSTY_MARKET_BUY, nil)
end
function activity_9001678_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001678_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001678_Ctrl:reqShareRsp(content)
	dump(content, "activity_9001678_Ctrl:reqShareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
		gErrDef.Err_None.key = "share"
		SoraDSendMessage(gErrDef.Err_None)
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function activity_9001678_Ctrl:reqHelpRsp(content)
	dump(content, "activity_9001678_Ctrl:reqHelpRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local discount = content.rspdata.discount
		local skin = self:getSkin()
		if skin == 1 then
			_ENV = nil
			;(nil).goodsID = content.data.goodId
			;(nil).discount = discount
			uiManager:show("Activity_9001678_Discount", nil)
		elseif skin == 2 then
			_ENV = nil
			;(nil).goodsID = content.data.goodId
			;(nil).discount = discount
			uiManager:show("Activity_9001714_Discount", nil)
		end
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = content.data.goodId
		content.data.goodId.num = discount
		SoraDShowMsgTip(i18n("Frosty_Market_text_27", content.data.goodId))
	elseif content.err == gErrDef.Err_FROSTY_MARKET_SHARE_INVALID then
		SoraDShowMsgTip(i18n("Frosty_Market_text_9"))
	end
	_ENV = i18n("Frosty_Market_text_9")
	i18n("Frosty_Market_text_9").msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
	i18n("Frosty_Market_text_9").key = "help"
	SoraDSendMessage(i18n("Frosty_Market_text_9"))
end
function activity_9001678_Ctrl:reqHelpersRsp(content)
	dump(content, "activity_9001678_Ctrl:reqHelpersRsp(content)", 10)
	local _ENV, helpers = dump, dump
	if content.err == gErrDef.Err_None then
		helpers = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
	gErrDef.Err_None.key = "helpers"
	gErrDef.Err_None.helpers = helpers
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001678_Ctrl:reqBuyRsp(content)
	dump(content, "activity_9001678_Ctrl:reqBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001678_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001678_Ctrl:getSkin()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	return param.skinType or 1
end
function activity_9001678_Ctrl:getReceiveStatusAndNum()
	local num = self:getMarketRedNum() + self:getExchangeRedNum()
	return 0 < num, num
end
function activity_9001678_Ctrl:getMarketRedNum()
	local num = 0
	local forstyNum = include("constantRead").getConstValue("FORSTY_DISCOUNT_NUM", 3)
	local activity_9001678_Read = include("activity_9001678_Read")
	local goodsList = self:getDayGoodsList()
	for _, goodId in ipairs(goodsList) do
		local total, count = self:getDayDiscount(goodId)
		local cfg = activity_9001678_Read.getFrostyMarketCfg(goodId)
		if forstyNum <= count and cfg.limit > self:getDayBuyCount(goodId) then
			num = num + 1
		end
	end
	return num
end
function activity_9001678_Ctrl:getExchangeRedNum()
	local num = 0
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	if not activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID) then
		local _ENV, exchangeList = activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID), activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID)
	end
	for _, v in ipairs(exchangeList) do
		if v.remindStatus == 1 and v.curExchangeNum < v.limitnum then
			local itemEnough1 = backpackCtrl:getItemCount(v.exchangeitem) >= v.exchangenum
			local itemEnough2 = true
			if v.exchangeitem2 and v.exchangenum2 then
				itemEnough2 = backpackCtrl:getItemCount(v.exchangeitem2) >= v.exchangenum2
			end
			if itemEnough1 and itemEnough2 then
				num = num + 1
			end
		end
	end
	return num
end
function activity_9001678_Ctrl:getDayGoodsList()
	local _ENV, list
	local activity_9001678_Read = include("activity_9001678_Read")
	for goodsID, data in pairs(self.defaultData.goods) do
		local cfg = activity_9001678_Read.getFrostyMarketCfg(tonumber(goodsID))
		if cfg then
			_ENV = tonumber(goodsID)
			tonumber(goodsID).id = tonumber(goodsID)
			tonumber(goodsID).goodsType = cfg.goodsType
			table.insert(list, tonumber(goodsID))
		end
	end
	table.sort(list, function(a, b)
		if a.goodsType == b.goodsType then
			return a.id < b.id
		else
			return a.goodsType < b.goodsType
		end
	end)
	return list
end
function activity_9001678_Ctrl:getDayBuyCount(goodId)
	local goodId = tostring(goodId)
	return self.defaultData.goods[goodId] and self.defaultData.goods[goodId].dayBuyCount or 0
end
function activity_9001678_Ctrl:getDayDiscount(goodId)
	local total = 0
	local count = 0
	local goodId = tostring(goodId)
	if self.defaultData.goods[goodId] and self.defaultData.goods[goodId].helper and next(self.defaultData.goods[goodId].helper) then
		for uid, discount in pairs(self.defaultData.goods[goodId].helper) do
			total = total + discount
			count = count + 1
		end
	end
	return total, count
end
function activity_9001678_Ctrl:getShareLeftTime()
	local constantRead = include("constantRead")
	local constantTime = constantRead.getConstValue("FROSTY_MARKEY_SHARE_TIME", 60)
	local time = self.defaultData.shareTime + constantTime - serviceFunctions.systemTime()
	return time
end
function activity_9001678_Ctrl:getGiftBuyCountDay(rid)
	local times = 0
	if self.defaultData.recharge[tostring(rid)] and serviceFunctions.isSameDay(self.defaultData.recharge[tostring(rid)].t) then
		times = self.defaultData.recharge[tostring(rid)].n
	end
	return times
end
return activity_9001678_Ctrl
