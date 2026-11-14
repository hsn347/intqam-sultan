local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local constantRead = include("constantRead")
local activityID = gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY
local SPOON_ID = 840301
local CAVALRY_RISE_LEVEL = 1
local coffeeCraftsmanCtrl = class("coffeeCraftsmanCtrl", gamemodulec)
coffeeCraftsmanCtrl.activityID = activityID
coffeeCraftsmanCtrl.SPOON_ID = SPOON_ID
function coffeeCraftsmanCtrl:getReceiveStatusAndNum()
	if self:isFree() or self:hasCoffeeForTaste() then
		return true, -1
	end
	return false
end
function coffeeCraftsmanCtrl:hasCoffeeForTaste()
	for i = 1, 4 do
		if self:canTasteCoffee(i) then
			return true
		end
	end
	return false
end
function coffeeCraftsmanCtrl:canTasteCoffee(index)
	local info = self:getSpecialCoffee(index)
	if info and self:getLeftTime(index) > 0 then
		local config = self:getConfig(info.id)
		local count = SoraDGetCtrl("backpackCtrl"):getItemCount(SPOON_ID)
		if count >= config.itemNeed then
			return true
		end
	end
	return false
end
function coffeeCraftsmanCtrl:getGroup()
	return self.data.group
end
function coffeeCraftsmanCtrl:isFree()
	return self.data.isFree
end
function coffeeCraftsmanCtrl:getSpecialCoffee(index)
	return self.data.specialRewardMap[tostring(index)]
end
function coffeeCraftsmanCtrl:hasPoolAward()
	for _, v in pairs(self.data.poolMap) do
		if 0 < v then
			return true
		end
	end
	return false
end
function coffeeCraftsmanCtrl:getPoolMapItemID(pool)
	return self.data.poolMap[tostring(pool)] or 0
end
function coffeeCraftsmanCtrl:getPoolMapItemCount(pool)
	local itemID = self:getPoolMapItemID(pool)
	if 0 < itemID then
		local cfg = self:getConfig(pool)
		for i, v in ipairs(cfg.reward) do
			if v.id == itemID then
				return v.count
			end
		end
	end
	return 0
end
function coffeeCraftsmanCtrl:getConfig(pool)
	return coffeeCraftsmanRead:getConfig(pool, self:getGroup())
end
function coffeeCraftsmanCtrl:getLeftTime(index)
	local info = self:getSpecialCoffee(index)
	if info then
		local curTime = SoraDGetCtrl("timeCtrl"):getServerTime()
		local config = self:getConfig(info.id)
		return info.beginTime + config.cd - curTime
	end
	return 0
end
function coffeeCraftsmanCtrl:getLeftDrawCount()
	local totalNum = constantRead.getConstValue("COFFEECRASHMAN_BAKE_LIMIT")
	return totalNum - self.data.toDayDrawCount
end
function coffeeCraftsmanCtrl:isSpecialCoffeeFull()
	for i = 1, 4 do
		if self:getLeftTime(i) <= 0 then
			return false
		end
	end
	return true
end
function coffeeCraftsmanCtrl:getBakeOnceGold()
	return self.data.isFree and 0 or constantRead.getConstValue("COFFEECRASHMAN_COINS_ONCE")
end
function coffeeCraftsmanCtrl:getBakeTenGold()
	return constantRead.getConstValue("COFFEECRASHMAN_COINS_TEN")
end
function coffeeCraftsmanCtrl:closeActivity()
	print("closeActivity")
	uiManager:close("CoffeeCraftsmanActivity")
	uiManager:close("CoffeeCraftsmanPreview")
	uiManager:close("CoffeeCraftsmanSpoon")
	uiManager:close("CoffeeCraftsmanTaste")
	uiManager:close("CoffeeCraftsmanPool")
	uiManager:close("CoffeeCraftsmanPoolSave")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_FGUI_CLOSE_OWNER"
	uiManager.ownerName = "coffeeCraftsmanCtrl"
	SoraDSendMessage(uiManager)
	self:resetData()
end
function coffeeCraftsmanCtrl:getPoolGuide()
	local dailyRemindManager = include("dailyRemindManager")
	return dailyRemindManager.checkNeedRemindOnce(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanPoolGuide, activityID)
end
function coffeeCraftsmanCtrl:setPoolGuide()
	local dailyRemindManager = include("dailyRemindManager")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local openCount = activityShowCtrl:getOpenCount(activityID)
	dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.coffeeCraftsmanPoolGuide, openCount)
end
function coffeeCraftsmanCtrl:ctor(properties)
	coffeeCraftsmanCtrl.super.ctor(self, properties)
	self.data, coffeeCraftsmanCtrl = coffeeCraftsmanCtrl.super.ctor, coffeeCraftsmanCtrl.super.ctor
	local constantRead = include("constantRead")
	coffeeCraftsmanCtrl.SPOON_ID = constantRead.getConstValue("COFFEECRASHMAN_ITEM")
end
function coffeeCraftsmanCtrl:EnterGame()
	self:resetData()
	msgCtrl.register(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_INIT, handler(self, self.rspInit))
	msgCtrl.register(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_DRAW, handler(self, self.rspDraw))
	msgCtrl.register(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_SPECIALDRAW, handler(self, self.rspSpecialDraw))
	msgCtrl.register(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_DEL, handler(self, self.rspDel))
	msgCtrl.register(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_CHOOSE, handler(self, self.rspChoose))
	local notifyCtrl = SoraDGetCtrl("notifyCtrl")
	notifyCtrl:register(gNotifyID.COFFEE_CRAFTSMAN_ACTIVITY, handler(self, self.notifyHandler))
end
function coffeeCraftsmanCtrl:resetData()
	self:removeTimer()
	print("coffeeCraftsmanCtrl:resetData")
	self.group = -1
	self.data.isFree = true
	self.data.specialRewardMap, _ENV = "coffeeCraftsmanCtrl:resetData", "coffeeCraftsmanCtrl:resetData"
	self.data.poolMap, _ENV = "coffeeCraftsmanCtrl:resetData", "coffeeCraftsmanCtrl:resetData"
	self.data.toDayDrawCount = 0
end
function coffeeCraftsmanCtrl:Logout()
	coffeeCraftsmanCtrl.super.Logout(self)
	self:resetData()
end
function coffeeCraftsmanCtrl:initClientData(data)
	dump(data, "coffeeCraftsmanCtrl:initClientData", 10)
	self:resetData()
	self:updateData(data)
end
function coffeeCraftsmanCtrl:notifyHandler(event)
	dump(event, "coffeeCraftsmanCtrl:notifyHandler", 10)
	for k, v in pairs(event.data) do
		self:updateData(v)
		break
	end
end
function coffeeCraftsmanCtrl:updateData(data)
	dump(data, "coffee", 10)
	local _ENV, diff = dump, dump
	for k, v in pairs(data.specialRewardMap) do
		local oldItem = self.data.specialRewardMap[k]
		local newItem = data.specialRewardMap[k]
		if not oldItem or newItem.beginTime ~= oldItem.beginTime or newItem.id ~= oldItem.id then
			table.insert(diff, tonumber(k))
			print("new", newItem.beginTime, newItem.id)
			if oldItem then
				print("old", oldItem.beginTime, oldItem.id)
			end
		end
	end
	self.data = data
	self:clearTimeoutData()
	return diff
end
function coffeeCraftsmanCtrl:clearTimeoutData()
	print("coffeeCraftsmanCtrl:clearTimeoutData")
	for k, v in pairs(self.data.specialRewardMap) do
		if self:getLeftTime(k) <= 0 then
			self.data.specialRewardMap[k] = nil
			_ENV = self
			self.msg = "MESSAGE_COFFEE_CRAFTSMAN_TIMEOUT"
			self.index = tonumber(k)
			SoraDSendMessage(self)
		end
	end
	self:updateTimer()
end
function coffeeCraftsmanCtrl:removeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function coffeeCraftsmanCtrl:updateTimer()
	self:removeTimer()
	local time
	local serverTime = SoraDGetCtrl("timeCtrl"):getServerTime()
	for k, v in pairs(self.data.specialRewardMap) do
		local endTime = v.beginTime + self:getConfig(v.id).cd - serverTime
		if not time or time > endTime then
			time = endTime
		end
	end
	if time then
		print("coffeeCraftsmanCtrl:updateTimer", time)
		if time < 0 then
			time = 0
		end
		if 0 < time then
			self.timer = SoraDCreateTimerEx(self, function()
				self:removeTimer()
				self:clearTimeoutData()
			end, time)
		else
			self:clearTimeoutData()
		end
	end
end
function coffeeCraftsmanCtrl:rspInit(event)
	dump(event, "coffeeCraftsmanCtrl:rspInit", 10)
	local err = event.err
	if err ~= gErrDef.Err_None then
		return
	end
	self:updateData(event.rspdata)
	_ENV = self
	self.msg = "MESSAGE_COFFEE_CRAFTSMAN_INIT"
	SoraDSendMessage(self)
end
function coffeeCraftsmanCtrl:rspDraw(event)
	dump(event, "coffeeCraftsmanCtrl:rspDraw", 10)
	if event.err ~= gErrDef.Err_None then
		return
	end
	local diff = self:updateData(event.rspdata.data)
	_ENV = event.rspdata.data
	event.rspdata.data.msg = "MESSAGE_COFFEE_CRAFTSMAN_DRAW"
	event.rspdata.data.data = event.rspdata
	event.rspdata.data.diff = diff
	SoraDSendMessage(event.rspdata.data)
end
function coffeeCraftsmanCtrl:rspSpecialDraw(event)
	dump(event, "coffeeCraftsmanCtrl:rspSpecialDraw", 10)
	if event.err ~= gErrDef.Err_None then
		return
	end
	self:updateData(event.rspdata.data)
	_ENV = self
	self.msg = "MESSAGE_COFFEE_CRAFTSMAN_SPECIAL_DRAW"
	SoraDSendMessage(self)
	fguiHelper.showRewardList(event.rspdata.rewards, "coffeeCraftsmanCtrl")
end
function coffeeCraftsmanCtrl:rspDel(event)
	dump(event, "coffeeCraftsmanCtrl:rspDel", 10)
	if event.err ~= gErrDef.Err_None then
		return
	end
	self:updateData(event.rspdata.data)
	_ENV = self
	self.msg = "MESSAGE_COFFEE_CRAFTSMAN_DEL"
	SoraDSendMessage(self)
end
function coffeeCraftsmanCtrl:rspChoose(event)
	dump(event, "coffeeCraftsmanCtrl:rspChoose", 10)
	if event.err ~= gErrDef.Err_None then
		return
	end
	self:updateData(event.rspdata.data)
	_ENV = self
	self.msg = "MESSAGE_COFFEE_CRAFTSMAN_CHOOSE"
	SoraDSendMessage(self)
end
function coffeeCraftsmanCtrl:reqInit()
	print("coffeeCraftsmanCtrl:reqInit")
	serverproxy:Request(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_INIT)
end
function coffeeCraftsmanCtrl:reqDraw(isTen)
	print("coffeeCraftsmanCtrl:reqDraw", isTen)
	_ENV = nil
	;(nil).isTen = isTen
	serverproxy:Request(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_DRAW, nil)
end
function coffeeCraftsmanCtrl:reqSpecialDraw(index)
	print("coffeeCraftsmanCtrl:reqSpecialDraw", index)
	_ENV = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_SPECIALDRAW, nil)
end
function coffeeCraftsmanCtrl:reqDel(index)
	print("coffeeCraftsmanCtrl:reqDel", index)
	_ENV = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_DEL, nil)
end
function coffeeCraftsmanCtrl:reqChoose(index, itemID)
	print("coffeeCraftsmanCtrl:reqChoose", index, itemID)
	_ENV = nil
	;(nil).pool = index
	;(nil).itemID = itemID
	serverproxy:Request(gCmd.CMD_COFFEE_MERCHANT_MODULE, gCmd.REQ_COFFEE_MERCHANT_CHOOSE, nil)
end
return coffeeCraftsmanCtrl
