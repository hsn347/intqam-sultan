local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local luxuryRebateCtrl = class("luxuryRebateCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local luxuryRebateRead = include("luxuryRebateRead")
local luxuryRebateDef = include("luxuryRebateDef")
local AWARD_STATUES = luxuryRebateDef.AWARD_STATUES
local DAY_STATUES = luxuryRebateDef.DAY_STATUES
function luxuryRebateCtrl:reqLuxuryRebateNormalReward()
	print("luxuryRebateCtrl:reqLuxuryRebateNormalReward")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD)
end
function luxuryRebateCtrl:reqLuxuryRebateLuxuryReward()
	print("luxuryRebateCtrl:reqLuxuryRebateLuxuryReward")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD)
end
function luxuryRebateCtrl:reqLuxuryRebateLuxuryBox()
	print("luxuryRebateCtrl:reqLuxuryRebateLuxuryBox")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX)
end
function luxuryRebateCtrl:reqLuxuryRebateBuyGift(data)
	print("luxuryRebateCtrl:reqLuxuryRebateBuyGift")
	serverproxy:Request(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, data)
end
function luxuryRebateCtrl:getLuxuryAwardStatus(cfg, god, isPreView)
	local data = self.data
	local award = god and data.luxuryReward or data.normalReward
	local dayAward = award[cfg.day_key]
	if dayAward and dayAward[cfg.class] then
		return AWARD_STATUES.AWARD_STATUES_GET
	end
	if god and not isPreView and not data.superRewardFalg then
		return AWARD_STATUES.AWARD_STATUES_LOCK
	end
	if cfg.day > self.data.unlockDay then
		return AWARD_STATUES.AWARD_STATUES_LOCK_DAY
	end
	return AWARD_STATUES.AWARD_STATUES_NORMAL
end
function luxuryRebateCtrl:getLuxuryDayStatus(cfg)
	local dailyRecharge = self.data.dailyRecharge
	local recharge = dailyRecharge[cfg.day_key] or 0
	if recharge >= cfg.recharge then
		return DAY_STATUES.DAY_STATUES_DONE
	end
	if cfg.day < self.data.unlockDay then
		return DAY_STATUES.DAY_STATUES_END
	elseif cfg.day > self.data.unlockDay then
		return DAY_STATUES.DAY_STATUES_UNOPEN
	end
	return DAY_STATUES.DAY_STATUES_NORMAL
end
function luxuryRebateCtrl:isHasLuxuryAwardByDay(day)
	if not luxuryRebateRead.getAwardListByDay(day) then
		local luxuryRebateRead, dayList = luxuryRebateRead.getAwardListByDay(day), luxuryRebateRead.getAwardListByDay(day)
	end
	for _, v in ipairs(dayList) do
		if DAY_STATUES.DAY_STATUES_DONE == self:getLuxuryDayStatus(v) then
			if AWARD_STATUES.AWARD_STATUES_NORMAL == self:getLuxuryAwardStatus(v, false) then
				return true
			end
			if AWARD_STATUES.AWARD_STATUES_NORMAL == self:getLuxuryAwardStatus(v, true) then
				return true
			end
		end
	end
	return false
end
function luxuryRebateCtrl:isHasLuxuryAwardAll()
	for i = 1, self.data.unlockDay do
		if self:isHasLuxuryAwardByDay(i) then
			return true
		end
	end
	return false
end
function luxuryRebateCtrl:getLuxuryAwardByDay(day, god, isPreView)
	if not luxuryRebateRead.getAwardListByDay(day) then
		local luxuryRebateRead, dayList = luxuryRebateRead.getAwardListByDay(day), luxuryRebateRead.getAwardListByDay(day)
	end
	local luxuryRebateRead, ret = day, day
	for _, v in ipairs(dayList) do
		if DAY_STATUES.DAY_STATUES_DONE == self:getLuxuryDayStatus(v) and AWARD_STATUES.AWARD_STATUES_NORMAL == self:getLuxuryAwardStatus(v, god, isPreView) then
			if god then
				table.insertto(ret, v.awardGod)
			else
				table.insertto(ret, v.awardNormal)
			end
		end
	end
	return ret
end
function luxuryRebateCtrl:getLuxuryAwardAll(god, isPreView)
	local _ENV, ret
	for i = 1, self.data.unlockDay do
		local item = self:getLuxuryAwardByDay(i, god, isPreView)
		if item then
			table.insert(ret, item)
		end
	end
	return ret
end
function luxuryRebateCtrl:getLuxuryRecharge(cfg)
	local dailyRecharge = self.data.dailyRecharge
	local recharge = dailyRecharge[cfg.day_key] or 0
	if recharge >= cfg.recharge then
		return cfg.recharge
	end
	return recharge
end
function luxuryRebateCtrl:isBoxRewardGet()
	return self.data.boxRewardFlag
end
function luxuryRebateCtrl:isSpuerReward()
	return self.data.superRewardFalg
end
function luxuryRebateCtrl:getRechargeRewardDay()
	local ret = 0
	for _, v in pairs(self.data.rechargeRewardDay) do
		if 0 < v then
			ret = ret + 1
		end
	end
	return ret
end
function luxuryRebateCtrl:checkCanGetBox()
	if not self:isSpuerReward() then
		return false
	end
	local rechargeDay = self:getRechargeRewardDay()
	return rechargeDay >= luxuryRebateRead.getBoxAwardDay()
end
function luxuryRebateCtrl:getRechargeCurDay()
	return self.data.unlockDay
end
function luxuryRebateCtrl:isRechargeActive()
	if not luxuryRebateRead.getAwardListByDay(self.data.unlockDay) then
		local luxuryRebateRead, dayList = luxuryRebateRead.getAwardListByDay(self.data.unlockDay), luxuryRebateRead.getAwardListByDay(self.data.unlockDay)
	end
	if dayList[1] and DAY_STATUES.DAY_STATUES_DONE == self:getLuxuryDayStatus(dayList[1]) then
		return true
	end
	return false
end
function luxuryRebateCtrl:ctor(properties)
	luxuryRebateCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY
end
_ENV, luxuryRebateCtrl.EnterGame = function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end, function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).round = 1
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).rechargeRewardDay, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).dailyRecharge, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).luxuryReward, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).normalReward, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).buyList, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).questData, _ENV, (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).unlockDay = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1
;(function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).superRewardFalg = false
local (function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end).boxRewardFlag, data_default = false, function(self)
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_NORMAL_REWARD, handler(self, self.luxuryRebateNormalRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_REWARD, handler(self, self.luxuryRebateLuxuryRewardRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LUXURY_REBATE_LUXURY_BOX, handler(self, self.luxuryRebateLuxuryBoxRSP))
	msgCtrl.register(gCmd.CMD_LUXURY_REBATE_MODULE, gCmd.REQ_LUXURY_REBATE_BUY_GIFT, handler(self, self.luxuryRebateBuyGiftRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.LUXURY_REBATE, handler(self, self.onMsg))
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	self:resetData()
end
data_default.__index = data_default
function luxuryRebateCtrl:resetData()
	_UPVALUE0_ = nil
	self:setData(nil)
end
function luxuryRebateCtrl:setData(data, notify)
	if not data then
		data, _ENV = nil, nil
	end
	self.data = data
	setmetatable(self.data, data_default)
	if notify then
		_ENV = self.data
		self.data.msg = "MESSAGE_LUXURY_REBATE_REFRESH"
		SoraDSendMessage(self.data)
		_ENV = self.data
		self.data.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.data.eventID = self.activityID
		SoraDSendMessage(self.data)
	end
end
function luxuryRebateCtrl:updateData(data)
	for k, v in pairs(data) do
		self.data[k] = v
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_LUXURY_REBATE_REFRESH"
	SoraDSendMessage(pairs(data))
end
function luxuryRebateCtrl:Logout()
	luxuryRebateCtrl.super.Logout(self)
	self:resetData()
end
function luxuryRebateCtrl:getReceiveStatusAndNum()
	return self:isHasLuxuryAwardAll() or not self:isBoxRewardGet() and self:checkCanGetBox(), -1
end
function luxuryRebateCtrl:initClientData(data)
	if not data then
		return
	end
	local activityData = data[tostring(self.activityID)]
	dump(activityData, "activityData", 10)
	self:setData(activityData)
end
function luxuryRebateCtrl:onMsg(event)
	local data = event.data
	dump(data, "luxuryRebateCtrl:onMsg", 10)
	if data then
		for _, msg in pairs(data) do
			if msg.type == "buyGift" then
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				SoraDSendMessage(nil)
				if msg.data.success then
					_ENV = nil
					;(nil).msg = "MESSAGE_LUXURY_REBATE_RECHARGE_SUCCESS"
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = self.activityID
					SoraDSendMessage(nil)
				end
			end
		end
	end
end
function luxuryRebateCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) ~= self.activityID then
			return
		end
		self:updateData(notifyMsg.notifyData)
	end
end
function luxuryRebateCtrl:luxuryRebateNormalRewardRSP(event)
	dump(event, "luxuryRebateCtrl:luxuryRebateNormalRewardRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None and event.rspdata.initData then
		self:setData(event.rspdata.initData, true)
	end
	_ENV = self
	self.msg = "MESSAGE_LUXURY_REBATE_REWARD_RSP"
	self.err = event.err
	SoraDSendMessage(self)
end
function luxuryRebateCtrl:luxuryRebateLuxuryRewardRSP(event)
	dump(event, "luxuryRebateCtrl:luxuryRebateLuxuryRewardRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None and event.rspdata.initData then
		self:setData(event.rspdata.initData, true)
	end
	_ENV = self
	self.msg = "MESSAGE_LUXURY_REBATE_REWARD_RSP"
	self.err = event.err
	SoraDSendMessage(self)
end
function luxuryRebateCtrl:luxuryRebateLuxuryBoxRSP(event)
	dump(event, "luxuryRebateCtrl:luxuryRebateLuxuryBoxRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None and event.rspdata.initData then
		self:setData(event.rspdata.initData, true)
	end
	_ENV = self
	self.msg = "MESSAGE_LUXURY_REBATE_BOX_RSP"
	self.err = event.err
	SoraDSendMessage(self)
end
function luxuryRebateCtrl:luxuryRebateBuyGiftRSP(content)
	dump(content, "luxuryRebateCtrl:luxuryRebateBuyGiftRSP", 10)
	if content.err == gErrDef.Err_None or not content.err then
		local orderID = content.rspdata.orderID
		local rechargeID = content.rspdata.rechargeID
		rechargeID = rechargeID or luxuryRebateRead.getGiftID()
		paymentManager.purchase(rechargeID, orderID)
	end
end
return luxuryRebateCtrl
