local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001713_Ctrl = class("activity_9001713_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001713_Read = include("activity_9001713_Read")
function activity_9001713_Ctrl:ctor(properties)
	activity_9001713_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_SHOP_2025
	self:resetData()
end
function activity_9001713_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2025_SHOP_BUY_GOOD, handler(self, self.reqBuyGoodRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2025_SHOP_REFRESH, handler(self, self.reqRefreshRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.onMsgUpdateModuleData))
	self:registerNotify()
end
function activity_9001713_Ctrl:Logout()
	activity_9001713_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001713_Ctrl:resetData()
	;(nil).recharge, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	;(nil).goods, _UPVALUE0_, (nil).goodsTime = nil, nil, 0
	self.initData, (nil).refreshCount = nil, 0
end
function activity_9001713_Ctrl:updateInitData(data)
	if data.recharge then
		self.initData.recharge = data.recharge
	end
	if data.goodsTime then
		self.initData.goodsTime = data.goodsTime
	end
	if data.goods then
		self.initData.goods = data.goods
	end
	if data.refreshCount then
		self.initData.refreshCount = data.refreshCount
	end
end
function activity_9001713_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	dump(activityData, "==activity_9001713_Ctrl:initClientData==", 10)
	if not activityData then
		return
	end
	self:updateInitData(activityData)
end
function activity_9001713_Ctrl:onMsgUpdateModuleData(target, event)
	if event.activityID == self.activityID then
		dump(event, "activity_9001713_Ctrl:onMsgUpdateModuleData")
		self:updateInitData(event.initData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001713_UPDATE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function activity_9001713_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function activity_9001713_Ctrl:notifyHandler(event)
	dump(event, "activity_9001713_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.activityID == self.activityID and v.notifyType == "updateData" then
			self:updateInitData(v.notifyData)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001713_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001713_Ctrl:getReceiveStatusAndNum()
	local itemID = activity_9001713_Read.getItemID()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemID)
	local ret = false
	local list = self:getGoodsList()
	for _, v in ipairs(list) do
		local cfg = activity_9001713_Read.getShopGoodCfg(v.goodsID)
		if v.buyCount < cfg.limit and itemCount >= cfg.itemCount then
			ret = true
			break
		end
	end
	return ret, -1
end
function activity_9001713_Ctrl:reqBuyGood(goodId)
	serverproxy = nil
	;(nil).goodId = goodId
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2025_SHOP_BUY_GOOD, nil)
end
function activity_9001713_Ctrl:reqBuyGoodRsp(content)
	dump(content, "activity_9001713_Ctrl:reqBuyGoodRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata.data)
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_9001713_UPDATE"
		SoraDSendMessage(reward)
	end
end
function activity_9001713_Ctrl:reqRefresh()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2025_SHOP_REFRESH, nil)
end
function activity_9001713_Ctrl:reqRefreshRsp(content)
	dump(content, "activity_9001713_Ctrl:reqRefreshRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateInitData(content.rspdata.data)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001713_UPDATE"
		SoraDSendMessage(self)
	end
end
function activity_9001713_Ctrl:getGoodsList()
	local _ENV, list
	for goodsID, v in pairs(self.initData.goods) do
		_ENV = nil
		;(nil).goodsID = tonumber(goodsID)
		;(nil).buyCount = v.dayBuyCount or 0
		table.insert(list, nil)
	end
	table.sort(list, function(a, b)
		return a.goodsID < b.goodsID
	end)
	return list
end
function activity_9001713_Ctrl:getGiftBuyCountDay(rid)
	local times = 0
	if self.initData.recharge[tostring(rid)] and serviceFunctions.isSameDay(self.initData.recharge[tostring(rid)].t) then
		times = self.initData.recharge[tostring(rid)].n
	end
	return times
end
function activity_9001713_Ctrl:getGoodsBuyCount(goodsID)
	if not self.initData.goods[tostring(goodsID)] then
		local _ENV, goodInfo = self.initData.goods[tostring(goodsID)], self.initData.goods[tostring(goodsID)]
	end
	return goodInfo.dayBuyCount or 0
end
function activity_9001713_Ctrl:getRefreshCount()
	return self.initData.refreshCount or 0
end
return activity_9001713_Ctrl
