local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local sevenDayRechargeGiftModule = include("sevenDayRechargeGiftModule")
local rechargeGiftltCtrl = include("rechargeGiftltCtrl")
local rechargeGiftCtrl = class("rechargeGiftCtrl", gameModule)
local _ENV, REQ = "rechargeGiftCtrl", "rechargeGiftCtrl"
local _ENV, RSP = gameModule, gameModule
function rechargeGiftCtrl:ctor(properties)
	rechargeGiftCtrl.super.ctor(self, properties)
	self.giftModules, rechargeGiftCtrl = rechargeGiftCtrl.super.ctor, rechargeGiftCtrl.super.ctor
	local sevenDayRechargeGiftModule = sevenDayRechargeGiftModule.new()
	sevenDayRechargeGiftModule:initialize()
	self.giftModules[gRechargeGiftType.SEVEN_DAY_GIFT] = sevenDayRechargeGiftModule
end
function rechargeGiftCtrl:initClientData(data)
	if not data then
		data, _ENV = nil, nil
	end
	for k, v in pairs(data) do
		local giftModule = self.giftModules[tonumber(k)]
		if giftModule then
			giftModule:initialize(v)
		end
	end
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.RECHARGE_GIFT, handler(self, RSP.noitfyDataRsp))
end
function rechargeGiftCtrl:buyRechargeGift(rid)
	REQ.reqBuyRechargeGift(rid)
end
function rechargeGiftCtrl:getGiftList(giftType)
	local giftList = rechargeGiftltCtrl:getGiftList(giftType)
	local rechargeGiftltCtrl, ret = rechargeGiftltCtrl, rechargeGiftltCtrl
	for rid, v in pairs(giftList) do
		rechargeGiftltCtrl = nil
		;(nil).rid = rid
		local (nil).condition, data = clone(rechargeGiftltCtrl:getCondition(rid)), nil
		table.insert(ret, data)
		local giftModule = self.giftModules[giftType]
		local canBuy = giftModule:canBuy(rid)
		for k, v in pairs(data.condition) do
			if gRechargeGiftCondType.CASTLE_LEVEL == k then
				local aim = v.aim
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local castleLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
				if aim > castleLevel then
					v.state = false
					canBuy = false
				else
					v.state = true
				end
			end
		end
		data.canBuy = canBuy
		if gRechargeGiftType.SEVEN_DAY_GIFT == giftType then
			data.alreadyBuy = giftModule:alreadyBuy(rid)
		end
	end
	return ret
end
function rechargeGiftCtrl:get7DGiftAlreadyBuy(rid)
	local giftModule = self.giftModules[gRechargeGiftType.SEVEN_DAY_GIFT]
	return giftModule:alreadyBuy(rid)
end
function rechargeGiftCtrl:get7DGiftCanBuy(rid)
	local giftModule = self.giftModules[gRechargeGiftType.SEVEN_DAY_GIFT]
	return giftModule:canBuy(rid)
end
function rechargeGiftCtrl:get7DFinishTime()
	local giftModule = self.giftModules[gRechargeGiftType.SEVEN_DAY_GIFT]
	return giftModule:getFinishTime()
end
function REQ.reqBuyRechargeGift(rid)
	serverproxy = nil
	local (nil).rid, data = rid, nil
	serverproxy:Request(gCmd.CMD_RECHARGE_GIFT_MODULE, gCmd.REQ_BUY_RECHARGE_GIFT, data)
end
function RSP:buyRechargeGiftRsp(content)
	if gErrDef.Err_None == content.err then
		local rid = content.data.rid
		local orderID = content.data.orderID
		paymentManager.purchase(rid, orderID)
	elseif gErrDef.Err_RECHARGE_GIFT_COND_NOT_ENOUGH == content.err then
		local condType = content.data.condType
		local aim = content.data.aim
		if gRechargeGiftCondType.CASTLE_LEVEL == condType then
			_ENV = nil
			;(nil).lv = aim
			SoraDShowMsgTip(i18n("common_text_2749", nil))
		end
		SoraDCloseLoading()
		paymentManager.isInRecharging = false
	end
end
function RSP:noitfyDataRsp(content)
	for i, notifyMsg in ipairs(content.data) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		if "buySuccess" == notifyType then
			local rid = notifyData.rid
			local giftType = rechargeGiftltCtrl:getGiftType(rid)
			local giftModule = self.giftModules[giftType]
			if giftModule then
				giftModule:buySuccess(rid)
			end
			if gRechargeGiftType.SEVEN_DAY_GIFT == giftType then
				local mid = notifyData.mid
				local gold = rechargeGiftltCtrl:getGold(rid)
				local reward = rechargeGiftltCtrl:getResult(rid)
				local price = rechargeGiftltCtrl:getPrice(rid)
				_ENV = nil
				;(nil).id = gIDDef.GOLD
				;(nil).count = gold
				table.insert(reward, 1, nil)
				paymentManager.OnemtRechargeSuccess(price)
				paymentManager.loopForFinishTransaction()
				_ENV = price
				_ENV, price.msg = 1, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(1).result = true
				;(1).rid = rid
				;(1).itemList = reward
				price.data, (1).mailID = 1, mid
				SoraDSendMessage(price)
			end
		elseif "orderExpired" == notifyType then
			local rid = notifyData.rid
			local giftType = rechargeGiftltCtrl:getGiftType(rid)
			if gRechargeGiftType.SEVEN_DAY_GIFT == giftType then
				paymentManager.loopForFinishTransaction()
				_ENV = rid
				_ENV, rid.msg = rechargeGiftltCtrl:getGold(rid), "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				rechargeGiftltCtrl:getGold(rid).result = false
				rid.data, rechargeGiftltCtrl:getGold(rid).rid = rechargeGiftltCtrl:getGold(rid), rid
				SoraDSendMessage(rid)
			end
		end
	end
end
function rechargeGiftCtrl:EnterGame()
	rechargeGiftCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_RECHARGE_GIFT_MODULE, gCmd.REQ_BUY_RECHARGE_GIFT, handler(self, RSP.buyRechargeGiftRsp))
end
function rechargeGiftCtrl:Logout()
	rechargeGiftCtrl.super.Logout(self)
	for k, giftModule in pairs(self.giftModules) do
		giftModule:destroy()
	end
end
return rechargeGiftCtrl
