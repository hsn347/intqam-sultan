local starGiftRead = include("starGiftRead")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local starGiftCtrl = class("starGiftCtrl", GameModule)
function starGiftCtrl:ctor(properties)
	starGiftCtrl.super.ctor(self, properties)
end
function starGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_INIT, handler(self, self.sendInitRsp))
	msgCtrl.register(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_BUY, handler(self, self.sendGiftBuyRsp))
	msgCtrl.register(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_REWARD, handler(self, self.sendGetRewardRsp))
	self:resetData()
	self:registerNotify()
end
function starGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STARS_GIFT, handler(self, self.notifyHandler))
end
function starGiftCtrl:notifyHandler(event)
	dump(event.data, "starGiftCtrl:notifyHandler", 10)
	for i, v in ipairs(event.data) do
		if v.type == "buyGift" and v.success then
			for rid, info in pairs(v.boughtGfit) do
				self.boughtGfit[rid] = info
			end
			_ENV = pairs(v.boughtGfit)
			pairs(v.boughtGfit).msg = "MESSAGE_SATR_GIFT_REFRESH"
			pairs(v.boughtGfit).subMsg = "buySuccess"
			pairs(v.boughtGfit).rewards = v.reward
			pairs(v.boughtGfit).rid = v.rid
			SoraDSendMessage(pairs(v.boughtGfit))
		end
	end
end
function starGiftCtrl:initClientData(data)
	if not data then
		return
	end
	self:setData(data)
end
function starGiftCtrl:popRechargeSuccessView(event)
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	local _rid = event.rid
	local goods = event.reward
	rechargePopMsg(goods, nil, _rid)
end
function starGiftCtrl:Logout()
	starGiftCtrl.super.Logout(self)
	self:resetData()
end
function starGiftCtrl:setData(data)
	dump(data, "starGiftCtrl:setData")
	dump(data.boughtGfit, "starGiftCtrl:6776setData")
	self.boughtGfit = data.boughtGfit
	self.activityLevel = data.activityLevel
	self.classType = data.classType
end
function starGiftCtrl:resetData()
	self.boughtGfit, _UPVALUE0_, self.activityLevel = nil, nil, 0
	self.classType = 1
end
function starGiftCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_INIT)
end
function starGiftCtrl:sendGiftBuyMsg()
	serverproxy:Request(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_BUY)
end
function starGiftCtrl:sendGiftRewardMsg(rechargeId)
	serverproxy = nil
	;(nil).rechargeId = rechargeId
	serverproxy:Request(gCmd.CMD_STARS_GIFT_MODULE, gCmd.REQ_STARS_GIFT_REWARD, nil)
end
function starGiftCtrl:sendInitRsp(content)
	dump(content, "starGiftCtrl:sendInitRsp")
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_SATR_GIFT_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function starGiftCtrl:sendGiftBuyRsp(content)
	dump(content, "starGiftCtrl:sendGiftBuyRsp")
	if content.err == gErrDef.Err_None then
		local rechargeID = content.rspdata.rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(rechargeID, orderID)
	end
end
function starGiftCtrl:sendGetRewardRsp(content)
	dump(content, "starGiftCtrl:sendGetRewardRsp")
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.boughtGfit) do
			self.boughtGfit[i] = v
		end
		if data.rewards and next(data.rewards) then
			SoraDMailGainItems(data.rewards, true)
		end
		_ENV = data.rewards
		data.rewards.msg = "MESSAGE_SATR_GIFT_REFRESH"
		data.rewards.subMsg = "init"
		SoraDSendMessage(data.rewards)
	end
end
function starGiftCtrl:getReceiveStatusAndNum()
	self.giftConfig = starGiftRead.getGiftConfig(self.classType, self.activityLevel)
	for i, v in ipairs(self.giftConfig) do
		local count = 0
		for i = 1, 5 do
			if v["reward" .. i] and next(v["reward" .. i]) then
				count = count + 1
			end
		end
		local state = self:getDayRewardState(v.recharge, count, i)
		if state == 2 then
			return true, -1
		end
	end
	return false, 0
end
function starGiftCtrl:getType()
	return self.classType
end
function starGiftCtrl:getOpenLv()
	return self.activityLevel
end
function starGiftCtrl:getDefaultIndex(max)
	if max <= table.nums(self.boughtGfit) then
		return max
	end
	self.giftConfig = starGiftRead.getGiftConfig(self.classType, self.activityLevel)
	for i, v in ipairs(self.giftConfig) do
		local count = 0
		for i = 1, 5 do
			if v["reward" .. i] and next(v["reward" .. i]) then
				count = count + 1
			end
		end
		local state = self:getDayRewardState(v.recharge, count, i)
		if state ~= 5 then
			dump(i, "fjdfdkfjk")
			return i
		end
	end
	return table.nums(self.boughtGfit) + 1
end
function starGiftCtrl:getBoxState(index, rid, max)
	if index <= table.nums(self.boughtGfit) then
		if table.nums(self.boughtGfit[tostring(rid)].gotList) == max then
			return 3
		end
		return 2
	end
	return 1
end
function starGiftCtrl:getDayRewardState(rid, max, curIndex)
	if self.boughtGfit[tostring(rid)] then
		if table.nums(self.boughtGfit[tostring(rid)].gotList) == max then
			return 5
		end
		if self:calCurDay(self.boughtGfit[tostring(rid)].boughtTime) > table.nums(self.boughtGfit[tostring(rid)].gotList) then
			return 2
		else
			return 3
		end
	end
	if curIndex == 1 or table.nums(self.boughtGfit) == curIndex - 1 then
		return 1
	else
		return 4
	end
end
function starGiftCtrl:getRewardState(rid, index)
	if self.boughtGfit[tostring(rid)] then
		if self.boughtGfit[tostring(rid)].gotList[tostring(index)] then
			return 3
		elseif index <= self:calCurDay(self.boughtGfit[tostring(rid)].boughtTime) then
			return 2
		end
	end
	return 1
end
function starGiftCtrl:scorllToViewIndex(rid, max)
	if self.boughtGfit[tostring(rid)] then
		return math.clamp(table.nums(self.boughtGfit[tostring(rid)].gotList), 0, max - 1)
	end
	return 0
end
function starGiftCtrl:calCurDay(buyTime)
	local beginDay = SoraDConverSecondToDayAndHours(buyTime)
	local curDay = SoraDConverSecondToDayAndHours(serviceFunctions.systemTime())
	return curDay - beginDay + 1
end
function starGiftCtrl:getGiftRewardNum(index)
	local giftConfig = starGiftRead.getGiftConfig(self.classType, self.activityLevel)[index]
	local count = 0
	for i = 1, 5 do
		if giftConfig["reward" .. i] and next(giftConfig["reward" .. i]) then
			count = count + 1
		end
	end
	local state = self:getDayRewardState(giftConfig.recharge, count, index)
	if state == 2 then
		return true, -1
	end
	return false, 0
end
return starGiftCtrl
